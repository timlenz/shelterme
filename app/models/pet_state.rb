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
  has_many :journals
  has_many :old_journals, foreign_key: "old_pet_state_id", class_name: "Journal"
  has_many :old_pet_states, through: :old_journals, source: :old_pet_state
  
  validates :status, presence: true
end