# == Schema Information
#
# Table name: shared_topics
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  shared_user_id :integer
#  topic_id       :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_shared_topics_on_topic_id              (topic_id)
#  index_shared_topics_on_user_id               (user_id)
#  index_shared_topics_on_user_id_and_topic_id  (user_id,topic_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => topics.id)
#  fk_rails_...  (user_id => users.id)
#

class SharedTopic < ApplicationRecord
  belongs_to :shared_user, class_name: 'User', foreign_key: 'shared_user_id'
  belongs_to :topic
  belongs_to :user
end
