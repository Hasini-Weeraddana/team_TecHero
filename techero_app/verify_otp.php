<?php
include 'config.php';

$email = $_POST['email'];
$otp = $_POST['otp'];

$stmt = $conn->prepare("SELECT otp, otp_expiry FROM doctors WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->bind_result($storedOtp, $otpExpiry);
$stmt->fetch();
$stmt->close();

if ($storedOtp == $otp && strtotime($otpExpiry) > time()) {
    echo "OTP verified successfully.";
} else {
    echo "Invalid or expired OTP.";
}

$conn->close();
?>
