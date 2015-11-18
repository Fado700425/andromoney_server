$ ->
  $('a#expenseLink').on 'click', (event) ->
    $('#record_out_payment').attr('name',"record[out_payment]")

  $('a#incomeLink').on 'click', (event) ->
    $('#record_out_payment').attr('name',"record[in_payment]")

  $('a#transferLink').on 'click', (event) ->
    $('#record_out_payment').attr('name',"record[out_payment]")