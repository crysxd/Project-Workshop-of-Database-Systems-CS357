/* Click handler for search box */
$('#splash-screen .search-box').click(function() {
  showLoadingOverlay();
});

/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  window.setTimeout(hideLoadingOverlay, 1000);
});