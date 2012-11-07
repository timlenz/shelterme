$(function(){
  
  // Hover tooltip for pet tile icons
  $('[rel=tooltip]').tooltip();
  
  // Pet profile follow/unfollow button mouseover text, style swap
  $('.btn-unfollow').mouseover(function(){
    $(this).removeClass("btn-info");
    $(this).addClass("btn-inverse");
    var text = $(this).attr('value');
    text = text.replace("Following","Unfollow");
    $(this).attr('value',text);
  });
  
  $('.btn-unfollow').mouseout(function(){
    $(this).removeClass("btn-inverse");
    $(this).addClass("btn-info");
    var text = $(this).attr('value');
    text = text.replace("Unfollow","Following");
    $(this).attr('value',text);
  })
  
  // Show/hide carousel navigation elements on mouseover
  $('.carousel').mouseover(function(){
    $(this).find('.carousel-control').show();
  });
  
  $('.carousel').mouseleave(function(){
    $(this).find('.carousel-control').hide();
  });
  
  // Auto-select all text in short link field
  $('input[type=text]').click(function(){
    $(this).select();
  });
  
  // AJAX render of admin index pages, sorting & pagination
  $('#shelters th a, #shelters .pagination a, #users th a, #users .pagination a, #pets th a, #pets .pagination a').live('click', function () {
    $.getScript(this.href);
    return false;
  });
  
  // AJAX render of Search forms
  $('#shelters_search, #users_search, #pets_search, #findpet_search').submit(function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });

  // Eliminate "tri-color" from secondary color selection list

  // On load
  $('#pet_secondary_color_id option:contains("tri-color")').remove();

  // On selection as primary color
  $('#pet_primary_color_id').change(function() {
	  pc = ($('#pet_primary_color_id option:selected').text())
	  if (pc == "tri-color") {
		  $('#pet_secondary_color_id').val("0");
	  };
  });

  // Eliminate secondary color selection if primary is "tri-color"
  $('#pet_secondary_color_id').change(function() {
	  pc = ($('#pet_primary_color_id option:selected').text())
	  if (pc == "tri-color") {
		  $('#pet_secondary_color_id').val("0");
		  alert("You cannot select a secondary color when 'tri-color' is already selected.")
	  };
  });
  
  // Eliminate redundant fur color selections
  $('#pet_primary_color_id').change(function() {
	  pc = ($('#pet_primary_color_id option:selected').text())
		sc = ($('#pet_secondary_color_id option:selected').text())
	  if (sc == pc) {
		  $('#pet_secondary_color_id').val("0");
		  alert("You cannot select the same color for both primary and secondary colors.")
	  };
  });

  $('#pet_secondary_color_id').change(function() {
	  pc = ($('#pet_primary_color_id option:selected').text())
		sc = ($('#pet_secondary_color_id option:selected').text())
	  if (sc == pc) {
		  $('#pet_secondary_color_id').val("0");
		  alert("You cannot select the same color for both primary and secondary colors.")
	  };
  });  

  // Show Add Pet Photo modal dialog if no pet photos exist for current pet
  if ($('.noPhoto').length) {
    $('#photoClick').click();
	};
	
	// Show loading interstitial during pet search
	$('form#new_search :submit, form[id^="edit_search"] :submit').click(function(){
		$('.petResults .findBlurb, .petResults .row, .petResults #results').hide();
		$('.petResults #waiting').show();
	});
	
	// Show loading interstitial during MatchMe search
	$('form[id^="edit_user"] :submit').click(function(){
		$('#matchme .findBlurb, #matchme .row, #results').hide();
		$('#waiting').show();
	});
	
	// Show loading interstitial during photo crop
	$('form[id^="edit_pet_photo"] :submit').click(function(){
		$('.fullEditForm').hide();
		$('#loadingCrop').show();
	});
  
  // Resize comment field on pet profile
  $('.commentEntry textarea').attr('rows', 5);

  // Character count on pet profile comment field
  $('#micropost_content').keyup(function(){
		var cnt = $(this).val().length;
		var maxcnt = 240;
		$('#char_count').text(maxcnt - cnt);
		if (maxcnt - cnt < 0) {
			$('input[name="commit"]').prop('disabled', true);
			$('#char_count').css('color','#ec520a');
		} else {
			$('input[name="commit"]').prop('disabled', false);
			$('#char_count').css('color','#c7c7c7');
		};
	});
  
  // Resize edit pet text area
  $('.rightEditForm textarea').attr('rows', 17);

  // Check if profile .headerInfo h1 field is too long and adjust font-size if needed
  if ($('.headerInfo h1').length) {
		var element = document.querySelector('.headerInfo h1');
		var default_height = 35;
		if (element.offsetHeight > default_height) {
			$('.headerInfo h1').css('font-size','22px');
		};
	};
  
  // Autocomplete text fields
  $('.ui-autocomplete').css('z-index', '2');

  $('#user_shelter_name').autocomplete({
	  minLength: 3,
	  source: $('#user_shelter_name').data('autocomplete-source')
  });

  $('#pet_shelter_name').autocomplete({
	  minLength: 3,
	  source: $('#pet_shelter_name').data('autocomplete-source')
  });

	$('#pet_primary_breed_name').autocomplete({
	  minLength: 3,
	  source: $('#pet_primary_breed_name').data('autocomplete-source')
  });
	$('#pet_secondary_breed_name').autocomplete({
	  minLength: 3,
	  source: $('#pet_secondary_breed_name').data('autocomplete-source')
  });

  $('#search_breed_name').autocomplete({
	  minLength: 3,
	  source: $('#search_breed_name').data('autocomplete-source')
  });
  
  // Show/hide change location in Find Pet
  $('#changeLocation').click(function(){
    $('div.findLocation').hide();
    $('div.changeLocation').show();
  });
  
  function changeLocation(){
    $('div.findLocation').show();
    $('div.changeLocation').hide();    
    var updatedLocation = $('[id$=_location]').val();
    $('span#currentLocation').text(updatedLocation);
  }
  
  $('#updateLocation').click(function(){
    changeLocation();
  });

  // Disable [enter] keypress in change location text field for Find Pet
  $('input[name="location"]').keypress(function(event) {
    if ( event.which == 13 ) {
      changeLocation();
      return false;
     };
  });

  // Connect Find Pet radio buttons with hidden input elements
  $('div.btn-group[data-toggle-name=*]').each(function(){
    var group   = $(this);
    var form    = group.parents('form').eq(0);
    var name    = group.attr('data-toggle-name');
    var hidden  = $('input[name="' + name + '"]', form);
    $('button', group).each(function(){
      var button = $(this);
      button.live('click', function(){
          hidden.val($(this).val());
					if(button.text().toLowerCase() == "dog") {
						set_dog_breeds();
						$('[id$=breed_name]').val("")
					} else if (button.text().toLowerCase() == "cat") {
						set_cat_breeds();
						$('[id$=breed_name]').val("")
					}
      });
      if(button.val() == hidden.val()) {
        button.addClass('active');
				if(button.text().toLowerCase() == "dog") {
					set_dog_breeds();
				} else if (button.text().toLowerCase() == "cat") {
					set_cat_breeds();
				}
      }
    });
  });

  function set_dog_breeds(){
		$('[id$=breed_name]').autocomplete({
		  minLength: 3,
		  source: ["Affenpinscher", "Afghan Hound", "Airedale Terrier", "Akita", "Alaskan Malamute", 
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
			  "Xoloitzcuintli", "Yorkshire Terrier"]
	  });
	}

	function set_cat_breeds(){
		$('[id$=breed_name]').autocomplete({
		  minLength: 3,
		  source: ["Abyssinian", "American Bobtail", "American Curl", "American Shorthair", "American Wirehair", 
			  "Angora", "Balinese", "Bengal", "Birman", "Bombay", "British Blue", "British Shorthair", 
			  "Burmese", "Chartreux", "Chinese Domestic", "Colorpoint Shorthair", "Cornish Rex", "Cymric", 
			  "Devon Rex", "Domestic Longhair", "Domestic Medium Hair", "Domestic Shorthair", "Egyptian Mau", 
			  "European Burmese", "Exotic", "Havana Brown", "Japanese Bobtail", "Javanese", "Korat", "LaPerm", 
			  "Maine Coon", "Manx", "Mix", "Norwegian Forest Cat", "Ocicat", "Oriental", "Persian", "RagaMuffin", 
			  "Ragdoll", "Russian Blue", "Scottish Fold", "Selkirk Rex", "Siamese", "Siberian", "Singapura", 
			  "Snowshoe", "Somali", "Sphynx", "Tonkinese", "Turkish Angora", "Turkish Van"]
	  });
	}
  
  // Automatically hide alert dialog after slight delay
  if($('.errorBox').is(':visible')) {
    $('#mainError').delay(3000).fadeOut('slow');
  }

	// Activate the appropriate tab on page re-load
	if($('.nav-tabs').length){
		// First, set the current tab as a var
	  var tab_links = $('.nav-tabs li a')
		tab_links.live('click', function(){
			current_tab = $(this).attr('href');
			$.cookie("active_tab", current_tab, { expires: 1 });
    });
		// Then, set appropriate tab as active on page load
		if($.cookie("active_tab").length){
			var old_tab = $.cookie("active_tab");
			$('.nav-tabs li a[href=' + old_tab + ']').click();
		};
	};
	
	// Populate footer quote
	$('div .quote').html(function() {
		var randSeed = Math.floor(Math.random()*51);
		var quotes = ["I have found the paradox that if I love until it hurts, then there is no hurt, but only more love. - Mother Teresa",
									"Unless someone like you cares a whole awful lot, nothing is going to get better.  It's not. - Dr. Seuss",
									"Act as if what you do makes a difference.  It does. - William James",
									"Being good is commendable, but only when it is combined with doing good is it useful. - Unknown",
									"The purpose of life is not to be happy - but to matter, to be productive, to be useful, to have it make some difference that you have lived at all. - Leo Rosten",
									"It is the greatest of all mistakes to do nothing because you can only do little - do what you can. - Sydney Smith",
									"The true meaning of life is to plant trees, under whose shade you do not expect to sit. - Nelson Henderson",
									"Dare to reach out your hand into the darkness, to pull another hand into the light. - Norman B. Rice",
									"The difference between a helping hand and an outstretched palm is a twist of the wrist. - Laurence Leamer",
									"I am only one, but I am one.  I cannot do everything, but I can do something.  And I will not let what I cannot do interfere with what I can do. - Edward Everett Hale",
									"How far that little candle throws his beams! So shines a good deed in a naughty world. - William Shakespeare",
									"I expect to pass through life but once.  If therefore, there be any kindness I can show, or any good thing I can do to any fellow being, let me do it now, and not defer or neglect it, as I shall not pass this way again. - William Penn",
									"How wonderful it is that nobody need wait a single moment before starting to improve the world. - Anne Frank",
									"Be an opener of doors for such as come after thee, and do not try to make the universe a blind alley. - Ralph Waldo Emerson",
									"We can do no great things, only small things with great love. - Mother Teresa",
									"Nobody can do everything, but everyone can do something. - Unknown",
									"Everyone thinks of changing the world, but no one thinks of changing himself. - Leo Tolstoy",
									"Nobody made a greater mistake than he who did nothing because he could only do a little. - Edmund Burke",
									"It seems to me that any full grown, mature adult would have a desire to be responsible, to help where he can in a world that needs so very much, that threatens us so very much. - Norman Lear",
									"Live simply that others might simply live. - Elizabeth Ann Seton",
									"We make a living by what we get, but we make a life by what we give. - Winston Churchill",
									"I wondered why somebody didn't do something.  Then I realized, I am somebody. - Unknown",
									"Do not commit the error, common among the young, of assuming that if you cannot save the whole of mankind you have failed. - Jan de Hartog",
									"Love the earth and sun and animals, Despise riches, give alms to everyone that asks, Stand up for the stupid and crazy, Devote your income and labor to others... And your very flesh shall be a great poem. - Walt Whitman",
									"Thousands of candles can be lighted from a single candle, and the life of the candle will not be shortened.  Happiness never decreases by being shared. - Buddha",
									"Our prayers for others flow more easily than those for ourselves.  This shows we are made to live by charity. - C.S.Lewis",
									"Not only must we be good, but we must also be good for something. - Henry David Thoreau",
									"Sometimes a man imagines that he will lose himself if he gives himself, and keep himself if he hides himself.  But the contrary takes place with terrible exactitude. - Ernest Hello",
									"Real joy comes not from ease or riches or from the praise of men, but from doing something worthwhile. - Wilfred Grenfell",
									"Things of the spirit differ from things material in that the more you give the more you have. - Christopher Morley",
									"A bone to the dog is not charity.  Charity is the bone shared with the dog, when you are just as hungry as the dog. - Jack London",
									"Service to others is the rent you pay for your room here on earth. - Muhammed Ali",
									"Do not let what you cannot do interfere with what you can do. - John Wooden",
									"You give but little when you give of your possessions.  It is when you give of yourself that you truly give. - Kahlil Gibran",
									"Great opportunities to help others seldom come, but small ones surround us every day. - Sally Koch",
									"If you do a good job for others, you heal yourself at the same time, because a dose of joy is a spiritual cure. - Dietrich Bonhoeffer",
									"No joy can equal the joy of serving others. - Sai Baba",
									"What we have done for ourselves alone dies with us; what we have done for others and the world remains and is immortal. - Albert Pike",
									"I've learned that you shouldn't go through life with a catchers mitt on both hands.  You need to be able to throw something back. - Maya Angelou",
									"The greatest good you can do for another is not just to share your riches but to reveal to him his own. - Benjamin Disraeli",
									"The work an unknown good man has done is like a vein of water flowing hidden underground, secretly making the ground green. - Thomas Carlyle",
									"If the world seems cold to you, kindle fires to warm it. - Lucy Larcom",
									"Every action in our lives touches on some chord that will vibrate in eternity. - Edwin Hubbel Chapin",
									"The world is moved along, not only by the mighty shoves of its heroes, but also by the aggregate of tiny pushes of each honest worker. - Helen Keller",
									"There are many in the world who are dying for a piece of bread, but there are many more dying for a little love. - Mother Teresa",
									"If you pursue good with labor, the labor passes away but the good remains; if you pursue evil with pleasure, the pleasure passes away and the evil remains. - Cicero",
									"If you think you are too small to be effective, you have never been in bed with a mosquito. - Betty Reese",
									"There are two ways of spreading light - to be the candle or the mirror that reflects it. - Edith Wharton",
									"Every man feels instinctively that all the beautiful sentiments in the world weigh less than a single lovely action. - Lowell",
									"Generosity is not giving me that which I need more than you do, but it is giving me that which you need more than I do. - Kahlil Gibran"]
		var randQuote = quotes[randSeed];
		return randQuote;
	});
  
});