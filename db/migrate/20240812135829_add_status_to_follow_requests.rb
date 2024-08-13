class AddStatusToFollowRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :follow_requests, :status, :string
  end
end
