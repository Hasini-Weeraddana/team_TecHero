<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$mediRegNum = $_GET['mediRegNum'];

$stmt = $conn->prepare("SELECT patient_id, first_name, patient_nic, is_check FROM patients WHERE mediRegNum = ?");
$stmt->bind_param("s", $mediRegNum);
$stmt->execute();
$result = $stmt->get_result();

$patients = array();
while ($row = $result->fetch_assoc()) {
    $patients[] = $row;
}

echo json_encode($patients);

$stmt->close();
$conn->close();
?>
