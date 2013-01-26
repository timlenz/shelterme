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

	// Show nav spinner on page navigation
	$('a[href^="/"], #addPet input[type="submit"]').click(function(){
		$('.navLogo').hide();
		$('.navSpinner').animate({
			opacity: "show"
		}, "750");
	});

	// Hover state on Join, Sign In header buttons
	$('.signInit').mouseover(function(){
		$(this).find("a").css("color","");
	}).mouseout(function(){
		$(this).find("a").css("color","#722705");
	});
	
	// Center Add Pet potential matches for one or two pets
	if ( $('#potentialMatch').length ) {
		var pet_tiles = $('div.pet-tile').size();
		if ( pet_tiles == 1 || pet_tiles == 2 ) {
			var inner_width = ($('div.pet-tile').width() + 10) * pet_tiles;
			$('#potentialMatch').css({'margin-left':'auto','margin-right':'auto'}).css('width',inner_width);
		};
	};
  
  // Show/hide carousel navigation elements on mouseover
  $('.carousel').mouseover(function(){
    $(this).find('.carousel-control').show();
  });
  
  $('.carousel').mouseleave(function(){
    $(this).find('.carousel-control').hide();
  });

  // Show/hide fader navigation elements on mouseover
  $('.fader').mouseover(function(){
    $(this).find('.fader-control').show();
  });
  
  $('.fader').mouseleave(function(){
    $(this).find('.fader-control').hide();
  });

	// Photo fader controls
	$('.fader-control[href="#next"]').click(function(){
		var current_image = $('.fader .active');
		var next_image = (current_image.next().length > 0) ? current_image.next() : $('.fader img:first');
		next_image.css('z-index', 2).show(); // move next image up in pile
		current_image.fadeOut(1500, function() {
			current_image.css('z-index', 1).show().removeClass('active'); // reset z-index and unhide
			next_image.css('z-index', 3).addClass('active'); // move next image to top
		});
	});
	
	$('.fader-control[href="#prev"]').click(function(){
		var current_image = $('.fader .active');
		var prev_image = (current_image.prev().length > 0) ? current_image.prev() : $('.fader img:last');
		prev_image.css('z-index', 2).show(); // move prev image up in pile
		current_image.fadeOut(1500, function() {
			current_image.css('z-index', 1).show().removeClass('active'); // reset z-index and unhide
			prev_image.css('z-index', 3).addClass('active'); // move prev image to top
		});		
	});
	
	// History Slider controls
	if ( $('#historySlider').length ) {
		var tiles = $('.small-pet-tile').length;
		var tile_width = $('.small-pet-tile').outerWidth([true]);
		var inner_width = tiles * tile_width;
		var hslider_width = $('#historySlider .container').width();
		var hslide_right = "+=" + (tile_width * 3);
		var hslide_left = "-=" + (tile_width * 3);
		// Set width of sliding element
		$('#historySlider ol').width(inner_width);
		// Video Display slider controls
		$('.slider-control').click(function(){
			var clicked = $(this).attr('class').replace(' slider-control','');
			if ( clicked == "right" ) {
				$('.slider-inner').animate({
					right: hslide_right
				}, 500, function(){
					$('.slider-control.left').show();
					// hide right control if last element visible
					var right_edge = parseInt($('.slider-inner').css('right'),10);
					if ( right_edge >= inner_width - hslider_width - 57) {
						$('.slider-control.right').hide();
					} else {
						$('.slider-control.right').show();
					};
				});
			} else if ( clicked == "left" ) {
				$('.slider-inner').animate({
					right: hslide_left
				}, 500, function(){
					$('.slider-control.right').show();
					// hide left control if first element visible
					var left_edge = parseInt($('.slider-inner').css('right'),10);
					if ( left_edge == 0 ) {
						$('.slider-control.left').hide();
					} else {
						$('.slider-control.left').show();
					};
				});
			};
			return false;
		});
	};
	
	// Video Display controls
	$('#videoDisplay li a').click(function(){
		// Grab number for new video
		var new_thumb = $(this).attr('id').replace('thumb',''); 
		$('.outerVideo li').removeClass('selected');
		$(this).parent().addClass('selected');
		// Pause current video before displaying new video
		var current_video = $('.innerVideo div.active').attr('id')
		_V_(current_video).ready(function(){
			var activePlayer = this;
			activePlayer.pause();
		});
		// Show new video, hide old video
		$('.innerVideo .video-js').removeClass('active');
		$('.innerVideo .video-js').eq(new_thumb).addClass('active');
		return false;
	});
	
	if ( $('#videoDisplay').length ) {
		var thumbs = $('.outerVideo li').length;
		var thumb_width = $('.outerVideo li').outerWidth([true]);
		var ol_width = thumbs * thumb_width;
		var slider_width = $('.outerVideo').outerWidth([true]);
		var slide_right = "+=" + (thumb_width * 4);
		var slide_left = "-=" + (thumb_width * 4)
		// Set width of sliding element
		$('#videoDisplay ol').width(ol_width);
		// Video Display slider controls
		$('.slide-control').click(function(){
			var clicked = $(this).attr('class').replace(' slide-control','');
			if ( clicked == "right" ) {
				$('.outerVideo ol').animate({
					right: slide_right
				}, 500, function(){
					$('.slide-control.left').show();
					// hide right control if last element visible
					var right_edge = parseInt($('.outerVideo ol').css('right'),10);
					if ( right_edge >= ol_width - slider_width ) {
						$('.slide-control.right').hide();
					} else {
						$('.slide-control.right').show();
					};
				});
			} else if ( clicked == "left" ) {
				$('.outerVideo ol').animate({
					right: slide_left
				}, 500, function(){
					$('.slide-control.right').show();
					// hide left control if first element visible
					var left_edge = parseInt($('.outerVideo ol').css('right'),10);
					if ( left_edge == 0 ) {
						$('.slide-control.left').hide();
					} else {
						$('.slide-control.left').show();
					};
				});
			};
			return false;
		});
	};
  
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
  $('#shelters_search, #users_search, #pets_search, #findpet_search, #managed_pets_search').submit(function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });

	// Alert dialog for verifying accuracy of entered ID for Adding a Pet
	$('#addPet input[type="submit"]').click(function(){
		var id_check = $('#search').val();
		var confirm_message = "You cannot change an ID once you create a pet profile. Is '" + id_check + "' the correct ID?"
		$('input[type="submit"]').attr("data-confirm", confirm_message);
	});

	// AJAX-like render of managed & admin pet state change (cookie used in controller to redirect view)
	$('#managed_pets form[id^="edit_pet"], #pets form[id^="edit_pet"]').submit(function () {
    $.cookie("managed_pets", "true", { expires: 1, path: '/' });
  });

	// AJAX-like render of managed pet deletion (cookie used in controller to redirect view)
	$('.managedDelete a').click(function() {
		$.cookie("delete_managed_pet", "true", { expires: 1, path: '/' });
	});
	
	// AJAX-like render of shelter deletion (cookie used in controller to redirect view)
	$('.adminDelete a').click(function() {
		$.cookie("delete_shelter", "true");
	});

	// Species-specific adjustment of available fur color choices
	
	// For cats, hide red and yellow
  function show_cat_colors(){
    $('#pet_primary_color, #pet_secondary_color').removeClass("six-btn");
		$('#pet_primary_color, #pet_secondary_color').addClass("five-btn");
		$('#pet_primary_color button[value="' + 5 + '"], #pet_secondary_color button[value="' + 5 + '"]').hide();
		$('#pet_primary_color button[value="' + 6 + '"], #pet_secondary_color button[value="' + 6 + '"]').hide();
		$('#pet_primary_color button[value="' + 7 + '"], #pet_secondary_color button[value="' + 7 + '"]').show();
  };
	
	// For dogs, hide orange
  function show_dog_colors(){
    $('#pet_primary_color, #pet_secondary_color').removeClass("five-btn");
		$('#pet_primary_color, #pet_secondary_color').addClass("six-btn");
		$('#pet_primary_color button[value="' + 5 + '"], #pet_secondary_color button[value="' + 5 + '"]').show();
		$('#pet_primary_color button[value="' + 6 + '"], #pet_secondary_color button[value="' + 6 + '"]').show();
		$('#pet_primary_color button[value="' + 7 + '"], #pet_secondary_color button[value="' + 7 + '"]').hide();
  };

  // Show Add Pet Photo modal dialog if no pet photos exist for current pet
  if ($('.noPhoto').length) {
    $('#photoClick').click();
	};
	
	// Disable Add Media buttons if user agent is iPad (and other tablets)
	if ( $('.addMedia').length ) {
		if ( navigator.userAgent.match(/iPad|Tablet/i) != null ) {
			$('.mediaButtons input').prop('disabled', true);
		};
	};
	
	// Disable Add Pet if user agent is iPad (and other tablets)
	if ( $('#addPet').length) {
		if ( navigator.userAgent.match(/iPad|Tablet/i) != null ) {
			$('#addPet input[type="submit"]').prop('disabled', true);
		};
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
	
	// Enable MatchMe submit button once descriptive terms have been selected
	// Live enabling
	$('.form-blue').live('click', function(){
		var ones = $('.form-blue input[id^="user_"][value="1"]').length;
		var twos = $('.form-blue input[id^="user_"][value="2"]').length;
		if ( ones + twos >= 7 ) {
			$('.form-blue button[type="submit"]').prop('disabled', false);
		};
	});
	// Reload enabling after saved values
	if ( $('.form-blue').length ) {
		var ones = $('.form-blue input[id^="user_"][value="1"]').length;
		var twos = $('.form-blue input[id^="user_"][value="2"]').length;
		if ( ones + twos >= 7 ) {
			$('.form-blue button[type="submit"]').prop('disabled', false);
		};
	};
	
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
		var default_height = 36;
		if (element.offsetHeight > default_height) {
			$('.headerInfo h1').css('font-size','22px');
		};
	};
  
  // Autocomplete text fields
  $('.ui-autocomplete').css('z-index', '2');

  $('#user_shelter_name').autocomplete({
	  minLength: 2,
	  source: $('#user_shelter_name').data('autocomplete-source')
  });

  $('#pet_shelter_name').autocomplete({
	  minLength: 2,
	  source: $('#pet_shelter_name').data('autocomplete-source')
  });

	$('#pet_primary_breed_name').autocomplete({
	  minLength: 2,
	  source: $('#pet_primary_breed_name').data('autocomplete-source')
  });
	$('#pet_secondary_breed_name').autocomplete({
	  minLength: 2,
	  source: $('#pet_secondary_breed_name').data('autocomplete-source')
  });

  $('#search_breed_name').autocomplete({
	  minLength: 2,
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
  };
  
  $('#new_search button[type="submit"], .match-me').click(function(){
    changeLocation();
  });

	// Reformat activity list item if Manager viewing
	if ( $('.activity').length ) {
		if ( $('.managed') ) {
			$('.managed').prev().css('border-bottom-color','#D9D7D6');
		};
	};
	
	// Center pagination controls for activity/updates feed
	if ( $('#activity .pagination').length ) {	
		var ctrl_width = $('.pagination ul').width();
		$('.pagination').css({'margin-left':'auto','margin-right':'auto','width':ctrl_width,'visibility':'visible'});
	};

	// Dynamic Floating content indicator
	var min_height = 730; // For monitors with 800 px of vertical resolution, must account for menu bars & such
	// Show floater for short browser windows (onload)
	if ($(window).height() < min_height) {
		$('#floater').show();
	};
	// Hide floater for pages with content near the size of the window
	if ( $(document).height() <= ($(window).height() + 400) ) {
		$('#floater').hide();
	};
	// Show floater for resized windows
	$(window).resize(function(){
		if ( ($(window).height() <= min_height) && ($(document).height() > ($(window).height() + 200)) ) { 
			$('#floater').show();
		} else {
			$('#floater').hide();
		};
	});
	// Hide/show when scrolling
	$(window).scroll(function() {
		if (( ($(document).height() - $('body').scrollTop() - $(window).height()) > min_height ) && ($(window).height() <= min_height)) {
			$('#floater').show();
		} else {
			$('#floater').hide();
		};
	});
	// Scroll down on click and hide floater
	$('#floater').click(function() {
		$('#floater').hide();
		$('body').scrollTop($('body').scrollTop() + min_height);
	});

  // Connect radio buttons with hidden input elements
  $('div.btn-group[data-toggle-name=*]').each(function(){
    var group   = $(this);
    var form    = group.parents('form').eq(0);
    var name    = group.attr('data-toggle-name');
    var hidden  = $('input[name="' + name + '"]', form);
		var current_value;
    $('button', group).each(function(){
      var button = $(this);
      button.live('click', function(){
				current_value = hidden.val();
				// Set value of clicked element to hidden control
				hidden.val($(this).val());
				// Show Breed control on selection of species
				if ( name == "search[species_id]" ) {
					$('#search_breed_name').parent().parent().show();
					$('#new_search button[type="submit"], #new_search a:contains("Reset")').css('visibility','visible');
				};
				// Disabling/deselecting secondary color on primary color click
				if(name == "pet[primary_color_id]") {
					disable_value = $(this).val();
					$('#pet_secondary_color button').prop('disabled', false);
					$('#pet_secondary_color button[value="'+ disable_value +'"]').prop('disabled', true);
					$('#pet_secondary_color button[value="'+ disable_value +'"]').removeClass("active");
					if ( $('#pet_secondary_color_id').val() == disable_value ) {
						$('#pet_secondary_color_id').val("");
					};
				};
				// Dealing with secondary color selections
				if(name == "pet[secondary_color_id]") {
					// Deselect all other secondary color selections
					$('#pet_secondary_color button').removeClass("active");
					// Deselect self if clicked while active
					if ( hidden.val() == current_value ) {
						$('#pet_secondary_color_id').val("");
						$(this).mouseout(function(){
							if ( !hidden.val() ) {
								$(this).removeClass("active");
							};
						});
					};
				};
				// Submit pet state changes on click for Managed Pets, Admin Pets views
				if($('#managed_pets, #pets').length) {
					$(this).parent().parent().find("input[type=submit]").click();
				};
				// Update pet breed fields based on species selection
				if(button.text().toLowerCase() == "dog") {
					set_dog_breeds();
					show_dog_colors();
					$('[id$=breed_name]').val("")
				} else if (button.text().toLowerCase() == "cat") {
					set_cat_breeds();
					show_cat_colors();
					$('[id$=breed_name]').val("")
				};
      });
      if(button.val() == hidden.val()) {
				// Set clicked button to active
				button.addClass('active');
				// Disable secondary color button with primary color selection on load
				$('#pet_secondary_color button[value="'+ $('#pet_primary_color_id').val() +'"]').prop('disabled', true);
				// Update pet breed fields based on species selection
				if(button.text().toLowerCase() == "dog") {
					set_dog_breeds();
					show_dog_colors();
				} else if (button.text().toLowerCase() == "cat") {
					set_cat_breeds();
					show_cat_colors();
				};
      };
    });
  });

  function set_dog_breeds(){
		$('[id$=breed_name]').autocomplete({
		  minLength: 2,
		  source: ["Affenpinscher", "Afghan Hound", "Airedale Terrier", "Akita", "Alaskan Malamute", "American Cocker Spaniel", "American English Coonhound", "American Eskimo Dog", "American Foxhound", "American Pit Bull Terrier", "American Staffordshire Terrier", "American Water Spaniel", "Anatolian Shepherd", "Australian Cattle Dog", "Australian Shepherd", "Australian Terrier", "Basenji", "Basset Hound", "Beagle", "Bearded Collie", "Beauceron", "Bedlington Terrier", "Belgian Malinois", "Belgian Sheepdog", "Belgian Tervuren", "Bernese Mountain Dog", "Bichon Frise", "Black and Tan Coonhound", "Black Russian Terrier", "Bloodhound", "Bluetick Coonhound", "Border Collie", "Border Terrier", "Borzoi", "Boston Terrier", "Bouvier des Flandres", "Boxer", "Boykin Spaniel", "Briard", "Brittany", "Brussels Griffon", "Bull Terrier", "Bulldog", "Bullmastiff", "Cairn Terrier", "Canaan Dog", "Cane Corso", "Cardigan Welsh Corgi", "Cavalier King Charles Spaniel", "Cesky Terrier", "Chesapeake Bay Retriever", "Chihuahua", "Chinese Crested", "Chinese Shar-Pei", "Chow Chow", "Clumber Spaniel", "Cocker Spaniel", "Collie", "Curly-Coated Retriever", "Dachshund", "Dalmatian", "Dandie Dinmont Terrier", "Doberman Pinscher", "Dogue de Bordeaux", "English Cocker Spaniel", "English Foxhound", "English Setter", "English Springer Spaniel", "English Toy Spaniel", "Entlebucher Mountain Dog", "Field Spaniel", "Finnish Lapphund", "Finnish Spitz", "Flat-Coated Retriever", "French Bulldog", "German Pinscher", "German Shepherd", "German Shorthaired Pointer", "German Wirehaired Pointer", "Giant Schnauzer", "Glen of Imaal Terrier", "Golden Retriever", "Gordon Setter", "Great Dane", "Great Pyrenees", "Greater Swiss Mountain Dog", "Greyhound", "Harrier", "Havanese", "Ibizan Hound", "Icelandic Sheepdog", "Irish Setter", "Irish Terrier", "Irish Water Spaniel", "Irish Wolfhound", "Italian Greyhound", "Japanese Chin", "Keeshond", "Kerry Blue Terrier", "Komondor", "Kuvasz", "Labrador Retriever", "Lakeland Terrier", "Leonberger", "Lhasa Apso", "Lowchen", "Maltese", "Manchester Terrier", "Mastiff", "Miniature American Eskimo Dog", "Miniature Bull Terrier", "Miniature Dachshund", "Miniature Pinscher", "Miniature Poodle", "Miniature Schnauzer", "Mix", "Mutt", "Neapolitan Mastiff", "Newfoundland", "Norfolk Terrier", "Norwegian Buhund", "Norwegian Elkhound", "Norwegian Lundehund", "Norwich Terrier", "Nova Scotia Duck Tolling Retriever", "Old English Sheepdog", "Otterhound", "Papillon", "Parson Russell Terrier", "Pekingese", "Pembroke Welsh Corgi", "Petit Basset Griffon Vendeen", "Pharaoh Hound", "Plott", "Pointer", "Polish Lowland Sheepdog", "Pomeranian", "Portuguese Water Dog", "Pug", "Puli", "Pyrenean Shepherd", "Redbone Coonhound", "Rhodesian Ridgeback", "Rottweiler", "Saint Bernard", "Saluki", "Samoyed", "Schipperke", "Scottish Deerhound", "Scottish Terrier", "Sealyham Terrier", "Shetland Sheepdog", "Shiba Inu", "Shih Tzu", "Siberian Husky", "Silky Terrier", "Skye Terrier", "Smooth Fox Terrier", "Soft Coated Wheaten Terrier", "Spinone Italiano", "Staffordshire Bull Terrier", "Standard Poodle", "Standard Schnauzer", "Sussex Spaniel", "Swedish Vallhund", "Tibetan Mastiff", "Tibetan Spaniel", "Tibetan Terrier", "Toy American Eskimo Dog", "Toy Fox Terrier", "Toy Manchester Terrier", "Toy Poodle", "Treeing Walker Coonhound", "Vizsla", "Weimaraner", "Welsh Springer Spaniel", "Welsh Terrier", "West Highland White Terrier", "Whippet", "Wire Fox Terrier", "Wirehaired Pointing Griffon", "Xoloitzcuintli", "Yorkshire Terrier"]
	  });
	};

	function set_cat_breeds(){
		$('[id$=breed_name]').autocomplete({
		  minLength: 2,
		  source: ["Abyssinian", "American Bobtail", "American Curl", "American Domestic", "American Shorthair", "American Wirehair", 
			  "Angora", "Balinese", "Bengal", "Birman", "Bombay", "British Blue", "British Shorthair", 
			  "Burmese", "Chartreux", "Chinese Domestic", "Colorpoint Shorthair", "Cornish Rex", "Cymric", 
			  "Devon Rex", "Domestic Longhair", "Domestic Medium Hair", "Domestic Shorthair", "Egyptian Mau", 
			  "European Burmese", "Exotic", "Havana Brown", "Japanese Bobtail", "Javanese", "Korat", "LaPerm", 
			  "Maine Coon", "Manx", "Mix", "Norwegian Forest Cat", "Ocicat", "Oriental", "Persian", "RagaMuffin", 
			  "Ragdoll", "Randombred", "Russian Blue", "Scottish Fold", "Selkirk Rex", "Siamese", "Siberian", "Singapura", 
			  "Snowshoe", "Somali", "Sphynx", "Tonkinese", "Turkish Angora", "Turkish Van"]
	  });
	};
  
  // Automatically hide alert dialog after slight delay
  if($('.errorBox').is(':visible')) {
    $('#mainError').delay(3000).fadeOut('slow');
  };

	// Activate the appropriate tab on page load
	if($('.nav-tabs').length){
		// Check if cookie exisits and matches with an available tab. Load proper tab if it does
		if($.cookie("active_tab") != null && $('a[href=' + $.cookie("active_tab") +']').length){ // Must check null explicitly for Safari
			var old_tab = $.cookie("active_tab");
			$('.nav-tabs li a[href=' + old_tab + ']').click();
		} else {
			// Select first tab as default if no cookie exists
			var first_tab = $('.nav-tabs li:first a');
			first_tab.click();
			$.cookie("active_tab", first_tab.attr('href'));
		};
		// Set cookie for any clicked tab
		var tab_links = $('.nav-tabs li a')
		tab_links.live('click', function(){
			current_tab = $(this).attr('href');
			$.cookie("active_tab", current_tab);
    });
	};
	
	// Populate footer quote
	$('div .quote').html(function() {
		var randSeed = Math.floor(Math.random()*53);
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
									"Generosity is not giving me that which I need more than you do, but it is giving me that which you need more than I do. - Kahlil Gibran",
									"Never doubt that a small group of thoughtful, committed citizens can change the world. - Margaret Mead",
									"The difference between friends and pets is that friends we allow into our company, pets we allow into our solitude. - Robert Brault"]
		var randQuote = quotes[randSeed];
		return randQuote;
	});
  
});