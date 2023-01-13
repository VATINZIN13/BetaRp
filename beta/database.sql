-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.24-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.0.0.6468
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for wavev32
CREATE DATABASE IF NOT EXISTS `wavev32` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `wavev32`;

-- Dumping structure for table wavev32.smartphone_accounts
CREATE TABLE IF NOT EXISTS `smartphone_accounts` (
  `id` int(11) NOT NULL,
  `app` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `password` varchar(50) NOT NULL,
  `birthdate` date DEFAULT current_timestamp(),
  `gender` varchar(50) DEFAULT NULL,
  `interested` varchar(50) DEFAULT NULL,
  `avatar` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `passions` text DEFAULT NULL,
  `cover` text DEFAULT NULL,
  `verify` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_accounts: ~0 rows (approximately)
DELETE FROM `smartphone_accounts`;

-- Dumping structure for table wavev32.smartphone_calls
CREATE TABLE IF NOT EXISTS `smartphone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(50) NOT NULL,
  `number` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `status` int(11) NOT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_calls: ~0 rows (approximately)
DELETE FROM `smartphone_calls`;

-- Dumping structure for table wavev32.smartphone_chats
CREATE TABLE IF NOT EXISTS `smartphone_chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(50) NOT NULL,
  `author` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `number` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_chats: ~0 rows (approximately)
DELETE FROM `smartphone_chats`;

-- Dumping structure for table wavev32.smartphone_chats_users
CREATE TABLE IF NOT EXISTS `smartphone_chats_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(50) NOT NULL,
  `number` varchar(50) NOT NULL,
  `admin` tinyint(4) NOT NULL DEFAULT 0,
  `author` varchar(50) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_chats_users: ~0 rows (approximately)
DELETE FROM `smartphone_chats_users`;

-- Dumping structure for table wavev32.smartphone_comments
CREATE TABLE IF NOT EXISTS `smartphone_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(50) NOT NULL,
  `post_id` int(11) NOT NULL,
  `author` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_comments: ~0 rows (approximately)
DELETE FROM `smartphone_comments`;

-- Dumping structure for table wavev32.smartphone_contacts
CREATE TABLE IF NOT EXISTS `smartphone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `number` varchar(50) NOT NULL,
  `display` varchar(50) NOT NULL,
  `bank` varchar(50) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_contacts: ~0 rows (approximately)
DELETE FROM `smartphone_contacts`;

-- Dumping structure for table wavev32.smartphone_followers
CREATE TABLE IF NOT EXISTS `smartphone_followers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `followed` varchar(50) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_followers: ~0 rows (approximately)
DELETE FROM `smartphone_followers`;

-- Dumping structure for table wavev32.smartphone_likes
CREATE TABLE IF NOT EXISTS `smartphone_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_likes: ~0 rows (approximately)
DELETE FROM `smartphone_likes`;

-- Dumping structure for table wavev32.smartphone_messages
CREATE TABLE IF NOT EXISTS `smartphone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_chat` int(11) NOT NULL,
  `owner` varchar(50) NOT NULL,
  `type` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `created` datetime NOT NULL,
  `read` tinyint(4) NOT NULL DEFAULT 0,
  `deleted` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `smartphone_messages` (`id_chat`) USING BTREE,
  CONSTRAINT `smartphone_messages` FOREIGN KEY (`id_chat`) REFERENCES `smartphone_chats` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_messages: ~0 rows (approximately)
DELETE FROM `smartphone_messages`;

-- Dumping structure for table wavev32.smartphone_messages_app
CREATE TABLE IF NOT EXISTS `smartphone_messages_app` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone` varchar(50) NOT NULL,
  `number` varchar(50) NOT NULL,
  `owner` varchar(50) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `read` tinyint(4) NOT NULL DEFAULT 0,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_messages_app: 0 rows
DELETE FROM `smartphone_messages_app`;
/*!40000 ALTER TABLE `smartphone_messages_app` DISABLE KEYS */;
/*!40000 ALTER TABLE `smartphone_messages_app` ENABLE KEYS */;

-- Dumping structure for table wavev32.smartphone_posts
CREATE TABLE IF NOT EXISTS `smartphone_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(50) NOT NULL,
  `author` varchar(50) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `filter` varchar(255) DEFAULT NULL,
  `hashtags` text DEFAULT NULL,
  `mentions` text DEFAULT NULL,
  `price` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_posts: ~0 rows (approximately)
DELETE FROM `smartphone_posts`;

-- Dumping structure for table wavev32.smartphone_settings
CREATE TABLE IF NOT EXISTS `smartphone_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `option` varchar(50) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_settings: ~0 rows (approximately)
DELETE FROM `smartphone_settings`;

-- Dumping structure for table wavev32.smartphone_stories
CREATE TABLE IF NOT EXISTS `smartphone_stories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(50) NOT NULL,
  `author` varchar(50) NOT NULL,
  `image` text NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `filter` varchar(255) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_stories: ~0 rows (approximately)
DELETE FROM `smartphone_stories`;

-- Dumping structure for table wavev32.smartphone_tinder_likes
CREATE TABLE IF NOT EXISTS `smartphone_tinder_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `id_liked` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table wavev32.smartphone_tinder_likes: ~0 rows (approximately)
DELETE FROM `smartphone_tinder_likes`;

-- Dumping structure for table wavev32.uniforms
CREATE TABLE IF NOT EXISTS `uniforms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text COLLATE armscii8_bin DEFAULT NULL,
  `permission` text COLLATE armscii8_bin DEFAULT NULL,
  `uniforms` text COLLATE armscii8_bin DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;

-- Dumping data for table wavev32.uniforms: ~0 rows (approximately)
DELETE FROM `uniforms`;

-- Dumping structure for table wavev32.wave_accounts
CREATE TABLE IF NOT EXISTS `wave_accounts` (
  `whitelist` tinyint(1) NOT NULL DEFAULT 0,
  `chars` int(1) NOT NULL DEFAULT 1,
  `gems` int(11) NOT NULL DEFAULT 0,
  `premium` int(11) NOT NULL DEFAULT 0,
  `predays` int(11) NOT NULL DEFAULT 0,
  `priority` int(3) NOT NULL DEFAULT 0,
  `login` varchar(25) NOT NULL DEFAULT '00/00/0000',
  `discord` varchar(50) NOT NULL DEFAULT '0',
  `steam` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`steam`) USING BTREE,
  KEY `steam` (`steam`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_accounts: ~0 rows (approximately)
DELETE FROM `wave_accounts`;

-- Dumping structure for table wavev32.wave_banneds
CREATE TABLE IF NOT EXISTS `wave_banneds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(100) NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `days` int(3) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_banneds: ~0 rows (approximately)
DELETE FROM `wave_banneds`;

-- Dumping structure for table wavev32.wave_characters
CREATE TABLE IF NOT EXISTS `wave_characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steam` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `serial` varchar(6) DEFAULT NULL,
  `name` varchar(50) DEFAULT 'Individuo',
  `name2` varchar(50) DEFAULT 'Indigente',
  `bank` int(11) NOT NULL DEFAULT 1500,
  `fines` int(11) NOT NULL DEFAULT 0,
  `garage` int(3) NOT NULL DEFAULT 1,
  `homes` int(3) NOT NULL DEFAULT 1,
  `prison` int(11) NOT NULL DEFAULT 0,
  `port` int(1) NOT NULL DEFAULT 0,
  `penal` int(1) NOT NULL DEFAULT 0,
  `deleted` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_characters: ~0 rows (approximately)
DELETE FROM `wave_characters`;

-- Dumping structure for table wavev32.wave_chests
CREATE TABLE IF NOT EXISTS `wave_chests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `weight` int(10) NOT NULL DEFAULT 0,
  `perm` varchar(100) NOT NULL,
  `logs` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_chests: ~0 rows (approximately)
DELETE FROM `wave_chests`;

-- Dumping structure for table wavev32.wave_entitydata
CREATE TABLE IF NOT EXISTS `wave_entitydata` (
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`dkey`),
  KEY `dkey` (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_entitydata: ~0 rows (approximately)
DELETE FROM `wave_entitydata`;

-- Dumping structure for table wavev32.wave_fines
CREATE TABLE IF NOT EXISTS `wave_fines` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `nuser_id` int(11) NOT NULL DEFAULT 0,
  `date` varchar(25) NOT NULL DEFAULT '00/00/0000',
  `price` int(11) NOT NULL DEFAULT 0,
  `text` text NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `id` (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `nuser_id` (`nuser_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_fines: ~0 rows (approximately)
DELETE FROM `wave_fines`;

-- Dumping structure for table wavev32.wave_playerdata
CREATE TABLE IF NOT EXISTS `wave_playerdata` (
  `user_id` int(11) NOT NULL,
  `dkey` varchar(100) NOT NULL,
  `dvalue` text DEFAULT NULL,
  PRIMARY KEY (`user_id`,`dkey`),
  KEY `user_id` (`user_id`),
  KEY `dkey` (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_playerdata: ~0 rows (approximately)
DELETE FROM `wave_playerdata`;

-- Dumping structure for table wavev32.wave_prison
CREATE TABLE IF NOT EXISTS `wave_prison` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `police` varchar(255) DEFAULT '0',
  `nuser_id` int(11) NOT NULL DEFAULT 0,
  `services` int(11) NOT NULL DEFAULT 0,
  `fines` int(11) NOT NULL DEFAULT 0,
  `text` longtext DEFAULT NULL,
  `date` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_prison: ~0 rows (approximately)
DELETE FROM `wave_prison`;

-- Dumping structure for table wavev32.wave_propertys
CREATE TABLE IF NOT EXISTS `wave_propertys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT 'Homes0001',
  `interior` varchar(255) NOT NULL DEFAULT 'Middle',
  `tax` int(20) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `price` int(11) NOT NULL DEFAULT 0,
  `residents` int(11) NOT NULL DEFAULT 1,
  `vault` int(11) NOT NULL DEFAULT 1,
  `fridge` int(11) NOT NULL DEFAULT 1,
  `owner` int(1) NOT NULL DEFAULT 0,
  `contract` int(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_propertys: ~0 rows (approximately)
DELETE FROM `wave_propertys`;

-- Dumping structure for table wavev32.wave_races
CREATE TABLE IF NOT EXISTS `wave_races` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `raceid` int(11) NOT NULL DEFAULT 0,
  `user_id` int(9) NOT NULL DEFAULT 0,
  `name` varchar(255) DEFAULT NULL,
  `vehicle` varchar(100) NOT NULL DEFAULT '0',
  `points` int(20) NOT NULL DEFAULT 0,
  `date` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_races: ~0 rows (approximately)
DELETE FROM `wave_races`;

-- Dumping structure for table wavev32.wave_vehicles
CREATE TABLE IF NOT EXISTS `wave_vehicles` (
  `user_id` int(11) NOT NULL,
  `vehicle` varchar(100) NOT NULL,
  `tax` int(20) NOT NULL DEFAULT 0,
  `plate` varchar(20) DEFAULT NULL,
  `hardness` int(1) NOT NULL DEFAULT 0,
  `rental` int(11) NOT NULL DEFAULT 0,
  `rendays` int(11) NOT NULL DEFAULT 0,
  `arrest` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL DEFAULT 0,
  `engine` int(11) NOT NULL DEFAULT 1000,
  `body` int(11) NOT NULL DEFAULT 1000,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `work` varchar(10) NOT NULL DEFAULT 'false',
  `doors` varchar(254) NOT NULL,
  `windows` varchar(254) NOT NULL,
  `tyres` varchar(254) NOT NULL,
  `brakes` varchar(254) NOT NULL,
  PRIMARY KEY (`user_id`,`vehicle`),
  KEY `user_id` (`user_id`),
  KEY `vehicle` (`vehicle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table wavev32.wave_vehicles: ~0 rows (approximately)
DELETE FROM `wave_vehicles`;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
