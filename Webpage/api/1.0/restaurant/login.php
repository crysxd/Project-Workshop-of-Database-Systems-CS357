<?php
  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("id", "pw"));

  // create answer array
  $answer = array();

  // Prepare Statements
  $stmt = $db_link->prepare("SELECT COUNT(*) AS ok, name FROM restaurant WHERE restaurant_id_pk=? AND password=?");
  
  if(!$stmt) {db_error();}

  // assure query parameters are clean and set parameters
  $user = $_GET['id'];
  $pw = hash(PASSWORD_HASH_FUNCTION, $_GET['pw']);

  // Execute queries
  if(!$stmt) {
    db_error();
  }

  if(!$stmt->bind_param("ss", $user, $pw)) {
    db_error();
  }
  if(!$stmt->execute()) {
    db_error();
  }
  if(!$result = $stmt->get_result()) {
    db_error();
  }

  $result = $result->fetch_assoc();
  if($result['ok'] == 1) {
    // Login successful
    $answer['success'] = true;
    $answer['name'] = $result['name'];

    // Log in
    $answer['session'] = start_restaurant_session($_GET['id']);

    // Query id
    $answer['id'] = $_GET['id'];

  } else {
    // Login unsuccessful
    $answer['success'] = false;
    $answer['err_no'] = ERROR_UNAUTHORIZED;

  }

  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close database connection
  db_close();
?>