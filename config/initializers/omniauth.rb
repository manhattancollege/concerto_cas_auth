# Initializer for omniauth-cas gem

# Store omniauth config values
omniauth_config = {}

# Check if concerto_cas_auth yml config file is present in the main application
if File.exists?("#{Rails.root.to_s}/config/initializers/concerto_cas_auth.yml")
	# get yml config from main Concerto application in config directory
	raw_config = YAML.load_file(
		"#{Rails.root.to_s}/config/initializers/concerto_cas_auth.yml")
	# read all available configuration options from yml file
	raw_config.each do |key, value|
	  omniauth_config[key] = value
	end
else
	# concerto_cas_auth yml config file was not present 
	#   in main application, use these default values instead
	#
	#
	# Edit these values and add more optional ones
	#   if you are opposed to using the yml config
	omniauth_config[:url] = "https://cas.example.org/cas"
	omniauth_config[:host] = "cas.example.org"
	omniauth_config[:uid_key] = :user
	omniauth_config[:first_name_key] = :firstname
	omniauth_config[:last_name_key] = :lastname
	omniauth_config[:email_key] = :email
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