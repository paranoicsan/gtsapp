$ ->
  $('report_agent').change ->
    reportAgentChange()
  reportAgentChange()

reportAgentChange = ->
  val = $('#report_agent').val()
  console.log val
  check = if val then val != -1 else true
  console.log check
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