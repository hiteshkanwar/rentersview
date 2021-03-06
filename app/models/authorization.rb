class Authorization < ActiveRecord::Base
  attr_accessible :provider, :secret, :token, :uid,:username

  belongs_to :user

  validates :provider, uniqueness: { scope: :uid }

  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, user=nil)

    user.authorizations.create(uid: hash['uid'],
                               username: hash['username'] || hash['extra']['raw_info']['username'],
                               provider: hash['provider'],
                               secret: hash['credentials']['secret'],
                               token: hash['credentials']['token'])
  end

end
