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
    // Prepare Statements
    $stmt_result = $db_link->prepare("SELECT * FROM restaurants WHERE 1 ORDER BY id LIMIT ?, ?");
    $stmt_result->bind_param("ii", $start, $count);
    $stmt_count = $db_link->prepare("SELECT COUNT(*) AS item_count FROM restaurants");
    
    // assure query parameters are clean and set parameters
    $center_lat = mysql_real_escape_string($_GET['center_lat']);
    $center_long = mysql_real_escape_string($_GET['center_long']);
    $start = mysql_real_escape_string($_GET['start']);
    $count = mysql_real_escape_string($_GET['count']);

    // Execute queries
    $result = $stmt_result->execute();
    $result = $stmt_result->get_result();
    $count = $stmt_count->execute();
    $count = $stmt_count->get_result();
    
    // if an error occured while performing the query
    if($db_link->errno || !$stmt_result || !$stmt_count || !$result || !$count) {
      // set fields for array
      $answer['success'] = false;
      $answer['err_no'] = ERROR_GENERAL;
      
      // THIS IS ONLY FOR DEBUGGING PURPOSE!
      // WE SHOULD NOT GIVE AN SQL-ERROR DESCRIPTION TO A POTENTIAL ATTACKER!
      // WE INSTEAD SEND BACK AN EMPTY ARRAY TO HIDE THE ERROR!
      $answer['err_msg'] = "[$db_link->errno] $db_link->error";

    } else {
      // Everything is fine
      $answer['success'] = true;
      $answer['item_count'] = $count->fetch_assoc()['item_count'];
      $answer['data'] = array();

      while($result && ($row = $result->fetch_assoc())) {
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