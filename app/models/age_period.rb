# == Schema Information
#
# Table name: age_periods
#
#  id         :integer         not null, primary key
#  length     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class AgePeriod < ActiveRecord::Base
  attr_accessible :length
  
  has_many :pets
  
  validates :length, presence: true
end
