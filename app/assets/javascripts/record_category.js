$(function() {
  var category, dynamicSelect, subcategory, original_selected_category, original_selected_subcateg;

  subcategory = $('#record_sub_category').html();

  var dynamicSelect = function() {
    var options;
    options = $(subcategory).filter("optgroup[label=" + category + "]").html();
    if (options) {
       $('#record_sub_category').html(options);
    } else {
       $('#record_sub_category').empty();
    }
    // If the displayed record_sub_category doen't have selected, then select the first item in this group.
    if ( original_selected_category !== category) {
      $("#record_sub_category :selected").removeAttr("selected");
      $("#record_sub_category :first").attr("selected","selected");
    }
  };

  subcategory = $('#record_sub_category').html();
  // Memory the original selected elements.
  original_selected_category = $('#record_category :selected').text();
  original_selected_subcateg = $('#record_sub_category :selected').text();
  // If there is no selected elements, select the first item in this group.
  category = original_selected_category;
  if (!category) {
    category = $('#record_category :first').text();
    $('#record_category :first').attr("selected","selected");
  }

  dynamicSelect();
  // apply when "change"
  return $('#record_category').change(function() {
    category = $('#record_category :selected').text();
    return dynamicSelect();
  });

});