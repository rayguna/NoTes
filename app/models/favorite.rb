# == Schema Information
#
# Table name: favorites
#
#  id               :bigint           not null, primary key
#  favoritable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  favoritable_id   :bigint
#  note_id          :integer
#  topic_id         :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_favorites_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favoritable, polymorphic: true

  belongs_to :note, optional: true
  belongs_to :topic, optional: true
  belongs_to :user

  validates :user_id, presence: true
  validates :favoritable_id, presence: true
  validates :favoritable_type, presence: true
end
