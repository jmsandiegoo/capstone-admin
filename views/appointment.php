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

    // $appointmentType = $GET["appointmentType"];
?>

<!DOCTYPE html>
<html lang="en">
    <?php include $helper->subviewPath('header.php') ?>
    <main class="main-content-wrapper">
        <?php include $helper->subviewPath('sidebar.php')?>
        <!-- main content -->
        <section class="content">
            <?php include $helper->subviewPath('navbar.php')?>
            <!-- Table View -->
            <div class="table-wrapper">
                <table class="table table-bordered">
                    <thead class="thead-dark">
                        <tr>
                        <th scope="col">Queue No.</th>
                        <th scope="col">Name</th>
                        <th scope="col">Waiting Time</th>
                        <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                        <th scope="row">1</th>
                        <td>Mark</td>
                        <td>Otto</td>
                        <td>Skip or Call</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
    <?php include $helper->subviewPath('footer.php') ?>
</html>