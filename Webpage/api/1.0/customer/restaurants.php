<?php
  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // create answer array
  $answer = array();

  // assure all required parameters are available
  if($err = check_parms_available(array("center_lat", "center_long", "start", "count"))) {
    // set fields for array
    $answer['success'] = false;
    $answer['err_no'] = ERROR_MISSING_PARAM;
    $answer['err_msg'] = $err;
    
  } else {
    // assure query parameters are clean
    $center_lat = mysql_real_escape_string($_GET['center_lat']);
    $center_long = mysql_real_escape_string($_GET['center_long']);
    $start = mysql_real_escape_string($_GET['start']);
    $count = mysql_real_escape_string($_GET['count']);

    // query all restaurants
    $result = mysql_query("SELECT * FROM restaurants WHERE 1 ORDER BY id LIMIT $start, $count");

    // if an error occured while performing the query
    if(mysql_error()) {
      // set fields for array
      $answer['success'] = false;
      $answer['err_no'] = ERROR_GENERAL;
      
      // THIS IS ONLY FOR DEBUGGING PURPOSE!
      // WE SHOULD NOT GIVE AN SQL-ERROR DESCRIPTION TO A POTENTIAL ATTACKER!
      // WE INSTEAD SEND BACK AN EMPTY ARRAY TO HIDE THE ERROR!
      $answer['err_msg'] = mysql_error();

    } else {
      // Everything is fine
      $answer['success'] = true;
      $answer['data'] = array();

      while($result && ($row = mysql_fetch_assoc($result))) {
        // add additional fields
        $row['random_additional_field'] = 42 + $row['id'];
        
        // append row to data array
        $answer['data'][] = $row;

      }
    }
  }

  // Encode answer as json and print aka send
  echo json_encode($answer);

  // close database connection
  db_close();
?>