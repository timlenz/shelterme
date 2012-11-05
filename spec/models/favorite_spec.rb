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

require 'spec_helper'

describe Favorite do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:shelter) { FactoryGirl.create(:shelter) }
  let(:favorite) { user.favorites.build(shelter_id: shelter.id) }
  
  subject { favorite }
  
  it { should be_valid }
  
  describe "favorited methods" do
    before { favorite.save }
    
    it { should respond_to(:user) }
    it { should respond_to(:shelter) }
    its(:user) { should == user }
    its(:shelter) { should == shelter }
  end
  
  describe "when shelter id is not present" do
    before { favorite.shelter_id = nil }
    it { should_not be_valid }
  end
  
  describe "when user id is not present" do
    before { favorite.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Favorite.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end