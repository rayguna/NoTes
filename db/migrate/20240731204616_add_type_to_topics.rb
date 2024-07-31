class AddTypeToTopics < ActiveRecord::Migration[7.1]
  def change
    add_column :topics, :type, :string
  end
end
