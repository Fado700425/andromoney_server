$ ->
  total_remain = 0
  total_income = 0
  total_expense = 0
  $(".remain").each ->
    remain = parseFloat($(this).text())
    total_remain += remain
    if(remain > 0)
      total_income += remain
    if(remain < 0)
      total_expense += remain
  $("#total_remain").text(total_remain.toFixed(2))
  $("#total_expense").text(total_expense.toFixed(2))
  $("#total_income").text(total_income.toFixed(2))

  $('.edit_category a').on 'click',(event) ->
    kind = $(this).data('kind')
    name = $(this).data('name')
    initial = parseFloat($(this).parent().parent().parent().children().eq(1).find(".init_amount").text())
    payment_id = $(this).data('payment-id')
    out_total = $(this).data('out-total')
    $('#payment_id').val(payment_id)
    $('#payment_kind').val(kind)
    $('#payment_modal_pic').attr('src',$('#payment_modal_pic').data("pic-#{kind}"))
    $('#payment_payment_name').val(name)
    $('#initial_amount').val(initial)
    if(out_total)
      $('#out_total').prop('checked',false);
      $('#out_total').val(1)
    else
      $('#out_total').prop('checked',true);
      $('#out_total').val(0)

  $("select#payment_kind").on "change", ->
    kind = @value
    $('#payment_modal_pic').attr('src',$('#payment_modal_pic').data("pic-#{kind}"))

  $('#out_total').on "change", ->
    if(this.checked)
      $('#out_total').val(0)
    else
      $('#out_total').val(1)