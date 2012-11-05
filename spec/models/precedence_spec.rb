# == Schema Information
#
# Table name: precedences
#
#  id         :integer         not null, primary key
#  rank       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Precedence do

  before do
    @precedence = Precedence.new(rank: 5)
  end
  
  subject { @precedence }
  
  it { should respond_to(:rank) }
  
  it { should be_valid }
  
  describe "when rank is blank" do
    before { @precedence.rank = " "} 
    it { should_not be_valid }
  end
end
