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
  belongs_to :user
  belongs_to :topic
  has_many :favorites, dependent: :destroy

  validates :title, presence: { message: "can't be blank. Please provide a title." }
  validates :content, presence: { message: "can't be blank. Please provide a content." }

  validates :title, uniqueness: { scope: [:user_id, :topic_id], message: "has already been taken for this topic and user" }
end
