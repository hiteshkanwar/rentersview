class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :verify_omniauth_data, only: :create

  def create
    build_resource

    resource.first_name = @auth_hash['user']['name']
    resource.profile_image_url = @auth_hash['user']['profile_image_url']
    resource.password = Devise.friendly_token[0,20]

    if resource.save
      Authorization.create_from_hash(@auth_hash['authorization'], resource)
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  private

  def verify_omniauth_data
    if (@auth_hash = session['devise.omniauth_data']).blank?
      redirect_to root_path, flash: {error: 'Registration is only by facebook or twitter.'}
    end
  end

end
