# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Topic < ApplicationRecord
  has_many :notes, dependent: :destroy
  belongs_to :user  

  validates :name, presence: true
  validates :user_id, presence: true
end
