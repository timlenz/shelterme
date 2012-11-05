# == Schema Information
#
# Table name: pet_media
#
#  id         :integer         not null, primary key
#  pet_id     :integer
#  media      :string(255)
#  photo      :boolean
#  primary    :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe PetMedia do
  
  let(:pet) { FactoryGirl.create(:pet) }
  before { @pet_media = pet.pet_media.build( media: "asdf.jpg",
                                             photo: true,
                                             primary: true) }
                                             
  subject { @pet_media }
  
  it { should respond_to(:media) }
  it { should respond_to(:photo) }
  it { should respond_to(:primary) }
  
  its(:pet) { should == pet }
  
  it { should be_valid }
  
  describe "when pet_id is not present" do
    before { @pet_media.pet_id = nil }
    it { should_not be_valid }
  end
  
  describe "when media is blank" do
    before { @pet_media.media = " " }
    it { should_not be_valid }
  end
  
  describe "when photo is blank" do
    before { @pet_media.photo = " " }
    it { should_not be_valid }
  end
  
  describe "when primary is blank" do
    before { @pet_media.primary = " " }
    it { should_not be_valid }
  end
end
