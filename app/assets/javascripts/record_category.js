$(document).ready(function(){
  var oriExpSelectCat, oriExpSelectSub, allExpSub, oriIncSelectCat, oriIncSelectSub, allIncSub, oriTraSelectCat, oriTraSelectSub, allTraSub;
  // Memorize the original selected elements.
  oriExpSelectCat = $("#expense-category :selected").text();
  oriExpSelectSub = $("#expense-subcategory :selected").text();
  allExpSub       = $("#expense-subcategory").html();
  oriIncSelectCat = $("#income-category :selected").text();
  oriIncSelectSub = $("#income-subcategory :selected").text();
  allIncSub       = $("#income-subcategory").html();
  oriTraSelectCat = $("#transfer-category :selected").text();
  oriTraSelectSub = $("#transfer-subcategory :selected").text();
  allTraSub       = $("#transfer-subcategory").html();

  var dynamicSelect = function(objCat, objSub, oriSelectCat, oriSelectSub, allSub, selectCat) {
    // objCat: select_tag id depends on user's choice: expense, income or transfer.
    // objSub: select_tag id depends on user's choice: expense, income or transfer.
    // oriSelectCat: default    category value.
    // oriSelectCat: default subcategory value.   #new: default="",   #edit: default=db value.
    // allSub: options, which are depends on user's choice: expense, income or transfer.
    var category, subcategory, dynamicSelect;
    // "category" is [1]oriSelectCat(default), if there is no selected made by the user.
    //               [2]the item selected by the user.
    if (selectCat == "") {
      category = oriSelectCat;
    } else {
      category = selectCat;
    }
    if (!category) {  // Redundency as a protection.
      category = $(objCat + " :first").text();
      $(objCat + " :first").attr("selected","selected");
    }
    // subcategory: options, which are depends on user's choice: expense, income or transfer.
    subcategory = allSub;

    var updateSelect = function() {
      var options;
      // filter "subcategory" options by "category".
      options = $(subcategory).filter("optgroup[label=" + category + "]").html();
      if (options) {
         $(objSub).html(options);
      } else {
         $(objSub).empty();
      }
      // When "category" is selected to a new value by the user, refresh "subcategory".
      if ( oriSelectCat != category) {
        $(objSub + " :selected").removeAttr("selected");
        $(objSub + " :first").attr("selected","selected");
      }
      // When there is no "oriSelectSub", like #new, then refresh "subcategory".
      if ( oriSelectSub === "") {
        $(objSub + " :selected").removeAttr("selected");
        $(objSub + " :first").attr("selected","selected");
      }
    };
    return updateSelect();
  };

  // apply immediately after "document ready"
  $(".select-with-icon").msDropDown().data("dd");
  var expenseSelectField = $('#expense-category').msDropDown().data("dd");
  var incomeSelectField = $('#income-category').msDropDown().data("dd");
  var transferSelectField = $('#transfer-category').msDropDown().data("dd");

  var setDisplayCategory = function(target, hide1, hide2) {
      $('#' + target + '-category').removeClass("hide");
      $('#' + target + '-subcategory').removeClass("hide");
      $('#' + hide1  + '-category').addClass("hide");
      $('#' + hide1  + '-subcategory').addClass("hide");
      $('#' + hide2  + '-category').addClass("hide");
      $('#' + hide2  + '-subcategory').addClass("hide");
  }

  var setReadCategory = function(target, hide1, hide2) {
    $('#' + target + '-category').attr('name',"record[category]");
    $('#' + target + '-subcategory').attr('name',"record[sub_category]");
    $('#' + hide1  + '-category').attr('name',"record[hide1cat]");
    $('#' + hide1  + '-subcategory').attr('name',"record[hide1sub]");
    $('#' + hide2  + '-category').attr('name',"record[hide2cat]");
    $('#' + hide2  + '-subcategory').attr('name',"record[hide2sub]");
  }

  var setCategorySelect = function(expense, income, transfer) {
    expenseSelectField.visible(expense);
    incomeSelectField.visible(income);
    transferSelectField.visible(transfer);
  }

  var editToken = $(".record-edit-tab .editLink").data('token');
  var refreshEditPage = function(token){
    if (token == "income") {
      setCategorySelect(false, true, false)
      setDisplayCategory('income', 'expense', 'transfer');
      selectedCat = $('#income-category :selected').text();
      dynamicSelect("#income-category", "#income-subcategory", oriIncSelectCat, oriIncSelectSub, allIncSub, selectedCat);
      setReadCategory('income', 'expense', 'transfer');
    } else if (token == "transfer") {
      setCategorySelect(false, false, true)
      setDisplayCategory('transfer', 'income', 'expense');
      selectedCat = $('#transfer-category :selected').text();
      dynamicSelect("#transfer-category", "#transfer-subcategory", oriTraSelectCat, oriTraSelectSub, allTraSub, selectedCat);
      setReadCategory('transfer', 'income', 'expense');
    }
  }
  
  // apply immediately after "document ready"     // default is set to "expense".
  setCategorySelect(true, false, false)
  setDisplayCategory('expense', 'income', 'transfer');
  dynamicSelect("#expense-category", "#expense-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, "");
  setReadCategory('expense', 'income', 'transfer');
  refreshEditPage(editToken);

  
  
  // apply when "click tab"
  $('a#incomeLink').on('click', function() {
    setCategorySelect(false, true, false)
    setDisplayCategory('income', 'expense', 'transfer');
    selectedCat = $('#income-category :selected').text();
    dynamicSelect("#income-category", "#income-subcategory", oriIncSelectCat, oriIncSelectSub, allIncSub, selectedCat);
    setReadCategory('income', 'expense', 'transfer');
  });
  // apply when "click tab"
  $('a#expenseLink').on('click', function() {
    setCategorySelect(true, false, false)
    setDisplayCategory('expense', 'income', 'transfer');
    selectedCat = $('#expense-category :selected').text();
    dynamicSelect("#expense-category", "#expense-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, selectedCat);
    setReadCategory('expense', 'income', 'transfer');
  });
  // apply when "click tab"
  $('a#transferLink').on('click', function() {
    setCategorySelect(false, false, true)
    setDisplayCategory('transfer', 'income', 'expense');
    selectedCat = $('#transfer-category :selected').text();
    dynamicSelect("#transfer-category", "#transfer-subcategory", oriTraSelectCat, oriTraSelectSub, allTraSub, selectedCat);
    setReadCategory('transfer', 'income', 'expense');
  });

  // apply when "change select"
  $('#expense-category').on('change', function() {
    selectedCat = $('#expense-category :selected').text();
    dynamicSelect("#expense-category", "#expense-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, selectedCat);
  });
  // apply when "change select"
  $('#income-category').on('change', function() {
    selectedCat = $('#income-category :selected').text();
    dynamicSelect("#income-category", "#income-subcategory", oriIncSelectCat, oriIncSelectSub, allIncSub, selectedCat);
  });
  // apply when "change select"
  $('#transfer-category').on('change', function() {
    selectedCat = $('#transfer-category :selected').text();
    dynamicSelect("#transfer-category", "#transfer-subcategory", oriTraSelectCat, oriTraSelectSub, allTraSub, selectedCat);
  });
});
