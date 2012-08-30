# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#add_rub_link').hide() # прячем ссылку для добавления рубрики

  # обработчик названия компании
  $('#company_title').keyup ->
    onTitleChange()
  onTitleChange()

  # устанавливаем наблюдателя за полем с названием компании
  el = $('#company_title')
  el.observe_field 1, () ->
    data = { company_title: this.value }
    url = '/companies/validate_title'
    $.post url, data, (html) ->
      $('#title_help').html(html)
      setTitleError(html.length != 0)
#      validate()

#  $.get(url, data, // make ajax request
#    function(html) { // function to handle the response
#      $("#article_list").html(html); // change the inner html of update div



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

##
# Обработчик нажатия на кнопку "Отправить администратору" на странцие просмотра компании для агента
# показывает модальный диалог с содержимым шаблона
@clickCompanyNeedAttention = (event) ->

  # создаём модальный диалог для ввода причины удаления
  url = $('#company_request_attention_link').attr('href')
  $('<div id="dialog-form"></div>')
    .html('Загрузка...')
    .dialog({
    autoOpen: false
    width: 520
    modal: true
    title: 'Отправка компании администратору'
    resizable: false
    draggable: false
    open: () ->
      $(this).load(url)
    close: () ->
      $('#dialog-form').remove()
    buttons: [
      {
      id: "btn_reason_need_attention_submit"
      text: "Отправить"
      click: () ->
        $('#reason_form').submit()
      },
      {
      id: "btn_reason_need_attention_cancel"
      text: "Отменить"
      click: () ->
        $('#dialog-form').dialog("close")
      }
    ]
    })

  $('#dialog-form').dialog('open')
  $('#btn_reason_need_attention_submit').button('disable') # отключаем кнопку отправки

  event.preventDefault()

@onReasonChange = () ->
  val = $('#reason_delete_on_ta').val()
  s = if val && val.trim() != "" then "enable" else "disable"
  $('#btn_reason_delete_submit').button(s)

@onReasonAttentionChange = () ->
  val = $('#reason_attention_on_ta').val()
  s = if val && val.trim() != "" then "enable" else "disable"
  $('#btn_reason_need_attention_submit').button(s)

##
# Прячет или показывает выпадающее меню со списком зарегистрированных агентов
@showHideAgentList = (id) ->
  div = $('#agent_list')
  list = $('#company_company_source_id')
  if id == (Number) list.val()
    div.show()
  else
    div.hide()

##
# Обработчик выпадающего меню со списком рубрик
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

##
# Обработчик изменения названия
onTitleChange = ->
  val = $('#company_title').val()
  check = if val then val.trim().length == 0 else true
  setTitleError(check)

##
# Устанавливает класс для оформления ошибки
setTitleError = (arg) ->
  el = $('#title_group')
  if arg then el.addClass('error') else el.removeClass('error')
  validate()

##
# Определяет, можно ли активировать кнопку для сохранения
validate = ->
  if $('#title_group').hasClass('error')
    $('#company_save').attr('disabled', 'disabled')
  else
    $('#company_save').removeAttr('disabled')




