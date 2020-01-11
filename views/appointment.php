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

    // Fetch the appointment Types
    $db->connect();
    
    $qry = "SELECT id, course_name, course_abbreviations FROM Course";

    $courseResult = $db->query($qry);

    $db->close();

    $appointmentName = "General";
    $courseResultArray = array();

    while($row = $db->fetch_array($courseResult)) {
        $courseResultArray[] = $row;

        if ($course_id && $course_id == $row["id"]) {
            $appointmentName = $row["course_name"];
        }
    }

    $errorMessage = "";
    // Error handling
    if (isset($_GET['call'])) {
        if ($_GET['call'] == 'failed') {
            $errorMessage = "Oops, it seems that a problem occured while calling a queue number. Please try again!";
        }
    } else if (isset($_GET['end'])) {
        if ($_GET['end'] == 'failed') {
            $errorMessage = "Ending the currently served appointment <b>failed</b>! Please try again.";
        }
    } else if (isset($_GET['recall'])) {
        if ($_GET['recall'] == 'failed') {
            $errorMessage = "Recalling the queue number <b>failed</b>! Please try again.";
        }
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
            <!-- Dashboard -->
            <?php if ($errorMessage): ?>
                <div id="errorMessage" class="alert alert-danger" role="alert">
                            <?php echo $errorMessage ?>
                </div>
            <?php endif; ?>
            <div class="dashboard-wrapper">
                <div class="container-fluid">
                    <div class="row align-items-stretch">
                        <div class="col-md d-flex flex-column justify-content-start">
                            <div class="card text-light bg-primary mb-3">
                                <div class="card-body">
                                    <h5 class="card-title">Today Queue</h5>
                                    <h3 class="queue-count">Fetching...</h3>
                                </div>
                            </div>
                            <div class="card text-light bg-success mb-3">
                                <div class="card-body">
                                    <h5 class="card-title">Today Served</h5>
                                    <h3 class="served-count">Fetching...</h3>
                                </div>
                            </div>
                            <div class="card text-light bg-danger mb-3">
                                <div class="card-body">
                                    <h5 class="card-title">Today Cancelled</h5>
                                    <h3 class="cancelled-count">Fetching...</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md">
                            <div class="card text-black bg-light mb-3">
                                <div class="card-body">
                                    <h5 class="card-title">Appointment List</h5>
                                    <table class="table dashboard-table">
                                        <thead>
                                            <th scope="col">Type</th>
                                            <th scope="col">Waiting</th>
                                            <th scope="col"></th>
                                        </thead>
                                        <tbody>
                                            <!-- Populated by js -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Table View -->
            <div class="table-wrapper">
                <h3>Waiting (<?php echo $appointmentName ?>)</h3>
                <table id="pending-table" class="table table-bordered pending-table">
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

    <script src="<?php echo $helper->jsPath('dashboard.js') ?>"></script>
    <script src="<?php echo $helper->jsPath('appointment.js') ?>"></script>
    <?php include $helper->subviewPath('footer.php') ?>
</html>