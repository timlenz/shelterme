# == Schema Information
#
# Table name: shelters
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text(255)
#  email       :string(255)
#  phone       :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Shelter < ActiveRecord::Base
  attr_accessible :description, :email, :name, :phone
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :phone, presence: true
end
