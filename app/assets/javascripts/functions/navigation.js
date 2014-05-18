$(function(){

  // Hide nav spinner on page load
  $('.navSpinner').hide();
  $('.navLogo').show();

	// Hide nav spinner on ESC key-press
	$(document).keyup(function(e) {
	  if (e.keyCode == 27) {   // esc
			$('.navSpinner').hide();
		  $('.navLogo').show();
		}
	});

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
  
  // Hide nav spinner on pet list export click
	$('.headerEdit .pet-export').click(function(){
	alert("This may take a few minutes. Please wait for the file to download. Do not navigate away from this page.");
    $('.navSpinner').hide();
    $('.navLogo').show();
  });

  // Hover state on Join, Sign In header buttons
  $('.signInit').mouseover(function(){
    $(this).find("a").css("color","");
  }).mouseout(function(){
    $(this).find("a").css("color","#722705");
  });

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
  
});