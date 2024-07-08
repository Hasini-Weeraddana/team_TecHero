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

  $sql = "SELECT * FROM patients WHERE patient_id = $patient_id";
  $result = $conn->query($sql);

  if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $patient = [
      'patient_id' => $row['patient_id'],
      'first_name' => $row['first_name'],
      'middle_name' => $row['middle_name'],
      'last_name' => $row['last_name'],
      'address' => $row['address'],
      'gender' => $row['gender'],
      'date_of_birth' => $row['date_of_birth'],
      'past_medical_information' => $row['past_medical_information'],
      'created_at' => $row['created_at'],
      'updated_at' => $row['updated_at'],
      'mediRegNum' => $row['mediRegNum'],
      'patient_nic' => $row['patient_nic']
    ];

    $images = [];
    $sql_images = "SELECT * FROM patient_lesion_images WHERE patient_id = $patient_id";
    $result_images = $conn->query($sql_images);
    if ($result_images->num_rows > 0) {
      while ($row_image = $result_images->fetch_assoc()) {
        $images[] = [
          'img_id' => $row_image['img_id'],
          'image_path' => $row_image['image_path'],
          'uploaded_at' => $row_image['uploaded_at'],
          'patient_id' => $row_image['patient_id']
        ];
      }
    }

    $patient['images'] = $images;

    header('Content-Type: application/json');
    echo json_encode($patient);
  } else {
    echo json_encode(['error' => 'Patient not found']);
  }

} else {
  echo json_encode(['error' => 'Missing patient_id parameter']);
}

$conn->close();
?>