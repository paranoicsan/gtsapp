$ ->
  $('#report_agent').change ->
    reportAgentChange()
  reportAgentChange()

  onCityChanged()
  $('#address_city').bind 'railsAutocomplete.select', (event, data) =>
    onCityChanged()
  $('#address_street').bind 'railsAutocomplete.select', (event, data) =>
    onStreetChanged()

reportAgentChange = ->
  check = if $('#report_agent').val() == "" then true else false
  el = $('#agent_group')
  if check then el.addClass('error') else el.removeClass('error')
  validateReportAgent()

# Обработка отчёта по агентам
validateReportAgent = ->
  valid = true
  if $('#agent_group').hasClass('error')
    valid = false

  el = $('#do_report_by_agent')
  if !valid
    el.attr('disabled', 'disabled')
  else
    el.removeAttr('disabled')

# Обработка отчёта компанийпо улице
validateReportStreet = ->
  valid = true
  if $('#city-group').hasClass('error') ||  $('#street-group').hasClass('error')
    valid = false

  el = $('#do_report_company_by_street')
  if !valid
    el.attr('disabled', 'disabled')
  else
    el.removeAttr('disabled')

@onStreetChanged = ->
  el = $('#street-group')
  if $('#street_id').val() == '' then el.addClass('error') else el.removeClass('error')
  validateReportStreet()

@onCityChanged= ->

  # подстановка ключа города для фильтрации улиц
  city_id = $('#city_id').val()
  if city_id == ''
    url = ''
  else
    url = '/addresses/autocomplete_street_name/' + city_id

  # ручное изменение
  if $('#address_city').val() && $('#address_city').val().trim() == ''
    url = ''

  $('#address_street').attr('data-autocomplete', url)

  disableStreet(url == '')

  el = $('#city-group')
  if url == '' then el.addClass('error') else el.removeClass('error')

disableStreet = (disable) ->
  el = $('#address_street')
  if disable
    el.attr('disabled', 'disabled')
    el.val('')
  else el.removeAttr('disabled')
