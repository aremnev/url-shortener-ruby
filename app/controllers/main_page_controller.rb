# @mkolganov
# рекомендация по именованию - обычно создается PagesController
# контроллеры принято называть во множественном числе, плюс - это универсальнее, что-ли
class MainPageController < ApplicationController
  def index
    # @mkolganov
    # вместь !session[:user_id].nil? можно было бы написать session[:user_id].present?
    # но тут лучше изменить порядок работы с сессией. я бы перенес в модель User
    # всю логику работы с авторизацией и сопутствующими проверками
    if !session[:user_id].nil?
      @user = User.find(session[:user_id])
      @user_shorted_urls = @user.shorted_urls.order('created_at')
    else
      @user_shorted_urls = Array.new
      if !session[:shorted_urls].nil?
        # @mkolganov
        # блоки с фигурными скобками общепринято применять, если блок помещается в одну строку,
        # например 10.times { |i| puts i }
        # в противном случае - do...end
        # это просто так, на будущее. тут вполне можно свернуть два блока ниже до однострочных
        session[:shorted_urls].each{ |id|
          @user_shorted_urls.push(ShortedUrl.find(id))
        }
        @user_shorted_urls.sort! { |x, y|
          x.created_at <=> y.created_at
        }
      end
    end
  end
end
