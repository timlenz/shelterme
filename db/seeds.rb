# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
# require 'open-uri'
# open("http://www.scimantics.com/shelterme/cat_breeds.txt") do |var|
# var.read.each_line do |var2|
# Breed.create!(name: var, species_id: 1)

[Precedence, Affection, AgePeriod, Breed, EnergyLevel,
  FurColor, FurLength, Gender, Nature, PetState, 
  Size, Species, OpenValue, PlanValue, SocialValue,
  AttitudeValue, EmotionValue, CleanValue,
  EnergyValue].each(& :delete_all)

["newest", "oldest", "popular", "unpopular"].each do |elem|
  Precedence.create!(rank: elem)
end

["devoted", "friendly", "reserved"].each do |var|
  Affection.create!(name: var)
end

["day", "week", "month", "year"].each do |var|
  AgePeriod.create!(length: var)
end

["Affenpinscher", "Afghan Hound", "Airedale Terrier", "Akita", "Alaskan Malamute", 
  "American English Coonhound", "American Eskimo Dog", "American Foxhound", 
  "American Staffordshire Terrier", "American Water Spaniel", "Anatolian Shepherd Dog", 
  "Australian Cattle Dog", "Australian Shepherd", "Australian Terrier", "Basenji", 
  "Basset Hound", "Beagle", "Bearded Collie", "Beauceron", "Bedlington Terrier", 
  "Belgian Malinois", "Belgian Sheepdog", "Belgian Tervuren", "Bernese Mountain Dog", 
  "Bichon Frise", "Black and Tan Coonhound", "Black Russian Terrier", "Bloodhound", 
  "Bluetick Coonhound", "Border Collie", "Border Terrier", "Borzoi", "Boston Terrier", 
  "Bouvier des Flandres", "Boxer", "Boykin Spaniel", "Briard", "Brittany", "Brussels Griffon", 
  "Bull Terrier", "Bulldog", "Bullmastiff", "Cairn Terrier", "Canaan Dog", "Cane Corso", 
  "Cardigan Welsh Corgi", "Cavalier King Charles Spaniel", "Cesky Terrier", 
  "Chesapeake Bay Retriever", "Chihuahua", "Chinese Crested", "Chinese Shar-Pei", "Chow Chow", 
  "Clumber Spaniel", "Cocker Spaniel", "Collie", "Curly-Coated Retriever", "Dachshund", 
  "Dalmatian", "Dandie Dinmont Terrier", "Doberman Pinscher", "Dogue de Bordeaux", 
  "English Cocker Spaniel", "English Foxhound", "English Setter", "English Springer Spaniel", 
  "English Toy Spaniel", "Entlebucher Mountain Dog", "Field Spaniel", "Finnish Lapphund", 
  "Finnish Spitz", "Flat-Coated Retriever", "French Bulldog", "German Pinscher", 
  "German Shepherd Dog", "German Shorthaired Pointer", "German Wirehaired Pointer", 
  "Giant Schnauzer", "Glen of Imaal Terrier", "Golden Retriever", "Gordon Setter", "Great Dane", 
  "Great Pyrenees", "Greater Swiss Mountain Dog", "Greyhound", "Harrier", "Havanese", "Ibizan Hound", 
  "Icelandic Sheepdog", "Irish Red and White Setter", "Irish Setter", "Irish Terrier", 
  "Irish Water Spaniel", "Irish Wolfhound", "Italian Greyhound", "Japanese Chin", "Keeshond", 
  "Kerry Blue Terrier", "Komondor", "Kuvasz", "Labrador Retriever", "Lakeland Terrier", "Leonberger", 
  "Lhasa Apso", "Lowchen", "Maltese", "Manchester Terrier", "Mastiff", "Miniature Bull Terrier", 
  "Miniature Pinscher", "Miniature Schnauzer", "Mix", "Neapolitan Mastiff", "Newfoundland", "Norfolk Terrier", 
  "Norwegian Buhund", "Norwegian Elkhound", "Norwegian Lundehund", "Norwich Terrier", 
  "Nova Scotia Duck Tolling Retriever", "Old English Sheepdog", "Otterhound", "Papillon", 
  "Parson Russell Terrier", "Pekingese", "Pembroke Welsh Corgi", "Petit Basset Griffon Vendeen", 
  "Pharaoh Hound", "Plott", "Pointer", "Polish Lowland Sheepdog", "Pomeranian", "Poodle", 
  "Portuguese Water Dog", "Pug", "Puli", "Pyrenean Shepherd", "Redbone Coonhound", "Rhodesian Ridgeback", 
  "Rottweiler", "Saint Bernard", "Saluki", "Samoyed", "Schipperke", "Scottish Deerhound", 
  "Scottish Terrier", "Sealyham Terrier", "Shetland Sheepdog", "Shiba Inu", "Shih Tzu", "Siberian Husky", 
  "Silky Terrier", "Skye Terrier", "Smooth Fox Terrier", "Soft Coated Wheaten Terrier", 
  "Spinone Italiano", "Staffordshire Bull Terrier", "Standard Schnauzer", "Sussex Spaniel", 
  "Swedish Vallhund", "Tibetan Mastiff", "Tibetan Spaniel", "Tibetan Terrier", "Toy Fox Terrier", 
  "Treeing Walker Coonhound", "Vizsla", "Weimaraner", "Welsh Springer Spaniel", "Welsh Terrier", 
  "West Highland White Terrier", "Whippet", "Wire Fox Terrier", "Wirehaired Pointing Griffon", 
  "Xoloitzcuintli", "Yorkshire Terrier"].each do |var| 
  Breed.create!(name: var, species_id: 2)
