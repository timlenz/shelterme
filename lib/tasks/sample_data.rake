namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
    make_shelters
    make_pets
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@testing.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..30]
  followers      = users[3..20]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

def make_shelters
  40.times do |n|
    name = Faker::Company.name
    description = Faker::Lorem.paragraph(8)
    email = Faker::Internet.email
    phone = Faker::PhoneNumber.phone_number
    Shelter.create!(name: name,
                    description: description,
                    email: email,
                    phone: phone)
  end
end

def make_pets
  users = User.all(limit: 1)
  100.times do
    name = Faker::Name.first_name
    description = Faker::Lorem.paragraph(7)
    users.each { |user| user.pets.create!(name: name, description: description)}
  end
end