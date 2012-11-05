# == Schema Information
#
# Table name: age_periods
#
#  id         :integer         not null, primary key
#  length     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe AgePeriod do

  before do
    @age_period = AgePeriod.new(length: "days")
  end
  
  subject { @age_period }
  
  it { should respond_to(:length) }
  
  it { should be_valid }
  
  describe "when length is blank" do
    before { @age_period.length = " "} 
    it { should_not be_valid }
  end
end