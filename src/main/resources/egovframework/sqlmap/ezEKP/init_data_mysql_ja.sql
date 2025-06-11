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

-- 2023.08.08 한슬기 tenant_id변경을 위한 변수선언 및 values의 tenant_id 변수로 교체(멀티테넌트 사용)
SET @tenant_id_value = 0;

-- 조직도 정보
INSERT INTO `tbl_tenant` (`TENANT_ID`,`TENANT_NAME`,`TENANT_NAME2`) VALUES (@tenant_id_value,'組織図','OrganizationChart');
INSERT INTO `tbl_deptmaster` (`TENANT_ID`,`CN`,`DISPLAYNAME`,`DISPLAYNAME2`,`USEFLAG`,`MAIL`,`COMPNM2`,`DEPTLEVEL`,`DEPT_CD_PATH`,`DEPT_NM_PATH`,`EXTENSIONATTRIBUTE1`,`EXTENSIONATTRIBUTE2`,`EXTENSIONATTRIBUTE3`,`EXTENSIONATTRIBUTE4`,`EXTENSIONATTRIBUTE5`,`EXTENSIONATTRIBUTE6`,`EXTENSIONATTRIBUTE7`,`EXTENSIONATTRIBUTE8`,`EXTENSIONATTRIBUTE9`,`EXTENSIONATTRIBUTE10`,`EXTENSIONATTRIBUTE11`,`EXTENSIONATTRIBUTE12`,`EXTENSIONATTRIBUTE13`,`EXTENSIONATTRIBUTE14`,`EXTENSIONATTRIBUTE15`,`ADFLAG`,`ADSPATH`,`UPDATEDT`,`DEPTTREEFLAG`) VALUES (@tenant_id_value,'Top','組織図','OrganizationChart',NULL,'Top@jtest.kaoni.com','OrganizationChart','1','Top','組織図',NULL,'Top','組織図',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','CN=Top,OU=組織図,OU=TopGroup,DC=jtest,DC=kaoni,DC=com','2017-01-06 00:00:00','Y');
INSERT INTO `tbl_usermaster` (`TENANT_ID`,`CN`,`DISPLAYNAME`,`DISPLAYNAME2`,`MAIL`,`MAILNICKNAME`,`UPNNAME`,`DEPARTMENT`,`DESCRIPTION`,`DESCRIPTION2`,`DESCRIPTION3`,`PHYSICALDELIVERYOFFICENAME`,`COMPANY`,`COMPANY2`,`TITLE`,`TITLE2`,`TELEPHONENUMBER`,`HOMEPHONE`,`FACSIMILETELEPHONENUMBER`,`MOBILE`,`POSTALCODE`,`STREETADDRESS`,`INFO`,`EXTENSIONATTRIBUTE1`,`EXTENSIONATTRIBUTE2`,`EXTENSIONATTRIBUTE3`,`EXTENSIONATTRIBUTE4`,`EXTENSIONATTRIBUTE5`,`EXTENSIONATTRIBUTE6`,`EXTENSIONATTRIBUTE7`,`EXTENSIONATTRIBUTE8`,`EXTENSIONATTRIBUTE9`,`EXTENSIONATTRIBUTE10`,`EXTENSIONATTRIBUTE102`,`EXTENSIONATTRIBUTE11`,`EXTENSIONATTRIBUTE12`,`EXTENSIONATTRIBUTE13`,`EXTENSIONATTRIBUTE14`,`EXTENSIONATTRIBUTE15`,`ADSPATH`,`SIPURI`,`UPDATEDT`,`CREATEDT`,`MOBILE_ENABLE`,`MOBILE_NOTUSE`,`MOBILE_PIN`,`POSITIONCD`,`BIRTH`,`BIRTHTYPE`,`PASSWORD`,`IPADDRESS`,`LASTLOGIN`,`LOGINCNT`,`LISTTYPE`,`USERTREEFLAG`) VALUES (@tenant_id_value,'masteradmin','Master','MasterAdmin','masteradmin@jtest.kaoni.com','masteradmin',NULL,'Top','組織図','OrganizationChart',NULL,'Top','組織図','OrganizationChart','MasterAdmin','MasterAdmin',NULL,NULL,NULL,NULL,NULL,NULL,' ','c=1;k=1;g=1;a=1;i=1;l=1;n=1;m=1;w=1;t=1;e=1;q=1',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'MasterAdmin','MasterAdmin',NULL,NULL,NULL,NULL,'1','CN=masteradmin,OU=사용자,OU=組織図,OU=TopGroup,DC=jtest,DC=kaoni,DC=com',NULL,'2017-01-06 00:00:00','2017-01-06 00:00:00',NULL,'N',NULL,NULL,NULL,'Y','m7jsQtm1Uqm+n51H00wciQOeQm9rlarZxD0wuM9QVCU=','0:0:0:0:0:0:0:1','2017-01-06 00:00:00',0,'TXT','Y');

-- primaryLang
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'PrimaryLang', '시스템 언어', '3', '시스템 primary 언어를 설정한다.1: 한국어3: 일본어  (default: 1)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangPrimary5', '멀티언어5(메인)', '', '', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangPrimary4', '멀티언어4(메인)', '日本語', '', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangPrimary3', '멀티언어3(메인)', '日本語', '', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangPrimary2', '멀티언어2(메인)', 'Japanese', '', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangPrimary1', '멀티언어1(메인)', '일본어', '시스템 언어에 따른 멀티언어(메인) 셋팅', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'PrimaryTimeZone', '시스템 표준 시간대', '230|+09:00', '시스템 primary 표준 시간대를 설정한다.시스템 Primary 표준 시간대 설정  (첫 로그인 시 사용자의 표준 시간대를 정할 수 없을 경우 시스템의 표준 시간대를 따름) (default: 230|+09:00)', '2017-01-06 00:00:00', '일반');

