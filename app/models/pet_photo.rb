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
#  user_id    :integer
#

class PetPhoto < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  attr_accessible :image, :pet_id, :primary, :user_id
  
  belongs_to :pet#, counter_cache: true
  belongs_to :user
  
  validates :image, presence: true
  validates :pet_id, presence: true
  validates :user_id, presence: true
  
  default_scope order: 'pet_photos.created_at ASC'
  
  mount_uploader :image, ImageUploader

end
