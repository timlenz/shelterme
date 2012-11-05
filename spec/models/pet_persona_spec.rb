# == Schema Information
#
# Table name: pet_personas
#
#  id              :integer         not null, primary key
#  affection_id    :integer
#  energy_level_id :integer
#  nature_id       :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe PetPersona do

  before do
    @pet_persona = PetPersona.new(affection_id: 1, energy_level_id: 1, nature_id: 1)
  end
  
  subject { @pet_persona }
  
  it { should respond_to(:affection_id) }
  it { should respond_to(:energy_level_id) }
  it { should respond_to(:nature_id) }
  
  it { should be_valid }
  
  describe "when affection_id is blank" do
    before { @pet_persona.affection_id = " "} 
    it { should_not be_valid }
  end

  describe "when energy_level_id is blank" do
    before { @pet_persona.energy_level_id = " "} 
    it { should_not be_valid }
  end

  describe "when nature_id is blank" do
    before { @pet_persona.nature_id = " "} 
    it { should_not be_valid }
  end
end