-- 게시판
INSERT INTO TBL_Board_BoardInfo (BoardID, BoardName, BoardName2, BoardName3, BoardName4, TreeViewOrder, BoardLevel, ParentBoardID, BoardDescription, ItemExpires, AttachsizeLimit, ReplyNotify, BoardGroupID, AlertPostItem, Gubun, URL, DeleteAfter, BoardColor, BoardNo, Portlet, tenant_ID, companyID) VALUES ('{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}', '新着', 'New BoardItem', '新着', '新帖子', -1, 0, 'None', NULL, 0, NULL, 0, NULL, 0, 0, NULL, 0, NULL, 0, 'N', @tenant_id_value, 'Top');
INSERT INTO TBL_Board_MyBoards (UserID, BoardID, BoardName, BoardName2, BoardName3, BoardName4, TreeviewNum, companyID, tenant_ID) VALUES ('everyone', '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}', '新着', 'New BoardItem', '新着', '新帖子', -1, 'Top',@tenant_id_value);

-- 전자결재
INSERT INTO   TBL_FormContainer  (FormContID,  FormContName,  FormContOwnDepID,  FormContParents,  FormContdescription,  FormContName2, COMPANYID, TENANT_ID) VALUES (N'2004000001', N'共通', N'ALL', N'ROOT', N'共通', N'DEPT003','Top',@tenant_id_value);
-- INSERT INTO   TBL_FormContainer  (FormContID,  FormContName,  FormContOwnDepID,  FormContParents,  FormContdescription,  FormContName2, COMPANYID, TENANT_ID) VALUES (N'2004000003', N'HWP양식함', N'ALL', N'ROOT', NULL, NULL,'Top',@tenant_id_value);

-- INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES ('ZZ000001', N'共通', N'共通', NULL, N'C','Top',@tenant_id_value);
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZA000001', N'総務行政', N'総務行政', NULL, N'총무행정_Eng','Top',@tenant_id_value);
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZB000001', N'経済', N'経済', NULL, N'경제_Eng','Top',@tenant_id_value);
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZC000001', N'財務', N'財務', NULL, N'재무_Eng','Top',@tenant_id_value);
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZZ000001', N'監事', N'監事', NULL, N'감사_Eng','Top',@tenant_id_value);
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZZ000002', N'資料', N'資料', NULL, N'에너지_Eng','Top',@tenant_id_value);

INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'100', N'稟議箱', N'Draft','Top',@tenant_id_value);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'200', N'協調箱', N'Support','Top',@tenant_id_value);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'300', N'監事箱', N'Audit','Top',@tenant_id_value);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'500', N'受信箱', N'Receive','Top',@tenant_id_value);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'600', N'合意箱', N'Agree','Top',@tenant_id_value);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'610', N'発信箱', N'Send','Top',@tenant_id_value);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'700', N'返送箱', N'Reject','Top',@tenant_id_value);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'999', N'廃棄箱', N'Obsolete','Top',@tenant_id_value);

-- INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'aa000001', N'共通', N'共通', N'ZZ000001', NULL, N'COMMON','Top',@tenant_id_value);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'aa000001', N'監事結果処理', N'監事結果処理', N'ZZ000001', NULL, N'감사결과처리_Eng','Top',@tenant_id_value);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'aa000002', N'人事管理', N'人事管理', N'ZZ000001', NULL, N'인사관리_Eng','Top',@tenant_id_value);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ab000001', N'記録管理', N'記録管理', N'ZA000001', NULL, N'기록관리_Eng','Top',@tenant_id_value);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ac000001', N'経済協力', N'経済協力', N'ZB000001', NULL, N'경제협력_Eng','Top',@tenant_id_value);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ad000001', N'租税', N'租税', N'ZC000001', NULL, N'조세_Eng','Top',@tenant_id_value);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'cb000001', N'記録管理', N'記録管理', N'ZA000001', NULL, N'기록관리_Eng','Top',@tenant_id_value);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'cc000001', N'人事管理', N'人事管理', N'ZA000001', NULL, N'인사관리_Eng','Top',@tenant_id_value);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZZ000022', N'資料', N'資料', N'ZZ000002', NULL, N'에너지용_Eng','Top',@tenant_id_value);

INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDXS',		'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'INIT',						'When loading a document (draft, reception)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_SIGN_INIT',			'When loading a document (approval)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DOCNUM_BEFORE',			'Immediately before submitting the document number (at the final screening of all screens)',			'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DOCNUM_AFTER',				'Immediately after submitting the document number (at the final screening of all screens)',			'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DRAFTSAVE_BEFORE',			'Immediately before draft(approval)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DRAFTSAVE_AFTER',			'Immediately after draft(approval)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DOCNUM_END',				'Immediately after final approval (draft)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_SIGN_BEFORE',		'Immediately before signing a mediator (approval)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_SIGN_AFTER',		'Immediately after signing a mediator (approval)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_END_AFTER',			'Successful approval of mediator(approval)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_END_FAIL',			'fail approval of mediator(approval)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'LAST_SIGN_BEFORE',			'Immediately before final signing (approval)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'LAST_SIGN_AFTER',			'Immediately after final signing (approval)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'END_FAIL',					'If the payment is unsuccessful (at the final screen of all screens)',			'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'SUSIN_DRAFTSAVE_BEFORE',	'Immediately before receipt of documents (receiption desk)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'SUSIN_DRAFTSAVE_AFTER',	'Immediately after receipt of documents (receiption desk)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'SUSIN_DOCNUM_END',			'After receipt of documents (reception)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'LAST_SEND_BEFORE',			'Immediately before final approval (draft)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'LAST_END_AFTER',			'Immediately after final approval (receipt of received documents)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'BANSONG_BEFORE',			'Immediately before the return (approval)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'BANSONG_AFTER',			'When the return is successful (approval)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'BANSONG_FAIL',				'When the return is failed (approval)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIMES',		'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'DRAFT',					'Call at the time of approval (Draft document)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'REDRAFT',					'call when redraft (draft when redraft)',			'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'SUSIN',					'Incoming document status call (Incoming document)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'HAPYUI',					'Agreement Document Status Call (Agreement Document)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'CHAMJO',					'Reference Document State Call (not implemented)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'GONGRAM',					'display document status (not implemented)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'GAMSA',					'Post-audit document status call (not implemented)',				'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'B_GAMSA',					'Pre-audit document status call (not implemented)',				'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('CONNSTRINGFLAGS',	'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('CONNSTRINGFLAG',		'CS',						'Connection imformation(If no exist, auto fill)',					'CONNSTRINGFLAGS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('CONNSTRINGFLAG',		'UI',						'Screen Dialog Information',						'CONNSTRINGFLAGS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPES',			'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPE',			'Q',						'Query execution',							'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPE',			'NA',						'Aspx without UI',						'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPE',			'UA',						'Aspx with UI(pass xml String)',		'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPE',			'UA_EX',					'Aspx with UI(pass xml Document)',	'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('KEYKINDS',			'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('KEYKIND',			'single',					'Field object',							'KEYKINDS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('KEYKIND',			'table',					'Table support (not implemented)',						'KEYKINDS');

-- resource insert

-- attitude Type
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A01', 'Top',@tenant_id_value, '出勤', 'check in', '1', 'inOut', null, 1);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A02', 'Top',@tenant_id_value, '遅刻', 'late', '1', 'inOut', null, 2);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A03', 'Top',@tenant_id_value, '退勤', 'check out', '1', 'inOut', null, 3);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A07', 'Top',@tenant_id_value, '休出', 'working Holiday', '1', 'inOut', null, 6);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A04', 'Top',@tenant_id_value, '外部勤務', 'outside work', '1', 'trip', null, 8);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A06', 'Top',@tenant_id_value, '外出', 'outing', '1', 'trip', null, 6);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A05', 'Top',@tenant_id_value, '休暇', 'vacation', '1', 'refresh', null, 0);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A09', 'Top',@tenant_id_value, '出張', 'business trip', '1', 'trip', null, 7);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A10', 'Top',@tenant_id_value, '派遣', 'dispatch', '1', 'trip', null, 7);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A08', 'Top',@tenant_id_value, '早退', 'early leave', '1', 'absence', null, 5);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A17', 'Top',@tenant_id_value, '欠勤', 'absenteeism', '1', 'absence', null, 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A11', 'Top',@tenant_id_value, '有給休暇', 'annual leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A12', 'Top',@tenant_id_value, '午前有給', 'morning off', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A13', 'Top',@tenant_id_value, '午後有給', 'afternoon off', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A14', 'Top',@tenant_id_value, '公暇', 'official leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A15', 'Top',@tenant_id_value, '午前公暇', 'morning official leave', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A16', 'Top',@tenant_id_value, '午後公暇', 'after official leave', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A18', 'Top',@tenant_id_value, '産休', 'maternity leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A19', 'Top',@tenant_id_value, '慶弔', 'congratulation and condolence leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A20', 'Top',@tenant_id_value, '病休', 'sick leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A21', 'Top',@tenant_id_value, '半半有給', 'half off', '1', 'refresh', 'A05', 4);


