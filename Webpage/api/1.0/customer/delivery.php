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
    $args_address_str = array('road', 'city', 'postal_code', 'country', 'lat', 'long');
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
    
    foreach ($args_put_str as $arg_str)
      $args[$arg_str] = $input[$arg_str];
    
    $answer = array();

    $answer['succes'] = true;
    //  Statements
    
    // Get customer id with nick $user
    if(!($select_user_id = push_stmt("SELECT customer_id_pk FROM Customer WHERE nick=? AND session_id=?", "ii", 
          array(&$args['user'], &$args['session']))))
      db_error($answer);
    $args['customer_id'] = $select_user_id->fetch_assoc();

    // gets the next delivery id
    
    // Insert into Delivery table
    $stmt_insert_delivery = "
        INSERT INTO `Delivery` (`Customer_customer_id`, 
            `Restaurant_restaurant_id`, `country`, `postcode`, `city`, `district`, `street_name`, `street_number`, `add_info`, `comment`) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, NULL, NULL)";
    
    if(!(push_stmt_insert($stmt_insert_delivery, "iissssss", 
          array(&$args['customer_id'], &$args['restaurant'],  &$args['address']['country'], &$args['address']['postcode'],
                &$args['address']['city'], &$args['address']['district'], &$args['address']['road'] , &$args['address']['number']))))
      db_error($answer);
    
    // Get the last inserted primary key
    $next_delivery_id = $db_link->insert_id;
  
    // Insert into Delivery_State table
    $stmt_insert_delivery_state = "
        INSERT INTO `Delivery_State` (`Delivery_delivery_id_pk`, `date_pk`, `Delivery_State_Type_delivery_status_type`, `comment`) 
        VALUES ($next_delivery_id, '$order_time', 1, NULL)";
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