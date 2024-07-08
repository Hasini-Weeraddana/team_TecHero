<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: login.php");
    exit();
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Patient</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .home-icon {
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 25px;
            color: #ffff;
            cursor: pointer;
        }
        .home-icon:hover {
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
            background-color: #fff;
            padding: 50px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            box-sizing: border-box;
            text-align: center;
            margin: 20px auto;
            
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin: 10px 0 5px;
            color: #555;
            font-weight: bold;
        }
        input[type="text"], input[type="date"], textarea, select, input[type="file"] {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 15px;
            font-size: 16px;
            width: 100%;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background-color: #28a745;
            color: #fff;
            border: none;
            padding: 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        input[type="submit"]:hover {
            background-color: #218838;
        }
        .form-group {
            margin-bottom: 15px;
        }
        textarea {
            resize: vertical;
        }
        @media (max-width: 600px) {
            .container {
                padding: 15px;
            }
            input[type="submit"] {
                padding: 12px;
                font-size: 14px;
            }
        }
    </style>
    <script>
        function fetchPatientDetails() {
            var nic = document.getElementById('patient_nic').value;
            if (nic.length > 0) {
                var xhr = new XMLHttpRequest();
                xhr.open('GET', 'fetch_patient.php?patient_nic=' + nic, true);
                xhr.onload = function () {
                    if (xhr.status === 200) {
                        var patient = JSON.parse(xhr.responseText);
                        if (patient) {
                            document.getElementById('first_name').value = patient.first_name;
                            document.getElementById('middle_name').value = patient.middle_name;
                            document.getElementById('last_name').value = patient.last_name;
                            document.getElementById('address').value = patient.address;
                            document.getElementById('gender').value = patient.gender;
                            document.getElementById('date_of_birth').value = patient.date_of_birth;
                            document.getElementById('past_medical_information').value = patient.past_medical_information;
                            document.getElementById('mediRegNum').value = patient.mediRegNum;
                        } else {
                            
                            document.getElementById('first_name').value = '';
                            document.getElementById('middle_name').value = '';
                            document.getElementById('last_name').value = '';
                            document.getElementById('address').value = '';
                            document.getElementById('gender').value = '';
                            document.getElementById('date_of_birth').value = '';
                            document.getElementById('past_medical_information').value = '';
                            document.getElementById('mediRegNum').value = '';
                        }
                    }
                };
                xhr.send();
            }
        }
    </script>
</head>
<body>
    
    <div class="container">
        <a href="admin_panel.php" class="home-icon"><i class="fas fa-home"></i></a>
        <h2>Add Patient Information</h2>
        <form action="process_form.php" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="patient_nic">Patient NIC:</label>
                <input type="text" id="patient_nic" name="patient_nic" onkeyup="fetchPatientDetails()" required>
            </div>
            <div class="form-group">
                <label for="first_name">First Name:</label>
                <input type="text" id="first_name" name="first_name" required>
            </div>
            <div class="form-group">
                <label for="middle_name">Middle Name:</label>
                <input type="text" id="middle_name" name="middle_name">
            </div>
            <div class="form-group">
                <label for="last_name">Last Name:</label>
                <input type="text" id="last_name" name="last_name" required>
            </div>
            <div class="form-group">
                <label for="address">Address:</label>
                <textarea id="address" name="address" required></textarea>
            </div>
            <div class="form-group">
                <label for="gender">Gender:</label>
                <select id="gender" name="gender" required>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <div class="form-group">
                <label for="date_of_birth">Date of Birth:</label>
                <input type="date" id="date_of_birth" name="date_of_birth" required>
            </div>
            <div class="form-group">
                <label for="past_medical_information">Past Medical Information:</label>
                <textarea id="past_medical_information" name="past_medical_information"></textarea>
            </div>
            <div class="form-group">
                <label for="mediRegNum">Medical Registration Number:</label>
                <select id="mediRegNum" name="mediRegNum" required>
                <?php
                   
                    $servername = "localhost";
                    $username = "root";
                    $password = "";
                    $dbname = "doctor_registration";

                    $conn = new mysqli($servername, $username, $password, $dbname);

                    
                    if ($conn->connect_error) {
                        die("Connection failed: " . $conn->connect_error);
                    }

                   
                    $sql = "SELECT mediRegNum, fullName FROM doctors WHERE is_active = 1";
                    $result = $conn->query($sql);

                    if ($result->num_rows > 0) {
                        while ($row = $result->fetch_assoc()) {
                            echo "<option value='" . $row["mediRegNum"] . "'>" . $row["fullName"] . " - " . $row["mediRegNum"] . "</option>";
                        }
                    } else {
                        echo "<option>No active doctors found</option>";
                    }

                    $conn->close();
                    ?>

                </select>
            </div>
            <div class="form-group">
                <label for="lesion_image">Lesion Image:</label>
                <input type="file" id="lesion_image" name="lesion_image" accept="image/*" required>
            </div>
            <input type="submit" value="Submit">
        </form>
    </div>
</body>
</html>
