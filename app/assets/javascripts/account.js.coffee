$ ->
  $('tbody.currency_grid tr td').bind "click", (event) ->
    selected_code = $(this).find('.currency_code').text().trim()
    $('tbody.currency_grid tr td.warning').attr('class','')
    $(this).attr('class','warning')
    $('#selected_code').text(selected_code)
    $('#selected_remark').text($(this).find('.currency_remark').text().trim())
    $('#selected_flag').attr('class', $(this).find('.currency_flag').attr('class'))
    $('#selected_currency').val(selected_code)
    $('#modal_code').html(selected_code + " ?")

  $('#search_box').on 'input', (event) ->
    $.ajax
      url: "/accounts/main_currency"
      type: "get"
      dataType: "script"
      data:
        searchWord: $(this).val()