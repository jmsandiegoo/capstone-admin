<?php
    session_start();

    use PHPMailer\PHPMailer\PHPMailer;
    use PHPMailer\PHPMailer\SMTP;
    use PHPMailer\PHPMailer\Exception;

    require __DIR__. '/../vendor/autoload.php';
    include_once __DIR__. '/../helpers/helper.php';
    include_once __DIR__. '/../helpers/mysql.php';

    $mail = new PHPMailer(true);

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
            $_SESSION["email"] = $email;
            $_SESSION["password"] = $password;
            $pageUrl = $helper->pageUrl('index.php') . "?error=empty";
            header("Location: $pageUrl");
            exit;
        } else {
            // check if account is valid
            $db->connect();

            $qry = "SELECT * FROM Account WHERE email = ?";

            $result = $db->query($qry, $email);

            $db->close();
            
            if ($db->num_rows($result) > 0) { 
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

            }
            $_SESSION["email"] = $email;
            $_SESSION["password"] = $password;
            $pageUrl = $helper->pageUrl('index.php') . "?error=incorrect";
            header("Location: $pageUrl");
            exit;
        }

    } else if (isset($_POST["forgotPassword"])) {

        $selector = bin2hex(random_bytes(8));
        $token = random_bytes(32);

        $url = $helper->pageUrl('createNewPassword.php'). "?selector=" . $selector . "&validator=" . bin2hex($token);
        echo "</br>$url";

        // Set expiry for tokens
        $expires = date("U") + 1800;

        $email = $_POST["email"];

        $db->connect();
        $qry = "DELETE FROM PwdReset WHERE reset_email=?";
        $result = $db->query($qry, $email);

        $qry = "INSERT INTO PwdReset (reset_email, reset_selector, reset_token, reset_expires) VALUES (?, ?, ?, ?)";
        
        $hashedToken = password_hash($token, PASSWORD_DEFAULT);
        $db->query($qry, $email, $selector, $hashedToken, $expires);

        $db->close();

        try {
        // Prepare email
        $mail->isSMTP();
        $mail->SMTPAuth = true;
        $mail->SMTPSecure = 'ssl';
        $mail->Host = 'smtp.gmail.com';
        $mail->Port = '465';
        $mail->isHTML();
        $mail->Username = 'npictopenhousenoreply@gmail.com';
        $mail->Password = 'Npict2019!';
        $mail->SetFrom('noreply@npictopenhouse.com');
        $mail->Subject = 'Reset your password for NP ICT Open House Admin Panel';

        $message = "<p><b>(This is auto-generated. Please do not reply to this email)</b></p>
        <p>We received a password reset request. The link to reset your password
        make this request, you can ignore this email</p>";
        $message .= "<p> Here is your password reset link: </br>";
        $message .= '<a href="' . $url . '">' . $url . '</a></p>';

        $mail->Body = $message;

        $mail->AddAddress($email);

        $mail->Send();
        
        $pageUrl = $helper->pageUrl('forgotPassword.php') . "?reset=success";
        header("Location: $pageUrl");
        } catch (Exception $e) {
        die($e->getMessage());

        }

    } else if (isset($_POST["createNewPassword"])) {

        $selector = $_POST["selector"];
        $validator = $_POST["validator"];
        $password = $_POST["password"];
        $cfmPassword = $_POST["cfmPassword"];

        if (empty($password) || empty($cfmPassword)) {
            $pageUrl = $helper->pageUrl('createNewPassword.php') . "?selector=" . $selector . "&validator=" . $validator . "&error=empty";
            header("Location: $pageUrl");
            exit;
        } else if ($password !== $cfmPassword) {
            $pageUrl = $helper->pageUrl('createNewPassword.php') . "?selector=" . $selector . "&validator=" . $validator . "&error=pwdnotsame";
            header("Location: $pageUrl");
            exit;
        }

        $currentDate = date("U");

        $db->connect();

        $qry = "SELECT * FROM PwdReset WHERE reset_selector= ? AND reset_expires >= ?";

        $result = $db->query($qry, $selector, $currentDate);

        if ($db->num_rows($result) <= 0) {
            //  You need to resubmit your reset request
            echo "You need to resubmit your reset request1";
            $pageUrl = $helper->pageUrl('createNewPassword.php') . '?reset=failed';
            header("Location: $pageUrl");
            exit; 
        }

        while ($row = $db->fetch_array($result)) {
            $tokenBin = hex2bin($validator);
            $tokenCheck = password_verify($tokenBin, $row["reset_token"]);

            if (!$tokenCheck) {
                // You need to resubmit your reset request
                echo "You need to resubmit your reset request2";
                $pageUrl = $helper->pageUrl('createNewPassword.php') . '?reset=failed';
                header("Location: $pageUrl");
                exit; 
            } else if ($tokenCheck) {

                // Update the password

                $tokenEmail = $row['reset_email'];

                $qry = "SELECT * FROM Account WHERE email=?";

                $accountResult = $db->query($qry, $tokenEmail);

                if ($db->num_rows($accountResult) <= 0) {
                    // You need to resubmit your reset request
                    echo "You need to resubmit your reset request3";
                    $pageUrl = $helper->pageUrl('createNewPassword.php') . '?reset=failed';
                    header("Location: $pageUrl");
                    exit; 
                } else {
                    $qry = "UPDATE Account SET password=? WHERE email=?";
                    $db->query($qry, password_hash($password, PASSWORD_DEFAULT), $tokenEmail);
    
                    // Delete tokens after use
                    $qry = "DELETE FROM PwdReset WHERE reset_email=?";
                    $db->query($qry, $tokenEmail);
    
                    $db->close();
    
                    $pageUrl = $helper->pageUrl('index.php') . "?pwdupdate=success";
                    header("Location: $pageUrl");
                    exit;
                }
            }
        }
    } else {
        $pageUrl = $helper->pageUrl('index.php');
        header("Location: $pageUrl");
    }

?>