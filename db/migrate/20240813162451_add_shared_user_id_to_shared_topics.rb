class AddSharedUserIdToSharedTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :shared_topics, :shared_user_id, :integer
  end
end
