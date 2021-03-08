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

$date = $_POST['date'];
$username = $_POST['username'];
$TaskName = $_POST['TaskName'];
$TaskStatus = $_POST['TaskStatus'];
$End_Date = $_POST['End_Date'];

$sql = "INSERT INTO UserTaskTable (date,username,Taskname, TaskStatus,End_Date) VALUES ('$date','$username','$TaskName','$TaskStatus','$End_Date');";

if ($conn->query($sql) === TRUE) {
	echo "New record created successfully";
}else {
	echo "Error: " .$sql . "<br>" . $conn->error;
}

$conn->close();

?>
