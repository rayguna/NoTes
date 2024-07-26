# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_topics_on_name_and_user_id  (name,user_id) UNIQUE
#  index_topics_on_user_id           (user_id)
#
class Topic < ApplicationRecord
  has_many :notes, dependent: :destroy
  belongs_to :user  

  validates :name, uniqueness: { scope: :user_id, message: "has already been taken for this user" }
  validates :name, presence: { message: "can't be blank. Please provide a topic name." }
  validates :user_id, presence: true
  
end
