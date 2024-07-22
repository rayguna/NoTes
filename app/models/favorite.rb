# == Schema Information
#
# Table name: favorites
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  note_id    :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_favorites_on_note_id  (note_id)
#  index_favorites_on_user_id  (user_id)
#
# Foreign Keys
#
#  note_id  (note_id => notes.id)
#  user_id  (user_id => users.id)
#
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :note
end
