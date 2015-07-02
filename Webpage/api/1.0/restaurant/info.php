<?php

  // include main database script
  include_once("../db.php");
  include_once("../../../../vendor/autoload.php");

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
    check_parms_available(array("name", "min_order_value", "shipping_cost", "max_delivery_range", 
                                "street", "postcode", "phone", "city", "country", "position_lat", "position_long",
                                "pw", "description"));
    
    // Check if params are sufficient
    // Password should have at least 6 characters
    if(strlen($_GET['pw']) < 6) {
        $answer = array();
        $answer['err_no'] = 1003;
        $answer['success'] = false;
    }
    
    // prepare insert empty
    $u = "undefined";
    $stmt = $db_link->prepare("INSERT INTO restaurant(region_code, min_order_value, shipping_cost, max_delivery_range, name,".
                              "street_name, postcode, national_number, city, country, position_lat, position_long, password,".
                              "description, offered) ".
                              "VALUES('+86', 0, 0, 0, '$u', '$u', '$u', '$u', '$u', '$u', 0, 0, 0, '$u', 0)");

    // insert empty
    if(!$stmt || !$stmt->execute()) {
      db_error();
    }
        
    // inject id in $_GET
    $_GET['id'] = $db_link->insert_id;
    
    // start session and inject in $_GET
    $_GET['session'] = start_restaurant_session($_GET['id']);
    
    // call post to update the stub
    rest_post();
    
  }
        
  /****************************************************************************************************************************
   * Handles put requests
   */     
  function rest_post() {
    global $db_link;
    
    // assure all required parameters are available, will die if not all are available
    check_parms_available(array("name", "min_order_value", "shipping_cost", "max_delivery_range", 
                                "street", "postcode", "phone", "city", "country", "position_lat", "position_long",
                                "description", "id", "session"));
    
    // assure user is logged in
    check_restaurant_session($_GET['id'], $_GET['session']);  
    
    // create answer array
    $answer = array();
    $answer['success'] = false;
    
    // Parse phone number
    $phone_number = $_GET['phone'];
    $phoneNumber = new \libphonenumber\PhoneNumber();
    $phoneUtil = \libphonenumber\PhoneNumberUtil::getInstance();
    try {
      // extracts the phone number fragments and saves them into the $phone_number object
      $phone_number_proto = $phoneUtil->parse($phone_number, "CH", $phoneNumber);
    } catch (\libphonenumber\NumberParseException $e) {
      db_error(array(), "Phone number is unvalid.", $ERROR_WRONG_PHONE_FORMAT);
    }
    
    // checks if phone number is valid
    if(!($phoneUtil->isValidNumber($phone_number_proto))) {
      db_error(array(), "Phone number is unvalid.", $ERROR_WRONG_PHONE_FORMAT);
    }
    
    $region_code = $phoneNumber->getCountryCode();
    $national_number = $phoneNumber->getNationalNumber();
    

    // prepare statement
    $stmt = $db_link->prepare("UPDATE restaurant ".
                              "SET region_code = ?, min_order_value = ?, shipping_cost = ?, max_delivery_range = ?, ".
                              "name = ?, street_name = ?, postcode = ?, national_number = ?, city = ?, country = ?, ".
                              "position_lat = ?, position_long = ?, description = ?, offered = 1 ".
                              "WHERE restaurant_id_pk = ?");
    
    // If preperation failed
    if(!$stmt) {
      db_error();
    }
    
    // Bind parameters
    $bind = $stmt->bind_param("siiisssssssssi", $region_code, $_GET['min_order_value'], $_GET['shipping_cost'], $_GET['max_delivery_range'],
                              $_GET['name'], $_GET['street'], $_GET['postcode'], $national_number, $_GET['city'], $_GET['country'],
                              $_GET['position_lat'], $_GET['position_long'], $_GET['description'], $_GET['id']);
    
    // execute
    if(!$bind || !$stmt->execute()) {
      db_error();
      
    } 

    // Get path and copy
    $file = get_restaurant_icon_file_name($_GET['id']);
    save_image_from_input($file);
                 
    // if a new password is supplied, update it
    if(array_key_exists('pw', $_GET) && strlen($_GET['pw']) > 0) {
      // Check if params are sufficient
      // Password should have at least 6 characters
      if(strlen($_GET['pw']) < 6) {
        $answer = array();
        $answer['err_no'] = 1003;
        $answer['success'] = false;
        die(json_encode($answer));
      }
      
      // hash password
      $password = hash(PASSWORD_HASH_FUNCTION, $_GET['pw']);
      
      //prepare
      $stmt = $db_link->prepare("UPDATE restaurant SET password = ? WHERE restaurant_id_pk = ?");
      
      // bind, execute and fetch result
      if(!$stmt || !$stmt->bind_param("si", $password, $_GET['id']) || !$stmt->execute()) {
        db_error();
      }
    }
    
    // Encode answer as json and print aka send
    rest_get();

  }
        
  /****************************************************************************************************************************
   * Handles get requests
   */     
  function rest_get() {
    global $db_link;
    
    // Check params and session
    check_parms_available(array("id", "session"));
    check_restaurant_session($_GET['id'], $_GET['session']); 
    
    // prepare query
    $stmt = $db_link->prepare("SELECT *, CONCAT('+', region_code, ' ', national_number) AS phone FROM restaurant WHERE restaurant_id_pk = ?");
    
    // check, bin, execute and get results
    if(!$stmt || !$stmt->bind_param("i", $_GET["id"]) || !$stmt->execute() || !$result=$stmt->get_result()) {
      db_error();
    }
    
    // create answer
    $answer = $result->fetch_assoc();
    $answer['id'] = $_GET['id'];
    $answer['success'] = true;
    $answer['session'] = $answer['session_id'];
    unset($answer['restaurant_id_pk']);
    unset($answer['password']);
    unset($answer['session_id']);
    unset($answer['national_number']);
    unset($answer['region_code']);
    
    // Load icon
    $file = get_restaurant_icon_file_name($_GET['id']);
    if(file_exists($file)) {
      $answer['icon'] = file_get_contents($file);
    }
    
    // Encode answer as json and print aka send
    echo json_encode($answer);
  }




?>