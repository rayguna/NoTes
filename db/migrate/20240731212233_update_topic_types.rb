class UpdateTopicTypes < ActiveRecord::Migration[6.0]
  def up
    Topic.where(type: 'question').update_all(type: 'teases')
  end

  def down
    Topic.where(type: 'teases').update_all(type: 'question')
  end
end
