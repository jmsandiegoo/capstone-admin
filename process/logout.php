<?php 
    include_once __DIR__ . '/../helpers/helper.php';
    session_start();

    $helper = new Helper();

    session_destroy();

    $pageUrl = $helper->pageUrl('index.php');
    header("Location: $pageUrl");
    exit;
?>