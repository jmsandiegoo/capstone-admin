<?php
    session_start();
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
                        <a href="#">General</a>
                    </li>
                    <li>
                        <a href="#">Course 1</a>
                    </li>
                    <li>
                        <a href="#">Course 2</a>
                    </li>
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
