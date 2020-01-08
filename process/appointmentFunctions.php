<?php
    use Longman\TelegramBot\Commands\Command;
    use Longman\TelegramBot\Commands\UserCommand;
    use Longman\TelegramBot\Request;
    
    require __DIR__. '/../vendor/autoload.php';
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
        
        $db->query($qry, $appointment_id);

        $qry = "SELECT * FROM Appointment WHERE appointment_id = ?";

        $result = $db->query($qry, $appointment_id);

        $row = $db->fetch_array($result);

        $db->close();

        // Push the notif
        $message = "Hi $row[appointment_name]! Your Queue Number: $row[appointment_id] is Now Serving! Please proceed to the consultation area. Thank you for waiting.";
        // $message = "Hi! Your Queue Number is Now Serving! Please proceed to the consultation area. Thank you for waiting.";
        $chat_id = $row["chat_id"];
        pushNotification($message, $chat_id);

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

    } else if (isset($_POST["skip-submit"])) {

        echo "skip";
        // update
        $appointment_id = $_POST["appointment_id"];

        $db->connect();

        $qry = "UPDATE Appointment SET appointment_status = 'Finished' 
                WHERE appointment_id = ? ";
        
        $db->query($qry, $appointment_id);

        $qry = "SELECT * FROM Appointment WHERE appointment_id = ?";

        $result = $db->query($qry, $appointment_id);

        $row = $db->fetch_array($result);

        $db->close();

        // Push the notif
        $message = "Your appointment has been skipped. Please create a new Queue Number through /CreateAppt if needed!";
        $chat_id = $row["chat_id"];
        pushNotification($message, $chat_id);

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

    }  else if (isset($_POST["end-submit"])) {

        echo "end";
        // update
        $appointment_id = $_POST["appointment_id"];

        $db->connect();

        $qry = "UPDATE Appointment SET appointment_status = 'Finished' 
                WHERE appointment_id = ? ";
        
        $db->query($qry, $appointment_id);

        $qry = "SELECT * FROM Appointment WHERE appointment_id = ?";

        $result = $db->query($qry, $appointment_id);

        $row = $db->fetch_array($result);

        $db->close();

        // Push the notif
        $message = "Your appointment has now ended. We hope we served you well. If you have any more inquiries, please create a new Queue Number through /CreateAppt";
        $chat_id = $row["chat_id"];
        pushNotification($message, $chat_id);

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
        $appointment_id = $_POST["appointment_id"];

        $db->connect();

        $qry = "UPDATE Appointment SET appointment_lastcalled = NOW(), appointment_calls = appointment_calls + 1  
                WHERE appointment_id = ? AND appointment_status = 'Now Serving'";
        
        $result = $db->query($qry, $appointment_id);

        $qry = "SELECT * FROM Appointment WHERE appointment_id = ?";

        $result = $db->query($qry, $appointment_id);

        $row = $db->fetch_array($result);

        $db->close();

        $recalls = $row["appointment_calls"] - 1;
        // Push the notif
        $message = "Your Queue Number: $row[appointment_id] is now being recalled [ Re-called: $recalls time(s) ]! Please proceed to the consultation area immediately. Else, your queue number will be ended.";
        // $message = "Hi! Your Queue Number is Now Serving! Please proceed to the consultation area. Thank you for waiting.";
        $chat_id = $row["chat_id"];
        pushNotification($message, $chat_id);

        $pageUrl = $helper->pageUrl('appointment.php');

        if (isset($_POST["course_id"]) && !$result) {
            echo 'call failed w/ course_id';
            $pageUrl .= '?course_id=' . $_POST["course_id"] . '&call=failed';
        } else if (isset($_POST["course_id"]) && $result) {
            echo 'call success w/ course_id';
            $pageUrl .= '?course_id=' . $_POST["course_id"];
        } else if (!$result) {
            echo 'call failed w/o course_id';
            $pageUrl .= '?call=failed';
        }

        header("Location: $pageUrl");
        exit;

    } else {
        
        $pageUrl = $helper->pageUrl('appointment.php');
        header("Location: $pageUrl");
        exit;
    }

    function pushNotification($message, $chat_id) {
        try {
            // Create Telegram API object
            $bot_api_key  = '976443852:AAGSd8gWovPo8jOjppg02GkoPpjWGi9B-cI';
            $bot_username = 'npictoh_bot';
            $telegram = new Longman\TelegramBot\Telegram($bot_api_key, $bot_username);

            $data = [
                'chat_id' => $chat_id,
                'text' => $message
            ];

            return Request::sendMessage($data);

        } catch (Longman\TelegramBot\Exception\TelegramException $e) {
            // log telegram errors
            echo $e->getMessage();
        }
    }
?>