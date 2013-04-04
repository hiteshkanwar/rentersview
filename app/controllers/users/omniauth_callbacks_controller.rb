class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def oauth
    @user = User.find_or_create_from_oauth(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => request.env['omniauth.auth']['provider']
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.omniauth_data"] = extract_data_from_auth(request.env['omniauth.auth'])
      redirect_to new_user_registration_url, notice: 'Please complete your registration.'
    end
  end
  alias_method :facebook, :oauth
  alias_method :twitter, :oauth

  private

  def extract_data_from_auth(auth_hash)
    Rails.logger.debug auth_hash
    data = {}
    data['authorization'] = auth_hash.select { |k, v| ['uid', 'provider', 'credentials'].include?(k) }
    if auth_hash.provider == 'twitter'
      data['authorization']['username'] = auth_hash.extra.raw_info.screen_name
    elsif auth_hash.provider == 'facebook'
      data['authorization']['username'] = auth_hash.extra.raw_info.username
    end
    data['user'] = auth_hash.extra.raw_info.select { |k, v| ['name', 'profile_image_url'].include?(k) }
    
    data
  end

end
