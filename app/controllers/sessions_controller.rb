require 'google/api_client'

class SessionsController < ApplicationController

  def sign_in
    session[:user_id] = 1;
    redirect_to :root
  end

  def sign_out
    session[:user_id] = nil;
    redirect_to :root
  end
end
