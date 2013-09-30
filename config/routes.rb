UrlShortenerRuby::Application.routes.draw do
  get '/', to: 'MainPage#index', as: :root
  match '/shorten', to: 'UrlShortener#shorten', via: [:get, :post], as: :shorten
  get '/:shortenUrl', to: 'UrlShortener#url'
end
