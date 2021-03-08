<?php
// Create connection


$con=mysqli_connect("localhost:3306","appstudio","_3JJaHdcS,G{","appstudi_users");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
 

$sql = "select details.name,UserTaskTable.TaskStatus,count(UserTaskTable.TaskStatus) AS CountTask,GROUP_CONCAT(UserTaskTable.Taskname) AS GroupTask,UserTaskTable.username FROM UserTaskTable INNER join details on UserTaskTable.username = details.username where UserTaskTable.TaskStatus = 'Completed' OR UserTaskTable.TaskStatus = 'Pending' GROUP by UserTaskTable.TaskStatus,UserTaskTable.username";
 
// Confirm there are results
if ($result = mysqli_query($con, $sql))
{
	// We have results, create an array to hold the results
        // and an array to hold the data
	$resultArray = array();
	$tempArray = array();
 
	// Loop through each result
	while($row = $result->fetch_object())
	{
		// Add each result into the results array
		$tempArray = $row;
	    array_push($resultArray, $tempArray);
	}
 
	// Encode the array to JSON and output the results
	echo json_encode($resultArray);
}
 
// Close connections
mysqli_close($con);
?>
