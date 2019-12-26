<?php  
    session_start();
    include_once __DIR__.'/../helpers/helper.php';
    $helper = new Helper();

    $success = false;
    if (isset($_GET["reset"])) {
        if ($_GET["reset"] == "success") {
            $success = !$success;
        }
    }
?>

<!DOCTYPE html>
<html lang="en">
    <?php include $helper->subviewPath('header.php') ?>
    <main class="login-container">
        <div class="login">
            <h1>Reset your Password</h1>
            <p>An e-mail will be send to you with instructions on how to reset your password.</p>
            <form action="<?php echo $helper->processUrl('loginFunctions.php') ?>" method="POST">
                <div class="form-group">
                    <label for="emailAddressField"><i class="fas fa-envelope"></i></label>
                    <input type="email" class="text-field" id="emailAddressField" placeholder="Email Address" name="email" >
                </div>
                <input type="hidden" name="forgotPassword" value="true">
                <?php if($success): ?>
                    <div id="loginErrorMessage" class="alert alert-success" role="alert">
                        Email sent successfully, Please check your email!
                    </div>
                <?php endif; ?>
                <button class="btn btn-login" type="submit" name="reset-request-submit">Reset Password</button>
            </form>
            <small><a href="<?php echo $helper->pageUrl("index.php")?>" id="backBtn"><u>Back to Login</u></a></small>
        </div>
        <!-- img logo here -->

    </main>
    <?php include $helper->subviewPath('footer.php') ?>  
</html>