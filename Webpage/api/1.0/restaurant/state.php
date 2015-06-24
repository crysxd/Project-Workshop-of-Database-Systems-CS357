<?php

  // include main database script
  include_once("../db.php");

  // open db 
  db_open();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("id", "session", "delivery", "state", "comment"));
  
  // assure user is logged in
  check_restaurant_session($_GET['id'], $_GET['session']);

  // Create answer array 
  $answer = array();

  // Check if restaurant is holder of the delivery
  // Prepare statement
  $stmt_check = $db_link->prepare("SELECT COUNT(*) AS ok ".
                                  "FROM delivery ".
                                  "WHERE restaurant_restaurant_id = ? AND delivery_id_pk = ?");

  // If preperation failed
  if(!$stmt_check) {
    db_error($answer);

  }

  // bind params
  $stmt_check->bind_param("ss", $_GET['id'], $_GET['delivery']);

  // Execute
  $stmt_check->execute();
  $result = $stmt_check->get_result();

  // if an error occured while performing the query
  // if the user has not bought the meal and is thus not allowed to rate it
  if(!$result || $result->fetch_assoc()['ok'] < 1) {
    db_error($answer, "Restaurant does not handle the delivery");
    
  }

  // Insert rating
  // prepare statement
  $stmt_insert = $db_link->prepare("INSERT INTO delivery_state".
                                   "(delivery_delivery_id_pk, delivery_state_type_delivery_status_type, comment) ".
                                   "VALUES (?, ?, ?)");
  
  // If preperation failed
  if(!$stmt_insert) {
    db_error($answer);

  }

  // bind params
  $stmt_insert->bind_param("sss", $_GET['delivery'], $_GET['state'], $_GET['comment']);

  // execute
  $result = $stmt_insert->execute();
  
  // Handle error
  if(!$result) {
    db_error();
  }

  // get data
  $stmt = $db_link->prepare("SELECT d.delivery_id_pk AS id, s.since, s.state, st.name AS state_name, c.nick AS customer
                             FROM delivery as d
                             INNER JOIN restaurant AS r ON r.restaurant_id_pk = d.restaurant_restaurant_id
                             INNER JOIN (
                                  SELECT max(date_pk) AS since, max(delivery_state_type_delivery_status_type) AS state, 
                                          delivery_delivery_id_pk
                                  FROM delivery_state
                                  GROUP BY delivery_delivery_id_pk
                                 ) AS s ON d.delivery_id_pk = s.delivery_delivery_id_pk
                              INNER JOIN delivery_state_type AS st ON st.delivery_status_type_id_pk = s.state
                              INNER JOIN customer AS c ON d.customer_customer_id = c.customer_id_pk
                              WHERE d.delivery_id_pk = ?");

  // Bind and execute
  if(!$stmt || !$stmt->bind_param("i", $_GET['delivery']) || !$stmt->execute() || !$result=$stmt->get_result()) {
    db_error();
  }

  $answer = $result->fetch_assoc();
  $answer['success'] = true;


  // fetch user email
  $stmt_email = $db_link->prepare("SELECT email FROM customer WHERE nick = ?");

  // check, bind and execute. Do not handle errors, as this would not be any kind of an critical error
  if($stmt && !$stmt->bind_param("s", $answer['nick']) && $stmt->execute() && $result=$stmt->get_result()) {
    // get email and notify user
    $email = $result->fetch_assoc()['email'];
    mail($email,
         "#{$answer['id']}: Status is now \"{$answer['state_name']}\"", 
         "Hey there,
          your order has been updated and the current status is now \"{$answer['state_name']}\"
          
          Your my-meal.com team",
         "From: hello@my-meal.com <my-meal.com Team>");
  }
  
  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close db
  db_close();

?>