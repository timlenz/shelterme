# == Schema Information
#
# Table name: age_groups
#
#  id         :integer         not null, primary key
#  group      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe AgeGroup do

  before do
    @age_group = AgeGroup.new(group: "young")
  end
  
  subject { @age_group }
  
  it { should respond_to(:group) }
  
  it { should be_valid }
  
  describe "when group is blank" do
    before { @age_group.group = " "} 
    it { should_not be_valid }
  end
end