$(document).ready(function(){
  var isRecordform = $(".verify-record-form").data('token');

  if(isRecordform){
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
      var dynamicSelect = function(obj, obj_h1, obj_h2, oriSelectCat, oriSelectSub, allSub, selectCat) {
        // obj: select_tag id depends on user's choice: expense, income or transfer.
        // oriSelectCat: default    category value.
        // oriSelectCat: default subcategory value.   #new: default="",   #edit: default=db value.
        // allSub: options, which are depends on user's choice: expense, income or transfer.
        var category, subcategory, dynamicSelect;
        // "category" is [1]oriSelectCat(default), if there is no selected made by the user.
        //               [2]the item selected by the user.
        category = (selectCat === "") ? oriSelectCat : selectCat;

        if (!category) {  // Redundency as a protection.
          category = $('#' + obj + '-category :first').text();
          $('#' + obj + '-category :first').attr("selected","selected");
        }
        // subcategory: options, which are depends on user's choice: expense, income or transfer.
        subcategory = allSub;

        (function updateSelect() {
          var filteredOpts;
          var selectedIndex;
          // filter "subcategory" filteredOpts by "category".
          filteredOpts = $(subcategory).filter("optgroup[label=\"" + category + "\"]").html();
          filteredOpts ? $('#' + obj + '-subcategory').html(filteredOpts) : $('#' + obj + '-subcategory').empty();
          // When "category" is selected to a new value by the user, refresh "subcategory".
          if ( oriSelectCat !== category) {
            $('#' + obj + '-subcategory :selected').removeAttr("selected");
            $('#' + obj + '-subcategory :first').attr("selected","selected");
          }
          // When there is no "oriSelectSub", like #new, then refresh "subcategory".
          if ( oriSelectSub === "") {
            $('#' + obj + '-subcategory :selected').removeAttr("selected");
            $('#' + obj + '-subcategory :first').attr("selected","selected");
          }
          // set subcategory msDropDown
          $('#' + obj_h1 + '-subcategory').msDropDown().data("dd").destroy();
          $('#' + obj_h1 + '-subcategory').msDropDown().data("dd").destroy();
          $('#' + obj + '-subcategory').msDropDown().data("dd").destroy();

          $('#' + obj_h1 + '-subcategory').msDropDown().data("dd").visible(false);
          $('#' + obj_h2 + '-subcategory').msDropDown().data("dd").visible(false);
          $('#' + obj + '-subcategory').msDropDown().data("dd").visible(true);
        })();
      };

      switch(typeOfRecord){
        case "expense":
          selectedCat = $('#expense-category :selected').text();
          dynamicSelect("expense", "income", "transfer", oriExpSelectCat, oriExpSelectSub, allExpSub, selectedCat);
          break;
        case "income":
          selectedCat = $('#income-category :selected').text();
          dynamicSelect("income", "transfer", "expense", oriIncSelectCat, oriIncSelectSub, allIncSub, selectedCat);
          break;
        case "transfer":
          selectedCat = $('#transfer-category :selected').text();
          dynamicSelect("transfer", "expense", "income", oriTraSelectCat, oriTraSelectSub, allTraSub, selectedCat);
          break;
      }
    }

    function setView(typeOfRecord){
      var arrRecordType, isExpense, isIncome, isTransfer;
      switch(typeOfRecord) {
        case "expense":
          arrRecordType = ["expense", "income", "transfer"];  // display arrRecordType[0] and hide arrRecordType[1], arrRecordType[2]
          isExpense  = true;
          isIncome   = false;
          isTransfer = false;
          break;
        case "income":
          arrRecordType = ["income", "transfer", "expense"];
          isExpense  = false;
          isIncome   = true;
          isTransfer = false;
          break;
        case "transfer":
          arrRecordType = ["transfer", "expense", "income"];
          isExpense  = false;
          isIncome   = false;
          isTransfer = true;
          break;
      }

      (function showTargetCatSub() {
        $('#' + arrRecordType[0] + '-category').removeClass("hide");
        $('#' + arrRecordType[0] + '-subcategory').removeClass("hide");
        $('#' + arrRecordType[1]  + '-category').addClass("hide");
        $('#' + arrRecordType[1]  + '-subcategory').addClass("hide");
        $('#' + arrRecordType[2]  + '-category').addClass("hide");
        $('#' + arrRecordType[2]  + '-subcategory').addClass("hide");
      })();

      (function readTargetCatSub() {
        $('#' + arrRecordType[0] + '-category').attr('name',"record[category]");
        $('#' + arrRecordType[0] + '-subcategory').attr('name',"record[sub_category]");
        $('#' + arrRecordType[1]  + '-category').attr('name',"record[hide1cat]");
        $('#' + arrRecordType[1]  + '-subcategory').attr('name',"record[hide1sub]");
        $('#' + arrRecordType[2]  + '-category').attr('name',"record[hide2cat]");
        $('#' + arrRecordType[2]  + '-subcategory').attr('name',"record[hide2sub]");
      })();

      (function asInOrOutPayment(){
        // set the 3rd column as "record[in_payment]" only when "income"
        isIncome ? $('#record_out_payment').attr('name',"record[in_payment]")
                   :
                   $('#record_out_payment').attr('name',"record[out_payment]");
      })();

      (function showTransOrNontra() {
        if(isTransfer){
          $('#nontrans-receiver').addClass("hide");
          $('#transfer-receiver').removeClass("hide");
        } else {
          $('#nontrans-receiver').removeClass("hide");
          $('#transfer-receiver').addClass("hide");
        }
      })();

      (function readTransOrNontra() {
        if(isTransfer){
          $('#nontrans-receiver').attr('name',"record[hideReceiver]");
          $('#transfer-receiver').attr('name',"record[in_payment]");
        } else {
          $('#nontrans-receiver').attr('name',"record[payee]");
          $('#transfer-receiver').attr('name',"record[hideReceiver]");
        }
      })();

      (function enableCatSubDD() {
        $('#expense-category').msDropDown().data("dd").visible(isExpense);
        $('#income-category').msDropDown().data("dd").visible(isIncome);
        $('#transfer-category').msDropDown().data("dd").visible(isTransfer);
      })();

      (function enableTransOrNontraDD() {
        $('#nontrans-receiver').msDropDown().data("dd").visible(!isTransfer);
        $('#transfer-receiver').msDropDown().data("dd").visible(isTransfer);
      })();
    };

    // setEditPage will be used only in the edit page.
    function setEditPage(){
      var editToken = $(".record-edit-tab .editLink").data('token');
      
      (function editViewConfig(){
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
    $(".category-select-with-icon").msDropDown().data("dd");
    $(".receiver-select-with-icon").msDropDown().data("dd");

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
      console.time("machen");
      setView("expense");
      setDynamicSelect("expense");
      console.timeEnd("machen");
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

    // set datetimepicker_report format
    (function setDatetimepickerFormat() {
      $('#datetimepicker_report').datetimepicker({ format: 'YYYY/MM/DD-HH:mm A'});
    })();
  }

});