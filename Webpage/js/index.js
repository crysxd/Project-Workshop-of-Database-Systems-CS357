/* Click handler for search box */
$('#splash-screen .search-box .btn').click(function() {
  /* Show laoding overlay */
  showLoadingOverlay(function() {
    /* Query data */
    $.rest.get('http://nominatim.openstreetmap.org/search', 
      {q: $('.search-box input').val(), format: 'jsonv2', addressdetails: 1}, function(data) {

      /* Nothing found */
      if(data.length == 0) {
        showErrorOverlay('No suitable addresses found', 
                         'There where no results for your search, try to be more specific.', 
                         function() {
          hideLoadingOverlay();
        });

        return;
      }
      
      /* Handle errors */
      if('success' in data) {
        showErrorOverlay('Network Error', 
                         'A network error occured while loading the results. ' +
                         'Make sure you are connected to the internet and try again.', 
                         function() {
          hideLoadingOverlay();
        });

        return;
      }
      
      /* Load template */
      var template = $('#address-list template').html().trim();

      /* Truncate list */
      $('#address-list>address').remove();
      
      /* Make list */
      $(data).each(function(i, d) {
        /* Copy and fill template */
        var e = $(template);
        e.find('.road').text(d.address.road);
        e.find('.suburb').text(d.address.suburb);
        e.find('.city').text(d.address.city);
        e.find('.postcode').text(d.address.postcode);
        e.find('.county').text(d.address.county);
        e.find('.state').text(d.address.state);
        e.find('.country').text(d.address.country);

        /* Append */
        $('#address-list .btn-cancel').before(e);
      });

      /* Show address picker overlay */
      showOverlay($('#address-picker'));
    });
  });
});

function showRestaurantsForAddress(address) {
  leaveTo('restaurants.php');
}

/* Click handler for cancel button in address picker */
$('#address-picker .btn-cancel').click(function() {
  console.log('cancel');
  hideOverlay($('#address-picker'));
  hideLoadingOverlay();
});

/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  window.setTimeout(hideLoadingOverlay, 250);

});