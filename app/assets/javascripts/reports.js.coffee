$ ->
  $('#report_agent').change ->
    reportAgentChange()
  reportAgentChange()

reportAgentChange = ->
  check = if $('#report_agent').val() == "" then true else false
  el = $('#agent_group')
  if check then el.addClass('error') else el.removeClass('error')
  validate()

validate = ->
  valid = true
  if $('#agent_group').hasClass('error')
    valid = false

  el = $('#do_report_by_agent')
  if !valid
    el.attr('disabled', 'disabled')
  else
    el.removeAttr('disabled')