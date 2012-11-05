require 'spec_helper'

describe "Pet pages" do
  
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "profile page" do
    let(:pet) { FactoryGirl.create(:pet) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, pet: pet, content: "Foo")}
    let!(:m2) { FactoryGirl.create(:micropost, user: user, pet: pet, content: "Bar")}
    before { visit pet_path(pet) }
    
    it { should have_header(pet.name) }
    it { should have_title(pet.name) }
    it { should have_selector('p', text: pet.description) }
    
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
    end
    
    describe "follow/unfollow buttons" do
      let(:pet) { FactoryGirl.create(:pet) }
      
      describe "following/watching a pet" do
        before { visit pet_path(pet) }
        
        it "should increment the watched pet count" do
          expect do
            click_button "Follow Me"
          end.to change(user.watched_pets, :count).by(1)
        end
        
        it "should increment the pet's watchers count" do
          expect do
            click_button "Follow Me"
          end.to change(pet.watchers, :count).by(1)
        end
        
        describe "toggling the button" do
          before { click_button "Follow Me" }
          it { should have_selector('input', value: 'Unfollow Me') }
        end
      end
      
      describe "unfollowing/unwatching a pet" do
        before do
          user.watch!(pet)
          visit pet_path(pet)
        end
        
        it "should decrement the watched pet count" do
          expect do
            click_button "Unfollow Me"
          end.to change(user.watched_pets, :count).by(-1)
        end
        
        it "should decrement the pet's watchers count" do
          expect do
            click_button "Unfollow Me"
          end.to change(pet.watchers, :count).by(-1)
        end
        
        describe "toggling the button" do
          before { click_button "Unfollow Me" }
          it { should have_selector('input', value: 'Follow Me') }
        end
      end
    end
  end
  
  describe "index" do
    
    before do
      sign_in FactoryGirl.create(:admin)
      FactoryGirl.create(:pet, name: "Max",description: "Cool guy", user_id: :user, animal_code: "A1234567")
      visit pets_path
    end
    
    it "should list each pet" do
      Pet.all.each do |pet|
        page.should have_selector('li', text: pet.name)
      end
    end
  end
end