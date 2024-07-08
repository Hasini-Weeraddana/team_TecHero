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
    <title>Admin Panel - Med App</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@700&display=swap" rel="stylesheet">
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
        .header-bar {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            background-color: rgba(7, 0, 145, 0.8);
            color: white;
            padding: 10px 20px;
            text-align: center;
            font-size: 32px;
            font-weight: bold;
            font-family: 'Roboto Slab', serif;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-sizing: border-box;
        }
        .logo-badge {
            width: 50px;
            height: 50px;
            background: url('logo.jpg') no-repeat center center;
            background-size: cover;
            border-radius: 50%;
            border: 2px solid white;
        }
        .contact-info {
            font-size: 12px;
            line-height: 1.2;
            margin-top: 5px;
        }
        .panel-container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
            transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
            margin-top: 80px;
            position: relative;
        }
        .panel-container:hover {
            transform: scale(1.05);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.3);
        }
        .panel-container h2 {
            margin-bottom: 20px;
            font-size: 24px;
            color: #333;
            font-weight: bold;
        }
        .panel-container .icon-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #070091;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 5px;
            cursor: pointer;
            width: calc(100% - 20px);
            margin: 10px 1px;
            font-size: 16px;
            transition: background-color 0.3s;
            text-decoration: none;
            text-align: center;
        }
        .panel-container .icon-btn:hover {
            background-color: #1abc9c; 
        }
        .panel-container .icon-btn i {
            margin-right: 10px;
        }
        .panel-container .logout-container {
            margin-top: 20px;
        }
        .panel-container .logout {
            background-color: transparent;
            color: #e74c3c;
            border: none;
            cursor: pointer;
            font-size: 16px;
            text-decoration: underline;
            transition: color 0.3s;
        }
        .panel-container .logout:hover {
            color: #c0392b;
        }
        .panel-container a {
            text-decoration: none;
            color: white;
        }
        .footer {
            position: fixed;
            bottom: 0;
            width: 100%;
            background-color: rgba(7, 0, 145, 0.8);
            color: white;
            text-align: center;
            padding: 15px 0;
            font-size: 14px;
            font-family: 'Roboto Slab', serif;
            box-shadow: 0 -4px 6px rgba(0, 0, 0, 0.1);
        }
        .footer a {
            color: white;
            text-decoration: none;
            transition: opacity 0.3s;
        }
        .footer a:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="header-bar">
        <div class="logo-badge"></div>
        <div class="header-title">
               MelanoCare - Admin control Panel
        </div>
        <div class="contact-info">
            0776124660<br>
            techero352@gmail.com
        </div>
    </div>
    <div class="panel-container">
        <h2>Welcome, <?php echo htmlspecialchars($_SESSION['admin']); ?></h2>
        <a href="add_patient.php" class="icon-btn">
            <i class="fas fa-user-plus"></i> Add Patient
        </a>
        <a href="manage_users.php" class="icon-btn">
            <i class="fas fa-users-cog"></i> Manage Users
        </a>
        <a href="search_patient.php" class="icon-btn">
            <i class="fas fa-search"></i> View Patients
        </a>
        <div class="logout-container">
            <form method="post" action="logout.php">
                <input type="submit" value="Logout" class="logout">
            </form>
        </div>
    </div>
    <div class="footer">
        &copy; <?php echo date("Y"); ?> Med App by TecHero Group
    </div>
</body>
</html>

