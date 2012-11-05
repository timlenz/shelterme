# == Schema Information
#
# Table name: species
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Species do

  before do
    @species = Species.new(name: "dog")
  end
  
  subject { @species }
  
  it { should respond_to(:name) }
  
  it { should be_valid }
  
  describe "when type is blank" do
    before { @species.name = " "} 
    it { should_not be_valid }
  end
end
