# == Schema Information
#
# Table name: shelter_hours
#
#  id         :integer         not null, primary key
#  shelter_id :integer
#  day        :integer(1)
#  open_time  :time
#  close_time :time
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class ShelterHours < ActiveRecord::Base
  attr_accessible :close_time, :day, :open_time
  belongs_to :shelter, inverse_of: :shelter_hours
  
  validates :day, presence: true
  validates :shelter_id, presence: true
  validates :shelter, presence: true
end
