<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: login.php");
    exit();
}

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

if (isset($_GET['patient_nic'])) {
    $patient_nic = $_GET['patient_nic'];

    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "doctor_registration";

    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    $sql = "SELECT first_name, middle_name, last_name, address, gender, date_of_birth, past_medical_information, mediRegNum FROM patients WHERE patient_nic = ?";
    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("s", $patient_nic);
        $stmt->execute();
        $stmt->bind_result($first_name, $middle_name, $last_name, $address, $gender, $date_of_birth, $past_medical_information, $mediRegNum);
        $stmt->fetch();

        $patient_details = array(
            "first_name" => $first_name,
            "middle_name" => $middle_name,
            "last_name" => $last_name,
            "address" => $address,
            "gender" => $gender,
            "date_of_birth" => $date_of_birth,
            "past_medical_information" => $past_medical_information,
            "mediRegNum" => $mediRegNum
        );

        echo json_encode($patient_details);

        $stmt->close();
    } else {
        echo json_encode(array("error" => "Error preparing statement: " . $conn->error));
    }


    $conn->close();
}
?>
