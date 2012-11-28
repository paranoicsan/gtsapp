# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  # активация Tabs
  $('#company-tabs a:first').tab('show')
  $('#company-tabs a').click (e) ->
      e.preventDefault()
      $(this).tab('show')


  $('#add_rub_link').hide() # прячем ссылку для добавления рубрики

  # обработчик названия компании
  $('#company_title').keyup ->
    onTitleChange()
  $('#company_title').blur ->
    onTitleChange()
  onTitleChange()

  # устанавливаем наблюдателя за полем с названием компании
  el = $('#company_title')
  el.observe_field 1, () ->
    if this.value && (this.value.trim().length > 0)
      data = { company_title: this.value }
      url = '/companies/validate_title'

      $.post url, data, (html) ->
        $('#title_help').html(html)
        setTitleError(html.length != 0)
        validate()

  # обработчик полей для выбора типа рубрикатор
  $('#company_rubricator_0').change ->
    onRubricatorChange()
  $('#company_rubricator_1').change ->
    onRubricatorChange()

  onRubricatorChange()


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

@clickCompanyNeedImprovement = (event) ->

  # создаём модальный диалог для ввода причины отправки на доработку
  url = $('#company_need_improvement_link').attr('href')
  $('<div id="dialog-form"></div>')
    .html('Загрузка...')
    .dialog({
    autoOpen: false
    width: 520
    modal: true
    title: 'Отправка компании на доработку'
    resizable: false
    draggable: false
    open: () ->
      $(this).load(url)
    close: () ->
      $('#dialog-form').remove()
    buttons: [
      {
      id: "btn_reason_need_improvement_submit"
      text: "Отправить"
      click: () ->
        $('#reason_form').submit()
      },
      {
      id: "btn_reason_need_improvement_cancel"
      text: "Отменить"
      click: () ->
        $('#dialog-form').dialog("close")
      }
    ]
    })

  $('#dialog-form').dialog('open')
  $('#btn_reason_need_improvement_submit').button('disable') # отключаем кнопку отправки

  event.preventDefault()

@onReasonChange = () ->
  val = $('#reason_delete_on_ta').val()
  s = if val && val.trim() != "" then "enable" else "disable"
  $('#btn_reason_delete_submit').button(s)

@onReasonAttentionChange = () ->
  val = $('#reason_attention_on_ta').val()
  s = if val && val.trim() != "" then "enable" else "disable"
  $('#btn_reason_need_attention_submit').button(s)

@onReasonImprovementChange = () ->
  val = $('#reason_improvement_on_ta').val()
  s = if val && val.trim() != "" then "enable" else "disable"
  $('#btn_reason_need_improvement_submit').button(s)

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
# Обработчик показа списка телефонов для определённого филиала
@showPhones = (branch_id) ->
  phones = $('#branch_' + branch_id)
  if phones.is(':visible') then phones.hide() else phones.show()

##
# Обработчик изменения названия
onTitleChange = ->
  val = $('#company_title').val()
  check = if val then val.trim().length == 0 else true
  setTitleError(check)
  validate()

##
# Обработчик изменения типа рубрикатора
onRubricatorChange = ->
  val_1 = $('#company_rubricator_0').is(':checked')
  val_2 = $('#company_rubricator_1').is(':checked')
  setRubricatorError(!(val_1 || val_2))
  onTitleChange()
  validate()
##
# Устанавливает класс для оформления ошибки
setTitleError = (arg) ->
  el = $('#title_group')
  if arg then el.addClass('error') else el.removeClass('error')

##
# Устанавливает класс для оформления ошибки
setRubricatorError = (arg) ->
  el = $('#rubricator-alert')
  if arg then el.show() else el.hide()


##
# Определяет, можно ли активировать кнопку для сохранения
validate = ->

  title_invalid = $('#title_group').hasClass('error')
  rubricator_invalid = $('#rubricator-alert').is(':visible')

  if title_invalid || rubricator_invalid
    $('#company_save').attr('disabled', 'disabled')
  else
    $('#company_save').removeAttr('disabled')

