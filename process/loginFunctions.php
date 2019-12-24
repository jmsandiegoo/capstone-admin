<?php
    session_start();
    include_once __DIR__. '/../helpers/helper.php';
    include_once __DIR__. '/../helpers/mysql.php';
    $helper = new Helper();
    $db = new Mysql_Driver();

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

            $db->connect();

            $qry = "SELECcT * FROM Account WHERE email = ? AND id = ?";

            $result = $db->query($qry, $email, 1);

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

        $selector = bin2hex(random_bytes(8));
        $token = bin2hex(random_bytes(32));

        $url = $helper->pageUrl('createNewPassword.php'). "?selector=" . $selector . "&validator=" . $token;

        // Set expiry for tokens
        $expires = date("U") + 1800;

        $email = $_POST["email"];
        $db->connect();
        $qry = "DELETE FROM PwdReset WHERE reset_email=?";
        $result = $db->query($qry, $email);

        $qry = "INSERT INTO PwdReset (reset_email, reset_selector, reset_token, reset_expires) VALUES (?, ?, ?, ?)";
        

    } else {
        $pageUrl = $helper->pageUrl('index.php');
        header("Location: $pageUrl");
    }

?>