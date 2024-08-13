class UpdateUniqueIndexOnSharedTopics < ActiveRecord::Migration[6.1]
  def change
    # Remove the old unique index
    remove_index :shared_topics, name: "index_shared_topics_on_user_id_and_topic_id"

    # Add a new unique index for topic_id and shared_user_id
    add_index :shared_topics, [:topic_id, :shared_user_id], unique: true
  end
end
