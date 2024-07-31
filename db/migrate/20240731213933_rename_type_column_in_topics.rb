class RenameTypeColumnInTopics < ActiveRecord::Migration[6.0]
  def change
    rename_column :topics, :type, :topic_type
  end
end
