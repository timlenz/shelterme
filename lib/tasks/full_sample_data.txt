namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_shelters
    make_users
    make_relationships
    make_pets
    make_microposts
    make_bonds
    make_favorites
  end
end

def make_shelters
  50.times do |n|
    name = Faker::Company.name
    description = Faker::Lorem.paragraph(8)
    email = Faker::Internet.email
    phone = Faker::PhoneNumber.phone_number
    precedence = rand(1..4)
    street = Faker::Address.street_address
    city = Faker::Address.city
    state = Faker::Address.state_abbr
    zipcode = Faker::Address.zip_code
    day_list = []
    7.times do |n|
      open_time = Random.rand(1..12)
      close_time = Random.rand(1..12)
      open_time == close_time ? day_list[n] = "closed" : day_list[n] = open_time.to_s + " - " + close_time.to_s
    end
    Shelter.create!(name: name,
                    description: description,
                    email: email,
                    phone: phone,
                    precedence_id: precedence,
                    street: street,
                    city: city, 
                    state: state,
                    zipcode: zipcode,
                    sun_hours: day_list[0],
                    mon_hours: day_list[1],
                    tue_hours: day_list[2],
                    wed_hours: day_list[3],
                    thu_hours: day_list[4],
                    fri_hours: day_list[5],
                    sat_hours: day_list[6])
  end
end

def make_users
  admin = User.create!(name:     "Tim Lenz",
                       email:    "tim@scimantics.com",
                       password: "foobar",
                       password_confirmation: "foobar",)
  admin.toggle!(:admin)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@testing.org"
    password  = "password"
    location = Faker::Address.city + ", " + Faker::Address.state_abbr
    phone = Faker::PhoneNumber.phone_number
    bio = Faker::Lorem.paragraph(8)
    manager_seed = Random.rand(1..10)
    shelter_count = Shelter.all.count
    shelter_seed = Random.rand(1..shelter_count)
    if manager_seed == 1
      manager = true
      shelter = Shelter.all[shelter_seed]
    else
      manager = false
    end
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password,
                 location: location,
                 phone:    phone,
                 bio:      bio,
                 manager:  manager,
                 shelter_id:  shelter)
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..30]
  followers      = users[5..25]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

def make_pets
  users = User.all
  s_count = Shelter.all.count
  users.each do |user|
    Random.rand(5..14).times do
      name = Faker::Name.first_name
      description = Faker::Lorem.paragraph(8)
      animal_code = "A#{1_000_000 + Random.rand(10_000_000 - 1_000_000)}"
      weight = Random.rand(5..125)
      age = Random.rand(1..20)
      age_length = Random.rand(1..4)
      affection = Random.rand(1..3)
      energy_level = Random.rand(1..3)
      nature = Random.rand(1..3)
      fur_length = Random.rand(1..3)
      primary_color = Random.rand(1..8)
      unless primary_color == 8
        sc_seed = Random.rand(1..7)
        unless sc_seed == primary_color
          secondary_color = sc_seed
        end
      end
      size = Random.rand(1..3)
      gender = Random.rand(1..2)
      species = Random.rand(1..2)
      breeds = Breed.all.count
      dogs = Breed.all.select{|d| d.species_id == 2}.count
      cats = Breed.all.count - dogs
      if species == 1
        primary_breed = Random.rand(dogs+1..breeds)
        secondary_breed = Random.rand(dogs+1..breeds)
        if secondary_breed == primary_breed
          secondary_breed = ""
        end
      else
        primary_breed = Random.rand(1..dogs)
        secondary_breed = Random.rand(1..dogs)
        if secondary_breed == primary_breed
          secondary_breed = ""
        end
      end
      state = Random.rand(1..3)
      shelter = Random.rand(1..s_count)
      user.pets.create!(name: name, description: description, animal_code: animal_code,
                        weight: weight, size_id: size, gender_id: gender, species_id: species,
                        pet_state_id: state, shelter_id: shelter, age: age, age_period_id: age_length,
                        affection_id: affection, energy_level_id: energy_level, nature_id: nature,
                        primary_color_id: primary_color, secondary_color_id: secondary_color,
                        fur_length_id: fur_length, primary_breed_id: primary_breed,
                        secondary_breed_id: secondary_breed)
    end
  end
end

def make_microposts
  users = User.all(limit: 40)
  pets = Pet.count
  20.times do
    users.each { |user| user.microposts.create!(content: Faker::Lorem.sentence(12), pet_id: Random.rand(1..pets)) }
  end
end

def make_bonds
  users = User.all
  pets = Pet.all
  petCount = pets.count
  users.each do |user|
    wp = Random.rand(1..10)
    target = Random.rand(petCount - wp)
    wp.times do |n|
      watched_pet = pets[target + n]
      user.watch!(watched_pet)
    end
  end
end

def make_favorites
  users = User.all
  shelters = Shelter.all
  shelterCount = shelters.count
  users.each do |user|
    wp = Random.rand(1..3)
    target = Random.rand(shelterCount - wp)
    wp.times do |n|
      boosted_shelter = shelters[target + n]
      user.boost!(boosted_shelter)
    end
  end
end