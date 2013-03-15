class UsersController < ApplicationController
  def doAccess
    if !params[:facebookId]
      render :json => "Error - The Facebook ID is required."
    else
      user_data = {}
      user_data.merge!(params)
      user = User.find_or_create_by_facebook_id(user_data)

      response = {'firstName' => user['first_name'], 'lastName' => user['last_name'],
                  'emailAddress' => user['email'], 'profileImage' => user['profile_image_url'],
                  'facebookId' => user['uid']}

      render :json => response
    end
  end
end
