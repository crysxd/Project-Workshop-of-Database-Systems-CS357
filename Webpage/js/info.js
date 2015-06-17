/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  window.setTimeout(hideLoadingOverlay, 250);
});

$(window).on('hashchange', function() {
  if($('#menu:visible').length > 0) {
    $('#top-menu-toggle').click();
  }
  window.setTimeout(hideLoadingOverlay, 250);
});