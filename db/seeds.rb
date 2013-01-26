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

User.create!(name:     "Ady Gil",
             email:    "ady@ady.com",
             password: "letsGoHome",
             password_confirmation: "letsGoHome",
             location: "Woodland Hills, CA",
             phone:    "",
             bio:      "",
             manager:  "",
             shelter_id:  "")
             
User.create!(name:    "Steven Latham",
            email:    "steven@stevenlathamproductions.com",
            password: "letsGoHome",
            password_confirmation: "letsGoHome",
            location: "Santa Monica, CA",
            phone:    "",
            bio:      "",
            manager:  "",
            shelter_id:  "",
            admin:    true)
             
User.create!(name:    "Tim Lenz",
            email:    "tim@scimantics.com",
            password: "letsGoHome",
            password_confirmation: "letsGoHome",
            location: "Red Hook, NY",
            phone:    "",
            bio:      "",
            manager:  "",
            shelter_id:  "",
            admin:    true)

["newest", "oldest", "popular", "unpopular"].each do |elem|
  Precedence.create!(rank: elem)
end

["devoted", "friendly", "reserved"].each do |var|
  Affection.create!(name: var)
end

["day", "week", "month", "year"].each do |var|
  AgePeriod.create!(length: var)
end

["Affenpinscher", "Afghan Hound", "Airedale Terrier", "Akita", "Alaskan Malamute", "American Cocker Spaniel", "American English Coonhound", "American Eskimo Dog", "American Foxhound", "American Pit Bull Terrier", "American Staffordshire Terrier", "American Water Spaniel", "Anatolian Shepherd", "Australian Cattle Dog", "Australian Shepherd", "Australian Terrier", "Basenji", "Basset Hound", "Beagle", "Bearded Collie", "Beauceron", "Bedlington Terrier", "Belgian Malinois", "Belgian Sheepdog", "Belgian Tervuren", "Bernese Mountain Dog", "Bichon Frise", "Black and Tan Coonhound", "Black Russian Terrier", "Bloodhound", "Bluetick Coonhound", "Border Collie", "Border Terrier", "Borzoi", "Boston Terrier", "Bouvier des Flandres", "Boxer", "Boykin Spaniel", "Briard", "Brittany", "Brussels Griffon", "Bull Terrier", "Bulldog", "Bullmastiff", "Cairn Terrier", "Canaan Dog", "Cane Corso", "Cardigan Welsh Corgi", "Cavalier King Charles Spaniel", "Cesky Terrier", "Chesapeake Bay Retriever", "Chihuahua", "Chinese Crested", "Chinese Shar-Pei", "Chow Chow", "Clumber Spaniel", "Cocker Spaniel", "Collie", "Curly-Coated Retriever", "Dachshund", "Dalmatian", "Dandie Dinmont Terrier", "Doberman Pinscher", "Dogue de Bordeaux", "English Cocker Spaniel", "English Foxhound", "English Setter", "English Springer Spaniel", "English Toy Spaniel", "Entlebucher Mountain Dog", "Field Spaniel", "Finnish Lapphund", "Finnish Spitz", "Flat-Coated Retriever", "French Bulldog", "German Pinscher", "German Shepherd", "German Shorthaired Pointer", "German Wirehaired Pointer", "Giant Schnauzer", "Glen of Imaal Terrier", "Golden Retriever", "Gordon Setter", "Great Dane", "Great Pyrenees", "Greater Swiss Mountain Dog", "Greyhound", "Harrier", "Havanese", "Ibizan Hound", "Icelandic Sheepdog", "Irish Setter", "Irish Terrier", "Irish Water Spaniel", "Irish Wolfhound", "Italian Greyhound", "Japanese Chin", "Keeshond", "Kerry Blue Terrier", "Komondor", "Kuvasz", "Labrador Retriever", "Lakeland Terrier", "Leonberger", "Lhasa Apso", "Lowchen", "Maltese", "Manchester Terrier", "Mastiff", "Miniature American Eskimo Dog", "Miniature Bull Terrier", "Miniature Dachshund", "Miniature Pinscher", "Miniature Poodle", "Miniature Schnauzer", "Mix", "Mutt", "Neapolitan Mastiff", "Newfoundland", "Norfolk Terrier", "Norwegian Buhund", "Norwegian Elkhound", "Norwegian Lundehund", "Norwich Terrier", "Nova Scotia Duck Tolling Retriever", "Old English Sheepdog", "Otterhound", "Papillon", "Parson Russell Terrier", "Pekingese", "Pembroke Welsh Corgi", "Petit Basset Griffon Vendeen", "Pharaoh Hound", "Plott", "Pointer", "Polish Lowland Sheepdog", "Pomeranian", "Portuguese Water Dog", "Pug", "Puli", "Pyrenean Shepherd", "Redbone Coonhound", "Rhodesian Ridgeback", "Rottweiler", "Saint Bernard", "Saluki", "Samoyed", "Schipperke", "Scottish Deerhound", "Scottish Terrier", "Sealyham Terrier", "Shetland Sheepdog", "Shiba Inu", "Shih Tzu", "Siberian Husky", "Silky Terrier", "Skye Terrier", "Smooth Fox Terrier", "Soft Coated Wheaten Terrier", "Spinone Italiano", "Staffordshire Bull Terrier", "Standard Poodle", "Standard Schnauzer", "Sussex Spaniel", "Swedish Vallhund", "Tibetan Mastiff", "Tibetan Spaniel", "Tibetan Terrier", "Toy American Eskimo Dog", "Toy Fox Terrier", "Toy Manchester Terrier", "Toy Poodle", "Treeing Walker Coonhound", "Vizsla", "Weimaraner", "Welsh Springer Spaniel", "Welsh Terrier", "West Highland White Terrier", "Whippet", "Wire Fox Terrier", "Wirehaired Pointing Griffon", "Xoloitzcuintli", "Yorkshire Terrier"].each do |var| 
  Breed.create!(name: var, species_id: 2)
