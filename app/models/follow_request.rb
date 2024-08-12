# == Schema Information
#
# Table name: follow_requests
#
#  id           :bigint           not null, primary key
#  status       :string
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

  validates :recipient_id, presence: true
  validates :sender_id, presence: true
  validate :recipient_and_sender_cannot_be_same
  validate :no_duplicate_follow_request
  validate :no_reverse_duplicate_follow_request

  def recipient_username
    recipient.username
  end

  def sender_username
    sender.username
  end

  private

  def recipient_and_sender_cannot_be_same
    if recipient_id == sender_id
      errors.add(:recipient_id, "cannot be the same as the sender")
    end
  end

  def no_duplicate_follow_request
    if FollowRequest.exists?(sender_id: sender_id, recipient_id: recipient_id)
      errors.add(:base, "A follow request already exists between these users")
    end
  end

  def no_reverse_duplicate_follow_request
    if FollowRequest.exists?(sender_id: recipient_id, recipient_id: sender_id)
      errors.add(:base, "A follow request already exists between these users in the reverse order")
    end
  end
end
