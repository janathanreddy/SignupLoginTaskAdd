<?php
    $servername = "localhost:3306";
    $username = "appstudio";
    $password = "_3JJaHdcS,G{";
    $dbname = "appstudi_users";


$conn = new mysqli($servername, $username, $password, $dbname);


if ($conn->connect_error) {
    die("connection failed:  " . $conn->connect_error);

}else {
    echo "Connection OK, ";
}

$TaskName = $_POST['TaskName'];
$TaskStatus = $_POST['TaskStatus'];

$sql = "UPDATE `UserTaskTable` SET `TaskStatus` = '$TaskStatus' WHERE `Taskname` = '$TaskName';";


if ($conn->query($sql) === TRUE) {
    echo "record updated successfully";
}else {
    echo "Error: " .$sql . "<br>" . $conn->error;
}

$conn->close();

?>



