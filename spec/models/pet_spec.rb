# == Schema Information
#
# Table name: pets
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  description        :text
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  user_id            :integer
#  animal_code        :string(255)
#  size_id            :integer
#  gender_id          :integer
#  species_id         :integer
#  pet_state_id       :integer
#  weight             :integer
#  shelter_id         :integer
#  age                :float
#  age_period_id      :integer
#  affection_id       :integer
#  energy_level_id    :integer
#  nature_id          :integer
#  primary_color_id   :integer
#  secondary_color_id :integer
#  fur_length_id      :integer
#  primary_breed_id   :integer
#  secondary_breed_id :integer
#  slug               :string(255)
#  pet_photos_count   :integer         default(0), not null
#  bonds_count        :integer         default(0), not null
#  intake_date        :datetime
#  refuge_name        :string(255)
#  refuge_contact     :string(255)
#

require 'spec_helper'

describe Pet do
  
  let(:user) { FactoryGirl.create(:user) }
  before do
    @pet = user.pets.build(name: "Sammy", 
                    description: "He acts like a puppy. Very silly, playful and loving.",
                    animal_code: "A1234567", weight: 45, size_id: 1, age: 1, age_period_id: 1,
                    affection_id: 1, energy_level_id: 1, nature_id: 1, gender_id: 1,
                    primary_color_id: 1, secondary_color_id: nil, fur_length_id: 1, species_id: 1,
                    primary_breed_id: 1, secondary_breed_id: nil, pet_state_id: 1, shelter_id: 1)
  end
  
  subject { @pet }
  
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:animal_code) }
  it { should respond_to(:bonds) }
  it { should respond_to(:watchers)}
  it { should respond_to(:size_id) }
  it { should respond_to(:weight) }
  it { should respond_to(:age) }
  it { should respond_to(:age_period_id) }
  it { should respond_to(:affection_id) }
  it { should respond_to(:energy_level_id) }
  it { should respond_to(:nature_id) }
  it { should respond_to(:fur_length_id) }
  it { should respond_to(:primary_color_id) }
  it { should respond_to(:secondary_color_id) }
  it { should respond_to(:gender_id) }
  it { should respond_to(:species_id) }
  it { should respond_to(:pet_state_id) }
  it { should respond_to(:primary_breed_id) }
  it { should respond_to(:secondary_breed_id) }
  it { should respond_to(:shelter) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  
  its(:user) { should == user }

  it { should be_valid }
  
  describe "when name is not present" do
    before { @pet.name = " "} 
    it { should_not be_valid }
  end
  
  describe "when description is not present" do
    before { @pet.description = " "} 
    it { should_not be_valid }
  end
  
  describe "when user_id is not present" do
    before { @pet.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "when animal_code is not present" do
    before { @pet.animal_code = nil }
    it { should_not be_valid }
  end

  describe "when size_id is not present" do
    before { @pet.size_id = nil }
    it { should_not be_valid }
  end

  describe "when age is not present" do
    before { @pet.age = nil }
    it { should_not be_valid }
  end

  describe "when age_period_id is not present" do
    before { @pet.age_period_id = nil }
    it { should_not be_valid }
  end
  
  describe "when primary_breed_id is not present" do
    before { @pet.primary_breed_id = nil }
    it { should_not be_valid }
  end

  describe "when affection_id is not present" do
    before { @pet.affection_id = nil }
    it { should_not be_valid }
  end
  
  describe "when energy_level_id is not present" do
    before { @pet.energy_level_id = nil }
    it { should_not be_valid }
  end
  
  describe "when nature_id is not present" do
    before { @pet.nature_id = nil }
    it { should_not be_valid }
  end

  describe "when fur_length_id is not present" do
    before { @pet.fur_length_id = nil }
    it { should_not be_valid }
  end
  
  describe "when primary_color_id is not present" do
    before { @pet.primary_color_id = nil }
    it { should_not be_valid }
  end

  describe "when gender_id is not present" do
    before { @pet.gender_id = nil }
    it { should_not be_valid }
  end

  describe "when species_id is not present" do
    before { @pet.species_id = nil }
    it { should_not be_valid }
  end

  describe "when pet_state_id is not present" do
    before { @pet.pet_state_id = nil }
    it { should_not be_valid }
  end

  describe "when shelter is not present" do
    before { @pet.shelter = nil }
    it { should_not be_valid }
  end
            
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  describe "watched" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      user.save
      user.watch!(@pet)
    end
    
    its(:watchers) { should include(user) }
  end
  
  describe "micropost associations" do
    
    before { @pet.save }
    let(:user) { FactoryGirl.create(:user) }
    let!(:older_micropost) do 
      FactoryGirl.create(:micropost, user: user, pet_id: @pet.id, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: user, pet_id: @pet.id, created_at: 1.hour.ago)
    end
    
    it "should have the right microposts in the right order" do
      @pet.microposts.should == [newer_micropost, older_micropost]
    end
    
    it "should destroy associated microposts" do
      microposts = @pet.microposts
      @pet.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end
  end
end
