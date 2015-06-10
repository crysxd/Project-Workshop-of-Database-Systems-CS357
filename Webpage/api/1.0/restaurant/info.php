<?php

  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // Select which code to run based on request method
  switch ($_SERVER['REQUEST_METHOD']) {
    case 'PUT':
      rest_put();  
      break;
    case 'POST':
      rest_post();  
      break;
    case 'GET':
      rest_get();  
      break;
    default:
      die(json_encode(array("success" => false, "err_no" => ERROR_GENERAL, "err_msg" => "Unsuported method {$_SERVER['REQUEST_METHOD']}")));
  }

  // close database connection
  db_close();

  /****************************************************************************************************************************
   * Handles put requests
   */     
  function rest_put() {
    global $db_link;
    
    // assure all required parameters are available, will die if not all are available
    check_parms_available(array("name", "min_order_value", "shipping_costs", "max_delivery_range", 
                                "street", "postcode", "phone", "city", "country", "position_lat", "position_long",
                                "pw", "description"));
        
    // create answer array
    $answer = array();
    $answer['success'] = false;

    // Check if params are sufficient
    // Password should have at least 6 characters
    if(strlen($_GET['pw']) < 6) {
      $answer['err_no'] = 1003;
      die(json_encode($answer));
    }
  
    // hash password
    $password = hash(PASSWORD_HASH_FUNCTION, $_GET['pw']);
    
    // prepare statement
    $stmt = $db_link->prepare("INSERT INTO restaurant(region_code, min_order_value, shipping_cost, max_delivery_range, name,".
                              "street_name, postcode, national_number, city, country, position_lat, position_long, password,".
                              "description) VALUES('+86', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    
    // If preperation failed
    if(!$stmt) {
      db_error();
    }
    
    // Bind parameters
    $stmt->bind_param("iiissssssssss", $_GET['min_order_value'], $_GET['shipping_costs'], $_GET['max_delivery_range'],
                      $_GET['name'], $_GET['street'], $_GET['postcode'], $_GET['phone'], $_GET['city'], $_GET['country'],
                      $_GET['position_lat'], $_GET['position_long'], $password, $_GET['description']);
    
    // execute
    if(!$stmt->execute()) {
      db_error();
      
    } else {
      $id =  $db_link->insert_id;
      $answer['success'] = true;
      $answer['id'] = $id;
      $answer['session'] = start_restaurant_session($id);
      $answer['name'] = $_GET['name'];
            
      // Get path and copy
      $file = get_restaurant_icon_file_name($id);
      save_image_from_input($file);
            
    }
    
    // Encode answer as json and print aka send
    echo json_encode($answer);
    
  }
        
  /****************************************************************************************************************************
   * Handles put requests
   */     
  function rest_post() {
    // create answer array
    $answer = array("success" => false, "err_no" => ERROR_GENERAL, "err_msg" => "Not implemented");
       
    // Encode answer as json and print aka send
    echo json_encode($answer);
  }
        
  /****************************************************************************************************************************
   * Handles get requests
   */     
  function rest_get() {
    // create answer array
    $answer = array("success" => false, "err_no" => ERROR_GENERAL, "err_msg" => "Not implemented");
       
    // Encode answer as json and print aka send
    echo json_encode($answer);
  }




?>