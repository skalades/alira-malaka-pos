-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: alira
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `categories_slug_unique` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Minuman','minuman','https://images.unsplash.com/photo-1544145945-f904253db0ad','2026-03-08 08:45:27','2026-03-08 08:45:27'),(2,'Makanan','makanan','https://images.unsplash.com/photo-1504674900247-0877df9cc836','2026-03-08 08:45:27','2026-03-08 08:45:27'),(3,'Cemilan','cemilan','https://images.unsplash.com/photo-1599481238640-4c1288750d7a','2026-03-08 08:45:27','2026-03-08 08:45:27');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `menus` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(15,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `image` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `menus_category_id_foreign` (`category_id`),
  CONSTRAINT `menus_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES (1,1,'Kopi Susu Gula Aren',NULL,15000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(2,1,'Good Day Mocacino',NULL,8000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(3,1,'Good Day Chococino',NULL,8000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(4,1,'Good Day Vanila Latte',NULL,8000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(5,1,'Kapal Api',NULL,7000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(6,1,'Cappucino',NULL,10000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(7,1,'Creamy Latte',NULL,10000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(8,1,'Dancow Coklat',NULL,10000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(9,1,'Dancow Vanila',NULL,10000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(10,1,'Milo',NULL,10000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(11,1,'Energen',NULL,8000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(12,1,'Teh Tarik',NULL,10000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(13,1,'Kopi Luwak',NULL,8000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(14,1,'Indocafe',NULL,7000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(15,1,'Abc Susu',NULL,7000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(16,1,'Jus Nanas',NULL,12000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(17,1,'Jus Buah Naga',NULL,15000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(18,1,'Jus Alpukat',NULL,15000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(19,1,'Es Jeruk',NULL,12000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(20,1,'Sop Buah Creamy',NULL,17000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(21,1,'Es Teler Creamy',NULL,15000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(22,1,'Milkshake Coklat',NULL,15000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(23,1,'Milkshake Strawberry',NULL,15000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(24,1,'Milkshake Matcha',NULL,15000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(25,1,'Milkshake Vanilla',NULL,15000.00,100,'https://images.unsplash.com/photo-1544145945-f904253db0ad',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(26,2,'Ayam Bakar Pejantan Kumplit',NULL,29000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(27,2,'Ayam Goreng Kumplit',NULL,25000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(28,2,'Ayam Bakar Kumplit',NULL,25000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(29,2,'Peda Berem Kumplit',NULL,17000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(30,2,'Ikan Bakar Kumplit',NULL,28000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(31,2,'Sop Iga',NULL,25000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(32,2,'Karedok Leunca',NULL,12000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(33,2,'Lotek / Karedok',NULL,15000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(34,2,'Tumis Genjer',NULL,12000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(35,2,'Ceker Mercon',NULL,15000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(36,2,'Usus Goreng',NULL,5000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(37,2,'Nasi Merah Ayam Goreng',NULL,25000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(38,2,'Nasi Cikur Kumplit',NULL,25000.00,50,'https://images.unsplash.com/photo-1504674900247-0877df9cc836',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(39,3,'Tempe Mendoan',NULL,12000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(40,3,'Bala-bala',NULL,12000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(41,3,'Cireng',NULL,12000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(42,3,'Cireng Isi',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(43,3,'Pisang Keju',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(44,3,'Baso Aci Kumplit',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(45,3,'Potato Cheese',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(46,3,'Beef Burger',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(47,3,'Tomyam',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(48,3,'Omlet Enoki',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(49,3,'Colenak',NULL,20000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(50,3,'Kentang Sosis',NULL,20000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(51,3,'Seblak',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(52,3,'Basreng',NULL,12000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(53,3,'Roti Bakar',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(54,3,'Nugget',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(55,3,'Risol Matcha',NULL,17000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(56,3,'Risol Coklat',NULL,17000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(57,3,'Risol Ubi Ungu',NULL,17000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(58,3,'Risol Ayam',NULL,17000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(59,3,'Risol Mayo',NULL,17000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27'),(60,3,'Donat',NULL,15000.00,50,'https://images.unsplash.com/photo-1599481238640-4c1288750d7a',1,'2026-03-08 08:45:27','2026-03-08 08:45:27');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_03_08_133527_create_tables_table',1),(5,'2026_03_08_133528_create_categories_table',1),(6,'2026_03_08_133528_create_menus_table',1),(7,'2026_03_08_133528_create_orders_table_z',1),(8,'2026_03_08_133529_create_order_items_table',1),(9,'2026_03_08_133530_create_transactions_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `menu_id` bigint(20) unsigned NOT NULL,
  `quantity` int(11) NOT NULL,
  `notes` text DEFAULT NULL,
  `price_at_time` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_items_order_id_foreign` (`order_id`),
  KEY `order_items_menu_id_foreign` (`menu_id`),
  CONSTRAINT `order_items_menu_id_foreign` FOREIGN KEY (`menu_id`) REFERENCES `menus` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `table_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `order_number` varchar(255) NOT NULL,
  `total_price` decimal(15,2) NOT NULL,
  `status` enum('pending','processing','ready','completed','cancelled') NOT NULL DEFAULT 'pending',
  `type` enum('dine_in','takeaway') NOT NULL DEFAULT 'dine_in',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `orders_order_number_unique` (`order_number`),
  KEY `orders_table_id_foreign` (`table_id`),
  KEY `orders_user_id_foreign` (`user_id`),
  CONSTRAINT `orders_table_id_foreign` FOREIGN KEY (`table_id`) REFERENCES `tables` (`id`) ON DELETE CASCADE,
  CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tables`
