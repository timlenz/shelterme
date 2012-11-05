# == Schema Information
#
# Table name: pet_states
#
#  id         :integer         not null, primary key
#  status     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe PetState do

  before do
    @pet_state = PetState.new(status: "available")
  end
  
  subject { @pet_state }
  
  it { should respond_to(:status) }
  
  it { should be_valid }
  
  describe "when status is blank" do
    before { @pet_state.status = " "} 
    it { should_not be_valid }
  end
end