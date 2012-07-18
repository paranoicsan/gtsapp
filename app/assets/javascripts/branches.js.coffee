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