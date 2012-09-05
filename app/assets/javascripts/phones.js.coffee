# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  # Проверка ввода телефонного номера
  $('#phone_name').keydown (event) ->

    # определяем максимальное количество символов
    max_digits = if $('#phone_mobile').is(':checked') then 6 else 5

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
    (val.length > max_digits)
      event.preventDefault()

  # Проверка ввода префикса мобильного оператора
  $('#phone_mobile_refix').keydown (event) ->

    # определяем максимальное количество символов
    max_digits = 3

    val = $('#phone_mobile_refix').val()

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
    (val.length > max_digits)
      event.preventDefault()

  # выклюячаем справочную строку
  showHideHelp($('#phone_name_help'), false)
  showHideHelp($('#phone_mobile_refix_help'), false)

  $('#phone_name').keyup ->
    checkPhoneNumber()
  $('#phone_name').blur ->
    checkPhoneNumber()

  $('#phone_mobile_refix').keyup ->
    checkPhoneMobilePrefix()
  $('#phone_mobile_refix').blur ->
    checkPhoneMobilePrefix()

  $('#phone_mobile').change ->
    mobilePhoneChange()
  mobilePhoneChange()

mobilePhoneChange = ->
  el = $('#phone_mobile_refix_group')
  if $('#phone_mobile').is(':checked')
    el.show()
  else
    el.hide()

  checkPhoneNumber()
  validate()

checkPhoneNumber = ->
  re = /^[0-9]{5,6}$/
  mre = /^[0-9]{7}$/
  el = $('#phone_name_group')
  val = $('#phone_name').val()

  # проверяем в зависимости от типа телефонного номера
  check = if $('#phone_mobile').is(':checked') then mre.test(val) else re.test(val)

  if check
    el.removeClass('error')
  else
    el.addClass('error')

  validate()
  showHideHelp($('#phone_name_help'), !check)

checkPhoneMobilePrefix = ->
  re = /^[0-9]{3}$/
  el = $('#phone_mobile_refix_group')
  val = $('#phone_mobile_refix').val()

  check = re.test(val)

  if check
    el.removeClass('error')
  else
    el.addClass('error')

  validate()
  showHideHelp($('#phone_mobile_refix_help'), !check)


# прячем справочную строку
showHideHelp = (el, show) ->
  if show
    el.show()
  else
    el.hide()

validate = ->
  valid = true
  if $('#phone_name_group').hasClass('error')
    valid = false
  if $('#phone_mobile_refix_group').hasClass('error')
    valid = false

  if !valid
    $('#btn_phone_save').attr('disabled', 'disabled')
  else
    $('#btn_phone_save').removeAttr('disabled')




