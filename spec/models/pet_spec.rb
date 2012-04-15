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

require 'spec_helper'

describe Pet do
  
  let(:user) { FactoryGirl.create(:user) }
  before do
    @pet = user.pets.build(name: "Sammy", 
                    description: "He acts like a puppy. Very silly, playful and loving.")
  end
  
  subject { @pet }
  
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
#  it { should respond_to(:adsf) }  weight
#  it { should respond_to(:adsf) }  size
#  it { should respond_to(:adsf) }  gender
#  it { should respond_to(:adsf) }  age
#  it { should respond_to(:adsf) }  mix
#  it { should respond_to(:adsf) }  coat
#  it { should respond_to(:adsf) }  petPersona
#  it { should respond_to(:adsf) }  status
#  it { should respond_to(:adsf) }  shelter
#  it { should respond_to(:adsf) }  species
#  it { should respond_to(:adsf) }  matches
#  it { should respond_to(:adsf) }  bonds
#  it { should respond_to(:adsf) }  microposts

  it { should be_valid }
  
  describe "when name is not present" do
    before { @pet.name = " "} 
    it { should_not be_valid }
  end
  
  describe "when description is not present" do
    before { @pet.description = " "} 
    it { should_not be_valid }
  end
  
  describe "when user_id is not present" do
    before { @pet.user_id = nil }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
