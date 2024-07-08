<?php
include 'config.php';

$email = $_POST['email'];
$otp = rand(100000, 999999);
$otpExpiry = date("Y-m-d H:i:s", strtotime('+10 minutes'));

$stmt = $conn->prepare("UPDATE doctors SET otp = ?, otp_expiry = ? WHERE email = ?");
$stmt->bind_param("sss", $otp, $otpExpiry, $email);

if ($stmt->execute() && $stmt->affected_rows > 0) {
    $subject = "Password Reset OTP";
    $message = "Your OTP for password reset is $otp. It will expire in 10 minutes.";
    $headers = "From: your-email@example.com";

    if (mail($email, $subject, $message, $headers)) {
        echo "OTP sent successfully.";
    } else {
        echo "Error sending OTP.";
    }
} else {
    echo "Error: Email not found.";
}

$stmt->close();
$conn->close();
?>
