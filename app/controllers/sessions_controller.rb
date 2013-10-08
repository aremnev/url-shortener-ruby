require 'google/api_client'

class SessionsController < ApplicationController

  def sign_in
    user = User.sign_in(params[:code])
    session[:user_id] = user.id if user.present?
    redirect_to :root
  end

  def sign_out
    session[:user_id] = nil;
    redirect_to :root
  end
end
