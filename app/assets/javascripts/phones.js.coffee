# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#phone_mobile').change ->
    mobilePhoneChange()
  mobilePhoneChange()

mobilePhoneChange = ->
  el = $('#phone_mobile_refix_group')
  if $('#phone_mobile').is(':checked')
    el.show()
  else
    el.hide()