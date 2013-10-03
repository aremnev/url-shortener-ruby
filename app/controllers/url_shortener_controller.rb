class UrlShortenerController < ApplicationController
  def shorten
    shorted_url = ShortedUrl.new(:url => params[:url])
    if !session[:user_id].nil?
      shorted_url.user= User.find(session[:user_id])
    end
    if shorted_url.save
      response = {:status => 'success', :url => (root_url() + shorted_url.name) }
      render :status => :created, :json => response.as_json
    else
      response = {:status => 'error', :errors => shorted_url.errors}
      render :status => :bad_request, :json => response.as_json
    end
  end

  def delete
    if !session[:user_id].nil?
      shorted_url = ShortedUrl.find(params[:id])
      if session[:user_id] == shorted_url.user.id
        shorted_url.destroy
        #render :status => :no_content
        #return
      end
      #render :status => :bad_request
    end
    #render :status => :unauthorized
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
  end

end