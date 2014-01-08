$ ->
  $('a#record_modal_link').on 'click', (event) ->
    $('#remark').val($(this).data('remark'))
    $('#record_id').val($(this).data('record-id'))

  $('tbody.main_category tr td').on 'click', (event) ->
    $('tbody.main_category tr td.active').attr('class','')
    $(this).attr('class','active')
  
  $('#tabs li').on 'click', (event) ->
    $('tbody.main_category tr:first-child td:first-child').attr('class','active')

  $('tbody.sub_category tr td').on 'click', (event) ->
    $('tbody.sub_category tr td.active').attr('class','')
    $(this).attr('class','active')