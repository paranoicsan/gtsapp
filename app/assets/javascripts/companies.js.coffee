# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

##
#
# Прячет или показывает выпадающее меню со списком зарегистрированных агентов
#
@ShowHideAgentList = (id) ->
  div = $('#agent_list')
  list = $('#company_company_source_id')
  if id == (Number) list.val()
    div.show()
  else
    div.hide()

##
#
# Прячет или показывает ссылку для добавления выбранной рубрики
#
@ShowHideAddRubLink = ->
  el =  $('#add_rub_link')
  if $('#select_rubrics_id').val() != ''
    el.show()
  else
    el.hide()

# прячем ссылку для добавления рубрики, т.к. по умолчанию нет выбранных рубрик
$ ->
  $('#add_rub_link').hide()
