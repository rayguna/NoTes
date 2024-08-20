class AddTopicIdToFavorites < ActiveRecord::Migration[7.1]
  def change
    add_column :favorites, :topic_id, :bigint
  end
end
