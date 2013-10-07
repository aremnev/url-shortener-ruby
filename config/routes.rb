UrlShortenerRuby::Application.routes.draw do

  match '/api/signin', to: 'Sessions#sign_in', via: [:get, :post], as: :sign_in
  match '/api/signout', to: 'Sessions#sign_out', via: [:delete], as: :sign_out
  get '/', to: 'MainPage#index', as: :root
  match '/api/shorten', to: 'UrlShortener#shorten', via: [:get, :post], as: :shorten
  match '/api/shorten', to: 'UrlShortener#delete', via: [:delete], as: :shorten
  match '/api/expand', to: 'UrlShortener#expand', via: [:get, :post], as: :expand

  get '/:shortenUrl', to: 'UrlShortener#url'

end