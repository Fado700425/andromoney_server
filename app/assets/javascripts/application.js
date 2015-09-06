// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require fancybox
//= require bootstrap
//= require bootstrap-datepicker
//= require_tree .
//= require moment/moment
//= require fullcalendar/dist/fullcalendar
//= require bootstrap-datetimepicker
//= require js-routes
//= require i18next/i18next.min
//= require currency-symbol/currency
//= require spin-js/spin


$(document).ready(function() {
  $("a.fancybox").fancybox();
});

$(function(){
    $("a[rel='group']").fancybox({
            'transitionIn': 'elastic',
            'transitionOut': 'elastic',
            'titlePosition': 'over',
            'titleFormat': function(title, currentArray, currentIndex, currentOpts) {
                return '<span id="fancybox-title-over">Image ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' &nbsp; ' + title : '') + '</span>';
            }
    });
});
