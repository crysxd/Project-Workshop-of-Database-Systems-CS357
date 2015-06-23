<?php

  // Include DB
  include_once('../db.php');

  // Open DB
  db_open();

  // Check params available
  check_parms_available(array("id", "session", "state"));

  // Check session
  check_restaurant_session($_GET['id'], $_GET['session']);

  // Prepare statement 
  $stmt = $db_link->prepare(
    "SELECT d.delivery_id_pk AS id, s.since, s.state, st.name AS state_name, c.nick AS customer
     FROM delivery as d
     INNER JOIN restaurant AS r ON r.restaurant_id_pk = d.restaurant_restaurant_id
     INNER JOIN (
           SELECT max(date_pk) AS since, max(delivery_state_type_delivery_status_type) AS state, 
                  delivery_delivery_id_pk
           FROM delivery_state
		   GROUP BY delivery_delivery_id_pk
         ) AS s ON d.delivery_id_pk = s.delivery_delivery_id_pk
      INNER JOIN delivery_state_type AS st ON st.delivery_status_type_id_pk = s.state
      INNER JOIN customer AS c ON d.customer_customer_id = c.customer_id_pk
      WHERE r.restaurant_id_pk = ? and s.state = ?
      ORDER BY s.since ASC 
      LIMIT 1000"
  );

  // Check, Bind, Execute and get result
  if(!$stmt || !$stmt->bind_param("ii", $_GET['id'], $_GET['state']) || !$stmt->execute() || !$result=$stmt->get_result()) {
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
