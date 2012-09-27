##
# Префиксы для функций
# repoAgent_ - отчёт по агенту
# repoCompStr - отчёт компаний по улицам
#


$ ->

  #######################################
  # Отчёт по агенту
  #######################################
  $('#report_agent').change ->
    repoAgent_AgentChange()
  repoAgent_AgentChange()

  #######################################
  # Отчёт компаний по улицам
  #######################################
#  onReportAgentCityChanged()
  repoCompStr_CityChanged()
  $('#address_city').bind 'railsAutocomplete.select', (event, data) =>
    repoCompStr_CityChanged()
  $('#address_city').change ->
    repoCompStr_CityChanged()
  $('#address_city').keyup ->
    repoCompStr_CityChanged()

#    onReportAgentStreetChanged()
  repoCompStr_StreetChanged()
  $('#address_street').bind 'railsAutocomplete.select', (event, data) =>
    repoCompStr_StreetChanged()
  $('#address_street').change ->
    repoCompStr_StreetChanged()
  $('#address_street').keyup ->
    repoCompStr_StreetChanged()


##########################################################################
# Отчёт по агенту
##########################################################################
##
# Изменение в выпадающем меню со списком агентов
repoAgent_AgentChange = ->
  check = if $('#report_agent').val() == "" then true else false
  el = $('#agent_group')
  if check then el.addClass('error') else el.removeClass('error')

  valid = if $('#agent_group').hasClass('error') then false else true

  el = $('#do_report_by_agent')
  if !valid
    el.attr('disabled', 'disabled')
  else
    el.removeAttr('disabled')

##########################################################################
# Отчёт компаний по улицам
##########################################################################
##
# Обработка изменений в поле для ввода улицы
@repoCompStr_StreetChanged = ->
  el = $('#street-group')
  if $('#street_id').val() == '' then el.addClass('error') else el.removeClass('error')

  valid = if $('#city-group').hasClass('error') ||  $('#street-group').hasClass('error') then false else true

  el = $('#do_report_company_by_street')
  if valid
    el.removeAttr('disabled')
  else
    el.attr('disabled', 'disabled')

##
# Обработка изменений в поле для ввода города
@repoCompStr_CityChanged= ->

  # подстановка ключа города для фильтрации улиц
  city_id = $('#city_id').val()
  url = if city_id == '' then '' else '/addresses/autocomplete_street_name/' + city_id

  # ручное изменение
  if $('#address_city').val() && $('#address_city').val().trim() == ''
    url = ''

  $('#address_street').attr('data-autocomplete', url)

  repoCompStr_DisableStreet(url == '')

  el = $('#city-group')
  if url == '' then el.addClass('error') else el.removeClass('error')

repoCompStr_DisableStreet = (disable) ->
  el = $('#address_street')
  if disable
    el.attr('disabled', 'disabled')
    el.val('')
  else el.removeAttr('disabled')
