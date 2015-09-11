$(document).ready(function(){
  var isRecordform = $(".verify-record-form").data('token');

  if(isRecordform){
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    function SelectObj(enableSelectArr, disableSelectArr) {
      this.enable  = enableSelectArr;
      this.disable = disableSelectArr;
      this.targetObj = this.enable[0];  // since we only have one element for enableSelectArr.
      this.oriSelectCat = $("#" + this.targetObj + "-category :selected").text();
      this.oriSelectSub = $("#" + this.targetObj + "-subcategory :selected").text();
      this.allSub       = $("#" + this.targetObj + "-subcategory").html();
    }
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    SelectObj.prototype.setView = function(){
      var that = this;
      // hide or show Class
      (function showTargetCatSub() {
        for(var i=0, bound=that.enable.length; i<bound; i++){   
          $('#' + that.enable[i] + '-category').removeClass("hide");
          $('#' + that.enable[i] + '-subcategory').removeClass("hide");
        }
      })();
      (function hideTargetCatSub() {
        for(var i=0, bound=that.disable.length; i<bound; i++){   
          $('#' + that.disable[i] + '-category').addClass("hide");
          $('#' + that.disable[i] + '-subcategory').addClass("hide");
        }
      })();
      // read or filter out
      (function readTargetCatSub() {
        for(var i=0, bound=that.enable.length; i<bound; i++){
          $('#' + that.enable[i] + '-category').attr('name',"record[category]");
          $('#' + that.enable[i] + '-subcategory').attr('name',"record[subcategory]");
        }
        for(var i=0, bound=that.disable.length; i<bound; i++){   
          $('#' + that.disable[i]  + '-category').attr('name',"record[hideCat]");
          $('#' + that.disable[i]  + '-subcategory').attr('name',"record[hideSub]");
        }
      })();
      // set the 3rd column as "record[in_payment]" only when "income"
      (function asInOrOutPayment(){
        that.targetObj==="income" ? $('#record_out_payment').attr('name',"record[in_payment]")
                                    :
                                    $('#record_out_payment').attr('name',"record[out_payment]");
      })();
      // hide or show receiver
      (function showTransOrNontra() {
        if(that.targetObj==="transfer"){
          $('#nontrans-receiver').addClass("hide");
          $('#transfer-receiver').removeClass("hide");
        } else {
          $('#nontrans-receiver').removeClass("hide");
          $('#transfer-receiver').addClass("hide");
        }
      })();
      // read or filter out receiver
      (function readTransOrNontra() {
        if(that.targetObj==="transfer"){
          $('#nontrans-receiver').attr('name',"record[hideReceiver]");
          $('#transfer-receiver').attr('name',"record[in_payment]");
        } else {
          $('#nontrans-receiver').attr('name',"record[payee]");
          $('#transfer-receiver').attr('name',"record[hideReceiver]");
        }
      })();
      // Category/Subcategory visible or invisible msDropDown
      (function enableCatSubDD() {
        for(var i=0, bound=that.enable.length; i<bound; i++){
          $('#' + that.enable[i] + '-category').msDropDown().data("dd").visible(true);
        }
        for(var i=0, bound=that.disable.length; i<bound; i++){
          $('#' + that.disable[i] + '-category').msDropDown().data("dd").visible(false);
        }
      })();
      // receiver visible or invisible msDropDown
      (function enableTransOrNontraDD() {
        $('#nontrans-receiver').msDropDown().data("dd").visible(that.targetObj!=="transfer");
        $('#transfer-receiver').msDropDown().data("dd").visible(that.targetObj==="transfer");
      })();
    }
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    SelectObj.prototype.setDynamicSelect = function(){
      var that = this;
      var selectCat = $('#' + that.targetObj + '-category :selected').text();
      function dynamicSelect() {
        // obj: select_tag id depends on user's choice: expense, income or transfer.
        // oriSelectCat: default    category value.
        // oriSelectCat: default subcategory value.   #new: default="",   #edit: default=db value.
        // allSub: options, which are depends on user's choice: expense, income or transfer.
        var category, subcategory, dynamicSelect;
        // "category" is [1]oriSelectCat(default), if there is no selected made by the user.
        //               [2]the item selected by the user.
        category = (selectCat === "") ? that.oriSelectCat : selectCat;

        if (!category) {  // Redundency as a protection.
          category = $('#' + that.targetObj + '-category :first').text();
          $('#' + that.targetObj + '-category :first').attr("selected","selected");
        }
        // subcategory: options, which are depends on user's choice: expense, income or transfer.
        subcategory = that.allSub;

        (function updateSelect() {
          var filteredOpts;
          var selectedIndex;
          // filter "subcategory" filteredOpts by "category".
          filteredOpts = $(subcategory).filter("optgroup[label=\"" + category + "\"]").html();
          filteredOpts ? $('#' + that.targetObj + '-subcategory').html(filteredOpts) : $('#' + that.targetObj + '-subcategory').empty();
          // When "category" is selected to a new value by the user, refresh "subcategory".
          if ( that.oriSelectCat !== category) {
            $('#' + that.targetObj + '-subcategory :selected').removeAttr("selected");
            $('#' + that.targetObj + '-subcategory :first').attr("selected","selected");
          }
          // When there is no "oriSelectSub", like #new, then refresh "subcategory".
          if ( that.oriSelectSub === "") {
            $('#' + that.targetObj + '-subcategory :selected').removeAttr("selected");
            $('#' + that.targetObj + '-subcategory :first').attr("selected","selected");
          }
          // set subcategory msDropDown
          $('#' + that.targetObj + '-subcategory').msDropDown().data("dd").destroy();
          for(var i=0, bound=that.disable.length; i<bound; i++){
            $('#' + that.disable[i] + '-subcategory').msDropDown().data("dd").destroy();
          }
          $('#' + that.targetObj + '-subcategory').msDropDown().data("dd").visible(true);
          for(var i=0, bound=that.disable.length; i<bound; i++){
            $('#' + that.disable[i] + '-subcategory').msDropDown().data("dd").visible(false);
          } 
        })();
      };
      return dynamicSelect();
    }
    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // Define all SelectObj.
    var expense  = new SelectObj(["expense"],  ["income", "transfer"]);
    var income   = new SelectObj(["income"],   ["expense", "transfer"]);
    var transfer = new SelectObj(["transfer"], ["income", "expense"]);

    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // setEditPage will be used only in the edit page.
    function setEditPage(){
      var editToken = $(".record-edit-tab .editLink").data('token');
      (function editViewConfig(){
        if (editToken === "income") {
          income.setView();
          income.setDynamicSelect();
        } else if (editToken === "transfer") {
          transfer.setView();
          transfer.setDynamicSelect();
        }
      })();
    }
    // apply all msDropDown immediately after "document ready"
    $(".select-with-icon").msDropDown().data("dd");
    $(".category-select-with-icon").msDropDown().data("dd");
    $(".receiver-select-with-icon").msDropDown().data("dd");

    // apply immediately after "document ready"     // default is set to "expense".
    expense.setView();
    expense.setDynamicSelect();
    // refresh if it is "edit" page.
    setEditPage();

    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // apply when "click tab"
    $('a#incomeLink').on('click', function() {
      income.setView();
      income.setDynamicSelect();
    });
    // apply when "click tab"
    $('a#expenseLink').on('click', function() {
      expense.setView();
      expense.setDynamicSelect();
    });
    // apply when "click tab"
    $('a#transferLink').on('click', function() {
      transfer.setView();
      transfer.setDynamicSelect();
    });

    // apply when "change select"
    $('#expense-category').on('change', function() {
      expense.setDynamicSelect();
    });
    // apply when "change select"
    $('#income-category').on('change', function() {
      income.setDynamicSelect();
    });
    // apply when "change select"
    $('#transfer-category').on('change', function() {
      transfer.setDynamicSelect();
    });

    // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
    // set datetimepicker_report format
    (function setDatetimepickerFormat() {
      $('#datetimepicker_report').datetimepicker({ format: 'YYYY/MM/DD-HH:mm A'});
    })();
  }

});