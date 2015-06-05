var localStorageDeliveryAddress = 'globalDeliveryAddress';
var localStorageSession = 'globalSession';

/* If we are on a mobile device we must fix the splash-screen hight,
   otehrwise the hight will jumo when the browser's navigation bar 
   is shown or hidden */
if(/mobile|android|iOS|iPhone|iPad/i.test(navigator.userAgent)) {
  $('#splash-screen').height($(window).height() - 20);
}

/* Init the height of .scroller elements */
updateScrollerHeight();

/* Init the state of the login button */
updateLoginButtonState();

/* Click handler for all menu-toggles */
$('.menu-toggle').click(function() {
  /* If the menu is already visible */
  if($('#menu:visible').length > 0) {
    /* Fade menu out */
    hideOverlay($('#menu'));
    
    /* Change all toggles from open state to closed state */
    $('#top-menu-toggle').removeClass('menu-toggle-open');
    $('#left-menu-toggle').removeClass('menu-toggle-open');
    
    /* Remove the element value for opacity. Will fade out th
       login button if it was hidden initially and shown on menu open */
    $('#login-button').css('opacity', '');
  } 
  
  /* If the menu is not visible and if no other overlay is visible */
  else if($('.overlay:visible').length <= 0) {
    /* Fade menu in and force display table (important for centering content!) */
    showOverlay($('#menu'));
    
    /* Change all toggles to open state */
    $('#top-menu-toggle').addClass('menu-toggle-open');
    $('#left-menu-toggle').addClass('menu-toggle-open');

    /* Fade login button in, might already be visible */
    $('#login-button').css('opacity', '1');
  }    
});

/* Click handler for login button */
$('#login-button').click(function() {
  /* If the user is logged in, redirect to the profile page */
  if(getSession() != null) {
    leaveTo('profile.php');  
    return;
  }
  
  /* Fade overlay in and disable scrolling of body */
  showOverlay($('#login-overlay'));
});

/* Click handler for login complete button */
$('#login-complete-button').click(function() {
  /* Show loading overlay */
  showLoadingOverlay(function() {
    /* Get login data from form */
    var user = $('#task-login #form-user').val();
    var pw = $('#task-login #form-password').val();

    /* Start request */
    $.rest.get('api/1.0/customer/login.php?', {user: user, pw: pw}, function(data) {
      /* If not successful: show error */
      if(!data.success) {
        showErrorOverlay('Login failed', 'User or password wrong');
      } 

      /* If succesfull: save login data and hide login form */
      else {
        setSession(data.session, data.user);
        updateLoginButtonState();
        hideOverlay($('#login-overlay'));
      }
      
      /* Hide the laoding overlay to make it possible */
      hideLoadingOverlay();
    });
  });
});

/* Click handler for register button */
$('#register-button').click(function() {
  /* Fade register button out */
  $('#register-button').animate({opacity: 0});
  
  /* Open the register form animated */
  $('#task-register').slideDown().fadeIn();
  
  /* Close the login form animated */
  $('#task-login').slideUp().fadeOut();
  
  /* Force update the height of .scroller elements */
  updateScrollerHeight();
});

/* Hide hanler for popovers for inputs in login/register forms */
$('#login-overlay input').on('hidden.bs.popover', function () {
  /* Destroy popover after it is hidden */
  $(this).popover('destroy');
})

/* Click handler for register complete button */
$('#register-complete-button').click(function() {
  /* Get register data from form */
  var params = new Object();
  params.nick = $('#task-register #form-user-name').val();
  params.pw = $('#task-register #form-password').val();
  var pw2 = $('#task-register #form-password-control').val();
  params.phone = $('#task-register #form-phone').val();
  var phone2 = $('#task-register #form-phone-control').val();
  params.first_name = $('#task-register #form-first-name').val();
  params.sure_name = $('#task-register #form-sure-name').val();
  
  /* Check that there is data in all fields */
  var emptyFields = $('#task-register input').filter(function(){ return !this.value });
  if(emptyFields.length > 0) {
    $(emptyFields[0]).popover(
      {content: 'Please fill in this field', placement: 'bottom'}).popover('show');
    return;
  }

  /* Check if password matches with its control */
  if(params.pw != pw2) {
    $('#task-register #form-password-control').popover(
      {content: 'The passwords do not match', placement: 'bottom'}).popover('show');
    return;
  }

  /* Check if the phone matches with its control */
  if(params.phone != phone2) {
    $('#task-register #form-phone-control').popover(
      {content: 'The phone numbers do not match', placement: 'bottom'}).popover('show');
    return;
  }
  
  /* Check if password is long enough */
  if(params.pw.length < 6) {
    $('#task-register #form-password').popover(
      {content: 'The password must have at least 6 characters', placement: 'bottom'}).popover('show');
    return;
  }
  
  /* Show loading overlay */
  showLoadingOverlay(function() {
    /* Start request */
    $.rest.put('api/1.0/customer/info.php', params, function(data) {
      /* If not successful: show error */
      if(!data.success) {
        console.log(data);
        
        /* Error: User already exists */
        if(data.err_no == 1000) {
          $('#task-register #form-user-name').popover(
            {content: 'The user name is already taken', placement: 'bottom'}).popover('show');
        } 
        
        /* Error: Phone number already exists */
        else if(data.err_no == 1001) {
          $('#task-register #form-phone').popover(
            {content: 'This phone number is already used by an other account', placement: 'bottom'}).popover('show');
        } 
        
        /* Generic error  */
        else {
          showErrorOverlay('Registration failed', data.err_msg + ' [' + data.err_no + ']');
        }
      } 

      /* If succesfull: save login data and hide login form */
      else {
        setSession(data.session, data.user);
        updateLoginButtonState();
        leaveTo('profile.php');
      }
      
      /* Hide the laoding overlay to make it possible */
      hideLoadingOverlay();
    });
  });
});

