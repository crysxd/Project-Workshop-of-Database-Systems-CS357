$(document).ready(function() {
  /* Redirect to home if the user is not logged in */
  if(getSession() == null) {
    leaveTo('index.php');
  }
  
  /* Click handlers for panel heders */
  $('.panel-collapse .panel-heading').click(function(e) {
    /* Toggle class collpased. This will show or hide the content */
    $(this).parents('.panel').toggleClass('panel-collapsed');
    /* The CSS solution does not work with lists, therefore we must add a JS based solution */
    $(this).parents('.panel').children('.list-group').slideToggle(300);
    
  });
  
  /* Slide up all list groups in collapsed panels */
  $('.panel-collapsed>.list-group').slideUp(0);

  /* When the doc is ready fade out the loading screen after 250ms */
  window.setTimeout(hideLoadingOverlay, 250);

});

$('#btn-logout').click(function() {
  /* Show the overlay */
  showLoadingOverlay(function() {
    /* Load the session */
    var session = getSession();
    /* Call logout */
    $.rest.get('api/1.0/customer/logout.php', {user: session.user, session: session.session}, function() {
      deleteSession();
      leaveTo('index.php');
    })
  });
});