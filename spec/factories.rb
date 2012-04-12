FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Filler text"
    user
  end
  
  factory :shelter do
    name        "Example Shelter"
    description "This is a very cool place."
    email       "shelter@example.com"
    phone       "555-345-6789"
  end
end