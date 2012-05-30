# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

##
# Главный объект
#
@gts_company =
  id: '-1'

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

  # Прячем или показываем ссылку для добавления рубрики
  if $('#select_rubrics_id').val() != ''
    el.show()
    # меняем саму ссылку
    s = '/companies/' + gts_company.id + '/add_rubric/' + $('#select_rubrics_id').val()
    el.attr('href', s)
  else
    el.hide()



# прячем ссылку для добавления рубрики, т.к. по умолчанию нет выбранных рубрик
$ ->
  $('#add_rub_link').hide()
