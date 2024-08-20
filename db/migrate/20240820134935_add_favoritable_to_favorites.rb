class AddFavoritableToFavorites < ActiveRecord::Migration[6.1]
  def change
    add_column :favorites, :favoritable_type, :string
    add_column :favorites, :favoritable_id, :bigint

    remove_column :favorites, :note_id, :bigint  # Remove if no longer needed
  end
end
