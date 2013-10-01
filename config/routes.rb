UrlShortenerRuby::Application.routes.draw do

  match '/signin', to: 'Sessions#sign_in', via: [:get, :post], as: :sign_in
  match '/signout', to: 'Sessions#sign_out', via: [:delete], as: :sign_out
  get '/', to: 'MainPage#index', as: :root
  match '/shorten', to: 'UrlShortener#shorten', via: [:get, :post], as: :shorten
  get '/:shortenUrl', to: 'UrlShortener#url'
end
