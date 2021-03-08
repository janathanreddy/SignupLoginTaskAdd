<?php
$con = new mysqli("localhost:3306","appstudio","_3JJaHdcS,G{","appstudi_users");
if($con){
	echo"connection success!!!!!";
}
else{
	echo"connection failed";
}
