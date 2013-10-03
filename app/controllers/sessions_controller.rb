require 'google/api_client'

class SessionsController < ApplicationController

  attr_accessor :client

  def initialize
    @client = Google::APIClient.new({application_name: 'Url shortener'})
    @client.authorization.client_id = CLIENT_ID
    @client.authorization.client_secret = CLIENT_SECRET
    @client.authorization.scope = SCOPE
  end

  def sign_in
    plus = @client.discovered_api('plus')
    @client.authorization.redirect_uri = sign_in_url;

    @client.authorization.code = params[:code]
    @client.authorization.fetch_access_token!

    user_name = @client.execute(
        :api_method => plus.people.get,
        :parameters => {'userId' => 'me'},
        :authenticated => true
    ).data['name']

    user_info = HTTParty.get(GET_USER_INFO + @client.authorization.access_token)
    email = user_info['email']
    user = User.find_or_create_by_email_and_name_and_family_name(email, user_name['given_name'], user_name['family_name'])

    session[:user_id] = user.id;
    if !session[:shorted_urls].nil?
      session[:shorted_urls].each{ |id|
        shorted_ulr = ShortedUrl.find(id)
        shorted_ulr.user = user
        shorted_ulr.save
      }
      session[:shorted_urls] = nil
    end

    session[:access_token] = @client.authorization.access_token
    session[:refresh_token] = @client.authorization.refresh_token
    session[:expires_in] = @client.authorization.expires_in
    session[:issued_at] = @client.authorization.issued_at

    redirect_to :root
  end

  def sign_out
    @client.authorization.update_token!(session)
    HTTParty.get "https://accounts.google.com/o/oauth2/revoke?token=#{@client.authorization.access_token}"
    session[:user_id] = nil;
    redirect_to :root
  end
end
