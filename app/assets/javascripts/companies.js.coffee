# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

##
#
# Прячет или показывает выпадающее меню со списком зарегистрированных агентов
#
@showHideAgentList = (id) ->
  div = $('#agent_list')
  list = $('#company_company_source_id')
  if id == (Number) list.val()
    div.show()
  else
    div.hide()

##
#
# Обработчик выпадающего меню со списком рубрик
#
@onRubSelect = ->
  el =  $('#add_rub_link')
  val = $('#company_rubric_id').val()
  rub_id = $('#rubric_id').val()

  if !val
    el.hide()
  else if rub_id
    # меняем саму ссылку
    s = '/companies/' + $('#company_id').val() + '/add_rubric/' + $('#rubric_id').val()
    el.show()
    el.attr('href', s)
  else
    el.hide()


# прячем ссылку для добавления рубрики, т.к. по умолчанию нет выбранных рубрик
$ ->
  $('#add_rub_link').hide()
