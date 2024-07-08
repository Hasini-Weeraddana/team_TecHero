<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "doctor_registration";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$processId = 1; 
$diagId = 1;    

$sqlProcess = "SELECT * FROM process_details WHERE process_id = $processId";
$resultProcess = $conn->query($sqlProcess);

if ($resultProcess->num_rows > 0) {
    $rowProcess = $resultProcess->fetch_assoc();

    $sqlDiagnosis = "SELECT * FROM diagnosis WHERE diag_id = $diagId";
    $resultDiagnosis = $conn->query($sqlDiagnosis);

    if ($resultDiagnosis->num_rows > 0) {
        $rowDiagnosis = $resultDiagnosis->fetch_assoc();

        // Combine process details and diagnosis details
        $data = array(
            'image_path' => $rowProcess['image_path'],
            'diagnosis' => array(
                'cancer_type' => $rowDiagnosis['cancer_type'],
                'risk_text' => $rowDiagnosis['risk_text']
            )
        );

        header('Content-Type: application/json');
        echo json_encode($data);
    } else {
        echo "Diagnosis details not found";
    }
} else {
    echo "Process details not found";
}

$conn->close();
?>
