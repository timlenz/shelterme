# == Schema Information
#
# Table name: affections
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Affection do

  before do
    @affection = Affection.new(name: "devoted")
  end
  
  subject { @affection }
  
  it { should respond_to(:name) }
  
  it { should be_valid }
  
  describe "when name is blank" do
    before { @affection.name = " "} 
    it { should_not be_valid }
  end
end