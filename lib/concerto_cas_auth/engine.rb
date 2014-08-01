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

        ConcertoConfig.make_concerto_config("cas_url", "https://cas.example.org/cas", :value_type => "string", :value_default => "https://cas.example.org/cas", :category => 'CAS User Authentication', :seq_no => 1, :description =>"Defines the url of your CAS server")
        ConcertoConfig.make_concerto_config("cas_uid_key", "user", :value_type => "string", :value_default => "user", :category => 'CAS User Authentication', :seq_no => 2, :description =>"Your user's unique identifier.")
        ConcertoConfig.make_concerto_config("cas_email_key", "email", :value_type => "string", :value_default => "email", :category => 'CAS User Authentication', :seq_no => 3, :description =>"The data attribute containing user email address")
        ConcertoConfig.make_concerto_config("cas_first_name_key", "first_name", :value_type => "string", :value_default => "first_name", :category => 'CAS User Authentication', :seq_no => 4, :description =>"The data attribute containing user first name")
        ConcertoConfig.make_concerto_config("cas_last_name_key", "last_name", :value_type => "string", :value_default => "last_name", :category => 'CAS User Authentication', :seq_no => 5, :description =>"The data attribute containing user last name")

        # View hook to override Devise sign in links in the main application
        add_view_hook "ApplicationController", :signin_hook,
          :partial => "concerto_cas_auth/omniauth_cas/signin"

      end
    end

  end
end
