jQuery(function() {
  var category, dynamicSelect, subcategory;
  dynamicSelect = function() {
    var options;
    options = $(subcategory).filter("optgroup[label=" + category + "]").html();
    if (options) {
      return $('#record_sub_category').html(options);
    } else {
      return $('#record_sub_category').empty();
    }
  };
  subcategory = $('#record_sub_category').html();
  category = $('#record_category :first').text();
  dynamicSelect();
  return $('#record_category').change(function() {
    category = $('#record_category :selected').text();
    return dynamicSelect();
  });
});