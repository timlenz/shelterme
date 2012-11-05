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

require 'spec_helper'

describe Address do
  
  let(:shelter) { FactoryGirl.create(:shelter) }
  before { @address = shelter.build_address(street: "123 Main St",
                                              city:   "Anytown",
                                              state:  "NY",
                                              zipcode:  "12345") }

  subject { @address }
  
  it { should respond_to(:street) }
  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:zipcode) }
  it { should respond_to(:shelter_id) }
  it { should respond_to(:shelter) }
  
  its(:shelter) { should == shelter }
  
  it { should be_valid }
  
  describe "when shelter_id is not present" do
    before { @address.shelter_id = nil }
    it { should_not be_valid }
  end
  
  describe "when street is blank" do
    before { @address.street = " "} 
    it { should_not be_valid }
  end

  describe "when city is blank" do
    before { @address.city = " "} 
    it { should_not be_valid }
  end

  describe "when state is blank" do
    before { @address.state = " "} 
    it { should_not be_valid }
  end

  describe "when zipcode is blank" do
    before { @address.zipcode = " "} 
    it { should_not be_valid }
  end
  
end
