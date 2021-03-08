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

$username = $_POST['username'];
$TaskName = $_POST['TaskName'];
$TaskStatus = $_POST['TaskStatus'];
$Id = $_POST['Id'];
$Start_Date = $_POST['date'];
$End_Date = $_POST['End_Date'];
echo $Id;
$sql = "UPDATE `UserTaskTable` SET `Taskname` = '$TaskName',`TaskStatus` = '$TaskStatus',`date` = '$Start_Date',`End_Date` = '$End_Date' WHERE `Id` = '$Id'";


if ($conn->query($sql) === TRUE) {
    echo "record updated successfully";
}else {
    echo "Error: " .$sql . "<br>" . $conn->error;
}

$conn->close();

?>
