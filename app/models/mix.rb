# == Schema Information
#
# Table name: mixes
#
#  id                 :integer         not null, primary key
#  primary_breed_id   :integer
#  secondary_breed_id :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class Mix < ActiveRecord::Base
  attr_accessible :primary_breed_id, :secondary_breed_id, :primary_breed_attributes, :secondary_breed_attributes
  has_many :pets
  
  belongs_to :primary_breed, class_name: "Breed"
  belongs_to :secondary_breed, class_name: "Breed"
  
  accepts_nested_attributes_for :primary_breed
  accepts_nested_attributes_for :secondary_breed
  
  validates :primary_breed_id, presence: true
end
