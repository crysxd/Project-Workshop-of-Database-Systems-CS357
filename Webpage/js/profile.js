/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  $('.panel-collapse .panel-heading').click(function(e) {
    $(this).parents('.panel').toggleClass('panel-collapsed');
  });

  window.setTimeout(hideLoadingOverlay, 250);

});