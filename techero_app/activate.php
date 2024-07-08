<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$activationCode = $_GET['code'];

$stmt = $conn->prepare("UPDATE doctors SET is_active = 1 WHERE activation_code = ?");
$stmt->bind_param("s", $activationCode);

if ($stmt->execute()) {
    echo "Account activated successfully. You can now log in.";
} else {
    echo "Error activating account: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>