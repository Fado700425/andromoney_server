$ ->
  $('a#expenseLink').on 'click', (event) ->
    $('.transferForm').addClass("hide")
    $('.recordForm').removeClass("hide")
    $('#record_out_payment').attr('name',"record[out_payment]")
    $('#record_category').val($('tbody.expense_main_category td.warning').data('category-id'))
    $('#record_sub_category').val($('tbody.expense_category.sub_category td.warning').data('subcategory-id'))

  $('a#incomeLink').on 'click', (event) ->
    $('.transferForm').addClass("hide")
    $('.recordForm').removeClass("hide")
    $('#record_out_payment').attr('name',"record[in_payment]")
    $('#record_category').val($('tbody.income_main_category td.warning').data('category-id'))
    $('#record_sub_category').val($('tbody.income_category.sub_category td.warning').data('subcategory-id'))

  $('a#transferLink').on 'click', (event) ->
    $('.transferForm').removeClass("hide")
    $('.recordForm').addClass("hide")

  $('tbody.expense_main_category tr td').on 'click', (event) ->
    if($(this).data('category-id'))
      $('tbody.expense_main_category tr td.warning').attr('class','')
      $(this).attr('class','warning')
      cateogry_hash = $(this).data('category-id')
      $('#record_category').val(cateogry_hash)
      $.ajax
        url: "/categories/expense_subcategories"
        type: "get"
        data:
          cateogry_hash: cateogry_hash

  $('tbody.income_main_category tr td').on 'click', (event) ->
    if($(this).data('category-id'))
      $('tbody.income_main_category tr td.warning').attr('class','')
      $(this).attr('class','warning')
      cateogry_hash = $(this).data('category-id')
      $('#record_category').val(cateogry_hash)
      $.ajax
        url: "/categories/income_subcategories"
        type: "get"
        data:
          cateogry_hash: cateogry_hash

  $('tbody.transfer_main_category tr td').on 'click', (event) ->
    if($(this).data('category-id'))
      $('tbody.transfer_main_category tr td.warning').attr('class','')
      $(this).attr('class','warning')
      cateogry_hash = $(this).data('category-id')
      $('#transfer_category').val(cateogry_hash)
      $.ajax
        url: "/categories/transfer_subcategories"
        type: "get"
        data:
          cateogry_hash: cateogry_hash
  


  $("tbody.sub_category.income_category tr td").bind "click", (event) ->
    if($(this).data('subcategory-id'))
      $("tbody.sub_category.income_category tr td.warning").attr "class", ""
      $(this).attr "class", "warning"
      $('#record_sub_category').val($(this).data('subcategory-id'))

  $("tbody.sub_category.expense_category tr td").bind "click", (event) ->
    if($(this).data('subcategory-id'))
      $("tbody.sub_category.expense_category tr td.warning").attr "class", ""
      $(this).attr "class", "warning"
      $('#record_sub_category').val($(this).data('subcategory-id'))

  $("tbody.sub_category.transfer_category tr td").bind "click", (event) ->
    if($(this).data('subcategory-id'))
      $("tbody.sub_category.transfer_category tr td.warning").attr "class", ""
      $(this).attr "class", "warning"
      $('#transfer_sub_category').val($(this).data('subcategory-id'))


  $('tbody.account tr td').on 'click', (event) ->
    $('tbody.account tr td.warning').attr('class','')
    $(this).attr('class','warning')
    $('#myPaymentModal').modal('toggle')
    $('#record_out_payment').val($(this).data('payment-name'))

  $('tbody.inaccount tr td').on 'click', (event) ->
    $('tbody.inaccount tr td.warning').attr('class','')
    $(this).attr('class','warning')
    $('#myInPaymentModal').modal('toggle')
    $('#transfer_in_payment').val($(this).data('payment-name'))
    $('#transfer_in_payment').attr('currency-code',$(this).data('currency-code'))
    if($('#transfer_in_payment').attr('currency-code') == $('#transfer_out_payment').attr('currency-code'))
      $('.in_amout').addClass("hide")
    else
      $('.in_amout').removeClass("hide")


  $('tbody.outaccount tr td').on 'click', (event) ->
    $('tbody.outaccount tr td.warning').attr('class','')
    $(this).attr('class','warning')
    $('#myOutPaymentModal').modal('toggle')
    $('#transfer_out_payment').val($(this).data('payment-name'))
    $('#transfer_out_payment').attr('currency-code',$(this).data('currency-code'))
    if($('#transfer_in_payment').attr('currency-code') == $('#transfer_out_payment').attr('currency-code'))
      $('.in_amout').addClass("hide")
    else
      $('.in_amout').removeClass("hide")



  $('tbody.payee tr td').on 'click', (event) ->
    $('tbody.payee tr td.warning').attr('class','')
    $(this).attr('class','warning')
    $('#myStoreModal').modal('toggle')
    $('#record_payee').val($(this).data('payee-name'))

  $('#payee-dismiss').on 'click', (event) ->
    $('tbody.payee tr td.warning').attr('class','')
    $('#record_payee').val('')

  $('tbody.project tr td').on 'click', (event) ->
    $('tbody.project tr td.warning').attr('class','')
    $(this).attr('class','warning')
    $('#myProjectModal').modal('toggle')
    $('#record_project').val($(this).data('project-name'))
    $('#transfer_project').val($(this).data('project-name'))


  $('#project-dismiss').on 'click', (event) ->
    $('tbody.project tr td.warning').attr('class','')
    $('#record_project').val('')

  $("input#record_mount,input#record_fee").blur ->
    num = parseFloat($(this).val())
    cleanNum = num.toFixed(2)
    $(this).val(cleanNum)
