/* If we are on a mobile device we must fix the splash-screen height,
   otehrwise the hight will jumo when the browser's navigation bar 
   is shown or hidden */
if(/mobile|android|iOS|iPhone|iPad/i.test(navigator.userAgent)) {
  $('#splash-screen').height($(window).height());
  $('#splash-screen').css('min-height', $(window).height()+'px');
}

/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  window.setTimeout(hideLoadingOverlay, 250);
});