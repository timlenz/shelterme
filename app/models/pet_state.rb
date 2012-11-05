# == Schema Information
#
# Table name: pet_states
#
#  id         :integer         not null, primary key
#  status     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class PetState < ActiveRecord::Base
  attr_accessible :status
  
  has_many :pets
  
  validates :status, presence: true
end
