# == Schema Information
#
# Table name: coats
#
#  id                 :integer         not null, primary key
#  primary_color_id   :integer
#  fur_length_id      :integer
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  secondary_color_id :integer
#

require 'spec_helper'

describe Coat do

  before do
    @coat = Coat.new(fur_length_id: 1, primary_color_id: 1, secondary_color_id: nil)
  end

  subject { @coat }

  it { should respond_to(:primary_color_id) }
  it { should respond_to(:secondary_color_id) }
  it { should respond_to(:fur_length_id) }

  it { should be_valid }
  
  describe "when primary color id or secondary color id is not present" do
    before { @coat.primary_color_id = nil || @coat.secondary_color_id = nil }
    it { should_not be_valid }
  end
  
  describe "when fur length id is not present" do
    before { @coat.fur_length_id = nil }
    it { should_not be_valid }
  end
end
