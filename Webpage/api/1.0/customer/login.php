<?php
  // include main database script
  include_once("../db.php");

  // assure all required parameters are available, will die if not all are available
  check_parms_available(array("user", "pw"));
                        
  // open database connection
  db_open();

  // create answer array
  $answer = array();

  // Prepare Statements
  $stmt = $db_link->prepare("SELECT COUNT(*) as ok FROM customer WHERE phone_pk=? AND password=?");
  $stmt->bind_param("ss", $user, $pw);

  // assure query parameters are clean and set parameters
  $user = mysql_real_escape_string($_GET['user']);
  $pw = hash(PASSWORD_HASH_FUNCTION, $_GET['pw']);

  // Execute queries
  $result = $stmt->execute();
  $result = $stmt->get_result();

  // if an error occured while performing the query
  if($db_link->errno || !$stmt || !$result) {
    // set fields for array
    $answer['success'] = false;
    $answer['err_no'] = ERROR_GENERAL;

    // THIS IS ONLY FOR DEBUGGING PURPOSE!
    // WE SHOULD NOT GIVE AN SQL-ERROR DESCRIPTION TO A POTENTIAL ATTACKER!
    // WE INSTEAD SEND BACK AN EMPTY ARRAY TO HIDE THE ERROR!
    $answer['err_msg'] = "[$db_link->errno] $db_link->error";

  } else {
    if($result->fetch_assoc()['ok'] == 1) {
      // Login successful
      $answer['success'] = true;
      $answer['session'] = bin2hex(openssl_random_pseudo_bytes(32));
      $db_link->query("UPDATE customer SET session=\"{$answer['session']}\" WHERE phone_pk=$user");
    } else {
      // Login unsuccessful
      $answer['success'] = false;
      $answer['err_no'] = ERROR_GENERAL;
    }
  }

  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close database connection
  db_close();
?>