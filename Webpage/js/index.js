$(function() {
  /* Load last search */
  var delivery = getCurrentDeliveryAddress();
  if(delivery != null) {
    $('.search-box input').val(delivery.formatted_address);
  }
});

/* Click handler for search box */
$('#splash-screen .search-box .btn').click(function() {
  searchAddress();
});

/* Enter handler for search box */
$('#splash-screen .search-box input').keypress(function(e) {
  if(e.which == 13) {
    searchAddress();
    return false;
  }
});


function searchAddress() {
  /* Show laoding overlay */
  showLoadingOverlay(function() {
    var delivery = getCurrentDeliveryAddress();

    /* If the query was not changed, use the last result */
    if(delivery != null && $('.search-box input').val() == delivery.formatted_address) {
      showRestaurantsForAddress(localStorage.getItem(localStorageDeliveryAddress));
    }
    
    /* Query data */
    $.rest.get('http://www.kart4you.de/meals/geo.php', {address: $('.search-box input').val()}, function(data) {

      /* Handle errors */
      if(!data.success || data.data.status !== "OK") {
        showErrorOverlay('Network Error', 
                         'A network error occured while loading the results. ' +
                         'Make sure you are connected to the internet and try again.', 
                         function() {
          hideLoadingOverlay();
        });

        return;
      }
      
      /* Delete all results which are too coarse */
      $(data.data.results).each(function(i, d) {
        /* Skip if the location is too coarse */
        if(d.geometry.location_type !== "ROOFTOP") {
          data.data.results.splice(i, 1);
        }
      });
      
      /* Nothing found */
      if(data.data.results.length == 0) {
        showErrorOverlay('No suitable addresses found', 
                         'There where no results for your search, try to be more specific.', 
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
      $(data.data.results).each(function(i, d) {
        /* Copy and fill template */
        var e = $(template);
        e.find('.road').text(d.simple.road);
        e.find('.city').text(d.simple.city);
        e.find('.postal_code').text(d.simple.postal_code);
        e.find('.state').text(d.simple.state);
        e.find('.country').text(d.simple.country);
        e.click(function() {
          showRestaurantsForAddress(d);
        })

        /* Append */
        $('#address-list .btn-cancel').before(e);
      });

      /* Show address picker overlay */
      showOverlay($('#address-picker'));
    });
  });
}

function showRestaurantsForAddress(address) {
  /* Save search and found address */
  setCurrentDeliveryAddress(address);
  /* Leave */
  hideOverlay($('#address-picker'), function() {
    leaveTo('restaurants.php');
  });
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