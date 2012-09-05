# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

@onCityChanged= ->
  city_id = $('#city_id').val()
  if city_id == ''
    url = ''
  else
    url = '/addresses/autocomplete_street_name/' + city_id
  $('#address_street').attr('data-autocomplete', url)