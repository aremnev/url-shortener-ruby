class MainPageController < ApplicationController
  def index
    if !session[:user_id].nil?
      @user = User.find(session[:user_id])
      @user_shorted_urls = @user.shorted_urls
    end
  end
end
