$ ->
  $('#optionsExpenseRadio').on 'click', (event) ->
    $.ajax
      url: "/reports/expense_category"
      type: "get"

  $('#optionsIncomeRadio').on 'click', (event) ->
    $.ajax
      url: "/reports/income_category"
      type: "get"

  $('.report_link a').on 'click', (event) ->
    $('#report_type').val($(this).data('value'))
    $('#report_form').submit()

  $('#report_form').submit (ev) ->
    $body = $("body")
    $body.addClass("loading")