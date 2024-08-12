# == Schema Information
#
# Table name: follow_requests
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :bigint           not null
#  sender_id    :bigint           not null
#
# Indexes
#
#  index_follow_requests_on_recipient_id  (recipient_id)
#  index_follow_requests_on_sender_id     (sender_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipient_id => users.id)
#  fk_rails_...  (sender_id => users.id)
#
class FollowRequest < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :sender, class_name: 'User'

  # You can add validations if needed
  validates :recipient_id, presence: true
  validates :sender_id, presence: true

def recipient_username
  recipient.username
end

def sender_username
  sender.username
end

end
