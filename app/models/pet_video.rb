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
#  user_id        :integer
#

class PetVideo < ActiveRecord::Base
  attr_accessible :panda_video_id, :pet_id, :primary, :user_id
  
  belongs_to :pet
  belongs_to :user
  
  validates :panda_video_id, presence: true, on: :create
  validates :pet_id, presence: true
  validates :user_id, presence: true
  
  default_scope order: 'pet_videos.created_at ASC'
  
  def panda_video
    @panda_video ||= Panda::Video.find(panda_video_id)
  end
  
  def h264
    @h264 = @panda_video.encodings["h264"]
  end
  
  def webm
    @webm = @panda_video.encodings["webm"]
  end
  
end
