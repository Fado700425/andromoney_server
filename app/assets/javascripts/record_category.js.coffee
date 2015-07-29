jQuery ->
  dynamicSelect = ->
    options = $(subcategory).filter("optgroup[label=#{category}]").html()
    if options
      $('#record_sub_category').html(options)
    else
      $('#record_sub_category').empty()

  subcategory = $('#record_sub_category').html()
  category = $('#record_category :first').text()
  dynamicSelect()
  
  $('#record_category').change ->
    category = $('#record_category :selected').text()
    dynamicSelect()