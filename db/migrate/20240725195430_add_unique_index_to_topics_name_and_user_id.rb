class AddUniqueIndexToTopicsNameAndUserId < ActiveRecord::Migration[7.1]
  def change
    add_index :topics, [:name, :user_id], unique: true
  end
end
