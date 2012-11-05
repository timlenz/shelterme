# == Schema Information
#
# Table name: ages
#
#  id            :integer         not null, primary key
#  number        :integer
#  age_period_id :integer
#  age_group_id  :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Age < ActiveRecord::Base
  attr_accessible :age_group_id, :age_period_id, :number, :age_group_attributes, :age_period_attributes
  
  belongs_to :age_group
  belongs_to :age_period
  has_many :pets
  
  accepts_nested_attributes_for :age_group
  accepts_nested_attributes_for :age_period
  
  validates :number, presence: true
  validates :age_group_id, presence: true
  validates :age_period_id, presence: true
end
