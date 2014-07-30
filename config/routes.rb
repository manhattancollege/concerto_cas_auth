Concerto::Application.routes.draw do
  mount ConcertoCasAuth::Engine, :at => '/auth'
end

ConcertoCasAuth::Engine.routes.draw do
  get ":provider/callback", :to => "omniauth_callback#cas_auth"
end
