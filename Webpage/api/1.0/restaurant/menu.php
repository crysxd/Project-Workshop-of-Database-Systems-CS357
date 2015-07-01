<?php

  // Include DB
  include_once('../db.php');

  // Open DB
  db_open();

  // Check params available
  check_parms_available(array("id", "session"));

  // Check session
  check_restaurant_session($_GET['id'], $_GET['session']);

  // Prepare statement 
  $stmt = $db_link->prepare("SELECT meal_id_pk AS id, name FROM meal WHERE restaurant_restaurant_id = ? AND offered = 1");

  // Check, Bind, Execute and get result
  if(!$stmt || !$stmt->bind_param("i", $_GET['id']) || !$stmt->execute() || !$result=$stmt->get_result()) {
    db_error();
  }

  // Create answer
  $answer = array("success"=>true, "data"=>array());

  // Copy result
  while($row = $result->fetch_assoc()) {
    $answer['data'][] = $row;
  }

  // Close DB
  db_close();

  // Send result
  echo json_encode($answer);

?>
