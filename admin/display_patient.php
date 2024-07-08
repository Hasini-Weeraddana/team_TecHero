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

    $stmt = $conn->prepare("SELECT * FROM patients WHERE patient_nic = ?");
    $stmt->bind_param("s", $patient_nic);

    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {

        $row = $result->fetch_assoc();
        echo "<div class='container'>";
        echo "<h2>Patient Details</h2>";
        echo "<p><strong>Patient NIC:</strong> " . htmlspecialchars($row["patient_nic"]) . "</p>";
        echo "<p><strong>First Name:</strong> " . htmlspecialchars($row["first_name"]) . "</p>";
        echo "<p><strong>Middle Name:</strong> " . htmlspecialchars($row["middle_name"]) . "</p>";
        echo "<p><strong>Last Name:</strong> " . htmlspecialchars($row["last_name"]) . "</p>";
        echo "<p><strong>Address:</strong> " . htmlspecialchars($row["address"]) . "</p>";
        echo "<p><strong>Gender:</strong> " . htmlspecialchars($row["gender"]) . "</p>";
        echo "<p><strong>Date of Birth:</strong> " . htmlspecialchars($row["date_of_birth"]) . "</p>";
        echo "<p><strong>Past Medical Information:</strong> " . htmlspecialchars($row["past_medical_information"]) . "</p>";

        $patient_folder = 'patients/' . htmlspecialchars($patient_nic);
        if (is_dir($patient_folder)) {
            echo "<h3>Appointments :</h3>";
            $appointment_folders = glob($patient_folder . '/Appointment no *');
            if ($appointment_folders) {
                echo "<ul class='folder-list'>";
                foreach ($appointment_folders as $folder) {
                    $folder_name = basename($folder);
                    echo "<li><a href='display_appointment.php?folder=" . urlencode($folder) . "'><i class='fas fa-folder'></i> " . htmlspecialchars($folder_name) . "</a></li>";
                }
                echo "</ul>";
            } else {
                echo "<p>No appointment folders found.</p>";
            }
        } else {
            echo "<p>No patient folder found.</p>";
        }
        echo "</div>";
    } else {
        echo "<div class='container'><p>No patient found with NIC: " . htmlspecialchars($patient_nic) . "</p></div>";
    }

    $stmt->close();
    $conn->close();
} else {
    echo "<div class='container'><p>No NIC provided.</p></div>";
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .icon {
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 25px;
            color: #fff;
            cursor: pointer;
        }
        .home-icon {
            top: 20px;
        }
        .search-icon {
            top: 70px;
        }
        .icon:hover {
            color: #0056b3;
        }
        body {
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)), url('panel.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            position: relative;
        }
        .container {
            width: 80%;
            max-width: 1000px;
            background: #fff;
            padding: 20px 40px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
            text-align: left;
            margin-top: 20px;
        }
        h2 {
            border-bottom: 2px solid #333;
            padding-bottom: 10px;
            margin-bottom: 20px;
            font-size: 24px;
        }
        p {
            margin: 10px 0;
            font-size: 16px;
            color: #333;
        }
        .folder-list {
            list-style-type: none;
            padding: 0;
            margin: 0;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .folder-list li {
            margin-bottom: 15px;
        }
        .folder-list li a {
            text-decoration: none;
            color: #333;
            background-color: #f4f4f4;
            padding: 10px 15px;
            display: inline-block;
            border-radius: 4px;
            transition: background-color 0.3s, color 0.3s;
        }
        .folder-list li a:hover {
            background-color: #ddd;
            color: #000;
        }
        .folder-list li a i {
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <a href="admin_panel.php" class="icon home-icon"><i class="fas fa-home"></i></a>
    <a href="search_patient.php" class="icon search-icon"><i class="fas fa-search"></i></a>
</body>
</html>
