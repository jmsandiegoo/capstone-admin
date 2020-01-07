<?php 
    session_start();
    include_once __DIR__.'/../helpers/helper.php';
    include_once __DIR__.'/../helpers/mysql.php';
    $helper = new Helper();
    $db = new Mysql_Driver();
    
    if (!isset($_SESSION['loggedin'])) {   
        $pageUrl = $helper->pageUrl('index.php');
        header("Location: $pageUrl");
        exit;
    }

    $course_id = '';

    if (isset($_GET["course_id"])) {
        $course_id = (int)$_GET["course_id"];
    }

    $appointmentName = "General";

    if ($course_id) {
        $db->connect();
        // Get the appointment name
        $qry = "SELECT * FROM Course WHERE id = ?";

        $courseResult = $db->query($qry, $course_id);

        $row = $db->fetch_array($courseResult);
        $appointmentName = $row["course_name"];

        $db->close();
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
            <!-- Table View -->
            <div class="table-wrapper">
                <h2><?php echo $appointmentName ?></h2>
                <hr>
                <h3>Waiting</h3>
                <table class="table table-bordered pending-table">
                    <thead class="thead-dark">
                        <tr>
                        <th scope="col">Queue No.</th>
                        <th scope="col">Name</th>
                        <th scope="col">Waiting Time</th>
                        <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Populated by js -->
                    </tbody>
                    
                </table>
                
                <h3>Now Serving</h3>
                <table class="table table-bordered now-serving-table">
                    <thead class="thead-dark">
                        <tr>
                        <th scope="col">Queue No.</th>
                        <th scope="col">Name</th>
                        <th scope="col">Course</th>
                        <th scope="col">Last Called</th>
                        <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Populated by js -->
                    </tbody>
                    
                </table>
            </div>
        </section>
    </main>

    <script src="<?php echo $helper->jsPath('appointment.js') ?>"></script>
    <?php include $helper->subviewPath('footer.php') ?>
</html>