require 'google/api_client'

class SessionsController < ApplicationController
  def sign_in
    redirect_to :root
  end

  def sign_out
    redirect_to :root
  end
end
