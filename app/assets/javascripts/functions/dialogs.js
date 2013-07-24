$(function() {
  
  // All Pets Delete
  $("#pets .managedDelete a").click(function(){
    $("#deletePet").dialog('open');
    deletePetLink = "";
    $("#deletePet").parent().find(".ui-dialog-buttonset button").last().focus(); // Set focus on "delete" button in dialog
    var active = $(this);
    deletePetLink  = $.trim(active.attr("href"));
    var name = $.trim($(this).parents('tbody').find(".name").text());
    var code = $.trim($(this).parents('tbody').find(".adminCode").text());
    if (name.length) {
      $(".ui-dialog-title").text("Delete " + name + "?");
      $("#deletePet .name").text(name);
    } else {
      $(".ui-dialog-title").text("Delete " + code + "?");
      $("#deletePet .name").text(code);
    };
    return false;	// prevents the default behavior
  });
  
  $("#deletePet").dialog({
    autoOpen: false,
    resizable: false,
    draggable: false,
    closeOnEscape: false,
    width: 400,
    modal: true,
    buttons: {
      Cancel: function() {
        $(this).dialog("close");
      },
      "Delete": function() {
        $("#deletePet p, .ui-dialog-buttonset").hide();
        $("#deletePet .hide").show();
        $(".ui-dialog-title").text("Deleting...");
				$.cookie("delete_managed_pet", "true", { expires: 1, path: '/' }); // cookie used in controller to redirect view
        $.ajax({
            url: deletePetLink,
            type: 'POST',
						data: {"_method":"delete"},
            complete: function() {
              location.reload();
            }
        });
      }
    }
  });

  // All Pets / Managed Pets Status Change
  
  // Submit pet state changes on click for Managed Pets, Admin Pets views
  $('#pets button:not(.active), #managed_pets button:not(.active)').click(function(){
    $("#petStatusChange").dialog('open');
		$(this).parents('form').find('#pet_refuge_name, #pet_refuge_contact').val('');
    var root = $("#petStatusChange").parent();
    root.find(".ui-dialog-buttonset button").last().focus(); // Set focus on "change" button in dialog
    statusChangeLink = $(this).parents('form').find("input[type=submit]");
    var name = $.trim($(this).parents('tbody').find(".name").text());
    var code = $.trim($(this).parents('tbody').find(".adminCode").text());
    old_value = $.cookie("old_pet_state");
    old_button = $(this).siblings('button[value="'+ old_value +'"]');
    new_button = $(this);
    new_value = $(this).val();
    hidden_input = $(this).parents('form').find("#pet_pet_state_id");
		refuge_name = $(this).parents('form').find("#pet_refuge_name");
		refuge_contact = $(this).parents('form').find("#pet_refuge_contact");
    switch(old_value) {
      case "1":
        var old = "Available";
        break;
      case "2":
        var old = "Adopted";
        break;
      case "3":
        var old = "Unavailable";
        break;
      case "4":
        var old = "Absent";
        break;
      case "5":
        var old = "Fostered";
        break;
      case "6":
        var old = "Rescued";
        break;
    };
    $("#petStatusChange .old").text(old);
    $("#petStatusChange .new").text($(this).text());
    if (name.length) {
      root.find(".ui-dialog-title").text("Update " + name + "?");
      $("#petStatusChange .name").text(name);
    } else {
      root.find(".ui-dialog-title").text("Update " + code + "?");
      $("#petStatusChange .name").text(code);
    };
    if ( new_value == '5' || new_value == '6' ){
      $('#refugeDetails').show();
    };
  });
  
  $("#petStatusChange").dialog({
    autoOpen: false,
    resizable: false,
    draggable: false,
    closeOnEscape: false,
    width: 400,
    modal: true,
    buttons: {
      Cancel: function() {
        $(this).dialog("close");
        // Reset buttons to previously selected
        old_button.addClass('active');
        new_button.removeClass('active');
        // Reset hidden value to previous value
        hidden_input.val(old_value);
      },
      "Change": function() {
        $.cookie("pet_state_change", new_value, { expires: 1, path: '/' }); // tracks pet state change for journaling
				$.cookie("managed_pets", "true", { expires: 1, path: '/' }); // used in controller to redirect view
				refuge_name.val($('#refuge_name').val());
				refuge_contact.val($('#refuge_contact').val());
				$('#search').val('');	// clear search dialog
        $(this).dialog("close");	// must close dialog before firing click event
				statusChangeLink.click();
      }
    }
  });

	// Find Pet invalid breed selection
	$('#findPetAlert').dialog({
		autoOpen: false,
    resizable: false,
    draggable: false,
		width: 400,
    modal: true,
		buttons: {
      Ok: function() {
        $( this ).dialog( "close" );
      }
    }
	});

});