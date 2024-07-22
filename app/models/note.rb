# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  content    :text
#  text       :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_notes_on_topic_id  (topic_id)
#  index_notes_on_user_id   (user_id)
#
# Foreign Keys
#
#  topic_id  (topic_id => topics.id)
#  user_id   (user_id => users.id)
#
class Note < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_many :favorites
  has_many :favorited_by, through: :favorites, source: :user
end
