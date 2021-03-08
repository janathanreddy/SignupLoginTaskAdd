
<?php
// Create connection


$con = mysqli_connect("localhost:3306","appstudio","_3JJaHdcS,G{","appstudi_users");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
 
$username = $_POST['username'];
$password = $_POST['password'];

// echo $username;
$sql = "SELECT * FROM details WHERE username = '$username' AND password = '$password'";
 
// Confirm there are results
if ($result = mysqli_query($con, $sql))
{
    $resultObj;
    $count = mysqli_num_rows($result);
    if ($count == 0){
        $resultObj->response = "failure";
    } else {
        $resultObj->response ="success";
    }
    
    // We have results, create an array to hold the results
        // and an array to hold the data
    // $resultArray = array();
    // $tempArray = array();
 
    // // Loop through each result
    // while($row = $result->fetch_object())
    // {
    //     // Add each result into the results array
    //     $tempArray = $row;
    //     array_push($resultArray, $tempArray);
    // }
 
    // Encode the array to JSON and output the results
    echo json_encode($resultObj);
}
 
// Close connections
mysqli_close($con);
?>
