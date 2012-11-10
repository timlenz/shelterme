# == Schema Information
#
# Table name: pet_videos
#
#  id             :integer         not null, primary key
#  pet_id         :integer
#  panda_video_id :string(255)
#  primary        :boolean         default(FALSE)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

class PetVideo < ActiveRecord::Base
  attr_accessible :panda_video_id, :pet_id, :primary
  
  belongs_to :pet
  
  validates :panda_video_id, presence: true
  validates :pet_id, presence: true
  
  default_scope order: 'pet_videos.created_at ASC'
  
  def panda_video
    @panda_video ||= Panda::Video.find(panda_video_id)
  end
  
end
