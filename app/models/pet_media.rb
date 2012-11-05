# == Schema Information
#
# Table name: pet_media
#
#  id         :integer         not null, primary key
#  pet_id     :integer
#  media      :string(255)
#  photo      :boolean
#  primary    :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class PetMedia < ActiveRecord::Base
  attr_accessible :media, :photo, :primary, :pet_id
  
  belongs_to :pet, inverse_of: :pet_media
  
  validates :media, presence: true
  validates :photo, presence: true
  validates :primary, presence: truep
  
  validates :pet_id, presence: true
  
  mount_uploader :media, MediaUploader
end
