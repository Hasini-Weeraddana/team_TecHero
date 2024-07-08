<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";
$fromEmail = "hasiniweeraddana@gmail.com"; 
$appPassword = "jfoj ltzz syag kwen"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$fullName = $_POST['fullName'];
$mediRegNum = $_POST['mediRegNum'];
$birthOfDate = $_POST['birthOfDate'];
$gender = $_POST['gender'];
$workPlace = $_POST['workPlace'];
$phone = $_POST['phone'];
$password = $_POST['password'];
$email = $_POST['email'];

$emailCheckQuery = $conn->prepare("SELECT email FROM doctors WHERE email = ?");
$emailCheckQuery->bind_param("s", $email);
$emailCheckQuery->execute();
$emailCheckQuery->store_result();

if ($emailCheckQuery->num_rows > 0) {
    echo "Error: Email already exists";
    $emailCheckQuery->close();
    $conn->close();
    exit();
}

$emailCheckQuery->close();

$hashedPassword = password_hash($password, PASSWORD_BCRYPT);
$activationCode = bin2hex(random_bytes(16)); // Generate a random activation code

$stmt = $conn->prepare("INSERT INTO doctors (fullName, mediRegNum, birthOfDate, gender, workPlace, phone, password, email, activation_code, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0)");
$stmt->bind_param("sssssssss", $fullName, $mediRegNum, $birthOfDate, $gender, $workPlace, $phone, $hashedPassword, $email, $activationCode);

if ($stmt->execute()) {
    // Send activation email
    $activationLink = "http://10.0.2.2/techero_app/activate.php?code=$activationCode";
    $subject = "Account Activation";
    $message = "Please click the link below to activate your account:\n$activationLink";
    $headers = "From: $fromEmail";

    $mailHeaders = [
        'From' => $fromEmail,
        'Reply-To' => $fromEmail,
        'X-Mailer' => 'PHP/' . phpversion()
    ];

    ini_set('SMTP', 'smtp.gmail.com');
    ini_set('smtp_port', '587');
    ini_set('sendmail_from', $fromEmail);
    ini_set('auth_username', $fromEmail);
    ini_set('auth_password', $appPassword);
    ini_set('smtp_auth', true);
    ini_set('smtp_secure', 'tls');

    if (mail($email, $subject, $message, $headers)) {
        echo "New record created successfully. Please check your email to activate your account.";
    } else {
        echo "Error: Unable to send activation email.";
    }
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>
