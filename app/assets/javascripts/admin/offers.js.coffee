# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
toggleTargetingOptions = ->
  if $('#offer_target_all').is(':checked')
    $('#targeting_options').slideUp(200)
    $('#targeting_options input[type=checkbox]').attr('checked', false)
  else
    $('#targeting_options').slideDown(200)

$('#offer_target_all').change toggleTargetingOptions

