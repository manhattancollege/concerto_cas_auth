module ConcertoCasAuth
  class ApplicationController < ::ApplicationController

    require 'concerto_identity'

    def find_from_omniauth(cas_hash)
      # Get any configuration options for customized CAS return value identifiers
      omniauth_keys = ConcertoCasAuth::Engine.config.omniauth_keys

      if identity = ConcertoIdentity::Identity.find_by_user_id(cas_hash[omniauth_keys["uid_key"]])
        # Check if user already exists
        return identity.user
      else
        # Add a new user via omniauth cas details
        user = User.new

        # Set user attributes
        user.is_admin = false
        user.first_name = cas_hash[omniauth_keys["first_name_key"]]
        user.email = cas_hash[omniauth_keys["email_key"]]
        user.password, user.password_confirmation = Devise.friendly_token.first(8)

        if !User.exists?
          # First user is an admin
          first_user_setup = true
          user.is_admin = true

          # Error reporting
          user.recieve_moderation_notifications = true
          user.confirmed_at = Date.today

          # Set concerto system config variables
          if ConcertoConfig["setup_complete"] == false
            ConcertoConfig.set("setup_complete", "true")
            ConcertoConfig.set("send_errors", "true")
          end

          # Create Concerto Admin Group
          group = Group.where(:name => "Concerto Admins").first_or_create
          membership = Membership.create(:user_id => user.id, :group_id => group.id, :level => Membership::LEVELS[:leader])
        end

        if user.save
          ConcertoIdentity::Identity.create(provider: "cas", external_id: cas_hash[omniauth_keys["uid_key"]], user_id: user.id)
          return user
        else
          return nil
        end
      end
    end

  end
end
