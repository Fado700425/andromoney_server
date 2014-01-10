$ ->
  $('a#expenseLink').on 'click', (event) ->
    $('#record_out_payment').attr('name',"record[out_payment]")
    $('#record_category').val($('tbody.expense_main_category td.active').data('category-id'))
    $('#record_sub_category').val($('tbody.expense_category.sub_category td.active').data('subcategory-id'))

  $('a#incomeLink').on 'click', (event) ->
    $('#record_out_payment').attr('name',"record[in_payment]")
    $('#record_category').val($('tbody.income_main_category td.active').data('category-id'))
    $('#record_sub_category').val($('tbody.income_category.sub_category td.active').data('subcategory-id'))

  $('a#record_modal_link').on 'click', (event) ->
    $('#remark').val($(this).data('remark'))
    $('#record_id').val($(this).data('record-id'))

  $('tbody.expense_main_category tr td').on 'click', (event) ->
    $('tbody.expense_main_category tr td.active').attr('class','')
    $(this).attr('class','active')
    cateogry_hash = $(this).data('category-id')
    $('#record_category').val(cateogry_hash)
    $.ajax
      url: "/categories/expense_subcategories"
      type: "get"
      data:
        cateogry_hash: cateogry_hash

  $('tbody.income_main_category tr td').on 'click', (event) ->
    $('tbody.income_main_category tr td.active').attr('class','')
    $(this).attr('class','active')
    cateogry_hash = $(this).data('category-id')
    $('#record_category').val(cateogry_hash)
    $.ajax
      url: "/categories/income_subcategories"
      type: "get"
      data:
        cateogry_hash: cateogry_hash
  


  $("tbody.sub_category.income_category tr td").bind "click", (event) ->
    if($(this).data('subcategory-id'))
      $("tbody.sub_category.income_category tr td.active").attr "class", ""
      $(this).attr "class", "active"
      $('#record_sub_category').val($(this).data('subcategory-id'))

  $("tbody.sub_category.expense_category tr td").bind "click", (event) ->
    if($(this).data('subcategory-id'))
      $("tbody.sub_category.expense_category tr td.active").attr "class", ""
      $(this).attr "class", "active"
      $('#record_sub_category').val($(this).data('subcategory-id'))


  $('tbody.account tr td').on 'click', (event) ->
    $('tbody.account tr td.active').attr('class','')
    $(this).attr('class','active')
    $('#myPaymentModal').modal('toggle')
    $('#record_out_payment').val($(this).data('payment-name'))

  $('tbody.payee tr td').on 'click', (event) ->
    $('tbody.payee tr td.active').attr('class','')
    $(this).attr('class','active')
    $('#myStoreModal').modal('toggle')
    $('#record_payee').val($(this).data('payee-name'))

  $('#payee-dismiss').on 'click', (event) ->
    $('tbody.payee tr td.active').attr('class','')
    $('#record_payee').val('')

  $('tbody.project tr td').on 'click', (event) ->
    $('tbody.project tr td.active').attr('class','')
    $(this).attr('class','active')
    $('#myProjectModal').modal('toggle')
    $('#record_project').val($(this).data('project-name'))

  $('#project-dismiss').on 'click', (event) ->
    $('tbody.project tr td.active').attr('class','')
    $('#record_project').val('')

  $("input#record_mount").blur ->
    num = parseFloat($(this).val())
    cleanNum = num.toFixed(2)
    $(this).val(cleanNum)
