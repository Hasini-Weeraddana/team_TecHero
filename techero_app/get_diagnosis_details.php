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

  $sql = "SELECT * FROM diagnosis WHERE patient_id = $patient_id";
  $result = $conn->query($sql);

  if ($result->num_rows > 0) {
    $diagnosis = [];
    while ($row = $result->fetch_assoc()) {
      $diagnosis[] = [
        'diag_id' => $row['diag_id'],
        'cancer_type' => $row['cancer_type'],
        'risk_text' => $row['risk_text'],
        'patient_id' => $row['patient_id'],
      ];
    }

    header('Content-Type: application/json');
    echo json_encode($diagnosis);
  } else {
    echo json_encode(['error' => 'No diagnosis details found']);
  }

} else {

  echo json_encode(['error' => 'Missing patient_id parameter']);
}

$conn->close();
?>
