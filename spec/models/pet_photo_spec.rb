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

require 'spec_helper'

describe PetPhoto do
  pending "add some examples to (or delete) #{__FILE__}"
end
