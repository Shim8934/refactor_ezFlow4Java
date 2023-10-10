/* 테넌트 도메인 변경 스크립트 */
UPDATE james_recipient_rewrite SET DOMAIN_NAME = REPLACE(DOMAIN_NAME, 'old.kaoni.com', 'new.kaoni.com');
UPDATE james_domain SET DOMAIN_NAME = REPLACE(DOMAIN_NAME, 'old.kaoni.com', 'new.kaoni.com');
UPDATE james_user SET USER_NAME = REPLACE (USER_NAME, 'old.kaoni.com','new.kaoni.com');
UPDATE jmocha_default_quota SET DOMAIN_NAME = REPLACE (DOMAIN_NAME, 'old.kaoni.com', 'new.kaoni.com');
UPDATE tbl_tenant_config SET PROPERTY_VALUE = REPLACE (PROPERTY_VALUE, 'old.kaoni.com', 'new.kaoni.com');
UPDATE tbl_deptmaster SET MAIL = REPLACE (MAIL, 'old.kaoni.com', 'new.kaoni.com');
UPDATE tbl_usermaster SET MAIL = REPLACE (MAIL, 'old.kaoni.com', 'new.kaoni.com');