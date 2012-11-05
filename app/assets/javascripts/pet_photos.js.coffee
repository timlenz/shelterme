# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  new PhotoCropper()
  
class PhotoCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1.5
      setSelect: [0, 0, 300, 200]
      onSelect: @update
      onChange: @update
    
  update: (coords) =>
    $('#pet_photo_crop_x').val(coords.x)
    $('#pet_photo_crop_y').val(coords.y)
    $('#pet_photo_crop_w').val(coords.w)
    $('#pet_photo_crop_h').val(coords.h)