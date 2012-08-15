# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

##
# Обработчик нажатия на кнопку "Удалить" на странцие просмотра компании для агента
# показывает модальный диалог с содержимым шаблона
@clickCompanyDelete = (event) ->

  # создаём модальный диалог для ввода причины удаления
  url = $('#company_delete_link').attr('href')
  $('<div id="dialog-form"></div>')
    .html('Загрузка...')
    .dialog({
      autoOpen: false
      width: 520
      modal: true
      title: 'Удаление компании'
      resizable: false
      draggable: false
      open: () ->
        $(this).load(url)
      close: () ->
        $('#dialog-form').remove()
      buttons: [
        {
          id: "btn_reason_delete_submit"
          text: "Удалить"
          click: () ->
            $('#reason_form').submit()
        },
        {
        id: "btn_reason_delete_cancel"
        text: "Отменить"
        click: () ->
          $('#dialog-form').dialog("close")
        }
      ]
    })

  $('#dialog-form').dialog('open')
  $('#btn_reason_delete_submit').button('disable') # отключаем кнопку отправки

  event.preventDefault()

@onReasonChange = () ->
  val = $('#reason_delete_on_ta').val()
  s = if $.trim(val) != "" then "enable" else "disable"
  $('#btn_reason_delete_submit').button(s)

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
    s = '/companies/' + $('#company_id').val() + '/add_rubric/' + rub_id
    el.show()
    el.attr('href', s)
  else
    el.hide()


$ ->
  # прячем ссылку для добавления рубрики
  $('#add_rub_link').hide()







