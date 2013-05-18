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
  $('#shelters th a, #shelters .pagination a, #users th a, #users .pagination a, #pets th a, #pets .pagination a').bind('click', function () {
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
    var id_check = $('#search').val().replace(/[\W\_]+/, "").replace(" ", "");
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
    $.cookie("location", newLocation);
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
    }  else {
      start_state = $(this).html();
      $(this).html("Collapse");
    };
  });

  // Show Add Pet Photo modal dialog if no pet photos exist for current pet
  if ($('.noPhoto').length) {
    $('#photoClick').click();
  };
  
  // Hide Add Media buttons if user agent is iPad (and other tablets) - added iPhone|iPod|Android until mobile apps ready
  if ( $('.addMedia').length ) {
    if ( navigator.userAgent.match(/iPhone|iPod|Android|iPad|Tablet/i) != null ) {
      $('.mediaButtons input').prop('disabled', true);
    };
  };
  
  // Hide Add Pet, Add Photo, Add Video if user agent is iPad (and other tablets) - added iPhone|iPod|Android until mobile apps ready
  if ( $('#addPet, .addMedia').length) {
    if ( navigator.userAgent.match(/iPhone|iPod|Android|iPad|Tablet/i) != null ) {
      $('#addPet, .addMedia .mediaButtons, .addMedia p:first').hide();
			$('#tabletAlert').show();
    };
  };

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
    $.cookie("matchme", "true");
  });
  
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
      $('#char_count').css('color','#999999');
    };
  });

  // Check if profile .headerInfo h1 field is too long and adjust font-size if needed
  if ($('.headerInfo h1').length) {
    var element = document.querySelector('.headerInfo h1');
    var default_height = 36;
    if (element.offsetHeight > default_height) {
      $('.headerInfo h1').css('font-size','22px');
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
  
});