end

["Abyssinian", "American Bobtail", "American Curl", "American Shorthair", "American Wirehair", "Balinese", "Bengal", "Birman", "Bombay", "British Blue", "British Longhair", "British Shorthair", "Burmese", "Burmilla", "Caliby", "Calico", "Calimanco", "Chartreux", "Chausie", "Chinese Domestic", "Colorpoint Shorthair", "Cornish Rex", "Cymric", "Devon Rex", "Domestic", "Donskoy", "Egyptian Mau", "European Burmese", "Exotic Shorthair", "Havana", "Highlander", "Highlander Shorthair", "Himalayan", "Household Pet", "Japanese Bobtail", "Javanese", "Khaomanee", "Korat", "Kurilian Bobtail", "LaPerm", "Maine Coon", "Maltese", "Manx", "Minskin", "Mix", "Munchkin", "Napoleon", "Nebelung", "Norwegian Forest", "Ocicat", "Ojos Azules", "Oriental Longhair", "Oriental Shorthair", "Persian", "Peterbald", "Pixiebob", "RagaMuffin", "Ragdoll", "Russian Blue", "Savannah", "Scottish Fold", "Selkirk Rex", "Serengeti", "Siamese", "Siberian", "Singapura", "Snowshoe", "Sokoke", "Somali", "Sphynx", "Tabby", "Thai", "Tonkinese", "Torbie", "Tortie", "Tortoiseshell", "Toyger", "Turkish Angora", "Turkish Van"].each do |var| 
  Breed.create!(name: var, species_id: 1)
end

["relaxed", "balanced", "tireless"].each do |var|
  EnergyLevel.create!(level: var)
end

["white", "black", "brown", "gray", "red", "yellow", "orange", "tri-color"].each do |var|
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

["cynical", "considerate"].each do |var|
  AttitudeValue.create!(name: var)
end

["calm", "impatient"].each do |var|
  EmotionValue.create!(name: var)
end

["orderly", "cluttered"].each do |var|
  CleanValue.create!(name: var)
end

["relaxed", "active"].each do |var|
  EnergyValue.create!(name: var)
end

Shelter.create!(name: "East Valley Care & Control",
                description: "Serving Arleta, Mission Hills, North Hollywood, Pacoima, Panorama City, Sherman Oaks, Studio City, Sun Valley, Sunland-Tujunga, Sylmar, Toluca Lake, Valley Glen, Valley Village, Van Nuys.  Outside the city limits, serving communities such as Burbank, Glendale and San Fernando. Spay/Neuter Clinic on site. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "14409 Vanowen St",
                city: "Van Nuys", 
                state: "CA",
                zipcode: "91405",
                sun_hours: "11am-5pm",
                mon_hours: "Closed",
                tue_hours: "8am-5pm",
                wed_hours: "8am-5pm",
                thu_hours: "8am-5pm",
                fri_hours: "8am-5pm",
                sat_hours: "8am-5pm",
                slug: "EastValley")
                
