$(document).ready(function() {
  /* Redirect to home if the user is not logged in */
  var session = getSession();
  if(session == null) {
    leaveTo('index.php');
  }
  
  /* Set user name */
  $('.user-name').html(session.user);
    
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
    $.rest.get('api/1.0/customer/logout.php', session, function() {
      deleteSession();
      leaveTo('index.php');
    })
  });
});

$('#order-list-ongoing .order').click(function() {
  $('#order-modal').modal('show'); 
  window.setTimeout(function() {
    $('#order-modal .modal-body-loading').hide(); 
    $('#order-modal .modal-body-content').show(); 
  }, 500);
});

$('#order-list-history .order').click(function() {
  $('#order-modal').modal('show'); 
  window.setTimeout(function() {
    $('#order-modal .modal-body-loading').hide(); 
    $('#order-modal .modal-body-content').show(); 
  }, 500);
});

$('#meal-list-ratable .meal').click(function() {
  $('#rate-modal').modal('show'); 
  window.setTimeout(function() {
    $('#rate-modal .modal-body-loading').hide(); 
    $('#rate-modal .modal-body-content').show(); 
  }, 500);
});