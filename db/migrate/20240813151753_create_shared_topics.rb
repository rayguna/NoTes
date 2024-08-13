class CreateSharedTopics < ActiveRecord::Migration[6.0]
  def change
    create_table :shared_topics do |t|
      t.references :user, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
    add_index :shared_topics, [:user_id, :topic_id], unique: true
  end
end