Shelter.create!(name: "South LA Care & Control",
                description: "Serving Arlington Heights, Arlington Park, Athens, Baldwin Hills, Baldwin Village, Canterbury Knolls, Carthay, Country Club Heights, Crenshaw, Exposition Park, Gramercy Park, Hyde Park, Lafayette Square, Jefferson Park, Koreatown, Leimert Park, Mid-City, Miracle Mile, Pan Pacific Park, Pico-Union, South Los Angeles, University Park, Vermont Knolls, Village Green, West Adams, West Alameda. Outside the city limits, serving communities such as Baldwin Vista, Inglewood, Ladera Heights, View Heights and View Park. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "3612 11th Avenue",
                city: "Los Angeles", 
                state: "CA",
                zipcode: "90018",
                sun_hours: "11am-5pm",
                mon_hours: "Closed",
                tue_hours: "8am-5pm",
                wed_hours: "8am-5pm",
                thu_hours: "8am-5pm",
                fri_hours: "8am-5pm",
                sat_hours: "8am-5pm",
                slug: "SouthLA")

Shelter.create!(name: "North Central Care & Control",
                description: "Serving Angelino Heights, Arts District, Atwater Village, Beachwood Canyon, Boyle Heights, Chinatown, Cypress Park, Downtown Los Angeles, Eagle Rock, East Hollywood, Echo Park, El Sereno, Elysian Heights, Elysian Park, Elysian Valley, Franklin Hills, Garvanza, Glassell Park, Griffith Park, Hancock Park, Hermon, Highland Park, Historic Filipino Town, Hollywood, Hollywood Heights, Larchmont, Lincoln Heights, Little Tokyo, Los Feliz, MacArthur Park-Westlake, Melrose Hill, Montecito Heights, Monterey Hills, Mt. Washington, Silver Lake, Solano Canyon, Temple-Beaudry, University Hills, Virgil Village, Wilshire Center, Windsor Square. Outside the city limits, serving communities such as Alhambra, East Los Angeles, Glendale, and Pasadena. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "3201 Lacy Street",
                city: "Los Angeles", 
                state: "CA",
                zipcode: "90031",
                sun_hours: "11am-5pm",
                mon_hours: "Closed",
                tue_hours: "8am-5pm",
                wed_hours: "8am-5pm",
                thu_hours: "8am-5pm",
                fri_hours: "8am-5pm",
                sat_hours: "8am-5pm",
                slug: "NorthCentral")

Shelter.create!(name: "West Los Angeles Care & Control",
                description: "Serving Bel Air, Benedict Canyon, Beverlywood, Beverly Crest, Beverly Hills, Brentwood, Century City, Cheviot Hills, Del Rey, Fairfax, Holmby Hills, Kenter Canyon, Laurel Canyon, Mandeville Canyon, Marina Peninsula, Mar Vista, Melrose District, Pacific Palisades, Palisades Highlands, Palms, Rancho Park, Rustic Canyon, Venice, Westchester, Westdale, Westside Village, West Pico. Outside the city limits, serving communities such as Culver City, Santa Monica and West Hollywood. Spay/Neuter Clinic on site. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "11361 West Pico Blvd",
                city: "Los Angeles", 
                state: "CA",
                zipcode: "90064",
                sun_hours: "11am-5pm",
                mon_hours: "Closed",
                tue_hours: "8am-5pm",
                wed_hours: "8am-5pm",
                thu_hours: "8am-5pm",
                fri_hours: "8am-5pm",
                sat_hours: "8am-5pm",
                slug: "WestLosAngeles")

Shelter.create!(name: "Harbor Care & Control",
                description: "Serving Harbor City, San Pedro, Watts (partial), Willowbrook, Wilmington. Outside the city limits, serving communities such as Carson, Compton, Gardena, Long Beach, Palos Verdes, Redondo Beach, Signal Hill, Torrance and Watts (partial). Spay/Neuter clinic on site. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "957 N. Gaffey Street",
                city: "San Pedro", 
                state: "CA",
                zipcode: "90731",
                sun_hours: "11am-5pm",
                mon_hours: "Closed",
                tue_hours: "8am-5pm",
                wed_hours: "8am-5pm",
                thu_hours: "8am-5pm",
                fri_hours: "8am-5pm",
                sat_hours: "8am-5pm",
                slug: "Harbor")

