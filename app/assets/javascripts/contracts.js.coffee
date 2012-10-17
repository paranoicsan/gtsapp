$ ->

  # активация Tabs
  $('#contracts-tabs a:first').tab('show')
  $('#brancontractsch-tabs a').click (e) ->
    e.preventDefault()
    $(this).tab('show')