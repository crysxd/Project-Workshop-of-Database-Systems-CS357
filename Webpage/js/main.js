/* If we are on a mobile device we must fix the splash-screen hight,
   otehrwise the hight will jumo when the browser's navigation bar 
   is shown or hidden */
if(/mobile|android|iOS|iPhone|iPad/i.test(navigator.userAgent)) {
  $('#splash-screen').height($(window).height() - 20);
}

/* Click handler for all menu-toggles */
$('.menu-toggle').click(function() {
  /* If the menu is already visible */
  if($('#menu:visible').length > 0) {
    /* Fade menu out */
    $('#menu').fadeOut();
    
    /* Change all toggles from open state to closed state */
    $('.menu-toggle').removeClass('menu-toggle-open');
    
    /* Remove the element value for opacity. Will fade out th
       login button if it was hidden initially and shown on menu open */
    $('#login-button').css('opacity', '');
    
    /* Reenable body scrolling */
    startScrolling();
  } 
  
  /* If the menu is not visible */
  else {
    /* Fade menu in and force display table (important for centering content!) */
    $('#menu').fadeIn().css('display','table');
    
    /* Change all toggles to open state */
    $('.menu-toggle').addClass('menu-toggle-open');
    
    /* Fade login button in, might already be visible */
    $('#login-button').css('opacity', '1');
    
    /* Disable scroling of body */
    stopScrolling();
  }    
});

/* Click handler for login button */
$('#login-button').click(function() {
  /* Fade overlay in and disable scrolling of body */
  $('#login-overlay').fadeIn().css('display','table');
  stopScrolling();
});

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
  $('#login-overlay').fadeOut(function() {
    /* Reset the login overlay, hide register form and show login form */
    $('#register-button').css('opacity', 1);
    $('#task-register').hide();
    $('#task-login').show();
  });
  
  /* Reenable scrolling for body */
  startScrolling();
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
  $('#loading-overlay').fadeIn(callback).css('display','table');
  stopScrolling();
}

/* Hides the loading overlay */
function hideLoadingOverlay(callback) {
  $('#loading-overlay').fadeOut(callback);
  startScrolling();
}