Shelter.create!(name: "West Valley Care & Control",
                description: "Serving Bell Canyon, Canoga Park, Chatsworth, Encino, Granada Hills, Lake Balboa, Northridge, North Hills, Porter Ranch, Reseda, Sepulveda, Tarzana, Warner Center, West Hills, Winnetka, Woodland Hills. Outside the city limits, serving communities such as Agoura, Malibu, Santa Clarita, Valencia and Westlake Village. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "20655 Plummer Street",
                city: "Chatsworth", 
                state: "CA",
                zipcode: "91311",
                sun_hours: "11am-5pm",
                mon_hours: "Closed",
                tue_hours: "8am-5pm",
                wed_hours: "8am-5pm",
                thu_hours: "8am-5pm",
                fri_hours: "8am-5pm",
                sat_hours: "8am-5pm",
                slug: "WestValley")

Shelter.create!(name: "Agoura Animal Care Center",
                description: "Proudly serving the cities/areas of: Agoura, Agoura Hills, Calabasas, Canoga Park, Chatsworth, Fernwood, Hidden Hills, Malibu, Thousand Oaks, Topanga Canyon, Westlake Village, Woodland Hills. Closed Holidays.",
                email: "",
                phone: "(818) 991-0071",
                precedence_id: 2,
                street: "29525 Agoura Rd.",
                city: "Agoura", 
                state: "CA",
                zipcode: "91301",
                sun_hours: "10:00 AM – 5:00 PM",
                mon_hours: "12:00 PM – 7:00 PM",
                tue_hours: "12:00 PM – 7:00 PM",
                wed_hours: "12:00 PM – 7:00 PM",
                thu_hours: "12:00 PM – 7:00 PM",
                fri_hours: "10:00 AM – 5:00 PM",
                sat_hours: "10:00 AM – 5:00 PM",
                slug: "Agoura")

Shelter.create!(name: "Baldwin Park Animal Care Center",
                description: "Proudly serving the cities/areas of: Altadena, Arcadia, Azusa, Baldwin Park, Bassett, Bradbury, Brea, Charter Oak, Claremont, Covina, Diamond Bar, Duarte, El Monte, Glendora, Hacienda Heights, Industry, Irwindale, La Crescenta, La Puente, La Verne, Monrovia, Montrose, Mt. Baldy, Pasadena, Rosemead, Rowland Heights, San Dimas, San Gabriel, South El Monte, South San Gabriel, Temple City, Valinda, Walnut, West Covina. Closed Holidays.",
                email: "",
                phone: "(626) 962-3577",
                precedence_id: 2,
                street: "4275 N. Elton",
                city: "Baldwin Park", 
                state: "CA",
                zipcode: "91706",
                sun_hours: "10:00 AM – 5:00 PM",
                mon_hours: "12:00 PM – 7:00 PM",
                tue_hours: "12:00 PM – 7:00 PM",
                wed_hours: "12:00 PM – 7:00 PM",
                thu_hours: "12:00 PM – 7:00 PM",
                fri_hours: "10:00 AM – 5:00 PM",
                sat_hours: "10:00 AM – 5:00 PM",
                slug: "BaldwinPark")

Shelter.create!(name: "Carson Animal Care Center",
                description: "Proudly serving the cities/areas of: Carson, Culver City, El Camino Village, Gardena, Harbor City, Inglewood, Ladera Heights, Lawndale, Lennox, Lomita, Los Angeles 90008, Los Angeles 90043, Los Angeles 90044, Los Angeles 90047, Los Angeles 90056, Los Angeles 90061, Marina Del Rey, Palos Verdes, Palos Verdes Estates, Rancho Palos Verdes, Rolling Hills, Rolling Hills Estates, San Pedro, Torrance, Universal Studios, West Hollywood. Closed Holidays.",
                email: "",
                phone: "(310) 523-9566",
                precedence_id: 2,
                street: "216 W. Victoria St.",
                city: "Gardena", 
                state: "CA",
                zipcode: "90248",
                sun_hours: "10:00 AM – 5:00 PM",
                mon_hours: "12:00 PM – 7:00 PM",
                tue_hours: "12:00 PM – 7:00 PM",
                wed_hours: "12:00 PM – 7:00 PM",
                thu_hours: "12:00 PM – 7:00 PM",
                fri_hours: "10:00 AM – 5:00 PM",
                sat_hours: "10:00 AM – 5:00 PM",
                slug: "Carson")

