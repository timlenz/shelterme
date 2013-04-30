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

  // Hide nav spinner on page load
  $('.navSpinner').hide();
  $('.navLogo').show();

  // Show nav spinner on page navigation
  $('a[href^="/"], #addPet input[type="submit"]').click(function(){
    $('.navLogo').hide();
    $('.navSpinner').animate({
      opacity: "show"
    }, "750");
    if ( $('.pagination').length ) {
      $('.navSpinner').hide();
      $('.navLogo').show();
    };
  });
  
  // Hide nav spinner on admin header click
  $('.adminView .asc, .adminView .desc').click(function(){
    $('.navSpinner').hide();
    $('.navLogo').show();
  });

	// Hide nav spinner on spawned window link click
	$('a[target^="t"], a[target="_blank"]').click(function(){
    $('.navSpinner').hide();
    $('.navLogo').show();
  });

  // Hover state on Join, Sign In header buttons
  $('.signInit').mouseover(function(){
    $(this).find("a").css("color","");
  }).mouseout(function(){
    $(this).find("a").css("color","#722705");
  });
  
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
    var tile_width = $('.small-pet-tile').outerWidth(true);
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
  
  // Pet Video Display controls
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
  
  // Reposition footer when no history slider is present
  if ( $('#history').length == 0 ) {
    $('#sm').css('margin-bottom','-100px');
    $('.push').css('height','100px');
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
  
  // Hide Add Media buttons if user agent is iPad (and other tablets)
  if ( $('.addMedia').length ) {
    if ( navigator.userAgent.match(/iPad|Tablet/i) != null ) {
      $('.mediaButtons input').prop('disabled', true);
    };
  };
  
  // Hide Add Pet if user agent is iPad (and other tablets)
  if ( $('#addPet').length) {
    if ( navigator.userAgent.match(/iPad|Tablet/i) != null ) {
      $('#addPet').hide();
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
    tab_links.bind('click', function(){
      current_tab = $(this).attr('href');
      $.cookie("active_tab", current_tab);
    });
  };

  // Connect radio buttons with hidden input elements
  $('div.btn-group[data-toggle-name]').each(function(){
    var group   = $(this);
    var form    = group.parents('form').eq(0);
    var name    = group.attr('data-toggle-name');
    var hidden  = $('input[name="' + name + '"]', form);
    var current_value;
    $('button', group).each(function(){
      var button = $(this);
      button.bind('click', function(){
        current_value = hidden.val();
				// Remove highlight required field on selection
				if ( group.hasClass('btn-required') ) {
					group.removeClass('btn-required');
				};
        // Set value of clicked element to hidden control
        hidden.val($(this).val());
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
        // Submit pet state changes on click for Managed Pets, Admin Pets views
        if($('#managed_pets, #pets').length) {
          $(this).parent().parent().find("input[type=submit]").click();
        };
        // Set cookie when pet state is changed
        if(name == 'pet[pet_state_id]') {
          $.cookie("pet_state_change", current_value, { expires: 1, path: '/' });
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
      };
    });
  });

  function set_dog_breeds(){
    $('[id$=breed_name]').autocomplete({
      minLength: 2,
      source: ["Affenpinscher", "Afghan Hound", "Aidi", "Airedale Terrier", "Akbash", "Akita Inu", "Alano Español", "Alapaha Blue Blood Bulldog", "Alaskan Klee Kai", "Alaskan Malamalute", "Alpine Dachsbracke", "Amenian Gampr", "American Akita", "American Bulldog", "American Cocker Spaniel", "American English Coonhound", "American Eskimo", "American Foxhound", "American Hairless Terrier", "American Leopard Hound", "American Mastiff", "American Pit Bull Terrier", "American Staffordshire Terrier", "American Water Spaniel", "Anatolian Shepherd", "Anglo-Français de Petite Vénerie", "Appenzeller Sennenhunde", "Ariege Pointer", "Ariegeois", "Armant", "Artois Hound", "Austrain Pinscher", "Australian Cattle", "Australian Kelpie", "Australian Shepherd", "Australian Silky Terrier", "Australian Stumpy Tail Cattle", "Australian Terrier", "Austrian Black and Tan Hound", "Azawakh", "Bakharwal", "Barbet", "Bascon Saintongeois", "Basenji", "Basque Shepherd", "Basset Artésien Normand", "Basset Bleu de Gascogne", "Basset Hound", "Bavarian Mountain Hound", "Beagle", "Beagle-Harrier", "Bearded Collie", "Beauceron", "Bedlington Terrier", "Belgian Groenendael", "Belgian Laekenois", "Belgian Malinois", "Belgian Sheepdog", "Belgian Tervuren", "Bergamasco Shepherd", "Berger Blanc Suisse", "Berger Picard", "Berner Laufhund", "Bernese Mountain", "Bichon Frise", "Billy", "Bisben", "Black and Tan Coonhound", "Black and Tan Virginia Foxhound", "Black Norwegian Elkhound", "Black Russian Terrier", "Blackmouth Cur", "Bloodhound", "Blue Lacy", "Bluetick Coonhound", "Boerboel", "Bohemian Shepherd", "Bolognese", "Border Collie", "Border Terrier", "Borzoi", "Bosnian Coarsehaired", "Boston Terrier", "Bouvier des Ardennes", "Bouvier des Flandres", "Boxer", "Boykin Spaniel", "Bracco Italiano", "Braque d'Auvergne", "Braque du Bourbonnais", "Braque Francais", "Braque Saint-Germain", "Brazilian Terrier", "Briard", "Briquet Griffon Vendéen", "Brittany", "Broholmer", "Bruno Jura Hound", "Brussels Griffon", "Bucovina Shepherd", "Bull and Terrier", "Bull Terrier", "Bulldog", "Bulldog Campeiro", "Bullmastiff", "Bully Kutta", "Cairn Terrier", "Canaan", "Canadian Eskimo", "Cane Corso", "Cardigan Welsh Corgi", "Carolina", "Carpathian Shepherd", "Catahoula Leopard", "Catalan Sheepdog", "Caucasian Ovcharka", "Caucasian Shepherd", "Cavalier King Charles Spaniel", "Central Asian Shepherd", "Cesky Fousek", "Cesky Terrier", "Chesapeake Bay Retriever", "Chien Français Blanc et Noir", "Chien Français Blanc et Orange", "Chien Français Tricolore", "Chien-gris", "Chihuahua", "Chilean Fox Terrier", "Chinese Chongqing", "Chinese Crested", "Chinese Imperial", "Chinese Shar-Pei", "Chinook", "Chippiparai", "Chow Chow", "Cierny Sery", "Cimarrón Uruguayo", "Cirneco dell'Etna", "Clumber Spaniel", "Cocker Spaniel", "Collie", "Combia", "Coton de Tulear", "Cretan Hound", "Croatian Sheepdog", "Curly-Coated Retriever", "Cursinu", "Czechoslovakian Vlcak", "Dachshund", "Dalmatian", "Dandie Dinmont Terrier", "Danish-Swedish Farmdog", "Deutsche Bracke", "Deutscher Wachtelhund", "Doberman Pinscher", "Dogo Argentino", "Dogo Guatemalteco", "Dogo Sardesco", "Dogue de Bordeaux", "Drentsche Patrijshond", "Drever", "Dunker", "Dutch Shepherd", "Dutch Smoushond", "East Siberian Laika", "East-European Shepherd", "Elo", "English Bulldog", "English Cocker Spaniel", "English Coonhound", "English Foxhound", "English Mastiff", "English Setter", "English Shepherd", "English Springer Spaniel", "English Toy Spaniel", "English Toy Terrier", "Entlebucher Mountain", "Epagnuel Bleu de Picardie", "Estonian Hound", "Estrela Mountain", "Eurasier", "Field Spaniel", "Fila Brasileiro", "Finnish Hound", "Finnish Lapphund", "Finnish Spitz", "Flat-Coated Retriever", "Formosan Mountain", "French Brittany", "French Bulldog", "French Spaniel", "Galgo Español", "Georgian Shepherd", "German Longhaired Pointer", "German Pinscher", "German Shepherd", "German Shorthaired Pointer", "German Spaniel", "German Spitz", "German Wirehaired Pointer", "Giant Schnauzer", "Glen of Imaal Terrier", "Golden Retriever", "Gordon Setter", "Grand Anglo-Français Blanc et Noir", "Grand Anglo-Français Blanc et Orange", "Grand Anglo-Français Blanc et Tricolore", "Grand Basset Griffon Vendeen", "Grand Blue de Gascogne", "Grand Mastín de Borínquen", "Great Dane", "Great Pyrenees", "Greater Swiss Mountain", "Greek Harehound", "Greenland", "Greyhound", "Griffon Bleu de Gascogne", "Griffon Bruxellois", "Griffon Fauve de Bretagne", "Griffon Nivernais", "Gull Dong", "Gull Terr", "Hamiltonstovare", "Hanover Hound", "Harrier", "Havanese", "Himalayan Sheepdog", "Hokkaido", "Hortaya Borzaya", "Hovawart", "Hungarian Hound", "Huntaway", "Hygenhund", "Ibizan Hound", "Icelandic Sheepdog", "Indian Spitz", "Irish Red and White Setter", "Irish Setter", "Irish Terrier", "Irish Water Spaniel", "Irish Wolfhound", "Istrian Coarsehaired", "Istrian Shorthaired", "Italian Greyhound", "Jack Russell Terrier", "Jagdterrier", "Japanese Chin", "Japanese Spitz", "Japanese Terrier", "Jindo", "Jonangi", "Jämthund", "Kai Ken", "Kaikadi", "Kangal", "Kanni", "Karakachan", "Karelian Bear", "Karst Shepherd", "Keeshond", "Kerry Beagle", "Kerry Blue Terrier", "King Charles Spaniel", "King Shepherd", "Kintamani", "Kishu Ken", "Komondor", "Kooikerhondje", "Koolie", "Korean Jindo", "Korean Mastiff", "Kromfohrlander", "Kunming Wolfdog", "Kuvasz", "Kyi-Leo", "Labrador Husky", "Labrador Retriever", "Lagotto Romagnolo", "Lakeland Terrier", "Lancashire Heeler", "Landseer", "Lapponian Herder", "Large Munsterlander", "Leonberger", "Lhasa Apso", "Lithuanian Hound", "Longhaired Whippet", "Lowchen", "Magyar Agar", "Maltese", "Manchester Terrier", "Maremma", "Mastiff", "McNab", "Mexican Hairless", "Miniature American Shepherd", "Miniature Australian Shepherd", "Miniature Bull Terrier", "Miniature Fox Terrier", "Miniature Pinscher", "Miniature Schnauzer", "Mioritic", "Mix", "Montenegrin Mountain Hound", "Moscow Watchdog", "Mountain Cur", "Mountain View Cur", "Mucuchies", "Mudhol Hound", "Mudi", "Murray River Curly Coated Retrevier", "Neapolitan Mastiff", "New Zealand Heading", "Newfoundland", "Norfolk Terrier", "Norrbottenspets", "Northern Inuit", "Norwegian Buhund", "Norwegian Elkhound", "Norwegian Lundehund", "Norwich Terrier", "Nova Scotia Duck Tolling Retriever", "Old Croatian Sighthound", "Old Danish Pointer", "Old English Sheepdog", "Old English Terrier", "Old German Shepherd", "Old Time Farm Shepherd", "Olde English Bulldogge", "Otterhound", "Pachon Navarro", "Papillon", "Parson Russell Terrier", "Patterdale Terrier", "Pekingese", "Pembroke Welsh Corgi", "Perro de Presa Canario", "Perro de Presa Malloquin", "Peruvian Hairless", "Peruvian Inca Orchid", "Petit Basset Griffon Vendeen", "Petit Blue de Gascogne", "Phalene", "Pharaoh Hound", "Phu Quoc Ridgeback", "Picardy Spaniel", "Plott Hound", "Podenco Canario", "Pointer", "Polish Greyhound", "Polish Hound", "Polish Hunting", "Polish Lowland Sheepdog", "Polish Tatra Sheepdog", "Pomeranian", "Pont-Audemer Spaniel", "Poodle", "Porcelaine", "Portuguese Podengo", "Portuguese Podengo Pequeno", "Portuguese Pointer", "Portuguese Sheepdog", "Portuguese Water Dog", "Posavac Hound", "Prazsky Krysarik", "Pudelpointer", "Pug", "Puli", "Pumi", "Pungsan", "Pyrenean Mastiff", "Pyrenean Shepherd", "Rafeiro do Alentejo", "Rajapalayam", "Rampur Greyhound", "Rat Terrier", "Redbone Coonhound", "Rhodesian Ridgeback", "Rottweiler", "Rough Collie", "Russell Terrier", "Russian Spaneil", "Russian Toy", "Russo-European Laika", "Saarlooswolfhond", "Sabueso Espanol", "Saint-Usuge Spaniel", "Sakhalin Husky", "Saluki", "Samoyed", "Sapsali", "Sarplaninac", "Schapendoes", "Scheizerisher Niederlaufhund", "Schillerstovare", "Schipperke", "Schweizer Laufhund", "Scotch Collie", "Scottish Deerhound", "Scottish Terrier", "Sealyham Terrier", "Segugio Italiano", "Seppala Siberian Sleddog", "Serbian Hound", "Serbian Tricolour Hound", "Shar Pei", "Shetland Sheepdog", "Shiba Inu", "Shih Tzu", "Shikoku", "Shiloh Shepherd", "Siberian Husky", "Silken Windhound", "Silky Terrier", "Sinhala Hound", "Skye Terrier", "Sloughi", "Slovakian Roughhaired Pointer", "Slovensky Cuvac", "Slovensky Kopov", "Smalandsstovare", "Small Greek Domestic", "Small Munsterlander", "Small Munsterlander Pointer", "Smooth Collie", "Smooth Fox Terrier", "Soft Coated Wheaten Terrier", "South Russian Ovcharka", "Spanish Mastiff", "Spanish Water Dog", "Spinone Italiano", "Sportin Lucas Terrier", "St. Bernard", "Stabyhoun", "Staffordshire Bull Terrier", "Standard Schnauzer", "Stephens Cur", "Styian Coarsehaired Hound", "Sussex Spaniel", "Swedish Lapphund", "Swedish Vallhund", "Taigan", "Tamaskan", "Teddy Roosevelt Terrier", "Telomian", "Tenterfield Terrier", "Thai Bangkaew", "Thai Ridgeback", "Tibetan Mastiff", "Tibetan Spaniel", "Tibetan Terrier", "Tornjak", "Tosa", "Toy Fox Terrier", "Toy Manchester Terrier", "Transylvanian Hound", "Treeing Cur", "Treeing Tennessee Brindle", "Treeing Walker Coonhound", "Trigg Hound", "Tyrolean Hound", "Vizsla", "Volpino Italiano", "Weimaraner", "Welsh Sheepdog", "Welsh Springer Spaniel", "Welsh Terrier", "West Highland White Terrier", "West Siberian Laika", "Westphalian Dachsbracke", "Wetterhoun", "Whippet", "White English Bulldog", "White Shepherd", "Wire Fox Terrier", "Wirehaired Pointing Griffon", "Wirehaired Vizsla", "Xoloitzcuintli", "Yorkshire Terrier"]
    });
  };

  function set_cat_breeds(){
    $('[id$=breed_name]').autocomplete({
      minLength: 2,
      source: ["Abyssinian", "American Bobtail", "American Curl", "American Shorthair", "American Wirehair", "Balinese", "Bengal", "Birman", "Bombay", "British Blue", "British Longhair", "British Shorthair", "Burmese", "Burmilla", "Caliby", "Calico", "Calimanco", "Chartreux", "Chausie", "Chinese Domestic", "Colorpoint Shorthair", "Cornish Rex", "Cymric", "Devon Rex", "Domestic", "Donskoy", "Egyptian Mau", "European Burmese", "Exotic Shorthair", "Havana", "Highlander", "Highlander Shorthair", "Himalayan", "Household Pet", "Japanese Bobtail", "Javanese", "Khaomanee", "Korat", "Kurilian Bobtail", "LaPerm", "Maine Coon", "Maltese", "Manx", "Minskin", "Mix", "Munchkin", "Napoleon", "Nebelung", "Norwegian Forest", "Ocicat", "Ojos Azules", "Oriental Longhair", "Oriental Shorthair", "Persian", "Peterbald", "Pixiebob", "RagaMuffin", "Ragdoll", "Russian Blue", "Savannah", "Scottish Fold", "Selkirk Rex", "Serengeti", "Siamese", "Siberian", "Singapura", "Snowshoe", "Sokoke", "Somali", "Sphynx", "Tabby", "Thai", "Tonkinese", "Torbie", "Tortie", "Tortoiseshell", "Toyger", "Turkish Angora", "Turkish Van"]
    });
  };
  
  // Populate footer quote
  $('div .quote').html(function() {
    var randSeed = Math.floor(Math.random()*53);
    var quotes = ["I have found the paradox that if I love until it hurts, then there is no hurt, but only more love. -Mother Teresa",
                  "Unless someone like you cares a whole awful lot, nothing is going to get better.  It's not. -Dr. Seuss",
                  "Act as if what you do makes a difference.  It does. -William James",
                  "Being good is commendable, but only when it is combined with doing good is it useful. -Unknown",
                  "The purpose of life is not to be happy - but to matter, to be productive, to be useful, to have it make some difference that you have lived at all. -Leo Rosten",
                  "It is the greatest of all mistakes to do nothing because you can only do little - do what you can. -Sydney Smith",
                  "The true meaning of life is to plant trees, under whose shade you do not expect to sit. -Nelson Henderson",
                  "Dare to reach out your hand into the darkness, to pull another hand into the light. -Norman B. Rice",
                  "The difference between a helping hand and an outstretched palm is a twist of the wrist. -Laurence Leamer",
                  "I am only one, but I am one.  I cannot do everything, but I can do something.  And I will not let what I cannot do interfere with what I can do. -Edward Everett Hale",
                  "How far that little candle throws his beams! So shines a good deed in a naughty world. -William Shakespeare",
                  "I expect to pass through life but once.  If therefore, there be any kindness I can show, or any good thing I can do to any fellow being, let me do it now, and not defer or neglect it, as I shall not pass this way again. -William Penn",
                  "How wonderful it is that nobody need wait a single moment before starting to improve the world. -Anne Frank",
                  "Be an opener of doors for such as come after thee, and do not try to make the universe a blind alley. -Ralph Waldo Emerson",
                  "We can do no great things, only small things with great love. -Mother Teresa",
                  "Nobody can do everything, but everyone can do something. -Unknown",
                  "Everyone thinks of changing the world, but no one thinks of changing himself. -Leo Tolstoy",
                  "Nobody made a greater mistake than he who did nothing because he could only do a little. -Edmund Burke",
                  "It seems to me that any full grown, mature adult would have a desire to be responsible, to help where he can in a world that needs so very much, that threatens us so very much. -Norman Lear",
                  "Live simply that others might simply live. -Elizabeth Ann Seton",
                  "We make a living by what we get, but we make a life by what we give. -Winston Churchill",
                  "I wondered why somebody didn't do something.  Then I realized, I am somebody. -Unknown",
                  "Do not commit the error, common among the young, of assuming that if you cannot save the whole of mankind you have failed. -Jan de Hartog",
                  "Love the earth and sun and animals, Despise riches, give alms to everyone that asks, Stand up for the stupid and crazy, Devote your income and labor to others... And your very flesh shall be a great poem. -Walt Whitman",
                  "Thousands of candles can be lighted from a single candle, and the life of the candle will not be shortened.  Happiness never decreases by being shared. -Buddha",
                  "Our prayers for others flow more easily than those for ourselves.  This shows we are made to live by charity. -C.S.Lewis",
                  "Not only must we be good, but we must also be good for something. -Henry David Thoreau",
                  "Sometimes a man imagines that he will lose himself if he gives himself, and keep himself if he hides himself.  But the contrary takes place with terrible exactitude. -Ernest Hello",
                  "Real joy comes not from ease or riches or from the praise of men, but from doing something worthwhile. -Wilfred Grenfell",
                  "Things of the spirit differ from things material in that the more you give the more you have. -Christopher Morley",
                  "A bone to the dog is not charity.  Charity is the bone shared with the dog, when you are just as hungry as the dog. -Jack London",
                  "Service to others is the rent you pay for your room here on earth. -Muhammed Ali",
                  "Do not let what you cannot do interfere with what you can do. -John Wooden",
                  "You give but little when you give of your possessions.  It is when you give of yourself that you truly give. -Kahlil Gibran",
                  "Great opportunities to help others seldom come, but small ones surround us every day. -Sally Koch",
                  "If you do a good job for others, you heal yourself at the same time, because a dose of joy is a spiritual cure. -Dietrich Bonhoeffer",
                  "No joy can equal the joy of serving others. -Sai Baba",
                  "What we have done for ourselves alone dies with us; what we have done for others and the world remains and is immortal. -Albert Pike",
                  "I've learned that you shouldn't go through life with a catchers mitt on both hands.  You need to be able to throw something back. -Maya Angelou",
                  "The greatest good you can do for another is not just to share your riches but to reveal to him his own. -Benjamin Disraeli",
                  "The work an unknown good man has done is like a vein of water flowing hidden underground, secretly making the ground green. -Thomas Carlyle",
                  "If the world seems cold to you, kindle fires to warm it. -Lucy Larcom",
                  "Every action in our lives touches on some chord that will vibrate in eternity. -Edwin Hubbel Chapin",
                  "The world is moved along, not only by the mighty shoves of its heroes, but also by the aggregate of tiny pushes of each honest worker. -Helen Keller",
                  "There are many in the world who are dying for a piece of bread, but there are many more dying for a little love. -Mother Teresa",
                  "If you pursue good with labor, the labor passes away but the good remains; if you pursue evil with pleasure, the pleasure passes away and the evil remains. -Cicero",
                  "If you think you are too small to be effective, you have never been in bed with a mosquito. -Betty Reese",
                  "There are two ways of spreading light - to be the candle or the mirror that reflects it. -Edith Wharton",
                  "Every man feels instinctively that all the beautiful sentiments in the world weigh less than a single lovely action. -Lowell",
                  "Generosity is not giving me that which I need more than you do, but it is giving me that which you need more than I do. -Kahlil Gibran",
                  "Never doubt that a small group of thoughtful, committed citizens can change the world. -Margaret Mead",
                  "The difference between friends and pets is that friends we allow into our company, pets we allow into our solitude. -Robert Brault"]
    var randQuote = quotes[randSeed];
    return randQuote;
  });
  
});