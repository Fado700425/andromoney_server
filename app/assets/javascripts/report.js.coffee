$ ->
  $('#optionsExpenseRadio').on 'click', (event) ->
    $.ajax
      url: "/reports/expense_category"
      type: "get"

  $('#optionsIncomeRadio').on 'click', (event) ->
    $.ajax
      url: "/reports/income_category"
      type: "get"
    