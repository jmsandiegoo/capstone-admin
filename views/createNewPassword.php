<?php 

    include_once __DIR__.'/../helpers/helper.php';
    $helper = new Helper();

    $validReq = false;
    $errorMessage = "";

    $selector = "";
    $validator = "";

    // Valid request
    if (isset($_GET["selector"]) && isset($_GET["validator"])) {
        $selector = $_GET["selector"];
        $validator = $_GET["validator"];
        if (!empty($_GET["selector"]) && !empty($_GET["validator"])) {
            $validReq = true;
        }
    } else if (isset($_GET["reset"])) {
        $validReq = false;
        $errorMessage = "Reset password failed! Please try requesting for a new email password reset.";

    } else {
        $validReq = false;
        $errorMessage = "We could not validate your request! Please try again";
    }

?>


<!DOCTYPE html>
<html lang="en">
    <?php include $helper->subviewPath('header.php') ?>
    <main class="login-container">
        <div class="login">
            <?php if($validReq): ?>

                <h1>Create New Password</h1>
                <form action="<?php echo $helper->processUrl('loginFunctions.php') ?>" method="POST">
                    <div class="form-group">
                        <label for="passwordField"><i class="fas fa-envelope"></i></label>
                        <input type="password" class="text-field" id="passwordField" placeholder="Enter new password" name="password" >
                    </div>
                    <div class="form-group">
                        <label for="cfmPasswordField"><i class="fas fa-envelope"></i></label>
                        <input type="password" class="text-field" id="cfmPasswordField" placeholder="Confirm new password" name="cfmPassword" >
                    </div>
                    <input type="hidden" name="selector" value="<?php echo $selector ?>">
                    <input type="hidden" name="validator" value="<?php echo $validator ?>">
                    <input type="hidden" name="createNewPassword" value="true">
                    <button class="btn btn-login" type="submit" name="reset-password-submit">Create New Password</button>
                </form>
                <small><a href="<?php echo $helper->pageUrl("index.php")?>" id="backBtn"><u>Back to Login</u></a></small>

            <?php else: ?>
                <h1>Sorry...</h1>
                <div id="loginErrorMessage" class="alert alert-danger" role="alert">
                    <?php echo $errorMessage ?>
                </div>
                <small><a href="<?php echo $helper->pageUrl("index.php")?>" id="backBtn"><u>Back to Login</u></a></small>
            <?php endif; ?>
        </div>
        <!-- img logo here -->

    </main>
    <?php include $helper->subviewPath('footer.php') ?> 
</html>