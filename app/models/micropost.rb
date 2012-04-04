# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 200 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'
end
