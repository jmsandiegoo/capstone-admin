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
        $course_id = $_GET["course_id"];
    }

    $db->connect();

    $appointmentWaitingResult = null;
    $appointmentServingResult = null;

    $appointmentName = "General";

    if ($course_id) {
        // Get the appointment records status pending
        $qry = "SELECT * , TIMESTAMPDIFF(SECOND, appointment_createdate, NOW()) AS 'waiting_time' FROM Appointment 
                WHERE course_id = ? AND appointment_status = 'Pending' 
                ORDER BY waiting_time DESC";

        $appointmentWaitingResult = $db->query($qry, $course_id);

        // Get the appointment records status now serving
        $qry = "SELECT * , TIMESTAMPDIFF(SECOND, appointment_lastcalled, NOW()) AS 'last_called' FROM Appointment 
        WHERE course_id = ? AND appointment_status = 'Now Serving' 
        ORDER BY last_called ASC";

        $appointmentServingResult = $db->query($qry, $course_id);

        // Get the appointment name
        $qry = "SELECT * FROM Course WHERE course_id = ?";

        $courseResult = $db->query($qry, $course_id);

        $row = $db->fetch_array($courseResult);

        $appointmentName = $row["course_name"];

    } else {
        // Get the appointment records status pending
        $qry = "SELECT * , TIMESTAMPDIFF(SECOND, appointment_createdate, NOW()) AS 'waiting_time' FROM Appointment 
                WHERE course_id IS NULL AND appointment_status = 'Pending' 
                ORDER BY waiting_time DESC";

        $appointmentWaitingResult = $db->query($qry);

        // Get the appointment records status now serving
        $qry = "SELECT * , TIMESTAMPDIFF(SECOND, appointment_lastcalled, NOW()) AS 'last_called' FROM Appointment 
        WHERE course_id IS NULL AND appointment_status = 'Now Serving' 
        ORDER BY last_called ASC";

        $appointmentServingResult = $db->query($qry);
    }

    $db->close();

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
                    <?php while($row = $db->fetch_array($appointmentWaitingResult)): ?>
                        <tr>
                        <th scope="row"><?php echo $row['appointment_id'] ?></th>
                        <td><?php echo $row['appointment_name'] ?></td>
                        <td>
                            <?php echo $helper->secondsToTime($row['waiting_time']) ?>
                        </td>
                        <td class="action-cell">
                            <form action="<?php echo $helper->processUrl('appointmentFunctions.php') ?>" method="POST">
                                <input type="hidden" name="appointment_id" value="<?php echo $row['appointment_id'] ?>" />
                                <?php if($course_id): ?>
                                    <input type="hidden" name="course_id" value="<?php echo $course_id ?>" />
                                <?php endif; ?>
                                <button type="submit" class="btn btn-dark" name="call-submit">Call</button>
                            </form>
                            <form action="<?php echo $helper->processUrl('appointmentFunctions.php') ?>" method="POST">
                                <input type="hidden" name="appointment_id" value="<?php echo $row['appointment_id'] ?>" />
                                <?php if($course_id): ?>
                                    <input type="hidden" name="course_id" value="<?php echo $course_id ?>" />
                                <?php endif; ?>
                                <button type="submit" class="btn btn-light" name="end-submit">Skip</button>
                            </form>
                        </td>
                        </tr>
                    <?php endwhile; ?>
                    <?php if (!$db->num_rows($appointmentWaitingResult) > 0): ?>
                        <tr>
                        <td colspan="100%" class="text-center">There are no pending appointments currently.</td>
                        </tr>
                    <?php endif; ?>
                    </tbody>
                    
                </table>
                
                <h3>Now Serving</h3>
                <table class="table table-bordered">
                    <thead class="thead-dark">
                        <tr>
                        <th scope="col">Queue No.</th>
                        <th scope="col">Name</th>
                        <th scope="col">Last Called</th>
                        <th scope="col">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php while($row = $db->fetch_array($appointmentServingResult)): ?>
                        <tr>
                        <th scope="row"><?php echo $row['appointment_id'] ?></th>
                        <td><?php echo $row['appointment_name'] ?></td>
                        <td>
                            <?php echo $helper->secondsToTime($row['last_called']) ?>
                        </td>
                        <td class="action-cell">
                            <form action="<?php echo $helper->processUrl('appointmentFunctions.php') ?>" method="POST">
                                <input type="hidden" name="appointment_id" value="<?php echo $row['appointment_id'] ?>" />
                                <?php if($course_id): ?>
                                    <input type="hidden" name="course_id" value="<?php echo $course_id ?>" />
                                <?php endif; ?>
                                <button type="submit" class="btn btn-dark" name="end-submit">End</button>
                            </form>
                            <form action="<?php echo $helper->processUrl('appointmentFunctions.php') ?>" method="POST">
                                <input type="hidden" name="appointment_id" value="<?php echo $row['appointment_id'] ?>" />
                                <?php if($course_id): ?>
                                    <input type="hidden" name="course_id" value="<?php echo $course_id ?>" />
                                <?php endif; ?>
                                <button type="submit" class="btn btn-light" name="recall-submit">Re-Call</button>
                            </form>
                        </td>
                        </tr>
                    <?php endwhile; ?>
                    <?php if (!$db->num_rows($appointmentServingResult) > 0): ?>
                        <tr>
                        <td colspan="100%" class="text-center">There are no appointments being served currently.</td>
                        </tr>
                    <?php endif; ?>
                    </tbody>
                    
                </table>
            </div>
        </section>
    </main>
    <?php include $helper->subviewPath('footer.php') ?>
</html>