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

$Id = $_POST['Id'];
$Name = $_POST['name'];
$Username = $_POST['username'];
$Password = $_POST['password'];



$sql = "INSERT INTO details (Id, name, username, password) VALUES ('$Id','$Name','$Username','$Password');";


if ($conn->query($sql) === TRUE) {
	echo "New record created successfully";
}else {
	
	echo "Error: " .$sql . "<br>" . $conn->error;

}

$conn->close();



?>
