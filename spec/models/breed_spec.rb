# == Schema Information
#
# Table name: breeds
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  species_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Breed do

  before do
    @breed = Breed.new(name: "Basset Hound", species_id: 1)
  end
  
  subject { @breed }
  
  it { should respond_to(:name) }
  it { should respond_to(:species_id) }
  
  it { should be_valid }
  
  describe "when name is blank" do
    before { @breed.name = " " } 
    it { should_not be_valid }
  end
  
  describe "when species_id is blank" do
    before { @breed.species_id = " " }
    it { should_not be_valid }
  end
end