require 'oauth/signature/hmac/sha1'
require 'oauth/client/helper'
require 'net/https'

#
# O2 Labs has exposed the power of #blue to developers via a simple REST & JSON based API, 
# enabling new ways for users to manage their texts and add combine the ubiquity of SMS 
# with their applications, users simply grant an application access to their messages stream 
# or just certain messages.
#
# Juan de Bravo (juandebravo@gmail.com)
# Ruby sensei at The Lab (http://thelab.o2.com)
#

class HashblueController < ApplicationController

  # parameters required in both OAuth steps
  DEFAULT_PARAMS = {
    :client_id => Rails.application.config.hashblue.client_id    
  }
  
  # OAuth step1: redirect to HashBlue endpoint with the application idenfitifer and the redirect uri
  def index
    hb_params = {
      :redirect_uri => 
    }
    hb_params.merge!(DEFAULT_PARAMS)
    
    redirect_to "#{endpoint}/oauth/authorize?".concat(hb_params.collect { |k, v| "#{k}=#{v.to_s}" }.join("&"))
  end

  # OAuth step2: retrieve the code from HashBlue, ask for a valid access token and
  # forward to the user defined uri
  def code
    # This code is retrieved from HashBlue
    code = params[:code]

    hb_params = {
      :redirect_uri => redirect_uri,
      :client_secret => Rails.application.config.hashblue.client_secret,
      :grant_type => "authorization_code",
      :code => code
    }
    hb_params.merge!(DEFAULT_PARAMS)

    response = rest.post( "/oauth/access_token?".concat(hb_params.collect { |k, v| "#{k}=#{v.to_s}" }.join("&")), nil)
    
    if response.code.eql?("200")
      response = ActiveSupport::JSON.decode(response.body)

      if response.has_key?("access_token")
        Rails.application.config.hashblue.forward_action.nil? and raise RuntimeError, "Invalid forward_action value"
        
        url = Rails.application.config.hashblue.forward_action.split("#")
        url.length == 2 or raise RuntimeError, "Invalid forward_action value"
        redirect_to ({
          :controller => url.first,
          :action => url.last,
          :access_token => response["access_token"],
          :expires_in => response["expires_in"],
          :refresh_token => response["refresh_token"]
          })
      elsif response.has_key?("error")
        logger.error "Error while accessing to HashBlue #{response['error']}"
        raise RuntimeError, response['error']
      end
    else
      logger.error "Error #{response.code} while accessing to HashBlue #{response.body}"
      raise RuntimeError, "Unable to access to hashblue"
    end
  end
  
  # rest client to HashBlue endpoint
  def rest
    @@rest ||= (uri = URI.parse(endpoint)
    rest = Net::HTTP.new(uri.host, uri.port)
    rest.use_ssl = true
    rest)
  end
  
  # HashBlue endpoint
  def endpoint
    Rails.application.config.hashblue.uri
  end
  
  def redirect_uri
    "#{request.protocol}#{request.host_with_port}/hashblue/code"
  end
  
  
end
