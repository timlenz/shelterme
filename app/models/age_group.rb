# == Schema Information
#
# Table name: age_groups
#
#  id         :integer         not null, primary key
#  group      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class AgeGroup < ActiveRecord::Base
  attr_accessible :group
  
  has_many :pets
  
  validates :group, presence: true
end
