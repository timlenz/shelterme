# == Schema Information
#
# Table name: genders
#
#  id         :integer         not null, primary key
#  sex        :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Gender < ActiveRecord::Base
  attr_accessible :sex
  
  has_many :pets
  
  validates :sex, presence: true
end
