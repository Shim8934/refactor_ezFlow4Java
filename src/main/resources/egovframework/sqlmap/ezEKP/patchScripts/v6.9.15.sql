-- v6.9.15
-- #155121 결함 수정으로 테넌트 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES	(@tenant_id_value, 'accountYearTimeZone', '전자결재 회계년도 계산 시 타임존 선택 옵션', 'KST', '회계년도 계산 시, UTC 또는 KST (한국 표준시)를 사용할지 선택한다. (default: KST)', '2025-04-29 00:00:00', '전자결재G');
