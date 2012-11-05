# == Schema Information
#
# Table name: pet_personas
#
#  id              :integer         not null, primary key
#  affection_id    :integer
#  energy_level_id :integer
#  nature_id       :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class PetPersona < ActiveRecord::Base
  attr_accessible :affection_id, :energy_level_id, :nature_id,
                  :affection_attributes, :energy_level_attributes,
                  :nature_attributes
  
  belongs_to :affection
  belongs_to :energy_level
  belongs_to :nature
  has_many :pets
  
  accepts_nested_attributes_for :affection
  accepts_nested_attributes_for :energy_level
  accepts_nested_attributes_for :nature
  
  validates :affection_id, presence: true
  validates :energy_level_id, presence: true
  validates :nature_id, presence: true
end
