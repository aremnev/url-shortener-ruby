
class PagesController < ApplicationController
  def index
    # @mkolganov
    # но тут лучше изменить порядок работы с сессией. я бы перенес в модель User
    # всю логику работы с авторизацией и сопутствующими проверками
    if session[:user_id].present?
      @user = User.find(session[:user_id])
      @user_shorted_urls = @user.shorted_urls.order('created_at')
    else
      @user_shorted_urls = Array.new
      if session[:shorted_urls].present?
        session[:shorted_urls].each{ |id| @user_shorted_urls.push(ShortedUrl.find(id)) }
        @user_shorted_urls.sort! { |x, y| x.created_at <=> y.created_at }
      end
    end
  end
end
