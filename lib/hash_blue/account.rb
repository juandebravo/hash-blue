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
  
  # This class models the Account entity, providing an easy way to CRUD operations
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

  class Account < Client
    
    attr_accessor :msisdn
    attr_accessor :phone_number
    attr_accessor :email
  
    def to_s
      "#{self.class.name} => {:phone_number => #{phone_number}, :msisdn => #{msisdn}, :email => #{email}}"
    end
    
    # Class methods
    class << self
      
      # Get user account
      def find
        parse_response(get "/account")
      end      
      
      private
      
      # Method used to parse a JSON response
      def parse_response(data)
        data = JSON::parse(data)
        value = Account.new
        if data.has_key?("account")
          data = data["account"]
          value.msisdn = data["msisdn"]
          value.phone_number = data["phone_number"]
          value.email = data["email"]
        end
        value
      end
    end
  end
  
end