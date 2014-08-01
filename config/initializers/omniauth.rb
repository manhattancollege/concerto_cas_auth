# Concerto Configs are created if they don't exist already
#   these are used to initialize and configure omniauth-cas 
ConcertoConfig.make_concerto_config("cas_url", "https://cas.example.org/cas", 
  :value_type => "string", 
  :value_default => "https://cas.example.org/cas", 
  :category => 'CAS User Authentication', 
  :seq_no => 1, 
  :description =>"Defines the url of your CAS server")

ConcertoConfig.make_concerto_config("cas_uid_key", "user", 
  :value_type => "string", 
  :value_default => "user", 
  :category => 'CAS User Authentication', 
  :seq_no => 2, 
  :description =>'The CAS field name containing user login names (uid, username,email,etc)')

ConcertoConfig.make_concerto_config("cas_email_key", "email", 
  :value_type => "string", 
  :value_default => "email", 
  :category => 'CAS User Authentication', 
  :seq_no => 3, 
  :description =>'The CAS field name containing user email addresses (email, uid,etc)')

# Store omniauth config values from main application's ConcertoConfig
omniauth_config = {
  :host => URI.parse(ConcertoConfig[:cas_url]).host,
  :url => ConcertoConfig[:cas_url],
  :uid_key => ConcertoConfig[:cas_uid_key],
  :email_key => ConcertoConfig[:cas_email_key]
}

# configure omniauth-cas gem based on specified yml configs
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas, omniauth_config
end

# save omniauth configuration for later use in application
#  to reference any unique identifiers for extra CAS options
ConcertoCasAuth::Engine.configure do
   config.omniauth_keys = omniauth_config
end
