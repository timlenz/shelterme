# == Schema Information
#
# Table name: shelter_hours
#
#  id         :integer         not null, primary key
#  shelter_id :integer
#  day        :integer(1)
#  open_time  :time
#  close_time :time
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe ShelterHours do
  
  let(:shelter) { FactoryGirl.create(:shelter) }
  before { @shelter_hours = shelter.shelter_hours.build(day: 1,
                                                        open_time: "09:00",
                                                        close_time: "18:00") }

  subject { @shelter_hours }
  
  it { should respond_to(:day) }
  it { should respond_to(:open_time) }
  it { should respond_to(:close_time) }
  it { should respond_to(:shelter_id) }
  it { should respond_to(:shelter) }
  
  its(:shelter) { should == shelter }
  
  it { should be_valid }
  
  describe "when shelter_id is not present" do
    before { @shelter_hours.shelter_id = nil }
    it { should_not be_valid }
  end
  
  describe "when day is blank" do
    before { @shelter_hours.day = " " } 
    it { should_not be_valid }
  end
  
  describe "when open_time is blank" do
    before { @shelter_hours.open_time = " " }
    it { should be_valid }
  end
  
  describe "when close_time is blank" do
    before { @shelter_hours.close_time = " " }
    it { should be_valid }
  end
  
end
