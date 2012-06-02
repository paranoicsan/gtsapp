# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# прячем ссылку для добавления веб-сайта
$ ->
  el = $('#branch_add_website')
  el.attr('disabled', 'disabled')
  $('#branch_website').keyup ->
    wsChange()

wsChange = ->
  el = $('#branch_add_website')
  if $('#branch_website').val().length > 0
    el.removeAttr 'disabled'
  else
    el.attr('disabled', 'disabled')