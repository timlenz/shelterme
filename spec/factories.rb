FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"
    location "Anytown, NY"
    phone "555-345-6789"
    bio "Just this guy, you know?"

    factory :admin do
      admin true
    end
  end
  
  factory :shelter do
    name        "Example Shelter"
    description "This is a very cool place."
    email       "shelter@example.com"
    phone       "555-345-6789"
    precedence_id 1
  end
  
  factory :address do
    street      "123 Main St"
    city        "Anytown"
    state       "NY"
    zipcode     "12345"
  end
  
  factory :pet do
    name "Sample Pet"
    description "Loveable and fun. What a gem."
    animal_code "A1234567"
    user
    size_id 1
    age_id 1
    weight 25
    mix_id 1
    gender_id 1
    species_id 1
    pet_state_id 1
    shelter_id 1
  end
  
  factory :micropost do
    content "Filler text"
    user
    pet_id 1
  end
end