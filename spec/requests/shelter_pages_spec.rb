require 'spec_helper'

describe "Shelter pages" do
  
  subject { page }
  
  describe "profile page" do
    let(:shelter) { FactoryGirl.create(:shelter) }
    before { visit shelter_path(shelter) }
    
    it { should have_header(shelter.name) }
    it { should have_title(shelter.name) }
    it { should have_selector('div.shelterBlurb') }    
    it { should have_selector('div.hours') }
    it { should have_selector('div.address') } # includes phone & email, too
    it { should have_selector('div#dogs') }
    it { should have_selector('div#cats') }
    it { should have_selector('div#adopted') }
  

  end
  
  describe "index" do
    
    FactoryGirl.create(:shelter)
    
   # before visit shelters_path # ROUTING ERROR HERE, BUT NOT REALLY (route works live, just not in test)

    it { should have_title('All Shelters') }
    

  end
end