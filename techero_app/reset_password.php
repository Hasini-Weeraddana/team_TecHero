<?php
include 'config.php';

$email = $_POST['email'];
$newPassword = $_POST['password'];
$hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT);

$stmt = $conn->prepare("UPDATE doctors SET password = ?, otp = NULL, otp_expiry = NULL WHERE email = ?");
$stmt->bind_param("ss", $hashedPassword, $email);

if ($stmt->execute()) {
    echo "Password reset successfully.";
} else {
    echo "Error resetting password.";
}

$stmt->close();
$conn->close();
?>
