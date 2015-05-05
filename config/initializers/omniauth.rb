if ActiveRecord::Base.connection.table_exists? 'concerto_configs'
  # Concerto Configs are created if they don't exist already
  #   these are used to initialize and configure omniauth-cas
  ConcertoConfig.make_concerto_config("cas_url", "https://cas.example.org/cas",
    :value_type => "string",
    :value_default => "https://cas.example.org/cas",
    :category => "CAS User Authentication",
    :seq_no => 1,
    :description =>"Defines the url of your CAS server")

  ConcertoConfig.make_concerto_config("cas_uid_key", "uid",
    :value_type => "string",
    :category => "CAS User Authentication",
    :seq_no => 2,
    :description => "CAS field name containing user login names")

  ConcertoConfig.make_concerto_config("cas_email_key", "email",
    :value_type => "string",
    :category => "CAS User Authentication",
    :seq_no => 3,
    :description => "CAS field name containing user email addresses")

  ConcertoConfig.make_concerto_config("cas_email_suffix", "@",
    :value_type => "string",
    :category => "CAS User Authentication",
    :seq_no => 4,
    :description => "Appends this suffix to a CAS returned user id. Leave blank if using email_key above")

  ConcertoConfig.make_concerto_config("cas_first_name_key", "first_name",
    :value_type => "string",
    :category => "CAS User Authentication",
    :seq_no => 5,
    :description => "CAS field name containing first name")

  ConcertoConfig.make_concerto_config("cas_whitelist", "",
    :value_type => "text",
    :value_default => "",
    :category => 'CAS User Authentication',
    :seq_no => 6,
    :description =>'A list of email addresses of CAS accounts allowed to be created')

  # Store omniauth config values from main application's ConcertoConfig
  omniauth_config = {
    :host => URI.parse(ConcertoConfig[:cas_url]).host,
    :url => ConcertoConfig[:cas_url],
    :uid_key => ConcertoConfig[:cas_uid_key],
    :first_name_key => ConcertoConfig[:cas_first_name_key],
    :email_key => ConcertoConfig[:cas_email_key],
    :email_suffix => ConcertoConfig[:cas_email_suffix],
    :callback_url => "/auth/cas/callback",
    :whitelist => ConcertoConfig[:cas_whitelist]
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
end
