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
  `MAIL_BLOB_ID` bigint(20) NOT NULL,
  `MAIL_BYTES` longblob NOT NULL,
  `MAIL_BODY_STRUCTURE` varchar(4000) DEFAULT NULL,
  `HEADER_BYTES` mediumblob NOT NULL,
  `MAILBOX_ID` bigint(20) DEFAULT NULL,
  `MAIL_UID` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`MAIL_BLOB_ID`),
  KEY `INDEX_MESSAGE_BLOB_MSG_ID` (`MAIL_BLOB_ID`),
  KEY `MAILBOX_ID` (`MAILBOX_ID`,`MAIL_UID`),
  CONSTRAINT `james_mail_blob_ibfk_1` FOREIGN KEY (`MAILBOX_ID`, `MAIL_UID`) REFERENCES `james_mail` (`MAILBOX_ID`, `MAIL_UID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `james_mail_property`
--

DROP TABLE IF EXISTS `james_mail_property`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_mail_property` (
  `PROPERTY_ID` bigint(20) NOT NULL,
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
-- Table structure for table `james_mail_userflag`
--

DROP TABLE IF EXISTS `james_mail_userflag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `james_mail_userflag` (
  `USERFLAG_ID` bigint(20) NOT NULL,
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
  `MAILBOX_NAME` varchar(200) NOT NULL,
  `MAILBOX_NAMESPACE` varchar(200) NOT NULL,
  `MAILBOX_UID_VALIDITY` bigint(20) NOT NULL,
  `USER_NAME` varchar(200) NOT NULL,
  PRIMARY KEY (`MAILBOX_ID`),
  KEY `I_JMS_LBX_USER_NAME` (`USER_NAME`)
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
  `TARGET_ADDRESS` varchar(4000) NOT NULL,
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
  `MAILBOX_NAME` varchar(100) NOT NULL,
  `USER_NAME` varchar(100) NOT NULL,
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
  `folder_name` varchar(100) DEFAULT NULL,
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
  `create_date` datetime DEFAULT NULL,
  `modifier_id` varchar(100) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  `s_name` varchar(100) DEFAULT NULL,
  `s_email` varchar(100) DEFAULT NULL,
  `s_company` varchar(50) DEFAULT NULL,
  `s_dept` varchar(50) DEFAULT NULL,
  `s_title` varchar(50) DEFAULT NULL,
  `s_company_phone` varchar(20) DEFAULT NULL,
  `s_fax` varchar(20) DEFAULT NULL,
  `s_mobile` varchar(20) DEFAULT NULL,
  `s_homepage` varchar(200) DEFAULT NULL,
  `s_company_zip` varchar(10) DEFAULT NULL,
  `s_company_addr` varchar(200) DEFAULT NULL,
  `s_home_zip` varchar(10) DEFAULT NULL,
  `s_home_addr` varchar(200) DEFAULT NULL,
  `s_memo` varchar(20000) DEFAULT NULL,
  `s_type` char(1) DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  KEY `owner_id` (`owner_id`,`s_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `simple_name` varchar(100) DEFAULT NULL,
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
  `MAX_STORAGE` double DEFAULT '0',
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
  `CN` varchar(20) NOT NULL,
  `DISPLAYNAME` varchar(50) NOT NULL,
  `DISPLAYNAME2` varchar(50) DEFAULT NULL,
  `USEFLAG` varchar(1) DEFAULT NULL,
  `MAIL` varchar(50) DEFAULT NULL,
  `COMPNM2` varchar(50) DEFAULT NULL,
  `DEPTLEVEL` varchar(3) DEFAULT NULL,
  `DEPT_CD_PATH` varchar(200) DEFAULT NULL,
  `DEPT_NM_PATH` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(200) DEFAULT NULL,
  `ADFLAG` varchar(1) DEFAULT NULL,
  `ADSPATH` varchar(200) DEFAULT NULL,
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
  `GROUP_NAME` varchar(100) NOT NULL,
  PRIMARY KEY (`DOMAIN_NAME`,`GROUP_NAME`,`USER_NAME`),
  KEY `foreign_keys_index` (`DOMAIN_NAME`,`USER_NAME`),
  CONSTRAINT `distribution_foreign_keys` FOREIGN KEY (`DOMAIN_NAME`, `USER_NAME`) REFERENCES `james_recipient_rewrite` (`DOMAIN_NAME`, `USER_NAME`) ON DELETE CASCADE ON UPDATE CASCADE
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
  `RULE_NAME` varchar(100) NOT NULL,
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
  `VALUE` varchar(10000) DEFAULT NULL,
  PRIMARY KEY (`ITEM_ID`),
  KEY `RULE_ID_idx` (`RULE_ID`),
  CONSTRAINT `RULE_ID` FOREIGN KEY (`RULE_ID`) REFERENCES `jmocha_inbox_rule` (`RULE_ID`) ON DELETE CASCADE ON UPDATE CASCADE
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
-- Table structure for table `jmocha_mail_delete`
--

DROP TABLE IF EXISTS `jmocha_mail_delete`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_mail_delete` (
  `USER_ID` varchar(100) NOT NULL,
  `FOLDER_PATH` varchar(200) NOT NULL,
  `EXPIRE_TIME` int(11) DEFAULT NULL,
  `DELETE_UNREAD` char(1) DEFAULT NULL,
  `FOLDER_NAME` varchar(100) DEFAULT NULL,
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
  `MAIL_SENDER_NAME` varchar(255) DEFAULT NULL,
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
  `INTERNAL` varchar(10000) NOT NULL,
  `EXTERNAL` varchar(10000) NOT NULL,
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
  `save_folder_path` varchar(100) DEFAULT NULL,
  `save_folder_name` varchar(100) DEFAULT NULL,
  `delete_yn` char(1) DEFAULT NULL,
  `ssl_yn` int(11) DEFAULT NULL,
  PRIMARY KEY (`pop3_idx`),
  KEY `pop3_index` (`user_id`,`pop3_server`,`pop3_user_id`(255))
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
  `READER_NAME` varchar(50) DEFAULT NULL,
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
  `subject` varchar(200) DEFAULT NULL,
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
  `SUBJECT` varchar(200) DEFAULT NULL,
  `SEND_DATE` datetime DEFAULT NULL,
  PRIMARY KEY (`MESSAGE_ID`),
  KEY `IDX_RESERVE_USER_ID` (`USER_ID`),
  KEY `IDX_RESERVE_SEND_DATE` (`SEND_DATE`)
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
  `CONTENT1` longtext,
  `CONTENT2` longtext,
  `CONTENT3` longtext,
  PRIMARY KEY (`USER_ID`)
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
-- Table structure for table `jmocha_stat_mail_company_flow_day`
--

DROP TABLE IF EXISTS `jmocha_stat_mail_company_flow_day`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jmocha_stat_mail_company_flow_day` (
  `TENANT_ID` int(11) NOT NULL,
  `DT_DD` varchar(15) NOT NULL,
  `SORGID` varchar(200) NOT NULL,
  `RORGID` varchar(200) NOT NULL,
  `CNT` int(11) DEFAULT '0',
  `MAILSIZE` int(11) DEFAULT '0',
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
  `DT_MM` varchar(15) NOT NULL,
  `SORGID` varchar(200) NOT NULL,
  `RORGID` varchar(200) NOT NULL,
  `CNT` int(11) DEFAULT '0',
  `MAILSIZE` int(11) DEFAULT '0',
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
  `DT_DD` varchar(15) NOT NULL,
  `DEPTID` varchar(200) NOT NULL,
  `ORGID` varchar(200) DEFAULT NULL,
  `RECEIVEINCNT` int(11) DEFAULT '0',
  `RECEIVEINSIZE` int(11) DEFAULT '0',
  `RECEIVEOUTCNT` int(11) DEFAULT '0',
  `RECEIVEOUTSIZE` int(11) DEFAULT '0',
  `SENDINCNT` int(11) DEFAULT '0',
  `SENDINSIZE` int(11) DEFAULT '0',
  `SENDOUTCNT` int(11) DEFAULT '0',
  `SENDOUTSIZE` int(11) DEFAULT '0',
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
  `DT_MM` varchar(15) NOT NULL,
  `DEPTID` varchar(200) NOT NULL,
  `ORGID` varchar(200) DEFAULT NULL,
  `RECEIVEINCNT` int(11) DEFAULT '0',
  `RECEIVEINSIZE` int(11) DEFAULT '0',
  `RECEIVEOUTCNT` int(11) DEFAULT '0',
  `RECEIVEOUTSIZE` int(11) DEFAULT '0',
  `SENDINCNT` int(11) DEFAULT '0',
  `SENDINSIZE` int(11) DEFAULT '0',
  `SENDOUTCNT` int(11) DEFAULT '0',
  `SENDOUTSIZE` int(11) DEFAULT '0',
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
  `SENDER` varchar(100) DEFAULT NULL,
  `RECIPIENT` varchar(100) DEFAULT NULL,
  `TOTALBYTES` int(11) DEFAULT NULL,
  `MESSAGEID` varchar(200) DEFAULT NULL,
  `MESSAGESUBJECT` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`IDX`)
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
  `DT_DD` varchar(15) NOT NULL,
  `USERID` varchar(20) NOT NULL,
  `DEPTID` varchar(200) NOT NULL,
  `ORGID` varchar(200) DEFAULT NULL,
  `RECEIVEINCNT` int(11) DEFAULT '0',
  `RECEIVEINSIZE` int(11) DEFAULT '0',
  `RECEIVEOUTCNT` int(11) DEFAULT '0',
  `RECEIVEOUTSIZE` int(11) DEFAULT '0',
  `SENDINCNT` int(11) DEFAULT '0',
  `SENDINSIZE` int(11) DEFAULT '0',
  `SENDOUTCNT` int(11) DEFAULT '0',
  `SENDOUTSIZE` int(11) DEFAULT '0',
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
  `DT_MM` varchar(15) NOT NULL,
  `USERID` varchar(20) NOT NULL,
  `DEPTID` varchar(200) NOT NULL,
  `ORGID` varchar(200) DEFAULT NULL,
  `RECEIVEINCNT` int(11) DEFAULT '0',
  `RECEIVEINSIZE` int(11) DEFAULT '0',
  `RECEIVEOUTCNT` int(11) DEFAULT '0',
  `RECEIVEOUTSIZE` int(11) DEFAULT '0',
  `SENDINCNT` int(11) DEFAULT '0',
  `SENDINSIZE` int(11) DEFAULT '0',
  `SENDOUTCNT` int(11) DEFAULT '0',
  `SENDOUTSIZE` int(11) DEFAULT '0',
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
  `DT_MM` varchar(15) NOT NULL,
  `QTY` int(11) DEFAULT '0',
  `ALLOT` int(11) DEFAULT '0',
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
  `CN` varchar(20) NOT NULL,
  `DISPLAYNAME` varchar(60) NOT NULL,
  `DISPLAYNAME2` varchar(60) DEFAULT NULL,
  `MAIL` varchar(50) DEFAULT NULL,
  `MAILNICKNAME` varchar(50) DEFAULT NULL,
  `UPNNAME` varchar(100) DEFAULT NULL,
  `DEPARTMENT` varchar(20) NOT NULL,
  `DESCRIPTION` varchar(100) DEFAULT NULL,
  `DESCRIPTION2` varchar(100) DEFAULT NULL,
  `DESCRIPTION3` varchar(100) DEFAULT NULL,
  `PHYSICALDELIVERYOFFICENAME` varchar(40) DEFAULT NULL,
  `COMPANY` varchar(100) DEFAULT NULL,
  `COMPANY2` varchar(100) DEFAULT NULL,
  `TITLE` varchar(100) DEFAULT NULL,
  `TITLE2` varchar(100) DEFAULT NULL,
  `TELEPHONENUMBER` varchar(50) DEFAULT NULL,
  `HOMEPHONE` varchar(50) DEFAULT NULL,
  `FACSIMILETELEPHONENUMBER` varchar(50) DEFAULT NULL,
  `MOBILE` varchar(50) DEFAULT NULL,
  `POSTALCODE` varchar(50) DEFAULT NULL,
  `STREETADDRESS` varchar(200) DEFAULT NULL,
  `INFO` varchar(1000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(1000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(1000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE102` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(100) DEFAULT NULL,
  `ADSPATH` varchar(100) DEFAULT NULL,
  `SIPURI` varchar(50) DEFAULT NULL,
  `UPDATEDT` datetime NOT NULL,
  `MOBILE_ENABLE` varchar(1) DEFAULT NULL,
  `MOBILE_NOTUSE` varchar(1) DEFAULT 'N',
  `MOBILE_PIN` varchar(1) DEFAULT NULL,
  `POSITIONCD` varchar(10) DEFAULT NULL,
  `BIRTH` varchar(10) DEFAULT NULL,
  `BIRTHTYPE` varchar(1) DEFAULT NULL,
  `PASSWORD` varchar(100) DEFAULT NULL,
  `IPADDRESS` varchar(15) DEFAULT NULL,
  `LASTLOGIN` datetime DEFAULT NULL,
  `LOGINCNT` int(11) DEFAULT '0',
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
  `CN` varchar(20) NOT NULL,
  `DISPLAYNAME` varchar(60) NOT NULL,
  `DISPLAYNAME2` varchar(60) DEFAULT NULL,
  `MAIL` varchar(50) DEFAULT NULL,
  `MAILNICKNAME` varchar(50) DEFAULT NULL,
  `UPNNAME` varchar(100) DEFAULT NULL,
  `DEPARTMENT` varchar(20) NOT NULL,
  `DESCRIPTION` varchar(100) DEFAULT NULL,
  `DESCRIPTION2` varchar(100) DEFAULT NULL,
  `DESCRIPTION3` varchar(100) DEFAULT NULL,
  `PHYSICALDELIVERYOFFICENAME` varchar(40) DEFAULT NULL,
  `COMPANY` varchar(100) DEFAULT NULL,
  `COMPANY2` varchar(100) DEFAULT NULL,
  `TITLE` varchar(100) DEFAULT NULL,
  `TITLE2` varchar(100) DEFAULT NULL,
  `TELEPHONENUMBER` varchar(50) DEFAULT NULL,
  `HOMEPHONE` varchar(50) DEFAULT NULL,
  `FACSIMILETELEPHONENUMBER` varchar(50) DEFAULT NULL,
  `MOBILE` varchar(50) DEFAULT NULL,
  `POSTALCODE` varchar(50) DEFAULT NULL,
  `STREETADDRESS` varchar(200) DEFAULT NULL,
  `INFO` varchar(1000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(1000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE102` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE11` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE12` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE13` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE14` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE15` varchar(100) DEFAULT NULL,
  `ADSPATH` varchar(100) DEFAULT NULL,
  `SIPURI` varchar(50) DEFAULT NULL,
  `UPDATEDT` datetime NOT NULL,
  `MOBILE_ENABLE` varchar(1) DEFAULT NULL,
  `MOBILE_NOTUSE` varchar(1) DEFAULT NULL,
  `MOBILE_PIN` varchar(1) DEFAULT NULL,
  `POSITIONCD` varchar(10) DEFAULT NULL,
  `BIRTH` varchar(10) DEFAULT NULL,
  `BIRTHTYPE` varchar(1) DEFAULT NULL,
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
  `MAX_STORAGE` double DEFAULT '0',
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
-- Table structure for table `tbl_addjobmaster`
--

DROP TABLE IF EXISTS `tbl_addjobmaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_addjobmaster` (
  `CN` varchar(80) NOT NULL,
  `DEPTID` varchar(80) NOT NULL,
  `TITLE` varchar(200) DEFAULT NULL,
  `TITLE2` varchar(200) DEFAULT NULL,
  `POSITIONCD` varchar(40) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`CN`,`DEPTID`)
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
  `MAINNAME` varchar(400) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`MAINID`),
  UNIQUE KEY `IDX_TBL_ADMINRECEIPTGROUP_MAIN` (`TENANT_ID`,`MAINID`)
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
  `DEPTNAME` varchar(200) DEFAULT NULL,
  `COMPANYID` varchar(40) DEFAULT NULL,
  `DEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`SUBID`),
  UNIQUE KEY `IDX_TBL_ADMINRECEIPTGROUP_SUB` (`TENANT_ID`,`SUBID`)
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
  `ATTACHFILENAME` varchar(1020) DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) DEFAULT NULL,
  `ATTACHFILESIZE` double(126,0) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(40) DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(600) DEFAULT NULL,
  `BODYATTACH` varchar(4) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(400) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`ATTACHFILESN`)
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
  `ATTACHDOCNAME` varchar(1020) DEFAULT NULL,
  `ATTACHDOCURL` varchar(1020) DEFAULT NULL,
  `SUBATTACHYN` varchar(4) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`ATTACHSN`)
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
  `DOCTITLE` varchar(1020) DEFAULT NULL,
  `DOCNO` varchar(200) DEFAULT NULL,
  `HASATTACHYN` varchar(4) DEFAULT NULL,
  `HASOPINIONYN` varchar(4) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) DEFAULT NULL,
  `WRITERNAME` varchar(200) DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) DEFAULT NULL,
  `WRITERDEPTID` varchar(400) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(200) DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL,
  `WRITERNAME2` varchar(200) DEFAULT NULL,
  `WRITERJOBTITLE2` varchar(200) DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`APRMEMBERSN`)
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
  `OPINIONGB` varchar(12) DEFAULT NULL,
  `CONTENT` longtext,
  `USERNAME` varchar(200) DEFAULT NULL,
  `USERJOBTITLE` varchar(200) DEFAULT NULL,
  `USERDEPTID` varchar(400) DEFAULT NULL,
  `USERDEPTNAME` varchar(200) DEFAULT NULL,
  `OPINIONSN` bigint(10) NOT NULL,
  `USERNAME2` varchar(200) DEFAULT NULL,
  `USERJOBTITLE2` varchar(200) DEFAULT NULL,
  `USERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`USERID`(255),`OPINIONSN`)
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
  `SENTDEPTNAME` varchar(200) DEFAULT NULL,
  `RECEIVEDDEPTID` varchar(400) NOT NULL,
  `RECEIVEDDEPTNAME` varchar(200) DEFAULT NULL,
  `DOCSTATE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSDOCID` varchar(80) DEFAULT NULL,
  `PROCESSORID` varchar(400) DEFAULT NULL,
  `PROCESSORNAME` varchar(200) DEFAULT NULL,
  `PROCESSORJOBTITLE` varchar(200) DEFAULT NULL,
  `PARENTSDOCID` varchar(80) DEFAULT NULL,
  `SENTDEPTNAME2` varchar(200) DEFAULT NULL,
  `RECEIVEDDEPTNAME2` varchar(200) DEFAULT NULL,
  `PROCESSORNAME2` varchar(200) DEFAULT NULL,
  `PROCESSORJOBTITLE2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`RECEIVESN`,`DOCID`,`RECEIVEDDEPTID`(255))
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
  `ATTENDANTNAME` varchar(100) NOT NULL,
  `ATTENDANTNAME2` varchar(100) DEFAULT NULL,
  `ATTENDANTDEPTNAME` varchar(100) NOT NULL,
  `ATTENDANTDEPTNAME2` varchar(100) DEFAULT NULL,
  `STATUS` mediumint(5) NOT NULL,
  `RESPONSEDATE` datetime NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`SCHEDULEID`,`ATTENDANTID`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`RECORDID`,`SEPERATEATTACHNO`),
  CONSTRAINT `FK_TBL_AUDIO_VISUALRECEXINFO` FOREIGN KEY (`TENANT_ID`, `RECORDID`, `SEPERATEATTACHNO`) REFERENCES `tbl_seperateattach` (`TENANT_ID`, `RECORDID`, `SEPERATEATTACHNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_apprlist`
--

DROP TABLE IF EXISTS `tbl_board_apprlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_apprlist` (
  `BOARDID` varchar(76) NOT NULL,
  `APPRUSERID` varchar(40) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`,`APPRUSERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_boardbackgroundinfo`
--

DROP TABLE IF EXISTS `tbl_board_boardbackgroundinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_boardbackgroundinfo` (
  `BACKGROUNDID` varchar(510) NOT NULL,
  `ORGFILENAME` varchar(510) DEFAULT NULL,
  `SAVEFILENAME` varchar(510) DEFAULT NULL,
  `REGUSERID` varchar(510) DEFAULT NULL,
  `REGDATE` varchar(510) DEFAULT NULL,
  `ISUSE` varchar(510) DEFAULT NULL,
  `SN` varchar(510) DEFAULT NULL,
  `WIDTH` varchar(510) DEFAULT NULL,
  `HEIGHT` varchar(510) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
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
  `BOARDNAME` varchar(510) DEFAULT NULL,
  `BOARDNAME2` varchar(510) DEFAULT NULL,
  `TREEVIEWORDER` int(11) DEFAULT NULL,
  `BOARDLEVEL` int(11) DEFAULT NULL,
  `PARENTBOARDID` varchar(510) DEFAULT NULL,
  `BOARDDESCRIPTION` varchar(510) DEFAULT NULL,
  `ITEMEXPIRES` int(11) DEFAULT NULL,
  `ATTACHSIZELIMIT` varchar(510) DEFAULT NULL,
  `REPLYNOTIFY` int(11) DEFAULT NULL,
  `BOARDGROUPID` varchar(510) DEFAULT NULL,
  `ALERTPOSTITEM` int(11) DEFAULT NULL,
  `GUBUN` int(11) DEFAULT NULL,
  `URL` varchar(510) DEFAULT NULL,
  `DELETEAFTER` int(11) DEFAULT NULL,
  `BOARDCOLOR` varchar(510) DEFAULT NULL,
  `BOARDNO` int(11) DEFAULT NULL,
  `PORTLET` varchar(2) DEFAULT NULL,
  `ONELINEREPLY` varchar(2) DEFAULT NULL,
  `BOARDTREEPATH` varchar(1600) DEFAULT NULL,
  `BACKGROUND` varchar(4) DEFAULT NULL,
  `FORMLOCATION` varchar(400) DEFAULT NULL,
  `FORMFLAG` varchar(4) DEFAULT NULL,
  `APPRFLAG` varchar(4) DEFAULT NULL,
  `APPRMAILFLAG` varchar(4) DEFAULT NULL,
  `ATTRIBUTEYN` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`BOARDID`(255))
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
  `COLNAME1` varchar(100) DEFAULT NULL,
  `COLNAME2` varchar(200) DEFAULT NULL,
  `VALUE` varchar(510) DEFAULT NULL,
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
  `ACCESSNAME` varchar(100) DEFAULT NULL,
  `ACCESSNAME2` varchar(100) DEFAULT NULL,
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
  `PREVIEWWLIST` bigint(10) DEFAULT '0',
  `PREVIEWWCONTENT` bigint(10) DEFAULT '0',
  `PREVIEWHLIST` bigint(10) DEFAULT '0',
  `PREVIEWHCONTENT` bigint(10) DEFAULT '0',
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
  `WRITERID` varchar(40) DEFAULT NULL,
  `WRITERNAME` varchar(40) DEFAULT NULL,
  `WRITERNAME2` varchar(40) DEFAULT NULL,
  `WRITERDEPTID` varchar(40) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(100) DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(100) DEFAULT NULL,
  `WRITERCOMPANYID` varchar(40) DEFAULT NULL,
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
  `UPPERITEMIDTREE` longtext,
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
  `MAINCONTENT` longtext,
  `NOTINO` decimal(19,0) DEFAULT NULL,
  `TOPWRITERID` varchar(40) DEFAULT NULL,
  `APPRFLAG` varchar(4) DEFAULT NULL,
  `EXTENSIONATTRIBUTE6` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`),
  KEY `writedate` (`WRITEDATE`,`PARENTWRITEDATE`),
  KEY `writedate1` (`WRITEDATE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_item_attachments`
--

DROP TABLE IF EXISTS `tbl_board_item_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_item_attachments` (
  `ITEMID` varchar(76) NOT NULL,
  `GUID` varchar(76) DEFAULT NULL,
  `FILEPATH` varchar(800) NOT NULL,
  `FILESIZE` varchar(100) DEFAULT NULL,
  `FILENAME` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`,`FILEPATH`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `NAME1` varchar(200) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `NAME3` varchar(200) DEFAULT NULL,
  `NAME4` varchar(200) DEFAULT NULL,
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
  `NAME1` varchar(200) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `NAME3` varchar(200) DEFAULT NULL,
  `NAME4` varchar(200) DEFAULT NULL,
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
  `USERNAME` varchar(100) DEFAULT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `USERDEPTNAME` varchar(100) DEFAULT NULL,
  `USERDEPTNAME2` varchar(100) DEFAULT NULL,
  `USERCOMPANYNAME` varchar(100) DEFAULT NULL,
  `USERCOMPANYNAME2` varchar(100) DEFAULT NULL,
  `USERTITLE` varchar(100) DEFAULT NULL,
  `USERTITLE2` varchar(100) DEFAULT NULL,
  `READDATE` datetime DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
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
  `WRITERNAME` varchar(40) DEFAULT NULL,
  `WRITERNAME2` varchar(40) DEFAULT NULL,
  `WRITERDEPTID` varchar(40) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(100) DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(100) DEFAULT NULL,
  `WRITERCOMPANYID` varchar(40) DEFAULT NULL,
  `WRITERCOMPANYNAME` varchar(100) DEFAULT NULL,
  `WRITERCOMPANYNAME2` varchar(100) DEFAULT NULL,
  `WRITEDATE` varchar(40) DEFAULT NULL,
  `PARENTWRITEDATE` varchar(40) DEFAULT NULL,
  `UPDATEDATE` varchar(40) DEFAULT NULL,
  `IMPORTANCE` bigint(10) DEFAULT NULL,
  `TITLE` varchar(400) DEFAULT NULL,
  `CONTENTLOCATION` varchar(400) DEFAULT NULL,
  `READCOUNT` bigint(10) DEFAULT NULL,
  `STARTDATE` varchar(40) DEFAULT NULL,
  `ENDDATE` varchar(40) DEFAULT NULL,
  `ABSTRACT` varchar(800) DEFAULT NULL,
  `ATTACHMENTS` varchar(2) DEFAULT NULL,
  `UPPERITEMIDTREE` longtext,
  `ITEMLEVEL` bigint(10) DEFAULT NULL,
  `COPIEDITEM` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE32` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(400) DEFAULT NULL,
  `DOCNO` decimal(19,0) DEFAULT NULL,
  `DOCPASSWORD` varchar(100) DEFAULT NULL,
  `MAINCONTENT` longtext,
  `EXTENSIONATTRIBUTE6` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE7` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE8` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE9` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE10` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `BOARDNAME` varchar(100) DEFAULT NULL,
  `BOARDNAME2` varchar(100) DEFAULT NULL,
  `TREEVIEWNUM` double(126,0) DEFAULT NULL,
  `TABUSED` varchar(4) DEFAULT 'Y',
  `VIEWORDER` double(126,0) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`USERID`,`BOARDID`)
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
  `TREENAME` varchar(510) NOT NULL,
  `TREENAME2` varchar(510) NOT NULL,
  `TREELEVEL` bigint(10) DEFAULT NULL,
  `TREESTEP` bigint(10) NOT NULL,
  `TREEUPPER` varchar(76) DEFAULT NULL,
  `TREEBOARDID` varchar(76) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
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
  PRIMARY KEY (`TENANT_ID`,`USERID`)
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
  `USERNAME` varchar(100) DEFAULT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `WRITEDATE` datetime DEFAULT NULL,
  `CONTENT` varchar(600) DEFAULT NULL,
  `PASSWORD` varchar(1368) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`ITEMID`,`REPLYID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_board_treecache`
--

DROP TABLE IF EXISTS `tbl_board_treecache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_board_treecache` (
  `QUERY` varchar(3600) NOT NULL,
  `RESULT` longtext,
  `RESULT2` longtext,
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `USERNAME` varchar(100) DEFAULT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `TITLE` varchar(400) NOT NULL,
  `CONTENT` longtext,
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
  `CHARFILENAME` longtext,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `C_CLUBNAME` varchar(400) NOT NULL,
  `C_CLUBNAME2` varchar(400) DEFAULT NULL,
  `C_CATE_A` varchar(4) NOT NULL DEFAULT '0',
  `C_CATE_B` varchar(4) DEFAULT '0',
  `C_CATE_C` varchar(4) DEFAULT '0',
  `C_CLUBGUBUN` varchar(100) DEFAULT NULL,
  `C_CLUBCONFIRMTYPE` varchar(100) DEFAULT NULL,
  `C_ADMINCONFIRM` varchar(2) DEFAULT NULL,
  `C_MAKER` varchar(40) DEFAULT NULL,
  `C_SYSOPID` varchar(40) DEFAULT NULL,
  `C_MEMBERCNT` bigint(10) NOT NULL DEFAULT '1',
  `C_LOGO` varchar(100) DEFAULT NULL,
  `C_LOGO_THUMBNAIL` varchar(100) DEFAULT NULL,
  `C_BGIMAGE` varchar(100) DEFAULT NULL,
  `C_FONTCOLOR` varchar(100) DEFAULT NULL,
  `C_BGCOLOR` varchar(100) DEFAULT NULL,
  `C_TITLEFONTCOLOR` varchar(100) DEFAULT NULL,
  `C_CLUBDESC` longtext,
  `C_CLUBBANNER` varchar(100) NOT NULL,
  `C_OPENDATE` varchar(100) DEFAULT NULL,
  `C_CLUBNOTICETITLE` varchar(200) DEFAULT '공지사항',
  `C_NOTICETITLECOLOR` varchar(20) DEFAULT NULL,
  `C_NOTICEFONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBNOTICE_ORDERBY` bigint(10) NOT NULL DEFAULT '0',
  `C_CLUBNOTICE_EXIST` varchar(4) NOT NULL DEFAULT '1',
  `C_CLUBBOARDTITLE` varchar(200) DEFAULT '게시판',
  `C_BOARDTITLECOLOR` varchar(20) DEFAULT NULL,
  `C_BOARDFONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBBOARD_ORDERBY` bigint(10) NOT NULL DEFAULT '0',
  `C_CLUBBOARD_EXIST` varchar(4) NOT NULL DEFAULT '1',
  `C_CLUBPDSTITLE` varchar(200) DEFAULT '자료실',
  `C_PDSTITLECOLOR` varchar(20) DEFAULT NULL,
  `C_PDSFONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBPDS_ORDERBY` bigint(10) NOT NULL DEFAULT '0',
  `C_CLUBPDS_EXIST` varchar(4) NOT NULL DEFAULT '1',
  `C_CLUBBOARD1TITLE` varchar(200) DEFAULT '게시판1',
  `C_BOARD1TITLECOLOR` varchar(20) DEFAULT NULL,
  `C_BOARD1FONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBBOARD1_EXIST` varchar(4) NOT NULL DEFAULT '0',
  `C_CLUBBOARD1_ORDERBY` bigint(10) NOT NULL DEFAULT '0',
  `C_CLUBBOARD2TITLE` varchar(200) DEFAULT '게시판2',
  `C_BOARD2TITLECOLOR` varchar(20) DEFAULT NULL,
  `C_BOARD2FONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBBOARD2_EXIST` varchar(4) NOT NULL DEFAULT '0',
  `C_CLUBBOARD2_ORDERBY` bigint(10) NOT NULL DEFAULT '0',
  `C_CLUBPDS1TITLE` varchar(200) DEFAULT '자료실1',
  `C_PDS1TITLECOLOR` varchar(20) DEFAULT NULL,
  `C_PDS1FONTCOLOR` varchar(20) DEFAULT NULL,
  `C_CLUBPDS1_EXIST` varchar(4) NOT NULL DEFAULT '0',
  `C_CLUBPDS1_ORDERBY` bigint(10) NOT NULL DEFAULT '0',
  `SCORE` bigint(10) DEFAULT NULL,
  `ISIN` bigint(10) DEFAULT NULL,
  `COMPANYID` varchar(100) DEFAULT NULL,
  `USINGDISKSIZE` bigint(18) DEFAULT '0',
  `SENDMAIL` varchar(4) DEFAULT '0',
  `SENDMAILCNT` varchar(4) DEFAULT '0',
  `ASSIGNDISKSIZE` varchar(20) NOT NULL DEFAULT '52428800',
  `C_TYPE` varchar(20) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `ID` varchar(40) DEFAULT NULL,
  `USERNAME` varchar(100) DEFAULT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `COMPANYID` varchar(100) DEFAULT NULL,
  `TITLE` varchar(400) DEFAULT NULL,
  `CONTENT` longtext,
  `CONTENTURL` varchar(400) DEFAULT NULL,
  `READNUM` decimal(19,0) DEFAULT NULL,
  `WRITEDAY` datetime DEFAULT NULL,
  `C_NO` decimal(19,0) NOT NULL,
  `C_CLUBNO` varchar(40) NOT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`NO`),
  UNIQUE KEY `IDX_TBL_C_CLUBGUEST` (`TENANT_ID`,`NO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `CONTENT` longtext,
  `CONTENTURL` varchar(400) DEFAULT NULL,
  `READNUM` decimal(19,0) DEFAULT NULL,
  `WRITEDAY` varchar(100) DEFAULT NULL,
  `C_NO` decimal(19,0) DEFAULT NULL,
  `C_CLUBNO` varchar(40) DEFAULT NULL,
  `FILENAME` varchar(40) DEFAULT NULL,
  `REF` bigint(18) DEFAULT NULL,
  `STEP` bigint(10) DEFAULT NULL,
  `RE_LEVEL` bigint(10) DEFAULT NULL,
  `CHARFILENAME` longtext,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `C_INDATE` varchar(60) DEFAULT NULL,
  `C_LASTDATE` varchar(60) DEFAULT NULL,
  `C_EMAIL` mediumint(5) NOT NULL DEFAULT '0',
  `C_HPHONE` mediumint(5) NOT NULL DEFAULT '0',
  `C_COMPANY` mediumint(5) NOT NULL DEFAULT '0',
  `C_HOUSE` mediumint(5) NOT NULL DEFAULT '0',
  `C_JOB` mediumint(5) NOT NULL DEFAULT '0',
  `C_BIRTH` mediumint(5) NOT NULL DEFAULT '0',
  `C_SEX` mediumint(5) NOT NULL DEFAULT '0',
  `C_VISITED` decimal(19,0) NOT NULL DEFAULT '0',
  `C_INTRO` longtext,
  `PERMIT` varchar(4) DEFAULT '0',
  `COMPANYID` varchar(100) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `C_CLUBNAME` varchar(400) DEFAULT NULL,
  `C_CLUBNAME2` varchar(400) DEFAULT NULL,
  `C_SYSOPID` varchar(100) DEFAULT NULL,
  `COMPANYNAME` varchar(400) DEFAULT NULL,
  `APPLICATIONDATE` varchar(100) DEFAULT NULL,
  `CLOSEREASON` longtext,
  `CLOSESTATE` varchar(100) DEFAULT NULL,
  `CLOSESTATE2` varchar(100) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `USERNAME` varchar(100) DEFAULT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `COMPANYNAME` varchar(100) DEFAULT NULL,
  `COMPANYNAME2` varchar(100) DEFAULT NULL,
  `COMPANYZIP` varchar(200) DEFAULT NULL,
  `COMPANYADDRESS` varchar(200) DEFAULT NULL,
  `DEPTNAME` varchar(100) DEFAULT NULL,
  `DEPTNAME2` varchar(100) DEFAULT NULL,
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
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `USERNAME` varchar(100) DEFAULT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `TITLE` varchar(400) NOT NULL,
  `CONTENT` longtext NOT NULL,
  `READNUM` decimal(19,0) NOT NULL,
  `WRITEDAY` varchar(100) NOT NULL,
  `FILENAME` varchar(40) DEFAULT NULL,
  `COMPANYID` varchar(100) DEFAULT NULL,
  `C_CLUBNO` varchar(40) DEFAULT NULL,
  `C_NO` bigint(18) DEFAULT NULL,
  `REF` bigint(18) DEFAULT NULL,
  `STEP` bigint(10) DEFAULT NULL,
  `RE_LEVEL` bigint(10) DEFAULT NULL,
  `CHARFILENAME` longtext,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `OUTDATE` varchar(100) DEFAULT NULL,
  `OUTREASON` longtext,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`C_CLUBNO`)
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
  `ANSWERNO` bigint(10) NOT NULL DEFAULT '0',
  `ANSWERCONTENT` varchar(400) NOT NULL,
  `TENANT_ID` bigint(10) NOT NULL DEFAULT '0',
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
  `POLLGROUPNO` bigint(10) NOT NULL DEFAULT '0',
  `POLLSUBJECT` varchar(400) DEFAULT NULL,
  `QUESTIONCOUNT` bigint(10) NOT NULL,
  `POLLREGDATE` datetime DEFAULT NULL,
  `POLLSTARTDATE` datetime DEFAULT NULL,
  `POLLENDDATE` datetime DEFAULT NULL,
  `POLLREGUSER` varchar(100) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `QUESTIONCONTENT` varchar(400) NOT NULL,
  `ANSWERCOUNT` bigint(10) NOT NULL,
  `ANSWERTYPE` bigint(10) NOT NULL,
  `ANSWERVIEWTYPE` bigint(10) DEFAULT '0',
  `TENANT_ID` bigint(10) NOT NULL DEFAULT '0',
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
  `ANSWERETC` varchar(2000) DEFAULT NULL,
  `USERID` varchar(100) NOT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  `TENANT_ID` bigint(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`RESPONSEID`),
  UNIQUE KEY `PK_TBL_C_POLLRESPONSE` (`TENANT_ID`,`RESPONSEID`),
  KEY `FK_TBL_C_POLLRESPONSE1_idx` (`TENANT_ID`,`QUESTIONID`),
  KEY `FK_TBL_C_POLLRESPONSE2_idx` (`TENANT_ID`,`ANSWERID`),
  CONSTRAINT `FK_TBL_C_POLLRESPONSE1` FOREIGN KEY (`TENANT_ID`, `QUESTIONID`) REFERENCES `tbl_c_pollquestion` (`TENANT_ID`, `QUESTIONID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_TBL_C_POLLRESPONSE2` FOREIGN KEY (`TENANT_ID`, `ANSWERID`) REFERENCES `tbl_c_pollanswer` (`TENANT_ID`, `ANSWERID`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `DELFLAG` varchar(4) DEFAULT '(0)',
  `TCABINETID` varchar(112) DEFAULT NULL,
  `TDEPTCODE` varchar(28) DEFAULT NULL,
  `TCABINETNAME` varchar(200) DEFAULT NULL,
  `TTASKCODE` varchar(32) DEFAULT NULL,
  `TDEPTNAME` varchar(200) DEFAULT NULL,
  `TTASKNAME` varchar(200) DEFAULT NULL,
  `TPRODUCEYEAR` varchar(16) DEFAULT NULL,
  `TREGSERIALNO` varchar(24) DEFAULT NULL,
  `TVOLUMENO` varchar(12) DEFAULT NULL,
  `TRANSFERDATE` datetime DEFAULT NULL,
  `CABINETTRANSFERFLAG` varchar(4) DEFAULT '(0)',
  `PRODREPORTFLAG` bigint(10) DEFAULT '0',
  `TRANSFERFLAG` bigint(10) DEFAULT '0',
  `CATALOGTRANSFERFLAG` varchar(4) DEFAULT '(0)',
  `CATALOGTRANSFERYEAR` bigint(10) DEFAULT NULL,
  `DOCTRANSFERFLAG` varchar(4) DEFAULT '(0)',
  `DOCTRANSFERYEAR` bigint(10) DEFAULT NULL,
  `TCABINETNAME2` varchar(200) DEFAULT NULL,
  `TDEPTNAME2` varchar(200) DEFAULT NULL,
  `TTASKNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`CABINETID`),
  KEY `FK_TBL_CABINET_idx` (`TENANT_ID`,`CABINETCLASSNO`),
  CONSTRAINT `FK_TBL_CABINET` FOREIGN KEY (`TENANT_ID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `PROCESSDEPTNAME` varchar(200) DEFAULT NULL,
  `PROCESSDEPTCODE` varchar(28) DEFAULT NULL,
  `REGSERIALNO` varchar(24) DEFAULT NULL,
  `TASKNAME` varchar(200) DEFAULT NULL,
  `TITLE` varchar(200) DEFAULT NULL,
  `RECTYPECODE` varchar(4) DEFAULT NULL,
  `EXPIRATIONYEAR` varchar(16) DEFAULT NULL,
  `DELAYENDYFLAG` varchar(4) DEFAULT 'N',
  `KEEPINGPERIOD` varchar(8) DEFAULT NULL,
  `TERMINATEFLAG` varchar(4) DEFAULT NULL,
  `OWNERNAME` varchar(200) DEFAULT NULL,
  `KEEPINGMETHOD` varchar(4) DEFAULT NULL,
  `OWNERID` varchar(200) DEFAULT NULL,
  `DISPLAYRECFLAG` varchar(4) DEFAULT NULL,
  `KEEPINGPLACE` varchar(4) DEFAULT NULL,
  `MODIFYFLAG` varchar(4) DEFAULT NULL,
  `DISPLAYENDDATE` varchar(32) DEFAULT NULL,
  `NUMOFREC` varchar(12) DEFAULT NULL,
  `PAGEOFREC` varchar(24) DEFAULT NULL,
  `TRANSDELAYFLAG` varchar(4) DEFAULT NULL,
  `EXTRANSYEAR` bigint(10) DEFAULT NULL,
  `TRANSDELAYREASON` varchar(400) DEFAULT NULL,
  `DISPLAYREASON` varchar(400) DEFAULT NULL,
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
  `TITLE2` varchar(400) DEFAULT NULL,
  `PROCESSDEPTNAME2` varchar(200) DEFAULT NULL,
  `TASKNAME2` varchar(200) DEFAULT NULL,
  `OWNERNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`CABINETCLASSNO`)
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
  `NAME` varchar(200) DEFAULT NULL,
  `ISUSED` smallint(3) NOT NULL,
  `CODEDESCRIPTION` varchar(400) DEFAULT NULL,
  `TYPEDESCRIPTION` varchar(400) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`CODETYPE`,`CODE`)
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
  `TITLE` varchar(400) DEFAULT NULL,
  `RECTYPECODE` varchar(4) DEFAULT NULL,
  `MODIFYDATE` varchar(32) DEFAULT NULL,
  `KEEPINGPERIOD` varchar(8) DEFAULT NULL,
  `DISPLAYENDDATE` varchar(32) DEFAULT NULL,
  `DISPLAYREASON` varchar(400) DEFAULT NULL,
  `MODIFYREASON` varchar(400) DEFAULT NULL,
  `MODIFIERID` varchar(400) DEFAULT NULL,
  `MODIFIERNAME` varchar(200) DEFAULT NULL,
  `MODIFYFLAG` varchar(4) DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT NULL,
  `MODIFIERNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`VERSION`,`CABINETCLASSNO`),
  KEY `FK_TBL_CABINETHISTORY_idx` (`TENANT_ID`,`CABINETCLASSNO`),
  CONSTRAINT `FK_TBL_CABINETHISTORY` FOREIGN KEY (`TENANT_ID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `USERNAME` varchar(200) DEFAULT NULL,
  `USERNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`USER_ID`(255),`CABINETCLASSNO`),
  KEY `FK_TBL_CABROLEINFO_idx` (`TENANT_ID`,`CABINETCLASSNO`),
  CONSTRAINT `FK_TBL_CABROLEINFO` FOREIGN KEY (`TENANT_ID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_clubid`
--

DROP TABLE IF EXISTS `tbl_clubid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_clubid` (
  `CLUBID` varchar(40) NOT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`CODE1`,`CODE2`)
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
  `BOARDNAME` varchar(100) NOT NULL,
  `BOARDNAME2` varchar(100) DEFAULT NULL,
  `TREEVIEWORDER` varchar(1000) DEFAULT NULL,
  `BOARDLEVEL` bigint(10) DEFAULT NULL,
  `PARENTBOARDID` varchar(76) NOT NULL,
  `BOARDDESCRIPTION` varchar(400) DEFAULT NULL,
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
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `ACCESSNAME` varchar(200) DEFAULT NULL,
  `ACCESSNAME2` varchar(200) DEFAULT NULL,
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
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `WRITERNAME` varchar(40) DEFAULT NULL,
  `WRITERNAME2` varchar(40) DEFAULT NULL,
  `WRITERDEPTID` varchar(40) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(100) DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(100) DEFAULT NULL,
  `WRITERCOMPANYID` varchar(40) DEFAULT NULL,
  `WRITERCOMPANYNAME` varchar(100) DEFAULT NULL,
  `WRITERCOMPANYNAME2` varchar(100) DEFAULT NULL,
  `WRITEDATE` varchar(40) DEFAULT NULL,
  `PARENTWRITEDATE` varchar(40) DEFAULT NULL,
  `UPDATEDATE` varchar(40) DEFAULT NULL,
  `IMPORTANCE` bigint(10) DEFAULT NULL,
  `TITLE` varchar(400) DEFAULT NULL,
  `CONTENTLOCATION` varchar(400) DEFAULT NULL,
  `READCOUNT` bigint(10) DEFAULT NULL,
  `STARTDATE` varchar(40) DEFAULT NULL,
  `ENDDATE` varchar(40) DEFAULT NULL,
  `ABSTRACT` varchar(800) DEFAULT NULL,
  `ATTACHMENTS` varchar(20) DEFAULT NULL,
  `UPPERITEMIDTREE` longtext,
  `ITEMLEVEL` bigint(10) DEFAULT NULL,
  `COPIEDITEM` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` bigint(10) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE32` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(100) DEFAULT NULL,
  `EXTENSIONATTRIBUTE5` varchar(400) DEFAULT NULL,
  `DOCNO` decimal(19,0) DEFAULT NULL,
  `DOCPASSWORD` varchar(2000) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `FILEPATH` varchar(400) NOT NULL,
  `FILESIZE` varchar(20) DEFAULT NULL,
  `FILENAME` varchar(100) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `USERNAME` varchar(100) DEFAULT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `USERDEPTNAME` varchar(100) DEFAULT NULL,
  `USERDEPTNAME2` varchar(100) DEFAULT NULL,
  `USERCOMPANYNAME` varchar(100) DEFAULT NULL,
  `USERCOMPANYNAME2` varchar(100) DEFAULT NULL,
  `USERTITLE` varchar(100) DEFAULT NULL,
  `USERTITLE2` varchar(100) DEFAULT NULL,
  `READDATE` datetime DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `BOARDNAME` varchar(40) DEFAULT NULL,
  `TREEVIEWNUM` bigint(10) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `USERNAME` varchar(100) DEFAULT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `WRITEDATE` datetime DEFAULT NULL,
  `CONTENT` varchar(600) DEFAULT NULL,
  `PASSWORD` varchar(2000) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `USERNAME` varchar(100) NOT NULL,
  `SECRETARYID` varchar(100) NOT NULL,
  `SECRETARYNAME` varchar(100) NOT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `RESULT` longtext,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`QUERY`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `USERNM` varchar(200) DEFAULT NULL,
  `USERNM2` varchar(200) DEFAULT NULL,
  `DEPTID` varchar(200) DEFAULT NULL,
  `DEPTNM` varchar(200) DEFAULT NULL,
  `DEPTNM2` varchar(200) DEFAULT NULL,
  `TITLE` varchar(200) DEFAULT NULL,
  `TITLE2` varchar(200) DEFAULT NULL,
  `COMPANYID` varchar(200) DEFAULT NULL,
  `COMPANYNM` varchar(200) DEFAULT NULL,
  `COMPANYNM2` varchar(200) DEFAULT NULL,
  `CONNECTIP` varchar(200) DEFAULT NULL,
  `CONNECTINFO` varchar(200) DEFAULT NULL,
  `CONNECTTIME` datetime DEFAULT NULL,
  `CONNECTBROWSER` varchar(40) DEFAULT NULL,
  `CONNECTOS` varchar(80) DEFAULT NULL,
  `CONNECTAGENT` varchar(1000) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`CONTAINERID`,`CONTAINEROWNDEPID`)
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
  `DOCUMENTSTATE` varchar(12) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  KEY `TBL_CONTAINERTODOCSTATE_INDEX1` (`TENANT_ID`)
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
  `CONTAINERTYPENAME` varchar(200) DEFAULT NULL,
  `CONTAINERTYPENAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`CONTAINERTYPEID`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`CONTAINERID`,`USEDEPID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_dailydoccountlog`
--

DROP TABLE IF EXISTS `tbl_dailydoccountlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_dailydoccountlog` (
  `REGDATE` varchar(40) NOT NULL,
  `DEPTID` varchar(255) NOT NULL,
  `DEPTNAME` varchar(200) DEFAULT NULL,
  `USERID` varchar(80) NOT NULL,
  `USERNAME` varchar(200) DEFAULT NULL,
  `DRAFTINGCNT` bigint(10) NOT NULL,
  `DRAFTENDCNT` bigint(10) NOT NULL,
  `DRAFTTIME` double(126,0) NOT NULL,
  `SUSININGCNT` bigint(10) NOT NULL,
  `SUSINENDCNT` bigint(10) NOT NULL,
  `SUSINTIME` double(126,0) NOT NULL,
  `RETURNCNT` bigint(10) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`REGDATE`,`DEPTID`,`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_dailyformcountlog`
--

DROP TABLE IF EXISTS `tbl_dailyformcountlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_dailyformcountlog` (
  `REGDATE` varchar(40) NOT NULL,
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
  PRIMARY KEY (`TENANT_ID`,`REGDATE`,`FORMID`,`FORMCONTID`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `DISPLAYNAME` varchar(100) NOT NULL,
  `DISPLAYNAME2` varchar(100) DEFAULT NULL,
  `USEFLAG` varchar(4) DEFAULT NULL,
  `MAIL` varchar(100) DEFAULT NULL,
  `COMPNM2` varchar(100) DEFAULT NULL,
  `DEPTLEVEL` varchar(12) DEFAULT NULL,
  `DEPT_CD_PATH` varchar(400) DEFAULT NULL,
  `DEPT_NM_PATH` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(400) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(400) DEFAULT NULL,
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`USERID`,`FORMID`,`APRDEPTSN`)
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
  `APRMEMBERDEPTNAME` varchar(200) DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `APRMEMBERID` varchar(400) DEFAULT NULL,
  `APRMEMBERNAME` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`USERID`(255),`FORMID`,`APRDEPTSN`,`APRDEPTMEMBERSN`)
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
  `ORGAN` varchar(200) DEFAULT NULL,
  `DOCNUMBER` varchar(200) DEFAULT NULL,
  `MANAGEDEPTID` varchar(400) DEFAULT NULL,
  `MANAGEDEPT` varchar(200) DEFAULT NULL,
  `CHARGEID` varchar(400) DEFAULT NULL,
  `CHARGENAME` varchar(200) DEFAULT NULL,
  `REMARK` varchar(200) DEFAULT NULL,
  `ORGDOCNUMCODE` varchar(200) DEFAULT NULL,
  `DOCTITLE` varchar(1020) DEFAULT NULL,
  `MANAGEDEPT2` varchar(200) DEFAULT NULL,
  `ORGAN2` varchar(200) DEFAULT NULL,
  `CHARGENAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`SN`,`DOCID`,`DEPTID`(255))
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
  `ATTACHDOCNAME` varchar(1020) DEFAULT NULL,
  `ATTACHDOCURL` varchar(1020) DEFAULT NULL,
  `SUBATTACHYN` varchar(4) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`ATTACHSN`)
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
  `DOCTITLE` varchar(1020) DEFAULT NULL,
  `DOCNO` varchar(200) DEFAULT NULL,
  `HASATTACHYN` varchar(4) DEFAULT NULL,
  `HASOPINIONYN` varchar(4) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) DEFAULT NULL,
  `WRITERNAME` varchar(200) DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) DEFAULT NULL,
  `WRITERDEPTID` varchar(400) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(200) DEFAULT NULL,
  `FORMID` varchar(40) DEFAULT NULL,
  `CONTAINERID` varchar(40) DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL,
  `WRITERNAME2` varchar(200) DEFAULT NULL,
  `WRITERJOBTITLE2` varchar(200) DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`)
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
  `APRMEMBERNAME` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(400) DEFAULT NULL,
  `RECEIVEDDATE` datetime DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `REASONDONOTAPPROVAL` varchar(1020) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`APRMEMBERSN`)
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
  `OPINIONGB` varchar(12) DEFAULT NULL,
  `CONTENT` longtext,
  `USERNAME` varchar(200) DEFAULT NULL,
  `USERJOBTITLE` varchar(200) DEFAULT NULL,
  `USERDEPTID` varchar(400) DEFAULT NULL,
  `USERDEPTNAME` varchar(200) DEFAULT NULL,
  `OPINIONSN` bigint(10) NOT NULL,
  `USERNAME2` varchar(200) DEFAULT NULL,
  `USERJOBTITLE2` varchar(200) DEFAULT NULL,
  `USERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`USERID`(255),`OPINIONSN`)
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
  `ATTACHFILENAME` varchar(1020) DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) DEFAULT NULL,
  `ATTACHFILESIZE` double(126,0) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(600) DEFAULT NULL,
  `BODYATTACH` varchar(4) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`ATTACHFILESN`)
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
  `RECEIPTPOINTNAME` varchar(200) DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSSN` bigint(10) NOT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERID` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE` varchar(200) DEFAULT NULL,
  `DEPTMEMBERSN` bigint(10) DEFAULT NULL,
  `RECEIPTPOINTNAME2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`RECEIPTPOINTID`(255),`PROCESSSN`)
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
  `SENTDEPTNAME` varchar(200) DEFAULT NULL,
  `RECEIVEDDEPTID` varchar(400) NOT NULL,
  `RECEIVEDDEPTNAME` varchar(200) DEFAULT NULL,
  `DOCSTATE` varchar(12) DEFAULT NULL,
  `APRSTATE` varchar(12) DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSDOCID` varchar(80) DEFAULT NULL,
  `PROCESSORID` varchar(400) DEFAULT NULL,
  `PROCESSORNAME` varchar(200) DEFAULT NULL,
  `PROCESSORJOBTITLE` varchar(200) DEFAULT NULL,
  `PARENTSDOCID` varchar(80) DEFAULT NULL,
  `SENTDEPTNAME2` varchar(200) DEFAULT NULL,
  `RECEIVEDDEPTNAME2` varchar(200) DEFAULT NULL,
  `PROCESSORNAME2` varchar(200) DEFAULT NULL,
  `PROCESSORJOBTITLE2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`RECEIVESN`,`DOCID`,`RECEIVEDDEPTID`(255))
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
  `SECURITYCODE` bigint(10) DEFAULT NULL,
  `STORAGEPERIOD` varchar(160) DEFAULT NULL,
  `KEYWORD` varchar(1020) DEFAULT NULL,
  `FORMNAME` varchar(1020) DEFAULT NULL,
  `COMPANYID` varchar(20) DEFAULT NULL,
  `ITEMCODE` varchar(160) DEFAULT NULL,
  `ITEMNAME` varchar(400) DEFAULT NULL,
  `URGENTAPPROVAL` varchar(4) DEFAULT NULL,
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
  `SEPERATEATTACHXML` longtext,
  `SUMMARY` longtext,
  `FORMNAME2` varchar(1020) DEFAULT NULL,
  `ITEMNAME2` varchar(400) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`)
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
  `ORGUSERID` varchar(400) NOT NULL,
  `PROXYUSERID` varchar(400) DEFAULT NULL,
  `PROXYUSERNAME` varchar(200) DEFAULT NULL,
  `PROXYUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `PROXYUSERDEPTID` varchar(400) DEFAULT NULL,
  `PROXYUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `PROXYUSERNAME2` varchar(200) DEFAULT NULL,
  `PROXYUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `PROXYUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  UNIQUE KEY `PK_TBL_EXPAPRLINE` (`TENANT_ID`,`DOCID`,`APRMEMBERSN`,`ORGUSERID`(255))
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
  `SECURITYCODE` bigint(10) DEFAULT NULL,
  `STORAGEPERIOD` varchar(160) DEFAULT NULL,
  `KEYWORD` varchar(1020) DEFAULT NULL,
  `ORGCONTID` varchar(40) DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT NULL,
  `FORMNAME` varchar(1020) DEFAULT NULL,
  `COMPANYID` varchar(40) DEFAULT NULL,
  `ITEMCODE` varchar(160) DEFAULT NULL,
  `ITEMNAME` varchar(400) DEFAULT NULL,
  `URGENTAPPROVAL` varchar(4) DEFAULT NULL,
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
  `SEPERATEATTACHXML` longtext,
  `SUMMARY` longtext,
  `FORMNAME2` varchar(1020) DEFAULT NULL,
  `ITEMNAME2` varchar(400) DEFAULT NULL,
  `SIGNCHECK` varchar(4) NOT NULL DEFAULT 'N',
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`DOCID`),
  KEY `TBL_EXPENDAPRDOCINFO_NONIDX1` (`TENANT_ID`,`DOCID`,`DELFLAG`)
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
  `PROXYUSERNAME` varchar(200) DEFAULT NULL,
  `PROXYUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `PROXYUSERDEPTID` varchar(400) DEFAULT NULL,
  `PROXYUSERDEPTNAME` varchar(400) DEFAULT NULL,
  `PROXYUSERNAME2` varchar(200) DEFAULT NULL,
  `PROXYUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `PROXYUSERDEPTNAME2` varchar(400) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  UNIQUE KEY `PK_TBL_EXPENDAPRLINE` (`TENANT_ID`,`ORGUSERID`,`APRMEMBERSN`,`DOCID`)
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
  `FORMCONTNAME` varchar(200) DEFAULT NULL,
  `FORMCONTOWNDEPID` varchar(255) NOT NULL,
  `FORMCONTPARENTS` varchar(200) NOT NULL,
  `FORMCONTDESCRIPTION` varchar(1020) DEFAULT NULL,
  `FORMCONTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  UNIQUE KEY `PK_TBL_FORMCONTAINER` (`TENANT_ID`,`FORMCONTID`,`FORMCONTNAME`,`FORMCONTOWNDEPID`,`FORMCONTPARENTS`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`FORMCONTID`,`FORMCONTUSERDEPID`(255))
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`SN`)
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
  `FORMNAME` varchar(1020) DEFAULT NULL,
  `FORMNAME2` varchar(1020) DEFAULT NULL,
  `FORMDOCTYPE` varchar(24) NOT NULL,
  `FORMDESCRIPTION` varchar(1020) DEFAULT NULL,
  `FORMFILELOCATION` varchar(200) NOT NULL,
  `FORMCONNFLAG` varchar(4) DEFAULT 'N',
  `FORMORDER` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`FORMID`)
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
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`SN`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  UNIQUE KEY `PK_TBL_FORMRECV` (`TENANT_ID`,`FORMID`,`DEPTID`(255))
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`FORMID`,`USERID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `ATTACHFILENAME` varchar(1020) DEFAULT NULL,
  `ATTACHFILEDISPLAYNAME` varchar(1020) DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) DEFAULT NULL,
  `ATTACHFILESIZE` double(126,0) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `MODIFYSN` bigint(10) NOT NULL,
  `MODIFYFLAG` varchar(80) DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `CHKFLAG` varchar(4) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  `COMPANYID` varchar(20) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`ATTACHFILESN`,`MODIFYSN`)
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
  `CHANGEUSERNAME` varchar(200) DEFAULT NULL,
  `CHANGEUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `CHANGEUSERDEPTID` varchar(400) DEFAULT NULL,
  `CHANGEUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `CHANGEDATE` datetime DEFAULT NULL,
  `CHKFLAG` varchar(4) DEFAULT NULL,
  `CHANGEUSERNAME2` varchar(200) DEFAULT NULL,
  `CHANGEUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `CHANGEUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`CHANGESN`)
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
  `APRMEMBERNAME` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `APRMEMBERDEPTNAME` varchar(200) DEFAULT NULL,
  `APRMEMBERLDAPPATH` varchar(400) DEFAULT NULL,
  `ISPROPOSERYN` varchar(4) DEFAULT NULL,
  `ISBRIEFUSERYN` varchar(4) DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `MODIFYSN` bigint(10) NOT NULL,
  `MODIFYUSERID` varchar(400) DEFAULT NULL,
  `MODIFYUSERNAME` varchar(200) DEFAULT NULL,
  `MODIFYUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `MODIFYUSERDEPTID` varchar(400) DEFAULT NULL,
  `MODIFYUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `CHKFLAG` varchar(4) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) DEFAULT NULL,
  `APRMEMBERDEPTNAME2` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) DEFAULT NULL,
  `MODIFYUSERNAME2` varchar(200) DEFAULT NULL,
  `MODIFYUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `MODIFYUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`APRMEMBERSN`,`MODIFYSN`)
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
  `RECEIPTDEPTNAME` varchar(200) DEFAULT NULL,
  `STATUS` varchar(4) DEFAULT NULL,
  `STATUSDATE` datetime DEFAULT NULL,
  `RECEIPTDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL
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
  `HOLIDAYNAME` varchar(100) DEFAULT NULL,
  `HOLIDAYNAME2` varchar(100) DEFAULT NULL,
  `HOLIDAYDATE` datetime DEFAULT NULL,
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`USERID`(255),`FORMID`,`APRMEMBERSN`)
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
  `RECEIPTPOINTNAME` varchar(200) DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSSN` bigint(10) DEFAULT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERID` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE` varchar(200) DEFAULT NULL,
  `DEPTMEMBERSN` bigint(10) DEFAULT NULL,
  `RECEIPTPOINTNAME2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`USERID`(255),`FORMID`,`RECEIPTPOINTID`(255))
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`LASTDOCID`)
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
  `APRTEMPLETNAME` varchar(800) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`USERID`(255),`FORMID`,`APRLINESN`)
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
  `APRMEMBERNAME` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE` varchar(200) DEFAULT NULL,
  `APRMEMBERDEPTID` varchar(400) DEFAULT NULL,
  `MEMBERDEPTNAME` varchar(400) DEFAULT NULL,
  `APRMEMBERNAME2` varchar(200) DEFAULT NULL,
  `APRMEMBERJOBTITLE2` varchar(200) DEFAULT NULL,
  `MEMBERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`USERID`(255),`FORMID`,`APRLINESN`,`APRMEMBERSN`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  `COLNAME2` varchar(4000) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`LISTTYPE`,`SN`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`LISTTYPE`,`SN`)
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
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
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
-- Table structure for table `tbl_menuitem_general`
--

DROP TABLE IF EXISTS `tbl_menuitem_general`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_menuitem_general` (
  `UID_` varchar(100) NOT NULL,
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
  `TYPE` bigint(10) DEFAULT NULL,
  `URL` varchar(1024) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) DEFAULT NULL,
  `IMAGETYPE` varchar(100) DEFAULT NULL,
  `NORMALIMAGEPATH` varchar(1024) DEFAULT NULL,
  `OVERIMAGEPATH` varchar(1024) DEFAULT NULL,
  `IMAGEWIDTH` bigint(10) DEFAULT NULL,
  `IMAGEHEIGHT` bigint(10) DEFAULT NULL,
  `LINKURL` varchar(1024) DEFAULT NULL,
  `LINKLOCATION` varchar(100) DEFAULT NULL,
  `WINDOWOPTION` varchar(300) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) DEFAULT NULL,
  `SUBFLAG` bigint(10) DEFAULT NULL,
  `COLUMNPOS` bigint(10) DEFAULT NULL,
  `IMAGEUID` varchar(100) DEFAULT NULL,
  `LINKURL` varchar(510) DEFAULT NULL,
  `LINKLOCATION` varchar(100) DEFAULT NULL,
  `LEFTMARGIN` bigint(10) DEFAULT NULL,
  `WINDOWOPTION` varchar(300) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) DEFAULT NULL,
  `COLUMNPOS` bigint(10) DEFAULT NULL,
  `IMAGEUID` varchar(100) DEFAULT NULL,
  `LINKURL` varchar(1024) DEFAULT NULL,
  `LINKLOCATION` varchar(100) DEFAULT NULL,
  `WINDOWOPTION` varchar(300) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `PARAMNAME` varchar(100) NOT NULL,
  `PARAMVALUE` varchar(200) DEFAULT NULL,
  `PARAMTYPE` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`,`PARAMNAME`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`CN`,`DEPTID`,`CABINETID`,`TASKCODE`)
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
  `SENDER` varchar(200) NOT NULL,
  `SUBJECT` varchar(500) NOT NULL,
  `TYPE` mediumint(5) NOT NULL,
  `ETCDATA` varchar(400) DEFAULT NULL,
  `LINKURL` varchar(4000) DEFAULT NULL,
  `SHOWMSG` varchar(256) DEFAULT 'N',
  `TENANT_ID` mediumint(5) NOT NULL,
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`CABINETCLASSNO`),
  CONSTRAINT `FK_TBL_OLDCABINETEXTRAINFO` FOREIGN KEY (`TENANT_ID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`RECORDID`),
  CONSTRAINT `FK_TBL_OLDRECORDEXTRAINFO` FOREIGN KEY (`TENANT_ID`, `RECORDID`) REFERENCES `tbl_record` (`TENANT_ID`, `RECORDID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `WRITERNAME` varchar(40) NOT NULL,
  `WRITERDEPTID` varchar(40) NOT NULL,
  `FILEPATH` varchar(400) NOT NULL,
  `WRITEDATE` varchar(40) NOT NULL,
  `FILECONTENT` longtext,
  `IMAGENAME` varchar(800) DEFAULT NULL,
  `MAIN_FLAG` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`IMAGEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `ANSWERCONTENT` varchar(2000) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `ATTACHNAME` varchar(200) DEFAULT NULL,
  `ATTACHURL` varchar(1000) DEFAULT NULL,
  `ATTACHTYPE` varchar(2) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `USER_NM` varchar(200) NOT NULL,
  `USER_NM2` varchar(200) DEFAULT NULL,
  `USER_EMAIL` varchar(510) NOT NULL,
  `USER_DEPTID` varchar(40) DEFAULT NULL,
  `USER_DEPTNM` varchar(200) DEFAULT NULL,
  `TITLE` varchar(510) NOT NULL,
  `CONTENT` varchar(510) NOT NULL,
  `POST_DATE` datetime NOT NULL,
  `UPDATE_DATE` varchar(38) DEFAULT NULL,
  `END_DATE` varchar(38) DEFAULT NULL,
  `POST_TERM` bigint(10) DEFAULT NULL,
  `ITEM_REF` bigint(10) DEFAULT NULL,
  `ITEM_LEVEL` bigint(10) DEFAULT NULL,
  `ITEM_STEP` bigint(10) DEFAULT NULL,
  `ITEM_IMP` varchar(2) NOT NULL DEFAULT '2',
  `HASATTACH` tinyint(1) NOT NULL DEFAULT '0',
  `SRCUSER_ID` varchar(40) DEFAULT NULL,
  `SRCUSER_NM` varchar(200) DEFAULT NULL,
  `SRCUSER_EMAIL` varchar(510) DEFAULT NULL,
  `ITEM_GB` varchar(2) NOT NULL DEFAULT '1',
  `READ_CNT` bigint(18) NOT NULL DEFAULT '0',
  `POLL_STARTDATE` varchar(38) DEFAULT NULL,
  `POLL_ENDDATE` varchar(38) DEFAULT NULL,
  `RES_CNT` bigint(18) NOT NULL DEFAULT '0',
  `COMPLETE_FLAG` varchar(2) NOT NULL DEFAULT 'N',
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `GUBUN_NM` varchar(200) DEFAULT NULL,
  `GUBUN_NM2` varchar(200) DEFAULT NULL,
  `CONDITION` varchar(6) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `READ_DATE` varchar(100) DEFAULT NULL,
  `USER_NM` varchar(510) DEFAULT NULL,
  `USER_NM2` varchar(510) DEFAULT NULL,
  `USER_DEPTID` varchar(100) DEFAULT NULL,
  `USER_DEPTNM` varchar(510) DEFAULT NULL,
  `USER_DEPTNM2` varchar(510) DEFAULT NULL,
  `USER_POSNM` varchar(510) DEFAULT NULL,
  `USER_POSNM2` varchar(510) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `QUESCONTENT` varchar(2000) NOT NULL,
  `ANSWERTYPE` bigint(10) NOT NULL DEFAULT '0',
  `ANSWERVIEWTYPE` bigint(10) DEFAULT NULL,
  `MULTISELECT` varchar(2) NOT NULL DEFAULT '0',
  `QUES_SN` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `ANSWER_SUBJECTIVITY` longtext,
  `ANSWER_VIEWSELECT` bigint(10) DEFAULT NULL,
  `RESPONSEUSER_ID` varchar(40) DEFAULT NULL,
  `RESPONSEUSER_NAME` varchar(100) DEFAULT NULL,
  `RESPONSEUSER_NAME2` varchar(100) DEFAULT NULL,
  `RESPONSEUSER_EMAIL` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_DEPT_ID` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_DEPT_NAME` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_DEPT_NAME2` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_POSITION` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_POSITION2` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_JIKGUB` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_JIKGUB2` varchar(200) DEFAULT NULL,
  `RESPONSEUSER_GENDER` varchar(2) DEFAULT NULL,
  `RESPONSEUSER_AGE` bigint(10) DEFAULT NULL,
  `RESPONSE_DATE` datetime NOT NULL,
  `RESPONSEUSER_IP` varchar(40) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `RESPONSE_DATE` varchar(38) DEFAULT NULL,
  `USER_NM` varchar(200) DEFAULT NULL,
  `USER_NM2` varchar(200) DEFAULT NULL,
  `USER_EMAIL` varchar(200) DEFAULT NULL,
  `USER_DEPT_ID` varchar(200) DEFAULT NULL,
  `USER_DEPT_NM` varchar(200) DEFAULT NULL,
  `USER_DEPT_NM2` varchar(200) DEFAULT NULL,
  `USER_POS` varchar(200) DEFAULT NULL,
  `USER_POS2` varchar(200) DEFAULT NULL,
  `USER_JIKGUB` varchar(200) DEFAULT NULL,
  `USER_JIKGUB2` varchar(200) DEFAULT NULL,
  `USER_GENDER` varchar(2) DEFAULT NULL,
  `USER_AGE` bigint(10) DEFAULT NULL,
  `GROUPID` varchar(10) DEFAULT NULL,
  `GROUPNAME` varchar(80) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `ANSWER_ANSWERCONTENT` varchar(2000) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`ITEM_NO`,`QUESTION_NO`,`ANSWERNO`)
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
  `ACCESSNAME` varchar(100) DEFAULT NULL,
  `VIEW_RIGHT` bigint(10) DEFAULT NULL,
  `EDIT_RIGHT` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`,`ACCESSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `RENDEREDHTML` longtext,
  `COMPANYID` varchar(100) DEFAULT NULL,
  `USERID` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `DISPLAYNAME` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) DEFAULT NULL,
  `CREATORID` varchar(100) DEFAULT NULL,
  `CREATORNAME` varchar(100) DEFAULT NULL,
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
  `COMPANYID` varchar(510) DEFAULT NULL,
  `BASETYPE` varchar(20) DEFAULT NULL,
  `THEMEUID` varchar(76) DEFAULT NULL,
  `DEFAULTPAGE` varchar(4) DEFAULT NULL,
  `TABLEVIEWOPTION` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`)
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
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `CREATORNAME` varchar(100) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `CHANGEFLAG` varchar(20) DEFAULT NULL,
  `USERPAGEUID` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`,`CREATORID`,`USERTYPE`,`BOARDID`)
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
  `DISPLAYNAME` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) DEFAULT NULL,
  `PORTLET_TYPE` bigint(10) DEFAULT NULL,
  `URL` varchar(1024) DEFAULT NULL,
  `MAXURL` varchar(1024) DEFAULT NULL,
  `SHOWTITLEBAR` varchar(20) DEFAULT NULL,
  `USERTYPE` varchar(20) DEFAULT NULL,
  `HEIGHT` bigint(10) DEFAULT NULL,
  `GUBUNFLAG` varchar(100) DEFAULT NULL,
  `COMPANYID` varchar(510) DEFAULT NULL,
  `BASETYPE` varchar(100) DEFAULT NULL,
  `USEPOTALGUBUN` varchar(100) DEFAULT NULL,
  `WIDTH` bigint(10) DEFAULT NULL,
  `FRAMETYPE` varchar(20) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`)
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
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
  `HTMLDATA` varchar(400) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `PARAMNAME` varchar(100) NOT NULL,
  `PARAMVALUE` varchar(200) DEFAULT NULL,
  `PARAMTYPE` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `URL` varchar(400) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`,`CREATORID`,`USERTYPE`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `DISPLAYNAME` varchar(120) NOT NULL,
  `DISPLAYNAME2` varchar(120) DEFAULT NULL,
  `DEPARTMENT` varchar(80) NOT NULL,
  `DESCRIPTION` varchar(200) DEFAULT NULL,
  `DESCRIPTION2` varchar(200) DEFAULT NULL,
  `PHYSICALDELIVERYOFFICENAME` varchar(160) DEFAULT NULL,
  `COMPANY` varchar(200) DEFAULT NULL,
  `COMPANY2` varchar(200) DEFAULT NULL,
  `TITLE` varchar(200) DEFAULT NULL,
  `TITLE2` varchar(200) DEFAULT NULL,
  `FILEPATH` varchar(1000) DEFAULT NULL,
  `TERM` varchar(20) NOT NULL,
  `DATE_` datetime DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  UNIQUE KEY `PK_TBL_PS_EMPMONTH` (`TENANT_ID`,`TERM`)
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
  `POLLTITLE` varchar(1000) NOT NULL,
  `POLLTITLE2` varchar(1000) DEFAULT NULL,
  `ANSWER1` varchar(200) NOT NULL,
  `ANSWER2` varchar(200) NOT NULL,
  `ANSWER3` varchar(200) NOT NULL,
  `ANSWER4` varchar(200) NOT NULL,
  `ANSWER5` varchar(200) NOT NULL,
  `ANSWER6` varchar(200) NOT NULL,
  `ANSWER7` varchar(200) NOT NULL,
  `ANSWER8` varchar(200) NOT NULL,
  `ANSWER9` varchar(200) NOT NULL,
  `ANSWER10` varchar(200) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ITEMSEQ`),
  UNIQUE KEY `IDX_TBL_PS_LIGHTPOLL` (`TENANT_ID`,`ITEMSEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
-- Table structure for table `tbl_ps_notice`
--

DROP TABLE IF EXISTS `tbl_ps_notice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_notice` (
  `ITEMSEQ` bigint(10) NOT NULL AUTO_INCREMENT,
  `COMPANYID` varchar(20) NOT NULL,
  `POSTDATE` datetime NOT NULL,
  `TITLE` varchar(500) NOT NULL,
  `TITLE2` varchar(500) DEFAULT NULL,
  `CONTENT` longtext,
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
  `TITLE` varchar(500) NOT NULL,
  `TITLE2` varchar(500) DEFAULT NULL,
  `CONTENT` longtext,
  `POSITION` varchar(20) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`ITEMSEQ`),
  UNIQUE KEY `IDX_TBL_PS_POPUP` (`TENANT_ID`,`COMPANYID`,`ITEMSEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_quicklink`
--

DROP TABLE IF EXISTS `tbl_ps_quicklink`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_quicklink` (
  `QUICKLINKID` varchar(76) NOT NULL,
  `QUICKLINKNAME` varchar(100) NOT NULL,
  `QUICKLINKNAME2` varchar(100) NOT NULL,
  `QUICKLINKNAME3` varchar(100) NOT NULL,
  `QUICKLINKNAME4` varchar(100) NOT NULL,
  `LINKTYPE` varchar(4) NOT NULL,
  `LINKTYPEURL` varchar(1024) DEFAULT NULL,
  `URL` varchar(1024) DEFAULT NULL,
  `REGDATE` varchar(200) NOT NULL,
  `MODIDATE` varchar(200) DEFAULT NULL,
  `REGUSERID` varchar(40) NOT NULL,
  `SIZE_` varchar(40) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
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
  `ACCESSNAME` varchar(100) NOT NULL,
  `ACCESSNAME2` varchar(100) DEFAULT NULL,
  `VIEW_FLAG` varchar(4) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`QUICKLINKID`,`ACCESSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_ps_sliderimage`
--

DROP TABLE IF EXISTS `tbl_ps_sliderimage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_ps_sliderimage` (
  `SLIDERID` varchar(76) NOT NULL,
  `SLIDERNAME` varchar(100) NOT NULL,
  `SLIDERNAME2` varchar(100) NOT NULL,
  `FILENAME` varchar(100) NOT NULL,
  `IMAGEPATH` varchar(1024) NOT NULL,
  `REGUSERID` varchar(40) NOT NULL,
  `REGDATE` varchar(200) NOT NULL,
  `COMPANYID` varchar(100) NOT NULL,
  `ISUSE` bigint(10) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
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
  `NAME` varchar(510) DEFAULT NULL,
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
  `NAME` varchar(510) DEFAULT NULL,
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
  `ACCESSNAME` varchar(510) DEFAULT NULL,
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
  PRIMARY KEY (`TENANT_ID`,`USERID`)
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
  `USER_NM` varchar(510) DEFAULT NULL,
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
  `ITEM_NO` bigint(10) DEFAULT '0',
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `RECEIPTPOINTNAME` varchar(200) DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSSN` bigint(10) NOT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERID` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE` varchar(200) DEFAULT NULL,
  `DEPTMEMBERSN` bigint(10) DEFAULT NULL,
  `RECEIPTPOINTNAME2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) DEFAULT NULL,
  `ROUTEYN` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`RECEIPTPOINTID`(255),`PROCESSSN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_record`
--

DROP TABLE IF EXISTS `tbl_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_record` (
  `RECORDID` varchar(68) NOT NULL,
  `DOCID` varchar(80) DEFAULT NULL,
  `PROCESSDEPTNAME` varchar(200) DEFAULT NULL,
  `PROCESSDEPTCODE` varchar(28) DEFAULT NULL,
  `REGISTERYEAR` varchar(16) DEFAULT NULL,
  `REGISTERDATE` datetime DEFAULT NULL,
  `REGISTERNO` varchar(52) DEFAULT NULL,
  `APRMEMBERTITLE` varchar(200) DEFAULT NULL,
  `DRAFTERNAME` varchar(200) DEFAULT NULL,
  `EXECUTEDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) DEFAULT NULL,
  `SENDINGMEMBERNAME` varchar(200) DEFAULT NULL,
  `DELIVERYNO` varchar(68) DEFAULT NULL,
  `PRODUCEDEPTREGNO` varchar(120) DEFAULT NULL,
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`RECORDID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `TITLE` varchar(400) DEFAULT NULL,
  `NUMOFPAGE` varchar(12) DEFAULT NULL,
  `APRMEMBERTITLE` varchar(200) DEFAULT NULL,
  `DRAFTER` varchar(200) DEFAULT NULL,
  `EXECUTEDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(200) DEFAULT NULL,
  `SENDINGMEMBERNAME` varchar(200) DEFAULT NULL,
  `MODIFYDATE` varchar(32) DEFAULT NULL,
  `MODIFYREASON` varchar(1020) DEFAULT NULL,
  `MODIFIERNAME` varchar(200) DEFAULT NULL,
  `MODIFIERID` varchar(400) DEFAULT NULL,
  `MODIFYFLAG` varchar(4) DEFAULT NULL,
  `DRAFTER2` varchar(200) DEFAULT NULL,
  `APRMEMBERTITLE2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) DEFAULT NULL,
  `SENDINGMEMBERNAME2` varchar(200) DEFAULT NULL,
  `MODIFIERNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`RECORDID`,`SEPERATEATTACHNO`,`VERSION`),
  CONSTRAINT `FK_TBL_RECORDHISTORY` FOREIGN KEY (`TENANT_ID`, `RECORDID`, `SEPERATEATTACHNO`) REFERENCES `tbl_seperateattach` (`TENANT_ID`, `RECORDID`, `SEPERATEATTACHNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `USERNAME` varchar(200) DEFAULT NULL,
  `USERTITLE` varchar(200) DEFAULT NULL,
  `DEPTCODE` varchar(28) DEFAULT NULL,
  `DEPTNAME` varchar(200) DEFAULT NULL,
  `READDATE` datetime DEFAULT NULL,
  `USERNAME2` varchar(200) DEFAULT NULL,
  `USERTITLE2` varchar(200) DEFAULT NULL,
  `DEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`SERIALNO`,`DOCID`)
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
  `USERNAME` varchar(200) DEFAULT NULL,
  `USERTITLE` varchar(200) DEFAULT NULL,
  `DEPTCODE` varchar(28) DEFAULT NULL,
  `DEPTNAME` varchar(200) DEFAULT NULL,
  `USERNAME2` varchar(200) DEFAULT NULL,
  `USERTITLE2` varchar(200) DEFAULT NULL,
  `DEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`RECORDID`,`SEPERATEATTACHNO`,`USERID`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `BRD_NM` varchar(510) DEFAULT NULL,
  `BRD_NM2` varchar(510) DEFAULT NULL,
  `BRD_GROUP` varchar(6) DEFAULT NULL,
  `BRD_GB` varchar(2) DEFAULT NULL,
  `BRD_REF` bigint(10) DEFAULT '0',
  `BRD_LEVEL` bigint(10) DEFAULT '0',
  `BRD_STEP` bigint(10) DEFAULT NULL,
  `BRD_POSTTERM` bigint(10) DEFAULT NULL,
  `BRD_EXPLAIN` varchar(4000) DEFAULT NULL,
  `BRD_ACCESS` varchar(2000) DEFAULT NULL,
  `BRD_UPPER` bigint(10) DEFAULT NULL,
  `BRD_COUNT` bigint(10) DEFAULT NULL,
  `BRD_URL` varchar(510) DEFAULT NULL,
  `ATTACH_SIZE` bigint(10) DEFAULT NULL,
  `REPLY_MAIL_FG` tinyint(1) DEFAULT NULL,
  `OWNDEPTID` varchar(100) DEFAULT NULL,
  `OWNDEPTNM` varchar(100) DEFAULT NULL,
  `OWNDEPTNM2` varchar(100) DEFAULT NULL,
  `OWNERID` varchar(24) DEFAULT NULL,
  `OWNERNM` varchar(32) DEFAULT NULL,
  `OWNERNM2` varchar(32) DEFAULT NULL,
  `OWNERPOSITION` varchar(20) DEFAULT NULL,
  `OWNERPOSITION2` varchar(100) DEFAULT NULL,
  `OWNERCALL` varchar(40) DEFAULT NULL,
  `MAKEDATE` varchar(16) DEFAULT NULL,
  `RESLOCATION` varchar(100) DEFAULT NULL,
  `BRD_UPPER2` varchar(8) DEFAULT NULL,
  `APPROVEFLAG` varchar(2) DEFAULT '0',
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`BRD_ID`,`BRD_COMPANY`)
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
  `MEMBER_NAM` varchar(200) DEFAULT NULL,
  `MEMBER_ID` varchar(80) NOT NULL,
  `ACCESS_LVL` varchar(2) DEFAULT NULL,
  `COMPANYID` varchar(40) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `PNUM` bigint(18) DEFAULT '0',
  `COMPANYID` varchar(40) NOT NULL,
  `WRITERID` varchar(40) DEFAULT NULL,
  `DEPTNM` varchar(100) DEFAULT NULL,
  `OWNERNM` varchar(40) DEFAULT NULL,
  `TITLE` varchar(100) DEFAULT NULL,
  `LOCATION` varchar(100) DEFAULT NULL,
  `TIMEDISPLAY` varchar(2) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `ALLDAY` varchar(2) DEFAULT NULL,
  `ALERTTIME` varchar(8) DEFAULT NULL,
  `CONTENT` longtext,
  `IMPORTANCE` varchar(2) DEFAULT NULL,
  `REFLAG` varchar(2) DEFAULT NULL,
  `GRESFLAG` varchar(2) DEFAULT NULL,
  `WRITEDAY` datetime DEFAULT NULL,
  `ENTRYLIST` varchar(400) DEFAULT NULL,
  `CHARACTERID` bigint(10) DEFAULT NULL,
  `ATTACHFLAG` varchar(2) DEFAULT NULL,
  `PUBLICFLAG` varchar(2) DEFAULT NULL,
  `APPROVEFLAG` varchar(2) DEFAULT '0',
  `SCHEDULEID` varchar(1000) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `BRDNM` varchar(200) DEFAULT NULL,
  `FORMTEXT` longtext,
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
  `OWNERNAME` varchar(100) NOT NULL,
  `OWNERNAME2` varchar(100) DEFAULT NULL,
  `CREATORID` varchar(100) NOT NULL,
  `CREATORNAME` varchar(100) NOT NULL,
  `CREATORNAME2` varchar(100) DEFAULT NULL,
  `CREATEDATE` datetime NOT NULL,
  `MODIFIERID` varchar(100) NOT NULL,
  `MODIFIERNAME` varchar(100) NOT NULL,
  `MODIFIERNAME2` varchar(100) DEFAULT NULL,
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
  `TITLE` varchar(500) NOT NULL,
  `LOCATION` varchar(500) NOT NULL,
  `CONTENTPATH` varchar(500) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`SCHEDULEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `USERNAME` varchar(120) NOT NULL,
  `USERNAME2` varchar(120) NOT NULL,
  `DEPARTMENTCN` varchar(80) NOT NULL,
  `DEPARTMENTNAME` varchar(120) NOT NULL,
  `DEPARTMENTNAME2` varchar(120) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`IDX`),
  UNIQUE KEY `IDX_TBL_SCHEDULE_PUBLIC_DEPT` (`TENANT_ID`,`USERCN`,`DEPARTMENTCN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedule_write_authority`
--

DROP TABLE IF EXISTS `tbl_schedule_write_authority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedule_write_authority` (
  `C_CLUBNO` varchar(40) NOT NULL,
  `C_CLUBNAME` varchar(200) DEFAULT NULL,
  `WRITER_DIVI` varchar(2) NOT NULL,
  `COMMENT_` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`C_CLUBNO`)
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
  `FILENAME` varchar(500) NOT NULL,
  `FILEPATH` varchar(500) NOT NULL,
  PRIMARY KEY (`ATTACHID`),
  UNIQUE KEY `IDX_TBL_SCHEDULEATTACH` (`ATTACHID`,`SCHEDULEID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedulecomment`
--

DROP TABLE IF EXISTS `tbl_schedulecomment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedulecomment` (
  `COMMENTID` bigint(10) NOT NULL AUTO_INCREMENT,
  `SCHEDULEID` bigint(10) NOT NULL,
  `COMMENTORID` varchar(100) NOT NULL,
  `COMMENTORNAME` varchar(100) NOT NULL,
  `COMMENTORNAME2` varchar(100) DEFAULT NULL,
  `COMMENTDATE` datetime NOT NULL,
  `COMMENT_` longtext NOT NULL,
  PRIMARY KEY (`COMMENTID`),
  UNIQUE KEY `IDX_TBL_SCHEDULECOMMENT` (`COMMENTID`,`SCHEDULEID`)
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
  `ENDTIME` varchar(8) NOT NULL,
  `AUTODELETE` bigint(10) NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`USERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_schedulegmailinfo`
--

DROP TABLE IF EXISTS `tbl_schedulegmailinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_schedulegmailinfo` (
  `USERID` varchar(100) NOT NULL,
  `FLAG` varchar(2) NOT NULL,
  `GMAILID` varchar(2000) DEFAULT NULL,
  `GMAILPWD` varchar(2000) DEFAULT NULL,
  PRIMARY KEY (`USERID`)
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
  `GROUPNAME` varchar(100) NOT NULL,
  `CREATORID` varchar(100) DEFAULT NULL,
  `CREATORNAME` varchar(100) NOT NULL,
  `CREATORNAME2` varchar(100) DEFAULT NULL,
  `DESCRIPTION` varchar(500) NOT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
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
  `MEMBERNAME` varchar(100) NOT NULL,
  `MEMBERNAME2` varchar(100) DEFAULT NULL,
  `STATUS` mediumint(5) NOT NULL,
  `RESPONSEDATE` datetime NOT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`GROUPID`,`MEMBERID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_scheduleshare`
--

DROP TABLE IF EXISTS `tbl_scheduleshare`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_scheduleshare` (
  `OWNERID` varchar(100) NOT NULL,
  `OWNERNAME` varchar(100) NOT NULL,
  `OWNERNAME2` varchar(100) DEFAULT NULL,
  `SHARERID` varchar(100) NOT NULL,
  `SHARERNAME` varchar(100) NOT NULL,
  `SHARERNAME2` varchar(100) DEFAULT NULL,
  `SHARETYPE` varchar(2) NOT NULL,
  `SHAREPERMISSION` varchar(2) NOT NULL,
  PRIMARY KEY (`OWNERID`,`SHARERID`)
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
  PRIMARY KEY (`TENANT_ID`,`VERSION`,`CABINETCLASSNO`,`SERIALNO`),
  CONSTRAINT `FK_TBL_SCHISTORY_CAB` FOREIGN KEY (`TENANT_ID`, `VERSION`, `CABINETCLASSNO`) REFERENCES `tbl_cabinethistory` (`TENANT_ID`, `VERSION`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  PRIMARY KEY (`TENANT_ID`,`RECORDID`,`SEPERATEATTACHNO`,`VERSION`,`SERIALNO`),
  CONSTRAINT `FK_TBL_SCHISTORY_REC` FOREIGN KEY (`TENANT_ID`, `RECORDID`, `SEPERATEATTACHNO`, `VERSION`) REFERENCES `tbl_recordhistory` (`TENANT_ID`, `RECORDID`, `SEPERATEATTACHNO`, `VERSION`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `SEALNAME` varchar(200) DEFAULT NULL,
  `SEALPATH` varchar(1020) DEFAULT NULL,
  `SEALWIDTH` double(126,0) DEFAULT NULL,
  `SEALHEIGHT` double(126,0) DEFAULT NULL,
  `REGDATE` datetime DEFAULT NULL,
  `DELDATE` datetime DEFAULT NULL,
  `REGUSERID` varchar(400) DEFAULT NULL,
  `REGUSERNAME` varchar(200) DEFAULT NULL,
  `REGUSERNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`SEALNUM`,`DEPTID`)
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
  `SEALNAME` varchar(200) DEFAULT NULL,
  `SEALPATH` varchar(1020) DEFAULT NULL,
  `SEALWIDTH` double(126,0) DEFAULT NULL,
  `SEALHEIGHT` double(126,0) DEFAULT NULL,
  `REGDATE` datetime DEFAULT NULL,
  `DELDATE` datetime DEFAULT NULL,
  `REGUSERID` varchar(400) DEFAULT NULL,
  `REGUSERNAME` varchar(200) DEFAULT NULL,
  `REGUSERNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`SEALNUM`)
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
  `USERNAME` varchar(100) NOT NULL,
  `USERNAME2` varchar(100) DEFAULT NULL,
  `SECRETARYID` varchar(100) NOT NULL,
  `SECRETARYNAME` varchar(100) NOT NULL,
  `SECRETARYNAME2` varchar(100) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
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
  PRIMARY KEY (`TENANT_ID`,`RECORDID`,`SEPERATEATTACHNO`),
  KEY `FK_TBL_SEPERATEATTACH_idx` (`TENANT_ID`,`CABINETID`),
  CONSTRAINT `FK_TBL_SEPERATEATTACH` FOREIGN KEY (`TENANT_ID`, `CABINETID`) REFERENCES `tbl_cabinet` (`TENANT_ID`, `CABINETID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0'
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
  PRIMARY KEY (`TENANT_ID`,`DOCID`,`APRSN`,`SIGNNAME`(255))
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `SC2` varchar(200) DEFAULT NULL,
  `SC3` varchar(200) DEFAULT NULL,
  `SC1` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`CABINETCLASSNO`,`SERIALNO`),
  CONSTRAINT `FK_TBL_SPECIALCATALOGINFO_CAB` FOREIGN KEY (`TENANT_ID`, `CABINETCLASSNO`) REFERENCES `tbl_cabinetclass` (`TENANT_ID`, `CABINETCLASSNO`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `SC2` varchar(200) DEFAULT NULL,
  `SC3` varchar(200) DEFAULT NULL,
  `SC1` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`RECORDID`,`SERIALNO`),
  CONSTRAINT `FK_TBL_SPECIALCATALOGINFO_REC` FOREIGN KEY (`TENANT_ID`, `RECORDID`) REFERENCES `tbl_record` (`TENANT_ID`, `RECORDID`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `PARENTID` bigint(10) NOT NULL,
  `OWNERID` varchar(100) NOT NULL,
  `CREATORID` varchar(100) NOT NULL,
  `CREATORNAME` varchar(100) NOT NULL,
  `CREATORNAME2` varchar(100) DEFAULT NULL,
  `CREATEDATE` datetime NOT NULL,
  `TASKSTATUS` mediumint(5) NOT NULL,
  `COMPLETERATE` mediumint(5) NOT NULL,
  `COMPLETEDATE` varchar(40) NOT NULL,
  `IMPORTANCE` mediumint(5) NOT NULL,
  `HASSHARE` varchar(2) NOT NULL,
  `HASATTACH` varchar(2) NOT NULL,
  `HASCOMMENT` varchar(2) NOT NULL,
  `STARTDATE` datetime NOT NULL,
  `ENDDATE` datetime NOT NULL,
  `REPETITION` varchar(100) DEFAULT NULL,
  `REPETITIONDELETE` varchar(500) DEFAULT NULL,
  `REPETITIONSTATUS` varchar(1000) DEFAULT NULL,
  `TITLE` varchar(500) NOT NULL,
  `CONTENTPATH` varchar(500) NOT NULL,
  `TASKTYPE` mediumint(5) DEFAULT NULL,
  `UPDATETIME` datetime DEFAULT NULL,
  `NEWANSWER` varchar(4) DEFAULT NULL,
  `NEWREFER` varchar(4) DEFAULT NULL,
  `PERSONID` varchar(100) DEFAULT NULL,
  `PERSONNAME` varchar(100) DEFAULT NULL,
  `PERSONNAME2` varchar(100) DEFAULT NULL,
  `PERSONDEPTNAME` varchar(100) DEFAULT NULL,
  `PERSONDEPTNAME2` varchar(100) DEFAULT NULL,
  `PERSONATTACH` varchar(2) DEFAULT NULL,
  `PERSONCONTENTPATH` varchar(500) DEFAULT NULL,
  `TASKPERSONID` varchar(100) DEFAULT NULL,
  `TASKPERSONNAME` varchar(100) DEFAULT NULL,
  `TASKPERSONNAME2` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TASKID`)
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
  `DESCRIPTION` varchar(600) DEFAULT NULL,
  `PROCESSDEPTNAME` varchar(200) DEFAULT NULL,
  `TASKTRANSFERFLAG` varchar(4) DEFAULT NULL,
  `TDEPTCODE` varchar(28) DEFAULT NULL,
  `PROCESSDEPTCODE` varchar(40) NOT NULL,
  `PROCESSDATE` varchar(48) DEFAULT NULL,
  `APPLYDATE` varchar(32) DEFAULT NULL,
  `TASKCODE` varchar(32) NOT NULL,
  `DELFLAG` varchar(4) DEFAULT '(0)',
  `DELETEDATE` datetime DEFAULT NULL,
  `ORGANCODE` varchar(28) DEFAULT NULL,
  `PROCESSDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`PROCESSDEPTCODE`,`TASKCODE`)
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
  `FILENAME` varchar(510) NOT NULL,
  `FILEPATH` varchar(100) NOT NULL,
  `TYPE` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`ATTACHID`),
  UNIQUE KEY `IDX_TBL_TASKATTACH` (`ATTACHID`,`TASKID`)
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
  `NAME` varchar(200) DEFAULT NULL,
  `DESCRIPTION` varchar(1020) DEFAULT NULL,
  `OLDFLAG` varchar(4) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`CATEGORYCODE`)
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
  `TASKNAME` varchar(200) DEFAULT NULL,
  `KEEPINGPERIOD` varchar(8) DEFAULT NULL,
  `CREATIONDATE` datetime DEFAULT NULL,
  `KPREASON` varchar(1000) DEFAULT NULL,
  `KEEPINGMETHOD` varchar(4) DEFAULT NULL,
  `KEEPINGPLACE` varchar(4) DEFAULT NULL,
  `DISPLAYRECFLAG` varchar(4) DEFAULT NULL,
  `DISPLAYRECTRASTIME` varchar(400) DEFAULT NULL,
  `EXDISPLAYFREQUENCY` varchar(4) DEFAULT NULL,
  `SPECIALCATALOGFLAG` varchar(4) DEFAULT NULL,
  `SC1` varchar(200) DEFAULT NULL,
  `SC2` varchar(200) DEFAULT NULL,
  `SC3` varchar(200) DEFAULT NULL,
  `DISPLAYUSAGE` varchar(4) DEFAULT NULL,
  `DESCRIPTION` varchar(1000) DEFAULT NULL,
  `TEMPFLAG` varchar(4) DEFAULT NULL,
  `SUBCATEGORYCODE` varchar(32) DEFAULT NULL,
  `DELFLAG` varchar(4) DEFAULT '0',
  `TASKNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`TASKCODE`),
  KEY `FK_TBL_TASKCODE_idx` (`TENANT_ID`,`SUBCATEGORYCODE`),
  CONSTRAINT `FK_TBL_TASKCODE` FOREIGN KEY (`TENANT_ID`, `SUBCATEGORYCODE`) REFERENCES `tbl_tasksubcategory` (`TENANT_ID`, `SUBCATEGORYCODE`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `TASKNAME` varchar(200) DEFAULT NULL,
  `CHANGEFACTOR` varchar(200) DEFAULT NULL,
  `BEFOREVALUE` varchar(1000) DEFAULT NULL,
  `AFTERVALUE` varchar(1200) DEFAULT NULL,
  `CHANGEFACTOR2` varchar(200) DEFAULT NULL,
  `TASKNAME2` varchar(200) DEFAULT NULL,
  `AFTERVALUE2` varchar(1200) DEFAULT NULL,
  `TENANT_ID` decimal(22,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`SN`),
  UNIQUE KEY `IDX_TBL_TASKCODEHISTORY` (`TENANT_ID`,`SN`)
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
  `COMMENTORNAME` varchar(100) NOT NULL,
  `COMMENTORNAME2` varchar(100) DEFAULT NULL,
  `COMMENTDATE` datetime NOT NULL,
  `T_COMMENT` longtext,
  PRIMARY KEY (`COMMENTID`),
  UNIQUE KEY `IDX_TBL_TASKCOMMENT` (`COMMENTID`,`TASKID`)
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
  `AUTODELETE` bigint(10) NOT NULL,
  PRIMARY KEY (`USERID`)
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
  `COMPLETEDATE` varchar(40) NOT NULL,
  PRIMARY KEY (`TASKID`,`REPEATCOUNT`)
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
  `NAME` varchar(200) DEFAULT NULL,
  `DESCRIPTION` varchar(1020) DEFAULT NULL,
  `CATEGORYCODE` varchar(32) DEFAULT NULL,
  `OLDFLAG` varchar(4) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`MCATEGORYCODE`),
  KEY `FK_TBL_TASKMIDDLECATEGORY_idx` (`TENANT_ID`,`CATEGORYCODE`),
  CONSTRAINT `FK_TBL_TASKMIDDLECATEGORY` FOREIGN KEY (`TENANT_ID`, `CATEGORYCODE`) REFERENCES `tbl_taskcategory` (`TENANT_ID`, `CATEGORYCODE`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `APPLYDATE` varchar(32) DEFAULT NULL,
  `REQUESTFLAG` varchar(4) NOT NULL,
  `PROCESSFLAG` bigint(10) DEFAULT NULL,
  `ORGANCODE` varchar(28) NOT NULL,
  `DEPTCODE` varchar(28) NOT NULL,
  `TASKCODE` varchar(32) DEFAULT NULL,
  `TASKNAME` varchar(200) DEFAULT NULL,
  `FILENAME` varchar(1020) DEFAULT NULL,
  `ERRMSG` longtext,
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
  `SHARERNAME` varchar(100) NOT NULL,
  `SHARERNAME2` varchar(100) DEFAULT NULL,
  `SHARERDEPTNAME` varchar(100) NOT NULL,
  `SHARERDEPTNAME2` varchar(100) DEFAULT NULL,
  `COMPLETERATE` mediumint(5) DEFAULT NULL,
  `COMPLETEDATE` varchar(40) DEFAULT NULL,
  `HASMEMO` varchar(2) DEFAULT NULL,
  `HASATTACH` varchar(2) DEFAULT NULL,
  `UPDATETIME` datetime DEFAULT NULL,
  `NEWORDER` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`TASKID`,`SHARERID`)
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
  `NAME` varchar(200) DEFAULT NULL,
  `DESCRIPTION` varchar(1020) DEFAULT NULL,
  `MCATEGORYCODE` varchar(32) DEFAULT NULL,
  `OLDFLAG` varchar(4) DEFAULT NULL,
  `NAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`SUBCATEGORYCODE`),
  KEY `FK_TBL_TASKSUBCATEGORY_idx` (`TENANT_ID`,`MCATEGORYCODE`),
  CONSTRAINT `FK_TBL_TASKSUBCATEGORY` FOREIGN KEY (`TENANT_ID`, `MCATEGORYCODE`) REFERENCES `tbl_taskmiddlecategory` (`TENANT_ID`, `MCATEGORYCODE`) ON DELETE NO ACTION ON UPDATE NO ACTION
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
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) DEFAULT NULL,
  `DISPLAYNAME3` varchar(510) DEFAULT NULL,
  `DISPLAYNAME4` varchar(510) DEFAULT NULL,
  `IMAGEURL` varchar(1000) DEFAULT NULL,
  `TOPURL` varchar(1000) DEFAULT NULL,
  `MAINURL` varchar(1000) DEFAULT NULL,
  `COMPANAYID` varchar(100) DEFAULT NULL,
  `CREATORID` varchar(100) DEFAULT NULL,
  `CREATORNM` varchar(100) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `TOPHEIGHT` bigint(10) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`)
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
  `ATTACHDOCNAME` varchar(1020) NOT NULL,
  `ATTACHDOCURL` varchar(1020) NOT NULL,
  `SUBATTACHYN` varchar(4) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(400) DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`SN`,`ATTACHSN`)
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
  `DOCTITLE` varchar(1020) DEFAULT NULL,
  `DOCNO` varchar(200) DEFAULT NULL,
  `HASATTACHYN` varchar(4) DEFAULT NULL,
  `HASOPINIONYN` varchar(4) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `WRITERID` varchar(400) DEFAULT NULL,
  `WRITERNAME` varchar(200) DEFAULT NULL,
  `WRITERJOBTITLE` varchar(200) DEFAULT NULL,
  `WRITERDEPTID` varchar(400) DEFAULT NULL,
  `WRITERDEPTNAME` varchar(200) DEFAULT NULL,
  `ISPUBLIC` varchar(4) DEFAULT NULL,
  `WRITERNAME2` varchar(200) DEFAULT NULL,
  `WRITERJOBTITLE2` varchar(200) DEFAULT NULL,
  `WRITERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`SN`)
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
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`SN`,`APRMEMBERSN`)
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
  `USERID` varchar(400) DEFAULT NULL,
  `OPINIONGB` varchar(12) DEFAULT NULL,
  `CONTENT` longtext,
  `USERNAME` varchar(200) DEFAULT NULL,
  `USERJOBTITLE` varchar(200) DEFAULT NULL,
  `USERDEPTID` varchar(400) DEFAULT NULL,
  `USERDEPTNAME` varchar(200) DEFAULT NULL,
  `OPINIONSN` bigint(10) NOT NULL,
  `USERNAME2` varchar(200) DEFAULT NULL,
  `USERJOBTITLE2` varchar(200) DEFAULT NULL,
  `USERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`SN`,`OPINIONSN`)
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
  `ATTACHFILENAME` varchar(1020) DEFAULT NULL,
  `ATTACHFILEHREF` varchar(1020) DEFAULT NULL,
  `ATTACHFILESIZE` double(126,0) DEFAULT NULL,
  `ATTACHUSERID` varchar(400) DEFAULT NULL,
  `ATTACHUSERNAME` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTID` varchar(400) DEFAULT NULL,
  `ATTACHUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `PAGENUM` bigint(10) DEFAULT NULL,
  `DISPLAYNAME` varchar(1020) DEFAULT NULL,
  `BODYATTACH` varchar(4) DEFAULT NULL,
  `ATTACHUSERNAME2` varchar(200) DEFAULT NULL,
  `ATTACHUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `ATTACHUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`SN`,`ATTACHFILESN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tbl_tmpexpaprdocinfo`
