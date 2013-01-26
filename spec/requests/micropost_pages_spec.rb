require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:pet) { FactoryGirl.create(:pet) }
  
  before { sign_in user }

  describe "micropost creation" do
    before { visit pet_path(pet) }

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Submit" }.should change(Micropost, :count).by(1)
      end
    end
  end
  
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user, pet: pet) }
    
    describe "as correct user" do
      before { visit pet_path(pet) }  # was user_path(user)
      
      it "should delete a micropost" do
        expect { click_link "Delete" }.should change(Micropost, :count).by(-1)
      end
    end
  end
end