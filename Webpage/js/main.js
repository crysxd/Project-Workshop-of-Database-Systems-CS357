/* If we are on a mobile device we must fix the splash-screen hight,
   otehrwise the hight will jumo when the browser's navigation bar 
   is shown or hidden */
if(/mobile|android|iOS|iPhone|iPad/i.test(navigator.userAgent)) {
  $('#splash-screen').height($(window).height() - 20);
}

/* Init the height of .scroller elements */
updateScrollerHeight();

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
  /* Fade overlay in and disable scrolling of body */
  showOverlay($('#login-overlay'));
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
function showErrorOverlay(title, message, callback) {
  $('#error-overlay .title').text(title);
  $('#error-overlay .message').text(message);
  showOverlay($('#error-overlay'), callback);
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