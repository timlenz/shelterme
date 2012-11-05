# == Schema Information
#
# Table name: bonds
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  pet_id     :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Bond < ActiveRecord::Base
  attr_accessible :pet_id
  
  belongs_to :user
  belongs_to :pet
  
  validates :user_id, presence: true
  validates :pet_id, presence: true
end
