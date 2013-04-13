# == Schema Information
#
# Table name: energy_levels
#
#  id         :integer         not null, primary key
#  level      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe EnergyLevel do

  before do
    @energy_level = EnergyLevel.new(level: "energetic")
  end
  
  subject { @energy_level }
  
  it { should respond_to(:level) }
  
  it { should be_valid }
  
  describe "when level is blank" do
    before { @energy_level.level = " "} 
    it { should_not be_valid }
  end
end