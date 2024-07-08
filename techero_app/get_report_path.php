<?php
header('Content-Type: application/json');

$patient_id = $_GET['patient_id'];

$servername = "localhost";
$username = "root";
$password = "";
$database = "doctor_registration"; 

$conn = new mysqli($servername, $username, $password, $database);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

// Fetch report_path 
$sql = "SELECT report_path FROM reports WHERE patient_id = $patient_id";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $response = array("report_path" => $row["report_path"]);
  echo json_encode($response);
} else {
  echo json_encode(array("report_path" => null)); 
}

$conn->close();
?>
