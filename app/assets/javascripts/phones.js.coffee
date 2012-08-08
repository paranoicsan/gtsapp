# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#phone_name').keydown (event) ->

    val = $('#phone_name').val()

    if event.keyCode == 46 ||
    event.keyCode == 8 ||
    event.keyCode == 9 ||
    event.keyCode == 27 ||
    event.keyCode == 13 ||
    (event.keyCode == 65 && event.ctrlKey == true) ||
    (event.keyCode >= 35 && event.keyCode <= 39)
      return
    else
    if event.shiftKey ||
    (event.keyCode < 48 || event.keyCode > 57) &&
    (event.keyCode < 96 || event.keyCode > 105 ) ||
    (val.length > 5)
      event.preventDefault()

  $('#phone_name').keyup ->
    checkPhoneNumber()

  # выклюячаем справочную строку
  showHidePhoneNameHelp(false)

  $('#phone_name').blur ->
    checkPhoneNumber()

  $('#phone_mobile').change ->
    mobilePhoneChange()
  mobilePhoneChange()

mobilePhoneChange = ->
  el = $('#phone_mobile_refix_group')
  if $('#phone_mobile').is(':checked')
    el.show()
  else
    el.hide()

checkPhoneNumber = ->
  re = /^[0-9]{5,6}$/
  el = $('#phone_name_group')
  val = $('#phone_name').val()


  if re.test(val)
    el.removeClass('error')
    showHidePhoneNameHelp(false)
  else
    el.addClass('error')
    showHidePhoneNameHelp(true)

# прячем справочную строку
showHidePhoneNameHelp = (show) ->
  el = $('#phone_name_help')

  if show
    el.show()
  else
    el.hide()






