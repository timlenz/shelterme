$(function(){

	// Hover tooltip for pet tile icons
	$('[rel=tooltip]').tooltip({
		container: 'body'
	});
	
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
	
	// Highlight Enter Animal ID field on mouseover of .animalID spans
	$('.animalID').mouseover(function(){
		$('#addPet').css("background-color","#c0dce5"); // 
	}).mouseout(function(){
		$('#addPet').css("background-color","#d3cacb");
	});

	// Center Add Pet potential matches for one or two pets
	if ( $('#potentialMatch').length ) {
		var pet_tiles = $('div.pet-tile').size();
		if ( pet_tiles == 1 || pet_tiles == 2 ) {
			var inner_width = ($('div.pet-tile').width() + 10) * pet_tiles;
			$('#potentialMatch').css({'margin-left':'auto','margin-right':'auto'}).css('width',inner_width);
		};
	};

	// Auto-select all text in short link field
	$('#pet_text').click(function(){
		$(this).select();
	});

	// Sparklines for Admin Index pages
	$('.sparklines').sparkline('html', { 
		fillColor: 'none',
		lineColor: '#999',
		spotColor: 'none',
		minSpotColor: 'none',
		maxSpotColor: 'none',
		highlightSpotColor: '#d54509',
		highlightLineColor: '#d54509',
		width: '60px'
	});

	// AJAX render of admin index pages, sorting & pagination
	$('#managed_pets .pagination a, #pets .pagination a, #shelters .pagination a, #users .pagination a').click(function () {
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
		var id_check = $('#search').val();//.replace(/[\W\_]+/, "").replace(" ", "");
		var confirm_message = "You cannot change an ID once you create a pet profile. Is '" + id_check + "' the correct ID?"
		$('input[type="submit"]').attr("data-confirm", confirm_message);
	});
	
	// AJAX-like render of shelter deletion (cookie used in controller to redirect view)
	$('.adminDelete a').click(function() {
		$.cookie("delete_shelter", "true");
	});
	
	// AJAX-like render of pet photo and video deletion from Admin view (cookie used in controllers to redirect back)
	$('a.deleteMedia').click(function() {
		$.cookie("delete_media", "true");
	});

	// Click species shelter link in Find Pets selects proper tab
	$('.foundShelterPets a').click(function() {
		var selected_species = $(this).parent().attr('class');
		var click_species = "#" + selected_species
		$.cookie("active_tab", click_species);
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

	// Update Add Pet location
	$('#updateLocation').click(function(){
		var newLocation = $('#pet_location').val();
		$.cookie("location", newLocation, { path: '/'});
		location.reload();
	});

	// Update pet status to 'absent' if not at shelter
	$('#absentPet').click(function(){
		$('#submitAbsentPet').click();
		$.cookie("pet_state_change", "available", { expires: 1, path: '/' });
		$.cookie("absent_pet_submit", "true", { expires: 1, path: '/' });
	});

	// Change text on expand/collapse of all shelters on Find Shelter
	$('#sheltersToggle').click(function(){
		if ($(this).html() == "Collapse") {
			$(this).html(start_state);
		}	else {
			start_state = $(this).html();
			$(this).html("Collapse");
		};
	});

	// Show Add Pet Photo modal dialog if no pet photos exist for current pet
	// Set pet_slug cookie value to check for pet_id mismatch on back nav
	if ($('.noPhoto').length) {
		var pet_slug = window.location.pathname.match(/[^\/]+$/);
		$.cookie("pet_slug", pet_slug, { path: '/'});
		$('#photoClick').click();
	};

	// Force correct pet target for added media on click of Add Photo / Add Video
	// Set pet_slug cookie value to check for pet_id mismatch on back nav
	$('#photoClick, #videoClick').click(function(){
		var pet_slug = window.location.pathname.match(/[^\/]+$/);
		$.cookie("pet_slug", pet_slug, { path: '/'});
	});
	
	// Hide Add Media buttons if user agent is iPad - added iPhone|iPod|Android until mobile apps ready
	// if ( $('.addMedia').length ) {
	// 	if ( navigator.userAgent.match(/iPhone|iPod|Android|iPad/i) != null ) {
	// 		$('.mediaButtons input').prop('disabled', true);
	// 	};
	// };
	
	// Hide Add Pet, Add Photo, Add Video if user agent is iPad (and other tablets) - added iPhone|iPod|Android until mobile apps ready
	// if ( $('#addPet, .addMedia').length) {
	// 	if ( navigator.userAgent.match(/iPhone|iPod|Android|iPad/i) != null ) {
	// 		$('#addPet, .addMedia .mediaButtons, .addMedia p:first').hide();
	// 		$('#tabletAlert').show();
	// 	};
	// };

	// Set Shelter Exclusion cookie if adding non-redundant pet ID after redundant result found
	// explicitly prevents the exclusion of shelters from potential pet shelter locations
	if ( $('#potentialMatch').length ) {
		$('#addPet').click(function(){
			$.cookie("exclude", "false");
		});
	};
	
	// Show loading interstitial during pet search
	$('form#new_search :submit, form[id^="edit_search"] :submit').click(function(){
		$('.petResults .findBlurb, .petResults .row, .petResults #results').hide();
		$('.petResults #waiting').show();
	});
	
	// Show loading interstitial during MatchMe search
	$('.match-me').click(function(){
		$('#matchme .findBlurb, #matchme .row, #results').hide();
		$('#waiting').show();
		// Set cookie for generating MatchMe results after submission
		$.cookie("matchme", "true", {path: '/'});
	});

	// Reset MatchMe flag on fresh load of page
	if ( $('button.match-me').length ) {
		$.cookie("matchme", "false", {path: '/'});
	};
	
	// Enable MatchMe submit button once descriptive terms have been selected
	// Live enabling
	$('.form-blue').bind('click', function(){
		var ones = $('.form-blue input[id^="user_"][value="1"]').length;
		var twos = $('.form-blue input[id^="user_"][value="2"]').length;
		if ( ones + twos >= 7 && $('#user_location').val() != "MapQuest not responding" ) {
			$('.form-blue button[type="submit"]').prop('disabled', false);
			//$('.form-blue button[type="submit"]').show();
			$('#enterAll').hide();
		};
	});
	// Reload enabling after saved values
	if ( $('.form-blue').length ) {
		var ones = $('.form-blue input[id^="user_"][value="1"]').length;
		var twos = $('.form-blue input[id^="user_"][value="2"]').length;
		if ( ones + twos >= 7 && $('#user_location').val() != "MapQuest not responding" ) {
			$('.form-blue button[type="submit"]').prop('disabled', false);
			//$('.form-blue button[type="submit"]').show();
			$('#enterAll').hide();
		};
	};
	
	// Show loading interstitial during photo crop
	$('form[id^="edit_pet_photo"] :submit').click(function(){
		$('.fullEditForm').hide();
		$('#loadingCrop').show();
	});

	// Show progress bar on upload start
	$('.cloudinary-fileupload').bind('fileuploadstart', function() {	
		$('#loadingPhoto, .handhold').show();
		$('button.close, .filedrop').hide();
		$('.cloudinary-fileupload').bind('fileuploadprogress', function(e, data){
			$('.mediaModal .headerInfo p').text(data.files[0].name);
			progress = parseInt(data.loaded / data.total * 100, 10);
			$('.progress .bar').css('width', progress + '%');
		});
		return true;
	});
	
	// Show selected avatar photo name
	$('.cloudinary-fileupload input[type=file]').change(function(){
		var new_label = escape($('input[type=file]').val()).replace('C%3A%5Cfakepath%5C','');
		$('.mediaModal .headerInfo p').text("new_label");
	});
	
	// Reset form if photo upload failure
	$('.cloudinary-fileupload').bind('fail', function() {
		alert("Upload failed.");
		$('#loadingPhoto, .handhold').hide();
		$('button.close, .filedrop').show();		
	});
	
	// Submit uploaded avatar info to db when uploaded
	$('#addAvatar .cloudinary-fileupload').bind('fileuploaddone', function() {
		$('.filedrop input[type=submit]').click();
		$.cookie("avatar", "true");
	});
	
	// Explicitly set avatar cookie to false on Save click
	$('#saveUser, #saveUserAccount').click(function(){
		$.cookie("avatar", "false");
	});
	
	// Resize comment field on pet profile
	$('.commentEntry textarea').attr('rows', 6);

	// Resize edit pet text area
	$('.rightEditForm textarea').attr('rows', 17);

	// Populate character count on text entry fields
	if ($('textarea').length) {		
		activeArea = $('textarea').attr('id');
		var cnt = $('textarea').val().length;
		switch(activeArea) {
			case "shelter_description":
				var maxcnt = 770;
				break;
			case "pet_description":
				var maxcnt = 800;
				break;
			case "user_bio":
				var maxcnt = 480;
				break;
			case "micropost_content":
				var maxcnt = 240;
				break;
		};
		$('#char_count').text(maxcnt - cnt);
	};

	// Update character count on text entry fields
	$('#micropost_content, #user_bio, #pet_description, #shelter_description').keyup(function(){
		var cnt = $(this).val().length;
		switch(this.id) {
			case "shelter_description":
				var maxcnt = 770;
				break;
			case "pet_description":
				var maxcnt = 800;
				break;
			case "user_bio":
				var maxcnt = 480;
				break;
			case "micropost_content":
				var maxcnt = 240;
				break;
		};
		$('#char_count').text(maxcnt - cnt);
		if (maxcnt - cnt < 0) {
			$('input[name="commit"]').prop('disabled', true);
			$('#char_count').css('color','#ec520a');
		} else {
			$('input[name="commit"]').prop('disabled', false);
			$('#char_count').css('color','#000000');
		};
	});

	// Check if profile .headerInfo h1 field is too long and adjust font-size if needed
	if ($('.headerInfo h1').length) {
		var element = document.querySelector('.headerInfo h1');
		var default_height = 36;
		if (element.offsetHeight > default_height) {
			$('.headerInfo h1').css('font-size','20px');
		};
	};
	
	// Show Breed control on selection of species
	if ( name == "search[species_id]" ) {
		$('#search_breed_name').parent().parent().show();
		$('#new_search button[type="submit"], #new_search a:contains("Reset")').css('visibility','visible');
	};

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
		$.cookie("location", updatedLocation);
	};
	
	$('#new_search button[type="submit"], .match-me').click(function(){
		changeLocation();
	});

	// Disable Find Me, Match Me submit button if no location
	$('#search_location, #user_location').change(function(){
		if ( $(this).val() == "" ) {
			alert("Please enter a location");
		};
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
	
	// Automatically hide alert dialog after slight delay
	if($('.errorBox').is(':visible')) {
		$('#mainError').delay(3000).fadeOut('slow');
	};

	// Connect graphic buttons with hidden input elements
	$('div.btn-group[data-toggle-name]').each(function(){
		var group	 = $(this);
		var form		= group.parents('form').eq(0);
		var name		= group.attr('data-toggle-name');
		var hidden	= $('input[name="' + name + '"]', form);
		var current_value;
		$('button', group).each(function(){
			var button = $(this);
			button.on('click', function(){
				current_value = hidden.val();
				$.cookie("old_pet_state", current_value, { expires: 1, path: '/' }); // Use for pet state change dialogs in All/Managed Pets
				// Remove highlight required field on selection
				if ( group.hasClass('btn-required') ) {
					group.removeClass('btn-required');
				};
				// Show Find Pet controls on selection of species
				if ( name == "search[species_id]" ) {
					$('#search_breed_name').parent().parent().show();
					$('#new_search button[type="submit"], #new_search a:contains("Reset"), #changeLocation').css('visibility','visible');
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
	
				hidden.val($(this).val());

				// Show rescue / foster details if clicked
				if ( name == "pet[pet_state_id]" ) {
					if ( hidden.val() == "5" || hidden.val() == "6" ) {
						$('#refugeDetails').show();
					} else {
						$('#refugeDetails').hide();
						$('#pet_refuge_name, #pet_refuge_email').val("");
					};
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
				// Find Pet search icons
				if ( $('#new_search').length ) {
					$('#displayCount').hide();
					set_search_icons();
				};
			});
			if(button.val() == hidden.val()) {
				// Set clicked button to active
				button.addClass('active');
				// Remove highlight required field on reload
				if ( group.hasClass('btn-required') ) {
					group.removeClass('btn-required');
				};
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
				// Find Pet search icons
				if ( $('#new_search').length ) {
					$('#displayCount').hide();
					set_search_icons();
				};
				// Show rescue / foster details if clicked
				if ( name == "pet[pet_state_id]" ) {
					if ( hidden.val() == "5" || hidden.val() == "6" ) {
						$('#refugeDetails').show();
					} else {
						$('#refugeDetails').hide();
					};
				};
				
			};
		});
	});

	// Initialize date picker for pet intake date
	$("#pet_intake_date").datepicker({
		dateFormat: "yy-mm-dd",
		maxDate: getMaxDate()
	});

	function getMaxDate() {
		if ( $('#created_at').length ) {	// Set maximum selectable date to pet profile creation date
			var created = new Date($('#created_at').val());
			var today = new Date();
			var date_diff = Math.ceil(Math.abs(today - created) / 86400000);
			var maxDate = "-" + date_diff + "D";
		} else {
			var maxDate = "+0D";
		};
		return maxDate;
	}

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
		source: $('#search_breed_name').data('autocomplete-source'),
		change: function( event, ui ) {		// Check if entered content is valid and clear if not
			if ( ui.item == null || ui.item == undefined ) {
				$('#search_breed_name').val('');
				// alert('Please select a valid breed');
				$("#findPetAlert").dialog('open');
				$(".ui-dialog-title").text("Invalid Breed");
			};
		}
	});

	// Prevent Find Pet from being submitted on Enter keypress from breed selection
	$('#search_breed_name').keypress(function(e){
			if ( e.which == 13 ) return false;
	});

	// Hide search results count on text field interaction
	$('#search_breed_name').change(function(){
		$('#displayCount').hide();
	});
	
	$('#search_search_string').click(function(){
		$('#displayCount').hide();
	});

	function set_search_icons(){
		energy = $('input[id$="energy_level_id"]').val();
		affection = $('input[id$="affection_id"]').val();
		nature = $('input[id$="nature_id"]').val();
		species = $('input[id$="species_id"]').val();
		size = $('input[id$="size_id"]').val();
		age = $('input[id$="age_group"]').val();
		gender = $('input[id$="gender_id"]').val();
		switch(energy) {
			case "1":
				var newEnergy = "low";
				break;
			case "2":
				var newEnergy = "mid";
				break;
			case "3":
				var newEnergy = "high";
				break;
		};
		switch(affection) {
			case "1":
				var newAffection = "high";
				break;
			case "2":
				var newAffection = "mid";
				break;
			case "3":
				var newAffection = "low";
				break;
		};
		if ( species.length != 0 ) {
				switch(species) {
					case "1":
						var newSpecies = "Cat";
						break;
					case "2":
						var newSpecies = "Dog";
						break;
				};
			if ( nature.length != 0 ) {
				switch(nature) {
					case "1":
						var newNature = "low";
						break;
					case "2":
						var newNature = "mid";
						break;
					case "3":
						var newNature = "high";
						break;
				};
				$('#natureTile').removeClass('lowCatNatureIcon lowDogNatureIcon midCatNatureIcon midDogNatureIcon highCatNatureIcon highDogNatureIcon');
				$('#natureTile').addClass(newNature + newSpecies + "NatureIcon");
				$('#natureTile').show();
			} else {
				$('#natureTile').hide();
			};
			if ( size.length != 0 ) {
				switch(size) {
					case "1":
						var newSize = "low";
						break;
					case "2":
						var newSize = "mid";
						break;
					case "3":
						var newSize = "high";
						break;
				};
				$('#speciesSizeTile').removeClass('lowSizeCatIcon lowSizeDogIcon midSizeCatIcon midSizeDogIcon highSizeCatIcon highSizeDogIcon');
				$('#speciesSizeTile').addClass(newSize + "Size" + newSpecies + "Icon");
				$('#speciesSizeTile').show();
			} else {
				$('#speciesSizeTile').hide();
			};
		};
		if ( age.length != 0 && gender.length != 0 ) {
			switch(gender) {
				case "1":
					var newGender = "Male";
					break;
				case "2":
					var newGender = "Female";
					break;
			};
			$('#ageGenderTile').removeClass('youngMaleIcon youngFemaleIcon adultMaleIcon adultFemaleIcon seniorMaleIcon seniorFemaleIcon');
			$('#ageGenderTile').addClass(age + newGender + "Icon");
			$('#ageGenderTile').show();
		} else {
			$('#ageGenderTile').hide();
		};
		if ( energy.length != 0 ) {
			$('#energyTile').removeClass('lowEnergyIcon midEnergyIcon highEnergyIcon');
			$('#energyTile').addClass(newEnergy + "EnergyIcon");
			$('#energyTile').show();
		} else {
			$('#energyTile').hide();
		};
		if ( affection.length != 0 ) {
			$('#affectionTile').removeClass('lowAffectionIcon midAffectionIcon highAffectionIcon');
			$('#affectionTile').addClass(newAffection + "AffectionIcon");
			$('#affectionTile').show();
		} else {
			$('#affectionTile').hide();
		};
	};

	function set_dog_breeds(){
		$('[id$=breed_name]').autocomplete({
			minLength: 2,
			source: ["Affenpinscher", "Afghan Hound", "Aidi", "Airedale Terrier", "Akbash", "Akita Inu", "Alano Español", "Alapaha Blue Blood Bulldog", "Alaskan Klee Kai", "Alaskan Malamalute", "Alpine Dachsbracke", "Amenian Gampr", "American Akita", "American Bulldog", "American Cocker Spaniel", "American English Coonhound", "American Eskimo", "American Foxhound", "American Hairless Terrier", "American Leopard Hound", "American Mastiff", "American Pit Bull Terrier", "American Staffordshire Terrier", "American Water Spaniel", "Anatolian Shepherd", "Anglo-Français de Petite Vénerie", "Appenzeller Sennenhunde", "Ariege Pointer", "Ariegeois", "Armant", "Artois Hound", "Austrain Pinscher", "Australian Cattle", "Australian Kelpie", "Australian Shepherd", "Australian Silky Terrier", "Australian Stumpy Tail Cattle", "Australian Terrier", "Austrian Black and Tan Hound", "Azawakh", "Bakharwal", "Barbet", "Bascon Saintongeois", "Basenji", "Basque Shepherd", "Basset Artésien Normand", "Basset Bleu de Gascogne", "Basset Hound", "Bavarian Mountain Hound", "Beagle", "Beagle-Harrier", "Bearded Collie", "Beauceron", "Bedlington Terrier", "Belgian Groenendael", "Belgian Laekenois", "Belgian Malinois", "Belgian Sheepdog", "Belgian Tervuren", "Bergamasco Shepherd", "Berger Blanc Suisse", "Berger Picard", "Berner Laufhund", "Bernese Mountain", "Bichon Frise", "Billy", "Bisben", "Black and Tan Coonhound", "Black and Tan Virginia Foxhound", "Black Norwegian Elkhound", "Black Russian Terrier", "Blackmouth Cur", "Bloodhound", "Blue Lacy", "Bluetick Coonhound", "Boerboel", "Bohemian Shepherd", "Bolognese", "Border Collie", "Border Terrier", "Borzoi", "Bosnian Coarsehaired", "Boston Terrier", "Bouvier des Ardennes", "Bouvier des Flandres", "Boxer", "Boykin Spaniel", "Bracco Italiano", "Braque d'Auvergne", "Braque du Bourbonnais", "Braque Francais", "Braque Saint-Germain", "Brazilian Terrier", "Briard", "Briquet Griffon Vendéen", "Brittany", "Broholmer", "Bruno Jura Hound", "Brussels Griffon", "Bucovina Shepherd", "Bull and Terrier", "Bull Terrier", "Bulldog", "Bulldog Campeiro", "Bullmastiff", "Bully Kutta", "Cairn Terrier", "Canaan", "Canadian Eskimo", "Cane Corso", "Cardigan Welsh Corgi", "Carolina", "Carpathian Shepherd", "Catahoula Leopard", "Catalan Sheepdog", "Caucasian Ovcharka", "Caucasian Shepherd", "Cavalier King Charles Spaniel", "Central Asian Shepherd", "Cesky Fousek", "Cesky Terrier", "Chesapeake Bay Retriever", "Chien Français Blanc et Noir", "Chien Français Blanc et Orange", "Chien Français Tricolore", "Chien-gris", "Chihuahua", "Chilean Fox Terrier", "Chinese Chongqing", "Chinese Crested", "Chinese Imperial", "Chinese Shar-Pei", "Chinook", "Chippiparai", "Chow Chow", "Cierny Sery", "Cimarrón Uruguayo", "Cirneco dell'Etna", "Clumber Spaniel", "Cocker Spaniel", "Collie", "Combia", "Coton de Tulear", "Cretan Hound", "Croatian Sheepdog", "Curly-Coated Retriever", "Cursinu", "Czechoslovakian Vlcak", "Dachshund", "Dalmatian", "Dandie Dinmont Terrier", "Danish-Swedish Farmdog", "Deutsche Bracke", "Deutscher Wachtelhund", "Doberman Pinscher", "Dogo Argentino", "Dogo Guatemalteco", "Dogo Sardesco", "Dogue de Bordeaux", "Drentsche Patrijshond", "Drever", "Dunker", "Dutch Shepherd", "Dutch Smoushond", "East Siberian Laika", "East-European Shepherd", "Elo", "English Bulldog", "English Cocker Spaniel", "English Coonhound", "English Foxhound", "English Mastiff", "English Setter", "English Shepherd", "English Springer Spaniel", "English Toy Spaniel", "English Toy Terrier", "Entlebucher Mountain", "Epagnuel Bleu de Picardie", "Estonian Hound", "Estrela Mountain", "Eurasier", "Feist", "Field Spaniel", "Fila Brasileiro", "Finnish Hound", "Finnish Lapphund", "Finnish Spitz", "Flat-Coated Retriever", "Formosan Mountain", "French Brittany", "French Bulldog", "French Spaniel", "Galgo Español", "Georgian Shepherd", "German Longhaired Pointer", "German Pinscher", "German Shepherd", "German Shorthaired Pointer", "German Spaniel", "German Spitz", "German Wirehaired Pointer", "Giant Schnauzer", "Glen of Imaal Terrier", "Golden Retriever", "Gordon Setter", "Grand Anglo-Français Blanc et Noir", "Grand Anglo-Français Blanc et Orange", "Grand Anglo-Français Blanc et Tricolore", "Grand Basset Griffon Vendeen", "Grand Blue de Gascogne", "Grand Mastín de Borínquen", "Great Dane", "Great Pyrenees", "Greater Swiss Mountain", "Greek Harehound", "Greenland", "Greyhound", "Griffon Bleu de Gascogne", "Griffon Bruxellois", "Griffon Fauve de Bretagne", "Griffon Nivernais", "Gull Dong", "Gull Terr", "Hamiltonstovare", "Hanover Hound", "Harrier", "Havanese", "Himalayan Sheepdog", "Hokkaido", "Hortaya Borzaya", "Hovawart", "Hungarian Hound", "Huntaway", "Hygenhund", "Ibizan Hound", "Icelandic Sheepdog", "Indian Spitz", "Irish Red and White Setter", "Irish Setter", "Irish Terrier", "Irish Water Spaniel", "Irish Wolfhound", "Istrian Coarsehaired", "Istrian Shorthaired", "Italian Greyhound", "Jack Russell Terrier", "Jagdterrier", "Japanese Chin", "Japanese Spitz", "Japanese Terrier", "Jindo", "Jonangi", "Jämthund", "Kai Ken", "Kaikadi", "Kangal", "Kanni", "Karakachan", "Karelian Bear", "Karst Shepherd", "Keeshond", "Kerry Beagle", "Kerry Blue Terrier", "King Charles Spaniel", "King Shepherd", "Kintamani", "Kishu Ken", "Komondor", "Kooikerhondje", "Koolie", "Korean Jindo", "Korean Mastiff", "Kromfohrlander", "Kunming Wolfdog", "Kuvasz", "Kyi-Leo", "Labrador Husky", "Labrador Retriever", "Lagotto Romagnolo", "Lakeland Terrier", "Lancashire Heeler", "Landseer", "Lapponian Herder", "Large Munsterlander", "Leonberger", "Lhasa Apso", "Lithuanian Hound", "Longhaired Whippet", "Lowchen", "Magyar Agar", "Maltese", "Manchester Terrier", "Maremma", "Mastiff", "McNab", "Mexican Hairless", "Miniature American Shepherd", "Miniature Australian Shepherd", "Miniature Bull Terrier", "Miniature Fox Terrier", "Miniature Pinscher", "Miniature Schnauzer", "Mioritic", "Mix", "Montenegrin Mountain Hound", "Moscow Watchdog", "Mountain Cur", "Mountain View Cur", "Mucuchies", "Mudhol Hound", "Mudi", "Murray River Curly Coated Retrevier", "Neapolitan Mastiff", "New Zealand Heading", "Newfoundland", "Norfolk Terrier", "Norrbottenspets", "Northern Inuit", "Norwegian Buhund", "Norwegian Elkhound", "Norwegian Lundehund", "Norwich Terrier", "Nova Scotia Duck Tolling Retriever", "Old Croatian Sighthound", "Old Danish Pointer", "Old English Sheepdog", "Old English Terrier", "Old German Shepherd", "Old Time Farm Shepherd", "Olde English Bulldogge", "Otterhound", "Pachon Navarro", "Papillon", "Parson Russell Terrier", "Patterdale Terrier", "Pekingese", "Pembroke Welsh Corgi", "Perro de Presa Canario", "Perro de Presa Malloquin", "Peruvian Hairless", "Peruvian Inca Orchid", "Petit Basset Griffon Vendeen", "Petit Blue de Gascogne", "Phalene", "Pharaoh Hound", "Phu Quoc Ridgeback", "Picardy Spaniel", "Plott Hound", "Podenco Canario", "Pointer", "Polish Greyhound", "Polish Hound", "Polish Hunting", "Polish Lowland Sheepdog", "Polish Tatra Sheepdog", "Pomeranian", "Pont-Audemer Spaniel", "Poodle", "Porcelaine", "Portuguese Podengo", "Portuguese Podengo Pequeno", "Portuguese Pointer", "Portuguese Sheepdog", "Portuguese Water Dog", "Posavac Hound", "Prazsky Krysarik", "Pudelpointer", "Pug", "Puli", "Pumi", "Pungsan", "Pyrenean Mastiff", "Pyrenean Shepherd", "Rafeiro do Alentejo", "Rajapalayam", "Rampur Greyhound", "Rat Terrier", "Redbone Coonhound", "Rhodesian Ridgeback", "Rottweiler", "Rough Collie", "Russell Terrier", "Russian Spaneil", "Russian Toy", "Russo-European Laika", "Saarlooswolfhond", "Sabueso Espanol", "Saint-Usuge Spaniel", "Sakhalin Husky", "Saluki", "Samoyed", "Sapsali", "Sarplaninac", "Schapendoes", "Scheizerisher Niederlaufhund", "Schillerstovare", "Schipperke", "Schweizer Laufhund", "Scotch Collie", "Scottish Deerhound", "Scottish Terrier", "Sealyham Terrier", "Segugio Italiano", "Seppala Siberian Sleddog", "Serbian Hound", "Serbian Tricolour Hound", "Shar Pei", "Shetland Sheepdog", "Shiba Inu", "Shih Tzu", "Shikoku", "Shiloh Shepherd", "Siberian Husky", "Silken Windhound", "Silky Terrier", "Sinhala Hound", "Skye Terrier", "Sloughi", "Slovakian Roughhaired Pointer", "Slovensky Cuvac", "Slovensky Kopov", "Smalandsstovare", "Small Greek Domestic", "Small Munsterlander", "Small Munsterlander Pointer", "Smooth Collie", "Smooth Fox Terrier", "Wheaten Terrier", "South Russian Ovcharka", "Spanish Mastiff", "Spanish Water Dog", "Spinone Italiano", "Sportin Lucas Terrier", "St. Bernard", "Stabyhoun", "Staffordshire Bull Terrier", "Standard Schnauzer", "Stephens Cur", "Styian Coarsehaired Hound", "Sussex Spaniel", "Swedish Lapphund", "Swedish Vallhund", "Taigan", "Tamaskan", "Teddy Roosevelt Terrier", "Telomian", "Tenterfield Terrier", "Thai Bangkaew", "Thai Ridgeback", "Tibetan Mastiff", "Tibetan Spaniel", "Tibetan Terrier", "Tornjak", "Tosa", "Toy Fox Terrier", "Toy Manchester Terrier", "Transylvanian Hound", "Treeing Cur", "Treeing Tennessee Brindle", "Treeing Walker Coonhound", "Trigg Hound", "Tyrolean Hound", "Vizsla", "Volpino Italiano", "Weimaraner", "Welsh Sheepdog", "Welsh Springer Spaniel", "Welsh Terrier", "West Highland White Terrier", "West Siberian Laika", "Westphalian Dachsbracke", "Wetterhoun", "Whippet", "White English Bulldog", "White Shepherd", "Wire Fox Terrier", "Wirehaired Pointing Griffon", "Wirehaired Vizsla", "Xoloitzcuintli", "Yorkshire Terrier", "Terrier"]
		});
	};

	function set_cat_breeds(){
		$('[id$=breed_name]').autocomplete({
			minLength: 2,
			source: ["Abyssinian", "American Bobtail", "American Curl", "American Shorthair", "American Wirehair", "Balinese", "Bengal", "Birman", "Bombay", "British Blue", "British Longhair", "British Shorthair", "Burmese", "Burmilla", "Caliby", "Calico", "Calimanco", "Chartreux", "Chausie", "Chinese Domestic", "Colorpoint Shorthair", "Cornish Rex", "Cymric", "Devon Rex", "Domestic", "Donskoy", "Egyptian Mau", "European Burmese", "Exotic Shorthair", "Havana", "Highlander", "Highlander Shorthair", "Himalayan", "Household Pet", "Japanese Bobtail", "Javanese", "Khaomanee", "Korat", "Kurilian Bobtail", "LaPerm", "Maine Coon", "Maltese", "Manx", "Minskin", "Mix", "Munchkin", "Napoleon", "Nebelung", "Norwegian Forest", "Ocicat", "Ojos Azules", "Oriental Longhair", "Oriental Shorthair", "Persian", "Peterbald", "Pixiebob", "RagaMuffin", "Ragdoll", "Russian Blue", "Savannah", "Scottish Fold", "Selkirk Rex", "Serengeti", "Siamese", "Siberian", "Singapura", "Snowshoe", "Sokoke", "Somali", "Sphynx", "Tabby", "Thai", "Tonkinese", "Torbie", "Tortie", "Tortoiseshell", "Toyger", "Turkish Angora", "Turkish Van"]
		});
	};
	
});