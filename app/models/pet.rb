# == Schema Information
#
# Table name: pets
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  user_id     :integer
#

class Pet < ActiveRecord::Base
  attr_accessible :name, :description
  belongs_to :user
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :description, presence: true
  validates :user_id, presence: true
#  validates weight, presence: true
#  validates size, presence: true
#  validates gender, presence: true
#  validates age, presence: true
#  validates mix, presence: true
#  validates coat, presence: true
#  validates petPersona, presence: true
#  validates status, presence: true
#  validates shelter, presence: true
#  validates species, presence: true
#  validates matches, presence: true
#  validates bonds, presence: true
#  validates microposts, presence: true

  default_scope order: 'pets.created_at DESC'
end
