UrlShortenerRuby::Application.routes.draw do
  # @mkolganov
  # предложение - возможно, что-то можно представить в виде ресурсов?
  # например, сессию и url? я понимаю, что задача не очень хорошо ложится на классический rails ресурс, но
  # частично - очень даже. это более rails-way, чем ручное объявление роутов.
  # http://guides.rubyonrails.org/routing.html#prefixing-the-named-route-helpers
  #
  # если очень хочется предварить методы строчкой /api, то можно обернуть в scope path: '/api' do...end
  # но тут можно и не выделять api методы в отдельный путь. один и тот же URL может
  # в нескольких форматах. и это кажется более правильным - меньше дублирования кода
  match '/api/signin', to: 'Sessions#sign_in', via: [:get, :post], as: :sign_in
  match '/api/signout', to: 'Sessions#sign_out', via: [:delete], as: :sign_out
  get '/', to: 'Pages#index', as: :root
  match '/api/shorten', to: 'UrlShortener#shorten', via: [:get, :post], as: :shorten
  match '/api/shorten', to: 'UrlShortener#delete', via: [:delete], as: :shorten
  match '/api/expand', to: 'UrlShortener#expand', via: [:get, :post], as: :expand

  get '/:shortenUrl', to: 'UrlShortener#url'

end
