<?php
    include_once __DIR__. '/../helpers/helper.php';
    include_once __DIR__. '/../helpers/mysql.php';

    $helper = new Helper();
    $db = new Mysql_Driver();

    if(isset($_POST["call-submit"])) {
        echo "call";
        // update and check the status
        $appointment_id = $_POST["appointment_id"];

        $db->connect();

        $qry = "UPDATE Appointment SET appointment_status = 'Now Serving', appointment_lastcalled = NOW(), appointment_calls = appointment_calls + 1   
                WHERE appointment_id = ? AND appointment_status = 'Pending'";
        
        $result = $db->query($qry, $appointment_id);

        $db->close();

        // TO-DO: Push the notif

        $pageUrl = $helper->pageUrl('appointment.php');

        if (isset($_POST["course_id"]) && !$result) {
            $pageUrl .= '?course_id=' . $_POST["course_id"] . '&call=failed';
        } else if (isset($_POST["course_id"]) && $result) {
            $pageUrl .= '?course_id=' . $_POST["course_id"];
        } else if (!$result) {
            $pageUrl .= '?call=failed';
        }

        header("Location: $pageUrl");
        exit;
        // go back to the appointment page

    } else if (isset($_POST["end-submit"])) {
        echo "end";
        // update
        $appointment_id = $_POST["appointment_id"];

        $db->connect();

        $qry = "UPDATE Appointment SET appointment_status = 'Finished' 
                WHERE appointment_id = ? ";
        
        $result = $db->query($qry, $appointment_id);

        $pageUrl = $helper->pageUrl('appointment.php');

        if (isset($_POST["course_id"]) && !$result) {
            $pageUrl .= '?course_id=' . $_POST["course_id"] . '&end=failed';
        } else if (isset($_POST["course_id"]) && $result) {
            $pageUrl .= '?course_id=' . $_POST["course_id"];
        } else if (!$result) {
            $pageUrl .= '?end=failed';
        }

        header("Location: $pageUrl");
        exit;

    } else if (isset($_POST["recall-submit"])) {
        echo "recall";

        // TO-DO: Push the notif
        $appointment_id = $_POST["appointment_id"];

        $db->connect();

        $qry = "UPDATE Appointment SET appointment_lastcalled = NOW(), appointment_calls = appointment_calls + 1  
                WHERE appointment_id = ? AND appointment_status = 'Now Serving'";
        
        $result = $db->query($qry, $appointment_id);

        $db->close();

        $pageUrl = $helper->pageUrl('appointment.php');

        if (isset($_POST["course_id"]) && !$result) {
            $pageUrl .= '?course_id=' . $_POST["course_id"] . '&call=failed';
        } else if (isset($_POST["course_id"]) && $result) {
            $pageUrl .= '?course_id=' . $_POST["course_id"];
        } else if (!$result) {
            $pageUrl .= '?call=failed';
        }

        header("Location: $pageUrl");
        exit;

    } else {
        
        $pageUrl = $helper->pageUrl('appointment.php');
        header("Location: $pageUrl");
        exit;
    }

    function pushNotif() {

    }
?>