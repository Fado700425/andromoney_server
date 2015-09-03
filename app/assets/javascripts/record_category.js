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

  function setDynamicSelect(typeOfRecord){
    var dynamicSelect = function(objCat, objSub, oriSelectCat, oriSelectSub, allSub, selectCat) {
      // objCat: select_tag id depends on user's choice: expense, income or transfer.
      // objSub: select_tag id depends on user's choice: expense, income or transfer.
      // oriSelectCat: default    category value.
      // oriSelectCat: default subcategory value.   #new: default="",   #edit: default=db value.
      // allSub: options, which are depends on user's choice: expense, income or transfer.
      var category, subcategory, dynamicSelect;
      // "category" is [1]oriSelectCat(default), if there is no selected made by the user.
      //               [2]the item selected by the user.
      category = (selectCat === "") ? oriSelectCat : selectCat;

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
        options ? $(objSub).html(options) : $(objSub).empty();

        // When "category" is selected to a new value by the user, refresh "subcategory".
        if ( oriSelectCat !== category) {
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

    switch(typeOfRecord){
      case "expense":
        selectedCat = $('#expense-category :selected').text();
        dynamicSelect("#expense-category", "#expense-subcategory", oriExpSelectCat, oriExpSelectSub, allExpSub, selectedCat);
        break;
      case "income":
        selectedCat = $('#income-category :selected').text();
        dynamicSelect("#income-category", "#income-subcategory", oriIncSelectCat, oriIncSelectSub, allIncSub, selectedCat);
        break;
      case "transfer":
        selectedCat = $('#transfer-category :selected').text();
        dynamicSelect("#transfer-category", "#transfer-subcategory", oriTraSelectCat, oriTraSelectSub, allTraSub, selectedCat);
        break;
    }
  }

  function setView(typeOfRecord){
    var arrRecordType, arrDispReceiver, isExpense, isIncome, isTransfer;
    switch(typeOfRecord) {
      case "expense":
        arrRecordType = ["expense", "income", "transfer"];  // display arrRecordType[0] and hide arrRecordType[1], arrRecordType[2]
        arrDispReceiver = ['nontrans', 'transfer'];         // display arrDispReceiver[0] and hide arrDispReceiver[1]
        isExpense  = true;
        isIncome   = false;
        isTransfer = false;
        break;
      case "income":
        arrRecordType = ["income", "transfer", "expense"];
        arrDispReceiver = ['nontrans', 'transfer'];
        isExpense  = false;
        isIncome   = true;
        isTransfer = false;
        break;
      case "transfer":
        arrRecordType = ["transfer", "expense", "income"];
        arrDispReceiver = ['transfer', 'nontrans'];
        isExpense  = false;
        isIncome   = false;
        isTransfer = true;
        break;
    }

    (function() {
      $('#' + arrRecordType[0] + '-category').removeClass("hide");
      $('#' + arrRecordType[0] + '-subcategory').removeClass("hide");
      $('#' + arrRecordType[1]  + '-category').addClass("hide");
      $('#' + arrRecordType[1]  + '-subcategory').addClass("hide");
      $('#' + arrRecordType[2]  + '-category').addClass("hide");
      $('#' + arrRecordType[2]  + '-subcategory').addClass("hide");
    })();

    (function() {
      $('#' + arrRecordType[0] + '-category').attr('name',"record[category]");
      $('#' + arrRecordType[0] + '-subcategory').attr('name',"record[sub_category]");
      $('#' + arrRecordType[1]  + '-category').attr('name',"record[hide1cat]");
      $('#' + arrRecordType[1]  + '-subcategory').attr('name',"record[hide1sub]");
      $('#' + arrRecordType[2]  + '-category').attr('name',"record[hide2cat]");
      $('#' + arrRecordType[2]  + '-subcategory').attr('name',"record[hide2sub]");
    })();

    (function(){
      // set the 3rd column as "record[in_payment]" only when "income"
      isIncome ? $('#record_out_payment').attr('name',"record[in_payment]")
                 :
                 $('#record_out_payment').attr('name',"record[out_payment]");
    })();

    (function() {
      $('#' + arrDispReceiver[0] + '-receiver').removeClass("hide");
      $('#' + arrDispReceiver[1]   + '-receiver').addClass("hide");
    })();

    (function() {
      if(isTransfer){
        $('#nontrans-receiver').attr('name',"record[hideReceiver]");
        $('#transfer-receiver').attr('name',"record[in_payment]");
      } else {
        $('#nontrans-receiver').attr('name',"record[payee]");
        $('#transfer-receiver').attr('name',"record[hideReceiver]");
      }
    })();

    (function() {
      $('#expense-category').msDropDown().data("dd").visible(isExpense);
      $('#income-category').msDropDown().data("dd").visible(isIncome);
      $('#transfer-category').msDropDown().data("dd").visible(isTransfer);
    })();

    (function() {
      $('#nontrans-receiver').msDropDown().data("dd").visible(!isTransfer);
      $('#transfer-receiver').msDropDown().data("dd").visible(isTransfer);
    })();
  }
  
  // setEditPage will be used only in the edit page.
  function setEditPage(){
    var editToken = $(".record-edit-tab .editLink").data('token');
    
    (function(){
      if (editToken === "income") {
        setView("income");
        setDynamicSelect("income");
      } else if (editToken === "transfer") {
        setView("transfer");
        setDynamicSelect("transfer");
      }
    })();
  }

  // apply all msDropDown immediately after "document ready"
  $(".select-with-icon").msDropDown().data("dd");
  $('#expense-category').msDropDown().data("dd");
  $('#income-category').msDropDown().data("dd");
  $('#transfer-category').msDropDown().data("dd");
  $('#nontrans-receiver').msDropDown().data("dd");
  $('#transfer-receiver').msDropDown().data("dd");

  // apply immediately after "document ready"     // default is set to "expense".
  setView("expense");
  setDynamicSelect("expense");
  // refresh if it is "edit" page.
  setEditPage();

  // apply when "click tab"
  $('a#incomeLink').on('click', function() {
    setView("income");
    setDynamicSelect("income");
  });
  // apply when "click tab"
  $('a#expenseLink').on('click', function() {
    setView("expense");
    setDynamicSelect("expense");
  });
  // apply when "click tab"
  $('a#transferLink').on('click', function() {
    setView("transfer");
    setDynamicSelect("transfer");
  });

  // apply when "change select"
  $('#expense-category').on('change', function() {
    setDynamicSelect("expense");
  });
  // apply when "change select"
  $('#income-category').on('change', function() {
    setDynamicSelect("income");
  });
  // apply when "change select"
  $('#transfer-category').on('change', function() {
    setDynamicSelect("transfer");
  });
});