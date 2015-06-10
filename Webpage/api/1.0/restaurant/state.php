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

  // if an error occured while performing the query
  if(!$result) {
    db_error($answer);

  } else {
    $answer['success'] = true;
    
  }
    
  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close db
  db_close();

?>