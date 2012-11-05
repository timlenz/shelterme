# == Schema Information
#
# Table name: genders
#
#  id         :integer         not null, primary key
#  sex        :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Gender do

  before do
    @gender = Gender.new(sex: "male")
  end
  
  subject { @gender }
  
  it { should respond_to(:sex) }
  
  it { should be_valid }
  
  describe "when sex is blank" do
    before { @gender.sex = " "} 
    it { should_not be_valid }
  end
end