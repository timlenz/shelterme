require 'spec_helper'

describe "Pet pages" do
  
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }
  
  describe "profile page" do
    let(:pet) { FactoryGirl.create(:pet) }
    before { visit pet_path(pet) }
    
    it { should have_header(pet.name) }
    it { should have_title(pet.name) }
    it { should have_selector('p', text: pet.description) }
  end
  
  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:pet, name: "Max",description: "Cool guy")
      FactoryGirl.create(:pet, name: "Molly",description: "Cool guy")
      visit pets_path
    end
    
    it "should list each pet" do
      Pet.all.each do |pet|
        page.should have_selector('li', text: pet.name)
      end
    end
  end
end