<?php
  // include main database script
  include_once("../db.php");

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("user", "session"));
                      
  // open database connection
  db_open();

  // create answer array
  $answer = array();
 
  // Check session, if unautorized -> die
  check_customer_session($_GET['user'], $_GET['session']);
  // This code will only be executed if the user is authorized

  // Destroy session
  $answer['success'] = true;
  $stmt = $db_link->prepare("UPDATE customer SET session_id=\"\" WHERE nick=?");
  $stmt->bind_param("s", $_GET['user']);
  $stmt->execute();

  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close database connection
  db_close();
?>