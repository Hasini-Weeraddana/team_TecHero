<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the doctor ID from GET request
$doctor_id = $_GET['doctor_id'];

// Prepare and bind
$stmt = $conn->prepare("SELECT id, fullName, mediRegNum, birthOfDate, gender, workPlace, phone, email, profilePicture FROM doctors WHERE id = ?");
$stmt->bind_param("i", $doctor_id);
$stmt->execute();
$stmt->bind_result($id, $fullName, $mediRegNum, $birthOfDate, $gender, $workPlace, $phone, $email, $profilePicture);
$stmt->fetch();

if ($id) {
    $doctor = array(
        "id" => $id,
        "fullName" => $fullName,
        "mediRegNum" => $mediRegNum,
        "birthOfDate" => $birthOfDate,
        "gender" => $gender,
        "workPlace" => $workPlace,
        "phone" => $phone,
        "email" => $email,
        "profilePicture" => $profilePicture
    );
    echo json_encode($doctor);
} else {
    echo json_encode(array("error" => "Doctor not found"));
}

$stmt->close();
$conn->close();
?>
