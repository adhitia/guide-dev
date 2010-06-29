-- MySQL dump 10.13  Distrib 5.1.43, for apple-darwin10.2.0 (i386)
--
-- Host: localhost    Database: calendars_dev
-- ------------------------------------------------------
-- Server version	5.1.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address` varchar(255) DEFAULT NULL,
  `lat` float DEFAULT NULL,
  `lng` float DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `tip_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,'',NULL,NULL,'2010-06-11 20:41:02','2010-06-11 20:41:02',1,1),(2,'',NULL,NULL,'2010-06-11 20:41:02','2010-06-11 20:41:02',1,2),(3,'',NULL,NULL,'2010-06-11 20:41:02','2010-06-11 20:41:02',1,3),(4,'',NULL,NULL,'2010-06-11 20:41:02','2010-06-11 20:41:02',1,4),(5,'',NULL,NULL,'2010-06-11 20:41:02','2010-06-11 20:41:02',1,5),(6,'',NULL,NULL,'2010-06-11 20:41:02','2010-06-11 20:41:02',1,6),(7,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,7),(8,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,8),(9,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,9),(10,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,10),(11,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,11),(12,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,12),(13,'CustoÌdio SerraÌƒo, 62, Jardim Botanico',-22.9613,-43.2068,'2010-06-11 20:41:03','2010-06-11 21:09:58',1,13),(14,'Avenida Rio Branco, 100',-22.9035,-43.1783,'2010-06-11 20:41:03','2010-06-11 21:10:56',1,14),(15,'Av. AtlaÌ‚ntica, 290, Leme',-22.9623,-43.1666,'2010-06-11 20:41:03','2010-06-11 21:20:52',1,15),(16,'R. Ronald de Carvalho, 55C, Copacabana',-22.9656,-43.1765,'2010-06-11 20:41:03','2010-06-11 21:21:49',1,16),(17,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,17),(18,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,18),(19,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,22),(20,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,23),(21,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,24),(22,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,27),(23,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',3,28),(24,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',3,29),(25,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',3,30),(26,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',6,31),(27,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',6,32),(28,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',6,33),(29,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,34),(30,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,35),(31,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,36),(32,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',8,37),(33,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',8,38),(34,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',8,39),(35,'Visconde de Piraja, 43',-22.9847,-43.1968,'2010-06-11 20:41:03','2010-06-11 20:46:13',1,40),(36,'',NULL,NULL,'2010-06-11 20:41:03','2010-06-11 20:41:03',1,41),(37,'Visconde de Piraja, 43',-22.9847,-43.1968,'2010-06-11 21:02:53','2010-06-11 21:02:53',1,42),(38,'Rua Raul PompÃ©ia, 102',-22.9845,-43.1915,'2010-06-12 16:36:42','2010-06-12 16:42:30',1,43),(39,'',0,0,'2010-06-23 23:28:06','2010-06-24 18:00:35',2,NULL),(40,'',0,0,'2010-06-24 18:10:33','2010-06-24 18:14:09',NULL,NULL),(41,'',0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',NULL,58),(42,'',0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',NULL,59),(43,'',0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',NULL,60),(44,'',0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',NULL,61),(45,'',0,0,'2010-06-24 18:28:28','2010-06-24 18:28:48',NULL,NULL),(46,'',0,0,'2010-06-24 18:28:28','2010-06-24 18:28:28',NULL,63),(47,'',0,0,'2010-06-24 18:28:28','2010-06-24 18:28:28',NULL,64),(48,'',0,0,'2010-06-24 18:28:28','2010-06-24 18:28:28',NULL,65),(49,'rua ronald de carvalho, 154',-22.9649,-43.1769,'2010-06-24 18:35:10','2010-06-25 17:33:58',NULL,66),(50,'',0,0,'2010-06-24 18:35:10','2010-06-24 18:35:10',NULL,67),(51,'',0,0,'2010-06-24 18:35:10','2010-06-24 18:35:10',NULL,68),(52,'Avenida Prefeito Mendes de Morais, 1500',-23.0008,-43.2725,'2010-06-24 18:35:11','2010-06-24 23:42:09',NULL,69),(53,'Rua CustÃ³dio SerrÃ£o, 62',-22.9613,-43.2068,'2010-06-25 04:57:33','2010-06-25 17:33:58',1,70),(54,'',0,0,'2010-06-25 05:15:28','2010-06-25 05:15:28',1,71);
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `advertisements`
--

DROP TABLE IF EXISTS `advertisements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `advertisements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `condition_id` int(11) DEFAULT NULL,
  `weekday_id` int(11) DEFAULT NULL,
  `calendar_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `views_total` int(11) DEFAULT NULL,
  `views_paid` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `advertisements`
--

LOCK TABLES `advertisements` WRITE;
/*!40000 ALTER TABLE `advertisements` DISABLE KEYS */;
INSERT INTO `advertisements` VALUES (1,1,1,2,1,0,1000,'2010-05-19 10:50:00','2010-05-19 10:50:00',1),(2,1,2,2,1,0,1000,'2010-05-19 10:50:00','2010-05-19 10:50:00',1),(3,1,3,2,1,48,1000,'2010-05-19 10:50:00','2010-06-09 04:04:40',1),(4,1,4,2,1,0,1000,'2010-05-19 10:50:00','2010-05-19 10:50:00',1),(5,1,5,2,1,0,1000,'2010-05-19 10:50:00','2010-05-19 10:50:00',1),(6,1,6,2,1,0,1000,'2010-05-19 10:50:00','2010-05-19 10:50:00',1),(7,1,7,2,1,0,1000,'2010-05-19 10:50:00','2010-05-19 10:50:00',1),(8,6,2,2,1,13,1000,'2010-05-19 10:50:00','2010-06-09 02:59:23',1),(9,6,3,2,1,177,1000,'2010-05-19 10:50:00','2010-06-09 22:29:08',1),(10,4,1,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(11,4,2,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(12,4,3,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(13,4,4,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(14,4,5,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(15,4,6,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(16,4,7,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(17,5,1,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(18,5,2,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(19,5,3,2,1,0,1000,'2010-05-19 20:09:13','2010-05-19 20:09:13',NULL),(20,2,1,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(21,2,2,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(22,2,3,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(23,2,4,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(24,2,5,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(25,2,6,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(26,2,7,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(27,3,4,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(28,3,5,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(29,5,4,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(30,5,5,2,5,0,1000,'2010-05-19 21:33:31','2010-05-19 21:33:31',NULL),(31,5,1,5,1,0,1000,'2010-06-12 17:25:24','2010-06-12 17:25:24',NULL),(32,5,2,5,1,0,1000,'2010-06-12 17:25:24','2010-06-12 17:25:24',NULL),(33,6,1,5,1,0,1000,'2010-06-12 17:25:24','2010-06-12 17:25:24',NULL);
/*!40000 ALTER TABLE `advertisements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `calendars`
--

DROP TABLE IF EXISTS `calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calendars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `view_count` int(11) DEFAULT '0',
  `click_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calendars`
--

LOCK TABLES `calendars` WRITE;
/*!40000 ALTER TABLE `calendars` DISABLE KEYS */;
INSERT INTO `calendars` VALUES (1,'test calendar','',39,1,'2010-04-27 19:29:09','2010-06-11 15:25:05',1,1),(2,' What to do this week in Rio','',480,8,'2010-05-03 13:54:38','2010-06-12 17:44:11',1,1),(3,'Rita\'s Paris with Family',NULL,38,1,'2010-06-10 18:53:13','2010-06-12 17:24:34',5,3),(4,'Astoria hotel\'s guide to Rome',NULL,30,0,'2010-06-11 00:00:59','2010-06-12 17:24:33',5,6),(5,'Romantic Rio de Janeiro',NULL,38,0,'2010-06-11 17:50:09','2010-06-12 17:24:33',3,1),(6,'John\'s Gay SAN FRANCISCO',NULL,14,0,'2010-06-11 17:59:31','2010-06-12 17:24:32',3,8),(7,'some calendar',NULL,4,0,'2010-06-12 16:58:44','2010-06-12 17:24:32',1,1),(11,'test',NULL,0,0,'2010-06-19 17:28:04','2010-06-19 17:28:04',1,2),(12,'test2',NULL,0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',1,2),(13,'test3',NULL,0,0,'2010-06-24 18:28:28','2010-06-24 18:28:28',1,2),(14,'test4',NULL,0,0,'2010-06-24 18:35:10','2010-06-24 18:35:10',1,1);
/*!40000 ALTER TABLE `calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `conditions`
--

DROP TABLE IF EXISTS `conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `conditions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `weather` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `conditions`
--

LOCK TABLES `conditions` WRITE;
/*!40000 ALTER TABLE `conditions` DISABLE KEYS */;
INSERT INTO `conditions` VALUES (1,'Sunny',NULL,'2010-04-27 19:25:05','2010-04-27 19:25:05'),(2,'Cloudy',NULL,'2010-04-27 19:25:05','2010-04-27 19:25:05'),(3,'Rainy',NULL,'2010-04-27 19:25:05','2010-04-27 19:25:05'),(4,'Dinner - Ritzy',NULL,'2010-04-27 19:25:05','2010-04-27 19:25:05'),(5,'Dinner - Casual',NULL,'2010-04-27 19:25:05','2010-04-27 19:25:05'),(6,'Dinner - Cheap',NULL,'2010-04-27 19:25:05','2010-04-27 19:25:05'),(7,'Clubbing',NULL,'2010-04-27 19:25:05','2010-04-27 19:25:05'),(8,'Live music',NULL,'2010-04-27 19:25:05','2010-04-27 19:25:05'),(9,'Chilling',NULL,'2010-04-27 19:25:05','2010-04-27 19:25:05');
/*!40000 ALTER TABLE `conditions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Rio de Janeiro, Brazil','BRXX0201','2010-05-19 19:49:08','2010-05-19 19:49:08'),(2,'New York, NY','USNY0996','2010-05-19 20:34:16','2010-06-24 18:35:11'),(3,'Paris, France','FRXX0076','2010-06-10 18:53:13','2010-06-10 18:53:13'),(5,'Austin, TX','USTX0057','2010-06-11 00:00:24','2010-06-11 00:00:24'),(6,'Rome, Italy','ITXX0067','2010-06-11 00:00:59','2010-06-11 00:00:59'),(7,'','','2010-06-11 16:47:32','2010-06-11 16:47:32'),(8,'San Francisco, CA','USCA0987','2010-06-11 17:59:31','2010-06-11 17:59:31');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20100418193627'),('20100418194518'),('20100418195948'),('20100425025533'),('20100427192135'),('20100503124648'),('20100506203929'),('20100512041003'),('20100517234203'),('20100517234535'),('20100519103053'),('20100519105519'),('20100519122756'),('20100519194257'),('20100519194331'),('20100611185806'),('20100611195012'),('20100611195724'),('20100611200656'),('20100611202123'),('20100611202302'),('20100611203540'),('20100611210430'),('20100611234817'),('20100618192343'),('20100618225354'),('20100625172214');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `show_places`
--

DROP TABLE IF EXISTS `show_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `show_places` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `condition_id` int(11) DEFAULT NULL,
  `weekday_id` int(11) DEFAULT NULL,
  `calendar_id` int(11) DEFAULT NULL,
  `tip_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `show_places`
--

LOCK TABLES `show_places` WRITE;
/*!40000 ALTER TABLE `show_places` DISABLE KEYS */;
INSERT INTO `show_places` VALUES (1,1,1,11,52,'2010-06-19 17:28:04','2010-06-19 17:28:04'),(2,2,1,11,53,'2010-06-19 17:28:04','2010-06-19 17:28:04'),(3,2,2,11,54,'2010-06-19 17:28:04','2010-06-19 17:28:04'),(4,3,3,11,55,'2010-06-19 17:28:04','2010-06-19 17:28:04'),(5,4,1,11,56,'2010-06-23 23:28:06','2010-06-23 23:28:06'),(6,1,1,12,57,'2010-06-24 18:10:33','2010-06-24 18:10:33'),(7,1,2,12,58,'2010-06-24 18:10:33','2010-06-24 18:10:33'),(8,1,3,12,59,'2010-06-24 18:10:33','2010-06-24 18:10:33'),(9,2,2,12,60,'2010-06-24 18:10:33','2010-06-24 18:10:33'),(10,3,1,12,61,'2010-06-24 18:10:33','2010-06-24 18:10:33'),(11,1,1,13,62,'2010-06-24 18:28:28','2010-06-24 18:28:28'),(12,1,2,13,63,'2010-06-24 18:28:28','2010-06-24 18:28:28'),(13,2,2,13,64,'2010-06-24 18:28:28','2010-06-24 18:28:28'),(14,3,1,13,65,'2010-06-24 18:28:28','2010-06-24 18:28:28'),(15,1,1,14,66,'2010-06-24 18:35:10','2010-06-24 18:35:10'),(16,1,2,14,67,'2010-06-24 18:35:10','2010-06-24 18:35:10'),(17,2,2,14,68,'2010-06-24 18:35:11','2010-06-24 18:35:11'),(18,3,1,14,69,'2010-06-24 18:35:11','2010-06-24 18:35:11'),(19,4,1,14,70,'2010-06-25 04:57:33','2010-06-25 04:57:33'),(20,4,2,14,71,'2010-06-25 05:15:28','2010-06-25 05:15:28');
/*!40000 ALTER TABLE `show_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tips`
--

DROP TABLE IF EXISTS `tips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `condition_id` int(11) DEFAULT NULL,
  `calendar_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT '',
  `url` varchar(255) DEFAULT '',
  `view_count` int(11) DEFAULT '0',
  `click_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `image_file_name` varchar(255) DEFAULT NULL,
  `image_content_type` varchar(255) DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `advertisement` tinyint(1) DEFAULT '0',
  `author_id` int(11) DEFAULT NULL,
  `image_remote_url` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tips`
--

LOCK TABLES `tips` WRITE;
/*!40000 ALTER TABLE `tips` DISABLE KEYS */;
INSERT INTO `tips` VALUES (1,1,1,'my tip','my desc','url',13,0,'2010-04-27 19:53:32','2010-06-11 20:41:02',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(2,4,1,'good diner','some tex','http://abc.com/',9,0,'2010-04-27 20:05:43','2010-06-11 20:41:02',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(3,8,1,'music','ddd','http://en.wikipedia.org',3,1,'2010-04-27 20:05:57','2010-06-11 20:41:02',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(4,7,1,'t2','ddd','',2,0,'2010-04-27 20:06:37','2010-06-11 20:41:02',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(5,2,1,'cloudy tip','ccc','',0,0,'2010-04-30 22:21:45','2010-06-11 20:41:02',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(6,1,1,'sunny tip','ttt','',0,0,'2010-04-30 22:24:31','2010-06-11 20:41:02',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(7,2,1,'cloudy tip 2','ttt','',0,0,'2010-04-30 22:24:43','2010-06-11 20:41:03',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(8,7,1,'some club','some text','http://thepiratebay.org/',9,0,'2010-05-03 13:21:01','2010-06-11 20:41:03',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(9,1,2,'Hang-glide','Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa','http://en.wikipedia.org/',12,3,'2010-05-03 13:57:02','2010-06-11 20:41:03','_hg.jpg','image/jpeg',7025,'2010-05-03 14:55:39',0,1,NULL,NULL),(10,1,2,'Go on the beach','Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil mulu','http://www.imdb.com/',119,1,'2010-05-03 13:58:17','2010-06-11 20:41:03','bicicleta.jpg','image/jpeg',4643,'2010-05-06 18:26:22',0,1,NULL,NULL),(11,2,2,'Museum','Museum here','http://museum.com/',101,0,'2010-05-03 13:59:32','2010-06-12 17:44:11','039_Ba_a_de_Todos_os_Santos_-_Salvador_BA_-_Farol_da_Barra_e.jpg','image/jpeg',13472,'2010-05-06 18:25:28',0,1,NULL,NULL),(12,3,2,'Cooking Class','Cooking Class info goes here','http://cook.com/',139,1,'2010-05-03 14:00:45','2010-06-11 21:51:55',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(13,4,2,'Olympe','Olympe is cool','http://waldorf.com/',277,1,'2010-05-03 14:01:37','2010-06-11 21:51:56','cruxHorto.jpg','image/jpeg',14916,'2010-05-19 16:16:51',0,1,NULL,NULL),(14,4,2,'McDonald\'s','McDonald\'s is cooler than Waldorf.','http://McDonalds.com/',189,1,'2010-05-03 14:02:30','2010-06-12 17:44:12','mcdonalds-logo.jpg','image/jpeg',165786,'2010-06-12 03:36:21',0,1,'http://blogs.spokenword.ac.uk/gillianwest/files/2008/11/mcdonalds-logo.jpg',NULL),(15,5,2,'Marius Crustaceos','Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil mulu','http://RedLobster.com/',466,0,'2010-05-03 14:03:13','2010-06-12 17:44:12','505363_46186152.jpg','image/jpeg',6834,'2010-05-19 16:17:16',0,1,NULL,NULL),(16,6,2,'Amir','Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil mulu','http://FatBurger.com/',466,0,'2010-05-03 14:03:48','2010-06-12 17:44:12','039_Ba_a_de_Todos_os_Santos_-_Salvador_BA_-_Farol_da_Barra_e.jpg','image/jpeg',13472,'2010-05-19 16:17:32',0,1,NULL,NULL),(17,7,2,'Xanadu ÐºÑÐ°Ð½Ð°Ð´Ñƒ','Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil muluopa Description text ipsum nevil mulu','http://xanadu.com/',464,0,'2010-05-03 14:04:54','2010-06-12 17:44:12',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(18,1,2,'do something','like, go out','google.com',48,0,'2010-05-19 12:21:35','2010-06-11 20:41:03',NULL,NULL,NULL,NULL,1,1,NULL,NULL),(22,1,2,'monday tip','monday tip','http://google.com',0,0,'2010-05-19 12:48:49','2010-06-11 20:41:03',NULL,NULL,NULL,NULL,1,1,NULL,NULL),(23,6,2,'test ad','test ad','http://google.com',187,1,'2010-05-19 15:15:08','2010-06-11 20:41:03',NULL,NULL,NULL,NULL,1,1,NULL,NULL),(24,5,2,'some tip','some text','http://google.com',125,0,'2010-05-19 20:10:29','2010-06-11 20:41:03',NULL,NULL,NULL,NULL,1,1,NULL,NULL),(27,2,2,'Go to the beach','Go to the beach Go to the beach Go to the beach Go to the beach Go to the beach Go to the beach Go to the beach ','beach.com',66,0,'2010-05-19 21:36:15','2010-06-11 20:41:03',NULL,NULL,NULL,NULL,1,5,NULL,NULL),(28,4,3,'Paris 1','Paris 1','',35,0,'2010-06-10 18:54:23','2010-06-12 17:24:34',NULL,NULL,NULL,NULL,0,5,NULL,NULL),(29,5,3,'Paris 2','Paris 2','',35,1,'2010-06-10 18:54:37','2010-06-12 17:24:34',NULL,NULL,NULL,NULL,0,5,NULL,NULL),(30,6,3,'Paris 3','Paris 3','',35,0,'2010-06-10 18:54:51','2010-06-12 17:24:34',NULL,NULL,NULL,NULL,0,5,NULL,NULL),(31,7,4,'Rome clubbing','Rome clubbing','',21,0,'2010-06-11 00:01:46','2010-06-12 17:24:34',NULL,NULL,NULL,NULL,0,5,NULL,NULL),(32,8,4,'Rome music','Rome music','',21,0,'2010-06-11 00:02:01','2010-06-12 17:24:34',NULL,NULL,NULL,NULL,0,5,NULL,NULL),(33,9,4,'Rome chilling','Rome chilling','',21,0,'2010-06-11 00:02:31','2010-06-12 17:24:34',NULL,NULL,NULL,NULL,0,5,NULL,NULL),(34,4,5,'McDonalds','','McDonalds.com',35,0,'2010-06-11 17:52:58','2010-06-12 17:24:33',NULL,NULL,NULL,NULL,0,3,NULL,NULL),(35,5,5,'KFC','','kfc.com',35,0,'2010-06-11 17:54:10','2010-06-12 17:24:33',NULL,NULL,NULL,NULL,0,3,NULL,NULL),(36,6,5,'don\'t eat','don\'t eat','stay-hungry.org',35,0,'2010-06-11 17:56:30','2010-06-12 17:24:33',NULL,NULL,NULL,NULL,0,3,NULL,NULL),(37,7,6,'test 1','test 1','',11,0,'2010-06-11 18:00:29','2010-06-12 17:24:33',NULL,NULL,NULL,NULL,0,3,NULL,NULL),(38,8,6,'test 2','test 2','',11,0,'2010-06-11 18:00:43','2010-06-12 17:24:33',NULL,NULL,NULL,NULL,0,3,NULL,NULL),(39,9,6,'test 3','test 3','',11,0,'2010-06-11 18:00:55','2010-06-12 17:24:33',NULL,NULL,NULL,NULL,0,3,NULL,NULL),(40,7,5,'club','cool club','',33,0,'2010-06-11 18:21:32','2010-06-12 17:24:33','paris_eiffel.jpeg','image/jpeg',80858,'2010-06-11 18:24:08',0,3,NULL,NULL),(41,8,5,'music','mmm','',17,0,'2010-06-11 18:47:21','2010-06-12 17:24:33','a_funny_music_note_000.png','image/png',24392,'2010-06-11 18:47:20',0,3,NULL,NULL),(42,9,1,'chill','chill','',0,0,'2010-06-11 21:02:53','2010-06-11 21:02:53',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(43,9,2,'Le Boy','cool place','http://www.leboy.com.br/',20,0,'2010-06-12 16:36:42','2010-06-12 17:44:12','p2362-Rio_de_Janeiro-Dancing_kings.jpg','image/jpeg',26419,'2010-06-12 16:38:30',0,1,'http://photos.igougo.com/images/p2362-Rio_de_Janeiro-Dancing_kings.jpg',NULL),(52,NULL,NULL,'beach','22b','',0,0,'2010-06-19 17:28:04','2010-06-24 03:22:18','indoensianbeach.jpg','image/jpeg',324319,'2010-06-24 03:22:17',0,1,'http://foodmarathon.files.wordpress.com/2009/07/indoensianbeach.jpg',NULL),(53,NULL,NULL,'watch a movie','','',0,0,'2010-06-19 17:28:04','2010-06-24 03:23:05','017_Ba_a_de_Todos_os_Santos_-_Salvador_BA_-_Carnaval_-_Pelourinho_-_Palco_no_cruzeiro_de_S_Francisco_-_Foto_Jotafreitas.jpg','image/jpeg',7025,'2010-06-24 03:17:37',0,1,NULL,NULL),(54,NULL,NULL,'tip2','','',0,0,'2010-06-19 17:28:04','2010-06-19 17:28:04',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(55,NULL,NULL,'tip3','','',0,0,'2010-06-19 17:28:04','2010-06-19 17:28:04',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(56,NULL,NULL,'new tip','','',0,0,'2010-06-23 23:28:06','2010-06-23 23:28:06',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(57,NULL,NULL,'beach','','',0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(58,NULL,NULL,'beach','','',0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(59,NULL,NULL,'scuba','','',0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(60,NULL,NULL,'hang-glide','','',0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(61,NULL,NULL,'cooking class','','',0,0,'2010-06-24 18:10:33','2010-06-24 18:10:33',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(62,NULL,NULL,'beach','','',0,0,'2010-06-24 18:28:28','2010-06-24 18:28:28',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(63,NULL,NULL,'beach','','',0,0,'2010-06-24 18:28:28','2010-06-24 18:28:28',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(64,NULL,NULL,'hang-glide','','',0,0,'2010-06-24 18:28:28','2010-06-24 18:28:28',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(65,NULL,NULL,'cooking class','','',0,0,'2010-06-24 18:28:28','2010-06-24 18:28:28',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(66,NULL,NULL,'cooking class','ddd','http://www.google.com/maps/place?source=uds&q=cooking+class&cid=11009526813048581914',0,0,'2010-06-24 18:35:10','2010-06-25 17:33:58',NULL,NULL,NULL,NULL,0,1,'http://www.cookinrio.com/cook%2520in%2520rio%2520flyer-%2520BACK%2520email.jpg','21 8761-3653'),(67,NULL,NULL,'beach','','',0,0,'2010-06-24 18:35:10','2010-06-24 18:35:10',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(68,NULL,NULL,'hang-glide','','',0,0,'2010-06-24 18:35:10','2010-06-24 18:35:10',NULL,NULL,NULL,NULL,0,1,NULL,NULL),(69,NULL,NULL,'hang gliding','2222211','http://www.google.com/maps/place?source=uds&q=hang+gliding&cid=11810180664217661423',0,0,'2010-06-24 18:35:11','2010-06-25 17:33:58','alg_cooking-class.jpg','image/jpeg',58236,'2010-06-24 20:21:23',0,1,'http://assets.nydailynews.com/img/2008/09/12/alg_cooking-class.jpg',''),(70,NULL,NULL,'Olympe','','http://www.google.com/maps/place?source=uds&q=Olympe&cid=7907203793947660199',0,0,'2010-06-25 04:57:33','2010-06-25 17:33:58',NULL,NULL,NULL,NULL,0,1,NULL,'21 2539-4542'),(71,NULL,NULL,'Olympe','','',0,0,'2010-06-25 05:15:28','2010-06-25 05:15:28',NULL,NULL,NULL,NULL,0,1,NULL,NULL);
/*!40000 ALTER TABLE `tips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tips_weekdays`
--

DROP TABLE IF EXISTS `tips_weekdays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tips_weekdays` (
  `tip_id` int(11) DEFAULT NULL,
  `weekday_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tips_weekdays`
--

LOCK TABLES `tips_weekdays` WRITE;
/*!40000 ALTER TABLE `tips_weekdays` DISABLE KEYS */;
INSERT INTO `tips_weekdays` VALUES (1,1),(1,2),(1,5),(2,2),(2,3),(2,7),(3,2),(4,5),(4,6),(5,5),(1,6),(5,6),(6,7),(7,7),(8,1),(9,1),(9,5),(9,6),(9,7),(10,2),(10,3),(10,4),(11,1),(11,2),(11,3),(11,4),(11,5),(11,6),(11,7),(12,1),(12,4),(12,5),(12,6),(12,7),(13,1),(13,3),(13,5),(13,7),(14,2),(14,4),(14,6),(15,1),(15,2),(15,3),(15,4),(15,5),(15,6),(15,7),(16,1),(16,2),(16,3),(16,4),(16,5),(16,6),(16,7),(17,1),(17,2),(17,3),(17,4),(17,5),(17,6),(17,7),(18,3),(18,4),(19,1),(20,1),(21,1),(22,1),(23,3),(24,3),(25,3),(26,3),(27,1),(27,2),(27,3),(27,4),(28,1),(28,2),(28,3),(28,4),(28,5),(28,6),(28,7),(29,1),(29,2),(29,3),(29,4),(29,5),(29,6),(29,7),(30,1),(30,2),(30,3),(30,4),(30,5),(30,6),(30,7),(31,1),(31,2),(31,3),(31,4),(31,5),(31,6),(31,7),(32,1),(32,2),(32,3),(32,4),(32,5),(32,6),(32,7),(33,1),(33,2),(33,3),(33,4),(33,5),(33,6),(33,7),(34,1),(34,2),(34,3),(34,4),(34,5),(34,6),(34,7),(35,1),(35,2),(35,3),(35,4),(35,5),(35,6),(35,7),(36,1),(36,2),(36,3),(36,4),(36,5),(36,6),(36,7),(37,1),(37,2),(37,3),(37,4),(37,5),(37,6),(37,7),(38,1),(38,2),(38,3),(38,4),(38,5),(38,6),(38,7),(39,1),(39,2),(39,3),(39,4),(39,5),(39,6),(39,7),(40,1),(40,5),(40,6),(41,2),(41,5),(41,6),(42,1),(42,2),(42,3),(42,4),(42,5),(42,6),(42,7),(43,1),(43,6),(43,2),(43,3),(43,4),(43,5),(43,7);
/*!40000 ALTER TABLE `tips_weekdays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'abc','Nikita','abc','2010-05-09 12:02:18','2010-05-12 03:34:40'),(3,'xyz','Cris','xyz','2010-05-12 04:01:54','2010-05-12 04:02:39'),(4,'test','test','test','2010-05-19 21:01:45','2010-05-19 21:01:45'),(5,'steve','Steve','abc','2010-05-19 21:33:02','2010-05-19 21:33:02');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weekdays`
--

DROP TABLE IF EXISTS `weekdays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `weekdays` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weekdays`
--

LOCK TABLES `weekdays` WRITE;
/*!40000 ALTER TABLE `weekdays` DISABLE KEYS */;
INSERT INTO `weekdays` VALUES (1,'Monday','2010-04-27 19:25:05','2010-04-27 19:25:05'),(2,'Tuesday','2010-04-27 19:25:05','2010-04-27 19:25:05'),(3,'Wednesday','2010-04-27 19:25:05','2010-04-27 19:25:05'),(4,'Thursday','2010-04-27 19:25:05','2010-04-27 19:25:05'),(5,'Friday','2010-04-27 19:25:05','2010-04-27 19:25:05'),(6,'Saturday','2010-04-27 19:25:05','2010-04-27 19:25:05'),(7,'Sunday','2010-04-27 19:25:05','2010-04-27 19:25:05');
/*!40000 ALTER TABLE `weekdays` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-06-26 16:58:43
