# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#rubric_name').keyup ->
    nameChange()
  nameChange()

nameChange = ->
  val = $('#rubric_name').val()
  check = if val then val.trim().length == 0 else true
  el = $('#name_group')
  if check then el.addClass('error') else el.removeClass('error')
  validate()

validate = ->
  valid = true
  if $('#name_group').hasClass('error')
    valid = false

  el = $('#btn_rubric_save')
  if !valid
    el.attr('disabled', 'disabled')
  else
    el.removeAttr('disabled')