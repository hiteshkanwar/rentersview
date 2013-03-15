class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :omniauthable

  include Omniauth

  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :city, :country, :last_name,
                  :first_name, :phone, :provider, :uid, :profile_image_url

  has_many :authorizations, dependent: :destroy
  has_many :reviews
  has_many :ads

  def name
    "#{first_name} #{last_name}".strip
  end
end
