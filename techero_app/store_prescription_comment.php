<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$patientNic = $_POST['patient_nic'];
$additionalComments = $_POST['additional_comments'];

$sql = "INSERT INTO prescription (patient_nic, additional_comments) VALUES (?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $patientNic, $additionalComments);

if ($stmt->execute()) {
    echo "Comment saved successfully";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$conn->close();
?>
