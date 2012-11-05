# == Schema Information
#
# Table name: coats
#
#  id                 :integer         not null, primary key
#  primary_color_id   :integer
#  fur_length_id      :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  secondary_color_id :integer
#

class Coat < ActiveRecord::Base
  attr_accessible :primary_color_id, :secondary_color_id, :fur_length_id, :fur_length_attributes
  
  belongs_to :primary_color, class_name: "FurColor"
  belongs_to :secondary_color, class_name: "FurColor"
  belongs_to :fur_length
  has_many :pets
  
  accepts_nested_attributes_for :primary_color
  accepts_nested_attributes_for :secondary_color
  accepts_nested_attributes_for :fur_length
  
  validates :primary_color_id, presence: true, if: "secondary_color_id.nil?"
  validates :secondary_color_id, presence: true, if: "primary_color_id.nil?"
  validates :fur_length_id, presence: true
end
