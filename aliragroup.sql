-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 11, 2026 at 06:43 AM
-- Server version: 10.11.10-MariaDB-log
-- PHP Version: 8.3.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aliragroup`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('alira-malaka-cache-admin@aliragroup.com|172.69.165.79', 'i:1;', 1773042884),
('alira-malaka-cache-admin@aliragroup.com|172.69.165.79:timer', 'i:1773042884;', 1773042884);

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `image`, `created_at`, `updated_at`) VALUES
(13, 'Minuman', 'minuman', 'https://images.unsplash.com/photo-1544145945-f904253db0ad', '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(14, 'Makanan', 'makanan', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(15, 'Cemilan', 'cemilan', 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', '2026-03-09 07:24:31', '2026-03-09 07:24:31');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

CREATE TABLE `menus` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(15,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`id`, `category_id`, `name`, `description`, `price`, `stock`, `image`, `is_available`, `created_at`, `updated_at`) VALUES
(245, 13, 'Kopi Susu Gula Aren', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(246, 13, 'Good Day Panas', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-10 10:53:00'),
(247, 13, 'Good Day Chococino', NULL, 8000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(248, 13, 'Good Day Vanila Latte', NULL, 8000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(249, 13, 'Kapal Api', NULL, 8000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-10 10:53:58'),
(250, 13, 'Cappucino panas', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-10 10:54:10'),
(251, 13, 'Creamy Latte panas', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-10 10:54:29'),
(252, 13, 'Dancow panas', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-10 10:55:13'),
(253, 13, 'Dancow Vanila', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(254, 13, 'Milo PANAS', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-10 10:55:51'),
(255, 13, 'Energen', NULL, 8000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(256, 13, 'Teh Tarik', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(257, 13, 'Kopi Luwak PANAS', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-10 10:57:53'),
(258, 13, 'Indocafe PANAS', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-10 10:58:50'),
(259, 13, 'Abc Susu', NULL, 7000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(260, 13, 'Jus Nanas', NULL, 12000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:31', '2026-03-09 07:24:31'),
(261, 13, 'Jus Buah Naga', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(262, 13, 'Jus Alpukat', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(263, 13, 'Es Jeruk', NULL, 12000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(264, 13, 'Sop Buah Creamy', NULL, 17000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(265, 13, 'Es Teler Creamy', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(266, 13, 'Milkshake Coklat', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(267, 13, 'Milkshake Strawberry', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(268, 13, 'Milkshake Matcha', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(269, 13, 'Milkshake Vanilla', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1544145945-f904253db0ad', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(270, 14, 'Ayam Bakar Pejantan Kumplit', 'Nasi, Protein, Tahu, Tempe, Lalapan, Sambal', 29000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(271, 14, 'Ayam Goreng Kumplit', 'Nasi, Protein, Tahu, Tempe, Lalapan, Sambal', 25000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(273, 14, 'Peda Berem Kumplit', 'Nasi, Protein, Tahu, Tempe, Lalapan, Sambal', 17000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(274, 14, 'Ikan Bakar Kumplit', 'Nasi, Protein, Tahu, Tempe, Lalapan, Sambal', 28000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(275, 14, 'Sop Iga', NULL, 35000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-10 10:49:26'),
(276, 14, 'Karedok Leunca', NULL, 12000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(277, 14, 'Karedok', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-10 10:49:44'),
(278, 14, 'Tumis Genjer', NULL, 12000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(279, 14, 'Ceker Mercon', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(280, 14, 'Usus Goreng', NULL, 10000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-10 10:49:57'),
(281, 14, 'Nasi Merah Ayam Goreng', NULL, 25000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(283, 14, 'Paket Ramadhan', 'Es lemon tea, ayam goreng, tahu tempe, free takjil, pilihan nasi, pilihan sambal', 25000.00, 10000, 'https://images.unsplash.com/photo-1504674900247-0877df9cc836', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(284, 15, 'Tempe Mendoan', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 08:35:52'),
(285, 15, 'Bala-bala', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 08:35:41'),
(286, 15, 'Cireng', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-10 10:50:31'),
(287, 15, 'Cireng Isi', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(288, 15, 'Pisang Keju', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(289, 15, 'Baso Aci Kumplit', 'Baso aci, tahu, cuankie, pilus cikur, bumbu lengkap', 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(290, 15, 'Potato Cheese', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(291, 15, 'Beef Burger', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(292, 15, 'Tomyam', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(293, 15, 'Omlet Enoki', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(294, 15, 'Colenak', NULL, 20000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(295, 15, 'Kentang Sosis', NULL, 20000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(296, 15, 'Seblak', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:32', '2026-03-09 07:24:32'),
(297, 15, 'Basreng', NULL, 12000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(298, 15, 'Roti Bakar', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(299, 15, 'Nugget', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(300, 15, 'Risol Matcha', NULL, 17000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(301, 15, 'Risol Coklat', NULL, 17000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(302, 15, 'Risol Ubi Ungu', NULL, 17000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(303, 15, 'Risol Ayam', NULL, 17000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(304, 15, 'Risol Mayo', NULL, 17000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(305, 15, 'Donat', NULL, 15000.00, 10000, 'https://images.unsplash.com/photo-1599481238640-4c1288750d7a', 1, '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(306, 14, 'NASI TIMBEL', NULL, 7000.00, 50, '/images/menus/default.jpg', 1, '2026-03-09 10:45:35', '2026-03-09 10:45:35'),
(307, 14, 'Nasi Putih', NULL, 6000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-09 10:46:17', '2026-03-09 10:46:42'),
(308, 14, 'Nasi Merah', NULL, 7000.00, 0, '/images/menus/default.jpg', 1, '2026-03-09 10:47:14', '2026-03-09 10:47:14'),
(309, 14, 'Nasi Cikur', NULL, 8000.00, 0, '/images/menus/default.jpg', 1, '2026-03-09 10:47:28', '2026-03-09 10:47:28'),
(310, 14, 'JENGKOL GORENG', NULL, 15000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-10 10:40:13', '2026-03-10 10:40:13'),
(311, 15, 'ROTI GARUT', NULL, 8000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-10 10:47:41', '2026-03-10 10:47:41'),
(312, 13, 'Gooday dingin', NULL, 12000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-10 10:53:15', '2026-03-10 10:53:15'),
(313, 13, 'Capucino dingin', NULL, 12000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-10 10:54:20', '2026-03-10 10:54:20'),
(314, 15, 'Creamy Latte dingin', NULL, 12000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-10 10:54:52', '2026-03-10 10:54:52'),
(315, 13, 'dancow dingin', NULL, 0.00, 0, '/images/menus/default.jpg', 1, '2026-03-10 10:55:27', '2026-03-10 10:55:27'),
(316, 13, 'MILO', NULL, 0.00, 0, '/images/menus/default.jpg', 1, '2026-03-10 10:55:43', '2026-03-10 10:55:43'),
(317, 13, 'MILO DINGIN', NULL, 12000.00, 0, '/images/menus/default.jpg', 1, '2026-03-10 10:56:03', '2026-03-10 10:56:03'),
(318, 13, 'ENERGEN', NULL, 10000.00, 0, '/images/menus/default.jpg', 1, '2026-03-10 10:56:48', '2026-03-10 10:56:48'),
(319, 13, 'TEH TARIK PANAS', NULL, 10000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-10 10:57:05', '2026-03-10 10:58:30'),
(320, 13, 'TEH TARIK DINGIN', NULL, 12000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-10 10:57:32', '2026-03-10 10:57:32'),
(321, 13, 'KOPI LUWAK DINGIN', NULL, 12000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-10 10:58:06', '2026-03-10 10:58:17'),
(322, 13, 'INDOCAFE DINGIN', NULL, 12000.00, 10000, '/images/menus/default.jpg', 1, '2026-03-10 10:59:03', '2026-03-10 10:59:03');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_03_08_133527_create_tables_table', 1),
(5, '2026_03_08_133528_create_categories_table', 1),
(6, '2026_03_08_133528_create_menus_table', 1),
(7, '2026_03_08_133528_create_orders_table_z', 1),
(8, '2026_03_08_133529_create_order_items_table', 1),
(9, '2026_03_08_133530_create_transactions_table', 1),
(10, '2026_03_08_204602_add_paid_status_to_orders_table', 1),
(11, '2026_03_08_211953_create_settings_table', 1),
(12, '2026_03_08_213859_create_shifts_table', 1),
(13, '2026_03_08_213913_add_shift_id_to_transactions_table', 1),
(14, '2026_03_08_215337_add_role_to_users_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `table_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `order_number` varchar(255) NOT NULL,
  `total_price` decimal(15,2) NOT NULL,
  `status` enum('pending','processing','ready','paid','completed','cancelled') NOT NULL DEFAULT 'pending',
  `type` enum('dine_in','takeaway') NOT NULL DEFAULT 'dine_in',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `table_id`, `user_id`, `order_number`, `total_price`, `status`, `type`, `created_at`, `updated_at`) VALUES
