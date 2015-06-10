<?php

  // include main database script
  include_once("../db.php");

  // open db 
  db_open();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("user", "session", "meal", "rating", "comment"));
  
  // assure user is logged in
  check_customer_session($_GET['user'], $_GET['session']);

  // Create answer array 
  $answer = array();

  // Check if user has bought the meal
  // Prepare statement
  $stmt_check = $db_link->prepare("SELECT COUNT(*) AS ok ".
                            "FROM delivery_meal_map ".
                            "LEFT JOIN delivery ON delivery_delivery_id_pk = delivery_id_pk ".
                            "LEFT JOIN customer ON customer_customer_id = customer_id_pk ".
                            "WHERE customer.nick = ? AND delivery_meal_map.meal_meal_id_pk = ?");

  // If preperation failed
  if(!$stmt_check) {
    db_error($answer);

  }

  // bind params
  $stmt_check->bind_param("ss", $_GET['user'], $_GET['meal']);

  // Execute
  $stmt_check->execute();
  $result = $stmt_check->get_result();

  // if an error occured while performing the query
  // if the user has not bought the meal and is thus not allowed to rate it
  if(!$result || $result->fetch_assoc()['ok'] < 1) {
    db_error($answer, "Customer did not buy the meal he trys to rate");
    
  }

  
  // Insert rating
  // prepare statement
  $stmt_insert = $db_link->prepare("INSERT INTO rating(meal_meal_id_pk, customer_customer_id_pk, rating, comment) ".
                            "VALUES (?, (SELECT customer_id_pk FROM customer where nick = ?), ?, ?)".
                            "ON DUPLICATE KEY UPDATE rating = VALUES(rating), comment = VALUES(comment)");
  
  // If preperation failed
  if(!$stmt_insert) {
    db_error($answer);

  }

  // bind params
  $stmt_insert->bind_param("ssss", $_GET['meal'], $_GET['user'], $_GET['rating'], $_GET['comment']);

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