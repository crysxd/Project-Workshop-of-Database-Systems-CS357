if(/mobile|android|iOS|iPhone|iPad/i.test(navigator.userAgent)) {
  $('#splash-screen').height($(window).height() - $('#splash-screen').css('margin-bottom').replace("px", ""));
}

$('.menu-toggle').click(function() {
  if($('#menu:visible').length > 0) {
    $('#menu').fadeOut();
    $('.menu-toggle').removeClass('menu-toggle-open');
    $('#login-button').css('opacity', '');
  } else {
    $('#menu').fadeIn().css('display','table');
    $('.menu-toggle').addClass('menu-toggle-open');
    $('#menu').addClass('menu-open');
    loginWasVisible = $('#login-button').css('opacity');
    $('#login-button').css('opacity', '1');
  }    
});
