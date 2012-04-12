require 'spec_helper'

describe "Shelter pages" do
  
  subject { page }
  
  describe "profile page" do
    let(:shelter) { FactoryGirl.create(:shelter) }
    before { visit shelter_path(shelter) }
    
    it { should have_header(shelter.name) }
    it { should have_title(shelter.name) }
    it { should have_selector('div.description') }    
    it { should have_selector('div.hours') }
    it { should have_selector('div.address') } # includes phone & email, too
    it { should have_selector('div#myCarousel') }
    it { should have_selector('div#available') }
    it { should have_selector('div#adopted') }
  end
  
  describe "following a shelter" do
    
  end
  
  describe "if admin" do
    
    describe "click edit" do
      
    end
    
  end
end