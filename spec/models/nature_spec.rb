# == Schema Information
#
# Table name: natures
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Nature do

  before do
    @nature = Nature.new(name: "friendly")
  end
  
  subject { @nature }
  
  it { should respond_to(:name) }
  
  it { should be_valid }
  
  describe "when name is blank" do
    before { @nature.name = " "} 
    it { should_not be_valid }
  end
end