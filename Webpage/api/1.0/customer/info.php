<?php

  // include main database script
  include_once("../db.php");

  // open database connection
  db_open();

  // Select which code to run based on request method
  switch ($_SERVER['REQUEST_METHOD']) {
    case 'PUT':
      rest_put();  
      break;
    case 'POST':
      rest_post();  
      break;
    case 'GET':
      rest_get();  
      break;
    default:
      die(json_encode(array("success" => false, "err_no" => ERROR_GENERAL, "err_msg" => "Unsuported method {$_SERVER['REQUEST_METHOD']}")));
  }

  // close database connection
  db_close();

  /****************************************************************************************************************************
   * Handles put requests
   */     
  function rest_put() {
    global $db_link;
    
    // assure all required parameters are available, will die if not all are available
    check_parms_available(array("first_name", "sure_name", "pw", "nick", "phone"));
        
    // create answer array
    $answer = array();
    $answer['success'] = false;
    $answer['nick'] = $_GET['nick'];

    // Check if params are sufficient
    // Password should have at least 6 characters
    if(strlen($_GET['pw']) < 6) {
      $answer['err_no'] = 1003;
      die(json_encode($answer));
    }
  
    // hash password
    $password = hash(PASSWORD_HASH_FUNCTION, $_GET['pw']);
    
    // prepare statement
    $stmt = $db_link->prepare("INSERT INTO customer(region_code, national_number, last_name, first_name, nick, password) VALUES('+86', ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssss", $_GET['phone'], $_GET['sure_name'], $_GET['first_name'], $_GET['nick'], $password);
    
    
    // execute
    if(!$stmt->execute()) {
      $answer['err_no'] = $db_link->errno;
      $answer['err_msg'] = "[$db_link->errno] $db_link->error";
      
      // replace error code with specific ones
      // Duplicate primary key means phone already in use
      if($db_link->errno == 1062 && strpos($db_link->error, 'PRIMARY')) {
        $answer['err_no'] = 1001;
      }
      
      // Duplicate primary key means phone already in use
      if($db_link->errno == 1062 && strpos($db_link->error, 'nick')) {
        $answer['err_no'] = 1000;
      }

      
    } else {
      $answer['success'] = true;
      $answer['user'] = $_GET['nick'];
      $answer['session'] = start_session($_GET['nick']);
      
    }
    
    // Encode answer as json and print aka send
    echo json_encode($answer);
    
  }
        
  /****************************************************************************************************************************
   * Handles put requests
   */     
  function rest_post() {
    // create answer array
    $answer = array("success" => false, "err_no" => ERROR_GENERAL, "err_msg" => "Not implemented");
       
    // Encode answer as json and print aka send
    echo json_encode($answer);
  }
        
  /****************************************************************************************************************************
   * Handles get requests
   */     
  function rest_get() {
    // create answer array
    $answer = array("success" => false, "err_no" => ERROR_GENERAL, "err_msg" => "Not implemented");
       
    // Encode answer as json and print aka send
    echo json_encode($answer);
  }




?>