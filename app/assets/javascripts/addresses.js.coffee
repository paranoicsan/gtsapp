# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  onCityChanged()
  $('#address_city_id').bind 'railsAutocomplete.select', (event, data) =>
    onCityChanged()
  $('#address_city_id').keyup ->
    onCityChanged()
  $('#address_city_id').change ->
    onCityChanged()

  onStreetChanged()
  $('#addr_address_street').bind 'railsAutocomplete.select', (event, data) =>
    onStreetChanged()
  $('#addr_address_street').keyup ->
    onStreetChanged()
  $('#addr_address_street').change ->
    onStreetChanged()

@onCityChanged= ->
  # подстановка ключа города для фильтрации улиц
  city_id = $('#city_id').val()
  if city_id == ''
    url = ''
  else
    url = '/addresses/autocomplete_street_name/' + city_id

  # ручное изменение
  if $('#address_city_id').val() && $('#address_city_id').val().trim() == ''
    url = ''
  if !$('#address_city_id').val() && city_id != ''
    url = ''

  $('#addr_address_street').attr('data-autocomplete', url)

  el = $('#addr-city-group')
  if url == '' then el.addClass('error') else el.removeClass('error')

  disableStreet(url == '')

@onStreetChanged= ->
  el = $('#addr-street-group')

  err = false
  # ручное изменение
  if $('#addr_address_street').val() && $('#addr_address_street').val().trim() == ''
    err = true
  if !$('#addr_address_street').val() && city_id != ''
    err = true

  if err then el.addClass('error') else el.removeClass('error')

  checkSubmitBtn()

disableStreet = (disable) ->
  el = $('#addr_address_street')
  if disable
    el.attr('disabled', 'disabled')
    el.val('')
    $('#street_city_id').val('')
  else el.removeAttr('disabled')

  checkSubmitBtn()

checkSubmitBtn= ->
  valid = if $('#addr-city-group').hasClass('error') ||  $('#addr-street-group').hasClass('error') then false else true
  el = $('#btn_address_save')
  if valid
    el.removeAttr('disabled')
  else
    el.attr('disabled', 'disabled')
