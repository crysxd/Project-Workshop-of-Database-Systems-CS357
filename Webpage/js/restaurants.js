var restaurants_meal_batch_size = 12;
var restuarants_meal_position = 0;
var restaurants_current_lat = undefined;
var restaurants_current_long = undefined;

/* If we are on a mobile device we must fix the splash-screen height,
   otehrwise the hight will jumo when the browser's navigation bar 
   is shown or hidden */
if(/mobile|android|iOS|iPhone|iPad/i.test(navigator.userAgent)) {
  $('#splash-screen').height($(window).height());
  $('#splash-screen').css('min-height', $(window).height()+'px');
}

/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  /* Get current position */
  navigator.geolocation.getCurrentPosition(
    function(pos) { restaurants_current_lat = pos.coords.latitude; restaurants_current_long = pos.coords.longitude; loadItems(); }, 
    function(err) { console.error(err); loadItems(); }, 
    {enableHighAccuracy: true, timeout: 30000, maximumAge: 0}
  );
});


$('.load-more-item').click(function() {
  showLoadingOverlay(function() {
      loadItems();
  });
});

/* Loads the next bunch of items */
function loadItems() {
  /* Cancel if position is not available */
  if(restaurants_current_lat == undefined || restaurants_current_long == undefined) {
    alert('Error: Unable to get position.');
    return;
  }
    
  /* Load data from server */
  $.rest.get(
    'api/1.0/customer/restaurants.php', {
      start:restuarants_meal_position, 
      count:restaurants_meal_batch_size, 
      center_lat:0, 
      center_long:0 
    }, function(data) {
      /* Handle errors */
      if(!data.success) {
        alert('An error occured, the page can not be loaded'); 
        console.error('An error occured while requesting data from the server:')
        console.error(data);
        return;

      }

      /* Load template */
      var template = $('#restaurants>template').html().trim();

      /* Add the loaded count to the current position, so the position is correct for the next bunch */
      restuarants_meal_position += data.data.length;

      /* Hide Load more button if there are no more items to laod */
      if(restuarants_meal_position >= data.item_count) {
        $('.load-more-item').hide();
      }
      
              console.log(data);

      /* Iterate over all elements */
      $(data.data).each(function(i, d) {
        var e = $(template);
        e.attr('restaurant', d.id);
        e.attr('href', 'javascript:leaveTo("meals.php?restaurant='  + d.id + '")');
        e.find('.restaurant-name').text(d.name);
        e.find('.rating-stars').text(generateRatingText(d.avg_rating));
        e.find('.rating-count').text(d.rating_count);
        e.find('.min-order-value').text(d.min_order_value);
        e.find('.shipping-costs').text(d.shipping_costs);
        e.find('.eta').text(d.eta);
        
        if(d.icon) {
          e.find('.restaurant-icon').attr('src', 'data:image/png;base64,' + d.icon);
        }
        
        $('.load-more-item').before(e);
      });

      /* Hide loading screen */
      window.setTimeout(hideLoadingOverlay, 500);

  });
}