ConcertoCasAuth::Engine.routes.draw do
  get ":provider/callback", :to => "omniauth_callback#cas_auth"
end
