# == Schema Information
#
# Table name: attitude_values
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class AttitudeValue < ActiveRecord::Base
  attr_accessible :name
  
  has_many :users
  
  validates :name, presence: true
end
