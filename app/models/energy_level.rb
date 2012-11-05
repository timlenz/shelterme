# == Schema Information
#
# Table name: energy_levels
#
#  id         :integer         not null, primary key
#  level      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class EnergyLevel < ActiveRecord::Base
  attr_accessible :level
  
  has_many :pets
  
  validates :level, presence: true
end
