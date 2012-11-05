# == Schema Information
#
# Table name: addresses
#
#  id         :integer         not null, primary key
#  street     :string(255)
#  city       :string(255)
#  state      :string(255)
#  zipcode    :string(255)
#  shelter_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  latitude   :float
#  longitude  :float
#

class Address < ActiveRecord::Base
  attr_accessible :city, :state, :street, :zipcode, :latitude, :longitude
  belongs_to :shelter, inverse_of: :address
  
  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
  validates :shelter_id, presence: true
  
  geocoded_by :street
  after_validation :geocode, if: :street_changed? #Generalize to changes in any element of the Address
end
