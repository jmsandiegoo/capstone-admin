<?php
    // include_once __DIR__.'/../../helpers/mysql.php';
    // // Get the courses
    // $db = new Mysql_Driver();

    $db->connect();

    $qry = "SELECT * FROM Course";

    $courseResult = $db->query($qry);

    $db->close();

?>

<div class="wrapper">
    <!-- Sidebar -->
    <nav id="sidebar">
        <div class="sidebar-header">
            <h3>School of ICT</h3>
        </div>

        <ul class="list-unstyled components">
            <p>Admin Menu</p>
            <li class="active">
                <a href="#appointmentSubmenu" data-toggle="collapse" aria-expanded="false" class="dropdown-toggle">Appointments</a>
                <ul class="collapse list-unstyled" id="appointmentSubmenu">
                    <li>
                        <a href="<?php echo $helper->pageUrl('appointment.php') ?>">General</a>
                    </li>
                    <?php while($row = $db->fetch_array($courseResult)): ?>
                        <li>
                            <a href="<?php echo $helper->pageUrl('appointment.php') . '?course_id=' . $row['id']?>"><?php echo $row['course_name'] ?></a>
                        </li>
                    <?php endwhile; ?>
                </ul>
            </li>
        </ul>

        <ul class="list-unstyled logout-container">
            <li>
                <small>Welcome: <br/> <?php echo $_SESSION['email'] ?> <br/></small>
                <a class="logout" href="<?php echo $helper->processUrl('logout.php') ?>">Logout</a>
            </li>
        </ul>
    </nav>

</div>
