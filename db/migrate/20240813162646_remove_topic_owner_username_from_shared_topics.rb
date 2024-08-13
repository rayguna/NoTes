class RemoveTopicOwnerUsernameFromSharedTopics < ActiveRecord::Migration[6.0]
  def change
    remove_column :shared_topics, :topic_owner_username, :string
  end
end
