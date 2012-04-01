FactoryGirl.define do
  factory :user do
    name     "Tim Lenz"
    email    "tim@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end