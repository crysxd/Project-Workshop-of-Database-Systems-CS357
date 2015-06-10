var restaurant = 0;

/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  /* Get restaurant id from url */
  restaurant = getUrlParam('restaurant');
  
  /* Init shopping cart */
  cart.initCart();

  /* Load necessary information */
  $.rest.get('api/1.0/customer/order_info.php?', {restaurant: restaurant}, function(data) {
    /* Handle errors */
    if(!data.success) {
      showErrorOverlay('An Error occured while loading the Page', 
                       'The page can not be displayed', 
                       undefined);
      console.error('An error occured while requesting data from the server:')
      console.error(data);
      leaveTo('meals.php?restaurant=' + restaurant);
      return;
    }

    /* Display information */
    $('.restaurant-name').html(data.data.name);
    $('.restaurant-eta').html(data.data.eta);
    $('.restaurant-phone').html(data.data.phone);
    $('.restaurant-shipping-cost').html(data.data.shipping_cost);
    
    /* Calculate order value */
    var cartContent = cart.getCartValue(restaurant, function(value) {
      /* Add shipping costs */
      value += data.data.shipping_cost;
      
      /* Set value */
      $('.order-value').html(value);

    });

    /* Hide loading overlay */
    hideLoadingOverlay();
      
  });
  
  /* Display delivery address */
  var address = getCurrentDeliveryAddress();
  $('.address-street').html(address.simple.road);
  $('.address-city').html(address.simple.city);
  $('.address-postal-code').html(address.simple.postal_code);
  $('.address-country').html(address.simple.country);
    
  /* Load shopping cart */
  var cartContent = cart.getOverview(restaurant, function(cartContent) {
    /* Load template */
    var template = $('.table-order tbody template').html().trim();
    
    /* Iterate over cart items */
    $(cartContent.rows).each(function(i, d) {
      /* Duplicate template */
      var e = $(template);
      
      /* Extract data */
      var data = JSON.parse(d.data);
      
      console.log(d);
      
      /* Set information */
      e.find('.item-name').html(data.name);
      e.find('.item-price').html(d.price);
      e.find('.item-amount').html(d.amount);
      e.find('.item-total-price').html(d.amount * d.price);
      
      /* Append to table */
      $('.table-order tbody').prepend(e);
      
    });
  });
});