$(document).ready(function() {
  /* Redirect to home if the user is not logged in */
  var session = getSession();
  if(session == null) {
    leaveTo('index.php');
  }
    
  /* Click handlers for panel heders */
  $('.panel-collapse .panel-heading').click(function(e) {
    /* Toggle class collpased. This will show or hide the content */
    $(this).parents('.panel').toggleClass('panel-collapsed');
    /* The CSS solution does not work with lists, therefore we must add a JS based solution */
    $(this).parents('.panel').children('.list-group').slideToggle(300);
    
  });
  
  /* Slide up all list groups in collapsed panels */
  $('.panel-collapsed>.list-group').slideUp(0);

  /* Load informations from server */
  $.rest.get('api/1.0/customer/info.php', getSession(), function(data) {
    /* Handle errors */
    if(handleError(data)) {
      return;
    }

    /* Set information */
    $('.user-nick').html(data.nick);
    $('.user-first-name').html(data.first_name);
    $('.user-sure-name').html(data.sure_name);
    $('.user-phone').html(data.phone);
    $('.user-email').html(data.email);
    
    /* Build lists for ongoing deliveries */
    fillDeliveryList($('#order-list-ongoing'), data.ongoing_deliveries, function(d) {
      return d.restaurant;
    }, function(d) {
      return d.state + ' (' + d.state_since + ')';
    }, function(d) {
      return d.id;
    }, function(d) {
      showDelivery(d.id);
    });
    
    /* Build lists for ongoing deliveries */
    fillDeliveryList($('#order-list-history'), data.old_deliveries, function(d) {
      return d.restaurant;
    }, function(d) {
      return d.state_since;
    }, function(d) {
      return d.id;
    }, function(d) {
      showDelivery(d.id);
    });
        
    /* Build list for unrated meals */
    fillDeliveryList($('#meal-list-ratable'), data.ratable_dishes, function(d) {
      return d.name;
    }, function(d) {
      return 'Bought from ' + d.restaurant + ' on ' + d.bought_on;
    }, function(d) {
      return d.id;
    }, function(d) {
      rateMeal(d);
    });
    
    /* Fade loading overlay out */
    hideLoadingOverlay();
    
  });
});

$('#btn-logout').click(function() {
  /* Show the overlay */
  showLoadingOverlay(function() {
    /* Load the session */
    var session = getSession();
    /* Call logout */
    $.rest.get('api/1.0/customer/logout.php', session, function() {
      deleteSession();
      leaveTo('index.php');
    })
  });
});
  
function fillDeliveryList(list, data, titleFunction, subtitleFunction, itemFunction, onclickFunction) {
  /* Set ongoing deliveries */
  if(data.length > 0) {
    /* Load template */
    var template = $(list).find('ul>template').html().trim();

    /* Empty list */
    $(list).find('ul').html('');

    /* Iterate over items */
    $(data).each(function(i, d) {
      /* Duplicate template */
      var e = $(template); 

      /* Set item id */
      e.attr('item', itemFunction(d));
      
      /* Set information */
      e.find('.title').html(titleFunction(d));
      e.find('.detail').html(subtitleFunction(d));

      /* Set onclick */
      e.click(function() {
        onclickFunction(d);
      });

      /* Add */
      $(list).find('ul').append(e);

    });
  }
}

function showDelivery(id) {
  /* Show modal in loading state */
  $('#delivery-modal').modal('show');
  $('#delivery-modal .modal-body-loading').show(); 
  $('#delivery-modal .modal-body-content').hide(); 
  
  /* Create params */
  var params = getSession();
  params['delivery'] = id;
  
  /* Load data */
  $.rest.get('api/1.0/customer/delivery.php', params, function(data) {
    /* Handle errors */
    if(handleError(data)) {
      $('#delivery-modal').modal('hide');
      return;
    }
    
    /* Fill in meals and calculate complete delivery value */
    var completeValue = data.shipping_cost;
    var list = $('#delivery-modal #delivery-meal-list');
    var template = list.find('tbody template').html().trim();
    list.find('tbody').children('.meal').remove();
    $(data.dishes).each(function(i, d) {
      /* Build item */
      var e = $(template);
      e.find('.meal-id').html(d.id);
      e.find('.meal-name').html(d.name);
      e.find('.meal-price').html(d.price);
      e.find('.meal-amount').html(d.quantity);
      
      /* Add price */
      completeValue += d.price * d.quantity;

      /* Append value */
      list.find('tbody').append(e);
      
    });
    
    /* Fill in states */
    list = $('#delivery-modal #delivery-state-list');
    template = list.find('tbody template').html().trim();
    list.find('tbody').children('.state').remove();
    $(data.states).each(function(i, d) {
      /* Build item */
      var e = $(template);
      e.find('.state-date').html(d.date);
      e.find('.state-state').html(d.state);

      /* Append value */
      list.find('tbody').append(e);
      
    });
    
    /* Fill in information */
    $('#delivery-modal .delivery-id').html(id);
    $('#delivery-modal .delivery-restaurant').html(data.restaurant);
    $('#delivery-modal .delivery-phone').html(data.phone);
    $('#delivery-modal .delivery-shipping-cost').html(data.shipping_cost);
    $('#delivery-modal .delivery-value').html(completeValue);
    $('#delivery-modal .delivery-name').html(data.first_name + ' ' + data.sure_name);
    $('#delivery-modal .delivery-street').html(data.street);
    $('#delivery-modal .delivery-postal-code').html(data.postcode);
    $('#delivery-modal .delivery-city').html(data.city);
    $('#delivery-modal .delivery-country').html(data.country);
    
    /* Change state to normal */
    $('#delivery-modal .modal-body-loading').hide(); 
    $('#delivery-modal .modal-body-content').show(); 
  });
}

function rateMeal(d) {
  /* Show modal in normal state */
  $('#rate-modal').modal('show');
  $('#rate-modal .modal-body-loading').hide(); 
  $('#rate-modal .modal-body-content').show(); 
  
  /* Set title and reset inputs */
  $('#rate-modal .meal-name').html(d.name);
  $('#rate-modal .rating-input span:first-child').trigger('mouseenter');
  $('#rate-modal textarea').val('');
  
  /* Set id */
  $('#rate-modal').attr('meal-id', d.id);
  
}

$('#meal-modal-save').click(function() {
  /* Go to loading state  */
  $('#rate-modal .modal-body-loading').show(); 
  $('#rate-modal .modal-body-content').hide(); 
  
  /* Save */
  var id = $('#rate-modal').attr('meal-id');
  var params = getSession();
  params.rating = $('.rating-input').attr('value');
  params.meal = id
  params.comment = $('#rate-modal textarea').val();
  $.rest.put('api/1.0/customer/rate.php', params, function(data) {
    /* Handle errors */
    if(!data.success) {
      showErrorOverlay('An Error occured while loading the Page', 
                       'The page can not be displayed', 
                       undefined);
      console.error('An error occured while requesting data from the server:')
      console.error(data);
      return;
    }
    
    /* Hide modal */
    $('#rate-modal').modal('hide');
    
    /* Remove from list */
    $('#meal-list-ratable .list-group-item[item="' + id + '"]').remove();
    
  })
});

/* Hover handler for the stars of the rating input */
$('.rating-input span').hover(function() {
  /* Fetch value of the hovered star and set as new value for the parent */
  var rating = $(this).attr('rating');
  $(this).parent().attr('value', rating);
  
  /* Update the stars to display the new value */
  $(this).parent().children('span').each(function(i) {
    $(this).html(i < rating ? '★' : '☆');
  
  });  
});