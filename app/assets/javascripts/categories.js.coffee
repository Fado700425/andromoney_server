$ ->
  $('tbody tr#category-index').on 'click', (event) ->
    if($(this).data('category-id'))
      $('tbody tr#category-index.warning').attr('class','')
      $('tr#subcategory').remove()
      $(this).attr('class','warning')
      cateogry_hash = $(this).data('category-id')
      $.ajax
        url: "/categories/index_table_expense_subcategories"
        type: "get"
        data:
          cateogry_hash: cateogry_hash

  $('#add_subcategory').on 'click', (event) ->
    id = $(this).attr('add_id')
    $(this).attr('add_id',parseInt(id,10)+1)
    $('#add_subcategory').parent().parent().before("<tr><td>#{id}</td><td><input id=\"subcategorys__subcategory\" name=\"subcategorys[][subcategory]\" placeholder=\"請輸入名稱\" type=\"text\" value=\"\"></td><td></td></tr>")
      

  $('#myNewCategoryModal td').on 'click',(event) ->
    file_path = $(this).data('file')
    $('#myNewCategoryModal td.selected').removeClass('selected')
    $(this).addClass('selected')
    $('#myNewCategoryModal').modal('toggle')
    pic_src = $(this).find("img").attr("src")
    $('#category_pic').attr("src",pic_src)
    $('#category_image').val(file_path)
