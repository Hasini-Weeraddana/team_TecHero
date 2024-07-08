<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$doctor_id = $_POST['doctor_id'];
$workPlace = $_POST['workPlace'];
$phone = $_POST['phone'];

$profilePicture = null;
if (isset($_FILES['profilePicture'])) {
    $target_dir = "uploads/";
    $target_file = $target_dir . basename($_FILES["profilePicture"]["name"]);
    if (move_uploaded_file($_FILES["profilePicture"]["tmp_name"], $target_file)) {
        $profilePicture = basename($_FILES["profilePicture"]["name"]);
    } else {
        echo "Error uploading profile picture.";
        exit;
    }
}

$stmt = $conn->prepare("UPDATE doctors SET workPlace = ?, phone = ?, profilePicture = ? WHERE id = ?");
$stmt->bind_param("sssi", $workPlace, $phone, $profilePicture, $doctor_id);

if ($stmt->execute()) {
    echo "Details updated successfully";
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>
