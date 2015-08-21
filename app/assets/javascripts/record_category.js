$(document).ready(function(){
  var oriExpSelectCat, oriExpSelectSub, allExpSub, oriIncSelectCat, oriIncSelectSub, allIncSub;
  var expenseSelectCatField, incomeSelectCatField, expenseSelectSubField, incomeSelectSubField;
  // Memory the original selected elements.
  oriExpSelectCat = $("#expense-category :selected").text();
  oriExpSelectSub = $("#expense-subcategory :selected").text();
  allExpSub       = $("#expense-subcategory").html();
  oriIncSelectCat = $("#income-category :selected").text();
  oriIncSelectSub = $("#income-subcategory :selected").text();
  allIncSub       = $("#income-subcategory").html();

  var dynamicSelect = function(objCat, objSub, oriSelectCat, oriSelectSub, allSub, selectCat) {
    var category, subcategory, dynamicSelect;
    // If there is no selected elements, select the first item in this group.
    if (selectCat == "") {
      category = oriSelectCat;
    } else {
      category = selectCat;
    }
    if (!category) {
      category = $(objCat + " :first").text();
      $(objCat + " :first").attr("selected","selected");
    }

    subcategory = allSub;

    console.log(oriExpSelectSub);
    console.log(oriIncSelectSub);

    var updateSelect = function() {
      var options;
      options = $(subcategory).filter("optgroup[label=" + category + "]").html();
      if (options) {
         $(objSub).html(options);
      } else {
         $(objSub).empty();
      }
      // If the displayed record_sub_category doen't have selected, then select the first item in this group.
      if ( oriSelectCat != category) {
        $(objSub + " :selected").removeAttr("selected");
        $(objSub + " :first").attr("selected","selected");
      }
    };
    return updateSelect();
  };

  // apply immediately after "document ready"
  $(".select-with-icon").msDropDown().data("dd");
  // apply immediately after "document ready"
  expenseSelectField = $('#expense-category').msDropDown().data("dd");
  incomeSelectField = $('#income-category').msDropDown().data("dd");
  if (expenseSelectField) {
    expenseSelectField.visible(true);
    incomeSelectField.visible(false);
  }
  $('#expense-subcategory').removeClass("hide");
  $('#income-subcategory').addClass("hide");
  // apply immediately after "document ready"
  dynamicSelect("#expense-category", "#expense-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, "");

  // apply when "click tab"
  $('a#incomeLink').on('click', function() {
    incomeSelectField.visible(true);
    expenseSelectField.visible(false);
    $('#income-subcategory').removeClass("hide");
    $('#expense-subcategory').addClass("hide");
    selectedCat = $('#income-category :selected').text();
    dynamicSelect("#income-category", "#income-subcategory", oriIncSelectCat, oriIncSelectSub, allIncSub, selectedCat);
  });
  // apply when "click tab"
  $('a#expenseLink').on('click', function() {
    expenseSelectField.visible(true);
    incomeSelectField.visible(false);
    $('#expense-subcategory').removeClass("hide");
    $('#income-subcategory').addClass("hide");
    selectedCat = $('#expense-category :selected').text();
    dynamicSelect("#expense-category", "#expense-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, selectedCat);
  });

  // apply when "change"
  $('#expense-category').on('change', function() {
    selectedCat = $('#expense-category :selected').text();
    dynamicSelect("#expense-category", "#expense-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, selectedCat);
  });
  // apply when "change"
  $('#income-category').on('change', function() {
    selectedCat = $('#income-category :selected').text();
    dynamicSelect("#income-category", "#income-subcategory", oriIncSelectCat, oriIncSelectSub, allIncSub, selectedCat);
  });
});
