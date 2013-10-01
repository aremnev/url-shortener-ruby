require 'google/api_client'

class SessionsController < ApplicationController

  def sign_in

    client = Google::APIClient.new({application_name: 'Url shortener'})
    plus = client.discovered_api('plus')
    client.authorization.client_id = CLIENT_ID
    client.authorization.client_secret = CLIENT_SECRET
    client.authorization.scope = SCOPE
    client.authorization.redirect_uri = sign_in_url;

    client.authorization.code = params[:code]
    client.authorization.fetch_access_token!

    user_name = client.execute(
        :api_method => plus.people.get,
        :parameters => {'userId' => 'me'},
        :authenticated => true
    ).data['name']

    user_info = HTTParty.get('https://www.googleapis.com/oauth2/v2/userinfo?access_token=' + client.authorization.access_token)
    email = user_info['email']
    user = User.find_by_email(email)
    if user.nil?
      user = User.create(:email => email, :name => user_name['given_name'], :family_name => user_name['family_name'])
    end

    session[:user] = user;
    redirect_to :root
  end

  def sign_out
    session[:user] = nil;
    redirect_to :root
  end
end
