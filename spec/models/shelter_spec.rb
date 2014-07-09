# == Schema Information
#
# Table name: shelters
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  description   :text
#  email         :string(255)
#  phone         :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  precedence_id :integer         default(1)
#  street        :string(255)
#  city          :string(255)
#  state         :string(255)
#  zipcode       :string(255)
#  latitude      :float
#  longitude     :float
#  sun_hours     :string(255)
#  mon_hours     :string(255)
#  tue_hours     :string(255)
#  wed_hours     :string(255)
#  thu_hours     :string(255)
#  fri_hours     :string(255)
#  sat_hours     :string(255)
#  slug          :string(255)
#  access        :boolean         default(FALSE)
#

require 'spec_helper'

describe Shelter do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @shelter = Shelter.new(name: "Example Shelter", description: "This is cool place.",
                                  email: "shelter@example.com", phone: "555-345-6789",
                                  precedence_id: 2) }
  
  subject { @shelter }
  
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:email) }
  it { should respond_to(:phone) }
  it { should respond_to(:precedence_id) }
  it { should respond_to(:favorites) }
  it { should respond_to(:boosters) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @shelter.name = " " }
    it { should_not be_valid }
  end
  
  describe "when description is not present" do
    before { @shelter.description = " " }
    it { should be_valid }
  end
  
  describe "when email is not present" do
    before { @shelter.email = " " }
    it { should_not be_valid }
  end
  
  describe "when phone is not present" do
    before { @shelter.phone = " " }
    it { should_not be_valid }
  end  
  
  describe "when precedence_id is not present" do
    before { @shelter.precedence_id = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @shelter.name = "a" * 51 }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
      addresses.each do |invalid_address|
        @shelter.email = invalid_address
        @shelter.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.com A_USER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @shelter.email = valid_address
        @shelter.should be_valid
      end      
    end
  end
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Favorite.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
  
  describe "boosted" do    
    before do
      user.save
      user.boost!(@shelter)
    end
    
    its(:boosters) { should include(user) }
  end
end
