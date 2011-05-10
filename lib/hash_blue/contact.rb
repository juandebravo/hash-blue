module HashBlue
  
  class Contact < Client
    
    attr_accessor :id    
    attr_accessor :phone_number
    attr_accessor :name
    attr_accessor :email
    
    def initialize(phone_number = nil, name = nil, email = nil)
      @phone_number = phone_number
      @name = name
      @email = email
    end
    
    def save!
      contact = {:phone_number => phone_number, :name => name, :email => email}
      self.class.post "/contacts", {:contact => contact}
    end

    def to_s
      "#{self.class.name} [#{id}] => {:phone_number => #{phone_number}, :name => #{name}, :email => #{email}}"
    end
        
    class << self
      
      def find(arg=nil)
        if arg.nil?
          parse_response(get "/contacts")
        elsif arg.is_a? Symbol
          if arg.eql?(:all)
            parse_response(get "/contacts")
          else
            raise ArgumentError, "Invalid argument #{arg}"
          end
        elsif arg.is_a? String or arg.is_a? Fixnum
          parse_response(get "/contacts/#{arg}")
        end
      end
      
      def create!(phone_number, name, email)
        contact = {:phone_number => phone_number, :name => name, :email => email}
        post "/contacts", {:contact => contact}
      end
      
      private
      
      def parse_response(data)
         data = JSON::parse(data)
          if data.has_key?("contact")
            value = Contact.new
            value.id = data["contact"]["uri"].split("/").last
            value.phone_number = data["contact"]["phone_number"]
            value.name = data["contact"]["name"]
            value.email = data["contact"]["email"]
          elsif data.has_key?("contacts")
            value = []
            data["contacts"].each do |contact|
              elem = Contact.new
              elem.id = contact["uri"].split("/").last
              elem.phone_number = contact["phone_number"]
              elem.name = contact["name"]
              elem.email = contact["email"]
              value.push elem
            end
          end
          value
      end
    end
  end
  
end