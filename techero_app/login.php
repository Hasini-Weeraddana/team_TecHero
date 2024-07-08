<?php
session_start(); 

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$email = $_POST['email'];
$password = $_POST['password'];

$stmt = $conn->prepare("SELECT id, fullName, password, is_active FROM doctors WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    $stmt->bind_result($id, $fullName, $hashedPassword, $isActive);
    $stmt->fetch();

    if ($isActive == 1) {
        if (password_verify($password, $hashedPassword)) {
            $_SESSION['doctor_id'] = $id; 
            echo json_encode(["message" => "Login successful", "doctor_id" => $id]);
        } else {
            echo json_encode(["message" => "Invalid username or password"]);
        }
    } else {
        echo json_encode(["message" => "Account not activated. Please check your email to activate your account."]);
    }
} else {
    echo json_encode(["message" => "Invalid username or password"]);
}

$stmt->close();
$conn->close();
?>
