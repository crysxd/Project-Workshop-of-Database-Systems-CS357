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
    
    $input = file_get_contents("php://input");
    $input = json_decode($input,true);

    $args_str = array("user", "session");
    $args_put_str = array('restaurant', 'dishes', 'address');
    $args_address_str = array('road', 'city', 'postal_code', 'state', 'country', 'lat', 'long');
    $args_dish_str = array('id', 'quantity');

    check_parms_available($args_str); 
  
    $args = array();
    foreach ($args_str as $arg_str)
      $args[$arg_str] = $_GET[$arg_str];
    
    // Checking if user has this session id
    check_customer_session($args['user'], $args['session']);
    
    // if there are no dishes to add we don't have to insert anything and the process can die
    if (empty($input['dishes']))
      die();
    
    check_parms_available_in_array($args_put_str, $input, false);
    $input['restaurant'] = htmlentities($db_link->real_escape_string($input['restaurant']));
    
 
    foreach ($input['dishes'] as $dish)
      check_parms_available_in_array($args_dish_str, $dish, true);
    
    check_parms_available_in_array($args_address_str, $input['address'], true);
    
    $args['dishes'] = array();
    $args['address'] = array();
    
    foreach ($args_put_str as $arg_str)
      $args[$arg_str] = $input[$arg_str];
    
    $answer = array();

    $answer['succes'] = true;
    // Prepare Statements

    //// TODO Check thread safety: Two threads both fetch the next auto_increment value, so both get the same one
    //// Get the next avaible id for a new delivery
    $stmt_status_result = $db_link->query("SHOW TABLE STATUS LIKE 'Delivery'");
    $fetched_row_status = $stmt_status_result->fetch_assoc();
    $next_delivery_id = intval($fetched_row_status['Auto_increment']);
    
    //// Insert into Delivery table
    $stmt_insert_delivery = "
        INSERT INTO `Delivery` (`delivery_id_pk`, `Customer_customer_id`, 
            `Restaurant_restaurant_id`, `street_number`, `street_name`, `postcode`, `city`, `add_info`, `comment`) 
        VALUES ($next_delivery_id, ?, ?, ?, ?, ?, ?, NULL, NULL)";
  
    if(!($insert_delivery_result = push_stmt($stmt_insert_delivery, "iissss", 
          array(&$args['customer_id'], &$args['restaurant'],  &$args['address']['number'], &$args['address']['road'], &$args['address']['city'], &$args['address']['postcode']))))
      db_error($answer);
    /*
    if ($stmt_insert_delivery_result =  $db_link->prepare($stmt_insert_delivery)){
      $stmt_insert_delivery_result->bind_param("iissss", $fetched_row_check_session['customer_id'], $restaurant, $address['number'],
                                                $address['street'], $address['city'], $address['postcode']);
      $insert_delivery_result = $stmt_insert_delivery_result->execute();
    }else {
      db_error($answer, "In file " . __FILE__ ." in line " . __LINE__ );
    }
    */
    
    if($db_link->errno || !$insert_delivery_result)
      db_error($answer);

    //// Insert into Delivery_State table
    $stmt_insert_delivery_state = "
        INSERT INTO `Delivery_State` (`Delivery_delivery_id_pk`, `date_pk`, `Delivery_State_Type_delivery_status_type`, `comment`) 
        VALUES ($next_delivery_id, '$order_time', 1, NULL)";
    if (!($db_link->query($stmt_insert_delivery_state)))
      db_error($answer);

    
    //// Insert into Delivery_Meal_Map table
    $stmt_insert_delivery_meal_map = "
          INSERT INTO `Delivery_Meal_Map` (`Delivery_delivery_id_pk`, `Meal_meal_id_pk`, `amount`) 
          VALUES ($next_delivery_id, ?, ?)";
    

    
    $stmt_insert_delivery_meal_map_result = $db_link->prepare($stmt_delivery_meal_map);

    foreach ($dishes as $dish){
      //check_parms_available(array("id", "quantity"),$dish); TODO create such a function for two arrays
      if(!($insert_delivery_meal_map_result = push_stmt($stmt_insert_delivery_meal_map, "ii", 
            array(&$args['dish']['id'], &$args['dish']['quantity']))))
        db_error($answer);
      //$stmt_insert_delivery_meal_map_result->bind_param("ii", $dish['id'], $dish['quantity']);
      //$insert_delivery_meal_map_result = $stmt_insert_delivery_meal_map_result->execute();

      if($db_link->errno || !$insert_delivery_meal_map_result ){
        db_error($answer);
      }
    }
    
    // Getting the phone number of a restaurant
    $answer['restaurant_phone'] = "" ;
    $stmt_select_restaurant_phone = "
        SELECT CONCAT(  '+', r.region_code, ' ', r.national_number ) restaurant_phone FROM Restaurant WHERE restaurant_id_pk = ?";
    
    if(!($select_restaurant_phone_result = push_stmt($stmt_select_restaurant_phone, "i", 
          array(&$args['restaurant']))))
      db_error($answer);
    
    if(!(add_answer($answer, $select_restaurant_phone_result, 
          array('restaurant'))))
      db_error($answer);
    
    /*if($stmt_select_restaurant_phone_result = $db_link->prepare($stmt_select_restaurant_phone)){
      $stmt_select_restaurant_phone_result->bind_param("i", $restaurant);
      $stmt_select_restaurant_phone_result->execute();
      $select_restaurant_phone_result = $stmt_select_restaurant_phone_result->get_result();
    } else {  
      db_error($answer, "Select: Restaurant with restaurant_id_pk: $restaurant. Line " . __LINE__);
    }

    if($select_restaurant_phone_result && $select_restaurant_phone_result->num_rows == 1
        && ($fetched_select_restaurant_phone = $select_restaurant_phone_result->fetch_assoc())){
      $answer['restaurant_phone'] = $fetched_select_restaurant_phone['restaurant_phone'];
    } else {
      if(!$select_restaurant_phone_result)
        db_error($answer, "Fetch Restaurant: Getting results failed. Line " . __LINE__);
      elseif($select_restaurant_phone_result->num_rows != 1)
        db_error($answer, "Fetch Restaurant: The number of rows is not correct; Number of rows: $select_restaurant_phone_result->num_rows. Line " . __LINE__);
      else
        db_error($answer, "Fetch Restaurant: Something else failed. Probably fetching the result. Line " . __LINE__); 
    }*/

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
    
    // set parameters
    $user = $_GET['user'];
    $session = $_GET['session'];
    $delivery = $_GET['delivery'];

    // create answer array
    $answer = array();

    // Checking if user has this session id
    check_customer_session($user, $session);

    
    //
    $stmt_select_head_info = "
        SELECT r.name restaurant, CONCAT(  '+', r.region_code, ' ', r.national_number ) phone , r.shipping_cost, CONCAT(d.number,' ' ,d.street) street, d.city, d.postcode
        FROM Restaurant r
        INNER JOIN (

          SELECT street_number number, street_name street, city, postcode, Restaurant_restaurant_id
          FROM Delivery
          WHERE delivery_id_pk = ?
        )d ON r.restaurant_id_pk = d.Restaurant_restaurant_id";
    
    $stmt_select_dishes = "
        SELECT dmm_d.id, m.name, dmm_d.quantity, m.price
        FROM (

          SELECT dmm.Meal_meal_id_pk id, dmm.amount quantity
          FROM (

            SELECT delivery_id_pk
            FROM Delivery
            WHERE delivery_id_pk = ?
          )d
          INNER JOIN Delivery_Meal_Map dmm ON dmm.Delivery_delivery_id_pk = d.delivery_id_pk
        )dmm_d
        INNER JOIN Meal m ON dmm_d.id = m.meal_id_pk";
    
    $stmt_select_states = "
        SELECT dst.name state, ds.date_pk date
        FROM (

          SELECT Delivery_State_Type_delivery_status_type state_id, date_pk
          FROM Delivery_State
          WHERE Delivery_delivery_id_pk = ?
        )ds
        INNER JOIN Delivery_State_Type dst ON ds.state_id = dst.delivery_status_type_id_pk
    ";
    
    $answer['success'] = true;

    // Processes $stmt_select_head_info statement
    if(!($select_head_info_result = push_stmt($stmt_select_head_info, "i", array(&$delivery))))
      db_error($answer, "In file " . __FILE__ ." in line " . __LINE__ );
    
    if(!(add_answer($answer, $select_head_info_result, 
                    array('restaurant', 'phone', 'shipping_cost', 'street', 'city', 'postcode'))))
      db_error($answer, "In file " . __FILE__ ." in line " . __LINE__ );
    
    
    // Processes $stmt_select_dishes statement
    
    //// Bind and execute $stmt_select_dishes
    $answer['dishes'] = array();
    
    if(!($select_dishes_result = push_stmt($stmt_select_dishes, "i", array(&$delivery))))
      db_error($answer, "In file " . __FILE__ ." in line " . __LINE__ );

    while($select_dishes_result && ($fetched_select_dishes_row = $select_dishes_result->fetch_assoc()))
      $answer['dishes'][] = $fetched_select_dishes_row;  
    
    // Processes $stmt_select_states statement
    
    //// Bind and execute $stmt_select_states
    $answer['states'] = array();
      
    if(!($select_states_result = push_stmt($stmt_select_states, "i", array(&$delivery))))
      db_error($answer, "In file " . __FILE__ ." in line " . __LINE__ );

    while($select_states_result && ($fetched_select_states_row = $select_states_result->fetch_assoc()))
      $answer['states'][] = $fetched_select_states_row;
    
    // Sends the answer
    echo json_encode($answer);
    db_close();
  }




?>