--

DROP TABLE IF EXISTS `tbl_tmpexpaprdocinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_tmpexpaprdocinfo` (
  `OWNERID` varchar(255) NOT NULL,
  `SN` bigint(10) NOT NULL,
  `SECURITYCODE` bigint(10) DEFAULT NULL,
  `STORAGEPERIOD` varchar(160) DEFAULT NULL,
  `KEYWORD` varchar(100) DEFAULT NULL,
  `FORMNAME` varchar(1020) DEFAULT NULL,
  `COMPANYID` varchar(1020) DEFAULT NULL,
  `ITEMCODE` varchar(160) DEFAULT NULL,
  `ITEMNAME` varchar(400) DEFAULT NULL,
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
  `SEPERATEATTACHXML` longtext,
  `SUMMARY` longtext,
  `FORMNAME2` varchar(1020) DEFAULT NULL,
  `ITEMNAME2` varchar(400) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`SN`)
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
  `PROXYUSERNAME` varchar(200) DEFAULT NULL,
  `PROXYUSERJOBTITLE` varchar(200) DEFAULT NULL,
  `PROXYUSERDEPTID` varchar(400) DEFAULT NULL,
  `PROXYUSERDEPTNAME` varchar(200) DEFAULT NULL,
  `PROXYUSERNAME2` varchar(200) DEFAULT NULL,
  `PROXYUSERJOBTITLE2` varchar(200) DEFAULT NULL,
  `PROXYUSERDEPTNAME2` varchar(200) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`SN`,`APRMEMBERSN`)
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
  `RECEIPTPOINTNAME` varchar(400) DEFAULT NULL,
  `EXTRECEPTYN` varchar(4) DEFAULT NULL,
  `PROCESSYN` varchar(4) DEFAULT NULL,
  `PROCESSSN` bigint(10) DEFAULT NULL,
  `CANEDITYN` varchar(4) DEFAULT NULL,
  `EXTRECEPTEMAIL` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERID` varchar(400) DEFAULT NULL,
  `RECEIPTMEMBERNAME` varchar(160) DEFAULT NULL,
  `PROCESSDATE` datetime DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE` varchar(80) DEFAULT NULL,
  `DEPTMEMBERSN` bigint(10) DEFAULT NULL,
  `RECEIPTPOINTNAME2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERJOBTITLE2` varchar(200) DEFAULT NULL,
  `RECEIPTMEMBERNAME2` varchar(200) DEFAULT NULL,
  `ROUTEYN` varchar(4) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL,
  PRIMARY KEY (`TENANT_ID`,`OWNERID`,`SN`,`RECEIPTPOINTID`)
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
  `DISPLAYNAME` varchar(510) DEFAULT NULL,
  `DISPLAYNAME2` varchar(510) DEFAULT NULL,
  `CREATORID` varchar(100) DEFAULT NULL,
  `CREATORNAME` varchar(100) DEFAULT NULL,
  `CREATEDATE` datetime DEFAULT NULL,
  `MODIFYDATE` datetime DEFAULT NULL,
  `WIDTH` bigint(10) DEFAULT NULL,
  `HEIGHT` bigint(10) DEFAULT NULL,
  `ROWLENGTH` bigint(10) DEFAULT NULL,
  `COLUMNLENGTH` bigint(10) DEFAULT NULL,
  `ROWSPLIT` varchar(100) DEFAULT NULL,
  `COLUMNSPLIT` varchar(100) DEFAULT NULL,
  `USEFLAG` varchar(2) DEFAULT NULL,
  `COMPANYID` varchar(510) DEFAULT NULL,
  `LANG` varchar(20) DEFAULT NULL,
  `TOPMNID` varchar(100) DEFAULT NULL,
  `BASETYPE` varchar(100) DEFAULT NULL,
  `THEMEUID` varchar(76) DEFAULT NULL,
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`,`PAGEUID`)
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
  `DISPLAYNAME` varchar(120) NOT NULL,
  `DISPLAYNAME2` varchar(120) DEFAULT NULL,
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
  `TITLE` varchar(200) DEFAULT NULL,
  `TITLE2` varchar(200) DEFAULT NULL,
  `TELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `HOMEPHONE` varchar(100) DEFAULT NULL,
  `FACSIMILETELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `MOBILE` varchar(100) DEFAULT NULL,
  `POSTALCODE` varchar(100) DEFAULT NULL,
  `STREETADDRESS` varchar(400) DEFAULT NULL,
  `INFO` varchar(2000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE1` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE2` varchar(200) DEFAULT NULL,
  `EXTENSIONATTRIBUTE3` varchar(2000) DEFAULT NULL,
  `EXTENSIONATTRIBUTE4` varchar(2000) DEFAULT NULL,
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
  `LOGINCNT` bigint(10) DEFAULT '0',
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
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
  `DISPLAYNAME` varchar(120) NOT NULL,
  `DISPLAYNAME2` varchar(120) DEFAULT NULL,
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
  `TITLE` varchar(200) DEFAULT NULL,
  `TITLE2` varchar(200) DEFAULT NULL,
  `TELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `HOMEPHONE` varchar(100) DEFAULT NULL,
  `FACSIMILETELEPHONENUMBER` varchar(100) DEFAULT NULL,
  `MOBILE` varchar(100) DEFAULT NULL,
  `POSTALCODE` varchar(100) DEFAULT NULL,
  `STREETADDRESS` varchar(400) DEFAULT NULL,
  `INFO` varchar(2000) DEFAULT NULL,
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  `PASSWORD` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`TENANT_ID`,`CN`)
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
  `TENANT_ID` mediumint(5) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TENANT_ID`,`UID_`,`ACCESSID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
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
 1 AS `URGENTAPPROVAL`*/;
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
 1 AS `URGENTAPPROVAL`*/;
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
/*!50001 VIEW `vaprdoingdoclist` AS select `tbl_aprdocinfo`.`DOCID` AS `DOCID`,`tbl_aprdocinfo`.`FORMID` AS `FORMID`,`tbl_aprdocinfo`.`ORGDOCID` AS `ORGDOCID`,`tbl_aprdocinfo`.`DOCTYPE` AS `DOCTYPE`,`tbl_aprdocinfo`.`DOCSTATE` AS `DOCSTATE`,`tbl_aprdocinfo`.`FUNCTIONTYPE` AS `FUNCTIONTYPE`,`tbl_aprdocinfo`.`HREF` AS `HREF`,`tbl_aprdocinfo`.`DOCTITLE` AS `DOCTITLE`,`tbl_aprdocinfo`.`DOCNO` AS `DOCNO`,`tbl_aprdocinfo`.`HASATTACHYN` AS `HASATTACHYN`,`tbl_aprdocinfo`.`HASOPINIONYN` AS `HASOPINIONYN`,`tbl_aprdocinfo`.`STARTDATE` AS `STARTDATE`,`tbl_aprdocinfo`.`ENDDATE` AS `ENDDATE`,`tbl_aprdocinfo`.`WRITERID` AS `WRITERID`,`tbl_aprdocinfo`.`WRITERNAME` AS `WRITERNAME`,`tbl_aprdocinfo`.`WRITERJOBTITLE` AS `WRITERJOBTITLE`,`tbl_aprdocinfo`.`WRITERDEPTID` AS `WRITERDEPTID`,`tbl_aprdocinfo`.`WRITERDEPTNAME` AS `WRITERDEPTNAME`,`tbl_aprdocinfo`.`ISPUBLIC` AS `ISPUBLIC`,`tbl_aprdocinfo`.`WRITERNAME2` AS `WRITERNAME2`,`tbl_aprdocinfo`.`WRITERJOBTITLE2` AS `WRITERJOBTITLE2`,`tbl_aprdocinfo`.`WRITERDEPTNAME2` AS `WRITERDEPTNAME2`,`tbl_aprdocinfo`.`TENANT_ID` AS `TENANT_ID`,`tbl_aprlineinfo`.`APRMEMBERSN` AS `APRMEMBERSN`,`tbl_aprlineinfo`.`APRTYPE` AS `APRTYPE`,`tbl_aprlineinfo`.`APRSTATE` AS `APRSTATE`,`tbl_aprlineinfo`.`APRMEMBERID` AS `APRMEMBERID`,`tbl_aprlineinfo`.`APRMEMBERNAME` AS `APRMEMBERNAME`,`tbl_aprlineinfo`.`APRMEMBERNAME2` AS `APRMEMBERNAME2`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE` AS `APRMEMBERJOBTITLE`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE2` AS `APRMEMBERJOBTITLE2`,`tbl_aprlineinfo`.`APRMEMBERDEPTID` AS `APRMEMBERDEPTID`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME` AS `APRMEMBERDEPTNAME`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME2` AS `APRMEMBERDEPTNAME2`,`tbl_aprlineinfo`.`RECEIVEDDATE` AS `RECEIVEDDATE`,`tbl_expaprdocinfo`.`FORMNAME` AS `FORMNAME`,`tbl_expaprdocinfo`.`FORMNAME2` AS `FORMNAME2`,`tbl_expaprdocinfo`.`URGENTAPPROVAL` AS `URGENTAPPROVAL` from ((`tbl_aprdocinfo` join `tbl_aprlineinfo` on(((`tbl_aprdocinfo`.`DOCID` = `tbl_aprlineinfo`.`DOCID`) and (`tbl_aprdocinfo`.`TENANT_ID` = `tbl_aprlineinfo`.`TENANT_ID`)))) join `tbl_expaprdocinfo` on(((`tbl_aprdocinfo`.`DOCID` = `tbl_expaprdocinfo`.`DOCID`) and (`tbl_aprdocinfo`.`TENANT_ID` = `tbl_expaprdocinfo`.`TENANT_ID`)))) where (((`tbl_aprlineinfo`.`APRSTATE` = '002') or (`tbl_aprlineinfo`.`APRSTATE` = '005')) and (`tbl_aprdocinfo`.`STARTDATE` is not null)) */;
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
/*!50001 VIEW `vaprwilldoclist` AS select `tbl_aprdocinfo`.`DOCID` AS `DOCID`,`tbl_aprdocinfo`.`FORMID` AS `FORMID`,`tbl_aprdocinfo`.`ORGDOCID` AS `ORGDOCID`,`tbl_aprdocinfo`.`DOCTYPE` AS `DOCTYPE`,`tbl_aprdocinfo`.`DOCSTATE` AS `DOCSTATE`,`tbl_aprdocinfo`.`FUNCTIONTYPE` AS `FUNCTIONTYPE`,`tbl_aprdocinfo`.`HREF` AS `HREF`,`tbl_aprdocinfo`.`DOCTITLE` AS `DOCTITLE`,`tbl_aprdocinfo`.`DOCNO` AS `DOCNO`,`tbl_aprdocinfo`.`HASATTACHYN` AS `HASATTACHYN`,`tbl_aprdocinfo`.`HASOPINIONYN` AS `HASOPINIONYN`,`tbl_aprdocinfo`.`STARTDATE` AS `STARTDATE`,`tbl_aprdocinfo`.`ENDDATE` AS `ENDDATE`,`tbl_aprdocinfo`.`WRITERID` AS `WRITERID`,`tbl_aprdocinfo`.`WRITERNAME` AS `WRITERNAME`,`tbl_aprdocinfo`.`WRITERJOBTITLE` AS `WRITERJOBTITLE`,`tbl_aprdocinfo`.`WRITERDEPTID` AS `WRITERDEPTID`,`tbl_aprdocinfo`.`WRITERDEPTNAME` AS `WRITERDEPTNAME`,`tbl_aprdocinfo`.`ISPUBLIC` AS `ISPUBLIC`,`tbl_aprdocinfo`.`WRITERNAME2` AS `WRITERNAME2`,`tbl_aprdocinfo`.`WRITERJOBTITLE2` AS `WRITERJOBTITLE2`,`tbl_aprdocinfo`.`WRITERDEPTNAME2` AS `WRITERDEPTNAME2`,`tbl_aprdocinfo`.`TENANT_ID` AS `TENANT_ID`,`tbl_aprlineinfo`.`APRMEMBERSN` AS `APRMEMBERSN`,`tbl_aprlineinfo`.`APRTYPE` AS `APRTYPE`,`tbl_aprlineinfo`.`APRSTATE` AS `APRSTATE`,`tbl_aprlineinfo`.`APRMEMBERID` AS `APRMEMBERID`,`tbl_aprlineinfo`.`APRMEMBERNAME` AS `APRMEMBERNAME`,`tbl_aprlineinfo`.`APRMEMBERNAME2` AS `APRMEMBERNAME2`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE` AS `APRMEMBERJOBTITLE`,`tbl_aprlineinfo`.`APRMEMBERJOBTITLE2` AS `APRMEMBERJOBTITLE2`,`tbl_aprlineinfo`.`APRMEMBERDEPTID` AS `APRMEMBERDEPTID`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME` AS `APRMEMBERDEPTNAME`,`tbl_aprlineinfo`.`APRMEMBERDEPTNAME2` AS `APRMEMBERDEPTNAME2`,`tbl_expaprdocinfo`.`FORMNAME` AS `FORMNAME`,`tbl_expaprdocinfo`.`FORMNAME2` AS `FORMNAME2`,`tbl_expaprdocinfo`.`URGENTAPPROVAL` AS `URGENTAPPROVAL` from ((`tbl_aprdocinfo` join `tbl_aprlineinfo` on(((`tbl_aprdocinfo`.`DOCID` = `tbl_aprlineinfo`.`DOCID`) and (`tbl_aprdocinfo`.`TENANT_ID` = `tbl_aprlineinfo`.`TENANT_ID`)))) join `tbl_expaprdocinfo` on(((`tbl_aprdocinfo`.`DOCID` = `tbl_expaprdocinfo`.`DOCID`) and (`tbl_aprdocinfo`.`TENANT_ID` = `tbl_expaprdocinfo`.`TENANT_ID`)))) where (`tbl_aprdocinfo`.`STARTDATE` is not null) */;
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
/*!50001 VIEW `vtaskclass` AS select `tbl_taskcategory`.`CATEGORYCODE` AS `CATEGORYCODE`,`tbl_taskcategory`.`NAME` AS `CNAME`,`tbl_taskcategory`.`NAME2` AS `CNAME2`,`tbl_taskmiddlecategory`.`MCATEGORYCODE` AS `MCATEGORYCODE`,`tbl_taskmiddlecategory`.`NAME` AS `MCNAME`,`tbl_taskmiddlecategory`.`NAME2` AS `MCNAME2`,`tbl_tasksubcategory`.`SUBCATEGORYCODE` AS `SUBCATEGORYCODE`,`tbl_tasksubcategory`.`NAME` AS `SCNAME`,`tbl_tasksubcategory`.`NAME2` AS `SCNAME2`,`tbl_taskcode`.`TASKCODE` AS `TASKCODE`,`tbl_taskcode`.`TASKNAME` AS `TASKNAME`,`tbl_taskcode`.`TASKNAME2` AS `TASKNAME2`,`tbl_taskcode`.`KEEPINGPERIOD` AS `KEEPINGPERIOD`,`tbl_taskcode`.`DISPLAYRECFLAG` AS `DISPLAYRECFLAG`,`tbl_taskcode`.`SPECIALCATALOGFLAG` AS `SPECIALCATALOGFLAG`,`tbl_taskcode`.`SC1` AS `SC1`,`tbl_taskcode`.`SC2` AS `SC2`,`tbl_taskcode`.`SC3` AS `SC3`,`tbl_taskcode`.`TEMPFLAG` AS `TEMPFLAG`,`tbl_taskcode`.`TENANT_ID` AS `TENANT_ID`,`tbl_task_deptinfo`.`PROCESSDEPTCODE` AS `PROCESSDEPTCODE`,`tbl_task_deptinfo`.`PROCESSDEPTNAME` AS `PROCESSDEPTNAME`,`tbl_task_deptinfo`.`PROCESSDEPTNAME2` AS `PROCESSDEPTNAME2`,`tbl_taskcode`.`KEEPINGMETHOD` AS `KEEPINGMETHOD`,`tbl_taskcode`.`KEEPINGPLACE` AS `KEEPINGPLACE`,`tbl_taskcode`.`DISPLAYRECTRASTIME` AS `DISPLAYRECTRASTIME`,`tbl_task_deptinfo`.`DELFLAG` AS `DELFLAG` from ((((`tbl_taskcategory` join `tbl_taskmiddlecategory` on(((`tbl_taskcategory`.`CATEGORYCODE` = `tbl_taskmiddlecategory`.`CATEGORYCODE`) and (`tbl_taskcategory`.`TENANT_ID` = `tbl_taskmiddlecategory`.`TENANT_ID`)))) join `tbl_tasksubcategory` on(((`tbl_taskmiddlecategory`.`MCATEGORYCODE` = `tbl_tasksubcategory`.`MCATEGORYCODE`) and (`tbl_taskmiddlecategory`.`TENANT_ID` = `tbl_tasksubcategory`.`TENANT_ID`)))) join `tbl_taskcode` on(((`tbl_tasksubcategory`.`SUBCATEGORYCODE` = `tbl_taskcode`.`SUBCATEGORYCODE`) and (`tbl_tasksubcategory`.`TENANT_ID` = `tbl_taskcode`.`TENANT_ID`)))) left join `tbl_task_deptinfo` on(((`tbl_taskcode`.`TASKCODE` = `tbl_task_deptinfo`.`TASKCODE`) and (`tbl_taskcode`.`TENANT_ID` = `tbl_task_deptinfo`.`TENANT_ID`)))) where ((`tbl_task_deptinfo`.`DELFLAG` = '0') or isnull(`tbl_task_deptinfo`.`DELFLAG`) or (`tbl_task_deptinfo`.`DELFLAG` = '2')) */;
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
