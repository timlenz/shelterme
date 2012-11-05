require 'spec_helper'

describe FavoritesController do

  let(:user) { FactoryGirl.create(:user) }
  let(:shelter) { FactoryGirl.create(:shelter) }

  before { sign_in user }

  describe "creating a favorite with Ajax" do

    it "should increment the Favorite count" do
      expect do
        xhr :post, :create, favorite: { shelter_id: shelter.id }
      end.should change(Favorite, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, favorite: { shelter_id: shelter.id }
      response.should be_success
    end
  end

  describe "destroying a favorite with Ajax" do

    before { user.boost!(shelter) }
    let(:favorite) { user.favorites.find_by_shelter_id(shelter) }

    it "should decrement the Favorite count" do
      expect do
        xhr :delete, :destroy, id: favorite.id
      end.should change(Favorite, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: favorite.id
      response.should be_success
    end
  end
end