class Message < ActiveRecord::Base
  attr_accessible :content, :receiver_id, :sender_id,:ad_id

  belongs_to :receiver, class_name: 'User'
  belongs_to :sender, class_name: 'User'
  belongs_to :ad
end