--

DROP TABLE IF EXISTS `tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tables` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `table_number` varchar(255) NOT NULL,
  `qr_code_token` varchar(255) NOT NULL,
  `status` enum('available','occupied') NOT NULL DEFAULT 'available',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tables_table_number_unique` (`table_number`),
  UNIQUE KEY `tables_qr_code_token_unique` (`qr_code_token`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tables`
--

LOCK TABLES `tables` WRITE;
/*!40000 ALTER TABLE `tables` DISABLE KEYS */;
INSERT INTO `tables` VALUES (1,'1','5114a5b7412c3409b259','available','2026-03-08 08:45:27','2026-03-08 08:45:27'),(2,'2','d64de064cd02a9d47b39','available','2026-03-08 08:45:27','2026-03-08 08:45:27'),(3,'3','6793dd2dd2199ded8f84','available','2026-03-08 08:45:27','2026-03-08 08:45:27'),(4,'4','b956405187e0300368f6','available','2026-03-08 08:45:27','2026-03-08 08:45:27'),(5,'5','d928d8db5faadfe22dbc','available','2026-03-08 08:45:27','2026-03-08 08:45:27'),(6,'6','a4e1c1b540ff37f4b8fc','available','2026-03-08 08:45:27','2026-03-08 08:45:27'),(7,'7','2d78bba27554b345b727','available','2026-03-08 08:45:27','2026-03-08 08:45:27'),(8,'8','33311f2db4305c498805','available','2026-03-08 08:45:27','2026-03-08 08:45:27'),(9,'9','86753f9b557141b26016','available','2026-03-08 08:45:27','2026-03-08 08:45:27'),(10,'10','206d6e201de95609bf1c','available','2026-03-08 08:45:27','2026-03-08 08:45:27');
/*!40000 ALTER TABLE `tables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transactions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` bigint(20) unsigned NOT NULL,
  `payment_method` enum('cash','qris','debit') NOT NULL,
  `amount_paid` decimal(15,2) NOT NULL,
  `change_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `transaction_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `transactions_order_id_foreign` (`order_id`),
  CONSTRAINT `transactions_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin Alira','admin@aliramalaka.com',NULL,'$2y$12$7ibfjRfKp/LV3po6MEM1ReOdOfUMLZQCzZWa.jYx3zDot8/LYseaC',NULL,'2026-03-08 08:45:27','2026-03-08 08:45:27');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-08 22:46:25
