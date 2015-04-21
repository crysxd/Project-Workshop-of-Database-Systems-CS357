if(/mobile|android|iOS|iPhone|iPad/i.test(navigator.userAgent)) {
  $('#splash-screen').height($(window).height() - $('#splash-screen').css('margin-bottom').replace("px", ""));
}

$('.menu-toggle').click(function() {
  if($('#menu:visible').length > 0) {
    $('#menu').fadeOut();
    $('.menu-toggle').removeClass('menu-toggle-open');
    $('#login-button').css('opacity', '');
    startScrolling();

  } else {
    $('#menu').fadeIn().css('display','table');
    $('.menu-toggle').addClass('menu-toggle-open');
    $('#menu').addClass('menu-open');
    $('#login-button').css('opacity', '1');
    stopScrolling();
  }    
});

$('#splash-screen .search-box').click(function() {
  $(this).find('p').html('Searching...');
});

$('#login-button').click(function() {
  $('#login-overlay').fadeIn().css('display','table');
  stopScrolling();
});

$('#register-button').click(function() {
  $('#register-button').animate({opacity: 0});
  $('#task-register').slideDown().fadeIn();
  $('#task-login').slideUp().fadeOut();
  updateScrollerHeight();
});

$('#login-cancel-button').click(function() {
  $('#login-overlay').fadeOut(function() {
    $('#register-button').css('opacity', 1);
    $('#task-register').hide();
    $('#task-login').show();
  });
  startScrolling();
});

$(window).resize(function() {
  updateScrollerHeight();
});

function updateScrollerHeight() {
    $('.scroll').css('max-height', $(window).height() + 'px');
}

function stopScrolling() {
  $('body').css('overflow', 'hidden');
}

function startScrolling() {
  $('body').css('overflow', 'scroll');
}