/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  window.setTimeout(hideLoadingOverlay, 250);
});

$('#drawer-toggle, #left-drawer').click(function(e) {
  $('#left-drawer').toggleClass('drawer-open');
  $('#main-contant-overlay').toggleClass('visible');
  e.stopPropagation();
});

$('#main-contant-overlay').click(function() {
  $('#drawer-toggle').click();
});