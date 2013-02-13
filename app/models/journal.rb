# == Schema Information
#
# Table name: journals
#
#  id               :integer         not null, primary key
#  shelter_id       :integer
#  pet_id           :integer
#  pet_state_id     :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  old_pet_state_id :integer
#

class Journal < ActiveRecord::Base
  attr_accessible :pet_state_id, :shelter_id, :old_pet_state_id
  
  belongs_to :pet
  belongs_to :shelter
  belongs_to :pet_state, class_name: "PetState"
  belongs_to :old_pet_state, class_name: "PetState"
  
  validates :shelter_id, presence: true
  validates :pet_id, presence: true
  validates :pet_state_id, presence: true

end
