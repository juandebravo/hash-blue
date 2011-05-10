require 'hash_blue/client'

module HashBlue
  class Message < Client
    attr_accessor :id
    attr_accessor :content
    attr_accessor :contact
    attr_accessor :sent
    attr_accessor :timestamp
    
    # Mark as favourite
    def favourite!
      self.class.put "/messages/#{id}/favourite"
    end

    # Unmark as favourite
    def unfavourite!
      self.class.delete "/messages/#{id}/favourite"
    end
    
    # Delete message
    def delete!
      self.class.delete "/messages/#{id}"
    end
    
    # Create message
    def save!
      self.class.create!(contact.is_a? HashBlue::Contact ? contact.phone_number : contact, content)
    end
    
    def to_s
      "#{self.class.name} [#{id}] => {:content => #{content}, :contact => #{contact}, :sent => #{sent}, :timestamp => #{timestamp}}"
    end
    
    alias :destroy! :delete!
    
    class << self
      
      def find(arg=nil)
        if arg.nil?
          messages = get "/messages"
        elsif arg.is_a? Symbol
          if arg.eql?(:all)
            messages = get "/messages"
          else
            raise ArgumentError, "Invalid argument #{arg}"
          end
        elsif arg.is_a? String or arg.is_a? Fixnum
          messages = get "/messages/#{arg}"
        elsif arg.is_a? Hash
          messages = get "/contacts/#{arg[:contact]}/messages"
        end
        parse_response(messages)
      end
      
      def favourites
        parse_response(get "/messages/favourites")
      end
      
      def create!(phone_number, content)
        message = {:phone_number => phone_number, :content => content}
        post "/messages", {:message => message}
      end
      
      private
      
      def parse_response(data)
         data = JSON::parse(data)
          if data.has_key?("message")
            value = Message.new
            value.id = data["message"]["uri"].split("/").last
            value.content = data["message"]["content"]
            value.contact = Contact.new(data["message"]["contact"]["phone_number"], data["message"]["contact"]["name"], data["message"]["contact"]["email"])
            value.timestamp = data["message"]["timestamp"]
            value.sent = data["message"]["sent"]
          elsif data.has_key?("messages")
            value = []
            data["messages"].each do |message|
              elem = Message.new
              elem.id = message["uri"].split("/").last
              elem.content = message["content"]
              elem.contact = Contact.new(message["contact"]["phone_number"], message["contact"]["name"], message["contact"]["email"])
              elem.contact.id = message["contact"]["uri"].split("/").last
              elem.timestamp = message["timestamp"]
              elem.sent = message["sent"]
              value.push elem
            end
          end
          value
      end
    end
  end
end