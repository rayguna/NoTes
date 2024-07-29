# == Schema Information
#
# Table name: favorites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  note_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_favorites_on_note_id  (note_id)
#  index_favorites_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (note_id => notes.id)
#  fk_rails_...  (user_id => users.id)
#
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :note

  validates :user_id, :note_id, presence: true
end

