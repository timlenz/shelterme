# == Schema Information
#
# Table name: mixes
#
#  id                 :integer         not null, primary key
#  primary_breed_id   :integer
#  secondary_breed_id :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

require 'spec_helper'

describe Mix do

  before do
    @mix = Mix.new(primary_breed_id: 1, secondary_breed_id: 1)
  end
  
  subject { @mix }
  
  it { should respond_to(:primary_breed_id) }
  it { should respond_to(:secondary_breed_id) }
  
  it { should be_valid }
  
  describe "when primary_breed_id is blank" do
    before { @mix.primary_breed_id = " " } 
    it { should_not be_valid }
  end
  
  describe "when secondary_breed_id is blank" do
    before { @mix.secondary_breed_id = " " }
    it { should be_valid }
  end
end