(17, 124, NULL, 'ORD-1DB29A9B', 132000.00, 'completed', 'dine_in', '2026-03-09 10:31:29', '2026-03-09 11:57:00'),
(18, 126, NULL, 'ORD-EBC63DB4', 106000.00, 'completed', 'dine_in', '2026-03-09 10:33:23', '2026-03-09 11:56:47'),
(23, 121, NULL, 'ORD-EFBAAF96', 290000.00, 'completed', 'dine_in', '2026-03-09 11:31:29', '2026-03-10 10:17:05'),
(24, 122, NULL, 'ORD-F0B50673', 290000.00, 'completed', 'dine_in', '2026-03-09 11:36:17', '2026-03-09 12:25:33'),
(25, 125, NULL, 'ORD-1EBC3130', 315000.00, 'completed', 'dine_in', '2026-03-09 11:47:48', '2026-03-09 12:21:37'),
(26, 132, NULL, 'ORD-B1402E21', 1075000.00, 'completed', 'dine_in', '2026-03-09 12:00:33', '2026-03-09 12:05:17'),
(27, 128, NULL, 'ORD-C8EC3908', 60000.00, 'completed', 'dine_in', '2026-03-09 12:05:59', '2026-03-09 12:09:48'),
(29, 132, NULL, 'ORD-B0BB2C04', 45000.00, 'completed', 'dine_in', '2026-03-09 12:08:29', '2026-03-09 12:09:45'),
(30, 127, NULL, 'ORD-31E7C5CB', 80000.00, 'completed', 'dine_in', '2026-03-09 12:12:00', '2026-03-09 12:29:25'),
(31, 131, NULL, 'ORD-550815A8', 33000.00, 'completed', 'dine_in', '2026-03-09 12:49:03', '2026-03-10 10:17:46'),
(32, 132, NULL, 'ORD-9E501571', 45000.00, 'completed', 'dine_in', '2026-03-09 13:48:32', '2026-03-10 10:01:22'),
(33, 127, NULL, 'ORD-88DE69D9', 23000.00, 'cancelled', 'dine_in', '2026-03-09 22:32:04', '2026-03-09 22:32:24'),
(34, 121, NULL, 'ORD-DF466EE5', 45000.00, 'completed', 'dine_in', '2026-03-10 10:20:31', '2026-03-10 13:35:21'),
(35, 125, NULL, 'ORD-C6874DD6', 82000.00, 'completed', 'dine_in', '2026-03-10 10:24:43', '2026-03-10 13:35:50'),
(36, 123, NULL, 'ORD-ECB24A04', 199000.00, 'completed', 'dine_in', '2026-03-10 10:27:46', '2026-03-10 13:35:11'),
(37, 121, NULL, 'ORD-BC066487', 208000.00, 'completed', 'dine_in', '2026-03-10 10:30:15', '2026-03-10 13:40:58'),
(38, 122, NULL, 'ORD-58141FD7', 379000.00, 'processing', 'dine_in', '2026-03-10 10:34:02', '2026-03-10 10:34:10'),
(39, 124, NULL, 'ORD-7009E9A1', 169000.00, 'completed', 'dine_in', '2026-03-10 10:40:35', '2026-03-10 13:36:47'),
(40, 126, NULL, 'ORD-4CC2BE48', 551000.00, 'processing', 'dine_in', '2026-03-10 10:44:43', '2026-03-10 10:44:47'),
(41, 133, NULL, 'ORD-4363B079', 82000.00, 'completed', 'dine_in', '2026-03-10 11:01:32', '2026-03-10 11:12:32'),
(42, 123, NULL, 'ORD-CD48BFC3', 196000.00, 'completed', 'dine_in', '2026-03-10 11:08:13', '2026-03-10 13:43:46'),
(43, 127, NULL, 'ORD-97BAC29B', 169000.00, 'completed', 'dine_in', '2026-03-10 11:10:19', '2026-03-10 11:11:37'),
(44, 129, NULL, 'ORD-5F7862FD', 262000.00, 'completed', 'dine_in', '2026-03-10 11:18:57', '2026-03-10 12:02:25'),
(45, 124, NULL, 'ORD-F02FB2AD', 15000.00, 'completed', 'dine_in', '2026-03-10 11:22:45', '2026-03-10 13:36:16'),
(46, 124, NULL, 'ORD-39138D70', 15000.00, 'cancelled', 'dine_in', '2026-03-10 11:22:47', '2026-03-10 11:46:32'),
(47, 146, NULL, 'ORD-E17656B4', 72000.00, 'completed', 'dine_in', '2026-03-10 11:41:50', '2026-03-10 13:35:56'),
(48, 123, NULL, 'ORD-4AF01549', 460000.00, 'completed', 'dine_in', '2026-03-10 11:56:23', '2026-03-10 13:41:38'),
(49, 124, NULL, 'ORD-52FFD70D', 15000.00, 'completed', 'dine_in', '2026-03-10 12:30:41', '2026-03-10 13:40:14'),
(50, 128, NULL, 'ORD-EC2C88AB', 122000.00, 'completed', 'dine_in', '2026-03-10 13:06:43', '2026-03-10 13:33:58'),
(51, 146, NULL, 'ORD-780ACB66', 15000.00, 'completed', 'dine_in', '2026-03-10 13:09:30', '2026-03-10 13:11:50'),
(52, 121, NULL, 'ORD-EFBDADD4', 30000.00, 'completed', 'dine_in', '2026-03-10 13:30:25', '2026-03-10 13:34:24');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `menu_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL,
  `notes` text DEFAULT NULL,
  `price_at_time` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `menu_id`, `quantity`, `notes`, `price_at_time`, `created_at`, `updated_at`) VALUES
(72, 17, 295, 1, NULL, 20000.00, '2026-03-09 10:31:29', '2026-03-09 10:31:29'),
(73, 17, 283, 1, 'Nasi Merah', 25000.00, '2026-03-09 10:31:29', '2026-03-09 10:31:29'),
(74, 17, 286, 1, NULL, 12000.00, '2026-03-09 10:31:29', '2026-03-09 10:31:29'),
(75, 17, 283, 1, 'Nasi Cikur', 25000.00, '2026-03-09 10:31:29', '2026-03-09 10:31:29'),
(78, 18, 270, 1, 'Sambel Dadak', 29000.00, '2026-03-09 10:33:23', '2026-03-09 10:33:23'),
(79, 18, 271, 1, 'Sambel Dadak', 25000.00, '2026-03-09 10:33:23', '2026-03-09 10:33:23'),
(80, 18, 288, 1, NULL, 15000.00, '2026-03-09 10:33:23', '2026-03-09 10:33:23'),
(81, 18, 305, 1, NULL, 15000.00, '2026-03-09 10:33:23', '2026-03-09 10:33:23'),
(82, 18, 268, 1, NULL, 15000.00, '2026-03-09 10:33:23', '2026-03-09 10:33:23'),
(83, 18, 259, 1, NULL, 7000.00, '2026-03-09 10:33:23', '2026-03-09 10:33:23'),
(101, 23, 271, 2, NULL, 25000.00, '2026-03-09 11:31:29', '2026-03-09 11:31:29'),
(102, 23, 283, 3, NULL, 25000.00, '2026-03-09 11:31:29', '2026-03-09 11:31:29'),
(103, 23, 261, 2, NULL, 15000.00, '2026-03-09 11:31:29', '2026-03-09 11:31:29'),
(104, 23, 254, 1, NULL, 10000.00, '2026-03-09 11:31:29', '2026-03-09 11:31:29'),
(105, 23, 256, 1, NULL, 10000.00, '2026-03-09 11:31:29', '2026-03-09 11:31:29'),
(106, 23, 245, 1, NULL, 15000.00, '2026-03-09 11:31:29', '2026-03-09 11:31:29'),
(107, 23, 251, 1, NULL, 10000.00, '2026-03-09 11:31:29', '2026-03-09 11:31:29'),
(108, 23, 268, 1, NULL, 15000.00, '2026-03-09 11:31:29', '2026-03-09 11:31:29'),
(111, 24, 271, 1, 'Nasi Cikur', 25000.00, '2026-03-09 11:36:17', '2026-03-09 11:36:17'),
(112, 24, 271, 1, NULL, 25000.00, '2026-03-09 11:36:17', '2026-03-09 11:36:17'),
(113, 24, 265, 1, NULL, 15000.00, '2026-03-09 11:36:17', '2026-03-09 11:36:17'),
(114, 25, 291, 1, NULL, 15000.00, '2026-03-09 11:47:48', '2026-03-09 11:47:48'),
(115, 25, 287, 1, NULL, 15000.00, '2026-03-09 11:47:48', '2026-03-09 11:47:48'),
(116, 25, 288, 1, NULL, 15000.00, '2026-03-09 11:47:48', '2026-03-09 11:47:48'),
(117, 25, 283, 10, NULL, 25000.00, '2026-03-09 11:47:48', '2026-03-09 11:47:48'),
(118, 25, 295, 1, NULL, 20000.00, '2026-03-09 11:47:48', '2026-03-09 11:47:48'),
(120, 26, 271, 5, 'Nasi Cikur', 25000.00, '2026-03-09 12:00:33', '2026-03-09 12:00:33'),
(122, 26, 271, 2, NULL, 25000.00, '2026-03-09 12:00:33', '2026-03-09 12:00:33'),
(124, 26, 271, 2, 'Nasi Timbel', 25000.00, '2026-03-09 12:00:33', '2026-03-09 12:00:33'),
(125, 27, 261, 1, NULL, 15000.00, '2026-03-09 12:05:59', '2026-03-09 12:05:59'),
(126, 27, 265, 1, NULL, 15000.00, '2026-03-09 12:05:59', '2026-03-09 12:05:59'),
(127, 27, 285, 1, NULL, 15000.00, '2026-03-09 12:05:59', '2026-03-09 12:05:59'),
(128, 27, 288, 1, NULL, 15000.00, '2026-03-09 12:05:59', '2026-03-09 12:05:59'),
(131, 29, 287, 1, NULL, 15000.00, '2026-03-09 12:08:29', '2026-03-09 12:08:29'),
(133, 29, 280, 1, NULL, 5000.00, '2026-03-09 12:08:29', '2026-03-09 12:08:29'),
(134, 30, 271, 2, NULL, 25000.00, '2026-03-09 12:12:00', '2026-03-09 12:12:00'),
(135, 30, 288, 2, NULL, 15000.00, '2026-03-09 12:12:00', '2026-03-09 12:12:00'),
(136, 31, 263, 1, NULL, 12000.00, '2026-03-09 12:49:05', '2026-03-09 12:49:05'),
(137, 31, 249, 3, NULL, 7000.00, '2026-03-09 12:49:05', '2026-03-09 12:49:05'),
(138, 32, 267, 1, NULL, 15000.00, '2026-03-09 13:48:32', '2026-03-09 13:48:32'),
(139, 32, 261, 2, NULL, 15000.00, '2026-03-09 13:48:32', '2026-03-09 13:48:32'),
(140, 33, 245, 1, NULL, 15000.00, '2026-03-09 22:32:04', '2026-03-09 22:32:04'),
(141, 33, 246, 1, NULL, 8000.00, '2026-03-09 22:32:04', '2026-03-09 22:32:04'),
(142, 34, 246, 1, NULL, 8000.00, '2026-03-10 10:20:31', '2026-03-10 10:20:31'),
(143, 34, 271, 1, NULL, 25000.00, '2026-03-10 10:20:31', '2026-03-10 10:20:31'),
(144, 34, 286, 1, NULL, 12000.00, '2026-03-10 10:20:31', '2026-03-10 10:20:31'),
(145, 35, 283, 1, 'Nasi Cikur', 25000.00, '2026-03-10 10:24:43', '2026-03-10 10:24:43'),
(146, 35, 288, 1, NULL, 15000.00, '2026-03-10 10:24:43', '2026-03-10 10:24:43'),
(147, 35, 283, 1, NULL, 25000.00, '2026-03-10 10:24:43', '2026-03-10 10:24:43'),
(148, 35, 304, 1, NULL, 17000.00, '2026-03-10 10:24:43', '2026-03-10 10:24:43'),
(149, 36, 283, 1, 'Nasi Cikur', 25000.00, '2026-03-10 10:27:46', '2026-03-10 10:27:46'),
(150, 36, 270, 2, NULL, 29000.00, '2026-03-10 10:27:46', '2026-03-10 10:27:46'),
(151, 36, 274, 2, NULL, 28000.00, '2026-03-10 10:27:46', '2026-03-10 10:27:46'),
(152, 36, 292, 2, NULL, 15000.00, '2026-03-10 10:27:46', '2026-03-10 10:27:46'),
(153, 36, 288, 2, NULL, 15000.00, '2026-03-10 10:27:47', '2026-03-10 10:27:47'),
(154, 37, 270, 1, 'Sambel Dadak', 29000.00, '2026-03-10 10:30:15', '2026-03-10 10:30:15'),
(155, 37, 283, 4, 'Nasi Cikur', 25000.00, '2026-03-10 10:30:15', '2026-03-10 10:30:15'),
(156, 37, 271, 1, 'Nasi Merah', 25000.00, '2026-03-10 10:30:15', '2026-03-10 10:30:15'),
(157, 37, 270, 1, 'Nasi Merah', 29000.00, '2026-03-10 10:30:15', '2026-03-10 10:30:15'),
(158, 37, 271, 1, NULL, 25000.00, '2026-03-10 10:30:15', '2026-03-10 10:30:15'),
(159, 38, 271, 5, 'Sambel Dadak', 25000.00, '2026-03-10 10:34:02', '2026-03-10 10:34:02'),
(160, 38, 271, 5, 'Nasi Cikur, Sambel Dadak', 25000.00, '2026-03-10 10:34:02', '2026-03-10 10:34:02'),
(161, 38, 271, 2, 'Nasi Timbel', 25000.00, '2026-03-10 10:34:02', '2026-03-10 10:34:02'),
(162, 38, 270, 1, 'Nasi Timbel, Sambel Dadak', 29000.00, '2026-03-10 10:34:02', '2026-03-10 10:34:02'),
(163, 38, 271, 2, 'Nasi Merah, Sambel Dadak', 25000.00, '2026-03-10 10:34:02', '2026-03-10 10:34:02'),
(164, 39, 274, 2, NULL, 28000.00, '2026-03-10 10:40:35', '2026-03-10 10:40:35'),
(165, 39, 270, 2, NULL, 29000.00, '2026-03-10 10:40:35', '2026-03-10 10:40:35'),
(166, 39, 271, 1, NULL, 25000.00, '2026-03-10 10:40:35', '2026-03-10 10:40:35'),
(167, 39, 288, 1, NULL, 15000.00, '2026-03-10 10:40:35', '2026-03-10 10:40:35'),
(168, 39, 262, 1, NULL, 15000.00, '2026-03-10 10:40:35', '2026-03-10 10:40:35'),
(169, 40, 270, 19, NULL, 29000.00, '2026-03-10 10:44:43', '2026-03-10 10:44:43'),
(170, 41, 271, 2, NULL, 25000.00, '2026-03-10 11:01:32', '2026-03-10 11:01:32'),
(171, 41, 249, 1, NULL, 8000.00, '2026-03-10 11:01:32', '2026-03-10 11:01:32'),
(172, 41, 311, 3, NULL, 8000.00, '2026-03-10 11:01:32', '2026-03-10 11:01:32'),
(173, 42, 283, 1, 'Nasi Cikur', 25000.00, '2026-03-10 11:08:13', '2026-03-10 11:08:13'),
(174, 42, 270, 2, NULL, 29000.00, '2026-03-10 11:08:13', '2026-03-10 11:08:13'),
(175, 42, 274, 1, NULL, 28000.00, '2026-03-10 11:08:13', '2026-03-10 11:08:13'),
(176, 42, 271, 1, NULL, 25000.00, '2026-03-10 11:08:13', '2026-03-10 11:08:13'),
(177, 42, 292, 2, NULL, 15000.00, '2026-03-10 11:08:13', '2026-03-10 11:08:13'),
(178, 42, 288, 2, NULL, 15000.00, '2026-03-10 11:08:13', '2026-03-10 11:08:13'),
(179, 43, 270, 3, NULL, 29000.00, '2026-03-10 11:10:19', '2026-03-10 11:10:19'),
(180, 43, 279, 2, NULL, 15000.00, '2026-03-10 11:10:19', '2026-03-10 11:10:19'),
(181, 43, 313, 1, NULL, 12000.00, '2026-03-10 11:10:19', '2026-03-10 11:10:19'),
(182, 43, 314, 1, NULL, 12000.00, '2026-03-10 11:10:19', '2026-03-10 11:10:19'),
(183, 43, 252, 2, NULL, 10000.00, '2026-03-10 11:10:19', '2026-03-10 11:10:19'),
(184, 43, 311, 1, NULL, 8000.00, '2026-03-10 11:10:19', '2026-03-10 11:10:19'),
(185, 44, 270, 8, NULL, 29000.00, '2026-03-10 11:18:57', '2026-03-10 11:18:57'),
(186, 44, 284, 2, NULL, 15000.00, '2026-03-10 11:18:57', '2026-03-10 11:18:57'),
(187, 45, 287, 1, NULL, 15000.00, '2026-03-10 11:22:45', '2026-03-10 11:22:45'),
(188, 46, 287, 1, NULL, 15000.00, '2026-03-10 11:22:47', '2026-03-10 11:22:47'),
(189, 47, 296, 1, NULL, 15000.00, '2026-03-10 11:41:50', '2026-03-10 11:41:50'),
(190, 47, 314, 1, NULL, 12000.00, '2026-03-10 11:41:50', '2026-03-10 11:41:50'),
(191, 47, 258, 1, NULL, 10000.00, '2026-03-10 11:41:50', '2026-03-10 11:41:50'),
(192, 47, 295, 1, NULL, 20000.00, '2026-03-10 11:41:50', '2026-03-10 11:41:50'),
(193, 47, 299, 1, NULL, 15000.00, '2026-03-10 11:41:50', '2026-03-10 11:41:50'),
(194, 48, 270, 2, 'Nasi Cikur', 29000.00, '2026-03-10 11:56:23', '2026-03-10 11:56:23'),
(195, 48, 271, 10, 'Nasi Cikur', 25000.00, '2026-03-10 11:56:23', '2026-03-10 11:56:23'),
(196, 48, 271, 2, 'Nasi Merah', 25000.00, '2026-03-10 11:56:23', '2026-03-10 11:56:23'),
(197, 48, 270, 1, 'Nasi Merah', 29000.00, '2026-03-10 11:56:23', '2026-03-10 11:56:23'),
(198, 48, 271, 2, 'Nasi Timbel', 25000.00, '2026-03-10 11:56:23', '2026-03-10 11:56:23'),
(199, 48, 296, 1, NULL, 15000.00, '2026-03-10 11:56:23', '2026-03-10 11:56:23'),
(200, 48, 248, 1, NULL, 8000.00, '2026-03-10 11:56:23', '2026-03-10 11:56:23'),
(201, 49, 296, 1, NULL, 15000.00, '2026-03-10 12:30:41', '2026-03-10 12:30:41'),
(202, 50, 271, 1, 'Nasi Cikur', 25000.00, '2026-03-10 13:06:43', '2026-03-10 13:06:43'),
(203, 50, 271, 1, 'Nasi Merah', 25000.00, '2026-03-10 13:06:43', '2026-03-10 13:06:43'),
(204, 50, 271, 1, NULL, 25000.00, '2026-03-10 13:06:44', '2026-03-10 13:06:44'),
(205, 50, 303, 1, NULL, 17000.00, '2026-03-10 13:06:44', '2026-03-10 13:06:44'),
(206, 50, 305, 1, NULL, 15000.00, '2026-03-10 13:06:44', '2026-03-10 13:06:44'),
(207, 50, 292, 1, NULL, 15000.00, '2026-03-10 13:06:44', '2026-03-10 13:06:44'),
(208, 51, 288, 1, NULL, 15000.00, '2026-03-10 13:09:30', '2026-03-10 13:09:30'),
(209, 52, 268, 2, NULL, 15000.00, '2026-03-10 13:30:25', '2026-03-10 13:30:25');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('0E8Hj5jKjQCGq8slGiv7TgoRQJcG67oRFVlj37dN', NULL, '100.24.16.246', 'Mozilla/5.0 (X11; U; Linux; i686; en-US; rv:1.6) Gecko Epiphany/1.2.5', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQWlkcUI3YVROaXJyQXQ4MWRLVDdLem1TMXRtSnBDallLdzFzbUFZViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773165725),
('0fOs7f3JY4GkozH2hu6FitYuL4jLUBGMWyo7jBkf', NULL, '134.199.144.178', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWU9qTmx0QzN0a1JSMEJ1WWZYVXBkanFhY3VtZFNvY1JqUWlsd0dwcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzY6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20vZGVtbyI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpKRHpZZU92QWlvRThucnVzIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773157340),
('2qMynrZmAVfC5ayQQwuW3UYYzIeSIX7L82nQ8irR', NULL, '45.92.85.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicVBJU21aZWlYa1BwRk5Kb3NXVzVibG5BcmZoelkwNWRrUXVqSnFpWSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773163830),
('3kTcTgG4SE0gZHf7kehQIO4yFDVrTmmDCvDX6fLx', NULL, '34.219.15.101', 'Mozilla/5.0 (Macintosh; PPC Mac OS X 10.8; rv:46.0) Gecko/20100101 Firefox/46.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWWc0UENycTl0eVlrSkU3UFZpd2h3VE45UkpoRmg1WllQMTZIZFVLTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773180633),
('6XuinRdftZWBmL1oHsxu9pgzOY2H0opNLynNc8cE', NULL, '111.90.182.153', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYmdTcXdtaHlwR0JJR25MbWNOcnFkaUZrQjNBeW1OYUR1S0NSOWxRdiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDM6Imh0dHBzOi8vdWppYW4uc21rbjFrYWxpZ29uZGFuZy5zY2guaWQvbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773174299),
('7c6Vq83dDOUJsLWyNC3tczno3iz2mJFMXdhrYuvs', NULL, '2.189.5.142', 'Mozilla/5.0 (Android 4.4; Mobile; rv:41.0) Gecko/41.0 Firefox/41.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicDNVUklPMTRmcHFzNVRoNU91MHVweVZObWtibkhtMVl2MjNOb3ZqQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773166136),
('8DcjMe5IdHM78eeZ0crJt4nY1hbgMfpJu6PGZ37J', NULL, '2.189.5.142', 'Mozilla/5.0 (Linux; Android 5.0.2; SAMSUNG SM-T550 Build/LRX22G) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/3.3 Chrome/38.0.2125.102 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOUk0STlMdWVadVNOVkRDNElkMTRMME5Id0Jsb0tUWFlGMkdtYVVlTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773181039),
('8fNnbbvcdmnVJjtP9SalwOzCv6SFhXcQ8Rt5gWRC', NULL, '2.189.5.142', 'Mozilla/5.0 (Linux; Android 11; Lenovo YT-J706X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic0lpVXM0OGRUY1paWkF0SjJHTG9pbVROcFZwc3ZmaGRHODE2d3BzUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773168674),
('9MIRDWSSHDX3scc8w3poMQP1o7pluF1dWWz4kgJF', NULL, '2.189.5.142', 'Mozilla/5.0 (Android 13; Mobile; rv:109.0) Gecko/118.0 Firefox/118.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVXlIWEw5WTdrbTJEU0Y1cFdReEg1dGtRWFhmUldPYkFRZTJzWFVLWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773161403),
('9yshBYtC5xD94LJkJUELIw0ZzcWRN1GqGoqSchwU', NULL, '141.98.11.106', 'Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoiMHRHUVhHWGdUcWpuRTA3b3VvTVNLeXBQYU9HcGUzdFVEM3JjNzVBdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20vbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX1zOjM6InVybCI7YToxOntzOjg6ImludGVuZGVkIjtzOjM3OiJodHRwczovL2hvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tL2FkbWluIjt9fQ==', 1773161161),
('aAno8kxl7C6hbl8LG26zQrhiUt4F1Aij86dRCvRu', NULL, '172.111.15.34', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRXFOMkNNQWVuMmtDU0ZoUzM3aXZrRVJIc0d1eFZzWGlOUE1vU2ZTSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773171019),
('ArsLmo0DoWbNeWUjIZaNYI5iHiPHisiunhnNj519', NULL, '16.144.17.106', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3829.0 Safari/537.36 Edg/77.0.197.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZlc2V3F4VjdhWGg0bU0wZ1FVY0o3WUN3VkZFdUZOdzE4S2U2dmh1VyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773173828),
('aSqNRjAFG4fBGFjyaeYRbv4Sz3iy2Ydtt4hoWMmv', NULL, '92.118.59.132', 'Go-http-client/1.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibnJPZFZXenJwVWVwN1Mxek12SjZtaU9KdU15Wjc2UlZ4cEVGNndHeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vMTAzLjEzOS4xOTMuODEvbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773165799),
('aVIUqFjJdFdG0gQBEB0nFsYxW4ab5ZE3GFFjX2mW', NULL, '2.189.5.142', 'Mozilla/5.0 (iPod touch; CPU iPhone OS 13_6 like Mac OS X) AppleWebKit/604.5.6 (KHTML, like Gecko) FxiOS/118.0 Mobile/15E148 Safari/605.1.15', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid290SG56TnF2VzZGNE9QN1E0OEJIYlo4OFJVYVBNNmxNNlhBampvNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773173246),
('BIxv8SbPukzTTR4RJbxWLq9QkrP2NZawbAVpnw6Z', NULL, '2.189.5.142', 'Mozilla/5.0 (Android 13; Mobile; rv:109.0) Gecko/118.0 Firefox/118.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQUdjdVVWMUFhdnBhYUtyTVhpSlpvU2VYa1NYenRCY29LNzFaTzBIZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773165537),
('bTaqEN65kEtj8Y9b2xLWt9u5H9l3kUeT4TAdDjWF', NULL, '45.92.84.107', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSTFQazcxSzZnbllFdDNib1RRbklTTVhzcUM5UkdPeWdUelh1UG1jQyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773178344),
('ByT0qnnw6Zlyf3eqZ53TamYkwKX94IXcx2FhyShQ', NULL, '93.123.109.214', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiemtxSWRGMW5sS0kyUU5OeWpreEZNQ2dGRkhyazU1bmRsWVNLeUxCTCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDM6Imh0dHBzOi8vdWppYW4uc21rbjFrYWxpZ29uZGFuZy5zY2guaWQvbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773172041),
('C7CJ9otDs8n4bwIxMeRcOxpPTn83q6kXEOxzARFe', NULL, '51.68.111.203', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidDB0MUJYczc3aEY2Qm80bk9JRHhpSkxweDNDbVU2YVg1TndQNkJNcSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20iO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773172823),
('cF1XmLVXkvHHfJew0MTYyUpeJjOW3Ieqy0yCiZoc', NULL, '162.19.252.246', '{USER_AGENT}', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWU5lS1JOT1VmVHR1SGptNjJTQk5SUVpubUtlZU9EaTFWemMxZ01JMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773164796),
('chxWcecgUCg0kA7HbUQ3ZilLFXurBUjgFqdLyHDC', NULL, '23.80.167.29', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUzNneDg0MzNVN0lPSEFNR3V2ODNsTHF5Z2x1OEdIUjZCT2sweHRBNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773163892),
('cM6NgiIgVjHQ5kIka9LJg8IFl0REQ1dhcpfFyerh', NULL, '35.81.84.176', 'Mozilla/5.0 (compatible; wpbot/1.4; +https://forms.gle/ajBaxygz9jSR8p8G9)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieGVPaGRQcm1GY0hkRjhPN2NDczNEM2V1QXQ4eGhXRkZodGl1M25GMyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDU6Imh0dHBzOi8vZGV2ZGFzaC5ob3VzZW9mYmVlZm9mZmljaWFsLmNvbS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773163202),
('D7ADaeOnIAg3VyzHSl8WzzNTUiqAiQVzChzbyxEv', NULL, '120.71.59.24', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaFdxam1jQzF6RW95clFPSUhsWnRGczdEODVrcDFSVnlxa0NYcUxuNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773170139),
('dECBWlfUJjOsrE6EyNtEgTmQGVVbrlsPBYAgrhbk', NULL, '45.92.85.240', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZTFSbVZ1VWhNRmFhVUFhVlJwTDUzdG55aGpuZlpydWxvSlJxT3hyUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773163822),
('DeyRJ2u8EeEJfxYO5cyN1GZuidMDYRichPk8oChE', NULL, '31.121.111.18', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.3', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZG52MXFUQzMwYk5mY3o5cXc4UTJsalJvZWNObGVCVjdXRVpKQUV0RyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773159085),
('dGDvAmxp1U1CrJ9GmtpAPWw2UT6irnd2aQgB3OCA', NULL, '2.189.5.142', 'Mozilla/5.0 (iPhone14,3; U; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) Version/10.0 Mobile/19A346 Safari/602.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidEdqVlc5UlV5S0hZY0ZOV0pTQXFTZFdPWjI2dDJ5Mm82SGJlTm5DYyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773177878),
('DIKrPKdmjjD1nGdR5BcmUzNNHTQfVunFzAmZXPh9', NULL, '66.249.77.200', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicUluV2s3aFV6ODVib25kc3ZqSnJoczJ1TnVnTFZDR21vcDBLbERlZCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773180640),
('Dp42mH0prNzE6DBLOARmCbNU6y4GN1eRldk6D3VI', NULL, '92.118.59.132', 'Go-http-client/1.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYTZWYnBoaWtHVVRXWGJmZmdMSklaTWVybk9FMnptRWVzOWR5Y3dPciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHBzOi8vMTAzLjEzOS4xOTMuODEiO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773165798),
('dVdT5JPKr5lDwkEQ3M6KBUxQVCnHJ2tAVFOTLxts', NULL, '35.93.83.219', '', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWmhLbjhKMmVROWpQS2hnOEU3NXNOeW91dDdDUmdPNmk1R3JKcjluWiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773180637),
('EKoYhEpvOSVOlSfoOiY53GKSCfX3LhXlli5BwWr9', NULL, '134.199.144.178', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibUx2NzluM1VpMEx4UkR2RThxMTlwdmZOMWtZdEFWQXFPWXdKRVpSTiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20vbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773157339),
('EmBDOzqh0vAI9Nbtagr8miY7zBloNBE142QPtN8n', NULL, '66.249.77.198', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiREI1WE0wTmVXT0VVMVg5YkV6eXh0OEE5SWRaT0xuSkhWOGtjSFRHUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773180642),
('EqKCFv8BHHYJsAyNV8uzM40YCG5tdI9zu9GYQMFR', NULL, '206.168.34.120', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicklKUXQzQXcyYTFOWW9RYmVhTDJKbGkwUnMyU0ZSV2pkSE85blBVdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHBzOi8vMTAzLjEzOS4xOTMuODEiO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773169320),
('ERNxJ5lQwGdu6pNiwVioFIOTYxXgBDTgNfL9lFFO', NULL, '167.114.3.106', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNExtOU9GbHQ0UXVsR3cwQlV0Mm9CUVZseXV3ejVJMG5wYlVDM0VMRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773180550),
('erSDVcehuJzZ4N1MfJ3Lv3rcF5qhYj0hwO8lnMZV', NULL, '54.189.162.174', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZjBOVFE3azlXak9hVXBEOVE5RmIwSXVLVkxJNzFUYndSNGhyMmZRZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773181292),
('ETIbgZbHmvUpZHaYZqAwo4AsbAZCnzvr1rb9Z6D9', NULL, '100.24.16.246', 'SonyEricssonT100/R101', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOXBYaFMwVDRuelB5OTU4dHdzMDhSRHB1MkNBUzZVS0p0YnoxekF5ciI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773165725),
('Fc45gCXcQ3VIetOcKpJSuSFYzNTaNOSOt7w7rsUs', NULL, '43.159.152.187', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMXRsY2JpcUFoOTBia2UxOHEwOTBCV3U1YjZSQU4zdGxLOGpqVWhtNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773160048),
('fG6XQ71153cFWvE4U5L8TD9w9M6kwFUPAliZFXaA', NULL, '206.168.34.120', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiM0lDYnh4T0xyaGdIRXJWTVdrWnFBcDYyOHViVkFnMVBHS3plSlFMUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vMTAzLjEzOS4xOTMuODEvbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773169332),
('g7Ug0cq8xo90Hxch5MTHGmfyrLJoiRr7dyQx2MOW', NULL, '2.189.5.142', 'Mozilla/5.0 (Linux; Android 11; Lenovo YT-J706X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTmRGNVpvWVJ5a3J3TVBqREtPcVNXbWc1QnV1MXZNRHFzclJFNllVdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773159004),
('glm292ohvKmKkFYN9SYZRoHwLytaYpWcSgPSRBoO', NULL, '51.68.111.203', 'Mozilla/5.0 (compatible; MJ12bot/v2.0.5; http://mj12bot.com/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTHBPeVZyNE1DZnBQWUE0OG1OMU9CTVFWMUxEVW5ZWFlMYnd2UlVEOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20vbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773172825),
('gyfQ8FevTwGqEQTSnOeOmfkogbgGBCzbPzyIkhhM', NULL, '2.189.5.142', 'Mozilla/5.0 (Linux; Android 5.0.2; SAMSUNG SM-T550 Build/LRX22G) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/3.3 Chrome/38.0.2125.102 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ1BGSWg4UHNvd2ZUOTRUekNYWktJSmhWalpWYjhVbGs2NzRIWFFUSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773174882),
('HFGIPS8NmTFWzBBexhLvBZfZxFxbCuEbqTCjCzl5', NULL, '151.80.144.77', '{USER_AGENT}', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS3hUN1FSSWNHbnVsYzltWWVWdUxUNE9NUm5WZFBzdkZzV1RialJCZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773169250),
('i8XsKjWmoXhbrhQglwMcN3WpMMspJGhJ0wtsXSjD', NULL, '151.80.144.77', '{USER_AGENT}', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRHhLZWlQRzVLSGZBekNqMHNmMHZmMEI5STU3R3Y3cFoybGE5ampSbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20iO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773156993),
('IjccDlkM329EkADrY0LnMzMGBTu6yiTApswiFX8G', NULL, '43.157.191.20', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSHZxcUF0NklTR3p4VHRlV1BUQTZvSmdPWXA0b29oQktXbG1vNTdoNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773179403),
('ILYT03gKme6b5RC0ZqnQEjEHuAZ1ybTG9Es7FOO3', NULL, '45.92.84.52', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaUkyV09OeUswUXh3dFlabTJOTHNvU3VobUFjcDN0Wkt6d2lacW1EZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773179887),
('ivI1TO1oBRWg18Cpp8JsFLBmkxDKNsEiRblRxzLG', NULL, '113.31.186.146', 'Mozilla/5.0 (Linux; Android 7.1.1; OPPO R11s Build/NMF26X; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/48.0.2564.116 Mobile Safari/537.36 T7/9.2 baiduboxapp/9.2.0.10 (Baidu; P1 7.1.1)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTE96UkdFQkY1TlJ3NWtZUHpFaWc5Z0JmTW41RGlwVFdzb3J2UVFTcCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773172087),
('Izn5mjinnidH33amLMKrOewDWQlKqceOxgmzsD3V', NULL, '2.189.5.142', 'Mozilla/5.0 (Linux; Android 11; Lenovo YT-J706X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQVlXMHFGazhRQ0NwQnYxRGlyVnhVVzEyWEZQeVZhR2JrMGRzZlY2aSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773171748),
('izWzHm3e4AF7n0vNjV8BIwzJUFEw5RtD0rCoKVyf', NULL, '134.199.144.178', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiallzZFJpbzBCeDk2TDk0YzNINGVDVHN0TU1lSFBTaDFXb2o1b3RDSCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20iO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773157338),
('jgpx7npgt4pflwbrq1DGwdM45MceTo2mox8poP4n', NULL, '2001:4860:7:912::fc', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVk9mWmRSZlZxN0Nya0l6RndVaG9LMUJNSXo1ZzY1WkhRZ2lETnRpayI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20vbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773161229),
('jOqfc7eWyrFS5aXz8OjL0WHMPaTGTr2FhzIbH87d', NULL, '43.159.152.187', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZ0F2QW1TS3l3MVBGZHIwREZ6VnlxdncyV0w2cjJrR2Z0dXdRMHpCUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773160046),
('JqlgEYpJWWlMXMtqGRG6fc04YafLKULfLM6oifeW', NULL, '120.71.59.24', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRUVoTHhsVFJQbWdFRldQQUJKc1hIRjQ2OVhJNTJLZnJJQ2I3enJ1QSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773170134),
('JTPlO2En5vJyMiSddXq69EOy3FaU6L7nzEcWSYe4', NULL, '2.189.5.142', 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:115.0) Gecko/20100101 Firefox/115.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicHNuRUc5aVZBZEhaMnIwUU91Rk04eThXQlc3WUpDZ1liZmI3Q2s5TCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773156665),
('KqfHOWbSYL8fWkYkmVxo0E7ZjPGHQimwREvGwZlW', NULL, '54.174.58.248', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTnR2QTBCc2dtUlU1Z3l6TzhFQTJGWHQzcGpzV1pvRlhHTW1PY2I1OSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20iO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773160613),
('ksJeHd0MgMrFc0Cg1sNox8hP3ZopYNqBmRzPc9k7', NULL, '2.189.5.142', 'Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:109.0) Gecko/20100101 Firefox/118.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaWJCaUg1N3hvOEEwSDhmYU9FekpHeU1XR0Y2VmZxUFp1U0xnVTJBTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773178009),
('KSnuCnFm8gERX7XfYgZ9dQ1WBduxZTxFB7qdH8An', NULL, '130.211.221.221', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVWQzRXNNOHg1Z3R3Q2ZLRDFlQlNwcDRSOFRrdThKcTBlRkJZS2pMVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773157205),
('MagY43Ew64cm4juMgCJUK746JQGoee6aSRlrSt8y', 1, '202.46.68.133', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'YTo0OntzOjY6Il90b2tlbiI7czo0MDoianNhdG1sZ2tPN2JNRWZaS2NGYkVnSWVJQkZuR0F2NkIxSVN3d3FTMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDM6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9hZG1pbi90cmFuc2FjdGlvbnMiO3M6NToicm91dGUiO3M6MTg6ImFkbWluLnRyYW5zYWN0aW9ucyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7fQ==', 1773160262),
('maI4HTSXiD58lOXCXH9KozMECwqcnxi8su8LKzbu', NULL, '16.144.17.106', 'Mozilla/5.0 (Linux; Android 9; ONEPLUS A5010) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.143 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRDZVNzdPWm1CNklVbHhVWDVnVjhZWUpyeG1zenhZYzFHaUtHVDBrbSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773173823),
('MP8h5mEQ4p00E9KHG0Tozmu9egqpOgNvGUX8BlPN', NULL, '152.53.195.17', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiclpaTzl2ZjhqQmFGczdBUUtvbnByWFFXR2RuVG5YWDA5MDhRSzlKNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773165417),
('mVjKkiGZKHIkL8MCdDWfYfoE7gw1pvx5l23P0cCb', NULL, '93.123.109.214', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRlY3b1d1a0Z3Wk8ybGJtSVR2NFc2TVE5a1M4VnRWdEhwb2RMQmp1SyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vdWppYW4uc21rbjFrYWxpZ29uZGFuZy5zY2guaWQiO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773172040),
('N4VfQNOqdNoWzt0AIDfadX77YNwl7GrnqE4ndLp1', NULL, '2600:1900:0:2107::1f01', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibkRjTnNVZnU5YTFtZ3VQT2x0Vk5XbmZDVGg5QWZxTHlGNk5jY2t4UyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773166108),
('n871nh3wrFTlpeGuQPFkFUCuQIKNyZNFTtlC8WXh', NULL, '2.189.5.142', 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/118.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieGVkZ2dzOFl4VUxuc1hVTWxRZmtMNGhIVTVodnM4SXN4V3NWRE5NMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773162392),
('nFrRcvFjrSDPq5a9eVnIeCxtTYcAY047SJvz6Vkj', NULL, '35.93.83.219', '', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSVhQeVVEUEJ1NzBLNnpjSWFvaVV5eWpPRkdmV2pSQkhLaEgwUUdoRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773180635),
('NgW5u6skY1WKppANBfI9xmAywhaMvsyF1u3UGJWm', NULL, '2600:1900:0:2107::1f01', 'Go-http-client/2.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNEo1ME1rOElIMEo1QThUd1V4ZEMwWGZlTXlQbzc2VVVJU0QyZzRLQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773166107),
('NLDsts6LI4eRIgvfTbhKapTW7W4qqMhPAn5qM2ns', NULL, '2001:4860:7:912::e9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidGhEeVZySUVOOUdCclliR0UzeGRmY3VLU1ZjeW45S0N2WDNiQU1sSyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20vbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773162571),
('nZ8jh7UScC2lN6XdfJgV4WuiHDXFsozZOWaObTsr', NULL, '93.123.109.214', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS0o0Q1JoUkNxUEdQUXZ1QnNxM2pZSWJ3TUxnQk1qdXY4blJ3WUp5OCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vdWppYW4uc21rbjFrYWxpZ29uZGFuZy5zY2guaWQiO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773172041),
('OIc9Qenmwk92Z6s9Wy65ymCVO8O3bjS2H4vHDYa9', NULL, '66.132.153.143', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWDZ0M0lDZkFzZDlXQTBpS0lCU2thaUJHZ3VUNzExdVdLZlg2U2xaSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHBzOi8vMTAzLjEzOS4xOTMuODEiO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773165607),
('OxmY7CntlqU5j6Ms0BlMKwng83zTUoWE9ND1h3fc', NULL, '66.132.153.143', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVjR4Qk9KWTNRQTl2TW1STmtXMTQ4RVJFUWh3NW5qV2xCRTZPWkNjNSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vMTAzLjEzOS4xOTMuODEvbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773165609),
('pavKXzpnvW9fHZNgui4MTYOSq8cOujwpiN1CPeAd', NULL, '172.111.15.34', 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_6_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR3JkMnVna3JTek8zZUdoNWV5ZjVrN3VxelRYSXhrU2FQQ0U3cDJ6eiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773171023),
('PjDDUwTFtriKBJwJp7nIF6xTZHtmQW9D5ooBVWFi', NULL, '134.199.144.178', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRUZEdUV6ZEUzRW1JWllEeEtQd0x3VHJoajlDbUNFbWQ2ek5RRVREaCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20vbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773157340),
('PKGyrUWBtA5eMcWrB5GFBbhZkMNUDmpajYr4QezJ', NULL, '2.189.5.142', 'Mozilla/5.0 (Android 13; Mobile; rv:109.0) Gecko/118.0 Firefox/118.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibG40RWJUcmNHR3RCSFo1dmY3cmVsMlZibEFSYkhBUHpzeFI4UTl5cCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773163788),
('PLxOM1nwDxFOq4SYSrsS5XtUFS9BrYhzaRrG4o0m', NULL, '152.53.195.17', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR2YxTlUwTUduVFlOZzBrZVZIMHhFR3dvc3JhTWVQeUFtTmhwSkhSRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773165426),
('qm9divaH9nPyJSaA3EA27EFRXATP3QGgCANchwUY', NULL, '152.53.195.17', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36 Edg/142.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ2Y0b3JLemFsaU9LbmFleWdpUnFPZkd3WDR3dUQzODR4ak1ySmtaWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773165342),
('qNuvU3EpcLSK5niYLKvf54RitRNARANBS4npPXVr', NULL, '183.134.59.133', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.27 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/601.1.27', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaUZNOWExZkEwczUzcWlJd3R2NEZHQVg5RXpGbGpHekdqbFpmQmNtNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773172247),
('QSmOyL8EZspiBdVKHp0jvQhYIz5bCUG2neCvjb4R', NULL, '130.211.221.221', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic1ZZOFgzMTJqbjREdnFGSUllMEZORUE2UmRUNU04Q2kyMDFmcTduNCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773157205),
('qUWTR6casNMt8XocgYUGjYfI5DqEbVroPBn2giZG', NULL, '34.126.69.100', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiR3d6MEZyTVlkT2JzVzU2bW5EOWlrYlE5MDFVekhtNHFVdXVERE13WCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773173222),
('QV65xjVHfuVn0xq6C7iy3wb3kNmjiFgURx2uLL56', NULL, '2620:96:e000::12f', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRG9jVmo3T3ZDalQ1Um5LWkFEemdDSUNIdk5XTkM1NHl5UnQydUh4RiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDQ6Imh0dHBzOi8vYXBpLXNoaXBwaW5nLmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773174831),
('R4dRuIZPTTkTFOSAdiVJJQYMr13lVUQoV4Ly3JDZ', NULL, '134.199.144.178', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiamtXbENDWVdHaTlSdmcwVGFxeWhsSDRxUWtGdG83M09icTc2dkIyUSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20iO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773157340),
('RdSONyIt0wQBDWHQfB8OfQo9qlHEkDyf0jtmJ50S', NULL, '45.92.85.161', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYUFJNkxtQTZNQ3BQaEtTZng5b3VFVUdmMURaZUpsZlc5Z0JNQWxCOCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773163827),
('RPzzQWIeqihgkuvP9aENVmaQQdjkcfEW9NjVInuW', NULL, '54.174.58.227', 'Mozilla/5.0 (compatible; HubSpot Crawler; HubSpot Domain check; +https://www.hubspot.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYklQejRMS0xCQWlJNUxpSkNPUWtWMFZ3eW13cm1JdUpTTnpKbHdKdCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20vbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773160615),
('rqgVq5IEYK0DfY0OjySadtKUw7jmWnEQG8UKfgbL', NULL, '2.189.5.142', 'Mozilla/5.0 (Android 13; Mobile; rv:109.0) Gecko/118.0 Firefox/118.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZXVyZnRyUXA0SlJnR2hCaG5CNUZwZk92RDhaOG9zanNXRE56dUp6NCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773159320),
('rxwAST4MpoLFptYhcQ8JhlT7rCXsfUL1ZTghJpYb', NULL, '44.204.228.85', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiOVNkb202eWJpT0xYMHk2VDZmNDZFek45d0dpb0ZDUEhsTWY2ODdCaCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjI6Imh0dHBzOi8vMTAzLjEzOS4xOTMuODEiO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773171970),
('RzrUHh7IQXqVQmLcgY5R8bmxynF0ivGT9KdugoZk', NULL, '2.189.5.142', 'Mozilla/5.0 (Android 4.4; Mobile; rv:41.0) Gecko/41.0 Firefox/41.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZlJQNG5ndDJwdjM0RkEzR1VMZlN3NXlpOHd0Um15Rmg0aUZlcG1hWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773175601),
('tt43dvjm975GjeNOJGX38ACmpwMd7OozLd4CUPO2', NULL, '44.202.25.250', 'Mozilla/5.0 (Kubuntu; Linux i686; rv:120.0) Gecko/20100101 Firefox/120.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVDhleFY3dzJ1WEtCakhySUhoY0tSNkkwanNNclRzTjFkMTMzTmZTNiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjQ6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZSI7czo1OiJyb3V0ZSI7czoyNzoiZ2VuZXJhdGVkOjpST2U4SmYwbUwwTU5vRzVxIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773176797),
('ulpQ6Ju5maFRwp5mFRMTtDfJDXHf4u8bfZyVq6IT', NULL, '34.87.33.223', 'Mozilla/5.0 (X11; Linux x86_64) Firefox/117.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTW42dW1CUEJnUGE0Wk9xNVd4WUhoZlJhUFRIZVZ6anJYUUlnZFlLZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773175622),
('ux4xgumWduCPxnrxgGWjmrMQ6XeHbLKqf881oYYu', NULL, '45.92.84.107', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUWFzcElvZml5WTlPRkRvUHM5QkthTVpCYzBGaHJTSmVleHVmNmNzRiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773178342),
('uXSUcYqHATfYrWKQBRMQ0QVee5iB7wYmzK1BqYLf', NULL, '134.199.144.178', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoiQzFzQWRpNm9UcW9Gc3ZUMzNOUTFpM2lBQ3FGS0FTTUdmTWhiZnNwYSI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773157340),
('UzNq6vVD6WMopzC7rFWzURpyDL0WdYcPw8n3LHBB', NULL, '2.189.5.142', 'Mozilla/5.0 (Android 4.4; Mobile; rv:41.0) Gecko/41.0 Firefox/41.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNWVITUh5bFFGRWxDN0pYR1VBVzd0bkNiNENxOFExTmpWOXJEZGdiVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773168461),
('v6KHyJ4rIufq1BxPlyhYE2TeNbJUj3O8qzVNxIOG', NULL, '100.24.16.246', 'Mozilla/5.0 (compatible; MSIE 10.0; Windows Phone 8.0; Trident/6.0; IEMobile/10.0; ARM; Touch)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaTNnUFJ0N2tFYk1taWRlMGg0OXEzc3BrenhQcXBlN1pCRXM5U2tTYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773165726),
('vhB6ryvfLCPjKJQD7cYXQLA5UEL2DPxc6GbBkYXW', NULL, '2.189.5.142', 'Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:115.0) Gecko/20100101 Firefox/115.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWTZRcUdBd2JsOXBkRFRVWWtINmhZT2VBaEtZdDE2YXhzd08yV3B2SiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773180251),
('vjThEQh59vJcW5kYEVntoqX5nXyjxmhrV7sbWaou', NULL, '54.252.129.217', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNTE0T1hRMnR0Yks5MnJYOExZdGg0TWh1RG9adm1sVmF3VkVyWFVYViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzE6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20iO3M6NToicm91dGUiO3M6Mjc6ImdlbmVyYXRlZDo6Uk9lOEpmMG1MME1Ob0c1cSI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773161560),
('VnqVGM8mggzTLaJOAcUn91bUql69CJZ2Xx2BB3iU', NULL, '143.110.184.76', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNUJ4VGduRkhBdE1ETzNQS2pEQURJamVMcjYxc29LM3BxdGJKVnp2WiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mzc6Imh0dHBzOi8vaG91c2VvZmJlZWZvZmZpY2lhbC5jb20vbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773167175),
('Wi38ZfmFNVPqM4XhS7xBW1ZJw6lMKJhLecefZw2V', NULL, '45.92.85.240', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicFZyTkVRcVpxY1hjS3VONlFqRll6MEN4NXNtT1FLamJud2lpTzhaYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773163816),
('WYv8yFDZZrc3U0UCfIPbtuDyNsu3cmzraNr1zxGt', NULL, '159.89.187.104', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNzR4bE14STVKd0VDTGdZaWtJQkJyVnVqZUtScDRJQXRaQ0NFR1ZxdyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773166111),
('XIM5TzPRj7rq4cBfBe1wx9wrg0aqFR0lLm4cauJn', NULL, '43.157.191.20', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZm9ZcXJaUUNWNWtwWlk3V09IMFVidG50Rnd3MmVBdjQxYmpIOGFOWCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773179402),
('xqo91YzqfdANsyaXMEf9fcEFX8mdgv3LYBfaHY0Q', NULL, '2.189.5.142', 'Mozilla/5.0 (iPhone; CPU iPhone OS 13_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/118.0 Mobile/15E148 Safari/605.1.15', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib3VPa2NGWDh5clVCelZvZHFoWFFsdmVBamx1eldGRWI0dnYxNlQyaiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzU6Imh0dHBzOi8vd3d3LmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773170872),
('Xu60of5PwC7PRqODa64TyXD4wouz6lHXIYCnwfhC', NULL, '93.123.109.214', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidGlZWEQ5dm5JNG52WkFGRGtXWDdOVGpoeDdwZkM2YnJSTHRQSG5KUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDM6Imh0dHBzOi8vdWppYW4uc21rbjFrYWxpZ29uZGFuZy5zY2guaWQvbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773172040),
('YIiAWXO3SqxLWUzcy4yr2CCPSRqInIW7O50XmWaO', NULL, '183.134.59.133', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11) AppleWebKit/601.1.27 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/601.1.27', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZUlLdHdjRzhiemhrYVNKOE5VV3BONlhGdjBKR3JtYTNEdmI3aTZ2WSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MzA6Imh0dHBzOi8vYWxpcmFncm91cC5zdG9yZS9sb2dpbiI7czo1OiJyb3V0ZSI7czo1OiJsb2dpbiI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1773172421),
('ZbWpjl3eRGIfwBQhiSXluyPmsdrWKAbwf1IKWGwS', NULL, '2620:96:e000::12f', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidUFpaUtPdGJVVEt0Wlc0MDNDNUExU0paMXdhUXdxOUJPSGY2Q0NCZiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NTA6Imh0dHBzOi8vYXBpLXNoaXBwaW5nLmhvdXNlb2ZiZWVmb2ZmaWNpYWwuY29tL2xvZ2luIjtzOjU6InJvdXRlIjtzOjU6ImxvZ2luIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1773174833),
('zvNp16gqLmWdAAIWLcYj4x3eCuEpvi6NyQPmoSGn', NULL, '206.168.34.120', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWkt0WU1LdWl5RFgzeVZTVVdOQTFBamNndDd1NmRvdXRsUW90TXdqNiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6Mjg6Imh0dHBzOi8vMTAzLjEzOS4xOTMuODEvbG9naW4iO3M6NToicm91dGUiO3M6NToibG9naW4iO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773169394),
('zYJSG5YHGjcNPxaQ5I7v5E9z38NSvYxxDnPPd4mo', NULL, '44.202.25.250', 'Mozilla/5.0 (Fedora; Linux i686; rv:131.0) Gecko/20100101 Firefox/131.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiYm4yRkJkRTJtNThrc0NUZ2NWTWhRRTYzdE9NZkhUZjR1WU1xdnlKbiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjM6Imh0dHA6Ly9hbGlyYWdyb3VwLnN0b3JlIjtzOjU6InJvdXRlIjtzOjI3OiJnZW5lcmF0ZWQ6OlJPZThKZjBtTDBNTm9HNXEiO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1773176805);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 'tax_enabled', '1', '2026-03-10 06:32:50', '2026-03-10 06:32:50'),
(2, 'tax_percentage', '5', '2026-03-10 06:32:50', '2026-03-10 06:32:50'),
(3, 'shop_name', 'ALIRA MALAKA 79', '2026-03-10 06:32:50', '2026-03-10 06:33:03'),
(4, 'shop_address', 'Kawasan Bukit Tegal Malaka, Desa Rancabango, Kec. Tarogong Kaler, Kab. Garut', '2026-03-10 06:32:50', '2026-03-10 06:32:50'),
(5, 'shop_footer', 'Terima Kasih!', '2026-03-10 06:32:50', '2026-03-10 06:33:28');

-- --------------------------------------------------------

--
-- Table structure for table `shifts`
--

CREATE TABLE `shifts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `opening_cash` decimal(15,2) NOT NULL,
  `closing_cash` decimal(15,2) DEFAULT NULL,
  `expected_cash` decimal(15,2) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'open',
  `notes` text DEFAULT NULL,
  `opened_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `closed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `shifts`
