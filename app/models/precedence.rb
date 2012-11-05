# == Schema Information
#
# Table name: precedences
#
#  id         :integer         not null, primary key
#  rank       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Precedence < ActiveRecord::Base
  attr_accessible :rank
  has_many :shelters
  
  validates :rank, presence: true
end
