class AddTopicOwnerUsernameToSharedTopics < ActiveRecord::Migration[6.0]
  def change
    add_column :shared_topics, :topic_owner_username, :string
  end
end
