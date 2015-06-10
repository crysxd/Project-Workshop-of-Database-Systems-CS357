/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  window.setTimeout(hideLoadingOverlay, 250);
});

$('#btn-change-address').click(function() {
  $('#address-name').popover({content: 'Enter a valid name', placement: 'auto'}).popover('show');
});