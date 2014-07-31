module ConcertoCasAuth

  require 'omniauth'
  require 'omniauth-cas'
  require 'concerto_identity'

  class Engine < ::Rails::Engine
    isolate_namespace ConcertoCasAuth
    engine_name 'concerto_cas_auth'

    # Define plugin information for the Concerto application to read.
    # Do not modify @plugin_info outside of this static configuration block.
    def plugin_info(plugin_info_class)
      @plugin_info ||= plugin_info_class.new do

        # Add our concerto_cas_auth route to the main application
        add_route("concerto_cas_auth", ConcertoCasAuth::Engine)

        # Create a hash with all the available Concerto config options
        config_options = {:cas_host => 
          ["cas.example.org", "Defines the host of your CAS server"],
          :cas_url => 
          ["https://cas.example.org/cas","Defines the url of your CAS server"],
          :cas_uid_key => 
          ["user", "Your user's unique identifier."],
          :cas_email_key =>
          ["email", "The data attribute containing user email address"],
          :cas_first_name_key =>
          ["first_name", "The data attribute containing user first name"],
          :cas_last_name_key =>
          ["last_name", "The data attribute containing user last name"]
        }

        # Add our Concerto config options to the main application
        config_options.each do |key, value|
          add_config(key.to_s, value.first,
                    :name => key.to_s[3..-1],
                    :value_type => "string",
                    :category => "CAS User Authentication",
                    :description => value.last)
        end

        # View hook to override Devise sign in links in the main application
        add_view_hook "ApplicationController", :signin_hook, 
          :partial => "concerto_cas_auth/omniauth_cas/signin"

      end
    end

  end
end
