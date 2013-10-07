require 'cgi'

class UrlShortenerController < ApplicationController
  include SessionsHelper
  def shorten
    shorted_url = ShortedUrl.new(:url => CGI::unescape(params[:url]))
    if signed_in?
      shorted_url.user= User.find(session[:user_id])
    end
    if shorted_url.save
      if session[:user_id].nil?
        if session[:shorted_urls].nil?
          session[:shorted_urls] = Array.new
        end
        session[:shorted_urls].push(shorted_url.id)
      end
      response = {:status => 'success', :url => (root_url() + shorted_url.name) }
      render :status => :created, :json => response.as_json
    else
      response = {:status => 'error', :errors => shorted_url.errors}
      render :status => :bad_request, :json => response.as_json
    end
  end

  def delete
    shorted_url = ShortedUrl.find(params[:id])
    if signed_in?
      if session[:user_id] == shorted_url.user.id
        shorted_url.destroy
      end
    else
      if session[:shorted_urls].include?(shorted_url.id)
        if shorted_url.user.nil?
          shorted_url.destroy
          session[:shorted_urls].delete(shorted_url.id)
        end
      end
    end
    redirect_to :root
  end

  def url
    begin
      shorted_url = ShortedUrl.find_by_name(params[:shortenUrl])
    rescue
      render :status => :not_found, :text => '404: NOT FOUND!'
      return;
    end
    shorted_url.follows = shorted_url.follows + 1
    shorted_url.save
    redirect_to shorted_url.url
  rescue
    render :text => 'you were ' + link_to('redirected', shorted_url.url)
  end

end