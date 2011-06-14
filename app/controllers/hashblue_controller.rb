require 'oauth/signature/hmac/sha1'
require 'oauth/client/helper'
require 'net/https'

class HashBlueController < ApplicationController

  DEFAULT_PARAMS = {
    :client_id => Rails.application.config.hashblue.api_key,
    :redirect_uri => Rails.application.config.hashblue.redirect_uri
  }
  
  def index
    redirect_to "#{Rails.application.config.hashblue.uri}/oauth/authorize?".concat(DEFAULT_PARAMS.collect { |k, v| "#{k}=#{v.to_s}" }.join("&"))
  end

  def code
    code = params[:code]

    hb_params = {
      :client_secret => Rails.application.config.hashblue.api_secret,
      :grant_type => "authorization_code",
      :code => code
    }
    hb_params.merge!(DEFAULT_PARAMS)

    response = rest.post( "/oauth/access_token?".concat(hb_params.collect { |k, v| "#{k}=#{v.to_s}" }.join("&")), nil)
    
    @response = response.body
    # Include here a callback (forward) so developer doesn't need to change any code.
  end
  
  def rest
    @@rest || (uri = URI.parse(Rails.application.config.hashblue.uri)
    rest = Net::HTTP.new(uri.host, uri.port)
    rest.use_ssl = true
    rest)
  end
  
end
