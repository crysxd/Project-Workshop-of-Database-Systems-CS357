<?php
  define("DB_HOST", "localhost");
  define("DB_USER", "root");
  define("DB_PASS", "");
  define("DB_NAME", "test");
  define("IMAGE_DIRECTORY", "img");
  define("ERROR_GENERAL", 0);
  define("ERROR_UNAUTHORIZED", 1);
  define("ERROR_MISSING_PARAM", 2);

  /****************************************************************************************************************************
   * Öffnet die Verbindung zur Datenbank
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
   * Schließt die Verbindung zur Datenbank
   */
  function db_close() {
    global $db_link;
    
    if($db_link != null) {
      $db_link->close();
      $db_link = null;
    
    } 
  }  

  /****************************************************************************************************************************
   * Stellt sicher das alle benötigten Parameter vorhanden sind.
   */
  function check_parms_available($params) {    
    foreach($params as $i => $p) {
      if(!array_key_exists ($p, $_GET)) {
        return "Required parameter \"$p\" is missing.";
      }
    }
  }
?>

