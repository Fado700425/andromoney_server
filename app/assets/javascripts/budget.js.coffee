$ ->
  $("#budget_category").on 'change', (event) ->
    $(".category-budget-setting").toggle()

  $("input#budget_amount").blur ->
    num = parseFloat($(this).val())
    cleanNum = num.toFixed(2)
    total = parseFloat($("#total_budget").val())
    if(isNaN(cleanNum))
      cleanNum = 0
    if(cleanNum > total)
      alert("超過總預算了，請重設!")
      cleanNum = 0
    $("input#budget_amount").val(cleanNum)
    $("#budget_persent").val(cleanNum/total*100)

  $("input#budget_persent").blur ->
    num = parseFloat($(this).val())
    cleanNum = num.toFixed(0)
    total = parseFloat($("#total_budget").val())
    if(isNaN(cleanNum))
      cleanNum = 0
    if(cleanNum > 100)
      alert("超過100%了，請重設!")
      cleanNum = 0
    $("input#budget_persent").val(cleanNum)
    $("#budget_amount").val(cleanNum*total/100)