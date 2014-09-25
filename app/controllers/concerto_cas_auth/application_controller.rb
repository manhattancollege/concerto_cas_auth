module ConcertoCasAuth
  class ApplicationController < ::ApplicationController

    # Used to map a user id with a corresponding authentication provider in the
    #   database (in this case it's CAS)
    require 'concerto_identity'

    # Find or create a new user based on values returned by the CAS callback
    def find_from_omniauth(cas_hash)
      # Get configuration options for customized CAS return value identifiers
      omniauth_keys = ConcertoCasAuth::Engine.config.omniauth_keys

      # Check if an identity records exists for the user attempting to sign in
      if identity = ConcertoIdentity::Identity.find_by_external_id(
                                            cas_hash.extra[omniauth_keys[:uid_key]])
        # Return the matching user record
        return identity.user
      else
        # Add a new user via omniauth cas details
        user = User.new

        # Set user attributes

        # First name is required for user validation
        if !cas_hash.extra[omniauth_keys[:first_name_key]].nil?
          user.first_name = cas_hash.extra[omniauth_keys[:first_name_key]]
        else 
          user.first_name = cas_hash.extra[omniauth_keys[:uid_key]]
        end

        # Email is required for user validation
        user.email = cas_hash.info[omniauth_keys[:email_key]]

        # Set user admin flag to false
        user.is_admin = false
        # Set user password and confirmation to random tokens
        user.password,user.password_confirmation=Devise.friendly_token.first(8)

        # Check if this is our application's first user
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
          membership = Membership.create(:user_id => user.id, 
            :group_id => group.id, 
            :level => Membership::LEVELS[:leader])
        end

        # Attempt to save our new user
        if user.save
          # Create a matching identity to track our new user for future 
          #   sessions and return our new user record 
          ConcertoIdentity::Identity.create(provider: "cas", 
            external_id: cas_hash.extra[omniauth_keys[:uid_key]], 
            user_id: user.id)
          return user
        else
          # User save failed, an error occurred 
          flash.notice = "Failed to sign in with CAS. 
            #{user.errors.full_messages.to_sentence}."
          return nil
        end
      end
    end

  end
end
