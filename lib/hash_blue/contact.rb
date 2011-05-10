require 'hash_blue/contact'

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

  # This class models the Contact entity, providing an easy way to CRUD operations
  # using ActiveRecord as design model
  #
  # Examples of use:
  #
  # # Initialize client with a valid access token
  # HashBlue::Client.user = <valid_access_token>
  #
  # # Retrieve all contacts
  # messages = HashBlue::Contact.find(:all)
  #
  # # Retrieve a specific contact
  # message = HashBlue::Contact.find(<valid_contact_id>)
  #
  # # Create a contact
  # HashBlue::Contact.create!(<phone_number>, <name>, <email>)
    
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
      
      # Retrieve a specific contact or a set of contacts
      # @param arg:
      # =>  nil => retrieve all messages
      # =>  :all => retrieve all messages
      # =>  {:contact => <contact_id>} => retrieve a specific contact messages
      # =>  id => retrieve a specific message using a valid unique identifier

      def find(arg = nil)
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
      
      # Create a new contact
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