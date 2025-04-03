-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 05, 2024 at 04:22 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `logreg`
--

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `username`, `message`, `timestamp`) VALUES
(38, 'essa', 'hi i need help with temp of fool', '2024-01-13 21:32:05'),
(39, 'hhh', 'start low then increase to 130 degrees', '2024-01-13 21:32:46'),
(40, 'rara', 'haha', '2024-01-17 23:34:30');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `profile_picture`) VALUES
(14, 'medo', '$2y$10$f0SZyAEa79XxS8pZMiwo2uiHwa1PKP0Ptic1x/Mby5d3aCbhBcJR2', 'moh_yahfoufi@hotmail.com', NULL),
(15, 'aaa', '$2y$10$FMeuXDpXmLJ.vSTNaZVS3.DMEYaJA3FjY0G1VxOwqW3NpRRZbyJBG', 'gxuyxfcb@dfirstmail.com', NULL),
(16, 'hahahaha', '$2y$10$LRqj8h167T2sK/V/pgIOke7RwTcNwnZ3UvhyCtLoh.ds.1f.mV.1C', 'lolipop@umich.edu', NULL),
(17, 'silya', '$2y$10$fZZgHb9fxGsfFRKnQMExaOIABZEAg8Cb4tg4yjS.GEErhn.Btonly', 'yahfoufim91@gmail.com', NULL),
(19, 'aaa', '$2y$10$Ktpxidf01c8dJDeL733gsuOLWsi2qgF5R/VKLvEsdSEDoLH2480WG', 'dadada@gmail.com', NULL),
(21, 'eee', '$2y$10$RQ5CLsv0DihEG9247/cAHuSw602xwPPO2QhSku37Od8N3CDv8N6.K', 'gaga@gmail.com', NULL),
(22, 'medo', '$2y$10$ml0Sd0JNdBZX48VDOjPkHuYBrF/zXSLkQ7meyUvSL0BSu16YGvGf2', 'essamagim1324@gmail.com', NULL),
(23, 'hhh', '$2y$10$mYX/n8EERB8YAG74iOfJX.Bd/ZW64Z6GunGFcWQ6bZy79.rbLHkOu', 'hhhh@gmail.com', NULL),
(24, 'rara', '$2y$10$ap5Gw5dD666/scb7kspYA.VHqtxuB2RcMX4TgKVDuq37S5kZVk3bq', 'dsadsada@gmail.com', NULL),
(25, 'medo', '$2y$10$Wdp9cVbTf5U4A1K8UVnCAe07uIswrG2YQkDtfwJFV0VTBbe.cRKZq', 'essamagim1324@gmail.com', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
