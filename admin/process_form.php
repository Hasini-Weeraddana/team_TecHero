<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: login.php");
    exit();
}

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$message = "";
$redirect_url = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "doctor_registration";
    
    $conn = new mysqli($servername, $username, $password, $dbname);

    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    $patient_nic = $_POST['patient_nic'];
    $past_medical_information = $_POST['past_medical_information'];
    
    $sql = "SELECT patient_id FROM patients WHERE patient_nic = ?";
    if ($stmt = $conn->prepare($sql)) {
        $stmt->bind_param("s", $patient_nic);
        $stmt->execute();
        $stmt->store_result();
    } else {
        die("Error preparing statement: " . $conn->error);
    }

    if ($stmt->num_rows > 0) {
        
        $stmt->bind_result($patient_id);
        $stmt->fetch();
        
        $sql_update_patient = "UPDATE patients SET past_medical_information = ?, mediRegNum = ? WHERE patient_id = ?";
        if ($stmt_update = $conn->prepare($sql_update_patient)) {
            $stmt_update->bind_param("ssi", $past_medical_information, $_POST['mediRegNum'], $patient_id);
            if (!$stmt_update->execute()) {
                die("Error executing update statement: " . $stmt_update->error);
            }
            $stmt_update->close();
        } else {
            die("Error preparing update statement: " . $conn->error);
        }

        $message = "Patient information updated successfully.<br>";
        $redirect_url = "admin_panel.php";

        
        $sql_update_is_check = "UPDATE patients SET is_check = 0 WHERE patient_id = ?";
        $stmt_update_is_check = $conn->prepare($sql_update_is_check);
        $stmt_update_is_check->bind_param("i", $patient_id);
        if (!$stmt_update_is_check->execute()) {
            die("Error updating is_check: " . $stmt_update_is_check->error);
        }
        $stmt_update_is_check->close();
    } else {
       
        $sql_insert_patient = "INSERT INTO patients (patient_nic, first_name, middle_name, last_name, address, gender, date_of_birth, past_medical_information, mediRegNum) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        if ($stmt = $conn->prepare($sql_insert_patient)) {
            $stmt->bind_param("sssssssss", $patient_nic, $_POST['first_name'], $_POST['middle_name'], $_POST['last_name'], $_POST['address'], $_POST['gender'], $_POST['date_of_birth'], $past_medical_information, $_POST['mediRegNum']);
            if ($stmt->execute()) {
                $patient_id = $stmt->insert_id;
                $message = "New patient added successfully.<br>";
                $redirect_url = "admin_panel.php";

                
                $sql_update_is_check = "UPDATE patients SET is_check = 0 WHERE patient_id = ?";
                $stmt_update_is_check = $conn->prepare($sql_update_is_check);
                $stmt_update_is_check->bind_param("i", $patient_id);
                if (!$stmt_update_is_check->execute()) {
                    die("Error updating is_check: " . $stmt_update_is_check->error);
                }
                $stmt_update_is_check->close();
            } else {
                die("Error executing insert statement: " . $stmt->error);
            }
        } else {
            die("Error preparing insert statement: " . $conn->error);
        }
    }

    
    $patient_folder = 'patients/' . $patient_nic;
    if (!file_exists($patient_folder)) {
        mkdir($patient_folder, 0777, true);
    }

    
    $sql_insert_image = "INSERT INTO patient_lesion_images (patient_id, img_id, image_path) VALUES (?, ?, ?)";
    if ($stmt_img = $conn->prepare($sql_insert_image)) {
        
        $target_dir = 'patients/' . $patient_nic . '/';
        $target_file = $target_dir . basename($_FILES['lesion_image']['name']);
        $uploadOk = 1;
        $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

        
        $check = getimagesize($_FILES['lesion_image']['tmp_name']);
        if ($check !== false) {
            $uploadOk = 1;
        } else {
            $message = "File is not an image.<br>";
            $uploadOk = 0;
        }

        
        if ($_FILES['lesion_image']['size'] > 5000000) {
            $message = "Sorry, your file is too large.<br>";
            $uploadOk = 0;
        }

        
        if ($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "gif") {
            $message = "Sorry, only JPG, JPEG, PNG & GIF files are allowed.<br>";
            $uploadOk = 0;
        }

        
        if ($uploadOk == 0) {
            $message = "Sorry, your file was not uploaded.<br>";
        } else {
            
            if (move_uploaded_file($_FILES['lesion_image']['tmp_name'], $target_file)) {
                
                $image_path = $target_file;
                $img_id = null;
                $stmt_img->bind_param("iis", $patient_id, $img_id, $image_path);
                if ($stmt_img->execute()) {
                    $img_id = $stmt_img->insert_id;
 
                    $date = date("Y-m-d");
                    $appointment_folder = $target_dir . "Appointment no " . $img_id . " (" . $date . ")";
                    if (!file_exists($appointment_folder)) {
                        mkdir($appointment_folder, 0777, true);
                    }

                    $new_image_path = $appointment_folder . '/' . basename($_FILES['lesion_image']['name']);
                    rename($target_file, $new_image_path);

                    $sql_update_image_path = "UPDATE patient_lesion_images SET image_path = ? WHERE img_id = ?";
                    if ($stmt_update_image = $conn->prepare($sql_update_image_path)) {
                        $stmt_update_image->bind_param("si", $new_image_path, $img_id);
                        if ($stmt_update_image->execute()) {
                            $message .= " Image information successfully uploaded.<br> Appointment no: $img_id";
                        } else {
                            $message = "Error executing statement: " . $stmt_update_image->error;
                        }
                        $stmt_update_image->close();
                    } else {
                        die("Error preparing update statement: " . $conn->error);
                    }
                } else {
                    $message = "Error executing statement: " . $stmt_img->error;
                }
            } else {
                $message = "<br> Sorry, there was an error uploading your file.";
            }
        }
    } else {
        die("Error preparing statement: " . $conn->error);
    }

    
    $stmt->close();
    $stmt_img->close();
    $conn->close();
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Form Processing</title>
    <style>
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
        .message-box {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            padding: 20px;
            background-color: #f0f0f0;
            border: 1px solid #ccc;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
            z-index: 1000;
            display: none;
        }
        .message-box h2 {
            margin-top: 0;
        }
        .message-box button {
            margin-top: 10px;
            padding: 8px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        .message-box button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<?php if (!empty($message)): ?>
    <div class="message-box">
        <h2><?php echo $message; ?></h2>
        <button onclick="redirectTo('admin_panel.php')">Home</button>
        <button onclick="redirectTo('add_patient.php')">Add Patient</button>
    </div>
<?php endif; ?>

<script>
    function redirectTo(url) {
        window.location.href = url;
    }

    document.addEventListener("DOMContentLoaded", function() {
        var messageBox = document.querySelector(".message-box");
        if (messageBox) {
            messageBox.style.display = "block";
        }
    });
</script>

</body>
</html>