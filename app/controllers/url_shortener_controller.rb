class UrlShortenerController < ApplicationController
  def shorten
    shortedUrl = ShortedUrl.new(:url => params[:url])
    shortedUrl.save
    render :text => shortedUrl.name
  end

  def url
    shortedUrl = ShortedUrl.find_by_name(params[:shortenUrl])
    render :text => shortedUrl.url
  end

end