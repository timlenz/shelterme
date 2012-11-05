# == Schema Information
#
# Table name: affections
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Affection < ActiveRecord::Base
  attr_accessible :name
  
  has_many :pets
  
  validates :name, presence: true
end
