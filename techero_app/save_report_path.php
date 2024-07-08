<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$patientId = $_POST['patient_id'];
$reportPath = $_POST['report_path'];

$sql = "INSERT INTO reports (patient_id, report_path) VALUES ($patientId, '$reportPath') 
        ON DUPLICATE KEY UPDATE report_path = '$reportPath'";

if ($conn->query($sql) === TRUE) {
  echo "Report path saved successfully";
} else {
  echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>
