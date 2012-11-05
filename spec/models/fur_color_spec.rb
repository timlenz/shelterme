# == Schema Information
#
# Table name: fur_colors
#
#  id         :integer         not null, primary key
#  color      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe FurColor do

  before do
    @fur_color = FurColor.new(color: "black")
  end
  
  subject { @fur_color }
  
  it { should respond_to(:color) }
  
  it { should be_valid }
  
  describe "when color is blank" do
    before { @fur_color.color = " "} 
    it { should_not be_valid }
  end
end