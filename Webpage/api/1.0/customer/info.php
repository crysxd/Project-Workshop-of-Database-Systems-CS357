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
    check_parms_available(array("first_name", "sure_name", "pw", "nick", "phone"));
        
    // create answer array
    $answer = array();
    $answer['success'] = false;
    $answer['nick'] = $_GET['nick'];

    // Check if params are sufficient
    // Password should have at least 6 characters
    if(strlen($_GET['pw']) < 6) {
      $answer['err_no'] = 1003;
      die(json_encode($answer));
    }
  
    // hash password
    $password = hash(PASSWORD_HASH_FUNCTION, $_GET['pw']);
    
    // prepare statement
    $stmt = $db_link->prepare("INSERT INTO customer(region_code, national_number, last_name, first_name, nick, password) VALUES('+86', ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssss", $_GET['phone'], $_GET['sure_name'], $_GET['first_name'], $_GET['nick'], $password);
    
    
    // execute
    if(!$stmt->execute()) {
      $answer['err_no'] = $db_link->errno;
      $answer['err_msg'] = "[$db_link->errno] $db_link->error";
      
    } else {
      $answer['success'] = true;
      $answer['user'] = $_GET['nick'];
      $answer['session'] = start_user_session($_GET['nick']);
      
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
    $answer = array("success" => true);
       
    global $db_link;
    
    $args_str = array("user", "session");
    check_parms_available($args_str);
    escape_parms($args_str);
    
    $args = array();
    foreach ($args_str as $arg_str)
      $args[$arg_str] = $_GET[$arg_str];
      
    $answer = array();
      
    check_customer_session($args['user'], $args['session']);
    
    $stmt_select_user="
      SELECT nick, CONCAT(  '+', region_code,  ' ', national_number ) phone, first_name, last_name sure_name
      FROM Customer
      WHERE nick = ?";
    
    // hier fehlt distinct damit meals nicht öfter auftreten
    $stmt_select_ratable_dishes = "
      SELECT m.meal_id_pk id, restaurant, m.name, bought_on from (
 
		SELECT * from (

          SELECT cdds.delivery_id_pk , r.name restaurant, cdds.date_pk bought_on
          FROM (

            SELECT d.delivery_id_pk, d.Restaurant_restaurant_id, ds.date_pk, ds.Delivery_State_Type_delivery_status_type type
            FROM (

              SELECT customer_id_pk
              FROM Customer
              WHERE nick =  ?
            )c
            INNER JOIN Delivery d ON c.customer_id_pk = d.Customer_customer_id
            INNER JOIN Delivery_State ds ON d.delivery_id_pk = ds.Delivery_delivery_id_pk
            WHERE ds.Delivery_State_Type_delivery_status_type = 4
          )cdds
          INNER JOIN Delivery_State_Type dst ON cdds.type = dst.delivery_status_type_id_pk
          INNER JOIN Restaurant r ON cdds.Restaurant_restaurant_id = r.restaurant_id_pk
          ORDER BY bought_on ASC
        )cddsr
        GROUP BY cddsr.delivery_id_pk) cddsrg 
		INNER JOIN Delivery_Meal_Map dmm ON cddsrg.delivery_id_pk = dmm.Delivery_delivery_id_pk
		INNER JOIN Meal m ON dmm.Meal_meal_id_pk = m.meal_id_pk
    ";
    
    $stmt_select_ongoing_deliveries = "
        SELECT * 
        FROM (

          SELECT cdds.delivery_id_pk id, r.name restaurant, dst.name state, cdds.date_pk state_since
          FROM (

            SELECT d.delivery_id_pk, d.Restaurant_restaurant_id, ds.date_pk, ds.Delivery_State_Type_delivery_status_type
            TYPE 
            FROM (

              SELECT customer_id_pk
              FROM Customer
              WHERE nick =  ?
            )c
            INNER JOIN Delivery d ON c.customer_id_pk = d.Customer_customer_id
            INNER JOIN Delivery_State ds ON d.delivery_id_pk = ds.Delivery_delivery_id_pk
            WHERE d.delivery_id_pk != ( 
              SELECT d.delivery_id_pk
              FROM (

                SELECT customer_id_pk
                FROM Customer
                WHERE nick =  ?
              )c
              INNER JOIN Delivery d ON c.customer_id_pk = d.Customer_customer_id
              INNER JOIN Delivery_State ds ON d.delivery_id_pk = ds.Delivery_delivery_id_pk
              WHERE ds.Delivery_State_Type_delivery_status_type = 4 ) 

          )cdds
          INNER JOIN Delivery_State_Type dst ON cdds.type = dst.delivery_status_type_id_pk
          INNER JOIN Restaurant r ON cdds.Restaurant_restaurant_id = r.restaurant_id_pk
          ORDER BY state_since DESC
        )cddsr
        GROUP BY cddsr.id
    ";

    $stmt_select_old_deliveries = "
        SELECT * 
        FROM (

          SELECT cdds.delivery_id_pk id, r.name restaurant, dst.name state, cdds.date_pk state_since
          FROM (

            SELECT d.delivery_id_pk, d.Restaurant_restaurant_id, ds.date_pk, ds.Delivery_State_Type_delivery_status_type type
            FROM (

              SELECT customer_id_pk
              FROM Customer
              WHERE nick =  ?
            )c
            INNER JOIN Delivery d ON c.customer_id_pk = d.Customer_customer_id
            INNER JOIN Delivery_State ds ON d.delivery_id_pk = ds.Delivery_delivery_id_pk
            WHERE ds.Delivery_State_Type_delivery_status_type = 4
          )cdds
          INNER JOIN Delivery_State_Type dst ON cdds.type = dst.delivery_status_type_id_pk
          INNER JOIN Restaurant r ON cdds.Restaurant_restaurant_id = r.restaurant_id_pk
          ORDER BY state_since DESC
        )cddsr
        GROUP BY cddsr.id
    ";
    
    $answer['success'] = true;

    // Processes $stmt_select_head_info statement
    if(!($select_user_result = push_stmt($stmt_select_user, "s", array(&$args['user']))))
      db_error($answer);
    
    if(!(add_answer($answer, $select_user_result, 
                    array('nick', 'phone', 'first_name', 'first_name', 'sure_name'))))
      db_error($answer);
    
    $answer['ratable_dishes'] = array();
    //
    if(!($select_ratable_dishes_result = push_stmt($stmt_select_ratable_dishes, "s", array(&$args['user']))))
      db_error($answer);

    while($select_ratable_dishes_result && ($fetched_select_ratable_dishes_row = $select_ratable_dishes_result->fetch_assoc()))
      $answer['ratable_dishes'][] = $fetched_select_ratable_dishes_row;
    
    $answer['ongoing_deliveries'] = array();
    //
    if(!($select_ongoing_deliveries_result = push_stmt($stmt_select_ongoing_deliveries, "ss", array(&$args['user'], &$args['user']))))
      db_error($answer);
    
    while($select_ongoing_deliveries_result && ($fetched_ongoing_deliveries_dishes_row = $select_ongoing_deliveries_result->fetch_assoc()))
      $answer['ongoing_deliveries'][] = $fetched_ongoing_deliveries_dishes_row;
    
    $answer['old_deliveries'] = array();
    //
    if(!($select_select_old_deliveries_result = push_stmt($stmt_select_old_deliveries, "s", array(&$args['user']))))
      db_error($answer);
    
    while($select_select_old_deliveries_result && ($fetched_select_old_deliveries_row = $select_select_old_deliveries_result->fetch_assoc()))
      $answer['old_deliveries'][] = $fetched_select_old_deliveries_row;  
    
    // Encode answer as json and print aka send, When there is no return the encoding returned NULL
    echo json_encode($answer);
  }




?>