--

INSERT INTO `shifts` (`id`, `user_id`, `opening_cash`, `closing_cash`, `expected_cash`, `status`, `notes`, `opened_at`, `closed_at`, `created_at`, `updated_at`) VALUES
(3, 1, 714000.00, NULL, NULL, 'open', NULL, '2026-03-09 10:18:06', NULL, '2026-03-09 10:18:06', '2026-03-09 10:18:06'),
(4, 2, 0.00, 0.00, 2650200.00, 'closed', NULL, '2026-03-10 10:01:15', '2026-03-10 13:45:39', '2026-03-10 10:01:15', '2026-03-10 13:45:39');

-- --------------------------------------------------------

--
-- Table structure for table `tables`
--

CREATE TABLE `tables` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `table_number` varchar(255) NOT NULL,
  `qr_code_token` varchar(255) NOT NULL,
  `status` enum('available','occupied') NOT NULL DEFAULT 'available',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `tables`
--

INSERT INTO `tables` (`id`, `table_number`, `qr_code_token`, `status`, `created_at`, `updated_at`) VALUES
(121, '1', '415aea5b77d25d611f56', 'available', '2026-03-09 07:24:33', '2026-03-10 13:34:24'),
(122, '2', '8281070347c30c4ee344', 'occupied', '2026-03-09 07:24:33', '2026-03-10 10:34:02'),
(123, '3', 'f1bb2f785a9fcdda8c87', 'available', '2026-03-09 07:24:33', '2026-03-10 13:35:12'),
(124, '4', 'cf8852f2c996609abebb', 'available', '2026-03-09 07:24:33', '2026-03-10 13:36:16'),
(125, '5', '7f401ca5851a28811c28', 'available', '2026-03-09 07:24:33', '2026-03-10 13:35:50'),
(126, '6', 'e6684e2f7756f2a9aa1f', 'occupied', '2026-03-09 07:24:33', '2026-03-10 10:44:43'),
(127, '7', '0489daffc27197d5f5d8', 'available', '2026-03-09 07:24:33', '2026-03-10 11:11:37'),
(128, '8', 'd9afc25d0f666315c802', 'available', '2026-03-09 07:24:33', '2026-03-10 13:33:58'),
(129, '9', 'dee4c48ec02f039b6499', 'available', '2026-03-09 07:24:33', '2026-03-10 12:02:25'),
(130, '10', '7826baba89b3538add39', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(131, '11', 'b6bc52ef3b316afbd115', 'available', '2026-03-09 07:24:33', '2026-03-10 10:17:46'),
(132, '12', '59e9bc1b5f22c7507a4f', 'available', '2026-03-09 07:24:33', '2026-03-10 10:01:22'),
(133, '13', 'b764c2cd4b1190750b4c', 'available', '2026-03-09 07:24:33', '2026-03-10 11:12:32'),
(134, '14', 'db210ab5ccb8cdfad104', 'available', '2026-03-09 07:24:33', '2026-03-09 08:28:33'),
(135, '15', '6b14715bf4e3262af4ea', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(136, '16', '98eeaad7e99d5ae82a8f', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(137, '17', '30cf993523db80cc9137', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(138, '18', 'd9991028aaad8fbc8dac', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(139, '19', '7d66aa03d31f7c32932a', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(140, '20', 'b953abbe2e78c121adb2', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(141, '21', '07b11c63736cb1497d4d', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(142, '22', 'afaf3424eb40f8e0182d', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(143, '23', 'c7b17ee4d43acd691790', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(144, '24', '4ea8c57bb4605f672c70', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(145, '25', '0fc50db0081344b5492b', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(146, '26', '101ebc91aa0fbf2eff1c', 'available', '2026-03-09 07:24:33', '2026-03-10 13:11:50'),
(147, '27', '487ee23b7590cf768704', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(148, '28', '3832d5a0145c04bc0c08', 'available', '2026-03-09 07:24:33', '2026-03-09 07:24:33'),
(149, '29', 'e144161737d960ff6708', 'available', '2026-03-09 07:24:34', '2026-03-09 07:24:34'),
(150, '30', 'ec0a4ba668f9bca7873e', 'available', '2026-03-09 07:24:34', '2026-03-09 07:24:34');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `payment_method` enum('cash','qris','debit') NOT NULL,
  `amount_paid` decimal(15,2) NOT NULL,
  `change_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `transaction_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `shift_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `order_id`, `payment_method`, `amount_paid`, `change_amount`, `transaction_time`, `created_at`, `updated_at`, `shift_id`) VALUES
(10, 18, 'cash', 106000.00, 0.00, '2026-03-09 10:34:51', '2026-03-09 10:34:51', '2026-03-09 10:34:51', 3),
(11, 17, 'cash', 150000.00, 18000.00, '2026-03-09 11:55:49', '2026-03-09 11:55:49', '2026-03-09 11:55:49', 3),
(12, 26, 'cash', 1075000.00, 0.00, '2026-03-09 12:02:18', '2026-03-09 12:02:18', '2026-03-09 12:02:18', 3),
(13, 27, 'cash', 60000.00, 0.00, '2026-03-09 12:06:11', '2026-03-09 12:06:11', '2026-03-09 12:06:11', 3),
(14, 29, 'cash', 50000.00, 5000.00, '2026-03-09 12:08:37', '2026-03-09 12:08:37', '2026-03-09 12:08:37', 3),
(15, 30, 'cash', 90000.00, 10000.00, '2026-03-09 12:12:10', '2026-03-09 12:12:10', '2026-03-09 12:12:10', 3),
(16, 25, 'cash', 315000.00, 0.00, '2026-03-09 12:19:40', '2026-03-09 12:19:40', '2026-03-09 12:19:40', 3),
(17, 24, 'cash', 291000.00, 1000.00, '2026-03-09 12:25:05', '2026-03-09 12:25:05', '2026-03-09 12:25:05', 3),
(19, 32, 'cash', 45000.00, 0.00, '2026-03-09 13:48:41', '2026-03-09 13:48:41', '2026-03-09 13:48:41', 3),
(20, 32, 'cash', 45000.00, 0.00, '2026-03-09 13:49:05', '2026-03-09 13:49:05', '2026-03-09 13:49:05', 3),
(21, 32, 'cash', 45000.00, 0.00, '2026-03-09 13:49:25', '2026-03-09 13:49:25', '2026-03-09 13:49:25', 3),
(22, 32, 'cash', 45000.00, 0.00, '2026-03-09 13:49:26', '2026-03-09 13:49:26', '2026-03-09 13:49:26', 3),
(23, 23, 'cash', 304500.00, 0.00, '2026-03-10 10:16:44', '2026-03-10 10:16:44', '2026-03-10 10:16:44', 4),
(24, 31, 'cash', 34650.00, 0.00, '2026-03-10 10:17:19', '2026-03-10 10:17:19', '2026-03-10 10:17:19', 4),
(25, 34, 'cash', 47250.00, 0.00, '2026-03-10 10:20:45', '2026-03-10 10:20:45', '2026-03-10 10:20:45', 4),
(26, 34, 'cash', 47250.00, 0.00, '2026-03-10 10:21:02', '2026-03-10 10:21:02', '2026-03-10 10:21:02', 4),
(27, 43, 'cash', 177450.00, 0.00, '2026-03-10 11:10:35', '2026-03-10 11:10:35', '2026-03-10 11:10:35', 4),
(28, 41, 'cash', 86100.00, 0.00, '2026-03-10 11:11:53', '2026-03-10 11:11:53', '2026-03-10 11:11:53', 4),
(29, 47, 'cash', 75600.00, 0.00, '2026-03-10 11:42:30', '2026-03-10 11:42:30', '2026-03-10 11:42:30', 4),
(30, 44, 'cash', 275100.00, 0.00, '2026-03-10 12:01:34', '2026-03-10 12:01:34', '2026-03-10 12:01:34', 4),
(31, 51, 'cash', 150750.00, 135000.00, '2026-03-10 13:11:23', '2026-03-10 13:11:23', '2026-03-10 13:11:23', 4),
(32, 51, 'cash', 15750.00, 0.00, '2026-03-10 13:11:35', '2026-03-10 13:11:35', '2026-03-10 13:11:35', 4),
(33, 50, 'cash', 128100.00, 0.00, '2026-03-10 13:33:52', '2026-03-10 13:33:52', '2026-03-10 13:33:52', 4),
(34, 52, 'cash', 31500.00, 0.00, '2026-03-10 13:34:14', '2026-03-10 13:34:14', '2026-03-10 13:34:14', 4),
(35, 36, 'cash', 208950.00, 0.00, '2026-03-10 13:34:56', '2026-03-10 13:34:56', '2026-03-10 13:34:56', 4),
(36, 35, 'cash', 86100.00, 0.00, '2026-03-10 13:35:41', '2026-03-10 13:35:41', '2026-03-10 13:35:41', 4),
(37, 45, 'cash', 15750.00, 0.00, '2026-03-10 13:36:08', '2026-03-10 13:36:08', '2026-03-10 13:36:08', 4),
(38, 39, 'cash', 177450.00, 0.00, '2026-03-10 13:36:39', '2026-03-10 13:36:39', '2026-03-10 13:36:39', 4),
(39, 49, 'cash', 15750.00, 0.00, '2026-03-10 13:40:05', '2026-03-10 13:40:05', '2026-03-10 13:40:05', 4),
(40, 37, 'cash', 250000.00, 31600.00, '2026-03-10 13:40:46', '2026-03-10 13:40:46', '2026-03-10 13:40:46', 4),
(41, 48, 'cash', 483000.00, 0.00, '2026-03-10 13:41:30', '2026-03-10 13:41:30', '2026-03-10 13:41:30', 4),
(42, 42, 'cash', 250000.00, 44200.00, '2026-03-10 13:43:31', '2026-03-10 13:43:31', '2026-03-10 13:43:31', 4);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'cashier',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `role`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin Alira', 'admin@aliramalaka.com', 'admin', NULL, '$2y$12$.WRT8yhqz//CKEBTfQZ/cezv5FubWwvttFKq6MsuE2AH8kFOsvzhe', 'eGyoLprznDdKgXCJF7kAeTwpxG4MV69Wl8rxO7pVIduW4fXjh8FbVg3K4D92', '2026-03-09 05:45:41', '2026-03-09 07:24:30'),
(2, 'Kasir Alira', 'kasir@aliramalaka.com', 'cashier', NULL, '$2y$12$0zsjNMbWTAJ6k/Ni2ih6xOcjIcKrUtt.YI97TjFZ7IrOCBmdMh2G6', 'ZPX5UB5uHdbhLpfUshcm7YTQMGG439BZbOZhUmzN74XNeAuu9gd3cYBnuyk3', '2026-03-09 05:45:41', '2026-03-09 07:24:31');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`id`),
  ADD KEY `menus_category_id_foreign` (`category_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `orders_order_number_unique` (`order_number`),
  ADD KEY `orders_table_id_foreign` (`table_id`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_items_order_id_foreign` (`order_id`),
  ADD KEY `order_items_menu_id_foreign` (`menu_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `settings_key_unique` (`key`);

--
-- Indexes for table `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `shifts_user_id_foreign` (`user_id`);

--
-- Indexes for table `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `tables_table_number_unique` (`table_number`),
  ADD UNIQUE KEY `tables_qr_code_token_unique` (`qr_code_token`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transactions_order_id_foreign` (`order_id`),
  ADD KEY `transactions_shift_id_foreign` (`shift_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=195;

--
-- AUTO_INCREMENT for table `menus`
--
ALTER TABLE `menus`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=323;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=210;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `shifts`
--
ALTER TABLE `shifts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tables`
--
ALTER TABLE `tables`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=151;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `menus`
--
ALTER TABLE `menus`
  ADD CONSTRAINT `menus_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_table_id_foreign` FOREIGN KEY (`table_id`) REFERENCES `tables` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_menu_id_foreign` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shifts`
--
ALTER TABLE `shifts`
  ADD CONSTRAINT `shifts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `transactions_shift_id_foreign` FOREIGN KEY (`shift_id`) REFERENCES `shifts` (`id`) ON DELETE SET NULL;
--
-- Database Synchronization updates (Added by Antigravity - Version 2)
-- Corrected based on alira (1).sql (Local Source of Truth)
--

-- 1. Create New Tables
CREATE TABLE IF NOT EXISTS `customers` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `phone` varchar(255) NOT NULL,
  `points` int(11) NOT NULL DEFAULT 0,
  `total_spent` decimal(15,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customers_phone_unique` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `reservations` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `table_id` bigint(20) UNSIGNED NOT NULL,
  `reservation_time` datetime NOT NULL,
  `num_people` int(11) NOT NULL,
  `dp_amount` decimal(12,2) NOT NULL DEFAULT 0.00,
  `transfer_proof` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `reservations_customer_id_foreign` (`customer_id`),
  KEY `reservations_table_id_foreign` (`table_id`),
  CONSTRAINT `reservations_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reservations_table_id_foreign` FOREIGN KEY (`table_id`) REFERENCES `tables` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `menu_variants` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `menu_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(15,2) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `menu_variants_menu_id_foreign` (`menu_id`),
  CONSTRAINT `menu_variants_menu_id_foreign` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Update Existing Tables (Correct Column Order)
ALTER TABLE `orders`
  ADD COLUMN `customer_id` bigint(20) UNSIGNED DEFAULT NULL AFTER `updated_at`,
  ADD COLUMN `points_earned` int(11) NOT NULL DEFAULT 0 AFTER `customer_id`,
  ADD COLUMN `points_redeemed` int(11) NOT NULL DEFAULT 0 AFTER `points_earned`,
  ADD COLUMN `loyalty_discount` decimal(12,2) NOT NULL DEFAULT 0.00 AFTER `points_redeemed`,
  ADD COLUMN `discount_amount` decimal(12,2) NOT NULL DEFAULT 0.00 AFTER `loyalty_discount`,
  ADD COLUMN `discount_notes` varchar(255) DEFAULT NULL AFTER `discount_amount`,
  ADD COLUMN `reservation_id` bigint(20) UNSIGNED DEFAULT NULL AFTER `discount_notes`,
  ADD COLUMN `dp_amount` decimal(12,2) NOT NULL DEFAULT 0.00 AFTER `reservation_id`;

ALTER TABLE `orders`
  ADD CONSTRAINT `orders_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `orders_reservation_id_foreign` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`) ON DELETE SET NULL;

ALTER TABLE `transactions`
  ADD COLUMN `points_earned` int(11) NOT NULL DEFAULT 0 AFTER `shift_id`,
  ADD COLUMN `points_redeemed` int(11) NOT NULL DEFAULT 0 AFTER `points_earned`,
  ADD COLUMN `loyalty_discount` decimal(12,2) NOT NULL DEFAULT 0.00 AFTER `points_redeemed`,
  ADD COLUMN `discount_amount` decimal(12,2) NOT NULL DEFAULT 0.00 AFTER `loyalty_discount`,
  ADD COLUMN `dp_amount` decimal(12,2) NOT NULL DEFAULT 0.00 AFTER `discount_amount`;

ALTER TABLE `order_items`
  ADD COLUMN `variant_id` bigint(20) UNSIGNED DEFAULT NULL AFTER `menu_id`,
  ADD CONSTRAINT `order_items_variant_id_foreign` FOREIGN KEY (`variant_id`) REFERENCES `menu_variants` (`id`) ON DELETE SET NULL;

-- 3. Add Missing Settings Configuration
INSERT IGNORE INTO `settings` (`id`, `key`, `value`, `created_at`, `updated_at`) VALUES
(6, 'loyalty_points_per_10k', '1', NOW(), NOW()),
(7, 'loyalty_point_value', '100', NOW(), NOW()),
(8, 'bank_name', '', NOW(), NOW()),
(9, 'bank_account_number', '', NOW(), NOW()),
(10, 'bank_account_name', '', NOW(), NOW()),
(11, 'reservation_min_dp', '0', NOW(), NOW()),
(12, 'service_charge_enabled', '1', NOW(), NOW()),
(13, 'service_charge_percentage', '5', NOW(), NOW());

-- 4. Update Migrations Table (Correct Batch Numbers)
INSERT INTO `migrations` (`migration`, `batch`) VALUES
('2026_03_10_051438_create_customers_table', 6),
('2026_03_10_051451_create_reservations_table', 6),
('2026_03_10_051458_add_customer_id_to_orders_table', 6),
('2026_03_10_061517_add_loyalty_columns_to_orders_table', 7),
('2026_03_10_061708_add_loyalty_columns_to_transactions_table', 8),
('2026_03_10_072603_add_dp_and_proof_to_reservations_table', 9),
('2026_03_10_075838_add_reservation_id_to_orders_table', 10),
('2026_03_10_080202_add_dp_amount_to_transactions_table', 11),
('2026_03_10_104001_add_discount_to_orders_and_transactions_tables', 12),
('2026_03_10_215122_create_menu_variants_table', 13),
('2026_03_10_215123_add_variant_id_to_order_items_table', 13);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
