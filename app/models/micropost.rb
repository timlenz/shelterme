# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :text
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  pet_id     :integer
#

class Micropost < ActiveRecord::Base
  attr_accessible :content, :pet_id
  belongs_to :user
  belongs_to :pet
  
  validates :content, presence: true, length: { maximum: 240 }
  validates :user_id, presence: true
  validates :pet_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'
  
  profanity_filter :content
  
  # Returns microposts from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  private
  
    # Returns an SQL condition for users followed by the given user.
    # Include the user's own id as well
    def self.followed_by(user)
      followed_user_ids = %(SELECT followed_id FROM relationships
                            WHERE follower_id = :user_id)
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
            { user_id: user })
    end
end
