# == Schema Information
#
# Table name: journals
#
#  id               :integer         not null, primary key
#  shelter_id       :integer
#  pet_id           :integer
#  pet_state_id     :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  old_pet_state_id :integer
#

require 'spec_helper'

describe Journal do
  pending "add some examples to (or delete) #{__FILE__}"
end
