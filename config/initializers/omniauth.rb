# Initializer for omniauth-cas gem

# get yml config from main Concerto application in config directory
raw_config = YAML.load_file("#{Rails.root.to_s}/config/concerto_cas_auth.yml")

# read all available configuration options from yml file
omniauth_config = {}
raw_config.each do |key, value|
  omniauth_config[key] = value
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