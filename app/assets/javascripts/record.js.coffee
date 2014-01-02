$ ->
  $('a#record_modal_link').on 'click', (event) ->
    $('#remark').val($(this).data('remark'))
    $('#record_id').val($(this).data('record-id'))