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

require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  let!(:pet) { FactoryGirl.create(:pet) }
  before { @micropost = user.microposts.build(content: "Filler text", pet_id: pet.id) }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:pet_id)}
  it { should respond_to(:pet) } # maybe unnecessary
  its(:user) { should == user }
  its(:pet) { should == pet }
  
  it { should be_valid }
  
  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when pet_id is not present" do
    before { @micropost.pet_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank content" do
    before { @micropost.content = " "} 
    it { should_not be_valid }
  end
  
  describe "with content that is too long" do
    before { @micropost.content = "a" * 201 }
    it { should_not be_valid }
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  describe "from_users_followed_by" do
    
    let(:user)        { FactoryGirl.create(:user) }
    let(:other_user)  { FactoryGirl.create(:user) }
    let(:third_user)  { FactoryGirl.create(:user) }
    
    before { user.follow!(other_user) }
    
    let(:own_post)          {       user.microposts.create!(content: "foo", pet_id: pet.id) }
    let(:followed_post)     { other_user.microposts.create!(content: "barry", pet_id: pet.id) }
    let(:unfollowed_post)   { third_user.microposts.create!(content: "blah", pet_id: pet.id) }
    
    subject { Micropost.from_users_followed_by(user) }
    
    it { should include(own_post) }
    it { should include(followed_post) }
    it { should_not include(unfollowed_post) }
  end
end
