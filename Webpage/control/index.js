/* Click handler for login complete button */
$('#btn-login-complete').click(function() {
  /* Set button to laoding state */
  $(this).button('loading');
  
  /* Get data */
  var params = new Object();
  params.id = $('#login-restaurant-id').val();
  params.pw = $('#login-password').val();
  
  /* Fire Request */
  $.rest.get('../api/1.0/restaurant/login.php', params, function(data) {
    /* Handle error */
    if(!data.success) {
      alert('Username or password wrong.');
      $('#btn-login-complete').button('reset');
      $('#login-password').val('');
      console.error(data);
      return;
    }
    
    /* Everything is ok, save session */
    delete data.success;
    utils.setSession(data);
        
    /* Forward */
    window.location.href = 'control.html';
    
  });
});