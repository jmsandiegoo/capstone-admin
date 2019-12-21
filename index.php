<?php
    session_start();

    include_once __DIR__.'/helpers/helper.php';
    $helper = new Helper();

    if (isset($_SESSION['loggedin'])) {
        $pageUrl = $helper->pageUrl('home.php');
        header("Location: $pageUrl");
        exit;
    }

    $login_error = "";
    $email = "";
    $password = "";
    if (isset($_SESSION["login_error"])) {
        $login_error = $_SESSION["login_error"];
    }

    if (isset($_SESSION["email"]) && isset($_SESSION["password"])) {
        $email = $_SESSION["email"];
        $password = $_SESSION["password"];
    }
    unset($_SESSION["login_error"]);
    unset($_SESSION["email"]);
    unset($_SESSION["password"]);
?>
<!DOCTYPE html>
<html lang="en">
    <?php include $helper->subviewPath('header.php') ?>
    <main class="login-container">
        <div class="login">
            <h1>Login</h1>
            <form action="process/loginFunctions.php" method="POST">
                <div class="form-group">
                    <label for="emailAddressField"><i class="fas fa-envelope"></i></label>
                    <input type="email" class="text-field" id="emailAddressField" placeholder="Email Address" name="email" value="<?php echo $email ?>" >
                </div>
                <div class="form-group">
                    <label for="passwordField"><i class="fas fa-key"></i></label>
                    <input type="password" class="text-field" id="passwordField" placeholder="Password" name="password" value="<?php echo $password ?>" >
                </div>
                <input type="hidden" name="authenticate" value="true">
                <?php if($login_error): ?>
                    <div id="loginErrorMessage" class="alert alert-danger" role="alert">
                        <?php echo $login_error ?>
                    </div>
                <?php endif; ?>
                <button class="btn btn-login" type="submit">Log In</button>
            </form>
            <small><a href="<?php echo $helper->pageUrl("forgotPassword.php")?>" id="forgotPassword"><u>Forgot Password</u></a></small>
        </div>
        <!-- img logo here -->

    </main>
    <?php include $helper->subviewPath('footer.php') ?>
</html>