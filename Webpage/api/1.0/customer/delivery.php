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
    $input = file_get_contents("php://input");
    $input = json_decode($input,true);

    $args_str = array("user", "session");
    $args_put_str = array('restaurant', 'dishes', 'address');
    $args_address_str = array('road', 'city', 'postal_code', 'country', 'lat', 'lng');
    $args_dish_str = array('id', 'quantity');

    check_parms_available($args_str); 
  
    $args = array();
    foreach ($args_str as $arg_str)
      $args[$arg_str] = $_GET[$arg_str];
    
    // Checking if user has this session id
    check_customer_session($args['user'], $args['session']);
  
    // if there are no dishes to add we don't have to insert anything and the process can die
    if (empty($input['dishes']))
      db_error($answer, '$dishes may not be empty');
    
    check_parms_available_in_array($args_put_str, $input, false);
    $input['restaurant'] = htmlentities($db_link->real_escape_string($input['restaurant']));
    
    foreach ($input['dishes'] as $dish)
      check_parms_available_in_array($args_dish_str, $dish, true);
    
    check_parms_available_in_array($args_address_str, $input['address'], true);
    
    $args['dishes'] = array();
    $args['address'] = array();
    
    foreach ($args_put_str as $arg_str){
      $args[$arg_str] = $input[$arg_str];
    }
    
    // If no street number is given the number is empty
    if(!(array_key_exists('number', $args['address'])))
      $args['address']['number']= '';
    
    $answer = array();

    $answer['succes'] = true;
    
    // check if the distance is ok
    $stmt_check_distance = "      
      SELECT COUNT( max_delivery_range > DISTANCE( position_lat, position_long, ?, ? ) ) ok
      FROM Restaurant
      WHERE restaurant_id_pk = ?
      ";
    
    if(!($select_check_distance_result = push_stmt($stmt_check_distance, "ddi", 
              array(&$args['address']['lat'], &$args['address']['lng'],  &$args['restaurant']))))
      db_error($answer);
    
    if($select_check_distance_result->fetch_assoc()['ok'] != 1) {
      db_error($answer, "Restaurant_id and address does not match in distance");
    }

    // check if the delivery value fullfills the minimum amount of the restaurant
    $stmt_meal_value = "SELECT price FROM Meal WHERE meal_id_pk = ?";
    
    $meal_value_sum = 0;
    foreach ($args['dishes'] as $dish){
      if(!($stmt_meal_value_result = push_stmt($stmt_meal_value, "i", 
            array(&$dish['id']))))
        db_error(array(), "Meal ID is unvalid.", $ERROR_GENERAL);
      $meal_value_sum += $stmt_meal_value_result->fetch_assoc()['price'];
    }
    
    $stmt_restaurant_min_order_value = "SELECT min_order_value FROM Restaurant WHERE restaurant_id_pk = ?";
    
    if(!($stmt_restaurant_min_order_value_result = push_stmt($stmt_restaurant_min_order_value, "i", 
      array(&$args['restaurant']))))
      db_error(array(), "Restaurant ID is unvalid.", $ERROR_GENERAL);
    
    $restaurant_min_order_value = $stmt_restaurant_min_order_value_result->fetch_assoc()['min_order_value'];
    if ($restaurant_min_order_value > $meal_value_sum)
      db_error(array(), "Delivery value to low.", $ERROR_TOO_LOW_DELIVERY_VALUE);
    
    //  Statements
    
    // Get customer id with nick $user
    if(!($select_user_id = push_stmt("SELECT customer_id_pk FROM Customer WHERE nick=? AND session_id=?", "ii", 
              array(&$args['user'], &$args['session']))))
      db_error($answer);
    $args['customer_id'] = $select_user_id->fetch_assoc()['customer_id_pk'];
    
    // Insert into Delivery table
    $stmt_insert_delivery = "
        INSERT INTO `Delivery` (`Customer_customer_id`, 
            `Restaurant_restaurant_id`, `country`, `postcode`, `city`, `street_name`, `street_number`, `add_info`, `comment`) 
        VALUES (?, ?, ?, ?, ?, ?, ?, NULL, NULL)";
    
    if(!(push_stmt_insert($stmt_insert_delivery, "iisssss", 
            array(&$args['customer_id'], &$args['restaurant'],  &$args['address']['country'], &$args['address']['postal_code'],
            &$args['address']['city'], &$args['address']['road'] , &$args['address']['number']))))
      db_error($answer);
    
    // Get the last inserted primary key
    $next_delivery_id = $db_link->insert_id;
  
    // Insert into Delivery_State table
    $stmt_insert_delivery_state = "
        INSERT INTO `Delivery_State` (`Delivery_delivery_id_pk`, `Delivery_State_Type_delivery_status_type`, `comment`) 
        VALUES ($next_delivery_id, 1, NULL)";
    if (!($db_link->query($stmt_insert_delivery_state)))
      db_error($answer);

    
    // Insert into Delivery_Meal_Map table
    $stmt_insert_delivery_meal_map = "
          INSERT INTO `Delivery_Meal_Map` (`Delivery_delivery_id_pk`, `Meal_meal_id_pk`, `amount`) 
          VALUES ($next_delivery_id, ?, ?)";
    
    foreach ($args['dishes'] as $dish){
      if(!(push_stmt_insert($stmt_insert_delivery_meal_map, "ii", 
            array(&$dish['id'], &$dish['quantity']))))
        db_error($answer);   
    }
    
    // Getting the phone number of a restaurant
    $answer['restaurant_phone'] = "" ;
    $stmt_select_restaurant_phone = "
        SELECT CONCAT(  '+', r.region_code, ' ', r.national_number ) restaurant_phone FROM Restaurant r WHERE restaurant_id_pk = ?";
    
    if(!($select_restaurant_phone_result = push_stmt($stmt_select_restaurant_phone, "i", 
          array(&$args['restaurant']))))
      db_error($answer);
    
    if(!(add_answer($answer, $select_restaurant_phone_result, 
          array('restaurant_phone'))))
      db_error($answer);

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
        SELECT r.name restaurant, CONCAT(  '+', r.region_code, ' ', r.national_number ) phone , r.shipping_cost, CONCAT(d.number,' ' ,d.street) street, d.city, d.postcode, d.country
        FROM Restaurant r
        INNER JOIN (

          SELECT country, street_number number, street_name street, city, postcode, Restaurant_restaurant_id
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
        SELECT dst.name state, ds.date_pk date, comment
        FROM (

          SELECT Delivery_State_Type_delivery_status_type state_id, date_pk, comment
          FROM Delivery_State
          WHERE Delivery_delivery_id_pk = ?
        )ds
        INNER JOIN Delivery_State_Type dst ON ds.state_id = dst.delivery_status_type_id_pk
    ";
    
    $answer['success'] = true;

    // Processes $stmt_select_head_info statement
    if(!($select_head_info_result = push_stmt($stmt_select_head_info, "i", array(&$delivery))))
      db_error();
    
    if(!(add_answer($answer, $select_head_info_result, 
                    array('restaurant', 'phone', 'shipping_cost', 'street', 'city', 'postcode', 'country'))))
      db_error();
    
    
    // Processes $stmt_select_dishes statement
    
    //// Bind and execute $stmt_select_dishes
    $answer['dishes'] = array();
    
    if(!($select_dishes_result = push_stmt($stmt_select_dishes, "i", array(&$delivery))))
      db_error();

    while($select_dishes_result && ($fetched_select_dishes_row = $select_dishes_result->fetch_assoc()))
      $answer['dishes'][] = $fetched_select_dishes_row;  
    
    // Processes $stmt_select_states statement
    
    //// Bind and execute $stmt_select_states
    $answer['states'] = array();
      
    if(!($select_states_result = push_stmt($stmt_select_states, "i", array(&$delivery))))
      db_error();

    while($select_states_result && ($fetched_select_states_row = $select_states_result->fetch_assoc()))
      $answer['states'][] = $fetched_select_states_row;
    
    // Sends the answer
    echo json_encode($answer);
    db_close();
  }




?>