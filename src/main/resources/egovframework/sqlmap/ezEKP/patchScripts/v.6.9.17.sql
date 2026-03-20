-- 테넌트 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES ('0', 'useParticipantLottery', '전자설문 참여자보기 추첨기능 사용여부', 'N', '전자설문 참여자보기에서 추첨기능 사용여부. YES: 사용, NO: 미사용 (default:N)', '2025-07-14 00:00:00.000', '전자설문');

CREATE INDEX jmocha_address_last_sent_TENANT_ID_IDX ON jmocha_address_last_sent (TENANT_ID,CN);

CREATE TABLE `jmocha_shared_mailfolder` (
  `simple_idx` int(11) NOT NULL AUTO_INCREMENT,
  `mailbox_id` varchar(100) DEFAULT NULL,
  `sharer` varchar(100) DEFAULT NULL,
  `share_member` varchar(100) DEFAULT NULL,
   PRIMARY KEY (`simple_idx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE)
        VALUES ('0', 'useSharedMailFolder', 'YES', '공유편지함 기능 사용 여부 (default:NO)', '공유편지함 기능 사용 여부', '2026-01-06 00:00:00', '메일');