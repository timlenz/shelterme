$(function(){
	
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
    current_image.fadeOut(750, function() {
      current_image.css('z-index', 1).show().removeClass('active'); // reset z-index and unhide
      next_image.css('z-index', 3).addClass('active'); // move next image to top
    });
  });
  
  $('.fader-control[href="#prev"]').click(function(){
    var current_image = $('.fader .active');
    var prev_image = (current_image.prev().length > 0) ? current_image.prev() : $('.fader img:last');
    prev_image.css('z-index', 2).show(); // move prev image up in pile
    current_image.fadeOut(750, function() {
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
    // Slider controls
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
  
	// Pet Video Display slider controls
  if ( $('#videoDisplay').length ) {
    var thumbs = $('.outerVideo li').length;
    var thumb_width = $('.outerVideo li').outerWidth(true);
    var ol_width = thumbs * thumb_width;
    var slider_width = $('.outerVideo').outerWidth(true);
    var slide_right = "+=" + (thumb_width * 4);
    var slide_left = "-=" + (thumb_width * 4);
    // Set width of sliding element
    $('#videoDisplay ol').width(ol_width);
    // Slider controls
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

});