<?php
// Create connection


$con = mysqli_connect("localhost:3306","appstudio","_3JJaHdcS,G{","appstudi_users");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
 
$username = $_POST['username'];
$sql = "SELECT *,DATEDIFF(End_Date,CURRENT_DATE) Remain_Days,DATEDIFF(End_Date,date) Total_Days FROM UserTaskTable WHERE DATE(date) < DATE(CURDATE()) AND username = '$username'";
 
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