/* Click handler for cancel button in login overlay */
$('#login-cancel-button').click(function() {
  /* Fade login overlay out */
  hideOverlay($('#login-overlay'), function() {
    /* Reset the login overlay, hide register form and show login form */
    $('#register-button').css('opacity', 1);
    $('#task-register').hide();
    $('#task-login').show();
  });
});

/* Resize handler for window */
$(window).resize(function() {
  /* Update height of .scroller elements to match new window height */
  updateScrollerHeight();
});

/* Updates the state of the login button. If the user is logged in the button shows the nick, else it shows "login" */
function updateLoginButtonState() {
  var session = getSession();
  
  /* If the user is logged in */
  if(session != null) {
    $('#login-button .text').html(session.user);
  }
  
  /* If not */
  else {
    $('#login-button .text').html("Login / Register");
  }
}

/* Updates height of .scroller elements to match new window height */
function updateScrollerHeight() {
    $('.scroll').css('max-height', $(window).height() + 'px');
}

/* Disbales the scrolling of the body element */
function stopScrolling() {
  $('body').css('overflow', 'hidden');
}

/* Enables the scrolling of the body element */
function startScrolling() {
  $('body').css('overflow', 'scroll');
}

/* Shows the loading overlay */
function showLoadingOverlay(callback) {
  showOverlay($('#loading-overlay'), callback);
}

/* Hides the loading overlay */
function hideLoadingOverlay(callback) {
  hideOverlay($('#loading-overlay'), callback);
}

/* Shows the error overlay */
function showErrorOverlay(title, message, callback, okAction) {
  $('#error-overlay .title').text(title);
  $('#error-overlay .message').text(message);
  showOverlay($('#error-overlay'), callback);
  
  /* Set the command executed when the ok button is pressed */
  if(okAction != undefined) {
    $('#error-overlay .btn').attr('onclick', okAction);
  } else {
    $('#error-overlay .btn').attr('onclick', '');
  }
}

/* Click handler for ok button in error overlay */
$('#error-overlay .btn').click(function() {
  hideOverlay($('#error-overlay'));
});


/* Shows the given overlay */
function showOverlay(overlay, callback) {
  $(overlay).fadeIn(callback).css('display','table');
  stopScrolling();
}

/* Hides the given overlay */
function hideOverlay(overlay, callback) {
  $(overlay).fadeOut(function() {
    /* Reenable scrolling if all overlays are hidden */
    if($('.overlay:visible').length <= 0) {
      startScrolling();
    }
    
    /* callback */
    if(callback) {
      callback();
    }
  });
}

/* Shows the loading dialog and goes to the given url */
function leaveTo(url) {
  showLoadingOverlay(function() {
    window.location.href = url;
  });
}

/* Generates a text with ★ and ☆ corresponding the rating. Max is 5 stars */
function generateRatingText(avg_raiting) {
  var text = '';
  
  for(var i=0; i<5; i++) {
    text += (i < Math.round(avg_raiting) ? '★' : '☆');
  }
    
  return text;  
}

/* Loads the current delivery address from local storage, returns null if not available */
function getCurrentDeliveryAddress() {
  var loaded = localStorage.getItem(localStorageDeliveryAddress);
  return JSON.parse(loaded);
}

/* Saves the delivery address to local storage */
function setCurrentDeliveryAddress(address) {
  return localStorage.setItem(localStorageDeliveryAddress, typeof address === "string" ? address : JSON.stringify(address));
}

/* Loads the data for the current session, null if not available */
function getSession() {
  var loaded = localStorage.getItem(localStorageSession);
  return JSON.parse(loaded);
}

/* Saves the data for the current session */
function setSession(session, user) {
  localStorage.setItem(localStorageSession, JSON.stringify({session: session, user: user}));
}

/* Deletes the data for the current session */
function deleteSession() {
  localStorage.removeItem(localStorageSession);
}