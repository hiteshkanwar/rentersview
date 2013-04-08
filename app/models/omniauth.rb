require 'active_support/concern'

module Omniauth
  extend ActiveSupport::Concern

  module ClassMethods

    def find_or_create_from_oauth(auth, current_user=nil)
      authorization = Authorization.find_from_hash(auth)
      user = if authorization
        authorization.user
      else
        create_from_hash(auth)
      end
    end

    def create_from_hash(hash)
      data = hash.extra.raw_info
      user =  create(
        first_name: data.first_name || data.name,
        last_name: data.last_name,
        email: data.email,
        profile_image_url: data.profile_image_url || "http://graph.facebook.com/#{hash.uid}/picture?type=square",
        password: Devise.friendly_token[0,20])

      Authorization.create_from_hash(hash, user) if user.persisted?
      user
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.omniauth_data"] && session["devise.omniauth_data"]["info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

  end

end