<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

$patient_id = $_GET['patient_id'];

// Fetch process details
$process_sql = "SELECT * FROM process_details WHERE patient_nic = (SELECT patient_nic FROM patients WHERE patient_id = ?)";
$stmt = $conn->prepare($process_sql);
$stmt->bind_param("i", $patient_id);
$stmt->execute();
$process_result = $stmt->get_result();
$process_details = $process_result->fetch_all(MYSQLI_ASSOC);

// Fetch diagnosis details
$diagnosis_sql = "SELECT * FROM diagnosis WHERE patient_nic = (SELECT patient_nic FROM patients WHERE patient_id = ?)";
$stmt = $conn->prepare($diagnosis_sql);
$stmt->bind_param("i", $patient_id);
$stmt->execute();
$diagnosis_result = $stmt->get_result();
$diagnosis_details = $diagnosis_result->fetch_all(MYSQLI_ASSOC);

$response = [
    'process_details' => $process_details,
    'diagnosis_details' => $diagnosis_details
];

echo json_encode($response);

$conn->close();
?>
