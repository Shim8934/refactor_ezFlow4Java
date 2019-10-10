-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: 10.0.102.8    Database: jmocha
-- ------------------------------------------------------
-- Server version	5.5.5-10.3.14-MariaDB

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
-- Table structure for table `approvconnscmc`
--

DROP TABLE IF EXISTS `approvconnscmc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approvconnscmc` (
  `MIS_KEY` varchar(64) DEFAULT NULL,
  `DOCID` char(20) DEFAULT NULL,
  `EMP_CD` varchar(20) DEFAULT NULL,
  `FORM_ID` varchar(10) DEFAULT NULL,
  `STATUS` char(3) DEFAULT NULL,
  `DRAFTDATE` datetime DEFAULT NULL,
  `ERRYN` char(1) DEFAULT NULL,
  `ERRMSG` varchar(2048) DEFAULT NULL,
  `ERRSYS` varchar(10) DEFAULT NULL,
  `SYS_TYPE` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `approvconnscsc`
--

DROP TABLE IF EXISTS `approvconnscsc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `approvconnscsc` (
  `index_id` varchar(32) NOT NULL,
  `docid` char(20) DEFAULT NULL,
  `writerid` varchar(100) DEFAULT NULL,
  `formid` varchar(10) DEFAULT NULL,
  `docstate` char(3) DEFAULT NULL,
  `draftdate` datetime DEFAULT NULL,
  `connhtml` longtext DEFAULT NULL,
  `conntitle` varchar(200) DEFAULT NULL,
  `docno` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_domain`
--

DROP TABLE IF EXISTS `james_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_domain` (
  `DOMAIN_NAME` varchar(100) NOT NULL,
  PRIMARY KEY (`DOMAIN_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_mail`
--

DROP TABLE IF EXISTS `james_mail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_mail` (
  `MAILBOX_ID` bigint(20) NOT NULL,
  `MAIL_UID` bigint(20) NOT NULL,
  `MAIL_IS_ANSWERED` bit(1) NOT NULL,
  `MAIL_BODY_START_OCTET` int(11) NOT NULL,
  `MAIL_CONTENT_OCTETS_COUNT` bigint(20) NOT NULL,
  `MAIL_IS_DELETED` bit(1) NOT NULL,
  `MAIL_IS_DRAFT` bit(1) NOT NULL,
  `MAIL_IS_FLAGGED` bit(1) NOT NULL,
  `MAIL_DATE` datetime DEFAULT NULL,
  `MAIL_MIME_TYPE` varchar(200) DEFAULT NULL,
  `MAIL_MODSEQ` bigint(20) DEFAULT NULL,
  `MAIL_IS_RECENT` bit(1) NOT NULL,
  `MAIL_IS_SEEN` bit(1) NOT NULL,
  `MAIL_MIME_SUBTYPE` varchar(200) DEFAULT NULL,
  `MAIL_TEXTUAL_LINE_COUNT` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MAILBOX_ID`,`MAIL_UID`),
  KEY `I_JMS_MIL_MAIL_IS_DELETED` (`MAIL_IS_DELETED`),
  KEY `I_JMS_MIL_MAIL_IS_RECENT` (`MAIL_IS_RECENT`),
  KEY `I_JMS_MIL_MAIL_IS_SEEN` (`MAIL_IS_SEEN`),
  KEY `I_JMS_MIL_MAIL_MODSEQ` (`MAIL_MODSEQ`),
  KEY `IDX_MAIL_DATE` (`MAIL_DATE`),
  CONSTRAINT `james_mail_ibfk_1` FOREIGN KEY (`MAILBOX_ID`) REFERENCES `james_mailbox` (`MAILBOX_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_mail_blob`
--

DROP TABLE IF EXISTS `james_mail_blob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_mail_blob` (
  `MAIL_BLOB_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `MAIL_BYTES` longblob NOT NULL,
  `MAIL_BODY_STRUCTURE` varchar(4000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `HEADER_BYTES` mediumblob NOT NULL,
  `MAILBOX_ID` bigint(20) DEFAULT NULL,
  `MAIL_UID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MAIL_BLOB_ID`),
  KEY `INDEX_MESSAGE_BLOB_MSG_ID` (`MAIL_BLOB_ID`),
  KEY `MAILBOX_ID` (`MAILBOX_ID`,`MAIL_UID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_mail_property`
--

DROP TABLE IF EXISTS `james_mail_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_mail_property` (
  `PROPERTY_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `PROPERTY_LINE_NUMBER` int(11) NOT NULL,
  `PROPERTY_LOCAL_NAME` varchar(500) NOT NULL,
  `PROPERTY_NAME_SPACE` varchar(500) NOT NULL,
  `PROPERTY_VALUE` varchar(1024) NOT NULL,
  `MAILBOX_ID` bigint(20) DEFAULT NULL,
  `MAIL_UID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PROPERTY_ID`),
  KEY `INDEX_PROPERTY_LINE_NUMBER` (`PROPERTY_LINE_NUMBER`),
  KEY `INDEX_PROPERTY_MSG_ID` (`PROPERTY_ID`),
  KEY `MAILBOX_ID` (`MAILBOX_ID`,`MAIL_UID`),
  CONSTRAINT `james_mail_property_ibfk_1` FOREIGN KEY (`MAILBOX_ID`, `MAIL_UID`) REFERENCES `james_mail` (`MAILBOX_ID`, `MAIL_UID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_mail_search`
--

DROP TABLE IF EXISTS `james_mail_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_mail_search` (
  `MAIL_SEARCH_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `ATTACHED_FILENAME` longtext DEFAULT NULL,
  `CONTENT` longtext DEFAULT NULL,
  `RECIPIENT` longtext DEFAULT NULL,
  `SENDER` mediumtext DEFAULT NULL,
  `SUBJECT` longtext DEFAULT NULL,
  `MAILBOX_ID` bigint(20) DEFAULT NULL,
  `MAIL_UID` bigint(20) DEFAULT NULL,
  `IMPORTANCE` int(1) DEFAULT NULL,
  `MESSAGE_ID` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`MAIL_SEARCH_ID`),
  KEY `MAILBOX_ID` (`MAILBOX_ID`,`MAIL_UID`),
  KEY `MESSAGE_ID` (`MESSAGE_ID`(191)),
  CONSTRAINT `james_mail_search_ibfk_1` FOREIGN KEY (`MAILBOX_ID`, `MAIL_UID`) REFERENCES `james_mail` (`MAILBOX_ID`, `MAIL_UID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_mail_userflag`
--

DROP TABLE IF EXISTS `james_mail_userflag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_mail_userflag` (
  `USERFLAG_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `USERFLAG_NAME` varchar(500) NOT NULL,
  `MAILBOX_ID` bigint(20) DEFAULT NULL,
  `MAIL_UID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`USERFLAG_ID`),
  KEY `MAILBOX_ID` (`MAILBOX_ID`,`MAIL_UID`),
  CONSTRAINT `james_mail_userflag_ibfk_1` FOREIGN KEY (`MAILBOX_ID`, `MAIL_UID`) REFERENCES `james_mail` (`MAILBOX_ID`, `MAIL_UID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_mailbox`
--

DROP TABLE IF EXISTS `james_mailbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_mailbox` (
  `MAILBOX_ID` bigint(20) NOT NULL,
  `MAILBOX_HIGHEST_MODSEQ` bigint(20) NOT NULL,
  `MAILBOX_LAST_UID` bigint(20) NOT NULL,
  `MAILBOX_NAME` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `MAILBOX_NAMESPACE` varchar(200) NOT NULL,
  `MAILBOX_UID_VALIDITY` bigint(20) NOT NULL,
  `USER_NAME` varchar(200) NOT NULL,
  PRIMARY KEY (`MAILBOX_ID`),
  KEY `I_JMS_LBX_USER_NAME` (`USER_NAME`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_recipient_rewrite`
--

DROP TABLE IF EXISTS `james_recipient_rewrite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_recipient_rewrite` (
  `DOMAIN_NAME` varchar(100) NOT NULL,
  `USER_NAME` varchar(100) NOT NULL,
  `TARGET_ADDRESS` varchar(20000) NOT NULL,
  PRIMARY KEY (`DOMAIN_NAME`,`USER_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_subscription`
--

DROP TABLE IF EXISTS `james_subscription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_subscription` (
  `SUBSCRIPTION_ID` bigint(20) NOT NULL,
  `MAILBOX_NAME` varchar(191) CHARACTER SET utf8mb4 NOT NULL,
  `USER_NAME` varchar(200) NOT NULL,
  PRIMARY KEY (`SUBSCRIPTION_ID`),
  UNIQUE KEY `U_JMS_PTN_USER_NAME` (`USER_NAME`,`MAILBOX_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_user`
--

DROP TABLE IF EXISTS `james_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_user` (
  `USER_NAME` varchar(100) NOT NULL,
  `PASSWORD_HASH_ALGORITHM` varchar(100) NOT NULL,
  `PASSWORD` varchar(128) NOT NULL,
  `version` int(11) DEFAULT NULL,
  PRIMARY KEY (`USER_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_addjob_master`
--

DROP TABLE IF EXISTS `jmocha_addjob_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_addjob_master` (
  `TENANT_ID` int(11) NOT NULL,
  `CN` varchar(20) NOT NULL,
  `DEPTID` varchar(20) NOT NULL,
  `TITLE` varchar(100) DEFAULT NULL,
  `TITLE2` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`CN`,`DEPTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_address_folder`
--

DROP TABLE IF EXISTS `jmocha_address_folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_address_folder` (
  `folder_id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `owner_id` varchar(100) DEFAULT NULL,
  `folder_type` char(1) DEFAULT NULL,
  `folder_name` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_address_general`
--

DROP TABLE IF EXISTS `jmocha_address_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_address_general` (
  `user_id` varchar(100) NOT NULL,
  `list_cnt` int(11) DEFAULT NULL,
  `list_type` char(4) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_address_info`
--

DROP TABLE IF EXISTS `jmocha_address_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_address_info` (
  `address_id` int(11) NOT NULL AUTO_INCREMENT,
  `folder_id` int(11) DEFAULT NULL,
  `owner_id` varchar(100) DEFAULT NULL,
  `creator_id` varchar(100) DEFAULT NULL,
  `creator_name` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `creator_name2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modifier_id` varchar(100) DEFAULT NULL,
  `modifier_name` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `modifier_name2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  `s_name` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_email` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_company` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_dept` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_title` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_company_phone` varchar(20) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_fax` varchar(20) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_mobile` varchar(20) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_homepage` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_company_zip` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_company_addr` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_home_zip` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_home_addr` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_memo` mediumtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `s_type` char(1) DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  KEY `owner_id` (`owner_id`,`s_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_address_search`
--

DROP TABLE IF EXISTS `jmocha_address_search`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_address_search` (
  `id` varchar(25) NOT NULL,
  `zip_code` varchar(5) DEFAULT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `old_address` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `fulltext_idx` (`address`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_address_simple`
--

DROP TABLE IF EXISTS `jmocha_address_simple`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_address_simple` (
  `simple_idx` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) DEFAULT NULL,
  `simple_name` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `simple_email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`simple_idx`),
  KEY `user_id_index` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_alias`
--

DROP TABLE IF EXISTS `jmocha_alias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_alias` (
  `target_address` varchar(100) NOT NULL,
  `alias_address` varchar(100) NOT NULL,
  PRIMARY KEY (`target_address`,`alias_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_connection_info`
--

DROP TABLE IF EXISTS `jmocha_connection_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_connection_info` (
  `SEQUENCE` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TENANT_ID` int(11) NOT NULL,
  `USERID` varchar(50) NOT NULL,
  `CONNECTIP` varchar(50) DEFAULT NULL,
  `CONNECTTIME` datetime DEFAULT NULL,
  `CONNECTBROWSER` varchar(10) DEFAULT NULL,
  `CONNECTOS` varchar(20) DEFAULT NULL,
  `CONNECTAGENT` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`SEQUENCE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_default_quota`
--

DROP TABLE IF EXISTS `jmocha_default_quota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_default_quota` (
  `DOMAIN_NAME` varchar(100) NOT NULL,
  `MAX_STORAGE` double DEFAULT 0,
  `WARN_STORAGE` double DEFAULT 0,
  PRIMARY KEY (`DOMAIN_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_dept_master`
--

DROP TABLE IF EXISTS `jmocha_dept_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_dept_master` (
  `TENANT_ID` int(11) NOT NULL,
  `CN` varchar(80) NOT NULL,
  `DISPLAYNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `DISPLAYNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USEFLAG` varchar(4) DEFAULT NULL,
  `MAIL` varchar(100) DEFAULT NULL,
  `COMPNM2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTLEVEL` varchar(12) DEFAULT NULL,
  `DEPT_CD_PATH` varchar(400) DEFAULT NULL,
  `DEPT_NM_PATH` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(400) DEFAULT NULL,
  `ADFLAG` varchar(4) DEFAULT NULL,
  `ADSPATH` varchar(400) DEFAULT NULL,
  `UPDATEDT` datetime DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`CN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_distribution`
--

DROP TABLE IF EXISTS `jmocha_distribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_distribution` (
  `DOMAIN_NAME` varchar(100) NOT NULL,
  `USER_NAME` varchar(100) NOT NULL,
  `COMPANY_ID` varchar(100) NOT NULL,
  `GROUP_NAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `MAIL` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`DOMAIN_NAME`,`USER_NAME`),
  KEY `foreign_keys_index` (`DOMAIN_NAME`,`USER_NAME`),
  CONSTRAINT `distribution_foreign_keys` FOREIGN KEY (`DOMAIN_NAME`, `USER_NAME`) REFERENCES `james_recipient_rewrite` (`DOMAIN_NAME`, `USER_NAME`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_distribution_sub`
--

DROP TABLE IF EXISTS `jmocha_distribution_sub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_distribution_sub` (
  `DOMAIN_NAME` varchar(100) NOT NULL,
  `USER_NAME` varchar(100) NOT NULL,
  `COMPANY_ID` varchar(100) NOT NULL,
  `SUB_MAIL` varchar(100) NOT NULL,
  `SUB_NAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  PRIMARY KEY (`DOMAIN_NAME`,`USER_NAME`,`SUB_MAIL`),
  KEY `foreign_keys_index` (`DOMAIN_NAME`,`USER_NAME`),
  CONSTRAINT `FK_distribution_sub` FOREIGN KEY (`DOMAIN_NAME`, `USER_NAME`) REFERENCES `jmocha_distribution` (`DOMAIN_NAME`, `USER_NAME`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_inbox_rule`
--

DROP TABLE IF EXISTS `jmocha_inbox_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_inbox_rule` (
  `RULE_ID` int(11) NOT NULL AUTO_INCREMENT,
  `RULE_NAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `USER_ID` varchar(100) NOT NULL,
  `IS_USE` varchar(1) NOT NULL,
  `PRIORITY` int(11) NOT NULL,
  PRIMARY KEY (`RULE_ID`),
  KEY `idx_jmocha_inbox_rule_USER_ID` (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_inbox_rule_sub`
--

DROP TABLE IF EXISTS `jmocha_inbox_rule_sub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_inbox_rule_sub` (
  `ITEM_ID` int(11) NOT NULL AUTO_INCREMENT,
  `RULE_ID` int(11) NOT NULL,
  `TYPE` varchar(45) NOT NULL,
  `KIND` varchar(45) NOT NULL,
  `VALUE` varchar(10000) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`ITEM_ID`),
  KEY `RULE_ID_idx` (`RULE_ID`),
  CONSTRAINT `RULE_ID` FOREIGN KEY (`RULE_ID`) REFERENCES `jmocha_inbox_rule` (`RULE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_letter`
--

DROP TABLE IF EXISTS `jmocha_letter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_letter` (
  `letter_no` int(11) NOT NULL AUTO_INCREMENT,
  `displayname` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `displayname2` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `letter_order` int(11) DEFAULT NULL,
  `letterbox_no` int(11) DEFAULT NULL,
  `letter_id` varchar(510) DEFAULT NULL,
  PRIMARY KEY (`letter_no`),
  KEY `letterbox_no_fk_idx` (`letterbox_no`),
  CONSTRAINT `letterbox_no_fk` FOREIGN KEY (`letterbox_no`) REFERENCES `jmocha_letterbox` (`letterbox_no`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_letterbox`
--

DROP TABLE IF EXISTS `jmocha_letterbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_letterbox` (
  `letterbox_no` int(11) NOT NULL AUTO_INCREMENT,
  `parent_letterbox_no` int(11) DEFAULT NULL,
  `displayname` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `displayname2` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `company_id` varchar(32) DEFAULT NULL,
  `tenant_id` mediumint(5) DEFAULT NULL,
  PRIMARY KEY (`letterbox_no`),
  KEY `parent_letterbox_idx` (`parent_letterbox_no`),
  KEY `company_id_idx` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_color`
--

DROP TABLE IF EXISTS `jmocha_mail_color`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_color` (
  `importance_color` varchar(45) DEFAULT NULL,
  `inmail_color` varchar(45) DEFAULT NULL,
  `outmail_color` varchar(45) DEFAULT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_copyright`
--

DROP TABLE IF EXISTS `jmocha_mail_copyright`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_copyright` (
  `TENANT_ID` int(11) NOT NULL,
  `COPYRIGHT_TEXT` varchar(1000) DEFAULT NULL,
  `COMPANY_ID` varchar(80) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_countryip`
--

DROP TABLE IF EXISTS `jmocha_mail_countryip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_countryip` (
  `START_IP` varchar(45) NOT NULL,
  `END_IP` varchar(45) NOT NULL,
  `START_IP_NUMBER` bigint(20) NOT NULL,
  `END_IP_NUMBER` bigint(20) NOT NULL,
  `COUNTRY_CODE` varchar(45) NOT NULL,
  `COUNTRY_NAME` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`END_IP_NUMBER`,`START_IP_NUMBER`),
  KEY `INDEX` (`START_IP_NUMBER`,`END_IP_NUMBER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_delete`
--

DROP TABLE IF EXISTS `jmocha_mail_delete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_delete` (
  `USER_ID` varchar(100) NOT NULL,
  `FOLDER_PATH` varchar(191) CHARACTER SET utf8mb4 NOT NULL,
  `EXPIRE_TIME` int(11) DEFAULT NULL,
  `DELETE_UNREAD` char(1) DEFAULT NULL,
  `FOLDER_NAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`FOLDER_PATH`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_forward`
--

DROP TABLE IF EXISTS `jmocha_mail_forward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_forward` (
  `userid` varchar(100) NOT NULL,
  `forward_address` varchar(100) NOT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_general`
--

DROP TABLE IF EXISTS `jmocha_mail_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_general` (
  `USER_ID` varchar(100) NOT NULL,
  `LIST_COUNT` int(11) DEFAULT NULL,
  `REFRESH_INTERVAL` int(11) DEFAULT NULL,
  `KEEP_DELETE_LENGTH` int(11) DEFAULT NULL,
  `PREVIEW_MODE` char(3) DEFAULT NULL,
  `PREVIEW_W_LIST` int(11) DEFAULT NULL,
  `PREVIEW_W_CONTENT` int(11) DEFAULT NULL,
  `PREVIEW_H_LIST` int(11) DEFAULT NULL,
  `PREVIEW_H_CONTENT` int(11) DEFAULT NULL,
  `MAIL_SENDER_NAME` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PREVIEW_SUBTREE` varchar(10) DEFAULT 'N',
  `PREVIEW_MAIL_IMAGE` varchar(10) DEFAULT 'Y',
  `TEXT_OPTION` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_outofoffice`
--

DROP TABLE IF EXISTS `jmocha_mail_outofoffice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_outofoffice` (
  `USER_ID` varchar(100) NOT NULL,
  `OOF_STATE` varchar(45) NOT NULL,
  `START_DATE` datetime NOT NULL,
  `END_DATE` datetime NOT NULL,
  `INTERNAL` varchar(8000) CHARACTER SET utf8mb4 NOT NULL,
  `EXTERNAL` varchar(8000) CHARACTER SET utf8mb4 NOT NULL,
  `EXTERNAL_AUDIENCE` varchar(45) NOT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_outofoffice_sent`
--

DROP TABLE IF EXISTS `jmocha_mail_outofoffice_sent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_outofoffice_sent` (
  `USER_ID` varchar(100) NOT NULL,
  `RECIPIENT_ID` varchar(100) NOT NULL,
  `SENT_TIME` datetime NOT NULL,
  PRIMARY KEY (`USER_ID`,`RECIPIENT_ID`),
  CONSTRAINT `outofoffice_sent_user_id` FOREIGN KEY (`USER_ID`) REFERENCES `jmocha_mail_outofoffice` (`USER_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_pop3`
--

DROP TABLE IF EXISTS `jmocha_mail_pop3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_pop3` (
  `pop3_idx` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(100) DEFAULT NULL,
  `pop3_server` varchar(50) DEFAULT NULL,
  `pop3_port` int(11) DEFAULT NULL,
  `pop3_user_id` varchar(300) DEFAULT NULL,
  `pop3_password` varchar(300) DEFAULT NULL,
  `save_folder_path` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `save_folder_name` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `delete_yn` char(1) DEFAULT NULL,
  `ssl_yn` int(11) DEFAULT NULL,
  PRIMARY KEY (`pop3_idx`),
  KEY `pop3_index` (`user_id`,`pop3_server`,`pop3_user_id`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_pop3_list`
--

DROP TABLE IF EXISTS `jmocha_mail_pop3_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_pop3_list` (
  `pop3_idx` int(11) NOT NULL,
  `message_id` varchar(200) NOT NULL,
  KEY `pop3_list_foreign_key_idx` (`pop3_idx`),
  CONSTRAINT `pop3_list_foreign_key` FOREIGN KEY (`pop3_idx`) REFERENCES `jmocha_mail_pop3` (`pop3_idx`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_read`
--

DROP TABLE IF EXISTS `jmocha_mail_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_read` (
  `USER_ID` varchar(100) NOT NULL,
  `MESSAGE_ID` varchar(200) NOT NULL,
  `READ_DATE` datetime DEFAULT NULL,
  `READER_EMAIL` varchar(100) NOT NULL,
  `READER_NAME` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`MESSAGE_ID`,`USER_ID`,`READER_EMAIL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_recall`
--

DROP TABLE IF EXISTS `jmocha_mail_recall`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_recall` (
  `recall_idx` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` varchar(200) DEFAULT NULL,
  `sender_email` varchar(100) DEFAULT NULL,
  `subject` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `recall_date` datetime DEFAULT NULL,
  PRIMARY KEY (`recall_idx`),
  KEY `recall_message_id_index` (`message_id`,`sender_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_recall_detail`
--

DROP TABLE IF EXISTS `jmocha_mail_recall_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_recall_detail` (
  `recall_idx` int(11) NOT NULL,
  `receiver_email` varchar(100) NOT NULL,
  `status` int(11) DEFAULT NULL,
  `del_date` datetime DEFAULT NULL,
  `receiver_name` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`recall_idx`,`receiver_email`),
  CONSTRAINT `recall_foreign_key` FOREIGN KEY (`recall_idx`) REFERENCES `jmocha_mail_recall` (`recall_idx`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_reserve`
--

DROP TABLE IF EXISTS `jmocha_mail_reserve`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_reserve` (
  `MESSAGE_ID` varchar(50) NOT NULL,
  `USER_ID` varchar(100) DEFAULT NULL,
  `SUBJECT` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SEND_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`MESSAGE_ID`),
  KEY `IDX_RESERVE_USER_ID` (`USER_ID`),
  KEY `IDX_RESERVE_SEND_DATE` (`SEND_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_secure`
--

DROP TABLE IF EXISTS `jmocha_mail_secure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_secure` (
  `secure_id` int(11) NOT NULL AUTO_INCREMENT,
  `mailbox_id` bigint(20) DEFAULT NULL,
  `mail_uid` bigint(20) DEFAULT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `password` varchar(128) DEFAULT NULL,
  `max_read_count` int(11) DEFAULT NULL,
  `max_read_date` datetime DEFAULT NULL,
  PRIMARY KEY (`secure_id`),
  KEY `fk_mail_secure_idx` (`mailbox_id`,`mail_uid`),
  CONSTRAINT `fk_mail_secure` FOREIGN KEY (`mailbox_id`, `mail_uid`) REFERENCES `james_mail` (`MAILBOX_ID`, `MAIL_UID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_secure_read`
--

DROP TABLE IF EXISTS `jmocha_mail_secure_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_secure_read` (
  `secure_id` int(11) NOT NULL,
  `reader_id` varchar(100) NOT NULL,
  `read_count` int(11) DEFAULT NULL,
  `read_date` datetime DEFAULT NULL,
  PRIMARY KEY (`secure_id`,`reader_id`),
  CONSTRAINT `fk_mail_secure_read` FOREIGN KEY (`secure_id`) REFERENCES `jmocha_mail_secure` (`secure_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_signature`
--

DROP TABLE IF EXISTS `jmocha_mail_signature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_signature` (
  `USER_ID` varchar(100) NOT NULL,
  `USE_FLAG` char(1) DEFAULT NULL,
  `CONTENT1` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENT2` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENT3` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_mail_signature_template`
--

DROP TABLE IF EXISTS `jmocha_mail_signature_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_signature_template` (
  `sign_no` int(11) NOT NULL AUTO_INCREMENT,
  `content` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `displayname` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `displayname2` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `tenant_id` mediumint(5) DEFAULT NULL,
  `company_id` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`sign_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_retired_user`
--

DROP TABLE IF EXISTS `jmocha_retired_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_retired_user` (
  `USER_NAME` varchar(100) NOT NULL,
  `PASSWORD_HASH_ALGORITHM` varchar(100) NOT NULL,
  `PASSWORD` varchar(128) NOT NULL,
  `version` int(11) DEFAULT NULL,
  PRIMARY KEY (`USER_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_scheduler_server`
--

DROP TABLE IF EXISTS `jmocha_scheduler_server`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_scheduler_server` (
  `scheduler` varchar(45) NOT NULL,
  `server` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`scheduler`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_shared_mailbox`
--

DROP TABLE IF EXISTS `jmocha_shared_mailbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_shared_mailbox` (
  `TENANT_ID` mediumint(5) NOT NULL,
  `SHARE_ID` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `USER_ID` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `DELETE_PERMISSION` varchar(4) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SEND_PERMISSION` varchar(4) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MANAGE_PERMISSION` varchar(4) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ORDERBY` int(11) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`SHARE_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_stat_mail_company_flow_day`
--

DROP TABLE IF EXISTS `jmocha_stat_mail_company_flow_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_stat_mail_company_flow_day` (
  `TENANT_ID` int(11) NOT NULL,
  `DT_DD` varchar(15) CHARACTER SET utf8mb4 NOT NULL,
  `SORGID` varchar(200) NOT NULL,
  `RORGID` varchar(200) NOT NULL,
  `CNT` int(11) DEFAULT 0,
  `MAILSIZE` bigint(20) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`DT_DD`,`SORGID`,`RORGID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_stat_mail_company_flow_month`
--

DROP TABLE IF EXISTS `jmocha_stat_mail_company_flow_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_stat_mail_company_flow_month` (
  `TENANT_ID` int(11) NOT NULL,
  `DT_MM` varchar(15) CHARACTER SET utf8mb4 NOT NULL,
  `SORGID` varchar(200) NOT NULL,
  `RORGID` varchar(200) NOT NULL,
  `CNT` int(11) DEFAULT 0,
  `MAILSIZE` bigint(20) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`DT_MM`,`SORGID`,`RORGID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_stat_mail_dept_day`
--

DROP TABLE IF EXISTS `jmocha_stat_mail_dept_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_stat_mail_dept_day` (
  `TENANT_ID` int(11) NOT NULL,
  `DT_DD` varchar(15) CHARACTER SET utf8mb4 NOT NULL,
  `DEPTID` varchar(200) NOT NULL,
  `ORGID` varchar(200) DEFAULT NULL,
  `RECEIVEINCNT` int(11) DEFAULT 0,
  `RECEIVEINSIZE` bigint(20) DEFAULT 0,
  `RECEIVEOUTCNT` int(11) DEFAULT 0,
  `RECEIVEOUTSIZE` bigint(20) DEFAULT 0,
  `SENDINCNT` int(11) DEFAULT 0,
  `SENDINSIZE` bigint(20) DEFAULT 0,
  `SENDOUTCNT` int(11) DEFAULT 0,
  `SENDOUTSIZE` bigint(20) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`DT_DD`,`DEPTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_stat_mail_dept_month`
--

DROP TABLE IF EXISTS `jmocha_stat_mail_dept_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_stat_mail_dept_month` (
  `TENANT_ID` int(11) NOT NULL,
  `DT_MM` varchar(15) CHARACTER SET utf8mb4 NOT NULL,
  `DEPTID` varchar(200) NOT NULL,
  `ORGID` varchar(200) DEFAULT NULL,
  `RECEIVEINCNT` int(11) DEFAULT 0,
  `RECEIVEINSIZE` bigint(20) DEFAULT 0,
  `RECEIVEOUTCNT` int(11) DEFAULT 0,
  `RECEIVEOUTSIZE` bigint(20) DEFAULT 0,
  `SENDINCNT` int(11) DEFAULT 0,
  `SENDINSIZE` bigint(20) DEFAULT 0,
  `SENDOUTCNT` int(11) DEFAULT 0,
  `SENDOUTSIZE` bigint(20) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`DT_MM`,`DEPTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_stat_mail_log`
--

DROP TABLE IF EXISTS `jmocha_stat_mail_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_stat_mail_log` (
  `IDX` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `TENANT_ID` int(11) NOT NULL,
  `LOG_DATE` datetime DEFAULT NULL,
  `EVENT_TYPE` varchar(20) DEFAULT NULL,
  `SENDER` varchar(200) DEFAULT NULL,
  `RECIPIENT` varchar(200) DEFAULT NULL,
  `TOTALBYTES` int(11) DEFAULT NULL,
  `MESSAGEID` varchar(500) DEFAULT NULL,
  `MESSAGESUBJECT` varchar(4000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SENDER_NAME` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECIPIENT_NAME` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHED_FILENAME` varchar(4000) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`IDX`),
  KEY `IDX_TENANT_ID` (`TENANT_ID`),
  KEY `IDX_LOG_DATE` (`LOG_DATE`),
  KEY `IDX_EVENT_TYPE` (`EVENT_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_stat_mail_user_day`
--

DROP TABLE IF EXISTS `jmocha_stat_mail_user_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_stat_mail_user_day` (
  `TENANT_ID` int(11) NOT NULL,
  `DT_DD` varchar(15) CHARACTER SET utf8mb4 NOT NULL,
  `USERID` varchar(20) NOT NULL,
  `DEPTID` varchar(200) NOT NULL,
  `ORGID` varchar(200) DEFAULT NULL,
  `RECEIVEINCNT` int(11) DEFAULT 0,
  `RECEIVEINSIZE` bigint(20) DEFAULT 0,
  `RECEIVEOUTCNT` int(11) DEFAULT 0,
  `RECEIVEOUTSIZE` bigint(20) DEFAULT 0,
  `SENDINCNT` int(11) DEFAULT 0,
  `SENDINSIZE` bigint(20) DEFAULT 0,
  `SENDOUTCNT` int(11) DEFAULT 0,
  `SENDOUTSIZE` bigint(20) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`DT_DD`,`USERID`,`DEPTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_stat_mail_user_month`
--

DROP TABLE IF EXISTS `jmocha_stat_mail_user_month`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_stat_mail_user_month` (
  `TENANT_ID` int(11) NOT NULL,
  `DT_MM` varchar(15) CHARACTER SET utf8mb4 NOT NULL,
  `USERID` varchar(20) NOT NULL,
  `DEPTID` varchar(200) NOT NULL,
  `ORGID` varchar(200) DEFAULT NULL,
  `RECEIVEINCNT` int(11) DEFAULT 0,
  `RECEIVEINSIZE` bigint(20) DEFAULT 0,
  `RECEIVEOUTCNT` int(11) DEFAULT 0,
  `RECEIVEOUTSIZE` bigint(20) DEFAULT 0,
  `SENDINCNT` int(11) DEFAULT 0,
  `SENDINSIZE` bigint(20) DEFAULT 0,
  `SENDOUTCNT` int(11) DEFAULT 0,
  `SENDOUTSIZE` bigint(20) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`DT_MM`,`USERID`,`DEPTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_stat_mailboxqty_info`
--

DROP TABLE IF EXISTS `jmocha_stat_mailboxqty_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_stat_mailboxqty_info` (
  `TENANT_ID` int(11) NOT NULL,
  `USERID` varchar(20) NOT NULL,
  `DT_MM` varchar(15) CHARACTER SET utf8mb4 NOT NULL,
  `QTY` bigint(20) DEFAULT 0,
  `ALLOT` bigint(20) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`USERID`,`DT_MM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_storage_warning_sent`
--

DROP TABLE IF EXISTS `jmocha_storage_warning_sent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_storage_warning_sent` (
  `USER_ID` varchar(100) NOT NULL,
  `SENT_TIME` datetime NOT NULL,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_tenant`
--

DROP TABLE IF EXISTS `jmocha_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_tenant` (
  `TENANT_ID` int(11) NOT NULL,
  `TENANT_NAME` varchar(100) NOT NULL,
  `TENANT_NAME2` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_tenant_config`
--

DROP TABLE IF EXISTS `jmocha_tenant_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_tenant_config` (
  `TENANT_ID` int(11) NOT NULL,
  `PROPERTY_NAME` varchar(100) NOT NULL,
  `PROPERTY_VALUE` varchar(1000) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`PROPERTY_NAME`),
  KEY `IDX_PROPERTY_NAME` (`PROPERTY_NAME`),
  CONSTRAINT `FK_TENANT_ID` FOREIGN KEY (`TENANT_ID`) REFERENCES `jmocha_tenant` (`TENANT_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_tenant_servername`
--

DROP TABLE IF EXISTS `jmocha_tenant_servername`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_tenant_servername` (
  `SERVER_NAME` varchar(100) NOT NULL,
  `TENANT_ID` int(11) NOT NULL,
  PRIMARY KEY (`SERVER_NAME`),
  KEY `TENANT_ID_idx` (`TENANT_ID`),
  CONSTRAINT `TENANT_ID` FOREIGN KEY (`TENANT_ID`) REFERENCES `jmocha_tenant` (`TENANT_ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_user_local_info`
--

DROP TABLE IF EXISTS `jmocha_user_local_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_user_local_info` (
  `TENANT_ID` int(11) NOT NULL,
  `USERID` varchar(50) NOT NULL,
  `TIMEZONE` varchar(10) NOT NULL,
  `LANG` varchar(1) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_user_master`
--

DROP TABLE IF EXISTS `jmocha_user_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_user_master` (
  `TENANT_ID` int(11) NOT NULL,
  `CN` varchar(80) NOT NULL,
  `DISPLAYNAME` varchar(120) CHARACTER SET utf8mb4 NOT NULL,
  `DISPLAYNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MAIL` varchar(100) DEFAULT NULL,
  `MAILNICKNAME` varchar(100) DEFAULT NULL,
  `UPNNAME` varchar(400) DEFAULT NULL,
  `DEPARTMENT` varchar(80) NOT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `DESCRIPTION2` varchar(200) DEFAULT NULL,
  `DESCRIPTION3` varchar(200) DEFAULT NULL,
  `PHYSICALDELIVERYOFFICENAME` varchar(160) DEFAULT NULL,
  `COMPANY` varchar(200) DEFAULT NULL,
  `COMPANY2` varchar(200) DEFAULT NULL,
  `TITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `HOMEPHONE` varchar(100) DEFAULT NULL,
  `FACSIMILETELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `MOBILE` varchar(100) DEFAULT NULL,
  `POSTALCODE` varchar(100) DEFAULT NULL,
  `STREETADDRESS` varchar(400) DEFAULT NULL,
  `INFO` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(2000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(2000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE102` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(200) DEFAULT NULL,
  `ADSPATH` varchar(200) DEFAULT NULL,
  `SIPURI` varchar(100) DEFAULT NULL,
  `UPDATEDT` datetime NOT NULL,
  `MOBILE_ENABLE` varchar(4) DEFAULT NULL,
  `MOBILE_NOTUSE` varchar(4) DEFAULT 'N',
  `MOBILE_PIN` varchar(4) DEFAULT NULL,
  `POSITIONCD` varchar(40) DEFAULT NULL,
  `BIRTH` varchar(20) DEFAULT NULL,
  `BIRTHTYPE` varchar(4) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  `IPADDRESS` varchar(15) DEFAULT NULL,
  `LASTLOGIN` datetime DEFAULT NULL,
  `LOGINCNT` int(11) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`CN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_user_master_retire`
--

DROP TABLE IF EXISTS `jmocha_user_master_retire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_user_master_retire` (
  `TENANT_ID` int(11) NOT NULL,
  `CN` varchar(80) NOT NULL,
  `DISPLAYNAME` varchar(120) CHARACTER SET utf8mb4 NOT NULL,
  `DISPLAYNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MAIL` varchar(100) DEFAULT NULL,
  `MAILNICKNAME` varchar(100) DEFAULT NULL,
  `UPNNAME` varchar(400) DEFAULT NULL,
  `DEPARTMENT` varchar(80) NOT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `DESCRIPTION2` varchar(200) DEFAULT NULL,
  `DESCRIPTION3` varchar(200) DEFAULT NULL,
  `PHYSICALDELIVERYOFFICENAME` varchar(160) DEFAULT NULL,
  `COMPANY` varchar(200) DEFAULT NULL,
  `COMPANY2` varchar(200) DEFAULT NULL,
  `TITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `HOMEPHONE` varchar(100) DEFAULT NULL,
  `FACSIMILETELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `MOBILE` varchar(100) DEFAULT NULL,
  `POSTALCODE` varchar(100) DEFAULT NULL,
  `STREETADDRESS` varchar(400) DEFAULT NULL,
  `INFO` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(2000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE102` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(200) DEFAULT NULL,
  `ADSPATH` varchar(200) DEFAULT NULL,
  `SIPURI` varchar(200) DEFAULT NULL,
  `UPDATEDT` datetime NOT NULL,
  `MOBILE_ENABLE` varchar(4) DEFAULT NULL,
  `MOBILE_NOTUSE` varchar(4) DEFAULT NULL,
  `MOBILE_PIN` varchar(4) DEFAULT NULL,
  `POSITIONCD` varchar(10) DEFAULT NULL,
  `BIRTH` varchar(10) DEFAULT NULL,
  `BIRTHTYPE` varchar(4) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`CN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jmocha_user_quota`
--

DROP TABLE IF EXISTS `jmocha_user_quota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_user_quota` (
  `USER_ID` varchar(100) NOT NULL,
  `MAX_STORAGE` double DEFAULT 0,
  `WARN_STORAGE` double DEFAULT 0,
  PRIMARY KEY (`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `openjpa_sequence_table`
--

DROP TABLE IF EXISTS `openjpa_sequence_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `openjpa_sequence_table` (
  `ID` tinyint(4) NOT NULL,
  `SEQUENCE_VALUE` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_add_info`
--

DROP TABLE IF EXISTS `road_name_add_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_add_info` (
  `관리번호` varchar(25) NOT NULL,
  `행정동코드` varchar(10) DEFAULT NULL,
  `행정동명` varchar(20) DEFAULT NULL,
  `우편번호` varchar(5) DEFAULT NULL,
  `우편번호일련번호` varchar(3) DEFAULT NULL,
  `다량배달처명` varchar(40) DEFAULT NULL,
  `건축물대장건물명` varchar(40) DEFAULT NULL,
  `시군구건물명` varchar(200) DEFAULT NULL,
  `공동주택여부` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`관리번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_add_info_change`
--

DROP TABLE IF EXISTS `road_name_add_info_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_add_info_change` (
  `관리번호` varchar(25) NOT NULL,
  `행정동코드` varchar(10) DEFAULT NULL,
  `행정동명` varchar(20) DEFAULT NULL,
  `우편번호` varchar(5) DEFAULT NULL,
  `우편번호일련번호` varchar(3) DEFAULT NULL,
  `다량배달처명` varchar(40) DEFAULT NULL,
  `건축물대장건물명` varchar(40) DEFAULT NULL,
  `시군구건물명` varchar(200) DEFAULT NULL,
  `공동주택여부` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`관리번호`),
  CONSTRAINT `변경분부가정보_FK` FOREIGN KEY (`관리번호`) REFERENCES `road_name_address_info_change` (`관리번호`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_address`
--

DROP TABLE IF EXISTS `road_name_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_address` (
  `관리번호` varchar(25) NOT NULL,
  `우편번호` varchar(5) DEFAULT NULL,
  `도로명주소` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`관리번호`),
  FULLTEXT KEY `fulltext_idx` (`도로명주소`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_address_info`
--

DROP TABLE IF EXISTS `road_name_address_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_address_info` (
  `관리번호` varchar(25) NOT NULL,
  `도로명코드` varchar(12) DEFAULT NULL,
  `읍면동일련번호` varchar(2) DEFAULT NULL,
  `지하여부` varchar(1) DEFAULT NULL,
  `건물본번` int(11) DEFAULT NULL,
  `건물부번` int(11) DEFAULT NULL,
  `기초구역번호` varchar(5) DEFAULT NULL,
  `변경사유코드` varchar(2) DEFAULT NULL,
  `고시일자` varchar(8) DEFAULT NULL,
  `변경전도로명주소` varchar(25) DEFAULT NULL,
  `상세주소부여여부` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`관리번호`),
  KEY `index` (`도로명코드`,`읍면동일련번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_address_info_change`
--

DROP TABLE IF EXISTS `road_name_address_info_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_address_info_change` (
  `관리번호` varchar(25) NOT NULL,
  `도로명코드` varchar(12) DEFAULT NULL,
  `읍면동일련번호` varchar(2) DEFAULT NULL,
  `지하여부` varchar(1) DEFAULT NULL,
  `건물본번` int(11) DEFAULT NULL,
  `건물부번` int(11) DEFAULT NULL,
  `기초구역번호` varchar(5) DEFAULT NULL,
  `변경사유코드` varchar(2) DEFAULT NULL,
  `고시일자` varchar(8) DEFAULT NULL,
  `변경전도로명주소` varchar(25) DEFAULT NULL,
  `상세주소부여여부` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`관리번호`),
  KEY `FK_idx` (`도로명코드`,`읍면동일련번호`),
  CONSTRAINT `변경분주소정보_FK` FOREIGN KEY (`도로명코드`, `읍면동일련번호`) REFERENCES `road_name_code_change` (`도로명코드`, `읍면동일련번호`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_code`
--

DROP TABLE IF EXISTS `road_name_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_code` (
  `도로명코드` varchar(12) NOT NULL,
  `도로명` varchar(80) DEFAULT NULL,
  `도로명로마자` varchar(80) DEFAULT NULL,
  `읍면동일련번호` varchar(2) NOT NULL,
  `시도명` varchar(20) DEFAULT NULL,
  `시도명로마자` varchar(40) DEFAULT NULL,
  `시군구명` varchar(20) DEFAULT NULL,
  `시군구명로마자` varchar(40) DEFAULT NULL,
  `읍면동명` varchar(20) DEFAULT NULL,
  `읍면동명로마자` varchar(40) DEFAULT NULL,
  `읍면동구분` varchar(1) DEFAULT NULL,
  `읍면동코드` varchar(3) DEFAULT NULL,
  `사용여부` varchar(1) DEFAULT NULL,
  `변경사유` varchar(1) DEFAULT NULL,
  `변경이력정보` varchar(14) DEFAULT NULL,
  `고시일자` varchar(8) DEFAULT NULL,
  `말소일자` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`도로명코드`,`읍면동일련번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_code_change`
--

DROP TABLE IF EXISTS `road_name_code_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_code_change` (
  `도로명코드` varchar(12) NOT NULL,
  `도로명` varchar(80) DEFAULT NULL,
  `도로명로마자` varchar(80) DEFAULT NULL,
  `읍면동일련번호` varchar(2) NOT NULL,
  `시도명` varchar(20) DEFAULT NULL,
  `시도명로마자` varchar(40) DEFAULT NULL,
  `시군구명` varchar(20) DEFAULT NULL,
  `시군구명로마자` varchar(40) DEFAULT NULL,
  `읍면동명` varchar(20) DEFAULT NULL,
  `읍면동명로마자` varchar(40) DEFAULT NULL,
  `읍면동구분` varchar(1) DEFAULT NULL,
  `읍면동코드` varchar(3) DEFAULT NULL,
  `사용여부` varchar(1) DEFAULT NULL,
  `변경사유` varchar(1) DEFAULT NULL,
  `변경이력정보` varchar(14) DEFAULT NULL,
  `고시일자` varchar(8) DEFAULT NULL,
  `말소일자` varchar(8) DEFAULT NULL,
  PRIMARY KEY (`도로명코드`,`읍면동일련번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_jibun_address`
--

DROP TABLE IF EXISTS `road_name_jibun_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_jibun_address` (
  `관리번호` varchar(25) NOT NULL,
  `지번주소` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`관리번호`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_jibun_info`
--

DROP TABLE IF EXISTS `road_name_jibun_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_jibun_info` (
  `관리번호` varchar(25) NOT NULL,
  `일련번호` varchar(3) NOT NULL,
  `법정동코드` varchar(10) DEFAULT NULL,
  `시도명` varchar(20) DEFAULT NULL,
  `시군구명` varchar(20) DEFAULT NULL,
  `법정읍면동명` varchar(20) DEFAULT NULL,
  `법정리명` varchar(20) DEFAULT NULL,
  `산여부` varchar(1) DEFAULT NULL,
  `지번본번` int(11) DEFAULT NULL,
  `지번부번` int(11) DEFAULT NULL,
  `대표여부` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`관리번호`,`일련번호`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `road_name_jibun_info_change`
--

DROP TABLE IF EXISTS `road_name_jibun_info_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `road_name_jibun_info_change` (
  `관리번호` varchar(25) NOT NULL,
  `일련번호` varchar(3) NOT NULL,
  `법정동코드` varchar(10) DEFAULT NULL,
  `시도명` varchar(20) DEFAULT NULL,
  `시군구명` varchar(20) DEFAULT NULL,
  `법정읍면동명` varchar(20) DEFAULT NULL,
  `법정리명` varchar(20) DEFAULT NULL,
  `산여부` varchar(1) DEFAULT NULL,
  `지번본번` int(11) DEFAULT NULL,
  `지번부번` int(11) DEFAULT NULL,
  `대표여부` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`관리번호`,`일련번호`),
  CONSTRAINT `변경분지번정보_FK` FOREIGN KEY (`관리번호`) REFERENCES `road_name_address_info_change` (`관리번호`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `search_index_approval`
--

DROP TABLE IF EXISTS `search_index_approval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_index_approval` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `DOCID` varchar(80) NOT NULL,
  `GUBUN` varchar(4) NOT NULL,
  `INSERTDATE` datetime NOT NULL,
  `STATUS` varchar(4) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `search_index_board`
--

DROP TABLE IF EXISTS `search_index_board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `search_index_board` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ITEMID` varchar(80) NOT NULL,
  `GUBUN` varchar(4) NOT NULL,
  `INSERTDATE` datetime NOT NULL,
  `STATUS` varchar(4) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `svtaskclass`
--

DROP TABLE IF EXISTS `svtaskclass`;
/*!50001 DROP VIEW IF EXISTS `svtaskclass`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `svtaskclass` AS SELECT 
 1 AS `CATEGORYCODE`,
 1 AS `CNAME`,
 1 AS `CNAME2`,
 1 AS `MCATEGORYCODE`,
 1 AS `MCNAME`,
 1 AS `MCNAME2`,
 1 AS `SUBCATEGORYCODE`,
 1 AS `SCNAME`,
 1 AS `SCNAME2`,
 1 AS `TASKCODE`,
 1 AS `TASKNAME`,
 1 AS `TASKNAME2`,
 1 AS `KEEPINGPERIOD`,
 1 AS `DISPLAYRECFLAG`,
 1 AS `SPECIALCATALOGFLAG`,
 1 AS `TEMPFLAG`,
 1 AS `COMPANYID`,
 1 AS `TENANT_ID`,
 1 AS `PROCESSDEPTCODE`,
 1 AS `PROCESSDEPTNAME`,
 1 AS `PROCESSDEPTNAME2`,
 1 AS `KEEPINGMETHOD`,
 1 AS `KEEPINGPLACE`,
 1 AS `DISPLAYRECTRASTIME`,
 1 AS `ISPUBLIC`,
 1 AS `ITEMSECURITY`,
 1 AS `DELFLAG`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `talk_tbl_adm_defalutserver`
--

DROP TABLE IF EXISTS `talk_tbl_adm_defalutserver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tbl_adm_defalutserver` (
  `ServerID` varchar(64) NOT NULL,
  PRIMARY KEY (`ServerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tbl_api_accesskey`
--

DROP TABLE IF EXISTS `talk_tbl_api_accesskey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tbl_api_accesskey` (
  `NAME` varchar(50) NOT NULL,
  `API` varchar(200) NOT NULL,
  `KEY` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tbladdjob`
--

DROP TABLE IF EXISTS `talk_tbladdjob`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tbladdjob` (
  `UserID` varchar(20) NOT NULL,
  `DeptID` varchar(50) NOT NULL,
  `Position` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL,
  `Position2` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OrderBy` varchar(100) DEFAULT NULL,
  `UpdateDate` datetime DEFAULT NULL,
  PRIMARY KEY (`UserID`,`DeptID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblauthlogintoken`
--

DROP TABLE IF EXISTS `talk_tblauthlogintoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblauthlogintoken` (
  `UserID` varchar(32) NOT NULL,
  `LToken` varchar(128) NOT NULL,
  `RegData` datetime NOT NULL,
  `CompID` varchar(32) NOT NULL,
  `Type` varchar(1) NOT NULL,
  PRIMARY KEY (`UserID`,`LToken`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblcompany`
--

DROP TABLE IF EXISTS `talk_tblcompany`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblcompany` (
  `CompID` varchar(32) NOT NULL,
  `CompName` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `CompName2` varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CompEmail` varchar(64) NOT NULL,
  `COrderBy` varchar(200) DEFAULT NULL,
  `UpdateDate` datetime NOT NULL,
  PRIMARY KEY (`CompID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tbldatelimit`
--

DROP TABLE IF EXISTS `talk_tbldatelimit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tbldatelimit` (
  `Type` varchar(50) NOT NULL,
  `Value` int(11) NOT NULL,
  `RegDate` datetime NOT NULL,
  PRIMARY KEY (`Type`,`RegDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tbldept`
--

DROP TABLE IF EXISTS `talk_tbldept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tbldept` (
  `DeptID` varchar(32) NOT NULL,
  `DeptName` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `DeptName2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DeptEmail` varchar(200) NOT NULL,
  `ParentDeptID` varchar(200) NOT NULL,
  `CompID` varchar(200) NOT NULL,
  `DOrderBy` varchar(200) DEFAULT NULL,
  `UpdateDate` datetime NOT NULL,
  PRIMARY KEY (`DeptID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tbldevice`
--

DROP TABLE IF EXISTS `talk_tbldevice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tbldevice` (
  `UserID` varchar(32) NOT NULL,
  `DeviceID` varchar(64) NOT NULL,
  `DeviceType` varchar(7) NOT NULL,
  `DeviceSubType` varchar(64) NOT NULL,
  `DeviceToken` varchar(256) NOT NULL,
  `PushState` char(1) NOT NULL,
  `RegDate` datetime NOT NULL,
  `CompID` varchar(32) NOT NULL,
  `NOTUSED` int(11) DEFAULT 0,
  PRIMARY KEY (`UserID`,`DeviceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblgroup`
--

DROP TABLE IF EXISTS `talk_tblgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblgroup` (
  `UserID` varchar(32) NOT NULL,
  `GroupID` varchar(32) NOT NULL,
  `Title` varchar(256) CHARACTER SET utf8mb4 NOT NULL,
  `CompID` varchar(32) NOT NULL,
  `UpdateDate` datetime DEFAULT NULL,
  PRIMARY KEY (`UserID`,`GroupID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblmember`
--

DROP TABLE IF EXISTS `talk_tblmember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblmember` (
  `OwnerID` varchar(32) NOT NULL,
  `GroupID` varchar(32) NOT NULL,
  `UserID` varchar(32) NOT NULL,
  `CompID` varchar(32) NOT NULL,
  `UpdateDate` datetime DEFAULT NULL,
  PRIMARY KEY (`OwnerID`,`GroupID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblmemberrelation`
--

DROP TABLE IF EXISTS `talk_tblmemberrelation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblmemberrelation` (
  `OwnerID` varchar(32) NOT NULL,
  `UserID` varchar(32) NOT NULL,
  `Flag` int(11) NOT NULL,
  `CompID` varchar(32) NOT NULL,
  PRIMARY KEY (`OwnerID`,`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblmessage`
--

DROP TABLE IF EXISTS `talk_tblmessage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblmessage` (
  `RoomID` varchar(36) NOT NULL,
  `Mseq` int(11) NOT NULL,
  `UserID` varchar(32) NOT NULL,
  `RegDate` varchar(14) CHARACTER SET utf8mb4 NOT NULL,
  `Message` varchar(8000) CHARACTER SET utf8mb4 NOT NULL,
  `FilePath` varchar(300) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ThumnailPath` varchar(300) CHARACTER SET utf8mb4 DEFAULT NULL,
  `Height` int(11) DEFAULT NULL,
  `Width` int(11) DEFAULT NULL,
  `Size` int(11) DEFAULT NULL,
  `Type` varchar(10) DEFAULT NULL,
  `CompID` varchar(32) NOT NULL,
  `FileLimit` varchar(14) DEFAULT NULL,
  PRIMARY KEY (`RoomID`,`Mseq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblmessage_backup`
--

DROP TABLE IF EXISTS `talk_tblmessage_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblmessage_backup` (
  `RoomID` varchar(36) NOT NULL,
  `Mseq` int(11) NOT NULL,
  `UserID` varchar(32) NOT NULL,
  `RegDate` varchar(14) CHARACTER SET utf8mb4 NOT NULL,
  `Message` varchar(8000) NOT NULL,
  `FilePath` varchar(300) DEFAULT NULL,
  `ThumnailPath` varchar(300) DEFAULT NULL,
  `Height` int(11) DEFAULT NULL,
  `Width` int(11) DEFAULT NULL,
  `Size` int(11) DEFAULT NULL,
  `Type` varchar(10) DEFAULT NULL,
  `CompID` varchar(32) NOT NULL,
  `FileLimit` varchar(14) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblnotification`
--

DROP TABLE IF EXISTS `talk_tblnotification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblnotification` (
  `ItemSeq` int(11) NOT NULL AUTO_INCREMENT,
  `UserID` varchar(100) DEFAULT NULL,
  `PostDate` datetime DEFAULT NULL,
  `Sender` varchar(100) DEFAULT NULL,
  `Subject` varchar(250) CHARACTER SET utf8mb4 DEFAULT NULL,
  `Type` int(11) DEFAULT NULL,
  `EtcData` varchar(200) DEFAULT NULL,
  `LinkURL` varchar(512) DEFAULT NULL,
  `ShowMsg` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`ItemSeq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblorgandeleteinfo`
--

DROP TABLE IF EXISTS `talk_tblorgandeleteinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblorgandeleteinfo` (
  `ID` varchar(32) NOT NULL,
  `Type` varchar(10) NOT NULL,
  `CompID` varchar(32) NOT NULL,
  `RegDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblroom`
--

DROP TABLE IF EXISTS `talk_tblroom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblroom` (
  `RoomID` varchar(36) NOT NULL,
  `UserID` varchar(32) NOT NULL,
  `CompID` varchar(32) NOT NULL,
  `SvrID` varchar(64) NOT NULL,
  `RoomType` varchar(2) NOT NULL,
  `RegDate` datetime NOT NULL,
  PRIMARY KEY (`RoomID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblroommember`
--

DROP TABLE IF EXISTS `talk_tblroommember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblroommember` (
  `RoomID` varchar(36) NOT NULL,
  `MemberID` varchar(32) NOT NULL,
  `Mseq` int(11) NOT NULL,
  `StartMSeq` int(11) NOT NULL,
  `CompID` varchar(32) NOT NULL,
  `RegDate` datetime NOT NULL,
  `DelFlag` varchar(1) NOT NULL,
  PRIMARY KEY (`RoomID`,`MemberID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblroommemberconfig`
--

DROP TABLE IF EXISTS `talk_tblroommemberconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblroommemberconfig` (
  `RoomID` varchar(36) NOT NULL,
  `MemberID` varchar(32) NOT NULL,
  `CompID` varchar(32) NOT NULL,
  `Title` varchar(128) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`RoomID`,`MemberID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblroomseq`
--

DROP TABLE IF EXISTS `talk_tblroomseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblroomseq` (
  `RoomID` varchar(36) NOT NULL,
  `UserID` varchar(32) NOT NULL,
  `MaxSeq` int(11) NOT NULL,
  `CompID` varchar(32) NOT NULL,
  PRIMARY KEY (`RoomID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblserverinfo`
--

DROP TABLE IF EXISTS `talk_tblserverinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblserverinfo` (
  `ID` varchar(64) NOT NULL,
  `IP` varchar(128) NOT NULL,
  `Port` int(11) NOT NULL,
  `Type` int(11) NOT NULL,
  `MaxSupport` int(11) NOT NULL,
  `NowConnect` int(11) NOT NULL,
  `Status` int(11) NOT NULL,
  `RelaySvrID` varchar(64) DEFAULT NULL,
  `Path` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tbluser`
--

DROP TABLE IF EXISTS `talk_tbluser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tbluser` (
  `UserID` varchar(32) NOT NULL,
  `PWD` varchar(32) NOT NULL,
  `Name` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `Name2` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `Email` varchar(100) NOT NULL,
  `DeptID` varchar(32) NOT NULL,
  `DeptName` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `DeptName2` varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CompID` varchar(32) NOT NULL,
  `CompName` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `CompName2` varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL,
  `Position` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `Position2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `Title` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `Title2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `Tel` varchar(200) DEFAULT NULL,
  `Mobile` varchar(200) DEFAULT NULL,
  `MainDept` int(11) DEFAULT NULL,
  `OrderBy` varchar(200) DEFAULT NULL,
  `ProfileImage` varchar(250) DEFAULT NULL,
  `ProfileImage_s` varchar(250) DEFAULT NULL,
  `UseMobile` varchar(1) DEFAULT NULL,
  `UpdateDate` datetime NOT NULL,
  `Furigana` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ExtensionPhone` varchar(100) DEFAULT NULL,
  `OfficeMobile` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tbluserinfo`
--

DROP TABLE IF EXISTS `talk_tbluserinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tbluserinfo` (
  `UserID` varchar(32) NOT NULL,
  `CompID` varchar(32) NOT NULL,
  `LoginToken` varchar(128) DEFAULT NULL,
  `Lang` char(1) DEFAULT NULL,
  `Message` varchar(256) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DefaultSvrID` varchar(64) DEFAULT NULL,
  `PCSvrID` varchar(64) DEFAULT NULL,
  `MoblieSvrID` varchar(64) DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `StatusMobile` int(11) DEFAULT NULL,
  `PCConnectTime` datetime DEFAULT NULL,
  `MobileConnectTime` datetime DEFAULT NULL,
  `PcDisconnectTime` datetime DEFAULT NULL,
  `MobileDisconnectTime` datetime DEFAULT NULL,
  `UpdateDate` datetime NOT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `talk_tblversion`
--

DROP TABLE IF EXISTS `talk_tblversion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `talk_tblversion` (
  `Type` varchar(50) NOT NULL,
  `Value` varchar(100) NOT NULL,
  `RegDate` datetime NOT NULL,
  PRIMARY KEY (`Type`,`RegDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_access_country`
--

DROP TABLE IF EXISTS `tbl_access_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_access_country` (
  `tenant_id` int(11) NOT NULL,
  `country_code` varchar(900) NOT NULL,
  PRIMARY KEY (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_access_id`
--

DROP TABLE IF EXISTS `tbl_access_id`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_access_id` (
  `ACCESSNO` int(11) NOT NULL AUTO_INCREMENT,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `CN` varchar(80) NOT NULL,
  PRIMARY KEY (`ACCESSNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_access_ip`
--

DROP TABLE IF EXISTS `tbl_access_ip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_access_ip` (
  `IPNO` int(11) NOT NULL AUTO_INCREMENT,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `IPADDRESS` varchar(100) NOT NULL,
  `ACCESS` varchar(10) DEFAULT 'YES',
  `EXPLANATION` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`IPNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_addjobmaster`
--

DROP TABLE IF EXISTS `tbl_addjobmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_addjobmaster` (
  `CN` varchar(80) NOT NULL,
  `DEPTID` varchar(80) NOT NULL,
  `TITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `POSITIONCD` varchar(40) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `ORDERBY` varchar(200) DEFAULT NULL,
  `JOBID` varchar(100) DEFAULT NULL,
  `PROXY` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`CN`,`DEPTID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_adminreceiptgroup_main`
--

DROP TABLE IF EXISTS `tbl_adminreceiptgroup_main`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_adminreceiptgroup_main` (
  `MAINID` bigint(10) NOT NULL AUTO_INCREMENT,
  `MAINNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`MAINID`,`TENANT_ID`,`COMPANYID`),
  UNIQUE KEY `IDX_TBL_ADMINRECEIPTGROUP_MAIN` (`TENANT_ID`,`COMPANYID`,`MAINID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_adminreceiptgroup_sub`
--

DROP TABLE IF EXISTS `tbl_adminreceiptgroup_sub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_adminreceiptgroup_sub` (
  `MAINID` bigint(10) NOT NULL,
  `SUBID` bigint(10) NOT NULL AUTO_INCREMENT,
  `DEPTID` varchar(400) DEFAULT NULL,
  `DEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `DEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`SUBID`,`TENANT_ID`,`COMPANYID`),
  UNIQUE KEY `IDX_TBL_ADMINRECEIPTGROUP_SUB` (`TENANT_ID`,`COMPANYID`,`SUBID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_addservice`
--

DROP TABLE IF EXISTS `tbl_admtool_addservice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_addservice` (
  `TENANTID` mediumint(5) NOT NULL,
  `TYPE` varchar(20) NOT NULL COMMENT '부가서비스 타입',
  `NOTE` varchar(20) DEFAULT NULL COMMENT '추가 입력사항',
  PRIMARY KEY (`TENANTID`,`TYPE`),
  KEY `TBL_ADMTOOL_ADDSERVICE_INDEX` (`TENANTID`),
  CONSTRAINT `TBL_ADMTOOL_ADDSERVICE_FK` FOREIGN KEY (`TENANTID`) REFERENCES `tbl_admtool_customer` (`TENANTID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_cancel_customer`
--

DROP TABLE IF EXISTS `tbl_admtool_cancel_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_cancel_customer` (
  `CANCELCUSTOMERID` int(11) NOT NULL AUTO_INCREMENT,
  `TENANTID` mediumint(5) NOT NULL,
  `COMPANYNAME` varchar(120) DEFAULT NULL COMMENT '회사이름',
  `COMPANYNAME2` varchar(120) DEFAULT NULL COMMENT '회사이름 (GLOBAL)',
  `MAILDOMAIN` varchar(100) DEFAULT NULL COMMENT '메일도메인',
  `CANCELMEMO` text DEFAULT NULL COMMENT '해지 사유',
  `REMARK` varchar(2000) DEFAULT NULL COMMENT '비고',
  `CANCELDATE` datetime DEFAULT NULL COMMENT '해지 신청일',
  `REMOVEDUEDATE` datetime DEFAULT NULL COMMENT '삭제(해지완료) 예정일',
  `REMOVEDATE` datetime DEFAULT NULL COMMENT '삭제 완료일',
  PRIMARY KEY (`CANCELCUSTOMERID`),
  KEY `TBL_ADMTOOL_CANCEL_CUST_INDEX` (`TENANTID`),
  CONSTRAINT `TBL_ADMTOOL_CANCEL_CUST_FK` FOREIGN KEY (`TENANTID`) REFERENCES `tbl_admtool_customer` (`TENANTID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_changerequest`
--

DROP TABLE IF EXISTS `tbl_admtool_changerequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_changerequest` (
  `CHANGEREQID` int(11) NOT NULL AUTO_INCREMENT,
  `TENANTID` mediumint(5) NOT NULL,
  `COMPANYNAME` varchar(120) NOT NULL COMMENT '회사 이름',
  `COMPANYNAME2` varchar(120) DEFAULT NULL COMMENT '회사 이름 (다국어)',
  `REQUSERID` varchar(80) NOT NULL COMMENT '신청자 아이디',
  `REQUSERNAME` varchar(120) NOT NULL COMMENT '신청자 이름',
  `REQUSERNAME2` varchar(120) DEFAULT NULL COMMENT '신청자 이름 (다국어)',
  `SUBJECT` varchar(20) NOT NULL COMMENT '변경 항목',
  `CONTENT` text NOT NULL COMMENT '변경 내용',
  `REMARK` varchar(2000) DEFAULT NULL COMMENT '비고',
  `REQDATE` datetime NOT NULL COMMENT '신청일',
  `STATUS` int(11) NOT NULL DEFAULT 0 COMMENT '처리 상태 (0:대기, 1:완료, 2:취소(관리자에 의한 취소), 3:신청취소(신청자에 의한 취소)',
  `CANCELMEMO` text DEFAULT NULL COMMENT '취소 사유',
  PRIMARY KEY (`CHANGEREQID`),
  KEY `TBL_ADMTOOL_CHANGEREQUEST_INDEX` (`TENANTID`),
  CONSTRAINT `TBL_ADMTOOL_CHANGEREQUEST_FK` FOREIGN KEY (`TENANTID`) REFERENCES `tbl_admtool_customer` (`TENANTID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_changerequest_attachments`
--

DROP TABLE IF EXISTS `tbl_admtool_changerequest_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_changerequest_attachments` (
  `ATTACHMENTID` int(11) NOT NULL AUTO_INCREMENT,
  `CHANGEREQID` int(11) NOT NULL,
  `FILENAME` varchar(255) NOT NULL COMMENT '파일 이름',
  `FILEPATH` varchar(800) NOT NULL COMMENT '파일 경로',
  `FILESIZE` bigint(20) NOT NULL COMMENT '파일 크기',
  `UPLOADDATE` datetime NOT NULL COMMENT '업로드 날짜',
  PRIMARY KEY (`ATTACHMENTID`),
  KEY `TBL_ADMTOOL_CHANGEREQ_ATTACH_INDEX` (`CHANGEREQID`),
  CONSTRAINT `TBL_ADMTOOL_CHANGEREQ_ATTACH_FK` FOREIGN KEY (`CHANGEREQID`) REFERENCES `tbl_admtool_changerequest` (`CHANGEREQID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_codelist`
--

DROP TABLE IF EXISTS `tbl_admtool_codelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_codelist` (
  `CODE` varchar(20) NOT NULL COMMENT '코드',
  `LANGUAGE` int(11) NOT NULL COMMENT '언어',
  `NAME` varchar(200) NOT NULL COMMENT '코드 이름',
  `DESCRIPTION` varchar(400) DEFAULT NULL COMMENT '코드 설명',
  PRIMARY KEY (`CODE`,`LANGUAGE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_customer`
--

DROP TABLE IF EXISTS `tbl_admtool_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_customer` (
  `TENANTID` mediumint(5) NOT NULL,
  `MAILDOMAIN` varchar(100) NOT NULL COMMENT '메인 메일 도메인',
  `DOMAIN` varchar(100) DEFAULT NULL COMMENT '사이트 도메인',
  `COMPANYNAME` varchar(120) NOT NULL COMMENT '회사 이름',
  `COMPANYNAME2` varchar(120) DEFAULT NULL COMMENT '회사 이름 (다국어)',
  `SELLERID` int(11) DEFAULT NULL COMMENT '판매자 아이디 번호',
  `ADMINID` varchar(80) NOT NULL,
  `REGDATE` datetime NOT NULL COMMENT '등록일',
  `OPENDATE` datetime DEFAULT NULL COMMENT '개통일',
  `STATUS` int(11) NOT NULL DEFAULT 1 COMMENT '청약 상태 (0: 해지, 1: 사용)',
  `SERVICESTATUS` int(11) NOT NULL DEFAULT 0 COMMENT '서비스 상태 (0: 대기, 1: 사용중, 2: 일시중지, 3: 강제중지, 4: 해지대기, 5: 해지완료)',
  `SERVICE` varchar(20) DEFAULT NULL COMMENT '가입 서비스',
  `PAIDUSERNUM` int(11) DEFAULT NULL COMMENT '유료 청약자수',
  `FREEUSERNUM` int(11) DEFAULT NULL COMMENT '무료 청약자수',
  `SERVICEYEAR` int(11) NOT NULL COMMENT '계약 기간',
  `USEADMPORTAL` int(11) NOT NULL COMMENT '관리자 포탈 이용여부 (0: 포탈 사용 안함, 1: 포탈 사용)',
  `CORPNUMBER` varchar(200) DEFAULT NULL COMMENT '법인등록번호',
  `BUSINUMBER` varchar(200) DEFAULT NULL COMMENT '사업자등록번호',
  `PRESIDENTNAME` varchar(120) DEFAULT NULL COMMENT '대표자명',
  `PRESIDENTNAME2` varchar(120) DEFAULT NULL COMMENT '대표자명 (다국어)',
  `PRESIDENTTELNUM` varchar(100) DEFAULT NULL COMMENT '대표자 연락번호',
  `PRESIDENTMAIL` varchar(100) DEFAULT NULL COMMENT '대표자 메일주소',
  `PRESIDENTGENDER` varchar(6) DEFAULT NULL COMMENT '대표자 성별',
  `PRESIDENTBIRTH` date DEFAULT NULL COMMENT '대표자 생년월일',
  `POSTALCODE` varchar(100) DEFAULT NULL COMMENT '우편번호',
  `ADDRESS` varchar(400) DEFAULT NULL COMMENT '주소',
  `COMPANYTYPE` varchar(45) DEFAULT NULL COMMENT '업종',
  `DEPUTYNAME` varchar(120) DEFAULT NULL COMMENT '대리인명',
  `DEPUTYNAME2` varchar(120) DEFAULT NULL COMMENT '대리인명 (다국어)',
  `DEPUTYGENDER` varchar(6) DEFAULT NULL COMMENT '대리인 성별',
  `DEPUTYBIRTH` date DEFAULT NULL COMMENT '대리인 생년월일',
  `DEPUTYTELNUM` varchar(100) DEFAULT NULL COMMENT '대리인 연락번호',
  `RELATION` varchar(120) DEFAULT NULL COMMENT '고객과의 관계',
  `PAYPERSONNAME` varchar(120) DEFAULT NULL COMMENT '요금납입책임자 이름',
  `PAYPERSONNAME2` varchar(120) DEFAULT NULL COMMENT '요금납입책임자 이름 (다국어)',
  `PPCORPNUMBER` varchar(200) DEFAULT NULL COMMENT '요금납입책임자 법인등록번호',
  `PPBUSINUMBER` varchar(200) DEFAULT NULL COMMENT '요금납입책임자 사업자등록번호',
  `PAYMENT` varchar(20) DEFAULT NULL COMMENT '납부방법',
  `PAYMENTDETAIL` varchar(600) DEFAULT NULL COMMENT '납부방법 상세',
  `STATEMENT` varchar(20) DEFAULT NULL COMMENT '명세서종류',
  `STATEMENTDETAIL` varchar(300) DEFAULT NULL COMMENT '명세서종류 상세',
  PRIMARY KEY (`TENANTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_customer_attachments`
--

DROP TABLE IF EXISTS `tbl_admtool_customer_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_customer_attachments` (
  `ATTACHMENTID` int(11) NOT NULL AUTO_INCREMENT,
  `TENANTID` mediumint(5) NOT NULL,
  `TYPE` int(11) NOT NULL COMMENT '첨부파일 타입 (0: 해지, 1: 청약/변경)',
  `FILENAME` varchar(255) NOT NULL COMMENT '파일 이름',
  `FILEPATH` varchar(800) NOT NULL COMMENT '파일 경로',
  `FILESIZE` bigint(20) NOT NULL COMMENT '파일 크기',
  `UPLOADDATE` datetime NOT NULL COMMENT '업로드 날짜',
  PRIMARY KEY (`ATTACHMENTID`),
  KEY `TBL_ADMTOOL_CUST_ATTACH_INDEX` (`TENANTID`),
  CONSTRAINT `TBL_ADMTOOL_CUST_ATTACH_FK` FOREIGN KEY (`TENANTID`) REFERENCES `tbl_admtool_customer` (`TENANTID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_history`
--

DROP TABLE IF EXISTS `tbl_admtool_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_history` (
  `HISTORYID` int(11) NOT NULL AUTO_INCREMENT,
  `TENANTID` mediumint(5) NOT NULL,
  `H_SUBJECT` varchar(20) NOT NULL COMMENT '변경 항목',
  `H_BEFORE` varchar(2000) DEFAULT NULL COMMENT '변경 전',
  `H_AFTER` varchar(2000) DEFAULT NULL COMMENT '변경 후',
  `REQUSERID` varchar(80) DEFAULT NULL COMMENT '신청자 아이디',
  `REQUSERNAME` varchar(120) DEFAULT NULL COMMENT '신청자 이름',
  `REQUSERNAME2` varchar(120) DEFAULT NULL COMMENT '신청자 이름 (다국어)',
  `UPDATEDATE` datetime NOT NULL COMMENT '변경일',
  PRIMARY KEY (`HISTORYID`),
  KEY `TBL_ADMTOOL_HISTORY_INDEX` (`TENANTID`),
  CONSTRAINT `TBL_ADMTOOL_HISTORY_FK` FOREIGN KEY (`TENANTID`) REFERENCES `tbl_admtool_customer` (`TENANTID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_notice`
--

DROP TABLE IF EXISTS `tbl_admtool_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_notice` (
  `NOTICEID` int(11) NOT NULL AUTO_INCREMENT,
  `TENANTID` mediumint(5) NOT NULL COMMENT '작성자 테넌트 아이디',
  `WRITERID` varchar(80) NOT NULL COMMENT '작성자 아이디',
  `TITLE` varchar(600) NOT NULL COMMENT '제목',
  `CONTENT` text DEFAULT NULL COMMENT '내용',
  `WRITERNAME` varchar(120) NOT NULL COMMENT '작성자 이름',
  `WRITERNAME2` varchar(120) DEFAULT NULL COMMENT '작성자 이름 (다국어)',
  `STARTDATE` datetime NOT NULL COMMENT '게시 시작일 (작성일)',
  `ENDDATE` datetime DEFAULT NULL COMMENT '게시 종료일',
  `POPSTARTDATE` datetime DEFAULT NULL COMMENT '팝업 시작일',
  `POPENDDATE` datetime DEFAULT NULL COMMENT '팝업 종료일',
  `POPPOSITION` varchar(12) DEFAULT NULL COMMENT '팝업 위치',
  `POPWIDTH` varchar(12) DEFAULT NULL COMMENT '팝업 너비',
  `POPHEIGHT` varchar(12) DEFAULT NULL COMMENT '팝업 높이',
  PRIMARY KEY (`NOTICEID`),
  KEY `TBL_ADMTOOL_NOTICE_INDEX` (`TENANTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_notice_attachments`
--

DROP TABLE IF EXISTS `tbl_admtool_notice_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_notice_attachments` (
  `ATTACHMENTID` int(11) NOT NULL AUTO_INCREMENT,
  `NOTICEID` int(11) NOT NULL,
  `FILENAME` varchar(255) NOT NULL COMMENT '파일 이름',
  `FILEPATH` varchar(800) NOT NULL COMMENT '파일 경로',
  `FILESIZE` bigint(20) NOT NULL COMMENT '파일 크기',
  `UPLOADDATE` datetime NOT NULL COMMENT '업로드 날짜',
  PRIMARY KEY (`ATTACHMENTID`),
  KEY `TBL_ADMTOOL_NOTICE_ATTACHMENTS_INDEX` (`NOTICEID`),
  CONSTRAINT `TBL_ADMTOOL_NOTICE_ATTACHMENTS_FK` FOREIGN KEY (`NOTICEID`) REFERENCES `tbl_admtool_notice` (`NOTICEID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_receivergroup`
--

DROP TABLE IF EXISTS `tbl_admtool_receivergroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_receivergroup` (
  `RECEIVERID` int(11) NOT NULL AUTO_INCREMENT,
  `RECEIVERCN` varchar(80) NOT NULL,
  `RECEIVERNAME` varchar(120) NOT NULL COMMENT '수신자 이름',
  `RECEIVERNAME2` varchar(120) DEFAULT NULL COMMENT '수신자 이름 (다국어)',
  `RECEIVERMAIL` varchar(100) NOT NULL COMMENT '수신자 메일',
  PRIMARY KEY (`RECEIVERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_admtool_seller`
--

DROP TABLE IF EXISTS `tbl_admtool_seller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_admtool_seller` (
  `SELLERID` int(11) NOT NULL AUTO_INCREMENT,
  `SELLERCN` varchar(80) NOT NULL COMMENT '판매자 아이디',
  `NAME` varchar(120) NOT NULL COMMENT '판매자 이름',
  `NAME2` varchar(120) DEFAULT NULL COMMENT '판매자 이름 (다국어)',
  `TELNUM` varchar(100) DEFAULT NULL COMMENT '판매자 연락번호',
  `DISTRIBUTORCODE` varchar(120) DEFAULT NULL COMMENT '유통코드',
  `DELETEFLAG` int(11) NOT NULL DEFAULT 1 COMMENT '삭제 여부 (0: 삭제, 1: 삭제안함)',
  `REGDATE` datetime NOT NULL,
  PRIMARY KEY (`SELLERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_apr_gamsaopinion`
--

DROP TABLE IF EXISTS `tbl_apr_gamsaopinion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_apr_gamsaopinion` (
  `SN` bigint(10) NOT NULL,
  `ORGDOCID` varchar(80) NOT NULL,
  `OPINIONID` varchar(80) NOT NULL,
  `OPINIONDOCNUM` bigint(10) NOT NULL,
  `FILEPATH` varchar(1020) DEFAULT NULL,
  `DELFLAG` varchar(2) NOT NULL DEFAULT 'N',
  `WRITEDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) NOT NULL,
  `WRITERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(400) NOT NULL,
  `WRITERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`SN`,`ORGDOCID`,`OPINIONID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_apr_isgsdoccategory`
--

DROP TABLE IF EXISTS `tbl_apr_isgsdoccategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_apr_isgsdoccategory` (
  `SN` bigint(10) NOT NULL,
  `DOCID` varchar(80) NOT NULL,
  `CODE2` varchar(12) NOT NULL,
  `CATEGORYNAME` varchar(100) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`SN`,`DOCID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_apr_jochidoc`
--

DROP TABLE IF EXISTS `tbl_apr_jochidoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_apr_jochidoc` (
  `DOCID` varchar(80) NOT NULL,
  `ORGDOCID` varchar(80) NOT NULL,
  `WRITEDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) NOT NULL,
  `WRITERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(400) NOT NULL,
  `WRITERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`DOCID`,`ORGDOCID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_apr_secure_list`
--

DROP TABLE IF EXISTS `tbl_apr_secure_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_apr_secure_list` (
  `DOCID` varchar(80) NOT NULL,
  `AUTHID` varchar(400) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`AUTHID`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprattachinfo`
--

DROP TABLE IF EXISTS `tbl_aprattachinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprattachinfo` (
  `DOCID` varchar(80) NOT NULL,
  `ATTACHFILESN` bigint(10) NOT NULL,
  `ATTACHFILENAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILESIZE` double(126,0) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(600) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BODYATTACH` varchar(4) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`ATTACHFILESN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprdocattachinfo`
--

DROP TABLE IF EXISTS `tbl_aprdocattachinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprdocattachinfo` (
  `DOCID` varchar(80) NOT NULL,
  `ATTACHSN` bigint(10) NOT NULL,
  `ATTACHDOCNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHDOCURL` varchar(1020) DEFAULT NULL,
  `SUBATTACHYN` varchar(4) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`ATTACHSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprdocgroupinfo`
--

DROP TABLE IF EXISTS `tbl_aprdocgroupinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprdocgroupinfo` (
  `DOCID` varchar(80) NOT NULL,
  `TABSN` bigint(10) NOT NULL,
  `GROUPDOCSN` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`GROUPDOCSN`,`TABSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprdocinfo`
--

DROP TABLE IF EXISTS `tbl_aprdocinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprdocinfo` (
  `DOCID` varchar(80) NOT NULL,
  `FORMID` varchar(40) DEFAULT NULL,
  `ORGDOCID` varchar(80) DEFAULT NULL,
  `DOCTYPE` varchar(12) DEFAULT NULL,
  `DOCSTATE` varchar(12) DEFAULT NULL,
  `FUNCTIONTYPE` varchar(12) DEFAULT NULL,
  `HREF` varchar(1020) DEFAULT NULL,
  `DOCTITLE` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DOCNO` varchar(200) DEFAULT NULL,
  `HASATTACHYN` varchar(4) DEFAULT NULL,
  `HASOPINIONYN` varchar(4) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) DEFAULT NULL,
  `WRITERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(400) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL COMMENT '공개여부(Y/N)',
  `WRITERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprdraftallgroup`
--

DROP TABLE IF EXISTS `tbl_aprdraftallgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprdraftallgroup` (
  `mainDocID` varchar(80) DEFAULT NULL,
  `subDocID` varchar(80) DEFAULT NULL,
  `tenant_id` mediumint(5) DEFAULT NULL,
  `companyID` varchar(20) DEFAULT NULL,
  `orderNum` mediumint(5) DEFAULT NULL,
  `createDate` datetime DEFAULT NULL,
  `aprMemberID` varchar(400) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprlinegroup`
--

DROP TABLE IF EXISTS `tbl_aprlinegroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprlinegroup` (
  `GROUPID` varchar(20) NOT NULL,
  `GROUPNAME` varchar(200) DEFAULT NULL,
  `GROUPORDER` bigint(10) DEFAULT NULL,
  `GROUPSUMMARY` varchar(20) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `UPDATEDATE` datetime DEFAULT NULL,
  `DELFLAG` varchar(5) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`GROUPID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='료비-결재그룹-그룹리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprlinegroupuser`
--

DROP TABLE IF EXISTS `tbl_aprlinegroupuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprlinegroupuser` (
  `GROUPID` varchar(20) NOT NULL,
  `USERID` varchar(80) NOT NULL,
  `DEPTID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`GROUPID`,`USERID`,`DEPTID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='료비-결재그룹-그룹 구성원 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprlineinfo`
--

DROP TABLE IF EXISTS `tbl_aprlineinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprlineinfo` (
  `DOCID` varchar(80) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `APRTYPE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERISDEPTYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(400) DEFAULT NULL,
  `RECEIVEDDATE` datetime DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `REASONDONOTAPPROV` varchar(1020) DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`APRMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_apropenhistory`
--

DROP TABLE IF EXISTS `tbl_apropenhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_apropenhistory` (
  `DOCID` varchar(80) NOT NULL,
  `USERID` varchar(40) NOT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `OPENDATE` datetime NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_apropinioninfo`
--

DROP TABLE IF EXISTS `tbl_apropinioninfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_apropinioninfo` (
  `DOCID` varchar(80) NOT NULL,
  `USERID` varchar(400) NOT NULL,
  `OPINIONGB` varchar(12) DEFAULT NULL COMMENT '001:일반의견, 002:반송의견, 003:보류의견, 004:회송의견',
  `CONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTID` varchar(400) DEFAULT NULL,
  `USERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OPINIONSN` bigint(10) NOT NULL,
  `USERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`USERID`(255),`OPINIONSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprpreviewinfo`
--

DROP TABLE IF EXISTS `tbl_aprpreviewinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprpreviewinfo` (
  `USERID` varchar(100) NOT NULL,
  `LISTCOUNT` bigint(10) DEFAULT NULL,
  `PREVIEW` varchar(100) DEFAULT NULL,
  `PREVIEWHLIST` bigint(10) DEFAULT 0,
  `PREVIEWHCONTENT` bigint(10) DEFAULT 0,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`USERID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprproxy_user`
--

DROP TABLE IF EXISTS `tbl_aprproxy_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprproxy_user` (
  `PROXYID` bigint(5) NOT NULL AUTO_INCREMENT COMMENT 'proxyAI',
  `USERID` varchar(100) NOT NULL COMMENT '유저아이디',
  `PROXYUSER` varchar(100) DEFAULT NULL COMMENT '대리아이디',
  `PROXYNAME` varchar(100) DEFAULT NULL COMMENT '대리이름',
  `PROXYNAME2` varchar(100) DEFAULT NULL COMMENT '대리이름2',
  `PROXYDEPTID` varchar(100) DEFAULT NULL COMMENT '대리부서ID',
  `PROXYDEPTNAME` varchar(100) DEFAULT NULL COMMENT '대리부서',
  `PROXYDEPTNAME2` varchar(100) DEFAULT NULL COMMENT '대리부서2',
  `PROXYSTARTTIME` varchar(100) DEFAULT NULL COMMENT '시간',
  `PROXYENDTIME` varchar(100) DEFAULT NULL COMMENT '시간',
  `PROXYCNT` mediumint(5) NOT NULL COMMENT '키값',
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `BUJAEREASON` varchar(45) DEFAULT '기타',
  PRIMARY KEY (`PROXYID`,`USERID`,`PROXYCNT`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_aprreceiptprocessinfo`
--

DROP TABLE IF EXISTS `tbl_aprreceiptprocessinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_aprreceiptprocessinfo` (
  `RECEIVESN` bigint(10) NOT NULL,
  `DOCID` varchar(80) NOT NULL,
  `SENTDEPTID` varchar(400) DEFAULT NULL,
  `SENTDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIVEDDEPTID` varchar(400) NOT NULL,
  `RECEIVEDDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DOCSTATE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSDOCID` varchar(80) DEFAULT NULL,
  `PROCESSORID` varchar(400) DEFAULT NULL,
  `PROCESSORNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSORJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PARENTSDOCID` varchar(80) DEFAULT NULL,
  `SENTDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIVEDDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSORNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSORJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECEIVESN`,`DOCID`,`RECEIVEDDEPTID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attendant`
--

DROP TABLE IF EXISTS `tbl_attendant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attendant` (
  `SCHEDULEID` bigint(10) NOT NULL,
  `ATTENDANTID` varchar(100) NOT NULL,
  `ATTENDANTNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `ATTENDANTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTENDANTDEPTNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `ATTENDANTDEPTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `STATUS` mediumint(5) NOT NULL,
  `RESPONSEDATE` datetime NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `companyid` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`SCHEDULEID`,`ATTENDANTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude`
--

DROP TABLE IF EXISTS `tbl_attitude`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude` (
  `ATTITUDE_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `COMPANY_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `WRITER_ID` varchar(80) NOT NULL,
  `DEPT_ID` varchar(80) NOT NULL,
  `START_DATE` datetime NOT NULL,
  `END_DATE` datetime DEFAULT NULL,
  `MODAPPL` char(1) DEFAULT '0',
  `REGION` varchar(200) DEFAULT NULL,
  `MOBILE` varchar(50) DEFAULT NULL,
  `BIZSUB` varchar(120) DEFAULT NULL,
  `CONTENT` varchar(3000) DEFAULT NULL,
  `IP` varchar(60) DEFAULT NULL,
  `DATE_TYPE` char(1) NOT NULL,
  `TYPE_ID` varchar(30) DEFAULT NULL COMMENT 'ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ',
  PRIMARY KEY (`ATTITUDE_ID`),
  KEY `dateIndex` (`TENANT_ID`,`WRITER_ID`,`START_DATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_annual`
--

DROP TABLE IF EXISTS `tbl_attitude_annual`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_annual` (
  `USER_ID` varchar(80) NOT NULL COMMENT '사원ID',
  `MONTHLY_HOLIDAY_CNT` decimal(4,1) NOT NULL DEFAULT 0.0 COMMENT '월차 수',
  `ANNUAL_HOLIDAY_CNT` decimal(4,1) NOT NULL DEFAULT 0.0 COMMENT '연차 수',
  `ADDITIONAL_HOLIDAY_CNT` decimal(4,1) NOT NULL DEFAULT 0.0 COMMENT '추가 연차 수',
  `JOIN_DATE` datetime DEFAULT NULL COMMENT '입사일',
  `COMPANY_ID` varchar(200) NOT NULL COMMENT '회사ID',
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트ID',
  PRIMARY KEY (`USER_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_annual_canappl`
--

DROP TABLE IF EXISTS `tbl_attitude_annual_canappl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_annual_canappl` (
  `ATTITUDE_ID` bigint(20) NOT NULL COMMENT '근태ID',
  `APPL_CNT` int(11) NOT NULL COMMENT '수정신청키',
  `COMPANY_ID` varchar(80) NOT NULL COMMENT '회사ID',
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트ID',
  `WRITER_ID` varchar(80) NOT NULL COMMENT '작성자ID',
  `WRITER_NAME` varchar(100) DEFAULT NULL COMMENT '작성자이름',
  `WRITER_NAME2` varchar(100) DEFAULT NULL COMMENT '작성자이름2',
  `WRITER_TITLE` varchar(200) DEFAULT NULL COMMENT '작성자직위',
  `WRITER_TITLE2` varchar(200) DEFAULT NULL COMMENT '작성자직위2',
  `WRITER_DEPT_ID` varchar(80) NOT NULL COMMENT '작성자부서ID',
  `WRITER_DEPT_NAME` varchar(100) DEFAULT NULL COMMENT '작성자부서이름',
  `WRITER_DEPT_NAME2` varchar(100) DEFAULT NULL COMMENT '작성자부서이름2',
  `DELFLAG` char(1) DEFAULT '0',
  `APPR_USER_ID` varchar(80) DEFAULT NULL COMMENT '승인자ID',
  `APPR_DATE` datetime DEFAULT NULL COMMENT '승인일시',
  `APPR_STATUS` char(1) DEFAULT '0' COMMENT '승인상태',
  `CONTENT` varchar(3000) DEFAULT NULL COMMENT '내용',
  `APPR_USER_NAME` varchar(100) DEFAULT NULL COMMENT '승인자이름',
  `APPR_USER_NAME2` varchar(100) DEFAULT NULL COMMENT '승인자이름2',
  `APPL_DATE` datetime DEFAULT NULL COMMENT '수정신청일시',
  PRIMARY KEY (`ATTITUDE_ID`,`APPL_CNT`,`COMPANY_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_annual_conf`
--

DROP TABLE IF EXISTS `tbl_attitude_annual_conf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_annual_conf` (
  `COMPANY_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `ANNUAL_CANCEL_RULE` char(1) NOT NULL DEFAULT '1',
  `USE_ANNUAL_AUTO_GNRT` char(1) NOT NULL DEFAULT '1',
  `ANNUAL_GNRT_STD` char(1) NOT NULL DEFAULT '1',
  `INITIAL_DATE` date DEFAULT NULL,
  `USE_MINUS_ANNUAL` char(1) NOT NULL DEFAULT '1',
  `USE_ANNUAL_TMNT` char(1) NOT NULL DEFAULT '1',
  `ROUND_OFF_RULE` char(1) NOT NULL DEFAULT '1',
  `CONF_SET_DATE` date NOT NULL,
  PRIMARY KEY (`COMPANY_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_annual_history`
--

DROP TABLE IF EXISTS `tbl_attitude_annual_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_annual_history` (
  `ANNUAL_HISTORY_ID` int(20) NOT NULL AUTO_INCREMENT COMMENT '연차수정기록ID',
  `USER_ID` varchar(80) NOT NULL COMMENT '사원ID',
  `ORIGIN_ANNUAL_CNT` decimal(4,1) NOT NULL COMMENT '기존연차수',
  `CHANGE_ANNUAL_CNT` decimal(4,1) NOT NULL COMMENT '수정연차수',
  `CHANGE_REASON` varchar(2000) DEFAULT NULL COMMENT '수정사유',
  `CHANGE_DATE` datetime NOT NULL COMMENT '수정일자',
  `CHANGE_USER_ID` varchar(80) NOT NULL COMMENT '수정자ID',
  `COMPANY_ID` varchar(200) NOT NULL COMMENT '회사ID',
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트ID',
  PRIMARY KEY (`ANNUAL_HISTORY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_apr_conn`
--

DROP TABLE IF EXISTS `tbl_attitude_apr_conn`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_apr_conn` (
  `ATTITUDE_ID` bigint(20) NOT NULL,
  `USER_ID` varchar(80) DEFAULT NULL,
  `ANNUAL_DOC_ID` varchar(80) NOT NULL,
  `CANCEL_DOC_ID` varchar(80) DEFAULT NULL,
  `ANNUAL_APPR_STATUS` char(1) DEFAULT NULL,
  `CANCEL_APPR_STATUS` char(1) DEFAULT NULL,
  `COMPANY_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ATTITUDE_ID`,`COMPANY_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_auth`
--

DROP TABLE IF EXISTS `tbl_attitude_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_auth` (
  `user_id` varchar(80) NOT NULL,
  `tenant_id` mediumint(5) NOT NULL,
  `auth_dept_id` varchar(80) NOT NULL,
  `company_id` varchar(80) DEFAULT NULL,
  `auth_type` varchar(10) NOT NULL DEFAULT 'R',
  PRIMARY KEY (`user_id`,`tenant_id`,`auth_dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_conf`
--

DROP TABLE IF EXISTS `tbl_attitude_conf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_conf` (
  `COMPANY_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `WORK_STARTTIME` varchar(40) NOT NULL DEFAULT '09:00',
  `WORK_ENDTIME` varchar(40) CHARACTER SET utf8mb4 NOT NULL DEFAULT '18:00',
  `CLOSED_DAY` varchar(30) NOT NULL DEFAULT '1,0,0,0,0,0,1',
  `ATTITUDE_MOD_APPL` char(1) NOT NULL DEFAULT '1',
  `CLOSED_DATE_ATTITUDE` char(1) NOT NULL DEFAULT '1',
  `CONF_SET_DATE` date NOT NULL,
  PRIMARY KEY (`COMPANY_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_form`
--

DROP TABLE IF EXISTS `tbl_attitude_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_form` (
  `FORM_ID` int(11) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `FORM_NAME` varchar(80) DEFAULT NULL,
  `FORM_NAME2` varchar(80) DEFAULT NULL,
  `FORM_HTML` varchar(3000) DEFAULT NULL,
  PRIMARY KEY (`FORM_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_modappl`
--

DROP TABLE IF EXISTS `tbl_attitude_modappl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_modappl` (
  `ATTITUDE_ID` bigint(20) NOT NULL,
  `APPL_CNT` int(11) NOT NULL,
  `COMPANY_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `WRITER_ID` varchar(80) NOT NULL,
  `WRITER_NAME` varchar(100) DEFAULT NULL,
  `WRITER_NAME2` varchar(100) DEFAULT NULL,
  `WRITER_TITLE` varchar(200) DEFAULT NULL,
  `WRITER_TITLE2` varchar(200) DEFAULT NULL,
  `WRITER_DEPT_ID` varchar(80) NOT NULL,
  `WRITER_DEPT_NAME` varchar(100) DEFAULT NULL,
  `WRITER_DEPT_NAME2` varchar(100) DEFAULT NULL,
  `ORIGIN_DATE` datetime NOT NULL,
  `CHANGE_DATE` datetime NOT NULL,
  `DELFLAG` char(1) DEFAULT '0',
  `APPR_USER_ID` varchar(80) DEFAULT NULL,
  `APPR_DATE` datetime DEFAULT NULL,
  `APPR_STATUS` char(1) DEFAULT '0',
  `CONTENT` varchar(3000) DEFAULT NULL,
  `APPR_USER_NAME` varchar(100) DEFAULT NULL,
  `APPR_USER_NAME2` varchar(100) DEFAULT NULL,
  `APPL_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`ATTITUDE_ID`,`APPL_CNT`,`COMPANY_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_modappl_history`
--

DROP TABLE IF EXISTS `tbl_attitude_modappl_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_modappl_history` (
  `ATTITUDE_ID` bigint(20) DEFAULT NULL,
  `MOD_CNT` int(11) NOT NULL AUTO_INCREMENT,
  `COMPANY_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `WRITER_ID` varchar(80) NOT NULL,
  `WRITER_NAME` varchar(100) DEFAULT NULL,
  `WRITER_NAME2` varchar(100) DEFAULT NULL,
  `WRITER_TITLE` varchar(200) DEFAULT NULL,
  `WRITER_TITLE2` varchar(200) DEFAULT NULL,
  `WRITER_DEPT_ID` varchar(80) NOT NULL,
  `WRITER_DEPT_NAME` varchar(100) DEFAULT NULL,
  `WRITER_DEPT_NAME2` varchar(100) DEFAULT NULL,
  `ORIGIN_STARTDATE` datetime DEFAULT NULL,
  `ORIGIN_ENDDATE` datetime DEFAULT NULL,
  `CHANGE_STARTDATE` datetime DEFAULT NULL,
  `CHANGE_ENDDATE` datetime DEFAULT NULL,
  `APPR_USER_ID` varchar(80) NOT NULL,
  `APPR_USER_NAME` varchar(100) DEFAULT NULL,
  `APPR_USER_NAME2` varchar(100) DEFAULT NULL,
  `APPR_DATE` datetime DEFAULT NULL,
  `ORIGIN_CONTENT` varchar(3000) DEFAULT NULL,
  `CHANGE_CONTENT` varchar(3000) DEFAULT NULL,
  `ORIGIN_REGION` varchar(200) DEFAULT NULL,
  `ORIGIN_MOBILE` varchar(50) DEFAULT NULL,
  `ORIGIN_BIZSUB` varchar(120) DEFAULT NULL,
  `ORIGIN_IP` varchar(60) DEFAULT NULL,
  `ORIGIN_TYPE_ID` varchar(30) DEFAULT NULL COMMENT 'ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ',
  `CHANGE_REGION` varchar(200) DEFAULT NULL,
  `CHANGE_MOBILE` varchar(50) DEFAULT NULL,
  `CHANGE_BIZSUB` varchar(120) DEFAULT NULL,
  `CHANGE_IP` varchar(60) DEFAULT NULL,
  `CHANGE_TYPE_ID` varchar(30) DEFAULT NULL COMMENT 'ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ',
  `ORIGIN_TYPE_NAME` varchar(120) DEFAULT NULL,
  `ORIGIN_TYPE_NAME2` varchar(120) DEFAULT NULL,
  `CHANGE_TYPE_NAME` varchar(120) DEFAULT NULL,
  `CHANGE_TYPE_NAME2` varchar(120) DEFAULT NULL,
  `ORIGIN_DATE_TYPE` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHANGE_DATE_TYPE` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`MOD_CNT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_type`
--

DROP TABLE IF EXISTS `tbl_attitude_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_type` (
  `ORDER` bigint(20) NOT NULL AUTO_INCREMENT,
  `TYPE_ID` varchar(30) NOT NULL,
  `COMPANY_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `TYPE_NAME` varchar(120) NOT NULL,
  `TYPE_NAME2` varchar(120) NOT NULL,
  `ISUSE` char(1) NOT NULL DEFAULT '1',
  `IMG_PATH` varchar(400) DEFAULT NULL,
  `PARENT_ID` varchar(30) DEFAULT NULL,
  `FORM_ID` int(11) NOT NULL,
  `ISADD` char(1) NOT NULL DEFAULT '0',
  `ISDEL` char(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ORDER`,`TYPE_ID`,`COMPANY_ID`,`TENANT_ID`),
  KEY `testIndex` (`COMPANY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_attitude_user_conf`
--

DROP TABLE IF EXISTS `tbl_attitude_user_conf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_attitude_user_conf` (
  `USER_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `WORK_STARTTIME` varchar(40) NOT NULL,
  `WORK_ENDTIME` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
  `COMPANY_ID` varchar(80) NOT NULL,
  `DEPT_ID` varchar(80) NOT NULL,
  PRIMARY KEY (`USER_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_audio_visualrecexinfo`
--

DROP TABLE IF EXISTS `tbl_audio_visualrecexinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_audio_visualrecexinfo` (
  `RECORDID` varchar(68) NOT NULL,
  `SEPERATEATTACHNO` varchar(8) NOT NULL,
  `SUMMARY` varchar(1020) DEFAULT NULL,
  `RECORDTYPE` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECORDID`,`SEPERATEATTACHNO`),
  CONSTRAINT `FK_TBL_AUDIO_VISUALRECEXINFO` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `RECORDID`, `SEPERATEATTACHNO`) REFERENCES `tbl_seperateattach` (`TENANT_ID`, `COMPANYID`, `RECORDID`, `SEPERATEATTACHNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_audio_visualrecexinfo_temp`
--

DROP TABLE IF EXISTS `tbl_audio_visualrecexinfo_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_audio_visualrecexinfo_temp` (
  `DOCID` char(20) NOT NULL,
  `RECORDID` varchar(68) DEFAULT NULL,
  `SEPERATEATTACHNO` varchar(8) NOT NULL,
  `SUMMARY` varchar(1020) DEFAULT NULL,
  `RECORDTYPE` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`DOCID`,`TENANT_ID`,`COMPANYID`,`SEPERATEATTACHNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_autodocnum_item`
--

DROP TABLE IF EXISTS `tbl_autodocnum_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_autodocnum_item` (
  `FORMID` char(10) NOT NULL,
  `KEEPPERIOD` varchar(8) DEFAULT NULL,
  `SECURITYLEVEL` varchar(4) DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL,
  `ITEMCODE` varchar(20) DEFAULT NULL,
  `ITEMNAME` varchar(100) DEFAULT NULL,
  `ITEMNAME2` varchar(100) DEFAULT NULL,
  `USEFLAG` varchar(1) DEFAULT NULL,
  `KEEPPERIODCODE` varchar(100) DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`FORMID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_apprlist`
--

DROP TABLE IF EXISTS `tbl_board_apprlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_apprlist` (
  `BOARDID` varchar(76) NOT NULL COMMENT '게시판ID',
  `APPRUSERID` varchar(40) NOT NULL COMMENT '승인자',
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`,`APPRUSERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='게시판 승인 권한';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_boardbackgroundinfo`
--

DROP TABLE IF EXISTS `tbl_board_boardbackgroundinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_boardbackgroundinfo` (
  `BACKGROUNDID` varchar(510) NOT NULL,
  `ORGFILENAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SAVEFILENAME` varchar(510) DEFAULT NULL,
  `REGUSERID` varchar(510) DEFAULT NULL,
  `REGDATE` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ISUSE` varchar(510) DEFAULT NULL,
  `SN` varchar(510) DEFAULT NULL,
  `WIDTH` varchar(510) DEFAULT NULL,
  `HEIGHT` varchar(510) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`BACKGROUNDID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_boardinfo`
--

DROP TABLE IF EXISTS `tbl_board_boardinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_boardinfo` (
  `BOARDID` varchar(510) NOT NULL,
  `BOARDNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BOARDNAME2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TREEVIEWORDER` int(11) DEFAULT NULL,
  `BOARDLEVEL` int(11) DEFAULT NULL,
  `PARENTBOARDID` varchar(510) DEFAULT NULL,
  `BOARDDESCRIPTION` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ITEMEXPIRES` int(11) DEFAULT NULL,
  `ATTACHSIZELIMIT` varchar(510) DEFAULT NULL,
  `REPLYNOTIFY` int(11) DEFAULT NULL,
  `BOARDGROUPID` varchar(510) DEFAULT NULL,
  `ALERTPOSTITEM` int(11) DEFAULT NULL,
  `GUBUN` int(11) DEFAULT NULL,
  `URL` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DELETEAFTER` int(11) DEFAULT NULL,
  `BOARDCOLOR` varchar(510) DEFAULT NULL,
  `BOARDNO` int(11) DEFAULT NULL,
  `PORTLET` varchar(2) DEFAULT NULL,
  `ONELINEREPLY` varchar(2) DEFAULT NULL,
  `BOARDTREEPATH` varchar(1600) DEFAULT NULL,
  `BACKGROUND` varchar(4) DEFAULT NULL,
  `FORMLOCATION` varchar(400) DEFAULT NULL,
  `FORMFLAG` varchar(4) DEFAULT NULL,
  `MAILFLAG` varchar(4) DEFAULT NULL,
  `APPRFLAG` varchar(4) DEFAULT NULL,
  `APPRMAILFLAG` varchar(4) DEFAULT NULL,
  `ATTRIBUTEYN` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(80) DEFAULT NULL,
  `LIKEFLAG` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`BOARDID`(255),`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_boardinfo_attribute`
--

DROP TABLE IF EXISTS `tbl_board_boardinfo_attribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_boardinfo_attribute` (
  `BOARDID` varchar(76) NOT NULL,
  `TABLECOL` varchar(100) NOT NULL,
  `SN` smallint(3) DEFAULT NULL,
  `COLNAME1` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COLNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `VALUE` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COLTYPE` varchar(100) DEFAULT NULL,
  `MUST` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`,`TABLECOL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_boardmanage`
--

DROP TABLE IF EXISTS `tbl_board_boardmanage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_boardmanage` (
  `BOARDID` varchar(76) NOT NULL,
  `ACCESSID` varchar(40) NOT NULL,
  `ACCESSNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ACCESSNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ACCESSLEVEL` bigint(10) DEFAULT NULL,
  `ACCESS_` bigint(10) DEFAULT NULL,
  `PARENTBOARDID` varchar(76) DEFAULT NULL,
  `BOARDADMIN_FG` varchar(10) DEFAULT NULL,
  `LISTVIEW_FG` varchar(10) DEFAULT NULL,
  `READ_FG` varchar(10) DEFAULT NULL,
  `WRITE_FG` varchar(10) DEFAULT NULL,
  `REPLY_FG` varchar(10) DEFAULT NULL,
  `DELETE_FG` varchar(10) DEFAULT NULL,
  `INHERIT_FG` varchar(10) DEFAULT NULL,
  `POSTNOTICE` varchar(10) DEFAULT NULL,
  `BOARDGROUPACL` varchar(2) DEFAULT 'Y',
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(80) DEFAULT NULL,
  `TYPE` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`,`ACCESSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_configuration`
--

DROP TABLE IF EXISTS `tbl_board_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_configuration` (
  `USERID` varchar(100) NOT NULL,
  `LISTCOUNT` bigint(10) DEFAULT NULL,
  `PREVIEW` varchar(100) DEFAULT NULL,
  `PREVIEWWLIST` bigint(10) DEFAULT 0,
  `PREVIEWWCONTENT` bigint(10) DEFAULT 0,
  `PREVIEWHLIST` bigint(10) DEFAULT 0,
  `PREVIEWHCONTENT` bigint(10) DEFAULT 0,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_deletereservedboard`
--

DROP TABLE IF EXISTS `tbl_board_deletereservedboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_deletereservedboard` (
  `BOARDID` varchar(76) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_deletereserveditem`
--

DROP TABLE IF EXISTS `tbl_board_deletereserveditem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_deletereserveditem` (
  `BOARDID` varchar(76) NOT NULL,
  `ITEMID` varchar(76) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`,`ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_item`
--

DROP TABLE IF EXISTS `tbl_board_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_item` (
  `ITEMID` varchar(80) NOT NULL,
  `BOARDID` varchar(80) NOT NULL,
  `WRITERID` varchar(80) DEFAULT NULL,
  `WRITERNAME` varchar(120) DEFAULT NULL,
  `WRITERNAME2` varchar(120) DEFAULT NULL,
  `WRITERDEPTID` varchar(80) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(120) DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(120) DEFAULT NULL,
  `WRITERCOMPANYID` varchar(80) DEFAULT NULL,
  `WRITERCOMPANYNAME` varchar(100) DEFAULT NULL,
  `WRITERCOMPANYNAME2` varchar(100) DEFAULT NULL,
  `WRITEDATE` varchar(40) DEFAULT NULL,
  `PARENTWRITEDATE` decimal(19,0) DEFAULT NULL,
  `UPDATEDATE` varchar(40) DEFAULT NULL,
  `IMPORTANCE` bigint(10) DEFAULT NULL,
  `TITLE` varchar(400) DEFAULT NULL,
  `CONTENTLOCATION` varchar(400) DEFAULT NULL,
  `READCOUNT` bigint(10) DEFAULT NULL,
  `STARTDATE` varchar(40) DEFAULT NULL,
  `ENDDATE` varchar(40) DEFAULT NULL,
  `ABSTRACT` varchar(800) DEFAULT NULL,
  `ATTACHMENTS` varchar(2) DEFAULT NULL,
  `UPPERITEMIDTREE` longtext DEFAULT NULL,
  `ITEMLEVEL` bigint(10) DEFAULT NULL,
  `COPIEDITEM` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE32` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(4000) DEFAULT NULL,
  `DOCNO` decimal(19,0) DEFAULT NULL,
  `DOCPASSWORD` varchar(2000) DEFAULT NULL,
  `MAINCONTENT` longtext DEFAULT NULL,
  `NOTINO` decimal(19,0) DEFAULT NULL,
  `TOPWRITERID` varchar(40) DEFAULT NULL,
  `APPRFLAG` varchar(4) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `CONTENT` longtext DEFAULT NULL,
  `PARENTWRITEDATE2` varchar(40) DEFAULT NULL,
  `DELFLAG` char(1) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`),
  KEY `writedate` (`WRITEDATE`,`PARENTWRITEDATE`),
  KEY `writedate1` (`WRITEDATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_item_attachhistory`
--

DROP TABLE IF EXISTS `tbl_board_item_attachhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_item_attachhistory` (
  `BOARDID` varchar(80) NOT NULL,
  `ITEMID` varchar(80) NOT NULL,
  `ATTACHFILENAME` varchar(1020) DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) DEFAULT NULL,
  `ATTACHFILESIZE` varchar(400) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `MODIFYSN` bigint(10) NOT NULL,
  `MODIFYFLAG` varchar(80) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`BOARDID`,`ITEMID`,`MODIFYSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_item_attachments`
--

DROP TABLE IF EXISTS `tbl_board_item_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_item_attachments` (
  `ITEMID` varchar(76) NOT NULL,
  `GUID` varchar(76) NOT NULL,
  `FILEPATH` varchar(800) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FILESIZE` varchar(100) DEFAULT NULL,
  `FILENAME` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`,`GUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_item_history`
--

DROP TABLE IF EXISTS `tbl_board_item_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_item_history` (
  `BOARDID` varchar(80) NOT NULL,
  `ITEMID` varchar(80) NOT NULL,
  `MODIFYSN` bigint(10) NOT NULL,
  `MODIFYUSERID` varchar(400) DEFAULT NULL,
  `MODIFYUSERNAME` varchar(200) DEFAULT NULL,
  `MODIFYUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `MODIFYUSERDEPTID` varchar(400) DEFAULT NULL,
  `MODIFYUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `MODIFYPART` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  `MODIFYFLAG` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`BOARDID`,`ITEMID`,`MODIFYSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_item_listoption`
--

DROP TABLE IF EXISTS `tbl_board_item_listoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_item_listoption` (
  `LISTTYPE` varchar(4) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `NAME1` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `NAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `NAME3` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `NAME4` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COLNAME` varchar(200) NOT NULL,
  `WIDTH` bigint(10) NOT NULL,
  `VIEW_FG` varchar(4) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`LISTTYPE`,`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_item_listoption_boar`
--

DROP TABLE IF EXISTS `tbl_board_item_listoption_boar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_item_listoption_boar` (
  `BOARDID` varchar(76) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `NAME1` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `NAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `NAME3` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `NAME4` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COLNAME` varchar(200) NOT NULL,
  `WIDTH` bigint(10) NOT NULL,
  `VIEW_FG` varchar(4) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  UNIQUE KEY `PK_TBL_BOARD_ITEM_LISTOPTION_2` (`TENANT_ID`,`BOARDID`,`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_item_read`
--

DROP TABLE IF EXISTS `tbl_board_item_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_item_read` (
  `BOARDID` varchar(76) NOT NULL,
  `ITEMID` varchar(76) NOT NULL,
  `USERID` varchar(100) NOT NULL,
  `USERNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERCOMPANYNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERCOMPANYNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `READDATE` datetime DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`,`ITEMID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_item_temp`
--

DROP TABLE IF EXISTS `tbl_board_item_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_item_temp` (
  `ITEMID` varchar(76) NOT NULL,
  `BOARDID` varchar(76) NOT NULL,
  `WRITERID` varchar(40) DEFAULT NULL,
  `WRITERNAME` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(40) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERCOMPANYID` varchar(40) DEFAULT NULL,
  `WRITERCOMPANYNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERCOMPANYNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITEDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PARENTWRITEDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `UPDATEDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `IMPORTANCE` bigint(10) DEFAULT NULL,
  `TITLE` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENTLOCATION` varchar(400) DEFAULT NULL,
  `READCOUNT` bigint(10) DEFAULT NULL,
  `STARTDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ENDDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ABSTRACT` varchar(800) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHMENTS` varchar(2) DEFAULT NULL,
  `UPPERITEMIDTREE` longtext DEFAULT NULL,
  `ITEMLEVEL` bigint(10) DEFAULT NULL,
  `COPIEDITEM` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE32` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(400) DEFAULT NULL,
  `DOCNO` decimal(19,0) DEFAULT NULL,
  `DOCPASSWORD` varchar(100) DEFAULT NULL,
  `MAINCONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_like`
--

DROP TABLE IF EXISTS `tbl_board_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_like` (
  `ITEMID` varchar(80) NOT NULL,
  `USERID` varchar(80) NOT NULL,
  `LIKEDATE` varchar(40) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ITEMID`,`USERID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_listheader`
--

DROP TABLE IF EXISTS `tbl_board_listheader`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_listheader` (
  `BOARDID` varchar(76) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `NAME1` varchar(200) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `NAME3` varchar(200) DEFAULT NULL,
  `NAME4` varchar(200) DEFAULT NULL,
  `COLNAME` varchar(200) NOT NULL,
  `WIDTH` bigint(10) NOT NULL,
  `VIEW_FG` varchar(4) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`BOARDID`,`SN`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_myboards`
--

DROP TABLE IF EXISTS `tbl_board_myboards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_myboards` (
  `USERID` varchar(100) NOT NULL,
  `BOARDID` varchar(76) NOT NULL,
  `BOARDNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BOARDNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TREEVIEWNUM` double(126,0) DEFAULT NULL,
  `TABUSED` varchar(4) DEFAULT 'Y',
  `VIEWORDER` double(126,0) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(80) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`,`BOARDID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_mytree`
--

DROP TABLE IF EXISTS `tbl_board_mytree`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_mytree` (
  `TREEID` varchar(76) NOT NULL,
  `USERID` varchar(40) NOT NULL,
  `TREENAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TREENAME2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TREELEVEL` bigint(10) DEFAULT NULL,
  `TREESTEP` bigint(10) NOT NULL,
  `TREEUPPER` varchar(76) DEFAULT NULL,
  `TREEBOARDID` varchar(76) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`TREEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_newboard_orderinfo`
--

DROP TABLE IF EXISTS `tbl_board_newboard_orderinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_newboard_orderinfo` (
  `BOARDID` varchar(76) DEFAULT NULL,
  `USERID` varchar(100) NOT NULL,
  `TABUSED` varchar(4) DEFAULT NULL,
  `VIEWORDER` double(126,0) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`TENANT_ID`,`USERID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_onelinereply`
--

DROP TABLE IF EXISTS `tbl_board_onelinereply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_onelinereply` (
  `ITEMID` varchar(76) NOT NULL,
  `REPLYID` varchar(76) NOT NULL,
  `BOARDID` varchar(76) NOT NULL,
  `USERID` varchar(100) DEFAULT NULL,
  `USERNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITEDATE` varchar(25) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENT` varchar(600) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PASSWORD` varchar(1368) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`,`REPLYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_thanks`
--

DROP TABLE IF EXISTS `tbl_board_thanks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_thanks` (
  `ITEMID` bigint(20) NOT NULL,
  `WRITERID` varchar(80) DEFAULT NULL,
  `WRITERNAME` varchar(120) DEFAULT NULL,
  `WRITERDEPTID` varchar(80) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(120) DEFAULT NULL,
  `WRITEDATE` datetime DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `TITLE` varchar(400) DEFAULT NULL,
  `READCOUNT` bigint(10) DEFAULT NULL,
  `DELETEFLAG` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `THANKSDEPT` varchar(45) DEFAULT '감사운동본부',
  `THANKSPERSON` varchar(45) DEFAULT '감사인',
  PRIMARY KEY (`ITEMID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_thanks_branch`
--

DROP TABLE IF EXISTS `tbl_board_thanks_branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_thanks_branch` (
  `ITEMID` bigint(20) NOT NULL,
  `UPDATEPERSONID` varchar(80) DEFAULT NULL,
  `UPDATEPERSON` varchar(120) DEFAULT NULL,
  `UPDATEDEPTID` varchar(80) DEFAULT NULL,
  `UPDATEDEPTNAME` varchar(120) DEFAULT NULL,
  `UPDATEDATE` datetime DEFAULT NULL,
  `BRANCHNUM` bigint(10) NOT NULL DEFAULT 0,
  `BRANCHNAME` varchar(80) DEFAULT NULL,
  `BRANCHPRESENTOR` varchar(80) DEFAULT NULL,
  `BRANCHCONTENT` longtext DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ITEMID`,`BRANCHNUM`,`TENANT_ID`),
  CONSTRAINT `tbl_board_thanks_branch_ibfk_1` FOREIGN KEY (`ITEMID`) REFERENCES `tbl_board_thanks` (`ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_thanks_branchname`
--

DROP TABLE IF EXISTS `tbl_board_thanks_branchname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_thanks_branchname` (
  `BRANCHNUM` bigint(10) NOT NULL DEFAULT 0,
  `BRANCHNAME` varchar(80) NOT NULL DEFAULT '',
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`BRANCHNUM`,`BRANCHNAME`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_treecache`
--

DROP TABLE IF EXISTS `tbl_board_treecache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_treecache` (
  `QUERY` varchar(3600) NOT NULL,
  `RESULT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESULT2` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`QUERY`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_builtin_parameters`
--

DROP TABLE IF EXISTS `tbl_builtin_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_builtin_parameters` (
  `PARAMTYPE` bigint(10) NOT NULL,
  `PARAMINFO` varchar(100) DEFAULT NULL,
  `DESCRIPTION` varchar(510) DEFAULT NULL,
  `SHORTNAME` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`PARAMTYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_board`
--

DROP TABLE IF EXISTS `tbl_c_board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_board` (
  `NO` bigint(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(40) NOT NULL,
  `COMPANYID` varchar(40) DEFAULT NULL,
  `USERNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENTURL` varchar(400) DEFAULT NULL,
  `WRITEDAY` varchar(100) NOT NULL,
  `REF` decimal(19,0) NOT NULL,
  `STEP` bigint(10) NOT NULL,
  `RE_LEVEL` bigint(10) NOT NULL,
  `READNUM` decimal(19,0) NOT NULL,
  `NUMM` decimal(19,0) DEFAULT NULL,
  `FILENAME` varchar(40) DEFAULT NULL,
  `C_CLUBNO` varchar(40) DEFAULT NULL,
  `C_NO` bigint(18) DEFAULT NULL,
  `CHARFILENAME` longtext DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`NO`),
  UNIQUE KEY `IDX_TBL_C_BOARD` (`TENANT_ID`,`NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_category`
--

DROP TABLE IF EXISTS `tbl_c_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_category` (
  `C_CODE` varchar(510) NOT NULL,
  `C_CAT` varchar(510) NOT NULL,
  `C_NAME` varchar(510) DEFAULT NULL,
  `C_ORDER` double(126,0) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`C_CODE`(255),`C_CAT`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_club`
--

DROP TABLE IF EXISTS `tbl_c_club`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_club` (
  `C_CLUBNO` varchar(40) NOT NULL,
  `C_REGDATE` datetime DEFAULT NULL,
  `C_CLUBNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `C_CLUBNAME2` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `C_CATE_A` varchar(4) NOT NULL DEFAULT '0',
  `C_CATE_B` varchar(4) DEFAULT '0',
  `C_CATE_C` varchar(4) DEFAULT '0',
  `C_CLUBGUBUN` varchar(100) DEFAULT NULL,
  `C_CLUBCONFIRMTYPE` varchar(100) DEFAULT NULL,
  `C_ADMINCONFIRM` varchar(2) DEFAULT NULL,
  `C_MAKER` varchar(40) DEFAULT NULL,
  `C_SYSOPID` varchar(40) DEFAULT NULL,
  `C_MEMBERCNT` bigint(10) NOT NULL DEFAULT 1,
  `C_LOGO` varchar(100) DEFAULT NULL,
  `C_LOGO_THUMBNAIL` varchar(100) DEFAULT NULL,
  `C_BGIMAGE` varchar(100) DEFAULT NULL,
  `C_FONTCOLOR` varchar(100) DEFAULT NULL,
  `C_BGCOLOR` varchar(100) DEFAULT NULL,
  `C_TITLEFONTCOLOR` varchar(100) DEFAULT NULL,
  `C_CLUBDESC` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `C_CLUBBANNER` varchar(100) NOT NULL,
  `C_OPENDATE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `C_CLUBNOTICETITLE` varchar(200) DEFAULT '공지사항',
  `C_NOTICETITLECOLOR` varchar(20) DEFAULT NULL,
  `C_NOTICEFONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBNOTICE_ORDERBY` bigint(10) NOT NULL DEFAULT 0,
  `C_CLUBNOTICE_EXIST` varchar(4) NOT NULL DEFAULT '1',
  `C_CLUBBOARDTITLE` varchar(200) DEFAULT '게시판',
  `C_BOARDTITLECOLOR` varchar(20) DEFAULT NULL,
  `C_BOARDFONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBBOARD_ORDERBY` bigint(10) NOT NULL DEFAULT 0,
  `C_CLUBBOARD_EXIST` varchar(4) NOT NULL DEFAULT '1',
  `C_CLUBPDSTITLE` varchar(200) DEFAULT '자료실',
  `C_PDSTITLECOLOR` varchar(20) DEFAULT NULL,
  `C_PDSFONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBPDS_ORDERBY` bigint(10) NOT NULL DEFAULT 0,
  `C_CLUBPDS_EXIST` varchar(4) NOT NULL DEFAULT '1',
  `C_CLUBBOARD1TITLE` varchar(200) DEFAULT '게시판1',
  `C_BOARD1TITLECOLOR` varchar(20) DEFAULT NULL,
  `C_BOARD1FONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBBOARD1_EXIST` varchar(4) NOT NULL DEFAULT '0',
  `C_CLUBBOARD1_ORDERBY` bigint(10) NOT NULL DEFAULT 0,
  `C_CLUBBOARD2TITLE` varchar(200) DEFAULT '게시판2',
  `C_BOARD2TITLECOLOR` varchar(20) DEFAULT NULL,
  `C_BOARD2FONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBBOARD2_EXIST` varchar(4) NOT NULL DEFAULT '0',
  `C_CLUBBOARD2_ORDERBY` bigint(10) NOT NULL DEFAULT 0,
  `C_CLUBPDS1TITLE` varchar(200) DEFAULT '자료실1',
  `C_PDS1TITLECOLOR` varchar(20) DEFAULT NULL,
  `C_PDS1FONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBPDS1_EXIST` varchar(4) NOT NULL DEFAULT '0',
  `C_CLUBPDS1_ORDERBY` bigint(10) NOT NULL DEFAULT 0,
  `SCORE` bigint(10) DEFAULT NULL,
  `ISIN` bigint(10) DEFAULT NULL,
  `COMPANYID` varchar(100) DEFAULT NULL,
  `USINGDISKSIZE` bigint(18) DEFAULT 0,
  `SENDMAIL` varchar(4) DEFAULT '0',
  `SENDMAILCNT` varchar(4) DEFAULT '0',
  `ASSIGNDISKSIZE` varchar(20) NOT NULL DEFAULT '52428800',
  `C_TYPE` varchar(20) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`C_CLUBNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_clubguest`
--

DROP TABLE IF EXISTS `tbl_c_clubguest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_clubguest` (
  `NO` bigint(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `USERNAME` varchar(100) DEFAULT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `COMPANYID` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `TITLE` varchar(400) CHARACTER SET utf8 DEFAULT NULL,
  `CONTENT` longtext DEFAULT NULL,
  `CONTENTURL` varchar(400) CHARACTER SET utf8 DEFAULT NULL,
  `READNUM` decimal(19,0) DEFAULT NULL,
  `WRITEDAY` datetime DEFAULT NULL,
  `C_NO` decimal(19,0) NOT NULL,
  `C_CLUBNO` varchar(40) CHARACTER SET utf8 NOT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`NO`),
  UNIQUE KEY `IDX_TBL_C_CLUBGUEST` (`TENANT_ID`,`NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_clubnotice`
--

DROP TABLE IF EXISTS `tbl_c_clubnotice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_clubnotice` (
  `NO` bigint(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(40) DEFAULT NULL,
  `USERNAME` varchar(100) DEFAULT NULL,
  `COMPANYID` varchar(100) DEFAULT NULL,
  `TITLE` varchar(400) DEFAULT NULL,
  `CONTENT` longtext DEFAULT NULL,
  `CONTENTURL` varchar(400) DEFAULT NULL,
  `READNUM` decimal(19,0) DEFAULT NULL,
  `WRITEDAY` varchar(100) DEFAULT NULL,
  `C_NO` decimal(19,0) DEFAULT NULL,
  `C_CLUBNO` varchar(40) DEFAULT NULL,
  `FILENAME` varchar(40) DEFAULT NULL,
  `REF` bigint(18) DEFAULT NULL,
  `STEP` bigint(10) DEFAULT NULL,
  `RE_LEVEL` bigint(10) DEFAULT NULL,
  `CHARFILENAME` longtext DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`NO`),
  UNIQUE KEY `IDX_TBL_C_CLUBNOTICE` (`TENANT_ID`,`NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_clubuser`
--

DROP TABLE IF EXISTS `tbl_c_clubuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_clubuser` (
  `C_CLUBNO` varchar(40) NOT NULL,
  `C_ID` varchar(40) NOT NULL,
  `C_INDATE` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `C_LASTDATE` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `C_EMAIL` mediumint(5) NOT NULL DEFAULT 0,
  `C_HPHONE` mediumint(5) NOT NULL DEFAULT 0,
  `C_COMPANY` mediumint(5) NOT NULL DEFAULT 0,
  `C_HOUSE` mediumint(5) NOT NULL DEFAULT 0,
  `C_JOB` mediumint(5) NOT NULL DEFAULT 0,
  `C_BIRTH` mediumint(5) NOT NULL DEFAULT 0,
  `C_SEX` mediumint(5) NOT NULL DEFAULT 0,
  `C_VISITED` decimal(19,0) NOT NULL DEFAULT 0,
  `C_INTRO` longtext DEFAULT NULL,
  `PERMIT` varchar(4) DEFAULT '0',
  `COMPANYID` varchar(100) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`C_CLUBNO`,`C_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_comclose`
--

DROP TABLE IF EXISTS `tbl_c_comclose`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_comclose` (
  `C_CLUBNO` varchar(40) NOT NULL,
  `C_CLUBNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `C_CLUBNAME2` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `C_SYSOPID` varchar(100) DEFAULT NULL,
  `COMPANYNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APPLICATIONDATE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CLOSEREASON` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `CLOSESTATE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CLOSESTATE2` varchar(100) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`C_CLUBNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_memberinfo`
--

DROP TABLE IF EXISTS `tbl_c_memberinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_memberinfo` (
  `COMPANYID` varchar(100) NOT NULL,
  `USERID` varchar(100) NOT NULL,
  `USERNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYZIP` varchar(200) DEFAULT NULL,
  `COMPANYADDRESS` varchar(200) DEFAULT NULL,
  `DEPTNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYTEL` varchar(100) DEFAULT NULL,
  `COMPANYFAX` varchar(100) DEFAULT NULL,
  `HOMEZIP` varchar(200) DEFAULT NULL,
  `HOMEADDRESS` varchar(200) DEFAULT NULL,
  `HOMETEL` varchar(100) DEFAULT NULL,
  `HANDPHONE` varchar(100) DEFAULT NULL,
  `EMAIL` varchar(100) DEFAULT NULL,
  `BIRTHDAY` varchar(100) DEFAULT NULL,
  `GENDER` varchar(20) DEFAULT NULL,
  `GENDER2` varchar(20) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_notice`
--

DROP TABLE IF EXISTS `tbl_c_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_notice` (
  `NO` bigint(10) NOT NULL AUTO_INCREMENT,
  `ID` varchar(40) NOT NULL,
  `USERNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(400) CHARACTER SET utf8mb4 NOT NULL,
  `CONTENT` longtext CHARACTER SET utf8mb4 NOT NULL,
  `READNUM` decimal(19,0) NOT NULL,
  `WRITEDAY` varchar(100) NOT NULL,
  `FILENAME` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYID` varchar(100) DEFAULT NULL,
  `C_CLUBNO` varchar(40) DEFAULT NULL,
  `C_NO` bigint(18) DEFAULT NULL,
  `REF` bigint(18) DEFAULT NULL,
  `STEP` bigint(10) DEFAULT NULL,
  `RE_LEVEL` bigint(10) DEFAULT NULL,
  `CHARFILENAME` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`NO`),
  UNIQUE KEY `IDX_TBL_C_NOTICE` (`TENANT_ID`,`NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_outapplication`
--

DROP TABLE IF EXISTS `tbl_c_outapplication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_outapplication` (
  `C_CLUBNO` varchar(40) NOT NULL,
  `USERID` varchar(100) NOT NULL,
  `OUTDATE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OUTREASON` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`C_CLUBNO`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_pollanswer`
--

DROP TABLE IF EXISTS `tbl_c_pollanswer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_pollanswer` (
  `ANSWERID` bigint(10) NOT NULL AUTO_INCREMENT,
  `POLLQUESTIONID` bigint(10) NOT NULL,
  `ANSWERNO` bigint(10) NOT NULL DEFAULT 0,
  `ANSWERCONTENT` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` bigint(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ANSWERID`),
  UNIQUE KEY `PK_TBL_C_POLLANSWER` (`TENANT_ID`,`ANSWERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_pollmanager`
--

DROP TABLE IF EXISTS `tbl_c_pollmanager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_pollmanager` (
  `MANAGERID` bigint(10) NOT NULL AUTO_INCREMENT,
  `C_CLUBNO` varchar(40) NOT NULL,
  `POLLGROUPNO` bigint(10) NOT NULL DEFAULT 0,
  `POLLSUBJECT` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `QUESTIONCOUNT` bigint(10) NOT NULL,
  `POLLREGDATE` datetime DEFAULT NULL,
  `POLLSTARTDATE` datetime DEFAULT NULL,
  `POLLENDDATE` datetime DEFAULT NULL,
  `POLLREGUSER` varchar(100) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`MANAGERID`),
  UNIQUE KEY `IDX_TBL_C_POLLMANAGER` (`TENANT_ID`,`MANAGERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_pollquestion`
--

DROP TABLE IF EXISTS `tbl_c_pollquestion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_pollquestion` (
  `QUESTIONID` bigint(10) NOT NULL AUTO_INCREMENT,
  `POLLMANAGERID` bigint(10) NOT NULL,
  `QUESTIONNO` bigint(10) NOT NULL,
  `QUESTIONCONTENT` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ANSWERCOUNT` bigint(10) NOT NULL,
  `ANSWERTYPE` bigint(10) NOT NULL,
  `ANSWERVIEWTYPE` bigint(10) DEFAULT 0,
  `TENANT_ID` bigint(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`QUESTIONID`),
  UNIQUE KEY `IDX_TBL_C_POLLQUESTION` (`TENANT_ID`,`QUESTIONID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_c_pollresponse`
--

DROP TABLE IF EXISTS `tbl_c_pollresponse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_c_pollresponse` (
  `RESPONSEID` bigint(10) NOT NULL AUTO_INCREMENT,
  `QUESTIONID` bigint(10) NOT NULL,
  `ANSWERID` bigint(10) NOT NULL,
  `ANSWERNO` bigint(10) NOT NULL,
  `ANSWERETC` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERID` varchar(100) NOT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  `TENANT_ID` bigint(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`RESPONSEID`),
  UNIQUE KEY `PK_TBL_C_POLLRESPONSE` (`TENANT_ID`,`RESPONSEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cabinet`
--

DROP TABLE IF EXISTS `tbl_cabinet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cabinet` (
  `CABINETID` varchar(112) NOT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `CABINETCLASSNO` varchar(100) NOT NULL,
  `DELETEDATE` datetime DEFAULT NULL,
  `VOLUMENO` varchar(12) DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT '0',
  `TCABINETID` varchar(112) DEFAULT NULL,
  `TDEPTCODE` varchar(28) DEFAULT NULL,
  `TCABINETNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TTASKCODE` varchar(32) DEFAULT NULL,
  `TDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TTASKNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TPRODUCEYEAR` varchar(16) DEFAULT NULL,
  `TREGSERIALNO` varchar(24) DEFAULT NULL,
  `TVOLUMENO` varchar(12) DEFAULT NULL,
  `TRANSFERDATE` datetime DEFAULT NULL,
  `CABINETTRANSFERFLAG` varchar(4) DEFAULT '0',
  `PRODREPORTFLAG` bigint(10) DEFAULT 0,
  `TRANSFERFLAG` bigint(10) DEFAULT 0,
  `CATALOGTRANSFERFLAG` varchar(4) DEFAULT '0',
  `CATALOGTRANSFERYEAR` bigint(10) DEFAULT NULL,
  `DOCTRANSFERFLAG` varchar(4) DEFAULT '0',
  `DOCTRANSFERYEAR` bigint(10) DEFAULT NULL,
  `TCABINETNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TTASKNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CABINETID`),
  KEY `FK_TBL_CABINET_idx` (`TENANT_ID`,`COMPANYID`,`CABINETCLASSNO`),
  CONSTRAINT `FK_TBL_CABINET` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cabinet_viewauth`
--

DROP TABLE IF EXISTS `tbl_cabinet_viewauth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cabinet_viewauth` (
  `CABINETID` varchar(112) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `CN` varchar(80) NOT NULL,
  `ACCESS_LV` varchar(1) NOT NULL DEFAULT 'N' COMMENT '부서의 경우 하위부서까지 권한이 전파되는지의 여부',
  `MNG_FG` varchar(1) NOT NULL DEFAULT 'N' COMMENT '관리자인지 아닌지를 나타내는 플래그',
  PRIMARY KEY (`CABINETID`,`TENANT_ID`,`COMPANYID`,`CN`),
  KEY `FK_TBL_CABINET_VIEWAUTH` (`TENANT_ID`,`COMPANYID`,`CABINETID`),
  CONSTRAINT `FK_TBL_CABINET_VIEWAUTH` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `CABINETID`) REFERENCES `tbl_cabinet` (`TENANT_ID`, `COMPANYID`, `CABINETID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='전자결재G 기록물철 권한테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cabinetclass`
--

DROP TABLE IF EXISTS `tbl_cabinetclass`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cabinetclass` (
  `CABINETCLASSNO` varchar(100) NOT NULL,
  `PRODUCTIONYEAR` varchar(16) NOT NULL,
  `TASKCODE` varchar(32) DEFAULT NULL,
  `PROCESSDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSDEPTCODE` varchar(28) DEFAULT NULL,
  `REGSERIALNO` varchar(24) DEFAULT NULL,
  `TASKNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECTYPECODE` varchar(4) DEFAULT NULL,
  `EXPIRATIONYEAR` varchar(16) DEFAULT NULL,
  `DELAYENDYFLAG` varchar(4) DEFAULT 'N',
  `KEEPINGPERIOD` varchar(8) DEFAULT NULL,
  `TERMINATEFLAG` varchar(4) DEFAULT NULL,
  `OWNERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `KEEPINGMETHOD` varchar(4) DEFAULT NULL,
  `OWNERID` varchar(200) DEFAULT NULL,
  `DISPLAYRECFLAG` varchar(4) DEFAULT NULL,
  `KEEPINGPLACE` varchar(4) DEFAULT NULL,
  `MODIFYFLAG` varchar(4) DEFAULT NULL,
  `DISPLAYENDDATE` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
  `NUMOFREC` varchar(12) DEFAULT NULL,
  `PAGEOFREC` varchar(24) DEFAULT NULL,
  `TRANSDELAYFLAG` varchar(4) DEFAULT NULL,
  `EXTRANSYEAR` bigint(10) DEFAULT NULL,
  `TRANSDELAYREASON` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYREASON` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OLDCABINETFLAG` varchar(4) DEFAULT NULL,
  `NUMOFELECTRONICDOC` varchar(24) DEFAULT NULL,
  `SPECIALCATALOGFLAG` varchar(4) DEFAULT NULL,
  `CONFIRMFLAG` varchar(4) DEFAULT NULL,
  `CONFIRMYEAR` bigint(10) DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `DELETEDATE` datetime DEFAULT NULL,
  `OWNERDEPTID` varchar(28) DEFAULT NULL,
  `OWNERTASK` varchar(32) DEFAULT NULL,
  `TITLE2` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TASKNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OWNERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CABINETCLASSNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cabinetcodelist`
--

DROP TABLE IF EXISTS `tbl_cabinetcodelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cabinetcodelist` (
  `CODETYPE` varchar(12) NOT NULL,
  `CODE` varchar(20) NOT NULL,
  `NAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ISUSED` smallint(3) NOT NULL,
  `CODEDESCRIPTION` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TYPEDESCRIPTION` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `NAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CODETYPE`,`CODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cabinethistory`
--

DROP TABLE IF EXISTS `tbl_cabinethistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cabinethistory` (
  `VERSION` bigint(10) NOT NULL,
  `CABINETCLASSNO` varchar(100) NOT NULL,
  `TITLE` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECTYPECODE` varchar(4) DEFAULT NULL,
  `MODIFYDATE` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
  `KEEPINGPERIOD` varchar(8) DEFAULT NULL,
  `DISPLAYENDDATE` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYREASON` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYREASON` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFIERID` varchar(400) DEFAULT NULL,
  `MODIFIERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYFLAG` varchar(4) DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT NULL,
  `MODIFIERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`VERSION`,`CABINETCLASSNO`),
  KEY `FK_TBL_CABINETHISTORY_idx` (`TENANT_ID`,`COMPANYID`,`CABINETCLASSNO`),
  CONSTRAINT `FK_TBL_CABINETHISTORY` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cabroleinfo`
--

DROP TABLE IF EXISTS `tbl_cabroleinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cabroleinfo` (
  `USER_ID` varchar(400) NOT NULL,
  `CABINETCLASSNO` varchar(100) NOT NULL,
  `USERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CABINETCLASSNO`,`USER_ID`(255)),
  CONSTRAINT `FK_TBL_CABROLEINFO` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_admin_module`
--

DROP TABLE IF EXISTS `tbl_cb_admin_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_admin_module` (
  `company_id` varchar(50) NOT NULL,
  `module_type` varchar(20) NOT NULL,
  `active_status` tinyint(4) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`company_id`,`module_type`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_attach_file`
--

DROP TABLE IF EXISTS `tbl_cb_attach_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_attach_file` (
  `attach_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `file_path` varchar(250) NOT NULL,
  `file_name` varchar(150) NOT NULL,
  `file_size` bigint(50) NOT NULL,
  `file_description` varchar(400) DEFAULT NULL,
  `company_id` varchar(50) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`attach_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_cabinet`
--

DROP TABLE IF EXISTS `tbl_cb_cabinet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_cabinet` (
  `cabinet_id` int(11) NOT NULL AUTO_INCREMENT,
  `cabinet_name1` varchar(150) NOT NULL,
  `cabinet_name2` varchar(150) NOT NULL,
  `creator_id` varchar(50) NOT NULL,
  `creator_name1` varchar(150) NOT NULL,
  `creator_name2` varchar(150) NOT NULL,
  `department_id` varchar(50) NOT NULL,
  `department_name1` varchar(150) NOT NULL,
  `department_name2` varchar(150) DEFAULT NULL,
  `cabinet_type` tinyint(4) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `cabinet_path` varchar(500) NOT NULL,
  `cabinet_order` int(11) NOT NULL,
  `cabinet_level` int(11) NOT NULL,
  `create_date` datetime NOT NULL,
  `update_date` datetime NOT NULL,
  `update_id` varchar(50) NOT NULL,
  `delete_id` varchar(50) DEFAULT NULL,
  `use_status` tinyint(4) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`cabinet_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_company_capacity`
--

DROP TABLE IF EXISTS `tbl_cb_company_capacity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_company_capacity` (
  `company_id` varchar(50) NOT NULL,
  `capacity_type` tinyint(4) NOT NULL,
  `capacity_value` int(11) DEFAULT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`company_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_config`
--

DROP TABLE IF EXISTS `tbl_cb_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_config` (
  `user_id` varchar(50) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `list_count` int(10) NOT NULL,
  `preview_mode` varchar(10) NOT NULL,
  `content_wpercent` int(5) NOT NULL,
  `content_hpercent` int(5) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`company_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_item`
--

DROP TABLE IF EXISTS `tbl_cb_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_item` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `cabinet_id` int(11) NOT NULL,
  `item_type` tinyint(4) NOT NULL,
  `title` varchar(250) NOT NULL,
  `summary` varchar(250) DEFAULT NULL,
  `creator_id` varchar(50) NOT NULL,
  `creator_name1` varchar(150) NOT NULL,
  `creator_name2` varchar(150) NOT NULL,
  `department_id` varchar(50) NOT NULL,
  `department_name1` varchar(150) NOT NULL,
  `department_name2` varchar(150) DEFAULT NULL,
  `content_path` longtext DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `update_date` datetime NOT NULL,
  `use_status` tinyint(4) NOT NULL,
  `update_id` varchar(50) NOT NULL,
  `delete_id` varchar(50) DEFAULT NULL,
  `company_id` varchar(50) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_rel`
--

DROP TABLE IF EXISTS `tbl_cb_rel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_rel` (
  `rel_id` varchar(50) NOT NULL,
  `item_id` int(11) NOT NULL,
  `rel_name1` varchar(80) DEFAULT NULL,
  `rel_name2` varchar(80) DEFAULT NULL,
  `rel_value` longtext NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`rel_id`,`tenant_id`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_relation`
--

DROP TABLE IF EXISTS `tbl_cb_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_relation` (
  `relation_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `relate_item_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`relation_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_share`
--

DROP TABLE IF EXISTS `tbl_cb_share`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_share` (
  `share_id` int(11) NOT NULL,
  `cabinet_id` int(11) NOT NULL,
  `sharer_id` varchar(50) NOT NULL,
  `sharer_name1` varchar(150) NOT NULL,
  `sharer_name2` varchar(150) NOT NULL,
  `shared_id` varchar(50) NOT NULL,
  `shared_type` tinyint(4) NOT NULL COMMENT '0: 회사, 1: 부서, 2: 사원 ',
  `permission` tinyint(4) NOT NULL COMMENT '0: 읽기, 1: 쓰기',
  `share_date` datetime NOT NULL,
  `child_permission` tinyint(4) NOT NULL COMMENT '1: 권한있음, 0: 권한없음',
  `use_status` tinyint(4) NOT NULL COMMENT '1: 사용, 0: 삭제',
  `company_id` varchar(50) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`share_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_user_capacity`
--

DROP TABLE IF EXISTS `tbl_cb_user_capacity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_user_capacity` (
  `user_id` varchar(50) NOT NULL,
  `capacity_type` tinyint(4) NOT NULL,
  `capacity_value` int(11) DEFAULT NULL,
  `company_id` varchar(50) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`company_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cb_user_module`
--

DROP TABLE IF EXISTS `tbl_cb_user_module`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cb_user_module` (
  `user_id` varchar(50) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `module_type` varchar(20) NOT NULL,
  `active_status` tinyint(4) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`company_id`,`module_type`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular`
--

DROP TABLE IF EXISTS `tbl_circular`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular` (
  `circularId` bigint(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `importance` mediumint(5) DEFAULT NULL,
  `option` mediumint(5) DEFAULT NULL,
  `content` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `hasFile` mediumint(5) DEFAULT NULL,
  `status` mediumint(5) DEFAULT NULL,
  `memberId` varchar(100) DEFAULT NULL,
  `memberName` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `memberName2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `regDate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `endDate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `tenantId` mediumint(5) NOT NULL,
  `companyId` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`circularId`),
  KEY `tenantId_memberId_index` (`tenantId`,`memberId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_bm`
--

DROP TABLE IF EXISTS `tbl_circular_bm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_bm` (
  `circularBMId` bigint(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `memberId` varchar(100) DEFAULT NULL,
  `regDate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `tenantId` mediumint(5) NOT NULL,
  `companyId` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`circularBMId`),
  KEY `tenantId_memberId_index` (`tenantId`,`memberId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_bmuser`
--

DROP TABLE IF EXISTS `tbl_circular_bmuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_bmuser` (
  `circularBMUserId` bigint(10) NOT NULL AUTO_INCREMENT,
  `circularBMId` bigint(10) DEFAULT NULL,
  `memberId` varchar(100) DEFAULT NULL,
  `memberName` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `memberName2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `tenantId` mediumint(5) NOT NULL,
  PRIMARY KEY (`circularBMUserId`),
  KEY `tenantId_memberId_circularBMId_index` (`tenantId`,`memberId`,`circularBMId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_comment`
--

DROP TABLE IF EXISTS `tbl_circular_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_comment` (
  `circularId` bigint(10) NOT NULL,
  `circularCommentId` bigint(10) NOT NULL AUTO_INCREMENT,
  `circularUserId` varchar(100) DEFAULT NULL,
  `circularComment` text CHARACTER SET utf8mb4 DEFAULT NULL,
  `memberId` varchar(100) DEFAULT NULL,
  `memberName` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `memberName2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `regDate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `status` mediumint(5) DEFAULT NULL,
  `hasFile` varchar(4) DEFAULT 'N',
  `tenantId` mediumint(5) NOT NULL,
  PRIMARY KEY (`circularCommentId`,`circularId`,`tenantId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_comment_file`
--

DROP TABLE IF EXISTS `tbl_circular_comment_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_comment_file` (
  `commentFileId` bigint(10) NOT NULL AUTO_INCREMENT,
  `circularId` bigint(10) NOT NULL,
  `circularCommentId` bigint(10) NOT NULL,
  `memberId` varchar(100) NOT NULL,
  `fileName` varchar(200) NOT NULL,
  `filesize` bigint(10) NOT NULL,
  `filepath` varchar(500) NOT NULL,
  `tenantId` mediumint(5) NOT NULL,
  PRIMARY KEY (`commentFileId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_commentstate`
--

DROP TABLE IF EXISTS `tbl_circular_commentstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_commentstate` (
  `circularCommentStateId` bigint(10) NOT NULL AUTO_INCREMENT,
  `circularCommentId` bigint(10) DEFAULT NULL,
  `memberId` varchar(100) DEFAULT NULL,
  `status` mediumint(5) DEFAULT NULL,
  `confirmDate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `updateDate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `tenantId` mediumint(5) NOT NULL,
  PRIMARY KEY (`circularCommentStateId`),
  KEY `tenantId_cn_circularCommentId_index` (`tenantId`,`memberId`,`circularCommentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_file`
--

DROP TABLE IF EXISTS `tbl_circular_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_file` (
  `circularFileId` bigint(10) NOT NULL AUTO_INCREMENT,
  `circularId` bigint(10) DEFAULT NULL,
  `fileName` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `fileSize` bigint(10) DEFAULT NULL,
  `filePath` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `tenantId` mediumint(5) NOT NULL,
  PRIMARY KEY (`circularFileId`),
  KEY `tenantId_circularId_index` (`tenantId`,`circularId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_folder`
--

DROP TABLE IF EXISTS `tbl_circular_folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_folder` (
  `circularFolderId` bigint(10) NOT NULL AUTO_INCREMENT,
  `circularFolderName` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `memberId` varchar(100) DEFAULT NULL,
  `regDate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `tenantId` mediumint(5) NOT NULL,
  `companyId` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`circularFolderId`),
  KEY `tenantId_memberId_index` (`tenantId`,`memberId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_link`
--

DROP TABLE IF EXISTS `tbl_circular_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_link` (
  `circularLinkId` bigint(10) NOT NULL AUTO_INCREMENT,
  `circularFolderId` bigint(10) DEFAULT NULL,
  `circularId` bigint(10) DEFAULT NULL,
  `memberId` varchar(100) DEFAULT NULL,
  `tenantId` mediumint(5) NOT NULL,
  PRIMARY KEY (`circularLinkId`),
  KEY `tenantId_memberId_index` (`tenantId`,`memberId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_listoption`
--

DROP TABLE IF EXISTS `tbl_circular_listoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_listoption` (
  `LISTTYPE` varchar(4) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `NAME1` varchar(200) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `NAME3` varchar(200) DEFAULT NULL,
  `NAME4` varchar(200) DEFAULT NULL,
  `COLNAME` varchar(200) NOT NULL,
  `WIDTH` bigint(10) NOT NULL,
  `TENANTID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANTID`,`LISTTYPE`,`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_option`
--

DROP TABLE IF EXISTS `tbl_circular_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_option` (
  `circularOptionId` bigint(10) NOT NULL AUTO_INCREMENT,
  `memberId` varchar(100) DEFAULT NULL,
  `listCnt` mediumint(5) DEFAULT NULL,
  `isPreview` mediumint(5) DEFAULT NULL,
  `previewListValue` varchar(10) DEFAULT NULL,
  `previewContentValue` varchar(10) DEFAULT NULL,
  `tenantId` mediumint(5) NOT NULL,
  PRIMARY KEY (`circularOptionId`),
  KEY `tenantId_memberId_index` (`tenantId`,`memberId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_circular_user`
--

DROP TABLE IF EXISTS `tbl_circular_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_circular_user` (
  `circularUserId` bigint(10) NOT NULL AUTO_INCREMENT,
  `circularId` bigint(10) DEFAULT NULL,
  `memberId` varchar(100) DEFAULT NULL,
  `memberName` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `memberName2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `status` mediumint(5) DEFAULT 0,
  `confirmDate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `updateStatus` mediumint(5) DEFAULT NULL,
  `updateDate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `commentStatus` mediumint(5) DEFAULT 0,
  `shareStatus` mediumint(5) DEFAULT 0,
  `deleteStatus` mediumint(5) DEFAULT 0,
  `tenantId` mediumint(5) NOT NULL,
  `companyId` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`circularUserId`),
  KEY `tenantId_memberId_circularId_index` (`tenantId`,`memberId`,`circularId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cloud_customer`
--

DROP TABLE IF EXISTS `tbl_cloud_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cloud_customer` (
  `customerId` int(11) NOT NULL AUTO_INCREMENT COMMENT '고객사 구분 번호',
  `customerName` varchar(120) NOT NULL COMMENT '고객사 이름 (회사 이름)',
  `domain` varchar(100) NOT NULL COMMENT '고객사 메일 도메인',
  `customerIp` varchar(100) NOT NULL COMMENT '고객사 아이피',
  `package` varchar(100) DEFAULT NULL COMMENT '고객사 가입 패키지',
  `startDate` datetime DEFAULT NULL COMMENT '개통날짜',
  `expireDate` datetime DEFAULT NULL COMMENT '만료날짜',
  `createDate` datetime NOT NULL COMMENT '등록날짜',
  `updateDate` datetime DEFAULT NULL COMMENT '업데이트날짜',
  PRIMARY KEY (`customerId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='ezCloud 고객사 정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_cloud_user`
--

DROP TABLE IF EXISTS `tbl_cloud_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cloud_user` (
  `userId` varchar(80) NOT NULL COMMENT '멀티서버 관리자 유저 아이디',
  `password` varchar(120) NOT NULL COMMENT '멀티서버 관리자 유저 비밀번호',
  `userName` varchar(120) NOT NULL COMMENT '멀티서버 관리자 유저 이름',
  `phone` varchar(100) DEFAULT NULL COMMENT '멀티서버 관리자 유저 연락번호',
  `email` varchar(100) DEFAULT NULL COMMENT '멀티서버 관리자 유저 메일',
  `createDate` datetime NOT NULL COMMENT '생성날짜',
  `deleteDate` datetime DEFAULT NULL COMMENT '삭제날짜',
  `updateDate` datetime DEFAULT NULL COMMENT '업데이트날짜',
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='멀티서버 관리자 유저 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_clubid`
--

DROP TABLE IF EXISTS `tbl_clubid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_clubid` (
  `CLUBID` varchar(40) NOT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`CLUBID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_codelist`
--

DROP TABLE IF EXISTS `tbl_codelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_codelist` (
  `CODE1` varchar(12) NOT NULL,
  `CODE2` varchar(12) NOT NULL,
  `NAME` varchar(510) DEFAULT NULL,
  `ISUSE` varchar(4) DEFAULT NULL,
  `DESCRIPT` varchar(1020) DEFAULT NULL,
  `NAME2` varchar(510) DEFAULT NULL,
  `NAME3` varchar(510) DEFAULT NULL,
  `NAME4` varchar(510) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CODE1`,`CODE2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_columns`
--

DROP TABLE IF EXISTS `tbl_columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_columns` (
  `TBL_ID` varchar(200) DEFAULT NULL,
  `ORDER_NUM` varchar(200) DEFAULT NULL,
  `COL_NM` varchar(200) DEFAULT NULL,
  `COL_COMM` varchar(200) DEFAULT NULL,
  `COL_TYPE` varchar(200) DEFAULT NULL,
  `COL_NULL` varchar(200) DEFAULT NULL,
  `COL_KEY` varchar(200) DEFAULT NULL,
  `COL_DEFAULT` varchar(200) DEFAULT NULL,
  `CREATE_DT` datetime DEFAULT NULL,
  `UPDATE_DT` datetime DEFAULT NULL,
  `USE_YN` char(1) DEFAULT 'Y'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_boardinfo`
--

DROP TABLE IF EXISTS `tbl_comm_boardinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_boardinfo` (
  `C_CLUBNO` varchar(40) NOT NULL,
  `BOARDID` varchar(76) NOT NULL,
  `BOARDNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BOARDNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TREEVIEWORDER` varchar(1000) DEFAULT NULL,
  `BOARDLEVEL` bigint(10) DEFAULT NULL,
  `PARENTBOARDID` varchar(76) NOT NULL,
  `BOARDDESCRIPTION` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ITEMEXPIRES` bigint(10) DEFAULT NULL,
  `ATTACHSIZELIMIT` varchar(20) DEFAULT NULL,
  `REPLYNOTIFY` bigint(10) DEFAULT NULL,
  `BOARDGROUPID` varchar(76) DEFAULT NULL,
  `ALERTPOSTITEM` bigint(10) DEFAULT NULL,
  `GUBUN` bigint(10) DEFAULT NULL,
  `URL` varchar(400) DEFAULT NULL,
  `DELETEAFTER` bigint(10) DEFAULT NULL,
  `BOARDCOLOR` varchar(100) DEFAULT NULL,
  `BOARDNO` bigint(10) DEFAULT NULL,
  `VERSIONUSE` varchar(2) DEFAULT NULL,
  `CHECKUSE` varchar(2) DEFAULT NULL,
  `SHOWPOSITION` varchar(2) DEFAULT NULL,
  `SN` bigint(10) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`C_CLUBNO`,`BOARDID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_boardmanage`
--

DROP TABLE IF EXISTS `tbl_comm_boardmanage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_boardmanage` (
  `BOARDID` varchar(76) NOT NULL,
  `ACCESSID` varchar(40) NOT NULL,
  `ACCESSNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ACCESSNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ACCESSLEVEL` bigint(10) DEFAULT NULL,
  `ACCESS_` bigint(10) DEFAULT NULL,
  `PARENTBOARDID` varchar(76) DEFAULT NULL,
  `BOARDADMIN_FG` varchar(100) DEFAULT NULL,
  `LISTVIEW_FG` varchar(10) DEFAULT NULL,
  `READ_FG` varchar(10) DEFAULT NULL,
  `WRITE_FG` varchar(10) DEFAULT NULL,
  `REPLY_FG` varchar(10) DEFAULT NULL,
  `DELETE_FG` varchar(10) DEFAULT NULL,
  `INHERIT_FG` varchar(10) DEFAULT NULL,
  `POSTNOTICE` varchar(10) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`,`ACCESSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_deletereservedboard`
--

DROP TABLE IF EXISTS `tbl_comm_deletereservedboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_deletereservedboard` (
  `BOARDID` varchar(76) NOT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_deletereserveditem`
--

DROP TABLE IF EXISTS `tbl_comm_deletereserveditem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_deletereserveditem` (
  `BOARDID` varchar(76) NOT NULL,
  `ITEMID` varchar(76) NOT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`,`ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_item`
--

DROP TABLE IF EXISTS `tbl_comm_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_item` (
  `ITEMID` varchar(76) NOT NULL,
  `BOARDID` varchar(76) NOT NULL,
  `WRITERID` varchar(40) DEFAULT NULL,
  `WRITERNAME` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(40) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERCOMPANYID` varchar(40) DEFAULT NULL,
  `WRITERCOMPANYNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERCOMPANYNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITEDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PARENTWRITEDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `UPDATEDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `IMPORTANCE` bigint(10) DEFAULT NULL,
  `TITLE` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENTLOCATION` varchar(400) DEFAULT NULL,
  `READCOUNT` bigint(10) DEFAULT NULL,
  `STARTDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ENDDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ABSTRACT` varchar(800) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHMENTS` varchar(20) DEFAULT NULL,
  `UPPERITEMIDTREE` longtext DEFAULT NULL,
  `ITEMLEVEL` bigint(10) DEFAULT NULL,
  `COPIEDITEM` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE32` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(400) DEFAULT NULL,
  `DOCNO` decimal(19,0) DEFAULT NULL,
  `DOCPASSWORD` varchar(2000) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_item_attachments`
--

DROP TABLE IF EXISTS `tbl_comm_item_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_item_attachments` (
  `ITEMID` varchar(76) NOT NULL,
  `GUID` varchar(76) NOT NULL,
  `FILEPATH` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FILESIZE` varchar(20) DEFAULT NULL,
  `FILENAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`GUID`,`ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_item_read`
--

DROP TABLE IF EXISTS `tbl_comm_item_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_item_read` (
  `BOARDID` varchar(76) NOT NULL,
  `ITEMID` varchar(76) NOT NULL,
  `USERID` varchar(40) NOT NULL,
  `USERNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERCOMPANYNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERCOMPANYNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `READDATE` datetime DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`,`ITEMID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_myboards`
--

DROP TABLE IF EXISTS `tbl_comm_myboards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_myboards` (
  `USERID` varchar(40) NOT NULL,
  `BOARDID` varchar(76) NOT NULL,
  `BOARDNAME` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TREEVIEWNUM` bigint(10) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`USERID`,`BOARDID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_onelinereply`
--

DROP TABLE IF EXISTS `tbl_comm_onelinereply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_onelinereply` (
  `ITEMID` varchar(76) NOT NULL,
  `REPLYID` varchar(76) NOT NULL,
  `BOARDID` varchar(76) NOT NULL,
  `USERID` varchar(100) DEFAULT NULL,
  `USERNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITEDATE` datetime DEFAULT NULL,
  `CONTENT` varchar(600) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PASSWORD` varchar(2000) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`,`REPLYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_secretary`
--

DROP TABLE IF EXISTS `tbl_comm_secretary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_secretary` (
  `USERID` varchar(100) NOT NULL,
  `USERNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `SECRETARYID` varchar(100) NOT NULL,
  `SECRETARYNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`USERID`,`SECRETARYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_comm_treecache`
--

DROP TABLE IF EXISTS `tbl_comm_treecache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_comm_treecache` (
  `QUERY` varchar(3600) NOT NULL,
  `RESULT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`QUERY`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_company_config`
--

DROP TABLE IF EXISTS `tbl_company_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_company_config` (
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANY_ID` varchar(80) NOT NULL,
  `PROPERTY_NAME` varchar(100) NOT NULL,
  `PROPERTY_VALUE` varchar(2000) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANY_ID`,`PROPERTY_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_conndata`
--

DROP TABLE IF EXISTS `tbl_conndata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_conndata` (
  `KEYID` varchar(50) NOT NULL COMMENT 'ERP Key 값',
  `FORMID` varchar(10) NOT NULL COMMENT '연동 양식ID',
  `BODYXML` longtext DEFAULT NULL COMMENT '본문 XML',
  `STATUS` varchar(10) DEFAULT NULL COMMENT 'W:대기\nD:기안\nE:완료\nR:반송',
  `DOCID` varchar(20) DEFAULT NULL COMMENT '문서ID',
  `UPDATEDATE` datetime DEFAULT NULL COMMENT '업데이트 일자',
  `UPDATEID` varchar(20) DEFAULT NULL COMMENT '업데이트 주체',
  PRIMARY KEY (`KEYID`,`FORMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_connection_info`
--

DROP TABLE IF EXISTS `tbl_connection_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_connection_info` (
  `SEQUENCE` int(10) NOT NULL AUTO_INCREMENT,
  `USERID` varchar(200) NOT NULL,
  `USERNM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNM2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTID` varchar(200) DEFAULT NULL,
  `DEPTNM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTNM2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYID` varchar(200) DEFAULT NULL,
  `COMPANYNM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYNM2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONNECTIP` varchar(200) DEFAULT NULL,
  `CONNECTINFO` varchar(200) DEFAULT NULL,
  `CONNECTTIME` datetime DEFAULT NULL,
  `CONNECTBROWSER` varchar(40) DEFAULT NULL,
  `CONNECTOS` varchar(80) DEFAULT NULL,
  `CONNECTAGENT` varchar(1000) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`SEQUENCE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_container`
--

DROP TABLE IF EXISTS `tbl_container`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_container` (
  `CONTAINERID` varchar(40) NOT NULL,
  `CONTAINERTYPEID` varchar(40) DEFAULT NULL,
  `CONTAINEROWNDEPID` varchar(200) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CONTAINERID`,`CONTAINEROWNDEPID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_container_old`
--

DROP TABLE IF EXISTS `tbl_container_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_container_old` (
  `CONTAINERID` varchar(40) NOT NULL,
  `CONTAINERTYPEID` varchar(40) DEFAULT NULL,
  `CONTAINEROWNDEPID` varchar(200) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CONTAINERID`,`CONTAINEROWNDEPID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_containertodocstate`
--

DROP TABLE IF EXISTS `tbl_containertodocstate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_containertodocstate` (
  `CONTAINERTYPEID` varchar(40) DEFAULT NULL,
  `DOCUMENTSTATE` varchar(12) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCUMENTSTATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_containertype`
--

DROP TABLE IF EXISTS `tbl_containertype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_containertype` (
  `CONTAINERTYPEID` varchar(40) NOT NULL,
  `CONTAINERTYPENAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTAINERTYPENAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CONTAINERTYPEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_containerusedep`
--

DROP TABLE IF EXISTS `tbl_containerusedep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_containerusedep` (
  `CONTAINERID` varchar(40) NOT NULL,
  `USEDEPID` varchar(200) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CONTAINERID`,`USEDEPID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_dailydoccountlog`
--

DROP TABLE IF EXISTS `tbl_dailydoccountlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_dailydoccountlog` (
  `REGDATE` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
  `DEPTID` varchar(255) NOT NULL,
  `DEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERID` varchar(80) NOT NULL,
  `USERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DRAFTINGCNT` bigint(10) NOT NULL,
  `DRAFTENDCNT` bigint(10) NOT NULL,
  `DRAFTTIME` double(126,0) NOT NULL,
  `SUSININGCNT` bigint(10) NOT NULL,
  `SUSINENDCNT` bigint(10) NOT NULL,
  `SUSINTIME` double(126,0) NOT NULL,
  `RETURNCNT` bigint(10) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`REGDATE`,`DEPTID`,`USERID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_dailyformcountlog`
--

DROP TABLE IF EXISTS `tbl_dailyformcountlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_dailyformcountlog` (
  `REGDATE` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
  `FORMID` varchar(40) NOT NULL,
  `FORMNAME` varchar(200) DEFAULT NULL,
  `FORMCONTID` varchar(40) NOT NULL,
  `FORMCONTNAME` varchar(200) DEFAULT NULL,
  `DRAFTINGCNT` bigint(10) NOT NULL,
  `DRAFTENDCNT` bigint(10) NOT NULL,
  `DRAFTTIME` double(126,0) NOT NULL,
  `SUSININGCNT` bigint(10) NOT NULL,
  `SUSINENDCNT` bigint(10) NOT NULL,
  `SUSINTIME` double(126,0) NOT NULL,
  `RETURNCNT` bigint(10) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`REGDATE`,`FORMID`,`FORMCONTID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_deletecabinetinfo`
--

DROP TABLE IF EXISTS `tbl_deletecabinetinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_deletecabinetinfo` (
  `CabinetID` varchar(112) NOT NULL,
  `DelUserID` varchar(50) DEFAULT NULL,
  `IPAddress` varchar(50) DEFAULT NULL,
  `companyID` varchar(45) NOT NULL,
  `tenantID` varchar(6) NOT NULL,
  PRIMARY KEY (`CabinetID`,`tenantID`,`companyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_deptcont`
--

DROP TABLE IF EXISTS `tbl_deptcont`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_deptcont` (
  `DEPTCONTID` varchar(40) NOT NULL,
  `DEPTCONTNAME` varchar(1020) DEFAULT NULL,
  `PARENTCONTID` varchar(40) DEFAULT NULL,
  `SN` bigint(10) DEFAULT NULL,
  `DESCRIPTION` varchar(1020) DEFAULT NULL,
  `OWNDEPTID` varchar(400) DEFAULT NULL,
  `MANAGEUSERID` varchar(400) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  UNIQUE KEY `PK_TBL_DEPTCONT` (`TENANT_ID`,`DEPTCONTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_deptcontlist`
--

DROP TABLE IF EXISTS `tbl_deptcontlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_deptcontlist` (
  `DOCID` varchar(80) NOT NULL,
  `DEPTCONTID` varchar(40) NOT NULL,
  `LINKDATE` datetime DEFAULT NULL,
  `DESCRIPTION` varchar(1020) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`DEPTCONTID`),
  KEY `FK_TBL_DEPTCONTLIST_idx` (`TENANT_ID`,`DEPTCONTID`),
  CONSTRAINT `FK_TBL_DEPTCONTLIST` FOREIGN KEY (`TENANT_ID`, `DEPTCONTID`) REFERENCES `tbl_deptcont` (`TENANT_ID`, `DEPTCONTID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_deptmaster`
--

DROP TABLE IF EXISTS `tbl_deptmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_deptmaster` (
  `CN` varchar(80) NOT NULL,
  `DISPLAYNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `DISPLAYNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USEFLAG` varchar(4) DEFAULT NULL,
  `MAIL` varchar(100) DEFAULT NULL,
  `COMPNM2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTLEVEL` varchar(12) DEFAULT NULL,
  `DEPT_CD_PATH` varchar(400) DEFAULT NULL,
  `DEPT_NM_PATH` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(400) DEFAULT NULL,
  `ADFLAG` varchar(4) DEFAULT NULL,
  `ADSPATH` varchar(400) DEFAULT NULL,
  `UPDATEDT` datetime DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `MANUAL_FLAG` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`CN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_depttemplet`
--

DROP TABLE IF EXISTS `tbl_depttemplet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_depttemplet` (
  `USERID` varchar(255) NOT NULL,
  `FORMID` varchar(40) NOT NULL,
  `APRDEPTSN` bigint(10) NOT NULL,
  `APRDEPTTEMPLETNAME` varchar(800) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERID`,`FORMID`,`APRDEPTSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_depttempletdetail`
--

DROP TABLE IF EXISTS `tbl_depttempletdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_depttempletdetail` (
  `USERID` varchar(400) NOT NULL,
  `FORMID` varchar(40) NOT NULL,
  `APRDEPTSN` bigint(10) NOT NULL,
  `APRDEPTMEMBERSN` bigint(10) NOT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERID`(255),`FORMID`,`APRDEPTSN`,`APRDEPTMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_dev_master`
--

DROP TABLE IF EXISTS `tbl_dev_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_dev_master` (
  `DEVSEQ` bigint(20) NOT NULL AUTO_INCREMENT,
  `DEVID` varchar(64) CHARACTER SET utf8 NOT NULL,
  `DEVTYPE` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `SUBTYPE` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `USERID` varchar(100) CHARACTER SET utf8 NOT NULL,
  `TOKEN` varchar(256) CHARACTER SET utf8 DEFAULT NULL,
  `BADGE` int(11) DEFAULT 1,
  `TENANTID` mediumint(5) NOT NULL,
  `STATE` char(1) DEFAULT NULL,
  `PUSHSTATE` char(1) DEFAULT NULL,
  `REGDATE` datetime DEFAULT NULL,
  `ISLOGIN` char(1) DEFAULT NULL,
  `STARTMENU` char(10) DEFAULT NULL,
  `LOGINTIME` datetime DEFAULT NULL,
  `LOGINLOCK` char(1) DEFAULT NULL,
  `ISPASSWORDCHANGE` char(1) DEFAULT NULL,
  `EXTENSION1` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `EXTENSION2` varchar(256) CHARACTER SET utf8 DEFAULT NULL,
  `NOTUSED` int(11) DEFAULT 0,
  PRIMARY KEY (`DEVSEQ`),
  UNIQUE KEY `DEVID_UNIQUE` (`DEVID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_docdeletehistory`
--

DROP TABLE IF EXISTS `tbl_docdeletehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_docdeletehistory` (
  `DOCID` varchar(100) NOT NULL,
  `DOCNO` varchar(45) DEFAULT NULL,
  `DOCTITLE` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTNAME` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERNAME` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DELETEUSERID` varchar(40) DEFAULT NULL,
  `DELETETIME` datetime DEFAULT NULL,
  `TENANT_ID` varchar(45) NOT NULL,
  `COMPANYID` varchar(45) NOT NULL,
  PRIMARY KEY (`DOCID`,`COMPANYID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_docdelivery`
--

DROP TABLE IF EXISTS `tbl_docdelivery`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_docdelivery` (
  `SN` bigint(10) NOT NULL,
  `DOCID` varchar(80) NOT NULL,
  `DEPTID` varchar(400) NOT NULL,
  `HREF` varchar(1020) DEFAULT NULL,
  `RECEIPTDATE` datetime DEFAULT NULL,
  `ORGANID` varchar(400) DEFAULT NULL,
  `ORGAN` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DOCNUMBER` varchar(200) DEFAULT NULL,
  `MANAGEDEPTID` varchar(400) DEFAULT NULL,
  `MANAGEDEPT` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHARGEID` varchar(400) DEFAULT NULL,
  `CHARGENAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `REMARK` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ORGDOCNUMCODE` varchar(200) DEFAULT NULL,
  `DOCTITLE` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MANAGEDEPT2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ORGAN2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHARGENAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  `ORGANUSERNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`SN`,`DOCID`,`DEPTID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_editapprdoc`
--

DROP TABLE IF EXISTS `tbl_editapprdoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_editapprdoc` (
  `SN` bigint(10) NOT NULL AUTO_INCREMENT,
  `DOCID` varchar(80) NOT NULL,
  `BEFOREHTML` text DEFAULT NULL,
  `AFTERHTML` text DEFAULT NULL,
  `USERID` varchar(80) NOT NULL,
  `MODIFYDATE` datetime NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`SN`,`DOCID`,`COMPANYID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endaprdocattachinfo`
--

DROP TABLE IF EXISTS `tbl_endaprdocattachinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endaprdocattachinfo` (
  `DOCID` varchar(80) NOT NULL,
  `ATTACHSN` bigint(10) NOT NULL,
  `ATTACHDOCNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHDOCURL` varchar(1020) DEFAULT NULL,
  `SUBATTACHYN` varchar(4) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`ATTACHSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endaprdocattachinfo_old`
--

DROP TABLE IF EXISTS `tbl_endaprdocattachinfo_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endaprdocattachinfo_old` (
  `DOCID` varchar(80) NOT NULL,
  `ATTACHSN` bigint(10) NOT NULL,
  `ATTACHDOCNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHDOCURL` varchar(1020) DEFAULT NULL,
  `SUBATTACHYN` varchar(4) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`ATTACHSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endaprdocinfo`
--

DROP TABLE IF EXISTS `tbl_endaprdocinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endaprdocinfo` (
  `DOCID` varchar(80) NOT NULL,
  `ORGDOCID` varchar(80) DEFAULT NULL,
  `DOCTYPE` varchar(12) DEFAULT NULL,
  `DOCSTATE` varchar(12) DEFAULT NULL,
  `FUNCTIONTYPE` varchar(12) DEFAULT NULL,
  `HREF` varchar(1020) DEFAULT NULL,
  `DOCTITLE` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DOCNO` varchar(200) DEFAULT NULL,
  `HASATTACHYN` varchar(4) DEFAULT NULL,
  `HASOPINIONYN` varchar(4) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) DEFAULT NULL,
  `WRITERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(400) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMID` varchar(40) DEFAULT NULL,
  `CONTAINERID` varchar(40) DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL COMMENT '공개여부(Y/N)',
  `WRITERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endaprdocinfo_old`
--

DROP TABLE IF EXISTS `tbl_endaprdocinfo_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endaprdocinfo_old` (
  `DOCID` varchar(80) NOT NULL,
  `ORGDOCID` varchar(80) DEFAULT NULL,
  `DOCTYPE` varchar(12) DEFAULT NULL,
  `DOCSTATE` varchar(12) DEFAULT NULL,
  `FUNCTIONTYPE` varchar(12) DEFAULT NULL,
  `HREF` varchar(1020) DEFAULT NULL,
  `DOCTITLE` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DOCNO` varchar(200) DEFAULT NULL,
  `HASATTACHYN` varchar(4) DEFAULT NULL,
  `HASOPINIONYN` varchar(4) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) DEFAULT NULL,
  `WRITERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(400) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMID` varchar(40) DEFAULT NULL,
  `CONTAINERID` varchar(40) DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL COMMENT '공개여부(Y/N)',
  `WRITERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endaprdocinfo_old`
--

DROP TABLE IF EXISTS `tbl_endaprdocinfo_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endaprdocinfo_old` (
  `DOCID` varchar(80) NOT NULL,
  `ORGDOCID` varchar(80) DEFAULT NULL,
  `DOCTYPE` varchar(12) DEFAULT NULL,
  `DOCSTATE` varchar(12) DEFAULT NULL,
  `FUNCTIONTYPE` varchar(12) DEFAULT NULL,
  `HREF` varchar(1020) DEFAULT NULL,
  `DOCTITLE` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DOCNO` varchar(200) DEFAULT NULL,
  `HASATTACHYN` varchar(4) DEFAULT NULL,
  `HASOPINIONYN` varchar(4) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) DEFAULT NULL,
  `WRITERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(400) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMID` varchar(40) DEFAULT NULL,
  `CONTAINERID` varchar(40) DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL COMMENT '공개여부(Y/N)',
  `WRITERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endaprlineinfo`
--

DROP TABLE IF EXISTS `tbl_endaprlineinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endaprlineinfo` (
  `DOCID` varchar(80) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `APRTYPE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERISDEPTYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(400) DEFAULT NULL,
  `RECEIVEDDATE` datetime DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `REASONDONOTAPPROVAL` varchar(1020) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  `CONTAINERDEPTID` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`APRMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endaprlineinfo_old`
--

DROP TABLE IF EXISTS `tbl_endaprlineinfo_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endaprlineinfo_old` (
  `DOCID` varchar(80) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `APRTYPE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERISDEPTYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(400) DEFAULT NULL,
  `RECEIVEDDATE` datetime DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `REASONDONOTAPPROVAL` varchar(1020) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  `CONTAINERDEPTID` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`APRMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endapropinioninfo`
--

DROP TABLE IF EXISTS `tbl_endapropinioninfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endapropinioninfo` (
  `DOCID` varchar(80) NOT NULL,
  `USERID` varchar(400) NOT NULL,
  `OPINIONGB` varchar(12) DEFAULT NULL COMMENT '001:일반의견, 002:반송의견, 003:보류의견, 004:회송의견',
  `CONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTID` varchar(400) DEFAULT NULL,
  `USERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OPINIONSN` bigint(10) NOT NULL,
  `USERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`USERID`(255),`OPINIONSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endapropinioninfo_old`
--

DROP TABLE IF EXISTS `tbl_endapropinioninfo_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endapropinioninfo_old` (
  `DOCID` varchar(80) NOT NULL,
  `USERID` varchar(400) NOT NULL,
  `OPINIONGB` varchar(12) DEFAULT NULL COMMENT '001:일반의견, 002:반송의견, 003:보류의견, 004:회송의견',
  `CONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTID` varchar(400) DEFAULT NULL,
  `USERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OPINIONSN` bigint(10) NOT NULL,
  `USERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`USERID`(255),`OPINIONSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endattachinfo`
--

DROP TABLE IF EXISTS `tbl_endattachinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endattachinfo` (
  `DOCID` varchar(80) NOT NULL,
  `ATTACHFILESN` bigint(10) NOT NULL,
  `ATTACHFILENAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILESIZE` double(126,0) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(600) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BODYATTACH` varchar(4) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`ATTACHFILESN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endattachinfo_old`
--

DROP TABLE IF EXISTS `tbl_endattachinfo_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endattachinfo_old` (
  `DOCID` varchar(80) NOT NULL,
  `ATTACHFILESN` bigint(10) NOT NULL,
  `ATTACHFILENAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILESIZE` double(126,0) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(600) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BODYATTACH` varchar(4) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`ATTACHFILESN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endreceiptpointinfo`
--

DROP TABLE IF EXISTS `tbl_endreceiptpointinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endreceiptpointinfo` (
  `DOCID` varchar(80) NOT NULL,
  `RECEIPTPOINTID` varchar(400) NOT NULL,
  `RECEIPTPOINTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL COMMENT '수신 상태 관련 - H:회송,  I:진행,  N:대기,  Y:완료, B:배부',
  `PROCESSSN` bigint(10) NOT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERID` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTMEMBERSN` bigint(10) DEFAULT NULL,
  `RECEIPTPOINTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`RECEIPTPOINTID`(255),`PROCESSSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endreceiptpointinfo_old`
--

DROP TABLE IF EXISTS `tbl_endreceiptpointinfo_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endreceiptpointinfo_old` (
  `DOCID` varchar(80) NOT NULL,
  `RECEIPTPOINTID` varchar(400) NOT NULL,
  `RECEIPTPOINTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL COMMENT '수신 상태 관련 - H:회송,  I:진행,  N:대기,  Y:완료, B:배부',
  `PROCESSSN` bigint(10) NOT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERID` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTMEMBERSN` bigint(10) DEFAULT NULL,
  `RECEIPTPOINTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`RECEIPTPOINTID`(255),`PROCESSSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_endreceiptprocessinfo`
--

DROP TABLE IF EXISTS `tbl_endreceiptprocessinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_endreceiptprocessinfo` (
  `RECEIVESN` bigint(10) NOT NULL,
  `DOCID` varchar(80) NOT NULL,
  `SENTDEPTID` varchar(400) DEFAULT NULL,
  `SENTDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIVEDDEPTID` varchar(400) NOT NULL,
  `RECEIVEDDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DOCSTATE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSDOCID` varchar(80) DEFAULT NULL,
  `PROCESSORID` varchar(400) DEFAULT NULL,
  `PROCESSORNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSORJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PARENTSDOCID` varchar(80) DEFAULT NULL,
  `SENTDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIVEDDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSORNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSORJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECEIVESN`,`DOCID`,`RECEIVEDDEPTID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_expaprdocinfo`
--

DROP TABLE IF EXISTS `tbl_expaprdocinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_expaprdocinfo` (
  `DOCID` varchar(80) NOT NULL,
  `SECURITYCODE` bigint(10) DEFAULT NULL COMMENT '100:1등급, 200:2등급, 300:3등급, 400:4등급, 500:5등급',
  `STORAGEPERIOD` varchar(160) DEFAULT NULL COMMENT '1:1년, 2:2년, 3:3년, 5:5년, 10:10년, 100:준영구, 1000:영구',
  `KEYWORD` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `ITEMCODE` varchar(160) DEFAULT NULL,
  `ITEMNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `URGENTAPPROVAL` varchar(4) DEFAULT NULL COMMENT '긴급결재(Y/N)',
  `SECURITYAPPROVAL` varchar(40) DEFAULT NULL,
  `TEMPATTRIBUTE` varchar(200) DEFAULT NULL,
  `STATUS` varchar(4) DEFAULT NULL,
  `SPECIALRECORDCODE` varchar(20) DEFAULT NULL,
  `PUBLICITYCODE` varchar(36) DEFAULT NULL,
  `LIMITRANGE` varchar(400) DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `CABINETID` varchar(112) DEFAULT NULL,
  `TASKCODE` varchar(32) DEFAULT NULL,
  `DOCNUMCODE` varchar(200) DEFAULT NULL,
  `ORGDOCNUMCODE` varchar(200) DEFAULT NULL,
  `SEPERATEATTACHXML` longtext DEFAULT NULL,
  `SUMMARY` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMNAME2` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ITEMNAME2` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `PUBLICITYYN` char(2) DEFAULT NULL,
  `FORMVERSION` int(11) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_expaprline`
--

DROP TABLE IF EXISTS `tbl_expaprline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_expaprline` (
  `DOCID` varchar(80) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `ORGUSERID` varchar(200) NOT NULL,
  `PROXYUSERID` varchar(400) DEFAULT NULL,
  `PROXYUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERDEPTID` varchar(400) DEFAULT NULL,
  `PROXYUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`APRMEMBERSN`,`ORGUSERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_expendaprdocinfo`
--

DROP TABLE IF EXISTS `tbl_expendaprdocinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_expendaprdocinfo` (
  `DOCID` varchar(80) NOT NULL,
  `SECURITYCODE` bigint(10) DEFAULT NULL COMMENT '100:1등급, 200:2등급, 300:3등급, 400:4등급, 500:5등급',
  `STORAGEPERIOD` varchar(160) DEFAULT NULL COMMENT '1:1년, 2:2년, 3:3년, 5:5년, 10:10년, 100:준영구, 1000:영구',
  `KEYWORD` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ORGCONTID` varchar(40) DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT NULL,
  `FORMNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `ITEMCODE` varchar(160) DEFAULT NULL,
  `ITEMNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `URGENTAPPROVAL` varchar(4) DEFAULT NULL COMMENT '긴급결재(Y/N)',
  `SECURITYAPPROVAL` varchar(40) DEFAULT NULL,
  `TEMPATTRIBUTE` varchar(200) DEFAULT NULL,
  `STATUS` varchar(4) DEFAULT NULL,
  `EDMSYN` varchar(4) DEFAULT NULL,
  `SPECIALRECORDCODE` varchar(20) DEFAULT NULL,
  `PUBLICITYCODE` varchar(36) DEFAULT NULL,
  `LIMITRANGE` varchar(400) DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `CABINETID` varchar(112) DEFAULT NULL,
  `TASKCODE` varchar(32) DEFAULT NULL,
  `DOCNUMCODE` varchar(52) DEFAULT NULL,
  `ORGDOCNUMCODE` varchar(52) DEFAULT NULL,
  `SEPERATEATTACHXML` longtext DEFAULT NULL,
  `SUMMARY` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMNAME2` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ITEMNAME2` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SIGNCHECK` varchar(4) NOT NULL DEFAULT 'N',
  `TENANT_ID` mediumint(5) NOT NULL,
  `PUBLICITYYN` char(2) DEFAULT NULL,
  `FORMVERSION` int(11) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`),
  KEY `TBL_EXPENDAPRDOCINFO_NONIDX1` (`TENANT_ID`,`COMPANYID`,`DOCID`,`DELFLAG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_expendaprdocinfo_old`
--

DROP TABLE IF EXISTS `tbl_expendaprdocinfo_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_expendaprdocinfo_old` (
  `DOCID` varchar(80) NOT NULL,
  `SECURITYCODE` bigint(10) DEFAULT NULL COMMENT '100:1등급, 200:2등급, 300:3등급, 400:4등급, 500:5등급',
  `STORAGEPERIOD` varchar(160) DEFAULT NULL COMMENT '1:1년, 2:2년, 3:3년, 5:5년, 10:10년, 100:준영구, 1000:영구',
  `KEYWORD` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ORGCONTID` varchar(40) DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT NULL,
  `FORMNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `ITEMCODE` varchar(160) DEFAULT NULL,
  `ITEMNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `URGENTAPPROVAL` varchar(4) DEFAULT NULL COMMENT '긴급결재(Y/N)',
  `SECURITYAPPROVAL` varchar(40) DEFAULT NULL,
  `TEMPATTRIBUTE` varchar(200) DEFAULT NULL,
  `STATUS` varchar(4) DEFAULT NULL,
  `EDMSYN` varchar(4) DEFAULT NULL,
  `SPECIALRECORDCODE` varchar(20) DEFAULT NULL,
  `PUBLICITYCODE` varchar(36) DEFAULT NULL,
  `LIMITRANGE` varchar(400) DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `CABINETID` varchar(112) DEFAULT NULL,
  `TASKCODE` varchar(32) DEFAULT NULL,
  `DOCNUMCODE` varchar(52) DEFAULT NULL,
  `ORGDOCNUMCODE` varchar(52) DEFAULT NULL,
  `SEPERATEATTACHXML` longtext DEFAULT NULL,
  `SUMMARY` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMNAME2` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ITEMNAME2` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SIGNCHECK` varchar(4) NOT NULL DEFAULT 'N',
  `TENANT_ID` mediumint(5) NOT NULL,
  `PUBLICITYYN` char(2) DEFAULT NULL,
  `FORMVERSION` int(11) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`),
  KEY `TBL_EXPENDAPRDOCINFO_NONIDX1` (`TENANT_ID`,`COMPANYID`,`DOCID`,`DELFLAG`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_expendaprline`
--

DROP TABLE IF EXISTS `tbl_expendaprline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_expendaprline` (
  `DOCID` varchar(80) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `ORGUSERID` varchar(255) NOT NULL,
  `PROXYUSERID` varchar(400) DEFAULT NULL,
  `PROXYUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERDEPTID` varchar(400) DEFAULT NULL,
  `PROXYUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`ORGUSERID`,`APRMEMBERSN`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_expendaprline_old`
--

DROP TABLE IF EXISTS `tbl_expendaprline_old`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_expendaprline_old` (
  `DOCID` varchar(80) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `ORGUSERID` varchar(255) NOT NULL,
  `PROXYUSERID` varchar(400) DEFAULT NULL,
  `PROXYUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERDEPTID` varchar(400) DEFAULT NULL,
  `PROXYUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`ORGUSERID`,`APRMEMBERSN`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_form_autorule`
--

DROP TABLE IF EXISTS `tbl_form_autorule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_form_autorule` (
  `FORMID` varchar(40) NOT NULL,
  `AUTORULESN` bigint(10) NOT NULL,
  `AUTORULEGUID` varchar(50) NOT NULL,
  `CHECKFIELDTYPE` varchar(50) DEFAULT NULL,
  `CHECKFIELD` varchar(100) DEFAULT NULL,
  `OPERATORTYPE` varchar(10) DEFAULT NULL,
  `OPERATOR` varchar(10) DEFAULT NULL,
  `CONDTYPE` varchar(10) DEFAULT NULL,
  `CONDVALUE` varchar(100) DEFAULT NULL,
  `CONDVALUEDEPTID` varchar(100) DEFAULT NULL,
  `RESULTAPRTYPE` varchar(6) DEFAULT NULL,
  `RESULTAPRMEMEBERID` varchar(50) DEFAULT NULL,
  `FIXFLAG` varchar(4) DEFAULT NULL,
  `DOCTYPE` varchar(10) DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`FORMID`,`AUTORULESN`,`AUTORULEGUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_form_autoruleline`
--

DROP TABLE IF EXISTS `tbl_form_autoruleline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_form_autoruleline` (
  `FORMID` varchar(40) NOT NULL,
  `AUTORULEGUID` varchar(50) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `APRTYPE` varchar(24) DEFAULT NULL,
  `APRSTATE` varchar(24) DEFAULT NULL,
  `APRMEMBERID` varchar(100) DEFAULT NULL,
  `APRMEMBERISDEPTYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(100) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(100) DEFAULT NULL,
  `RECEIVEDDATE` datetime DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `REASONDONOTAPPROV` varchar(255) DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`FORMID`,`AUTORULEGUID`,`APRMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_form_office`
--

DROP TABLE IF EXISTS `tbl_form_office`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_form_office` (
  `FORMID` varchar(40) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`FORMID`,`TENANT_ID`,`COMPANYID`),
  CONSTRAINT `FK_TBL_FORMINFO` FOREIGN KEY (`FORMID`, `TENANT_ID`, `COMPANYID`) REFERENCES `tbl_forminfo` (`FORMID`, `TENANT_ID`, `COMPANYID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='전자결재 양식이 오피스 양식인지 아닌지를 구분해주는 테이블. 이 테이블에 존재하는 양식은 모두 오피스 양식이다.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_formconninfo`
--

DROP TABLE IF EXISTS `tbl_formconninfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_formconninfo` (
  `SN` bigint(10) NOT NULL AUTO_INCREMENT,
  `CONNNODE` varchar(40) NOT NULL,
  `CONNINFO` varchar(40) NOT NULL,
  `DESCRIPTION` varchar(100) DEFAULT NULL,
  `UPPERNODE` varchar(100) NOT NULL,
  PRIMARY KEY (`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_formcontainer`
--

DROP TABLE IF EXISTS `tbl_formcontainer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_formcontainer` (
  `FORMCONTID` varchar(40) NOT NULL,
  `FORMCONTNAME` varchar(191) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `FORMCONTOWNDEPID` varchar(255) NOT NULL,
  `FORMCONTPARENTS` varchar(200) NOT NULL,
  `FORMCONTDESCRIPTION` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMCONTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`FORMCONTID`,`FORMCONTNAME`,`FORMCONTOWNDEPID`,`FORMCONTPARENTS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_formcontusergroup`
--

DROP TABLE IF EXISTS `tbl_formcontusergroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_formcontusergroup` (
  `FORMCONTID` varchar(40) NOT NULL,
  `FORMCONTUSERDEPID` varchar(400) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`FORMCONTID`,`FORMCONTUSERDEPID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_formgroup`
--

DROP TABLE IF EXISTS `tbl_formgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_formgroup` (
  `SN` bigint(10) NOT NULL,
  `FORMGROUPID` varchar(200) DEFAULT NULL,
  `FORMID` varchar(40) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_forminfo`
--

DROP TABLE IF EXISTS `tbl_forminfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_forminfo` (
  `FORMCONTID` varchar(40) DEFAULT NULL,
  `FORMID` varchar(40) NOT NULL,
  `FORMNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMNAME2` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMDOCTYPE` varchar(24) NOT NULL,
  `FORMDESCRIPTION` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMFILELOCATION` varchar(200) NOT NULL,
  `FORMCONNFLAG` varchar(4) DEFAULT 'N',
  `FORMGAMSAFLAG` varchar(4) DEFAULT '1',
  `FORMDRAFTALLFLAG` varchar(4) DEFAULT 'N',
  `FORMORDER` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `REFORMFLAG` varchar(4) DEFAULT 'N',
  `INFORMALFLAG` int(11) DEFAULT 0,
  `FORMVERSION` int(11) DEFAULT 0,
  `OPENGOVFLAG` varchar(4) DEFAULT 'N',
  `DRAFTALLFLAG` varchar(4) DEFAULT 'N',
  `formxslt` longtext DEFAULT NULL COMMENT '연동에서 XML을 HTML로 변환하기 위해 필요한 XSLT정보',
  `passaprlineflag` varchar(4) DEFAULT 'N' COMMENT '기결재통과플래그',
  `FORMGUIDE` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`FORMID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_formproperty`
--

DROP TABLE IF EXISTS `tbl_formproperty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_formproperty` (
  `SN` decimal(22,0) NOT NULL,
  `CODE` varchar(36) NOT NULL,
  `ID` varchar(100) DEFAULT NULL,
  `NAME` varchar(100) DEFAULT NULL,
  `DESCRIPTION` varchar(100) DEFAULT NULL,
  `UPPERCODE` varchar(36) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_formrecv`
--

DROP TABLE IF EXISTS `tbl_formrecv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_formrecv` (
  `FORMID` varchar(40) NOT NULL,
  `DEPTID` varchar(400) NOT NULL,
  `DEPTSN` bigint(10) DEFAULT NULL,
  `USERID` varchar(400) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `DEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`FORMID`,`DEPTID`(255),`TENANT_ID`,`COMPANYID`),
  UNIQUE KEY `PK_TBL_FORMRECV` (`TENANT_ID`,`COMPANYID`,`FORMID`,`DEPTID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_formuserinfo`
--

DROP TABLE IF EXISTS `tbl_formuserinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_formuserinfo` (
  `FORMID` varchar(40) NOT NULL,
  `USERID` varchar(400) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`FORMID`,`USERID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_gongramlineinfo`
--

DROP TABLE IF EXISTS `tbl_gongramlineinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_gongramlineinfo` (
  `DOCID` varchar(80) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `APRTYPE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERISDEPTYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(400) DEFAULT NULL,
  `RECEIVEDDATE` datetime DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `REASONDONOTAPPROV` varchar(1020) DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`DOCID`,`COMPANYID`,`TENANT_ID`,`APRMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_historyattachinfo`
--

DROP TABLE IF EXISTS `tbl_historyattachinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_historyattachinfo` (
  `DOCID` varchar(80) NOT NULL,
  `ATTACHFILESN` bigint(10) NOT NULL,
  `ATTACHFILENAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILEDISPLAYNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILESIZE` double(126,0) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `MODIFYSN` bigint(10) NOT NULL,
  `MODIFYFLAG` varchar(80) DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `CHKFLAG` varchar(4) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`ATTACHFILESN`,`MODIFYSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_historydocinfo`
--

DROP TABLE IF EXISTS `tbl_historydocinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_historydocinfo` (
  `DOCID` varchar(80) NOT NULL,
  `CHANGESN` bigint(10) NOT NULL,
  `URL` varchar(1020) DEFAULT NULL,
  `CHANGEUSERID` varchar(400) DEFAULT NULL,
  `CHANGEUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHANGEUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHANGEUSERDEPTID` varchar(400) DEFAULT NULL,
  `CHANGEUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHANGEDATE` datetime DEFAULT NULL,
  `CHKFLAG` varchar(4) DEFAULT NULL,
  `CHANGEUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHANGEUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHANGEUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`CHANGESN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_historylineinfo`
--

DROP TABLE IF EXISTS `tbl_historylineinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_historylineinfo` (
  `DOCID` varchar(80) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `APRTYPE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERISDEPTYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(400) DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `MODIFYSN` bigint(10) NOT NULL,
  `MODIFYUSERID` varchar(400) DEFAULT NULL,
  `MODIFYUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYUSERDEPTID` varchar(400) DEFAULT NULL,
  `MODIFYUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHKFLAG` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`APRMEMBERSN`,`MODIFYSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_historyreceiptinfo`
--

DROP TABLE IF EXISTS `tbl_historyreceiptinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_historyreceiptinfo` (
  `DOCID` varchar(80) NOT NULL,
  `RECEIPTDEPTID` varchar(255) NOT NULL,
  `RECEIPTDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `STATUS` varchar(4) DEFAULT NULL,
  `STATUSDATE` datetime DEFAULT NULL,
  `RECEIPTDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_holidaylist`
--

DROP TABLE IF EXISTS `tbl_holidaylist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_holidaylist` (
  `HOLIDAYID` bigint(10) NOT NULL AUTO_INCREMENT,
  `HOLIDAYNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `HOLIDAYNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `HOLIDAYFLAG` varchar(45) DEFAULT NULL,
  `HOLIDAYDATE` datetime DEFAULT NULL,
  `HOLIDAYREPEAT` varchar(45) DEFAULT NULL,
  `ISSOLAR` bigint(10) DEFAULT NULL,
  `ISREPEAT` bigint(10) DEFAULT NULL,
  `ISREST` bigint(10) DEFAULT NULL,
  `ISUSE` bigint(10) DEFAULT NULL,
  `USECOMPANY` varchar(80) DEFAULT NULL,
  `TENANT_ID` mediumint(5) DEFAULT NULL,
  PRIMARY KEY (`HOLIDAYID`),
  UNIQUE KEY `IDX_TBL_HOLIDAYLIST` (`TENANT_ID`,`HOLIDAYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal`
--

DROP TABLE IF EXISTS `tbl_journal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal` (
  `journal_id` bigint(10) NOT NULL AUTO_INCREMENT COMMENT '일지 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `journal_title` varchar(200) DEFAULT NULL COMMENT '일지 제목',
  `journal_content` longtext DEFAULT NULL COMMENT '일지 내용',
  `journal_date` datetime DEFAULT NULL COMMENT '일지 일',
  `journal_writer` varchar(100) DEFAULT NULL COMMENT '일지 작성자',
  `form_id` bigint(10) DEFAULT NULL COMMENT '양식 아이디',
  `dept_share` varchar(4) DEFAULT NULL COMMENT '부서 공유',
  `journal_status` varchar(10) DEFAULT NULL COMMENT '일지 상태',
  `journal_dept` varchar(100) DEFAULT NULL,
  `journal_text` longtext DEFAULT NULL,
  `journal_sum` varchar(4) DEFAULT 'N',
  PRIMARY KEY (`journal_id`,`tenant_id`),
  KEY `FK_tbl_journal_form_id_tbl_journal_form_form_id` (`form_id`),
  CONSTRAINT `FK_tbl_journal_form_id_tbl_journal_form_form_id` FOREIGN KEY (`form_id`) REFERENCES `tbl_journal_form` (`form_id`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='일지';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_auth`
--

DROP TABLE IF EXISTS `tbl_journal_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_auth` (
  `user_id` varchar(100) NOT NULL COMMENT '사원아이디',
  `dept_id` varchar(100) NOT NULL COMMENT '부서아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='열람권한';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_env`
--

DROP TABLE IF EXISTS `tbl_journal_env`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_env` (
  `user_id` varchar(100) NOT NULL COMMENT '사원아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `list_cnt` int(10) DEFAULT 20 COMMENT '리스트 수',
  `viewenv` varchar(10) DEFAULT 'NONE' COMMENT '미리보기(NONE:기본,W:가로분할보기,H:세로분할보기)',
  `preview_wcontent` int(10) DEFAULT 50 COMMENT '가로분할보기시 본문영역길이',
  `preview_hcontent` int(10) DEFAULT 50 COMMENT '세로분할보기시 본문영역길이',
  `reply_alert` varchar(4) DEFAULT 'Y' COMMENT '댓글 알림',
  `recv_alert` varchar(4) DEFAULT 'Y' COMMENT '수신 알림',
  PRIMARY KEY (`user_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='환경설정';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_file`
--

DROP TABLE IF EXISTS `tbl_journal_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_file` (
  `file_id` bigint(10) NOT NULL AUTO_INCREMENT COMMENT '파일 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `file_path` varchar(200) DEFAULT NULL COMMENT '파일 경로',
  `journal_id` bigint(10) DEFAULT NULL COMMENT '일지 아이디',
  `file_size` varchar(45) DEFAULT NULL,
  `file_name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`file_id`,`tenant_id`),
  KEY `FK_tbl_journal_file_journal_id_tbl_journal_journal_id` (`journal_id`),
  CONSTRAINT `FK_tbl_journal_file_journal_id_tbl_journal_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `tbl_journal` (`journal_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='첨부파일';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_form`
--

DROP TABLE IF EXISTS `tbl_journal_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_form` (
  `form_id` bigint(10) NOT NULL AUTO_INCREMENT COMMENT '양식 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `form_name` varchar(200) NOT NULL COMMENT '양식 명',
  `form_content` text DEFAULT NULL COMMENT '양식 내용',
  `type_id` varchar(80) NOT NULL COMMENT '함 아이디',
  `form_date` datetime NOT NULL COMMENT '양식 일',
  `form_writer` varchar(100) DEFAULT NULL COMMENT '양식 작성자',
  `form_info` varchar(4000) DEFAULT NULL COMMENT '양식 설명',
  `form_status` varchar(10) DEFAULT NULL COMMENT '양식 상태',
  `company_id` varchar(80) NOT NULL COMMENT '회사 아이디',
  `form_del_flag` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`form_id`,`tenant_id`),
  KEY `FK_tbl_journal_form_type_id_tbl_journal_form_type_type_id_idx` (`type_id`),
  KEY `FK_tbl_journal_form_company_id_tbl_journal_form_type_compan_idx` (`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='양식';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_form_type`
--

DROP TABLE IF EXISTS `tbl_journal_form_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_form_type` (
  `type_id` varchar(80) NOT NULL COMMENT '함 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `company_id` varchar(80) NOT NULL COMMENT '회사 아이디',
  `used` varchar(10) NOT NULL DEFAULT 'use' COMMENT '사용',
  PRIMARY KEY (`type_id`,`tenant_id`,`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='양식함';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_form_use_dept`
--

DROP TABLE IF EXISTS `tbl_journal_form_use_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_form_use_dept` (
  `dept_id` varchar(100) NOT NULL COMMENT '부서 아이디',
  `form_id` bigint(10) NOT NULL COMMENT '양식 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  KEY `FK_tbl_journal_form_user_dept_form_id_tbl_journal_form_form_id` (`form_id`),
  CONSTRAINT `FK_tbl_journal_form_user_dept_form_id_tbl_journal_form_form_id` FOREIGN KEY (`form_id`) REFERENCES `tbl_journal_form` (`form_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='양식사용부서';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_order`
--

DROP TABLE IF EXISTS `tbl_journal_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_order` (
  `user_id` varchar(80) NOT NULL,
  `related_user_id` varchar(80) NOT NULL,
  `user_order` mediumint(11) NOT NULL DEFAULT 1,
  `tenant_id` mediumint(11) NOT NULL,
  PRIMARY KEY (`user_id`,`related_user_id`,`tenant_id`),
  KEY `idx1` (`user_id`,`user_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_recv`
--

DROP TABLE IF EXISTS `tbl_journal_recv`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_recv` (
  `user_id` varchar(100) NOT NULL COMMENT '사원아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `journal_id` bigint(10) DEFAULT NULL COMMENT '일지 아이디',
  `recieve_date` datetime DEFAULT NULL COMMENT '수신 일',
  `recv_status` varchar(4) DEFAULT 'Y',
  KEY `FK_tbl_journal_recv_journal_id_tbl_journal_journal_id` (`journal_id`),
  CONSTRAINT `FK_tbl_journal_recv_journal_id_tbl_journal_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `tbl_journal` (`journal_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='수신';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_recv_favorite`
--

DROP TABLE IF EXISTS `tbl_journal_recv_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_recv_favorite` (
  `favorite_id` bigint(10) NOT NULL AUTO_INCREMENT COMMENT '즐찾 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `user_id` varchar(100) DEFAULT NULL COMMENT '사원아이디',
  `favorite_name` varchar(200) DEFAULT NULL COMMENT '즐찾 명',
  `favorite_date` datetime DEFAULT NULL COMMENT '즐찾 일',
  PRIMARY KEY (`favorite_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='즐찾';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_recv_favorite_list`
--

DROP TABLE IF EXISTS `tbl_journal_recv_favorite_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_recv_favorite_list` (
  `favorite_id` bigint(10) NOT NULL COMMENT '즐찾 아이디',
  `user_id` varchar(100) DEFAULT NULL COMMENT '사원아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  KEY `FK_tbl_journal_recv_favorite_list_favorite_id` (`favorite_id`),
  CONSTRAINT `FK_tbl_journal_recv_favorite_list_favorite_id` FOREIGN KEY (`favorite_id`) REFERENCES `tbl_journal_recv_favorite` (`favorite_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='즐찾 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_reply`
--

DROP TABLE IF EXISTS `tbl_journal_reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_reply` (
  `reply_id` bigint(10) NOT NULL AUTO_INCREMENT COMMENT '댓글 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `reply_content` varchar(4000) DEFAULT NULL COMMENT '댓글 내용',
  `journal_id` bigint(10) NOT NULL COMMENT '일지 아이디',
  `reply_date` datetime DEFAULT NULL COMMENT '댓글 일',
  `reply_writer` varchar(100) DEFAULT NULL COMMENT '댓글 작성자',
  PRIMARY KEY (`reply_id`,`tenant_id`),
  KEY `FK_tbl_journal_reply_journal_id_tbl_journal_journal_id` (`journal_id`),
  CONSTRAINT `FK_tbl_journal_reply_journal_id_tbl_journal_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `tbl_journal` (`journal_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='댓글';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_symbol`
--

DROP TABLE IF EXISTS `tbl_journal_symbol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_symbol` (
  `symbol_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `symbol_level` int(11) NOT NULL DEFAULT 1,
  `symbol_str` varbinary(50) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `tenant_id` mediumint(9) NOT NULL,
  PRIMARY KEY (`symbol_id`),
  UNIQUE KEY `symbol_str_company_id_tenant_id` (`symbol_str`,`company_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_journal_view`
--

DROP TABLE IF EXISTS `tbl_journal_view`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_journal_view` (
  `user_id` varchar(100) NOT NULL COMMENT '사원아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `journal_id` bigint(10) NOT NULL COMMENT '일지 아이디',
  `view_date` datetime DEFAULT NULL COMMENT '확인 일',
  PRIMARY KEY (`user_id`,`tenant_id`,`journal_id`),
  KEY `FK_tbl_journal_view_journal_id_tbl_journal_journal_id` (`journal_id`),
  CONSTRAINT `FK_tbl_journal_view_journal_id_tbl_journal_journal_id` FOREIGN KEY (`journal_id`) REFERENCES `tbl_journal` (`journal_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='일지조회';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ladder`
--

DROP TABLE IF EXISTS `tbl_ladder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ladder` (
  `tenant_id` mediumint(5) NOT NULL,
  `ladderid` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(500) DEFAULT NULL,
  `type` tinyint(4) NOT NULL,
  `status` tinyint(4) DEFAULT 0,
  `secretflag` tinyint(4) DEFAULT 0,
  `writerid` varchar(80) NOT NULL,
  `writername` varchar(120) NOT NULL,
  `writername2` varchar(120) DEFAULT NULL,
  `deptname` varchar(100) NOT NULL,
  `deptname2` varchar(100) DEFAULT NULL,
  `linecnt` smallint(6) NOT NULL,
  `linearray` text DEFAULT NULL,
  `deleteflag` tinyint(4) DEFAULT 0,
  `writedate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `startdate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `deletedate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `companyid` varchar(80) DEFAULT NULL,
  `deptID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`ladderid`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ladder_bm`
--

DROP TABLE IF EXISTS `tbl_ladder_bm`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ladder_bm` (
  `tenant_id` mediumint(5) NOT NULL,
  `ladderbmid` bigint(20) NOT NULL AUTO_INCREMENT,
  `bmname` varchar(100) DEFAULT NULL,
  `userId` varchar(80) NOT NULL,
  `regdate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `companyID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`ladderbmid`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ladder_bmuser`
--

DROP TABLE IF EXISTS `tbl_ladder_bmuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ladder_bmuser` (
  `tenant_id` mediumint(5) NOT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ladderbmid` bigint(20) NOT NULL,
  `userId` varchar(80) DEFAULT NULL,
  `username` varchar(120) NOT NULL,
  `username2` varchar(120) DEFAULT NULL,
  `companyID` varchar(80) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `description2` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`,`tenant_id`),
  KEY `fk_tbl_ladder_bmuser` (`ladderbmid`),
  CONSTRAINT `fk_tbl_ladder_bmuser` FOREIGN KEY (`ladderbmid`) REFERENCES `tbl_ladder_bm` (`ladderbmid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ladder_codelist`
--

DROP TABLE IF EXISTS `tbl_ladder_codelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ladder_codelist` (
  `tenant_id` mediumint(5) NOT NULL,
  `code` varchar(20) NOT NULL,
  `language` tinyint(4) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`tenant_id`,`code`,`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ladder_comment`
--

DROP TABLE IF EXISTS `tbl_ladder_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ladder_comment` (
  `tenant_id` mediumint(5) NOT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ladderid` bigint(20) NOT NULL,
  `comment` text DEFAULT NULL,
  `userid` varchar(80) NOT NULL,
  `username` varchar(120) NOT NULL,
  `username2` varchar(120) DEFAULT NULL,
  `writedate` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `deptID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`,`tenant_id`),
  KEY `tbl_ladder_comment_fk` (`ladderid`),
  CONSTRAINT `tbl_ladder_comment_fk` FOREIGN KEY (`ladderid`) REFERENCES `tbl_ladder` (`ladderid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ladder_line`
--

DROP TABLE IF EXISTS `tbl_ladder_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ladder_line` (
  `tenant_id` mediumint(5) NOT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ladderid` bigint(20) NOT NULL,
  `userid` varchar(80) DEFAULT NULL,
  `username` varchar(120) NOT NULL,
  `username2` varchar(120) DEFAULT NULL,
  `item` varchar(100) DEFAULT NULL,
  `ladderorder` smallint(6) NOT NULL,
  `resultuserid` varchar(80) DEFAULT NULL,
  `resultusername` varchar(120) DEFAULT NULL,
  `resultusername2` varchar(120) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `description2` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`,`tenant_id`),
  KEY `tbl_ladder_line_fk` (`ladderid`),
  CONSTRAINT `tbl_ladder_line_fk` FOREIGN KEY (`ladderid`) REFERENCES `tbl_ladder` (`ladderid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ladder_order`
--

DROP TABLE IF EXISTS `tbl_ladder_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ladder_order` (
  `tenant_id` mediumint(5) NOT NULL,
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ladderid` bigint(20) NOT NULL,
  `changeladderid` bigint(20) DEFAULT NULL,
  `userId` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`,`tenant_id`),
  KEY `fk_tbl_ladder_order` (`ladderid`),
  CONSTRAINT `fk_tbl_ladder_order` FOREIGN KEY (`ladderid`) REFERENCES `tbl_ladder` (`ladderid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_lastaprline`
--

DROP TABLE IF EXISTS `tbl_lastaprline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_lastaprline` (
  `USERID` varchar(400) NOT NULL,
  `FORMID` varchar(40) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `APRTYPE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERISDEPTYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(400) DEFAULT NULL,
  `RECEIVEDDATE` datetime DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `REASONDONOTAPPROV` varchar(1020) DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERID`(255),`FORMID`,`APRMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_lastdeptline`
--

DROP TABLE IF EXISTS `tbl_lastdeptline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_lastdeptline` (
  `USERID` varchar(400) NOT NULL,
  `FORMID` varchar(40) NOT NULL,
  `RECEIPTPOINTID` varchar(400) NOT NULL,
  `RECEIPTPOINTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSSN` bigint(10) DEFAULT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERID` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTMEMBERSN` bigint(10) DEFAULT NULL,
  `RECEIPTPOINTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERID`(255),`FORMID`,`RECEIPTPOINTID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_lastdocid`
--

DROP TABLE IF EXISTS `tbl_lastdocid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_lastdocid` (
  `LASTDOCID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`LASTDOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_lintemplet`
--

DROP TABLE IF EXISTS `tbl_lintemplet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_lintemplet` (
  `USERID` varchar(400) NOT NULL,
  `FORMID` varchar(40) NOT NULL,
  `APRLINESN` bigint(10) NOT NULL,
  `APRTEMPLETNAME` varchar(800) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(200) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERID`(255),`FORMID`,`APRLINESN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_lintempletdetail`
--

DROP TABLE IF EXISTS `tbl_lintempletdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_lintempletdetail` (
  `USERID` varchar(400) NOT NULL,
  `FORMID` varchar(40) NOT NULL,
  `APRLINESN` bigint(10) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `APRTYPE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERISDEPTYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `MEMBERDEPTNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MEMBERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(200) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERID`(255),`FORMID`,`APRLINESN`,`APRMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_listinfo`
--

DROP TABLE IF EXISTS `tbl_listinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_listinfo` (
  `LISTTYPE` varchar(12) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `NAME` varchar(200) DEFAULT NULL,
  `WIDTH` bigint(10) NOT NULL,
  `TABLENAME` varchar(200) DEFAULT NULL,
  `COLNAME` varchar(4000) DEFAULT NULL,
  `COLALIAS` varchar(200) NOT NULL,
  `DTYPE` varchar(200) NOT NULL,
  `TYPEDESC` varchar(400) DEFAULT NULL,
  `FIELDDESC` varchar(400) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `NAME3` varchar(200) DEFAULT NULL,
  `NAME4` varchar(200) DEFAULT NULL,
  `DELFLAG` varchar(50) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`LISTTYPE`,`SN`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_listoption`
--

DROP TABLE IF EXISTS `tbl_listoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_listoption` (
  `LISTTYPE` varchar(12) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `NAME` varchar(200) DEFAULT NULL,
  `WIDTH` bigint(10) DEFAULT NULL,
  `TABLENAME` varchar(200) DEFAULT NULL,
  `COLNAME` varchar(400) DEFAULT NULL,
  `COLALIAS` varchar(200) DEFAULT NULL,
  `DTYPE` varchar(200) DEFAULT NULL,
  `TYPEDESC` varchar(400) DEFAULT NULL,
  `FIELDDESC` varchar(400) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `NAME3` varchar(200) DEFAULT NULL,
  `NAME4` varchar(200) DEFAULT NULL,
  `DELFLAG` varchar(20) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`LISTTYPE`,`SN`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_logo_size`
--

DROP TABLE IF EXISTS `tbl_logo_size`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_logo_size` (
  `C_CLUBNO` varchar(40) NOT NULL,
  `LOGO_SIZE` double(126,0) DEFAULT NULL,
  `BANNER_SIZE` double(126,0) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`C_CLUBNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_lunaruse`
--

DROP TABLE IF EXISTS `tbl_lunaruse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_lunaruse` (
  `USECOMPANY` varchar(20) NOT NULL,
  `LUNARUSE` decimal(22,0) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USECOMPANY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_memo`
--

DROP TABLE IF EXISTS `tbl_memo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_memo` (
  `memo_id` bigint(10) NOT NULL AUTO_INCREMENT,
  `contents` longtext DEFAULT NULL,
  `user_id` varchar(80) NOT NULL,
  `display_flag` tinyint(4) DEFAULT 0,
  `delete_flag` tinyint(4) DEFAULT 0,
  `write_date` datetime DEFAULT NULL,
  `delete_date` datetime DEFAULT NULL,
  `orders` bigint(10) NOT NULL,
  `folder_id` bigint(10) DEFAULT NULL,
  `color_id` tinyint(4) DEFAULT NULL,
  `company_id` varchar(80) NOT NULL,
  `tenant_id` mediumint(5) NOT NULL,
  PRIMARY KEY (`memo_id`,`company_id`,`tenant_id`),
  KEY `fk_tbl_memo_folder_folder_id` (`folder_id`),
  CONSTRAINT `fk_tbl_memo_folder_folder_id` FOREIGN KEY (`folder_id`) REFERENCES `tbl_memo_folder` (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_memo_config`
--

DROP TABLE IF EXISTS `tbl_memo_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_memo_config` (
  `user_id` varchar(80) NOT NULL,
  `font_size` tinyint(4) NOT NULL,
  `use_date` tinyint(4) DEFAULT 1,
  `use_gadget` tinyint(4) DEFAULT 1,
  `default_color` tinyint(4) DEFAULT NULL,
  `gadget_right` smallint(6) DEFAULT NULL,
  `gadget_bottom` smallint(6) DEFAULT NULL,
  `layer_left` smallint(6) DEFAULT NULL,
  `layer_top` smallint(6) DEFAULT NULL,
  `layer_width` smallint(6) DEFAULT NULL,
  `layer_height` smallint(6) DEFAULT NULL,
  `company_id` varchar(80) NOT NULL,
  `tenant_id` mediumint(5) NOT NULL,
  `full_mode` tinyint(4) DEFAULT 1,
  `b_memo_left` smallint(6) DEFAULT 0,
  `b_memo_top` smallint(6) DEFAULT 0,
  `b_memo_width` smallint(6) DEFAULT 0,
  `b_memo_height` smallint(6) DEFAULT 0,
  `b_memo_status` tinyint(4) DEFAULT 0,
  `memo_id` bigint(10) DEFAULT 0,
  PRIMARY KEY (`user_id`,`company_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_memo_folder`
--

DROP TABLE IF EXISTS `tbl_memo_folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_memo_folder` (
  `folder_id` bigint(10) NOT NULL AUTO_INCREMENT,
  `folder_name` varchar(100) NOT NULL,
  `reg_date` datetime DEFAULT NULL,
  `delete_date` datetime DEFAULT NULL,
  `user_id` varchar(80) NOT NULL,
  `orders` bigint(10) DEFAULT NULL,
  `company_id` varchar(80) NOT NULL,
  `tenant_id` mediumint(5) NOT NULL,
  `delete_flag` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`folder_id`,`company_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_menuitem_general`
--

DROP TABLE IF EXISTS `tbl_menuitem_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_menuitem_general` (
  `UID_` varchar(100) NOT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TYPE` bigint(10) DEFAULT NULL,
  `URL` varchar(1024) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_menuitem_items_image`
--

DROP TABLE IF EXISTS `tbl_menuitem_items_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_menuitem_items_image` (
  `UID_` varchar(100) NOT NULL,
  `OWNERPAGEID` varchar(100) NOT NULL,
  `SKINNUM` bigint(10) NOT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `IMAGETYPE` varchar(100) DEFAULT NULL,
  `NORMALIMAGEPATH` varchar(1024) DEFAULT NULL,
  `OVERIMAGEPATH` varchar(1024) DEFAULT NULL,
  `IMAGEWIDTH` bigint(10) DEFAULT NULL,
  `IMAGEHEIGHT` bigint(10) DEFAULT NULL,
  `LINKURL` varchar(1024) CHARACTER SET utf8mb4 DEFAULT NULL,
  `LINKLOCATION` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WINDOWOPTION` varchar(300) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`OWNERPAGEID`,`SKINNUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_menuitem_items_logos`
--

DROP TABLE IF EXISTS `tbl_menuitem_items_logos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_menuitem_items_logos` (
  `UID_` varchar(100) NOT NULL,
  `OWNERPAGEID` varchar(100) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`OWNERPAGEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_menuitem_items_menuitems`
--

DROP TABLE IF EXISTS `tbl_menuitem_items_menuitems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_menuitem_items_menuitems` (
  `UID_` varchar(100) NOT NULL,
  `PARENTUID` varchar(100) DEFAULT NULL,
  `PARENTMENUID` varchar(100) DEFAULT NULL,
  `OWNERPAGEID` varchar(100) DEFAULT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SUBFLAG` bigint(10) DEFAULT NULL,
  `COLUMNPOS` bigint(10) DEFAULT NULL,
  `IMAGEUID` varchar(100) DEFAULT NULL,
  `LINKURL` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `LINKLOCATION` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `LEFTMARGIN` bigint(10) DEFAULT NULL,
  `WINDOWOPTION` varchar(300) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_menuitem_items_menuitems_s`
--

DROP TABLE IF EXISTS `tbl_menuitem_items_menuitems_s`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_menuitem_items_menuitems_s` (
  `UID_` varchar(100) NOT NULL,
  `PARENTMENUID` varchar(100) DEFAULT NULL,
  `OWNERPAGEID` varchar(100) DEFAULT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COLUMNPOS` bigint(10) DEFAULT NULL,
  `IMAGEUID` varchar(100) DEFAULT NULL,
  `LINKURL` varchar(1024) DEFAULT NULL,
  `LINKLOCATION` varchar(100) DEFAULT NULL,
  `WINDOWOPTION` varchar(300) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  UNIQUE KEY `PK_TBL_MENUITEM_ITEMS_MENUIT` (`TENANT_ID`,`UID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_menuitem_parameters`
--

DROP TABLE IF EXISTS `tbl_menuitem_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_menuitem_parameters` (
  `UID_` varchar(100) NOT NULL,
  `PARAMNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `PARAMVALUE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PARAMTYPE` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`PARAMNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_mobileoption`
--

DROP TABLE IF EXISTS `tbl_mobileoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_mobileoption` (
  `USERID` varchar(200) NOT NULL,
  `TIMEZONE` varchar(40) NOT NULL,
  `LANG` varchar(4) NOT NULL,
  `MAINVIEWCOUNT` int(100) NOT NULL,
  `RESOURCEYN` varchar(4) NOT NULL,
  `RESOURCEDETAIL` varchar(8) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_mytaskcode`
--

DROP TABLE IF EXISTS `tbl_mytaskcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_mytaskcode` (
  `CN` varchar(100) NOT NULL,
  `DEPTID` varchar(100) NOT NULL,
  `CABINETID` varchar(100) NOT NULL,
  `TASKCODE` varchar(100) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CN`,`DEPTID`,`CABINETID`,`TASKCODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_notification`
--

DROP TABLE IF EXISTS `tbl_notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_notification` (
  `ITEMSEQ` bigint(10) NOT NULL AUTO_INCREMENT,
  `USERID` varchar(80) NOT NULL,
  `POSTDATE` datetime NOT NULL,
  `SENDER` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `SUBJECT` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `TYPE` mediumint(5) NOT NULL,
  `ETCDATA` varchar(400) DEFAULT NULL,
  `LINKURL` varchar(4000) DEFAULT NULL,
  `SHOWMSG` varchar(256) DEFAULT 'N',
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ITEMSEQ`),
  UNIQUE KEY `IDX_TBL_NOTIFICATION` (`TENANT_ID`,`ITEMSEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_oldcabinetextrainfo`
--

DROP TABLE IF EXISTS `tbl_oldcabinetextrainfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_oldcabinetextrainfo` (
  `CABINETCLASSNO` varchar(100) NOT NULL,
  `CREATEORGANNAME` varchar(200) DEFAULT NULL,
  `CLASSIFICATIONNO` varchar(20) DEFAULT NULL,
  `CREATEORGANNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL DEFAULT 'S907000',
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CABINETCLASSNO`),
  CONSTRAINT `FK_TBL_OLDCABINETEXTRAINFO` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_oldrecordextrainfo`
--

DROP TABLE IF EXISTS `tbl_oldrecordextrainfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_oldrecordextrainfo` (
  `RECORDID` varchar(68) NOT NULL,
  `CREATEORGANNAME` varchar(200) DEFAULT NULL,
  `RECORDNO` varchar(120) DEFAULT NULL,
  `KEEPINGPERIOD` varchar(8) DEFAULT NULL,
  `CREATEORGANNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECORDID`),
  CONSTRAINT `FK_TBL_OLDRECORDEXTRAINFO` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `RECORDID`) REFERENCES `tbl_record` (`TENANT_ID`, `COMPANYID`, `RECORDID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_opengovdocinfo`
--

DROP TABLE IF EXISTS `tbl_opengovdocinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_opengovdocinfo` (
  `docid` varchar(80) NOT NULL,
  `openflag` char(9) DEFAULT NULL,
  `basis` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `reason` varchar(1000) CHARACTER SET utf8 DEFAULT NULL,
  `openlimitdate` datetime DEFAULT NULL,
  `createdate` datetime DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL,
  `tenant_id` mediumint(5) NOT NULL,
  `companyid` varchar(20) NOT NULL,
  `listopenflag` char(2) DEFAULT NULL,
  PRIMARY KEY (`docid`,`tenant_id`,`companyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_opengovfileinfo`
--

DROP TABLE IF EXISTS `tbl_opengovfileinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_opengovfileinfo` (
  `DOCID` varchar(80) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `FILEOPENFLAG` char(1) DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`DOCID`,`SN`,`COMPANYID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='원문정보공개 첨부파일 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_permissiongroupinfo`
--

DROP TABLE IF EXISTS `tbl_permissiongroupinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_permissiongroupinfo` (
  `GROUP_ID` varchar(80) NOT NULL,
  `MEMBER_ID` varchar(80) NOT NULL,
  `MEMBER_TYPE` varchar(10) NOT NULL,
  `ADDED_DATE` datetime NOT NULL,
  `SUB_DEPT_YN` varchar(10) NOT NULL,
  `COMPANY_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`GROUP_ID`,`TENANT_ID`,`MEMBER_ID`),
  CONSTRAINT `GROUP_ID` FOREIGN KEY (`GROUP_ID`) REFERENCES `tbl_permissiongrouplist` (`GROUP_ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_permissiongrouplist`
--

DROP TABLE IF EXISTS `tbl_permissiongrouplist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_permissiongrouplist` (
  `GROUP_ID` varchar(80) NOT NULL,
  `GROUP_NAME` varchar(100) NOT NULL,
  `CREATE_ID` varchar(80) NOT NULL,
  `CREATE_DATE` datetime NOT NULL,
  `UPDATE_ID` varchar(80) DEFAULT NULL,
  `UPDATE_DATE` datetime DEFAULT NULL,
  `COMPANY_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`GROUP_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_photo_imageitem`
--

DROP TABLE IF EXISTS `tbl_photo_imageitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_photo_imageitem` (
  `IMAGEID` varchar(76) NOT NULL,
  `ITEMID` varchar(76) NOT NULL,
  `BOARDID` varchar(76) NOT NULL,
  `WRITERID` varchar(40) NOT NULL,
  `WRITERNAME` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(40) NOT NULL,
  `FILEPATH` varchar(400) NOT NULL,
  `WRITEDATE` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
  `FILECONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `IMAGENAME` varchar(800) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MAIN_FLAG` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`IMAGEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_board_folder`
--

DROP TABLE IF EXISTS `tbl_pms_board_folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_board_folder` (
  `folder_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT NULL,
  `folder_name` varchar(100) DEFAULT NULL,
  `folder_name2` varchar(100) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `creator_id` varchar(100) DEFAULT NULL,
  `folder_order` int(11) DEFAULT NULL,
  `del_status` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_comment`
--

DROP TABLE IF EXISTS `tbl_pms_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_comment` (
  `comment_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '의견 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `task_id` bigint(20) DEFAULT NULL COMMENT '업무 아이디',
  `group_id` bigint(20) DEFAULT NULL COMMENT '그룹 아이디',
  `update_date` datetime NOT NULL COMMENT '수정 일',
  `comment_content` longtext NOT NULL COMMENT '의견 내용',
  `writer_id` varchar(100) NOT NULL COMMENT '게시자 아이디',
  `write_date` datetime NOT NULL COMMENT '게시 일',
  `writer_name` varchar(100) NOT NULL COMMENT '게시자 명',
  `writer_name2` varchar(100) NOT NULL COMMENT '게시자 명다국어',
  `writer_deptname` varchar(100) DEFAULT NULL COMMENT '게시자 부서',
  `writer_deptname2` varchar(100) DEFAULT NULL COMMENT '게시자 부서다국어',
  `del_status` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`comment_id`),
  KEY `FK_tbl_pms_comment_task_id_tbl_pms_task_task_id` (`task_id`),
  KEY `FK_tbl_pms_comment_group_id_tbl_pms_group_group_id` (`group_id`),
  CONSTRAINT `FK_tbl_pms_comment_group_id_tbl_pms_group_group_id` FOREIGN KEY (`group_id`) REFERENCES `tbl_pms_group` (`group_id`),
  CONSTRAINT `FK_tbl_pms_comment_task_id_tbl_pms_task_task_id` FOREIGN KEY (`task_id`) REFERENCES `tbl_pms_task` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='프로젝트 의견';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_favorite`
--

DROP TABLE IF EXISTS `tbl_pms_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_favorite` (
  `favorite_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '즐겨찾기 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `project_id` bigint(20) NOT NULL COMMENT '프로젝트 아이디',
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  PRIMARY KEY (`favorite_id`),
  KEY `FK_tbl_pms_favorite_project_id_tbl_pms_project_project_id` (`project_id`),
  CONSTRAINT `FK_tbl_pms_favorite_project_id_tbl_pms_project_project_id` FOREIGN KEY (`project_id`) REFERENCES `tbl_pms_project` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_fixedholiday`
--

DROP TABLE IF EXISTS `tbl_pms_fixedholiday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_fixedholiday` (
  `holiday_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `holiday_name` varchar(50) DEFAULT NULL,
  `holiday_name2` varchar(50) DEFAULT NULL,
  `holiday` varchar(10) NOT NULL,
  `solarlunar` smallint(6) DEFAULT NULL,
  `country` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`holiday_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_group`
--

DROP TABLE IF EXISTS `tbl_pms_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_group` (
  `group_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '그룹 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `project_id` bigint(20) NOT NULL COMMENT '프로젝트 아이디',
  `group_name` varchar(200) NOT NULL COMMENT '그룹 명',
  `upper_group_id` bigint(20) NOT NULL COMMENT '상위 그룹 아이디',
  `plan_start_date` date NOT NULL COMMENT '계획 시작 일',
  `plan_end_date` date NOT NULL COMMENT '계획 종료 일',
  `real_start_date` date DEFAULT NULL COMMENT '실제 시작 일',
  `real_end_date` date DEFAULT NULL COMMENT '실제 종료 일',
  `real_progress` float NOT NULL COMMENT '실제 진행률',
  `overview` longtext DEFAULT NULL COMMENT '개요',
  `member_count` mediumint(9) NOT NULL COMMENT '참여 인원수',
  `head_manager_id` varchar(100) NOT NULL COMMENT '총괄 담당자 아이디',
  `head_manager_name` varchar(100) NOT NULL COMMENT '총괄 담당자 명',
  `head_manager_name2` varchar(100) NOT NULL COMMENT '총괄 담당자 명다국어',
  `head_manager_deptname` varchar(100) DEFAULT NULL COMMENT '총괄 담당자 부서',
  `head_manager_deptname2` varchar(100) DEFAULT NULL COMMENT '총괄 담당자 부서다국어',
  `creator_id` varchar(100) NOT NULL COMMENT '생성자 아이디',
  `create_date` date NOT NULL COMMENT '생성 일',
  `creator_name` varchar(100) NOT NULL COMMENT '생성자 명',
  `creator_name2` varchar(100) NOT NULL COMMENT '생성자 명다국어',
  `creator_deptname` varchar(100) DEFAULT NULL COMMENT '생성자 부서',
  `creator_deptname2` varchar(100) DEFAULT NULL COMMENT '생성자 부서다국어',
  `tree_depth` int(11) NOT NULL COMMENT '트리 깊이',
  `ancester_group` varchar(45) NOT NULL COMMENT '조상 그룹',
  `sort_order` int(11) NOT NULL COMMENT '정렬 순서',
  `del_status` mediumint(9) NOT NULL COMMENT '삭제 상태',
  `workingday` mediumint(9) NOT NULL COMMENT '업무일',
  `rest_dueday` mediumint(9) NOT NULL COMMENT '남은 기한',
  `issueYN` varchar(10) DEFAULT 'N',
  `workingday_sum` float DEFAULT 0,
  PRIMARY KEY (`group_id`),
  KEY `FK_tbl_pms_group_project_id_tbl_pms_project_project_id` (`project_id`),
  CONSTRAINT `FK_tbl_pms_group_project_id_tbl_pms_project_project_id` FOREIGN KEY (`project_id`) REFERENCES `tbl_pms_project` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='프로젝트 그룹';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_groupmember`
--

DROP TABLE IF EXISTS `tbl_pms_groupmember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_groupmember` (
  `group_member_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '그룹 멤버 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `group_id` bigint(20) NOT NULL COMMENT '그룹 아이디',
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `user_name` varchar(100) NOT NULL COMMENT '사용자 명',
  `user_name2` varchar(100) NOT NULL COMMENT '사용자 명다국어',
  `user_deptname` varchar(100) DEFAULT NULL COMMENT '사용자 부서',
  `user_deptname2` varchar(100) DEFAULT NULL COMMENT '사용자 부서다국어',
  `member_role_id` int(11) NOT NULL,
  PRIMARY KEY (`group_member_id`),
  KEY `FK_tbl_pms_groupmember_group_id_tbl_pms_group_group_id` (`group_id`),
  CONSTRAINT `FK_tbl_pms_groupmember_group_id_tbl_pms_group_group_id` FOREIGN KEY (`group_id`) REFERENCES `tbl_pms_group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='그룹 담당자';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_item_attachment`
--

DROP TABLE IF EXISTS `tbl_pms_item_attachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_item_attachment` (
  `file_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '파일 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `item_id` int(11) NOT NULL COMMENT '게시물 아이디',
  `file_path` varchar(250) NOT NULL COMMENT '파일 경로',
  `file_size` varchar(45) NOT NULL COMMENT '파일 크기',
  `file_name` varchar(100) NOT NULL COMMENT '파일 명',
  PRIMARY KEY (`file_id`),
  KEY `FK_tbl_pms_item_attachment_item_id_tbl_pms_item_list_item_id` (`item_id`),
  CONSTRAINT `FK_tbl_pms_item_attachment_item_id_tbl_pms_item_list_item_id` FOREIGN KEY (`item_id`) REFERENCES `tbl_pms_item_list` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='게시물 첨부파일';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_item_list`
--

DROP TABLE IF EXISTS `tbl_pms_item_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_item_list` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '게시물 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `writer_id` varchar(100) NOT NULL COMMENT '게시자 아이디',
  `title` varchar(400) NOT NULL COMMENT '제목',
  `write_overview` longtext DEFAULT NULL COMMENT '게시 개요',
  `write_type` int(11) DEFAULT NULL COMMENT '게시 종류',
  `write_content` longtext DEFAULT NULL COMMENT '게시 내용',
  `write_date` datetime NOT NULL COMMENT '게시 일',
  `write_update_date` datetime DEFAULT NULL COMMENT '게시 수정 일',
  `read_count` int(11) NOT NULL COMMENT '조회 수',
  `task_id` bigint(20) DEFAULT NULL COMMENT '업무 아이디',
  `group_id` bigint(20) DEFAULT NULL COMMENT '그룹 아이디',
  `writer_name` varchar(100) NOT NULL COMMENT '게시자 명',
  `writer_name2` varchar(100) NOT NULL COMMENT '게시자 명다국어',
  `writer_deptname` varchar(100) DEFAULT NULL COMMENT '게시자 부서',
  `writer_deptname2` varchar(100) DEFAULT NULL COMMENT '게시자 부서다국어',
  `writer_position` varchar(100) DEFAULT NULL COMMENT '게시자 직위',
  `writer_position2` varchar(100) DEFAULT NULL COMMENT '게시자 직위다국어',
  `del_status` tinyint(1) NOT NULL DEFAULT 0,
  `root_item_id` int(11) DEFAULT NULL,
  `upper_item_id` int(11) DEFAULT NULL,
  `item_level` int(11) NOT NULL DEFAULT 0,
  `doc_no` int(11) NOT NULL,
  `folder_id` bigint(20) DEFAULT 0,
  `upper_doc_no_tree` longtext DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `FK_tbl_pms_item_list_task_id_tbl_pms_task_task_id` (`task_id`),
  KEY `FK_tbl_pms_item_list_group_id_tbl_pms_group_group_id` (`group_id`),
  CONSTRAINT `FK_tbl_pms_item_list_group_id_tbl_pms_group_group_id` FOREIGN KEY (`group_id`) REFERENCES `tbl_pms_group` (`group_id`),
  CONSTRAINT `FK_tbl_pms_item_list_task_id_tbl_pms_task_task_id` FOREIGN KEY (`task_id`) REFERENCES `tbl_pms_task` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='게시물 리스트';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_item_read`
--

DROP TABLE IF EXISTS `tbl_pms_item_read`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_item_read` (
  `read_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '조회 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `project_id` bigint(20) NOT NULL COMMENT '프로젝트 아이디',
  `item_id` int(11) NOT NULL COMMENT '게시물 아이디',
  `read_date` datetime NOT NULL COMMENT '조회 일',
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `user_name` varchar(100) NOT NULL COMMENT '사용자 명',
  `user_name2` varchar(100) NOT NULL COMMENT '사용자 명다국어',
  `user_deptname` varchar(100) NOT NULL COMMENT '사용자 부서',
  `user_deptname2` varchar(100) NOT NULL COMMENT '사용자 부서다국어',
  PRIMARY KEY (`read_id`),
  KEY `FK_tbl_pms_item_read_item_id_tbl_pms_item_list_item_id` (`item_id`),
  CONSTRAINT `FK_tbl_pms_item_read_item_id_tbl_pms_item_list_item_id` FOREIGN KEY (`item_id`) REFERENCES `tbl_pms_item_list` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='게시물 조회자';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_log`
--

DROP TABLE IF EXISTS `tbl_pms_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '이력 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `project_id` bigint(20) DEFAULT NULL COMMENT '프로젝트 아이디',
  `group_id` bigint(20) DEFAULT NULL COMMENT '그룹 아이디',
  `task_id` bigint(20) DEFAULT NULL COMMENT '업무 아이디',
  `log_date` datetime DEFAULT NULL,
  `log_status` mediumint(9) NOT NULL COMMENT '이력 상태',
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `user_name` varchar(100) NOT NULL COMMENT '사용자 명',
  `user_name2` varchar(100) NOT NULL COMMENT '사용자 명다국어',
  `user_deptname` varchar(100) DEFAULT NULL COMMENT '사용자 부서',
  `user_deptname2` varchar(100) DEFAULT NULL COMMENT '사용자 부서다국어',
  `log_content` varchar(500) NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `FK_tbl_pms_log_project_id_tbl_pms_project_project_id` (`project_id`),
  KEY `FK_tbl_pms_log_group_id_tbl_pms_group_group_id` (`group_id`),
  KEY `FK_tbl_pms_log_task_id_tbl_pms_task_task_id` (`task_id`),
  CONSTRAINT `FK_tbl_pms_log_group_id_tbl_pms_group_group_id` FOREIGN KEY (`group_id`) REFERENCES `tbl_pms_group` (`group_id`),
  CONSTRAINT `FK_tbl_pms_log_project_id_tbl_pms_project_project_id` FOREIGN KEY (`project_id`) REFERENCES `tbl_pms_project` (`project_id`),
  CONSTRAINT `FK_tbl_pms_log_task_id_tbl_pms_task_task_id` FOREIGN KEY (`task_id`) REFERENCES `tbl_pms_task` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='작업이력';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_mainlist`
--

DROP TABLE IF EXISTS `tbl_pms_mainlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_mainlist` (
  `list_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '리스트 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `project_id` bigint(20) NOT NULL COMMENT '프로젝트 아이디',
  `kanban_order` varchar(45) NOT NULL COMMENT '칸반 순서',
  PRIMARY KEY (`list_id`),
  KEY `FK_tbl_pms_mainlist_project_id_tbl_pms_project_project_id` (`project_id`),
  CONSTRAINT `FK_tbl_pms_mainlist_project_id_tbl_pms_project_project_id` FOREIGN KEY (`project_id`) REFERENCES `tbl_pms_project` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='프로젝트 상세보기 메인 custom';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_member`
--

DROP TABLE IF EXISTS `tbl_pms_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_member` (
  `member_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '멤버 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `project_id` bigint(20) NOT NULL COMMENT '프로젝트 아이디',
  `member_role_id` int(11) NOT NULL COMMENT '멤버 역할 아이디',
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `user_name` varchar(100) DEFAULT NULL COMMENT '사용자 명',
  `user_name2` varchar(100) DEFAULT NULL COMMENT '사용자 명다국어',
  `user_deptname` varchar(100) DEFAULT NULL COMMENT '사용자 부서',
  `user_deptname2` varchar(100) DEFAULT NULL COMMENT '사용자 부서다국어',
  `user_position` varchar(100) DEFAULT NULL COMMENT '사용자 직위',
  `user_position2` varchar(100) DEFAULT NULL COMMENT '사용자 직위다국어',
  `user_id_type` varchar(100) NOT NULL COMMENT '사용자 아이디 종류',
  PRIMARY KEY (`member_id`),
  KEY `FK_tbl_pms_member_project_id_tbl_pms_project_project_id` (`project_id`),
  CONSTRAINT `FK_tbl_pms_member_project_id_tbl_pms_project_project_id` FOREIGN KEY (`project_id`) REFERENCES `tbl_pms_project` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='프로젝트 참여자 관련 정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_pretaskrel`
--

DROP TABLE IF EXISTS `tbl_pms_pretaskrel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_pretaskrel` (
  `pretaskrel_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '선행작업관계 아이디',
  `pretask` bigint(20) DEFAULT NULL COMMENT '선행작업',
  `task_id` bigint(20) DEFAULT NULL COMMENT '업무 아이디',
  `pregroup` bigint(20) DEFAULT NULL COMMENT '선행그룹',
  `group_id` bigint(20) DEFAULT NULL COMMENT '그룹 아이디',
  `tenant_id` mediumint(9) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`pretaskrel_id`),
  KEY `FK_tbl_pms_pretaskrel_task_id_tbl_pms_task_task_id` (`task_id`),
  KEY `FK_tbl_pms_pretaskrel_group_id_tbl_pms_group_group_id` (`group_id`),
  CONSTRAINT `FK_tbl_pms_pretaskrel_group_id_tbl_pms_group_group_id` FOREIGN KEY (`group_id`) REFERENCES `tbl_pms_group` (`group_id`),
  CONSTRAINT `FK_tbl_pms_pretaskrel_task_id_tbl_pms_task_task_id` FOREIGN KEY (`task_id`) REFERENCES `tbl_pms_task` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='선행작업관계';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_project`
--

DROP TABLE IF EXISTS `tbl_pms_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_project` (
  `project_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '프로젝트 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `project_name` varchar(100) NOT NULL COMMENT '프로젝트 명',
  `plan_start_date` date NOT NULL COMMENT '계획 시작 일',
  `plan_end_date` date NOT NULL COMMENT '계획 종료 일',
  `real_start_date` date DEFAULT NULL COMMENT '실제 시작 일',
  `real_end_date` date DEFAULT NULL COMMENT '실제 종료 일',
  `head_manager_id` varchar(100) NOT NULL COMMENT '총괄 담당자 아이디',
  `head_manager_name` varchar(100) DEFAULT NULL COMMENT '총괄 담당자 명',
  `head_manager_name2` varchar(100) DEFAULT NULL COMMENT '총괄 담당자 명다국어',
  `head_manager_deptname` varchar(100) DEFAULT NULL COMMENT '총괄 담당자 부서',
  `head_manager_deptname2` varchar(100) DEFAULT NULL COMMENT '총괄 담당자 부서다국어',
  `status` varchar(45) NOT NULL COMMENT '상태',
  `progress` float NOT NULL COMMENT '진행률',
  `overview` longtext DEFAULT NULL COMMENT '개요',
  `weight_input` mediumint(9) NOT NULL COMMENT '가중치 입력',
  `creator_id` varchar(100) NOT NULL COMMENT '생성자 아이디',
  `create_date` date NOT NULL COMMENT '생성 일',
  `creator_name` varchar(100) NOT NULL COMMENT '생성자 명',
  `creator_name2` varchar(100) NOT NULL COMMENT '생성자 명다국어',
  `creator_deptname` varchar(100) DEFAULT NULL COMMENT '생성자 부서',
  `creator_deptname2` varchar(100) DEFAULT NULL COMMENT '생성자 부서다국어',
  `workingday` float NOT NULL COMMENT '업무일',
  `rest_dueday` mediumint(9) NOT NULL COMMENT '남은 기한',
  `alam_mail_status` mediumint(9) DEFAULT NULL COMMENT '알림 메일 상태',
  `del_status` mediumint(9) NOT NULL DEFAULT 0,
  `workingday_sum` float DEFAULT 0,
  `mail_repeat` smallint(6) DEFAULT 0,
  `is_late` int(11) DEFAULT 0,
  `is_suspend` int(11) DEFAULT 0,
  PRIMARY KEY (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='프로젝트 정보';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_setting`
--

DROP TABLE IF EXISTS `tbl_pms_setting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_setting` (
  `setting_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '환경설정 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `view_type` bigint(20) DEFAULT NULL COMMENT '화면 종류',
  `progress_color` varchar(10) DEFAULT NULL COMMENT '진행률 색상',
  `complete_color` varchar(10) DEFAULT NULL COMMENT '완료 색상',
  `overdue_color` varchar(10) DEFAULT NULL COMMENT '지연 색상',
  `hold_color` varchar(10) DEFAULT NULL COMMENT '보류 색상',
  `project_sort` mediumint(9) DEFAULT NULL COMMENT '프로젝트 정렬',
  `list_number` int(11) DEFAULT NULL COMMENT '리스트 개수',
  `list_project_status` varchar(45) DEFAULT 'P',
  PRIMARY KEY (`setting_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='프로젝트 환경설정 custom';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_task`
--

DROP TABLE IF EXISTS `tbl_pms_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_task` (
  `task_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '업무 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `project_id` bigint(20) NOT NULL COMMENT '프로젝트 아이디',
  `group_id` bigint(20) NOT NULL COMMENT '그룹 아이디',
  `task_name` varchar(100) NOT NULL COMMENT '업무 명',
  `status` varchar(45) NOT NULL COMMENT '상태',
  `plan_start_date` date NOT NULL COMMENT '계획 시작 일',
  `plan_end_date` date NOT NULL COMMENT '계획 종료 일',
  `real_start_date` date DEFAULT NULL COMMENT '실제 시작 일',
  `real_end_date` date DEFAULT NULL COMMENT '실제 종료 일',
  `real_progress` float NOT NULL COMMENT '실제 진행률',
  `weight` float NOT NULL COMMENT '가중치',
  `overview` longtext NOT NULL COMMENT '개요',
  `member_count` mediumint(9) NOT NULL COMMENT '참여 인원수',
  `head_manager_id` varchar(100) NOT NULL COMMENT '총괄 담당자 아이디',
  `head_manager_name` varchar(100) NOT NULL COMMENT '총괄 담당자 명',
  `head_manager_name2` varchar(100) NOT NULL COMMENT '총괄 담당자 명다국어',
  `head_manager_deptname` varchar(100) DEFAULT NULL COMMENT '총괄 담당자 부서',
  `head_manager_deptname2` varchar(100) DEFAULT NULL COMMENT '총괄 담당자 부서다국어',
  `writer_id` varchar(100) NOT NULL COMMENT '게시자 아이디',
  `write_date` date NOT NULL COMMENT '게시 일',
  `writer_name` varchar(100) NOT NULL COMMENT '게시자 명',
  `writer_name2` varchar(100) NOT NULL COMMENT '게시자 명다국어',
  `writer_deptname` varchar(100) DEFAULT NULL COMMENT '게시자 부서',
  `writer_deptname2` varchar(100) DEFAULT NULL COMMENT '게시자 부서다국어',
  `tree_depth` int(11) DEFAULT 0 COMMENT '트리 깊이',
  `ancester_group` varchar(45) DEFAULT NULL COMMENT '조상 그룹',
  `sort_order` int(11) NOT NULL COMMENT '정렬 순서',
  `workingday` float NOT NULL COMMENT '업무일',
  `rest_dueday` mediumint(9) DEFAULT NULL COMMENT '남은 기한',
  `link_task_id` bigint(20) DEFAULT NULL COMMENT '업무관리 업무 아이디',
  `del_status` mediumint(9) NOT NULL DEFAULT 0 COMMENT '삭제 상태',
  `real_workingday` int(11) DEFAULT 0,
  PRIMARY KEY (`task_id`),
  KEY `FK_tbl_pms_task_project_id_tbl_pms_project_project_id` (`project_id`),
  KEY `FK_tbl_pms_task_group_id_tbl_pms_group_group_id` (`group_id`),
  CONSTRAINT `FK_tbl_pms_task_group_id_tbl_pms_group_group_id` FOREIGN KEY (`group_id`) REFERENCES `tbl_pms_group` (`group_id`),
  CONSTRAINT `FK_tbl_pms_task_project_id_tbl_pms_project_project_id` FOREIGN KEY (`project_id`) REFERENCES `tbl_pms_project` (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='프로젝트 작업';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pms_taskmember`
--

DROP TABLE IF EXISTS `tbl_pms_taskmember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pms_taskmember` (
  `task_member_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '업무 멤버 아이디',
  `tenant_id` mediumint(9) NOT NULL COMMENT '테넌트 아이디',
  `task_id` bigint(20) NOT NULL COMMENT '업무 아이디',
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `user_name` varchar(100) NOT NULL COMMENT '사용자 명',
  `user_name2` varchar(100) NOT NULL COMMENT '사용자 명다국어',
  `user_deptname` varchar(100) DEFAULT NULL COMMENT '사용자 부서',
  `user_deptname2` varchar(100) DEFAULT NULL COMMENT '사용자 부서다국어',
  `pctinput` float NOT NULL COMMENT '투입률',
  PRIMARY KEY (`task_member_id`),
  KEY `FK_tbl_pms_taskmember_task_id_tbl_pms_task_task_id` (`task_id`),
  CONSTRAINT `FK_tbl_pms_taskmember_task_id_tbl_pms_task_task_id` FOREIGN KEY (`task_id`) REFERENCES `tbl_pms_task` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='작업 담당자';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_answer`
--

DROP TABLE IF EXISTS `tbl_poll_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_answer` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `QUESTION_NO` bigint(10) NOT NULL,
  `ANSWERNO` bigint(10) NOT NULL,
  `ANSWERCONTENT` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`,`QUESTION_NO`,`ANSWERNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_attach`
--

DROP TABLE IF EXISTS `tbl_poll_attach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_attach` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `QUESTION_NO` bigint(10) NOT NULL,
  `ANSWERNO` bigint(10) NOT NULL,
  `ATTACHNO` bigint(10) NOT NULL,
  `ATTACHNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHURL` varchar(1000) DEFAULT NULL,
  `ATTACHTYPE` varchar(2) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`,`QUESTION_NO`,`ANSWERNO`,`ATTACHNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_item`
--

DROP TABLE IF EXISTS `tbl_poll_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_item` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `USER_ID` varchar(40) NOT NULL,
  `USER_NM` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `USER_NM2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_EMAIL` varchar(510) NOT NULL,
  `USER_DEPTID` varchar(40) DEFAULT NULL,
  `USER_DEPTNM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(510) CHARACTER SET utf8mb4 NOT NULL,
  `CONTENT` varchar(510) CHARACTER SET utf8mb4 NOT NULL,
  `POST_DATE` datetime NOT NULL,
  `UPDATE_DATE` varchar(38) CHARACTER SET utf8mb4 DEFAULT NULL,
  `END_DATE` varchar(38) CHARACTER SET utf8mb4 DEFAULT NULL,
  `POST_TERM` bigint(10) DEFAULT NULL,
  `ITEM_REF` bigint(10) DEFAULT NULL,
  `ITEM_LEVEL` bigint(10) DEFAULT NULL,
  `ITEM_STEP` bigint(10) DEFAULT NULL,
  `ITEM_IMP` varchar(2) NOT NULL DEFAULT '2',
  `HASATTACH` tinyint(1) NOT NULL DEFAULT 0,
  `SRCUSER_ID` varchar(40) DEFAULT NULL,
  `SRCUSER_NM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SRCUSER_EMAIL` varchar(510) DEFAULT NULL,
  `ITEM_GB` varchar(2) NOT NULL DEFAULT '1',
  `READ_CNT` bigint(18) NOT NULL DEFAULT 0,
  `POLL_STARTDATE` varchar(38) CHARACTER SET utf8mb4 DEFAULT NULL,
  `POLL_ENDDATE` varchar(38) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RES_CNT` bigint(18) NOT NULL DEFAULT 0,
  `COMPLETE_FLAG` varchar(2) NOT NULL DEFAULT 'N',
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_itemacl`
--

DROP TABLE IF EXISTS `tbl_poll_itemacl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_itemacl` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `GUBUN` varchar(2) NOT NULL,
  `GUBUN_ID` varchar(100) NOT NULL,
  `GUBUN_NM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `GUBUN_NM2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONDITION` varchar(6) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`,`GUBUN`,`GUBUN_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_itemread`
--

DROP TABLE IF EXISTS `tbl_poll_itemread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_itemread` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `USER_ID` varchar(40) NOT NULL,
  `READ_DATE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_NM` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_NM2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_DEPTID` varchar(100) DEFAULT NULL,
  `USER_DEPTNM` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_DEPTNM2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_POSNM` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_POSNM2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_permission`
--

DROP TABLE IF EXISTS `tbl_poll_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_permission` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `PUBLIC_FLG` varchar(2) NOT NULL,
  `PUBLIC_RESULT_FLG` varchar(2) NOT NULL,
  `MULTI_RESPONSE_FLG` varchar(2) NOT NULL,
  `END_FLG` varchar(2) NOT NULL DEFAULT '0',
  `RESPONSE_RANGE` varchar(2) NOT NULL DEFAULT '0',
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_question`
--

DROP TABLE IF EXISTS `tbl_poll_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_question` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `QUESTION_NO` bigint(10) NOT NULL,
  `QUESCONTENT` varchar(2000) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWERTYPE` bigint(10) NOT NULL DEFAULT 0,
  `ANSWERVIEWTYPE` bigint(10) DEFAULT NULL,
  `MULTISELECT` varchar(2) NOT NULL DEFAULT '0',
  `QUES_SN` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`,`QUESTION_NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_response`
--

DROP TABLE IF EXISTS `tbl_poll_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_response` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `QUESTION_NO` bigint(10) NOT NULL,
  `RESPONSENO` bigint(10) NOT NULL,
  `ANSWER_OBJECTIVITY` bigint(10) DEFAULT NULL,
  `ANSWER_SUBJECTIVITY` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `ANSWER_VIEWSELECT` bigint(10) DEFAULT NULL,
  `RESPONSEUSER_ID` varchar(40) DEFAULT NULL,
  `RESPONSEUSER_NAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESPONSEUSER_NAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESPONSEUSER_EMAIL` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_DEPT_ID` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_DEPT_NAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESPONSEUSER_DEPT_NAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESPONSEUSER_POSITION` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESPONSEUSER_POSITION2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESPONSEUSER_JIKGUB` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESPONSEUSER_JIKGUB2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESPONSEUSER_GENDER` varchar(2) DEFAULT NULL,
  `RESPONSEUSER_AGE` bigint(10) DEFAULT NULL,
  `RESPONSE_DATE` datetime NOT NULL,
  `RESPONSEUSER_IP` varchar(40) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`,`QUESTION_NO`,`RESPONSENO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_responseperson`
--

DROP TABLE IF EXISTS `tbl_poll_responseperson`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_responseperson` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `USER_ID` varchar(40) NOT NULL,
  `RESPONSE_DATE` varchar(38) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_NM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_NM2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_EMAIL` varchar(200) DEFAULT NULL,
  `USER_DEPT_ID` varchar(200) DEFAULT NULL,
  `USER_DEPT_NM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_DEPT_NM2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_POS` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_POS2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_JIKGUB` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_JIKGUB2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USER_GENDER` varchar(2) DEFAULT NULL,
  `USER_AGE` bigint(10) DEFAULT NULL,
  `GROUPID` varchar(10) DEFAULT NULL,
  `GROUPNAME` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_poll_table_answer`
--

DROP TABLE IF EXISTS `tbl_poll_table_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_poll_table_answer` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) NOT NULL,
  `QUESTION_NO` bigint(10) NOT NULL,
  `ANSWERNO` bigint(10) NOT NULL,
  `ANSWER_ANSWERCONTENT` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`,`QUESTION_NO`,`ANSWERNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_popupservey`
--

DROP TABLE IF EXISTS `tbl_popupservey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_popupservey` (
  `sn` int(11) NOT NULL AUTO_INCREMENT,
  `cn` varchar(80) DEFAULT NULL,
  `userName` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `deptName` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `checkDate` date DEFAULT NULL,
  `updateCheckDate` date DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `serveyId` int(11) DEFAULT NULL,
  PRIMARY KEY (`sn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_acl`
--

DROP TABLE IF EXISTS `tbl_portal_acl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_acl` (
  `UID_` varchar(100) NOT NULL,
  `ACCESSID` varchar(100) NOT NULL,
  `ACCESSNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `VIEW_RIGHT` bigint(10) DEFAULT NULL,
  `EDIT_RIGHT` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`ACCESSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_frame`
--

DROP TABLE IF EXISTS `tbl_portal_frame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_frame` (
  `frame_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '프레임아이디',
  `frame_name` varchar(100) DEFAULT NULL COMMENT '프레임 이름',
  `theme_id` int(11) DEFAULT NULL COMMENT '프레임이 속한 테마 아이디',
  PRIMARY KEY (`frame_id`),
  KEY `FK_tbl_portal_frame_theme_id_tbl_portal_theme_theme_id` (`theme_id`),
  CONSTRAINT `FK_tbl_portal_frame_theme_id_tbl_portal_theme_theme_id` FOREIGN KEY (`theme_id`) REFERENCES `tbl_portal_theme` (`theme_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='프레임 정보 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_frame_comp`
--

DROP TABLE IF EXISTS `tbl_portal_frame_comp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_frame_comp` (
  `company_id` varchar(100) NOT NULL COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `theme_id` int(11) NOT NULL DEFAULT 0 COMMENT '테마 아이디',
  `frame_id` int(11) NOT NULL DEFAULT 0 COMMENT '프레임 아이디',
  `frame_used` int(11) DEFAULT 0 COMMENT '활성화(Y), 비활성화(N)',
  `frame_default` int(11) DEFAULT 0 COMMENT '기본(Y), 기본아님(N)',
  PRIMARY KEY (`company_id`,`tenant_id`,`theme_id`,`frame_id`),
  KEY `FK_tbl_portal_frame_comp_frame_id_tbl_portal_frame_frame_id` (`frame_id`),
  KEY `FK_tbl_portal_frame_comp_theme_id_tbl_portal_theme_theme_id` (`theme_id`),
  CONSTRAINT `FK_tbl_portal_frame_comp_frame_id_tbl_portal_frame_frame_id` FOREIGN KEY (`frame_id`) REFERENCES `tbl_portal_frame` (`frame_id`),
  CONSTRAINT `FK_tbl_portal_frame_comp_theme_id_tbl_portal_theme_theme_id` FOREIGN KEY (`theme_id`) REFERENCES `tbl_portal_theme` (`theme_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회사별 프레임 설정 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_logo`
--

DROP TABLE IF EXISTS `tbl_portal_logo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_logo` (
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `logo_type` varchar(6) NOT NULL DEFAULT '' COMMENT '대표이미지(R), 로그인(L), 포탈 내부(P)',
  `logo_url` varchar(200) DEFAULT NULL COMMENT '로고 이미지 경로',
  PRIMARY KEY (`company_id`,`tenant_id`,`logo_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회사별 로고관리 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_menu`
--

DROP TABLE IF EXISTS `tbl_portal_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_menu` (
  `menu_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '메뉴 아이디',
  `menu_url` varchar(100) DEFAULT NULL COMMENT '메뉴 연동 URL',
  `menu_type` varchar(5) DEFAULT 'G' COMMENT '기본(G), 추가(A)',
  `icon_url` varchar(200) DEFAULT NULL COMMENT '메뉴 아이콘 이미지 경로',
  `default_order` int(11) DEFAULT NULL COMMENT '제공된 메뉴의 기본 순서',
  `menucode` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메뉴 정보 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_menu_auth`
--

DROP TABLE IF EXISTS `tbl_portal_menu_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_menu_auth` (
  `menu_id` int(11) NOT NULL COMMENT '메뉴 아이디',
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `user_id` varchar(100) NOT NULL DEFAULT '' COMMENT '사용자/부서 아이디',
  `access_YN` int(11) DEFAULT NULL COMMENT '접근 가능(1), 접근 불가(0)',
  `user_type` int(11) DEFAULT NULL COMMENT '사용자(U), 부서(D)',
  `sn` int(11) DEFAULT 0,
  PRIMARY KEY (`menu_id`,`company_id`,`tenant_id`,`user_id`),
  CONSTRAINT `FK_tbl_portal_menu_auth_menu_id_tbl_portal_menu_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `tbl_portal_menu` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메뉴권한 설정 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_menu_comp`
--

DROP TABLE IF EXISTS `tbl_portal_menu_comp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_menu_comp` (
  `company_id` varchar(100) NOT NULL COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `menu_id` int(11) NOT NULL DEFAULT 0 COMMENT '메뉴 아이디',
  `menu_used` int(11) DEFAULT 0 COMMENT '활성화(Y), 비활성화(N)',
  `company_lang` varchar(45) DEFAULT NULL,
  `company_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`company_id`,`tenant_id`,`menu_id`),
  KEY `FK_tbl_portal_menu_comp_menu_id_tbl_portal_menu_menu_id` (`menu_id`),
  CONSTRAINT `FK_tbl_portal_menu_comp_menu_id_tbl_portal_menu_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `tbl_portal_menu` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회사별 메뉴 설정 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_menu_name`
--

DROP TABLE IF EXISTS `tbl_portal_menu_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_menu_name` (
  `menu_id` int(11) NOT NULL DEFAULT 0 COMMENT '메뉴 아이디',
  `menu_lang` varchar(45) NOT NULL DEFAULT '' COMMENT '메뉴 이름의 언어',
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `menu_name` varchar(100) DEFAULT NULL COMMENT '메뉴 이름(언어별)',
  PRIMARY KEY (`menu_id`,`menu_lang`,`company_id`,`tenant_id`),
  CONSTRAINT `FK_tbl_portal_menu_name_menu_id_tbl_portal_menu_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `tbl_portal_menu` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='메뉴 이름 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_menu_user`
--

DROP TABLE IF EXISTS `tbl_portal_menu_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_menu_user` (
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `menu_id` int(11) NOT NULL DEFAULT 0 COMMENT '메뉴 아이디',
  `menu_order` int(11) DEFAULT NULL COMMENT '메뉴 순서',
  PRIMARY KEY (`user_id`,`tenant_id`,`company_id`,`menu_id`),
  KEY `FK_tbl_portal_menu_user_menu_id_tbl_portal_menu_menu_id` (`menu_id`),
  CONSTRAINT `FK_tbl_portal_menu_user_menu_id_tbl_portal_menu_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `tbl_portal_menu` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='개인별 메뉴 순서 설정 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_portlet`
--

DROP TABLE IF EXISTS `tbl_portal_portlet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_portlet` (
  `portlet_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '포틀릿 아이디',
  `menu_id` int(11) NOT NULL DEFAULT 0 COMMENT '포틀릿에 연결된 메뉴 아이디',
  `portlet_url` varchar(200) DEFAULT NULL COMMENT '포틀릿 연결 URL',
  `portlet_type` varchar(5) DEFAULT 'G' COMMENT '기본(G), 추가(A)',
  `default_order` int(11) DEFAULT NULL COMMENT '제공된 포틀릿 기본 순서',
  `portletcode` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`portlet_id`,`menu_id`),
  KEY `FK_tbl_portal_portlet_menu_id_tbl_portal_menu_menu_id` (`menu_id`),
  CONSTRAINT `FK_tbl_portal_portlet_menu_id_tbl_portal_menu_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `tbl_portal_menu` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='포틀릿 정보 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_portlet_auth`
--

DROP TABLE IF EXISTS `tbl_portal_portlet_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_portlet_auth` (
  `portlet_id` int(11) NOT NULL COMMENT '포틀릿 아이디',
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `user_id` varchar(100) NOT NULL DEFAULT '' COMMENT '사용자/부서 아이디',
  `access_YN` int(11) DEFAULT NULL COMMENT '접근 가능(1), 접근 불가(0)',
  `user_type` int(11) DEFAULT NULL COMMENT '사용자(U), 부서(D)',
  `sn` int(11) DEFAULT 0,
  PRIMARY KEY (`portlet_id`,`company_id`,`tenant_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_portlet_comp`
--

DROP TABLE IF EXISTS `tbl_portal_portlet_comp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_portlet_comp` (
  `company_id` varchar(100) NOT NULL COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `portlet_id` int(11) NOT NULL DEFAULT 0 COMMENT '포틀릿 아이디',
  `menu_id` int(11) DEFAULT NULL COMMENT '메뉴 아이디',
  `portlet_category` varchar(5) DEFAULT NULL COMMENT '게시판(B), 메일(M), 결재(A), 외부링크(L)',
  `connection_url` varchar(200) DEFAULT NULL COMMENT '타입별 모듈 아이디 / URL',
  `portlet_used` int(11) DEFAULT 0 COMMENT '포틀릿 보임(Y)/숨김(N)',
  `portlet_order` int(11) DEFAULT NULL COMMENT '포틀릿 순서',
  `board_id` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`company_id`,`tenant_id`,`portlet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회사별 포틀릿 설정 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_portlet_name`
--

DROP TABLE IF EXISTS `tbl_portal_portlet_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_portlet_name` (
  `portlet_id` int(11) NOT NULL DEFAULT 0 COMMENT '포틀릿 아이디',
  `menu_id` int(11) NOT NULL DEFAULT 0 COMMENT '메뉴 아이디',
  `portlet_lang` varchar(100) NOT NULL DEFAULT '' COMMENT '이름의 언어',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `portlet_name` varchar(100) DEFAULT NULL COMMENT '포틀릿 이름(언어별)',
  PRIMARY KEY (`portlet_id`,`menu_id`,`portlet_lang`,`tenant_id`,`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='포틀릿 이름 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_portlet_user`
--

DROP TABLE IF EXISTS `tbl_portal_portlet_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_portlet_user` (
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `portlet_id` int(11) NOT NULL DEFAULT 0 COMMENT '포틀릿 아이디',
  `portlet_order` int(11) DEFAULT NULL COMMENT '포틀릿 순서',
  `menu_id` int(11) DEFAULT NULL COMMENT '포틀릿과 연관된 메뉴 아이디',
  `portlet_used` int(11) DEFAULT 1,
  `theme_id` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`user_id`,`tenant_id`,`company_id`,`portlet_id`,`theme_id`),
  KEY `FK_tbl_portlet_user_idx` (`portlet_id`,`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자별 포틀릿 순서 설정 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_startpage`
--

DROP TABLE IF EXISTS `tbl_portal_startpage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_startpage` (
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `menu_id` int(11) DEFAULT NULL COMMENT '메뉴 아이디',
  PRIMARY KEY (`user_id`,`tenant_id`,`company_id`),
  KEY `FK_tbl_portal_startpage_menu_id_tbl_portal_menu_menu_id` (`menu_id`),
  CONSTRAINT `FK_tbl_portal_startpage_menu_id_tbl_portal_menu_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `tbl_portal_menu` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_theme`
--

DROP TABLE IF EXISTS `tbl_portal_theme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_theme` (
  `theme_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '테마아이디',
  `theme_name` varchar(100) DEFAULT NULL COMMENT '테마 이름',
  `theme_content` varchar(400) DEFAULT NULL COMMENT '테마 설명(내용)',
  `theme_content2` varchar(400) DEFAULT NULL,
  `theme_content3` varchar(400) DEFAULT NULL,
  `THEME_NAME2` varchar(100) DEFAULT 'theme2',
  `THEME_NAME3` varchar(100) DEFAULT 'theme3',
  PRIMARY KEY (`theme_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='테마 정보 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_theme_auth`
--

DROP TABLE IF EXISTS `tbl_portal_theme_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_theme_auth` (
  `theme_id` int(11) NOT NULL COMMENT '테마 아이디',
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `user_id` varchar(100) NOT NULL DEFAULT '' COMMENT '사용자/부서 아이디',
  `access_YN` int(11) DEFAULT NULL COMMENT '접근 가능(1), 접근 불가(0)',
  `user_type` int(11) DEFAULT NULL COMMENT '사용자(U), 부서(D)',
  `sn` int(11) DEFAULT 0,
  PRIMARY KEY (`theme_id`,`company_id`,`tenant_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_theme_comp`
--

DROP TABLE IF EXISTS `tbl_portal_theme_comp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_theme_comp` (
  `company_id` varchar(100) NOT NULL COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `theme_id` int(11) NOT NULL DEFAULT 0 COMMENT '테마 아이디',
  `theme_used` int(4) DEFAULT 0 COMMENT '활성화(Y), 비활성화(N)',
  `theme_default` int(4) DEFAULT 0 COMMENT '기본(Y), 기본아님(N)',
  PRIMARY KEY (`company_id`,`tenant_id`,`theme_id`),
  KEY `FK_tbl_portal_theme_comp_theme_id_tbl_portal_theme_theme_id` (`theme_id`),
  CONSTRAINT `FK_tbl_portal_theme_comp_theme_id_tbl_portal_theme_theme_id` FOREIGN KEY (`theme_id`) REFERENCES `tbl_portal_theme` (`theme_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='회사별 테마 설정 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_theme_portlet`
--

DROP TABLE IF EXISTS `tbl_portal_theme_portlet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_theme_portlet` (
  `theme_id` int(11) NOT NULL,
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0,
  `company_id` varchar(100) NOT NULL DEFAULT '',
  `portlet_id` int(11) NOT NULL DEFAULT 0,
  `portlet_used` int(11) DEFAULT NULL,
  `portlet_order` int(11) DEFAULT NULL,
  `menu_id` int(11) DEFAULT NULL,
  `is_fixed` int(11) DEFAULT 0,
  PRIMARY KEY (`theme_id`,`tenant_id`,`company_id`,`portlet_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='테마별 포틀릿 사용여부 관련 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portal_theme_user`
--

DROP TABLE IF EXISTS `tbl_portal_theme_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portal_theme_user` (
  `user_id` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `company_id` varchar(100) NOT NULL DEFAULT '' COMMENT '회사 아이디',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `used_theme` int(11) NOT NULL DEFAULT 0 COMMENT '사용자가 사용하는 테마 아이디',
  `used_frame` int(11) DEFAULT NULL COMMENT '사용자가 사용하는 프레임 아이디',
  `is_default` int(11) DEFAULT 0,
  PRIMARY KEY (`user_id`,`company_id`,`tenant_id`,`used_theme`),
  KEY `FK_tbl_portal_theme_user_used_theme_tbl_portal_theme_theme_id` (`used_theme`),
  KEY `FK_tbl_portal_theme_user_used_frame_tbl_portal_frame_frame_id` (`used_frame`),
  CONSTRAINT `FK_tbl_portal_theme_user_used_frame_tbl_portal_frame_frame_id` FOREIGN KEY (`used_frame`) REFERENCES `tbl_portal_frame` (`frame_id`),
  CONSTRAINT `FK_tbl_portal_theme_user_used_theme_tbl_portal_theme_theme_id` FOREIGN KEY (`used_theme`) REFERENCES `tbl_portal_theme` (`theme_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자별 테마 & 프레임 설정 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portalpage_cache`
--

DROP TABLE IF EXISTS `tbl_portalpage_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portalpage_cache` (
  `PORTALPAGEID` varchar(200) NOT NULL,
  `ACCESSIDLIST` varchar(510) NOT NULL,
  `RENDEREDHTML` longtext DEFAULT NULL,
  `COMPANYID` varchar(100) DEFAULT NULL,
  `USERID` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`PORTALPAGEID`,`ACCESSIDLIST`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portalpage_category`
--

DROP TABLE IF EXISTS `tbl_portalpage_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portalpage_category` (
  `CATEGORY` varchar(100) NOT NULL,
  `DISPLAYNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`CATEGORY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portalpage_general`
--

DROP TABLE IF EXISTS `tbl_portalpage_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portalpage_general` (
  `UID_` varchar(100) NOT NULL,
  `PARENTUID` varchar(100) DEFAULT NULL,
  `DEPTH` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATORID` varchar(100) DEFAULT NULL,
  `CREATORNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `WIDTH` bigint(10) DEFAULT NULL,
  `HEIGHT` bigint(10) DEFAULT NULL,
  `ROWLENGTH` bigint(10) DEFAULT NULL,
  `COLUMNLENGTH` bigint(10) DEFAULT NULL,
  `ROWSPLIT` varchar(100) DEFAULT NULL,
  `COLUMNSPLIT` varchar(100) DEFAULT NULL,
  `GUBUNFLAG` varchar(100) DEFAULT NULL,
  `USEFLAG` varchar(20) DEFAULT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  `BASETYPE` varchar(20) DEFAULT NULL,
  `THEMEUID` varchar(76) DEFAULT NULL,
  `DEFAULTPAGE` varchar(4) DEFAULT NULL,
  `TABLEVIEWOPTION` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`UID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portalpage_items`
--

DROP TABLE IF EXISTS `tbl_portalpage_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portalpage_items` (
  `UID_` varchar(100) NOT NULL,
  `PAGEUID` varchar(100) NOT NULL,
  `PARENTPAGEUID` varchar(100) NOT NULL,
  `OWNERPAGEUID` varchar(100) NOT NULL,
  `PORTLETTYPE` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WIDTH` bigint(10) DEFAULT NULL,
  `HEIGHT` bigint(10) DEFAULT NULL,
  `ROWPOS` bigint(10) DEFAULT NULL,
  `COLUMNPOS` bigint(10) DEFAULT NULL,
  `CANREMOVE` bigint(10) DEFAULT NULL,
  `CANRESIZE` bigint(10) DEFAULT NULL,
  `CANREPLACE` bigint(10) DEFAULT NULL,
  `ALIGN` varchar(100) DEFAULT NULL,
  `VALIGN` varchar(100) DEFAULT NULL,
  `TOPMARGIN` bigint(10) DEFAULT NULL,
  `BOTTOMMARGIN` bigint(10) DEFAULT NULL,
  `LEFTMARGIN` bigint(10) DEFAULT NULL,
  `RIGHTMARGIN` bigint(10) DEFAULT NULL,
  `MANDATORY` varchar(20) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`PAGEUID`,`OWNERPAGEUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portalpage_items_change`
--

DROP TABLE IF EXISTS `tbl_portalpage_items_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portalpage_items_change` (
  `UID_` varchar(100) NOT NULL,
  `PAGEUID` varchar(100) NOT NULL,
  `OWNERPAGEUID` varchar(100) NOT NULL,
  `CREATORID` varchar(100) NOT NULL,
  `CREATORNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `CHANGEFLAG` varchar(20) DEFAULT NULL,
  `USERPAGEUID` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`PAGEUID`,`OWNERPAGEUID`,`CREATORID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portlet_board`
--

DROP TABLE IF EXISTS `tbl_portlet_board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portlet_board` (
  `UID_` varchar(100) NOT NULL,
  `CREATORID` varchar(100) NOT NULL,
  `USERTYPE` varchar(20) NOT NULL,
  `BOARDID` varchar(100) NOT NULL,
  `ITEMCOUNT` bigint(10) DEFAULT NULL,
  `ITEMFIELDS` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`USERTYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portlet_category`
--

DROP TABLE IF EXISTS `tbl_portlet_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portlet_category` (
  `CATEGORY` varchar(100) NOT NULL,
  `DISPLAYNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`CATEGORY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portlet_general`
--

DROP TABLE IF EXISTS `tbl_portlet_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portlet_general` (
  `UID_` varchar(100) NOT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PORTLET_TYPE` bigint(10) DEFAULT NULL,
  `URL` varchar(1024) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MAXURL` varchar(1024) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SHOWTITLEBAR` varchar(20) DEFAULT NULL,
  `USERTYPE` varchar(20) DEFAULT NULL,
  `HEIGHT` bigint(10) DEFAULT NULL,
  `GUBUNFLAG` varchar(100) DEFAULT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  `BASETYPE` varchar(100) DEFAULT NULL,
  `USEPOTALGUBUN` varchar(100) DEFAULT NULL,
  `WIDTH` bigint(10) DEFAULT NULL,
  `FRAMETYPE` varchar(20) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`UID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portlet_htmlpage`
--

DROP TABLE IF EXISTS `tbl_portlet_htmlpage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portlet_htmlpage` (
  `UID_` varchar(100) NOT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `HTMLDATA` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portlet_image`
--

DROP TABLE IF EXISTS `tbl_portlet_image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portlet_image` (
  `UID_` varchar(200) NOT NULL,
  `IMAGEPATH` varchar(1000) DEFAULT NULL,
  `IMAGEWIDTH` bigint(10) DEFAULT NULL,
  `IMAGEHEIGHT` bigint(10) DEFAULT NULL,
  `IMAGETYPE` varchar(4) DEFAULT NULL,
  `OPENMODE` varchar(4) DEFAULT NULL,
  `WINDOWOPTION` varchar(600) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portlet_parameters`
--

DROP TABLE IF EXISTS `tbl_portlet_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portlet_parameters` (
  `UID_` varchar(100) NOT NULL,
  `PARAMNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `PARAMVALUE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PARAMTYPE` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`PARAMNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_portlet_url`
--

DROP TABLE IF EXISTS `tbl_portlet_url`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_portlet_url` (
  `UID_` varchar(100) NOT NULL,
  `CREATORID` varchar(100) NOT NULL,
  `USERTYPE` varchar(2) NOT NULL,
  `URL` varchar(400) CHARACTER SET utf8mb4 NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`USERTYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_previoslyregi`
--

DROP TABLE IF EXISTS `tbl_previoslyregi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_previoslyregi` (
  `USECOMPANY` varchar(20) NOT NULL,
  `PREVIOSLYREGIUSE` decimal(22,0) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USECOMPANY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_procedure_log`
--

DROP TABLE IF EXISTS `tbl_procedure_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_procedure_log` (
  `log_num` int(11) NOT NULL AUTO_INCREMENT,
  `log_msg` varchar(1000) DEFAULT NULL,
  `log_date` datetime DEFAULT NULL,
  PRIMARY KEY (`log_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_proxyinfo`
--

DROP TABLE IF EXISTS `tbl_proxyinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_proxyinfo` (
  `USERID` varchar(80) NOT NULL,
  `PROXYUSERID` varchar(80) DEFAULT NULL,
  `PROXYUSERNAME` varchar(200) DEFAULT NULL,
  `PROXYUSERDEPTID` varchar(400) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_approvnotimailconf`
--

DROP TABLE IF EXISTS `tbl_ps_approvnotimailconf`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_approvnotimailconf` (
  `USERID` varchar(40) NOT NULL,
  `ALERT` varchar(4) DEFAULT NULL,
  `COMPLETE` varchar(4) DEFAULT NULL,
  `BANSONG` varchar(4) DEFAULT NULL,
  `CALLBACK` varchar(4) DEFAULT NULL,
  `HESONG` varchar(4) NOT NULL,
  `SAVEMAILFLAG` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_empmonth`
--

DROP TABLE IF EXISTS `tbl_ps_empmonth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_empmonth` (
  `CN` varchar(80) NOT NULL,
  `DISPLAYNAME` varchar(120) CHARACTER SET utf8mb4 NOT NULL,
  `DISPLAYNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPARTMENT` varchar(80) NOT NULL,
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PHYSICALDELIVERYOFFICENAME` varchar(160) NOT NULL,
  `COMPANY` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANY2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FILEPATH` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TERM` varchar(20) NOT NULL,
  `DATE_` datetime DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`PHYSICALDELIVERYOFFICENAME`,`TERM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_lightpoll`
--

DROP TABLE IF EXISTS `tbl_ps_lightpoll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_lightpoll` (
  `ITEMSEQ` bigint(10) NOT NULL AUTO_INCREMENT,
  `COMPANYID` varchar(20) NOT NULL,
  `STARTDATE` datetime NOT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `POLLSELECTIONCOUNT` bigint(10) NOT NULL,
  `POLLTITLE` varchar(1000) CHARACTER SET utf8mb4 NOT NULL,
  `POLLTITLE2` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ANSWER1` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWER2` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWER3` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWER4` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWER5` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWER6` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWER7` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWER8` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWER9` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `ANSWER10` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ITEMSEQ`),
  UNIQUE KEY `IDX_TBL_PS_LIGHTPOLL` (`TENANT_ID`,`ITEMSEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_lightpoll_option`
--

DROP TABLE IF EXISTS `tbl_ps_lightpoll_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_lightpoll_option` (
  `lightpollOptionId` bigint(10) NOT NULL AUTO_INCREMENT,
  `userId` varchar(100) DEFAULT NULL,
  `isPreview` tinyint(5) DEFAULT 0,
  `tenantId` mediumint(5) NOT NULL,
  PRIMARY KEY (`lightpollOptionId`,`tenantId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_lightpollresult`
--

DROP TABLE IF EXISTS `tbl_ps_lightpollresult`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_lightpollresult` (
  `ITEMSEQ` varchar(10) NOT NULL,
  `USERID` varchar(100) NOT NULL,
  `RESULT` bigint(10) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMSEQ`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_linkportlet`
--

DROP TABLE IF EXISTS `tbl_ps_linkportlet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_linkportlet` (
  `LINK_ID` int(11) NOT NULL AUTO_INCREMENT,
  `LINK_NAME` varchar(45) DEFAULT NULL,
  `LINK_URL` varchar(2000) DEFAULT NULL,
  `LINK_NUM_URL` varchar(2000) DEFAULT NULL,
  `LINK_ORDER` int(11) DEFAULT NULL,
  `TENANT_ID` mediumint(5) DEFAULT NULL,
  `COMPANYID` varchar(45) DEFAULT NULL,
  `USE_NUM_URL` varchar(45) DEFAULT 'N',
  `NUM_URL_USERID` varchar(45) DEFAULT 'N',
  `NUM_URL_DEPTID` varchar(45) DEFAULT 'N',
  `NUM_URL_COMPANYID` varchar(45) DEFAULT 'N',
  `NUM_URL_EMPNO` varchar(45) DEFAULT 'N',
  `URL_USERID` varchar(45) DEFAULT 'N',
  `URL_DEPTID` varchar(45) DEFAULT 'N',
  `URL_COMPANYID` varchar(45) DEFAULT 'N',
  `URL_EMPNO` varchar(45) DEFAULT 'N',
  PRIMARY KEY (`LINK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_notice`
--

DROP TABLE IF EXISTS `tbl_ps_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_notice` (
  `ITEMSEQ` bigint(10) NOT NULL AUTO_INCREMENT,
  `COMPANYID` varchar(20) NOT NULL,
  `POSTDATE` datetime NOT NULL,
  `TITLE` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `TITLE2` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ITEMSEQ`),
  UNIQUE KEY `IDX_TBL_PS_NOTICE` (`TENANT_ID`,`ITEMSEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_popup`
--

DROP TABLE IF EXISTS `tbl_ps_popup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_popup` (
  `COMPANYID` varchar(20) NOT NULL,
  `ITEMSEQ` bigint(10) NOT NULL AUTO_INCREMENT,
  `STARTDATE` datetime NOT NULL,
  `ENDDATE` datetime NOT NULL,
  `WIDTH` mediumint(5) DEFAULT NULL,
  `HEIGHT` mediumint(5) DEFAULT NULL,
  `TITLE` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `TITLE2` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `POSITION` varchar(20) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `INUSE` smallint(6) NOT NULL DEFAULT 1,
  `SKINVALUE` smallint(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ITEMSEQ`),
  UNIQUE KEY `IDX_TBL_PS_POPUP` (`TENANT_ID`,`COMPANYID`,`ITEMSEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_popup_option`
--

DROP TABLE IF EXISTS `tbl_ps_popup_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_popup_option` (
  `popupOptionId` bigint(10) NOT NULL AUTO_INCREMENT,
  `userId` varchar(100) DEFAULT NULL,
  `isPreview` smallint(6) DEFAULT 0,
  `tenantId` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`popupOptionId`,`tenantId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_quicklink`
--

DROP TABLE IF EXISTS `tbl_ps_quicklink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_quicklink` (
  `QUICKLINKID` varchar(76) NOT NULL,
  `QUICKLINKNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `QUICKLINKNAME2` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `QUICKLINKNAME3` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `QUICKLINKNAME4` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `LINKTYPE` varchar(4) NOT NULL,
  `LINKTYPEURL` varchar(1024) CHARACTER SET utf8mb4 DEFAULT NULL,
  `URL` varchar(1024) CHARACTER SET utf8mb4 DEFAULT NULL,
  `REGDATE` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `MODIDATE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `REGUSERID` varchar(40) NOT NULL,
  `SIZE_` varchar(40) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `LINKORDER` int(11) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`QUICKLINKID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_quicklink_acl`
--

DROP TABLE IF EXISTS `tbl_ps_quicklink_acl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_quicklink_acl` (
  `QUICKLINKID` varchar(76) NOT NULL,
  `ACCESSID` varchar(100) NOT NULL,
  `ACCESSNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `ACCESSNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `VIEW_FLAG` varchar(4) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`QUICKLINKID`,`ACCESSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_shareapproval`
--

DROP TABLE IF EXISTS `tbl_ps_shareapproval`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_shareapproval` (
  `OWNERID` varchar(80) NOT NULL,
  `SHAREUSERID` varchar(80) NOT NULL,
  `SHAREDATE` datetime DEFAULT NULL,
  `SHAREUSERDEPTID` varchar(200) DEFAULT NULL,
  `TENANTID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(160) NOT NULL,
  PRIMARY KEY (`OWNERID`,`TENANTID`,`SHAREUSERID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_sliderimage`
--

DROP TABLE IF EXISTS `tbl_ps_sliderimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_sliderimage` (
  `SLIDERID` varchar(76) NOT NULL,
  `SLIDERNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `SLIDERNAME2` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `FILENAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `IMAGEPATH` varchar(1024) CHARACTER SET utf8mb4 NOT NULL,
  `REGUSERID` varchar(40) NOT NULL,
  `REGDATE` varchar(200) CHARACTER SET utf8mb4 NOT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  `ISUSE` bigint(10) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `URL` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`SLIDERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_userwebpart`
--

DROP TABLE IF EXISTS `tbl_ps_userwebpart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_userwebpart` (
  `USERID` varchar(40) NOT NULL,
  `ITEMID` varchar(144) NOT NULL,
  `ITEMSEQ` bigint(10) NOT NULL,
  `ITEMPOSITION` bigint(10) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`,`ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_webpartgroup`
--

DROP TABLE IF EXISTS `tbl_ps_webpartgroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_webpartgroup` (
  `COMPANYID` varchar(510) DEFAULT NULL,
  `ID` varchar(510) NOT NULL,
  `NAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  UNIQUE KEY `PK_TBL_PS_WEBPARTGROUP` (`TENANT_ID`,`ID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_webpartitem`
--

DROP TABLE IF EXISTS `tbl_ps_webpartitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_webpartitem` (
  `COMPANYID` varchar(510) DEFAULT NULL,
  `ID` varchar(510) NOT NULL,
  `GROUPID` varchar(510) DEFAULT NULL,
  `NAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `URL` varchar(510) DEFAULT NULL,
  `DEFAULTPRIORITY` double(126,0) DEFAULT NULL,
  `DEFAULTPOSITION` double(126,0) DEFAULT NULL,
  `DEFAULTUSE` double(126,0) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  UNIQUE KEY `PK_TBL_PS_WEBPARTITEM` (`TENANT_ID`,`ID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_webpartitemacl`
--

DROP TABLE IF EXISTS `tbl_ps_webpartitemacl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_webpartitemacl` (
  `ITEMID` varchar(510) NOT NULL,
  `ACCESSID` varchar(510) DEFAULT NULL,
  `ACCESSNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  UNIQUE KEY `PK_TBL_PS_WEBPARTITEMACL` (`TENANT_ID`,`ITEMID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_pwdinfo`
--

DROP TABLE IF EXISTS `tbl_pwdinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_pwdinfo` (
  `USERID` varchar(100) NOT NULL,
  `FLAG` varchar(2) NOT NULL,
  `PWD` varchar(2000) DEFAULT NULL,
  `PWDTYPE` varchar(4) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_qs_brdmng`
--

DROP TABLE IF EXISTS `tbl_qs_brdmng`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_qs_brdmng` (
  `BRD_ID` bigint(10) NOT NULL,
  `USER_ID` varchar(40) NOT NULL,
  `MNG_GB` varchar(2) NOT NULL,
  `USER_NM` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ADMIN_FG` tinyint(1) DEFAULT NULL,
  `LST_FG` varchar(2) DEFAULT NULL,
  `READ_FG` tinyint(1) DEFAULT NULL,
  `REPLY_FG` tinyint(1) DEFAULT NULL,
  `WRT_FG` tinyint(1) DEFAULT NULL,
  `VBL_FG` tinyint(1) DEFAULT NULL,
  `MNGER_FG` tinyint(1) DEFAULT NULL,
  `MNGER_MAIL_FG` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`BRD_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_qs_itemseq`
--

DROP TABLE IF EXISTS `tbl_qs_itemseq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_qs_itemseq` (
  `BRD_ID` bigint(10) NOT NULL,
  `ITEM_NO` bigint(10) DEFAULT 0,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_receiptpointinfo`
--

DROP TABLE IF EXISTS `tbl_receiptpointinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_receiptpointinfo` (
  `DOCID` varchar(80) NOT NULL,
  `RECEIPTPOINTID` varchar(400) NOT NULL,
  `RECEIPTPOINTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSSN` bigint(10) NOT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERID` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTMEMBERSN` bigint(10) DEFAULT NULL,
  `RECEIPTPOINTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ROUTEYN` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`RECEIPTPOINTID`(255),`PROCESSSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_recexchinfo`
--

DROP TABLE IF EXISTS `tbl_recexchinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_recexchinfo` (
  `PackDocID` varchar(255) DEFAULT NULL,
  `administrative_num` varchar(255) DEFAULT NULL,
  `s_id` varchar(30) DEFAULT NULL,
  `s_UserID` varchar(30) DEFAULT NULL,
  `s_orgname` varchar(100) DEFAULT NULL,
  `s_systemname` varchar(100) DEFAULT NULL,
  `s_email` varchar(50) DEFAULT NULL,
  `r_ID` varchar(30) DEFAULT NULL,
  `r_UserID` varchar(30) DEFAULT NULL,
  `recdate` datetime DEFAULT NULL,
  `attachxml` varchar(255) DEFAULT NULL,
  `attachxsl` varchar(255) DEFAULT NULL,
  `xmlpath` varchar(255) DEFAULT NULL,
  `sourcexmlPath` varchar(255) DEFAULT NULL,
  `DocID` varchar(50) DEFAULT NULL,
  `ModiFlag` varchar(10) DEFAULT NULL,
  `ModiDate` datetime DEFAULT NULL,
  `Notification` varchar(10) DEFAULT NULL,
  `AddenDa` text DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`COMPANYID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_record`
--

DROP TABLE IF EXISTS `tbl_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_record` (
  `RECORDID` varchar(200) NOT NULL,
  `DOCID` varchar(80) DEFAULT NULL,
  `PROCESSDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSDEPTCODE` varchar(28) DEFAULT NULL,
  `REGISTERYEAR` varchar(16) DEFAULT NULL,
  `REGISTERDATE` datetime DEFAULT NULL,
  `REGISTERNO` varchar(200) DEFAULT NULL,
  `APRMEMBERTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DRAFTERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXECUTEDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SENDINGMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DELIVERYNO` varchar(68) DEFAULT NULL,
  `PRODUCEDEPTREGNO` varchar(200) DEFAULT NULL,
  `ELECTRONICRECFLAG` varchar(4) DEFAULT NULL,
  `SPECIALRECORDCODE` varchar(20) DEFAULT NULL,
  `PUBLICITYCODE` varchar(36) DEFAULT NULL,
  `LIMITRANGE` varchar(400) DEFAULT NULL,
  `OLDRECORDFLAG` varchar(4) DEFAULT NULL,
  `DELETEDATE` datetime DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT NULL,
  `SPECIALCATALOGFLAG` varchar(4) DEFAULT NULL,
  `ATTACHFLAG` varchar(4) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `REJECTFLAG` varchar(4) DEFAULT NULL,
  `MANUALREGFLAG` varchar(4) DEFAULT NULL,
  `DOCTYPE` varchar(4) DEFAULT NULL,
  `PROCESSDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DRAFTERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SENDINGMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  `PUBLICITYYN` char(2) DEFAULT 'Y',
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECORDID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_record_temp`
--

DROP TABLE IF EXISTS `tbl_record_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_record_temp` (
  `RECORDID` varchar(200) DEFAULT NULL,
  `DOCID` varchar(80) NOT NULL,
  `PROCESSDEPTNAME` varchar(200) DEFAULT NULL,
  `PROCESSDEPTCODE` varchar(28) DEFAULT NULL,
  `REGISTERYEAR` varchar(16) DEFAULT NULL,
  `REGISTERDATE` datetime DEFAULT NULL,
  `REGISTERNO` varchar(200) DEFAULT NULL,
  `APRMEMBERTITLE` varchar(200) DEFAULT NULL,
  `DRAFTERNAME` varchar(200) DEFAULT NULL,
  `EXECUTEDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) DEFAULT NULL,
  `SENDINGMEMBERNAME` varchar(200) DEFAULT NULL,
  `DELIVERYNO` varchar(68) DEFAULT NULL,
  `PRODUCEDEPTREGNO` varchar(200) DEFAULT NULL,
  `ELECTRONICRECFLAG` varchar(4) DEFAULT NULL,
  `SPECIALRECORDCODE` varchar(20) DEFAULT NULL,
  `PUBLICITYCODE` varchar(36) DEFAULT NULL,
  `LIMITRANGE` varchar(400) DEFAULT NULL,
  `OLDRECORDFLAG` varchar(4) DEFAULT NULL,
  `DELETEDATE` datetime DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT NULL,
  `SPECIALCATALOGFLAG` varchar(4) DEFAULT NULL,
  `ATTACHFLAG` varchar(4) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `REJECTFLAG` varchar(4) DEFAULT NULL,
  `MANUALREGFLAG` varchar(4) DEFAULT NULL,
  `DOCTYPE` varchar(4) DEFAULT NULL,
  `PROCESSDEPTNAME2` varchar(200) DEFAULT NULL,
  `APRMEMBERTITLE2` varchar(200) DEFAULT NULL,
  `DRAFTERNAME2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) DEFAULT NULL,
  `SENDINGMEMBERNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`DOCID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_recordhistory`
--

DROP TABLE IF EXISTS `tbl_recordhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_recordhistory` (
  `RECORDID` varchar(68) NOT NULL,
  `SEPERATEATTACHNO` varchar(8) NOT NULL,
  `VERSION` bigint(10) NOT NULL,
  `REGISTERDATE` datetime DEFAULT NULL,
  `TITLE` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `NUMOFPAGE` varchar(12) DEFAULT NULL,
  `APRMEMBERTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DRAFTER` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXECUTEDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SENDINGMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYDATE` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYREASON` varchar(1020) DEFAULT NULL,
  `MODIFIERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFIERID` varchar(400) DEFAULT NULL,
  `MODIFYFLAG` varchar(4) DEFAULT NULL,
  `DRAFTER2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SENDINGMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFIERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL DEFAULT 'S907000',
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECORDID`,`SEPERATEATTACHNO`,`VERSION`),
  CONSTRAINT `FK_TBL_RECORDHISTORY` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `RECORDID`, `SEPERATEATTACHNO`) REFERENCES `tbl_seperateattach` (`TENANT_ID`, `COMPANYID`, `RECORDID`, `SEPERATEATTACHNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_recreadhistory`
--

DROP TABLE IF EXISTS `tbl_recreadhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_recreadhistory` (
  `SERIALNO` decimal(19,0) NOT NULL,
  `DOCID` varchar(80) NOT NULL,
  `USERID` varchar(400) DEFAULT NULL,
  `USERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTCODE` varchar(28) DEFAULT NULL,
  `DEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `READDATE` datetime DEFAULT NULL,
  `USERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`SERIALNO`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_recrelayattachinfo`
--

DROP TABLE IF EXISTS `tbl_recrelayattachinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_recrelayattachinfo` (
  `xDocID` varchar(255) DEFAULT NULL,
  `AttachName` varchar(255) DEFAULT NULL,
  `AttachURL` varchar(255) DEFAULT NULL,
  `AttachSN` int(11) DEFAULT NULL,
  `AttachType` char(1) DEFAULT NULL,
  `TENANT_ID` mediumint(5) DEFAULT NULL,
  `COMPANYID` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_recrelayinfo`
--

DROP TABLE IF EXISTS `tbl_recrelayinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_recrelayinfo` (
  `docID` char(20) DEFAULT NULL,
  `xDocID` varchar(255) NOT NULL,
  `recdate` datetime DEFAULT NULL,
  `mFrom` varchar(255) DEFAULT NULL,
  `mTo` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `xMailType` varchar(8) DEFAULT NULL,
  `xFromCode` varchar(255) DEFAULT NULL,
  `xToCode` varchar(255) DEFAULT NULL,
  `xGw` varchar(255) DEFAULT NULL,
  `xDocType` varchar(6) DEFAULT NULL,
  `xDtdversion` varchar(255) DEFAULT NULL,
  `xxslVersion` varchar(255) DEFAULT NULL,
  `contentType` varchar(255) DEFAULT NULL,
  `sealURL` varchar(255) DEFAULT NULL,
  `xmlURL` varchar(255) DEFAULT NULL,
  `emlURL` varchar(255) DEFAULT NULL,
  `isPKI` char(1) DEFAULT NULL,
  `receivedDate` char(20) DEFAULT NULL,
  `idx` int(11) NOT NULL AUTO_INCREMENT,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`idx`,`xDocID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='							';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_recrelaysigninfo`
--

DROP TABLE IF EXISTS `tbl_recrelaysigninfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_recrelaysigninfo` (
  `XDOCID` varchar(255) DEFAULT NULL,
  `SIGNNAME` varchar(255) DEFAULT NULL,
  `REALSIGNNAME` varchar(255) DEFAULT NULL,
  `COMPANYID` varchar(45) DEFAULT NULL,
  `TENANT_ID` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_recroleinfo`
--

DROP TABLE IF EXISTS `tbl_recroleinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_recroleinfo` (
  `RECORDID` varchar(68) NOT NULL,
  `SEPERATEATTACHNO` varchar(8) NOT NULL,
  `USERID` varchar(400) NOT NULL,
  `USERRIGHT` bigint(10) DEFAULT NULL,
  `USERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTCODE` varchar(28) DEFAULT NULL,
  `DEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECORDID`,`SEPERATEATTACHNO`,`USERID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_recroleinfo_temp`
--

DROP TABLE IF EXISTS `tbl_recroleinfo_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_recroleinfo_temp` (
  `DOCID` char(20) NOT NULL,
  `RECORDID` varchar(68) DEFAULT NULL,
  `SEPERATEATTACHNO` varchar(8) NOT NULL,
  `USERID` varchar(200) NOT NULL,
  `USERRIGHT` bigint(10) DEFAULT NULL,
  `USERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTCODE` varchar(28) DEFAULT NULL,
  `DEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`DOCID`,`SEPERATEATTACHNO`,`USERID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_registercontainer`
--

DROP TABLE IF EXISTS `tbl_registercontainer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_registercontainer` (
  `sn` bigint(255) NOT NULL AUTO_INCREMENT,
  `containerID` varchar(45) NOT NULL,
  `contname` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
  `ownerID` varchar(45) DEFAULT NULL,
  `ownerName` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ownerTitle` varchar(20) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ownerDeptID` varchar(20) DEFAULT NULL,
  `ownerDeptNM` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `owneremail` varchar(255) DEFAULT NULL,
  `grantorID` varchar(45) DEFAULT NULL,
  `grantorName` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `grantorTitle` varchar(20) CHARACTER SET utf8mb4 DEFAULT NULL,
  `grantorDeptID` varchar(20) DEFAULT NULL,
  `grantorDeptNM` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `grantoremail` varchar(255) DEFAULT NULL,
  `sendYN` varchar(4) DEFAULT 'N',
  `companyid` varchar(20) NOT NULL,
  `tenant_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`sn`,`companyid`,`tenant_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_registerdoc`
--

DROP TABLE IF EXISTS `tbl_registerdoc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_registerdoc` (
  `SN` int(11) NOT NULL,
  `containerID` varchar(45) NOT NULL,
  `regtitle` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `orgdocid` varchar(45) DEFAULT NULL,
  `href` varchar(255) DEFAULT NULL,
  `hasAttachYn` varchar(4) DEFAULT NULL,
  `writerDeptID` varchar(20) DEFAULT NULL,
  `writerDeptName` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `writerDeptName2` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `writerName` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `writerName2` varchar(45) CHARACTER SET utf8mb4 DEFAULT NULL,
  `confirmYN` varchar(4) DEFAULT NULL,
  `regdate` datetime DEFAULT NULL,
  `confirmdate` datetime DEFAULT NULL,
  `receivedept` varchar(50) DEFAULT NULL,
  `nalincnt` varchar(45) DEFAULT NULL,
  `ingam` varchar(45) DEFAULT NULL,
  `dunggi` varchar(45) DEFAULT NULL,
  `displayYN` varchar(4) DEFAULT NULL,
  `tenant_id` mediumint(5) NOT NULL,
  `companyid` varchar(20) NOT NULL,
  `writerID` varchar(80) DEFAULT NULL,
  `confirmUserName` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`SN`,`containerID`,`tenant_id`,`companyid`),
  KEY `contID_idx` (`containerID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_registergrant`
--

DROP TABLE IF EXISTS `tbl_registergrant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_registergrant` (
  `containerID` varchar(45) DEFAULT NULL,
  `dept` varchar(10) DEFAULT NULL,
  `accessYN` char(1) DEFAULT NULL,
  `tenant_id` mediumint(5) DEFAULT NULL,
  `grantID` int(11) NOT NULL AUTO_INCREMENT,
  `cn` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`grantID`),
  KEY `index_cn` (`cn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_announcement`
--

DROP TABLE IF EXISTS `tbl_rgstbook_announcement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_announcement` (
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `ann_date` date DEFAULT NULL,
  `related_docu` varchar(100) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_announcement_history`
--

DROP TABLE IF EXISTS `tbl_rgstbook_announcement_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_announcement_history` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `ann_date` date DEFAULT NULL,
  `related_docu` varchar(100) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`,`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_certificate`
--

DROP TABLE IF EXISTS `tbl_rgstbook_certificate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_certificate` (
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `cer_date` date DEFAULT NULL,
  `gubun` tinyint(4) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  `purpose` varchar(200) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_certificate_history`
--

DROP TABLE IF EXISTS `tbl_rgstbook_certificate_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_certificate_history` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `cer_date` datetime DEFAULT NULL,
  `gubun` tinyint(4) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  `purpose` varchar(200) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`,`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_config`
--

DROP TABLE IF EXISTS `tbl_rgstbook_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_config` (
  `user_id` varchar(50) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `list_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_externaldocu`
--

DROP TABLE IF EXISTS `tbl_rgstbook_externaldocu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_externaldocu` (
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `ext_date` date DEFAULT NULL,
  `code_number` varchar(100) DEFAULT NULL,
  `seal_number` varchar(200) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_externaldocu_history`
--

DROP TABLE IF EXISTS `tbl_rgstbook_externaldocu_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_externaldocu_history` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `ext_date` datetime DEFAULT NULL,
  `code_number` varchar(100) DEFAULT NULL,
  `seal_number` varchar(200) DEFAULT NULL,
  `title` varchar(45) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`,`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_officialseal`
--

DROP TABLE IF EXISTS `tbl_rgstbook_officialseal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_officialseal` (
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `off_date` date DEFAULT NULL,
  `code_number` varchar(100) DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `stamp_number` int(11) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_officialseal_history`
--

DROP TABLE IF EXISTS `tbl_rgstbook_officialseal_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_officialseal_history` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `off_date` date DEFAULT NULL,
  `code_number` varchar(100) DEFAULT NULL,
  `destination` varchar(100) DEFAULT NULL,
  `stamp_number` int(11) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`,`tenant_id`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_otherseal`
--

DROP TABLE IF EXISTS `tbl_rgstbook_otherseal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_otherseal` (
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `oth_date` date DEFAULT NULL,
  `seal_number` tinyint(4) DEFAULT NULL,
  `stamp_number` int(11) DEFAULT NULL,
  `contents` varchar(200) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_otherseal_history`
--

DROP TABLE IF EXISTS `tbl_rgstbook_otherseal_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_otherseal_history` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `oth_date` date DEFAULT NULL,
  `seal_number` tinyint(4) DEFAULT NULL,
  `stamp_number` int(11) DEFAULT NULL,
  `contents` varchar(200) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`,`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_publication`
--

DROP TABLE IF EXISTS `tbl_rgstbook_publication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_publication` (
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `pub_date` date DEFAULT NULL,
  `book_title` varchar(200) DEFAULT NULL,
  `publisher` varchar(100) DEFAULT NULL,
  `related_docu` varchar(100) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rgstbook_publication_history`
--

DROP TABLE IF EXISTS `tbl_rgstbook_publication_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rgstbook_publication_history` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `pub_date` date DEFAULT NULL,
  `book_title` varchar(200) DEFAULT NULL,
  `publisher` varchar(100) DEFAULT NULL,
  `related_docu` varchar(100) DEFAULT NULL,
  `deptid` varchar(80) DEFAULT NULL,
  `deptname1` varchar(120) DEFAULT NULL,
  `deptname2` varchar(120) DEFAULT NULL,
  `manager` varchar(120) DEFAULT NULL,
  `create_id` varchar(80) NOT NULL,
  `create_date` datetime DEFAULT NULL,
  `update_date` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`,`item_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rnd_ask`
--

DROP TABLE IF EXISTS `tbl_rnd_ask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rnd_ask` (
  `business_seq` bigint(20) NOT NULL COMMENT '사업 일련번호',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `ask_user_id` varchar(100) NOT NULL COMMENT '요청자 아이디',
  `ask_date` date NOT NULL COMMENT '요청일',
  `askflag` varchar(4) DEFAULT '0' COMMENT '요청 상태',
  PRIMARY KEY (`business_seq`,`ask_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='R&D사업 변경요청 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rnd_business`
--

DROP TABLE IF EXISTS `tbl_rnd_business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rnd_business` (
  `business_seq` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '사업 일련번호',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `business_name` varchar(200) NOT NULL COMMENT '사업 명',
  `manager_id` varchar(100) NOT NULL COMMENT '사업 담당자 아이디',
  `create_user_id` varchar(100) NOT NULL COMMENT '사업 생성자 아이디',
  `create_date` date NOT NULL COMMENT '생성 일',
  `update_user_id` varchar(100) DEFAULT NULL COMMENT '사업 수정자 아이디',
  `update_date` date DEFAULT NULL COMMENT '수정 일',
  `delete_user_id` varchar(100) DEFAULT NULL COMMENT '사업 삭제자 아이디',
  `delete_date` date DEFAULT NULL COMMENT '삭제 일',
  `delflag` varchar(4) DEFAULT NULL COMMENT '삭제 상태',
  PRIMARY KEY (`business_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='R&D사업';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rnd_manage`
--

DROP TABLE IF EXISTS `tbl_rnd_manage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rnd_manage` (
  `manage_seq` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '사업관리 일련번호',
  `business_seq` bigint(20) NOT NULL COMMENT '사업 일련번호',
  `business_name` varchar(200) NOT NULL COMMENT '사업 명',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `start_date` date NOT NULL COMMENT '시작 일',
  `end_date` date NOT NULL COMMENT '종료 일',
  `manager_id` varchar(100) NOT NULL COMMENT '사업 담당자 아이디',
  `create_user_id` varchar(100) NOT NULL COMMENT '사업 생성자 아이디',
  `create_date` date NOT NULL COMMENT '생성 일',
  `update_user_id` varchar(100) DEFAULT NULL COMMENT '사업 수정자 아이디',
  `update_date` date DEFAULT NULL COMMENT '수정 일',
  `delete_user_id` varchar(100) DEFAULT NULL COMMENT '사업 삭제자 아이디',
  `delete_date` date DEFAULT NULL COMMENT '삭제 일',
  `accept_user_id` varchar(100) DEFAULT NULL COMMENT '사업 승인자 아이디',
  `accept_date` date DEFAULT NULL COMMENT '승인 일',
  `final_accept_user_id` varchar(100) DEFAULT NULL COMMENT '최종 승인자 아이디',
  `final_accept_date` date DEFAULT NULL COMMENT '최종 승인 일',
  `status` varchar(4) DEFAULT '0' COMMENT '승인 상태',
  `delflag` varchar(4) DEFAULT NULL COMMENT '삭제 상태',
  `ask_update` varchar(4) DEFAULT '0',
  PRIMARY KEY (`manage_seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='R&D사업 관리';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rnd_member`
--

DROP TABLE IF EXISTS `tbl_rnd_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rnd_member` (
  `business_seq` bigint(20) NOT NULL COMMENT '사업 일련번호',
  `tenant_id` mediumint(9) NOT NULL DEFAULT 0 COMMENT '테넌트 아이디',
  `member_role_code` varchar(4) NOT NULL COMMENT '멤버 역할 코드',
  `user_id` varchar(100) NOT NULL COMMENT '참여자 아이디',
  `shares_rate` bigint(10) NOT NULL COMMENT '참여율',
  `create_user_id` varchar(100) NOT NULL COMMENT '참여자를 등록한 사업 담당자 아이디',
  `create_date` date NOT NULL COMMENT '참여자(참여율) 등록 일',
  `update_user_id` varchar(100) DEFAULT NULL COMMENT '참여자의 정보를 수정한 사업 담당자 아이디',
  `update_date` date DEFAULT NULL COMMENT '참여자(참여율) 수정 일',
  `delete_user_id` varchar(100) DEFAULT NULL COMMENT '참여자의 정보를 삭제한 사업 담당자 아이디',
  `delete_date` date DEFAULT NULL COMMENT '참여자(참여율) 삭제 일',
  `delflag` varchar(4) DEFAULT NULL COMMENT '삭제 상태',
  PRIMARY KEY (`business_seq`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='R&D사업 담당자, 참여자 테이블';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rs_attach`
--

DROP TABLE IF EXISTS `tbl_rs_attach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rs_attach` (
  `ATTACHID` bigint(10) NOT NULL AUTO_INCREMENT,
  `RESID` bigint(10) NOT NULL,
  `FILESIZE` bigint(10) NOT NULL,
  `FILENAME` varchar(500) NOT NULL,
  `FILEPATH` varchar(500) NOT NULL,
  `COMPANYID` varchar(40) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ATTACHID`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rs_brd`
--

DROP TABLE IF EXISTS `tbl_rs_brd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rs_brd` (
  `BRD_ID` decimal(22,0) NOT NULL,
  `BRD_COMPANY` varchar(40) NOT NULL,
  `BRD_NM` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BRD_NM2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BRD_GROUP` varchar(6) DEFAULT NULL,
  `BRD_GB` varchar(2) DEFAULT NULL,
  `BRD_REF` bigint(10) DEFAULT 0,
  `BRD_LEVEL` bigint(10) DEFAULT 0,
  `BRD_STEP` bigint(10) DEFAULT NULL,
  `BRD_POSTTERM` bigint(10) DEFAULT NULL,
  `BRD_EXPLAIN` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BRD_ACCESS` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BRD_UPPER` bigint(10) DEFAULT NULL,
  `BRD_COUNT` bigint(10) DEFAULT NULL,
  `BRD_URL` varchar(510) DEFAULT NULL,
  `ATTACH_SIZE` bigint(10) DEFAULT NULL,
  `REPLY_MAIL_FG` tinyint(1) DEFAULT NULL,
  `OWNDEPTID` varchar(100) DEFAULT NULL,
  `OWNDEPTNM` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OWNDEPTNM2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OWNERID` varchar(2000) DEFAULT NULL,
  `OWNERNM` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OWNERNM2` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OWNERPOSITION` varchar(20) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OWNERPOSITION2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OWNERCALL` varchar(40) DEFAULT NULL,
  `MAKEDATE` varchar(16) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RESLOCATION` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BRD_UPPER2` varchar(8) DEFAULT NULL,
  `APPROVEFLAG` varchar(2) DEFAULT '0',
  `RETURNFLAG` varchar(2) DEFAULT '0',
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`BRD_COMPANY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rs_favorite`
--

DROP TABLE IF EXISTS `tbl_rs_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rs_favorite` (
  `RESID` varchar(40) NOT NULL,
  `RESCOMPANY` varchar(40) NOT NULL,
  `USERID` varchar(40) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`RESID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rs_persportlet`
--

DROP TABLE IF EXISTS `tbl_rs_persportlet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rs_persportlet` (
  `CN` varchar(80) NOT NULL COMMENT 'id',
  `BRD_ID` decimal(22,0) NOT NULL COMMENT '자원관리 id',
  `BRD_COMPANY` varchar(40) NOT NULL COMMENT 'company id',
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0 COMMENT '테넌트 id',
  PRIMARY KEY (`TENANT_ID`,`CN`,`BRD_COMPANY`,`BRD_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rs_resacl`
--

DROP TABLE IF EXISTS `tbl_rs_resacl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rs_resacl` (
  `RESID` varchar(40) NOT NULL,
  `DEPT_YN` varchar(2) DEFAULT NULL,
  `SDA_YN` varchar(2) DEFAULT NULL,
  `MEMBER_NAM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MEMBER_ID` varchar(80) NOT NULL,
  `ACCESS_LVL` varchar(2) DEFAULT NULL,
  `COMPANYID` varchar(40) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`RESID`,`MEMBER_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rs_schedule`
--

DROP TABLE IF EXISTS `tbl_rs_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rs_schedule` (
  `OWNERID` varchar(40) NOT NULL,
  `NUM` bigint(18) NOT NULL,
  `PNUM` bigint(18) DEFAULT 0,
  `COMPANYID` varchar(40) NOT NULL,
  `WRITERID` varchar(40) DEFAULT NULL,
  `DEPTNM` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OWNERNM` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `LOCATION` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TIMEDISPLAY` varchar(2) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `ALLDAY` varchar(2) DEFAULT NULL,
  `ALERTTIME` varchar(8) DEFAULT NULL,
  `CONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `IMPORTANCE` varchar(2) DEFAULT NULL,
  `REFLAG` varchar(2) DEFAULT NULL,
  `GRESFLAG` varchar(2) DEFAULT NULL,
  `WRITEDAY` datetime DEFAULT NULL,
  `ENTRYLIST` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHARACTERID` bigint(10) DEFAULT NULL,
  `ATTACHFLAG` varchar(2) DEFAULT NULL,
  `PUBLICFLAG` varchar(2) DEFAULT NULL,
  `APPROVEFLAG` varchar(2) DEFAULT '0',
  `RETURNFLAG` varchar(2) DEFAULT '0',
  `SCHEDULEID` varchar(1000) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`NUM`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rs_schedule_2`
--

DROP TABLE IF EXISTS `tbl_rs_schedule_2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rs_schedule_2` (
  `OWNERID` varchar(40) NOT NULL,
  `NUM` bigint(18) NOT NULL,
  `PNUM` bigint(18) DEFAULT 0,
  `COMPANYID` varchar(40) NOT NULL,
  `WRITERID` varchar(40) DEFAULT NULL,
  `DEPTNM` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OWNERNM` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `LOCATION` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TIMEDISPLAY` varchar(2) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `ALLDAY` varchar(2) DEFAULT NULL,
  `ALERTTIME` varchar(8) DEFAULT NULL,
  `CONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `IMPORTANCE` varchar(2) DEFAULT NULL,
  `REFLAG` varchar(2) DEFAULT NULL,
  `GRESFLAG` varchar(2) DEFAULT NULL,
  `WRITEDAY` datetime DEFAULT NULL,
  `ENTRYLIST` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHARACTERID` bigint(10) DEFAULT NULL,
  `ATTACHFLAG` varchar(2) DEFAULT NULL,
  `PUBLICFLAG` varchar(2) DEFAULT NULL,
  `APPROVEFLAG` varchar(2) DEFAULT '0',
  `SCHEDULEID` varchar(1000) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`NUM`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rs_scheduleform`
--

DROP TABLE IF EXISTS `tbl_rs_scheduleform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rs_scheduleform` (
  `RESID` varchar(40) NOT NULL,
  `BRDNM` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMTEXT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`RESID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_rs_schedulerepetition`
--

DROP TABLE IF EXISTS `tbl_rs_schedulerepetition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_rs_schedulerepetition` (
  `OWNERID` varchar(40) NOT NULL,
  `NUM` bigint(18) NOT NULL,
  `COMPANYID` varchar(40) NOT NULL,
  `STARTDATETIME` datetime DEFAULT NULL,
  `ENDDATETIME` datetime DEFAULT NULL,
  `REWAY` varchar(4) DEFAULT NULL,
  `RENUM` varchar(10) DEFAULT NULL,
  `REDAY` varchar(4) DEFAULT NULL,
  `REYOIL` varchar(28) DEFAULT NULL,
  `REMONTH` varchar(4) DEFAULT NULL,
  `REORD` varchar(4) DEFAULT NULL,
  `ENDFLAG` varchar(2) DEFAULT NULL,
  `RECOUNT` varchar(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`NUM`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedule`
--

DROP TABLE IF EXISTS `tbl_schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedule` (
  `SCHEDULEID` bigint(10) NOT NULL AUTO_INCREMENT,
  `PARENTID` bigint(10) NOT NULL,
  `OWNERID` varchar(100) NOT NULL,
  `OWNERNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `OWNERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATORID` varchar(100) NOT NULL,
  `CREATORNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `CREATORNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATEDATE` datetime NOT NULL,
  `MODIFIERID` varchar(100) NOT NULL,
  `MODIFIERNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `MODIFIERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYDATE` datetime NOT NULL,
  `SCHEDULETYPE` mediumint(5) NOT NULL,
  `IMPORTANCE` mediumint(5) NOT NULL,
  `HASATTENDANT` varchar(2) NOT NULL,
  `HASATTACH` varchar(2) NOT NULL,
  `HASCOMMENT` varchar(2) NOT NULL,
  `ISREADONLY` varchar(2) NOT NULL,
  `ISPUBLIC` varchar(2) NOT NULL,
  `DATETYPE` mediumint(5) NOT NULL,
  `STARTDATE` datetime NOT NULL,
  `ENDDATE` datetime NOT NULL,
  `REPETITION` varchar(100) NOT NULL,
  `REPETITIONDELETE` varchar(500) NOT NULL,
  `TITLE` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `LOCATION` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `CONTENTPATH` varchar(500) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `companyid` varchar(40) DEFAULT NULL,
  `googleid` varchar(100) DEFAULT NULL,
  `REPEATEDSCHEDULEOFFSET` double NOT NULL DEFAULT 0,
  PRIMARY KEY (`SCHEDULEID`),
  KEY `IDX_OWNERID` (`OWNERID`),
  KEY `IDX_GOOGLEID` (`googleid`,`TENANT_ID`,`companyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedule_google_partupdate`
--

DROP TABLE IF EXISTS `tbl_schedule_google_partupdate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedule_google_partupdate` (
  `SCHEDULEID` bigint(10) NOT NULL AUTO_INCREMENT,
  `PARENTID` bigint(10) NOT NULL,
  `OWNERID` varchar(100) NOT NULL,
  `OWNERNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `OWNERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATORID` varchar(100) NOT NULL,
  `CREATORNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `CREATORNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATEDATE` datetime NOT NULL,
  `MODIFIERID` varchar(100) NOT NULL,
  `MODIFIERNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `MODIFIERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MODIFYDATE` datetime NOT NULL,
  `SCHEDULETYPE` mediumint(5) NOT NULL,
  `IMPORTANCE` mediumint(5) NOT NULL,
  `HASATTENDANT` varchar(2) NOT NULL,
  `HASATTACH` varchar(2) NOT NULL,
  `HASCOMMENT` varchar(2) NOT NULL,
  `ISREADONLY` varchar(2) NOT NULL,
  `ISPUBLIC` varchar(2) NOT NULL,
  `DATETYPE` mediumint(5) NOT NULL,
  `STARTDATE` datetime NOT NULL,
  `ENDDATE` datetime NOT NULL,
  `REPETITION` varchar(100) NOT NULL,
  `REPETITIONDELETE` varchar(500) NOT NULL,
  `TITLE` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `LOCATION` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `CONTENTPATH` varchar(500) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `companyid` varchar(40) DEFAULT NULL,
  `googleid` varchar(100) DEFAULT NULL,
  `ORIGINALSTARTTIME` datetime DEFAULT NULL,
  `RECURRINGEVENTID` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`SCHEDULEID`),
  UNIQUE KEY `IDX_GOOGLEID` (`googleid`,`TENANT_ID`,`companyid`),
  KEY `IDX_OWNERID` (`OWNERID`),
  KEY `IDX_RECURRINGEVENTID` (`RECURRINGEVENTID`,`TENANT_ID`,`companyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedule_oauthinfo`
--

DROP TABLE IF EXISTS `tbl_schedule_oauthinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedule_oauthinfo` (
  `USERID` varchar(80) NOT NULL,
  `GOOGLEACCESSTOKEN` longtext DEFAULT NULL,
  `GOOGLEREFRESHTOKEN` longtext DEFAULT NULL,
  `GOOGLESYNCTOKEN` longtext DEFAULT NULL,
  `GOOGLESYNCSTART` datetime DEFAULT NULL,
  `GOOGLECREATEDATE` datetime DEFAULT NULL,
  `GOOGLEUPDATEDATE` datetime DEFAULT NULL,
  `OFFICETENANTID` longtext DEFAULT NULL,
  `OFFICEACCESSTOKEN` longtext DEFAULT NULL,
  `OFFICEREFRESHTOKEN` longtext DEFAULT NULL,
  `OFFICECREATEDATE` datetime DEFAULT NULL,
  `OFFICEUPDATEDATE` datetime DEFAULT NULL,
  `COMPANYID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`USERID`,`COMPANYID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedule_public_dept`
--

DROP TABLE IF EXISTS `tbl_schedule_public_dept`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedule_public_dept` (
  `IDX` bigint(10) NOT NULL AUTO_INCREMENT,
  `USERCN` varchar(80) NOT NULL,
  `USERNAME` varchar(120) CHARACTER SET utf8mb4 NOT NULL,
  `USERNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPARTMENTCN` varchar(80) NOT NULL,
  `DEPARTMENTNAME` varchar(120) CHARACTER SET utf8mb4 NOT NULL,
  `DEPARTMENTNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `companyid` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`IDX`),
  UNIQUE KEY `IDX_TBL_SCHEDULE_PUBLIC_DEPT` (`TENANT_ID`,`USERCN`,`DEPARTMENTCN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedule_sync`
--

DROP TABLE IF EXISTS `tbl_schedule_sync`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedule_sync` (
  `sync_num` int(10) NOT NULL AUTO_INCREMENT,
  `cn` varchar(50) NOT NULL,
  `user_type` int(4) NOT NULL,
  `company_id` varchar(50) NOT NULL,
  `google` tinyint(4) NOT NULL,
  `office` tinyint(4) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  PRIMARY KEY (`sync_num`,`cn`,`user_type`,`company_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedule_timezone`
--

DROP TABLE IF EXISTS `tbl_schedule_timezone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedule_timezone` (
  `timezone_id` int(11) NOT NULL AUTO_INCREMENT,
  `timezone_description` varchar(250) NOT NULL,
  `windows_name` varchar(150) NOT NULL,
  `windows_timezone_id` varchar(150) NOT NULL,
  `iana_name` varchar(150) NOT NULL,
  PRIMARY KEY (`timezone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedule_usergroup`
--

DROP TABLE IF EXISTS `tbl_schedule_usergroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedule_usergroup` (
  `groupid` varchar(100) NOT NULL,
  `creatorid` varchar(100) NOT NULL,
  `groupname` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SN` int(11) DEFAULT NULL,
  `tenant_id` int(11) NOT NULL,
  `companyid` varchar(100) NOT NULL,
  `groupflag` int(11) DEFAULT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `createDate` datetime DEFAULT NULL,
  PRIMARY KEY (`groupid`,`tenant_id`,`companyid`,`creatorid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedule_usergroup_member`
--

DROP TABLE IF EXISTS `tbl_schedule_usergroup_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedule_usergroup_member` (
  `groupid` varchar(100) NOT NULL,
  `memberid` varchar(100) NOT NULL,
  `membername` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `tenant_id` int(11) NOT NULL,
  `companyid` varchar(100) NOT NULL,
  `membername2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `memberorder` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`groupid`,`memberid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_scheduleattach`
--

DROP TABLE IF EXISTS `tbl_scheduleattach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_scheduleattach` (
  `ATTACHID` bigint(10) NOT NULL AUTO_INCREMENT,
  `SCHEDULEID` bigint(10) NOT NULL,
  `FILESIZE` bigint(10) NOT NULL,
  `FILENAME` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `FILEPATH` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ATTACHID`),
  UNIQUE KEY `IDX_TBL_SCHEDULEATTACH` (`ATTACHID`,`SCHEDULEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_scheduleconfig`
--

DROP TABLE IF EXISTS `tbl_scheduleconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_scheduleconfig` (
  `USERID` varchar(100) NOT NULL,
  `DEFAULTVIEW` varchar(2) NOT NULL,
  `STARTDAY` varchar(2) NOT NULL,
  `STARTTIME` varchar(8) NOT NULL,
  `ENDTIME` varchar(8) CHARACTER SET utf8mb4 NOT NULL,
  `InvitationMail` varchar(4) DEFAULT 'Y',
  `CancellationMail` varchar(4) DEFAULT 'Y',
  `AttendanceMail` varchar(4) DEFAULT 'Y',
  `RejectedMail` varchar(4) DEFAULT 'Y',
  `AUTODELETE` bigint(10) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`USERID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedulegroup`
--

DROP TABLE IF EXISTS `tbl_schedulegroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedulegroup` (
  `GROUPID` varchar(100) NOT NULL,
  `GROUPNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `CREATORID` varchar(100) DEFAULT NULL,
  `CREATORNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `CREATORNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `companyid` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`GROUPID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedulegroupmember`
--

DROP TABLE IF EXISTS `tbl_schedulegroupmember`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedulegroupmember` (
  `GROUPID` varchar(100) NOT NULL,
  `MEMBERID` varchar(100) NOT NULL,
  `MEMBERNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `MEMBERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `STATUS` mediumint(5) NOT NULL,
  `RESPONSEDATE` datetime NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`GROUPID`,`MEMBERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedulerepetition_del`
--

DROP TABLE IF EXISTS `tbl_schedulerepetition_del`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedulerepetition_del` (
  `REPETITIONID` bigint(10) NOT NULL AUTO_INCREMENT,
  `SCHEDULEID` longtext DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `TENANT_ID` mediumint(5) DEFAULT NULL,
  `companyid` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`REPETITIONID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schistory_cab`
--

DROP TABLE IF EXISTS `tbl_schistory_cab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schistory_cab` (
  `VERSION` bigint(10) NOT NULL,
  `CABINETCLASSNO` varchar(100) NOT NULL,
  `SERIALNO` varchar(12) NOT NULL,
  `SC1` varchar(200) DEFAULT NULL,
  `SC2` varchar(200) DEFAULT NULL,
  `SC3` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`VERSION`,`CABINETCLASSNO`,`SERIALNO`),
  CONSTRAINT `FK_TBL_SCHISTORY_CAB` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `VERSION`, `CABINETCLASSNO`) REFERENCES `tbl_cabinethistory` (`TENANT_ID`, `COMPANYID`, `VERSION`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schistory_rec`
--

DROP TABLE IF EXISTS `tbl_schistory_rec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schistory_rec` (
  `RECORDID` varchar(68) NOT NULL,
  `SEPERATEATTACHNO` varchar(8) NOT NULL,
  `VERSION` bigint(10) NOT NULL,
  `SERIALNO` varchar(12) NOT NULL,
  `SC1` varchar(200) DEFAULT NULL,
  `SC2` varchar(200) DEFAULT NULL,
  `SC3` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECORDID`,`SEPERATEATTACHNO`,`VERSION`,`SERIALNO`),
  CONSTRAINT `FK_TBL_SCHISTORY_REC` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `RECORDID`, `SEPERATEATTACHNO`, `VERSION`) REFERENCES `tbl_recordhistory` (`TENANT_ID`, `COMPANYID`, `RECORDID`, `SEPERATEATTACHNO`, `VERSION`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_sealdeptinfo`
--

DROP TABLE IF EXISTS `tbl_sealdeptinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_sealdeptinfo` (
  `SEALNUM` bigint(10) NOT NULL,
  `DEPTID` varchar(255) NOT NULL,
  `SEALNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SEALPATH` varchar(1020) DEFAULT NULL,
  `SEALWIDTH` double(126,0) DEFAULT NULL,
  `SEALHEIGHT` double(126,0) DEFAULT NULL,
  `REGDATE` datetime DEFAULT NULL,
  `DELDATE` datetime DEFAULT NULL,
  `REGUSERID` varchar(400) DEFAULT NULL,
  `REGUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `REGUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`SEALNUM`,`DEPTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_sealinfo`
--

DROP TABLE IF EXISTS `tbl_sealinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_sealinfo` (
  `SEALNUM` bigint(10) NOT NULL,
  `SEALNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SEALPATH` varchar(1020) DEFAULT NULL,
  `SEALWIDTH` double(126,0) DEFAULT NULL,
  `SEALHEIGHT` double(126,0) DEFAULT NULL,
  `REGDATE` datetime DEFAULT NULL,
  `DELDATE` datetime DEFAULT NULL,
  `REGUSERID` varchar(400) DEFAULT NULL,
  `REGUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `REGUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`SEALNUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_secretary`
--

DROP TABLE IF EXISTS `tbl_secretary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_secretary` (
  `USERID` varchar(100) NOT NULL,
  `USERNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `USERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SECRETARYID` varchar(100) NOT NULL,
  `SECRETARYNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `SECRETARYNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `companyid` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`,`SECRETARYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_seperateattach`
--

DROP TABLE IF EXISTS `tbl_seperateattach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_seperateattach` (
  `RECORDID` varchar(68) NOT NULL,
  `SEPERATEATTACHNO` varchar(8) NOT NULL,
  `TITLE` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `REGISTERTYPE` varchar(4) DEFAULT NULL,
  `NUMOFPAGE` varchar(12) DEFAULT NULL,
  `DELFLAG` varchar(72) DEFAULT NULL,
  `MODIFYFLAG` varchar(4) DEFAULT NULL,
  `DELETEDATE` datetime DEFAULT NULL,
  `CABINETID` varchar(112) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `CATALOGTRANSFERYEAR` bigint(10) DEFAULT NULL,
  `DOCTRANSFERYEAR` bigint(10) DEFAULT NULL,
  `CONFIRMFLAG` varchar(4) DEFAULT NULL,
  `CATALOGTRANSFERFLAG` varchar(4) DEFAULT NULL,
  `DOCTRANSFERFLAG` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECORDID`,`SEPERATEATTACHNO`),
  KEY `FK_TBL_SEPERATEATTACH_idx` (`TENANT_ID`,`COMPANYID`,`CABINETID`),
  CONSTRAINT `FK_TBL_SEPERATEATTACH` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `CABINETID`) REFERENCES `tbl_cabinet` (`TENANT_ID`, `COMPANYID`, `CABINETID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_seperateattach_temp`
--

DROP TABLE IF EXISTS `tbl_seperateattach_temp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_seperateattach_temp` (
  `DOCID` char(20) NOT NULL,
  `RECORDID` varchar(68) DEFAULT NULL,
  `SEPERATEATTACHNO` varchar(8) NOT NULL,
  `TITLE` varchar(1020) DEFAULT NULL,
  `REGISTERTYPE` varchar(4) DEFAULT NULL,
  `NUMOFPAGE` varchar(12) DEFAULT NULL,
  `DELFLAG` varchar(72) DEFAULT NULL,
  `MODIFYFLAG` varchar(4) DEFAULT NULL,
  `DELETEDATE` datetime DEFAULT NULL,
  `CABINETID` varchar(112) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `CATALOGTRANSFERYEAR` bigint(10) DEFAULT NULL,
  `DOCTRANSFERYEAR` bigint(10) DEFAULT NULL,
  `CONFIRMFLAG` varchar(4) DEFAULT NULL,
  `CATALOGTRANSFERFLAG` varchar(4) DEFAULT NULL,
  `DOCTRANSFERFLAG` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`DOCID`,`TENANT_ID`,`COMPANYID`,`SEPERATEATTACHNO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_serialnumgen`
--

DROP TABLE IF EXISTS `tbl_serialnumgen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_serialnumgen` (
  `TYPE1` varchar(200) DEFAULT NULL,
  `TYPE3` varchar(200) DEFAULT NULL,
  `ROLLBACKFLAG` mediumint(5) NOT NULL,
  `TYPE2` varchar(200) DEFAULT NULL,
  `TIMESEP` bigint(10) DEFAULT NULL,
  `REGSERIALNO` decimal(19,0) NOT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) DEFAULT NULL,
  `IDX` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`IDX`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_signinfo`
--

DROP TABLE IF EXISTS `tbl_signinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_signinfo` (
  `DOCID` varchar(80) NOT NULL,
  `APRSN` bigint(10) NOT NULL,
  `SIGNTYPE` varchar(40) DEFAULT NULL,
  `SIGNNAME` varchar(400) NOT NULL,
  `CONTENT` varchar(1020) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DOCID`,`APRSN`,`SIGNNAME`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_skin_general`
--

DROP TABLE IF EXISTS `tbl_skin_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_skin_general` (
  `SKINNUM` bigint(10) NOT NULL,
  `SKINNAME` varchar(200) DEFAULT NULL,
  `SKINBGFLAG` varchar(20) DEFAULT NULL,
  `SKINBGCOLOR` varchar(100) DEFAULT NULL,
  `SKINBGIMAGE` varchar(100) DEFAULT NULL,
  `SKINFONTCOLOR` varchar(100) DEFAULT NULL,
  `SKINFONTOVERCOLOR` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`SKINNUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_skin_items`
--

DROP TABLE IF EXISTS `tbl_skin_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_skin_items` (
  `UID_` varchar(100) NOT NULL,
  `SKINNUM` bigint(10) NOT NULL,
  `SKINNAME` varchar(200) DEFAULT NULL,
  `SKINNAME2` varchar(200) DEFAULT NULL,
  `SKINBGFLAG` varchar(20) DEFAULT NULL,
  `SKINBGCOLOR` varchar(100) DEFAULT NULL,
  `SKINBGIMAGE` varchar(500) DEFAULT NULL,
  `SKINFONTCOLOR` varchar(100) DEFAULT NULL,
  `SKINFONTOVERCOLOR` varchar(100) DEFAULT NULL,
  `SKINDEFAULTIMAGE` varchar(500) DEFAULT NULL,
  `SKINDEFAULTCOLOR` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`SKINNUM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_specialcataloginfo_cab`
--

DROP TABLE IF EXISTS `tbl_specialcataloginfo_cab`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_specialcataloginfo_cab` (
  `CABINETCLASSNO` varchar(100) NOT NULL,
  `SERIALNO` varchar(12) NOT NULL,
  `SC2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SC3` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SC1` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CABINETCLASSNO`,`SERIALNO`),
  CONSTRAINT `FK_TBL_SPECIALCATALOGINFO_CAB` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `COMPANYID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_specialcataloginfo_rec`
--

DROP TABLE IF EXISTS `tbl_specialcataloginfo_rec`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_specialcataloginfo_rec` (
  `RECORDID` varchar(68) NOT NULL,
  `SERIALNO` varchar(12) NOT NULL,
  `SC2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SC3` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SC1` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`RECORDID`,`SERIALNO`),
  CONSTRAINT `FK_TBL_SPECIALCATALOGINFO_REC` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `RECORDID`) REFERENCES `tbl_record` (`TENANT_ID`, `COMPANYID`, `RECORDID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_specialcataloginfo_tmp`
--

DROP TABLE IF EXISTS `tbl_specialcataloginfo_tmp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_specialcataloginfo_tmp` (
  `DOCID` char(20) NOT NULL,
  `RECORDID` varchar(68) NOT NULL,
  `SERIALNO` varchar(12) NOT NULL,
  `SC1` varchar(200) DEFAULT NULL,
  `SC2` varchar(200) DEFAULT NULL,
  `SC3` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`DOCID`,`RECORDID`,`SERIALNO`,`TENANT_ID`,`COMPANYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_specialcontainerinfo`
--

DROP TABLE IF EXISTS `tbl_specialcontainerinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_specialcontainerinfo` (
  `DEPTID` varchar(100) NOT NULL,
  `CONTTYPE` varchar(12) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `CONTNAME` varchar(510) DEFAULT NULL,
  `SUBQUERY` varchar(1000) DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`DEPTID`,`CONTTYPE`,`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_submit_queue`
--

DROP TABLE IF EXISTS `tbl_submit_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_submit_queue` (
  `CMP_MSG_ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `CMP_MSG_GROUP_ID` varchar(20) DEFAULT NULL,
  `USR_ID` varchar(16) NOT NULL,
  `SMS_GB` char(1) DEFAULT '1',
  `USED_CD` char(2) NOT NULL,
  `RESERVED_FG` char(1) NOT NULL,
  `RESERVED_DTTM` char(14) NOT NULL,
  `SAVED_FG` char(1) DEFAULT '0',
  `RCV_PHN_ID` varchar(24) NOT NULL,
  `SND_PHN_ID` varchar(24) DEFAULT NULL,
  `NAT_CD` varchar(8) DEFAULT NULL,
  `ASSIGN_CD` varchar(5) DEFAULT '00000',
  `SND_MSG` varchar(2000) DEFAULT NULL,
  `CALLBACK_URL` varchar(120) DEFAULT NULL,
  `CONTENT_CNT` int(11) DEFAULT 0,
  `CONTENT_MIME_TYPE` varchar(128) DEFAULT NULL,
  `CONTENT_PATH` varchar(1024) DEFAULT NULL,
  `CMP_SND_DTTM` char(14) DEFAULT NULL,
  `CMP_RCV_DTTM` char(14) DEFAULT NULL,
  `REG_SND_DTTM` char(14) DEFAULT NULL,
  `REG_RCV_DTTM` char(14) DEFAULT NULL,
  `MACHINE_ID` char(2) DEFAULT NULL,
  `SMS_STATUS` char(1) DEFAULT '0',
  `RSLT_VAL` char(5) DEFAULT NULL,
  `MSG_TITLE` varchar(200) DEFAULT NULL,
  `TELCO_ID` char(4) DEFAULT NULL,
  `ASP_ID` varchar(32) DEFAULT NULL,
  `DCS` int(11) DEFAULT 0,
  PRIMARY KEY (`CMP_MSG_ID`),
  KEY `IDX_SUBMIT_QUEUE_1` (`SMS_STATUS`,`RESERVED_FG`),
  KEY `IDX_SUBMIT_QUEUE_2` (`CMP_MSG_ID`,`SMS_STATUS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_survey`
--

DROP TABLE IF EXISTS `tbl_survey`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_survey` (
  `survey_id` bigint(20) NOT NULL COMMENT '설문 아이디',
  `title` mediumtext NOT NULL COMMENT '설문 제목',
  `purpose` longtext NOT NULL COMMENT '설문 목적',
  `user_id` varchar(50) NOT NULL COMMENT '작성자 아이디',
  `create_date` datetime NOT NULL COMMENT '작성일',
  `start_date` datetime NOT NULL COMMENT '설문 시작 일시',
  `end_date` datetime NOT NULL COMMENT '설문 마감 일시',
  `user_name1` varchar(150) NOT NULL COMMENT '작성자 이름(한글)',
  `user_name2` varchar(150) NOT NULL COMMENT '작성자 이름(영어)',
  `use_status` int(11) DEFAULT 0 COMMENT '설문 사용 상태',
  `open_days` int(11) NOT NULL COMMENT '공개일',
  `result_public_flag` tinyint(4) DEFAULT 0 COMMENT '결과 공개 여부',
  `anonymous_flag` tinyint(4) DEFAULT 0 COMMENT '익명 여부',
  `multi_answer_flag` tinyint(4) DEFAULT 0 COMMENT '중복 응답 가능 여부',
  `participate_flag` tinyint(4) DEFAULT 0 COMMENT '대상자 선택 여부',
  `attach_flag` tinyint(4) DEFAULT 0 COMMENT '첨부 파일 유무 여부',
  `modify_flag` tinyint(4) DEFAULT 0 COMMENT '수정 여부',
  `draft_flag` tinyint(4) DEFAULT 0 COMMENT '임시 저장 여부',
  `response_flag` tinyint(4) DEFAULT 0 COMMENT '응답 유무',
  `delete_user` varchar(50) DEFAULT NULL COMMENT '삭제한 유저 아이디',
  `update_user` varchar(50) DEFAULT NULL COMMENT '수정한 유저 아이디',
  `update_date` datetime DEFAULT NULL COMMENT '수정한 날짜',
  `total_user` int(20) NOT NULL DEFAULT 0 COMMENT '설문 대상자 수',
  `company_id` varchar(80) NOT NULL COMMENT '컴퍼니 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`survey_id`,`tenant_id`,`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_survey_attachfile`
--

DROP TABLE IF EXISTS `tbl_survey_attachfile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_survey_attachfile` (
  `att_file_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '첨부파일 아이디',
  `survey_id` bigint(20) NOT NULL COMMENT '설문 아이디',
  `target_id` bigint(20) NOT NULL COMMENT '타겟(설문 or 질문 or 보기) 아이디',
  `target_type` varchar(50) NOT NULL COMMENT '타겟 타입(설문 or 질문 or 보기)',
  `file_nm` varchar(256) NOT NULL COMMENT '파일 이름',
  `file_size` bigint(20) DEFAULT 0 COMMENT '파일 사이즈',
  `file_path` varchar(256) DEFAULT NULL COMMENT '파일 경로',
  `file_url` varchar(256) DEFAULT NULL COMMENT '첨부 URL',
  `company_id` varchar(80) NOT NULL COMMENT '컴퍼니 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`att_file_id`,`tenant_id`,`company_id`),
  KEY `attachIdx1` (`target_id`,`target_type`),
  KEY `FK_SURVEY_ATTACHFILE_idx` (`survey_id`),
  CONSTRAINT `FK_SURVEY_ATTACHFILE` FOREIGN KEY (`survey_id`) REFERENCES `tbl_survey` (`survey_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_survey_config`
--

DROP TABLE IF EXISTS `tbl_survey_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_survey_config` (
  `user_id` varchar(50) NOT NULL COMMENT '작성자 아이디',
  `list_count` int(11) DEFAULT NULL COMMENT '리스트 개수',
  `preview_flag` varchar(10) DEFAULT NULL COMMENT '미리보기 설정값',
  `list_h_percent` int(11) DEFAULT NULL COMMENT '미리보기 높이 퍼센트',
  `list_w_percent` int(11) DEFAULT NULL COMMENT '미리보기 넓이 퍼센트',
  `company_id` varchar(80) NOT NULL COMMENT '컴퍼니 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`user_id`,`tenant_id`,`company_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_survey_option`
--

DROP TABLE IF EXISTS `tbl_survey_option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_survey_option` (
  `option_id` bigint(20) NOT NULL COMMENT '보기 아이디',
  `survey_id` bigint(20) NOT NULL COMMENT '설문 아이디',
  `question_id` bigint(20) NOT NULL COMMENT '질문 아이디',
  `question_type` tinyint(4) NOT NULL COMMENT '질문 타입',
  `question_level` bigint(20) NOT NULL COMMENT '질문 순서',
  `content` varchar(250) DEFAULT NULL COMMENT '보기 내용',
  `levels` int(11) NOT NULL COMMENT '순서',
  `other_flag` tinyint(4) DEFAULT 0 COMMENT '기타 여부',
  `logic_num` int(11) DEFAULT -1 COMMENT '분기 번호',
  `row_level` int(11) DEFAULT NULL COMMENT '행 순서',
  `column_level` int(11) DEFAULT NULL COMMENT '컬럼 순서',
  `company_id` varchar(80) NOT NULL COMMENT '컴퍼니 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`option_id`,`company_id`,`tenant_id`),
  KEY `FK_SURVEY_OPTION_SURVEY_idx` (`survey_id`),
  KEY `FK_SURVEY_OPTION_QUEESTION_idx` (`question_id`),
  CONSTRAINT `FK_SURVEY_OPTION_QUEESTION` FOREIGN KEY (`question_id`) REFERENCES `tbl_survey_question` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_SURVEY_OPTION_SURVEY` FOREIGN KEY (`survey_id`) REFERENCES `tbl_survey` (`survey_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_survey_participant`
--

DROP TABLE IF EXISTS `tbl_survey_participant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_survey_participant` (
  `participant_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '설문 참여자 아이디',
  `survey_id` bigint(20) NOT NULL COMMENT '설문 아이디',
  `user_type` varchar(50) NOT NULL COMMENT '참여자 타입',
  `user_id` varchar(50) NOT NULL COMMENT '참여자 아이디',
  `user_name1` varchar(80) DEFAULT NULL COMMENT '참여자 이름(한글)',
  `user_name2` varchar(80) DEFAULT NULL COMMENT '참여자 이름(영문)',
  `email` varchar(150) DEFAULT NULL COMMENT '참여자 이메일',
  `dept_id` varchar(80) DEFAULT NULL COMMENT '참여자 부서 아이디',
  `dept_name1` varchar(80) DEFAULT NULL COMMENT '부서 이름(한글)',
  `dept_name2` varchar(80) DEFAULT NULL COMMENT '부서 이름(영문)',
  `company_id` varchar(80) NOT NULL COMMENT '컴퍼니 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`participant_id`,`company_id`,`tenant_id`),
  UNIQUE KEY `participantIdx1` (`survey_id`,`user_type`,`user_id`,`company_id`,`tenant_id`),
  CONSTRAINT `FK_SURVEY_PARTICIPANT` FOREIGN KEY (`survey_id`) REFERENCES `tbl_survey` (`survey_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_survey_question`
--

DROP TABLE IF EXISTS `tbl_survey_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_survey_question` (
  `question_id` bigint(20) NOT NULL COMMENT '질문 아이디',
  `survey_id` bigint(20) NOT NULL COMMENT '설문 아이디',
  `question_type` tinyint(4) NOT NULL COMMENT '질문 타입',
  `title` varchar(250) NOT NULL COMMENT '질문 내용',
  `levels` int(11) NOT NULL COMMENT '순서',
  `use_status` tinyint(4) DEFAULT 0 COMMENT '사용 상태',
  `required_flag` tinyint(4) DEFAULT 0 COMMENT '필수 답변 여부',
  `logic_flag` tinyint(4) DEFAULT 0 COMMENT '분기 설정 여부',
  `slider_logic_point` bigint(20) DEFAULT -1 COMMENT '슬라이드 질문의 분기 실행 기준',
  `skip_flag` tinyint(4) DEFAULT 0 COMMENT '다음 질문 번호 설정 여부',
  `skip_num` int(11) DEFAULT -1 COMMENT '다음 질문 번호',
  `unit` bigint(20) DEFAULT -1 COMMENT '슬라이드 질문의 단위',
  `company_id` varchar(80) NOT NULL COMMENT '컴퍼니 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`question_id`,`company_id`,`tenant_id`),
  KEY `FK_SURVEY_QUESTION_idx` (`survey_id`),
  CONSTRAINT `FK_SURVEY_QUESTION` FOREIGN KEY (`survey_id`) REFERENCES `tbl_survey` (`survey_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_survey_respondent`
--

DROP TABLE IF EXISTS `tbl_survey_respondent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_survey_respondent` (
  `response_id` bigint(20) NOT NULL COMMENT '응답 아이디',
  `survey_id` bigint(20) NOT NULL COMMENT '설문 아이디',
  `user_id` varchar(50) NOT NULL COMMENT '응답자 아이디',
  `user_name1` varchar(80) NOT NULL COMMENT '이름(한글)',
  `user_name2` varchar(80) NOT NULL COMMENT '이름(영어)',
  `email` varchar(150) NOT NULL COMMENT '이메일',
  `image` varchar(150) DEFAULT NULL COMMENT '이미지',
  `dept_id` varchar(80) NOT NULL COMMENT '부서 아이디',
  `dept_name1` varchar(80) NOT NULL COMMENT '부서 이름(한글)',
  `dept_name2` varchar(80) NOT NULL COMMENT '부서 이름(영어)',
  `response_date` datetime NOT NULL COMMENT '응답일',
  `company_id` varchar(80) NOT NULL COMMENT '컴퍼니 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`company_id`,`tenant_id`,`response_id`),
  KEY `FK_SURVEY_RESPONDENT_idx` (`survey_id`),
  KEY `FK_SURVEY_RESPONDENT_RESPONSE_idx` (`response_id`),
  CONSTRAINT `FK_SURVEY_RESPONDENT_RESPONSE` FOREIGN KEY (`response_id`) REFERENCES `tbl_survey_response` (`response_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SURVEY_RESPONDENT_SURVEY` FOREIGN KEY (`survey_id`) REFERENCES `tbl_survey` (`survey_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_survey_response`
--

DROP TABLE IF EXISTS `tbl_survey_response`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_survey_response` (
  `response_id` bigint(20) NOT NULL COMMENT '응답 아이디',
  `survey_id` bigint(20) NOT NULL COMMENT '설문 아이디',
  `question_level` bigint(20) NOT NULL COMMENT '질문 순서',
  `question_type` tinyint(4) NOT NULL COMMENT '질문 타입',
  `user_id` varchar(50) NOT NULL COMMENT '응답자 아이디',
  `option_id` bigint(20) NOT NULL DEFAULT -1 COMMENT '보기 아이디',
  `texts` mediumtext DEFAULT NULL COMMENT '텍스트 답변',
  `row_id` int(11) DEFAULT -1 COMMENT '행 아이디',
  `column_id` int(11) DEFAULT -1 COMMENT '열 아이디',
  `ranking_level` int(11) DEFAULT -1 COMMENT '순위 질문의 보기 번호',
  `slider_value` int(11) DEFAULT -1 COMMENT '슬라이더 질문의 답변값',
  `company_id` varchar(80) NOT NULL COMMENT '컴퍼니 아이디',
  `tenant_id` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`response_id`,`company_id`,`tenant_id`),
  KEY `FK_SURVEY_RESPONSE_idx` (`survey_id`),
  CONSTRAINT `FK_SURVEY_RESPONSE` FOREIGN KEY (`survey_id`) REFERENCES `tbl_survey` (`survey_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_table`
--

DROP TABLE IF EXISTS `tbl_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_table` (
  `TBL_ID` varchar(200) DEFAULT NULL,
  `TBL_NM` varchar(200) DEFAULT NULL,
  `TBL_DESCRPT` varchar(200) DEFAULT NULL,
  `CREATE_DT` datetime DEFAULT NULL,
  `UPDATE_DT` datetime DEFAULT NULL,
  `USE_YN` char(1) DEFAULT 'Y'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_task`
--

DROP TABLE IF EXISTS `tbl_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_task` (
  `TASKID` bigint(10) NOT NULL AUTO_INCREMENT,
  `CREATORID` varchar(100) DEFAULT NULL,
  `CREATORNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATORNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATORDEPTNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATORDEPTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATOREMAIL` varchar(100) DEFAULT NULL,
  `CREATEDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TASKSTATUS` mediumint(5) DEFAULT NULL,
  `COMPLETERATE` mediumint(5) DEFAULT NULL,
  `IMPORTANCE` mediumint(5) DEFAULT NULL,
  `HASSHARE` varchar(2) DEFAULT NULL,
  `HASATTACH` varchar(2) DEFAULT NULL,
  `HASCOMMENT` varchar(2) DEFAULT NULL,
  `STARTDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ENDDATE` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CONTENTPATH` varchar(500) DEFAULT NULL,
  `TASKTYPE` mediumint(5) DEFAULT NULL,
  `UPDATETIME` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PERSONID` varchar(100) DEFAULT NULL,
  `PERSONNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PERSONNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PERSONDEPTNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PERSONDEPTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PERSONEMAIL` varchar(100) DEFAULT NULL,
  `PERSONATTACH` varchar(2) DEFAULT NULL,
  `PERSONCONTENTPATH` varchar(500) DEFAULT NULL,
  `MEMO` varchar(500) CHARACTER SET utf8mb4 DEFAULT NULL,
  `REPETITION` varchar(100) DEFAULT NULL,
  `TOTALREP` mediumint(9) NOT NULL DEFAULT 0,
  `TENANTID` mediumint(5) NOT NULL,
  `companyid` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`TASKID`,`TENANTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_task_deptinfo`
--

DROP TABLE IF EXISTS `tbl_task_deptinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_task_deptinfo` (
  `CREATEDATE` datetime DEFAULT NULL,
  `DESCRIPTION` varchar(600) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TASKTRANSFERFLAG` varchar(4) DEFAULT NULL,
  `TDEPTCODE` varchar(28) DEFAULT NULL,
  `PROCESSDEPTCODE` varchar(40) NOT NULL,
  `PROCESSDATE` varchar(48) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APPLYDATE` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TASKCODE` varchar(32) NOT NULL,
  `DELFLAG` varchar(4) DEFAULT '(0)',
  `DELETEDATE` datetime DEFAULT NULL,
  `ORGANCODE` varchar(28) DEFAULT NULL,
  `PROCESSDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`PROCESSDEPTCODE`,`TASKCODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskattach`
--

DROP TABLE IF EXISTS `tbl_taskattach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskattach` (
  `ATTACHID` bigint(10) NOT NULL AUTO_INCREMENT,
  `TASKID` bigint(10) NOT NULL,
  `FILESIZE` bigint(10) NOT NULL,
  `FILENAME` varchar(500) CHARACTER SET utf8mb4 NOT NULL,
  `FILEPATH` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `TYPE` varchar(2) DEFAULT NULL,
  `TENANTID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ATTACHID`,`TENANTID`,`TASKID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskcategory`
--

DROP TABLE IF EXISTS `tbl_taskcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskcategory` (
  `CATEGORYCODE` varchar(32) NOT NULL,
  `NAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OLDFLAG` varchar(4) DEFAULT NULL,
  `NAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`CATEGORYCODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskcode`
--

DROP TABLE IF EXISTS `tbl_taskcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskcode` (
  `TASKCODE` varchar(32) NOT NULL,
  `TASKNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `KEEPINGPERIOD` varchar(8) DEFAULT NULL,
  `CREATIONDATE` datetime DEFAULT NULL,
  `KPREASON` varchar(1000) DEFAULT NULL,
  `KEEPINGMETHOD` varchar(4) DEFAULT NULL,
  `KEEPINGPLACE` varchar(4) DEFAULT NULL,
  `DISPLAYRECFLAG` varchar(4) DEFAULT NULL,
  `DISPLAYRECTRASTIME` varchar(400) DEFAULT NULL,
  `EXDISPLAYFREQUENCY` varchar(4) DEFAULT NULL,
  `SPECIALCATALOGFLAG` varchar(4) DEFAULT NULL,
  `SC1` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SC2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SC3` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYUSAGE` varchar(4) DEFAULT NULL,
  `DESCRIPTION` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TEMPFLAG` varchar(4) DEFAULT NULL,
  `SUBCATEGORYCODE` varchar(32) DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT '0',
  `TASKNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ITEMSECURITY` varchar(4) DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`TASKCODE`),
  KEY `FK_TBL_TASKCODE_idx` (`TENANT_ID`,`COMPANYID`,`SUBCATEGORYCODE`),
  CONSTRAINT `FK_TBL_TASKCODE` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `SUBCATEGORYCODE`) REFERENCES `tbl_tasksubcategory` (`TENANT_ID`, `COMPANYID`, `SUBCATEGORYCODE`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskcodehistory`
--

DROP TABLE IF EXISTS `tbl_taskcodehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskcodehistory` (
  `SN` bigint(10) NOT NULL AUTO_INCREMENT,
  `APPLYDATE` datetime DEFAULT NULL,
  `TASKCODE` varchar(32) DEFAULT NULL,
  `TASKNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHANGEFACTOR` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BEFOREVALUE` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `AFTERVALUE` varchar(1200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CHANGEFACTOR2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TASKNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `AFTERVALUE2` varchar(1200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`SN`),
  UNIQUE KEY `IDX_TBL_TASKCODEHISTORY` (`COMPANYID`,`TENANT_ID`,`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskcomment`
--

DROP TABLE IF EXISTS `tbl_taskcomment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskcomment` (
  `COMMENTID` bigint(10) NOT NULL AUTO_INCREMENT,
  `TASKID` bigint(10) NOT NULL,
  `COMMENTORID` varchar(100) NOT NULL,
  `COMMENTORNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `COMMENTORNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMMENTDATE` datetime NOT NULL,
  `COMMENT` longtext CHARACTER SET utf8mb4 NOT NULL,
  `TENANTID` mediumint(5) NOT NULL,
  PRIMARY KEY (`COMMENTID`,`TASKID`,`TENANTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskconfig`
--

DROP TABLE IF EXISTS `tbl_taskconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskconfig` (
  `USERID` varchar(100) NOT NULL,
  `DELAYCOLOR` varchar(12) NOT NULL,
  `COMPLETECOLOR` varchar(12) NOT NULL,
  `ORIGINCOLOR` varchar(12) NOT NULL,
  `ORIGINCOLOR2` varchar(12) NOT NULL,
  `TENANTID` mediumint(5) NOT NULL,
  PRIMARY KEY (`USERID`,`TENANTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskgeneral`
--

DROP TABLE IF EXISTS `tbl_taskgeneral`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskgeneral` (
  `USERID` varchar(100) NOT NULL,
  `LISTCOUNT` bigint(10) NOT NULL,
  `SELECTTASKSTATUS` varchar(12) NOT NULL,
  `TENANTID` mediumint(5) NOT NULL,
  PRIMARY KEY (`USERID`,`TENANTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskinstancestatus`
--

DROP TABLE IF EXISTS `tbl_taskinstancestatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskinstancestatus` (
  `TASKID` bigint(10) NOT NULL,
  `REPEATCOUNT` bigint(10) NOT NULL,
  `TASKSTATUS` mediumint(5) NOT NULL,
  `COMPLETERATE` mediumint(5) NOT NULL,
  `STARTDATE` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
  `ENDDATE` varchar(40) CHARACTER SET utf8mb4 NOT NULL,
  `TENANTID` mediumint(5) NOT NULL,
  `DELETESTATUS` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TASKID`,`TENANTID`,`STARTDATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskmiddlecategory`
--

DROP TABLE IF EXISTS `tbl_taskmiddlecategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskmiddlecategory` (
  `MCATEGORYCODE` varchar(32) NOT NULL,
  `NAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CATEGORYCODE` varchar(32) DEFAULT NULL,
  `OLDFLAG` varchar(4) DEFAULT NULL,
  `NAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`MCATEGORYCODE`),
  KEY `FK_TBL_TASKMIDDLECATEGORY_idx` (`TENANT_ID`,`COMPANYID`,`CATEGORYCODE`),
  CONSTRAINT `FK_TBL_TASKMIDDLECATEGORY` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `CATEGORYCODE`) REFERENCES `tbl_taskcategory` (`TENANT_ID`, `COMPANYID`, `CATEGORYCODE`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskrequest`
--

DROP TABLE IF EXISTS `tbl_taskrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskrequest` (
  `REQUESTID` bigint(10) NOT NULL,
  `REQUESTDATE` datetime DEFAULT NULL,
  `APPLYDATE` varchar(32) CHARACTER SET utf8mb4 DEFAULT NULL,
  `REQUESTFLAG` varchar(4) NOT NULL,
  `PROCESSFLAG` bigint(10) DEFAULT NULL,
  `ORGANCODE` varchar(28) NOT NULL,
  `DEPTCODE` varchar(28) NOT NULL,
  `TASKCODE` varchar(32) DEFAULT NULL,
  `TASKNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `FILENAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ERRMSG` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`REQUESTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_taskshare`
--

DROP TABLE IF EXISTS `tbl_taskshare`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_taskshare` (
  `TASKID` bigint(10) NOT NULL,
  `SHARERID` varchar(100) NOT NULL,
  `SHARERNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `SHARERNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SHARERDEPTNAME` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `SHARERDEPTNAME2` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `SHAREREMAIL` varchar(100) NOT NULL,
  `UPDATETIME` datetime DEFAULT NULL,
  `TENANTID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TASKID`,`SHARERID`,`TENANTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tasksubcategory`
--

DROP TABLE IF EXISTS `tbl_tasksubcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tasksubcategory` (
  `SUBCATEGORYCODE` varchar(32) NOT NULL,
  `NAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MCATEGORYCODE` varchar(32) DEFAULT NULL,
  `OLDFLAG` varchar(4) DEFAULT NULL,
  `NAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`SUBCATEGORYCODE`),
  KEY `FK_TBL_TASKSUBCATEGORY_idx` (`TENANT_ID`,`COMPANYID`,`MCATEGORYCODE`),
  CONSTRAINT `FK_TBL_TASKSUBCATEGORY` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `MCATEGORYCODE`) REFERENCES `tbl_taskmiddlecategory` (`TENANT_ID`, `COMPANYID`, `MCATEGORYCODE`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_temppassword`
--

DROP TABLE IF EXISTS `tbl_temppassword`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_temppassword` (
  `USERID` varchar(200) NOT NULL,
  `PHONENUM` varchar(200) NOT NULL,
  `IP` varchar(100) NOT NULL,
  `SMSCODE` varchar(100) NOT NULL,
  `CREATEDDATE` datetime NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tenant`
--

DROP TABLE IF EXISTS `tbl_tenant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tenant` (
  `TENANT_ID` mediumint(5) NOT NULL,
  `TENANT_NAME` varchar(200) NOT NULL,
  `TENANT_NAME2` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tenant_config`
--

DROP TABLE IF EXISTS `tbl_tenant_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tenant_config` (
  `TENANT_ID` mediumint(5) NOT NULL,
  `PROPERTY_NAME` varchar(400) NOT NULL,
  `PROPERTY_VALUE` varchar(2000) NOT NULL,
  `DESCRIPTION` varchar(1000) DEFAULT NULL,
  `CONFIG_NAME` varchar(400) DEFAULT NULL,
  `REGDATE` datetime DEFAULT NULL,
  `CONFIG_TYPE` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`PROPERTY_NAME`(255)),
  CONSTRAINT `FK_TBLTENANT_CONFIG_TENANT_ID` FOREIGN KEY (`TENANT_ID`) REFERENCES `tbl_tenant` (`TENANT_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tenant_servername`
--

DROP TABLE IF EXISTS `tbl_tenant_servername`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tenant_servername` (
  `SERVER_NAME` varchar(400) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`SERVER_NAME`(255)),
  KEY `FK_TBL_TENANT_SERVERNAME_idx` (`TENANT_ID`),
  CONSTRAINT `FK_TBL_TENANT_SERVERNAME` FOREIGN KEY (`TENANT_ID`) REFERENCES `tbl_tenant` (`TENANT_ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_theme_general`
--

DROP TABLE IF EXISTS `tbl_theme_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_theme_general` (
  `UID_` varchar(76) NOT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYNAME3` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYNAME4` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `IMAGEURL` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TOPURL` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MAINURL` varchar(1000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANAYID` varchar(100) NOT NULL,
  `CREATORID` varchar(100) DEFAULT NULL,
  `CREATORNM` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `TOPHEIGHT` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`COMPANAYID`,`UID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tmpaprdocattachinfo`
--

DROP TABLE IF EXISTS `tbl_tmpaprdocattachinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tmpaprdocattachinfo` (
  `OWNERID` varchar(255) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `ATTACHSN` bigint(10) NOT NULL,
  `ATTACHDOCNAME` varchar(1020) CHARACTER SET utf8mb4 NOT NULL,
  `ATTACHDOCURL` varchar(1020) NOT NULL,
  `SUBATTACHYN` varchar(4) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`OWNERID`,`SN`,`ATTACHSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tmpaprdocinfo`
--

DROP TABLE IF EXISTS `tbl_tmpaprdocinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tmpaprdocinfo` (
  `OWNERID` varchar(255) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `FORMID` varchar(40) DEFAULT NULL,
  `ORGDOCID` varchar(80) DEFAULT NULL,
  `DOCTYPE` varchar(12) DEFAULT NULL,
  `DOCSTATE` varchar(12) DEFAULT NULL,
  `FUNCTIONTYPE` varchar(12) DEFAULT NULL,
  `HREF` varchar(400) DEFAULT NULL,
  `DOCTITLE` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DOCNO` varchar(200) DEFAULT NULL,
  `HASATTACHYN` varchar(4) DEFAULT NULL,
  `HASOPINIONYN` varchar(4) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) DEFAULT NULL,
  `WRITERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTID` varchar(400) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL,
  `WRITERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`OWNERID`,`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tmpaprlineinfo`
--

DROP TABLE IF EXISTS `tbl_tmpaprlineinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tmpaprlineinfo` (
  `OWNERID` varchar(255) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `APRTYPE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERISDEPTYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(400) DEFAULT NULL,
  `RECEIVEDDATE` datetime DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `REASONDONOTAPPROV` varchar(1020) DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`OWNERID`,`SN`,`APRMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tmpapropinioninfo`
--

DROP TABLE IF EXISTS `tbl_tmpapropinioninfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tmpapropinioninfo` (
  `OWNERID` varchar(255) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `USERID` varchar(100) NOT NULL,
  `OPINIONGB` varchar(12) DEFAULT NULL,
  `CONTENT` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTID` varchar(400) DEFAULT NULL,
  `USERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `OPINIONSN` bigint(10) NOT NULL,
  `USERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `USERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`OWNERID`,`SN`,`USERID`,`OPINIONSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tmpattachinfo`
--

DROP TABLE IF EXISTS `tbl_tmpattachinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tmpattachinfo` (
  `OWNERID` varchar(255) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `ATTACHFILESN` bigint(10) NOT NULL,
  `ATTACHFILENAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHFILESIZE` double(126,0) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `BODYATTACH` varchar(4) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL COMMENT '원문정보공개 첨부파일 플래그',
  `FILEOPENFLAG` char(1) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`OWNERID`,`SN`,`ATTACHFILESN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tmpexpaprdocinfo`
--

DROP TABLE IF EXISTS `tbl_tmpexpaprdocinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tmpexpaprdocinfo` (
  `OWNERID` varchar(200) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `SECURITYCODE` bigint(10) DEFAULT NULL,
  `STORAGEPERIOD` varchar(160) DEFAULT NULL,
  `KEYWORD` varchar(100) DEFAULT NULL,
  `FORMNAME` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANYID` varchar(20) NOT NULL DEFAULT '',
  `ITEMCODE` varchar(160) DEFAULT NULL,
  `ITEMNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `URGENTAPPROVAL` varchar(4) DEFAULT NULL,
  `SECURITYAPPROVAL` varchar(40) DEFAULT NULL,
  `TEMPATTRIBUTE` varchar(400) DEFAULT NULL,
  `STATUS` varchar(4) DEFAULT NULL,
  `SPECIALRECORDCODE` varchar(20) DEFAULT NULL,
  `PUBLICITYCODE` varchar(36) DEFAULT NULL,
  `LIMITRANGE` varchar(400) DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `CABINETID` varchar(112) DEFAULT NULL,
  `TASKCODE` varchar(32) DEFAULT NULL,
  `DOCNUMCODE` varchar(52) DEFAULT NULL,
  `ORGDOCNUMCODE` varchar(52) DEFAULT NULL,
  `SEPERATEATTACHXML` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `SUMMARY` longtext CHARACTER SET utf8mb4 DEFAULT NULL,
  `FORMNAME2` varchar(1020) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ITEMNAME2` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `PUBLICITYYN` char(2) DEFAULT NULL,
  `FORMVERSION` int(11) DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`OWNERID`,`SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tmpexpaprline`
--

DROP TABLE IF EXISTS `tbl_tmpexpaprline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tmpexpaprline` (
  `OWNERID` varchar(255) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `APRMEMBERSN` bigint(10) NOT NULL,
  `ORGUSERID` varchar(400) DEFAULT NULL,
  `PROXYUSERID` varchar(400) DEFAULT NULL,
  `PROXYUSERNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERJOBTITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERDEPTID` varchar(400) DEFAULT NULL,
  `PROXYUSERDEPTNAME` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROXYUSERDEPTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`OWNERID`,`SN`,`APRMEMBERSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tmpreceiptpointinfo`
--

DROP TABLE IF EXISTS `tbl_tmpreceiptpointinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tmpreceiptpointinfo` (
  `OWNERID` varchar(255) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `RECEIPTPOINTID` varchar(255) NOT NULL,
  `RECEIPTPOINTNAME` varchar(400) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSSN` bigint(10) DEFAULT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERID` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(160) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE` varchar(80) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DEPTMEMBERSN` bigint(10) DEFAULT NULL,
  `RECEIPTPOINTNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `ROUTEYN` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`OWNERID`,`SN`,`RECEIPTPOINTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_topmenu_general`
--

DROP TABLE IF EXISTS `tbl_topmenu_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_topmenu_general` (
  `UID_` varchar(100) NOT NULL,
  `PARENTUID` varchar(100) DEFAULT NULL,
  `DEPTH` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATORID` varchar(100) DEFAULT NULL,
  `CREATORNAME` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `WIDTH` bigint(10) DEFAULT NULL,
  `HEIGHT` bigint(10) DEFAULT NULL,
  `ROWLENGTH` bigint(10) DEFAULT NULL,
  `COLUMNLENGTH` bigint(10) DEFAULT NULL,
  `ROWSPLIT` varchar(100) DEFAULT NULL,
  `COLUMNSPLIT` varchar(100) DEFAULT NULL,
  `USEFLAG` varchar(2) DEFAULT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  `LANG` varchar(20) DEFAULT NULL,
  `TOPMNID` varchar(100) DEFAULT NULL,
  `BASETYPE` varchar(100) DEFAULT NULL,
  `THEMEUID` varchar(76) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`UID_`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_topmenu_items`
--

DROP TABLE IF EXISTS `tbl_topmenu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_topmenu_items` (
  `UID_` varchar(100) NOT NULL,
  `PAGEUID` varchar(100) NOT NULL,
  `PARENTPAGEUID` varchar(100) DEFAULT NULL,
  `OWNERPAGEID` varchar(100) DEFAULT NULL,
  `MENUITEMTYPE` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(100) DEFAULT NULL,
  `WIDTH` bigint(10) DEFAULT NULL,
  `HEIGHT` bigint(10) DEFAULT NULL,
  `ROWPOS` bigint(10) DEFAULT NULL,
  `COLUMNPOS` bigint(10) DEFAULT NULL,
  `CANREMOVE` bigint(10) DEFAULT NULL,
  `CANRESIZE` bigint(10) DEFAULT NULL,
  `CANREPLACE` bigint(10) DEFAULT NULL,
  `ALIGN` varchar(100) DEFAULT NULL,
  `VALIGN` varchar(100) DEFAULT NULL,
  `TOPMARGIN` bigint(10) DEFAULT NULL,
  `BOTTOMMARGIN` bigint(10) DEFAULT NULL,
  `LEFTMARGIN` bigint(10) DEFAULT NULL,
  `RIGHTMARGIN` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`PAGEUID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_totalalert_filter_personal`
--

DROP TABLE IF EXISTS `tbl_totalalert_filter_personal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_totalalert_filter_personal` (
  `USER_ID` varchar(20) NOT NULL,
  `IS_MOBILE` char(1) NOT NULL DEFAULT 'n',
  `READ_FILTER` char(3) DEFAULT 'all',
  `FAVORITE_FILTER` char(3) DEFAULT 'all',
  `MAIN_TYPE_FILTER` varchar(100) NOT NULL DEFAULT 'all',
  `OTHER_FILTER` char(3) DEFAULT NULL,
  `COMPANY_ID` varchar(100) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`USER_ID`,`COMPANY_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_totalalert_noti`
--

DROP TABLE IF EXISTS `tbl_totalalert_noti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_totalalert_noti` (
  `NOTI_ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `USER_ID` varchar(20) NOT NULL,
  `MAIN_TYPE` varchar(20) NOT NULL,
  `SUB_TYPE` varchar(20) DEFAULT NULL,
  `NOTI_CONTENT` varchar(2000) DEFAULT NULL,
  `SENDER_ID` varchar(20) DEFAULT NULL,
  `SENDER_NAME` varchar(200) DEFAULT NULL,
  `REG_DATE` datetime DEFAULT NULL,
  `IS_READ` varchar(10) DEFAULT 'N',
  `READ_DATE` datetime DEFAULT NULL,
  `IS_DELETE` varchar(10) DEFAULT 'N',
  `DELETE_DATE` datetime DEFAULT NULL,
  `COMPANY_ID` varchar(80) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `LINK_URL` varchar(300) DEFAULT NULL,
  `LINK_URL_MOBILE` varchar(300) DEFAULT NULL,
  `IS_FAVORITE` varchar(10) DEFAULT NULL,
  `VIEW_TYPE` varchar(10) DEFAULT NULL,
  `VIEW_WIDTH` mediumint(5) DEFAULT NULL,
  `VIEW_HEIGHT` mediumint(5) DEFAULT NULL,
  PRIMARY KEY (`NOTI_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_totalalert_noti_config`
--

DROP TABLE IF EXISTS `tbl_totalalert_noti_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_totalalert_noti_config` (
  `EXPIRE_PERIOD` varchar(30) NOT NULL,
  `COMPANY_ID` varchar(200) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`EXPIRE_PERIOD`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_totalalert_noti_config_notuseplatform`
--

DROP TABLE IF EXISTS `tbl_totalalert_noti_config_notuseplatform`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_totalalert_noti_config_notuseplatform` (
  `USER_ID` varchar(20) NOT NULL,
  `MAIN_TYPE` varchar(20) NOT NULL,
  `SUB_TYPE` varchar(50) NOT NULL,
  `NOT_USE_PLATFORM` varchar(20) NOT NULL,
  `DEL_FLAG` char(1) DEFAULT NULL,
  `TENANT_ID` mediumint(5) DEFAULT NULL,
  `COMPANY_ID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`USER_ID`,`MAIN_TYPE`,`SUB_TYPE`,`NOT_USE_PLATFORM`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_user_config`
--

DROP TABLE IF EXISTS `tbl_user_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_user_config` (
  `TENANT_ID` mediumint(5) NOT NULL,
  `USER_ID` varchar(80) NOT NULL,
  `PROPERTY_NAME` varchar(100) NOT NULL,
  `PROPERTY_VALUE` varchar(2000) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USER_ID`,`PROPERTY_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_user_jobmaster`
--

DROP TABLE IF EXISTS `tbl_user_jobmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_user_jobmaster` (
  `JOBID` bigint(20) NOT NULL AUTO_INCREMENT,
  `TYPE` varchar(50) NOT NULL,
  `CN` varchar(100) DEFAULT NULL,
  `DISPLAYNAME` varchar(200) DEFAULT NULL,
  `DISPLAYNAME2` varchar(200) DEFAULT NULL,
  `USEFLAG` varchar(2) DEFAULT NULL,
  `SORT` int(11) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `COMPANYID` varchar(40) NOT NULL,
  `TENANT_ID` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`JOBID`,`TYPE`,`COMPANYID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='CN은 사용안함(혹시 몰라서 컬럼은 살려둠)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_user_listoption`
--

DROP TABLE IF EXISTS `tbl_user_listoption`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_user_listoption` (
  `CN` varchar(80) NOT NULL,
  `LISTTYPE` varchar(20) NOT NULL,
  `SN` varchar(50) DEFAULT NULL,
  `TENANT_ID` int(11) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`CN`,`TENANT_ID`,`COMPANYID`,`LISTTYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_user_multilogin`
--

DROP TABLE IF EXISTS `tbl_user_multilogin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_user_multilogin` (
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `USER_ID` varchar(80) NOT NULL DEFAULT '',
  `LOGIN_TIME` varchar(15) NOT NULL,
  PRIMARY KEY (`USER_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_usercont`
--

DROP TABLE IF EXISTS `tbl_usercont`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_usercont` (
  `USERCONTID` varchar(20) NOT NULL,
  `USERCONTNAME` varchar(255) CHARACTER SET utf8mb4 DEFAULT NULL,
  `PARENTCONTID` varchar(20) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `OWNUSERID` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERCONTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_usercontlist`
--

DROP TABLE IF EXISTS `tbl_usercontlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_usercontlist` (
  `DOCID` varchar(20) NOT NULL,
  `USERCONTID` varchar(20) NOT NULL,
  `LINKDATE` datetime DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`COMPANYID`,`USERCONTID`,`DOCID`),
  CONSTRAINT `PK_USERCONT` FOREIGN KEY (`TENANT_ID`, `COMPANYID`, `USERCONTID`) REFERENCES `tbl_usercont` (`TENANT_ID`, `COMPANYID`, `USERCONTID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_userinfo`
--

DROP TABLE IF EXISTS `tbl_userinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_userinfo` (
  `USERID` varchar(100) NOT NULL,
  `UID_` varchar(100) DEFAULT NULL,
  `SKINNUM` bigint(10) DEFAULT NULL,
  `SKINDEFAULTIMAGE` varchar(500) DEFAULT NULL,
  `SKINDEFAULTCOLOR` varchar(100) DEFAULT NULL,
  `PORTAL_UID` varchar(100) DEFAULT NULL,
  `PORTAL_SKINNUM` bigint(10) DEFAULT NULL,
  `LANG` varchar(20) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_userlocalinfo`
--

DROP TABLE IF EXISTS `tbl_userlocalinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_userlocalinfo` (
  `USERID` varchar(200) NOT NULL,
  `TIMEZONE` varchar(40) NOT NULL,
  `LANG` varchar(4) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_usermaster`
--

DROP TABLE IF EXISTS `tbl_usermaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_usermaster` (
  `CN` varchar(80) NOT NULL,
  `DISPLAYNAME` varchar(120) CHARACTER SET utf8mb4 NOT NULL,
  `DISPLAYNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MAIL` varchar(100) DEFAULT NULL,
  `MAILNICKNAME` varchar(100) DEFAULT NULL,
  `UPNNAME` varchar(400) DEFAULT NULL,
  `DEPARTMENT` varchar(80) NOT NULL,
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION3` varchar(200) DEFAULT NULL,
  `PHYSICALDELIVERYOFFICENAME` varchar(160) DEFAULT NULL,
  `COMPANY` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANY2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `HOMEPHONE` varchar(100) DEFAULT NULL,
  `FACSIMILETELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `MOBILE` varchar(100) DEFAULT NULL,
  `POSTALCODE` varchar(100) DEFAULT NULL,
  `STREETADDRESS` varchar(400) DEFAULT NULL,
  `INFO` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(200) DEFAULT NULL COMMENT 'c:전체, k:회사, g:그룹, a:수발신, n:게시관리, l:설문, i:심사자, w:업무, m:기록물관리',
  `EXTENSIONATTRIBUTE2` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(2000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(2000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE102` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(200) DEFAULT NULL,
  `ADSPATH` varchar(200) DEFAULT NULL,
  `SIPURI` varchar(100) DEFAULT NULL,
  `UPDATEDT` datetime NOT NULL,
  `MOBILE_ENABLE` varchar(4) DEFAULT NULL,
  `MOBILE_NOTUSE` varchar(4) DEFAULT 'N',
  `MOBILE_PIN` varchar(4) DEFAULT NULL,
  `POSITIONCD` varchar(40) DEFAULT NULL,
  `BIRTH` varchar(20) DEFAULT NULL,
  `BIRTHTYPE` varchar(4) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  `IPADDRESS` varchar(15) DEFAULT NULL,
  `LASTLOGIN` datetime DEFAULT NULL,
  `LOGINCNT` bigint(10) DEFAULT 0,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `MANUAL_FLAG` varchar(4) DEFAULT NULL,
  `LISTTYPE` varchar(3) DEFAULT 'TXT',
  `PASSWORD_UPDATEDT` datetime DEFAULT NULL,
  `FURIGANA` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONPHONE` varchar(100) DEFAULT NULL,
  `OFFICEMOBILE` varchar(100) DEFAULT NULL,
  `MAILBOXQUOTA` varchar(50) DEFAULT NULL,
  `MAILBOXUSAGE` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`CN`,`TENANT_ID`),
  KEY `IDX_EMP_NO` (`EXTENSIONATTRIBUTE14`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_usermaster_delete`
--

DROP TABLE IF EXISTS `tbl_usermaster_delete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_usermaster_delete` (
  `CN` varchar(80) NOT NULL,
  `DISPLAYNAME` varchar(120) CHARACTER SET utf8mb4 NOT NULL,
  `DISPLAYNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MAIL` varchar(100) DEFAULT NULL,
  `MAILNICKNAME` varchar(100) DEFAULT NULL,
  `UPNNAME` varchar(400) DEFAULT NULL,
  `DEPARTMENT` varchar(80) NOT NULL,
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION3` varchar(200) DEFAULT NULL,
  `PHYSICALDELIVERYOFFICENAME` varchar(160) DEFAULT NULL,
  `COMPANY` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANY2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `HOMEPHONE` varchar(100) DEFAULT NULL,
  `FACSIMILETELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `MOBILE` varchar(100) DEFAULT NULL,
  `POSTALCODE` varchar(100) DEFAULT NULL,
  `STREETADDRESS` varchar(400) DEFAULT NULL,
  `INFO` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(2000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE102` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(200) DEFAULT NULL,
  `ADSPATH` varchar(200) DEFAULT NULL,
  `UPDATEDT` datetime NOT NULL,
  `MOBILE_ENABLE` varchar(4) DEFAULT NULL,
  `MOBILE_NOTUSE` varchar(4) DEFAULT NULL,
  `MOBILE_PIN` varchar(4) DEFAULT NULL,
  `SIPURI` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `PASSWORD` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`CN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_usermaster_retire`
--

DROP TABLE IF EXISTS `tbl_usermaster_retire`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_usermaster_retire` (
  `CN` varchar(80) NOT NULL,
  `DISPLAYNAME` varchar(120) CHARACTER SET utf8mb4 NOT NULL,
  `DISPLAYNAME2` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `MAIL` varchar(100) DEFAULT NULL,
  `MAILNICKNAME` varchar(100) DEFAULT NULL,
  `UPNNAME` varchar(400) DEFAULT NULL,
  `DEPARTMENT` varchar(80) NOT NULL,
  `DESCRIPTION` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DESCRIPTION3` varchar(200) DEFAULT NULL,
  `PHYSICALDELIVERYOFFICENAME` varchar(160) DEFAULT NULL,
  `COMPANY` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `COMPANY2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TITLE2` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL,
  `TELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `HOMEPHONE` varchar(100) DEFAULT NULL,
  `FACSIMILETELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `MOBILE` varchar(100) DEFAULT NULL,
  `POSTALCODE` varchar(100) DEFAULT NULL,
  `STREETADDRESS` varchar(400) DEFAULT NULL,
  `INFO` varchar(2000) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(2000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE102` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(200) DEFAULT NULL,
  `ADSPATH` varchar(200) DEFAULT NULL,
  `UPDATEDT` datetime NOT NULL,
  `MOBILE_ENABLE` varchar(4) DEFAULT NULL,
  `MOBILE_NOTUSE` varchar(4) DEFAULT NULL,
  `MOBILE_PIN` varchar(4) DEFAULT NULL,
  `SIPURI` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  `PASSWORD` varchar(100) DEFAULT NULL,
  `FURIGANA` varchar(120) CHARACTER SET utf8mb4 DEFAULT NULL,
  `EXTENSIONPHONE` varchar(100) DEFAULT NULL,
  `OFFICEMOBILE` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`CN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_usermobileinfo`
--

DROP TABLE IF EXISTS `tbl_usermobileinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_usermobileinfo` (
  `USERID` varchar(200) NOT NULL,
  `TIMEZONE` varchar(40) NOT NULL,
  `LANG` varchar(4) NOT NULL,
  `MAINTYPE` char(1) NOT NULL,
  `LISTCNT` mediumint(5) NOT NULL,
  `USESECURITY` char(1) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`USERID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_userstartpage_item`
--

DROP TABLE IF EXISTS `tbl_userstartpage_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_userstartpage_item` (
  `UID_` varchar(100) NOT NULL,
  `PARENTUID` varchar(100) NOT NULL,
  `IMAGEUID` varchar(100) NOT NULL,
  `ACCESSID` varchar(100) NOT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  `LINKURL` varchar(510) NOT NULL,
  `LANG` varchar(20) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`UID_`,`ACCESSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_vote_answer`
--

DROP TABLE IF EXISTS `tbl_vote_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vote_answer` (
  `ID` mediumint(9) NOT NULL,
  `QST_ID` mediumint(9) NOT NULL,
  `TENANT_ID` mediumint(9) NOT NULL,
  `CONTENT` varchar(250) NOT NULL,
  `VOTES_NUM` int(11) NOT NULL DEFAULT 0,
  `FILE_PATH` longtext DEFAULT NULL,
  PRIMARY KEY (`ID`,`QST_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_vote_comment`
--

DROP TABLE IF EXISTS `tbl_vote_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vote_comment` (
  `ID` int(11) NOT NULL,
  `QST_ID` int(11) NOT NULL,
  `TENANT_ID` int(11) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `USER_NAME1` varchar(120) NOT NULL,
  `USER_NAME2` varchar(120) NOT NULL,
  `TEXT_CONTENT` varchar(500) DEFAULT '',
  `IMAGE_TYPE` varchar(50) DEFAULT '',
  `FILE_TYPE` varchar(250) DEFAULT '',
  `FILE_NAME` varchar(250) DEFAULT '',
  `FILE_PATH` varchar(250) DEFAULT '',
  `CMT_TIME` varchar(50) NOT NULL,
  `dept_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`,`QST_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_vote_configuration`
--

DROP TABLE IF EXISTS `tbl_vote_configuration`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vote_configuration` (
  `USER_ID` varchar(100) NOT NULL,
  `START_TIME` varchar(50) NOT NULL,
  `END_TIME` varchar(50) NOT NULL,
  `TARGET_DEPTS` varchar(500) DEFAULT NULL,
  `TARGET_USERS` varchar(500) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`USER_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_vote_question`
--

DROP TABLE IF EXISTS `tbl_vote_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vote_question` (
  `ID` mediumint(9) NOT NULL,
  `TENANT_ID` mediumint(9) NOT NULL,
  `CONTENT` longtext DEFAULT NULL,
  `MULTI_SELECT` tinyint(4) NOT NULL DEFAULT 0,
  `CREATE_DATE` varchar(38) NOT NULL,
  `START_DATE` varchar(38) NOT NULL,
  `END_DATE` varchar(38) NOT NULL,
  `TARGET` tinyint(4) NOT NULL DEFAULT 0,
  `TITLE` varchar(250) NOT NULL,
  `SECRET_VOTE` tinyint(4) NOT NULL DEFAULT 0,
  `CREATOR` varchar(80) NOT NULL DEFAULT '0',
  `CREATOR_NAME1` varchar(120) NOT NULL,
  `CREATOR_NAME2` varchar(120) NOT NULL,
  `CREATOR_DEPT` varchar(80) DEFAULT NULL,
  `FILE_PATH` longtext DEFAULT NULL,
  `RESULT_FIRST` tinyint(4) NOT NULL DEFAULT 1,
  `IS_MODIFYING` tinyint(4) NOT NULL DEFAULT 0,
  `SET_DATE` tinyint(4) NOT NULL DEFAULT 0,
  `IS_SORTING` tinyint(4) NOT NULL DEFAULT 0,
  `IS_SELONLYONCE` tinyint(4) NOT NULL DEFAULT 0,
  `SENDPOSTNOTICE` tinyint(4) NOT NULL DEFAULT 0,
  `OPENTOALL` tinyint(4) NOT NULL DEFAULT 0,
  `VOTEOPTION1` tinyint(4) DEFAULT 0,
  `VOTEOPTION2` tinyint(4) DEFAULT 0,
  `VOTEOPTION3` tinyint(4) DEFAULT 0,
  `VOTEOPTION4` tinyint(4) DEFAULT 0,
  `COMPANYID` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_vote_question_related`
--

DROP TABLE IF EXISTS `tbl_vote_question_related`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vote_question_related` (
  `QST_ID` int(11) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `TENANT_ID` int(11) NOT NULL,
  `SEEN` tinyint(4) NOT NULL DEFAULT 0,
  `COMMENT` tinyint(4) NOT NULL DEFAULT 0,
  `HIDE` tinyint(4) NOT NULL DEFAULT 0,
  `MODIFYING` tinyint(4) NOT NULL DEFAULT 0,
  `COMPANYID` varchar(80) DEFAULT NULL,
  `dept_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`QST_ID`,`USER_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_vote_user_and_answer`
--

DROP TABLE IF EXISTS `tbl_vote_user_and_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vote_user_and_answer` (
  `ANS_ID` mediumint(9) NOT NULL,
  `QST_ID` mediumint(9) NOT NULL,
  `USER_ID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(9) NOT NULL,
  `USER_NAME1` varchar(120) NOT NULL,
  `USER_NAME2` varchar(120) NOT NULL,
  `VOTE_DATE` varchar(70) NOT NULL,
  `dept_id` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ANS_ID`,`QST_ID`,`USER_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_vote_user_and_question`
--

DROP TABLE IF EXISTS `tbl_vote_user_and_question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vote_user_and_question` (
  `QST_ID` int(11) NOT NULL,
  `USER_ID` varchar(50) NOT NULL,
  `TENANT_ID` int(11) NOT NULL,
  `USER_TYPE` varchar(50) NOT NULL DEFAULT '0',
  `COMPANYID` varchar(80) DEFAULT NULL,
  `DEPT_ID` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`QST_ID`,`USER_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_vote_users`
--

DROP TABLE IF EXISTS `tbl_vote_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_vote_users` (
  `TENANT_ID` int(11) NOT NULL,
  `QST_ID` int(11) NOT NULL,
  `USER_ID` varchar(80) NOT NULL,
  `USER_NAME` varchar(120) NOT NULL,
  `USER_NAME2` varchar(120) DEFAULT NULL,
  `DEPT_ID` varchar(80) DEFAULT NULL,
  `DEPT_NAME` varchar(200) DEFAULT NULL,
  `DEPT_NAME2` varchar(200) DEFAULT NULL,
  `USER_STATUS` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`TENANT_ID`,`QST_ID`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_weather`
--

DROP TABLE IF EXISTS `tbl_weather`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_weather` (
  `SN` varchar(3) NOT NULL,
  `CITYCODE` varchar(20) CHARACTER SET utf8mb4 NOT NULL,
  `CITYNAME` varchar(50) CHARACTER SET utf8mb4 DEFAULT NULL,
  `DISPLAYCITYNAME` varchar(50) CHARACTER SET utf8mb4 NOT NULL,
  `PRIMARYLANG` varchar(10) CHARACTER SET utf8mb4 NOT NULL,
  `CURRENTWEATHER` varchar(200) DEFAULT NULL,
  `TODAYWEATHER` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`CITYCODE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_weather_user`
--

DROP TABLE IF EXISTS `tbl_weather_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_weather_user` (
  `USERID` varchar(80) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  `CITYCODE` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`USERID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_config`
--

DROP TABLE IF EXISTS `tbl_webfolder_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_config` (
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `COMPANY_ID` varchar(100) NOT NULL COMMENT '회사 아이디',
  `UPLOAD_LIMIT` varchar(100) DEFAULT NULL COMMENT '1회 업로드 제한량',
  `USER_TOTAL_LIMIT` varchar(100) DEFAULT NULL,
  `COMPANY_TOTAL_LIMIT` varchar(100) DEFAULT NULL,
  `DEPARTMENT_TOTAL_LIMIT` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`COMPANY_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='웹폴더 기본설정';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_env`
--

DROP TABLE IF EXISTS `tbl_webfolder_env`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_env` (
  `CN` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `ENV_TYPE` varchar(100) NOT NULL COMMENT '환경설정 타입: 부서: D, 페이지: P ',
  `ENV_VALUE` varchar(100) DEFAULT NULL COMMENT '부서명 ; 페이지 카운트: 10,20,30,40,50',
  `TENANT_ID` bigint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`CN`,`ENV_TYPE`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='사용자 환경설정';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_favor`
--

DROP TABLE IF EXISTS `tbl_webfolder_favor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_favor` (
  `TARGET_ID` varchar(100) NOT NULL COMMENT '대상 아이디(폴더 또는 파일)',
  `USER_ID` varchar(80) NOT NULL COMMENT '사용자 아이디',
  `TARGET_TYPE` varchar(50) NOT NULL COMMENT '유형 폴더:FOLDER, 파일:FILE',
  `CREATE_DATE` datetime NOT NULL COMMENT '생성일',
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`TENANT_ID`,`TARGET_ID`,`TARGET_TYPE`,`USER_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='웹폴더 즐겨찾기';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_file`
--

DROP TABLE IF EXISTS `tbl_webfolder_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_file` (
  `FILE_ID` varchar(100) NOT NULL COMMENT '파일 아이디',
  `FILE_NAME` varchar(250) NOT NULL COMMENT '파일 이름',
  `FILE_PATH` varchar(250) NOT NULL COMMENT '파일 경로',
  `FILE_SIZE` bigint(20) NOT NULL COMMENT '파일 크기',
  `TYPE_ID` varchar(100) NOT NULL COMMENT '파일 유형 아이디',
  `DOWN_COUNT` bigint(20) NOT NULL DEFAULT 0 COMMENT '다운로드 카운트',
  `FILE_EXT` varchar(10) NOT NULL COMMENT '파일 확장자명',
  `FOLDER_ID` varchar(50) NOT NULL COMMENT '상위 폴더 아이디',
  `USE_STATUS` varchar(250) NOT NULL COMMENT '사용여부 사용:Y , 미사용: N, 휴지통: T',
  `CREATE_ID` varchar(80) NOT NULL COMMENT '생성자 아이디',
  `CREATE_NAME1` varchar(120) NOT NULL COMMENT '생성자 이름',
  `CREATE_NAME2` varchar(120) NOT NULL COMMENT '생성자 이름 2',
  `CREATE_DATE` datetime NOT NULL COMMENT '생성일',
  `UPDATE_ID` varchar(80) NOT NULL COMMENT '수정자 아이디',
  `UPDATE_DATE` datetime NOT NULL COMMENT '수정일',
  `DELETER_ID` varchar(100) DEFAULT NULL COMMENT '삭제한 사람',
  `TENANT_ID` mediumint(5) unsigned NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`FILE_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='웹폴더 파일';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_filetype`
--

DROP TABLE IF EXISTS `tbl_webfolder_filetype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_filetype` (
  `TYPE_ID` varchar(100) NOT NULL COMMENT '유형아이디',
  `TYPE_NAME` varchar(80) NOT NULL COMMENT '파일확장자',
  `TYPE_NAME2` varchar(80) NOT NULL,
  `FILE_EXT` varchar(80) NOT NULL COMMENT '파일유형 문서:DOCU, 음악:MUSIC, 영상:VIDEO, 그림:PHOTO, 폴더:FOLDER, 압축파일:ZIP',
  `TYPE_ICON` varchar(100) DEFAULT NULL COMMENT '파일 아이콘 경로',
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`TYPE_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='파일확장자 유형';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_folder`
--

DROP TABLE IF EXISTS `tbl_webfolder_folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_folder` (
  `FOLDER_ID` varchar(100) NOT NULL COMMENT '폴더아이디',
  `FOLDER_NAME1` varchar(200) NOT NULL COMMENT '폴더이름',
  `FOLDER_NAME2` varchar(200) DEFAULT NULL COMMENT '폴더이름2',
  `FOLDER_TYPE` varchar(50) NOT NULL COMMENT '폴더유형 회사:C, 부서: D, 개인: U',
  `FOLDER_PATH` varchar(200) DEFAULT NULL COMMENT '폴더경로',
  `FOLDER_STEP` bigint(10) NOT NULL COMMENT '폴더트리스텝',
  `FOLDER_LEVEL` bigint(10) NOT NULL COMMENT '폴더트리레벨',
  `FOLDER_UPPER` varchar(50) DEFAULT NULL COMMENT '상위폴더 아이디',
  `USE_STATUS` varchar(5) DEFAULT NULL COMMENT '사용여부 사용:Y, 미사용:N, 휴지통:T',
  `OWNER_ID` varchar(100) DEFAULT NULL COMMENT '소유자 아이디 (사원아이디,부서아이디,회사아이디)',
  `CREATE_ID` varchar(100) NOT NULL COMMENT '생성자 아이디',
  `CREATE_DATE` datetime NOT NULL COMMENT '생성일',
  `CREATE_NAME1` varchar(100) NOT NULL COMMENT '생성자 이름',
  `CREATE_NAME2` varchar(100) NOT NULL COMMENT '생성자 이름2',
  `UPDATE_ID` varchar(100) DEFAULT NULL COMMENT '수정자 아이디',
  `UPDATE_DATE` datetime DEFAULT NULL COMMENT '수정일',
  `COMPANY_ID` varchar(100) NOT NULL COMMENT '회사 아이디',
  `DELETER_ID` varchar(100) DEFAULT NULL COMMENT '삭제한 사람',
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`TENANT_ID`,`FOLDER_ID`),
  KEY `index2` (`TENANT_ID`,`OWNER_ID`,`FOLDER_UPPER`,`FOLDER_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='웹폴더 폴더';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_folderuser`
--

DROP TABLE IF EXISTS `tbl_webfolder_folderuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_folderuser` (
  `SEQ_ID` varchar(100) NOT NULL COMMENT '생성 순번',
  `USER_ID` varchar(100) NOT NULL COMMENT '사용자 아이디',
  `USER_TYPE` varchar(50) NOT NULL COMMENT '사용자 타입 부서: DEPT, 사원:USER ',
  `FOLDER_ID` varchar(100) NOT NULL COMMENT '폴더 아이디',
  `CREATE_ID` varchar(100) NOT NULL COMMENT '생성자 아이디',
  `CREATE_DATE` datetime NOT NULL COMMENT '생성일',
  `COMPANY_ID` varchar(50) NOT NULL COMMENT '회사 아이디',
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`SEQ_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='웹폴더 폴더 사용자';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_log`
--

DROP TABLE IF EXISTS `tbl_webfolder_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_log` (
  `LOG_ID` varchar(200) NOT NULL COMMENT '로그 순번',
  `FILE_TYPE` varchar(200) DEFAULT NULL COMMENT '파일유형',
  `FILE_NAME` varchar(200) DEFAULT NULL COMMENT '파일이름',
  `FILE_SIZE` bigint(20) DEFAULT NULL COMMENT '파일크기',
  `FILE_EXT` varchar(10) DEFAULT NULL COMMENT '파일확장자',
  `LOG_TYPE` varchar(200) DEFAULT NULL COMMENT '수행사항(업로드:C, 다운로드:D, 수정:U, 삭제: R, 영구삭제:P)',
  `CREATE_ID` varchar(200) DEFAULT NULL COMMENT '생성자 아이디',
  `CREATE_NAME1` varchar(200) DEFAULT NULL COMMENT '생성자 이름',
  `CREATE_NAME2` varchar(200) DEFAULT NULL COMMENT '생성자 이름2',
  `CREATE_DATE` datetime DEFAULT NULL COMMENT '생성일',
  `COMPANY_ID` varchar(200) DEFAULT NULL COMMENT '회사 아이디',
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  PRIMARY KEY (`LOG_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='웹폴더 사용 로그';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_share`
--

DROP TABLE IF EXISTS `tbl_webfolder_share`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_share` (
  `SHARE_ID` bigint(20) NOT NULL,
  `SHARER_ID` varchar(80) NOT NULL,
  `SHARER_NAME1` varchar(120) NOT NULL,
  `SHARER_NAME2` varchar(120) NOT NULL,
  `FOLDERFILE_ID` varchar(100) NOT NULL,
  `FOLDERFILE_TYPE` varchar(5) NOT NULL,
  `USER_NAME_LIST` varchar(300) DEFAULT NULL,
  `SHARE_DATE` datetime NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`SHARE_ID`,`TENANT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_share_hide`
--

DROP TABLE IF EXISTS `tbl_webfolder_share_hide`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_share_hide` (
  `SEQ_ID` bigint(20) NOT NULL,
  `SHARE_ID` bigint(20) NOT NULL,
  `USER_ID` varchar(80) NOT NULL,
  `USER_NAME1` varchar(120) NOT NULL,
  `USER_NAME2` varchar(120) NOT NULL,
  `HIDE_DATE` datetime NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`SEQ_ID`,`TENANT_ID`),
  KEY `tbl_webfolder_share_del_fk_idx` (`SHARE_ID`,`TENANT_ID`),
  CONSTRAINT `fk_webfolder_share_hide` FOREIGN KEY (`SHARE_ID`, `TENANT_ID`) REFERENCES `tbl_webfolder_share` (`SHARE_ID`, `TENANT_ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_share_sub`
--

DROP TABLE IF EXISTS `tbl_webfolder_share_sub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_share_sub` (
  `SEQ_ID` bigint(20) NOT NULL,
  `SHARE_ID` bigint(20) NOT NULL,
  `USER_ID` varchar(80) NOT NULL,
  `USER_NAME1` varchar(120) NOT NULL,
  `USER_NAME2` varchar(120) NOT NULL,
  `USER_TYPE` varchar(5) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`SEQ_ID`,`TENANT_ID`),
  KEY `tbl_webfolder_share_fk_idx` (`SHARE_ID`,`TENANT_ID`),
  CONSTRAINT `tbl_webfolder_share_sub_fk` FOREIGN KEY (`SHARE_ID`, `TENANT_ID`) REFERENCES `tbl_webfolder_share` (`SHARE_ID`, `TENANT_ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_token`
--

DROP TABLE IF EXISTS `tbl_webfolder_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_token` (
  `USERID` varchar(32) NOT NULL,
  `LTOKEN` varchar(128) DEFAULT NULL,
  `REGDATA` datetime DEFAULT NULL,
  `COMPID` varchar(32) DEFAULT NULL,
  `TENANTID` varchar(45) NOT NULL,
  `DEVICE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`USERID`,`TENANTID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_webfolder_user`
--

DROP TABLE IF EXISTS `tbl_webfolder_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_webfolder_user` (
  `CN` varchar(80) NOT NULL COMMENT '사용자 아이디',
  `TOTAL_CAPACITY` varchar(250) DEFAULT NULL COMMENT '총용량',
  `COMPANY_ID` varchar(50) NOT NULL COMMENT '회사 아이디',
  `TENANT_ID` mediumint(5) NOT NULL COMMENT '테넌트 아이디',
  `TYPE` varchar(50) NOT NULL,
  PRIMARY KEY (`CN`,`TENANT_ID`,`TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='웹폴더 사용자';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `vaprdoingdoclist`
--

DROP TABLE IF EXISTS `vaprdoingdoclist`;
/*!50001 DROP VIEW IF EXISTS `vaprdoingdoclist`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vaprdoingdoclist` AS SELECT 
 1 AS `DOCID`,
 1 AS `FORMID`,
 1 AS `ORGDOCID`,
 1 AS `DOCTYPE`,
 1 AS `DOCSTATE`,
 1 AS `FUNCTIONTYPE`,
 1 AS `HREF`,
 1 AS `DOCTITLE`,
 1 AS `DOCNO`,
 1 AS `HASATTACHYN`,
 1 AS `HASOPINIONYN`,
 1 AS `STARTDATE`,
 1 AS `ENDDATE`,
 1 AS `WRITERID`,
 1 AS `WRITERNAME`,
 1 AS `WRITERJOBTITLE`,
 1 AS `WRITERDEPTID`,
 1 AS `WRITERDEPTNAME`,
 1 AS `ISPUBLIC`,
 1 AS `WRITERNAME2`,
 1 AS `WRITERJOBTITLE2`,
 1 AS `WRITERDEPTNAME2`,
 1 AS `TENANT_ID`,
 1 AS `COMPANYID`,
 1 AS `APRMEMBERSN`,
 1 AS `APRTYPE`,
 1 AS `APRSTATE`,
 1 AS `APRMEMBERID`,
 1 AS `APRMEMBERNAME`,
 1 AS `APRMEMBERNAME2`,
 1 AS `APRMEMBERJOBTITLE`,
 1 AS `APRMEMBERJOBTITLE2`,
 1 AS `APRMEMBERDEPTID`,
 1 AS `APRMEMBERDEPTNAME`,
 1 AS `APRMEMBERDEPTNAME2`,
 1 AS `RECEIVEDDATE`,
 1 AS `FORMNAME`,
 1 AS `FORMNAME2`,
 1 AS `URGENTAPPROVAL`,
 1 AS `companyName`,
 1 AS `companyName2`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vaprwilldoclist`
--

DROP TABLE IF EXISTS `vaprwilldoclist`;
/*!50001 DROP VIEW IF EXISTS `vaprwilldoclist`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vaprwilldoclist` AS SELECT 
 1 AS `DOCID`,
 1 AS `FORMID`,
 1 AS `ORGDOCID`,
 1 AS `DOCTYPE`,
 1 AS `DOCSTATE`,
 1 AS `FUNCTIONTYPE`,
 1 AS `HREF`,
 1 AS `DOCTITLE`,
 1 AS `DOCNO`,
 1 AS `HASATTACHYN`,
 1 AS `HASOPINIONYN`,
 1 AS `STARTDATE`,
 1 AS `ENDDATE`,
 1 AS `WRITERID`,
 1 AS `WRITERNAME`,
 1 AS `WRITERJOBTITLE`,
 1 AS `WRITERDEPTID`,
 1 AS `WRITERDEPTNAME`,
 1 AS `ISPUBLIC`,
 1 AS `WRITERNAME2`,
 1 AS `WRITERJOBTITLE2`,
 1 AS `WRITERDEPTNAME2`,
 1 AS `TENANT_ID`,
 1 AS `COMPANYID`,
 1 AS `APRMEMBERSN`,
 1 AS `APRTYPE`,
 1 AS `APRSTATE`,
 1 AS `APRMEMBERID`,
 1 AS `APRMEMBERNAME`,
 1 AS `APRMEMBERNAME2`,
 1 AS `APRMEMBERJOBTITLE`,
 1 AS `APRMEMBERJOBTITLE2`,
 1 AS `APRMEMBERDEPTID`,
 1 AS `APRMEMBERDEPTNAME`,
 1 AS `APRMEMBERDEPTNAME2`,
 1 AS `FORMNAME`,
 1 AS `FORMNAME2`,
 1 AS `URGENTAPPROVAL`,
 1 AS `companyName`,
 1 AS `companyName2`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vendchamjodocinfo`
--

DROP TABLE IF EXISTS `vendchamjodocinfo`;
/*!50001 DROP VIEW IF EXISTS `vendchamjodocinfo`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vendchamjodocinfo` AS SELECT 
 1 AS `DOCID`,
 1 AS `FORMID`,
 1 AS `ORGDOCID`,
 1 AS `DOCTYPE`,
 1 AS `DOCSTATE`,
 1 AS `FUNCTIONTYPE`,
 1 AS `HREF`,
 1 AS `DOCTITLE`,
 1 AS `DOCNO`,
 1 AS `HASATTACHYN`,
 1 AS `HASOPINIONYN`,
 1 AS `STARTDATE`,
 1 AS `ENDDATE`,
 1 AS `WRITERID`,
 1 AS `WRITERNAME`,
 1 AS `WRITERJOBTITLE`,
 1 AS `WRITERDEPTID`,
 1 AS `WRITERDEPTNAME`,
 1 AS `ISPUBLIC`,
 1 AS `WRITERNAME2`,
 1 AS `WRITERJOBTITLE2`,
 1 AS `WRITERDEPTNAME2`,
 1 AS `TENANT_ID`,
 1 AS `COMPANYID`,
 1 AS `APRMEMBERSN`,
 1 AS `APRTYPE`,
 1 AS `APRSTATE`,
 1 AS `APRMEMBERID`,
 1 AS `APRMEMBERNAME`,
 1 AS `APRMEMBERNAME2`,
 1 AS `APRMEMBERJOBTITLE`,
 1 AS `APRMEMBERJOBTITLE2`,
 1 AS `APRMEMBERDEPTID`,
 1 AS `APRMEMBERDEPTNAME`,
 1 AS `APRMEMBERDEPTNAME2`,
 1 AS `RECEIVEDDATE`,
 1 AS `FORMNAME`,
 1 AS `FORMNAME2`,
 1 AS `URGENTAPPROVAL`,
 1 AS `companyName`,
 1 AS `companyName2`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vgongramaprdoingdoclist`
--

DROP TABLE IF EXISTS `vgongramaprdoingdoclist`;
/*!50001 DROP VIEW IF EXISTS `vgongramaprdoingdoclist`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vgongramaprdoingdoclist` AS SELECT 
 1 AS `DOCID`,
 1 AS `FORMID`,
 1 AS `ORGDOCID`,
 1 AS `DOCTYPE`,
 1 AS `DOCSTATE`,
 1 AS `FUNCTIONTYPE`,
 1 AS `HREF`,
 1 AS `DOCTITLE`,
 1 AS `DOCNO`,
 1 AS `HASATTACHYN`,
 1 AS `HASOPINIONYN`,
 1 AS `STARTDATE`,
 1 AS `ENDDATE`,
 1 AS `WRITERID`,
 1 AS `WRITERNAME`,
 1 AS `WRITERJOBTITLE`,
 1 AS `WRITERDEPTID`,
 1 AS `WRITERDEPTNAME`,
 1 AS `ISPUBLIC`,
 1 AS `WRITERNAME2`,
 1 AS `WRITERJOBTITLE2`,
 1 AS `WRITERDEPTNAME2`,
 1 AS `TENANT_ID`,
 1 AS `COMPANYID`,
 1 AS `APRMEMBERSN`,
 1 AS `APRTYPE`,
 1 AS `APRSTATE`,
 1 AS `APRMEMBERID`,
 1 AS `APRMEMBERNAME`,
 1 AS `APRMEMBERNAME2`,
 1 AS `APRMEMBERJOBTITLE`,
 1 AS `APRMEMBERJOBTITLE2`,
 1 AS `APRMEMBERDEPTID`,
 1 AS `APRMEMBERDEPTNAME`,
 1 AS `APRMEMBERDEPTNAME2`,
 1 AS `RECEIVEDDATE`,
 1 AS `FORMNAME`,
 1 AS `FORMNAME2`,
 1 AS `URGENTAPPROVAL`,
 1 AS `companyName`,
 1 AS `companyName2`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_ezapprovalg`
--

DROP TABLE IF EXISTS `view_ezapprovalg`;
/*!50001 DROP VIEW IF EXISTS `view_ezapprovalg`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_ezapprovalg` AS SELECT 
 1 AS `docid`,
 1 AS `docno`,
 1 AS `doctitle`,
 1 AS `writerdeptname`,
 1 AS `writerdeptname2`,
 1 AS `writername`,
 1 AS `writername2`,
 1 AS `StartDate`,
 1 AS `EndDate`,
 1 AS `hasattachyn`,
 1 AS `ContentsPath`,
 1 AS `href`,
 1 AS `formid`,
 1 AS `formname`,
 1 AS `formname2`,
 1 AS `containerid`,
 1 AS `KeyWord`,
 1 AS `WriterDeptID`,
 1 AS `TENANT_ID`,
 1 AS `COMPANYID`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `view_ezboardstd`
--

DROP TABLE IF EXISTS `view_ezboardstd`;
/*!50001 DROP VIEW IF EXISTS `view_ezboardstd`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `view_ezboardstd` AS SELECT 
 1 AS `ITEMID`,
 1 AS `BOARDNAME`,
 1 AS `BOARDNAME2`,
 1 AS `GUBUN`,
 1 AS `title`,
 1 AS `WRITERDEPTNAME`,
 1 AS `WRITERNAME`,
 1 AS `WRITEDATE`,
 1 AS `ATTACHMENTS`,
 1 AS `BOARDID`,
 1 AS `WRITERID`,
 1 AS `Herf`,
 1 AS `CONTENTLOCATION`,
 1 AS `WRITERDEPTID`,
 1 AS `TENANT_ID`,
 1 AS `COMPANYID`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `vtaskclass`
--

DROP TABLE IF EXISTS `vtaskclass`;
/*!50001 DROP VIEW IF EXISTS `vtaskclass`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vtaskclass` AS SELECT 
 1 AS `CATEGORYCODE`,
 1 AS `CNAME`,
 1 AS `CNAME2`,
 1 AS `MCATEGORYCODE`,
 1 AS `MCNAME`,
 1 AS `MCNAME2`,
 1 AS `SUBCATEGORYCODE`,
 1 AS `SCNAME`,
 1 AS `SCNAME2`,
 1 AS `TASKCODE`,
 1 AS `TASKNAME`,
 1 AS `TASKNAME2`,
 1 AS `KEEPINGPERIOD`,
 1 AS `DISPLAYRECFLAG`,
 1 AS `SPECIALCATALOGFLAG`,
 1 AS `SC1`,
 1 AS `SC2`,
 1 AS `SC3`,
 1 AS `TEMPFLAG`,
 1 AS `COMPANYID`,
 1 AS `TENANT_ID`,
 1 AS `PROCESSDEPTCODE`,
 1 AS `PROCESSDEPTNAME`,
 1 AS `PROCESSDEPTNAME2`,
 1 AS `KEEPINGMETHOD`,
 1 AS `KEEPINGPLACE`,
 1 AS `DISPLAYRECTRASTIME`,
 1 AS `DELFLAG`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `svtaskclass`
--

/*!50001 DROP VIEW IF EXISTS `svtaskclass`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ezEKP2017`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `svtaskclass` AS select `tbl_taskcategory`.`CATEGORYCODE` AS `CATEGORYCODE`,`tbl_taskcategory`.`NAME` AS `CNAME`,`tbl_taskcategory`.`NAME2` AS `CNAME2`,`tbl_taskmiddlecategory`.`MCATEGORYCODE` AS `MCATEGORYCODE`,`tbl_taskmiddlecategory`.`NAME` AS `MCNAME`,`tbl_taskmiddlecategory`.`NAME2` AS `MCNAME2`,`tbl_tasksubcategory`.`SUBCATEGORYCODE` AS `SUBCATEGORYCODE`,`tbl_tasksubcategory`.`NAME` AS `SCNAME`,`tbl_tasksubcategory`.`NAME2` AS `SCNAME2`,`tbl_taskcode`.`TASKCODE` AS `TASKCODE`,`tbl_taskcode`.`TASKNAME` AS `TASKNAME`,`tbl_taskcode`.`TASKNAME2` AS `TASKNAME2`,`tbl_taskcode`.`KEEPINGPERIOD` AS `KEEPINGPERIOD`,`tbl_taskcode`.`DISPLAYRECFLAG` AS `DISPLAYRECFLAG`,`tbl_taskcode`.`SPECIALCATALOGFLAG` AS `SPECIALCATALOGFLAG`,`tbl_taskcode`.`TEMPFLAG` AS `TEMPFLAG`,`tbl_taskcode`.`COMPANYID` AS `COMPANYID`,`tbl_taskcode`.`TENANT_ID` AS `TENANT_ID`,`tbl_task_deptinfo`.`PROCESSDEPTCODE` AS `PROCESSDEPTCODE`,`tbl_task_deptinfo`.`PROCESSDEPTNAME` AS `PROCESSDEPTNAME`,`tbl_task_deptinfo`.`PROCESSDEPTNAME2` AS `PROCESSDEPTNAME2`,`tbl_taskcode`.`KEEPINGMETHOD` AS `KEEPINGMETHOD`,`tbl_taskcode`.`KEEPINGPLACE` AS `KEEPINGPLACE`,`tbl_taskcode`.`DISPLAYRECTRASTIME` AS `DISPLAYRECTRASTIME`,`tbl_taskcode`.`ISPUBLIC` AS `ISPUBLIC`,`tbl_taskcode`.`ITEMSECURITY` AS `ITEMSECURITY`,`tbl_task_deptinfo`.`DELFLAG` AS `DELFLAG` from ((((`tbl_taskcategory` join `tbl_taskmiddlecategory` on(`tbl_taskcategory`.`CATEGORYCODE` = `tbl_taskmiddlecategory`.`CATEGORYCODE` and `tbl_taskcategory`.`TENANT_ID` = `tbl_taskmiddlecategory`.`TENANT_ID` and `tbl_taskcategory`.`COMPANYID` = `tbl_taskmiddlecategory`.`COMPANYID`)) join `tbl_tasksubcategory` on(`tbl_taskmiddlecategory`.`MCATEGORYCODE` = `tbl_tasksubcategory`.`MCATEGORYCODE` and `tbl_taskmiddlecategory`.`TENANT_ID` = `tbl_tasksubcategory`.`TENANT_ID` and `tbl_taskmiddlecategory`.`COMPANYID` = `tbl_tasksubcategory`.`COMPANYID`)) join `tbl_taskcode` on(`tbl_tasksubcategory`.`SUBCATEGORYCODE` = `tbl_taskcode`.`SUBCATEGORYCODE` and `tbl_tasksubcategory`.`TENANT_ID` = `tbl_taskcode`.`TENANT_ID` and `tbl_tasksubcategory`.`COMPANYID` = `tbl_taskcode`.`COMPANYID`)) left join `tbl_task_deptinfo` on(`tbl_taskcode`.`TASKCODE` = `tbl_task_deptinfo`.`TASKCODE` and `tbl_taskcode`.`TENANT_ID` = `tbl_task_deptinfo`.`TENANT_ID` and `tbl_taskcode`.`COMPANYID` = `tbl_task_deptinfo`.`COMPANYID`)) where `tbl_task_deptinfo`.`DELFLAG` = '0' or `tbl_task_deptinfo`.`DELFLAG` is null or `tbl_task_deptinfo`.`DELFLAG` = '2' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vaprdoingdoclist`
--

/*!50001 DROP VIEW IF EXISTS `vaprdoingdoclist`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ezEKP2017`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vaprdoingdoclist` AS select `tbl_aprdocinfo`.`DOCID` AS `DOCID`,`tbl_aprdocinfo`.`FORMID` AS `FORMID`,`tbl_aprdocinfo`.`ORGDOCID` AS `ORGDOCID`,`tbl_aprdocinfo`.`DOCTYPE` AS `DOCTYPE`,case when `tbl_aprlineinfo`.`APRSTATE` = '000' then '017' else `tbl_aprdocinfo`.`DOCSTATE` end AS `DOCSTATE`,case when (`tbl_aprlineinfo`.`APRSTATE` = '000' and `tbl_aprdocinfo`.`FUNCTIONTYPE` <> '004') then '002' else `tbl_aprdocinfo`.`FUNCTIONTYPE` end AS `FUNCTIONTYPE`,`tbl_aprdocinfo`.`HREF` AS `HREF`,`tbl_aprdocinfo`.`DOCTITLE` AS `DOCTITLE`,`tbl_aprdocinfo`.`DOCNO` AS `DOCNO`,`tbl_aprdocinfo`.`HASATTACHYN` AS `HASATTACHYN`,`tbl_aprdocinfo`.`HASOPINIONYN` AS `HASOPINIONYN`,`tbl_aprdocinfo`.`STARTDATE` AS `STARTDATE`,`tbl_aprdocinfo`.`ENDDATE` AS `ENDDATE`,`tbl_aprdocinfo`.`WRITERID` AS `WRITERID`,`tbl_aprdocinfo`.`WRITERNAME` AS `WRITERNAME`,`tbl_aprdocinfo`.`WRITERJOBTITLE` AS `WRITERJOBTITLE`,`tbl_aprdocinfo`.`WRITERDEPTID` AS `WRITERDEPTID`,`tbl_aprdocinfo`.`WRITERDEPTNAME` AS `WRITERDEPTNAME`,`tbl_aprdocinfo`.`ISPUBLIC` AS `ISPUBLIC`,`tbl_aprdocinfo`.`WRITERNAME2` AS `WRITERNAME2`,`tbl_aprdocinfo`.`WRITERJOBTITLE2` AS `WRITERJOBTITLE2`,`tbl_aprdocinfo`.`WRITERDEPTNAME2` AS `WRITERDEPTNAME2`,`tbl_aprdocinfo`.`TENANT_ID` AS `TENANT_ID`,`tbl_aprdocinfo`.`COMPANYID` AS `COMPANYID`,`tbl_aprlineinfo`.`APRMEMBERSN` AS `APRMEMBERSN`,`tbl_aprlineinfo`.`APRTYPE` AS `APRTYPE`,`tbl_aprlineinfo`.`APRSTATE` AS `APRSTATE`,`tbl_aprlineinfo`.`APRMEMBERID` AS `APRMEMBERID`,`tbl_aprlineinfo`.`APRMEMBERNAME` AS `APRMEMBERNAME`,`tbl_aprlineinfo`.`APRMEMBERNAME2` AS `APRMEMBERNAME2`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE` AS `APRMEMBERJOBTITLE`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE2` AS `APRMEMBERJOBTITLE2`,`tbl_aprlineinfo`.`APRMEMBERDEPTID` AS `APRMEMBERDEPTID`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME` AS `APRMEMBERDEPTNAME`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME2` AS `APRMEMBERDEPTNAME2`,`tbl_aprlineinfo`.`RECEIVEDDATE` AS `RECEIVEDDATE`,`tbl_expaprdocinfo`.`FORMNAME` AS `FORMNAME`,`tbl_expaprdocinfo`.`FORMNAME2` AS `FORMNAME2`,`tbl_expaprdocinfo`.`URGENTAPPROVAL` AS `URGENTAPPROVAL`,`tbl_deptmaster`.`EXTENSIONATTRIBUTE3` AS `companyName`,`tbl_deptmaster`.`COMPNM2` AS `companyName2` from (((`tbl_aprdocinfo` join `tbl_aprlineinfo` on(`tbl_aprdocinfo`.`DOCID` = `tbl_aprlineinfo`.`DOCID` and `tbl_aprdocinfo`.`TENANT_ID` = `tbl_aprlineinfo`.`TENANT_ID` and `tbl_aprdocinfo`.`COMPANYID` = `tbl_aprlineinfo`.`COMPANYID`)) join `tbl_expaprdocinfo` on(`tbl_aprdocinfo`.`DOCID` = `tbl_expaprdocinfo`.`DOCID` and `tbl_aprdocinfo`.`TENANT_ID` = `tbl_expaprdocinfo`.`TENANT_ID` and `tbl_aprdocinfo`.`COMPANYID` = `tbl_expaprdocinfo`.`COMPANYID`)) join `tbl_deptmaster` on(`tbl_aprdocinfo`.`COMPANYID` = `tbl_deptmaster`.`CN` and `tbl_aprdocinfo`.`TENANT_ID` = `tbl_deptmaster`.`TENANT_ID`)) where (`tbl_aprlineinfo`.`APRSTATE` = '002' or `tbl_aprlineinfo`.`APRSTATE` = '005' or `tbl_aprlineinfo`.`APRSTATE` = '000') and `tbl_aprdocinfo`.`STARTDATE` is not null */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vaprwilldoclist`
--

/*!50001 DROP VIEW IF EXISTS `vaprwilldoclist`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ezEKP2017`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vaprwilldoclist` AS select `tbl_aprdocinfo`.`DOCID` AS `DOCID`,`tbl_aprdocinfo`.`FORMID` AS `FORMID`,`tbl_aprdocinfo`.`ORGDOCID` AS `ORGDOCID`,`tbl_aprdocinfo`.`DOCTYPE` AS `DOCTYPE`,`tbl_aprdocinfo`.`DOCSTATE` AS `DOCSTATE`,`tbl_aprdocinfo`.`FUNCTIONTYPE` AS `FUNCTIONTYPE`,`tbl_aprdocinfo`.`HREF` AS `HREF`,`tbl_aprdocinfo`.`DOCTITLE` AS `DOCTITLE`,`tbl_aprdocinfo`.`DOCNO` AS `DOCNO`,`tbl_aprdocinfo`.`HASATTACHYN` AS `HASATTACHYN`,`tbl_aprdocinfo`.`HASOPINIONYN` AS `HASOPINIONYN`,`tbl_aprdocinfo`.`STARTDATE` AS `STARTDATE`,`tbl_aprdocinfo`.`ENDDATE` AS `ENDDATE`,`tbl_aprdocinfo`.`WRITERID` AS `WRITERID`,`tbl_aprdocinfo`.`WRITERNAME` AS `WRITERNAME`,`tbl_aprdocinfo`.`WRITERJOBTITLE` AS `WRITERJOBTITLE`,`tbl_aprdocinfo`.`WRITERDEPTID` AS `WRITERDEPTID`,`tbl_aprdocinfo`.`WRITERDEPTNAME` AS `WRITERDEPTNAME`,`tbl_aprdocinfo`.`ISPUBLIC` AS `ISPUBLIC`,`tbl_aprdocinfo`.`WRITERNAME2` AS `WRITERNAME2`,`tbl_aprdocinfo`.`WRITERJOBTITLE2` AS `WRITERJOBTITLE2`,`tbl_aprdocinfo`.`WRITERDEPTNAME2` AS `WRITERDEPTNAME2`,`tbl_aprdocinfo`.`TENANT_ID` AS `TENANT_ID`,`tbl_aprdocinfo`.`COMPANYID` AS `COMPANYID`,`tbl_aprlineinfo`.`APRMEMBERSN` AS `APRMEMBERSN`,`tbl_aprlineinfo`.`APRTYPE` AS `APRTYPE`,`tbl_aprlineinfo`.`APRSTATE` AS `APRSTATE`,`tbl_aprlineinfo`.`APRMEMBERID` AS `APRMEMBERID`,`tbl_aprlineinfo`.`APRMEMBERNAME` AS `APRMEMBERNAME`,`tbl_aprlineinfo`.`APRMEMBERNAME2` AS `APRMEMBERNAME2`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE` AS `APRMEMBERJOBTITLE`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE2` AS `APRMEMBERJOBTITLE2`,`tbl_aprlineinfo`.`APRMEMBERDEPTID` AS `APRMEMBERDEPTID`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME` AS `APRMEMBERDEPTNAME`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME2` AS `APRMEMBERDEPTNAME2`,`tbl_expaprdocinfo`.`FORMNAME` AS `FORMNAME`,`tbl_expaprdocinfo`.`FORMNAME2` AS `FORMNAME2`,`tbl_expaprdocinfo`.`URGENTAPPROVAL` AS `URGENTAPPROVAL`,`tbl_deptmaster`.`EXTENSIONATTRIBUTE3` AS `companyName`,`tbl_deptmaster`.`COMPNM2` AS `companyName2` from (((`tbl_aprdocinfo` join `tbl_aprlineinfo` on(`tbl_aprdocinfo`.`DOCID` = `tbl_aprlineinfo`.`DOCID` and `tbl_aprdocinfo`.`TENANT_ID` = `tbl_aprlineinfo`.`TENANT_ID` and `tbl_aprdocinfo`.`COMPANYID` = `tbl_aprlineinfo`.`COMPANYID`)) join `tbl_expaprdocinfo` on(`tbl_aprdocinfo`.`DOCID` = `tbl_expaprdocinfo`.`DOCID` and `tbl_aprdocinfo`.`TENANT_ID` = `tbl_expaprdocinfo`.`TENANT_ID` and `tbl_aprdocinfo`.`COMPANYID` = `tbl_expaprdocinfo`.`COMPANYID`)) join `tbl_deptmaster` on(`tbl_aprdocinfo`.`COMPANYID` = `tbl_deptmaster`.`CN` and `tbl_aprdocinfo`.`TENANT_ID` = `tbl_deptmaster`.`TENANT_ID`)) where `tbl_aprdocinfo`.`STARTDATE` is not null */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vendchamjodocinfo`
--

/*!50001 DROP VIEW IF EXISTS `vendchamjodocinfo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ezEKP2017`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vendchamjodocinfo` AS select `tbl_endaprdocinfo`.`DOCID` AS `DOCID`,`tbl_endaprdocinfo`.`FORMID` AS `FORMID`,`tbl_endaprdocinfo`.`ORGDOCID` AS `ORGDOCID`,`tbl_endaprdocinfo`.`DOCTYPE` AS `DOCTYPE`,'017' AS `DOCSTATE`,'002' AS `FUNCTIONTYPE`,`tbl_endaprdocinfo`.`HREF` AS `HREF`,`tbl_endaprdocinfo`.`DOCTITLE` AS `DOCTITLE`,`tbl_endaprdocinfo`.`DOCNO` AS `DOCNO`,`tbl_endaprdocinfo`.`HASATTACHYN` AS `HASATTACHYN`,`tbl_endaprdocinfo`.`HASOPINIONYN` AS `HASOPINIONYN`,`tbl_endaprdocinfo`.`STARTDATE` AS `STARTDATE`,`tbl_endaprdocinfo`.`ENDDATE` AS `ENDDATE`,`tbl_endaprdocinfo`.`WRITERID` AS `WRITERID`,`tbl_endaprdocinfo`.`WRITERNAME` AS `WRITERNAME`,`tbl_endaprdocinfo`.`WRITERJOBTITLE` AS `WRITERJOBTITLE`,`tbl_endaprdocinfo`.`WRITERDEPTID` AS `WRITERDEPTID`,`tbl_endaprdocinfo`.`WRITERDEPTNAME` AS `WRITERDEPTNAME`,`tbl_endaprdocinfo`.`ISPUBLIC` AS `ISPUBLIC`,`tbl_endaprdocinfo`.`WRITERNAME2` AS `WRITERNAME2`,`tbl_endaprdocinfo`.`WRITERJOBTITLE2` AS `WRITERJOBTITLE2`,`tbl_endaprdocinfo`.`WRITERDEPTNAME2` AS `WRITERDEPTNAME2`,`tbl_endaprdocinfo`.`TENANT_ID` AS `TENANT_ID`,`tbl_endaprdocinfo`.`COMPANYID` AS `COMPANYID`,`tbl_endaprlineinfo`.`APRMEMBERSN` AS `APRMEMBERSN`,`tbl_endaprlineinfo`.`APRTYPE` AS `APRTYPE`,`tbl_endaprlineinfo`.`APRSTATE` AS `APRSTATE`,`tbl_endaprlineinfo`.`APRMEMBERID` AS `APRMEMBERID`,`tbl_endaprlineinfo`.`APRMEMBERNAME` AS `APRMEMBERNAME`,`tbl_endaprlineinfo`.`APRMEMBERNAME2` AS `APRMEMBERNAME2`,`tbl_endaprlineinfo`.`APRMEMBERJOBTITLE` AS `APRMEMBERJOBTITLE`,`tbl_endaprlineinfo`.`APRMEMBERJOBTITLE2` AS `APRMEMBERJOBTITLE2`,`tbl_endaprlineinfo`.`APRMEMBERDEPTID` AS `APRMEMBERDEPTID`,`tbl_endaprlineinfo`.`APRMEMBERDEPTNAME` AS `APRMEMBERDEPTNAME`,`tbl_endaprlineinfo`.`APRMEMBERDEPTNAME2` AS `APRMEMBERDEPTNAME2`,`tbl_endaprlineinfo`.`RECEIVEDDATE` AS `RECEIVEDDATE`,`tbl_expendaprdocinfo`.`FORMNAME` AS `FORMNAME`,`tbl_expendaprdocinfo`.`FORMNAME2` AS `FORMNAME2`,`tbl_expendaprdocinfo`.`URGENTAPPROVAL` AS `URGENTAPPROVAL`,`tbl_deptmaster`.`EXTENSIONATTRIBUTE3` AS `companyName`,`tbl_deptmaster`.`COMPNM2` AS `companyName2` from (((`tbl_endaprdocinfo` join `tbl_endaprlineinfo` on(`tbl_endaprdocinfo`.`DOCID` = `tbl_endaprlineinfo`.`DOCID` and `tbl_endaprdocinfo`.`TENANT_ID` = `tbl_endaprlineinfo`.`TENANT_ID` and `tbl_endaprdocinfo`.`COMPANYID` = `tbl_endaprlineinfo`.`COMPANYID`)) join `tbl_expendaprdocinfo` on(`tbl_endaprdocinfo`.`DOCID` = `tbl_expendaprdocinfo`.`DOCID` and `tbl_endaprdocinfo`.`TENANT_ID` = `tbl_expendaprdocinfo`.`TENANT_ID` and `tbl_endaprdocinfo`.`COMPANYID` = `tbl_expendaprdocinfo`.`COMPANYID`)) join `tbl_deptmaster` on(`tbl_endaprdocinfo`.`COMPANYID` = `tbl_deptmaster`.`CN` and `tbl_endaprdocinfo`.`TENANT_ID` = `tbl_deptmaster`.`TENANT_ID`)) where `tbl_endaprlineinfo`.`APRSTATE` <> '002' and `tbl_endaprlineinfo`.`APRSTATE` <> '005' and `tbl_endaprlineinfo`.`APRSTATE` = '000' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vgongramaprdoingdoclist`
--

/*!50001 DROP VIEW IF EXISTS `vgongramaprdoingdoclist`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ezEKP2017`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vgongramaprdoingdoclist` AS select `tbl_aprdocinfo`.`DOCID` AS `DOCID`,`tbl_aprdocinfo`.`FORMID` AS `FORMID`,`tbl_aprdocinfo`.`ORGDOCID` AS `ORGDOCID`,`tbl_aprdocinfo`.`DOCTYPE` AS `DOCTYPE`,`tbl_aprdocinfo`.`DOCSTATE` AS `DOCSTATE`,`tbl_aprdocinfo`.`FUNCTIONTYPE` AS `FUNCTIONTYPE`,`tbl_aprdocinfo`.`HREF` AS `HREF`,`tbl_aprdocinfo`.`DOCTITLE` AS `DOCTITLE`,`tbl_aprdocinfo`.`DOCNO` AS `DOCNO`,`tbl_aprdocinfo`.`HASATTACHYN` AS `HASATTACHYN`,`tbl_aprdocinfo`.`HASOPINIONYN` AS `HASOPINIONYN`,`tbl_aprdocinfo`.`STARTDATE` AS `STARTDATE`,`tbl_aprdocinfo`.`ENDDATE` AS `ENDDATE`,`tbl_aprdocinfo`.`WRITERID` AS `WRITERID`,`tbl_aprdocinfo`.`WRITERNAME` AS `WRITERNAME`,`tbl_aprdocinfo`.`WRITERJOBTITLE` AS `WRITERJOBTITLE`,`tbl_aprdocinfo`.`WRITERDEPTID` AS `WRITERDEPTID`,`tbl_aprdocinfo`.`WRITERDEPTNAME` AS `WRITERDEPTNAME`,`tbl_aprdocinfo`.`ISPUBLIC` AS `ISPUBLIC`,`tbl_aprdocinfo`.`WRITERNAME2` AS `WRITERNAME2`,`tbl_aprdocinfo`.`WRITERJOBTITLE2` AS `WRITERJOBTITLE2`,`tbl_aprdocinfo`.`WRITERDEPTNAME2` AS `WRITERDEPTNAME2`,`tbl_aprdocinfo`.`TENANT_ID` AS `TENANT_ID`,`tbl_aprdocinfo`.`COMPANYID` AS `COMPANYID`,`tbl_aprlineinfo`.`APRMEMBERSN` AS `APRMEMBERSN`,`tbl_aprlineinfo`.`APRTYPE` AS `APRTYPE`,`tbl_aprlineinfo`.`APRSTATE` AS `APRSTATE`,`tbl_aprlineinfo`.`APRMEMBERID` AS `APRMEMBERID`,`tbl_aprlineinfo`.`APRMEMBERNAME` AS `APRMEMBERNAME`,`tbl_aprlineinfo`.`APRMEMBERNAME2` AS `APRMEMBERNAME2`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE` AS `APRMEMBERJOBTITLE`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE2` AS `APRMEMBERJOBTITLE2`,`tbl_aprlineinfo`.`APRMEMBERDEPTID` AS `APRMEMBERDEPTID`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME` AS `APRMEMBERDEPTNAME`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME2` AS `APRMEMBERDEPTNAME2`,`tbl_aprlineinfo`.`RECEIVEDDATE` AS `RECEIVEDDATE`,`tbl_expaprdocinfo`.`FORMNAME` AS `FORMNAME`,`tbl_expaprdocinfo`.`FORMNAME2` AS `FORMNAME2`,`tbl_expaprdocinfo`.`URGENTAPPROVAL` AS `URGENTAPPROVAL`,`tbl_deptmaster`.`EXTENSIONATTRIBUTE3` AS `companyName`,`tbl_deptmaster`.`COMPNM2` AS `companyName2` from (((`tbl_aprdocinfo` join `tbl_aprlineinfo` on(`tbl_aprdocinfo`.`DOCID` = `tbl_aprlineinfo`.`DOCID` and `tbl_aprdocinfo`.`TENANT_ID` = `tbl_aprlineinfo`.`TENANT_ID` and `tbl_aprdocinfo`.`COMPANYID` = `tbl_aprlineinfo`.`COMPANYID`)) join `tbl_expaprdocinfo` on(`tbl_aprdocinfo`.`DOCID` = `tbl_expaprdocinfo`.`DOCID` and `tbl_aprdocinfo`.`TENANT_ID` = `tbl_expaprdocinfo`.`TENANT_ID` and `tbl_aprdocinfo`.`COMPANYID` = `tbl_expaprdocinfo`.`COMPANYID`)) join `tbl_deptmaster` on(`tbl_aprdocinfo`.`COMPANYID` = `tbl_deptmaster`.`CN` and `tbl_aprdocinfo`.`TENANT_ID` = `tbl_deptmaster`.`TENANT_ID`)) where `tbl_aprlineinfo`.`APRSTATE` = '002' and `tbl_aprdocinfo`.`DOCSTATE` = '015' and `tbl_aprdocinfo`.`STARTDATE` is not null */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_ezapprovalg`
--

/*!50001 DROP VIEW IF EXISTS `view_ezapprovalg`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ezEKP2017`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `view_ezapprovalg` AS select `a`.`DOCID` AS `docid`,`a`.`DOCNO` AS `docno`,`a`.`DOCTITLE` AS `doctitle`,`a`.`WRITERDEPTNAME` AS `writerdeptname`,`a`.`WRITERDEPTNAME2` AS `writerdeptname2`,`a`.`WRITERNAME` AS `writername`,`a`.`WRITERNAME2` AS `writername2`,`a`.`STARTDATE` AS `StartDate`,`a`.`ENDDATE` AS `EndDate`,`a`.`HASATTACHYN` AS `hasattachyn`,concat('/volumes/shared/ezFlow',`a`.`HREF`) AS `ContentsPath`,`a`.`HREF` AS `href`,`a`.`FORMID` AS `formid`,`d`.`FORMNAME` AS `formname`,`d`.`FORMNAME2` AS `formname2`,`a`.`CONTAINERID` AS `containerid`,ifnull(`x`.`KEYWORD`,'') AS `KeyWord`,`e`.`APRMEMBERDEPTID` AS `WriterDeptID`,`a`.`TENANT_ID` AS `TENANT_ID`,`a`.`COMPANYID` AS `COMPANYID` from ((((`tbl_endaprdocinfo` `a` join `tbl_container` `c` on(`a`.`CONTAINERID` = `c`.`CONTAINERID` and `a`.`TENANT_ID` = `c`.`TENANT_ID` and `a`.`COMPANYID` = `c`.`COMPANYID`)) join `tbl_expendaprdocinfo` `x` on(`a`.`DOCID` = `x`.`DOCID` and `a`.`TENANT_ID` = `x`.`TENANT_ID` and `a`.`COMPANYID` = `x`.`COMPANYID`)) left join `tbl_forminfo` `d` on(`d`.`FORMID` = `a`.`FORMID` and `d`.`TENANT_ID` = `a`.`TENANT_ID` and `d`.`COMPANYID` = `a`.`COMPANYID`)) join `tbl_endaprlineinfo` `e` on(`a`.`DOCID` = `e`.`DOCID` and `a`.`TENANT_ID` = `e`.`TENANT_ID` and `a`.`COMPANYID` = `e`.`COMPANYID`)) where `e`.`APRMEMBERSN` = 1 and `a`.`CONTAINERID` <> '9999999999' union all select `a`.`DOCID` AS `docid`,`a`.`DOCNO` AS `docno`,`a`.`DOCTITLE` AS `doctitle`,`a`.`WRITERDEPTNAME` AS `writerdeptname`,`a`.`WRITERDEPTNAME2` AS `writerdeptname2`,`a`.`WRITERNAME` AS `writername`,`a`.`WRITERNAME2` AS `writername2`,`a`.`STARTDATE` AS `StartDate`,`a`.`ENDDATE` AS `EndDate`,`a`.`HASATTACHYN` AS `hasattachyn`,concat('/volumes/shared/ezFlow',`a`.`HREF`) AS `ContentsPath`,`a`.`HREF` AS `href`,`a`.`FORMID` AS `formid`,`d`.`FORMNAME` AS `formname`,`d`.`FORMNAME2` AS `formname2`,'' AS `containerid`,ifnull(`x`.`KEYWORD`,'') AS `KeyWord`,'' AS `WriterDeptID`,`a`.`TENANT_ID` AS `TENANT_ID`,`a`.`COMPANYID` AS `COMPANYID` from (((`tbl_aprdocinfo` `a` join `tbl_aprlineinfo` `b` on(`a`.`DOCID` = `b`.`DOCID` and `a`.`TENANT_ID` = `b`.`TENANT_ID` and `a`.`COMPANYID` = `b`.`COMPANYID`)) join `tbl_expaprdocinfo` `x` on(`a`.`DOCID` = `x`.`DOCID` and `a`.`TENANT_ID` = `x`.`TENANT_ID` and `a`.`COMPANYID` = `x`.`COMPANYID`)) left join `tbl_forminfo` `d` on(`d`.`FORMID` = `a`.`FORMID` and `d`.`TENANT_ID` = `a`.`TENANT_ID` and `d`.`COMPANYID` = `a`.`COMPANYID`)) where `b`.`APRSTATE` = '010' and `b`.`APRTYPE` = '015' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_ezboardstd`
--

/*!50001 DROP VIEW IF EXISTS `view_ezboardstd`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ezEKP2017`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `view_ezboardstd` AS select `b`.`ITEMID` AS `ITEMID`,`a`.`BOARDNAME` AS `BOARDNAME`,`a`.`BOARDNAME2` AS `BOARDNAME2`,`a`.`GUBUN` AS `GUBUN`,`b`.`TITLE` AS `title`,`b`.`WRITERDEPTNAME` AS `WRITERDEPTNAME`,`b`.`WRITERNAME` AS `WRITERNAME`,`b`.`WRITEDATE` AS `WRITEDATE`,`b`.`ATTACHMENTS` AS `ATTACHMENTS`,`b`.`BOARDID` AS `BOARDID`,`b`.`WRITERID` AS `WRITERID`,`b`.`CONTENTLOCATION` AS `Herf`,concat('/volumes/shared/ezFlow',`b`.`CONTENTLOCATION`) AS `CONTENTLOCATION`,`b`.`WRITERDEPTID` AS `WRITERDEPTID`,`a`.`TENANT_ID` AS `TENANT_ID`,`a`.`COMPANYID` AS `COMPANYID` from (`tbl_board_boardinfo` `a` join `tbl_board_item` `b` on(`a`.`BOARDID` = `b`.`BOARDID` and `a`.`TENANT_ID` = `b`.`TENANT_ID`)) where `b`.`APPRFLAG` <> 'C' and `b`.`APPRFLAG` <> 'N' or `b`.`APPRFLAG` is null */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vtaskclass`
--

/*!50001 DROP VIEW IF EXISTS `vtaskclass`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ezEKP2017`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `vtaskclass` AS select `tbl_taskcategory`.`CATEGORYCODE` AS `CATEGORYCODE`,`tbl_taskcategory`.`NAME` AS `CNAME`,`tbl_taskcategory`.`NAME2` AS `CNAME2`,`tbl_taskmiddlecategory`.`MCATEGORYCODE` AS `MCATEGORYCODE`,`tbl_taskmiddlecategory`.`NAME` AS `MCNAME`,`tbl_taskmiddlecategory`.`NAME2` AS `MCNAME2`,`tbl_tasksubcategory`.`SUBCATEGORYCODE` AS `SUBCATEGORYCODE`,`tbl_tasksubcategory`.`NAME` AS `SCNAME`,`tbl_tasksubcategory`.`NAME2` AS `SCNAME2`,`tbl_taskcode`.`TASKCODE` AS `TASKCODE`,`tbl_taskcode`.`TASKNAME` AS `TASKNAME`,`tbl_taskcode`.`TASKNAME2` AS `TASKNAME2`,`tbl_taskcode`.`KEEPINGPERIOD` AS `KEEPINGPERIOD`,`tbl_taskcode`.`DISPLAYRECFLAG` AS `DISPLAYRECFLAG`,`tbl_taskcode`.`SPECIALCATALOGFLAG` AS `SPECIALCATALOGFLAG`,`tbl_taskcode`.`SC1` AS `SC1`,`tbl_taskcode`.`SC2` AS `SC2`,`tbl_taskcode`.`SC3` AS `SC3`,`tbl_taskcode`.`TEMPFLAG` AS `TEMPFLAG`,`tbl_taskcode`.`COMPANYID` AS `COMPANYID`,`tbl_taskcode`.`TENANT_ID` AS `TENANT_ID`,`tbl_task_deptinfo`.`PROCESSDEPTCODE` AS `PROCESSDEPTCODE`,`tbl_task_deptinfo`.`PROCESSDEPTNAME` AS `PROCESSDEPTNAME`,`tbl_task_deptinfo`.`PROCESSDEPTNAME2` AS `PROCESSDEPTNAME2`,`tbl_taskcode`.`KEEPINGMETHOD` AS `KEEPINGMETHOD`,`tbl_taskcode`.`KEEPINGPLACE` AS `KEEPINGPLACE`,`tbl_taskcode`.`DISPLAYRECTRASTIME` AS `DISPLAYRECTRASTIME`,`tbl_task_deptinfo`.`DELFLAG` AS `DELFLAG` from ((((`tbl_taskcategory` join `tbl_taskmiddlecategory` on(`tbl_taskcategory`.`CATEGORYCODE` = `tbl_taskmiddlecategory`.`CATEGORYCODE` and `tbl_taskcategory`.`TENANT_ID` = `tbl_taskmiddlecategory`.`TENANT_ID` and `tbl_taskcategory`.`COMPANYID` = `tbl_taskmiddlecategory`.`COMPANYID`)) join `tbl_tasksubcategory` on(`tbl_taskmiddlecategory`.`MCATEGORYCODE` = `tbl_tasksubcategory`.`MCATEGORYCODE` and `tbl_taskmiddlecategory`.`TENANT_ID` = `tbl_tasksubcategory`.`TENANT_ID` and `tbl_taskmiddlecategory`.`COMPANYID` = `tbl_tasksubcategory`.`COMPANYID`)) join `tbl_taskcode` on(`tbl_tasksubcategory`.`SUBCATEGORYCODE` = `tbl_taskcode`.`SUBCATEGORYCODE` and `tbl_tasksubcategory`.`TENANT_ID` = `tbl_taskcode`.`TENANT_ID` and `tbl_tasksubcategory`.`COMPANYID` = `tbl_taskcode`.`COMPANYID` and `tbl_taskcode`.`DELFLAG` = '0')) left join `tbl_task_deptinfo` on(`tbl_taskcode`.`TASKCODE` = `tbl_task_deptinfo`.`TASKCODE` and `tbl_taskcode`.`TENANT_ID` = `tbl_task_deptinfo`.`TENANT_ID` and `tbl_taskcode`.`COMPANYID` = `tbl_task_deptinfo`.`COMPANYID`)) where `tbl_task_deptinfo`.`DELFLAG` = '0' or `tbl_task_deptinfo`.`DELFLAG` is null or `tbl_task_deptinfo`.`DELFLAG` = '2' */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-09-20 10:57:27
