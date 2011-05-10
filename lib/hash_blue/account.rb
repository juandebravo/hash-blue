module HashBlue
  
  class Account < Client
    
    attr_accessor :msisdn
    attr_accessor :phone_number
    attr_accessor :email
  
    def to_s
      "#{self.class.name} => {:phone_number => #{phone_number}, :msisdn => #{msisdn}, :email => #{email}}"
    end
    
    class << self
      
      def find
        parse_response(get "/account")
      end      
      
      private
      
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