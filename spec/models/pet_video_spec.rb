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

require 'spec_helper'

describe PetVideo do
  pending "add some examples to (or delete) #{__FILE__}"
end
