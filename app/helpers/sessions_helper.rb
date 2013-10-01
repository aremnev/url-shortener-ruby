CLIENT_ID = '817617958445.apps.googleusercontent.com'
CLIENT_SECRET = 'efzv6jH5hP9bfy6jOy84lb_7'
SCOPE = 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email'

module SessionsHelper
  def signed_in?
    !session[:user].nil?
  end

  def sign_in_link
    'https://accounts.google.com/o/oauth2/auth?' +
        'scope=' + SCOPE + '&' +
        'state=%2Fprofile&' +
        'redirect_uri=' + sign_in_url + '&' +
        'response_type=code&' +
        'client_id=' + CLIENT_ID
  end
end
