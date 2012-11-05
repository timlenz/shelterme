# == Schema Information
#
# Table name: ages
#
#  id            :integer         not null, primary key
#  number        :integer
#  age_period_id :integer
#  age_group_id  :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

require 'spec_helper'

describe Age do

  before do
    @age = Age.new(number: 5, age_period_id: 1, age_group_id: 1)
  end
  
  subject { @age }
  
  it { should respond_to(:number) }
  it { should respond_to(:age_period_id) }
  it { should respond_to(:age_group_id) }
  
  it { should be_valid }
  
  describe "when number is blank" do
    before { @age.number = " "} 
    it { should_not be_valid }
  end
  
  describe "when age_period_id is blank" do
    before { @age.age_period_id = " "}
    it { should_not be_valid }
  end

  describe "when age_group_id is blank" do
    before { @age.age_group_id = " "}
    it { should_not be_valid }
  end
end