Shelter.create!(name: "Castaic Animal Care Center",
                description: "Proudly serving the cities/areas of: Acton, Agua Dulce, Bouquet Canyon, Canyon Country, Castaic, Gorman, Green Valley, Kagel Canyon, Lang, Newhall, San Fernando, Santa Clarita, Saugus, Stevenson Ranch, Tujunga, Valencia. Closed Holidays. Alternate phone (818) 367-8065.",
                email: "",
                phone: "(661) 257-3191",
                precedence_id: 2,
                street: "31044 N. Charlie Canyon Rd.",
                city: "Castaic", 
                state: "CA",
                zipcode: "91384",
                sun_hours: "10:00 AM – 5:00 PM",
                mon_hours: "12:00 PM – 7:00 PM",
                tue_hours: "12:00 PM – 7:00 PM",
                wed_hours: "12:00 PM – 7:00 PM",
                thu_hours: "12:00 PM – 7:00 PM",
                fri_hours: "10:00 AM – 5:00 PM",
                sat_hours: "10:00 AM – 5:00 PM",
                slug: "Castaic")

Shelter.create!(name: "Downey Animal Care Center",
                description: "Proudly serving the cities/areas of: Alhambra, Artesia, Bell, Cerritos, City Terrace, Compton, Cudahy, East Los Angeles 90022, East Los Angeles 90023, East Los Angeles 90063, Florence/Firestone, Hawaiian Gardens, La Habra Heights, La Habra Heights, La Mirada, Los Angeles 90001, Los Angeles 90002, Los Angeles 90032, Lynwood, Maywood, Walnut Park, Whittier. Closed Holidays.",
                email: "",
                phone: "(562) 940-6898",
                precedence_id: 2,
                street: "11258 S. Garfield Ave.",
                city: "Downey", 
                state: "CA",
                zipcode: "90242",
                sun_hours: "10:00 AM – 5:00 PM",
                mon_hours: "12:00 PM – 7:00 PM",
                tue_hours: "12:00 PM – 7:00 PM",
                wed_hours: "12:00 PM – 7:00 PM",
                thu_hours: "12:00 PM – 7:00 PM",
                fri_hours: "10:00 AM – 5:00 PM",
                sat_hours: "10:00 AM – 5:00 PM",
                slug: "Downey")

Shelter.create!(name: "Lancaster Animal Care Center",
                description: "Proudly serving the cities/areas of: Lake Elizabeth, Lake Hughes, Lake Los Angeles, Lancaster, Leona Valley, Llano, Palmdale, Pearblossom, Quartz Hill, Valyermo. Closed Holidays.",
                email: "",
                phone: "(661) 940-4191",
                precedence_id: 2,
                street: "210 W. Ave. I",
                city: "Lancaster", 
                state: "CA",
                zipcode: "93536",
                sun_hours: "10:00 AM – 5:00 PM",
                mon_hours: "12:00 PM – 7:00 PM",
                tue_hours: "12:00 PM – 7:00 PM",
                wed_hours: "12:00 PM – 7:00 PM",
                thu_hours: "12:00 PM – 7:00 PM",
                fri_hours: "10:00 AM – 5:00 PM",
                sat_hours: "10:00 AM – 5:00 PM",
                slug: "Lancaster")

Shelter.create!(name: "Antelope Valley Adoption Center",
                description: "Please note: While this facility houses ready to adopt shelter dogs, it is not a shelter. This facility does not take in/impound stray or owned pets, nor does it dispatch requests for service. Only dogs available for adoption are housed here. The phone is only answered during business hours. Closed Holidays.",
                email: "",
                phone: "(661) 974-8309",
                precedence_id: 2,
                street: "42116 4th St. East",
                city: "Lancaster", 
                state: "CA",
                zipcode: "93535",
                sun_hours: "12:00 PM to 4:00 PM",
                mon_hours: "Closed",
                tue_hours: "10:00 AM to 5:00 PM",
                wed_hours: "10:00 AM to 5:00 PM",
                thu_hours: "10:00 AM to 5:00 PM",
                fri_hours: "10:00 AM to 5:00 PM",
                sat_hours: "10:00 AM to 5:00 PM",
                slug: "AntelopeValley")