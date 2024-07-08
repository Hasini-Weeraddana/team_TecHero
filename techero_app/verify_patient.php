<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}


if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $patient_id = $_POST['patient_id'];

    $query = "UPDATE patients SET is_check = 1 WHERE patient_id = ?";
    $stmt = $conn->prepare($query);
    $stmt->bind_param('i', $patient_id);

    if ($stmt->execute()) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to update patient']);
    }

    $stmt->close();
    $conn->close();
}
?>
