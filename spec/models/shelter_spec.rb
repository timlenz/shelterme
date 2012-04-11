require 'spec_helper'

describe Shelter do
  
  before { @shelter = Shelter.new(name: "Example Shelter", description: "This is cool place.",
                                  email: "shelter@example.com", phone: "555-345-6789") }
  
  subject { @shelter }
  
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:email) }
  it { should respond_to(:phone) }
  
  it { should be_valid }
  
  describe "when name is not present" do
    before { @shelter.name = " " }
    it { should_not be_valid }
  end
  
  describe "when description is not present" do
    before { @shelter.description = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @shelter.email = " " }
    it { should_not be_valid }
  end
  
  describe "when phone is not present" do
    before { @shelter.phone = " " }
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
end
