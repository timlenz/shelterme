# == Schema Information
#
# Table name: fur_lengths
#
#  id         :integer         not null, primary key
#  length     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe FurLength do

  before do
    @fur_length = FurLength.new(length: "short")
  end
  
  subject { @fur_length }
  
  it { should respond_to(:length) }
  
  it { should be_valid }
  
  describe "when length is blank" do
    before { @fur_length.length = " "} 
    it { should_not be_valid }
  end
end