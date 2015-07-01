<?php
  
  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("id", "session", "delivery"));

  // set parameters
  $user = $_GET['id'];
  $session = $_GET['session'];
  $delivery = $_GET['delivery'];

  // create answer array
  $answer = array();

  // Checking if user has this session id
  check_restaurant_session($user, $session);

  $stmt_select_head_info = "
      SELECT c.nick customer, CONCAT(  '+', c.region_code, ' ', c.national_number ) phone , CONCAT(c.first_name, ' ', c.last_name) name, CONCAT(d.number,' ' ,d.street) street, d.city, d.postcode, d.country, r.shipping_cost
      FROM customer c
      INNER JOIN (
        SELECT country, street_number number, street_name street, city, postcode, customer_customer_id, restaurant_restaurant_id
        FROM Delivery
        WHERE delivery_id_pk = ?
      )d ON d.customer_customer_id = c.customer_id_pk
      INNER JOIN restaurant r ON d.restaurant_restaurant_id = r.restaurant_id_pk";

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
                  array('customer', 'name', 'phone', 'street', 'city', 'postcode', 'country', 'shipping_cost'))))
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

?>