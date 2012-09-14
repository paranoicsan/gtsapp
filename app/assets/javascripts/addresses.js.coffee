# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  onCityChanged()
  $('#address_city_id').bind 'railsAutocomplete.select', (event, data) =>
    onCityChanged()

@onCityChanged= ->

  # подстановка ключа города для фильтрации улиц
  city_id = $('#city_id').val()
  if city_id == ''
    url = ''
  else
    url = '/addresses/autocomplete_street_name/' + city_id

  # ручное изменение
  if $('#address_city_id').val().trim() == ''
    url = ''

  $('#address_street').attr('data-autocomplete', url)

  disableStreet(url == '')

disableStreet = (disable) ->
  el = $('#address_street')
  if disable
    el.attr('disabled', 'disabled')
    el.val('')
    $('#street_city_id').val('')
  else el.removeAttr('disabled')
