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
  $patientId = $_GET['patient_id'];

  // patient details
  $sqlPatient = "SELECT first_name, middle_name, last_name, address, gender 
                 FROM patients 
                 WHERE patient_id = $patientId";

  $resultPatient = $conn->query($sqlPatient);

  if ($resultPatient->num_rows > 0) {
    $patientDetails = $resultPatient->fetch_assoc();

    // process details
    $sqlProcess = "SELECT process_id, image_path, enhanced_image_path, segmented_image_path, asymmetry, border, colour, diameter
                   FROM process_details 
                   WHERE patient_id = $patientId";

    $resultProcess = $conn->query($sqlProcess);

    if ($resultProcess->num_rows > 0) {
      $processDetails = array();
      while ($row = $resultProcess->fetch_assoc()) {
        $processDetails[] = $row;
      }

      $combinedDetails = array(
        'patient' => $patientDetails,
        'process' => $processDetails
      );

      header('Content-Type: application/json');
      echo json_encode($combinedDetails);
    } else {
      echo "Process details not found";
    }
  } else {
    echo "Patient not found";
  }
} else {
  echo "Patient ID not provided";
}

$conn->close();
?>
