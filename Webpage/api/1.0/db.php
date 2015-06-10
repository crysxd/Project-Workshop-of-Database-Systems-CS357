<?php
  define("DB_HOST", "localhost");
  define("DB_USER", "mymeal_admin");
  define("DB_PASS", "u9wZpVbs7xbD45JR");
  define("DB_NAME", "mymeal");
  define("IMAGE_DIRECTORY", "img");
  define("PASSWORD_HASH_FUNCTION", "sha1");
  define("ERROR_GENERAL", 0);
  define("ERROR_UNAUTHORIZED", 1);
  define("ERROR_MISSING_PARAM", 2);
  define("DEBUG",1);

  /****************************************************************************************************************************
   * Opens a connection to the database
   */
  function db_open() {
    global $db_link;
    
    //Abbrechen wenn bereits geöffnet
    if($db_link != null) {
      return;
    }
    
    $db_link = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

    if (!$db_link || $db_link->connect_error) {
      echo $db_link->connect_error;
      die();
    }
  }

  /****************************************************************************************************************************
   * Closes the connection to the database
   */
  function db_close() {
    global $db_link;
    
    if($db_link != null) {
      $db_link->close();
      $db_link = null;
    
    } 
  }  

  /****************************************************************************************************************************
   * Assures all neeeded parameteres are availabel in $_GET
   */
  function check_parms_available($params) { 
	global $db_link;
	
    foreach($params as $i => $p) {
      // Check if key is available
      if(!array_key_exists ($p, $_GET) || strlen($_GET[$p]) == 0) {
        die(json_encode(array("success" => false, "err_no" => ERROR_MISSING_PARAM, "err_msg" => "Required parameter \"$p\" is missing.")));
      }
    }
  }

  /****************************************************************************************************************************
   * Escapes all given parameteres 
   */
  function escape_parms($params) { 
	global $db_link;
    foreach($params as $i => $p) {
      $_GET[$p] = htmlentities($db_link->real_escape_string($_GET[$p])); 
    }
  }

  /****************************************************************************************************************************
   * Is used in combination with array_walk_recursive to walk through an array and escape every item
   * Usage Exampe:  array_walk_recursive($arrays, 'mysqli_real_escape_string_asso_array');
   */
  function mysqli_real_escape_string_asso_array(&$item, $key){
    global $db_link;
    return htmlentities(mysqli_real_escape_string($db_link, $item));
  }

  /****************************************************************************************************************************
   * Returns the path to the icon file for the restaurant with the given id.
   */
  function get_restaurant_icon_file_name($restaurant_id) {
    return get_image_dir()."/restaurant_".$restaurant_id;
  }

  /****************************************************************************************************************************
   * Returns the path to the image file for the meal with the given id.
   */
  function get_meal_image_file_name($restaurant_id) {
    return get_image_dir()."/meal_".$restaurant_id;
  }

  /****************************************************************************************************************************
   * Returns the path to the directory storing all images
   */
  function get_image_dir() {
    return dirname(__FILE__)."/".IMAGE_DIRECTORY;
  }

  /****************************************************************************************************************************
   * Checks if the given session is valid for the given customer. Kills the PHP script if the user is unauthorized
   */
  function check_customer_session($user, $session) {
    global $db_link;
    
    // Create a answer for unauthorized users
    $answer = json_encode(array("success" => false, "err_no" => ERROR_UNAUTHORIZED));

    // Preapre query
    if(!$stmt = $db_link->prepare("SELECT COUNT(*) as ok FROM Customer WHERE nick=? AND session_id=?")) {
      db_error($answer, "Unauthorized", ERROR_UNAUTHORIZED);
    }
    
    // Bind params
    if(!$stmt->bind_param("ss", $user, $session)) {
      db_error($answer, "Unauthorized", ERROR_UNAUTHORIZED);
    }
    
    // Execute
    if(!$stmt->execute()) {
      db_error($answer, "Unauthorized", ERROR_UNAUTHORIZED);
    }
    
    // Check result
    if($stmt->get_result()->fetch_assoc()['ok'] != 1) {
      db_error($answer, "Unauthorized", ERROR_UNAUTHORIZED);
    }
  }

  /****************************************************************************************************************************
   * Checks if the given session is valid for the given restaurant. Kills the PHP script if the user is unauthorized
   */
  function check_restaurant_session($id, $session) {
    global $db_link;
    
    // Create a answer for unauthorized users
    $answer = json_encode(array("success" => false, "err_no" => ERROR_UNAUTHORIZED));

    // Preapre query
    if(!$stmt = $db_link->prepare("SELECT COUNT(*) as ok FROM Restaurant WHERE restaurant_id_pk=? AND session_id=?")) {
      db_error($answer, "Unauthorized", ERROR_UNAUTHORIZED);
    }
    
    // Bind params
    if(!$stmt->bind_param("ss", $id, $session)) {
      db_error($answer, "Unauthorized", ERROR_UNAUTHORIZED);
    }
    
    // Execute
    if(!$stmt->execute()) {
      db_error($answer, "Unauthorized", ERROR_UNAUTHORIZED);
    }
    
    // Check result
    if($stmt->get_result()->fetch_assoc()['ok'] != 1) {
      db_error($answer, "Unauthorized", ERROR_UNAUTHORIZED);
    }
  }

  /****************************************************************************************************************************
   * Starts a new session for the given user. The session id is returned
   */
  function start_user_session($user) {
    global $db_link;
   
    // Generate session id
    $session = generate_session_id();

    // Put session id
    $db_link->query("UPDATE Customer SET session_id=\"$session\" WHERE nick=$user");
    
    //return
    return $session;
  }

  /****************************************************************************************************************************
   * Starts a new session for the given restaurant. The session id is returned
   */
  function start_restaurant_session($id) {
    global $db_link;
   
    // Generate session id
    $session = generate_session_id();

    // Put session id
    $db_link->query("UPDATE Restaurant SET session_id=\"$session\" WHERE restaurant_id_pk=$id");
    
    //return
    return $session;
  }

  /****************************************************************************************************************************
   * Generates a new session id and returns it
   */
  function generate_session_id() {
    return bin2hex(openssl_random_pseudo_bytes(32));
  }

 /****************************************************************************************************************************
   * Pushes an statement $stmt with the input parameters to the database, executes it and return the result. The type of the parameters are specified by $string_input
   */
  function push_stmt($stmt, $string_input, $arguments){
    global $db_link;
    
    if($stmt_result = $db_link->prepare($stmt)){
      $arguments_for_binding = array_merge(array($stmt_result, $string_input), $arguments);
      call_user_func_array('mysqli_stmt_bind_param', $arguments_for_binding);
      $result = $stmt_result->execute();
      return $stmt_result->get_result();
    } else {
      return null ;
    }
  }

  /****************************************************************************************************************************
   * Gets the pointer of the answer $answer, and the parameters $parms which should be added from the result into the answer
   */ 
  function add_answer(&$answer, &$result, $parms){
    if(!($result && ($fetched_row = $result->fetch_assoc())))
      return 0;
    
    foreach ($parms as $parm) {
        $answer[$parm] = $fetched_row[$parm];

    }
    return 1;
  }
       

  /****************************************************************************************************************************
   * Creates an Error message and kills the process
   */
  function db_error($puffer_answer=array(), $info="", $err_no=ERROR_GENERAL) {
    global $db_link;
    
    $answer['success'] = false;
    $answer['err_no'] = $err_no;
    $answer['err_msg'] = $info;

    // THIS IS ONLY FOR DEBUGGING PURPOSE!
    // WE SHOULD NOT GIVE AN SQL-ERROR DESCRIPTION TO A POTENTIAL ATTACKER!
    // WE INSTEAD SEND BACK AN EMPTY ARRAY TO HIDE THE ERROR!
    if(DEBUG) {
      if($db_link->errno) {
        $answer['err_sql'] = "[$db_link->errno] $db_link->error";
      }
      
      $answer['err_loc'] = debug_backtrace();
        
    }
    
    die(json_encode($answer));
    
  }

  /****************************************************************************************************************************
   * Creates an Error message and kills the process
   */
  function save_image_from_input($dest_path) {
    // Open files
    $dest = fopen($dest_path, "w");
    $src = fopen("php://input", "r");
   
    if(!$dest) {
      db_error(array(), "Unable to open output file: \"$file_path\"");
    }
    if(!$dest) {
      db_error(array(), "Unable to open input file");
    }
    
    // Copy stream
    stream_copy_to_stream($src, $dest);
    
    //Close
    fclose($src);
    fclose($dest);

  }

?>