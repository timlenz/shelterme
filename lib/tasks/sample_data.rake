namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_pets
    make_microposts
    make_bonds
  end
end

def make_users
  25.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@testing.org"
    password  = "password"
    location = Faker::Address.city + ", " + Faker::Address.state_abbr
    phone = Faker::PhoneNumber.phone_number
    bio = Faker::Lorem.paragraph(8)
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password,
                 location: location,
                 phone:    phone,
                 bio:      bio)
  end
end

def make_pets
  shelters = Shelter.all
  users = User.all
  u_count = users.count
  shelters.each do |shelter|
    Random.rand(20..50).times do
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
      if species == 2
        primary_color = Random.rand(1..6)
        sc_seed = Random.rand(1..6)
        unless sc_seed == primary_color
          secondary_color = sc_seed
        end
      else
        primary_color = Random.rand(1..4)
        sc_seed = Random.rand(1..4)
        unless sc_seed == primary_color
          secondary_color = sc_seed
        end
      end
      state = Random.rand(1..4)
      user = Random.rand(1..u_count)
      shelter.pets.create!(name: name, description: description, animal_code: animal_code,
                        weight: weight, size_id: size, gender_id: gender, species_id: species,
                        pet_state_id: state, user_id: user, age: age, age_period_id: age_length,
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
    users.each { |user| user.microposts.create!(content: Faker::Lorem.sentence(18), pet_id: Random.rand(1..pets)) }
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