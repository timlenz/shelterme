# == Schema Information
#
# Table name: pet_photos
#
#  id         :integer         not null, primary key
#  pet_id     :integer
#  image      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  primary    :boolean         default(FALSE)
#

class PetPhoto < ActiveRecord::Base
  attr_accessible :image, :pet_id, :primary, :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  after_update :crop_pet_photo
  
  belongs_to :pet
  
  validates :image, presence: true
  validates :pet_id, presence: true
  
  default_scope order: 'pet_photos.created_at ASC'
  
  mount_uploader :image, ImageUploader
  
  def crop_pet_photo
    image.recreate_versions! if crop_x.present?
  end
end
