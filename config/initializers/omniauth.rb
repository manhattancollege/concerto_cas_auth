# Check if our ConcertoConfig values have been created yet
#   (this prevents issues with initializing omniauth-cas on first install)


# Store omniauth config values from main application's ConcertoConfig
omniauth_config = {
  :host => URI.parse(ConcertoConfig[:cas_url]).host,
  :url => ConcertoConfig[:cas_url],
  :uid_key => ConcertoConfig[:cas_uid_key],
  :email_key => ConcertoConfig[:cas_email_key],
  :first_name_key => ConcertoConfig[:cas_first_name_key],
  :last_name_key => ConcertoConfig[:cas_last_name_key]
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
