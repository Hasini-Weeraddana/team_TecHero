<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

if (isset($_GET['patient_id'])) {
    $patient_id = $_GET['patient_id'];

    // patient details
    $query_patient = "SELECT first_name, middle_name, last_name, patient_nic FROM patients WHERE patient_id = '$patient_id'";
    $result_patient = mysqli_query($conn, $query_patient);

    if (!$result_patient) {
        echo json_encode(['error' => 'Error fetching patient details']);
        exit;
    }

    $patient_details = mysqli_fetch_assoc($result_patient);

    // process details
    $query_process = "SELECT * FROM process_details WHERE patient_id = '$patient_id'";
    $result_process = mysqli_query($conn, $query_process);

    if (!$result_process) {
        echo json_encode(['error' => 'Error fetching process details']);
        exit;
    }

    $process_details = [];
    while ($row = mysqli_fetch_assoc($result_process)) {
        $row['first_name'] = $patient_details['first_name'];
        $row['middle_name'] = $patient_details['middle_name'];
        $row['last_name'] = $patient_details['last_name'];
        $row['patient_nic'] = $patient_details['patient_nic'];
        $process_details[] = $row;
    }

    echo json_encode($process_details);
} else {
    echo json_encode(['error' => 'Invalid patient ID']);
}

$conn->close();
?>
