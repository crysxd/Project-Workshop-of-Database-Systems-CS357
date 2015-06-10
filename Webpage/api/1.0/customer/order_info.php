<?php

  // include main database script
  include_once("../db.php");

  // open db 
  db_open();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("restaurant"));
  
  // Create answer array 
  $answer = array();

  // prepare statement
  $stmt = $db_link->prepare("SELECT name, shipping_cost, CONCAT('+', region_code, ' ', national_number) as phone, 0 as eta ".
                            "FROM restaurant WHERE restaurant_id_pk=?");
  // if an error occured while performing the query
  if($db_link->errno || !$stmt) {
    // set fields for array
    $answer['success'] = false;
    $answer['err_no'] = ERROR_GENERAL;
    $answer['err_msg'] = "[$db_link->errno] $db_link->error";

    die(json_encode($answer));
  } 
  // bind params
  $stmt->bind_param("s", $_GET['restaurant']);

  // execute
  $result = $stmt->execute();

  // if an error occured while performing the query
  if($db_link->errno || !$stmt || !$result) {
    // set fields for array
    $answer['success'] = false;
    $answer['err_no'] = ERROR_GENERAL;
    $answer['err_msg'] = "[$db_link->errno] $db_link->error";

  } else {
    $answer['success'] = true;
    
    if($row = $stmt->get_result()->fetch_assoc()) {
      $answer['data'] = $row;

    }
  }
    
  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close db
  db_close();

?>