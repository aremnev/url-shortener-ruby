require 'cgi'

class UrlShortenerController < ApplicationController
  include SessionsHelper
  # @mkolganov
  # этот метод можно переписать изящнее, избавившись от жесткой привязки к ответу в формате json
  # я понимаю, что, возможно стояла задача сделать только API, но можно не отказываться от возможности
  # в будущем очень легко добавить HTML представления и работу через браузер.
  # гугли метод #respond_with
  # Ну и несколько проверок можно было бы упростить, убрав часть логики в модели.
  def shorten
    shorted_url = ShortedUrl.new(:url => CGI::unescape(params[:url]))
    if signed_in?
      shorted_url.user= User.find(session[:user_id])
    end
    # @mkolganov
    # похоже, что можно сохранить несколько url подряд.
    # почему бы не сделать уникальной связку url + user_id в модели ShortenUrl?
    if shorted_url.save
      if session[:user_id].nil?
        if session[:shorted_urls].nil?
          session[:shorted_urls] = Array.new
        end
        # @mkolganov: предложение - вместо повсеместных проверок на то, зарегистрирован ли пользователь, или он гость,
        # записи всем в сессию сохраненных URL (похоже, для зарегистрированных это не требуется)
        # можно было бы переместить эту логику в модель User или создать модель Guest (без таблицы)
        session[:shorted_urls].push(shorted_url.id)
      end
      # @mkolganov
      # вместо `root_url() + shorted_url.name` я бы создал хелпер, внутри которого
      # бы к shorted_url.name прицеплялся root_url(). контроллер не самое подходящее место для этого.
      # похожая ситуация в методе #expand ниже
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
    # можно сократить код с блоком begin-rescue-end, использовав короткий синтаксис
    #
    # shorted_url = ShortedUrl.find_by_name(params[:shortenUrl]) rescue nil
    # if shorted_url
    # ...
    #
    # такая же ситуация в методе #expand ниже
    begin
      shorted_url = ShortedUrl.find_by_name(params[:shortenUrl])
    rescue
      # @mkolganov
      # логичнее было бы написать return render ... в одну строку
      # и сделать view вместо отправки текста или переместить текст в локализацию
      render :status => :not_found, :text => '404: NOT FOUND!'
      return;
    end
    # @mkolganov
    # можно убрать логику в модель, создав в ней метод #touch, например
    shorted_url.follows = shorted_url.follows + 1
    shorted_url.save
    redirect_to shorted_url.url
  rescue
    # @mkolganov
    # и тут - view или локализация
    render :text => 'you were ' + link_to('redirected', shorted_url.url)
  end

  def expand
    @short_url = params[:url]
    begin
      @shorted_url = ShortedUrl.find_by_name(@short_url)
      response = {:status => 'success', :shorted_url => (root_url() + @shorted_url.name),
                  :expanded_url => @shorted_url.url, :follows => @shorted_url.follows }
      render :status => :ok, :json => response.as_json
    rescue
      response = {:status => 'error', :shorted_url => (root_url() + @short_url),
                  :errors => ['Not found'] }
      render :status => :not_found, :json => response.as_json
    end
  end

end
