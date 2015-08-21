$(document).ready(function(){
  var oriExpSelectCat, oriExpSelectSub, allExpSub;
  // Memory the original selected elements.
  oriExpSelectCat = $(".expanse-category :selected").text();
  oriExpSelectSub = $(".expanse-subcategory :selected").text();
  allExpSub       = $(".expanse-subcategory").html();
  oriIncSelectCat = $(".income-category :selected").text();
  oriIncSelectSub = $(".income-subcategory :selected").text();
  allIncSub       = $(".income-subcategory").html();

  $(".select-with-icon, .expanse-category, .income-category").msDropDown();

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
  // apply when "document ready"
  dynamicSelect(".expanse-category", ".expanse-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, "");

  // apply when "change"
  $('.expanse-category').on('change', function() {
    selectedCat = $('.expanse-category :selected').text();
    dynamicSelect(".expanse-category", ".expanse-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, selectedCat);
  });
  // apply when "change"
  $('.income-category').on('change', function() {
    selectedCat = $('.income-category :selected').text();
    dynamicSelect(".income-category", ".income-subcategory", oriIncSelectCat, oriIncSelectSub, allIncSub, selectedCat);
  });

  // apply when "click tab"
  $('a#incomeLink').on('click', function() {
    selectedCat = $('.income-category :selected').text();
    dynamicSelect(".income-category", ".income-subcategory", oriIncSelectCat, oriIncSelectSub, allIncSub, selectedCat);
  });
  // apply when "click tab"
  $('a#expanseLink').on('click', function() {
    selectedCat = $('.expanse-category :selected').text();
    dynamicSelect(".expanse-category", ".expanse-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, selectedCat);
  });
});





