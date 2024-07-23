class AddUsernameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :string

    User.reset_column_information
    User.find_each do |user|
      user.update_columns(username: "user_#{user.id}")
    end

    change_column_null :users, :username, false
    add_index :users, :username, unique: true
  end
end
