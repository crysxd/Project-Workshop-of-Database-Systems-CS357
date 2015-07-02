/* Create Object */
var utils = new Object();

/* Sets the session */
utils.setSession = function(data) {
  localStorage.setItem('restaurantSession', JSON.stringify(data));
}

/* Gets the session */
utils.getSession = function() {
  return JSON.parse(localStorage.getItem('restaurantSession'));
}

/* Delets the session */
utils.deleteSession = function() {
  localStorage.setItem('restaurantSession', undefined);
}

/* Function to handle rest errors */
utils.handleError = function(data) {
  if(!data.success) {
    var message = 'An error occured: ' + data.err_msg;
    var action = undefined;
    
    /* If the user was unauthorized, log out */
    if(data.err_no == 1) {
      utils.deleteSession();
      action = function() { window.location.href = 'index.html'; };
      message = 'Your login seems to be invalid. Please login again.'
    }
    
    /* Log error */
    console.error('An error occured while requesting data from the server:')
    console.error(data);
    
    /* Show error message*/
    alert(message);
    
    /* Perform action if any*/
    if(action != undefined) {
      action();
    }
    
    /* Return true to signal there was an error */
    return true;
    
  }
}