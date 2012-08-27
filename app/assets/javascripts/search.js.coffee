# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


inputChange = (elem) ->
  a = ($(elem).val().length > 0)
  changeBtnState(a)

selectChange = (elem) ->
  a = ($(elem).val() != null)
  changeBtnState(a)

allowSearch = ->
  ret = false
  $('.controls > input').each (index, element) =>
    ret = ret || ($(element).val().length > 0)
  $('.controls > select').each (index, element) =>
    ret = ret || $(element).val()

  return ret

# Очистка формы поиска
@resetFields = ->
  $('#search_form_plain')[0].reset() # это очищает только изменённые поля
  $('#search_form_plain').find('input:text, input:password, input:file, select, textarea')
    .val('');
  $('#search_form_plain').find('input:radio, input:checkbox')
    .removeAttr('checked')
    .removeAttr('selected');

changeBtnState = (state) ->
  el = $('#do_search')
  if state || allowSearch()
    el.removeAttr 'disabled'
  else
    el.attr('disabled', 'disabled')

# Вешаем обработчики для параметров поиска
$ ->
  $('.controls > input').each (index, element) =>
    $(element).keyup ->
      inputChange(element)

  $('.controls > select').each (index, element) =>
    $(element).change ->
      selectChange(element)

  changeBtnState(false)
