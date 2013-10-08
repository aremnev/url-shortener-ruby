require 'google/api_client'

class SessionsController < ApplicationController

  def sign_in
    # @mkolganov
    # два момента: первый - в rails мире существует принцип Fat Model - Skinny Controller
    # всегда лучше избегать писать в контроллере код, который напрашивается быть в модели.
    # второй момент: авторизацию, работу с сессией я бы поместил в модель User.
    # Изначально можно было бы сделать авторизацию через Devise + OmniAuth, чтобы не изобретать велосипед,
    # но, с точки зрения изучения, конечно, приведенный ниже код подходит лучше.
    # Нужно только его правильно организовать
    # еще см. комментарий в controllers/main_page_controller.rb
    client = Google::APIClient.new({application_name: 'Url shortener'})
    client.authorization.client_id = CLIENT_ID
    client.authorization.client_secret = CLIENT_SECRET
    client.authorization.scope = SCOPE
    plus = client.discovered_api('plus')
    client.authorization.redirect_uri = sign_in_url;

    client.authorization.code = params[:code]
    client.authorization.fetch_access_token!

    user_name = client.execute(
        :api_method => plus.people.get,
        :parameters => {'userId' => 'me'},
        :authenticated => true
    ).data['name']

    user_info = HTTParty.get(GET_USER_INFO + client.authorization.access_token)
    email = user_info['email']
    # @mkolganov
    # слишком длинное имя метода. в следующей версии рельс(4) это объявлено как deprecated, нужно будет использовать
    # метод find_by field: value
    # но в данном случае рельсы версии 3, вместо find_by можно использовать
    # User.where(email: email, name: user_name['given_name'], family_name: user_name['family_name']).first_or_create
    user = User.find_or_create_by_email_and_name_and_family_name(email, user_name['given_name'], user_name['family_name'])

    session[:user_id] = user.id;
    if !session[:shorted_urls].nil?
      # @mkolganov
      # про стиль блоков уже писал в controllers/main_page_controller.rb
      session[:shorted_urls].each{ |id|
        shorted_ulr = ShortedUrl.find(id)
        shorted_ulr.user = user
        shorted_ulr.save
      }
      session[:shorted_urls] = nil
    end

    redirect_to :root
  end

  def sign_out
    session[:user_id] = nil;
    redirect_to :root
  end
end
