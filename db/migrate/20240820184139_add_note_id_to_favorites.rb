class AddNoteIdToFavorites < ActiveRecord::Migration[7.1]
  def change
    add_column :favorites, :note_id, :integer
  end
end
