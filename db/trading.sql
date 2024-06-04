-- MySQL dump 10.13  Distrib 8.1.0, for macos13.3 (arm64)
--
-- Host: localhost    Database: cex3
-- ------------------------------------------------------
-- Server version	8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assets`
--

DROP TABLE IF EXISTS `assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assets` (
  `asset_id` int NOT NULL AUTO_INCREMENT,
  `asset_symbol` varchar(10) NOT NULL,
  `asset_name` varchar(255) NOT NULL,
  PRIMARY KEY (`asset_id`),
  UNIQUE KEY `asset_symbol` (`asset_symbol`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `assets`
--

LOCK TABLES `assets` WRITE;
/*!40000 ALTER TABLE `assets` DISABLE KEYS */;
INSERT INTO `assets` VALUES (1,'BTC','Bitcoin'),(2,'ETH','Ethereum'),(3,'USD','US Dollar');
/*!40000 ALTER TABLE `assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hist`
--

DROP TABLE IF EXISTS `hist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hist` (
  `trn_id` int NOT NULL AUTO_INCREMENT,
  `acn` int DEFAULT NULL,
  `trn_typ` varchar(50) DEFAULT NULL,
  `amount` decimal(18,2) DEFAULT NULL,
  `trn_date` datetime DEFAULT NULL,
  PRIMARY KEY (`trn_id`),
  KEY `acn` (`acn`),
  CONSTRAINT `history_ibfk_1` FOREIGN KEY (`acn`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hist`
--

LOCK TABLES `hist` WRITE;
/*!40000 ALTER TABLE `hist` DISABLE KEYS */;
/*!40000 ALTER TABLE `hist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
  `user_id` int DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `details` text,
  PRIMARY KEY (`log_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20063 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_matches`
--

DROP TABLE IF EXISTS `order_matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_matches` (
  `match_id` int NOT NULL AUTO_INCREMENT,
  `buy_order_id` int DEFAULT NULL,
  `sell_order_id` int DEFAULT NULL,
  `asset_id` int DEFAULT NULL,
  `price` decimal(18,8) DEFAULT NULL,
  `quantity` decimal(18,8) DEFAULT NULL,
  `trade_time` datetime DEFAULT NULL,
  PRIMARY KEY (`match_id`),
  KEY `buy_order_id` (`buy_order_id`),
  KEY `sell_order_id` (`sell_order_id`),
  KEY `asset_id` (`asset_id`),
  CONSTRAINT `order_matches_ibfk_1` FOREIGN KEY (`buy_order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_matches_ibfk_2` FOREIGN KEY (`sell_order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `order_matches_ibfk_3` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_matches`
--

LOCK TABLES `order_matches` WRITE;
/*!40000 ALTER TABLE `order_matches` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `asset_id` int DEFAULT NULL,
  `order_type` enum('buy','sell') NOT NULL,
  `price` decimal(18,8) NOT NULL,
  `quantity` decimal(18,8) NOT NULL,
  `filled_quantity` decimal(18,8) DEFAULT '0.00000000',
  `status` enum('open','partially_filled','filled','cancelled') DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `order_asodst` (`asset_id`,`order_type`,`status`),
  KEY `order_asodst2` (`asset_id`,`price`,`order_type`,`status`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`)
) ENGINE=InnoDB AUTO_INCREMENT=972397 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `create_wallet_after_buy` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
    DECLARE wallet_exists INT;

    -- Chỉ kiểm tra và tạo ví nếu đó là lệnh mua
    IF NEW.order_type = 'buy' THEN
        -- Kiểm tra nếu người dùng đã có ví cho tài sản này
        SELECT COUNT(*)
        INTO wallet_exists
        FROM wallets
        WHERE user_id = NEW.user_id AND asset_id = NEW.asset_id;

        -- Nếu người dùng chưa có ví cho tài sản này, tạo ví mới
        IF wallet_exists = 0 THEN
            INSERT INTO wallets (user_id, asset_id, balance)
            VALUES (NEW.user_id, NEW.asset_id, 0);
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `trades`
--

DROP TABLE IF EXISTS `trades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trades` (
  `trade_id` int NOT NULL AUTO_INCREMENT,
  `buy_order_id` int DEFAULT NULL,
  `sell_order_id` int DEFAULT NULL,
  `asset_id` int DEFAULT NULL,
  `price` decimal(18,8) DEFAULT NULL,
  `quantity` decimal(18,8) DEFAULT NULL,
  `trade_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`trade_id`),
  KEY `buy_order_id` (`buy_order_id`),
  KEY `sell_order_id` (`sell_order_id`),
  KEY `asset_id` (`asset_id`),
  CONSTRAINT `trades_ibfk_3` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9939 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trades`
--

LOCK TABLES `trades` WRITE;
/*!40000 ALTER TABLE `trades` DISABLE KEYS */;
/*!40000 ALTER TABLE `trades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'johndoe','johndoe@example.com','2024-05-23 16:50:10'),(2,'foo','foo@example.com','2024-05-23 16:53:26'),(3,'duong','duog@e.c','2024-05-26 16:26:20'),(4,'az','azg@e.c','2024-05-26 16:31:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallets`
--

DROP TABLE IF EXISTS `wallets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wallets` (
  `user_id` int NOT NULL,
  `asset_id` int NOT NULL,
  `balance` decimal(18,8) NOT NULL DEFAULT '0.00000000',
  PRIMARY KEY (`user_id`,`asset_id`),
  KEY `asset_id` (`asset_id`),
  CONSTRAINT `wallets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `wallets_ibfk_2` FOREIGN KEY (`asset_id`) REFERENCES `assets` (`asset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallets`
--

LOCK TABLES `wallets` WRITE;
/*!40000 ALTER TABLE `wallets` DISABLE KEYS */;
INSERT INTO `wallets` VALUES (1,1,100014997.00000000),(1,2,100005095.00000000),(1,3,97996307.00000000),(2,1,100001409.00000000),(2,2,99994381.00000000),(2,3,100410305.00000000),(3,1,100004909.00000000),(3,2,99996702.00000000),(3,3,99822244.00000000),(4,1,99978685.00000000),(4,2,100003822.00000000),(4,3,101771144.00000000);
/*!40000 ALTER TABLE `wallets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-04 21:17:55
