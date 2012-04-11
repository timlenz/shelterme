class Shelter < ActiveRecord::Base
  attr_accessible :description, :email, :name, :phone
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :phone, presence: true
end
