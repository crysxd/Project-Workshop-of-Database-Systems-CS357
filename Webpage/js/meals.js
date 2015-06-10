var restaurant = 1;

/* When the doc is ready fade out the loading screen after 1s */
$(document).ready(function() {
  /* get restaurant id */
  restaurant = getUrlParam('restaurant');
  
  /* Set checkout url */
  $('.btn-checkout').attr('href', 'javascript:leaveTo("order.php?restaurant=' + restaurant + '")');
  
  /* Init the cart database */
  cart.initCart();
  
  /* Update the checkout button badge*/
  updateCheckoutBadge();
  
  /* Load the menu */
  loadMenu();
  
});

/* Change handler for sorting */
$('#meals-order-column').change(function() {
  loadMenu();

});

/* Change handler for sorting */
$('#meals-search-complete').click(function() {
  loadMenu();

});

/* Loads the menu*/
function loadMenu() {
  showLoadingOverlay(function() {
    /* Create object for params */
    var params = {start: 0, count: 10000};

    /* Fetch order data and search string */
    var order = $('#meals-order-column').val();
    params.order = order.split(';')[0];
    params.direction = order.split(';')[1];
    params.search = $('#meals-search').val()
    params.restaurant = restaurant;

    console.log('order: ' + params.order);
    console.log('direction: ' + params.direction);

    /* Trigger REST request */
    $.rest.get('/api/1.0/customer/menu.php', params, function(data) {
      /* Handle errors */
      if(!data.success) {
        showErrorOverlay('An Error occured while loading the Page', 
                         'The page can not be displayed', 
                         undefined);
        hideLoadingOverlay();
        console.error('An error occured while requesting data from the server:')
        console.error(data);
        return;
      }

      /* Set general information */
      $('.restaurant-name').html(data.name);
      $('.restaurant-rating-stars').html(generateRatingText(data.avg_rating));
      $('.restaurant-rating-count').html(data.rating_count);
      $('.restaurant-description').html(data.description);
      $('.restaurant-min-order-value').html(data.min_order_value);
      $('.restaurant-shipping-costs').html(data.shipping_cost);
      $('.restaurant-icon').attr('src', 'data:' + data.icon_mime + ',' + data.icon);

      /* Empty table, but not delete the template */
      $('#meals-list tbody').children('.meal').remove();

      /* Read template */
      var template = $('#meals-list template').html().trim();

      /* Iterate over meals */
      $(data.data).each(function(i, d) {
        /* Duplicate template */
        var e = $(template);

        /* Set all infos */
        e.find('.meal-name').html(d.name);
        e.find('.meal-spiciness').addClass('chilli-' + d.spicy)
        e.find('.meal-rating-stars').html(generateRatingText(d.raiting));
        e.find('.meal-rating-count').html(d.rating_count);
        e.find('.meal-price').html(d.price);

        /* Click handler for plus button */
        e.find('.meal-cart-plus').click(function() {
          cart.increaseAmount(restaurant, d, function(amount) {
            e.find('.meal-cart-amount').val(amount);
            updateCheckoutBadge();

          });    
        });

        /* Click handler for minus button */
        e.find('.meal-cart-minus').click(function() {
          cart.decreaseAmount(restaurant, d, function(amount) {
            e.find('.meal-cart-amount').val(amount);
            updateCheckoutBadge();

          });
        });

        /* Change handler for text field */
        e.find('.meal-cart-amount').change(function() {
          /* Get amount (round to ensure integer) */
          var amount = Math.round($(this).val());

          /* Ensure positive value */
          if(amount < 0) {
            amount = 0;
          }

          /* Set value */
          cart.setAmount(restaurant, d, amount, function(amount2) {       
            /* Set back value */
            e.find('.meal-cart-amount').val(amount2);
            updateCheckoutBadge();

          });
        });

        /* Restore amount */
        cart.getAmount(restaurant, d, function(amount) {
          e.find('.meal-cart-amount').val(amount);

        });

        /* Add tags */
        $(d.tags).each(function(i2, d2) {
          var tag = $('<span class="label label-default"></span>');
          tag.html(d2.name);
          tag.attr('style', 'background-color: #' + d2.color);
          e.find('.meal-tags').append(tag);
          e.find('.meal-tags').append('&nbsp;');

        });

        /* Append to table */
        $('#meals-list tbody').append(e);

      });

      /* Hide loading overlay */
      hideLoadingOverlay();

    });
  });
}

/* Updates the badge of the checkout button to the new cart value */
function updateCheckoutBadge() {
  /* Query value */
  cart.getCartValue(restaurant, function(value) {
    /* Set value */
    $('.cart-value').html(value);
    
  });
}