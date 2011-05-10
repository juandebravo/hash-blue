require 'uri'
require 'net/http'
require 'net/https'
require 'json'

module HashBlue
  class Client
    class << self
      attr_accessor :user
      
      def client
        @rest ||= (uri = URI.parse("https://api.hashblue.com")
        rest = Net::HTTP.new(uri.host, uri.port)
        rest.use_ssl = true
        rest)
      end
      
      def get(path)
        if user.nil?
          token = self.superclass.user
        else
          token = self.user
        end
        client.get(path, {'Authorization' => "OAuth #{token}"}).body
      end
      
      def post(path, body)
        client.post(path, body.to_json, {'Authorization' => "OAuth #{self.superclass.user}",
                                        'Content-Type' => "application/json"}).body
      end
      
      def put(path, body = nil)
        client.put(path, body, {'Authorization' => "OAuth #{self.superclass.user}"})
      end

      def delete(path)
        client.delete(path, {'Authorization' => "OAuth #{self.superclass.user}"})
      end

    end
  end
end