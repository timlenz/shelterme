# This file should contain all the record creation needed-seed the database with its default values.
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
  EnergyValue, User, Shelter].each(& :delete_all)

User.create!(name:     "Ady Gil",
             email:    "ady@ady.com",
             password: "letsGoHome",
             password_confirmation: "letsGoHome",
             location: "Woodland Hills, CA",
             phone:    "",
             bio:      "")
             
User.create!(name:    "Steven Latham",
            email:    "steven@stevenlathamproductions.com",
            password: "letsGoHome",
            password_confirmation: "letsGoHome",
            location: "Santa Monica, CA",
            phone:    "",
            bio:      "",
            admin:    true)
             
User.create!(name:    "Tim Lenz",
            email:    "tim@scimantics.com",
            password: "letsGoHome",
            password_confirmation: "letsGoHome",
            location: "Red Hook, NY",
            phone:    "",
            bio:      "",
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

["Affenpinscher", "Afghan Hound", "Aidi", "Airedale Terrier", "Akbash", "Akita Inu", "Alano Espanol", "Alapaha Blue Blood Bulldog", "Alaskan Klee Kai", "Alaskan Malamalute", "Alpine Dachsbracke", "Amenian Gampr", "American Akita", "American Bulldog", "American Cocker Spaniel", "American English Coonhound", "American Eskimo", "American Foxhound", "American Hairless Terrier", "American Leopard Hound", "American Mastiff", "American Pit Bull Terrier", "American Staffordshire Terrier", "American Water Spaniel", "Anatolian Shepherd", "Anglo-Francais de Petite Venerie", "Appenzeller Sennenhunde", "Ariege Pointer", "Ariegeois", "Armant", "Artois Hound", "Austrain Pinscher", "Australian Cattle", "Australian Kelpie", "Australian Shepherd", "Australian Silky Terrier", "Australian Stumpy Tail Cattle", "Australian Terrier", "Austrian Black and Tan Hound", "Azawakh", "Bakharwal", "Barbet", "Bascon Saintongeois", "Basenji", "Basque Shepherd", "Basset Artesien Normand", "Basset Bleu de Gascogne", "Basset Hound", "Bavarian Mountain Hound", "Beagle", "Beagle-Harrier", "Bearded Collie", "Beauceron", "Bedlington Terrier", "Belgian Groenendael", "Belgian Laekenois", "Belgian Malinois", "Belgian Sheepdog", "Belgian Tervuren", "Bergamasco Shepherd", "Berger Blanc Suisse", "Berger Picard", "Berner Laufhund", "Bernese Mountain", "Bichon Frise", "Billy", "Bisben", "Black and Tan Coonhound", "Black and Tan Virginia Foxhound", "Black Norwegian Elkhound", "Black Russian Terrier", "Blackmouth Cur", "Bloodhound", "Blue Lacy", "Bluetick Coonhound", "Boerboel", "Bohemian Shepherd", "Bolognese", "Border Collie", "Border Terrier", "Borzoi", "Bosnian Coarsehaired", "Boston Terrier", "Bouvier des Ardennes", "Bouvier des Flandres", "Boxer", "Boykin Spaniel", "Bracco Italiano", "Braque d'Auvergne", "Braque du Bourbonnais", "Braque Francais", "Braque Saint-Germain", "Brazilian Terrier", "Briard", "Briquet Griffon Vendeen", "Brittany", "Broholmer", "Bruno Jura Hound", "Brussels Griffon", "Bucovina Shepherd", "Bull and Terrier", "Bull Terrier", "Bulldog", "Bulldog Campeiro", "Bullmastiff", "Bully Kutta", "Cairn Terrier", "Canaan", "Canadian Eskimo", "Cane Corso", "Cardigan Welsh Corgi", "Carolina", "Carpathian Shepherd", "Catahoula Leopard", "Catalan Sheepdog", "Caucasian Ovcharka", "Caucasian Shepherd", "Cavalier King Charles Spaniel", "Central Asian Shepherd", "Cesky Fousek", "Cesky Terrier", "Chesapeake Bay Retriever", "Chien Francais Blanc et Noir", "Chien Francais Blanc et Orange", "Chien Francais Tricolore", "Chien-gris", "Chihuahua", "Chilean Fox Terrier", "Chinese Chongqing", "Chinese Crested", "Chinese Imperial", "Chinese Shar-Pei", "Chinook", "Chippiparai", "Chow Chow", "Cierny Sery", "Cimarron Uruguayo", "Cirneco dell'Etna", "Clumber Spaniel", "Cocker Spaniel", "Collie", "Combia", "Coton de Tulear", "Cretan Hound", "Croatian Sheepdog", "Curly-Coated Retriever", "Cursinu", "Czechoslovakian Vlcak", "Dachshund", "Dalmatian", "Dandie Dinmont Terrier", "Danish-Swedish Farmdog", "Deutsche Bracke", "Deutscher Wachtelhund", "Doberman Pinscher", "Dogo Argentino", "Dogo Guatemalteco", "Dogo Sardesco", "Dogue de Bordeaux", "Drentsche Patrijshond", "Drever", "Dunker", "Dutch Shepherd", "Dutch Smoushond", "East Siberian Laika", "East-European Shepherd", "Elo", "English Bulldog", "English Cocker Spaniel", "English Coonhound", "English Foxhound", "English Mastiff", "English Setter", "English Shepherd", "English Springer Spaniel", "English Toy Spaniel", "English Toy Terrier", "Entlebucher Mountain", "Epagnuel Bleu de Picardie", "Estonian Hound", "Estrela Mountain", "Eurasier", "Field Spaniel", "Fila Brasileiro", "Finnish Hound", "Finnish Lapphund", "Finnish Spitz", "Flat-Coated Retriever", "Formosan Mountain", "French Brittany", "French Bulldog", "French Spaniel", "Galgo Espanol", "Georgian Shepherd", "German Longhaired Pointer", "German Pinscher", "German Shepherd", "German Shorthaired Pointer", "German Spaniel", "German Spitz", "German Wirehaired Pointer", "Giant Schnauzer", "Glen of Imaal Terrier", "Golden Retriever", "Gordon Setter", "Grand Anglo-Francais Blanc et Noir", "Grand Anglo-Francais Blanc et Orange", "Grand Anglo-Francais Blanc et Tricolore", "Grand Basset Griffon Vendeen", "Grand Blue de Gascogne", "Grand Mastin de Borinquen", "Great Dane", "Great Pyrenees", "Greater Swiss Mountain", "Greek Harehound", "Greenland", "Greyhound", "Griffon Bleu de Gascogne", "Griffon Bruxellois", "Griffon Fauve de Bretagne", "Griffon Nivernais", "Gull Dong", "Gull Terr", "Hamiltonstovare", "Hanover Hound", "Harrier", "Havanese", "Himalayan Sheepdog", "Hokkaido", "Hortaya Borzaya", "Hovawart", "Hungarian Hound", "Huntaway", "Hygenhund", "Ibizan Hound", "Icelandic Sheepdog", "Indian Spitz", "Irish Red and White Setter", "Irish Setter", "Irish Terrier", "Irish Water Spaniel", "Irish Wolfhound", "Istrian Coarsehaired", "Istrian Shorthaired", "Italian Greyhound", "Jack Russell Terrier", "Jagdterrier", "Japanese Chin", "Japanese Spitz", "Japanese Terrier", "Jindo", "Jonangi", "Jamthund", "Kai Ken", "Kaikadi", "Kangal", "Kanni", "Karakachan", "Karelian Bear", "Karst Shepherd", "Keeshond", "Kerry Beagle", "Kerry Blue Terrier", "King Charles Spaniel", "King Shepherd", "Kintamani", "Kishu Ken", "Komondor", "Kooikerhondje", "Koolie", "Korean Jindo", "Korean Mastiff", "Kromfohrlander", "Kunming Wolfdog", "Kuvasz", "Kyi-Leo", "Labrador Husky", "Labrador Retriever", "Lagotto Romagnolo", "Lakeland Terrier", "Lancashire Heeler", "Landseer", "Lapponian Herder", "Large Munsterlander", "Leonberger", "Lhasa Apso", "Lithuanian Hound", "Longhaired Whippet", "Lowchen", "Magyar Agar", "Maltese", "Manchester Terrier", "Maremma", "Mastiff", "McNab", "Mexican Hairless", "Miniature American Shepherd", "Miniature Australian Shepherd", "Miniature Bull Terrier", "Miniature Fox Terrier", "Miniature Pinscher", "Miniature Schnauzer", "Mioritic", "Mix", "Montenegrin Mountain Hound", "Moscow Watchdog", "Mountain Cur", "Mountain View Cur", "Mucuchies", "Mudhol Hound", "Mudi", "Murray River Curly Coated Retrevier", "Neapolitan Mastiff", "New Zealand Heading", "Newfoundland", "Norfolk Terrier", "Norrbottenspets", "Northern Inuit", "Norwegian Buhund", "Norwegian Elkhound", "Norwegian Lundehund", "Norwich Terrier", "Nova Scotia Duck Tolling Retriever", "Old Croatian Sighthound", "Old Danish Pointer", "Old English Sheepdog", "Old English Terrier", "Old German Shepherd", "Old Time Farm Shepherd", "Olde English Bulldogge", "Otterhound", "Pachon Navarro", "Papillon", "Parson Russell Terrier", "Patterdale Terrier", "Pekingese", "Pembroke Welsh Corgi", "Perro de Presa Canario", "Perro de Presa Malloquin", "Peruvian Hairless", "Peruvian Inca Orchid", "Petit Basset Griffon Vendeen", "Petit Blue de Gascogne", "Phalene", "Pharaoh Hound", "Phu Quoc Ridgeback", "Picardy Spaniel", "Plott Hound", "Podenco Canario", "Pointer", "Polish Greyhound", "Polish Hound", "Polish Hunting", "Polish Lowland Sheepdog", "Polish Tatra Sheepdog", "Pomeranian", "Pont-Audemer Spaniel", "Poodle", "Porcelaine", "Portuguese Podengo", "Portuguese Podengo Pequeno", "Portuguese Pointer", "Portuguese Sheepdog", "Portuguese Water Dog", "Posavac Hound", "Prazsky Krysarik", "Pudelpointer", "Pug", "Puli", "Pumi", "Pungsan", "Pyrenean Mastiff", "Pyrenean Shepherd", "Rafeiro do Alentejo", "Rajapalayam", "Rampur Greyhound", "Rat Terrier", "Redbone Coonhound", "Rhodesian Ridgeback", "Rottweiler", "Rough Collie", "Russell Terrier", "Russian Spaneil", "Russian Toy", "Russo-European Laika", "Saarlooswolfhond", "Sabueso Espanol", "Saint-Usuge Spaniel", "Sakhalin Husky", "Saluki", "Samoyed", "Sapsali", "Sarplaninac", "Schapendoes", "Scheizerisher Niederlaufhund", "Schillerstovare", "Schipperke", "Schweizer Laufhund", "Scotch Collie", "Scottish Deerhound", "Scottish Terrier", "Sealyham Terrier", "Segugio Italiano", "Seppala Siberian Sleddog", "Serbian Hound", "Serbian Tricolour Hound", "Shar Pei", "Shetland Sheepdog", "Shiba Inu", "Shih Tzu", "Shikoku", "Shiloh Shepherd", "Siberian Husky", "Silken Windhound", "Silky Terrier", "Sinhala Hound", "Skye Terrier", "Sloughi", "Slovakian Roughhaired Pointer", "Slovensky Cuvac", "Slovensky Kopov", "Smalandsstovare", "Small Greek Domestic", "Small Munsterlander", "Small Munsterlander Pointer", "Smooth Collie", "Smooth Fox Terrier", "Soft Coated Wheaten Terrier", "South Russian Ovcharka", "Spanish Mastiff", "Spanish Water Dog", "Spinone Italiano", "Sportin Lucas Terrier", "St. Bernard", "Stabyhoun", "Staffordshire Bull Terrier", "Standard Schnauzer", "Stephens Cur", "Styian Coarsehaired Hound", "Sussex Spaniel", "Swedish Lapphund", "Swedish Vallhund", "Taigan", "Tamaskan", "Teddy Roosevelt Terrier", "Telomian", "Tenterfield Terrier", "Thai Bangkaew", "Thai Ridgeback", "Tibetan Mastiff", "Tibetan Spaniel", "Tibetan Terrier", "Tornjak", "Tosa", "Toy Fox Terrier", "Toy Manchester Terrier", "Transylvanian Hound", "Treeing Cur", "Treeing Tennessee Brindle", "Treeing Walker Coonhound", "Trigg Hound", "Tyrolean Hound", "Vizsla", "Volpino Italiano", "Weimaraner", "Welsh Sheepdog", "Welsh Springer Spaniel", "Welsh Terrier", "West Highland White Terrier", "West Siberian Laika", "Westphalian Dachsbracke", "Wetterhoun", "Whippet", "White English Bulldog", "White Shepherd", "Wire Fox Terrier", "Wirehaired Pointing Griffon", "Wirehaired Vizsla", "Xoloitzcuintli", "Yorkshire Terrier"].each do |var| 
  Breed.create!(name: var, species_id: 2)
end

["Abyssinian", "American Bobtail", "American Curl", "American Shorthair", "American Wirehair", "Balinese", "Bengal", "Birman", "Bombay", "British Blue", "British Longhair", "British Shorthair", "Burmese", "Burmilla", "Caliby", "Calico", "Calimanco", "Chartreux", "Chausie", "Chinese Domestic", "Colorpoint Shorthair", "Cornish Rex", "Cymric", "Devon Rex", "Domestic", "Donskoy", "Egyptian Mau", "European Burmese", "Exotic Shorthair", "Havana", "Highlander", "Highlander Shorthair", "Himalayan", "Household Pet", "Japanese Bobtail", "Javanese", "Khaomanee", "Korat", "Kurilian Bobtail", "LaPerm", "Maine Coon", "Maltese", "Manx", "Minskin", "Mix", "Munchkin", "Napoleon", "Nebelung", "Norwegian Forest", "Ocicat", "Ojos Azules", "Oriental Longhair", "Oriental Shorthair", "Persian", "Peterbald", "Pixiebob", "RagaMuffin", "Ragdoll", "Russian Blue", "Savannah", "Scottish Fold", "Selkirk Rex", "Serengeti", "Siamese", "Siberian", "Singapura", "Snowshoe", "Sokoke", "Somali", "Sphynx", "Tabby", "Thai", "Tonkinese", "Torbie", "Tortie", "Tortoiseshell", "Toyger", "Turkish Angora", "Turkish Van"].each do |var| 
  Breed.create!(name: var, species_id: 1)
end

["relaxed", "moderate", "energetic"].each do |var|
  EnergyLevel.create!(level: var)
end

["white", "black", "brown", "gray", "red", "yellow", "orange"].each do |var|
  FurColor.create!(color: var)
end

["short", "medium", "long"].each do |var|
  FurLength.create!(length: var)
end

["male", "female"].each do |var|
  Gender.create!(sex: var)
end

["submissive", "playful", "confident"].each do |var|
  Nature.create!(name: var)
end

["available", "adopted", "unavailable", "absent", "fostered", "rescued"].each do |var|
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

Shelter.create!(name: "East Valley Shelter",
                description: "Serving Arleta, Mission Hills, North Hollywood, Pacoima, Panorama City, Sherman Oaks, Studio City, Sun Valley, Sunland-Tujunga, Sylmar, Toluca Lake, Valley Glen, Valley Village, Van Nuys.  Outside the city limits, serving communities such as Burbank, Glendale and San Fernando. Spay/Neuter Clinic on site. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "14409 Vanowen St",
                city: "Van Nuys", 
                state: "CA",
                zipcode: "91405",
                sun_hours: "11 - 5",
                mon_hours: "Closed",
                tue_hours: "8 - 5",
                wed_hours: "8 - 5",
                thu_hours: "8 - 5",
                fri_hours: "8 - 5",
                sat_hours: "8 - 5",
                slug: "EastValley")
                
Shelter.create!(name: "South LA Shelter",
                description: "Serving Arlington Heights, Arlington Park, Athens, Baldwin Hills, Baldwin Village, Canterbury Knolls, Carthay, Country Club Heights, Crenshaw, Exposition Park, Gramercy Park, Hyde Park, Lafayette Square, Jefferson Park, Koreatown, Leimert Park, Mid-City, Miracle Mile, Pan Pacific Park, Pico-Union, South Los Angeles, University Park, Vermont Knolls, Village Green, West Adams, West Alameda. Outside the city limits, serving communities such as Baldwin Vista, Inglewood, Ladera Heights, View Heights and View Park. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "1850 W 60th St",
                city: "Los Angeles", 
                state: "CA",
                zipcode: "90047",
                sun_hours: "11 - 5",
                mon_hours: "Closed",
                tue_hours: "8 - 5",
                wed_hours: "8 - 5",
                thu_hours: "8 - 5",
                fri_hours: "8 - 5",
                sat_hours: "8 - 5",
                slug: "SouthLA")

Shelter.create!(name: "North Central Shelter",
                description: "Serving Angelino Heights, Arts District, Atwater Village, Beachwood Canyon, Boyle Heights, Chinatown, Cypress Park, Downtown Los Angeles, Eagle Rock, East Hollywood, Echo Park, El Sereno, Elysian Heights, Elysian Park, Elysian Valley, Franklin Hills, Garvanza, Glassell Park, Griffith Park, Hancock Park, Hermon, Highland Park, Historic Filipino Town, Hollywood, Hollywood Heights, Larchmont, Lincoln Heights, Little Tokyo, Los Feliz, MacArthur Park-Westlake, Melrose Hill, Montecito Heights, Monterey Hills, Mt. Washington, Silver Lake, Solano Canyon, Temple-Beaudry, University Hills, Virgil Village, Wilshire Center, Windsor Square. Outside the city limits, serving communities such as Alhambra, East Los Angeles, Glendale, and Pasadena. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "3201 Lacy Street",
                city: "Los Angeles", 
                state: "CA",
                zipcode: "90031",
                sun_hours: "11 - 5",
                mon_hours: "Closed",
                tue_hours: "8 - 5",
                wed_hours: "8 - 5",
                thu_hours: "8 - 5",
                fri_hours: "8 - 5",
                sat_hours: "8 - 5",
                slug: "NorthCentral")

Shelter.create!(name: "West LA Shelter",
                description: "Serving Bel Air, Benedict Canyon, Beverlywood, Beverly Crest, Beverly Hills, Brentwood, Century City, Cheviot Hills, Del Rey, Fairfax, Holmby Hills, Kenter Canyon, Laurel Canyon, Mandeville Canyon, Marina Peninsula, Mar Vista, Melrose District, Pacific Palisades, Palisades Highlands, Palms, Rancho Park, Rustic Canyon, Venice, Westchester, Westdale, Westside Village, West Pico. Outside the city limits, serving communities such as Culver City, Santa Monica and West Hollywood. Spay/Neuter Clinic on site. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "11361 West Pico Blvd",
                city: "Los Angeles", 
                state: "CA",
                zipcode: "90064",
                sun_hours: "11 - 5",
                mon_hours: "Closed",
                tue_hours: "8 - 5",
                wed_hours: "8 - 5",
                thu_hours: "8 - 5",
                fri_hours: "8 - 5",
                sat_hours: "8 - 5",
                slug: "WestLA")

Shelter.create!(name: "Harbor Shelter",
                description: "Serving Harbor City, San Pedro, Watts (partial), Willowbrook, Wilmington. Outside the city limits, serving communities such as Carson, Compton, Gardena, Long Beach, Palos Verdes, Redondo Beach, Signal Hill, Torrance and Watts (partial). Spay/Neuter clinic on site. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "957 N Gaffey Street",
                city: "San Pedro", 
                state: "CA",
                zipcode: "90731",
                sun_hours: "11 - 5",
                mon_hours: "Closed",
                tue_hours: "8 - 5",
                wed_hours: "8 - 5",
                thu_hours: "8 - 5",
                fri_hours: "8 - 5",
                sat_hours: "8 - 5",
                slug: "Harbor")

Shelter.create!(name: "West Valley Shelter",
                description: "Serving Bell Canyon, Canoga Park, Chatsworth, Encino, Granada Hills, Lake Balboa, Northridge, North Hills, Porter Ranch, Reseda, Sepulveda, Tarzana, Warner Center, West Hills, Winnetka, Woodland Hills. Outside the city limits, serving communities such as Agoura, Malibu, Santa Clarita, Valencia and Westlake Village. Closed Holidays.",
                email: "",
                phone: "",
                precedence_id: 2,
                street: "20655 Plummer Street",
                city: "Chatsworth", 
                state: "CA",
                zipcode: "91311",
                sun_hours: "11 - 5",
                mon_hours: "Closed",
                tue_hours: "8 - 5",
                wed_hours: "8 - 5",
                thu_hours: "8 - 5",
                fri_hours: "8 - 5",
                sat_hours: "8 - 5",
                slug: "WestValley")

Shelter.create!(name: "Agoura Animal Care Center",
                description: "Proudly serving the cities/areas of: Agoura, Agoura Hills, Calabasas, Canoga Park, Chatsworth, Fernwood, Hidden Hills, Malibu, Thousand Oaks, Topanga Canyon, Westlake Village, Woodland Hills. Closed Holidays.",
                email: "",
                phone: "(818) 991-0071",
                precedence_id: 2,
                street: "29525 Agoura Rd",
                city: "Agoura", 
                state: "CA",
                zipcode: "91301",
                sun_hours: "10 - 5",
                mon_hours: "12 - 7",
                tue_hours: "12 - 7",
                wed_hours: "12 - 7",
                thu_hours: "12 - 7",
                fri_hours: "10 - 5",
                sat_hours: "10 - 5",
                slug: "Agoura")

Shelter.create!(name: "Baldwin Park Animal Care Center",
                description: "Proudly serving the cities/areas of: Altadena, Arcadia, Azusa, Baldwin Park, Bassett, Bradbury, Brea, Charter Oak, Claremont, Covina, Diamond Bar, Duarte, El Monte, Glendora, Hacienda Heights, Industry, Irwindale, La Crescenta, La Puente, La Verne, Monrovia, Montrose, Mt. Baldy, Pasadena, Rosemead, Rowland Heights, San Dimas, San Gabriel, South El Monte, South San Gabriel, Temple City, Valinda, Walnut, West Covina. Closed Holidays.",
                email: "",
                phone: "(626) 962-3577",
                precedence_id: 2,
                street: "4275 N Elton",
                city: "Baldwin Park", 
                state: "CA",
                zipcode: "91706",
                sun_hours: "10 - 5",
                mon_hours: "12 - 7",
                tue_hours: "12 - 7",
                wed_hours: "12 - 7",
                thu_hours: "12 - 7",
                fri_hours: "10 - 5",
                sat_hours: "10 - 5",
                slug: "BaldwinPark")

Shelter.create!(name: "Carson/Gardena Animal Care Center",
                description: "Proudly serving the cities/areas of: Carson, Culver City, El Camino Village, Gardena, Harbor City, Inglewood, Ladera Heights, Lawndale, Lennox, Lomita, Los Angeles 90008, Los Angeles 90043, Los Angeles 90044, Los Angeles 90047, Los Angeles 90056, Los Angeles 90061, Marina Del Rey, Palos Verdes, Palos Verdes Estates, Rancho Palos Verdes, Rolling Hills, Rolling Hills Estates, San Pedro, Torrance, Universal Studios, West Hollywood. Closed Holidays.",
                email: "",
                phone: "(310) 523-9566",
                precedence_id: 2,
                street: "216 W Victoria St",
                city: "Gardena", 
                state: "CA",
                zipcode: "90248",
                sun_hours: "10 - 5",
                mon_hours: "12 - 7",
                tue_hours: "12 - 7",
                wed_hours: "12 - 7",
                thu_hours: "12 - 7",
                fri_hours: "10 - 5",
                sat_hours: "10 - 5",
                slug: "CarsonGardena")

Shelter.create!(name: "Castaic Animal Care Center",
                description: "Proudly serving the cities/areas of: Acton, Agua Dulce, Bouquet Canyon, Canyon Country, Castaic, Gorman, Green Valley, Kagel Canyon, Lang, Newhall, San Fernando, Santa Clarita, Saugus, Stevenson Ranch, Tujunga, Valencia. Closed Holidays. Alternate phone (818) 367-8065.",
                email: "",
                phone: "(661) 257-3191",
                precedence_id: 2,
                street: "31044 N Charlie Canyon Rd",
                city: "Castaic", 
                state: "CA",
                zipcode: "91384",
                sun_hours: "10 - 5",
                mon_hours: "12 - 7",
                tue_hours: "12 - 7",
                wed_hours: "12 - 7",
                thu_hours: "12 - 7",
                fri_hours: "10 - 5",
                sat_hours: "10 - 5",
                slug: "Castaic")

Shelter.create!(name: "Downey Animal Care Center",
                description: "Proudly serving the cities/areas of: Alhambra, Artesia, Bell, Cerritos, City Terrace, Compton, Cudahy, East Los Angeles 90022, East Los Angeles 90023, East Los Angeles 90063, Florence/Firestone, Hawaiian Gardens, La Habra Heights, La Habra Heights, La Mirada, Los Angeles 90001, Los Angeles 90002, Los Angeles 90032, Lynwood, Maywood, Walnut Park, Whittier. Closed Holidays.",
                email: "",
                phone: "(562) 940-6898",
                precedence_id: 2,
                street: "11258 S Garfield Ave",
                city: "Downey", 
                state: "CA",
                zipcode: "90242",
                sun_hours: "10 - 5",
                mon_hours: "12 - 7",
                tue_hours: "12 - 7",
                wed_hours: "12 - 7",
                thu_hours: "12 - 7",
                fri_hours: "10 - 5",
                sat_hours: "10 - 5",
                slug: "Downey")

Shelter.create!(name: "Lancaster Animal Care Center",
                description: "Proudly serving the cities/areas of: Lake Elizabeth, Lake Hughes, Lake Los Angeles, Lancaster, Leona Valley, Llano, Palmdale, Pearblossom, Quartz Hill, Valyermo. Closed Holidays.",
                email: "",
                phone: "(661) 940-4191",
                precedence_id: 2,
                street: "210 W Ave I",
                city: "Lancaster", 
                state: "CA",
                zipcode: "93536",
                sun_hours: "10 - 5",
                mon_hours: "12 - 7",
                tue_hours: "12 - 7",
                wed_hours: "12 - 7",
                thu_hours: "12 - 7",
                fri_hours: "10 - 5",
                sat_hours: "10 - 5",
                slug: "Lancaster")

Shelter.create!(name: "Antelope Valley Adoption Center",
                description: "Please note: While this facility houses ready-adopt shelter dogs, it is not a shelter. This facility does not take in/impound stray or owned pets, nor does it dispatch requests for service. Only dogs available for adoption are housed here. The phone is only answered during business hours. Closed Holidays.",
                email: "",
                phone: "(661) 974-8309",
                precedence_id: 2,
                street: "42116 4th St E",
                city: "Lancaster", 
                state: "CA",
                zipcode: "93535",
                sun_hours: "12 -4",
                mon_hours: "Closed",
                tue_hours: "10 - 5",
                wed_hours: "10 - 5",
                thu_hours: "10 - 5",
                fri_hours: "10 - 5",
                sat_hours: "10 - 5",
                slug: "AntelopeValley")