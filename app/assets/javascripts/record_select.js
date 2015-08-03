$('.select-with-icon').wSelect();

$('.select-with-icon').change(function() {
    console.log($(this).val());
});

$('#demo').val('AU').change(); // should see in console

$('#demo').val('PL').wSelect('change'); // should see the selected option change to three

$('#demo').append('<option value="US" data-icon="./img/US.png">United States of America</option>').wSelect('reset');

$('#demo').val('CA').change();
