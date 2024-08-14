# == Schema Information
#
# Table name: topics
#
#  id           :bigint           not null, primary key
#  author_email :string
#  name         :string
#  topic_type   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_topics_on_name_and_user_id  (name,user_id) UNIQUE
#  index_topics_on_user_id           (user_id)
#
class Topic < ApplicationRecord
  has_many :shared_topics
  has_many :shared_users, through: :shared_topics, source: :user

  encrypts :name

  has_many :notes, dependent: :destroy
  belongs_to :user  

  validates :name, uniqueness: { scope: :user_id, message: "has already been taken for this user" }
  validates :name, presence: { message: "can't be blank. Please provide a topic name." }
  validates :user_id, presence: true

  has_many :notes

  include PgSearch::Model

  pg_search_scope :search_by_name,
    against: :name,
    using: {
      tsearch: { prefix: true, any_word: true },  # Prefix allows for partial matching
      trigram: { threshold: 0.3 }                 # Fuzzy matching threshold
    }

  has_many :notes
  belongs_to :user

  def decrypt(attribute)
    # Assuming you're using Active Record Encryption
    self.public_send(attribute) # This assumes automatic decryption by Active Record Encryption
  end

  def share_with(user)
    self.shared_users << user unless self.shared_users.include?(user)
  end

  # For searching purposes
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at", "user_id", "topic_type"]
  end
end
