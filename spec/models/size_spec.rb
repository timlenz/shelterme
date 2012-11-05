# == Schema Information
#
# Table name: sizes
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Size do

  before do
    @size = Size.new(name: "small")
  end
  
  subject { @size }
  
  it { should respond_to(:name) }
  
  it { should be_valid }
  
  describe "when name is blank" do
    before { @size.name = " "} 
    it { should_not be_valid }
  end
end