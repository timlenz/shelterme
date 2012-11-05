require 'spec_helper'

describe BondsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:pet) { FactoryGirl.create(:pet) }

  before { sign_in user }

  describe "creating a bond with Ajax" do

    it "should increment the Bond count" do
      expect do
        xhr :post, :create, bond: { pet_id: pet.id }
      end.should change(Bond, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, bond: { pet_id: pet.id }
      response.should be_success
    end
  end

  describe "destroying a bond with Ajax" do

    before { user.watch!(pet) }
    let(:bond) { user.bonds.find_by_pet_id(pet) }

    it "should decrement the Bond count" do
      expect do
        xhr :delete, :destroy, id: bond.id
      end.should change(Bond, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: bond.id
      response.should be_success
    end
  end
end