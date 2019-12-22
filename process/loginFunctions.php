<?php 
    include_once __DIR__. '/../helpers/helper.php';
    include_once __DIR__. '/../helpers/mysql.php';
    session_start();
    $helper = new Helper();

    if (isset($_SESSION['loggedin'])) {
        $pageUrl = $helper->pageUrl('appointment.php');
        header("Location: $pageUrl");
        exit;
    }

    if (isset($_POST["authenticate"])) {
        $email = $_POST["email"];
        $password = $_POST["password"];
        // check if email field
        if (empty($email) || empty($password)) {
            $empty_error = "Please fill both <b> email and password </b> fields.";
            $_SESSION["login_error"] = $empty_error;
            $_SESSION["email"] = $email;
            $_SESSION["password"] = $password;
            $pageUrl = $helper->pageUrl('index.php');
            header("Location: $pageUrl");
            exit;
        } else {
            // check if account is valid
            $db = new Mysql_Driver();

            $db->connect();

            $qry = "SELECT * FROM Account WHERE email = '$email'";

            $result = $db->query($qry);

            if ($db->num_rows($result) <= 0) {
                echo "No results";
                $login_error = "Sorry, it seems that the <b> email and/or password is incorrect </b>. Please try again.";
            } else { 
                echo "Got results";
                $row = $db->fetch_array($result);
                $userId = $row["id"]; 
                $correctPassword = $row["password"];
                echo "Password: $password". gettype($password) . "Correct: $correctPassword" . gettype($correctPassword);
                if (password_verify($password, $correctPassword)) {
                    echo "doesnt go here wtf?";
                    session_regenerate_id();
                    $_SESSION['loggedin'] = TRUE;
                    $_SESSION['email'] = $email;
                    $_SESSION['user_id'] = $userId;
                    $pageUrl = $helper->pageUrl('appointment.php');
                    header("Location: $pageUrl");
                    exit;
                }

                $login_error = "Sorry, it seems that the <b> email and/or password is incorrect </b>. Please try again.";
            }
            $_SESSION["login_error"] = $login_error;
            $_SESSION["email"] = $email;
            $_SESSION["password"] = $password;
            $pageUrl = $helper->pageUrl('index.php');
            header("Location: $pageUrl");
            exit;
        }

    } else if (isset($_POST["forgotPassword"])) {

    }

?>