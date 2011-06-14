require 'rails'
require 'hash_blue/engine_config'

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
  #
  # This class defines the HashBlue Rails Engine to handle OAuth authentication.
  # The Engine defines two new routes to handle each of the OAuth steps
  # 1.- forward the user request to HashBlue server
  # 2.- get the oauth code, request a valid access token and forward the token info to a user defined action
  #
  # How to configure HashBlue Engine
  #
  # :uri => HashBlue API endpoint 
  # :client_id => token that identifies your application in OAuth mechanism
  # :client_secret => token that secures your communication in OAuth mechanism
  # :forward_action => controller#action where hashblue#code action will redirect the user token data:
  #           - :access_token
  #           - :expires_in
  #           - :refresh_token
  #
  # These configuration can be included in your config/application.rb file:
  #   require "hash-blue"
  #      (...)
  #
  #      config.respond_to?("hashblue") or config.hashblue = HashBlue::EngineConfig.new
  #      config.hashblue.client_id = "<client_id>"
  #      config.hashblue.client_secret = "<client_secret"
  #      config.hashblue.forward_action = "controller#action" that will receive the user token data
  #
  
  class Engine < ::Rails::Engine
    
    initializer "hash-blue.some_init_task" do |app|
      app.config.hashblue.nil? and app.config.hashblue = HashBlue::Engine::HashBlueConfig.new
      # HashBlue API endpoint
      app.config.hashblue.uri = "https://hashblue.com"
    end
    
  end
end
