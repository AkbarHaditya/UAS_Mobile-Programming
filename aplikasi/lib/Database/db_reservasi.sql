-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 29, 2024 at 08:17 AM
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
-- Database: `db_reservasi`
--

-- --------------------------------------------------------

--
-- Table structure for table `booking_hotel`
--

CREATE TABLE `booking_hotel` (
  `Kode_Kamar` int(20) NOT NULL,
  `Kamar` varchar(20) NOT NULL,
  `Jumlah` varchar(20) NOT NULL,
  `Checkin` varchar(20) NOT NULL,
  `Checkout` varchar(20) NOT NULL,
  `Dewasa` int(20) NOT NULL,
  `Anak_Anak` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking_hotel`
--

INSERT INTO `booking_hotel` (`Kode_Kamar`, `Kamar`, `Jumlah`, `Checkin`, `Checkout`, `Dewasa`, `Anak_Anak`) VALUES
(1, 'Standard', '1', '29-6-2024', '30-6-2024', 2, 3);

-- --------------------------------------------------------

--
-- Table structure for table `data_pelanggan`
--

CREATE TABLE `data_pelanggan` (
  `Kode_Pelanggan` int(20) NOT NULL,
  `Nama_Pelanggan` varchar(20) NOT NULL,
  `Email` varchar(20) NOT NULL,
  `Telp` int(20) NOT NULL,
  `Negara` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `data_pelanggan`
--

INSERT INTO `data_pelanggan` (`Kode_Pelanggan`, `Nama_Pelanggan`, `Email`, `Telp`, `Negara`) VALUES
(1, 'Akbar', 'hadityaakbar@gmail.c', 2147483647, 'Indonesia');

-- --------------------------------------------------------

--
-- Table structure for table `data_user`
--

CREATE TABLE `data_user` (
  `Email` varchar(20) NOT NULL,
  `Password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `form_transaksi`
--

CREATE TABLE `form_transaksi` (
  `Kode_Transaksi` int(20) NOT NULL,
  `Hotel` varchar(15) NOT NULL,
  `Metode` varchar(20) NOT NULL,
  `Harga` varchar(20) NOT NULL,
  `Checkin` varchar(10) NOT NULL,
  `Checkout` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `form_transaksi`
--

INSERT INTO `form_transaksi` (`Kode_Transaksi`, `Hotel`, `Metode`, `Harga`, `Checkin`, `Checkout`) VALUES
(1, 'Hotel A', 'Gopay', '500000', '29-6-2024', '30-6-2024');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booking_hotel`
--
ALTER TABLE `booking_hotel`
  ADD PRIMARY KEY (`Kode_Kamar`);

--
-- Indexes for table `data_pelanggan`
--
ALTER TABLE `data_pelanggan`
  ADD PRIMARY KEY (`Kode_Pelanggan`);

--
-- Indexes for table `form_transaksi`
--
ALTER TABLE `form_transaksi`
  ADD PRIMARY KEY (`Kode_Transaksi`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `booking_hotel`
--
ALTER TABLE `booking_hotel`
  MODIFY `Kode_Kamar` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `data_pelanggan`
--
ALTER TABLE `data_pelanggan`
  MODIFY `Kode_Pelanggan` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `form_transaksi`
--
ALTER TABLE `form_transaksi`
  MODIFY `Kode_Transaksi` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
