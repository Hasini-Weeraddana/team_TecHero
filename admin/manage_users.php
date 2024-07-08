<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: login.php");
    exit();
}

$conn = new mysqli('localhost', 'root', '', 'doctor_registration');

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$search = '';
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['search'])) {
    $search = $_POST['search'];
    if (isset($_POST['clear'])) {
        $search = '';
    }
}

$sql = "SELECT * FROM doctors";
if (!empty($search)) {
    $sql .= " WHERE mediRegNum LIKE '%" . $conn->real_escape_string($search) . "%'";
}

$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
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
        .table-container {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 90%;
            max-width: 1000px;
            overflow-y: auto;
            max-height: 90vh;
        }
        .table-container h2 {
            margin-bottom: 20px;
            text-align: center;
        }
        .search-container {
            text-align: center;
            margin-bottom: 20px;
        }
        .search-container input[type="text"] {
            padding: 10px;
            width: 60%;
            max-width: 300px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-right: 10px;
        }
        .search-container input[type="submit"], .search-container input[type="button"] {
            padding: 10px 20px;
            border: none;
            background-color: #007bff;
            color: #fff;
            border-radius: 5px;
            cursor: pointer;
        }
        .search-container input[type="submit"]:hover, .search-container input[type="button"]:hover {
            background-color: #0056b3;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid #ccc;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f8f8f8;
        }
        .profile-pic {
            width: 50px;
            height: 50px;
            border-radius: 50%;
        }
        .status-switch input[type="checkbox"] {
            display: none;
        }
        .status-switch label {
            cursor: pointer;
            text-indent: -9999px;
            width: 40px;
            height: 20px;
            background: #d6d6d6;
            display: block;
            border-radius: 100px;
            position: relative;
        }
        .status-switch label:after {
            content: '';
            position: absolute;
            top: 2px;
            left: 2px;
            width: 16px;
            height: 16px;
            background: #fff;
            border-radius: 90px;
            transition: 0.3s;
        }
        .status-switch input:checked + label {
            background: #4cd137;
        }
        .status-switch input:checked + label:after {
            left: calc(100% - 2px);
            transform: translateX(-100%);
        }
        .status-switch label:active:after {
            width: 28px;
        }
        .no-users {
            text-align: center;
            font-size: 18px;
            color: red;
            font-weight: bold;
        }
        .remove-button {
            background-color: red;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }
        .remove-button:hover {
            background-color: darkred;
        }
    </style>
    <script>
        
        window.addEventListener('popstate', function(event) {
            document.getElementById('searchForm').reset(); 
        });

        
        function submitSearchForm() {
            document.getElementById('searchForm').submit();
        }

        function clearSearch() {
            document.getElementById('searchField').value = '';
            document.getElementById('searchForm').submit();
        }

    function toggleStatus(mediRegNum, currentStatus) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "toggle_status.php", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    var response = JSON.parse(xhr.responseText);
                    if(response.success) {
                        alert("Status updated successfully");
                        
                        location.reload();
                    } else {
                        alert("Failed to update status: " + response.error);
                    }
                }
            };
            xhr.send("mediRegNum=" + mediRegNum + "&status=" + (currentStatus ? 0 : 1));
        }
    </script>
</head>
<body>
    <a href="admin_panel.php" class="home-icon"><i class="fas fa-home"></i></a>
    <div class="table-container">
        <h2>Manage Users</h2>
        <div class="search-container">
            <form id="searchForm" method="post" action="">
                <input id="searchField" type="text" name="search" placeholder="Enter Medical Reg. No" value="<?php echo htmlspecialchars($search); ?>">
                <input type="button" value="Search" onclick="submitSearchForm();">
                <?php if (!empty($search)): ?>
                <input type="button" value="Clear" onclick="clearSearch();">
                <?php endif; ?>
            </form>
        </div>
        <table>
            <tr>
                <th>Name</th>
                <th>Medical Reg. No</th>
                <th>Gender</th>
                <th>Work Place</th>
                <th>Phone No</th>
                <th>Email</th>
                <th>Profile Picture</th>
                <th>Status</th>
                
            </tr>
            <?php
            if ($result->num_rows > 0) {
                while($row = $result->fetch_assoc()) {
                    echo "<tr id='row_" . htmlspecialchars($row['mediRegNum']) . "'>
                        <td>" . htmlspecialchars($row['fullName']) . "</td>
                        <td>" . htmlspecialchars($row['mediRegNum']) . "</td>
                        <td>" . htmlspecialchars($row['gender']) . "</td>
                        <td>" . htmlspecialchars($row['workPlace']) . "</td>
                        <td>" . htmlspecialchars($row['phone']) . "</td>
                        <td>" . htmlspecialchars($row['email']) . "</td>
                        <td>";
                    
                    $profilePicPath = $row['profilePicture'];
                    $baseURL = 'http://localhost/techero_app/uploads/';
                    
                    if (!empty($profilePicPath) && filter_var($baseURL . $profilePicPath, FILTER_VALIDATE_URL)) {
                        echo "<img src='$baseURL$profilePicPath' class='profile-pic'>";
                    } else {
                        echo "<img src='$baseURL" . 'person.png' . "' class='profile-pic'>";
                    }
                    
                    echo "</td>
                        <td>
                            <div class='status-switch'>
                                <input type='checkbox' id='switch" . htmlspecialchars($row['mediRegNum']) . "' " . ($row['is_active'] ? "checked" : "") . " onchange='toggleStatus(\"" . htmlspecialchars($row['mediRegNum']) . "\", " . $row['is_active'] . ")'>
                                <label for='switch" . htmlspecialchars($row['mediRegNum']) . "'></label>
                            </div>
                        </td>
                        
                        </tr>";
                    }
                } else {
                    echo "<tr><td colspan='8' class='no-users'>No users found</td></tr>";
                }
                ?>
            </table>
        </div>
    </body>
    </html>
    
    <?php
    $conn->close();
    ?>
