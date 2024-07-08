<?php
header('Content-Type: application/json');

$servername = "localhost"; 
$username = "root"; 
$password = ""; 
$dbname = "doctor_registration"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $patient_id = $_POST['patient_id'];
    $comment = $_POST['comment'];

    echo json_encode(["patient_id" => $patient_id, "comment" => $comment]);

    if (!empty($patient_id) && !empty($comment)) {
        $stmt = $conn->prepare("INSERT INTO prescription (patient_id, additional_comments) VALUES (?, ?)");
        if ($stmt === false) {
            die(json_encode(["success" => false, "message" => "Prepare failed: " . $conn->error]));
        }
        
        $bind = $stmt->bind_param("is", $patient_id, $comment);
        if ($bind === false) {
            die(json_encode(["success" => false, "message" => "Bind failed: " . $stmt->error]));
        }

        $execute = $stmt->execute();
        if ($execute) {
            echo json_encode(["success" => true, "message" => "Comment saved successfully"]);
        } else {
            echo json_encode(["success" => false, "message" => "Execute failed: " . $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "Invalid input"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}

$conn->close();
?>
