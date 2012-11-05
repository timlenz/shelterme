# == Schema Information
#
# Table name: breeds
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  species_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Breed < ActiveRecord::Base
  attr_accessible :name, :species_id
  
  has_many :pets, foreign_key: "primary_breed_id", dependent: :destroy
  has_many :primary_breeds, through: :pets, source: :primary
  has_many :binary_pets, foreign_key: "secondary_breed_id",
                                   class_name: "Pet",
                                   dependent: :destroy
  has_many :secondary_breeds, through: :binary_pets, source: :secondary
  
  belongs_to :species
  
  validates :name, presence: true
  validates :species_id, presence: true
end