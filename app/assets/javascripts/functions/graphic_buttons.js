$(function(){

	// Connect graphic buttons with hidden input elements
	$('div.btn-group[data-toggle-name]').each(function(){
	  var group   = $(this);
	  var form    = group.parents('form').eq(0);
	  var name    = group.attr('data-toggle-name');
	  var hidden  = $('input[name="' + name + '"]', form);
	  var current_value;
	  $('button', group).each(function(){
	    var button = $(this);
	    button.on('click', function(){
	      current_value = hidden.val();
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
				// Submit pet state changes on click for Managed Pets, Admin Pets views
				if($('#managed_pets, #pets').length) {
				  $(this).parent().parent().find("input[type=submit]").click();
				};
				// Set cookie when pet state is changed
				if(name == 'pet[pet_state_id]') {
				  $.cookie("pet_state_change", current_value, { expires: 1, path: '/' });
				};
	      // // Submit pet state changes on click for Managed Pets, Admin Pets views
	      // 	      if($('#managed_pets, #pets').length && current_value != $(this).val()) {
	      // 					hidden.val($(this).val());
	      // 					$(this).parent().parent().find("input[type=submit]").click();
	      // 					
	      // 	        statusChangePetLink = "";
	      // 					$("#petStatusChange").dialog('open');
	      // 					var root = $("#petStatusChange").parent();
	      // 					root.find(".ui-dialog-buttonset button").last().focus();
	      // 					statusChangePetLink = $.trim(form.attr('action'));
	      // 					var name = $.trim($(this).parents('tr').find(".name").text());
	      // 					var code = $.trim($(this).parents('tr').find(".adminCode").text());
	      // 					old_button = group.children('button[value="'+ current_value +'"]');
	      // 					new_button = button;
	      // 					hidden_input = hidden;
	      // 					switch(current_value) {
	      // 						case "1":
	      // 							var current = "Available";
	      // 							break;
	      // 						case "2":
	      // 							var current = "Adopted";
	      // 							break;
	      // 						case "3":
	      // 							var current = "Unavailable";
	      // 							break;
	      // 						case "4":
	      // 							var current = "Absent";
	      // 							break;
	      // 					};
	      // 					$("#petStatusChange .current").text(current);
	      // 					$("#petStatusChange .new").text($(this).text());
	      // 					if (name.length) {
	      // 						root.find(".ui-dialog-title").text("Update " + name + "?");
	      // 						$("#petStatusChange .name").text(name);
	      // 					} else {
	      // 						root.find(".ui-dialog-title").text("Update " + code + "?");
	      // 						$("#petStatusChange .name").text(code);
	      // 					};
	      // 	      } else {
	      // 		
	      // 					// Set value of clicked element to hidden control for all instances
	      // 					// other than pet state changes for Managed/All Pet views
	      // 		      hidden.val($(this).val());
	      // 				};
	
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

});