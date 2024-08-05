# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  name       :string
#  topic_type :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_topics_on_name_and_user_id  (name,user_id) UNIQUE
#  index_topics_on_user_id           (user_id)
#
class Topic < ApplicationRecord
  # has_one_attached :avatar #for aws image upload

  has_many :notes, dependent: :destroy
  belongs_to :user  

  validates :name, uniqueness: { scope: :user_id, message: "has already been taken for this user" }
  validates :name, presence: { message: "can't be blank. Please provide a topic name." }
  validates :user_id, presence: true

  # enum topic_type: { note: 'note', teases: 'teases' }

  # For searching purposes
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at", "user_id", "topic_type"]
  end
end
