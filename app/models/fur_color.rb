# == Schema Information
#
# Table name: fur_colors
#
#  id         :integer         not null, primary key
#  color      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class FurColor < ActiveRecord::Base
  attr_accessible :color
  
  has_many :pets, foreign_key: "primary_color_id", dependent: :destroy
  has_many :primary_colors, through: :pets, source: :primary
  has_many :binary_pets, foreign_key: "secondary_color_id",
                                   class_name: "Pet",
                                   dependent: :destroy
  has_many :secondary_colors, through: :binary_pets, source: :secondary
  
  validates :color, presence: true

end
