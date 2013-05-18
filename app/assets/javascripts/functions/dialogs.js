$(function() {
	
	// All Pets Delete
	$("#pets .managedDelete a").click(function(){
		deletePetLink = "";
		$("#deletePet").dialog('open');
		$("#deletePet").parent().find(".ui-dialog-buttonset button").last().focus();
		var active = $(this);
		deletePetLink	= $.trim(active.attr("href"));
		var name = $.trim($(this).parent().parent().find(".name").text());
		var code = $.trim($(this).parent().parent().find(".adminCode").text());
		if (name.length) {
			$(".ui-dialog-title").text("Delete " + name + "?");
			$("#deletePet .name").text(name);
		} else {
			$(".ui-dialog-title").text("Delete " + code + "?");
			$("#deletePet .name").text(code);
		};
		return false;
	});
	
  $("#deletePet").dialog({
		autoOpen: false,
		resizable: false,
		draggable: false,
		height: 250,
		width: 400,
		modal: true,
		buttons: {
      Cancel: function() {
        $(this).dialog("close");
      },
      "Delete": function() {
				$("#deletePet p, .ui-dialog-buttonset").hide();
				$("#deletePet .hide").show();
				var header = $(".ui-dialog-title").text();
				var newHeader = header.replace("Delete", "Deleting").replace("?", "...");
				$(".ui-dialog-title").text(newHeader);
				$.ajax({
				    url: deletePetLink,
				    type: 'DELETE',
						success: function() {
							location.reload();
						}
				});
      }
    }
  });

	// All Pets / Managed Pets Status Change
	// Dialog open in graphic_buttons.js
  $("#petStatusChange").dialog({
		autoOpen: false,
		resizable: false,
		draggable: false,
		height: 250,
		width: 400,
		modal: true,
		buttons: {
      Cancel: function() {
        $(this).dialog("close");
				// Reset active button to previously selected
	      old_button.addClass('active');
				new_button.removeClass('active');
      },
      "Change": function() {
				hidden_input.val(new_button.val());
				$.cookie("pet_state_change", old_button.val(), { expires: 1, path: '/' });
				$("#petStatusChange p, .ui-dialog-buttonset").hide();
				$("#petStatusChange .hide").show();
				$(".ui-dialog-title").text("Updating status...");
				$.ajax({
				    url: statusChangePetLink,
				    type: 'PUT',
						success: function() {
							location.reload();
						}
				});
      }
    }
  });

});