end

["Abyssinian", "American Bobtail", "American Curl", "American Shorthair", "American Wirehair", 
  "Angora", "Balinese", "Bengal", "Birman", "Bombay", "British Blue", "British Shorthair", 
  "Burmese", "Chartreux", "Chinese Domestic", "Colorpoint Shorthair", "Cornish Rex", "Cymric", 
  "Devon Rex", "Domestic Longhair", "Domestic Medium Hair", "Domestic Shorthair", "Egyptian Mau", 
  "European Burmese", "Exotic", "Havana Brown", "Japanese Bobtail", "Javanese", "Korat", "LaPerm", 
  "Maine Coon", "Manx", "Mix", "Norwegian Forest Cat", "Ocicat", "Oriental", "Persian", "RagaMuffin", 
  "Ragdoll", "Russian Blue", "Scottish Fold", "Selkirk Rex", "Siamese", "Siberian", "Singapura", 
  "Snowshoe", "Somali", "Sphynx", "Tonkinese", "Turkish Angora", "Turkish Van"].each do |var| 
  Breed.create!(name: var, species_id: 1)
end

["relaxed", "balanced", "tireless"].each do |var|
  EnergyLevel.create!(level: var)
end

["white", "black", "brown", "gray", "red", "yellow", "tri-color"].each do |var|
  FurColor.create!(color: var)
end

["short", "medium", "long"].each do |var|
  FurLength.create!(length: var)
end

["male", "female"].each do |var|
  Gender.create!(sex: var)
end

["submissive", "playful", "dominant"].each do |var|
  Nature.create!(name: var)
end

["available", "adopted", "unavailable"].each do |var|
  PetState.create!(status: var)
end

["small", "medium", "large"].each do |var|
  Size.create!(name: var)
end

["cat", "dog"].each do |var|
  Species.create!(name: var)
end

["curious", "cautious"].each do |var|
  OpenValue.create!(name: var)
end

["spontaneous", "disciplined"].each do |var|
  PlanValue.create!(name: var)
end

["quiet", "enthusiastic"].each do |var|
  SocialValue.create!(name: var)
end

["skeptical", "considerate"].each do |var|
  AttitudeValue.create!(name: var)
end

["calm", "anxious"].each do |var|
  EmotionValue.create!(name: var)
end

["orderly", "cluttered"].each do |var|
  CleanValue.create!(name: var)
end

["relaxed", "active"].each do |var|
  EnergyValue.create!(name: var)
end