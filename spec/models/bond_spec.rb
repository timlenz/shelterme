# == Schema Information
#
# Table name: bonds
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  pet_id     :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Bond do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:pet) { FactoryGirl.create(:pet) }
  let(:bond) { user.bonds.build(pet_id: pet.id) }
  
  subject { bond }
  
  it { should be_valid }
  
  describe "bonded methods" do
    before { bond.save }
    
    it { should respond_to(:user) }
    it { should respond_to(:pet) }
    its(:user) { should == user }
    its(:pet) { should == pet }
  end
  
  describe "when pet id is not present" do
    before { bond.pet_id = nil }
    it { should_not be_valid }
  end
  
  describe "when user id is not present" do
    before { bond.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Bond.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
