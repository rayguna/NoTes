class AddAuthorEmailToTopics < ActiveRecord::Migration[7.1]
  def change
    add_column :topics, :author_email, :string
  end
end
