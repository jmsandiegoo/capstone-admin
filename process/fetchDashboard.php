<?php
    header("Content-Type: application/json");
    include_once __DIR__.'/../helpers/mysql.php';
    include_once __DIR__.'/../helpers/helper.php';

    $helper = new Helper();
    $db = new Mysql_Driver();
    
    $db->connect();

    // Fetch today's queue, Served, Skipped
    $qry = "SELECT appointment_status, COUNT(*) as 'today_count' FROM Appointment 
			WHERE DATE(appointment_createdate) = CURDATE() 
            GROUP BY appointment_status";

	$statsResult = $db->query($qry);

	$statsResultArray = array();

	// Prepare statsResult for json result
    while ($row = $db->fetch_array($statsResult)) {
        array_push($statsResultArray, $row);
	}

	// Get the course results
	$qry = "SELECT * FROM Course";

	$courseResult = $db->query($qry);

	$waitingResultArray = array();

	while ($row = $db->fetch_array($courseResult)) {
		$course = array('course_id' => $row['id'],
						'course_name' => $row['course_name'], 
						'course_abbreviations' => $row['course_abbreviations'], 
						'today_count' => 0);
	
		array_push($waitingResultArray, $course);
	}

	array_unshift($waitingResultArray, array('course_id' => null,
										  'course_name' => 'General', 
										  'course_abbreviations' => null, 
										  'today_count' => 0));

    // Fetch the Appointment Type Waiting List
    $qry = "SELECT a.course_id ,COUNT(*) as 'today_count' 
            FROM Appointment a LEFT OUTER JOIN Course c ON a.course_id = c.id
            WHERE appointment_status = 'Pending' AND DATE(appointment_createdate) = CURDATE() 
			GROUP BY course_id";

	$appointmentResult = $db->query($qry);
	
	while ($row = $db->fetch_array($appointmentResult)) {
		foreach ($waitingResultArray as &$item) {
			if ($item['course_id'] == $row['course_id']) {
				$item['today_count'] = $row['today_count'];
				break;
			}
		}
	}
	
	$db->close();
	
	$response = array(
		'status' => 200,
		'message' => 'Success',
		'data' => array($statsResultArray, $waitingResultArray)
	);
    
    // Send via json
    echo json_encode($response)
?>