Insert into TBL_RS_BRD (BRD_ID,BRD_COMPANY,BRD_NM,BRD_NM2,BRD_GROUP,BRD_GB,BRD_REF,BRD_LEVEL,BRD_STEP,BRD_POSTTERM,BRD_EXPLAIN,BRD_ACCESS,BRD_UPPER,BRD_COUNT,BRD_URL,ATTACH_SIZE,REPLY_MAIL_FG,OWNDEPTID,OWNDEPTNM,OWNDEPTNM2,OWNERID,OWNERNM,OWNERNM2,OWNERPOSITION,OWNERPOSITION2,OWNERCALL,MAKEDATE,RESLOCATION,BRD_UPPER2,APPROVEFLAG,TENANT_ID) values (1,'Top','組織図','OrganizationChart','A00','1',0,0,1,365,'',null,0,0,' ',20,null,null,null,null,null,null,null,null,null,null,null,null,null,'0',@tenant_id_value);
Insert into TBL_CAR (CAR_ID, CAR_NAME, CAR_NAME2, CAR_NM, CAR_GB, CAR_LEVEL, CAR_STEP, CAR_ACCESS, CAR_UPPER, OWNDEPTID, OWNDEPTNM, OWNDEPTNM2,OWNERID, OWNERNM, OWNERNM2, OWNERPOSITION, OWNERPOSITION2, OWNERCALL, CAR_REGISTER_DATE, DELFLAG, COMPANYID, TENANT_ID, CAR_URL, CAR_EXPLAIN)  values (1,'Top','組織図','OrganizationChart',1,0,1,null,0,null,null,null,null,null,null,null,null,null,null,0,'Top',@tenant_id_value,null,null);
-- portal insert
