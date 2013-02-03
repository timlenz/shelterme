# == Schema Information
#
# Table name: searches
#
#  id              :integer         not null, primary key
#  species_id      :integer
#  age_group       :string(255)
#  gender_id       :integer
#  breed_id        :integer
#  size_id         :integer
#  energy_level_id :integer
#  affection_id    :integer
#  nature_id       :integer
#  location        :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  user_id         :integer
#  save_search     :boolean         default(FALSE)
#

require 'spec_helper'

describe Search do
  pending "add some examples to (or delete) #{__FILE__}"
end
