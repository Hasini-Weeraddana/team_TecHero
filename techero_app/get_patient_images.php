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

  $sql = "SELECT * FROM patient_lesion_images WHERE patient_id = $patient_id ORDER BY uploaded_at DESC";
  $result = $conn->query($sql);

  $images = [];
  if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
      $images[] = [
        'img_id' => $row['img_id'],
        'image_path' => $row['image_path'],
        'uploaded_at' => $row['uploaded_at'],
        'patient_id' => $row['patient_id']
      ];
    }
  }

  header('Content-Type: application/json');
  echo json_encode($images);

} else {
  echo json_encode(['error' => 'Missing patient_id parameter']);
}

$conn->close();
?>
