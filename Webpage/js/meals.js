/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  window.setTimeout(hideLoadingOverlay, 250);
});

$('#meals-list tbody tr').click(function(e) {
  $('#meal-info-overlay').fadeIn();
});

$('#meal-info-overlay .overlay-close-button').click(function(e) {
  $('#meal-info-overlay').fadeOut();
  e.stopImmediatePropagation();
  e.stopPropagation();
});
