<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: login.php");
    exit();
}

require 'vendor/autoload.php';
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['mediRegNum']) && isset($_POST['status'])) {
        $mediRegNum = $_POST['mediRegNum'];
        $status = $_POST['status'];

        
        $conn = new mysqli('localhost', 'root', '', 'doctor_registration');

        if ($conn->connect_error) {
            die("Connection failed: " . $conn->connect_error);
        }

        
        $sql = "UPDATE doctors SET is_active = $status WHERE mediRegNum = '$mediRegNum'";

        if ($conn->query($sql) === TRUE) {
            
            $emailQuery = "SELECT email, fullName FROM doctors WHERE mediRegNum = '$mediRegNum'";
            $emailResult = $conn->query($emailQuery);

            if ($emailResult->num_rows > 0) {
                $row = $emailResult->fetch_assoc();
                $doctorEmail = $row['email'];
                $doctorName = $row['fullName'];
                $statusMessage = $status ? 'activated' : 'deactivated';

                
                $mail = new PHPMailer(true);
                try {
                    
                    $mail->isSMTP();
                    $mail->Host = 'smtp.gmail.com';
                    $mail->SMTPAuth = true;
                    $mail->Username = 'hasiniweeraddana@gmail.com'; 
                    $mail->Password = 'jfoj ltzz syag kwen'; 
                    $mail->SMTPSecure = 'tls';
                    $mail->Port = 587;

                    
                    $mail->setFrom('hasiniweeraddana@gmail.com', 'Admin Panel'); 
                    $mail->addAddress($doctorEmail, $doctorName);

                 
                    $mail->isHTML(true);
                    $mail->Subject = 'Account Status Changed';
                    $mail->Body = "Dear $doctorName,<br><br>Your account has been $statusMessage.<br><br>Best Regards,<br>TecHero,<br>Admin Panel";

                    $mail->send();
                    echo json_encode(['success' => true]);
                } catch (Exception $e) {
                    echo json_encode(['success' => false, 'error' => "Message could not be sent. Mailer Error: {$mail->ErrorInfo}"]);
                }
            } else {
                echo json_encode(['success' => false, 'error' => 'Doctor email not found']);
            }
        } else {
            echo json_encode(['success' => false, 'error' => $conn->error]);
        }

        $conn->close();
    } else {
        echo json_encode(['success' => false, 'error' => 'mediRegNum and status not provided']);
    }
} else {
    echo json_encode(['success' => false, 'error' => 'Invalid request method']);
}
?>
