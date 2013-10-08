class User < ActiveRecord::Base
  attr_accessible :email, :family_name, :name
  has_many :shorted_urls

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :name, presence: true

  def self.sign_in(code)
    client = Google::APIClient.new({application_name: 'Url shortener'})
    client.authorization.client_id = CLIENT_ID
    client.authorization.client_secret = CLIENT_SECRET
    client.authorization.scope = SCOPE
    plus = client.discovered_api('plus')
    client.authorization.redirect_uri = sign_in_url;

    client.authorization.code = code
    client.authorization.fetch_access_token!

    user_name = client.execute(
        :api_method => plus.people.get,
        :parameters => {'userId' => 'me'},
        :authenticated => true
    ).data['name']

    user_info = HTTParty.get(GET_USER_INFO + client.authorization.access_token)
    email = user_info['email']
    user = User.find_or_create_by_email(email)
    user.name= user_name['given_name']
    user.family_name= user_name['family_name']
    user.save

    if !session[:shorted_urls].nil?
      session[:shorted_urls].each do |id|
        shorted_ulr = ShortedUrl.find(id)
        shorted_ulr.user= user
        shorted_ulr.save
      end
      session[:shorted_urls] = nil
    end
    user
  end
end
