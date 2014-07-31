# Check if our ConcertoConfig values have been created yet
#   (this prevents issues with initializing omniauth-cas on first install)
cas_config = ConcertoConfig.where(:category => "CAS User Authentication")
if cas_config.length == 6 
  # Store omniauth config values from main application's ConcertoConfig
  omniauth_config = {
    :host => ConcertoConfig[:cas_host],
    :url => ConcertoConfig[:cas_url],
    :uid_key => ConcertoConfig[:cas_uid_key],
    :email_key => ConcertoConfig[:cas_email_key],
    :first_name_key => ConcertoConfig[:cas_first_name_key],
    :last_name_key => ConcertoConfig[:cas_last_name_key]
  }
else 
  # Required ConcertoConfig keys have not been created, fallback to defaults
  omniauth_config = {
    :host => "cas.example.org",
    :url => "https://cas.example.org/cas",
    :uid_key => "user",
    :email_key => "email",
    :first_name_key => "first_name",
    :last_name_key => "last_name"
  }
end

# configure omniauth-cas gem based on specified yml configs
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas, omniauth_config
end

# save omniauth configuration for later use in application
#  to reference any unique identifiers for extra CAS options
ConcertoCasAuth::Engine.configure do
   config.omniauth_keys = omniauth_config
end
