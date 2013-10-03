class MainPageController < ApplicationController
  def index
    if !session[:user_id].nil?
      @user = User.find(session[:user_id])
      @user_shorted_urls = @user.shorted_urls
    else
      @user_shorted_urls = Array.new
      if !session[:shorted_urls].nil?
        session[:shorted_urls].each{ |id|
          @user_shorted_urls.push(ShortedUrl.find(id))
        }
      end
    end
  end
end
