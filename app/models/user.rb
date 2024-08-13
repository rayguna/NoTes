# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :notes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :topics

  has_many :shared_topics
  has_many :shared_with_me_topics, through: :shared_topics, source: :topic

  validates :email, presence: true, uniqueness: true

  validates :username, presence: true, uniqueness: true

    # Check if a topic is shared with this user
    def can_access?(topic)
      topic.user == self || topic.shared_users.include?(self)
    end
  
    # Share a topic with another user
    def share_topic_with(topic, other_user)
      if FollowRequest.exists?(sender_id: self.id, recipient_id: other_user.id, status: 'accepted') || 
         FollowRequest.exists?(sender_id: other_user.id, recipient_id: self.id, status: 'accepted')
        topic.share_with(other_user)
      else
        raise "You can only share topics with users who have accepted your follow request."
      end
    end

end
