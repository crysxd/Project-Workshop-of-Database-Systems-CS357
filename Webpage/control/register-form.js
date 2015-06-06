/* Click handler for register complete button */
$('#btn-register-complete').click(function() {

  /* Check that there is data in all fields */
  var emptyFields = $('#register-form input').filter(function(){ return !this.value });
  if(emptyFields.length > 0) {
    /* Show popover */
    $(emptyFields[0]).popover(
      {content: 'Please fill in this field', placement: 'bottom'}).popover('show');
    /* Scroll to field */
    scrollTo(emptyFields[0]);
    return;
  }

  /* Load values */
  var params = new Object();
  params.name = $('#register-name').val();
  params.pw = $('#register-password').val();
  params.phone = $('#register-phone').val();
  params.min_order_value = $('#register-min-value').val();
  params.max_delivery_range = $('#register-range').val();
  params.shipping_costs = $('#register-shipping-costs').val();
  params.description = $('#register-description').val();
  var icon = $('#register-icon-preview').attr('src');  
  var address = $('#register-address-search').attr('result');

  /* Check if the user searched for the address */
  if(address == null) {
    alert("Please search for your address");
    return;
  }

  /* Decode */
  address = JSON.parse(address);
  
  /* Copy, prevent values from being empty */
  params.street = address.simple.road ? address.simple.road : "null"
  params.city = address.simple.city ? address.simple.city : "null";
  params.country = address.simple.country ? address.simple.country : "null";
  params.postcode = address.simple.postcode ? address.simple.postcode : "null";
  params.position_lat = address.geometry.location.lat;
  params.position_long = address.geometry.location.lng;

  /* Check if passwords matches its control */
  if(params.pw != $('#register-password-control').val()) {
    /* Show popover */
    $('#register-password').popover(
      {content: 'The passwords do not match', placement: 'bottom'}).popover('show');
    /* Scroll to field */
    scrollTo($('#register-password'));
    return;
  }

  /* Check if password is long enough */
  if(params.pw.length < 6) {
    /* Show popover */
    $('#register-password').popover(
      {content: 'The password must have at least 6 characters', placement: 'bottom'}).popover('show');
    /* Scroll to field */
    scrollTo($('#register-password'));
    return;
  }
  
  /* Set button to loading state */
  $('#btn-register-complete').button('loading');
  
  /* Send data */
  $.rest.put('../api/1.0/restaurant/info.php', params, function(data) {
    /* Handle errors */
    if(!data.success) {
      if(data.err_no == 1000) {
        alert('A restaurant with the same name already exists.');
      } else {
        alert('A network error occured.');  
      }
      console.error(data);
      return;
    }
    
    /* Save session */
    delete data.success;
    localStorage.setItem('restaurantSession', JSON.stringify(data));
    
    /* Tell user his id */
    alert('Your restaurant ID is: ' + data.id + '\nYou need this id to login!');
    
    /* Reset button state */
    $('#btn-register-complete').button('reset');
    
    /* Forward to control */
    window.location.href = 'control.html';
    
  }, icon);
});

/* Value change handler for the icon input */
$('#register-icon').change(function(e) {
  /* Read image file */
  var reader = new FileReader();
  reader.onload = function(result) {
    /* Check the image size */
    if(result.currentTarget.result.length > 100000) {
      alert("The file size must not exceed 100kb.");
      $('#register-icon').val('');
      return;
    }

    /* Set the data in the preview img */
    $('#register-icon-preview').attr('src', result.currentTarget.result);      
  };

  /* Read the file */
  reader.readAsDataURL(e.target.files[0]);

});

/* Click handler for address search button */
$('#btn-search-address').click(function() {
  /* Show dialog in loading state */
  $('#address-modal').modal('show'); 
  $('#address-modal .modal-body-loading').show(); 
  $('#address-modal .modal-body-content').hide();
  
  /* Query data */
  $.rest.get('http://www.kart4you.de/meals/geo.php', {address: $('#register-address-search').val()}, function(data) {

    /* Handle errors */
    if(!data.success || data.data.status !== "OK" && data.data.status !== "ZERO_RESULTS") {
      alert('A network error occured while loading the results. ' +
            'Make sure you are connected to the internet and try again.');
      console.error(data);
      $('#address-modal').modal('hide'); 
      return;
    }

    /* Nothing found */
    if(data.data.results.length == 0) {
      alert('There where no results for your search, try to be more specific.');
      $('#address-modal').modal('hide'); 
      return;
    }

    /* Load template */
    var template = $('#register-address-list template').html().trim();

    /* Truncate list */
    $('#register-address-list>address').remove();

    /* Make list */
    $(data.data.results).each(function(i, d) {
      /* Copy and fill template */
      var e = $(template);
      e.find('.road').text(d.simple.road);
      e.find('.city').text(d.simple.city);
      e.find('.postal_code').text(d.simple.postal_code);
      e.find('.state').text(d.simple.state);
      e.find('.country').text(d.simple.country);
      
      /* Add click handler for button, hide modal and set address */
      e.click(function() {
        $('#address-modal').modal('hide'); 
        $('#register-address-search').attr('result', JSON.stringify(d));
        $('#register-address-search').val(d.formatted_address)
      });

      /* Append */
      $('#register-address-list').append(e);
    });
    
    /* Show result */
    $('#address-modal .modal-body-loading').hide(); 
    $('#address-modal .modal-body-content').show();
  
  });
});

/* Click handler for registerreset button */
$('#btn-register-reset').click(function() {
    alert("reset");

});

/* Hide hanler for popovers for inputs in login/register forms */
$('#register-form input').on('hidden.bs.popover', function () {
  /* Destroy popover after it is hidden */
  $(this).popover('destroy');
});

function scrollTo(elem) {
  /* Scroll to element */
  $('html, body').animate({
    scrollTop: $(elem).offset().top - 30
  }, 500);
}