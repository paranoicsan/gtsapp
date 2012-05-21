# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

##
#
# Прячет или показывает выпадающее меню со списком зарегистрированных агентов
#
@ShowHideAgentList = (id) ->
  div = $('#agents.list')
  list = $('#company_company_source_id')
  if id == (Number) list.val()
    div.show()
  else
    div.hide()

$(document).ready(
  v = (Number) $('#company_company_source_id').val()
  alert v
  if v == 2
    $('#agents.list').css('display', 'none')
    alert 'fuck'
)
