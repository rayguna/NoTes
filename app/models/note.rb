# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  content    :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_notes_on_topic_id  (topic_id)
#  index_notes_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#
class Note < ApplicationRecord
  encrypts :title, :content

  has_one_attached :note_image

  belongs_to :user
  belongs_to :topic
  has_many :favorites, dependent: :destroy

  validates :title, presence: { message: "can't be blank. Please provide a title." }
  validates :content, presence: { message: "can't be blank. Please provide a content." }

  validates :title, uniqueness: { scope: [:user_id, :topic_id], message: "has already been taken for this topic and user" }

  belongs_to :topic

  include PgSearch::Model

  pg_search_scope :search_by_content_and_title,
    against: [:title, :content],
    using: {
      tsearch: { prefix: true, any_word: true },  # Prefix allows for partial matching
      trigram: { threshold: 0.3 }                 # Fuzzy matching threshold
    }

  belongs_to :topic
  belongs_to :user

  def decrypt(attribute)
    # Assuming you're using Active Record Encryption
    self.public_send(attribute) # This assumes automatic decryption by Active Record Encryption
  end

  def self.ransackable_attributes(auth_object = nil)
    # Return an array of attributes that can be searched
    %w[title content created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    ["favorites", "topic", "user"]
  end

  def topic_name
    topic.name
  end

  def topic_type
    topic.topic_type
  end
end
