<?php
    header("Content-Type: application/json");
    include_once __DIR__.'/../helpers/mysql.php';
    include_once __DIR__.'/../helpers/helper.php';

    $helper = new Helper();
    $db = new Mysql_Driver();

    if (isset($_GET["type"]))
    {
        $type = $_GET["type"];
        
        if ($type == 'Pending') {

            $course_id = '';

            if (isset($_GET["course_id"])) {
                $course_id = $_GET["course_id"];
            }

            $db->connect();
            
            $appointmentWaitingResult = null;

            if ($course_id) {
        
                // Fetch course specific pending appointments
                $qry = "SELECT * , TIMESTAMPDIFF(SECOND, appointment_createdate, NOW()) AS 'waiting_time' FROM Appointment 
                        WHERE course_id = ? AND appointment_status = 'Pending' 
                        ORDER BY waiting_time DESC";
        
                $appointmentWaitingResult = $db->query($qry, $course_id);

            } else {

                // Fetch general pending appointments
                $qry = "SELECT * , TIMESTAMPDIFF(SECOND, appointment_createdate, NOW()) AS 'waiting_time' FROM Appointment 
                        WHERE course_id IS NULL AND appointment_status = 'Pending' 
                        ORDER BY waiting_time DESC";

                $appointmentWaitingResult = $db->query($qry);

            }

            $db->close();

            $resultArray = array();

            while ($row = $db->fetch_array($appointmentWaitingResult)) {
                array_push($resultArray, $row);
            }

            $response = array(
                'status' => 200,
                'message' => 'Success',
                'data' => $resultArray
            );

        } else if ($type == 'NowServing') {
            $db->connect();
            $appointmentServingResult = null;

            // Get the appointment records status now serving
            $qry = "SELECT a.* , TIMESTAMPDIFF(SECOND, a.appointment_lastcalled, NOW()) AS 'last_called', c.course_abbreviations  
            FROM Appointment a LEFT OUTER JOIN Course c ON a.course_id = c.id 
            WHERE appointment_status = 'Now Serving' 
            ORDER BY last_called ASC";

            $appointmentServingResult = $db->query($qry);

            $db->close();

            $resultArray = array();
            
            while ($row = $db->fetch_array($appointmentServingResult)) {
                array_push($resultArray, $row);
            }

            $response = array(
                'status' => 200,
                'message' => 'Success',
                'data' => $resultArray
            ); 

        } else {
            $response = array(
                'status' => 400,
                'message' => "Invalid query string key: 'type' value!"
            );
        }
    } else {
        $response = array(
            'status' => 400,
            'message' => "Error Occured: Must provide of key: 'type' and value: 'NowServing' or 'Pending' query string"
        );
    }

    echo json_encode($response)
?>