# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#street_name').keyup ->
    nameChange()
  nameChange()

  $('#street_city_id').change ->
    cityChange()
  cityChange()

nameChange = ->
  val = $('#street_name').val()
  check = if val then val.trim().length == 0 else true
  el = $('#name_group')
  if check then el.addClass('error') else el.removeClass('error')
  validate()

cityChange = ->
  val = $('#street_city_id').val()
  check = if val then val.trim().length == 0 else true
  el = $('#city_group')
  if check then el.addClass('error') else el.removeClass('error')
  validate()

validate = ->
  valid = true
  if $('#name_group').hasClass('error')
    valid = false
  if $('#city_group').hasClass('error')
    valid = false

  el = $('#btn_street_save')
  if !valid
    el.attr('disabled', 'disabled')
  else
    el.removeAttr('disabled')