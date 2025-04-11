/* init_data_tibero 사용 X, init_data_oracle로 사용하세요.

SET DEFINE OFF;
INSERT INTO jmocha_dept_master (TENANT_ID,CN,DISPLAYNAME,DISPLAYNAME2,USEFLAG,MAIL,COMPNM2,DEPTLEVEL,DEPT_CD_PATH,DEPT_NM_PATH,EXTENSIONATTRIBUTE1,EXTENSIONATTRIBUTE2,EXTENSIONATTRIBUTE3,EXTENSIONATTRIBUTE4,EXTENSIONATTRIBUTE5,EXTENSIONATTRIBUTE6,EXTENSIONATTRIBUTE7,EXTENSIONATTRIBUTE8,EXTENSIONATTRIBUTE9,EXTENSIONATTRIBUTE10,EXTENSIONATTRIBUTE11,EXTENSIONATTRIBUTE12,EXTENSIONATTRIBUTE13,EXTENSIONATTRIBUTE14,EXTENSIONATTRIBUTE15,ADFLAG,ADSPATH,UPDATEDT) VALUES (0,'Top','조직도','OrganizationChart',NULL,'Top@jtest.kaoni.com','OrganizationChart','1','Top','조직도',NULL,'Top','조직도',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','CN=Top,OU=조직도,OU=TopGroup,DC=jtest,DC=kaoni,DC=com',TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'));
INSERT INTO jmocha_user_master (TENANT_ID,CN,DISPLAYNAME,DISPLAYNAME2,MAIL,MAILNICKNAME,UPNNAME,DEPARTMENT,DESCRIPTION,DESCRIPTION2,DESCRIPTION3,PHYSICALDELIVERYOFFICENAME,COMPANY,COMPANY2,TITLE,TITLE2,TELEPHONENUMBER,HOMEPHONE,FACSIMILETELEPHONENUMBER,MOBILE,POSTALCODE,STREETADDRESS,INFO,EXTENSIONATTRIBUTE1,EXTENSIONATTRIBUTE2,EXTENSIONATTRIBUTE3,EXTENSIONATTRIBUTE4,EXTENSIONATTRIBUTE5,EXTENSIONATTRIBUTE6,EXTENSIONATTRIBUTE7,EXTENSIONATTRIBUTE8,EXTENSIONATTRIBUTE9,EXTENSIONATTRIBUTE10,EXTENSIONATTRIBUTE102,EXTENSIONATTRIBUTE11,EXTENSIONATTRIBUTE12,EXTENSIONATTRIBUTE13,EXTENSIONATTRIBUTE14,EXTENSIONATTRIBUTE15,ADSPATH,SIPURI,UPDATEDT,MOBILE_ENABLE,MOBILE_NOTUSE,MOBILE_PIN,POSITIONCD,BIRTH,BIRTHTYPE,PASSWORD,IPADDRESS,LASTLOGIN,LOGINCNT) VALUES (0,'masteradmin','마스터관리자','MasterAdmin','masteradmin@jtest.kaoni.com','masteradmin',NULL,'Top','조직도','OrganizationChart',NULL,'Top','조직도','OrganizationChart','마스터관리자','MasterAdmin',NULL,NULL,NULL,NULL,NULL,NULL,' ','c=1;a=1;k=1;i=1;g=1;l=1;n=0;m=0;w=0;t=0;',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'마스터관리자','MasterAdmin',NULL,NULL,NULL,NULL,'1','CN=masteradmin,OU=사용자,OU=조직도,OU=TopGroup,DC=jtest,DC=kaoni,DC=com',NULL,TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'),NULL,'N',NULL,NULL,NULL,'Y','m7jsQtm1Uqm+n51H00wciQOeQm9rlarZxD0wuM9QVCU=','0:0:0:0:0:0:0:1',TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'),0);
INSERT INTO james_recipient_rewrite (DOMAIN_NAME,USER_NAME,TARGET_ADDRESS) VALUES ('jtest.kaoni.com','Top','');
INSERT INTO james_domain (DOMAIN_NAME) VALUES ('jtest.kaoni.com');
INSERT INTO james_user (USER_NAME,PASSWORD_HASH_ALGORITHM,PASSWORD,version) VALUES ('masteradmin@jtest.kaoni.com','SHA-256','9bb8ec42d9b552a9be9f9d47d34c1c89039e426f6b95aad9c43d30b8cf505425',1);
INSERT INTO jmocha_tenant (TENANT_ID,TENANT_NAME,TENANT_NAME2) VALUES (0,'조직도','OrganizationChart');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'ExpirePassPeriod','0');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'BigSizeMailAttachDelDay','14');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'BigSizeMailAttachLimit','10');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'DomainName','jtest.kaoni.com');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'IS_READ_DELETE','NO');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'LangPrimary1','한글');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'LangPrimary2','Korean');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'LangPrimary3','韓国語');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'LangPrimary4','韩国语');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'LangSecondary1','영문');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'LangSecondary2','English');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'LangSecondary3','英語');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'LangSecondary4','英语');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'MailAttachLimit','10');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'MailInnerDomain','jtest.kaoni.com');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'PrimaryLang','1');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'SignImageSizeLimit','10');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'totBigSizeMailAttachLimit','800');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'INDIVIDUALMAILUSER','5');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'USE_FileExtension','7z,alz,avi,bmp,csv,cur,doc,docx,eml,gif,hwp,hwpx,hwt,jpeg,jpg,log,mht,mp4,odt,pdf,png,ppt,pptx,rar,tif,txt,wmv,xls,xlsx,zip');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'LicenseKey',' ');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'MaxMessageSize','0');
INSERT INTO jmocha_tenant_config (TENANT_ID,PROPERTY_NAME,PROPERTY_VALUE) VALUES (0,'Use_FromAddress','NO');
INSERT INTO jmocha_tenant_servername (TENANT_ID, SERVER_NAME) VALUES (0, 'jtest.kaoni.com');
INSERT INTO jmocha_default_quota (DOMAIN_NAME,MAX_STORAGE,WARN_STORAGE) VALUES ('jtest.kaoni.com',1024,819.2);
INSERT INTO tbl_tenant (TENANT_ID,TENANT_NAME,TENANT_NAME2) VALUES (0,'조직도','OrganizationChart');
INSERT INTO tbl_tenant_servername (TENANT_ID, SERVER_NAME) VALUES (0, 'jtest.kaoni.com');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'MaxMessageSize', '메일최대크기', '65536', '메일최대크기 (default:65536)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useZipCodeSearchInApr', '전자결재 민원인주소 검색 사용여부', 'NO', '전자결재>결재정보에서 민원인주소를 입력 시 주소정보 검색을 사용한다.(민원인주소 버튼: 결재정보>수신자>민원인주소입력 버튼, 전자결재G에서 재기안이 아닐 때 버튼 활성화)YES: 이름+우편번호검색+상세주소 입력NO: 이름 입력 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useZipCodeSearch', '우편번호 검색 사용여부', 'YES', '사용자 정보 관리, 주소록에서 우편번호 검색을 사용한다. (우편번호 검색 버튼 활성화)YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseTodoMemo', '업무관리 메모기능 사용여부', 'YES', '업무관리 모듈 내 메모기능을 사용한다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '업무관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseShowEmailAddrOnPrint', '메일 인쇄 시 주소 포함여부', 'YES', '메일 인쇄 시 보낸사람, 받는사람의 메일주소를 포함하여 인쇄한다.YES: 메일주소 포함NO: 메일주소 포함안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSearchContent', '메일 내용검색 사용여부', 'YES', '메일 간단검색 시 내용 검색이 가능하다. (메일리스트 화면 우측 상단 검색 셀렉트박스)YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseRunTime', '게시판 RunTime 표시여부', 'NO', '게시판 리스트 하단에 런타임 표시 기능을 사용한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UserInfo_RelayG_Type', '유통 중계문서 문서 정의', 'MHT', '결재문서 접수 시 유통 중계문서 변환 양식을 정의한다.MHT: MHT 접수기 사용HWP: 한글 접수기 사용공백: 사용안함 (default: MHT)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UserInfo_Enforce', '시행문 변환 정의', '3', '* 2024-04-16 기준 분석 결과 : 소스코드 상에서 전체 주석처리되거나 테넌트 컨피그 파라미터를 아예 전달하지 않는 등 정상적으로 사용되지 않는 값으로 확인, 차후 수정 가능성이 있어 테넌트 컨피그 레코드는 유지함. * 기존 테넌트 컨피그 설명 : 1: 단순 변환 후 인쇄2: 시행문 변환 후 심사용3: 시행문 변환 후 바로 발송용(*추후개발) (default: 3)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UserInfo_ApprovalG_VIEW', '문서 열람 권한 정의', 'YYY', '문서 열람 권한을 정의한다. 권한을 체크 할 경우 Y로 권한을 체크하지 않을 경우 N으로 각 자리를 채운다. 비공개 문서인 경우, 이곳에 속하면 열람 가능. 속하지 않으면, 2번, 3번을 추가로 체크. 부분공개 문서인 경우, 이곳에 속하면 열람 가능. 속하지 않으면, 2번, 3번을 추가로 체크.공개 문서인 경우, 2번 3번을 추가로 체크.첫번째자리 Y/N: 공개/부분공개/비공개 권한 체크두번째자리 Y/N: 보안등급 권한 체크세번째자리 Y/N: 열람권한 체크 (default: YYY)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useReSend', '메일 재작성 사용여부', 'YES', '보낸 메일의 재작성 기능을 사용한다.YES: 사용NO: 사용안함메일>보낸편지함메일>보낸편지함>메일읽기 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useReform', '전자결재 폼빌더 양식 작성 가능 여부', 'NO', '전자결재 양식 추가 시에 폼빌더 작성기를 활성화할 수 있는지에 대한 여부를 설정한다. 이미 폼빌더 양식으로 추가 됐다면 옵션을 비활성화해도 폼빌더 양식으로서 동작한다. (default : NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useReceiveInfoName', '수신부서 표기 타입', '0', '수신부서 지정 시 부서 이름 끝에 "장"을 붙인다.0: 부서이름만 표기1: 부서이름+장으로 표기 (default: 0)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useReceiveDocNo', '접수 시 채번방식 설정', 'NO', '결재문서 접수 시 채번 붙이는 때를 설정한다. (전자결재G)YES: 접수/편철/전결 시 채번NO: 최종결재/편철/전결 시 채번 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useReceiptExternal', '외부메일 수신확인 지원여부', 'YES', '외부메일 수신확인을 지원한다.YES: 지원NO: 지원안함 (default: YES)', TO_DATE('2024-11-13 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useQuestion', '전자설문 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UsePreviewSubTreeForEmail', '하위 편지함 오픈 설정 사용여부', 'YES', '메일>환경설정에서 하위편지함 자동 열기 설정을 사용한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseOnlyInnerMail', '메일 내부망만 사용여부', 'NO', '메일을 내부망에서만 사용한다. 외부메일 관련 설정은 모두 숨김. YES: 내부만 사용NO: 내부+외부 사용 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMobileViewer', '모바일 뷰어', '0', '0: 파일 다운로드1: SAT 뷰어 사용2: 쿠쿠닥스 뷰어 사용 (default: 0)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMobileMailOnly', '모바일 메일만 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMemo', '메모 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMasteradminLogin', '최고관리자 암호 로그인', 'NO', 'masteradmin 비밀번호로 모든 로그인이 가능하다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseMailZipEucKr', '메일 내보내기 시 zip 인코딩 타입', 'NO', '메일/편지함 내보내기 시 zip 인코딩 타입을 설정한다. utf-8로 압축했을 경우 윈도우 기본 프로그램으로 압축을 풀면 실패하여 euc-kr로 압축할 수 있도록 옵션처리YES: euc-krNO: utf-8 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailWriteSenderClick', '보낸사람에게 바로 메일보내기 사용여부', 'YES', '메일리스트에서 보낸사람 클릭 시 메일 작성 팝업이 뜬다. 사용하지 않으면 행선택.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailReceiveScreen', '수신확인 리스트 사용여부', 'YES', '수신확인 리스트 화면을 사용한다. 메일화면 왼쪽에 수신확인 메뉴가 표출된다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailNewWindow', '메일 읽기 아이콘 사용여부', 'NO', '메일리스트에서 단일 클릭으로 메일 읽기 팝업이 뜨는 아이콘을 사용한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailLinkHostname', '대용량첨부/보안메일 링크의 hostname 지정여부', 'YES', '대용량첨부메일 및 보안메일의 경우 어느 hostname으로 접속해도 설정된 mailLinkHostname 컨피그 값으로 링크가 만들어진다.YES: mailLinkHostname 링크 사용NO: 사용자의 그룹웨어 접속 hostname으로 링크 사용 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseMailBoxBackUp', '편지함 내보내기/가져오기 사용여부', 'YES', '메일 왼쪽 편지함에서 마우스 오른쪽 클릭 시 편지함 내보내기/가져오기가 가능하다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailAddrAutoComplete', '메일 수신인 자동완성 사용여부', 'YES', '메일쓰기>받는사람, 참조, 숨은참조에 수신인 이름 입력 시 자동완성 기능을 사용한다 YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'usePlainForDefaultTextOption', '기본 메일 본문 형식을 PlainText로 사용여부', 'NO', '메일 환경설정의 메일본문형식을 PlainText를 default로 설정한다. YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2019-05-23 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useLoginCookieSSO', 'loginCookieSSO 로그인 쿠키 추가생성', 'NO', 'loginCookieSSO라는 쿠키에 도메인으로 설정하여 로그인 쿠키 하나 추가로 생성NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useLetter', '메일 편지지 기능 사용여부', 'YES', 'YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useLadder', '사다리게임 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useIPAccess', '접속 IP 관리 허용여부', 'NO', '접속 IP 관리 기능을 사용하면 모든 사용자가 차단되고 등록한 사용자만 그룹웨어에 접속 가능하다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseInitMailSign', '메일 서명 자동 등록여부', 'NO', '사용자 생성 시 메일 서명 테이블에 있는 초기 메일 서명을 해당 사용자의 메일 서명으로 등록한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseInitInboxRule', '초기 메일 자동분류 등록여부', 'NO', '사용자 생성 시 메일 자동분류 테이블에 들어있는 초기 자동분류 룰을 해당 사용자의 자동분류 룰로 등록한다. 룰에 포함된 편지함이 사용자에게 없을 경우 편지함을 자동 생성한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useImapMoveCommand', '메일 이동 시 IMAP MOVE 커맨드 사용여부', 'YES', '메일 이동 시 IMAP MOVE 커맨드를 사용한다. 사용하지 않으면 IMAP COPY 커맨드를 사용한다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useHWP', 'HWP 양식작성기 사용유무', 'NO', 'HWP 양식을 작성하고 사용할 수 있다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useWebHWP', '웹 한글 기안기 사용유무', 'YES', 'useHWP가 YES인 경우 웹한글기안기 사용유무. YES: 사용 NO: 사용안함 (default : YES)', TO_DATE('2020-10-08 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'webHWPUrl', '웹 한글 기안기 url', 'http://hedit.kaoni.com:8080/webhwpctrl/', '웹 한글 기안기 url', TO_DATE('2020-02-26 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseEncryptZipForEmail', '메일 내보내기/가져오기 암호화 사용여부', 'NO', '메일 내보내기/가져오기 시 압축파일을 암호화한다. YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseEmpNumberLogin', '사번 로그인', 'NO', '사용자 아이디 대신 사번으로 로그인한다.YES: 사용NO: 사용안함*tbl_usermaster 테이블의 extensionAttribute14 컬럼 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useEditApprDoc', '전체 진행문서 편집기능 사용여부', 'NO', '전체문서조회(진행문서)에서 편집모드로 들어가 편집이 가능하다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseDisablePopImap', 'POP3/IMAP 설정 미사용여부', 'NO', 'POP3/IMAP 사용여부를 설정할 수 있는 기능을 활성화한다. YES: 사용안함NO: 사용 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseDefaultFoldersForLangOnly', '사용자 언어에 따른 기본 편지함만 표출', 'NO', '사용자 언어별로 각각 다른 이름의 편지함이 생성되는 데 현재 언어에 맞는 편지함만 보이도록한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useCabinet', '캐비닛 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useBottomFrameOnly', '하단프레임만 DIM 처리', 'NO', '레이어 팝업이 띄워질 때 탑메뉴와 따로 하단프레임만 DIM 처리된다. 사용하지 않으면 탑메뉴도 DIM 처리됨.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseBizmekaTalk', '비즈메카톡과의 연동여부', 'NO', '그룹웨어 계정으로 비즈메카톡 계정을 동기화 할 수 있다.YES: 연동NO: 연동안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseBizmekaSpambox', '비즈메카 스팸편지함과의 연동여부', 'NO', 'YES: 연동NO: 연동안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useBallotSystem', '투표 모듈 사용여부', 'NO', '투표모듈을 사용한다. 투표모듈 사용 시 투표 포틀렛에 투표모듈이, 사용안할 시 퀵폴이 표출된다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAutoSaveMailAddress', '외부메일 자동 주소록 등록', 'NO', '외부로 메일을 보낼 시 주소록에 저장되지 않은 외부메일이면 개인주소록에 자동으로 등록한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useApprovalKlib', '전자결재완료 문서를 KLIB 암호화 저장', 'NO', '전자결재완료시 문서, 첨부파일을 KLIB 으로 암호화할 것인지의 여부(default : NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useApprovalKlibBackup', '전자결재완료 문서 KLIB 암호화시 원본 백업', 'NO', '전자결재 관련 파일을 KLIB 으로 암호화할 때 원본 파일을 백업할지에 대한 여부(default : NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseAnyoneEdit', '주소록, 일정 편집 권한 오픈여부', 'NO', '모든 사용자가 부서/회사 주소록과 일정을 추가 및 수정 가능하다. 사용하지 않을 시 부서관리자와 회사관리자에게 권한이 있다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '주소록');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAllUserOldMailDeletePeriod', '받은편지함 메일 보관기간', '0', '월 단위로 받은편지함 메일 보관기간을 지정한다. 지정한 기간이 지난 메일은 모두 삭제한다.0: 삭제안함*useAllUserOldMailDelete 옵션의 값이 YES일 때 사용가능 (default: 0)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAllUserOldMailDelete', '받은편지함 오래된 메일 자동 삭제', 'NO', '받은편지함에서 오래된 메일을 자동으로 삭제하는 기능을 사용한다. useAllUserOldMailDeletePeriod 옵션에서 지정한 기간에 의해 삭제된다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAllowTextSelection', '전자결재 문서 내용 드래그 가능여부', 'YES', 'YES: 드래그 가능NO: 드래그 불가능 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAdvancedMailSearch', '속도 개선 메일검색 기능 사용여부', 'YES', '메일검색 테이블을 이용하여 속도가 개선된 메일검색 기능을 사용한다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAdminBujae', '관리자의 부재자 설정 사용여부', 'YES', '관리자 페이지에서 특정 사용자의 부재자 설정이 가능하다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useEzTalkNotification', '전자결재 톡알림', 'NO', '전자결재 관련 알림을 ezTalk으로 보낸다. YES:사용, NO:사용안함 (default: NO)', TO_DATE('2019-10-19 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAdvancedEachMail', '개별발신 성능 향상 방식 적용', 'YES', '개별발신 성능 향상 방식 적용 YES:사용, NO:사용안함 (default: NO)', TO_DATE('2019-12-08 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useShowAllCompanies', '조직도 그룹사 전체 표시', 'NO', '메일쓰기 수신자지정창 조직도, 직원조회 조직도 등에서 그룹사 전체 표시 여부. YES: 표시, NO:미표시 (default: NO)', TO_DATE('2019-10-21 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailDeletedId', 'james_mail_deleted_id 테이블 사용여부', 'NO', 'james_mail_deleted_id 테이블 사용여부 (default: NO)', TO_DATE('2019-12-29 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_SECUREMAIL', '보안메일 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'Use_Portal', '포탈 모듈 사용여부', 'YES', 'YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_OCS', 'MS OCS 사용여부', 'NO', 'ms ocs 2007 사용여부YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'Use_MultiData', '멀티언어 사용여부', 'YES', 'YES: 사용NO: 사용안함 (default: YES)     * 2024-05-22(해당 컨피그를 확인한 시점) 기준으로 게시판 모듈에서만 사용중인 것으로 확인됨', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_JOURNAL', '업무일지 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_HTTPS', 'HTTPS 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_HTMLMODE', '에디터 HTML 모드 사용여부', 'YES', '에디터의 HTML 모드를 사용한다. 관리자 화면에서는 설정에 관계없이 무조건 사용한다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'Use_FromAddress', '발신인 주소 선택 사용여부', 'NO', '발신인이 멀티 메일 도메인을 가지고 있을 때 메일쓰기에서 보내는 사람의 메일 주소 선택이 가능하다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_FileExtension', '첨부파일 확장자명 제한', '7z,alz,avi,bmp,csv,cur,doc,docx,eml,gif,hwp,hwpx,hwt,jpeg,jpg,log,mht,mp4,odt,pdf,png,ppt,pptx,rar,tif,txt,wmv,xls,xlsx,zip', '업로드 가능한 첨부파일의 확장자명을 설정한다. ex) exe|jpg*: 제한하지 않음 (모든 확장자 허용) (default: *)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_DirectSign', '부서 협조/합의 직접서명 사용여부', 'NO', '전자결재 부서 협조/합의 접수 시 직접서명을 사용한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_BOARD_LEFTMENU_COUNT', '게시판 왼쪽 메뉴 총 개수 표시', 'YES', '게시판 왼쪽 메뉴에 각 게시판의 게시문 개수를 표시한다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_ATTITUDE', '근태관리 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_AdditionalROle', '겸직부서에 따른 일괄결재 제한', 'YES', '전자결재에서 겸직부서 선택에 따라 현재 부서의 일괄결재만 가능하다.YES: 겸직부서 선택에 따라 일괄결재제한NO: 겸직부서 상관없이 모두 일괄결재 가능 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_AD', 'Active Directory 사용 유무', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'totBigSizeMailAttachLimit', '메일 대용량 첨부파일 최대 크기', '800', 'MB 단위로 대용량 첨부파일의 최대 크기를 지정한다.0: 대용량 첨부파일 사용안함 (default: 800)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'Site_OpenYear', '전자결재 시작 년도 설정', '2017', '전자결재 리스트에서 년도별 셀렉트박스의 시작 년도를 설정한다. (default: 2017)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'signImageType', '이미지 서명 시 사인칸 타입', 'IMAGE', '이미지 서명 시 사인칸에 표시할 타입을 설정한다.IMAGE: 서명이미지만 표시NAME: 서명이미지+서명인 이름 함께 표시 (default: IMAGE)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'SignImageSizeLimit', '결재 서명이미지 파일 최대 크기', '10', 'KB 단위로 결재 서명 이미지 파일의의 최대 크기를 지정한다. (default: 10)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'signImageSize', '전자결재 사인이미지 크기', '50/50', '전자결재 사인칸의 이미지 크기를 설정한다. width/height 로 표기한다. (default: 50/50)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'apprReuseConfig', '전자결재 재사용 환경설정', '0', '전자결재에서 재사용시 설정. 0:문서의 모든 내용 재사용 1:에디터 본문만 재사용 default:모든 내용 재사용(0)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재S');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'receptGubunYN', '전자결재 수신자탭 표출 타입', 'N', '전자결재G 결재정보에서 양식종류에 따라 수신자탭이 보여지는 타입을 정한다Y: 시행문일 경우 외부탭, 수신문일 경우 조직도탭이 표출N: 양식종류에 상관없이 외부탭, 조직도탭 모두 표출 (default: N)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'PrimaryTimeZone', '시스템 표준 시간대', '235|+09:00', '시스템 primary 표준 시간대를 설정한다.시스템 Primary 표준 시간대 설정  (첫 로그인 시 사용자의 표준 시간대를 정할 수 없을 경우 시스템의 표준 시간대를 따름) (default: 235|+09:00)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'PrimaryLang', '시스템 언어', '1', '시스템 primary 언어를 설정한다.1: 한국어3: 일본어  (default: 1)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'portalEnv', '마이포탈설정 메뉴표출 범위', '0', '환경설정>마이포탈설정의 메뉴가 보여지는 범위를 정한다.0: 마이포탈페이지+초기화면설정1: 마이포탈페이지2: 초기화면설정3: 모두 안보임*패키지가 스탠다드고 firstScreen_Mail이 NO일때만 적용 (default: 0)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'PersonalAgreeReturnType', '개인병렬 협조/합의 반송 처리 타입', '1', '개인병렬 협조/합의자가 반송한 경우 처리 타입을 정의한다.1: 반송해도 다음 결재권자에게 진행문서로 전달2. 한 명이라도 반송한 경우 원 기안자에게 반송 (default: 1)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ONELINE_REPLY_ENABLE', '게시판 한줄답변 FLAG', '1', '커뮤니티 게시판의 한줄답변 FLAG0: 사용안함1: 사용 (default: 1)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '커뮤니티');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'MyBoardTopFlag', '게시판 마이게시판 위치', 'YES', '게시판 왼쪽 메뉴에서 마이게시판의 위치를 설정한다. YES:상단 / NO:하단 (default: YES) *2024-05-22(해당 컨피그를 확인한 시점) 기준으로 즐겨찾기 메뉴는 상단 고정이 스펙', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'mobileUseMailAddrAutoComplete', '모바일 메일 이름 자동완성 기능 사용여부', 'YES', '모바일에서 메일쓰기>받는사람, 참조, 숨은참조에 수신인 이름 입력 시 자동완성 기능을 사용한다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'MineViewYN', '결재진행문서 표출 타입', 'NO', '결재진행문서에 문서가 보여지는 타입을 설정한다.YES: 결재 순서가 본인인 문서만 표출NO: 결재선에 본인이 존재하는 모든 문서 표출 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'MaxAllowedCountOfLoginFail', '비밀번호 오류 최대 횟수', '0', '계정 잠금이 되는 최대 로그인 실패 횟수를 설정한다. 0: 무제한 (default: 0)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'mailLinkHostname', '대용량첨부메일/보안메일 링크의 hostname', 'jtest.kaoni.com', '대용량첨부메일 및 보안메일 링크의 hostname을 설정한다. (port번호 포함, 80포트는 생략)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'MailInnerDomain', '내부 메일도메인', 'jtest.kaoni.com', '내부 메일 도메인 리스트. 세미콜론으로 도메인을 구분하며 메인 메일도메인은 필수로 포함한다. (세미콜론(;)으로 도메인 구분, 주 메일 도메인 필수로 포함, alias 도메인 사용할 경우 포함) (default: jtest.kaoni.com)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'MailAttachLimit', '메일 일반 첨부파일 최대 크기', '10', 'MB 단위로 메일 일반 첨부파일의 최대 크기를 지정한다. (default: 10)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'mailMaxReceiverCount', '메일 최대 수신자 수', '200', '메일 발송 시 최대 수신자 수를 지정한다. (default: 200)', TO_DATE('2019-03-21 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'MailBigSizeAttachDownloadLimitCount', '대용량첨부 다운로드 횟수 제한', '0', '대용량첨부 다운로드 횟수 제한, 0일 경우 무제한', TO_DATE('2020-03-12 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'MailBigSizeAttachLimitCount', '대용량첨부 개수 제한', '0', '대용량첨부 개수 제한, 0일 경우 무제한', TO_DATE('2020-03-12 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LoginMailLogKeepPeriod', '로그인, 메일 로그 보존기간', '3', '월 단위로 로그인 기록과 메일 수발신 로그를 보존하는 기간을 지정한다. 지정한 기간이 지나면 삭제한다. (default: 3)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LicenseKey', '라이센스키', '', '라이센스 키', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangSecondary5', '멀티언어5(서브)', '', '', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangSecondary4', '멀티언어4(서브)', '英语', '', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangSecondary3', '멀티언어3(서브)', '英語', '', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangSecondary2', '멀티언어2(서브)', 'English', '', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangSecondary1', '멀티언어1(서브)', '영문', '시스템 언어에 따른 멀티언어(서브) 셋팅', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangPrimary5', '멀티언어5(메인)', '', '', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangPrimary4', '멀티언어4(메인)', '韩国语', '', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangPrimary3', '멀티언어3(메인)', '韓国語', '', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangPrimary2', '멀티언어2(메인)', 'Korean', '', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'LangPrimary1', '멀티언어1(메인)', '한글', '시스템 언어에 따른 멀티언어(메인) 셋팅', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'JunGyulFlag', '전자결재 전결 처리 타입', '1', '전결 처리 타입을 정의한다.1: 전결자 이후 결재자들도 사인칸에 등록. 전결자가 결재하면 전결자 사인칸에 전결표시하고 최종결재자 사인칸에 전결자 서명을 입력한다.4: 전결자 이후 결재자들은 사인칸에 미등록. 전결자가 결재하면 전결자 사인칸에 전결자 서명을 입력한다. (default: 1)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'isDefaultReceiptExternal', '메일 수신확인 범위 기본값', 'YES', '메일쓰기>메일옵션>추적설정에서 기본값으로 사용할 타입을 설정한다.YES: 외부용을 기본값으로 사용NO: 내부용을 기본값으로 사용*useReceiptExternal 옵션이 YES 일 때 사용가능 (default: YES)', TO_DATE('2024-11-13 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'IS_READ_DELETE', '읽은 메일 회수기능 사용여부', 'NO', '메일 회수 시 수신자가 읽은 메일도 회수가 가능하다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'INDIVIDUALMAILUSER', '메일 개별발신 최대 인원', '200', '명 단위로 메일 개별발신 보낼 수 있는 최대 인원 수를 지정한다.0: 개별발신 사용 안함 (default: 5)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'HWPToolbar', '한글양식기 상단툴바 사용여부', '100001', '한글양식기에서 상단 편집 툴바를 라인별로 사용하면 1 사용하지 않으면 0으로 설정한다. (default: 100001)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'hideSusin', '전자결재 부서수신함 사용여부', 'Y', '전자결재 왼쪽 메뉴에서 부서수신함을 표출한다.Y: 사용N: 사용안함 (default: Y)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'FormProcSpelling', '폼프로세서 맞춤법 검사', '0', 'FORM 에디터 사용 시 폼프로세서 맞춤법 검사 버튼을 활성화한다.1: 사용0: 사용안함 (default: 0) * 2024-05-07 기준으로 표준모듈 master 브랜치에서 더이상 사용되지 않음', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'forceCallBack_YN', '강제회수 사용여부', 'NO', '전자결재에서 상위결재자가 결재한 문서도 회수 할 수 있다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'firstScreen_Mail', '초기화면 메일만 표출', 'NO', '초기 화면에 메일 모듈을 표출한다. YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ezTalkSyncServerUrl', '톡서버 전체 사용자 연동 URL', 'http://10.0.102.8:31032/api/sync/org', '톡서버 전체 사용자 연동 URL (default: http://10.0.102.8:31032/api/sync/org)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ezTalkSyncServerUrlForSingle', '톡서버 단일 사용자 연동 URL', 'http://10.0.102.8:31032/api/sync/user', '톡서버 단일 사용자 연동 URL (default: http://10.0.102.8:31032/api/sync/user)', TO_DATE('2022-01-26 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ezTalkGateNoticeBoardId2', '비즈메카톡 사내공지게시판 아이디2', '0', '비즈메카톡에서 호출하는 두 번째 사내공지게시판 아이디 (default: 0) * 2024-05-17 기준으로 표준모듈 master 브랜치에서 더이상 사용되지 않음', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ezTalkGateNoticeBoardId', '비즈메카톡 사내공지게시판 아이디', '0', '비즈메카톡에서 호출하는 사내공지게시판 아이디 (default: 0) * 2024-05-17 기준으로 표준모듈 master 브랜치에서 더이상 사용되지 않음', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ezOffice365ClientSecret', 'Office365 Client Secret Key', '', 'Office365 Client Secret Key', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ezOffice365ClientId', 'Office365 Client Id', '', 'Office365 Client Id', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ezOffice365Auth', 'Office365와의 인증 연동여부', 'NO', 'YES: 연동NO: 연동안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ExpirePassPeriod', '비밀번호 만료 주기', '0', '일 단위로 비밀번호 변경 이벤트가 발생하는 주기를 지정한다.0: 사용안함*changePassword 컨피그 값이 1 이어야 한다. (default: 0)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'editorFontStyle', '에디터 기본 폰트 스타일', '굴림|10pt', '에디터에서 기본으로 설정되는 폰트 스타일을 설정한다. 수직바(|)로 글꼴과 크기를 구분하며, 사용자 언어(lang)가 한글일 경우에만 적용된다. (default: 굴림|10pt)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'EDITOR', '에디터 타입', 'KUKUDOCS', 'CK, NAMO, TAGFREE, FORM, POLARIS, DEXT, KUKUDOCS 중 사용할 에디터를 설정한다. (default: KUKUDOCS)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'draftJunGyulFlag', '전자결재 사인칸 전결자 표시', '1', '전자결재 기안 시 사인칸에 전결자 텍스트를 표시한다.1: 사용0: 사용안함 (default: 1)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'dotNetUrl', '닷넷 모듈 URL', '', '', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'dotNetIntegration', '닷넷 모듈과의 연동여부', 'NO', 'YES/NO (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'DomainName', '메인 메일도메인', 'jtest.kaoni.com', '메인 메일도메인 (불변) (default: jtest.kaoni.com)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'docNumZeroCnt', '문서 일련번호 제로필 수', '2', '문서 일련번호의 최소 길이를 설정한다. 새로 작성된 문서의 일련번호 길이가 부족하면 앞자리에 0이 붙는다. (default: 2)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'defaultForDisablePopImap', 'POP3/IMAP 기본값', 'YES', 'POP3/IMAP 허용 여부의 기본값을 설정한다.YES: 사용안함이 기본값NO: 사용함이 기본값*UseDisablePopImap 컨피그 값이 YES일 경우 적용 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'daliyDocNumYN', '채번 초기화 주기', 'NO', '채번 초기화 주기를 설정한다.YES: 매일 채번 초기화NO: 매년 채번 초기화 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'containLow', '직원 수 카운트 시 하위부서 포함 여부', 'NO', '조직도에서 하위부서 직원 수도 포함하여 표시한다.YES: 현재부서/현재부서+하위부서 직원 수로 표시NO: 현재부서 직원수만 표시 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ChkOldBrowser', '오래된 브라우저 체크여부', 'NO', 'IE10 이전 버전을 사용할 경우 로그인을 막는다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'changePassword', '비밀번호 변경 이벤트 발생여부', '1', '비밀번호 변경 이벤트가 발생한다.1: 이벤트 있음0: 이벤트 없음 (default: 1)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'chamjoAfterYN', '최종결재자 이후 참조 추가', 'YES', '전자결재 결재정보에서 최종결재자 이후 참조 추가가 가능하다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'BizmekaCompanyId', '비즈메카 연동을 위한 회사 ID', 'withkt', ' (default: withkt)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'BizmekaAdminPw', '비즈메카 연동을 위한 관리자 PW', '193A68920F2AE8A807A6DCBD34E2580E0237C6BB746141140BBA6D661108546035EA3C2E7698E3C192494456DFF551BAE637ED4292A9DB7C71F8FE0AD747DD302C60D7FDEE9FAD4BE872104578CA822833EB4B87703811556778DC22FA9FB7FC4CCC18C17F62E83A8663F5E62DB3735D37462422737A172F382875DF88FF96D6', ' (default: 193A68920F2AE8A807A6DCBD34E2580E0237C6BB746141140BBA6D661108546035EA3C2E7698E3C192494456DFF551BAE637ED4292A9DB7C71F8FE0AD747DD302C60D7FDEE9FAD4BE872104578CA822833EB4B87703811556778DC22FA9FB7FC4CCC18C17F62E83A8663F5E62DB3735D37462422737A172F382875DF88FF96D6)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'BizmekaAdminId', '비즈메카 연동을 위한 관리자 ID', '27F8EA7760FDB7F338AC7CFBCD0FC0328B8F4C9BD665BDAEE11B987E727CFA2EDDFD229560CC9001F993FA50896A1C40B44CEC40CB4962476374183313EAC1B07F66B19E14252C4ECBA3B8E8B9DA54B7EA6AA1814B4DAC082E614A375D99983270A7758FB12986143874A26A606D0FE2C96213863D9145BC997796FA1C7B36C2', ' (default: 27F8EA7760FDB7F338AC7CFBCD0FC0328B8F4C9BD665BDAEE11B987E727CFA2EDDFD229560CC9001F993FA50896A1C40B44CEC40CB4962476374183313EAC1B07F66B19E14252C4ECBA3B8E8B9DA54B7EA6AA1814B4DAC082E614A375D99983270A7758FB12986143874A26A606D0FE2C96213863D9145BC997796FA1C7B36C2)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'BigSizeMailAttachLimit', '메일 대용량 첨부파일로의 자동전환 크기', '10', 'MB 단위로 메일의 일반 첨부파일이 대용량 첨부파일로 변경되는 크기를 지정한다.MailAttachLimit 과 함께 변경 (default: 10)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'BigSizeMailAttachDelDay', '메일 대용량 첨부파일 보존기간', '14', '일 단위로 보존기간을 지정한다. 지정한 기간이 지나면 메일 대용량 첨부파일을 삭제한다. (default: 14)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'attachFileNameMaxLength', '첨부파일명 최대 길이', '100', '글자 단위로 확장자 포함한 최대 길이를 지정한다. (default: 100)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ApprTotalAttachLimit', '전자결재 첨부파일 최대 크기', '50', 'MB 단위로 전자결재 첨부파일의 최대 크기를 지정한다.0: 무제한 (default: 50)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'APPROVLEFTCOUNT', '전자결재 왼쪽 메뉴 총 개수 표시', 'YES', '전자결재 왼쪽 결재문서 메뉴에서 총 문서 개수를 표시한다.YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'approvalForDoc', '전체문서 조회 사용여부', 'N', '전체, 회사, 결재조회 관리자가 전체문서 조회 할 수 있는 기능을 사용한다.Y: 사용N: 사용안함 (default: N)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ApprovalFlag', '전자결재 타입', 'S', 'G: 전자결재 공공S: 전자결재 일반 (default: S)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'allApproveYN', '모두결재 표출 순서', 'N', '전자결재에서 모두 결재시 다음 결재문서를 보여주는 순서를 정한다. 시작하는 문서는 선택한 문서가 된다.Y: 기안일이 오래된 문서부터 결재N: 기안일이 최근인 문서부터 결재 (default: N)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ADJACENT_ITEMS_ENABLE', '인접 게시글 표시', '1', '게시글 조회 시 다음글, 이전글을 표시하고 바로 이동 가능하게 한다.1: 사용0: 사용안함 (default: 1)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'addLastKyulJeYN', '최종결재선 결재유형 허용 범위', '0', '전자결재 결재정보에서 최종결재자 유형으로 합의를 추가할 수 있는지 설정한다. 0:불가능, 1:개인순차합의만 허용, 2:개인순차합의와 부서순차합의 모두 허용 (default: 0)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재S');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useWebfolder', '웹폴더 기능 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useWebfolderVersionHistory', '웹폴더 버전관리 사용 여부', 'YES', 'YES: 사용, NO: 사용안함 (default: YES)', TO_DATE('2021-05-10 00:00:00','yyyy-mm-dd hh24:mi:ss'), '웹폴더');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'howToSendOffer', '기안자를 발송의뢰 담당자로 지정', '0', '전자결재에서 발송의뢰 할 때 심사자를 선택하는 팝업이 뜨지 않고 기안자가 바로 발송의뢰 담당자로 지정된다.1: 사용0: 사용안함 (심사자 선택) (default: 0)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_COMMUNITY', '커뮤니티 모듈 사용여부', 'YES', 'YES: 사용 NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '커뮤니티');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useIPAccessMenu', '접속 IP 관리 화면 여부', 'YES', 'YES: 사용 (default)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'viewCompany','결재문서리스트 회사 이름 표출 여부','0','전자결재 리스트에 회사명 표출 여부 1:보여줌 그외:안보여줌', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSeparatedLargeFileFolder', '분리된 대용량 첨부파일 폴더 사용여부', 'YES', 'YES: 사용 (default:NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useCountryIP', '메일 보낸사람 국기 표시 여부', 'NO', '메일 리스트에서 보낸사람 앞에 국기를 표시한다. YES: 사용 (default:NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'chkSchedulePublic', '일정등록 공개범위 기본값 설정 여부', 'OFF', '일정작성시 사용자의 일정 공개 기본값 설정 기능 사용 여부 ON : 일정 공개/비공개 기본값 설정 기능 사용 OFF : 일정 비공개 기본값 설정', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일정관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMobileManagemant','모바일 설정 통합 사용 여부','NO','모바일 설정 사용여부 YES:사용함 NO:사용안함 (default : NO) (관리자)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAllowUserMobileManagement','모바일 설정 유저의 사용 여부 ','YES','유저의 모바일 설정 사용여부 (default: YES) (유저)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useScheduleIcs', '일정관리 ICS파일 가져오기 기능 사용 여부', 'NO', '일정관리에서 ICS파일 가져오기 기능 사용 여부 YES: 사용 / NO: 사용안함 (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일정관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSharedMailbox', '공유사서함 기능 사용 여부', 'YES', '메일에서 공유사서함 기능 사용 여부 YES: 사용 / NO: 사용안함 (default: YES)', TO_DATE('2019-12-09 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useRDBOnlyMailList', '메일목록 표시 RDB 쿼리 사용', 'YES', '메일목록 표시 RDB 쿼리 사용 여부 YES: 사용 / NO: 사용안함 (default: YES)', TO_DATE('2020-12-28 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useShareApproval', '전자결재 공유결재자', 'NO', '전자결재 공유결재자 사용 유무. YES: 사용 NO: 사용안함',  TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSyncServer', '수동 인사정보 동기화 사용 여부', 'NO', '수동 인사정보 동기화 사용 여부. YES: 사용 NO: 사용안함', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ezSyncServerUrl', 'ezSyncServer 인사정보 동기화 호출 url', 'http://127.0.0.1:9091/ezSyncServer/std/syncAccounts', 'ezSyncServer 인사정보 동기화 요청 url', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useModuleUsage', '모듈별 모니터링 사용여부', 'NO', '관리자>시스템에서 모듈별 사용량을 조회하는 모니터링 기능을 사용한다. (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useActiveX', 'ActiveX 사용여부', 'NO', '그룹웨어 접속 시 ActiveX를 설치하고 사용한다. (default: NO)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'systemCountryCode', '현재국가코드', 'KR', '메일리스트 > 국기표시시 현재국가코드 나타냄 (default: KR), 시스템 국가는 useShowSystemCountry 설정이 YES일 때만 표시', TO_DATE('2018-12-20 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useShowSystemCountry', 'systemCountryCode와 .eml파일의 국가코드가 같을시 국기 표시할지 여부', 'NO', 'systemCountryCode와 .eml파일의 국가코드가 같을시 국기 표시할지 여부 YES: 현재 국가도 국기표시 NO: 현재 국가는 표시하지 않음 (default: NO)', TO_DATE('2018-12-20 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'dotNetTotalNotification', '닷넷 모듈의 통합알림 사용 여부', 'NO', 'YES/NO (default: NO)', TO_DATE('2019-01-08 00:00:00','yyyy-mm-dd hh24:mi:ss'), '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSurvey', '전자설문 리뉴얼 모듈 사용여부', 'YES', 'YES: 사용NO: 사용안함 (default: YES)', TO_DATE('2019-06-26 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'usePortalAutoRefreshInterval', '포탈 자동 새로고침 간격', '5', '포탈 자동 새로고침 간격(분 단위), 단 0이면 새로고침 사용안함', TO_DATE('2019-01-08 00:00:00','yyyy-mm-dd hh24:mi:ss'), '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'Pop3MaxFetchSize', 'pop3 외부메일 확인 최대 개수', '40', 'pop3 외부메일 확인시 최대로 가져올 수 있는 메일 개수 제한 (default: 40)', TO_DATE('2019-01-08 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'mobileRedirection', '모바일 기기로 접속시 리다이렉션할 주소', '*', '모바일 기기로 접속시 리다이렉션할 주소. 단, *면 사용 안함', TO_DATE('2019-01-08 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSession', '세션 유지 시간', '0', '세션 유지 시간. 단, 0이면 세션 사용 안함 (default: 0)', TO_DATE('2018-12-20 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSessionMobile', '세션 유지 시간 모바일', '0', '세션 유지 시간. 단, 0이면 세션 사용 안함 (default: 0)', TO_DATE('2019-01-08 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseEnforceSihang', '시행문변환 관인등록 옵션 (일반버전 .mht용)', 'YES', 'YES: 사용 (관리자 > 전자결재 > 관인대장 메뉴 표시 ) NO: 사용안함 (default : YES)', TO_DATE('2019-09-17 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useUtilTalk', '유틸메뉴 톡설치(메신저설치) 사용여부', 'NO', '포탈 탑메뉴 유틸메뉴에 톡설치 기능을 사용한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2019-09-20 00:00:00','yyyy-mm-dd hh24:mi:ss'), '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'talkFilePath', '톡 설치 프로그램 위치', '/files/ezEKP-20190916.tar.gz', '톡 설치 프로그램 위치', TO_DATE('2019-09-20 00:00:00','yyyy-mm-dd hh24:mi:ss'), '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useTotalSearch', '통합검색 사용여부', 'NO', '포탈 탑메뉴 유틸메뉴 옆에 통합검색 기능을 사용한다.YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2019-10-04 00:00:00','yyyy-mm-dd hh24:mi:ss'), '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_CIRCULAR', '회람판 모듈 사용여부', 'NO', 'YES: 사용 NO: 사용안함 (default: YES)', TO_DATE('2017-01-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '회람판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailWriteRecipientAdditional', '메일쓰기 수신인 추가 정보 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2019-12-10 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'mailWriteRecipientAdditionalFormat', '메일쓰기 수신인 추가 정보 포맷', ' (%s)', '자바 String.format에 들어가는 형태로 입력', TO_DATE('2019-12-10 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'mailWriteRecipientAdditionalParameters', '메일쓰기 수신인 추가 정보 파라미터', 'description','OrganUserVO 프로터피를 세미콜론으로 구분하여 입력 (default:부서)', TO_DATE('2019-12-10 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useCopyrightMenu', '수취인안내설정 관리 화면 여부', 'NO', 'YES: 사용 NO: 사용안함 (default: NO)', TO_DATE('2019-03-04 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSignatureTemplate', '서명템플릿', 'YES', '서명 템플릿 관리 사용여부 (default: YES)', TO_DATE('2019-12-09 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'spamSniperAuthIv', '스팸스나이퍼 ', 'Admin@spam123456', 'spamSniper Iv ', TO_DATE('2019-11-21 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'spamSniperAuthKey', '스팸스나이퍼 인증키', 'Admin@spam123456', 'spamSniper key', TO_DATE('2019-11-21 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'spamSniperUnixTime', '스팸스나이퍼 유효기간', '0', '스팸스나이퍼 인증 유효기간으로 초 단위로 입력', TO_DATE('2020-04-01 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'spamSniperUrl', '스팸스나이퍼 url', 'https://spam-demo.jiransecurity.com/personal/index.php', '스팸스나이퍼 url', TO_DATE('2019-11-21 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSpamSniper', '스팸스나이퍼 사용여부', 'NO', '스팸편지함 사용(default:YES, 사용안함 : NO)', TO_DATE('2019-11-21 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailConfirm', '메일 완료/완료취소', 'NO', '메일 완료/완료취소 기능 사용 여부(default: NO)', TO_DATE('2020-01-28 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'autoSendOfferFlag', '내부시행문 자동발송의뢰 옵션', '0', '자동발송의뢰 사용 시 기안부서 최종결재가 끝나면 기안자의 미처리문서함에 도착한다. 0: 자동발송의뢰 사용안함, 1: 자동발송의뢰 사용함 (내부시행문, 민원인시행문만 자동발송의뢰) (default: 0)', TO_DATE('2020-11-23 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재G');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSpamOut', '스팸아웃 사용여부', 'NO', '스팸편지함 사용(default:YES, 사용안함 : NO)', TO_DATE('2019-11-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'spamOutLoginURI', '스팸아웃 서버 ID 로그인 주소', 'http://spam-demo.ked.com/src/id_direct.php?user=%s&tok=abcdefghijklmnopqrstuvwxyz', '스팸아웃 서버의 스팸편지함으로 ID 로그인을 할 수 있는 URI, %s 로 파라미터를 넣을 수 있게 한다.', TO_DATE('2019-11-18 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useUserDefinedDL', '사용자 정의 공용배포그룹 사용 여부', 'NO', '사용자 정의 공용배포그룹 사용 여부 (default:NO)', TO_DATE('2020-02-10 14:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAnnualSusinYN', '근태 휴가계 연동 결재 완료 시점', '0', '0:수신부서결재 사용, 1:내부결제사용 : 0이면 개인연차현황에서 완료처리가 되는 시점이 수신부서 결재완료, 1이면 내부결재 완료시 결재완료', TO_DATE('2020-01-23 14:00:00','yyyy-mm-dd hh24:mi:ss'), '근태관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailAliasSettingOnLogin', '첫 로그인 시 이메일ID 설정 여부', 'NO', 'NO: 개인정보설정, 첫로그인에서 이메일ID 설정 불가능, YES: 개인정보설정, 첫 로그인 시 이메일ID 설정 가능', TO_DATE('2020-02-06 14:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useImageConvertServer', '그룹웨어에서 이미지 변환 솔루션 사용 ', '0', '0 : 사용안함, 1 : SAT', TO_DATE('2020-03-12 14:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'SATimageConvertServerURL', 'SAT 변환 솔루션 URL ', 'http://jmocha.kaoni.com:8080/DG_viewer/viewer/document/docviewer.do', 'IP 또는 PORT는 사이트에 맞게 변경', TO_DATE('2020-03-12 14:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'webfolderHostUrlForSAT', 'SAT 변환 솔루션에서 웹폴더 파일을 다운로드 하는 포트까지의 Rest API URL', 'http://jmocha.kaoni.com', '프로토콜://호스트이름:포트(생략가능)', TO_DATE('2021-06-14 00:00:00','yyyy-mm-dd hh24:mi:ss'), '웹폴더');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useAnnualScheduleYN', '근태현황 일정관리 연동', '0', '0:근태현황 일정관리 미연동, 1:근태현황 부서일정 연동, 2:근태현황 회사일정 연동', TO_DATE('2020-02-24 00:00:00','yyyy-mm-dd hh24:mi:ss'), '근태관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'workspaceHostUrl', '협업의 호스트이름 까지의 주소', 'http://space.kaoni.com', '프로토콜://호스트이름', TO_DATE('2020-02-26 00:00:00','yyyy-mm-dd hh24:mi:ss'), '협업');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'workspaceContextRootUrl', '협업으로 호출할 /ezWorkspace 이전까지의 주소', 'http://space.kaoni.com/myoffice', '프로토콜://호스트이름/myoffice', TO_DATE('2020-02-26 00:00:00','yyyy-mm-dd hh24:mi:ss'), '협업');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useLoginStop', '사용자정지 사용여부', 'YES', '사용자정지 기능 사용여부(YES/NO)', TO_DATE('2020-04-03 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'HackingAdminID', '해킹의심메일 신고 관리자 계정', 'masteradmin', '해킹의심메일 신고 관리자 계정', TO_DATE('2020-04-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useHackingMailReport', '해킹의심메일 신고 기능 사용 여부', 'NO', '해킹의심메일 신고 기능 사용 여부(YES/NO)', TO_DATE('2020-04-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useExternalMailServer', '외부메일 사용 여부', 'NO', '메일 모듈 사용 여부. YES: 외부메일 사용 NO: 내부메일 사용(default: NO)', TO_DATE('2020-04-03 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES ('0', 'USEPASSWORDRESET', 'NO', 'YES: 사용NO: 사용안함 (DEFAULT: YES)', '비밀번호 초기화 기능 사용여부', TO_DATE('2020-04-28 00:00:00','yyyy-mm-dd hh24:mi:ss'), '로그인');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'USE_MATTITUDE', '모바일 근태관리 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', TO_DATE('2020-06-30 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'attitudeMapApiKey', '근태관리 지도 api key(미사용시 빈값)', '', '근태관리 지도 api key', TO_DATE('2020-06-30 00:00:00','yyyy-mm-dd hh24:mi:ss'), '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useDeptSearchCab', '처리과 검색 조건 사용여부', 'NO', '기록물철등록부에서 검색 시 처리과 검색을 사용한다. YES:사용함 NO:사용안함 (default: NO)', TO_DATE('2020-07-13 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSchedule', 'YES: 사용 NO: 사용안함', 'YES', '일정 모듈 사용 여부', TO_DATE('2020-08-01 00:00:00','yyyy-mm-dd hh24:mi:ss'), '일정관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useResource', 'YES: 사용 NO: 사용안함', 'YES', '자원관리 모듈 사용 여부', TO_DATE('2020-08-01 00:00:00','yyyy-mm-dd hh24:mi:ss'), '자원관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useBoard', '게시판 모듈 사용 여부', 'YES', 'YES: 사용 NO: 사용안함 (default: YES)', TO_DATE('2020-08-01 00:00:00','yyyy-mm-dd hh24:mi:ss'), '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useToDo', 'YES: 사용 NO: 사용안함', 'YES', '업무관리 모듈 사용 여부', TO_DATE('2020-08-01 00:00:00','yyyy-mm-dd hh24:mi:ss'), '업무관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'UseAutoDeleteOfRetireUser', '퇴직자 자동삭제', 'NO', 'n일 이후 퇴직자 자동삭제 사용여부(default: NO)', TO_DATE('2020-09-14 00:00:00','yyyy-mm-dd hh24:mi:ss'), '조직도');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'autoDeleteOfRetireUserLimit', '퇴직자 자동삭제', '0', 'n일 이후 퇴직자 자동삭제 : n일 설정(default: 0, 0=사용안함)', TO_DATE('2020-09-14 00:00:00','yyyy-mm-dd hh24:mi:ss'), '조직도');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useExternalMailServerAddress', '외부메일 서버 주소 ', '0.0.0.0', '외부메일 서버 주소 (default:0.0.0.0)', TO_DATE('2020-09-29 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useExternalMailServerAuth', '외부메일 서버 인증 사용여부 ', 'NO', '외부메일 서버 인증 사용여부(default: NO)', TO_DATE('2020-09-29 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useExternalMailServerUserId', '외부메일 서버 인증 id', 'authId', '외부메일 서버 인증 id (ex: test@test.com)', TO_DATE('2020-09-29 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useExternalMailServerUserPw', '외부메일 서버 인증 pass', 'authId', '외부메일 서버 인증 pass (ex: password123)', TO_DATE('2020-09-29 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useDeleteMailBlob', '메일 blob 삭제 스케줄러 사용여부', 'YES', '메일 blob 삭제 스케줄러 사용여부 (default:YES)', TO_DATE('2021-02-19 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useCar', 'YES: 사용 NO: 사용안함', 'NO', '차량관리 모듈 사용 여부', TO_DATE('2021-07-12 00:00:00','yyyy-mm-dd hh24:mi:ss'), '차량관리');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'ApprNonElecRecType', '전자결재G 비전자문서등록 양식 확장자', 'HWP', '전자결재 G버전의 비전자문서 등록 시, 양식 확장자를 설정한다. (MHT 또는 HWP) (default : HWP)', TO_DATE('2021-04-07 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'copyReadCountBoardItem', '게시물 복사/이동 시 조회정보 유지기능', 'MOVE', '게시물 복사/이동 시 조회수, 조회자정보 유지 여부  COPY : 복사 시 조회정보 유지 MOVE : 이동 시 조회정보 유지 (default) ALL : 복사, 이동 시 조회정보 유지 NO : 사용안함', TO_DATE('2019-12-17 00:00:00','yyyy-mm-dd hh24:mi:ss'), '게시판');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useApprCodeCont', '분류코드문서함 사용유무(전자결재 일반)', 'YES', '전자결재 분류코드문서함 사용유무', TO_DATE('2021-05-21 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useApprFormCont', '양식별문서함 사용유무(전자결재 일반)', 'YES', '전자결재 양식별문서함 사용유무', TO_DATE('2021-05-21 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useMailApprNoti', '전자결재에서 알림 메일 기능 사용 여부', 'YES', '전자결재에서 알림 메일 기능 사용 여부  YES: 사용 NO: 사용안함 (default : YES) * 2024-05-07 기준으로 표준모듈 master 브랜치에서 더이상 사용되지 않음', TO_DATE('2020-05-21 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
-- 전자결재 첨부파일 - SAT뷰어사용 관련 변수 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useApprImageConvert', '전자결재 첨부파일 이미지 변환솔루션 사용', '0', '전자결재 첨부파일 이미지 변환솔루션 사용  여부  1: 사용 0: 사용안함 (default : 0)', TO_DATE('2021-06-15 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'apprConvertExt', '이미지 변환솔루션 사용할 전자결재 첨부파일 확장자 모음', 'xlsx:xls:pdf:hwp:doc', '이미지 변환할 확장자 모음 (default : xlsx, xls, pdf, hwp, doc) / 구분자 : ', TO_DATE('2021-06-15 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useOrgListCheckBox', '조직도 리스트 체크박스 표시', 'NO', '조직도 리스트 체크박스 표시 (메일,주소록) (default:NO)', TO_DATE('2021-11-10 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');

-- 전자결재G 일괄기안 테넌트 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(0, 'useDraftAll', '웹한글 일괄기안 사용여부', 'NO', 'YES: 사용 NO: 사용안함 (default : NO)', TO_DATE('2022-02-25 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재G');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'androidAppVersion', 'Mobile App Android Version', '1.0.0', 'Mobile App Android Version', TO_DATE('2021-11-10 00:00:00','yyyy-mm-dd hh24:mi:ss'), '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'iosAppVersion', 'Mobile App IOS Version', '1.0.0', 'Mobile App IOS Version', TO_DATE('2021-11-10 00:00:00','yyyy-mm-dd hh24:mi:ss'), '모바일');

-- 메일 자동전달 외부 주소 허용 여부 설정
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE)  VALUES (0, 'useBlockExternalForwardAddress', '외부주소 사용여부', 'NO', 'YES: 외부주소 허용하지 않음, NO: 외부주소 허용 (기본값: NO)',TO_DATE('2023-04-06 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');

-- 전자결재 리스트 우측 미리보기 테넌트 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE)  VALUES (0, 'useAprPreview', '전자결재 리스트 우측 미리보기 사용여부', 'YES', '전자결재 리스트 우측에 미리보기 영역을 표출한다. YES: 사용  NO: 사용안함 (default: NO)', TO_DATE('2022-07-01 09:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');

-- 전자결재 기록물 등록 시 결재권자 칼럼(APRMEMBERTITLE)에 최종결재자명 또는 최종결재자 직위를 삽입하는 옵션 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE)  VALUES (0, 'recordAprMemberTitleType', '전자결재 기록물등록 시 결재권자 칼럼에 결재자명 또는 직위를 삽입', 'TITLE', '전자결재 기록물등록 시 결재권자 칼럼에 결재자명 또는 직위를 삽입한다. NAME: 최종결재자명  TITLE: 최종결재자직위 (default: NAME)', TO_DATE('2022-07-26 09:00:00', 'yyyy-mm-dd hh24:mi:ss'), '전자결재');

-- 메일 태그 기능 사용 여부 설정
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE)  VALUES (0, 'useMailTag', '메일 태그 기능 사용 여부', 'NO', '메일 태그 기능 사용 여부 (기본값: NO)', TO_DATE('2022-10-05 00:00:00','yyyy-mm-dd hh24:mi:ss'), '메일');

-- 전자결재G 관리자단 좌측메뉴 기록물철 자동생성 메뉴 표출여부 테넌트 컨피그 추가 (스케줄러가 아닌 반자동 생성)
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(0, 'useRegisterCabinetSemiAuto', '전자결재G 관리자단 좌측메뉴 기록물철 자동생성 메뉴 표출여부', 'NO', '전자결재G 관리자단 좌측메뉴에 기록물철 자동생성 메뉴를 표출한다. (현재 연도의 종료 예정 기록물철을 그대로 복사하여 원하는 생산연도의 기록물철로 생성하는 기능 사용 여부) YES: 사용  NO: 사용안함 (default: NO)', TO_DATE('2022-12-27 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), '전자결재G');

-- 전자결재 가변결재선 기본 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(0, 'UseDynamicAprLine', '전자결재 가변결재선 사용여부', '0', '0/1 (0:사용안함, 1:사용함) (default: 0)', TO_DATE('2022-12-29 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), '전자결재');

INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (0, 'Top', 'useCopyright', 'NO');
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (0, 'Top', 'ExpirePassPeriod', '0');
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (0, 'Top', 'MaxAllowedCountOfLoginFail', '0');
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (0, 'Top', 'UsePasswordPatternPolicy', 'NO');
-- 중복 로그인 허용 (기본값: YES, 허용)
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (0, 'Top', 'useMultiLogin', 'YES');
-- 중복 로그인 비허용시 PC, Mobile 통합 체크 (기본값: NO, 따로 체크)
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (0, 'Top', 'useMobileIntergratedMultiLogin', 'NO');

INSERT INTO tbl_deptmaster (TENANT_ID,CN,DISPLAYNAME,DISPLAYNAME2,USEFLAG,MAIL,COMPNM2,DEPTLEVEL,DEPT_CD_PATH,DEPT_NM_PATH,EXTENSIONATTRIBUTE1,EXTENSIONATTRIBUTE2,EXTENSIONATTRIBUTE3,EXTENSIONATTRIBUTE4,EXTENSIONATTRIBUTE5,EXTENSIONATTRIBUTE6,EXTENSIONATTRIBUTE7,EXTENSIONATTRIBUTE8,EXTENSIONATTRIBUTE9,EXTENSIONATTRIBUTE10,EXTENSIONATTRIBUTE11,EXTENSIONATTRIBUTE12,EXTENSIONATTRIBUTE13,EXTENSIONATTRIBUTE14,EXTENSIONATTRIBUTE15,ADFLAG,ADSPATH,UPDATEDT) VALUES (0,'Top','조직도','OrganizationChart',NULL,'Top@jtest.kaoni.com','OrganizationChart','1','Top','조직도',NULL,'Top','조직도',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Y','CN=Top,OU=조직도,OU=TopGroup,DC=jtest,DC=kaoni,DC=com',sysdate);
INSERT INTO tbl_usermaster (TENANT_ID,CN,DISPLAYNAME,DISPLAYNAME2,MAIL,MAILNICKNAME,UPNNAME,DEPARTMENT,DESCRIPTION,DESCRIPTION2,DESCRIPTION3,PHYSICALDELIVERYOFFICENAME,COMPANY,COMPANY2,TITLE,TITLE2,TELEPHONENUMBER,HOMEPHONE,FACSIMILETELEPHONENUMBER,MOBILE,POSTALCODE,STREETADDRESS,INFO,EXTENSIONATTRIBUTE1,EXTENSIONATTRIBUTE2,EXTENSIONATTRIBUTE3,EXTENSIONATTRIBUTE4,EXTENSIONATTRIBUTE5,EXTENSIONATTRIBUTE6,EXTENSIONATTRIBUTE7,EXTENSIONATTRIBUTE8,EXTENSIONATTRIBUTE9,EXTENSIONATTRIBUTE10,EXTENSIONATTRIBUTE102,EXTENSIONATTRIBUTE11,EXTENSIONATTRIBUTE12,EXTENSIONATTRIBUTE13,EXTENSIONATTRIBUTE14,EXTENSIONATTRIBUTE15,ADSPATH,SIPURI,UPDATEDT,MOBILE_ENABLE,MOBILE_NOTUSE,MOBILE_PIN,POSITIONCD,BIRTH,BIRTHTYPE,PASSWORD,IPADDRESS,LASTLOGIN,LOGINCNT, LISTTYPE) VALUES (0,'masteradmin','Master','MasterAdmin','masteradmin@jtest.kaoni.com','masteradmin',NULL,'Top','조직도','OrganizationChart',NULL,'Top','조직도','OrganizationChart','MasterAdmin','MasterAdmin',NULL,NULL,NULL,NULL,NULL,NULL,' ','c=1;a=1;k=1;i=1;g=1;l=1;n=0;m=0;w=0;t=0;',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'마스터관리자','MasterAdmin',NULL,NULL,NULL,NULL,'1','CN=masteradmin,OU=사용자,OU=조직도,OU=TopGroup,DC=jtest,DC=kaoni,DC=com',NULL,sysdate,NULL,'N',NULL,NULL,NULL,'Y','m7jsQtm1Uqm+n51H00wciQOeQm9rlarZxD0wuM9QVCU=','0:0:0:0:0:0:0:1',sysdate,0,'TXT');

--Board insert 

INSERT INTO TBL_Board_MyBoards (UserID, BoardID, BoardName, BoardName2, TreeviewNum, companyID, tenant_ID) VALUES ('everyone', '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}', '새게시물', 'New BoardItem', -1, 'Top', 0);
--INSERT INTO TBL_Board_MyBoards (UserID, BoardID, BoardName, BoardName2, TreeviewNum, companyID, tenant_ID) VALUES ('everyone', '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}', '新着', 'New BoardItem', -1, 'Top', 0);

INSERT INTO TBL_Board_BoardInfo (BoardID, BoardName, BoardName2, TreeViewOrder, BoardLevel, ParentBoardID, BoardDescription, ItemExpires, AttachsizeLimit, ReplyNotify, BoardGroupID, AlertPostItem, Gubun, URL, DeleteAfter, BoardColor, BoardNo, Portlet, tenant_ID, companyID) VALUES ('{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}', '새게시물', 'New BoardItem', -1, 0, 'None', NULL, 0, NULL, 0, NULL, 0, 0, NULL, 0, NULL, 0, 'N', 0, 'Top');
--INSERT INTO TBL_Board_BoardInfo (BoardID, BoardName, BoardName2, TreeViewOrder, BoardLevel, ParentBoardID, BoardDescription, ItemExpires, AttachsizeLimit, ReplyNotify, BoardGroupID, AlertPostItem, Gubun, URL, DeleteAfter, BoardColor, BoardNo, Portlet, tenant_ID, companyID) VALUES ('{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}', '新着', 'New BoardItem', -1, 0, 'None', NULL, 0, NULL, 0, NULL, 0, 0, NULL, 0, NULL, 0, 'N', 0, 'Top');

Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',1,'No','No','No','No','DOCNO',30,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',3,'제목','Title','件名','标题','TITLE',400,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',4,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',5,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',6,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',7,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',1,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',2,'No','No','No','No','DOCNO',30,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',3,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',4,'제목','Title','件名','标题','TITLE',500,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',5,'회사','Company','会社','公司','WRITERCOMPANYNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',6,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',7,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',8,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',9,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',1,'No','No','No','No','DOCNO',30,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',3,'제목','Title','件名','标题','TITLE',500,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',4,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',5,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',6,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',1,'No','No','No','No','DOCNO',30,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',3,'제목','Title','件名','标题','TITLE',300,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',4,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',5,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',6,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',7,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',1,'No','No','No','No','DOCNO',30,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',2,'제목','Title','件名','标题','TITLE',600,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',3,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',4,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',5,'게시일','Registered','掲示日','发布日期','WRITEDATE',120,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',6,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',1,'No','No','No','No','DOCNO',30,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',3,'제목','Title','件名','标题','TITLE',400,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',4,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',5,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',6,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',7,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',1,'No','No','No','No','DOCNO',30,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',2,'제목','Title','件名','标题','TITLE',600,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',3,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',4,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',5,'게시일','Registered','掲示日','发布日期','WRITEDATE',120,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',6,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',1,'첨부','Attach','添付','附加','ATTACHMENTS',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',2,'게시판명','Board','掲示板名','布告板名称','BOARDNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',3,'제목','Title','件名','标题','TITLE',400,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',4,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',5,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',6,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',7,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',1,'No','No','No','No','DOCNO',30,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',3,'게시판명','Board','掲示板名','布告板名称','BOARDNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',4,'제목','Title','件名','标题','TITLE',400,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',5,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',6,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',7,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',8,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',1,'No','No','No','No','DOCNO',30,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',3,'게시판명','Board','掲示板名','布告板名称','BOARDNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',4,'제목','Title','件名','标题','TITLE',400,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',5,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',6,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',7,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',8,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',1,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',2,'제목','Title','件名','标题','TITLE',400,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',3,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',4,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',5,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',0);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',6,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',0);
--Community Insert

Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('AA','a','t1496',1,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CC','a','t1497',2,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CE','a','t1498',3,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CG','a','t1499',4,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CI','a','t1500',5,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CK','a','t1501',6,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CM','a','t1502',7,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CO','a','t1503',8,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EC','a','t1504',9,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EE','a','t1505',10,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EG','a','t1506',11,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EI','a','t1507',12,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('ZA','a','t1508',22,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('AA','b','t1509',1,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CC','b','t1510',2,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EC','b','t1511',3,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('GC','b','t1512',4,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('IC','b','t1513',5,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('KC','b','t1514',6,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('MC','b','t1515',7,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('OC','b','t1516',8,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('QC','b','t1517',9,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EK','a','t1518',13,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('ZC','b','t1519',10,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('AA','c','t1520',1,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CC','c','t1521',2,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EC','c','t1522',3,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('GC','c','t1523',4,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('IC','c','t1524',5,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('KC','c','t1525',6,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('MC','c','t1526',7,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('OC','c','t1527',8,0);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('ZA','c','t1528',9,0);

-- approvalG Insert
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZA000001', N'총무행정', N'총무행정', NULL, N'총무행정_Eng','Top',0);
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZB000001', N'경제', N'경제', NULL, N'경제_Eng','Top',0);
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZC000001', N'재무', N'재무', NULL, N'재무_Eng','Top',0);
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZZ000001', N'감사', N'감사', NULL, N'감사_Eng','Top',0);
INSERT INTO TBL_TASKCATEGORY  (CategoryCode,  Name,  Description,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZZ000002', N'에너지', N'에너지관리공단테스트용', NULL, N'에너지_Eng','Top',0);

INSERT INTO TBL_LastDocID  (lastDocID, COMPANYID, TENANT_ID) VALUES ('0                ','Top', 0);

INSERT INTO   TBL_FormContainer  (FormContID,  FormContName,  FormContOwnDepID,  FormContParents,  FormContdescription,  FormContName2, COMPANYID, TENANT_ID) VALUES (N'2004000001', N'기본양식함', N'ALL', N'ROOT', N'기본 양식함 입니다.', N'DEPT003','Top',0);
-- INSERT INTO   TBL_FormContainer  (FormContID,  FormContName,  FormContOwnDepID,  FormContParents,  FormContdescription,  FormContName2, COMPANYID, TENANT_ID) VALUES (N'2004000003', N'HWP양식함', N'ALL', N'ROOT', NULL, NULL,'Top',0);

INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'100', N'품의함', N'Draft','Top',0);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'200', N'협조함', N'Support','Top',0);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'300', N'감사함', N'Audit','Top',0);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'500', N'수신함', N'Receive','Top',0);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'600', N'합의함', N'Agree','Top',0);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'610', N'발신함', N'Send','Top',0);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'700', N'반송함', N'Reject','Top',0);
INSERT INTO   TBL_ContainerType  (ContainerTypeID,  ContainerTypeName,  ContainerTypeName2, COMPANYID, TENANT_ID) VALUES (N'999', N'폐기함', N'Obsolete','Top',0);

INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'100', N'001','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'200', N'002','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'300', N'003','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'300', N'014','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'300', N'018','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'500', N'011','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'500', N'015','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'600', N'012','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'610', N'019','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (NULL , N'022','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (NULL , N'023','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'700', N'031','Top',0);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'700', N'032','Top',0);

INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'aa000001', N'감사결과처리', N'감사결과처리', N'ZZ000001', NULL, N'감사결과처리_Eng','Top',0);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'aa000002', N'인사관리', N'인사관리', N'ZZ000001', NULL, N'인사관리_Eng','Top',0);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ab000001', N'기록관리', N'기록관리', N'ZA000001', NULL, N'기록관리_Eng','Top',0);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ac000001', N'경제협력', N'경제협력', N'ZB000001', NULL, N'경제협력_Eng','Top',0);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ad000001', N'조세', N'조세', N'ZC000001', NULL, N'조세_Eng','Top',0);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'cb000001', N'기록관리', N'기록관리', N'ZA000001', NULL, N'기록관리_Eng','Top',0);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'cc000001', N'인사관리', N'인사관리', N'ZA000001', NULL, N'인사관리_Eng','Top',0);
INSERT INTO   TBL_TASKMIDDLECATEGORY  (MCategoryCode,  Name,  Description,  CategoryCode,  OldFlag,  Name2, COMPANYID, TENANT_ID) VALUES (N'ZZ000022', N'에너지용', N'에너지용', N'ZZ000002', NULL, N'에너지용_Eng','Top',0);

------------------------------------------
-- TENANT_ID 추가시 TENANT_ID 수정해서 INSERT
-------------------------------------------

INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (1, SYS_GUID (), 'processinfo', 'F0001', '문서정보', 'ROOT','Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (2, SYS_GUID (),'headcampaign', 'F0002', '머리표제', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (3, SYS_GUID (),'doctitle', 'F0003', '문서제목', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (4,	SYS_GUID (), 'body', 'F0004', '본문', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (5,	SYS_GUID (), 'docnumber', 'F0005', '문서번호', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (6,	SYS_GUID (), 'grouping', 'F0006', '분류기호', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (7, SYS_GUID (),'publication', 'F0007', '공개유무', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (8,	SYS_GUID (), 'securitylevel', 'F0008', '보안등급', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (9,	SYS_GUID (), 'keepperiod', 'F0009', '보존년한', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (10,SYS_GUID (), 'docsummary', 'F0010', '문서요약', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (11,SYS_GUID (), 'senddate', 'F0011', '발신일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (12,SYS_GUID (), 'enforcedate', 'F0012', '시행일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (13,SYS_GUID (), 'memo', 'F0013', '의견', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (14,SYS_GUID (), 'zipcode', 'F0014', '우편번호', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (15,SYS_GUID (), 'telephone', 'F0015', '전화', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (16,SYS_GUID (), 'junkyul', 'F0016', '전결/대결', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (17,SYS_GUID (), 'address', 'F0017', '주소', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (18,SYS_GUID (), 'sealsign', 'F0018', '관인날인', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (19,SYS_GUID (), 'noseal', 'F0019', '관인생략', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (20,SYS_GUID (), 'receiptnumber', 'F0056', '접수번호', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (21,SYS_GUID (), 'draftinfo', 'F0020', '기안부서 정보', 'ROOT','Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (22,SYS_GUID (), 'draftername', 'F0021', '기안자 성명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (23,SYS_GUID (), 'department', 'F0022', '기안자 부서명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (24,SYS_GUID (), 'position', 'F0023', '기안자 직위', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (25,SYS_GUID (), 'email', 'F0024', '기안자 E-Mail', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (26,SYS_GUID (), 'draftdate', 'F0025', '기안일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (27,SYS_GUID (), 'lastKyulName', 'F0026', '최종결재자명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (28,SYS_GUID (), 'lastKyuljikwee', 'F0027', '최종결재자직위', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (29,SYS_GUID (), 'chief', 'F0028', '기관장', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (30,SYS_GUID (), 'deptshortedname', 'F0029', '부서약어', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (31,SYS_GUID (), 'receiptinfo', 'F0030', '수신 정보', 'ROOT','Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (32,SYS_GUID (), 'recipient', 'F0031', '수신', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (33,SYS_GUID (), 'recipients', 'F0032', '수신처', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (34,SYS_GUID (), 'refer', 'F0033', '참조', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (35,SYS_GUID (), 'seal', 'F0034', '발신처명의', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (36,SYS_GUID (), 'receiptdate', 'F0035', '접수일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (37,SYS_GUID (), 'approvalinfo', 'F0036', '기안결재 사인정보', 'ROOT','Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (38,SYS_GUID (), 'sign', 'F0037', '결재사인', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (39,SYS_GUID (), 'approdept', 'F0038', '결재자부서명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (40,SYS_GUID (), 'jikwe', 'F0039', '결재자직위', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (41,SYS_GUID (), 'seumyung', 'F0040', '결재자명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (42,SYS_GUID (), 'seumyungdate', 'F0041', '결재일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (43,SYS_GUID (), 'habyuisign', 'F0042', '합의자 사인', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (44,SYS_GUID (), 'habyui', 'F0043', '합의자 부서명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (45,SYS_GUID (), 'habyuipositon', 'F0044', '합의자 직위', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (46,SYS_GUID (), 'habyuija', 'F0045', '합의자명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (47,SYS_GUID (), 'habyuidate', 'F0046', '합의일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (48,SYS_GUID (), 'gongram', 'F0047', '공람사인', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (49,SYS_GUID (), 'recvapprovalinfo', 'F0048', '수신결재 사인정보', 'ROOT','Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (50,SYS_GUID (), '1sign', 'F0049', '결재사인1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (51,SYS_GUID (), '1approdept', 'F0050', '결재자부서명1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (52,SYS_GUID (), '1jikwe', 'F0051', '결재자직위1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (53,SYS_GUID (), '1seumyung', 'F0052', '결재자명1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (54,SYS_GUID (), '1seumyungdate', 'F0053', '결재일자1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (55,SYS_GUID (), 'userdefinedinfo', 'F0054', '사용자 지정', 'ROOT','Top',0);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (56,SYS_GUID (), '', 'F0055', '사용자정의정보', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='userdefinedinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);
-- INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (57,SYS_GUID (), 'free', 'F0057', '사용자정의정보', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='userdefinedinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',0);

INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','003','수신문','1','수신문','Receipt','受信文','收件文件','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','004','연계기안','1','시행문','Linked Draft',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','005','협조','1','부서합의','Agreement(personal)','合意','起案书','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','006','감사','0','감사문서','Audit','監査','审查','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A24','001','0','1','문서보기를 위한 기한을 설정.','0','0','0','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A25','0  ','회송처리','1','0:원기안부서, 1:이전 수신부서','회송처리','회송처리','회송처리','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A25','001','0','1','구분','0','0','0','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A26','0  ','대리결재사인헤드','1','대리결재사인헤드','대리결재사인헤드','대리결재사인헤드','대리결재사인헤드','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A26','001','代','1','대리결재사인헤드','代','代','代','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A27','0  ','수신처구분','1','0:부서,1:부서/사람','수신처구분','수신처구분','수신처구분','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A27','001','부서','1','부서','부서','부서','부서','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A27','002','부서/사람','0','부서/사람','부서/사람','부서/사람','부서/사람','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A28','0  ','조직도구분','0','조직도 구분','조직도구분','조직도구분','조직도구분','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A28','001','001','1','조직도 직위','001','001','001','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A28','002','002','0','조직도 직책','002','002','002','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A28','003','003','0','조직도 직위/직책','003','003','003','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A29','0  ','개인수신처','0',null,'개인수신처','개인수신처','개인수신처','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A29','001','개인수신처구분','0','1:수신처리기, 0:결재진행관리기','개인수신처구분','개인수신처구분','개인수신처구분','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A30','0  ','문서채번룰','1','문서채번시 적용되는 룰 정의','문서채번룰','문서채번룰','문서채번룰','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A30','001','11S','1','x1 - 채번범위 (0:전체, 1:부서별, 2:양시함별) x2 - 분류기호 사용여부(0:사용안함, 1:사용함) x3 - 초기화 시점 (N: 초기화안함, M: 월별, Y:년별)','11S','11S','11S','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A30','002','0000','1','문서번호 FORMAT','0000','0000','0000','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A30','003','2','1','회계종료월 (예: 2007.3~2008.2 이 회계년도이면 2를 넣는다. 1~12월이면 0을 넣는다)로 채번 및 기록물등록년도에 이용된다','2','2','2','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A31','0  ','결재처리제한','0','결재처리 되지 않는 문서리스트 제한','결재처리제한','결재처리제한','결재처리제한','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A31','001','3','0','N일 이상 지체되는 결재문서','3','3','3','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A32','0  ','전결처리방법','0','전결처리방법 정의','전결처리방법','전결처리방법','전결처리방법','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A32','001','100','1','x1 - 전결자 (0:사인, 1:전결표시)x2 - 전결이후 결재자(0:표시안함, 1: 전결표시)x3 - 최종결재자(0:사인, 1:전결표시)','100','100','100','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A33','0  ','결재칸Split 유무','0','결재한 Split  유무확인','결재칸Split 유무','결재칸Split 유무','결재칸Split 유무','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A33','001','N','1','사용유무','N','N','N','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A33','002','FIX','1','FIX : 칸고정, DIV : 칸나눔으로 처리','FIX','FIX','FIX','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A34','0  ','문서링크','0','합의/감사 문서 Link','문서링크','문서링크','문서링크','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A34','001','9','1','0:사용안함,1:합의,2:감사,9:전체적용','9','9','9','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A35','0  ','수신함보내기','0','수신함으로 바로 보내기','수신함보내기','수신함보내기','수신함보내기','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A35','001','0','1','0:사용안함,1:사용함. 1이면 완료쪽으로 Copy','0','0','0','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A35','002','G','1','G버전 Flag. "G"면 심사시에만 문서 발송. (G 정부버전, S 대학버전)','G','G','G','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A35','003','Y','1','G버전 폐기 Flag. "Y"면 완료후 보존기간 경과한 문서 폐기 대상. 그외는 이관된 기록물철은 모두 폐기대상.','Y','Y','Y','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','0  ','변환문서','0','변환문서URL','변환문서','변환문서','변환문서','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','001','/files/upload_approvalG/form/2003000007.mht','1','합의문서','/files/upload_approvalG/form/2003000007.mht','/files/upload_approvalG/form/2003000007.mht','/files/upload_approvalG/form/2003000007.mht','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','002','/upload_approvalG/Top/form/2006000001.hwp','1','감사문서','/upload_approval/Top/form/2003000008.mht','/upload_approvalG/Top/form/2006000001.hwp','/upload_approvalG/Top/form/2006000001.hwp','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','003','/files/upload_approvalG/form/relay001.hwp','1','유통문서(중계)','/files/upload_approvalG/form/relay001.hwp','/files/upload_approvalG/form/relay001.hwp','/files/upload_approvalG/form/relay001.hwp','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','004','/upload_approvalG/Top/form/2006000001.hwp','1','행정문서(연계)','/upload_approvalG/Top/form/2006000001.hwp','/upload_approvalG/Top/form/2006000001.hwp','/upload_approvalG/Top/form/2006000001.hwp','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','005','/upload_approvalG/Top/form/2006000001.hwp','1','전자기안문','/upload_approvalG/Top/form/2006000001.hwp','/upload_approvalG/Top/form/2006000001.hwp','/upload_approvalG/Top/form/2006000001.hwp','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','006','/ekp/Upload_ApprovalG/','1','Document Path','/ekp/Upload_ApprovalG/','//ekp/Upload_ApprovalG/','//ekp/Upload_ApprovalG/','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','007','2005000015;','1','(전자기안문양식아이디1);(전자기안문양식아이디2);.....','2005000015;','2005000015;','2005000015;','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A37','0  ','그룹사용','0','참조그룹사용','그룹사용',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A37','001','junsign','1','사인ID 값. null 값이면 사용안함','junsign',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A38','0  ','특정인 결재처리','0','특정인에 대한 결재 사인처리를 한다.','특정인 결재처리','특정인 결재처리','특정인 결재처리','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A38','001','1','1','참조사용유무 0:사용안함,1:사용함','1','1','1','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A39','0  ','첨부문서Filter',null,'첨부할 문서 종류를 제한한다.','첨부문서Filter','첨부문서Filter','첨부문서Filter','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A39','001','NONE','1','NONE(대문자) : 사용안함 , ;로 구분한다.','NONE','NONE','NONE','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A39','002','50','1','단위:메가','50','50','50','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A40','0  ','감사부서정의','0','감사부서 정의','감사부서정의','감사부서정의','감사부서정의','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A40','001','S907002','1','20630감사부서ID 리스트, 부서1;부서2;부서3;..부서N','S907002','S907002','S907002','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A43','0  ','노티유무','0','노티유무','노티유무','노티유무','노티유무','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A43','001','Y','1','N:사용안함,Y:사용','Y','Y','Y','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A44','0  ','최근결재선정보','1','최근 결재선 정보 사용유무','최근결재선정보','최근결재선정보','최근결재선정보','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A44','001','1','1','결재선 : 0:사용안함,1:사용함','1','1','1','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A44','002','0','1','수신처 : 0:사용안함,1:사용함','1','0','0','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A50','0  ','공개/비공개 정의','0','공개비공개정의(ALL : 모든 사람, DEPT : 부서원 + 결재선, LINE : 결재선, DRAFT : 기안자만)','공개/비공개 정의','공개/비공개 정의','공개/비공개 정의','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A50','1  ','ALL','1','공개','ALL','ALL','ALL','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A50','2  ','DEPT','1','부분공개','DEPT','DEPT','DEPT','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A50','3  ','LINE','1','비공개','LINE','LINE','LINE','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','0  ','보안등급정의','0','보안등급정의','보안등급정의',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','001','1;1등급;100','1','임시;이름;코드','1;Level 1;100','1;Level 1;100','1;Level 1;100','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','002','1;2등급;200','1',null,'1;Level 2;200','1;Level 2;200','1;Level 2;200','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','003','1;3등급;300','1',null,'1;Level 3;300','1;Level 3;300','1;Level 3;300','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','006','1;준영구;100','1',null,'1;Semi-permanence;100','1;準永久;100','1;准永久;100','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','007','1;영구;1000','1',null,'1;Permanence;1000','1;永久;1000','1;永久;1000','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A53','0  ','수신처그룹기호','0','수신처그룹구분기호 정의','수신처그룹기호','수신처그룹기호','수신처그룹기호','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A53','001','SG_','1','수신처 그룹 앞부분에 사용할 필드명. COM에서 사용. 스크립트 부분 동기화 필요','SG_','SG_','SG_','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A53','002','Y','1','수신처 그룹 확장(수신처 저장시 확장여부). Y는 사용. N은 사용안함','Y','Y','Y','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A54','0  ','배부대장처리방법','0','배부대장 처리방법','배부대장처리방법','배부대장처리방법','배부대장처리방법','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A54','001','Y','1','Y:기존 데이터 업데이트, N:신규데이터생성','Y','Y','Y','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A54','002','Y','1','Y:다중배부 문서 재배부요청 시 한개의 문서만 남김, N:다중배부문서 재배부요청시 문서변화 없음','Y','Y','Y','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A55','0  ','자동발송의뢰코드','0','민원인 주소가 존재할 때에 자동 발송의뢰 하는 루틴 옵션. (계명대 특수 옵션)','자동발송의뢰코드','자동발송의뢰코드','자동발송의뢰코드','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A55','001','Top','1','민원인 주소일때에 이 부서로 자동 발신을 의뢰한다.','Top','Top','Top','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A56','0  ','공람발송관련','0','수신처 공람발송 순차/병렬여부 설정','공람발송관련','공람발송관련','공람발송관련','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A56','001','Y','1','Y면 병렬, 그외는 순차 공람.','Y','Y','Y','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A57','0  ','내양식함관련','0','내양식함 기능 사용 여부','내양식함관련','내양식함관련','내양식함관련','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A57','001','Y','1','내양식함기능 사용여부 (Y는 사용. 그외는 사용안함)','Y','Y','Y','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','0  ','수신처상태','0','ProcessYN Flag','수신처상태','수신처상태','수신처상태','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','A  ','도착','1','도착 (Arrived)','Arrived','到着','到达','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','B  ','발송의뢰반송','1','발송의뢰반송(Return Offered)','Return Offered','送信依頼拒否','拒绝发送请求','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','E  ','전송실패','1','전송 실패 (Error)','Error','送信エラー','传输失败','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','H  ','회송','1','회송 (HweSong)','Return','返送','返回','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','I  ','접수','1','접수 (Inter..)','Reception progress','受付','收到','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','N  ','대기','1','발신 대기 (Not Yet)','No receipt','待機','待机','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','O  ','발송의뢰','1','발송 의뢰 (Offered)','Offered','送信依頼','发送请求','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','R  ','수신','1','수신 (Received)','Received','受信','接待','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','S  ','발송','1','발송 (Sent)','Sent','送信','送货','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','T  ','재발송대기','1','재발송대기 (Try Again)','Try Again','再送待ち','不满等待','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','V  ','도달','1','도달 (arriVed)','arriVed','到達','抵达','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','Y  ','수신완료','1','수신완료 (Yes)','Reception complete','受信完了','接收完成','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('F01','0  ','플로우','0','플로우관련 업무 정의','플로우','플로우','플로우','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('F01','001','Y','1','수발신문을 발신함으로 보낸다.','Y','Y','Y','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('F01','002','O','1','D:DSN연결;O:OleDB 연결','O','O','O','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J01','0  ','조직도소팅순서','1','조직도소팅순서','조직도소팅순서','조직도소팅순서','조직도소팅순서','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J01','001','이름순서','0','이름순서','Name Order','Name Order','Name Order','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J01','002','TREE ORDER LIST','0','조직도 순서리스트','TREE ORDER LIST','TREE ORDER LIST','TREE ORDER LIST','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J01','003','사번','0','사번','EmpNo','EmpNo','EmpNo','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','000','사원리스트','4','사원리스트순서사용여부','사원리스트','사원리스트','사원리스트','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','001','성명','1','사원명','Name','氏名','姓名','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','002','부서','1','부서명','Dept.','部署','部门','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','003','직위','1','사원직위','Title','役職','职位','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','004','전화번호','1','전화번호','전화번호','電話番号','电话号码','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','005','회사','1','회사명','회사','会社','公司','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J03','002','KMTESTOrganName','1','KMTESTOrganName',null,null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L01','0  ','다국어처리','0','다국어코드값','다국어처리','다국어처리','다국어처리','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L01','001','파일','1','File','File','File','File','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L01','002','문서','1','Document','Document','Document','Document','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L02','001','문서함명리스트','0','NULL','Doc. folder name','文書フォルダ名','Doc. folder name','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L03','001','개인문서함','1','개인문서함-GetUserContTree()','Personal doc. folder','Personal doc. folder','Personal doc. folder','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L03','002','문서함명','1','부서문서함-GetDeptContTree()','Dept. doc. folder','文書フォルダ名','Dept. doc. folder','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L04','001','부서명','1','부서명-GetContUseDeptInfo()','Dept. name','Dept. name','Dept. name','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','001','코드','1','GetItemCode_Item()','Code','Code','Code','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','002','기능명칭','1','GetItemCode_Item()','Name','Name','Name','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','004','1;4등급;400','1',null,'1;Level 4;400','1;Level 4;400','1;Level 4;400','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','003','보존기간','1','GetItemCode_Item()','Keeping period','Keeping period','Keeping period','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','004','보안등급','1','GetItemCode_Item()','Security level','Security level','Security level','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','005','1;5등급;500','1',null,'1;Level 5;500','1;Level 5;500','1;Level 5;500','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','0  ','보존년한정의','0','보존연한정의','보존년한정의','보존년한정의','보존년한정의','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','001','1;1년;1','1',null,'1;1 year;1','1;1年;1','1;1年;1','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','002','1;2년;2','0',null,'1;2 year;2','1;2年;2','1;2年;2','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','003','1;3년;3','1',null,'1;3 year;3','1;3年;3','1;3年;3','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','004','1;5년;5','1',null,'1;5 year;5','1;5年;5','1;5年;5','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','005','1;10년;10','1',null,'1;10 year;10','1;10年;10','1;10年;10','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','005','공개여부','1','GetItemCode_Item()','Public','Public','Public','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','001','결재문서','1','결재알림시 사용','결재문서','결재문서','결재문서','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','002','문서도착','1','결재알림시 사용','문서도착','문서도착','문서도착','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','003','문서완료','1','결재알림시 사용','문서완료','문서완료','문서완료','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','004','문서반송','1','결재알림시 사용','문서반송','문서반송','문서반송','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','005','문서보류','1','결재알림시 사용','문서보류','문서보류','문서보류','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','006','문서발송','1','결재알림시 사용','문서발송','문서발송','문서발송','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','007','수신문서','1','결재알림시 사용','수신문서','수신문서','수신문서','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','008','지정문서','1','결재알림시 사용','지정문서','지정문서','지정문서','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','009','회송문서','1','결재알림시 사용','회송문서','회송문서','회송문서','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','010','문서회수','1','결재알림시 사용','문서회수','문서회수','문서회수','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','011','결재노티','1','결재알림시 사용','결재노티','결재노티','결재노티','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','012','배부문서','1','결재알림시 사용','배부문서','배부문서','배부문서','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','013','재지정요청','1','결재알림시 사용','재지정요청','재지정요청','재지정요청','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','014','재배부요청','1','결재알림시 사용','재배부요청','재배부요청','재배부요청','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','007','신청','0','신청문서','Application','申し込み','申请','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','008','대외접수','0','대외문서접수','Receipt(outside)','対外受付','对外接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','009','대외발송','0','대외문서발송','Sending(outside)','対外送信','对外发送','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','0  ','문서상태','0','문서상태','Doc. status','文書区分','文書区分','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','001','품의','1','품의','Draft','稟議','评价','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','002','협조','1','협조','Agreement(personal)','協力','合作','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','003','준법감시','1','감사','Audit','遵法監視','监督','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','004','발송의뢰','0','심사','Request send','審査','审查','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','011','수신','1','수신','Receipt','受信','收件','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','012','합의','1','협조/합의','Agreement','合意','起案书','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','013','시행','0','시행','Enforcement','施行','执行','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','014','사전감사','0','감사(검사부)','Audit(dept.)','監査','审查','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','015','공람','0','공람','Display','回覧','传阅','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','016','회람1','0','회람','Circular','回覧','传阅','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','017','참조','1','참조','Reference','参照','抄送','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','018','사후공람','1','사후감사','Public viewing(After-approval)','事後供覧','事后共览','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','019','발송','1','발송','Sending','送信','发送','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','020','신청','1','신청','Application','施行','执行','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','022','대외접수','1','대외문서접수','Receipt(outside)','対外受付','对外接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','023','대외발송','1','대외문서발송','Sending(outside)','対外送信','对外发送','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','031','반송','1','반송','Rejection','差し戻し','退回','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','032','회송','1','회송','Returning','返送','退回','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','0  ','결재방법','0','결재방법','결재방법',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','001','결재','1','일반','Approval','決裁','审批','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','002','확인','1','확인','Confirmation','確認','確認','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','003','결재안함','0','결재안함','Skip-approval','決裁しない','不审批','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','004','전결','1','전결','Pre-approval','専決','先决','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','005','준법감시','0','감사','Audit','遵法監視','监督','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','006','발송의뢰','0','심사','Request Sending','審査','审查','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','007','참조','0','참조','Reference','参照','抄送','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','008','개인순차합의','1','개인순차협조','Agreement(personal)','個人順次合意','个人顺序协议','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','009','개인병렬합의','1','개인병렬협조','Parallel agreement(personal)','個人並列合意','个人并行协议','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','011','부서순차합의','1','부서순차협조','Sequential agreement(dept.)','部署順次合意','顺序协议(部门)','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','012','부서병렬합의','1','부서병렬협조','Parallel agreement(dept.)','部署並列合意','并行的协议(部门)','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','013','사전감사','0','감사','Pre-audit','監査','审查','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','014','수신','0','제일제당수신','Receipt','受信','收件','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','015','공람','0','후결','Display','回覧','传阅','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','016','대결','1','대결','Deputy','代決','待决','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','017','회람','0','공람','Circular reference','回覧','传阅','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','018','기안','1','기안','Draft','起案','起草','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','019','검토','1','검토','Examination','検討','评论','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','0  ','결재처리상태','0','결재처리상태','결재처리상태',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','000','미결','1','기안처리하지 않은 문서','Not approved','未決','未決','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','001','대기','1','대기','Waiting','待機','待机','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','002','진행','1','진행','In progress','進行中','进行中','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','003','승인','1','승인','Approved','決裁','审批','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','004','반송','1','반송','Rejected','差し戻し','退回','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','005','보류','1','보류','Hold','保留','保存','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','006','회수','1','회수','Withdrew','引き戻し','回收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','010','완료','1','완료','Completed','完了','完成','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','011','도착','1','도착','Arrived','到着','到达','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','012','지정','1','지정','Designated','未受付','未接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','013','접수','1','접수','Received','受付','接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','014','배부','1','배부','Distributed','配付','发行','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','015','회송','1','회송','Returned','返送','退回','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','016','접수','1','수신진행','Received','受信進行','进行接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','017','수신완료','1','수신완료','Completed(receipt)','受信完了','接收完成','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','018','발신','1','수신부서미접수','Sending','未受付','未接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','019','전송실패','1','전송실패','Sending failure','送信エラー','传输失败','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','020','수신','1','전송성공','Receipt','受信','接待','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','021','도달','1','도달(G중계)','Arrived','到達','到达','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','022','재요청','1','재발신요청','ReRequest','ジェヨチョン','再生','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','0  ','사인종류','1','사인종류','사인종류','사인종류','사인종류','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','001','PIC','1','일반결재','PIC','PIC','PIC','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','002','PIC','1','개인순차협조','PIC','PIC','PIC','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','003','PIC','1','개인병렬협조','PIC','PIC','PIC','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','004','NAME','1','부서순차협조','NAME','NAME','NAME','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','005','NAME','1','부서병렬협조','NAME','NAME','NAME','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','006','PIC','1','공람','PIC','PIC','PIC','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','007',null,'1','전결',null,null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','008',null,'1','대결',null,null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','009','DNAME','1','후결','DNAME','DNAME','DNAME','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A13','0  ','결재TYPE','1','결재형식','결재TYPE','결재TYPE','결재TYPE','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A13','001','001','0','사용자와부서분리','001','001','001','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A13','002','002','1','사용자와부서가 통합','002','002','002','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A15','0  ','UI폼형식처리','1','UI폼형식처리','UI폼형식처리','UI폼형식처리','UI폼형식처리','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A15','001','yyyy.mm.dd hh:mm','1','년-월-일','yyyy.mm.dd hh:mm','yyyy.mm.dd hh:mm','yyyy.mm.dd hh:mm','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A15','002','.','1','사인일자 형식','.','.','.','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','0  ','의견종류','1','의견종류','의견종류',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','001','일반의견','1','일반의견','General','一般','一般意见','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','002','반송의견','1','반송의견','Rejection','差し戻し','退回意见','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','003','보류의견','1','보류의견','Holding','保留','保存意见','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','004','회송의견','1','회송의견','Returning','返送','退回意见','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','005','지시사항','1','지시사항','지시사항','指示','说明','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','006','메모','1','메모','메모','メモ','备忘录','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','008','재배부요청','1','재배부요청','재배부요청','재배부요청','재배부요청','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A18','0  ','결재날짜순서','1','리스트ORDERBY','결재날짜순서','결재날짜순서','결재날짜순서','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A18','001','DESC','1','결재문서(ASC,DESC)','DESC','DESC','DESC','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A18','002','DESC','1','문서함(ASC,DESC)','DESC','DESC','DESC','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A19','0  ','첨부공유유무','0','첨부공유유무확인','첨부공유유무','첨부공유유무','첨부공유유무','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A19','001','0','1','0 : 별도, 1: 공유','0','0','0','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A20','0  ','첨부/의견 display','1','첨부/의견 유무Dispaly','첨부/의견 display','첨부/의견 display','첨부/의견 display','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A20','001','Y','1','유','Y','Y','Y','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A20','002','N','1','무','N','N','N','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','000','확장기능사용유무','0',null,'확장기능사용유무','확장기능사용유무','확장기능사용유무','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','001','보안등급','1',null,'보안등급','보안등급','보안등급','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','002','보존기간','0',null,'보존기간','보존기간','보존기간','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','003','키워드','0',null,'키워드','키워드','키워드','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','004','0','1','공개여부. 0:사용안함, 1: 사용','0','0','0','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','005','결재선포함','1','보안등급쿼리시 결재선에 있는 사람은 보안등급 무시 여부(1 : 무시. 2 : 보안등급이 우선함)','결재선포함','결재선포함','결재선포함','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A23','000','대리결재유무','0','대리결재유무','대리결재유무','대리결재유무','대리결재유무','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A23','001','대리결재','1','0:사용X, 1:사용O','대리결재','대리결재','대리결재','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A24','0  ','문서보기 기한 설정',null,null,'문서보기 기한 설정','문서보기 기한 설정','문서보기 기한 설정','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','0  ','문서종류','0','문서종류','문서종류',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','001','시행문','1','기안문','Enforcement','施行文','执行文件','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','002','내부결재','1','보고문','Inner Approval','報告文','报告书','Top',0);

--approvalS 필요한것만 간추려야함
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','0','문서종류','0','문서종류(DocType)','문서종류',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','001','기안문','1','기안문','Approval','起案文','起案文','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','002','보고문','1','보고문','Report','報告文','报告书','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','003','수신문','1','수신문','Received','受信文','收件文','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','004','시행문','1','시행문','Enforcement','施行文','执行文件','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','005','부서합의','0','기안문','agreement','起案文','起案文','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','006','감사문서','0','감사','Inspect','監査','审查','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','007','신청문서','0','신청','application','申請','申请','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','008','대외문서접수','0','대외접수','eng_대외접수','対外受付','对外接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','009','대외문서발송','0','대외발송','eng_대외발송','対外送信','对外发送','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','0  ','결재방법','0','결재방법','결재방법',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','001','결재','1','일반','Approval','決裁','审批','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','002','확인','1','확인','Confirmation','確認','確認','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','003','결재안함','0','결재안함','Skip-approval','決裁しない','不审批','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','004','전결','1','전결','Pre-approval','専決','先决','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','005','준법감시','0','감사','Audit','遵法監視','监督','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','006','발송의뢰','0','심사','Request Sending','審査','审查','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','007','참조','1','참조','Reference','参照','抄送','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','008','개인순차합의','1','개인순차협조','Agreement(personal)','個人順次合意','个人顺序协议','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','009','개인병렬합의','1','개인병렬협조','Parallel agreement(personal)','個人並列合意','个人并行协议','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','011','부서순차합의','1','부서순차협조','Sequential agreement(dept.)','部署順次合意','顺序协议(部门)','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','012','부서병렬합의','1','부서병렬협조','Parallel agreement(dept.)','部署並列合意','并行的协议(部门)','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','013','사전감사','0','감사','Pre-audit','監査','审查','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','014','수신','0','제일제당수신','Receipt','受信','收件','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','015','회람','0','회람','Circular reference','回覧','传阅','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','016','대결','0','대결','Deputy','代決','待决','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','018','기안','0','기안','Draft','起案','起草','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','019','검토','0','검토','Examination','検討','评论','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','040','후결','0','후결','후결','후결','후결','Top',0);

INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '0  ', '사인종류', '사인종류', '사인종류', '사인종류', '1', '사인종류', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '001', 'PIC', 'PIC', 'PIC', 'PIC', '1', '일반결재', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '002', 'PIC', 'PIC', 'PIC', 'PIC', '1', '개인순차협조', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '003', 'PIC', 'PIC', 'PIC', 'PIC', '1', '개인병렬협조', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '004', 'NAME', 'NAME', 'NAME', 'NAME', '1', '부서순차협조', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '005', 'NAME', 'NAME', 'NAME', 'NAME', '1', '부서병렬협조', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '006', 'PIC', 'PIC', 'PIC', 'PIC', '1', '공람', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '007', NULL, NULL, NULL, NULL, '1', '전결', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '008', NULL, NULL, NULL, NULL, '0', '대결', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '009', 'DNAME', 'DNAME', 'DNAME', 'DNAME', '0', '후결', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA13', '0  ', '결재TYPE', '결재TYPE', '결재TYPE', '결재TYPE', '1', '결재형식', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA13', '001', '1', '1', '1', '1', '0', '사용자와부서분리', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA13', '002', '2', '2', '2', '2', '1', '사용자와부서가 통합', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA15', '0  ', 'UI폼형식처리', 'UI폼형식처리', 'UI폼형식처리', 'UI폼형식처리', '1', 'UI폼형식처리', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA15', '001', 'yyyy.mm.dd hh:mm', 'yyyy.mm.dd hh:mm', 'yyyy.mm.dd hh:mm', 'yyyy.mm.dd hh:mm', '1', '년-월-일', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA15', '002', '.', '.', '.', '.', '1', '사인일자 형식', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '0  ', '의견종류', '의견종류', '의견종류', '의견종류', '1', '의견종류', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '001', '일반의견', '일반의견', '일반의견', '일반의견', '1', '일반의견', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '002', '반송의견', '반송의견', '반송의견', '반송의견', '1', '반송의견', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '003', '보류의견', '보류의견', '보류의견', '보류의견', '1', '보류의견', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '004', '회송의견', '회송의견', '회송의견', '회송의견', '1', '회송의견', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA18', '0  ', '결재날짜순서', '결재날짜순서', '결재날짜순서', '결재날짜순서', '1', '리스트ORDERBY', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA18', '001', 'DESC', 'DESC', 'DESC', 'DESC', '1', '결재문서(ASC,DESC)', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA18', '002', 'DESC', 'DESC', 'DESC', 'DESC', '1', '문서함(ASC,DESC)', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA19', '0  ', '첨부공유유무', '첨부공유유무', '첨부공유유무', '첨부공유유무', '0', '첨부공유유무확인', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA19', '001', '0', '0', '0', '0', '1', '0 : 별도, 1: 공유', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA20', '0  ', '첨부/의견 display', '첨부/의견 display', '첨부/의견 display', '첨부/의견 display', '1', '첨부/의견 유무Dispaly', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA20', '001', 'Y', 'Y', 'Y', 'Y', '1', '유', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA20', '002', 'N', 'N', 'N', 'N', '1', '무', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '0  ', '확장기능사용유무', '확장기능사용유무', '확장기능사용유무', '확장기능사용유무', '0', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '001', '보안등급', '보안등급', '보안등급', '보안등급', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '002', '보존기간', '보존기간', '보존기간', '보존기간', '0', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '003', '키워드', '키워드', '키워드', '키워드', '0', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '004', '1', '1', '1', '1', '1', '공개여부. 0:사용안함, 1: 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '005', '결재선포함', '결재선포함', '결재선포함', '결재선포함', '1', '보안등급쿼리시 결재선에 있는 사람은 보안등급 무시 여부(1 : 무시. 2 : 보안등급이 우선함)', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA23', '0  ', '대리결재유무', '대리결재유무', '대리결재유무', '대리결재유무', '0', '대리결재유무', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA23', '001', '대리결재', '대리결재', '대리결재', '대리결재', '1', '0:사용X, 1:사용O', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA24', '0  ', '문서보기 기한 설정', '문서보기 기한 설정', '문서보기 기한 설정', '문서보기 기한 설정', ' ', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA24', '001', NULL, '0', '0', '0', '1', '문서보기를 위한 기한을 설정.', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA25', '0  ', '회송처리', '회송처리', '회송처리', '회송처리', '1', '0:원기안부서, 1:이전 수신부서, 2:원기안부서회송하고, 재기안모드로 변신~ ^^;', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA25', '001', '2', '2', '2', '2', '1', '구분', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA25', '002', 'Y', 'Y', 'Y', 'Y', '1', '반송시 자동으로 반송함에 등록을 하는지 여부. (회송이 아니라 반송임!) Y면 동작', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA25', '003', 'Y', 'Y', 'Y', 'Y', '1', '감사 회송시 감사함에 회송문서를 남기는지 여부. Y면 남긴다.', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA26', '0  ', '대리결재사인헤드', '대리결재사인헤드', '대리결재사인헤드', '대리결재사인헤드', '1', '대리결재사인헤드', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA26', '001', '代', '代', '代', '代', '1', '대리결재사인헤드', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA27', '0  ', '수신처구분', '수신처구분', '수신처구분', '수신처구분', '1', '0:부서,1:부서/사람', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA27', '001', '부서', '부서', '부서', '부서', '1', '부서', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA27', '002', '부서/사람', '부서/사람', '부서/사람', '부서/사람', '0', '부서/사람', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA28', '0  ', '조직도구분', '조직도구분', '조직도구분', '조직도구분', '0', '조직도 구분', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA28', '001', '1', '1', '1', '1', '1', '조직도 직위', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA28', '002', '2', '2', '2', '2', '0', '조직도 직책', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA28', '003', '3', '3', '3', '3', '0', '조직도 직위/직책', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA29', '0  ', '개인수신처', '개인수신처', '개인수신처', '개인수신처', '0', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA29', '001', '개인수신처구분', '개인수신처구분', '개인수신처구분', '개인수신처구분', '0', '1:수신처리기, 0:결재진행관리기', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA30', '0  ', '문서채번룰', '문서채번룰', '문서채번룰', '문서채번룰', '1', '문서채번시 적용되는 룰 정의', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA30', '001', '10S', '10S', '10S', '10S', '1', 'x1 - 채번범위 (0:전체, 1:부서별, 2:양시함별) x2 - 분류기호 사용여부(0:사용안함, 1:사용함) x3 - 초기화 시점 (N: 초기화안함, M: 월별, Y:년별)', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA30', '002', '0', '0', '0', '0', '1', '문서번호 FORMAT', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA30', '003', '1', '1', '1', '1', '1', 'S일때 리프레쉬달', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA31', '0  ', '결재처리제한', '결재처리제한', '결재처리제한', '결재처리제한', '0', '결재처리 되지 않는 문서리스트 제한', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA31', '001', '3', '3', '3', '3', '0', 'N일 이상 지체되는 결재문서', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA32', '0  ', '전결처리방법', '전결처리방법', '전결처리방법', '전결처리방법', '0', '전결처리방법 정의', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA32', '001', '100', '100', '100', '100', '1', 'x1 - 전결자 (0:사인, 1:전결표시)x2 - 전결이후 결재자(0:표시안함, 1: 전결표시)x3 - 최종결재자(0:사인, 1:전결표시)', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA33', '0  ', '결재칸Split 유무', '결재칸Split 유무', '결재칸Split 유무', '결재칸Split 유무', '0', '결재한 Split  유무확인', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA33', '001', 'Y', 'Y', 'Y', 'Y', '1', '사용유무', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA33', '002', 'FIX', 'FIX', 'FIX', 'FIX', '1', 'FIX : 칸고정, DIV : 칸나눔으로 처리', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA34', '0  ', '문서링크', '문서링크', '문서링크', '문서링크', '0', '합의/감사 문서 Link', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA34', '001', '9', '9', '9', '9', '1', '0:사용안함,1:합의,2:감사,9:전체적용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA34', '002', '2004000004;2004000006;2004000005', '2004000004;2004000006;2004000005', '2004000004;2004000006;2004000005', '2004000004;2004000006;2004000005', '1', '감사시에변환안하는양식아이디(;로구분)', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA35', '0  ', '수신함보내기', '수신함보내기', '수신함보내기', '수신함보내기', '0', '수신함으로 바로 보내기', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA35', '001', '0', '0', '0', '0', '1', '0:사용안함,1:사용함', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA36', '0  ', '변환문서', '변환문서', '변환문서', '변환문서', '0', '변환문서URL', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA36', '001', '/upload_approval/Top/form/2016000068.mht', '/upload_approval/Top/form/2016000068.mht', '/upload_approval/Top/form/2016000068.mht', '/upload_approval/Top/form/2016000068.mht', '1', '합의문서', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA36', '002', '/upload_approval/Top/form/2003000008.mht', '/upload_approval/Top/form/2003000008.mht', '/upload_approval/Top/form/2003000008.mht', '/upload_approval/Top/form/2003000008.mht', '1', '감사문서', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA37', '0  ', '그룹사용', '그룹사용', '그룹사용', '그룹사용', '0', '참조그룹사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA37', '001', 'junsig', 'junsig', 'junsig', 'junsig', '1', '사인ID 값. null 값이면 사용안함', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA38', '0  ', '특정인 결재처리', '특정인 결재처리', '특정인 결재처리', '특정인 결재처리', '0', '특정인에 대한 결재 사인처리를 한다.', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA38', '001', '1', '1', '1', '1', '1', '참조사용유무 0:사용안함,1:사용함', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA39', '0  ', '첨부문서Filter', '첨부문서Filter', '첨부문서Filter', '첨부문서Filter', ' ', '첨부할 문서 종류를 제한한다.', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA39', '001', 'NONE', 'NONE', 'NONE', 'NONE', '1', 'NONE(대문자) : 사용안함 , ;로 구분한다.', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA39', '002', '50', '50', '50', '50', '1', '단위:메가', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA40', '0  ', '감사부서정의', '감사부서정의', '감사부서정의', '감사부서정의', '0', '감사부서 정의', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA40', '001', 'sb', 'sb', 'sb', 'sb', '1', '20630감사부서ID 리스트, 부서1;부서2;부서3;..부서', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA43', '0  ', '노티유무', '노티유무', '노티유무', '노티유무', '0', '노티유무', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA43', '001', 'Y', 'Y', 'Y', 'Y', '1', 'N:사용안함,Y:사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA44', '0  ', '최근결재선정보', '최근결재선정보', '최근결재선정보', '최근결재선정보', '1', '최근 결재선 정보 사용유무', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA44', '001', '1', '1', '1', '1', '1', '결재선 : 0:사용안함,1:사용함', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA44', '002', '1', '1', '1', '1', '1', '수신처 : 0:사용안함,1:사용함', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA45', '0  ', '문서바로발송', '문서바로발송', '문서바로발송', '문서바로발송', '0', '문서바로발송여부', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA45', '001', '기안문-품의시', '기안문-품의시', '기안문-품의시', '기안문-품의시', '1', '0 : 바로 발송. 1 - 바로발송아님. 시행문변환해야함.', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '0  ', '보안등급정의', '보안등급정의', '보안등급정의', '보안등급정의', '0', '보안등급정의', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '001', '1;1등급;100', '1;Level 1;100', '1;1等級;100', '1;1等級;100', '1', '임시;이름;코드', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '002', '1;2등급;200', '1;Level 2;200', '1;2等級;200', '1;2等級;200', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '003', '1;3등급;300', '1;Level 3;300', '1;3等級;300', '1;3等級;300', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '004', '1;4등급;400', '1;Level 4;400', '1;4等級;400', '1;4等級;400', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '005', '1;5등급;500', '1;Level 5;500', '1;5等級;500', '1;5等級;500', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '0  ', '보존년한정의', NULL, NULL, NULL, '0', '보존연한정의', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '001', '1;1년;1', '1;1 year;1', '1;1年;1', '1;1年;1', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '002', '1;2년;2', '1;2 year;2', '1;2年;2', '1;2年;2', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '003', '1;3년;3', '1;3 year;3', '1;3年;3', '1;3年;3', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '004', '1;5년;5', '1;5 year;5', '1;5年;5', '1;5年;5', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '005', '1;10년;10', '1;10 year;10', '1;10年;10', '1;10年;10', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '006', '1;준영구;100', '1;Semi-permanence;100', '1;準永久;100', '1;准永久;100', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '007', '1;영구;1000', '1;Permanence;1000', '1;永久;1000', '1;永久;1000', '1', NULL, 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA53', '0  ', '수신처그룹기호', '수신처그룹기호', '수신처그룹기호', '수신처그룹기호', '0', '수신처그룹구분기호 정의', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA53', '001', 'SG_', 'SG_', 'SG_', 'SG_', '1', '수신처 그룹 앞부분에 사용할 필드명. COM에서 사용. 스크립트 부분 동기화 필요', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA53', '002', 'Y', 'Y', 'Y', 'Y', '1', '수신처 그룹 확장(수신처 저장시 확장여부). Y는 사용. N은 사용안함', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '0  ', '특별문서함구분', '특별문서함구분', '특별문서함구분', '특별문서함구분', '0', '특별문서함구분코드입니다.', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '001', '결재할문서', 'To be process', '決裁する文書', '批准文件', '1', '결재할문서', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '002', '기안한문서', 'Proposed', '決裁済み', '草案文件', '1', '기안한문서', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '003', '결재진행문서', 'In progress', '決裁進捗文書', '批准执行文件', '1', '결재진행문서', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '004', '부서수신함', 'Dept. receipt folder', '部署受信フォルダ', '部门收信箱', '1', '부서수신함', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '005', '심사할문서', 'To be inspect', '審査する文書', '审查文件', '1', '심사할문서', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SF01', '0  ', '플로우', '플로우', '플로우', '플로우', '0', '플로우관련 업무 정의', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SF01', '001', 'Y', 'Y', 'Y', 'Y', '1', '수발신문을 발신함으로 보낸다.', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SF01', '002', 'O', 'O', 'O', 'O', '1', '"D:DSN연결;O:OleDB 연결', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL01', '0  ', '다국어처리', '다국어처리', '다국어처리', '다국어처리', '0', '다국어코드값', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL01', '001', '파일', 'File', 'ファイル', '文件夹', '1', 'file', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL01', '002', '문서', 'Document', '文書', '文件', '1', 'document', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL02', '001', '문서함명', 'Doc. folder name', '文書フォルダ名', '文件夹名', '1', '문서함-GetUseContInfo()', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL03', '001', '개인문서함', 'Personal doc. folder', '個人文書フォルダ', '个人文件夹', '1', '개인문서함-GetUserContTree()', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL03', '002', '문서함명', 'Dept. doc. folder', '文書フォルダ名', '文件夹名', '1', '부서문서함-GetDeptContTree()', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL04', '001', '부서명', 'Dept. name', '部署名', '部门名', '1', '부서명-GetContUseDeptInfo()', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '001', '코드', 'Code', 'コード', '代码', '1', 'GetItemCode_Item()', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '002', '기능명칭', 'Name', '機能名称', '功能名称', '1', 'GetItemCode_Item()', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '003', '보존기간', 'Keeping period', '保存期間', '保留时间', '1', 'GetItemCode_Item()', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '004', '보안등급', 'Security level', '保安等級', '安全级别', '1', 'GetItemCode_Item()', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '005', '공개여부', 'Public', '公開可否', '是否共享', '1', 'GetItemCode_Item()', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '001', '결재문서', '결재문서', '決済文書', '결재문서', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '002', '문서도착', '문서도착', '文書到着', '문서도착', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '003', '문서완료', '문서완료', '決済完了文書', '문서완료', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '004', '문서반송', '문서반송', '文書搬送', '문서반송', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '005', '문서보류', '문서보류', '文書保留', '문서보류', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '006', '문서발송', '문서발송', '文書送信', '문서발송', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '007', '수신문서', '수신문서', '受信文書', '수신문서', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '008', '지정문서', '지정문서', '指定文書', '지정문서', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '009', '회송문서', '회송문서', '返送文書', '회송문서', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '010', '문서회수', '문서회수', '文書引き戻し', '문서회수', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '011', '결재노티', '결재노티', '決済完了通知', '결재노티', '1', '결재알림시 사용', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('ST01', '0  ', '재기안 의견유무', '재기안 의견유무', '재기안 의견유무', '재기안 의견유무', '1', '재기안시 반송의견 삭제 유/무( Y : 삭제 or N : 삭제안함 )', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('ST01', '001', 'N', 'N', 'N', 'N', '1', '재기안시 반송의견 삭제 유/무( Y : 삭제 or N : 삭제안함 )', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '0', 	'0',	'문서상태(DocState)',	'문서상태','Doc. status','文書区分','文書区分',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '001',	'1',	'품의',			'품의',	'Draft',	'稟議',	'评价',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '002',	'1',	'협조',			'협조',	'Agreement(personal)',	'協力',	'合作',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '003',	'0',	'감사',			'준법감시',	'Audit',	'遵法監視',	'监督',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '004',	'1',	'심사',			'심사',	'심사_EN',	'심사_JA',	'심사_ZH',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '011',	'1',	'수신',			'수신',	'Receipt',	'受信',	'收件',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '012',	'1',	'협조/합의',	'기안문',	'기안문_EN',	'기안문_JA',	'기안문_ZH',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '013',	'0',	'시행',			'시행',	'Enforcement',	'施行',	'执行',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '014',	'0',	'감사(검사부)',	'감사',	'Audit(dept.)',	'監査',	'审查',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '015',	'0',	'공람',			'공람',	'Display',	'回覧',	'传阅',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '016',	'0',	'회람',			'회람',	'Circular',	'回覧',	'传阅',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '017',	'0',	'참조',			'참조',	'Reference',	'参照',	'抄送',	'Top',	0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '018',	'0',	'사후감사',		'사후공람',	'Public viewing(After-approval)',	'事後供覧',	'事后共览',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '019',	'1',	'발송',		'발송',	'Sending',	'送信',	'发送',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '020',	'0',	'신청',		'시행',	'Application',	'施行',	'执行',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '022',	'0',	'대외문서접수','대외접수',	'Receipt(outside)',	'対外受付',	'对外接收', 'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '023',	'0',	'대외문서발송','대외발송',	'Sending(outside)',	'対外送信',	'对外发送',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '024',	'1',	'수신배부',		'배부',	'배부_EN',	'배부_JA',	'배부_ZH',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '031',	'0',	'반송',			'반송',	'Rejection',	'差し戻し',	'退回',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '032',	'0',	'회송',			'회송',	'Returning',	'返送',	'退回',	'Top', 0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','0  ','결재처리상태','0','결재처리상태','결재처리상태',null,null,'Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','000','미결','1','기안처리하지 않은 문서','Not approved','未決','未決','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','001','대기','1','대기','Waiting','待機','待机','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','002','진행','1','진행','In progress','進行','进行','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','003','승인','1','승인','Approved','決裁','审批','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','004','반송','1','반송','Rejected','差し戻し','退回','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','005','보류','1','보류','Hold','保留','保存','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','006','회수','1','회수','Withdrew','引き戻し','回收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','010','완료','1','완료','Completed','完了','完成','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','011','도착','1','도착','Arrived','到着','到达','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','012','미접수','1','지정','Designated','未受付','未接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','013','접수','1','접수','Received','受付','接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','014','배부','1','배부','Distributed','配付','发行','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','015','회송','1','회송','Returned','返送','退回','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','016','접수','1','수신진행','Received','受信進行','进行接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','017','수신완료','1','수신완료','Completed(receipt)','受信完了','接收完成','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','018','발신','1','수신부서미접수','Sending','未受付','未接收','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','019','전송실패','1','전송실패','Sending failure','送信エラー','传输失败','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','020','수신','1','전송성공','Receipt','受信','接待','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','021','도달','1','도달(G중계)','Arrived','到達','到达','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','022','재요청','1','재발신요청','ReRequest','ジェヨチョン','再生','Top',0);

--G
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',1,'제목',400,null,'DocTitle',null,null,'서버저장문서','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',2,'기안부서',120,null,'WriterDeptName',null,null,'기안부서','기안부서','Dept.(draft)','送信依頼部門','傳出部門委託','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',3,'기안자',100,null,'WriterName',null,null,'기안자','기안자','Drafter','送信依頼者','傳出贊助商','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',4,'저장일시',100,null,'StartDate',null,null,'저장일시','저장일시','Save Date','保存日時','保存日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',5,'양식명',100,null,'FormName',null,null,'양식명','양식명','Form title','文書名','文書名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',6,'첨부',30,null,'HASATTACHYN',null,null,'서버저장문서','첨부','Attach','添付','附件','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',7,'공개',30,null,'ISPUBLIC',null,null,'서버저장문서','공개','Public','公開','公开','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',1,'순번',35,'TBL_APRLINEINFO','AprMemberSN',null,null,'결재선정보(진행)','순번','No.','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',2,'성명',120,'TBL_APRLINEINFO','AprMemberName',null,null,'결재선정보(진행)','성명','Name','氏名','姓名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',3,'직위',100,'TBL_APRLINEINFO','AprMemberJobTitle',null,null,'결재선정보(진행)','직위','Title','役職','职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',4,'부서',130,'TBL_APRLINEINFO','AprMemberDeptName',null,null,'결재선정보(진행)','부서명','Dept.','部署','部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',5,'결재유형',100,'TBL_APRLINEINFO','AprType',null,null,'결재선정보(진행)','결재방법','Type','処理類型','批准类型','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',6,'결재상태',80,'TBL_APRLINEINFO','AprState',null,null,'결재선정보(진행)','결재상태','Status','ステータス','批准状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',7,'결재일시',130,'TBL_APRLINEINFO','ProcessDate',null,null,'결재선정보(진행)','결재일시','Date','処理日時','批准日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',1,'순번',35,'TBL_ENDAPRLINEINFO','AprMemberSN',null,null,'결재선정보(완료)','순번','No.','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',2,'성명',100,'TBL_ENDAPRLINEINFO','AprMemberName',null,null,'결재선정보(완료)','성명','Name','氏名','姓名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',3,'직위',100,'TBL_ENDAPRLINEINFO','AprMemberJobTitle',null,null,'결재선정보(완료)','직위','Title','役職','职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',4,'부서',120,'TBL_ENDAPRLINEINFO','AprMemberDeptName',null,null,'결재선정보(완료)','부서명','Dept.','部署','部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',5,'결재유형',120,'TBL_ENDAPRLINEINFO','AprType',null,null,'결재선정보(완료)','결재방법','Type','処理類型','批准类型','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',6,'결재상태',70,'TBL_ENDAPRLINEINFO','AprState',null,null,'결재선정보(완료)','결재상태','Status','ステータス','批准状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',7,'결재일시',150,'TBL_ENDAPRLINEINFO','ProcessDate',null,null,'결재선정보(완료)','결재일시','Date','処理日時','批准日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',8,'대리자',110,'TBL_EXPENDAPRLINE','proxyusername',null,null,'결재선정보(완료)','대리결재자이름','Deputy','代理者','代理者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',9,'대리자직위',100,'TBL_EXPENDAPRLINE','proxyuserjobtitle',null,null,'결재선정보(완료)','대리결재자직위','Title(deputy)','代理者の役職','代理者职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',10,'대리자부서',120,'TBL_EXPENDAPRLINE','proxyuserdeptname',null,null,'결재선정보(완료)','대리결재자부서','Dept.(deputy)','代理者の部署','代理者部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',1,'순번',35,'TBL_APRLINEINFO','AprMemberSN',null,null,'결재선정보(코딩)','순번','No.','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',2,'성명',120,'TBL_APRLINEINFO','AprMemberName',null,null,'결재선정보(코딩)','성명','Name','氏名','姓名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',3,'직위',100,'TBL_APRLINEINFO','AprMemberJobTitle',null,null,'결재선정보(코딩)','직위','Title','役職','职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',4,'부서',130,'TBL_APRLINEINFO','AprMemberDeptName',null,null,'결재선정보(코딩)','부서명','Dept.','部署','部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',5,'결재유형',100,'TBL_APRLINEINFO','AprType',null,null,'결재선정보(코딩)','결재방법','Type','処理類型','批准类型','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',6,'결재상태',80,'TBL_APRLINEINFO','AprState',null,null,'결재선정보(코딩)','결재상태','Status','ステータス','批准状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',7,'결재일시',130,'TBL_APRLINEINFO','ProcessDate',null,null,'결재선정보(코딩)','결재일시','Date','処理日時','批准日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',1,'순번',35,'TBL_RECEIPTPOINTINFO','DeptMemberSN',null,null,'수신처정보(진행)','순번','No.','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',2,'수신자명',200,'TBL_RECEIPTPOINTINFO','ReceiptPointName',null,null,'수신처정보(진행)','수신부서명','Dept.','受信部署名','收信部门名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',3,'수신자성명',200,'TBL_RECEIPTPOINTINFO','ReceiptMemberName',null,null,'수신처정보(진행)','수신자성명','Name','受信者氏名','收信创建名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',4,'승인상태',100,'TBL_RECEIPTPOINTINFO','ProcessYN',null,null,'수신처정보(진행)','처리여부','Status','承認状態','承认状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',5,'승인일자',180,'TBL_RECEIPTPOINTINFO','ProcessDate',null,null,'수신처정보(진행)','처리일자','Date','処理日時','承认日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',1,'순번',35,'TBL_ENDRECEIPTPOINTINFO','DeptMemberSN',null,null,'수신처정보(완료)','순번','No.','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',2,'수신자명',200,'TBL_ENDRECEIPTPOINTINFO','ReceiptPointName',null,null,'수신처정보(완료)','수신부서명','Dept.','受信部署名','收信部门名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',3,'수신자성명',200,'TBL_ENDRECEIPTPOINTINFO','ReceiptMemberName',null,null,'수신처정보(완료)','수신자성명','Name','受信者氏名','收信创建名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',4,'승인상태',100,'TBL_ENDRECEIPTPOINTINFO','ProcessYN',null,null,'수신처정보(완료)','처리여부','Status','承認状態','承认状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',5,'승인일자',180,'TBL_ENDRECEIPTPOINTINFO','ProcessDate',null,null,'수신처정보(완료)','처리일자','Date','処理日時','承认日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('023',1,'순번',35,'TBL_RECEIPTPOINTINFO','DeptMemberSN',null,null,'수신처정보(코딩)','순번','No.','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('023',2,'수신자명',200,'TBL_RECEIPTPOINTINFO','ReceiptPointName',null,null,'수신처정보(코딩)','수신부서명','Dept','受信部署名','收信部门名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('024',1,'순번',35,'TBL_RECEIPTPOINTINFO','DeptMemberSN',null,null,'수신처정보(재발송)','순번','SN','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('024',2,'수신자명',200,'TBL_RECEIPTPOINTINFO','ReceiptPointName',null,null,'수신처정보(재발송)','수신부서명','Dept.','受信部署名','收信部门名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('024',3,'발송상태',100,'TBL_RECEIPTPOINTINFO','ProcessYN',null,null,'수신처정보(재발송)','발송상태','ProcessYN','送信進行状況','発送進行状況','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',1,'구분',55,'TBL_APROPINIONINFO','OpinionGB',null,null,'의견정보(진행)','의견구분','Type','区分','区分','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',2,'성명',100,'TBL_APROPINIONINFO','UserName',null,null,'의견정보(진행)','작성자','Name','氏名','姓名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',3,'내용',300,'TBL_APROPINIONINFO','Content',null,null,'의견정보(진행)','의견내용','Content','内容','内容','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',4,'직위',100,'TBL_APROPINIONINFO','UserJobTitle',null,null,'의견정보(진행)','작성자직위','Title','役職','职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',5,'부서',100,'TBL_APROPINIONINFO','UserDeptName',null,null,'의견정보(진행)','작성자부서명`','Dept.','部署','部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',1,'구분',55,'TBL_ENDAPROPINIONINFO','OpinionGB',null,null,'의견정보(완료)','의견구분','Type','区分','区分','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',2,'성명',100,'TBL_ENDAPROPINIONINFO','UserName',null,null,'의견정보(완료)','작성자','Name','氏名','姓名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',3,'내용',300,'TBL_ENDAPROPINIONINFO','Content',null,null,'의견정보(완료)','의견내용','Content','内容','内容','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',4,'직위',100,'TBL_ENDAPROPINIONINFO','UserJobTitle',null,null,'의견정보(완료)','작성자직위','Title','役職','职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',5,'부서',100,'TBL_ENDAPROPINIONINFO','UserDeptName',null,null,'의견정보(완료)','작성자부서명`','Dept.','部署','部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('033',1,'구분',55,'TBL_APROPINIONINFO','OpinionGB',null,null,'의견정보(진행UI)','의견구분','Type','区分','区分','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('033',2,'성명',100,'TBL_APROPINIONINFO','UserName',null,null,'의견정보(진행UI)','작성자','Name','氏名','姓名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('033',3,'직위',100,'TBL_APROPINIONINFO','UserJobTitle',null,null,'의견정보(진행UI)','작성자직위','Title','役職','职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('033',4,'부서',100,'TBL_APROPINIONINFO','UserDeptName',null,null,'의견정보(진행UI)','작성자부서명`','Dept.','部署','部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('034',1,'구분',55,'TBL_ENDAPROPINIONINFO','OpinionGB',null,null,'의견정보(완료UI)','의견구분','Type','区分','区分','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('034',2,'성명',100,'TBL_ENDAPROPINIONINFO','UserName',null,null,'의견정보(완료UI)','작성자','Name','氏名','姓名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('034',3,'직위',100,'TBL_ENDAPROPINIONINFO','UserJobTitle',null,null,'의견정보(완료UI)','작성자직위','Title','役職','职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('034',4,'부서',100,'TBL_ENDAPROPINIONINFO','UserDeptName',null,null,'의견정보(완료UI)','작성자부서명`','Dept.','部署','部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('041',1,'첨부자',80,'TBL_APRATTACHINFO','AttachUserName',null,null,'첨부파일정보(진행UI)','첨부자명','User','添付者','附件者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('041',2,'파일이름',250,'TBL_APRATTACHINFO','DisplayName',null,null,'첨부파일정보(진행UI)','디스플래이명','Filename','ファイル名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('041',3,'파일크기',100,'TBL_APRATTACHINFO','AttachFileSize',null,null,'첨부파일정보(진행UI)','파일크기','Size','ファイルサイズ','文件大小','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('041',4,'쪽수',40,'TBL_APRATTACHINFO','PageNum',null,null,'첨부파일정보(진행UI)','쪽수','PageNum','ページ数','頁數','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('042',1,'문서명',300,'TBL_APRDOCATTACHINFO','AttachDocName',null,null,'첨부문서정보(진행UI)','문서명','Form title','文書名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('043',1,'구분',35,null,'AttachType',null,null,'첨부정보','구분','Type','区分','区分','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('043',2,'첨부이름',200,null,'AttachName',null,null,'첨부정보','첨부이름','Filename','添付名','附件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('043',3,'첨부자',100,null,'AttachUserName',null,null,'첨부정보','첨부자명','User','添付者','附件者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('043',4,'첨부자부서명',100,null,'AttachUserDeptName',null,null,'첨부정보','첨부자부서명','Dept.','添付者部署名','附件者部门名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',1,'문서번호',150,'TBL_ENDAPRDOCINFO','DocNo',null,null,'개인문서함리스트','문서번호','Doc. No.','文書番号','文件号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',2,'제목',350,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'개인문서함리스트','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',3,'기안자',100,'TBL_ENDAPRDOCINFO','WriterName',null,null,'개인문서함리스트','기안자이름','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',4,'완료일시',100,'TBL_ENDAPRDOCINFO','EndDate',null,null,'개인문서함리스트','완료일시','Date completed','完了日時','结束日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',5,'문서명',160,'TBL_ENDAPRDOCINFO','FormName',null,null,'개인문서함리스트','양식이름','Form title','文書名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',6,'등록일자',100,'TBL_USERCONTLIST','LinkDate',null,null,'개인문서함리스트','등록일자','Date registered','登録日時','注册日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',1,'문서번호',150,'TBL_ENDAPRDOCINFO','DocNo',null,null,'부서문서함리스트','문서번호','Doc. No.','文書番号','文件号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',2,'제목',350,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'부서문서함리스트','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',3,'기안자',100,'TBL_ENDAPRDOCINFO','WriterName',null,'null','부서문서함리스트','기안자이름','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',4,'완료일시',100,'TBL_ENDAPRDOCINFO','EndDate',null,null,'부서문서함리스트','완료일시','Date completed','完了日時','结束日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',5,'문서명',160,'TBL_ENDAPRDOCINFO','FormName',null,null,'부서문서함리스트','양식이름','Form title','文書名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',6,'등록일자',100,'TBL_DEPTCONTLIST','LinkDate',null,null,'부서문서함리스트','등록일자','Date registered','登録日時','注册日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',1,'변경내용',60,'TBL_HISTORYATTACHINFO','ModifyFlag',null,null,'첨부파일이력리스트','변경내용','Content','変更内容','变更内容','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',2,'첨부이름',200,'TBL_HISTORYATTACHINFO','AttachFileDisplayName',null,null,'첨부파일이력리스트','첨부이름','Filename','添付名','附件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',3,'첨부사이즈',80,'TBL_HISTORYATTACHINFO','AttachFileSize',null,null,'첨부파일이력리스트','첨부사이즈','Size','添付サイズ','附件大小','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',4,'변경일자',120,'TBL_HISTORYATTACHINFO','ModifyDate',null,null,'첨부파일이력리스트','변경일자','Date','変更日時','变更日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',5,'변경자',80,'TBL_HISTORYATTACHINFO','AttachUserName',null,null,'첨부파일이력리스트','변경자','User','変更者','変更者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',6,'페이지',40,'TBL_HISTORYATTACHINFO','PageNum',null,null,'첨부파일이력리스트','페이지','PageNum','ページ','頁','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',1,'변경순번',60,'TBL_HISTORYLINEINFO','ModifySN',null,null,'결재선이력리스트','변경순번','No.','変更順番','变更序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',2,'변경일자',100,'TBL_HISTORYLINEINFO','ModifyDate',null,null,'결재선이력리스트','변경일자','Date','変更日時','变更日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',3,'변경자',100,'TBL_HISTORYLINEINFO','ModifyUserName',null,null,'결재선이력리스트','변경자','User','変更者','変更者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',4,'변경자직위',100,'TBL_HISTORYLINEINFO','ModifyUserJobTitle',null,null,'결재선이력리스트','변경자직위','Title','変更者役職','变更者职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',5,'변경자부서',100,'TBL_HISTORYLINEINFO','ModifyUserDeptName',null,null,'결재선이력리스트','변경자부서','Dept.','変更者部署','变更者部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',1,'결재순번',60,'TBL_HISTORYLINEINFO','AprMemberSN',null,null,'결재선이력상세리스트','결재순번','No.','決裁順番','批准序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',2,'결재방법',60,'TBL_HISTORYLINEINFO','AprType',null,null,'결재선이력상세리스트','결재방법','Type','決裁方法','批准方法','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',3,'결재상태',60,'TBL_HISTORYLINEINFO','AprState',null,null,'결재선이력상세리스트','결재상태','Status','ステータス','批准状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',4,'결재자이름',100,'TBL_HISTORYLINEINFO','AprMemberName',null,null,'결재선이력상세리스트','결재자이름','Name','決裁者','批准者名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',5,'결재자직위',100,'TBL_HISTORYLINEINFO','AprMemberJobTitle',null,null,'결재선이력상세리스트','결재자직위','Title','決裁者役職','批准者职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',6,'결재자부서',100,'TBL_HISTORYLINEINFO','AprMemberDeptName',null,null,'결재선이력상세리스트','결재자부서명','Dept.','決裁者部署','批准者部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',7,'보고자',50,'TBL_HISTORYLINEINFO','isBriefUserYN',null,null,'결재선이력상세리스트','보고자','Reporter','報告者','报告者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',8,'발의자',50,'TBL_HISTORYLINEINFO','isProposerYN',null,null,'결재선이력상세리스트','발의자','Proposer','発意者','倡议者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',1,'변경순번',60,'TBL_HISTORYDOCINFO','ChangeSN',null,null,'문서이력리스트','변경순번','No.','変更順番','变更序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',2,'변경일자',100,'TBL_HISTORYDOCINFO','ChangeDate',null,null,'문서이력리스트','변경일자','Date','変更日時','变更日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',3,'변경자이름',100,'TBL_HISTORYDOCINFO','ChangeUserName',null,null,'문서이력리스트','변경자이름','Name','変更者','变更者名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',4,'변경자직위',100,'TBL_HISTORYDOCINFO','ChangeUserJobTitle',null,null,'문서이력리스트','변경자직위','Title','変更者役職','变更者职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',5,'변경자부서',100,'TBL_HISTORYDOCINFO','ChangeUserDeptName',null,null,'문서이력리스트','변경자부서','Dept.','変更者部署','变更者部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',1,'순번',50,null,'DeptMemberSN',null,null,'수신처리스트','순번','SN','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',2,'수신자',100,null,'ReceiptPointName',null,null,'수신처리스트','수신부서','Dept.','受信者氏名','收信创建名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',3,'승인유무',70,null,'ProcessYN',null,null,'수신처리스트','승인유무','ProcessYN','承認の有無','立即批准','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',4,'승인일자',100,null,'ProcessDate',null,null,'수신처리스트','승인일자','ProcessDate','処理日時','承认日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',5,'수신자',80,null,'ReceiptMemberName',null,null,'수신처리스트','수신자','Name','受信者氏名','收信创建名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('066',1,'수신자',100,'TBL_HISTORYRECEIPTINFO','ReceiptDeptName',null,null,'수신처이력리스트','수신처','Dept.','受信者氏名','收信创建名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('066',2,'상태',80,'TBL_HISTORYRECEIPTINFO','Status',null,null,'수신처이력리스트','상태','Status','ステータス','状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('066',3,'일자',100,'TBL_HISTORYRECEIPTINFO','StatusDate',null,null,'수신처이력리스트','일자','Date','日','日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',1,'배부번호',70,'TBL_DOCDELIVERY','sn',null,null,'배부대장리스트','배부번호','SN','配付番号','分配數量','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',2,'문서번호',120,'TBL_DOCDELIVERY','DocNumber',null,null,'배부대장리스트','문서번호','Doc. No.','登録番号','註冊號','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',3,'제목',200,'TBL_DOCDELIVERY','DocTitle',null,null,'배부대장리스트','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',4,'배부일자',130,'TBL_DOCDELIVERY','ReceiptDate',null,null,'배부대장리스트','배부일자','ReceiptDate','配付日時','分派日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',5,'배부과',80,'TBL_DOCDELIVERY','Organ',null,null,'배부대장리스트','배부과','Organ','配付課','分佈及','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',6,'처리과',80,'TBL_DOCDELIVERY','ManageDept',null,null,'배부대장리스트','처리과','Manage Dept.','処理課','加工','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',7,'인수자',80,'TBL_DOCDELIVERY','ChargeName',null,null,'배부대장리스트','인수자','Charge Name','引受者','引受者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',1,'제목',300,'TBL_APRDOCINFO','DocTitle',null,null,'관리자 진행문서','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',2,'기안부서',135,'TBL_APRDOCINFO','WriterDeptName',null,null,'관리자 진행문서','기안부서','Dept.(draft)','起案部署','起草部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',3,'기안자',60,'TBL_APRDOCINFO','WriterName',null,null,'관리자 진행문서','기안자','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',4,'기안일시',160,'TBL_APRDOCINFO','StartDate',null,null,'관리자 진행문서','기안일시','Date(draft)','起案日時','起草日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',5,'상태',50,'TBL_APRDOCINFO','FunctionType',null,null,'관리자 진행문서','상태','Status','ステータス','状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',6,'문서명',160,'TBL_EXPAPRDOCINFO','FormName',null,null,'관리자 진행문서','양식명','Form title','文書名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',1,'문서번호',150,'TBL_ENDAPRDOCINFO','DocNo',null,null,'관리자 완료문서','문서번호','Doc. No.','文書番号','文件号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',2,'제목',350,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'관리자 완료문서','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',3,'기안자',100,'TBL_ENDAPRDOCINFO','WriterName',null,null,'관리자 완료문서','기안자','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',4,'기안부서',100,'TBL_ENDAPRDOCINFO','WriterDeptName',null,null,'관리자 완료문서','기안부서명','Dept.(draft)','起案部署','起草部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',5,'완료일시',160,'TBL_ENDAPRDOCINFO','EndDate',null,null,'관리자 완료문서','완료일시','Date completed','完了日時','结束日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',6,'문서명',150,'TBL_ENDAPRDOCINFO','FormName',null,null,'관리자 완료문서','양식명','Form title','文書名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',7,'이관',30,'TBL_EXPENDAPRDOCINFO','EDMSYN',null,'NoUse','관리자 완료문서','EDMS이관여부','Transfer','移管','移交','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('091',1,'순번',55,'TBL_ADMINRECEIPTGROUP_MAIN','MAINID',null,'NoUse','수신처그룹정보','순번','No.','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('091',2,'수신자그룹',250,'TBL_ADMINRECEIPTGROUP_MAIN','MAINNAME',null,null,'수신처그룹정보','수신처그룹명','Receiving Dept. Group','受信先グループ','集团电话','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('092',1,'순번',55,'TBL_ADMINRECEIPTGROUP_SUB','SUBID',null,'NoUse','수신처그룹소속부서정보','순번','No.','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('092',2,'부서아이디',250,'TBL_ADMINRECEIPTGROUP_SUB','DEPTID',null,'NoUse','수신처그룹소속부서정보','부서아이디','Dept. ID','部署ID','部门 ID','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('092',3,'부서명',250,'TBL_ADMINRECEIPTGROUP_SUB','DEPTNAME',null,null,'수신처그룹소속부서정보','부서명','Dept. Name','部署名','部门名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('092',4,'회사아이디',250,'TBL_ADMINRECEIPTGROUP_SUB','companyID',null,'NoUse','수신처그룹소속부서정보','회사아이디','Company ID','会社ID','公司 ID','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',1,'코드',80,'TBL_TASKCODEHISTORY','TaskCode',null,null,'단위업무이력','단위업무코드','Code','コード','线','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',2,'명칭',100,'TBL_TASKCODEHISTORY','TaskName',null,null,'단위업무이력','단위업무명','Name','名称','指定','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',3,'적용일자',150,'TBL_TASKCODEHISTORY','ApplyDate',null,null,'단위업무이력','적용일자.변경일자','ApplyDate','適用日','生效日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',4,'변경항목',120,'TBL_TASKCODEHISTORY','ChangeFactor',null,null,'단위업무이력','변경항목','ChangeFactor','変更項目','更改主题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',5,'변경전값',150,'TBL_TASKCODEHISTORY','BeforeValue',null,null,'단위업무이력','변경전 데이터','BeforeValue','変更前の値','数据前的变化。','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',6,'변경후값',150,'TBL_TASKCODEHISTORY','AfterValue',null,null,'단위업무이력','변경후 데이터','AfterValue','変更後の値','更改后的数据','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',1,'단위업무명',0,'TASKNAME',null,null,null,'단위업무이력관리','단위업무명','단위업무명E','単位業務名','单位商业名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',2,'보존연한',0,'KEEPINGPERIOD','CODE',null,null,'단위업무이력관리','보존연한','보존연한E','保存年限','保存完好的软','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',3,'보존연한책정사유',0,'KPREASON',null,null,null,'단위업무이력관리','보존연한책정사유','보존연한책정사유E','보존연한책정사유J','보존연한책정사유C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',4,'보존방법',0,'KEEPINGMETHOD','CODE',null,null,'단위업무이력관리','보존방법','보존방법E','保存方法','如何保存','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',5,'보존장소',0,'KEEPINGPLACE','CODE',null,null,'단위업무이력관리','보존장소','보존장소E','保存場所','保护区','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',6,'비치기록물',0,'DISPLAYRECFLAG','CODE',null,null,'단위업무이력관리','비치기록물','비치기록물E','비치기록물J','비치기록물C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',7,'비치기록물이관시기',0,'DISPLAYRECTRASTIME',null,null,null,'단위업무이력관리','비치기록물이관시기','비치기록물이관시기E','비치기록물이관시기J','비치기록물이관시기C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',8,'이관후예상열람빈도',0,'EXDISPLAYFREQUENCY','CODE',null,null,'단위업무이력관리','이관후예상열람빈도','이관후예상열람빈도E','이관후예상열람빈도J','이관후예상열람빈도C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',9,'특수목록위치',0,'SPECIALCATALOGFLAG','CODE',null,null,'단위업무이력관리','특수목록위치','특수목록위치E','특수목록위치J','특수목록위치C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',10,'제1특수목록',0,'SC1',null,null,null,'단위업무이력관리','제1특수목록','제1특수목록E','제1특수목록J','제1특수목록C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',11,'제2특수목록',0,'SC2',null,null,null,'단위업무이력관리','제2특수목록','제2특수목록E','제2특수목록J','제2특수목록C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',12,'제3특수목록',0,'SC3',null,null,null,'단위업무이력관리','제3특수목록','제3특수목록E','제3특수목록J','제3특수목록C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',13,'주요열람용도',0,'DISPLAYUSAGE',null,null,null,'단위업무이력관리','주요열람용도','주요열람용도E','주요열람용도J','주요열람용도C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',14,'단위업무설명',0,'DESCRIPTION',null,null,null,'단위업무이력관리','단위업무설명','단위업무설명E','단위업무설명J','단위업무설명C','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',15,'소기능',0,'SUBCATEGORYCODE','CODE',null,null,'단위업무이력관리','소기능','소기능E','二次カテゴリコード','次要类别代码','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',1,'이름',140,'TBL_CABINETCLASS','TITLE',null,null,'Simple기록물철','이름','Name','綴じ名','名稱','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',2,'생산연도',50,'TBL_CABINETCLASS','PRODUCTIONYEAR',null,null,'Simple기록물철','생산연도','Productionyear','生産年度','生产年度','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',3,'단위업무명(분류코드)',140,'TBL_CABINETCLASS','TASKNAME',null,null,'Simple기록물철','단위업무명(분류코드)','Taskname','単位業務名','单位业务名称','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',4,'형태',100,'TBL_CABINETCLASS','RECTYPECODE',null,null,'Simple기록물철','형태','FORM','形態','表','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',5,'연번',50,'TBL_CABINETCLASS','REGSERIALNO',null,null,'Simple기록물철','연번','SN.','連番','序列号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',6,'권호수',40,'TBL_CABINET','VOLUMENO',null,null,'Simple기록물철','권호수','VOL.','巻号数','卷湖','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',1,'대기능',140,null,null,null,null,'기록물철리스트','대기능','MajorCategoryCode','主なカテゴリコード','主要类别代码','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',2,'중기능',140,null,null,null,null,'기록물철리스트','중기능','MiddleCategoryCode','中間のカテゴリコード','中间类别代码','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',3,'소기능',140,null,null,null,null,'기록물철리스트','소기능','MinorCategoryCode','二次カテゴリコード','次要类别代码','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',4,'단위업무명',140,null,null,null,null,'기록물철리스트','단위업무명','TaskName','単位業務名','单位商业名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',5,'이름',140,null,null,null,null,'기록물철리스트','이름','Name','綴じ名','名稱','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',6,'형태',100,null,null,null,null,'기록물철리스트','형태','Rectype','形態','表','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',7,'연번',50,null,null,null,null,'기록물철리스트','연번','NO.','連番','序列号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',8,'권호수',40,null,null,null,null,'기록물철리스트','권호수','VoluMemo','巻号数','卷湖','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('097',1,'단위업무',65,null,null,null,null,'단위업무리스트','단위업무','UNIT WORKING','単位業務','单位商业','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('097',2,'단위업무명',120,null,null,null,null,'단위업무리스트','단위업무명','UNIT WORKING NAME','単位業務名','单位商业名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('097',3,'보존연한',60,null,null,null,null,'단위업무리스트','보존연한','KEEPING PERIOD','保存年限','保存完好的软','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('097',4,'임시',40,null,null,null,null,'단위업무리스트','임시','TEMPORARY','臨時','临时','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',1,'처리과명',100,'VTASKCLASS','PROCESSDEPTNAME',null,null,'단위업무리스트(full)','처리과명','PROCDEPT NAME','処理部署名','加工名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',2,'단위업무명',150,'VTASKCLASS','TASKNAME',null,null,'단위업무리스트(full)','단위업무명','UNIT WORKING NAME','単位業務名','单位商业名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',3,'단위업무코드',80,'VTASKCLASS','TASKCODE',null,null,'단위업무리스트(full)','단위업무코드','UNITWORKING CODE','単位業務コード','工作单位代码','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',4,'임시',40,'VTASKCLASS','TEMPFLAG',null,null,'단위업무리스트(full)','임시','TEMP','臨時','临时','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',5,'대기능명',100,'VTASKCLASS','CNAME',null,null,'단위업무리스트(full)','대기능명','MAJOR','大機能','大機能','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',6,'중기능명',100,'VTASKCLASS','MCNAME',null,null,'단위업무리스트(full)','중기능명','MIDDLE','中機能','中機能','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',7,'소기능명',100,'VTASKCLASS','SCNAME',null,null,'단위업무리스트(full)','소기능명','MINOR','小機能','小機能','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',8,'보존기간',55,'VTASKCLASS','KEEPINGPERIOD',null,null,'단위업무리스트(full)','보존기간','KEEPING PERIOD','保存期間','年龄','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',9,'보존방법',180,'VTASKCLASS','KEEPINGMETHOD',null,null,'단위업무리스트(full)','보존방법','CONSERVATION METHOD','保存方法','如何保存','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',10,'보존장소',80,'VTASKCLASS','KEEPINGPLACE',null,null,'단위업무리스트(full)','보존장소','CONSERVATION PLACE','保存場所','保护区','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',11,'비치',40,'VTASKCLASS','DISPLAYRECFLAG',null,null,'단위업무리스트(full)','비치','STOCKED','備付','備付','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',12,'특수목록',55,'VTASKCLASS','SPECIALCATALOGFLAG',null,null,'단위업무리스트(full)','특수목록','SPECIAL LIST','特殊リスト','特别名单','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',1,'버전',40,null,null,null,null,'기록물철변경이력정보','버전','Ver','Ver.','版本','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',2,'제목',180,null,null,null,null,'기록물철변경이력정보','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',3,'기록물 형태',100,null,null,null,null,'기록물철변경이력정보','기록물 형태','DocForm','記録物の形態','纪录片的形式','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',4,'변경영역',100,null,null,null,null,'기록물철변경이력정보','변경영역','ModifyArea','変更領域','变化领域版本','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',5,'변경자',80,null,null,null,null,'기록물철변경이력정보','변경자','Modifier','変更者','変更者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',6,'변경일자',80,null,null,null,null,'기록물철변경이력정보','변경일자','ModifiedDate','変更日時','变更日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('100',1,'순번',40,null,null,null,null,'결재선템플릿','순번','No.','順番','序号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('100',2,'결재유형',70,null,null,null,null,'결재선템플릿','결재유형','ApprovalType','処理類型','批准类型','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('100',3,'결재자',70,null,null,null,null,'결재선템플릿','결재자','Approver','決裁者','批准者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('101',1,'코드',60,null,null,null,null,'단위업무 소기능(소분류)','코드','CODE','コード','线','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('101',2,'이름',120,null,null,null,null,'단위업무 소기능(소분류)','이름','Name','綴じ名','名稱','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('102',1,'부서코드',70,null,null,null,null,'단위업무 사용 부서','부서코드','DEPTCODE','部署コード','部门代码','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('102',2,'부서명',130,null,null,null,null,'단위업무 사용 부서','부서명','DEPTNAME','部署名','部门名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',1,'버전',30,null,null,null,null,'기록물 변경이력정보','버전','Ver.','Ver.','版本','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',2,'제목',170,null,null,null,null,'기록물 변경이력정보','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',3,'등록일자',100,null,null,null,null,'기록물 변경이력정보','등록일자','Regdate','登録日時','注册日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',4,'쪽수',35,null,null,null,null,'기록물 변경이력정보','쪽수','Page','ページ数','頁數','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',5,'결재권자',80,null,null,null,null,'기록물 변경이력정보','결재권자','Approval person','決裁権者','审批','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',6,'기안자',80,null,null,null,null,'기록물 변경이력정보','기안자','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',7,'시행일자',70,null,null,null,null,'기록물 변경이력정보','시행일자','Enforce date.','施行日','生效日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',8,'수신자(발신자)',90,null,null,null,null,'기록물 변경이력정보','수신자(발신자)','Recipient(Sender)','受信者（起案者）','受信者(送信者)','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',9,'변경영역',80,null,null,null,null,'기록물 변경이력정보','변경영역','Modifyarea','変更領域','变化领域版本','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',10,'변경자',60,null,null,null,null,'기록물 변경이력정보','변경자','Modifier','変更者','変更者','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',11,'변경일자',70,null,null,null,null,'기록물 변경이력정보','변경일자','Modified date','変更日時','变更日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('104',1,'열람시간',150,null,null,null,null,'기록물 열람이력정보','열람시간','ReadingTime','閲覧時間','时间','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('104',2,'열람자',100,null,null,null,null,'기록물 열람이력정보','열람자','Reader','閲覧者','观众','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('104',3,'부서명',120,null,null,null,null,'기록물 열람이력정보','부서명','DeptName','部署名','部门名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('104',4,'직위',120,null,null,null,null,'기록물 열람이력정보','직위','Position','役職','职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('105',1,'수 신 자',200,null,null,null,null,'수신처 템플릿 상세 리스트','수 신 자','Receiver','受信先','收 件 人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('106',1,'문서함리스트',250,null,null,null,null,'부서 문서함리스트','문서함리스트','DocFormList','文書フォルダリスト','一提到文件清单','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('107',1,'부서명',100,null,null,null,null,'사용자별 문서 결재 건수','부서명','APRMEMBERDEPTNAME','部署名','部门名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('107',2,'직위',80,null,null,null,null,'사용자별 문서 결재 건수','직위','APRMEMBERJOBTITLE','役職','职位','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('107',3,'기안자',80,null,null,null,null,'사용자별 문서 결재 건수','기안자','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('107',4,'결재건수',60,null,null,null,null,'사용자별 문서 결재 건수','결재건수','APRCOUNT','決裁件数','批准件数','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('108',1,'발신부서',150,null,null,null,null,'부서별 발송/수신건수','발신부서','SENTDEPTNAME','送信部署','发送部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('108',2,'수신부서',150,null,null,null,null,'부서별 발송/수신건수','수신부서','RECEVDEPTNAME','送信部署','发送部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('108',3,'건수',40,null,null,null,null,'부서별 발송/수신건수','건수','APRCOUNT','件数','件数','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('109',1,'양식리스트',215,'TBL_FORMINFO','FormName','FormName',null,'양식리스트','양식명','Form list','様式リスト','样式列表','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('110',1,'성명',100,null,null,null,null,'업무담당자지정','성명','Name','綴じ名','名稱','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('111',1,'문서상태',100,null,null,null,null,'문서함 문서상태 등록','문서상태','Doc. status','文書区分','文件状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('111',2,'문서함명',100,null,null,null,null,'문서함 문서상태 등록','문서함명','Dept. doc. folder','文書フォルダ名','Dept. doc. folder','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',1,'제목',380,'VAPRDOINGDOCLIST','DocTitle',null,null,'결재할 문서','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',2,'회사',120,'VAPRDOINGDOCLIST','companyName',null,null,'결재할 문서','회사','Company','会社','公司','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',3,'기안부서',120,'VAPRDOINGDOCLIST','WriterDeptName',null,null,'결재할 문서','기안부서','Dept.(draft)','起案部署','起草部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',4,'기안자',100,'VAPRDOINGDOCLIST','WriterName',null,null,'결재할 문서','기안자','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',5,'기안일시',100,'VAPRDOINGDOCLIST','StartDate',null,null,'결재할 문서','기안일시','Date(draft)','起案日時','起草日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',6,'상태',60,'VAPRDOINGDOCLIST','FunctionType',null,null,'결재할 문서','상태','Status','ステータス','状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',7,'양식명',100,'VAPRDOINGDOCLIST','FormName',null,null,'결재할 문서','양식명','Form title','文書名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',8,'첨부',30,'VAPRDOINGDOCLIST','HASATTACHYN',null,null,'결재할 문서','첨부','Attach','添付','附件','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',9,'공개',30,'VAPRDOINGDOCLIST','ISPUBLIC',null,null,'결재할 문서','공개','Public','公開','公开','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',1,'제목',380,'VAPRWILLDOCLIST','DocTitle',null,null,'기안한 문서','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',2,'회사',120,'VAPRWILLDOCLIST','companyName',null,null,'기안한 문서','회사','Company','会社','公司','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',3,'기안부서',120,'VAPRWILLDOCLIST','WriterDeptName',null,null,'기안한 문서','기안부서','Dept.(draft)','起案部署','起草部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',4,'기안자',100,'VAPRWILLDOCLIST','WriterName',null,null,'기안한 문서','기안자','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',5,'기안일시',100,'VAPRWILLDOCLIST','StartDate',null,null,'기안한 문서','기안일시','Date(draft)','起案日時','起草日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',6,'상태',60,'VAPRWILLDOCLIST','FunctionType',null,null,'기안한 문서','상태','Status','ステータス','状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',7,'양식명',100,'VAPRWILLDOCLIST','FormName',null,null,'기안한 문서','양식명','Form title','文書名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',8,'첨부',30,'VAPRWILLDOCLIST','HASATTACHYN',null,null,'기안한 문서','첨부','Attach','添付','附件','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',9,'공개',30,'VAPRWILLDOCLIST','ISPUBLIC',null,null,'기안한 문서','공개','Public','公開','公开','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',1,'제목',380,'VAPRWILLDOCLIST','DocTitle',null,null,'결재진행문서','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',2,'회사',120,'VAPRWILLDOCLIST','companyName',null,null,'결재진행문서','회사','Company','会社','公司','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',3,'기안부서',120,'VAPRWILLDOCLIST','WriterDeptName',null,null,'결재진행문서','기안부서','Dept.(draft)','起案部署','起草部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',4,'기안자',100,'VAPRWILLDOCLIST','WriterName',null,null,'결재진행문서','기안자','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',5,'기안일시',100,'VAPRWILLDOCLIST','StartDate',null,null,'결재진행문서','기안일시','Dept.(draft)','起案日時','起草日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',6,'상태',60,'VAPRWILLDOCLIST','FunctionType',null,null,'결재진행문서','상태','Status','ステータス','状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',7,'양식명',100,'VAPRWILLDOCLIST','FormName',null,null,'결재진행문서','양식명','Form title','文書名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',8,'첨부',30,'VAPRWILLDOCLIST','HASATTACHYN',null,null,'결재진행문서','첨부','Attach','添付','附件','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',10,'공개',30,'VAPRWILLDOCLIST','ISPUBLIC',null,null,'결재진행문서','공개','Public','公開','公开','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',1,'제목',320,'TBL_APRDOCINFO','DocTitle',null,null,'수신문서처리기','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',2,'문서상태',70,'TBL_APRRECEIPTPROCESSINFO','DocState',null,null,'수신문서처리기','문서상태','Doc. status','文書区分','文件状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',3,'결재상태',70,'TBL_APRRECEIPTPROCESSINFO','AprState',null,null,'수신문서처리기','결재상태','Approval status','ステータス','批准状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',4,'기안자',70,'TBL_APRDOCINFO','WriterName',null,null,'기안한 문서','기안자','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',5,'발신부서',100,'TBL_APRRECEIPTPROCESSINFO','SentDeptName',null,null,'수신문서처리기','발신부서','Dept. sent','送信部署','发送部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',6,'수신부서',100,'TBL_APRRECEIPTPROCESSINFO','ReceivedDeptName',null,null,'수신문서처리기','도착부서','Date recevied','受信部署','收信部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',7,'수신일자',100,'TBL_APRRECEIPTPROCESSINFO','ProcessDate',null,null,'수신문서처리기','도착일자','ProcessDate','到着日付','接收日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',8,'양식명',100,'TBL_APRDOCINFO','FormName',null,null,'수신문서처리기','양식명','Form Name','様式名','样式名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',9,'첨부',30,'TBL_APRDOCINFO','HASATTACHYN',null,null,'수신문서처리기','첨부','Attach','添付','附件','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',10,'공개',30,'TBL_APRDOCINFO','ISPUBLIC',null,null,'수신문서처리기','공개','Public','公開','公开','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',1,'제목',300,'TBL_APRDOCINFO','DocTitle',null,null,'심사진행기','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',2,'문서상태',80,'TBL_APRRECEIPTPROCESSINFO','DocState',null,null,'심사진행기','문서상태','Doc. status','文書区分','文件状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',3,'결재상태',80,'TBL_APRRECEIPTPROCESSINFO','AprState',null,null,'심사진행기','결재상태','Approval status','ステータス','批准状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',4,'발신부서',100,'TBL_APRRECEIPTPROCESSINFO','SentDeptName',null,null,'심사진행기','발신부서','Dept. sent','送信部署','发送部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',5,'도착일자',150,'TBL_APRRECEIPTPROCESSINFO','ProcessDate',null,null,'심사진행기','도착일자','Date recevied','到着日付','接收日','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',6,'첨부',30,'TBL_APRRECEIPTPROCESSINFO','HASATTACHYN',null,null,'심사진행기','첨부','Attach','添付','附件','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',7,'공개',30,'TBL_APRRECEIPTPROCESSINFO','ISPUBLIC',null,null,'심사진행기','공개','Public','公開','公开','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',1,'문서번호',150,'TBL_ENDAPRDOCINFO','DocNo',null,null,'문서함문서','문서번호','Doc. No.','文書番号','文件号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',2,'제목',350,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'문서함문서','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',3,'기안자',100,'TBL_ENDAPRDOCINFO','WriterName',null,null,'문서함문서','기안자','Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',4,'회사',100,'TBL_ENDAPRDOCINFO','companyName',null,null,'결재할 문서','회사','Company','会社','公司','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',5,'기안부서',100,'TBL_ENDAPRDOCINFO','WriterDeptName',null,null,'문서함문서','기안부서명','Dept.(draft)','起案部署','起草部门','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',6,'완료일시',160,'TBL_ENDAPRDOCINFO','EndDate',null,null,'문서함문서','완료일시','Date completed','完了日時','结束日期','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',7,'문서명',150,'TBL_ENDAPRDOCINFO','FormName',null,null,'문서함문서','양식명','Form title','文書名','文件名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',8,'이관',30,'TBL_EXPENDAPRDOCINFO','EDMSYN',null,'NoUse','문서함문서','EDMS이관여부','Transfer','移管','移交','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',9,'첨부',30,'TBL_EXPENDAPRDOCINFO','HASATTACHYN',null,null,'문서함문서','첨부','Attach','添付','附件','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',10,'공개',30,'TBL_EXPENDAPRDOCINFO','ISPUBLIC',null,null,'문서함문서','공개','Public','公開','公开','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',1,'제목',300,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'발송대기문서','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',2,'발신의뢰부서',150,'TBL_ENDAPRDOCINFO','WriterDeptName',null,null,'발송대기문서','기안부서','Dept.(draft)','送信依頼部門','傳出部門委託','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',3,'발신의뢰자',150,'TBL_ENDAPRDOCINFO','WriterName',null,null,'발송대기문서','기안자','Drafter','送信依頼者','傳出贊助商','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',4,'발신의뢰일자',150,'TBL_ENDAPRDOCINFO','EndDate',null,null,'발송대기문서','완료일자','Date(draft)','送信依頼日','日期的傳出請求','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',5,'상태',100,'TBL_ENDRECEIPTPOINTINFO','ProcessYN',null,null,'발송대기문서','발송대기상태','Status','ステータス','状态','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',6,'양식명',150,'TBL_ENDAPRDOCINFO','FormName',null,null,'발송대기문서','양식명','Form title','様式名','样式名','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('083',1,'문서번호',150,null,'DocNo',null,null,'원문공개문서함','문서번호','Doc. No.','文書番号','文件号','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('083',2,'제목',400,null,'DocTitle',null,null,'원문공개문서함','제목','Title','見出し','标题','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('083',3,'공개여부',50,null,'OpenFlag',null,null,'원문공개문서함','공개여부','공개여부','공개여부','공개여부','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('083',4,'목록공개',50,null,'ListOpenFlag',null,null,'원문공개문서함','목록공개','목록공개','목록공개','목록공개','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('083',5,'열람제한일자',100,null,'OpenLimitDate',null,null,'원문공개문서함','열람제한일자','열람제한일자','열람제한일자','열람제한일자','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('083',6,'수정일자',140,null,'UpdateDate',null,null,'원문공개문서함','수정일자','수정일자','수정일자','수정일자','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('083',7,'생성일자',140,null,'CreateDate',null,null,'원문공개문서함','생성일자','생성일자','생성일자','생성일자','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('083',8,'작성자',100,null,'WriterName',null,null,'원문공개문서함','작성자','작성자','작성자','작성자','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('083',9,'기안부서',140,null,'WriterDeptName',null,null,'원문공개문서함','기안부서','기안부서','기안부서','기안부서','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('084',1,'변경자 부서',180,null,'ModifierDeptName',null,null,'원문공개문서함 수정이력','변경자 부서','변경자 부서','변경자 부서','변경자 부서','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('084',2,'변경자',180,null,'ModifierName',null,null,'원문공개문서함 수정이력','변경자','변경자','변경자','변경자','Top',0);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('084',3,'변경일',100,null,'ModifyDate',null,null,'원문공개문서함 수정이력','변경일','변경일','변경일','변경일','Top',0);

--S
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 1, '제목', 'Title', 'タイトル', '标题', 300, 'VAPRDOINGDOCLIST', 'DocTitle', NULL, NULL, '결재할 문서', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 2, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 135, 'VAPRDOINGDOCLIST', 'WriterDeptName', NULL, NULL, '결재할 문서', '기안부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 3, '기안자', 'Drafter', '起案者', '起草人', 70, 'VAPRDOINGDOCLIST', 'WriterName', NULL, NULL, '결재할 문서', '기안자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 4, '수신일자', 'ProcessDate', '到着日時', '接收日', 160, 'VAPRDOINGDOCLIST', 'StartDate', NULL, NULL, '결재할 문서', '기안일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 5, '상태', 'Status', 'ステータス', '状态', 50, 'VAPRDOINGDOCLIST', 'FunctionType', NULL, NULL, '결재할 문서', '상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 6, '문서명', 'Form title', '文書名', '文件名', 100, 'VAPRDOINGDOCLIST', 'FormName', NULL, NULL, '결재할 문서', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 7, '첨부', 'Attach', '添付', '附件', 50, 'VAPRDOINGDOCLIST', 'HASATTACHYN', NULL, NULL, '결재할 문서', '첨부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 8, '공개', 'Public', '公開', '公开', 50, 'VAPRDOINGDOCLIST', 'ISPUBLIC', NULL, NULL, '결재할 문서', '공개', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 1, '제목', 'Title', 'タイトル', '标题', 300, 'VAPRWILLDOCLIST', 'DocTitle', NULL, NULL, '기안한 문서', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 2, '회사', 'Company', '会社', '公司', 135, 'VAPRWILLDOCLIST', 'companyName', NULL, NULL, '결재할 문서', '회사', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 3, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 135, 'VAPRWILLDOCLIST', 'WriterDeptName', NULL, NULL, '기안한 문서', '기안부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 4, '기안자', 'Drafter', '起案者', '起草人', 70, 'VAPRWILLDOCLIST', 'WriterName', NULL, NULL, '기안한 문서', '기안자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 5, '기안일시', 'Date(draft)', '起案日時', '起草日期', 160, 'VAPRWILLDOCLIST', 'StartDate', NULL, NULL, '기안한 문서', '기안일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 6, '상태', 'Status', 'ステータス', '状态', 50, 'VAPRWILLDOCLIST', 'FunctionTypeName', NULL, NULL, '기안한 문서', '상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 7, '문서명', 'Form title', '文書名', '文件名', 100, 'VAPRWILLDOCLIST', 'FormName', NULL, NULL, '기안한 문서', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 8, '첨부', 'Attach', '添付', '附件', 50, 'VAPRWILLDOCLIST', 'HASATTACHYN', NULL, NULL, '기안한 문서', '첨부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 9, '공개', 'Public', '公開', '公开', 50, 'VAPRWILLDOCLIST', 'ISPUBLIC', NULL, NULL, '기안한 문서', '공개', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 1, '제목', 'Title', 'タイトル', '标题', 300, 'VAPRWILLDOCLIST', 'DocTitle', NULL, NULL, '결재진행문서', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 2, '회사', 'Company', '会社', '公司', 135, 'VAPRWILLDOCLIST', 'companyName', NULL, NULL, '결재할 문서', '회사', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 3, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 135, 'VAPRWILLDOCLIST', 'WriterDeptName', NULL, NULL, '결재진행문서', '기안부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 4, '기안자', 'Drafter', '起案者', '起草人', 70, 'VAPRWILLDOCLIST', 'WriterName', NULL, NULL, '결재진행문서', '기안자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 5, '기안일시', 'Dept.(draft)', '起案日時', '起草日期', 160, 'VAPRWILLDOCLIST', 'StartDate', NULL, NULL, '결재진행문서', '기안일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 6, '상태', 'Status', 'ステータス', '状态', 50, 'VAPRWILLDOCLIST', 'FunctionTypeName', NULL, NULL, '결재진행문서', '상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 7, '문서명', 'Form title', '文書名', '文件名', 100, 'VAPRWILLDOCLIST', 'FormName', NULL, NULL, '결재진행문서', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 8, '첨부', 'Attach', '添付', '附件', 50, 'VAPRWILLDOCLIST', 'HASATTACHYN', NULL, NULL, '결재진행문서', '첨부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 9, '공개', 'Public', '公開', '公开', 50, 'VAPRWILLDOCLIST', 'ISPUBLIC', NULL, NULL, '결재진행문서', '공개', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 1, '제목', 'Title', 'タイトル', '标题', 300, 'TBL_APRDOCINFO', 'DocTitle', NULL, NULL, '수신문서처리기', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 2, '문서상태', 'Doc. status', '文書区分', '文件状态', 110, 'TBL_APRRECEIPTPROCESSINFO', 'DocStateName', NULL, NULL, '수신문서처리기', '문서상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 3, '결재상태', 'Approval status', '進行段階', '批准状态', 110, 'TBL_APRRECEIPTPROCESSINFO', 'AprState', NULL, NULL, '수신문서처리기', '결재상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 4, '발신부서', 'Dept. sent', '送信部署', '发送部门', 100, 'TBL_APRRECEIPTPROCESSINFO', 'SentDeptName', NULL, NULL, '수신문서처리기', '발신부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 5, '도착일자', 'Date recevied', '到着日付', '接收日', 150, 'TBL_APRRECEIPTPROCESSINFO', 'ProcessDate', NULL, NULL, '수신문서처리기', '도착일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 6, '양식명', 'Form title', '様式名', '样式名', 100, 'TBL_APRDOCINFO', 'FormName', NULL, NULL, '수신문서처리기', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 7, '첨부', 'Attach', '添付', '附件', 50, 'TBL_APRDOCINFO', 'HASATTACHYN', NULL, NULL, '수신문서처리기', '첨부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 8, '공개', 'Public', '公開', '公开', 50, 'TBL_APRDOCINFO', 'ISPUBLIC', NULL, NULL, '수신문서처리기', '공개', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 1, '제목', 'Title', 'タイトル', '标题', 400, 'TBL_APRDOCINFO', 'DocTitle', NULL, NULL, '심사진행기', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 2, '문서상태', 'Doc. status', '文書区分', '文件状态', 110, 'TBL_APRRECEIPTPROCESSINFO', 'DocStateName', NULL, NULL, '심사진행기', '문서상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 3, '결재상태', 'Approval status', '進行段階', '批准状态', 110, 'TBL_APRRECEIPTPROCESSINFO', 'AprState', NULL, NULL, '심사진행기', '결재상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 4, '발신부서', 'Dept. sent', '送信部署', '发送部门', 100, 'TBL_APRRECEIPTPROCESSINFO', 'SentDeptName', NULL, NULL, '심사진행기', '발신부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 5, '도착일자', 'Date recevied', '到着日付', '接收日', 150, 'TBL_APRRECEIPTPROCESSINFO', 'ProcessDate', NULL, NULL, '심사진행기', '도착일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 6, '첨부', 'Attach', '添付', '附件', 50, 'TBL_APRRECEIPTPROCESSINFO', 'HASATTACHYN', NULL, NULL, '심사진행기', '첨부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 7, '공개', 'Public', '公開', '公开', 50, 'TBL_APRRECEIPTPROCESSINFO', 'ISPUBLIC', NULL, NULL, '심사진행기', '공개', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 140, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '문서함문서', '문서번호', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 2, '제목', 'Title', 'タイトル', '标题', 320, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '문서함문서', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 3, '기안자', 'Drafter', '起案者', '起草人', 90, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '문서함문서', '기안자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 4, '회사', 'Company', '会社', '公司', 110, 'TBL_ENDAPRDOCINFO', 'companyName', NULL, NULL, '결재할 문서', '회사', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 5, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 110, 'TBL_ENDAPRDOCINFO', 'WriterDeptName', NULL, NULL, '문서함문서', '기안부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 6, '완료일시', 'Date completed', '完了日時', '结束日期', 110, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '문서함문서', '완료일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 7, '양식명', 'Form title', '文書名', '文件名', 100, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '문서함문서', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 8, '이관', 'Transfer', '移管', '移交', 50, 'TBL_EXPENDAPRDOCINFO', 'EDMSYN', NULL, 'NoUse', '문서함문서', 'EDMS이관여부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 9, '구분', 'Type', '区分', '区分', 50, 'TBL_ENDAPRDOCINFO', 'DocStateName', NULL, NULL, '문서함문서', '문서상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 10, '발송상태', 'Sending status', '送信状態', '发送状态', 50, NULL, 'SendFlag', NULL, NULL, '문서함문서', '발송상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 11, '첨부', 'Attach', '添付', '附件', 20, NULL, 'HASATTACHYN', NULL, NULL, '문서함문서', '첨부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 12, '공개', 'Public', '公開', '公开', 20, NULL, 'ISPUBLIC', NULL, NULL, '문서함문서', '공개', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 1, '제목', 'Title', 'タイトル', '标题', 300, 'TBL_TMPAPRDOCINFO', 'DocTitle', NULL, NULL, '서버저장문서', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 2, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 130, 'TBL_TMPAPRDOCINFO', 'WriterDeptName', NULL, NULL, '서버저장문서', '기안부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 3, '기안자', 'Drafter', '起案者', '起草人', 120, 'TBL_TMPAPRDOCINFO', 'WriterName', NULL, NULL, '서버저장문서', '기안자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 4, '기안일시', 'Date(draft)', '起案日時', '起草日期', 130, 'TBL_TMPAPRDOCINFO', 'StartDate', NULL, NULL, '서버저장문서', '기안일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 5, '문서명', 'Form title', '文書名', '文件名', 100, 'TBL_TMPEXPAPRDOCINFO', 'FormName', NULL, NULL, '서버저장문서', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 6, '첨부', 'Attach', '添付', '附件', 50, 'TBL_APRDOCINFO', 'HASATTACHYN', NULL, NULL, '서버저장문서', '첨부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 7, '공개', 'Public', '公開', '公开', 50, 'TBL_APRDOCINFO', 'ISPUBLIC', NULL, NULL, '서버저장문서', '공개', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_APRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(진행)', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 2, '성명', 'Name', '氏名', '姓名', 120, 'TBL_APRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(진행)', '성명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_APRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(진행)', '직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 4, '부서', 'Dept.', '部署', '部门', 130, 'TBL_APRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(진행)', '부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 5, '결재유형', 'Type', '処理類型', '批准类型', 100, 'TBL_APRLINEINFO', 'AprType', NULL, NULL, '결재선정보(진행)', '결재방법', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 6, '결재상태', 'Status', '進行段階', '批准状态', 80, 'TBL_APRLINEINFO', 'AprState', NULL, NULL, '결재선정보(진행)', '결재상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 7, '결재일시', 'Date', '処理日時', '批准日', 130, 'TBL_APRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(진행)', '결재일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_ENDAPRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(완료)', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 2, '성명', 'Name', '氏名', '姓名', 120, 'TBL_ENDAPRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(완료)', '성명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_ENDAPRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(완료)', '직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 4, '부서', 'Dept.', '部署', '部门', 130, 'TBL_ENDAPRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(완료)', '부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 5, '결재유형', 'Type', '処理類型', '批准类型', 100, 'TBL_ENDAPRLINEINFO', 'AprType', NULL, NULL, '결재선정보(완료)', '결재방법', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 6, '결재상태', 'Status', '進行段階', '批准状态', 80, 'TBL_ENDAPRLINEINFO', 'AprState', NULL, NULL, '결재선정보(완료)', '결재상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 7, '결재일시', 'Date', '処理日時', '批准日', 130, 'TBL_ENDAPRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(완료)', '결재일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 8, '대리자', 'Deputy', '代理者', '代理者', 110, 'TBL_EXPENDAPRLINE', 'proxyusername', NULL, NULL, '결재선정보(완료)', '대리결재자이름', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 9, '대리자직위', 'Title(deputy)', '代理者の役職', '代理者职位', 90, 'TBL_EXPENDAPRLINE', 'proxyuserjobtitle', NULL, NULL, '결재선정보(완료)', '대리결재자직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 10, '대리자부서', 'Dept.(deputy)', '代理者の部署', '代理者部门', 120, 'TBL_EXPENDAPRLINE', 'proxyuserdeptname', NULL, NULL, '결재선정보(완료)', '대리결재자부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_APRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(코딩)', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 2, '성명', 'Name', '氏名', '姓名', 120, 'TBL_APRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(코딩)', '성명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 3, '직위', 'Title', '役職', '职位', 50, 'TBL_APRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(코딩)', '직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 4, '부서', 'Dept.', '部署', '部门', 130, 'TBL_APRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(코딩)', '부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 5, '결재유형', 'Type', '処理類型', '批准类型', 120, 'TBL_APRLINEINFO', 'AprType', NULL, NULL, '결재선정보(코딩)', '결재방법', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 6, '결재상태', 'Status', '進行段階', '批准状态', 80, 'TBL_APRLINEINFO', 'AprState', NULL, NULL, '결재선정보(코딩)', '결재상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 7, '결재일시', 'Date', '処理日時', '批准日', 130, 'TBL_APRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(코딩)', '결재일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_APRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(회람)', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_APRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(회람)', '성명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_APRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(회람)', '직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 4, '부서', 'Dept.', '部署', '部门', 600, 'TBL_APRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(회람)', '부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 5, '회람일시', 'Date', '回覧日時', '批准日(수정해야됨)', 300, 'TBL_APRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(회람)', '회람일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_APRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(회람)', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_APRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(회람)', '성명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_APRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(회람)', '직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 4, '부서', 'Dept.', '部署', '部门', 100, 'TBL_APRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(회람)', '부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 5, '회람일시', 'Date', '回覧日時', '批准日(수정해야됨)', 600, 'TBL_APRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(회람)', '회람일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_RECEIPTPOINTINFO', 'DeptMemberSN', NULL, NULL, '수신처정보(진행)', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 2, '수신부서명', 'Dept.', '受信部署名', '收信部门名', 120, 'TBL_RECEIPTPOINTINFO', 'ReceiptPointName', NULL, NULL, '수신처정보(진행)', '수신부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 3, '수신자성명', 'Name', '受信者氏名', '收信创建名', 120, 'TBL_RECEIPTPOINTINFO', 'ReceiptMemberName', NULL, NULL, '수신처정보(진행)', '수신자성명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 4, '승인상태', 'Status', '承認状態', '承认状态', 100, 'TBL_RECEIPTPOINTINFO', 'ProcessYN', NULL, NULL, '수신처정보(진행)', '처리여부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 5, '승인일자', 'Date', '処理日時', '承认日', 180, 'TBL_RECEIPTPOINTINFO', 'ProcessDate', NULL, NULL, '수신처정보(진행)', '처리일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_ENDRECEIPTPOINTINFO', 'DeptMemberSN', NULL, NULL, '수신처정보(완료)', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 2, '수신부서명', 'Dept.', '受信部署名', '收信部门名', 120, 'TBL_ENDRECEIPTPOINTINFO', 'ReceiptPointName', NULL, NULL, '수신처정보(완료)', '수신부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 3, '수신자성명', 'Name', '受信者氏名', '收信创建名', 120, 'TBL_ENDRECEIPTPOINTINFO', 'ReceiptMemberName', NULL, NULL, '수신처정보(완료)', '수신자성명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 4, '승인상태', 'Status', '承認状態', '承认状态', 100, 'TBL_ENDRECEIPTPOINTINFO', 'ProcessYN', NULL, NULL, '수신처정보(완료)', '처리여부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 5, '승인일자', 'Date', '処理日時', '承认日', 180, 'TBL_ENDRECEIPTPOINTINFO', 'ProcessDate', NULL, NULL, '수신처정보(완료)', '처리일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S023', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_RECEIPTPOINTINFO', 'DeptMemberSN', NULL, NULL, '수신처정보(코딩)', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S023', 2, '수신부서명', 'Dept', '受信部署名', '收信部门名', 200, 'TBL_RECEIPTPOINTINFO', 'ReceiptPointName', NULL, NULL, '수신처정보(코딩)', '수신부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S023', 3, '수신자성명', 'Name', '受信者氏名', '收信创建名', 200, 'TBL_RECEIPTPOINTINFO', 'ReceiptMemberName', NULL, NULL, '수신처정보(진행)', '수신자성명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 1, '구분', 'Type', '区分', '区分', 55, 'TBL_APROPINIONINFO', 'OpinionGBName', NULL, NULL, '의견정보(진행)', '의견구분', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_APROPINIONINFO', 'UserName', NULL, NULL, '의견정보(진행)', '작성자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 3, '내용', 'Content', '内容', '内容', 300, 'TBL_APROPINIONINFO', 'Content', NULL, NULL, '의견정보(진행)', '의견내용', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 4, '직위', 'Title', '役職', '职位', 100, 'TBL_APROPINIONINFO', 'UserJobTitle', NULL, NULL, '의견정보(진행)', '작성자직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 5, '부서', 'Dept.', '部署', '部门', 100, 'TBL_APROPINIONINFO', 'UserDeptName', NULL, NULL, '의견정보(진행)', '작성자부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 1, '구분', 'Type', '区分', '区分', 55, 'TBL_ENDAPROPINIONINFO', 'OpinionGBName', NULL, NULL, '의견정보(완료)', '의견구분', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_ENDAPROPINIONINFO', 'UserName', NULL, NULL, '의견정보(완료)', '작성자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 3, '내용', 'Content', '内容', '内容', 300, 'TBL_ENDAPROPINIONINFO', 'Content', NULL, NULL, '의견정보(완료)', '의견내용', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 4, '직위', 'Title', '役職', '职位', 100, 'TBL_ENDAPROPINIONINFO', 'UserJobTitle', NULL, NULL, '의견정보(완료)', '작성자직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 5, '부서', 'Dept.', '部署', '部门', 100, 'TBL_ENDAPROPINIONINFO', 'UserDeptName', NULL, NULL, '의견정보(완료)', '작성자부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S033', 1, '구분', 'Type', '区分', '区分', 55, 'TBL_APROPINIONINFO', 'OpinionGBName', NULL, NULL, '의견정보(진행UI)', '의견구분', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S033', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_APROPINIONINFO', 'UserName', NULL, NULL, '의견정보(진행UI)', '작성자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S033', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_APROPINIONINFO', 'UserJobTitle', NULL, NULL, '의견정보(진행UI)', '작성자직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S033', 4, '부서', 'Dept.', '部署', '部门', 100, 'TBL_APROPINIONINFO', 'UserDeptName', NULL, NULL, '의견정보(진행UI)', '작성자부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S034', 1, '구분', 'Type', '区分', '区分', 55, 'TBL_ENDAPROPINIONINFO', 'OpinionGBName', NULL, NULL, '의견정보(완료UI)', '의견구분', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S034', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_ENDAPROPINIONINFO', 'UserName', NULL, NULL, '의견정보(완료UI)', '작성자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S034', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_ENDAPROPINIONINFO', 'UserJobTitle', NULL, NULL, '의견정보(완료UI)', '작성자직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S034', 4, '부서', 'Dept.', '部署', '部门', 100, 'TBL_ENDAPROPINIONINFO', 'UserDeptName', NULL, NULL, '의견정보(완료UI)', '작성자부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S041', 1, '첨부자', 'User', '添付者', '附件者', 100, 'TBL_APRATTACHINFO', 'AttachUserName', NULL, NULL, '첨부파일정보(진행UI)', '첨부자명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S041', 2, '파일이름', 'Filename', 'ファイル名', '文件名', 200, 'TBL_APRATTACHINFO', 'AttachFileName', NULL, NULL, '첨부파일정보(진행UI)', '디스플래이명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S041', 3, '파일크기', 'Size', 'ファイルサイズ', '文件大小', 100, 'TBL_APRATTACHINFO', 'AttachFileSize', NULL, NULL, '첨부파일정보(진행UI)', '파일크기', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S042', 1, '문서명', 'Form title', '文書名', '文件名', 300, 'TBAPRDOCATTACHINFO', 'AttachDocName', NULL, NULL, '첨부문서정보(진행UI)', '문서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S043', 1, '구분', 'Type', '区分', '区分', 180, NULL, 'AttachType', NULL, NULL, '첨부정보', '구분', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S043', 2, '첨부이름', 'Filename', '添付名', '附件名', 700, NULL, 'AttachName', NULL, NULL, '첨부정보', '첨부이름', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S043', 3, '첨부자', 'User', '添付者', '附件者', 450, NULL, 'AttachUserName', NULL, NULL, '첨부정보', '첨부자명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S043', 4, '첨부자부서명', 'Dept.', '添付者部署名', '附件者部门名', 200, NULL, 'AttachUserDeptName', NULL, NULL, '첨부정보', '첨부자부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '개인문서함리스트', '문서번호', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 2, '제목', 'Title', 'タイトル', '标题', 380, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '개인문서함리스트', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '개인문서함리스트', '기안자이름', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 4, '완료일시', 'Date completed', '完了日時', '结束日期', 100, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '개인문서함리스트', '완료일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 5, '양식명', 'Form title', '文書名', '文件名', 100, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '개인문서함리스트', '양식이름', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 6, '등록일자', 'Date registered', '登録日付', '注册日期', 50, 'TBL_USERCONTLIST', 'LinkDate', NULL, NULL, '개인문서함리스트', '등록일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 7, '첨부', 'Attach', '添付', '附件', 30, 'TBL_USERCONTLIST', 'HASATTACHYN', NULL, NULL, '개인문서함리스트', '첨부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 8, '공개', 'Public', '公開', '公开', 30, 'TBL_USERCONTLIST', 'ISPUBLIC', NULL, NULL, '개인문서함리스트', '공개', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '부서문서함리스트', '문서번호', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 2, '제목', 'Title', 'タイトル', '标题', 350, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '부서문서함리스트', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '부서문서함리스트', '기안자이름', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 4, '완료일시', 'Date completed', '完了日時', '结束日期', 160, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '부서문서함리스트', '완료일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 5, '문서명', 'Form title', '文書名', '文件名', 160, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '부서문서함리스트', '양식이름', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 6, '등록일자', 'Date registered', '登録日付', '注册日期', 160, 'TBL_DEPTCONTLIST', 'LinkDate', NULL, NULL, '부서문서함리스트', '등록일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '문서함문서', '문서번호', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 2, '제목', 'Title', 'タイトル', '标题', 350, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '문서함문서', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '문서함문서', '기안자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 4, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 100, 'TBL_ENDAPRDOCINFO', 'WriterDeptName', NULL, NULL, '문서함문서', '기안부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 5, '완료일시', 'Date completed', '完了日時', '结束日期', 160, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '문서함문서', '완료일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 6, '문서명', 'Form title', '文書名', '文件名', 150, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '문서함문서', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '문서함문서', '문서번호', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 2, '제목', 'Title', 'タイトル', '标题', 350, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '문서함문서', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '문서함문서', '기안자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 4, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 100, 'TBL_ENDAPRDOCINFO', 'WriterDeptName', NULL, NULL, '문서함문서', '기안부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 5, '등록일시', 'Date registered', '登録日時', '注册日', 160, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '문서함문서', '완료일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 6, '문서명', 'Form title', '文書名', '文件名', 150, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '문서함문서', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 1, '변경내용', 'Content', '変更内容', '变更内容', 60, 'TBL_HISTORYATTACHINFO', 'ModifyFlag', NULL, NULL, '첨부파일이력리스트', '변경내용', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 2, '첨부이름', 'Filename', '添付名', '附件名', 200, 'TBL_HISTORYATTACHINFO', 'AttachFileDisplayName', NULL, NULL, '첨부파일이력리스트', '첨부이름', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 3, '첨부사이즈', 'Size', '添付サイズ', '附件大小', 80, 'TBL_HISTORYATTACHINFO', 'AttachFileSize', NULL, NULL, '첨부파일이력리스트', '첨부사이즈', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 4, '변경일자', 'Date', '変更日付', '变更日', 120, 'TBL_HISTORYATTACHINFO', 'ModifyDate', NULL, NULL, '첨부파일이력리스트', '변경일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 5, '변경자', 'User', '変更者', '变更者', 80, 'TBL_HISTORYATTACHINFO', 'AttachUserName', NULL, NULL, '첨부파일이력리스트', '변경자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 1, '변경순번', 'No.', '順番', '变更序号', 60, 'TBL_HISTORYLINEINFO', 'ModifySN', NULL, NULL, '결재선이력리스트', '변경순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 2, '변경일자', 'Date', '変更日付', '变更日', 100, 'TBL_HISTORYLINEINFO', 'ModifyDate', NULL, NULL, '결재선이력리스트', '변경일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 3, '변경자', 'User', '変更者', '变更者', 100, 'TBL_HISTORYLINEINFO', 'ModifyUserName', NULL, NULL, '결재선이력리스트', '변경자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 4, '변경자직위', 'Title', '変更者役職', '变更者职位', 100, 'TBL_HISTORYLINEINFO', 'ModifyUserJobTitle', NULL, NULL, '결재선이력리스트', '변경자직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 5, '변경자부서', 'Dept.', '部署', '变更者部门', 100, 'TBL_HISTORYLINEINFO', 'ModifyUserDeptName', NULL, NULL, '결재선이력리스트', '변경자부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 1, '결재순번', 'No.', '決裁順番', '批准序号', 60, 'TBL_HISTORYLINEINFO', 'AprMemberSN', NULL, NULL, '결재선이력상세리스트', '결재순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 2, '결재방법', 'Type', '決裁方法', '批准方法', 60, 'TBL_HISTORYLINEINFO', 'AprType', NULL, NULL, '결재선이력상세리스트', '결재방법', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 3, '결재상태', 'Status', '進行段階', '批准状态', 60, 'TBL_HISTORYLINEINFO', 'AprState', NULL, NULL, '결재선이력상세리스트', '결재상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 4, '결재자이름', 'Name', '決裁者', '批准者名', 100, 'TBL_HISTORYLINEINFO', 'AprMemberName', NULL, NULL, '결재선이력상세리스트', '결재자이름', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 5, '결재자직위', 'Title', '決裁者役職', '批准者职位', 100, 'TBL_HISTORYLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선이력상세리스트', '결재자직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 6, '결재자부서', 'Dept.', '決裁者部署', '批准者部门', 100, 'TBL_HISTORYLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선이력상세리스트', '결재자부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 7, '보고자', 'Reporter', 'レポーター', '报告者', 50, 'TBL_HISTORYLINEINFO', 'isBriefUserYN', NULL, 'nouse', '결재선이력상세리스트', '보고자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 8, '발의자', 'Proposer', '発議者', '倡议者', 50, 'TBL_HISTORYLINEINFO', 'isProposerYN', NULL, 'nouse', '결재선이력상세리스트', '발의자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 1, '변경순번', 'No.', '順番', '变更序号', 60, 'TBL_HISTORYDOCINFO', 'ChangeSN', NULL, NULL, '문서이력리스트', '변경순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 2, '변경일자', 'Date', '変更日付', '变更日', 100, 'TBL_HISTORYDOCINFO', 'ChangeDate', NULL, NULL, '문서이력리스트', '변경일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 3, '변경자이름', 'Name', '変更者氏名', '变更者名', 100, 'TBL_HISTORYDOCINFO', 'ChangeUserName', NULL, NULL, '문서이력리스트', '변경자이름', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 4, '변경자직위', 'Title', '変更者役職', '变更者职位', 100, 'TBL_HISTORYDOCINFO', 'ChangeUserJobTitle', NULL, NULL, '문서이력리스트', '변경자직위', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 5, '변경자부서', 'Dept.', '部署', '变更者部门', 100, 'TBL_HISTORYDOCINFO', 'ChangeUserDeptName', NULL, NULL, '문서이력리스트', '변경자부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 1, '제목', 'Title', 'タイトル', '标题', 300, 'TBL_APRDOCINFO', 'DocTitle', NULL, NULL, '관리자 진행문서', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 2, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 135, 'TBL_APRDOCINFO', 'WriterDeptName', NULL, NULL, '관리자 진행문서', '기안부서', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 3, '기안자', 'Drafter', '起案者', '起草人', 50, 'TBL_APRDOCINFO', 'WriterName', NULL, NULL, '관리자 진행문서', '기안자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 4, '기안일시', 'Date(draft)', '起案日時', '起草日期', 160, 'TBL_APRDOCINFO', 'StartDate', NULL, NULL, '관리자 진행문서', '기안일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 5, '상태', 'Status', 'ステータス', '状态', 50, 'TBL_APRDOCINFO', 'FunctionTypeName', NULL, NULL, '관리자 진행문서', '상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 6, '문서명', 'Form title', '文書名', '文件名', 160, 'TBEXPAPRDOCINFO', 'FormName', NULL, NULL, '관리자 진행문서', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '관리자 완료문서', '문서번호', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 2, '제목', 'Title', 'タイトル', '标题', 350, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '관리자 완료문서', '제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '관리자 완료문서', '기안자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 4, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 100, 'TBL_ENDAPRDOCINFO', 'WriterDeptName', NULL, NULL, '관리자 완료문서', '기안부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 5, '완료일시', 'Date completed', '完了日時', '结束日期', 160, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '관리자 완료문서', '완료일시', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 6, '문서명', 'Form title', '文書名', '文件名', 150, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '관리자 완료문서', '양식명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 7, '이관', 'Transfer', '移管', '移交', 30, 'TBL_EXPENDAPRDOCINFO', 'EDMSYN', NULL, NULL, '관리자 완료문서', 'EDMS이관여부', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 130, NULL, 'DocNo', NULL, NULL, '연동문서', '문서번호', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 2, '제목', 'Title', 'タイトル', '标题', 250, NULL, 'DocTitle', NULL, NULL, '연동문서', '문서제목', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 3, '상태', 'Status', 'ステータス', '状态', 100, NULL, 'Status', NULL, NULL, '연동문서', '문서상태', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 4, '기안일자', 'Date drated', '起案日付', '起草日', 150, NULL, 'StartDate', NULL, NULL, '연동문서', '기안일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 5, '완료일자', 'Date completed', '完了日付', '结束日', 150, NULL, 'EndDate', NULL, NULL, '연동문서', '완료일자', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S091', 1, '순번', 'No.', '順番', '序号', 55, 'TBL_ADMINRECEIPTGROUP_MAIN', 'MAINID', NULL, 'NoUse', '수신처그룹정보', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S091', 2, '수신처그룹', 'Receiving Dept. Group', '受信先グループ', '收信组', 250, 'TBL_ADMINRECEIPTGROUP_MAIN', 'MAINNAME', NULL, NULL, '수신처그룹정보', '수신처그룹명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S092', 1, '순번', 'No.', '順番', '序号', 55, 'TBL_ADMINRECEIPTGROUP_SUB', 'SUBID', NULL, 'NoUse', '수신처그룹소속부서정보', '순번', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S092', 2, '부서아이디', 'Dept. ID', '部署ID', '部门 ID', 250, 'TBL_ADMINRECEIPTGROUP_SUB', 'DEPTID', NULL, 'NoUse', '수신처그룹소속부서정보', '부서아이디', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S092', 3, '부서명', 'Dept. Name', '部署名', '部门名', 250, 'TBL_ADMINRECEIPTGROUP_SUB', 'DEPTNAME', NULL, NULL, '수신처그룹소속부서정보', '부서명', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S092', 4, '회사아이디', 'Company ID', '会社ID', '公司 ID', 250, 'TBL_ADMINRECEIPTGROUP_SUB', 'companyID', NULL, 'NoUse', '수신처그룹소속부서정보', '회사아이디', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S101', 1, '양식리스트', 'Form list', '様式リスト', '样式列表', 250, 'tbFormInfo', 'FORMNAME', NULL, NULL, '양식', '양식리스트', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S102', 1, '순번', 'No.', '順番', '序号', 40, 'TBL_LINTEMPLETDETAIL', 'APRMEMBERSN', NULL, NULL, '순번', '결재선템플릿내결재선정보', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S102', 2, '결재유형', 'Type', '処理類型', '批准类型', 70, 'TBL_LINTEMPLETDETAIL', 'APRTYPE', NULL, NULL, '결재유형', '결재선템플릿내결재선정보', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S102', 3, '결재자', 'Processor', '決裁者', '批准者', 120, 'TBL_LINTEMPLETDETAIL', 'APRMEMBERNAME', NULL, NULL, '결재자', '결재선템플릿내결재선정보', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S103', 1, '수 신 처', 'Receiving Dept.', '受信先', '收信人', 200, 'TBL_DEPTTEMPLETDETAIL', 'APRMEMBERDEPTNAME', NULL, NULL, '수신처', '수신처템플릿내수신처정보', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S103', 2, '수 신 자', 'Name', '受信者', '接受者', 100, 'TBL_DEPTTEMPLETDETAIL', 'APRMEMBERNAME', NULL, NULL, '수신자', '수신처템플릿내수신처정보', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 1, '부서명', 'Dept. name', '部署名', '部门名', 100, 'TBL_ENDAPRLINEINFO', 'APRMEMBERDEPTNAME', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 2, '직위', 'Title', '役職', '职位', 80, 'TBL_ENDAPRLINEINFO', 'APRMEMBERJOBTITLE', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 3, '결재자', 'Approval perso', '決裁者', '批准者', 80, 'TBL_ENDAPRLINEINFO', 'APRMEMBERNAME', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 4, '결재방법', 'Approval type', '決裁方法', '批准方法', 80, 'TBL_ENDAPRLINEINFO', 'APRTYPE', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 5, '결재건수', 'The number of approval', '決裁件数', '批准件数', 60, 'TBL_ENDAPRLINEINFO', 'APRCOUNT', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S105', 1, '발신부서', 'Sending dept.', '送信部署', '发送部门', 150, 'TBL_ENDRECEIPTPROCESSINFO', 'SENTDEPTNAME', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S105', 2, '건수', 'The number of cases', '件数', '件数', 40, 'TBL_ENDRECEIPTPROCESSINFO', 'APRCOUNT', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S106', 1, '수신부서', 'Receiving dept.', '受信部署', '收信部门', 150, 'TBL_ENDRECEIPTPROCESSINFO', 'RECEIVEDDEPTNAME', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S106', 2, '건수', 'The number of cases', '件数', '件数', 40, 'TBL_ENDRECEIPTPROCESSINFO', 'APRCOUNT', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S107', 1, '발신부서', 'Sending dept.', '送信部署', '发送部门', 150, 'TBL_ENDRECEIPTPROCESSINFO', 'SENTDEPTNAME', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S107', 2, '수신부서', 'Receiving dept.', '受信部署', '收信部门', 150, 'TBL_ENDRECEIPTPROCESSINFO', 'RECEIVEDDEPTNAME', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S107', 3, '건수', 'The number of cases', '件数', '件数', 40, 'TBL_ENDRECEIPTPROCESSINFO', 'APRCOUNT', NULL, NULL, NULL, NULL, 'Top', 0);  
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S108', 1, '문서상태', 'Doc. status', '文書区分', '文件状态', 100, NULL, NULL, NULL, NULL, '문서함관리', '문서함관리', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S108', 2, '문서함명', 'Doc. folder name', '文書フォルダ名', '文件夹名', 100, NULL, NULL, NULL, NULL, '문서함관리', '문서함관리', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S109', 1, '소속문서함', 'Special doc. folder type', '所属文書フォルダ', '所属文件夹', 100, NULL, NULL, NULL, NULL, '문서함관리-특수문서함', '문서함관리-특수문서함', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S109', 2, '문서함명', 'Special doc. folder name', '文書フォルダ名', '文件夹名', 100, NULL, NULL, NULL, NULL, '문서함관리-특수문서함', '문서함관리-특수문서함', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S109', 3, '서브쿼리', 'Query', 'サーブクイーリー', '查询', 100, NULL, NULL, NULL, NULL, '문서함관리-특수문서함', '문서함관리-특수문서함', 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 2, '코드', 'Code', 'コード', '代码', 70, NULL, 'ITEMCODE', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 3, '기능명칭', 'Name', '機能名', '功能名称', 180, NULL, 'ITEMNAME', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 4, '보존기간', 'Keeping period', '保存期間', '保留时间', 70, NULL, 'ITEMLIMIT', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 5, '보안등급', 'Security level', '保安等級', '安全级别', 70, NULL, 'ITEMSECURITY', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 6, '공개여부', 'Public', '公開設定', '是否共享', 60, NULL, 'ITEMPUBLIC', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 1, '문서분류', 'Classified document', '文書分類', '文件分类', 105, NULL, 'GROUPNAME', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 2, '코드', 'Code', 'コード', '代码', 50, NULL, 'ITEMCODE', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 3, '기능명칭', 'Name', '機能名', '功能名称', 180, NULL, 'ITEMNAME', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 4, '보존기간', 'Keeping period', '保存期間', '保留时间', 80, NULL, 'ITEMLIMIT', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 5, '보안등급', 'Security level', '保安等級', '安全级别', 80, NULL, 'ITEMSECURITY', NULL, NULL, NULL, NULL, 'Top', 0);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 6, '공개여부', 'Public', '公開設定', '是否共享', 60, NULL, 'ITEMPUBLIC', NULL, NULL, NULL, NULL, 'Top', 0);

INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물 이관목록',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',2,'문서번호',80,null,'CONCAT(CONCAT(TBL_RECORD.ProcessDeptName,''-''),TRIM(LEADING''0'' FROM TBL_RECORD.RegisterNo))','DispRegisterNo','Default','기록물 이관목록',null,'Doc. No.','登録番号','註冊號','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',3,'제목',220,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','RecTitle','Default','기록물 이관목록',null,'Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',4,'기록물 형태',110,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.RegisterType','RegisterType','dtRegisterType','기록물 이관목록',null,'DocForm','記録物の形態','纪录片的形式','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',5,'쪽수',40,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.NumOfPage','NumOfPage','Default','기록물 이관목록',null,'PageNum','ページ数','頁數','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',6,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(TBL_CABINET.ProcessDeptCode),''-''),TBL_CABINET.TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물 이관목록',null,'DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',7,'공개구분',95,'TBL_RECORD','TBL_RECORD.PublicityCode','PublicityCode','dtPubCode','기록물 이관목록',null,'PublicityCode','公開区分','公共区分','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',8,'공개제한부분',90,'TBL_RECORD','TBL_RECORD.LimitRange','LimitRange','Default','기록물 이관목록',null,'LimitRange','公開制限の部分','部分公众有限公司','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',1,'순번',65,null,null,'dtSerialNum','dtSerialNum','기록물철 이관목록',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',2,'분류번호',200,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물철 이관목록',null,'DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',3,'제목',260,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 이관목록',null,'Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',4,'건수',80,'GetCabPageStaTbl2','NVL(GetNumOfRec(TBL_CABINET.CabinetID),0)','NumOfRec','Default','기록물철 이관목록',null,'APRCOUNT','件数','件数','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',5,'쪽수',80,'GetCabPageStaTbl2','NVL(GetNumOfPage(TBL_CABINET.CabinetID),0)','PageOfRec','Default','기록물철 이관목록',null,'PageNum','ページ数','頁數','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',6,'기록물 형태',110,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','기록물철 이관목록',null,'DocForm','記録物の形態','纪录片的形式','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',1,'일련번호',55,null,null,'dtSerialNum','dtSerialNum','기록물 이관연기 목록',null,'SerialNum','シリアル番号','序列号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',2,'문서번호',100,null,'CONCAT(CONCAT(TBL_RECORD.ProcessDeptName, ''-''), TRIM(LEADING''0'' FROM TBL_RECORD.RegisterNo))','DispRegisterNo','Default','기록물 이관연기 목록',null,'Doc. No.','登録番号','註冊號','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',3,'제목',220,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','Title','Default','기록물 이관연기 목록',null,'Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',4,'생산연도',80,'TBL_RECORD','TBL_RECORD.RegisterYear','RegisterYear','Default','기록물 이관연기 목록',null,'RegisterYear','生産年度','生产年份','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',5,'이관연도',80,'TBL_CABINETCLASS','Case TBL_CABINET.DisplayRecFlag When ''1'' Then Year(TBL_CABINET.DisplayEndDate)||1 Else TBL_CABINET.ExTransYear End','TransYear','Default','기록물 이관연기 목록',null,'TransYear','移管年度','移民一年','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',6,'연기사유',250,'TBL_CABINETCLASS','Case TBL_CABINET.DisplayRecFlag When ''1'' Then TBL_CABINET.DisplayReason Else TBL_CABINET.TransDelayReason End','DisplayReason','Default','기록물 이관연기 목록',null,'DisplayReason','延期の理由','吸烟的原因','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',1,'일련번호',55,null,null,'dtSerialNum','dtSerialNum','기록물철 이관연기 목록',null,'SerialNum','シリアル番号','序列号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물철 이관연기 목록',null,'DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 이관연기 목록',null,'Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',4,'생산연도',60,'TBL_CABINETCLASS','TBL_CABINETCLASS.ProductionYear','ProductionYear','ProductionYear','기록물철 이관연기 목록',null,'RegisterYear','生産年度','生产年份','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',5,'이관연도',60,'TBL_CABINETCLASS','Case DisplayRecFlag When ''1'' Then Year(TBL_CABINETCLASS.DisplayEndDate)||1 Else TBL_CABINETCLASS.ExTransYear End','TransYear','Default','기록물철 이관연기 목록',null,'TransYear','移管年度','移民一年','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',6,'연기사유',235,'TBL_CABINETCLASS','Case DisplayRecFlag When ''1'' Then TBL_CABINETCLASS.DisplayReason Else TBL_CABINETCLASS.TransDelayReason End','DisplayReason','Default','기록물철 이관연기 목록',null,'DisplayReason','延期の理由','吸烟的原因','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','정리대상기록물철',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','정리대상기록물철','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','정리대상기록물철','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',4,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','정리대상기록물철',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',5,'종료연도',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.ExpirationYear','EndYear','Default','정리대상기록물철',null,'EndYear','終了年度','年退出','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',6,'편철확인',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.TerminateFlag','TerminateFlag','dtBool','정리대상기록물철',null,'TerminateFlag','編綴','编辑拼写','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',7,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','정리대상기록물철',null,'STOCKED','備付','備付','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',8,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','정리대상기록물철',null,'KEEPING PERIOD','保存期間','年龄','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',9,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','정리대상기록물철',null,'CONSERVATION METHOD','保存方法','如何保存','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',10,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','정리대상기록물철',null,'보존장소E','保存場所','保护区','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',11,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','정리대상기록물철',null,'RegisterDate','登録日','注册','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','종료연기의뢰기록물철',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','종료연기의뢰기록물철','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','종료연기의뢰기록물철','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',4,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','종료연기의뢰기록물철',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',11,'연기신청',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.DelayEndYFlag','DelayEndYFlag','Default','종료연기의뢰기록물철',null,'DelayFlag','延期申請','延期请求','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',6,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','종료연기의뢰기록물철',null,'STOCKED','備付','備付','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',7,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','종료연기의뢰기록물철',null,'KEEPING PERIOD','保存期間','年龄','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',8,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','종료연기의뢰기록물철',null,'CONSERVATION METHOD','保存方法','如何保存','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',9,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','종료연기의뢰기록물철',null,'보존장소E','保存場所','保护区','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',10,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','종료연기의뢰기록물철',null,'RegisterDate','登録日','注册','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물철 생상현황보고',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',2,'분류번호',180,null,null,'dtCabClassNo','dtCabClassNo','기록물철 생상현황보고','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 생상현황보고','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',4,'상태',80,null,null,'TransStatus','Default',null,null,'Status','ステータス','状态','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',5,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','기록물철 생상현황보고',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',6,'종료연도',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.ExpirationYear','ExpirationYear','Default','기록물철 생상현황보고',null,'EndYear','終了年度','年退出','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',7,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','기록물철 생상현황보고',null,'STOCKED','備付','備付','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',8,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','기록물철 생상현황보고',null,'KEEPING PERIOD','保存期間','年龄','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',9,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','기록물철 생상현황보고',null,'CONSERVATION METHOD','保存方法','如何保存','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',10,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','기록물철 생상현황보고',null,'보존장소E','保存場所','保护区','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',11,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','기록물철 생상현황보고',null,'RegisterDate','登録日','注册','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',1,'순번',30,null,null,'dtSerialNum','dtSerialNum','기록물 생상현황보고',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',2,'등록구분',120,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.RegisterType','RegisterType','dtRegisterType','기록물 생상현황보고',null,'RegisterType','登録区分','招生区分','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',3,'등록일',100,'TBL_RECORD','TBL_RECORD.RegisterDate','RegisterDate','RegisterDate','기록물 생상현황보고',null,'RegisterDate','登録日','注册','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',4,'문서번호',100,null,null,'RegisterNo','RegisterNo','기록물 생상현황보고',null,'Doc. No.','登録番号','註冊號','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',5,'첨부번호',55,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.SeperateAttachNo','SeperateAttachNo','Default','기록물 생상현황보고',null,'SepAttachNo','添付番号','附件编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',6,'제목',200,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','Title','Default','기록물 생상현황보고',null,'Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',7,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(TBL_CABINET.ProcessDeptCode),''-''),TBL_CABINET.TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','dtCabClassNo','dtCabClassNo','기록물 생상현황보고','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',8,'결재권자',80,'TBL_RECORD','TBL_RECORD.AprMemberTitle','AprMemberTitle','Default','기록물 생상현황보고',null,'Approval person','決裁権者','审批','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',9,'기안자',80,'TBL_RECORD','TBL_RECORD.DrafterName','DrafterName','Default','기록물 생상현황보고',null,'Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',10,'첨부',40,'TBL_RECORD','TBL_RECORD.AttachFlag','AttachFlag','dtBool','기록물 생상현황보고','첨부여부','AttachFlag','添付','附件','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',1,'처리과코드',80,null,null,'ProcessDeptCode','Default','기록물철 등록부 변경이력','처리과기관코드','ProcessDeptCode','処理とコード','处理和代码','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',2,'단위업무코드',80,null,null,'TaskCode','Default',null,null,'UNITWORKING CODE','単位業務コード','工作单位代码','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',3,'생산년도',60,null,null,'ProductionYear','Default',null,null,'ProductionYear','生産年度','生产年份','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',4,'등록일련번호',80,null,null,'RegSerialNo','Default',null,null,'RegSerialNo','登録のシリアル番号','注册序列号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',5,'권호수',60,null,null,'VolumeNo','Default',null,null,'VOL.','巻号数','卷湖','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',6,'변경전 기록물철제목',200,null,null,'oTitle','Default',null,null,'BeforeTitle','変更前の見出し','前更改名称','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',7,'변경후 기록물철제목',200,null,null,'nTitle','Default',null,null,'AfterTitle','変更後の見出し','变更后的标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',8,'변경전 기록물형태',120,null,null,'oRecTypeCode','Default',null,null,'BeforeRecTypeCode','変更前の形式','表前的变化。','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',9,'변경후 기록물형태',120,null,null,'nRecTypeCode','Default',null,null,'AfterRecTypeCode','変更後の形','表变更后','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',10,'변경일자',120,null,null,'ModifyDate','Default',null,null,'Modified date','変更日時','变更日','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',11,'변경사유',250,null,null,'ModifyReason','Default',null,null,'ModifyReason','変更の理由','更改原因','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',12,'변경자',120,null,null,'ModifierName','Default','기록물등록대장 변경이력',null,'User','変更者','変更者','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',1,'처리과코드',80,null,null,'ProcessDeptCode','Default',null,null,'ProcessDeptCode','処理とコード','处理和代码','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',2,'생산년도',60,null,null,'RegisterYear','Default',null,null,'ProductionYear','生産年度','生产年份','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',3,'문서번호',120,null,null,'RegisterNo','Default',null,null,'Doc. No.','登録番号','註冊號','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',4,'분리번호',60,null,null,'SeperateAttachNo','Default',null,null,'SeperateAttachNo','分割番号','卸下数','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',5,'변경전 등록일자',120,null,null,'oRegisterDate','Default',null,null,'BeforeDate','変更前の登録日','日期前更改。','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',6,'변경후 등록일자',120,null,null,'nRegisterDate','Default',null,null,'AfterDate','変更後の登録日','日期的变更登记后。','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',7,'변경전 제목',200,null,null,'oTitle','Default',null,null,'BeforeTitle','変更前の見出し','前更改名称','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',8,'변경후 제목',200,null,null,'nTitle','Default',null,null,'AfterTitle','変更後の見出し','变更后的标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',9,'변경전쪽수',70,null,null,'oNumOfPage','Default',null,null,'BeforePage','変更前の改','表前的网页。','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',10,'변경후쪽수',70,null,null,'nNumOfPage','Default',null,null,'AfterPage','変更後の改','变更后网页','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',11,'변경전 결재권자',120,null,null,'oAprMemTitle','Default',null,null,'BeforeApprover','変更前の決裁権者','审批前更改。','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',12,'변경후 결재권자',120,null,null,'nAprMemTitle','Default',null,null,'AfterApprover','変更後決裁権者','审批后的变化','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',13,'변경전 기안자',120,null,null,'oDrafter','Default',null,null,'BeforeDrafter','変更前の首謀者','策划前的变化。','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',14,'변경후 기안자',120,null,null,'nDrafter','Default',null,null,'AfterDrafter','変更後首謀者','策划变更后','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',15,'변경전 시행일자',100,null,null,'oExecuteDate','Default',null,null,'BeforeExecuteDate','変更前の施行日','生效日期前更改。','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',16,'변경후 시행일자',100,null,null,'nExecuteDate','Default',null,null,'AfterExecuteDate','変更後の施行日','变更后的生效日期','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',17,'변경전 수신자',120,null,null,'oRMemName','Default',null,null,'BeforeRecevName','変更前の受信者','接收机前更改。','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',18,'변경후 수신자',120,null,null,'nRMemName','Default',null,null,'AfterRecevName','変更後の受信者','收件人变更后','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',19,'변경일자',100,null,null,'ModifyDate','Default',null,null,'Modified date','変更日時','变更日','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',20,'변경사유',200,null,null,'ModifyReason','Default',null,null,'ModifyReason','変更の理由','更改原因','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',21,'변경자',120,null,null,'ModifierName','Default',null,null,'User','変更者','変更者','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',1,'특수목록위치',100,null,null,'SCLocation','Default',null,null,'특수목록위치E','특수목록위치J','특수목록위치C','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',2,'기록물철분류번호',150,null,null,'ClassifyNo_Cab','Default',null,null,'ClassifyNo_Cab','ドキュメンタリー鉄の分類番号','铁的记录数分类','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',3,'기록물등록번호',150,null,null,'ClassifyNo_Rec','Default',null,null,'ClassifyNo_Rec','ドキュメンタリーの登録番号','记录登记号码','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',4,'일련번호',80,null,null,'SerialNo','Default',null,null,'SerialNum','シリアル番号','序列号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',5,'특수목록#1',150,null,null,'SC1','Default',null,null,'Special List # 1','特殊なリスト＃1','特别名单＃1','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',6,'특수목록#2',150,null,null,'SC2','Default',null,null,'Special List # 2','特殊なリスト＃2','特别名单＃2','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',7,'특수목록#3',150,null,null,'SC3','Default',null,null,'Special List # 3','特殊なリスト＃3','特别名单＃3','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',1,'처리과기관코드',120,null,null,'ProcessDeptCode','Default',null,null,'ProcessDeptCode','処理の機関コード','处理和机构法规','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',2,'생산년도',80,null,null,'RegisterYear','Default',null,null,'ProductionYear','生産年度','生产年份','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',3,'문서번호',150,null,null,'RegisterNo','Default',null,null,'Doc. No.','登録番号','註冊號','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',4,'첨부일련번호',100,null,null,'AttFileSN','Default',null,null,'AttFileSN','添付のシリアル番号','附加的序列号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',5,'쪽수',80,null,null,'NumOfPage','Default',null,null,'PageNum','ページ数','頁數','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',1,'기관코드',120,null,null,'OrganCode','dtOrganCode',null,null,'OrganCode','機関コード','机构代码','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',2,'접수년도',80,null,null,'ReceiptY','Default',null,null,'ReceiptYear','受付年','新年招待会','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',3,'배부일련번호',80,null,null,'SN','Default',null,null,'AllocationSN','分配のシリアル番号','序列号的分配','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',4,'접수일자',120,null,null,'ReceiptD','Default',null,null,'ReceptionDate','受付日','日期的收据','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',5,'생산기관등록번호',150,null,null,'OrgDocNumCode','Default',null,null,'OrgDocNumCode','生産機関登録番号','生产管理局注册号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',6,'제목',200,null,null,'DocTitle','Default',null,null,'Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',7,'받은 처리과코드',120,null,null,'ManageDeptID','Default',null,null,'ManageDeptID','された処理とコード','接受治疗和代码','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',8,'받은 처리과명',150,null,null,'ManageDept','Default',null,null,'ManageDept','された処理科名','而接受治疗名','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',9,'배부일자',120,null,null,'DeliveryD','Default',null,null,'ReceiptDate','配付日時','分派日期','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',10,'인수자',120,null,null,'ChargeName','Default',null,null,'Charge Name','引受者','引受者','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물 대장',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',2,'등록구분',120,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.RegisterType','RegisterType','dtRegisterType','기록물 대장',null,'RegisterType','登録区分','招生区分','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',3,'등록일',100,'TBL_RECORD','TBL_RECORD.RegisterDate','RegisterDate','dtDateTime','기록물 대장',null,'RegisterDate','登録日','注册','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('001',4,'문서번호',80,'TBL_ENDAPRDOCINFO','TBL_ENDAPRDOCINFO.DOCNO', 'DispRegisterNo', 'Default', null, '기록물 대장', 'Doc. No.', '登録番号', '註冊號', 'Top', '0');
--INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('001', '4', '문서번호', '80', null, 'CONCAT(CONCAT((SELECT NVL(EXTENSIONATTRIBUTE6, DISPLAYNAME) FROM TBL_DEPTMASTER WHERE CN = TBL_RECORD.ProcessDeptCode AND TENANT_ID = TBL_RECORD.TENANT_ID), ''-''), SUBSTR(TBL_RECORD.RegisterNo, -2)) ', 'DispRegisterNo', 'Default', null, '기록물 대장', 'Doc. No.', '登録番号', '註冊號', 'Top', '0');
--INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',5,'첨부번호',55,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.SeperateAttachNo','SeperateAttachNo','Default','기록물 대장',null,'SepAttachNo','添付番号','附件编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',5,'제목',300,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','RecTitle','Default','기록물 대장',null,'Title','タイトル','标题','Top',0);
--INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',7,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(TBL_CABINET.ProcessDeptCode),''-''),TBL_CABINET.TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물 대장','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',6,'기록물철명',150,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','RecName','dtClassTitle','기록물 대장',null,'RecName','記録物名','档案名称','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',10,'시행번호',180,null,null,'SihangNo','dtSihangNO','기록물 대장',null,'SihangNo','施行番号','试行编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',9,'결재권자',80,'TBL_RECORD','TBL_RECORD.AprMemberTitle','AprMemberTitle','Default','기록물 대장',null,'Approval person','決裁権者','审批','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',7,'기안자',70,'TBL_RECORD','TBL_RECORD.DrafterName','DrafterName','Default','기록물 대장',null,'Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',8,'수신자(발신자)',90,'TBL_RECORD','TBL_RECORD.ReceiptMemberName','ReceiptName','Default','기록물 대장',null,'Recipient(Sender)','受信者（起案者）','受信者(送信者)','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',11,'첨부',40,'TBL_RECORD','TBL_RECORD.AttachFlag','AttachFlag','dtBool','기록물 대장','첨부여부','AttachFlag','添付','附件','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',13,'반려',40,'TBL_RECORD','TBL_RECORD.RejectFlag','RejectFlag','dtBool','기록물 대장','반려여부','RejectFlag','差し戻し','伴侣区分','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',12,'수신',40,'TBL_RECORD','CASE WHEN TBL_ENDAPRDOCINFO.DocType = ''003'' AND TBL_SEPERATEATTACH.RegisterType = ''1'' THEN ''발송'' ELSE ''없음'' END','ReSendFlag','Default','기록물 대장','수신문 발송여부','ReSendFlag','受信','接待区分','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물철 대장',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물철 대장','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 대장','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',4,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','기록물철 대장',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',5,'종료연도',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.ExpirationYear','EndYear','Default','기록물철 대장',null,'EndYear','終了年度','年退出','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',6,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','기록물철 대장',null,'STOCKED','備付','備付','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',7,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','기록물철 대장',null,'KEEPING PERIOD','保存期間','年龄','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',8,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','기록물철 대장',null,'CONSERVATION METHOD','保存方法','如何保存','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',9,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','기록물철 대장',null,'보존장소E','保存場所','保护区','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',10,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','기록물철 대장',null,'RegisterDate','登録日','注册','Top',0);
-- INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',11,'이관여부',60,null,'fGetCabTransStatus(TBL_CABINET.TransferFlag, 1) ','TransferFlag','Default','기록물철 대장','이관여부','TransferFlag','移管有無','无论是转移','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',11,'이관여부',60,null,'''미전송''','TransferFlag','Default','기록물철 대장','이관여부','TransferFlag','移管有無','无论是转移','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',12,'연기신청',60,null,'Case TransDelayFlag When ''1'' Then ''Y'' Else ''N'' End','DelayFlag','Default','기록물철 대장','이관연기여부','DelayFlag','延期申請','延期请求','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',1,'순번',30,null,null,'dtSerialNum','dtSerialNum','기록물 생상현황보고',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',2,'등록구분',110,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.RegisterType','RegisterType','dtRegisterType','기록물 생상현황보고',null,'RegisterType','登録区分','招生区分','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',3,'등록일',100,'TBL_RECORD','TBL_RECORD.RegisterDate','RegisterDate','dtDateTime','기록물 생상현황보고',null,'RegisterDate','登録日','注册','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',4,'문서번호',80,null,'CONCAT(CONCAT(TBL_RECORD.ProcessDeptName, ''-''), TRIM(LEADING''0'' FROM TBL_RECORD.RegisterNo))','DispRegisterNo','Default','기록물 생상현황보고',null,'Doc. No.','登録番号','註冊號','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',5,'첨부번호',55,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.SeperateAttachNo','SeperateAttachNo','Default','기록물 생상현황보고',null,'SepAttachNo','添付番号','附件编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',6,'제목',200,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','RecTitle','Default','기록물 생상현황보고',null,'Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',7,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(TBL_CABINET.ProcessDeptCode),''-''),TBL_CABINET.TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물 생상현황보고','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',8,'결재권자',80,'TBL_RECORD','TBL_RECORD.AprMemberTitle','AprMemberTitle','Default','기록물 생상현황보고',null,'Approval person','決裁権者','审批','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',9,'기안자',80,'TBL_RECORD','TBL_RECORD.DrafterName','DrafterName','Default','기록물 생상현황보고',null,'Drafter','起案者','起草人','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',10,'수신자(발신자)',90,'TBL_RECORD','TBL_RECORD.ReceiptMemberName','ReceiptName','Default','기록물 생상현황보고',null,'Recipient(Sender)','受信者（起案者）','受信者(送信者)','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',11,'첨부',40,'TBL_RECORD','TBL_RECORD.AttachFlag','AttachFlag','dtBool','기록물 생상현황보고','첨부여부','AttachFlag','添付','附件','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물철 생상현황보고',null,'No.','順番','序号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물철 생상현황보고','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 생상현황보고','제목','Title','タイトル','标题','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',4,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','기록물철 생상현황보고',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',5,'종료연도',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.ExpirationYear','EndYear','Default','기록물철 생상현황보고',null,'EndYear','終了年度','年退出','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',6,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','기록물철 생상현황보고',null,'STOCKED','備付','備付','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',7,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','기록물철 생상현황보고',null,'KEEPING PERIOD','保存期間','年龄','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',8,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','기록물철 생상현황보고',null,'CONSERVATION METHOD','保存方法','如何保存','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',9,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','기록물철 생상현황보고',null,'보존장소E','保存場所','保护区','Top',0);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',10,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','기록물철 생상현황보고',null,'RegisterDate','登録日','注册','Top',0);

INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','1','일반문서',1,'일반문서','기록물형태 코드(기록물철)','General Documents','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','2','도면류',1,'도면류',null,'Drawings kinds','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','3','사진/필름류',1,'사진/필름류',null,'Photo/Film kinds','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','4','녹음/동영상류',1,'녹음/동영상류',null,'Recording/Video kinds','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','5','카드류',1,'카드류',null,'Card kinds','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('001','1','원본과 보존매체 함께 보존',1,'원본과 보존매체 함께 보존','보존방법(기록물철)','Conservation and preservation of the original with the media','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('001','2','원본 폐기, 보존매체만 보존',1,'원본 폐기, 보존매체만 보존',null,'The original disposal, preservation bojonmaecheman','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('001','3','원본을 그대로 보존',1,'원본을 그대로 보존',null,'Preserving the original','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('002','1','자료관',1,'자료관','보존장소(기록물철)','Archives','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('002','2','전문관리기관',1,'전문관리기관',null,'Management agency specializing in','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','1','일반문서 생산/발송',1,'일반문서 생산/발송','등록구분(기록물)','General document production/shipment','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','2','일반문서 접수',1,'일반문서 접수',null,'General Documents received','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','3','도면류 생산/발송',1,'도면류 생산/발송',null,'Drawings kinds production/shipment','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','4','도면류 접수',1,'도면류 접수',null,'Drawings received','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','5','사진/필름류',1,'사진/필름류',null,'Photo/Film kinds','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','6','녹음/동영상류',1,'녹음/동영상류',null,'Recording/Video kinds','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','7','카드류 생산/접수',1,'카드류 생산/접수',null,'Card Kinds Production/Reception','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','8','카드류 이첩발송',1,'카드류 이첩발송',null,'Cards sent yicheop','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','01','1년',1,'1년','보존년한','1 year','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','03','3년',1,'3년',null,'3 years','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','05','5년',1,'5년',null,'5 years','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','10','10년',1,'10년',null,'10 years','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','20','30년',1,'30년',null,'30 years','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','30','준영구',1,'준영구',null,'Semi-permanence','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','40','영구',1,'영구',null,'Permanence','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','1','대통령관련 기록물',1,'대통령관련 기록물','특수기록물(기록물)','President Related Records','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','2','비밀기록물',1,'비밀기록물',null,'Confidential Records','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','3','개별관리 기록물',1,'개별관리 기록물',null,'Individual Management Records','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','4','저작권보호 기록물',1,'저작권보호 기록물',null,'Copyright Records','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','5','특수규격기록물',1,'특수규격기록물',null,'Documentary special specifications','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','1','1등급',1,'1등급','공개등급','1 Level','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','2','2등급',1,'2등급',null,'2 Level','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','3','3등급',1,'3등급',null,'3 Level','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','4','4등급',1,'4등급',null,'4 Level','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','5','5등급',1,'5등급',null,'5 Level','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','6','6등급',1,'6등급',null,'6 Level','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','7','7등급',1,'7등급',null,'7 Level','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','8','8등급',1,'8등급',null,'8 Level','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('007','1','채번 구분필드1',1,'채번 구분필드1 이용여부','회사단위 채번','채번 구분필드1','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('007','2','채번 구분필드2',1,'채번 구분필드2 이용여부','부서단위 채번','채번 구분필드2','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('007','3','채번 구분필드3',0,'채번 구분필드3 이용여부',null,'채번 구분필드3','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('007','4','채번 구분시간',1,'0: 이용하지 않음, 1:연도별 구분, 2: 월별 구분',null,'채번 구분시간','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DA','녹음테이프 카세트',1,'녹음테이프 카세트','녹음/동영상류 시청각 기록물 코드','Cassette tape recording of','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DB','녹음테이프 릴',1,'녹음테이프 릴',null,'Reel tape recording','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DC','녹음테이프 카트리지',1,'녹음테이프 카트리지',null,'Cartridge tape recording','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DD','DVD',1,'DVD',null,'DVD','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DF','음반 SP',1,'음반 SP',null,'Music SP','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DG','음반 LP',1,'음반 LP',null,'Music LP','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DH','음반 CD',1,'음반 CD',null,'Music CD','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DJ','음반 LD',1,'음반 LD',null,'Music LD','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DK','음반 DAT',1,'음반 DAT',null,'Music DAT','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DN','영화필름',1,'영화필름',null,'Movie Film','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DO','비디오 CD',1,'비디오 CD',null,'Video CD','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DP','비디오 LD',1,'비디오 LD',null,'Video LD','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DQ','비디오 테이프',1,'비디오 테이프',null,'Video tape','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CR','슬라이드 필름세트(영상)',1,'슬라이드 필름세트(영상)','사진/필름류 시청각 기록물 코드','A set of slides (pictures)','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CS','사진 CD',1,'사진 CD',null,'Photo CD','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CT','사진/필름',1,'사진/필름',null,'Photo / Film','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CU','인화된 사진',1,'인화된 사진',null,'Printed Photo','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CV','슬라이드사진(비영상)',1,'슬라이드사진(비영상)',null,'Slide photos (Non-imaging)','Top',0);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CY','그림',1,'그림',null,'Picture','Top',0);

INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDXS',		' ',							' ',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'INIT',						'문서 로딩시(기안, 접수기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'MIDDLE_SIGN_INIT',			'문서 로딩시(결재기)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'DOCNUM_BEFORE',			'문서번호 채번직전(모든화면최종결재시)',			'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'DOCNUM_AFTER',				'문서번호 채번직후(모든화면최종결재시)',			'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'DRAFTSAVE_BEFORE',			'기안상신직전(기안기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'DRAFTSAVE_AFTER',			'기안상신직후(기안기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'DOCNUM_END',				'최종결재직후(기안기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'MIDDLE_SIGN_BEFORE',		'중간결재자 사인직전(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'MIDDLE_SIGN_AFTER',		'중간결재자 사인직후(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'MIDDLE_END_AFTER',			'중간결재자 결재성공시(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'MIDDLE_END_FAIL',			'중간결재자 결재실패시(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'LAST_SIGN_BEFORE',			'최종결재자 사인직전(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'LAST_SIGN_AFTER',			'최종결재자 사인직후(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'END_FAIL',					'결재완료 실패시(모든화면 최종결재시)',			'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'SUSIN_DRAFTSAVE_BEFORE',	'접수문서 접수직전(접수기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'SUSIN_DRAFTSAVE_AFTER',	'접수문서 접수직후(접수기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'SUSIN_DOCNUM_END',			'접수문서 접수후(접수기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'LAST_SEND_BEFORE',			'최종결재직전(기안기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'LAST_END_AFTER',			'최종결재직후(수신문서접수기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'BANSONG_BEFORE',			'반송직전(결재기)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'BANSONG_AFTER',			'반송성공시(결재기)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSIDX',			'BANSONG_FAIL',				'반송실패시(결재기)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSTIMES',		' ',							' ',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSTIME',		'DRAFT',					'기안결재시 호출(기안문)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSTIME',		'REDRAFT',					'재기안시 호출(재기안시기안기에서)',			'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSTIME',		'SUSIN',					'수신문서상태 호출(수신문)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSTIME',		'HAPYUI',					'합의문서상태 호출(합의문)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSTIME',		'CHAMJO',					'참조문서상태 호출(미구현)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSTIME',		'GONGRAM',					'공람문서상태 호출(미구현)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSTIME',		'GAMSA',					'사후감사문서상태 호출(미구현)',				'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'PROCESSTIME',		'B_GAMSA',					'사전감사문서상태 호출(미구현)',				'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'CONNSTRINGFLAGS',	' ',							' ',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'CONNSTRINGFLAG',		'CS',						'커넥션 정보(없으면 자동)',					'CONNSTRINGFLAGS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'CONNSTRINGFLAG',		'UI',						'화면 다이얼로그 정보',						'CONNSTRINGFLAGS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'QUERYTYPES',			' ',							' ',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'QUERYTYPE',			'Q',						'쿼리 실행',							'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'QUERYTYPE',			'NA',						'UI가 없는 aspx',						'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'QUERYTYPE',			'UA',						'UI가 있는 aspx(xml String을 전달)',		'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'QUERYTYPE',			'UA_EX',					'UI가 있는 aspx(xml Document를 전달)',	'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'KEYKINDS',			' ',							' ',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'KEYKIND',			'single',					'필드개체',							'KEYKINDS');
INSERT INTO TBL_FORMCONNINFO (SN, CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES (SEQ_TBL_FORMCONNINFO.nextval, 'KEYKIND',			'table',					'테이블지원(미구현)',						'KEYKINDS');

--resource insert

Insert into TBL_RS_BRD (BRD_ID,BRD_COMPANY,BRD_NM,BRD_NM2,BRD_GROUP,BRD_GB,BRD_REF,BRD_LEVEL,BRD_STEP,BRD_POSTTERM,BRD_EXPLAIN,BRD_ACCESS,BRD_UPPER,BRD_COUNT,BRD_URL,ATTACH_SIZE,REPLY_MAIL_FG,OWNDEPTID,OWNDEPTNM,OWNDEPTNM2,OWNERID,OWNERNM,OWNERNM2,OWNERPOSITION,OWNERPOSITION2,OWNERCALL,MAKEDATE,RESLOCATION,BRD_UPPER2,APPROVEFLAG,TENANT_ID) values (1,'Top','조직도','OrganizationChart','A00','1',0,0,1,365,'',null,0,0,' ',20,null,null,null,null,null,null,null,null,null,null,null,null,null,'0',0);

--car insert
Insert into TBL_CAR (CAR_ID, CAR_NAME, CAR_NAME2, CAR_NM, CAR_GB, CAR_LEVEL, CAR_STEP, CAR_ACCESS, CAR_UPPER, OWNDEPTID, OWNDEPTNM, OWNDEPTNM2,OWNERID, OWNERNM, OWNERNM2, OWNERPOSITION, OWNERPOSITION2, OWNERCALL, CAR_REGISTER_DATE, DELFLAG, COMPANYID, TENANT_ID, CAR_URL, CAR_EXPLAIN)  values (1,'Top','조직도','OrganizationChart',1,0,1,null,0,null,null,null,null,null,null,null,null,null,null,0,'Top',0,null,null);

--portal insert

Insert into TBL_BUILTIN_PARAMETERS (PARAMTYPE,PARAMINFO,DESCRIPTION,SHORTNAME,TENANT_ID) values (0,'HardCoding','지정된 값을 넘겨줍니다','t4086',0);
Insert into TBL_BUILTIN_PARAMETERS (PARAMTYPE,PARAMINFO,DESCRIPTION,SHORTNAME,TENANT_ID) values (1,'USERID','자동으로 사용자 아이디를 넘긴다','t4087',0);
Insert into TBL_BUILTIN_PARAMETERS (PARAMTYPE,PARAMINFO,DESCRIPTION,SHORTNAME,TENANT_ID) values (2,'BASICAUTH','암호화된 기본인증 헤더를 넘긴다','t4088',0);
Insert into TBL_BUILTIN_PARAMETERS (PARAMTYPE,PARAMINFO,DESCRIPTION,SHORTNAME,TENANT_ID) values (3,'DEPTID','자동으로 사용자 부서코드를 넘긴다','t4089',0);
Insert into TBL_BUILTIN_PARAMETERS (PARAMTYPE,PARAMINFO,DESCRIPTION,SHORTNAME,TENANT_ID) values (4,'COMPANYID','자동으로 사용자 회사코드를 넘긴다','t4090',0);
Insert into TBL_BUILTIN_PARAMETERS (PARAMTYPE,PARAMINFO,DESCRIPTION,SHORTNAME,TENANT_ID) values (5,'TITLE','자동으로 사용자 직급을 넘긴다','t4091',0);
Insert into TBL_BUILTIN_PARAMETERS (PARAMTYPE,PARAMINFO,DESCRIPTION,SHORTNAME,TENANT_ID) values (6,'ROLLINFO','자동으로 사용자 권한정보를 넘긴다','t4092',0);

Insert into TBL_MENUITEM_GENERAL (UID_,DISPLAYNAME,TYPE,URL,TENANT_ID) values ('201','t4079',1,null,0);
Insert into TBL_MENUITEM_GENERAL (UID_,DISPLAYNAME,TYPE,URL,TENANT_ID) values ('202','t4080',2,null,0);
Insert into TBL_MENUITEM_GENERAL (UID_,DISPLAYNAME,TYPE,URL,TENANT_ID) values ('203','t4081',3,null,0);
Insert into TBL_MENUITEM_GENERAL (UID_,DISPLAYNAME,TYPE,URL,TENANT_ID) values ('204','t4082',4,null,0);
Insert into TBL_MENUITEM_GENERAL (UID_,DISPLAYNAME,TYPE,URL,TENANT_ID) values ('205','t4083',5,null,0);
Insert into TBL_MENUITEM_GENERAL (UID_,DISPLAYNAME,TYPE,URL,TENANT_ID) values ('206','t4084',6,null,0);
Insert into TBL_MENUITEM_GENERAL (UID_,DISPLAYNAME,TYPE,URL,TENANT_ID) values ('207','t4085',7,null,0);

Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('586258b4-f2ac-4416-b9ec-328132df65d0','d4dcceee-01f5-42da-9093-a243d3056204',1,'메일',null,'2','/files/upload_portal/Top/Menu/top_menu02(5).gif','/files/upload_portal/Top/Menu/top_menu02o(3).gif',99,33,'/ezEmail/mailMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('2d13f9fc-51c1-4dfe-bfa3-d0bed6a22918','d4dcceee-01f5-42da-9093-a243d3056204',1,'게시판',null,'2','/files/upload_portal/Top/Menu/top_menu05(4).gif','/files/upload_portal/Top/Menu/top_menu05o(4).gif',101,33,'/ezBoard/boardMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('388f0b77-9c53-42d5-b860-7eb1e74db215','b0a4e923-d270-4353-9e81-e86c14424262',1,'PIMS',null,'2','/files/upload_portal/Top/Menu/top_menu03(5).gif','/files/upload_portal/Top/Menu/top_menu03o(9).gif',118,33,'/ezSchedule/scheduleIndex.do?funCode=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('46418adc-1f61-4e30-b8f8-53faebaf83b4','b0a4e923-d270-4353-9e81-e86c14424262',1,'메일',null,'2','/files/upload_portal/Top/Menu/top_menu02(3).gif','/files/upload_portal/Top/Menu/top_menu02o(1).gif',102,33,'/ezEmail/mailMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('1ab34e97-4c6b-4249-a80a-4c4214486b95','b0a4e923-d270-4353-9e81-e86c14424262',1,'전자결재',null,'2','/files/upload_portal/Top/Menu/top_menu04(3).gif','/files/upload_portal/Top/Menu/top_menu04o(2).gif',120,33,'/ezApprovalG/apprGMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('1db3cf2c-742e-4958-8f9f-557bb08aec75','F3633607-8E8B-42A1-B777-6E2969072E58',1,'로고아이템','LogoItem',null,'/files/upload_portal/Top/Logo/logo.gif',null,106,42,' ',' ',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('4d8d47b5-7257-4f4e-b70b-d63e09e32299','d4dcceee-01f5-42da-9093-a243d3056204',1,'전자결재',null,'2','/files/upload_portal/Top/Menu/top_menu04(7).gif','/files/upload_portal/Top/Menu/top_menu04o(6).gif',115,33,'/ezApproval/apprMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('55500da7-0de3-4e2c-8acc-e52cbd8bbee8','F3633607-8E8B-42A1-B777-6E2969072E58',1,'자원관리',null,'2','/files/upload_portal/Top/Menu/top_menu06.gif','/files/upload_portal/Top/Menu/top_menu06o.gif',121,33,'/ezResource/resMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('d351b126-4e3a-486c-ab85-ef78738abead','d4dcceee-01f5-42da-9093-a243d3056204',1,'자원관리',null,'2','/files/upload_portal/Top/Menu/top_menu06(2).gif','/files/upload_portal/Top/Menu/top_menu06o(2).gif',114,33,'/ezResource/resMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('d6237135-c331-4fff-92c0-2cd0584347a4','d4dcceee-01f5-42da-9093-a243d3056204',1,'홈',null,'2','/files/upload_portal/Top/Menu/top_menu01(3).gif','/files/upload_portal/Top/Menu/top_menu01o(4).gif',95,33,'/ezPortal/myPortal.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('d7e86d24-137e-4934-bf70-87fed28f5530','F3633607-8E8B-42A1-B777-6E2969072E58',1,'홈',null,'2','/files/upload_portal/Top/Menu/top_menu01.gif','/files/upload_portal/Top/Menu/top_menu01o.gif',86,33,'/ezPortal/myPortal.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('e45ac7ba-496d-47fa-a711-db8bb16fd95a','F3633607-8E8B-42A1-B777-6E2969072E58',1,'게시판',null,'2','/files/upload_portal/Top/Menu/top_menu05.gif','/files/upload_portal/Top/Menu/top_menu05o.gif',110,33,'/ezBoard/boardMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('e58fec85-1180-43dc-bbcf-002d86019057','d4dcceee-01f5-42da-9093-a243d3056204',1,'전자결재',null,'2','/files/upload_portal/Top/Menu/top_menu04(8).gif','/files/upload_portal/Top/Menu/top_menu04o(7).gif',115,33,'/ezApprovalG/apprGMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('e6f32470-e5ea-4e38-9d3d-337d41fedccd','b0a4e923-d270-4353-9e81-e86c14424262',1,'게시판',null,'2','/files/upload_portal/Top/Menu/top_menu05(3).gif','/files/upload_portal/Top/Menu/top_menu05o(3).gif',108,33,'/ezBoard/boardMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('ecb5c796-bfce-46a0-9c42-801eca04b31b','d4dcceee-01f5-42da-9093-a243d3056204',1,'PIMS',null,'2','/files/upload_portal/Top/Menu/top_menu03(7).gif','/files/upload_portal/Top/Menu/top_menu03o(11).gif',114,33,'/ezSchedule/scheduleIndex.do?funCode=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('9da456ad-190e-4ebe-9411-05fd19514278','F3633607-8E8B-42A1-B777-6E2969072E58',1,'전자결재',null,'2','/files/upload_portal/Top/Menu/top_menu04.gif','/files/upload_portal/Top/Menu/top_menu04o.gif',123,33,'/ezApproval/apprMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('9dcb873f-4254-45b2-87f2-1e326a63db78','d4dcceee-01f5-42da-9093-a243d3056204',1,'커뮤니티',null,'2','/files/upload_portal/Top/Menu/top_menu09(18).gif','/files/upload_portal/Top/Menu/top_menu09o(23).gif',127,33,'/ezCommunity/communityMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('a2c52ee7-4e41-493d-8d58-bb26e00d52c1','F3633607-8E8B-42A1-B777-6E2969072E58',1,'전자결재',null,'2','/files/upload_portal/Top/Menu/top_menu04(1).gif','/files/upload_portal/Top/Menu/top_menu04o(1).gif',123,33,'/ezApprovalG/apprGMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('80e37141-1c98-40b4-a7dc-8298e1abdce0','F3633607-8E8B-42A1-B777-6E2969072E58',1,'커뮤니티',null,'2','/files/upload_portal/Top/Menu/top_menu09(16).gif','/files/upload_portal/Top/Menu/top_menu09o(21).gif',105,33,'/ezCommunity/communityMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('856c0213-ae8a-40be-ade0-63ab865fa1fd','b0a4e923-d270-4353-9e81-e86c14424262',1,'로고아이템','LogoItem',null,'/files/upload_portal/Top/Logo/logo(1).gif',null,106,42,' ',' ',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('8ac377c8-e8e6-463d-a44f-e6a47202b45f','b0a4e923-d270-4353-9e81-e86c14424262',1,'홈',null,'2','/files/upload_portal/Top/Menu/top_menu01(1).gif','/files/upload_portal/Top/Menu/top_menu01o(2).gif',105,33,'/ezPortal/myPortal.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('8f89f7ea-cc5b-43f6-a522-d57f584fe3f7','b0a4e923-d270-4353-9e81-e86c14424262',1,'전자결재',null,'2','/files/upload_portal/Top/Menu/top_menu04(6).gif','/files/upload_portal/Top/Menu/top_menu04o(5).gif',120,33,'/ezApproval/apprMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('ac5d2eca-a340-42dc-95ae-1a4c42ff7885','b0a4e923-d270-4353-9e81-e86c14424262',1,'커뮤니티',null,'2','/files/upload_portal/Top/Menu/top_menu09(17).gif','/files/upload_portal/Top/Menu/top_menu09o(22).gif',143,33,'/ezCommunity/communityMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('b56c7f48-99dc-4145-81ea-80e1d6f9db8d','F3633607-8E8B-42A1-B777-6E2969072E58',1,'메일',null,'2','/files/upload_portal/Top/Menu/top_menu02.gif','/files/upload_portal/Top/Menu/top_menu02o.gif',94,33,'/ezEmail/mailMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('bf71381c-4e0e-415a-82aa-dfcc1f0b4c7d','b0a4e923-d270-4353-9e81-e86c14424262',1,'자원관리',null,'2','/files/upload_portal/Top/Menu/top_menu06(1).gif','/files/upload_portal/Top/Menu/top_menu06o(1).gif',125,33,'/ezResource/resMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('c2f44b2e-41f0-48c2-a7ea-607a58a0dd80','d4dcceee-01f5-42da-9093-a243d3056204',1,'로고아이템','LogoItem',null,'/files/upload_portal/Top/Logo/logo(5).gif',null,106,42,' ',' ',' ',0);
Insert into TBL_MENUITEM_ITEMS_IMAGE (UID_,OWNERPAGEID,SKINNUM,DISPLAYNAME,DISPLAYNAME2,IMAGETYPE,NORMALIMAGEPATH,OVERIMAGEPATH,IMAGEWIDTH,IMAGEHEIGHT,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('c76829c2-94a9-48e5-b281-c4a8df65afcb','F3633607-8E8B-42A1-B777-6E2969072E58',1,'일정관리',null,'2','/files/upload_portal/Top/Menu/top_menu03(4).gif','/files/upload_portal/Top/Menu/top_menu03o(8).gif',115,33,'/ezSchedule/scheduleIndex.do?funCode=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_LOGOS (UID_,OWNERPAGEID,TENANT_ID) values ('1db3cf2c-742e-4958-8f9f-557bb08aec75','F3633607-8E8B-42A1-B777-6E2969072E58',0);
Insert into TBL_MENUITEM_ITEMS_LOGOS (UID_,OWNERPAGEID,TENANT_ID) values ('856c0213-ae8a-40be-ade0-63ab865fa1fd','b0a4e923-d270-4353-9e81-e86c14424262',0);
Insert into TBL_MENUITEM_ITEMS_LOGOS (UID_,OWNERPAGEID,TENANT_ID) values ('c2f44b2e-41f0-48c2-a7ea-607a58a0dd80','d4dcceee-01f5-42da-9093-a243d3056204',0);

Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('4c74feab-07b1-4234-aef0-52c82983547f','204','f932a0fe-a62b-4be0-bcfd-52e27c9c3ca5','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('4e9e1389-9e52-4896-8f40-1dd5a6bf59e9','202',null,'F3633607-8E8B-42A1-B777-6E2969072E58','환경설정','eng_환경설정',null,3,null,'/ezPortal/environmentMain.do','main',null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('53e846f4-3946-4614-a146-2866c14940dc','203',null,'d4dcceee-01f5-42da-9093-a243d3056204','홈','HOME',null,1,'d6237135-c331-4fff-92c0-2cd0584347a4','/ezPortal/myPortal.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('55b6ee75-bdbd-4690-821e-9e41ee14603c','203',null,'d4dcceee-01f5-42da-9093-a243d3056204','전자결재','전자결재',null,10,'e58fec85-1180-43dc-bbcf-002d86019057','/ezApprovalG/apprGMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('5aa98062-f4be-4245-9659-94a0d526a9a3','204','cc9b12f3-85b5-40c2-8f90-5db1b543d9a1','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('5b61e8f2-f226-48d8-b94e-bc545a909c9e','204','53e846f4-3946-4614-a146-2866c14940dc','d4dcceee-01f5-42da-9093-a243d3056204',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('5b6e9111-4b55-473b-ac39-22acb6ff7d16','204','c509b9ce-a545-4bde-bc38-77786cd87c41','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('5e665934-a497-4757-aed9-0502369b5ed1','204','7ad2f4ee-5fd8-4c72-bd39-40f889c07e37','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('5f2b7286-5a1e-4f7b-8dff-ddbe41fba8c7','204','c4736cf0-6cf0-42f1-979d-20678b68d171','d4dcceee-01f5-42da-9093-a243d3056204',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('654c49f3-ea51-4e09-a4f8-396d767733b3','204','4c66937f-83ee-45ea-9f0b-cada9d179280','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('68924dd0-5369-41ce-9a5c-c6a8ae9cb22a','204','0ad5cb7c-a4b9-46d5-a7c7-6ff05bd46d5b','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('284127a1-adb4-4ce5-be48-00ed37100d38','204','f5c278f0-b62d-4437-8b08-1a81c2410497','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('28e8af74-de0c-4e3e-a392-0e63ff623981','202',null,'d4dcceee-01f5-42da-9093-a243d3056204','設定','設定',null,3,null,'/ezPortal/environmentMain.do','main',null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('2ceeaab8-3ec5-47fd-87ff-6e9b684b0594','204','4d0e8144-011d-4483-ac42-43c179b9dc87','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('2e1803bc-9df3-412a-98ae-045fa345ed98','203',null,'b0a4e923-d270-4353-9e81-e86c14424262','메일','메일',null,2,'46418adc-1f61-4e30-b8f8-53faebaf83b4','/ezEmail/mailMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('2f9e65ff-b89b-4089-819c-8a1dd13561ae','202',null,'d4dcceee-01f5-42da-9093-a243d3056204','ヘルプ','ヘルプ',null,4,null,'/ezPortal/help/help.do','helpWindow',null,'height=700px,width=1000px, status = no, toolbar=no, menubar=no, location=no, resizable=0',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('30e786cb-d358-4335-b0b1-234eca27d56c','204','8a485e8a-9162-479d-a21a-fda9585e0e3e','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('7acbc603-5383-4da4-ae14-523112a5c167','203',null,'b0a4e923-d270-4353-9e81-e86c14424262','전자결재','전자결재',null,4,'8f89f7ea-cc5b-43f6-a522-d57f584fe3f7','/ezApproval/apprMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('0258f59a-2478-48cd-8145-0323bedc2cb7','204','49e1b202-c2ae-4a4d-980a-29239b3e6e14','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('0260dc48-e5b6-477b-9a15-3ad6a9b31dd0','202',null,'F3633607-8E8B-42A1-B777-6E2969072E58','로그아웃','eng_로그아웃',null,5,null,'/user/login/actionLogout.do','top',null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('04bc1910-6e80-4904-9da2-e6c86eccc366','203',null,'d4dcceee-01f5-42da-9093-a243d3056204','메일','메일',null,2,'586258b4-f2ac-4416-b9ec-328132df65d0','/ezEmail/mailMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('07350485-7e46-4dc6-a8ec-1d6ca89ac7ed','202',null,'d4dcceee-01f5-42da-9093-a243d3056204','管理者','管理者',null,1,null,'/admin/main.do',null,null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('08eb7695-3b27-4003-b5c4-eea1a99bbd05','202',null,'b0a4e923-d270-4353-9e81-e86c14424262','Administrator','Administrator',null,1,null,'/admin/main.do',null,null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('09e1d12c-5ffd-4240-8791-020431a5c47b','203',null,'F3633607-8E8B-42A1-B777-6E2969072E58','메일','메일',null,2,'b56c7f48-99dc-4145-81ea-80e1d6f9db8d','/ezEmail/mailMain.do','main',null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('0e5a0f4a-9f85-4fe7-bb26-ee0dcceda821','204','7431401e-6b06-4363-ba5b-fc7026757d63','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('0f3de424-a078-4165-87d5-4fd21534803c','202',null,'F3633607-8E8B-42A1-B777-6E2969072E58','관리자','eng_관리자',null,1,null,'/admin/main.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('0f75caac-ed19-47be-bab1-9240c09ccfcc','204','ef6672bd-e78e-4889-b7c0-edff98814f2c','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('11f6ac57-a9bf-4373-bb54-da94d71f957f','204','f31e5262-c633-4f0d-ac95-817843fc5f38','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('134c1c56-02c1-4159-a067-b2a495d969e0','204','4100d63f-5203-49f3-bf0e-22a6a4e437d1','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('155f4e89-c405-4e5b-9391-97c7d3dc0dcd','204','62ef609e-ab67-4b30-bde9-0412c3378290','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('1cd70cfa-44ad-4e43-98dd-ed07c659b4b7','204','03b0ee1d-8cd7-4e73-afe4-4696a6662922','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','203',null,'F3633607-8E8B-42A1-B777-6E2969072E58','게시판','게시판',null,5,'e45ac7ba-496d-47fa-a711-db8bb16fd95a','/ezBoard/boardMain.do','main',null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('1f07c057-1fa1-4e35-a51f-2c3aa99f3c0c','204','1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('1f3ab4e9-787e-41f5-a691-6b1e0e52380b','204','ac7b2e1b-71b2-4c46-b544-66468bfaf2f9','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('1f613cb1-a2f6-4f73-8b89-f0511cd2f911','203',null,'b0a4e923-d270-4353-9e81-e86c14424262','게시판','게시판',null,5,'e6f32470-e5ea-4e38-9d3d-337d41fedccd','/ezBoard/boardMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('37e4a9c1-a923-4ba6-9f08-2757cf4d4693','202',null,'F3633607-8E8B-42A1-B777-6E2969072E58','직원조회','eng_직원조회',null,2,null,'/ezPersonal/personSearch.do',' ',null,'height=560px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('404591f7-fae8-452b-bb20-31b78d189325','204','55b6ee75-bdbd-4690-821e-9e41ee14603c','d4dcceee-01f5-42da-9093-a243d3056204',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('4330099a-4889-497b-ac76-912fc6e10994','203',null,'b0a4e923-d270-4353-9e81-e86c14424262','커뮤니티','커뮤니티en',null,6,'ac5d2eca-a340-42dc-95ae-1a4c42ff7885','/ezCommunity/communityMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('43bd6bc5-808b-4a2f-b0a9-da4abf1bb7b2','202',null,'d4dcceee-01f5-42da-9093-a243d3056204','ログアウト','ログアウト',null,5,null,'/user/login/actionLogout.do','top',null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('f17d98c7-6331-428d-9d4e-421312eec8ee','203',null,'d4dcceee-01f5-42da-9093-a243d3056204','자원관리','자원관리',null,9,'d351b126-4e3a-486c-ab85-ef78738abead','/ezResource/resMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('f5c278f0-b62d-4437-8b08-1a81c2410497','203',null,'F3633607-8E8B-42A1-B777-6E2969072E58','커뮤니티','커뮤니티en',null,6,'80e37141-1c98-40b4-a7dc-8298e1abdce0','/ezCommunity/communityMain.do','main',null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('f805822c-f0da-4911-89dc-c71aa2c3bb62','204','89c88f6b-b68e-45a8-9a2b-58817f6d6cab','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('6a1ea8aa-cceb-4928-bba1-076a73b62223','204','7acbc603-5383-4da4-ae14-523112a5c167','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('6cdb78b7-ae72-48ce-990f-5c0f6838fbbc','203',null,'F3633607-8E8B-42A1-B777-6E2969072E58','일정관리','Schedule',null,3,'c76829c2-94a9-48e5-b281-c4a8df65afcb','/ezSchedule/scheduleIndex.do?funCode=2','main',null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('6db81dc5-e8ba-49c8-b625-df4fd375a43a','203',null,'F3633607-8E8B-42A1-B777-6E2969072E58','자원관리','자원관리',null,7,'55500da7-0de3-4e2c-8acc-e52cbd8bbee8','/ezResource/resMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('70fd0c61-af80-4f22-bf6e-d17d3f666bf9','202',null,'b0a4e923-d270-4353-9e81-e86c14424262','Help','Help',null,4,null,'/ezPortal/help/help.do','helpWindow',null,'height=700px,width=1000px, status = no, toolbar=no, menubar=no, location=no, resizable=0',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('723443ed-b168-45db-9176-fb1aa3de0513','204','6cdb78b7-ae72-48ce-990f-5c0f6838fbbc','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('72bcbef1-6b4c-41ec-b884-9762c21e4dcb','204','c4cb8eef-6f1c-4c7b-b8cb-de1cd5196da9','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('73bf6744-6693-4142-ae0e-8570f13c5c69','204','52bd442b-58c4-4f2e-aadf-3cf6264631a5','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('73fc6012-c812-4a54-bdc1-0bc580f837a4','203',null,'b0a4e923-d270-4353-9e81-e86c14424262','Schedule','Schedule',null,3,'388f0b77-9c53-42d5-b860-7eb1e74db215','/ezSchedule/scheduleIndex.do?funCode=2',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('74220b1f-342a-441d-b7e2-a644ec208db0','204','f96d5cd6-17f3-4765-9657-f1d18475ba4b','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('78940244-839d-46af-ba00-463bc4648b80','204','f78914fe-351f-473b-87da-ed967bce5060','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('fb438703-6026-44f8-8878-84c2a206e3b3','204','64f696d4-4b57-445a-aadf-1e171ae7bcb8','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('63d37f4d-967e-4182-84ab-b26b7c351c71','204','a912118a-f4e7-4917-8547-71e8149fdb9d','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('b11d5737-e06c-4387-bcd0-7792b6053b0d','204','4a213121-bb22-4d43-81df-982e1ba07be2','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('d1dbcb93-cce0-4311-a202-6effcdcf0358','204','a52e3c9c-171e-44aa-b540-b4311f357b55','d4dcceee-01f5-42da-9093-a243d3056204',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('d2cb8420-4efe-4b56-986e-69a4a2c20814','204','8e35e3f1-ec52-4ee4-8638-af25a8737da7','d4dcceee-01f5-42da-9093-a243d3056204',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('d6de0e54-85fe-45a0-b9f1-52564900961e','204','04bc1910-6e80-4904-9da2-e6c86eccc366','d4dcceee-01f5-42da-9093-a243d3056204',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('d780c364-c267-4302-bef5-3fba95b06619','204','73fc6012-c812-4a54-bdc1-0bc580f837a4','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('ea075496-9065-4f2a-b9f0-f8181ca1928d','202',null,'F3633607-8E8B-42A1-B777-6E2969072E58','도움말','eng_도움말',null,4,null,'/ezPortal/help/help.do','helpWindow',null,'height=700px,width=1000px, status = no, toolbar=no, menubar=no, location=no, resizable=0',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('ec86804a-415b-41b9-97fc-164e7876a14e','204','cf34747c-d809-461d-93d9-e50486ae3b68','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('94ef77fe-04fd-434a-8508-7fba98631bb8','203',null,'d4dcceee-01f5-42da-9093-a243d3056204','게시판','게시판',null,5,'2d13f9fc-51c1-4dfe-bfa3-d0bed6a22918','/ezBoard/boardMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('9770dc92-5da3-48aa-a674-dfeaefb4a7ec','204','1294c930-12b3-4fa7-9c53-86fb0261589a','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('98c8d196-a0c8-4767-b641-69e0c2020150','204','d00d04fb-3d8f-466c-9f0f-7fc974954c1c','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('9a434395-e198-4aa1-a424-74d035b5128e','204','5cf0b82b-dd98-4d68-b6e2-fc54eb1e950f','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('9ab26aa1-a70f-40e5-b22f-e1994d01897b','204','0e3e00ce-6046-4883-9afd-5b394d02e423','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('9b2a3574-b823-4956-83b2-2f671f90a547','204','b39f97e9-4272-45d2-bcda-2ceb6d6e46d0','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('9eb0fd34-725e-47ed-93e4-06e06a66dd92','202',null,'b0a4e923-d270-4353-9e81-e86c14424262','Logout','Logout',null,5,null,'/user/login/actionLogout.do','top',null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('9f190819-a7f1-4742-8ad3-0be1a75cb0db','204','94ef77fe-04fd-434a-8508-7fba98631bb8','d4dcceee-01f5-42da-9093-a243d3056204',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('9fbb793a-565d-4a42-ad88-2f3df5c87616','204','f17d98c7-6331-428d-9d4e-421312eec8ee','d4dcceee-01f5-42da-9093-a243d3056204',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('a20f58e8-6df9-4ec4-9a86-f08afee5bbe1','204','2e1803bc-9df3-412a-98ae-045fa345ed98','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('a52e3c9c-171e-44aa-b540-b4311f357b55','203',null,'d4dcceee-01f5-42da-9093-a243d3056204','전자결재','전자결재',null,4,'4d8d47b5-7257-4f4e-b70b-d63e09e32299','/ezApproval/apprMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('69b6d233-c50d-4b38-bb50-5bf51c02c35b','202',null,'b0a4e923-d270-4353-9e81-e86c14424262','Organization ','Organization ',null,2,null,'/ezPersonal/personSearch.do',null,null,'height=560px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('69edeceb-c945-41bd-861f-987814fcc2a4','204','193e8246-8215-4680-9fc0-3f7a5c13e12c','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('7dd03f77-b6ac-4e1e-918d-a4354fa25608','204','7fde32ad-5e48-4357-b24c-5f2594919b88','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('7f942e44-bc4d-42d5-bb51-30f7eee96525','204','6260bacb-398a-4391-8871-fd80142981bf','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('7fde32ad-5e48-4357-b24c-5f2594919b88','203',null,'b0a4e923-d270-4353-9e81-e86c14424262','홈','HOME',null,1,'8ac377c8-e8e6-463d-a44f-e6a47202b45f','/ezPortal/myPortal.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('8139c1a3-eb8b-4cf9-8c5a-a1bde7078a09','204','1f613cb1-a2f6-4f73-8b89-f0511cd2f911','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('821d9667-737e-4666-84c3-09ab96a545dd','204','6db81dc5-e8ba-49c8-b625-df4fd375a43a','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('841cc601-4327-459d-9a81-87347e0283c6','204','4330099a-4889-497b-ac76-912fc6e10994','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('87c4bcf7-ac7f-455a-8ad7-a1698ccc3e7e','204','b8d8195c-c484-4409-a9bd-89e93d76e262','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('887ef24b-a0f6-438b-a3e6-032c4b9c580b','204','68be0f39-94ad-4b46-8ff5-304bdfddb47a','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('8e35e3f1-ec52-4ee4-8638-af25a8737da7','203',null,'d4dcceee-01f5-42da-9093-a243d3056204','일정관리','Schedule',null,3,'ecb5c796-bfce-46a0-9c42-801eca04b31b','/ezSchedule/scheduleIndex.do?funCode=2',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('902628a5-92a6-4622-96fe-a8ed2ebf6bb0','204','517efcdf-3e2d-4588-ba6f-14eebeee48d9','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('a56082ad-9136-43a7-9749-c867f1f5529e','202',null,'d4dcceee-01f5-42da-9093-a243d3056204','組織','組織',null,2,null,'/ezPersonal/personSearch.do',null,null,'height=560px,width=750px, status = no, toolbar=no, menubar=no,location=no, resizable=0',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('a889fc9d-13e5-4656-874b-cfb58c989007','204','109faf7e-faf4-464f-8206-c19a3880a206','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('ac53a787-6411-4b12-9528-e7a9178e4f7d','204','763e71e3-4d56-4ecb-bfb0-6f8b743f4601','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('b39f97e9-4272-45d2-bcda-2ceb6d6e46d0','203',null,'F3633607-8E8B-42A1-B777-6E2969072E58','전자결재','전자결재',null,4,'a2c52ee7-4e41-493d-8d58-bb26e00d52c1','/ezApprovalG/apprGMain.do','main',null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('bc70e84c-1ae0-4e2a-9e7a-e8dbfaf09719','204','062d1b08-991f-414b-80b2-406312da7095','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('c2fd093d-7923-4262-8a18-1fb3b47a99d1','204','09e1d12c-5ffd-4240-8791-020431a5c47b','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,100,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('c4736cf0-6cf0-42f1-979d-20678b68d171','203',null,'d4dcceee-01f5-42da-9093-a243d3056204','커뮤니티','커뮤니티',null,6,'9dcb873f-4254-45b2-87f2-1e326a63db78','/ezCommunity/communityMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('cc9b12f3-85b5-40c2-8f90-5db1b543d9a1','203',null,'b0a4e923-d270-4353-9e81-e86c14424262','자원관리','자원관리',null,9,'bf71381c-4e0e-415a-82aa-dfcc1f0b4c7d','/ezResource/resMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('cf34747c-d809-461d-93d9-e50486ae3b68','203',null,'F3633607-8E8B-42A1-B777-6E2969072E58','홈','HOME',null,1,'d7e86d24-137e-4934-bf70-87fed28f5530','/ezPortal/myPortal.do','main',null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('d00d04fb-3d8f-466c-9f0f-7fc974954c1c','203',null,'b0a4e923-d270-4353-9e81-e86c14424262','전자결재','전자결재',null,10,'1ab34e97-4c6b-4249-a80a-4c4214486b95','/ezApprovalG/apprGMain.do',null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('edabe052-f573-4377-ad95-7743f9093151','202',null,'b0a4e923-d270-4353-9e81-e86c14424262','Configuration','Configuration',null,3,null,'/ezPortal/environmentMain.do','main',null,' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('edc0803a-5e67-443a-bc8b-9659e39f87cf','204','0fbe027c-9241-4922-bf97-cc6d10e402c9','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('f9da0e32-1ef0-440a-9796-d061c802a112','204','e254ef6f-d602-4d40-8e39-b44177a8737c','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('6f321dd7-9626-4962-ac76-af4ef759824f','204','2016a429-cb39-4653-b92c-c9595c12acec','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('9440231a-414b-4133-8fef-8859375b542a','204','8593cc87-7630-420b-a6d5-f7a8577c5a31','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('dc2ee231-aedf-4cae-9741-155ddf055475','204','8e9ebb41-5631-4c6f-9887-ec824464bce3','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('e14fa5b9-acdd-494f-9c69-7e1c924898d0','204','f6f7ecd7-1969-4025-9bcc-bbc181e41073','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('ff61d3fe-8d14-4752-8cd7-b40eb64611e9','204','ce2fd9b5-3934-4cba-b13f-a32d36a5d63a','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('38f17c9a-292c-41fc-bbe4-d767e42f2e27','204','56b67047-d14a-46fa-aebb-6e95041a8929','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('e18e476b-9dd7-47d8-8be4-0e3d3ba496e4','204','8eef9794-1eeb-4f8d-9aa3-9c6b1126540e','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('19fe8ed4-6be5-4ccc-a1c5-3dd538a88ecb','204','47211276-30bb-45c5-8735-873b5af59e64','b0a4e923-d270-4353-9e81-e86c14424262',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('d8c4d0ba-120d-411f-96ee-fd8715fd77dd','204','d29fe5ad-1dc6-413d-a208-d9c2b052acfc','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('13027555-4d6a-4d59-99bf-f562880cd767','204','36b3c83f-0062-4313-90b1-91b029f11d03','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('13371bff-4bf3-4018-a327-8c4b8aae408c','204','eca0b70d-7324-4c49-bc35-15e72f148fe2','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('e527a052-3a14-4379-8bd5-150c14726138','204','ba0d5a0d-7ea9-469a-a981-a00e2b8825ec','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('464b8cc3-d778-4c6b-9a2b-221187d138b4','204','698d7b32-1fe1-4fcc-af02-643b08fddfce','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS (UID_,PARENTUID,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,SUBFLAG,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,LEFTMARGIN,WINDOWOPTION,TENANT_ID) values ('f3b97b60-a177-4086-a460-29c04db4a824','204','7d3b9b37-5975-4cf5-9096-1adb43f7e755','F3633607-8E8B-42A1-B777-6E2969072E58',null,null,null,null,null,null,null,null,null,0);

Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('04fccf89-e849-4c87-b364-ce5768c67031','55b6ee75-bdbd-4690-821e-9e41ee14603c','d4dcceee-01f5-42da-9093-a243d3056204','決裁待ちの文書','決裁待ちの文書',1,' ','/ezApprovalG/apprGMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('0d99fc50-55f4-4243-b47b-bf36c7ae58aa','2e1803bc-9df3-412a-98ae-045fa345ed98','b0a4e923-d270-4353-9e81-e86c14424262','Address','Address',2,' ','/ezEmail/mailMain.do?funCode=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('101d7cc4-555d-4c8a-a108-b776fabdad47','a52e3c9c-171e-44aa-b540-b4311f357b55','d4dcceee-01f5-42da-9093-a243d3056204','起案した文書','起案した文書',3,' ','/ezApproval/apprMain.do?listType=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('14c7302b-063e-4ba7-8233-8e8f257a0551','94ef77fe-04fd-434a-8508-7fba98631bb8','d4dcceee-01f5-42da-9093-a243d3056204','电子调查','电子调查',2,' ','/ezBoard/boardMain.do?subFunc=1','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('22adf8b9-b12d-449b-9b91-ece274f32eb5','55b6ee75-bdbd-4690-821e-9e41ee14603c','d4dcceee-01f5-42da-9093-a243d3056204','起案した文書','起案した文書',3,' ','/ezApprovalG/apprGMain.do?listType=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('2341220c-33d9-430e-9a30-0cce35335552','55b6ee75-bdbd-4690-821e-9e41ee14603c','d4dcceee-01f5-42da-9093-a243d3056204','部署受信文書','部署受信文書',4,' ','/ezApprovalG/apprGMain.do?listType=4','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('26aa5ca6-986a-410c-8522-9b020580ee65','a52e3c9c-171e-44aa-b540-b4311f357b55','d4dcceee-01f5-42da-9093-a243d3056204','決裁進捗文書','決裁進捗文書',2,' ','/ezApproval/apprMain.do?listType=3','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('7d237704-4123-4c60-95cc-16b6b0a06642','b39f97e9-4272-45d2-bcda-2ceb6d6e46d0','F3633607-8E8B-42A1-B777-6E2969072E58','결재할문서','결재할문서_en',1,' ','/ezApprovalG/apprGMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('8d13543c-7747-4828-a141-1e28045ff722','09e1d12c-5ffd-4240-8791-020431a5c47b','F3633607-8E8B-42A1-B777-6E2969072E58','주소록','ezAddress',2,' ','/ezEmail/mailMain.do?funCode=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('9d853064-592b-4d07-a731-bd71b2832325','55b6ee75-bdbd-4690-821e-9e41ee14603c','d4dcceee-01f5-42da-9093-a243d3056204','決裁進捗文書','決裁進捗文書',2,' ','/ezApprovalG/apprGMain.do?listType=3','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('32c593d8-6d84-457c-bce3-28d66c15453b','1f613cb1-a2f6-4f73-8b89-f0511cd2f911','b0a4e923-d270-4353-9e81-e86c14424262','Reserved post','Reserved post',3,' ','/ezBoard/boardMain.do?subFunc=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('356bae53-0b8f-42af-b0e2-16cdd9a42a95','2e1803bc-9df3-412a-98ae-045fa345ed98','b0a4e923-d270-4353-9e81-e86c14424262','E-mail','E-mail',1,' ','/ezEmail/mailMain.do?funCode=1','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('39f98e56-8eaa-49e0-95cf-b64fa2697f04','d00d04fb-3d8f-466c-9f0f-7fc974954c1c','b0a4e923-d270-4353-9e81-e86c14424262','Proposed','Proposed',4,' ','/ezApprovalG/apprGMain.do?listType=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('3a666e56-b5c5-4dc3-b455-2a4b607ce332','1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','F3633607-8E8B-42A1-B777-6E2969072E58','즐겨찾기','즐겨찾기_en',2,' ','/ezBoard/boardMain.do?subFunc=1','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('4046c701-2829-4dc9-8814-02bff616d2c4','7acbc603-5383-4da4-ae14-523112a5c167','b0a4e923-d270-4353-9e81-e86c14424262','Proposed','Proposed',3,' ','/ezApproval/apprMain.do?listType=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('449adeff-b4db-4840-8fb6-9436fcaaf9df','a52e3c9c-171e-44aa-b540-b4311f357b55','d4dcceee-01f5-42da-9093-a243d3056204','部署受信箱','部署受信箱',4,' ','/ezApproval/apprMain.do?listType=4','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('451ef007-5316-472d-9a22-eeafbe8367e9','1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','F3633607-8E8B-42A1-B777-6E2969072E58','예약게시물','예약게시물_en',3,' ','/ezBoard/boardMain.do?subFunc=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('53fbc413-b279-4bc8-9a0b-e490660a6495','7acbc603-5383-4da4-ae14-523112a5c167','b0a4e923-d270-4353-9e81-e86c14424262','Dept.receipt folder','Dept.receipt folder',4,' ','/ezApproval/apprMain.do?listType=4','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('55eaf17c-55e9-485a-9b82-a5096d47a19c','1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','F3633607-8E8B-42A1-B777-6E2969072E58','전자설문','ezQuestion',4,' ','/ezBoard/boardMain.do?func=1','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('45eaf17c-55e9-326j-12hf-b6096d47789g','1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','F3633607-8E8B-42A1-B777-6E2969072E58','투표','ezPoll',5,' ','/ezBoard/boardMain.do?func=3','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('f85dc4dd-662d-414b-bf2c-20009cd87f4b','1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','F3633607-8E8B-42A1-B777-6E2969072E58','사다리게임','ezLadder',7,' ','/ezBoard/boardMain.do?func=4','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('57773384-f434-4450-92eb-1bdfe7e8a725','d00d04fb-3d8f-466c-9f0f-7fc974954c1c','b0a4e923-d270-4353-9e81-e86c14424262','To be process','To be process',1,' ','/ezApprovalG/apprGMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('5f930a90-0a15-4a5a-a48e-2111e86bd503','04bc1910-6e80-4904-9da2-e6c86eccc366','d4dcceee-01f5-42da-9093-a243d3056204','アドレス帳','アドレス帳',2,' ','/ezEmail/mailMain.do?funCode=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('64f2e977-8759-43a4-b746-555378d22274','d00d04fb-3d8f-466c-9f0f-7fc974954c1c','b0a4e923-d270-4353-9e81-e86c14424262','In process','In process',2,' ','/ezApprovalG/apprGMain.do?listType=3','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('9f3651b2-fb17-429b-88db-b9d91cadfdbe','1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','F3633607-8E8B-42A1-B777-6E2969072E58','즐겨찾기','즐겨찾기_en',1,' ','/ezBoard/boardMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('a463482f-2e87-4ab1-be9f-e0ed5e054f76','1f613cb1-a2f6-4f73-8b89-f0511cd2f911','b0a4e923-d270-4353-9e81-e86c14424262','My Posts','My Posts',2,' ','/ezBoard/boardMain.do?subFunc=1','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('a8ec0f1d-e9f5-4689-a953-5338ce70f75c','7acbc603-5383-4da4-ae14-523112a5c167','b0a4e923-d270-4353-9e81-e86c14424262','To be process','To be process',1,' ','/ezApproval/apprMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('ad35d4e0-d885-43dc-899a-9c0ec92add53','1f613cb1-a2f6-4f73-8b89-f0511cd2f911','b0a4e923-d270-4353-9e81-e86c14424262','My board','My board',1,' ','/ezBoard/boardMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('c443c133-3172-4e22-b681-5edb5318628a','94ef77fe-04fd-434a-8508-7fba98631bb8','d4dcceee-01f5-42da-9093-a243d3056204','電子アンケート','電子アンケート',4,' ','/ezBoard/boardMain.do?func=1','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('c422d596-4890-8h34-g556-6sgj4236289t','94ef77fe-04fd-434a-8508-7fba98631bb8','d4dcceee-01f5-42da-9093-a243d3056204','投票','投票',5,' ','/ezBoard/boardMain.do?func=3','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('c54e8173-ad8f-43dd-a220-05e4cc979788','1f613cb1-a2f6-4f73-8b89-f0511cd2f911','b0a4e923-d270-4353-9e81-e86c14424262','Question','Question',4,' ','/ezBoard/boardMain.do?func=1','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('c76e9210-b9df-21gh-b110-34t2sg147345','1f613cb1-a2f6-4f73-8b89-f0511cd2f911','b0a4e923-d270-4353-9e81-e86c14424262','Vote','Vote',5,' ','/ezBoard/boardMain.do?func=3','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('c93e6f29-ac0a-46a4-84c2-ae809e9c7c9e','09e1d12c-5ffd-4240-8791-020431a5c47b','F3633607-8E8B-42A1-B777-6E2969072E58','메일','mail',1,' ','/ezEmail/mailMain.do?funCode=1','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('c9cd4fa8-4806-47e7-92c2-3daccb0bd6bb','b39f97e9-4272-45d2-bcda-2ceb6d6e46d0','F3633607-8E8B-42A1-B777-6E2969072E58','결재진행문서','결재진행문서_en',2,' ','/ezApprovalG/apprGMain.do?listType=3','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('ce4f389f-47bf-4cb8-ab86-76e049eb9dc8','a52e3c9c-171e-44aa-b540-b4311f357b55','d4dcceee-01f5-42da-9093-a243d3056204','決裁待ちの文書','決裁待ちの文書',1,' ','/ezApproval/apprMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('8755e9ee-b116-4fa0-90c9-4ba174e33944','b39f97e9-4272-45d2-bcda-2ceb6d6e46d0','F3633607-8E8B-42A1-B777-6E2969072E58','회람수신함','회람수신함_en',4,' ','/ezApprovalG/apprGMain.do?listType=99','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('cffefdb6-e3d5-4336-a1e9-1e1a973981eb','b39f97e9-4272-45d2-bcda-2ceb6d6e46d0','F3633607-8E8B-42A1-B777-6E2969072E58','부서수신함','부서수신함_en',5,' ','/ezApprovalG/apprGMain.do?listType=4','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('d3dfdede-b4c7-48d6-a6e6-0b14f54d3ed9','04bc1910-6e80-4904-9da2-e6c86eccc366','d4dcceee-01f5-42da-9093-a243d3056204','メール','メール',1,' ','/ezEmail/mailMain.do?funCode=1','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('d48b3355-defd-4a62-b373-3369f7f46bb3','b39f97e9-4272-45d2-bcda-2ceb6d6e46d0','F3633607-8E8B-42A1-B777-6E2969072E58','기안한문서','기안한문서_en',3,' ','/ezApprovalG/apprGMain.do?listType=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('d95e558c-e454-4e26-9ddf-688aba9aa89b','94ef77fe-04fd-434a-8508-7fba98631bb8','d4dcceee-01f5-42da-9093-a243d3056204','マイ掲示板','マイ掲示板',1,' ','/ezBoard/boardMain.do','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('e3d09096-0258-4528-98d0-d2313a512897','7acbc603-5383-4da4-ae14-523112a5c167','b0a4e923-d270-4353-9e81-e86c14424262','In process','In process',2,' ','/ezApproval/apprMain.do?listType=3','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('f4fa93e8-e87d-4a21-ae9a-36099e8b3d56','d00d04fb-3d8f-466c-9f0f-7fc974954c1c','b0a4e923-d270-4353-9e81-e86c14424262','Dept.receipt folder','Dept.receipt folder',3,' ','/ezApprovalG/apprGMain.do?listType=4','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('fff4584e-3c0c-4b2f-98e5-4834138de988','94ef77fe-04fd-434a-8508-7fba98631bb8','d4dcceee-01f5-42da-9093-a243d3056204','予約掲示物','予約掲示物',3,' ','/ezBoard/boardMain.do?subFunc=2','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('9c7cfadb-4f21-4cbf-94b9-60669936a9f8','6cdb78b7-ae72-48ce-990f-5c0f6838fbbc','F3633607-8E8B-42A1-B777-6E2969072E58','업무관리','ToDo',1,' ','/ezSchedule/scheduleIndex.do?funCode=3','main',' ',0);
Insert into TBL_MENUITEM_ITEMS_MENUITEMS_S (UID_,PARENTMENUID,OWNERPAGEID,DISPLAYNAME,DISPLAYNAME2,COLUMNPOS,IMAGEUID,LINKURL,LINKLOCATION,WINDOWOPTION,TENANT_ID) values ('fed12253-3627-441a-9c1d-fffc79e419ea','1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','F3633607-8E8B-42A1-B777-6E2969072E58','캐비넷','Cabinet',8,' ','/ezCabinet/cabinetMain.do','main',' ',0);

Insert into TBL_PORTALPAGE_CATEGORY (CATEGORY,DISPLAYNAME,TENANT_ID) values ('1','마이포탈',0);
Insert into TBL_PORTALPAGE_CATEGORY (CATEGORY,DISPLAYNAME,TENANT_ID) values ('2','비즈메카',0);
Insert into TBL_PORTALPAGE_CATEGORY (CATEGORY,DISPLAYNAME,TENANT_ID) values ('3','교수포탈',0);

Insert into TBL_PORTALPAGE_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,GUBUNFLAG,USEFLAG,COMPANYID,BASETYPE,THEMEUID,DEFAULTPAGE,TABLEVIEWOPTION,TENANT_ID) values ('ba3541ea-8da9-4fcf-b24b-29b1fb1aedf6','top',1,'ba3541ea-8da9-4fcf-b24b-29b1fb1aedf6',null,'gisa1','기사원',TO_DATE('2014-06-27 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,225,0,3,null,'250;250;9999;','1',null,'Top',null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',null,'D',0);
Insert into TBL_PORTALPAGE_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,GUBUNFLAG,USEFLAG,COMPANYID,BASETYPE,THEMEUID,DEFAULTPAGE,TABLEVIEWOPTION,TENANT_ID) values ('bd7d2263-939b-481e-ae95-7aa70e67c5c3','top',1,'표준포탈페이지 A 테마','en_표준포탈페이지 A 테마','gisa1','기사원',TO_DATE('2014-06-27 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,500,0,1,null,'9999;','1','Y         ','Top',null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf','Y','D',0);
Insert into TBL_PORTALPAGE_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,GUBUNFLAG,USEFLAG,COMPANYID,BASETYPE,THEMEUID,DEFAULTPAGE,TABLEVIEWOPTION,TENANT_ID) values ('d6e9c786-3af3-4c46-809d-267c2fd96976','top',1,'d6e9c786-3af3-4c46-809d-267c2fd96976',null,'gisa1','기사원',TO_DATE('2014-06-27 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,1,null,'9999;','1',null,'Top',null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',null,'D',0);
Insert into TBL_PORTALPAGE_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,GUBUNFLAG,USEFLAG,COMPANYID,BASETYPE,THEMEUID,DEFAULTPAGE,TABLEVIEWOPTION,TENANT_ID) values ('d8dc7da6-7572-4853-801a-14072d823c65','top',1,'d8dc7da6-7572-4853-801a-14072d823c65',null,'gisa1','기사원',TO_DATE('2014-06-27 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,3,null,'250;250;9999;','1',null,'Top',null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',null,'D',0);
Insert into TBL_PORTALPAGE_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,GUBUNFLAG,USEFLAG,COMPANYID,BASETYPE,THEMEUID,DEFAULTPAGE,TABLEVIEWOPTION,TENANT_ID) values ('e6e189b3-6a83-4c5e-90f3-61cbfd50c59c','top',1,'e6e189b3-6a83-4c5e-90f3-61cbfd50c59c',null,'gisa1','기사원',TO_DATE('2014-06-27 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,2,null,'500;9999;','1',null,'Top',null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',null,'D',0);
Insert into TBL_PORTALPAGE_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,GUBUNFLAG,USEFLAG,COMPANYID,BASETYPE,THEMEUID,DEFAULTPAGE,TABLEVIEWOPTION,TENANT_ID) values ('054a5b35-d8d5-4b07-9e47-d7820bf59435','top',1,'054a5b35-d8d5-4b07-9e47-d7820bf59435',null,'gisa1','기사원',TO_DATE('2014-06-27 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,3,null,'250;250;9999;','1',null,'Top',null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',null,'D',0);
Insert into TBL_PORTALPAGE_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,GUBUNFLAG,USEFLAG,COMPANYID,BASETYPE,THEMEUID,DEFAULTPAGE,TABLEVIEWOPTION,TENANT_ID) values ('df178301-cfe4-46d9-8c0f-80e9f92673a9','top',1,'df178301-cfe4-46d9-8c0f-80e9f92673a9',null,'gisa1','gisa1',TO_DATE('2015-12-24 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,1,null,'9999;','1',null,'Top',null,'69ae464d-e0ab-4558-b42b-4c9679474377',null,'D',0);

Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('d6e9c786-3af3-4c46-809d-267c2fd96976','bd7d2263-939b-481e-ae95-7aa70e67c5c3','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',1,'bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,100,10000,1,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('d8dc7da6-7572-4853-801a-14072d823c65','bd7d2263-939b-481e-ae95-7aa70e67c5c3','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',1,'bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,110,150000,1,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('e6e189b3-6a83-4c5e-90f3-61cbfd50c59c','bd7d2263-939b-481e-ae95-7aa70e67c5c3','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',1,'bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,110,60000,1,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('054a5b35-d8d5-4b07-9e47-d7820bf59435','bd7d2263-939b-481e-ae95-7aa70e67c5c3','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',1,'bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,110,100000,1,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('0b4d7088-ea3c-4afb-ac2e-862cfa69bbb3','ba3541ea-8da9-4fcf-b24b-29b1fb1aedf6','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'슬라이드이미지_포틀릿',517,225,10000,2,1,1,1,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('8af6e9a5-0970-45a9-9495-ba0c7a9163fd','e6e189b3-6a83-4c5e-90f3-61cbfd50c59c','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'결재_메일 통합 포틀릿',797,235,40000,1,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('8fd70c9a-83b2-4294-a57b-9a59abe3850d','054a5b35-d8d5-4b07-9e47-d7820bf59435','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'설문통계_포틀릿',265,235,10000,2,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('9b157fdc-057d-4c5c-b036-f2107adf7f0b','d8dc7da6-7572-4853-801a-14072d823c65','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'활용하기_포틀릿',230,225,110000,1,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('a2149765-4c0b-466c-9e61-310925139d3c','d6e9c786-3af3-4c46-809d-267c2fd96976','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'사용자정보통합_포틀릿',1150,220,10000,1,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('ba3541ea-8da9-4fcf-b24b-29b1fb1aedf6','bd7d2263-939b-481e-ae95-7aa70e67c5c3','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',1,'bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,225,30000,1,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('c06b1862-ce83-4472-91d7-fd92cee3a7ac','d8dc7da6-7572-4853-801a-14072d823c65','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'포토게시판_포틀릿',558,225,10000,2,1,1,1,null,null,null,null,null,null,'2         ',0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('c08c6efa-7494-4185-b1dc-09ecc908f683','ba3541ea-8da9-4fcf-b24b-29b1fb1aedf6','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'공지게시판_포틀릿',280,225,20000,1,1,1,1,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('c1479aa0-824d-43ff-a7f6-999ad660378a','ba3541ea-8da9-4fcf-b24b-29b1fb1aedf6','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'배너_우수사원_포틀릿',330,225,10000,3,1,1,0,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('a37406b2-7a0a-48b0-a2a9-aacf811e9bd4','d8dc7da6-7572-4853-801a-14072d823c65','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'직원생일_포틀릿',338,225,10000,3,1,1,1,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('f90b6413-c94c-4c6f-abe5-39480da308f1','e6e189b3-6a83-4c5e-90f3-61cbfd50c59c','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'우수커뮤니티_포틀릿',330,235,10000,2,1,1,1,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('7851b606-aa1c-4f96-ba9b-562432b922a6','054a5b35-d8d5-4b07-9e47-d7820bf59435','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'결재사용현황_포틀릿',348,235,10000,3,1,1,1,null,null,null,null,null,null,null,0);
Insert into TBL_PORTALPAGE_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEUID,PORTLETTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,MANDATORY,TENANT_ID) values ('94dfe6d0-043a-4284-bde5-8275aba64d6e','054a5b35-d8d5-4b07-9e47-d7820bf59435','top','bd7d2263-939b-481e-ae95-7aa70e67c5c3',0,'마이게시판_포틀릿',512,235,70000,1,1,1,1,null,null,null,null,null,null,null,0);

Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values (' ','gisa1','gisa1',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values (' ','masteradmin','masteradmin',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('0260dc48-e5b6-477b-9a15-3ad6a9b31dd0','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('04bc1910-6e80-4904-9da2-e6c86eccc366','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('04fccf89-e849-4c87-b364-ce5768c67031','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('07350485-7e46-4dc6-a8ec-1d6ca89ac7ed','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('08eb7695-3b27-4003-b5c4-eea1a99bbd05','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('09e1d12c-5ffd-4240-8791-020431a5c47b','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('0b4d7088-ea3c-4afb-ac2e-862cfa69bbb3','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('0d99fc50-55f4-4243-b47b-bf36c7ae58aa','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('0f3de424-a078-4165-87d5-4fd21534803c','gisa1','gisa1',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('0f3de424-a078-4165-87d5-4fd21534803c','masteradmin','masteradmin',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('101d7cc4-555d-4c8a-a108-b776fabdad47','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('14c7302b-063e-4ba7-8233-8e8f257a0551','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('64f2e977-8759-43a4-b746-555378d22274','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('69b6d233-c50d-4b38-bb50-5bf51c02c35b','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('69f68282-5617-45ca-9118-27b6170df5c3','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('6cdb78b7-ae72-48ce-990f-5c0f6838fbbc','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('6db81dc5-e8ba-49c8-b625-df4fd375a43a','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('70fd0c61-af80-4f22-bf6e-d17d3f666bf9','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('73fc6012-c812-4a54-bdc1-0bc580f837a4','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('7851b606-aa1c-4f96-ba9b-562432b922a6','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('7acbc603-5383-4da4-ae14-523112a5c167','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('1db3cf2c-742e-4958-8f9f-557bb08aec75','everyone','조직도',2,1,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('1dc7d4e1-303f-4d13-a8b6-d5ebf8f3f32d','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('1f613cb1-a2f6-4f73-8b89-f0511cd2f911','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('22adf8b9-b12d-449b-9b91-ece274f32eb5','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('2341220c-33d9-430e-9a30-0cce35335552','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('26aa5ca6-986a-410c-8522-9b020580ee65','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('28e8af74-de0c-4e3e-a392-0e63ff623981','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('2e1803bc-9df3-412a-98ae-045fa345ed98','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('2f9e65ff-b89b-4089-819c-8a1dd13561ae','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('32c593d8-6d84-457c-bce3-28d66c15453b','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('356bae53-0b8f-42af-b0e2-16cdd9a42a95','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('37e4a9c1-a923-4ba6-9f08-2757cf4d4693','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('39f98e56-8eaa-49e0-95cf-b64fa2697f04','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('3a666e56-b5c5-4dc3-b455-2a4b607ce332','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('4046c701-2829-4dc9-8814-02bff616d2c4','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('4330099a-4889-497b-ac76-912fc6e10994','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('43bd6bc5-808b-4a2f-b0a9-da4abf1bb7b2','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('449adeff-b4db-4840-8fb6-9436fcaaf9df','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('451ef007-5316-472d-9a22-eeafbe8367e9','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('4e9e1389-9e52-4896-8f40-1dd5a6bf59e9','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('53e846f4-3946-4614-a146-2866c14940dc','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('53fbc413-b279-4bc8-9a0b-e490660a6495','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('55eaf17c-55e9-485a-9b82-a5096d47a19c','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('45eaf17c-55e9-326j-12hf-b6096d47789g','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('63ad15a0-524c-4c30-b9d4-04cb6beae971','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('57773384-f434-4450-92eb-1bdfe7e8a725','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('5f930a90-0a15-4a5a-a48e-2111e86bd503','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c06b1862-ce83-4472-91d7-fd92cee3a7ac','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c1479aa0-824d-43ff-a7f6-999ad660378a','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c2f44b2e-41f0-48c2-a7ea-607a58a0dd80','masteradmin','관리자',2,1,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c443c133-3172-4e22-b681-5edb5318628a','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c422d596-4890-8h34-g556-6sgj4236289t','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c4736cf0-6cf0-42f1-979d-20678b68d171','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c54e8173-ad8f-43dd-a220-05e4cc979788','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c76e9210-b9df-21gh-b110-34t2sg147345','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c93e6f29-ac0a-46a4-84c2-ae809e9c7c9e','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c9cd4fa8-4806-47e7-92c2-3daccb0bd6bb','everyone','조직도',2,1,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('cc9b12f3-85b5-40c2-8f90-5db1b543d9a1','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('ce4f389f-47bf-4cb8-ab86-76e049eb9dc8','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('cf34747c-d809-461d-93d9-e50486ae3b68','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('8755e9ee-b116-4fa0-90c9-4ba174e33944','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('cffefdb6-e3d5-4336-a1e9-1e1a973981eb','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('d00d04fb-3d8f-466c-9f0f-7fc974954c1c','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('ea075496-9065-4f2a-b9f0-f8181ca1928d','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('edabe052-f573-4377-ad95-7743f9093151','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('f17d98c7-6331-428d-9d4e-421312eec8ee','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('f4fa93e8-e87d-4a21-ae9a-36099e8b3d56','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('f5c278f0-b62d-4437-8b08-1a81c2410497','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('f90b6413-c94c-4c6f-abe5-39480da308f1','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('fff4584e-3c0c-4b2f-98e5-4834138de988','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('8fd70c9a-83b2-4294-a57b-9a59abe3850d','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('c08c6efa-7494-4185-b1dc-09ecc908f683','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('94dfe6d0-043a-4284-bde5-8275aba64d6e','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('a37406b2-7a0a-48b0-a2a9-aacf811e9bd4','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('b39f97e9-4272-45d2-bcda-2ceb6d6e46d0','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('8593cc87-7630-420b-a6d5-f7a8577c5a31','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('e254ef6f-d602-4d40-8e39-b44177a8737c','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('d3dfdede-b4c7-48d6-a6e6-0b14f54d3ed9','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('d48b3355-defd-4a62-b373-3369f7f46bb3','everyone','조직도',2,1,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('d95e558c-e454-4e26-9ddf-688aba9aa89b','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('e3d09096-0258-4528-98d0-d2313a512897','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('7d237704-4123-4c60-95cc-16b6b0a06642','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('7fde32ad-5e48-4357-b24c-5f2594919b88','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('856c0213-ae8a-40be-ade0-63ab865fa1fd','everyone','조직도',2,1,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('8af6e9a5-0970-45a9-9495-ba0c7a9163fd','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('8d13543c-7747-4828-a141-1e28045ff722','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('8e35e3f1-ec52-4ee4-8638-af25a8737da7','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('94ef77fe-04fd-434a-8508-7fba98631bb8','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('9b157fdc-057d-4c5c-b036-f2107adf7f0b','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('9d853064-592b-4d07-a731-bd71b2832325','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('9eb0fd34-725e-47ed-93e4-06e06a66dd92','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('9f3651b2-fb17-429b-88db-b9d91cadfdbe','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('a52e3c9c-171e-44aa-b540-b4311f357b55','everyone','ENG_조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('a56082ad-9136-43a7-9749-c867f1f5529e','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('a8ec0f1d-e9f5-4689-a953-5338ce70f75c','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('ad35d4e0-d885-43dc-899a-9c0ec92add53','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('bd7d2263-939b-481e-ae95-7aa70e67c5c3','Top','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('55b6ee75-bdbd-4690-821e-9e41ee14603c','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('a2149765-4c0b-466c-9e61-310925139d3c','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('a463482f-2e87-4ab1-be9f-e0ed5e054f76','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('9c7cfadb-4f21-4cbf-94b9-60669936a9f8','everyone','조직도',2,2,0);
Insert into TBL_PORTAL_ACL (UID_,ACCESSID,ACCESSNAME,VIEW_RIGHT,EDIT_RIGHT,TENANT_ID) values ('fed12253-3627-441a-9c1d-fffc79e419ea','everyone','조직도',2,2,0);

Insert into TBL_PORTLET_CATEGORY (CATEGORY,DISPLAYNAME,TENANT_ID) values ('1','t4075',0);
Insert into TBL_PORTLET_CATEGORY (CATEGORY,DISPLAYNAME,TENANT_ID) values ('2','t4076',0);
Insert into TBL_PORTLET_CATEGORY (CATEGORY,DISPLAYNAME,TENANT_ID) values ('3','t4077',0);
Insert into TBL_PORTLET_CATEGORY (CATEGORY,DISPLAYNAME,TENANT_ID) values ('4','t4078',0);

Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('c06b1862-ce83-4472-91d7-fd92cee3a7ac','포토게시판_포틀릿','en_포토게시판_포틀릿',1,'/ezPortal/urlPortlet.do?uID=c06b1862-ce83-4472-91d7-fd92cee3a7ac',null,'0         ','1         ',225,'0','Top',null,null,548,'iFrame    ',0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('c08c6efa-7494-4185-b1dc-09ecc908f683','공지게시판_포틀릿','en_공지게시판_포틀릿',1,'/ezPortal/urlPortlet.do?uID=c08c6efa-7494-4185-b1dc-09ecc908f683',' ','0         ','1         ',225,'0','Top',null,null,280,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('c1479aa0-824d-43ff-a7f6-999ad660378a','배너_우수사원_포틀릿','en_배너_우수사원_포틀릿',1,'/ezPortal/urlPortlet.do?uID=c1479aa0-824d-43ff-a7f6-999ad660378a',' ','0         ','1         ',225,'0','Top',null,null,330,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('f90b6413-c94c-4c6f-abe5-39480da308f1','우수커뮤니티_포틀릿','en_우수커뮤니티_포틀릿',1,'/ezPortal/urlPortlet.do?uID=f90b6413-c94c-4c6f-abe5-39480da308f1',' ','0         ','1         ',235,'0','Top',null,null,330,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('0b4d7088-ea3c-4afb-ac2e-862cfa69bbb3','슬라이드이미지_포틀릿','en_슬라이드이미지_포틀릿',1,'/ezPortal/urlPortlet.do?uID=0b4d7088-ea3c-4afb-ac2e-862cfa69bbb3',' ','0         ','1         ',225,'0','Top',null,null,517,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('69f68282-5617-45ca-9118-27b6170df5c3','포토_생일 통합 포틀릿','포토_생일 통합 포틀릿_en',1,'/ezPortal/urlPortlet.do?uID=69f68282-5617-45ca-9118-27b6170df5c3',' ','0         ','1         ',240,'0','Top',null,null,1150,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('73c0940e-5d44-4edc-bfa3-822fd6fd17b5','공지_슬라이드_이모저모 통합 포틀릿','공지_슬라이드_이모저모 통합 포틀릿_en',1,'/ezPortal/urlPortlet.do?uID=73c0940e-5d44-4edc-bfa3-822fd6fd17b5',' ','0         ','1         ',240,'0','Top',null,null,1150,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('7851b606-aa1c-4f96-ba9b-562432b922a6','결재사용현황_포틀릿','en_결재사용현황_포틀릿',1,'/ezPortal/urlPortlet.do?uID=7851b606-aa1c-4f96-ba9b-562432b922a6',' ','0         ','1         ',225,'0','Top',null,null,348,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('8af6e9a5-0970-45a9-9495-ba0c7a9163fd','결재_메일 통합 포틀릿','en_결재_메일 통합 포틀릿',1,'/ezPortal/urlPortlet.do?uID=8af6e9a5-0970-45a9-9495-ba0c7a9163fd',' ','0         ','1         ',235,'0','Top',null,null,797,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('8fd70c9a-83b2-4294-a57b-9a59abe3850d','설문통계_포틀릿','en_설문통계_포틀릿',1,'/ezPortal/urlPortlet.do?uID=8fd70c9a-83b2-4294-a57b-9a59abe3850d',' ','0         ','1         ',225,'0','Top',null,null,265,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('94dfe6d0-043a-4284-bde5-8275aba64d6e','마이게시판_포틀릿','en_마이게시판_포틀릿',1,'/ezPortal/urlPortlet.do?uID=94dfe6d0-043a-4284-bde5-8275aba64d6e',' ','0         ','1         ',225,'0','Top',null,null,512,null,0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('9b157fdc-057d-4c5c-b036-f2107adf7f0b','활용하기_포틀릿','en_활용하기_포틀릿',1,'/ezPortal/urlPortlet.do?uID=9b157fdc-057d-4c5c-b036-f2107adf7f0b','2345235','0         ','1         ',225,'0','Top',null,null,240,'DIV       ',0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('a37406b2-7a0a-48b0-a2a9-aacf811e9bd4','직원생일_포틀릿','en_직원생일_포틀릿',1,'/ezPortal/urlPortlet.do?uID=a37406b2-7a0a-48b0-a2a9-aacf811e9bd4',null,'0         ','1         ',225,'0','Top',null,null,338,'DIV       ',0);
Insert into TBL_PORTLET_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,PORTLET_TYPE,URL,MAXURL,SHOWTITLEBAR,USERTYPE,HEIGHT,GUBUNFLAG,COMPANYID,BASETYPE,USEPOTALGUBUN,WIDTH,FRAMETYPE,TENANT_ID) values ('a2149765-4c0b-466c-9e61-310925139d3c','사용자정보통합_포틀릿','en_사용자정보통합_포틀릿',1,'/ezPortal/urlPortlet.do?uID=a2149765-4c0b-466c-9e61-310925139d3c',' ','0         ','1         ',220,'0','Top',null,null,1150,null,0);

Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('f90b6413-c94c-4c6f-abe5-39480da308f1','gisa1','1','/ezPortal/wpNewCommunity.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('9b157fdc-057d-4c5c-b036-f2107adf7f0b','gisa1','1','/ezPortal/wpNewGWBanner.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('c06b1862-ce83-4472-91d7-fd92cee3a7ac','gisa1','1','/ezPortal/wpNewPhoto.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('0b4d7088-ea3c-4afb-ac2e-862cfa69bbb3','gisa1','1','/ezPortal/wpNewImage.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('69f68282-5617-45ca-9118-27b6170df5c3','gisa1','1','/ezPortal/wpTotalSection5.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('73c0940e-5d44-4edc-bfa3-822fd6fd17b5','gisa1','1','/ezPortal/wpTotalSection2.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('7851b606-aa1c-4f96-ba9b-562432b922a6','gisa1','1','/ezPortal/wpNewGraph.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('8af6e9a5-0970-45a9-9495-ba0c7a9163fd','gisa1','1','/ezPortal/wpNewApprMail.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('8fd70c9a-83b2-4294-a57b-9a59abe3850d','gisa1','1','/ezPortal/wpNewPoll.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('94dfe6d0-043a-4284-bde5-8275aba64d6e','gisa1','1','/ezPortal/wpNewBoardSTD.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('a2149765-4c0b-466c-9e61-310925139d3c','gisa1','1','/ezPortal/wpTotalSection.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('a37406b2-7a0a-48b0-a2a9-aacf811e9bd4','gisa1','1','/ezPortal/wpNewBirth.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('c08c6efa-7494-4185-b1dc-09ecc908f683','gisa1','1','/ezPortal/wpNewBoard.do',0);
Insert into TBL_PORTLET_URL (UID_,CREATORID,USERTYPE,URL,TENANT_ID) values ('c1479aa0-824d-43ff-a7f6-999ad660378a','gisa1','1','/ezPortal/wpNewSide.do',0);

Insert into TBL_SKIN_ITEMS (UID_,SKINNUM,SKINNAME,SKINNAME2,SKINBGFLAG,SKINBGCOLOR,SKINBGIMAGE,SKINFONTCOLOR,SKINFONTOVERCOLOR,SKINDEFAULTIMAGE,SKINDEFAULTCOLOR,TENANT_ID) values ('b0a4e923-d270-4353-9e81-e86c14424262',1,' ',null,'          ',' ',' ',' ',' ',null,null,0);
Insert into TBL_SKIN_ITEMS (UID_,SKINNUM,SKINNAME,SKINNAME2,SKINBGFLAG,SKINBGCOLOR,SKINBGIMAGE,SKINFONTCOLOR,SKINFONTOVERCOLOR,SKINDEFAULTIMAGE,SKINDEFAULTCOLOR,TENANT_ID) values ('d4dcceee-01f5-42da-9093-a243d3056204',1,' ',null,'          ',' ',' ',' ',' ',null,null,0);
Insert into TBL_SKIN_ITEMS (UID_,SKINNUM,SKINNAME,SKINNAME2,SKINBGFLAG,SKINBGCOLOR,SKINBGIMAGE,SKINFONTCOLOR,SKINFONTOVERCOLOR,SKINDEFAULTIMAGE,SKINDEFAULTCOLOR,TENANT_ID) values ('F3633607-8E8B-42A1-B777-6E2969072E58',1,' ',null,'          ',' ',' ',' ',' ',null,null,0);

Insert into TBL_THEME_GENERAL (UID_,DISPLAYNAME,DISPLAYNAME2,DISPLAYNAME3,DISPLAYNAME4,IMAGEURL,TOPURL,MAINURL,COMPANAYID,CREATORID,CREATORNM,CREATEDATE,MODIFYDATE,TOPHEIGHT,TENANT_ID) values ('f2de22b9-9a3f-49a9-884b-2e179e564cbf','A Theme','A Theme','A Theme','A Theme','/files/upload_portal/Top/Theme/08c5179c-1c9d-46e8-bea3-9c4495fa3704.jpg','/ezPortal/topMenu.do','/ezPortal/portalPage.do','Top','gisa1','기사원',TO_DATE('2014-03-17 00:00:00','yyyy-mm-dd hh24:mi:ss'),TO_DATE('2016-10-05 00:00:00','yyyy-mm-dd hh24:mi:ss'),100,0);

Insert into TBL_TOPMENU_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,USEFLAG,COMPANYID,LANG,TOPMNID,BASETYPE,THEMEUID,TENANT_ID) values ('d4dcceee-01f5-42da-9093-a243d3056204','top',1,'표준메뉴_일본','표준메뉴_일본','gisa1','기사원',TO_DATE('2013-06-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,200,0,1,' ',';','Y','Top','3',null,null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',0);
Insert into TBL_TOPMENU_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,USEFLAG,COMPANYID,LANG,TOPMNID,BASETYPE,THEMEUID,TENANT_ID) values ('F3633607-8E8B-42A1-B777-6E2969072E58','top',1,'표준메뉴_한국','표준메뉴_한국','gisa1','김사원',TO_DATE('2017-10-23 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,57,0,1,null,';','Y','Top','1',null,null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',0);
Insert into TBL_TOPMENU_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,USEFLAG,COMPANYID,LANG,TOPMNID,BASETYPE,THEMEUID,TENANT_ID) values ('174da7a0-e379-44bb-937d-a91216a7b459','top',1,'174da7a0-e379-44bb-937d-a91216a7b459','174da7a0-e379-44bb-937d-a91216a7b459','gisa1','기사원',TO_DATE('2013-06-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,4,' ','100;280;500;;',null,'Top',null,null,null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',0);
Insert into TBL_TOPMENU_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,USEFLAG,COMPANYID,LANG,TOPMNID,BASETYPE,THEMEUID,TENANT_ID) values ('29e70a07-904b-41c6-a683-4d06a0b15d85','top',1,'29e70a07-904b-41c6-a683-4d06a0b15d85','29e70a07-904b-41c6-a683-4d06a0b15d85','gisa1','기사원',TO_DATE('2013-06-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,1,null,';',null,'Top',null,null,null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',0);
Insert into TBL_TOPMENU_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,USEFLAG,COMPANYID,LANG,TOPMNID,BASETYPE,THEMEUID,TENANT_ID) values ('306fedec-66da-4070-8b54-8d1517a4545b','top',1,'306fedec-66da-4070-8b54-8d1517a4545b','306fedec-66da-4070-8b54-8d1517a4545b','gisa1','기사원',TO_DATE('2013-06-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,4,' ','100;280;500;;',null,'Top',null,null,null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',0);
Insert into TBL_TOPMENU_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,USEFLAG,COMPANYID,LANG,TOPMNID,BASETYPE,THEMEUID,TENANT_ID) values ('64aa1712-8a96-4b25-aa9c-51e74282d54f','top',1,'64aa1712-8a96-4b25-aa9c-51e74282d54f','64aa1712-8a96-4b25-aa9c-51e74282d54f','gisa1','기사원',TO_DATE('2013-06-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,1,' ',';',null,'Top',null,null,null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',0);
Insert into TBL_TOPMENU_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,USEFLAG,COMPANYID,LANG,TOPMNID,BASETYPE,THEMEUID,TENANT_ID) values ('b0a4e923-d270-4353-9e81-e86c14424262','top',1,'표준메뉴_영어','표준메뉴_영어','gisa1','기사원',TO_DATE('2013-06-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,200,0,1,' ',';','Y','Top','2',null,null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',0);
Insert into TBL_TOPMENU_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,USEFLAG,COMPANYID,LANG,TOPMNID,BASETYPE,THEMEUID,TENANT_ID) values ('cc6758b3-1f3f-483a-9d7a-861caca82f92','top',1,'cc6758b3-1f3f-483a-9d7a-861caca82f92','cc6758b3-1f3f-483a-9d7a-861caca82f92','gisa1','기사원',TO_DATE('2013-06-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,3,null,'100;280;;',null,'Top',null,null,null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',0);
Insert into TBL_TOPMENU_GENERAL (UID_,PARENTUID,DEPTH,DISPLAYNAME,DISPLAYNAME2,CREATORID,CREATORNAME,CREATEDATE,MODIFYDATE,WIDTH,HEIGHT,ROWLENGTH,COLUMNLENGTH,ROWSPLIT,COLUMNSPLIT,USEFLAG,COMPANYID,LANG,TOPMNID,BASETYPE,THEMEUID,TENANT_ID) values ('cd941931-9343-4186-b920-22106c63bfc1','top',1,'cd941931-9343-4186-b920-22106c63bfc1','cd941931-9343-4186-b920-22106c63bfc1','gisa1','기사원',TO_DATE('2013-06-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),null,-1,110,0,1,' ',';',null,'Top',null,null,null,'f2de22b9-9a3f-49a9-884b-2e179e564cbf',0);

Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('204','cd941931-9343-4186-b920-22106c63bfc1','top','b0a4e923-d270-4353-9e81-e86c14424262',0,'서브메뉴영역',0,100,20000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('205','174da7a0-e379-44bb-937d-a91216a7b459','top','b0a4e923-d270-4353-9e81-e86c14424262',0,'검색영역',0,100,10000,3,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('205','306fedec-66da-4070-8b54-8d1517a4545b','top','d4dcceee-01f5-42da-9093-a243d3056204',0,'검색영역',0,100,10000,3,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('29e70a07-904b-41c6-a683-4d06a0b15d85','F3633607-8E8B-42A1-B777-6E2969072E58','top','F3633607-8E8B-42A1-B777-6E2969072E58',1,'F3633607-8E8B-42A1-B777-6E2969072E58',0,100,20000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('306fedec-66da-4070-8b54-8d1517a4545b','d4dcceee-01f5-42da-9093-a243d3056204','top','d4dcceee-01f5-42da-9093-a243d3056204',1,'d4dcceee-01f5-42da-9093-a243d3056204',0,110,10000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('64aa1712-8a96-4b25-aa9c-51e74282d54f','d4dcceee-01f5-42da-9093-a243d3056204','top','d4dcceee-01f5-42da-9093-a243d3056204',1,'d4dcceee-01f5-42da-9093-a243d3056204',0,100,20000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('cc6758b3-1f3f-483a-9d7a-861caca82f92','F3633607-8E8B-42A1-B777-6E2969072E58','top','F3633607-8E8B-42A1-B777-6E2969072E58',1,'F3633607-8E8B-42A1-B777-6E2969072E58',0,110,10000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('cd941931-9343-4186-b920-22106c63bfc1','b0a4e923-d270-4353-9e81-e86c14424262','top','b0a4e923-d270-4353-9e81-e86c14424262',1,'b0a4e923-d270-4353-9e81-e86c14424262',0,100,20000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('205','cc6758b3-1f3f-483a-9d7a-861caca82f92','top','F3633607-8E8B-42A1-B777-6E2969072E58',0,'검색영역',0,100,10000,3,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('174da7a0-e379-44bb-937d-a91216a7b459','b0a4e923-d270-4353-9e81-e86c14424262','top','b0a4e923-d270-4353-9e81-e86c14424262',1,'b0a4e923-d270-4353-9e81-e86c14424262',0,110,10000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('201','174da7a0-e379-44bb-937d-a91216a7b459','top','b0a4e923-d270-4353-9e81-e86c14424262',0,'로고영역',0,100,10000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('201','306fedec-66da-4070-8b54-8d1517a4545b','top','d4dcceee-01f5-42da-9093-a243d3056204',0,'로고영역',0,100,10000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('201','cc6758b3-1f3f-483a-9d7a-861caca82f92','top','F3633607-8E8B-42A1-B777-6E2969072E58',0,'로고영역',0,100,10000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('202','174da7a0-e379-44bb-937d-a91216a7b459','top','b0a4e923-d270-4353-9e81-e86c14424262',0,'유틸메뉴영역',0,100,10000,2,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('202','306fedec-66da-4070-8b54-8d1517a4545b','top','d4dcceee-01f5-42da-9093-a243d3056204',0,'유틸메뉴영역',0,100,10000,2,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('202','cc6758b3-1f3f-483a-9d7a-861caca82f92','top','F3633607-8E8B-42A1-B777-6E2969072E58',0,'유틸메뉴영역',0,100,10000,2,1,1,1,'center','middle',0,0,100,0,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('203','29e70a07-904b-41c6-a683-4d06a0b15d85','top','F3633607-8E8B-42A1-B777-6E2969072E58',0,'메인메뉴영역',0,100,10000,1,1,1,1,'center','middle',0,0,0,0,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('203','64aa1712-8a96-4b25-aa9c-51e74282d54f','top','d4dcceee-01f5-42da-9093-a243d3056204',0,'메인메뉴영역',0,100,10000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('203','cd941931-9343-4186-b920-22106c63bfc1','top','b0a4e923-d270-4353-9e81-e86c14424262',0,'메인메뉴영역',0,100,10000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('204','29e70a07-904b-41c6-a683-4d06a0b15d85','top','F3633607-8E8B-42A1-B777-6E2969072E58',0,'서브메뉴영역',0,100,20000,1,1,1,1,null,null,null,null,null,null,0);
Insert into TBL_TOPMENU_ITEMS (UID_,PAGEUID,PARENTPAGEUID,OWNERPAGEID,MENUITEMTYPE,DISPLAYNAME,WIDTH,HEIGHT,ROWPOS,COLUMNPOS,CANREMOVE,CANRESIZE,CANREPLACE,ALIGN,VALIGN,TOPMARGIN,BOTTOMMARGIN,LEFTMARGIN,RIGHTMARGIN,TENANT_ID) values ('204','64aa1712-8a96-4b25-aa9c-51e74282d54f','top','d4dcceee-01f5-42da-9093-a243d3056204',0,'서브메뉴영역',0,100,20000,1,1,1,1,null,null,null,null,null,null,0);

Insert into TBL_USERSTARTPAGE_ITEM (UID_,PARENTUID,IMAGEUID,ACCESSID,COMPANYID,LINKURL,LANG,TENANT_ID) values ('cf34747c-d809-461d-93d9-e50486ae3b68','F3633607-8E8B-42A1-B777-6E2969072E58','d7e86d24-137e-4934-bf70-87fed28f5530','gisa1','Top','/ezPortal/myPortal.do','1',0);

--circular insert

Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',0,'CHECK','CHECK','CHECK',NULL,'ITEMID',20,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',1,NULL,'IMPORTANCE',NULL,NULL,'IMPORTANCE',28,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',2,NULL,'CONFIRMSTATUS',NULL,NULL,'CONFIRMSTATUS',28,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',3,NULL,'COMMENTSTATUS',NULL,NULL,'COMMENTSTATUS',28,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',4,NULL,'HASFILE',NULL,NULL,'HASFILE',28,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',5,'제목','TITLE','タイトル',NULL,'TITLE',350,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',6,'작성자','MEMBERNAME','作成者',NULL,'MEMBERNAME',100,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',7,'등록일','REGDATE','登録日',NULL,'REGDATE',140,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',8,'확인','CONFIRM','確認',NULL,'CONFIRM',55,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',9,'상태','STATUS','ステータス',NULL,'STATUS',75,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',0,'CHECK','CHECK','CHECK',NULL,'ITEMID',20,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',1,NULL,'IMPORTANCE',NULL,NULL,'IMPORTANCE',28,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',2,NULL,'CONFIRMSTATUS',NULL,NULL,'CONFIRMSTATUS',28,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',3,NULL,'HASFILE',NULL,NULL,'HASFILE',28,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',4,'제목','TITLE','タイトル',NULL,'TITLE',350,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',5,'작성자','MEMBERNAME','作成者',NULL,'MEMBERNAME',100,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',6,'등록일','REGDATE','登録日',NULL,'REGDATE',140,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',7,'확인','CONFIRM','確認',NULL,'CONFIRM',55,0);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',8,'상태','STATUS','ステータス',NULL,'STATUS',75,0);

-------------------------- 업무일지 ---------------------------------
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t05','Top',0);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t06','Top',0);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t07','Top',0);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t08','Top',0);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t09','Top',0);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t10','Top',0);

Insert into tbl_journal_form (form_id,tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) 
values (seq_tbl_journal_form.nextval,0,'일일업무일지(기본)',
to_clob('<div>
   <table width="629" align="center" style="border-collapse:collapse; width: 629px; font-family: 굴림체; font-size: 0pt; table-layout: fixed; -design-time-lock: true; ">
      <tbody>
         <tr>
            <td width="629" height="60" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 60px; vertical-align: middle;" colspan="2">
               <table width="629" style="width: 629px; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="629" height="50" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 50px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-size: 24pt; font-weight: bold;">일일업무일지</span>
                           </p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
         <tr>
            <td width="12" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 12px; height: 71px; vertical-align: middle;">
               <p style="font-family: 맑은 고딕; font-size: 13px; margin-top: 0pt; margin-bottom: 0pt;">
                  <span>&nbsp;</span>
               </p>
            </td>
            <td width="315" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 313px; height: 71px; vertical-align: middle;">
               <div>
                  <table width="311" align="right" style="border-collapse:collapse; width: 311px; height: 69px; font-family: 굴림체; font-size: 10pt; table-layout: fixed; -design-time-lock: true;">
                     <tbody>
                        <tr>
                           <td width="115"style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">부&nbsp;&nbsp;서&nbsp;&nbsp;명</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterDept" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterDept</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">')||
to_clob('<p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;자</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterName" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterName</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-bottom-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-bottom-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;일</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriteDate" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 186px; vertical-align: middle;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriteDate</p>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
            </td>
         </tr>
         <tr>
            <td width="629" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; vertical-align: top; padding-top: 5px;" colspan="2" free="">
               <div>
                  <span>
                     <br>
                  </span>
               </div>
               <table width="630" style="border-collapse:collapse; width: 630px; height: 100%; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="104" height="38" style="width: 104px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">구&nbsp;분</span>
                           </p>
                        </td>')||
to_clob('<td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">업무내용 및 진행사항</span>
                           </p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="width: 104px; height: 200px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">금&nbsp;일</span>
                           </p>
                        </td>
                        <td width="520" id="thisJournal" style="width: 520px; vertical-align: top; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="border-width: 1px medium 1px 1px; border-style: solid none solid solid; border-color: rgb(0, 0, 0) currentColor rgb(0, 0, 0) rgb(0, 0, 0); border-image: none; width: 104px; height: 200px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">익&nbsp;일</span>
                           </p>
                        </td>
                        <td width="520" id="nextJournal" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 520px; vertical-align: top;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
      </tbody>
   </table>
</div>
<div>
   <span>
      <br>
   </span>
</div>
<p>
   <span>&nbsp;</span>
</p>')
,'ezJournal.t05',SYS_EXTRACT_UTC(SYSTIMESTAMP),'기본일일업무일지','Top','basic');

Insert into tbl_journal_form (form_id,tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) 
values (seq_tbl_journal_form.nextval,0,'주간업무일지(기본)',
to_clob('<div>
   <table width="629" align="center" style="border-collapse:collapse; width: 629px; font-family: 굴림체; font-size: 0pt; table-layout: fixed; -design-time-lock: true; ">
      <tbody>
         <tr>
            <td width="629" height="60" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 60px; vertical-align: middle;" colspan="2">
               <table width="629" style="width: 629px; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="629" height="50" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 50px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-size: 24pt; font-weight: bold;">주간업무일지</span>
                           </p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
         <tr>
            <td width="12" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 12px; height: 71px; vertical-align: middle;">
               <p style="font-family: 맑은 고딕; font-size: 13px; margin-top: 0pt; margin-bottom: 0pt;">
                  <span>&nbsp;</span>
               </p>
            </td>
            <td width="315" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 313px; height: 71px; vertical-align: middle;">
               <div>
                  <table width="311" align="right" style="border-collapse:collapse; width: 311px; height: 69px; font-family: 굴림체; font-size: 10pt; table-layout: fixed; -design-time-lock: true;">
                     <tbody>
                        <tr>
                           <td width="115"style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">부&nbsp;&nbsp;서&nbsp;&nbsp;명</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterDept" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterDept</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">')||
to_clob('<p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;자</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterName" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterName</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-bottom-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-bottom-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;일</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriteDate" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 186px; vertical-align: middle;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriteDate</p>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
            </td>
         </tr>
         <tr>
            <td width="629" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; vertical-align: top; padding-top: 5px;" colspan="2" free="">
               <div>
                  <span>
                     <br>
                  </span>
               </div>
               <table width="630" style="border-collapse:collapse; width: 630px; height: 100%; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="104" height="38" style="width: 104px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">구&nbsp;분</span>
                           </p>
                        </td>')||
to_clob('<td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">업무내용 및 진행사항</span>
                           </p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="width: 104px; height: 200px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">금&nbsp;주</span>
                           </p>
                        </td>
                        <td width="520" id="thisJournal" style="width: 520px; vertical-align: top; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="border-width: 1px medium 1px 1px; border-style: solid none solid solid; border-color: rgb(0, 0, 0) currentColor rgb(0, 0, 0) rgb(0, 0, 0); border-image: none; width: 104px; height: 200px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">차&nbsp;주</span>
                           </p>
                        </td>
                        <td width="520" id="nextJournal" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 520px; vertical-align: top;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
      </tbody>
   </table>
</div>
<div>
   <span>
      <br>
   </span>
</div>
<p>
   <span>&nbsp;</span>
</p>')
,'ezJournal.t06',SYS_EXTRACT_UTC(SYSTIMESTAMP),'기본주간업무일지','Top','basic');

Insert into tbl_journal_form (form_id,tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) 
values (seq_tbl_journal_form.nextval,0,'월간업무일지(기본)',
to_clob('<div>
   <table width="629" align="center" style="border-collapse:collapse; width: 629px; font-family: 굴림체; font-size: 0pt; table-layout: fixed; -design-time-lock: true; ">
      <tbody>
         <tr>
            <td width="629" height="60" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 60px; vertical-align: middle;" colspan="2">
               <table width="629" style="width: 629px; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="629" height="50" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 50px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-size: 24pt; font-weight: bold;">월간업무일지</span>
                           </p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
         <tr>
            <td width="12" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 12px; height: 71px; vertical-align: middle;">
               <p style="font-family: 맑은 고딕; font-size: 13px; margin-top: 0pt; margin-bottom: 0pt;">
                  <span>&nbsp;</span>
               </p>
            </td>
            <td width="315" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 313px; height: 71px; vertical-align: middle;">
               <div>
                  <table width="311" align="right" style="border-collapse:collapse; width: 311px; height: 69px; font-family: 굴림체; font-size: 10pt; table-layout: fixed; -design-time-lock: true;">
                     <tbody>
                        <tr>
                           <td width="115"style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">부&nbsp;&nbsp;서&nbsp;&nbsp;명</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterDept" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterDept</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">')||
to_clob('<p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;자</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterName" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterName</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-bottom-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-bottom-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;일</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriteDate" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 186px; vertical-align: middle;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriteDate</p>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
            </td>
         </tr>
         <tr>
            <td width="629" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; vertical-align: top; padding-top: 5px;" colspan="2" free="">
               <div>
                  <span>
                     <br>
                  </span>
               </div>
               <table width="630" style="border-collapse:collapse; width: 630px; height: 100%; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="104" height="38" style="width: 104px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">구&nbsp;분</span>
                           </p>
                        </td>')||
to_clob('<td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">업무내용 및 진행사항</span>
                           </p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="width: 104px; height: 200px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">금&nbsp;월</span>
                           </p>
                        </td>
                        <td width="520" id="thisJournal" style="width: 520px; vertical-align: top; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="border-width: 1px medium 1px 1px; border-style: solid none solid solid; border-color: rgb(0, 0, 0) currentColor rgb(0, 0, 0) rgb(0, 0, 0); border-image: none; width: 104px; height: 200px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">익&nbsp;월</span>
                           </p>
                        </td>
                        <td width="520" id="nextJournal" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 520px; vertical-align: top;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
      </tbody>
   </table>
</div>
<div>
   <span>
      <br>
   </span>
</div>
<p>
   <span>&nbsp;</span>
</p>')
,'ezJournal.t07',SYS_EXTRACT_UTC(SYSTIMESTAMP),'기본월간업무일지','Top','basic');

Insert into tbl_journal_form (form_id,tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) 
values (seq_tbl_journal_form.nextval,0,'분기업무일지(기본)',
to_clob('<div>
   <table width="629" align="center" style="border-collapse:collapse; width: 629px; font-family: 굴림체; font-size: 0pt; table-layout: fixed; -design-time-lock: true; ">
      <tbody>
         <tr>
            <td width="629" height="60" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 60px; vertical-align: middle;" colspan="2">
               <table width="629" style="width: 629px; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="629" height="50" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 50px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-size: 24pt; font-weight: bold;">분기업무일지</span>
                           </p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
         <tr>
            <td width="12" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 12px; height: 71px; vertical-align: middle;">
               <p style="font-family: 맑은 고딕; font-size: 13px; margin-top: 0pt; margin-bottom: 0pt;">
                  <span>&nbsp;</span>
               </p>
            </td>
            <td width="315" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 313px; height: 71px; vertical-align: middle;">
               <div>
                  <table width="311" align="right" style="border-collapse:collapse; width: 311px; height: 69px; font-family: 굴림체; font-size: 10pt; table-layout: fixed; -design-time-lock: true;">
                     <tbody>
                        <tr>
                           <td width="115"style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">부&nbsp;&nbsp;서&nbsp;&nbsp;명</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterDept" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterDept</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">')||
to_clob('<p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;자</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterName" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterName</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-bottom-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-bottom-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;일</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriteDate" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 186px; vertical-align: middle;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriteDate</p>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
            </td>
         </tr>
         <tr>
            <td width="629" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; vertical-align: top; padding-top: 5px;" colspan="2" free="">
               <div>
                  <span>
                     <br>
                  </span>
               </div>
               <table width="630" style="border-collapse:collapse; width: 630px; height: 100%; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="104" height="38" style="width: 104px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">구&nbsp;분</span>
                           </p>
                        </td>')||
to_clob('<td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">업무내용 및 진행사항</span>
                           </p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="width: 104px; height: 200px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">금분기</span>
                           </p>
                        </td>
                        <td width="520" id="thisJournal" style="width: 520px; vertical-align: top; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="border-width: 1px medium 1px 1px; border-style: solid none solid solid; border-color: rgb(0, 0, 0) currentColor rgb(0, 0, 0) rgb(0, 0, 0); border-image: none; width: 104px; height: 200px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">차분기</span>
                           </p>
                        </td>
                        <td width="520" id="nextJournal" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 520px; vertical-align: top;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
      </tbody>
   </table>
</div>
<div>
   <span>
      <br>
   </span>
</div>
<p>
   <span>&nbsp;</span>
</p>')
,'ezJournal.t08',SYS_EXTRACT_UTC(SYSTIMESTAMP),'기본분기업무일지','Top','basic');

Insert into tbl_journal_form (form_id,tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) 
values (seq_tbl_journal_form.nextval,0,'반기업무일지(기본)',
to_clob('<div>
   <table width="629" align="center" style="border-collapse:collapse; width: 629px; font-family: 굴림체; font-size: 0pt; table-layout: fixed; -design-time-lock: true; ">
      <tbody>
         <tr>
            <td width="629" height="60" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 60px; vertical-align: middle;" colspan="2">
               <table width="629" style="width: 629px; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="629" height="50" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 50px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-size: 24pt; font-weight: bold;">반기업무일지</span>
                           </p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
         <tr>
            <td width="12" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 12px; height: 71px; vertical-align: middle;">
               <p style="font-family: 맑은 고딕; font-size: 13px; margin-top: 0pt; margin-bottom: 0pt;">
                  <span>&nbsp;</span>
               </p>
            </td>
            <td width="315" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 313px; height: 71px; vertical-align: middle;">
               <div>
                  <table width="311" align="right" style="border-collapse:collapse; width: 311px; height: 69px; font-family: 굴림체; font-size: 10pt; table-layout: fixed; -design-time-lock: true;">
                     <tbody>
                        <tr>
                           <td width="115"style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">부&nbsp;&nbsp;서&nbsp;&nbsp;명</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterDept" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterDept</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">')||
to_clob('<p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;자</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterName" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterName</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-bottom-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-bottom-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;일</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriteDate" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 186px; vertical-align: middle;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriteDate</p>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
            </td>
         </tr>
         <tr>
            <td width="629" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; vertical-align: top; padding-top: 5px;" colspan="2" free="">
               <div>
                  <span>
                     <br>
                  </span>
               </div>
               <table width="630" style="border-collapse:collapse; width: 630px; height: 100%; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="104" height="38" style="width: 104px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">구&nbsp;분</span>
                           </p>
                        </td>')||
to_clob('<td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">업무내용 및 진행사항</span>
                           </p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="width: 104px; height: 200px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">금반기</span>
                           </p>
                        </td>
                        <td width="520" id="thisJournal" style="width: 520px; vertical-align: top; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="border-width: 1px medium 1px 1px; border-style: solid none solid solid; border-color: rgb(0, 0, 0) currentColor rgb(0, 0, 0) rgb(0, 0, 0); border-image: none; width: 104px; height: 200px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">차반기</span>
                           </p>
                        </td>
                        <td width="520" id="nextJournal" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 520px; vertical-align: top;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
      </tbody>
   </table>
</div>
<div>
   <span>
      <br>
   </span>
</div>
<p>
   <span>&nbsp;</span>
</p>')
,'ezJournal.t09',SYS_EXTRACT_UTC(SYSTIMESTAMP),'기본반기업무일지','Top','basic');

Insert into tbl_journal_form (form_id,tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) 
values (seq_tbl_journal_form.nextval,0,'연간업무일지(기본)',
to_clob('<div>
   <table width="629" align="center" style="border-collapse:collapse; width: 629px; font-family: 굴림체; font-size: 0pt; table-layout: fixed; -design-time-lock: true; ">
      <tbody>
         <tr>
            <td width="629" height="60" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 60px; vertical-align: middle;" colspan="2">
               <table width="629" style="width: 629px; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="629" height="50" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; height: 50px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-size: 24pt; font-weight: bold;">연간업무일지</span>
                           </p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
         <tr>
            <td width="12" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 12px; height: 71px; vertical-align: middle;">
               <p style="font-family: 맑은 고딕; font-size: 13px; margin-top: 0pt; margin-bottom: 0pt;">
                  <span>&nbsp;</span>
               </p>
            </td>
            <td width="315" height="71" style="border: 1px rgb(255, 255, 255); border-image: none; width: 313px; height: 71px; vertical-align: middle;">
               <div>
                  <table width="311" align="right" style="border-collapse:collapse; width: 311px; height: 69px; font-family: 굴림체; font-size: 10pt; table-layout: fixed; -design-time-lock: true;">
                     <tbody>
                        <tr>
                           <td width="115"style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">부&nbsp;&nbsp;서&nbsp;&nbsp;명</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterDept" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterDept</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">')||
to_clob('<p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;자</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriterName" style="width: 186px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriterName</p>
                           </td>
                        </tr>
                        <tr>
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-bottom-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-bottom-width: 1px; border-left-width: 1px; border-top-style: solid; border-bottom-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                                 <span style="font-weight: bold;">작&nbsp;&nbsp;성&nbsp;&nbsp;일</span>
                              </p>
                           </td>
                           <td width="186" class="FIELD" id="journalWriteDate" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 186px; vertical-align: middle;" free="">
                              <p style="font-family: 맑은 고딕; font-size: 13px;">@journalWriteDate</p>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
            </td>
         </tr>
         <tr>
            <td width="629" style="border: 1px rgb(255, 255, 255); border-image: none; width: 629px; vertical-align: top; padding-top: 5px;" colspan="2" free="">
               <div>
                  <span>
                     <br>
                  </span>
               </div>
               <table width="630" style="border-collapse:collapse; width: 630px; height: 100%; font-family: 굴림체; font-size: 10pt;">
                  <tbody>
                     <tr>
                        <td width="104" height="38" style="width: 104px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">구&nbsp;분</span>
                           </p>
                        </td>')||
to_clob('<td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">업무내용 및 진행사항</span>
                           </p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="width: 104px; height: 200px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">금&nbsp;년</span>
                           </p>
                        </td>
                        <td width="520" id="thisJournal" style="width: 520px; vertical-align: top; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                     <tr>
                        <td width="104" height="200" style="border-width: 1px medium 1px 1px; border-style: solid none solid solid; border-color: rgb(0, 0, 0) currentColor rgb(0, 0, 0) rgb(0, 0, 0); border-image: none; width: 104px; height: 200px; vertical-align: middle;">
                           <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
                              <span style="font-weight: bold;">익&nbsp;년</span>
                           </p>
                        </td>
                        <td width="520" id="nextJournal" style="border: 1px solid rgb(0, 0, 0); border-image: none; width: 520px; vertical-align: top;" free="">
                           <p style="font-family: 맑은 고딕; font-size: 13px;">&nbsp;</p>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </td>
         </tr>
      </tbody>
   </table>
</div>
<div>
   <span>
      <br>
   </span>
</div>
<p>
   <span>&nbsp;</span>
</p>')
,'ezJournal.t10',SYS_EXTRACT_UTC(SYSTIMESTAMP),'기본연간업무일지','Top','basic');

-- webfolder fileType 
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('1','document','doc','/images/webfolder/msWord.png',0,'문서');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('2','document','docx','/images/webfolder/msWord.png',0,'문서');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('3','document','xls','/images/webfolder/msExcel.png',0,'문서');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('4','document','xlsx','/images/webfolder/msExcel.png',0,'문서');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('5','document','ppt','/images/webfolder/msPowerpoint.png',0,'문서');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('6','document','pptx','/images/webfolder/msPowerpoint.png',0,'문서');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('7','music','mp3','/images/webfolder/mp3.png',0,'음악');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('8','image','gif','/images/webfolder/gif.png',0,'그림');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('9','image','jpeg','/images/webfolder/jpeg.png',0,'그림');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('10','image','jpg','/images/webfolder/jpg.png',0,'그림');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('11','zip','zip','/images/webfolder/zip.png',0,'압축파일');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('12','zip','rar','/images/webfolder/rar.png',0,'압축파일');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('13','zip','iso','/images/webfolder/iso.png',0,'압축파일');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('14','document','pdf','/images/webfolder/pdf.png',0,'문서');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('15','document','hwp','/images/webfolder/hwp.png',0,'문서');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('16','image','png','/images/webfolder/png.png',0,'그림');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('17','folder','folder','/images/webfolder/fldr.png',0,'폴더');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('18','video','mp4','/images/webfolder/mp4.png',0,'영상');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('19','video','mkv','/images/webfolder/mkv.png',0,'영상');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('20','video','flv','/images/webfolder/flv.png',0,'영상');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('21','unknown','unknown','/images/webfolder/unknown.png',0,'기타');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('22','document','txt','/images/webfolder/txt.png',0,'문서');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('23','video','avi','/images/webfolder/video.png',0,'영상');
Insert into TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('24','video','wmv','/images/webfolder/video.png',0,'영상');

--webfolder config
INSERT INTO TBL_WEBFOLDER_CONFIG VALUES(0,'*',1,1,1,1);

-- attitude(근태) form데이터
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (0,0,'폼1','form1','<tr><th>성명</th><td id="writerName" style=""></td></tr><tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="3"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /> ~<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>연락처</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>업무대리</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (1,0,'폼2','form2','<tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="2"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (2,0,'폼3','form3','<tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="2"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (3,0,'폼4','form4','<tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="2"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (4,0,'폼5','form5','<tr><th>성명</th><td id="writerName" style=""></td></tr><tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="1"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"></span></td></tr><tr> <th>연락처</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>업무대리</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (5,0,'폼6','form6','<tr><th>성명</th><td id="writerName" style=""></td></tr><tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="2"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>연락처</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>업무대리</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (6,0,'폼7','form7','<tr><th>성명</th><td id="writerName" style=""></td></tr><tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="3"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /> ~<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>연락처</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>업무대리</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (7,0,'폼8','form8','<tr><th>성명</th><td id="writerName" style=""></td></tr><tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="4"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></span></td></tr><tr> <th>근무지</th> <td id="region" style=""><input name="region" type="text" style="width:98%" value=""  maxlength="200"></td> </tr><tr> <th>연락처</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>업무대리</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (8,0,'폼9','form9','<tr><th>성명</th><td id="writerName" style=""></td></tr><tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="5"><input name="checkbox" type="checkbox" id="alldaycheck" style="height:22px;" onclick="allday_change()" value="1">하루종일 <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>근무지</th> <td id="region" style=""><input name="region" type="text" style="width:98%" value=""  maxlength="200"></td> </tr><tr> <th>연락처</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>업무대리</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (9,0,'폼10','form10','<tr><th>성명</th><td id="writerName" style=""></td></tr><tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="4"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></span></td></tr><tr> <th>연락처</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>업무대리</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML) VALUES (10,0,'폼11','form11','<tr><th>성명</th><td id="writerName" style=""></td></tr><tr><th>일시 </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="3"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /> ~<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>연락처</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr>');

-- attitude conf
INSERT INTO TBL_ATTITUDE_CONF (COMPANY_ID, TENANT_ID, WORK_STARTTIME, WORK_ENDTIME, CLOSED_DAY, ATTITUDE_MOD_APPL, CLOSED_DATE_ATTITUDE, CONF_SET_DATE) VALUES ('Top', 0, '00:00', '09:00', '1,0,0,0,0,0,1', '1', '1', SYSDATE);

-- attitude Type
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A01', 'Top', 0, '출근', 'check in', '1', 'inOut', null, 1);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A02', 'Top', 0, '지각', 'late', '1', 'inOut', null, 2);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A03', 'Top', 0, '퇴근', 'check out', '1', 'inOut', null, 3);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A07', 'Top', 0, '휴근', 'working Holiday', '1', 'inOut', null, 6);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A04', 'Top', 0, '외근', 'outside work', '1', 'trip', null, 8);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A06', 'Top', 0, '외출', 'outing', '1', 'trip', null, 6);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A05', 'Top', 0, '휴가', 'vacation', '1', 'refresh', null, 0);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A09', 'Top', 0, '출장', 'business trip', '1', 'trip', null, 7);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A10', 'Top', 0, '파견', 'dispatch', '1', 'trip', null, 7);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A08', 'Top', 0, '조퇴', 'early leave', '1', 'absence', null, 5);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A17', 'Top', 0, '결근', 'absenteeism', '1', 'absence', null, 4);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A11', 'Top', 0, '연차', 'annual leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A12', 'Top', 0, '오전반차', 'morning off', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A13', 'Top', 0, '오후반차', 'afternoon off', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A14', 'Top', 0, '공가', 'official leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A15', 'Top', 0, '오전공가', 'morning official leave', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A16', 'Top', 0, '오후공가', 'after official leave', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A18', 'Top', 0, '산휴', 'maternity leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A19', 'Top', 0, '경조', 'congratulation and condolence leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A20', 'Top', 0, '병가', 'sick leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE ("ORDER", TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES (SEQ_TBL_ATTITUDE_TYPE.nextval, 'A21', 'Top', 0, '반반차', 'half off', '1', 'refresh', 'A05', 4);

-- nonElecRec initData
Insert into TBL_FORMINFO (FORMCONTID,FORMID,FORMNAME,FORMNAME2,FORMDOCTYPE,FORMDESCRIPTION,FORMFILELOCATION,FORMCONNFLAG,FORMORDER,TENANT_ID,COMPANYID,FORMDRAFTALLFLAG) values ('2018000000','2018000000','비전자문서양식','비전자문서양식','003','비전자문서양식','/fileroot/0/files/upload_approvalG/Top/form/2018000000.hwp','N',null,0,'Top','1');
Insert into TBL_FORMINFO (FORMCONTID,FORMID,FORMNAME,FORMNAME2,FORMDOCTYPE,FORMDESCRIPTION,FORMFILELOCATION,FORMCONNFLAG,FORMORDER,TENANT_ID,COMPANYID,FORMDRAFTALLFLAG) values ('2021000000','2021000000','비전자문서양식','비전자문서양식','003','비전자문서양식','/fileroot/0/files/upload_approvalG/Top/form/2021000000.mht','N',null,0,'Top','1');

-- 날씨 도시 데이터
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('10','1832157','Reisui','여수','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('7','1833747','Ulsan','울산','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('2','1835235','Daejeon','대전','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('3','1835329','Daegu','대구','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('1','1835848','Seoul','서울','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('4','1838524','Busan','부산','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('9','1841811','Gwangju','광주','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('5','1843137','Kang-neung','강릉','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('6','1845136','Chuncheon','춘천','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('8','1845457','Jeonju','전주','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('11','1846266','Jeju','제주도','1',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('1','1850147','Tokyo','東京','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('3','1853909','Osaka-shi','大阪市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('4','1854383','Okayama-shi','岡山市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('13','1855431','Niigata-shi','新潟市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('10','1856057','Nagoya-shi','名古屋市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('11','1856215','Nagano-shi','長野市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('5','1857910','Kyoto','京都市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('6','1860827','Kagoshima-shi','鹿児島市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('8','1862415','Hiroshima-shi','広島市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('7','1863967','Fukuoka-shi','福岡市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('9','1926099','Matsuyama-shi','松山市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('12','2112923','Fukushima-shi','福島市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('15','2128295','Sapporo-shi','札幌市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('14','2130658','Aomori-shi','青森市','3',NULL,NULL);
INSERT INTO tbl_weather (SN,CITYCODE,CITYNAME,DISPLAYCITYNAME,PRIMARYLANG,CURRENTWEATHER,TODAYWEATHER) VALUES ('2','6697514','Asahi','旭市','3',NULL,NULL);

-- 포탈 개인화
INSERT INTO TBL_PORTAL_THEME (theme_id, theme_name, theme_name2, theme_name3, theme_content, theme_content2, theme_content3) VALUES (1, '테마1', 'Theme1', 'Theme1', '왼쪽 혹은 오른쪽에 사용자 관련 정보가 있는 디자인의 테마입니다.', 'A theme with a fixed area on the left or right.', '固定領域を画面の右または左に配置できるテーマです。');
INSERT INTO TBL_PORTAL_THEME (theme_id, theme_name, theme_name2, theme_name3, theme_content, theme_content2, theme_content3) VALUES (2, '테마2', 'Theme2', 'Theme2', '위쪽에 사용자 관련 정보가 있는 디자인의 테마입니다.', 'A theme with a fixed area on the top.', '固定領域が画面の上部に表示されるテーマです。');
INSERT INTO TBL_PORTAL_THEME (theme_id, theme_name, theme_name2, theme_name3, theme_content, theme_content2, theme_content3) VALUES (3, '테마3', 'Theme3', 'Theme3', '기본 정보관련 영역이 없이 포틀릿에 집중할 수 있는 테마 입니다.', 'A theme that consists of only portlets without fixed areas.', '固定領域がなく、すべてのポートレットを自由に配置できるテーマです。');
-- 모바일 테마
INSERT INTO TBL_PORTAL_THEME (theme_id, theme_name, theme_name2, theme_name3, theme_content, theme_content2, theme_content3, theme_content4, theme_content5, theme_content6) VALUES (4, '테마4', 'Theme4', 'Theme4', '모바일용 포틀릿 테마 입니다.', 'Theme For Mobile', 'モバイルのテーマ', '手机主题', 'Theme For Mobile', 'Theme For Mobile');

INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (0, '/ezNewPortal/newPortalPortalPage.do', 'G', '', 0, 'portal');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (1, '/ezEmail/mailMain.do', 'G', 'icon_topmenu icon_nav_mail', 1, 'mail');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (2, '/ezSchedule/scheduleIndex.do?funCode=2', 'G', 'icon_topmenu icon_nav_calendar', 2, 'schedule');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (3, '/ezApprovalG/apprGMain.do', 'G', 'icon_topmenu icon_nav_approval', 3, 'approval');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (4, '/ezBoard/boardMain.do', 'G', 'icon_topmenu icon_nav_board', 4, 'board');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (5, '/ezCommunity/communityMain.do', 'G', 'icon_topmenu icon_nav_community', 5, 'community');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (6, '/ezResource/resMain.do', 'G', 'icon_topmenu icon_nav_resource', 6, 'resource');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (7, '/ezCircular/circularIndex.do', 'G', 'icon_topmenu icon_nav_circular_edition', 7, 'circular');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (8, '/ezJournal/journalMain.do', 'G', 'icon_topmenu icon_nav_workdiary', 8, 'journal');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (9, '/ezAttitude/attitudeMain.do', 'G', 'icon_topmenu icon_nav_absenteeism', 9, 'attitude');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (10, '/ezWebFolder/webfolderMain.do', 'G', 'icon_topmenu icon_nav_webfolder', 10, 'webfolder');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (11, '/ezCabinet/cabinetMain.do', 'G', 'icon_topmenu icon_nav_cabinet', 11, 'cabinet');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (12, '/ezPMS/pmsMain.do', 'G', 'icon_topmenu icon_nav_project', 12, 'pms');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (13, '/ezEmail/mailMain.do?funCode=2', 'G', 'icon_topmenu icon_nav_addressbook', 13, 'address');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (14, '/ezQuestion/qstMain.do', 'G', 'icon_topmenu icon_nav_survey', 14, 'question');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (15, '/ezPoll/pollMain.do', 'G', 'icon_topmenu icon_nav_voting', 15, 'vote');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (16, '/ezLadder/ladderMainPage.do', 'G', 'icon_topmenu icon_nav_laddergame', 16, 'ladder');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (17, '/ezTask/taskIndex.do', 'G', 'icon_topmenu icon_nav_work', 17, 'task');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (18, '/ezMemo/memoMainPage.do', 'G', 'icon_topmenu icon_nav_memo', 18, 'memo');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (19, '/ezSurvey/surveyMain.do', 'G', 'icon_topmenu icon_nav_survey', 19, 'survey');
INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (20, '/ezCar/resCar.do', 'G', 'icon_topmenu icon_nav_workdiary', 20, 'car');

UPDATE TBL_PORTAL_MENU SET menu_id = 0 WHERE default_order = 0;

INSERT INTO TBL_PORTAL_FRAME (frame_id, frame_name, theme_id) VALUES (1, 'Frame1', 1);
INSERT INTO TBL_PORTAL_FRAME (frame_id, frame_name, theme_id) VALUES (2, 'Frame2', 1);
INSERT INTO TBL_PORTAL_FRAME (frame_id, frame_name, theme_id) VALUES (3, 'Frame3', 1);
INSERT INTO TBL_PORTAL_FRAME (frame_id, frame_name, theme_id) VALUES (4, 'Frame4', 1);
INSERT INTO TBL_PORTAL_FRAME (frame_id, frame_name, theme_id) VALUES (5, 'Frame1', 2);
INSERT INTO TBL_PORTAL_FRAME (frame_id, frame_name, theme_id) VALUES (6, 'Frame1', 3);
INSERT INTO TBL_PORTAL_FRAME (frame_id, frame_name, theme_id) VALUES (7, 'Frame2', 2);
INSERT INTO TBL_PORTAL_FRAME (frame_id, frame_name, theme_id) VALUES (8, 'Frame2', 3);
-- 모바일 프레임
INSERT INTO TBL_PORTAL_FRAME (frame_id, frame_name, theme_id) VALUES (9, 'Frame1', 4);

INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (1, 1, '/ezNewPortal/receivedMailPortlet.do', 'G', 2, 'receivedmail');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (2, 4, '/ezNewPortal/noticePortlet.do', 'G', 1, 'notice');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (4, 15, '/ezNewPortal/votePortlet.do', 'G', 3, 'vote');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (5, 0, '/ezNewPortal/pollPortlet.do', 'G', 4, 'poll');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (6, 2, '/ezNewPortal/schedulePortlet.do', 'G', 5, 'schedule');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (7, 3, '/ezNewPortal/approvalListPortlet.do', 'G', 6, 'approvallist');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (8, 3, '/ezNewPortal/favoriteFormsPortlet.do', 'G', 7, 'favoriteforms');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (9, 4, '/ezNewPortal/photoBoardPortlet.do', 'G', 8, 'photoboard');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (10, 4, '/ezNewPortal/favoriteBoardPortlet.do', 'G', 9, 'favoriteboard');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (11, 5, '/ezNewPortal/communityPortlet.do', 'G', 10, 'community');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (12, 0, '/ezNewPortal/helpPortlet.do', 'G', 11, 'help');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (14, 0, '/ezNewPortal/weatherPortlet.do', 'G', 13, 'weather');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (26, 0, '/ezNewPortal/birthdayPortlet.do', 'G', 14, 'birthday');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (34, 0, '/ezNewPortal/slideImagePortlet.do', 'G', 15, 'slideimage');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (36, 0, '/ezNewPortal/userInfoPortlet.do', 'G', 16, 'userinfo');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (47, 4, '/ezNewPortal/movieBoardPortlet.do', 'G', 17, 'movieboard');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (49, 0, '/ezNewPortal/countPortlet.do', 'G', 19, 'count');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (51, 6, '/ezNewPortal/resourcePortlet.do', 'G', 21, 'resource');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (70, 10, '/ezNewPortal/webFolderPortlet.do', 'G', 22, 'webfolder');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (73, 19, '/ezNewPortal/surveyPortlet.do', 'G', 20, 'survey');
-- 모바일 포틀릿 추가
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (76, 4, '/mobile/ezNewPortal/getCustomBoardInfo.do', 'MG', 1, 'mFixTop');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (77, 4, '/mobile/ezNewPortal/getCustomBoardInfo.do', 'MG', 2, 'mFixBottom');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (78, 2, '/mobile/ezNewPortal/schedulePortlet.do', 'MG', 3, 'mSchedule');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (79, 6, '/mobile/ezNewPortal/resourcePortlet.do', 'MG', 4, 'mResource');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (80, 3, '/mobile/ezNewPortal/approvallistPortlet.do', 'MG', 5, 'mApprovallist');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (81, 1, '/mobile/ezNewPortal/receivedmailPortlet.do', 'MG', 6, 'mReceivedmail');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (82, 4, '/mobile/ezNewPortal/noticePortlet.do', 'MG', 7, 'mNotice');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (83, 4, '/mobile/ezNewPortal/photoboardPortlet.do', 'MG', 8, 'mPhotoboard');

-- Top이 회사인 이닛데이터
INSERT INTO TBL_PORTAL_THEME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, THEME_USED, THEME_DEFAULT) VALUES ('Top', 0, 1, 1, 1);
INSERT INTO TBL_PORTAL_THEME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, THEME_USED, THEME_DEFAULT) VALUES ('Top', 0, 2, 1, 0);
INSERT INTO TBL_PORTAL_THEME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, THEME_USED, THEME_DEFAULT) VALUES ('Top', 0, 3, 1, 0);

INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top', 0, 1, 1, 1, 1);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top', 0, 1, 2, 1, 0);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top', 0, 1, 3, 1, 0);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top', 0, 1, 4, 1, 0);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top', 0, 2, 5, 1, 1);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top', 0, 2, 7, 1, 0);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top', 0, 3, 6, 1, 1);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top', 0, 3, 8, 1, 0);
-- 모바일 포틀릿
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',0, 4, 9, 1, 1);

INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 1, 1, 1, 1);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 2, 1, 1, 2);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 3, 1, 1, 3);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 4, 1, 1, 4);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 5, 1, 1, 5);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',0, 6, 1, 1, 6);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 7, 1, 1, 7);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 8, 1, 1, 8);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 9, 1, 1, 9);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 10, 1, 1, 10);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',0, 11, 1, 1, 11);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 12, 1, 1, 12);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',0, 13, 1, 1, 13);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 14, 1, 1, 14);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 15, 1, 1, 15);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top', 0, 16, 1, 1, 16);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',0, 17, 1, 1, 17);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',0, 18, 1, 1, 18);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',0, 19, 1, 1, 19);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',0, 20, 0, 1, 20);
				
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (0, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (1, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (2, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (3, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (4, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (5, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (6, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (7, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (8, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (9, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (10, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (11, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (12, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (13, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (14, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (15, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (16, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (17, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (18, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (19, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (20, 'Top', 0, 'Top', 1, 0, 1);

INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (1, 1, 'Top', 0, '메일');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (1, 2, 'Top', 0, 'E-Mail');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (1, 3, 'Top', 0, 'メール');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (2, 1, 'Top', 0, '일정관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (2, 2, 'Top', 0, 'Schedule');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (2, 3, 'Top', 0, '日程管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (3, 1, 'Top', 0, '전자결재');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (3, 2, 'Top', 0, 'Approval');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (3, 3, 'Top', 0, '電子決裁');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (4, 1, 'Top', 0, '게시판');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (4, 2, 'Top', 0, 'Board');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (4, 3, 'Top', 0, '掲示板');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (5, 1, 'Top', 0, '커뮤니티');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (5, 2, 'Top', 0, 'Community');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (5, 3, 'Top', 0, 'コミュニティ');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (6, 1, 'Top', 0, '자원관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (6, 2, 'Top', 0, 'Resource');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (6, 3, 'Top', 0, '設備管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (7, 1, 'Top', 0, '회람판');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (7, 2, 'Top', 0, 'Circular');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (7, 3, 'Top', 0, '回覧板');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (8, 1, 'Top', 0, '업무일지');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (8, 2, 'Top', 0, 'Journal');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (8, 3, 'Top', 0, 'ジャーナル');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (9, 1, 'Top', 0, '근태관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (9, 2, 'Top', 0, 'Attitude');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (9, 3, 'Top', 0, '勤怠管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (10, 1, 'Top', 0, '웹폴더');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (10, 2, 'Top', 0, 'WebFolder');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (10, 3, 'Top', 0, 'Webフォルダ');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (11, 1, 'Top', 0, '캐비넷');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (11, 2, 'Top', 0, 'Cabinet');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (11, 3, 'Top', 0, 'キャビネット');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (12, 1, 'Top', 0, '프로젝트관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (12, 2, 'Top', 0, 'PMS');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (12, 3, 'Top', 0, 'プロジェクト管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (13, 1, 'Top', 0, '주소록');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (13, 2, 'Top', 0, 'Contacts');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (13, 3, 'Top', 0, 'アドレス帳');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (14, 1, 'Top', 0, '설문조사');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (14, 2, 'Top', 0, 'Poll');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (14, 3, 'Top', 0, '電子アンケート');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (15, 1, 'Top', 0, '투표');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (15, 2, 'Top', 0, 'Vote');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (15, 3, 'Top', 0, '投票');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (16, 1, 'Top', 0, '사다리게임');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (16, 2, 'Top', 0, 'LadderGame');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (16, 3, 'Top', 0, 'はしごゲーム');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (17, 1, 'Top', 0, '업무관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (17, 2, 'Top', 0, 'Tasks');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (17, 3, 'Top', 0, 'To Do');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (18, 1, 'Top', 0, '메모');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (18, 2, 'Top', 0, 'Memo');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (18, 3, 'Top', 0, 'メモ帳');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (19, 1, 'Top', 0, '전자설문');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (19, 2, 'Top', 0, 'Survey');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (19, 3, 'Top', 0, '電子アンケート');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (20, 1, 'Top', 0, '차량관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (20, 2, 'Top', 0, 'Car');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (20, 3, 'Top', 0, '自動車');

INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 1, 1, 1, 2, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 2, 4, 1, 1, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 4, 15, 1, 3, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 5, 0, 1, 4, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 6, 2, 1, 5, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 7, 3, 1, 6, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 8, 3, 1, 7, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 9, 4, 1, 8, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 10, 4, 1, 9, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 11, 5, 1, 10, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 12, 0, 1, 11, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 14, 0, 1, 13, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 26, 0, 1, 14, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 34, 0, 1, 15, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 36, 0, 1, 16, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 47, 4, 1, 17, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 49, 0, 1, 18, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 51, 6, 1, 21, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 70, 10, 1, 22, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 73, 19, 1, 20, null);
-- 모바일 포틀릿
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',0, 76, 4, 1, 1, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',0, 77, 4, 1, 2, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',0, 78, 2, 1, 3, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',0, 79, 6, 1, 4, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',0, 80, 3, 1, 5, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',0, 81, 1, 1, 6, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',0, 82, 4, 1, 7, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',0, 83, 4, 1, 8, null);
                
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (1, 1, 1, 0, 'Top', '받은 메일');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (1, 1, 2, 0, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (1, 1, 3, 0, 'Top', '受信トレイ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (2, 4, 1, 0, 'Top', '공지사항');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (2, 4, 2, 0, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (2, 4, 3, 0, 'Top', 'お知らせ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (4, 15, 1, 0, 'Top', '투표');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (4, 15, 2, 0, 'Top', 'Vote');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (4, 15, 3, 0, 'Top', '投票');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (5, 0, 1, 0, 'Top', '빠른설문');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (5, 0, 2, 0, 'Top', 'Quick Poll');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (5, 0, 3, 0, 'Top', 'Quick Poll');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (6, 2, 1, 0, 'Top', '일정');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (6, 2, 2, 0, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (6, 2, 3, 0, 'Top', '日程');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (7, 3, 1, 0, 'Top', '결재리스트');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (7, 3, 2, 0, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (7, 3, 3, 0, 'Top', '電子決裁リスト');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (8, 3, 1, 0, 'Top', '즐겨찾기양식');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (8, 3, 2, 0, 'Top', 'Favorite Forms');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (8, 3, 3, 0, 'Top', 'お気に入り様式');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (9, 4, 1, 0, 'Top', '포토 갤러리');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (9, 4, 2, 0, 'Top', 'Photo Gallery');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (9, 4, 3, 0, 'Top', 'フォトギャラリー');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (10, 4, 1, 0, 'Top', '즐겨찾기 게시판');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (10, 4, 2, 0, 'Top', 'Favorite Boards');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (10, 4, 3, 0, 'Top', 'お気に入り掲示板');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (11, 5, 1, 0, 'Top', '커뮤니티');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (11, 5, 2, 0, 'Top', 'Community');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (11, 5, 3, 0, 'Top', 'コミュニティ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (12, 0, 1, 0, 'Top', '도움말');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (12, 0, 2, 0, 'Top', 'Help');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (12, 0, 3, 0, 'Top', 'ヘルプ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (14, 0, 1, 0, 'Top', '날씨');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (14, 0, 2, 0, 'Top', 'Weather');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (14, 0, 3, 0, 'Top', '天気');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (26, 0, 1, 0, 'Top', '생일자');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (26, 0, 2, 0, 'Top', 'birthday');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (26, 0, 3, 0, 'Top', '誕生者');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (34, 0, 1, 0, 'Top', '슬라이드 이미지');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (34, 0, 2, 0, 'Top', 'Slide Image');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (34, 0, 3, 0, 'Top', 'スライド画像');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (36, 0, 1, 0, 'Top', '사용자 정보');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (36, 0, 2, 0, 'Top', 'user Info');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (36, 0, 3, 0, 'Top', 'ユーザ情報');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (47, 4, 1, 0, 'Top', '동영상 게시판');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (47, 4, 2, 0, 'Top', 'Movie Board');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (47, 4, 3, 0, 'Top', '動画掲示板');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (49, 0, 1, 0, 'Top', '카운트');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (49, 0, 2, 0, 'Top', 'Count');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (49, 0, 3, 0, 'Top', 'カウント');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (51, 6, 1, 0, 'Top', '자원관리');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (51, 6, 2, 0, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (51, 6, 3, 0, 'Top', '設備管理');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (70, 10, 1, 0, 'Top', '개인폴더');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (70, 10, 2, 0, 'Top', 'My Folder');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (70, 10, 3, 0, 'Top', 'Webフォルダ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (73, 19, 1, 0, 'Top', '전자설문');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (73, 19, 2, 0, 'Top', 'Survey');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (73, 19, 3, 0, 'Top', '電子アンケート');
-- 모바일 포틀릿
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 1, 0, 'Top', '고정 포틀릿');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 2, 0, 'Top', 'fixed portlet');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 3, 0, 'Top', '固定ポートレット');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 4, 0, 'Top', '固定门户组件');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 5, 0, 'Top', 'portlet cố định');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 6, 0, 'Top', 'portlet tetap');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 1, 0, 'Top', '고정 포틀릿');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 2, 0, 'Top', 'fixed portlet');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 3, 0, 'Top', '固定ポートレット');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 4, 0, 'Top', '固定门户组件');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 5, 0, 'Top', 'portlet cố định');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 6, 0, 'Top', 'portlet tetap');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 1, 0, 'Top', '일정');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 2, 0, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 3, 0, 'Top', '日程');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 4, 0, 'Top', '附表');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 5, 0, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 6, 0, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 1, 0, 'Top', '자원관리');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 2, 0, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 3, 0, 'Top', '設備管理');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 4, 0, 'Top', '教学资源');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 5, 0, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 6, 0, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 1, 0, 'Top', '결재리스트');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 2, 0, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 3, 0, 'Top', '電子決裁リスト');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 4, 0, 'Top', '批准名单');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 5, 0, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 6, 0, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 1, 0, 'Top', '받은 메일');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 2, 0, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 3, 0, 'Top', '受信トレイ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 4, 0, 'Top', '收件邮件');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 5, 0, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 6, 0, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 1, 0, 'Top', '공지사항');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 2, 0, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 3, 0, 'Top', 'お知らせ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 4, 0, 'Top', '公告');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 5, 0, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 6, 0, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 1, 0, 'Top', '포토 갤러리');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 2, 0, 'Top', 'Photo Gallery');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 3, 0, 'Top', 'フォトギャラリー');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 4, 0, 'Top', '相片集');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 5, 0, 'Top', 'Photo Gallery');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 6, 0, 'Top', 'Photo Gallery');

INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 1, 1, 1, 1, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 2, 1, 2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 4, 1, 3, 15, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 5, 1, 4, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 6, 1, 5, 2, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 7, 1, 6, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 8, 1, 7, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 9, 1, 8, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 10, 1, 9, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 11, 1, 10, 5, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 12, 1, 11, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 14, 1, 12, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 26, 1, 13, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 34, 1, 14, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 36, 1, 15, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 47, 1, 16, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 48, 1, 17, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 49, 1, 18, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 51, 1, 21, 6, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 70, 1, 22, 10, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 73, 1, 20, 19, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 1, 1, 1, 1, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 2, 1, 2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 4, 1, 3, 15, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 5, 1, 4, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 6, 1, 5, 2, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 7, 1, 6, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 8, 1, 7, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 9, 1, 8, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 10, 1, 9, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 11, 1, 10, 5, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 12, 1, 11, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 14, 1, 12, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 26, 1, 13, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 34, 1, 14, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 36, 1, 15, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 47, 1, 16, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 48, 1, 17, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 49, 1, 18, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 51, 1, 21, 6, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 70, 1, 22, 10, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 73, 1, 20, 19, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 1, 1, 1, 1, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 2, 1, 2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 4, 1, 3, 15, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 5, 1, 4, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 6, 1, 5, 2, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 7, 1, 6, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 8, 1, 7, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 9, 1, 8, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 10, 1, 9, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 11, 1, 10, 5, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 12, 1, 11, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 14, 1, 12, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 26, 1, 13, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 34, 1, 14, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 36, 1, 15, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 47, 1, 16, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 48, 1, 17, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 49, 1, 18, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 51, 1, 21, 6, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 70, 1, 22, 10, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 73, 1, 20, 19, 0);
-- 모바일 포틀릿 
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, 0, 'Top', 76, 1, 1, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, 0, 'Top', 77, 1, 2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, 0, 'Top', 78, 1, 3, 2, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, 0, 'Top', 79, 1, 4, 6, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, 0, 'Top', 80, 1, 5, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, 0, 'Top', 81, 1, 6, 1, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, 0, 'Top', 82, 1, 7, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, 0, 'Top', 83, 1, 8, 4, 0);
				
INSERT INTO TBL_PORTAL_THEME_AUTH (THEME_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (1, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_THEME_AUTH (THEME_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (2, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_THEME_AUTH (THEME_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (3, 'Top', 0, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_THEME_AUTH (THEME_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (4, 'Top', 0, 'Top', 1, 0, 1);

INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (1, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (2, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (4, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (5, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (6, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (7, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (8, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (9, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (10, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (11, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (12, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (14, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (26, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (34, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (36, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (47, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (49, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (51, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (70, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (73, 'Top', 0, 'Top', 1, 0, 1, 'Y');
-- 모바일 포틀릿 권한
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (76, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (77, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (78, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (79, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (80, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (81, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (82, 'Top', 0, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (83, 'Top', 0, 'Top', 1, 0, 1, 'Y');

-- 모바일 외부메일 포틀릿 추가
-- INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (84, 1, '/mobile/ezNewPortal/receivedMailPortlet.do', 'MG', 9, 'mReceivedmail2');
-- INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',0, 84, 1, 1, 9, null);
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 1, 0, 'Top', '외부 메일함');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 2, 0, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 3, 0, 'Top', '受信トレイ');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 4, 0, 'Top', '收件邮件');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 5, 0, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 6, 0, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, 0, 'Top', 84, 1, 9, 1, 0);
-- INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (84, 'Top', 0, 'Top', 1, 0, 1, 'Y');

-- 모바일 우측 탭 외부메일 버튼 추가
-- INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (34, '/mobile/ezEmail/mailList.do?folderId=INBOX&mail2=Y', 'MG', 'iconCommon icon_outmail', 24, 'mMail');
-- INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER, ICON_URL, OPENTYPE) VALUES ('8000',0, 34, 1, 1, 22, 'iconCommon icon_outmail', 1);
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 1, '8000', 0, '외부메일');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 2, '8000', 0, 'E-Mail');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 3, '8000', 0, 'メール');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 4, '8000', 0, '邮件');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 5, '8000', 0, 'E-Mail');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 6, '8000', 0, 'E-Mail');
-- INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (34, '8000', 0, '8000', 1, 0, 0, 'Y');

-- 포탈 외부메일 포틀릿 추가
-- INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (20, 1, '/ezNewPortal/receivedMailPortlet2.do', 'G', 25, 'receivedmail2');
-- INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top', 0, 20, 1, 1, 25, null);
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 1, 0, 'Top', '외부 메일함');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 2, 0, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 3, 0, 'Top', '受信トレイ');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 4, 0, 'Top', '收件邮件');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 5, 0, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 6, 0, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, 0, 'Top', 20, 1, 25, 1, 0);
-- INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, 0, 'Top', 20, 1, 25, 1, 0);
-- INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, 0, 'Top', 20, 1, 25, 1, 0);
-- INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (20, 'Top', 0, 'Top', 1, 0, 1, 'Y');

UPDATE TBL_CODELIST SET ISUSE = 1 WHERE CODE1 = 'A03' AND CODE2 = '005' AND TENANT_ID = 0 AND COMPANYID = 'TOP';
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(0, 'absenceAllClear', 'NO', '부재설정 해제 팝업(전자결재화면로드시)에서 겸직부재설정까지 해제할지 여부', '겸직일괄해제설정', TIMESTAMP '2020-12-09 20:30:53.000000', '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(0, 'serverName', 'jtest.kaoni.com', '모바일 결재시 메일 링크 주소값 (:portno)', '웹서버 네임', TIMESTAMP '2021-03-12 00:00:00.000000', '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (0, 'useSusinSchedulerYn', '수신문서 전달 스케쥴러 사용여부', 'N', 'Y: 사용 N: 사용안함 (default: N)', TO_DATE('2021-03-02 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(0, 'useSusinSchedulerTime', '5', '스케쥴러 동작주기 분 (default: 5)', '수신문서 전달 스케쥴러 주기', TO_DATE('2021-03-03 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('D24','001','','1','','문서24 URL','문서24 URL','문서24 URL','Top',0);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('D24','002','','1','','문서24 API_KEY','문서24 API_KEY','문서24 API_KEY','Top',0);
INSERT ALL
    INTO TBL_LISTOPTION (LISTTYPE, SN, NAME, WIDTH, TABLENAME, COLNAME, COLALIAS, DTYPE, TYPEDESC, FIELDDESC, NAME2, NAME3, NAME4, DELFLAG, TENANT_ID, COMPANYID) 
    VALUES ('112', 1, '수신자', 200, NULL, 'RECEIPTDEPTNAME', NULL, NULL, '수신자', NULL, 'Receiver', '受信者' , '受信者', NULL, 0, 'Top')
    INTO TBL_LISTOPTION (LISTTYPE, SN, NAME, WIDTH, TABLENAME, COLNAME, COLALIAS, DTYPE, TYPEDESC, FIELDDESC, NAME2, NAME3, NAME4, DELFLAG, TENANT_ID, COMPANYID) 
    VALUES ('112', 2, '상태', 100, NULL, 'STATUS', NULL, NULL, '상태', NULL, 'Status', 'ステータス', 'ステータス', NULL, 0, 'Top')
    INTO TBL_LISTOPTION (LISTTYPE, SN, NAME, WIDTH, TABLENAME, COLNAME, COLALIAS, DTYPE, TYPEDESC, FIELDDESC, NAME2, NAME3, NAME4, DELFLAG, TENANT_ID, COMPANYID) 
    VALUES ('112', 3, '일자', 300, NULL, 'STATUSDATE', NULL, NULL, '일자', NULL, 'Date', '日付', '日付', NULL, 0, 'Top')
SELECT
	*
FROM DUAL;

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) 
VALUES(0, 'useWorkspaceSchedule', '협업 일정 연동 여부', 'NO', 'YES: 사용 NO: 사용안함', TO_DATE('2024-05-22 00:00:00','yyyy-mm-dd hh24:mi:ss'), '협업');

INSERT INTO tbl_tenant_config (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) 
VALUES(0, 'delAttachByOthers', '0', '결재에서 첨부를 올린사람 이외의 사람도 삭제가능여부를  결정하는 테넌트 값(0 : 불가 1 : 허용), (default:0) ', '결재에서 첨부파일을 다른사람이 지울수있는 여부', TO_DATE('2021-03-05 00:00:00','yyyy-mm-dd hh24:mi:ss'), '전자결재');
*/
