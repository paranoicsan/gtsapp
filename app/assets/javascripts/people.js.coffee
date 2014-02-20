$ ->

  el = $('#person_name')
  el.keyup ->
    checkName()
  el.blur ->
    checkName()

  el = $('#person_email')
  el.keyup ->
    checkEmail()
  el.blur ->
    checkEmail()

  el = $('#person_second_name')
  el.keyup ->
    checkSecondName()
  el.blur ->
    checkSecondName()

  el = $('#person_phone')
  el.keydown (event) ->
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
    (event.keyCode < 96 || event.keyCode > 105 )
      event.preventDefault()

checkName = ->
  el = $('#person_name_group')
  val = $('#person_name').val()

  if val.trim()
    el.removeClass('error')
  else
    el.addClass('error')

checkSecondName = ->
  el = $('#person_second_name_group')
  val = $('#person_second_name').val()

  if val.trim()
    el.removeClass('error')
  else
    el.addClass('error')

checkEmail = ->
  el = $('#person_email_group')
  val = $('#person_email').val()

  re = /^([\w\.]+@([\w-]+\.)+[\w-]{2,4})?$/

  if re.test(val.trim())
    el.removeClass('error')
  else
    el.addClass('error')

