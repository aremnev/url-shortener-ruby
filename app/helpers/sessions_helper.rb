# @mkolganov
# Подобные константы удобнее вынести в конфиг. Например, можно использовать
# библиотеку https://github.com/railsjedi/rails_config
CLIENT_ID = '817617958445.apps.googleusercontent.com'
CLIENT_SECRET = 'efzv6jH5hP9bfy6jOy84lb_7'
SCOPE = 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email'
GET_USER_INFO = 'https://www.googleapis.com/oauth2/v2/userinfo?access_token='
SIGN_IN_LINK = 'https://accounts.google.com/o/oauth2/auth?' +
    'scope=' + SCOPE + '&' +
    'state=%2Fprofile&' +
    'redirect_uri=' + sign_in_url + '&' +
    'response_type=code&' +
    'client_id=' + CLIENT_ID

module SessionsHelper
  def signed_in?
    session[:user_id].present?
  end
end
