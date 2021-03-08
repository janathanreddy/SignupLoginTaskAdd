<?php
$con = mysqli_connect("localhost:3306","appstudio","_3JJaHdcS,G{","appstudi_users");
if(isset($_GET['logout'])) {
    $resultObj;
    session_destroy();
    unset($_SESSION['username']);
    unset($_SESSION['password']);
    $resultObj->response = "Success";
    echo json_encode($resultObj);

}else{
    $resultObj->response = "Failture";
    echo json_encode($resultObj);

}
?>