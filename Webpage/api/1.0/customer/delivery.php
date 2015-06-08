<?php
  //http://www.ehow.com/how_8424199_remove-rows-array-php.html
  //http://stackoverflow.com/questions/12490028/delete-selected-row-from-table-in-php
  // http://php.net/manual/en/control-structures.foreach.php

  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // Select which code to run based on request method
  switch ($_SERVER['REQUEST_METHOD']) {
    case 'PUT':
      rest_put();  
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

    // gets a timestamp for the insert to the delivery state
    $order_time = date ("Y-m-d H:i:s");
    // create answer array
    $answer = array();

    // assure all required parameters are available, will die if not all are available
    check_parms_available(array("user", "session", "restaurant", "dishes", "address"));
    // assure query parameters are clean and set parameters
    escape_parms(array("user", "session", "restaurant"));

    $user = $_GET['user'];
    $session = $_GET['session'];
    $restaurant = $_GET['restaurant'];
    // Add brackets so it is recognized as json code
    $dishes = json_decode($_GET['dishes'],true);
    $address = json_decode($_GET['address'],true);

    // The array could not be decoded, potential attack
    if ($dishes == NULL || $address == NULL)
      db_error($answer, "Dish or address is null. Line " . __LINE__);

    // escapes the content of the arrays
    array_walk_recursive($dishes, 'mysqli_real_escape_string_asso_array');
    array_walk_recursive($address, 'mysqli_real_escape_string_asso_array');  


    // Prepare Statements

    //// Checking if user has this session id
    $stmt_check_session = "SELECT customer_id_pk customer_id FROM Customer WHERE nick = ? && session_id = ?";
    if ($stmt_check_session_result = $db_link->prepare($stmt_check_session)){
      $stmt_check_session_result->bind_param("ss", $user, $session);
      $check_session_result = $stmt_check_session_result->execute();
      $check_session_result = $stmt_check_session_result->get_result();
    } else {
      db_error($answer, "Select: Customer with nick: $user; and session_id: $session. Line " . __LINE__);
    }

    //// If user does not have the session id, the result will be empty
    if($check_session_result && $check_session_result->num_rows == 1 
        && ($fetched_row_check_session = $check_session_result->fetch_assoc())){
    } else {
      db_error($answer, "Line " . __LINE__);
    } 


    //// TODO Check thread safety: Two threads both fetch the next auto_increment value, so both get the same one
    //// Get the next avaible id for a new delivery
    $stmt_status_result = $db_link->query("SHOW TABLE STATUS LIKE 'Delivery'");
    $fetched_row_status = $stmt_status_result->fetch_assoc();
    $next_delivery_id = intval($fetched_row_status['Auto_increment']);

    //// Insert into Delivery table
    $stmt_insert_delivery = "
        INSERT INTO `Delivery` (`delivery_id_pk`, `Customer_customer_id`, `Restaurant_restaurant_id`, `street_number`, `street_name`, `postcode`, `city`, `add_info`, `comment`) 
        VALUES ($next_delivery_id, ?, ?, ?, ?, ?, ?, NULL, NULL)";
    if ($stmt_insert_delivery_result =  $db_link->prepare($stmt_insert_delivery)){
      $stmt_insert_delivery_result->bind_param("iissss", $fetched_row_check_session['customer_id'], $restaurant, $address['number'],
                                                $address['street'], $address['city'], $address['postcode']);
      $insert_delivery_result = $stmt_insert_delivery_result->execute();
    }else {
      db_error($answer, "Line " . __LINE__);
    }

    if($db_link->errno || !$insert_delivery_result)
      db_error($answer, "Line " . __LINE__);

    //// Insert into Delivery_State table
    $stmt_delivery_state = "
        INSERT INTO `Delivery_State` (`Delivery_delivery_id_pk`, `date_pk`, `Delivery_State_Type_delivery_status_type`, `comment`) 
        VALUES ($next_delivery_id, '$order_time', 1, NULL)";
    if (!($db_link->query($stmt_delivery_state)))
      db_error($answer, "Insert: Delivery_State failed. Line " . __LINE__);


    //// Insert into Delivery_Meal_Map table
    $stmt_delivery_meal_map = "
          INSERT INTO `Delivery_Meal_Map` (`Delivery_delivery_id_pk`, `Meal_meal_id_pk`, `amount`) 
          VALUES ($next_delivery_id, ?, ?)";
    if (!($insert_delivery_state_result = $db_link->prepare($stmt_delivery_state)))
      db_error($answer, "Insert: Delivery_Meal_Map failed. Line " . __LINE__);

    $stmt_insert_delivery_meal_map_result = $db_link->prepare($stmt_delivery_meal_map);

    foreach ($dishes as $dish){
      //check_parms_available(array("id", "quantity"),$dish); TODO create such a function for two arrays
      $stmt_insert_delivery_meal_map_result->bind_param("ii", $dish['id'], $dish['quantity']);
      $insert_delivery_meal_map_result = $stmt_insert_delivery_meal_map_result->execute();

      if($db_link->errno || !$insert_delivery_meal_map_result ){
        $dish_id = $dish['id'];
        db_error($answer, "Insert: Dish failed with id, $dish_id. Line " . __LINE__);
      }
    }
    // Getting the phone number of a restaurant
    $answer['restaurant_phone'] = "" ;
    $stmt_select_restaurant_phone = "SELECT region_code, national_number FROM Restaurant WHERE restaurant_id_pk = ?";
    if($stmt_select_restaurant_phone_result = $db_link->prepare($stmt_select_restaurant_phone)){
      $stmt_select_restaurant_phone_result->bind_param("i", $restaurant);
      $stmt_select_restaurant_phone_result->execute();
      $select_restaurant_phone_result = $stmt_select_restaurant_phone_result->get_result();
    } else {  
      db_error($answer, "Select: Restaurant with restaurant_id_pk: $restaurant. Line " . __LINE__);
    }

    if($select_restaurant_phone_result && $select_restaurant_phone_result->num_rows == 1
        && ($fetched_select_restaurant_phone = $select_restaurant_phone_result->fetch_assoc())){
    $answer['restaurant_phone'] = 
      implode(array($fetched_select_restaurant_phone['region_code'],$fetched_select_restaurant_phone['national_number']));
    } else {
      if(!$select_restaurant_phone_result)
        db_error($answer, "Fetch Restaurant: Getting results failed. Line " . __LINE__);
      elseif($select_restaurant_phone_result->num_rows != 1)
        db_error($answer, "Fetch Restaurant: The number of rows is not correct; Number of rows: $select_restaurant_phone_result->num_rows. Line " . __LINE__);
      else
        db_error($answer, "Fetch Restaurant: Something else failed. Probably fetching the result. Line " . __LINE__); 
    }

    $answer['eta_minutes'] = 30;
    $answer['success'] = true;

    echo json_encode($answer);
    db_close();
  }

  /****************************************************************************************************************************
   * Handles get requests
   */     
  function rest_get() {
    global $db_link;

    // assure all required parameters are available, will die if not all are available
    check_parms_available(array("user", "session", "delivery"));

    // assure query parameters are clean and set parameters
    $user = $db_link->real_escape_string($_GET['user']);
    $session = $db_link->real_escape_string($_GET['session']);
    $delivery = $db_link->real_escape_string($_GET['delivery']);

    // create answer array
    $answer = array();
    $answer['success'] = true;

    // Prepare Statements

    //// Checking if user has this session id
    $stmt_check_session_result = $db_link->prepare("SELECT nick FROM Customer WHERE nick = ? && session_id = ?");
    $stmt_check_session_result->bind_param("ss", $user, $session);
    $check_session_result = $stmt_check_session_result->execute();
    $check_session_result = $stmt_check_session_result->get_result();

    //// If user does not have the session id, the result will be empty
    if($check_session_result->num_rows() != 1)
      db_error($answer, "There is no user with this name and session_id");

    ///------
  }




?>
