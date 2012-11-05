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
  
});