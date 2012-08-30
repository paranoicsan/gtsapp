# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# прячем ссылку для добавления веб-сайта
$ ->
  el = $('#branch_add_website')
  el.attr('disabled', 'disabled')
  $('#branch_website').keyup ->
    wsChange()

  el = $('#branch_add_email')
  el.attr('disabled', 'disabled')
  $('#branch_email').keyup ->
    emChange()

  $('#branch_fact_name').keyup ->
    factNameChange()
  factNameChange()

  $('#branch_legel_name').keyup ->
    legelNameChange()
  legelNameChange()

factNameChange = ->
  val = $('#branch_fact_name').val()
  check = if val then val.trim().length == 0 else true
  el = $('#fact_name_group')
  if check then el.addClass('error') else el.removeClass('error')
  validate()

legelNameChange = ->
  val = $('#branch_legel_name').val()
  check = if val then val.trim().length == 0 else true
  el = $('#legel_name_group')
  if check then el.addClass('error') else el.removeClass('error')
  validate()

# Обработка изменений в строке с веб-адресом филиала
wsChange = ->
  el = $('#branch_add_website')
  if $('#branch_website').val().length > 0
    el.removeAttr 'disabled'
  else
    el.attr('disabled', 'disabled')

# Обработка изменений в строке с адресом электронной почты
emChange = ->
  el = $('#branch_add_email')
  if $('#branch_email').val().length > 0
    el.removeAttr 'disabled'
  else
    el.attr('disabled', 'disabled')

validate = ->
  valid = true
  if $('#fact_name_group').hasClass('error')
    valid = false
  if $('#legel_name_group').hasClass('error')
    valid = false

  if !valid
    $('#btn_branch_save').attr('disabled', 'disabled')
  else
    $('#btn_branch_save').removeAttr('disabled')
