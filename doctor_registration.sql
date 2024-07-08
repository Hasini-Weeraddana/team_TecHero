-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 08, 2024 at 06:15 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `doctor_registration`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `email`, `password`) VALUES
(11, 'sa', 'hdsachini16@gmail.com', '$2y$10$vr.UrWWGOLcXKoVxnMrcSuogyWRMVJO5Y2Yle0BhOjqSR6l7drLbW'),
(12, 'admin01', 'hasiniweeraddana@gmail.com', '$2y$10$xWkfEXQPf2uATGYRH5BcW.zdDIwh1YFEHLZxefv/znC7GMYVfOp7K');

-- --------------------------------------------------------

--
-- Table structure for table `diagnosis`
--

CREATE TABLE `diagnosis` (
  `diag_id` int(11) NOT NULL,
  `cancer_type` varchar(100) NOT NULL,
  `risk_text` text NOT NULL,
  `patient_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `diagnosis`
--

INSERT INTO `diagnosis` (`diag_id`, `cancer_type`, `risk_text`, `patient_id`) VALUES
(1, 'Malignant Melanoma', 'Based on the results from our AI analysis, it appears that this is a Malignant tumor.', 14),
(2, 'Benign ', 'Based on the results from our AI analysis, it appears that this is a Malignant tumor.', 15),
(3, 'melidnent  ', 'Based on the results from our AI analysis, it appears that this is a Malignant tumor.', 16),
(4, 'Malignant Melanoma', 'Based on the results from our AI analysis, it appears that this is a Malignant tumor.', 19);

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `id` int(11) NOT NULL,
  `fullName` varchar(255) DEFAULT NULL,
  `mediRegNum` varchar(255) DEFAULT NULL,
  `birthOfDate` date DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `workPlace` varchar(255) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `activation_code` varchar(32) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 0,
  `otp` varchar(6) DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL,
  `profilePicture` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`id`, `fullName`, `mediRegNum`, `birthOfDate`, `gender`, `workPlace`, `phone`, `password`, `email`, `activation_code`, `is_active`, `otp`, `otp_expiry`, `profilePicture`) VALUES
(66, 'doctor 01', 'med01', '2024-07-02', 'Male', 'colombo', '0700000000', '$2y$10$r7HU.mEUQbJEb4aad9RRmOo3Vm6qd6zTvi4SXMX7lsb2OV1AvE3B6', 'doctor01@gmail.com', '73faf1b48c16afc0600ea3708bc7374c', 1, NULL, NULL, '30.jpg'),
(67, 'doctor 02', 'med02', '2024-07-03', 'Male', 'colombo', '0701111111', '$2y$10$JoPIORHgC1nauRoNdmiyD.MY1AzIi.oJJC9.QYZ5s.ONmM2m005si', 'doctor02@gmail.com', '45685ea3ebf6a081fbcddefce588af52', 0, NULL, NULL, NULL),
(68, 'Doctor 03', 'med03', '2024-07-03', 'Male', 'kegalle', '0770000000', '$2y$10$Bk8rm9f4DlKKxKpU4q1YI.o0ezJi30qcWVWzJoPpf36UuHTSV649y', 'eampsuri@gmail.com', 'b7131b0ed6fda90a79f0bca02802df96', 1, NULL, NULL, 'IMG_20240624_204705.jpg'),
(70, 'Sachini Fernando ', '12345', '1998-07-07', 'Female', 'galle', '0775255694', '$2y$10$P2.iSqmP7eivWU5jNAXh5.91eOINSAFL1.XQRnUpKDvnptnXdZhOW', 'hdsachini16@gmail.com', 'e92d08fbada47e2dc421a95f1d0e0827', 1, NULL, NULL, 'IMG-20240705-WA0047.jpg'),
(72, 'Manel Dissanayake', 'med04', '1988-07-13', 'Female', 'Colombo, Sri Lanka', '0777712345', '$2y$10$LyErH.c0SATp62QruShoWOMdd73n5EuLvtsNn3bT2MkuPthZczsqy', 'hasiniweeraddana@gmail.com', '12bab211fd0a90a002a162fcf3b1fc27', 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `patient_id` int(11) NOT NULL,
  `patient_nic` varchar(10) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) NOT NULL,
  `address` text NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `date_of_birth` date NOT NULL,
  `past_medical_information` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `mediRegNum` varchar(255) DEFAULT NULL,
  `is_check` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`patient_id`, `patient_nic`, `first_name`, `middle_name`, `last_name`, `address`, `gender`, `date_of_birth`, `past_medical_information`, `created_at`, `updated_at`, `mediRegNum`, `is_check`) VALUES
(14, '123456789V', 'John', 'Smith', 'Johnson', '12/A/kegalle', 'Male', '2024-07-18', 'non', '2024-07-03 07:39:48', '2024-07-07 01:10:19', 'med03', 1),
(15, '010032299V', 'John', 'Smith', 'Johnson', 'A/201/mawanella ', 'Male', '2024-07-01', 'Family Members Diagnosed with Melanoma,\r\nFrequency of Sunburns (especially blistering sunburns)\r\n', '2024-07-04 11:56:29', '2024-07-06 23:00:38', 'med03', 1),
(16, '987654321V', 'Smith', 'Edward', 'Wilson', '321 Pine St, Anycity, SriLanka', 'Male', '1997-08-08', 'Multiple atypical moles', '2024-07-06 23:47:28', '2024-07-07 01:46:54', 'med03', 1),
(19, '100020003V', 'Amal', 'Nishantha', 'Perera', 'Colombo, Sri Lanka', 'Male', '1985-09-16', 'The first tumour originated on June 12, 2024.', '2024-07-08 12:11:30', '2024-07-08 12:11:30', 'med04', 0);

-- --------------------------------------------------------

--
-- Table structure for table `patient_lesion_images`
--

CREATE TABLE `patient_lesion_images` (
  `img_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `patient_id` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patient_lesion_images`
--

INSERT INTO `patient_lesion_images` (`img_id`, `image_path`, `uploaded_at`, `patient_id`) VALUES
(33, 'patients/992230010V/Appointment no 33 (2024-07-03)/30.jpg', '2024-07-03 03:20:15', '12'),
(34, 'patients/963852741V/Appointment no 34 (2024-07-03)/30.jpg', '2024-07-03 04:26:17', '13'),
(35, 'patients/963852741V/Appointment no 35 (2024-07-03)/30.jpg', '2024-07-03 04:28:00', '13'),
(36, 'patients/963852741V/Appointment no 36 (2024-07-03)/30.jpg', '2024-07-03 05:19:41', '13'),
(37, 'patients/963852741V/Appointment no 37 (2024-07-03)/30.jpg', '2024-07-03 05:46:37', '13'),
(38, 'patients/963852741V/Appointment no 38 (2024-07-03)/30.jpg', '2024-07-03 07:31:13', '13'),
(39, 'patients/123456789V/Appointment no 39 (2024-07-03)/30.jpg', '2024-07-03 07:39:49', '14'),
(40, 'patients/123456789V/Appointment no 40 (2024-07-03)/30.jpg', '2024-07-03 07:41:22', '14'),
(41, 'patients/123456789V/Appointment no 41 (2024-07-04)/30.jpg', '2024-07-04 02:27:10', '14'),
(42, 'patients/010032299V/Appointment no 42 (2024-07-04)/30.jpg', '2024-07-04 11:56:30', '15'),
(43, 'patients/010032299V/Appointment no 43 (2024-07-04)/31.jpg', '2024-07-04 13:11:25', '15'),
(44, 'patients/123456789V/Appointment no 44 (2024-07-04)/31.jpg', '2024-07-04 13:22:16', '14'),
(45, 'patients/123456789V/Appointment no 45 (2024-07-04)/', '2024-07-04 13:28:13', '14'),
(46, 'patients/123456789V/Appointment no 46 (2024-07-06)/32.jpg', '2024-07-06 14:03:11', '14'),
(47, 'patients/141414111411/Appointment no 47 (2024-07-06)/32.jpg', '2024-07-06 14:04:13', '16'),
(48, 'patients/123456789V/Appointment no 48 (2024-07-06)/1.jpg', '2024-07-06 21:41:37', '14'),
(49, 'patients/123456789V/Appointment no 49 (2024-07-06)/2.jpg', '2024-07-06 21:46:19', '14'),
(50, 'patients/123456789V/Appointment no 50 (2024-07-07)/2.jpg', '2024-07-06 23:02:34', '14'),
(51, 'patients/987654321V/Appointment no 51 (2024-07-07)/IMG_20240421_181925 (2).jpg', '2024-07-06 23:47:30', '16'),
(55, 'patients/123456789V/Appointment no 55 (2024-07-07)/1.jpg', '2024-07-07 01:08:56', '14'),
(56, 'patients/987654321V/Appointment no 56 (2024-07-07)/1.jpg', '2024-07-07 01:41:20', '16'),
(57, 'patients/987654321V/Appointment no 57 (2024-07-07)/2.jpg', '2024-07-07 01:45:48', '16'),
(58, 'patients/100020003V/Appointment no 58 (2024-07-08)/uimg1.jpg', '2024-07-08 12:11:30', '19');

-- --------------------------------------------------------

--
-- Table structure for table `prescription`
--

CREATE TABLE `prescription` (
  `pres_id` int(11) NOT NULL,
  `additional_comments` varchar(100) DEFAULT NULL,
  `patient_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prescription`
--

INSERT INTO `prescription` (`pres_id`, `additional_comments`, `patient_id`) VALUES
(104, 'no comments', 14),
(105, 'no', 14),
(106, 'no', 14),
(107, 'no', 15),
(108, 'no', 15),
(109, 'no', 15),
(110, 'no', 14),
(111, 'no', 14),
(114, 'no', 14),
(115, 'no comments', 16),
(116, 'not at all', 16),
(117, 'Avoid sun exposure and use sunscreen with high SPF.', 19);

-- --------------------------------------------------------

--
-- Table structure for table `process_details`
--

CREATE TABLE `process_details` (
  `process_id` int(11) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `enhanced_image_path` varchar(255) NOT NULL,
  `segmented_image_path` varchar(255) NOT NULL,
  `asymmetry` text DEFAULT NULL,
  `border` text DEFAULT NULL,
  `colour` text DEFAULT NULL,
  `diameter` text DEFAULT NULL,
  `patient_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `process_details`
--

INSERT INTO `process_details` (`process_id`, `image_path`, `enhanced_image_path`, `segmented_image_path`, `asymmetry`, `border`, `colour`, `diameter`, `patient_id`) VALUES
(1, 'patients/123456789V/Appointment no 4 (2024-07-02)/uimg1.jpg', 'patients/123456789V/Appointment no 4 (2024-07-02)/eimg1.jpg', 'patients/123456789V/Appointment no 4 (2024-07-02)/simg1.jpg', 'Asymmetric', 'irregular border', 'brown reddish, brown, maroon, orange brown', 'Approximately 7.99mm', 14),
(2, 'patients/010032299V/Appointment no 42 (2024-07-04)/30.jpg', 'patients/010032299V/Appointment no 42 (2024-07-04)/eimg2.jpg', 'patients/010032299V/Appointment no 42 (2024-07-04)/simg2.jpg', 'Asymmetric', 'irregular border', 'brown reddish, brown, maroon, orange brown', 'Approximately 7.79mm', 15),
(3, 'patients/987654321V/Appointment no 49 (2024-07-07)/1.png', 'patients/987654321V/Appointment no 49 (2024-07-07)/2.png', 'patients/987654321V/Appointment no 49 (2024-07-07)/3.jpg', 'Asymmetric', 'irregular border', 'brown reddish, brown, maroon, orange brown', 'Approximately 8.79mm', 16),
(4, 'patients/100020003V/Appointment no 58 (2024-07-08)/uimg1.jpg', 'patients/100020003V/Appointment no 58 (2024-07-08)/eimg1.jpg', 'patients/100020003V/Appointment no 58 (2024-07-08)/simg1.jpg', 'Asymmetric', 'irregular border', 'brown reddish, brown, maroon, orange brown', 'Approximately 7.79mm', 19);

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `report_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `report_path` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`report_id`, `patient_id`, `report_path`, `created_at`, `updated_at`) VALUES
(28, 14, 'C:/xampp/htdocs/techero_app/pdf/report_14.pdf', '2024-07-06 21:42:36', '2024-07-06 21:42:36'),
(29, 14, 'C:/xampp/htdocs/techero_app/pdf/report_14.pdf', '2024-07-06 21:42:39', '2024-07-06 21:42:39'),
(30, 14, 'C:/xampp/htdocs/techero_app/pdf/report_14.pdf', '2024-07-07 01:10:23', '2024-07-07 01:10:23'),
(31, 16, 'C:/xampp/htdocs/techero_app/pdf/report_16.pdf', '2024-07-07 01:43:17', '2024-07-07 01:43:17'),
(32, 16, 'C:/xampp/htdocs/techero_app/pdf/report_16.pdf', '2024-07-07 01:46:58', '2024-07-07 01:46:58');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `diagnosis`
--
ALTER TABLE `diagnosis`
  ADD PRIMARY KEY (`diag_id`),
  ADD KEY `fk_patient` (`patient_id`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_email` (`email`),
  ADD UNIQUE KEY `mediRegNum` (`mediRegNum`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`patient_id`),
  ADD UNIQUE KEY `patient_nic` (`patient_nic`),
  ADD KEY `idx_mediRegNum` (`mediRegNum`);

--
-- Indexes for table `patient_lesion_images`
--
ALTER TABLE `patient_lesion_images`
  ADD PRIMARY KEY (`img_id`),
  ADD KEY `idx_patient_id` (`patient_id`);

--
-- Indexes for table `prescription`
--
ALTER TABLE `prescription`
  ADD PRIMARY KEY (`pres_id`),
  ADD KEY `prescription_ibfk_1` (`patient_id`);

--
-- Indexes for table `process_details`
--
ALTER TABLE `process_details`
  ADD PRIMARY KEY (`process_id`),
  ADD KEY `fk_process_details_patient_id` (`patient_id`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`report_id`),
  ADD KEY `patient_id` (`patient_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `diagnosis`
--
ALTER TABLE `diagnosis`
  MODIFY `diag_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `patient_lesion_images`
--
ALTER TABLE `patient_lesion_images`
  MODIFY `img_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `prescription`
--
ALTER TABLE `prescription`
  MODIFY `pres_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- AUTO_INCREMENT for table `process_details`
--
ALTER TABLE `process_details`
  MODIFY `process_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `report_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `diagnosis`
--
ALTER TABLE `diagnosis`
  ADD CONSTRAINT `fk_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`);

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`mediRegNum`) REFERENCES `doctors` (`mediRegNum`);

--
-- Constraints for table `prescription`
--
ALTER TABLE `prescription`
  ADD CONSTRAINT `prescription_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`);

--
-- Constraints for table `process_details`
--
ALTER TABLE `process_details`
  ADD CONSTRAINT `fk_process_details_patient_id` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reports`
--
ALTER TABLE `reports`
  ADD CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
