<?php
session_start();
if (!isset($_SESSION['admin'])) {
    header("Location: login.php");
    exit();
}
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

if (isset($_GET['folder'])) {
    $folder = urldecode($_GET['folder']);

    if (is_dir($folder) && strpos(realpath($folder), realpath('patients/')) === 0) {
        echo "<div class='container'>";
        echo "<h2>" . htmlspecialchars(basename($folder)) . "</h2>";
        
        $images = glob($folder . '/*.{jpg,jpeg,png,gif}', GLOB_BRACE);
        if ($images) {
            foreach ($images as $image) {
                echo "<img src='" . htmlspecialchars($image) . "' alt='Lesion Image' class='lesion-image'><br>";
            }
        } else {
            echo "<p>No images found in this folder.</p>";
        }
        echo "</div>";
    } else {
        echo "<div class='container'><p>Invalid folder specified.</p></div>";
    }
} else {
    echo "<div class='container'><p>No folder specified.</p></div>";
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointment Images</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .icon {
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 25px;
            color: black;
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
            background: white;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            position: relative;
        }
        h2 {
            border-bottom: 2px solid #333;
            padding-bottom: 10px;
        }
        .lesion-image {
            max-width: 512px;
            max-height: 512px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<a href="admin_panel.php" class="icon home-icon"><i class="fas fa-home"></i></a>
<a href="search_patient.php" class="icon search-icon"><i class="fas fa-search"></i></a>
</body>
</html>
