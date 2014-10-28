Concerto::Application.routes.draw do
  get "/auth/cas/callback", :to => "concerto_cas_auth/omniauth_callback#cas_auth"
end