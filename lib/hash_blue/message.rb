require 'hash_blue/client'

#
# O2 Labs has exposed the power of #blue to developers via a simple REST & JSON based API, 
# enabling new ways for users to manage their texts and add combine the ubiquity of SMS 
# with their applications, users simply grant an application access to their messages stream 
# or just certain messages.
#
# Juan de Bravo (juandebravo@gmail.com)
# Ruby sensei at The Lab (http://thelab.o2.com)
#

module HashBlue

  # This class models the Message entity, providing an easy way to CRUD operations
  # using ActiveRecord as design model
  #
  # Examples of use:
  #
  # # Initialize client with a valid access token
  # HashBlue::Client.user = <valid_access_token>
  #
  # # Retrieve all messages
  # messages = HashBlue::Message.find(:all)
  #
  # # Retrieve a specific message
  # message = HashBlue::Message.find(<valid_message_id>)
  #
  # # Retrieve a contact messages
  # messages = HashBlue::Message.find({:contact => <valid_contact_id>})
  #
  # # Retrieve favourite messages
  #	messages = HashBlue::Message.favourites
  #
  # # Mark a message as favourite
  # message = HashBlue::Message.find(<valid_message_id>)
  # message.favourite!
  #
  # # Unmark a message as favourite
  #	message = HashBlue::Message.find(<valid_message_id>)
  #	message.unfavourite!
  #
  # # Create a message
  # HashBlue::Message.create!(<phone_number>, <content>)
  
  class Message < Client
    attr_accessor :id
    attr_accessor :content
    attr_accessor :contact # HashBlue::Contact object
    attr_accessor :sent # true|false
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
    
    # Class methods
    class << self
      
      # Retrieve a specific message or a set of messages
      # @param arg:
      # =>  nil => retrieve all messages
      # =>  :all => retrieve all messages
      # =>  {:contact => <contact_id>} => retrieve a specific contact messages
      # =>  id => retrieve a specific message using a valid unique identifier
      
      def find(arg = nil)
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
          arg.has_key?(:contact) or raise ArgumentError, "Invalid argument #{arg}"
          messages = get "/contacts/#{arg[:contact]}/messages"
        end
        parse_response(messages)
      end

      # Retrieve the messaged marked as favourites
      def favourites
        parse_response(get "/messages/favourites")
      end
      
      # Send a message to a specific number
      def create!(phone_number, content)
        message = {:phone_number => phone_number, :content => content}
        post "/messages", {:message => message}
      end
      
      private
      
      # Method used to parse a JSON response
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