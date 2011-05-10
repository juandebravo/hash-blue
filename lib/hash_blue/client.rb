require 'uri'
require 'net/http'
require 'net/https'
require 'json'

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
  # This class is in charge of the HTTP channel with HashBlue API
  class Client
    class << self
      attr_accessor :user
      
      def client
        @rest ||= (uri = URI.parse("https://api.hashblue.com")
        rest = Net::HTTP.new(uri.host, uri.port)
        rest.use_ssl = true
        rest)
      end
      
      # Send a HTTP GET request (should be used to retrieve available resources)
      def get(path)
        # get oAuth token directly from the class or the subclass
        if user.nil?
          token = self.superclass.user
        else
          token = self.user
        end
        client.get(path, {'Authorization' => "OAuth #{token}"}).body
      end
      
      # Send a HTTP POST request (should be used to create new resources)
      def post(path, body)
        client.post(path, body.to_json, {'Authorization' => "OAuth #{self.superclass.user}",
                                        'Content-Type' => "application/json"}).body
      end
      
      # Send a HTTP PUT request (should be used to update available resources)
      def put(path, body = nil)
        client.put(path, body, {'Authorization' => "OAuth #{self.superclass.user}"})
      end

      # Send a HTTP DELETE request (should be used to delete available resources)
      def delete(path)
        client.delete(path, {'Authorization' => "OAuth #{self.superclass.user}"})
      end

    end
  end
end