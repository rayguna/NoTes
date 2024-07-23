# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  password   :string
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :notes
  has_many :favorites
  has_many :favorite_notes, through: :favorites, source: :note
end
