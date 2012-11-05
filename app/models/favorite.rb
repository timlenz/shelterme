# == Schema Information
#
# Table name: favorites
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  shelter_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Favorite < ActiveRecord::Base
  attr_accessible :shelter_id
  
  belongs_to :user
  belongs_to :shelter
  
  validates :user_id, presence: true
  validates :shelter_id, presence: true
end
