<?php 
    session_start();
    include_once __DIR__.'/../helpers/helper.php';
    $helper = new Helper();

    if (!isset($_SESSION['loggedin'])) {
        echo 'goes here';
        $pageUrl = $helper->pageUrl('index.php');
        header("Location: $pageUrl");
        exit;
    }


?>

<!DOCTYPE html>
<html lang="en">
    <?php include $helper->subviewPath('header.php') ?>

    <main class="main-content-wrapper">
        <?php include $helper->subviewPath('sidebar.php')?>
        <!-- main content -->
        <section class="content">
            <?php include $helper->subviewPath('navbar.php')?>
        </section>
    </main>
    <?php include $helper->subviewPath('footer.php') ?>
</html>