
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

INSERT INTO `james_recipient_rewrite` (`DOMAIN_NAME`,`USER_NAME`,`TARGET_ADDRESS`) VALUES ('jtest.kaoni.com','Top','');
INSERT IGNORE INTO `james_domain` (`DOMAIN_NAME`) VALUES ('jtest.kaoni.com');
INSERT INTO `james_user` (`USER_NAME`,`PASSWORD_HASH_ALGORITHM`,`PASSWORD`,`version`) VALUES ('masteradmin@jtest.kaoni.com','SHA-256','9bb8ec42d9b552a9be9f9d47d34c1c89039e426f6b95aad9c43d30b8cf505425',1);
INSERT INTO `jmocha_default_quota` (`DOMAIN_NAME`,`MAX_STORAGE`,`WARN_STORAGE`) VALUES ('jtest.kaoni.com',1024,819.2);

INSERT INTO `tbl_tenant_servername` (`TENANT_ID`, `SERVER_NAME`) VALUES (@tenant_id_value, 'jtest.kaoni.com');
INSERT INTO `tbl_tenant_servername` (`TENANT_ID`, `SERVER_NAME`) VALUES (@tenant_id_value, '127.0.0.1');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'dbSessionStoragePeriod', 'DB세션 보관 기간', '5', 'DB 세션 사용 시 tbl_session 테이블에 세션 보관 기간 day기준(default:5)', '2023-12-14 00:00:00', '로그인');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'checkPasswordNumber', '3자리 이상의 연속숫자, 같은숫자, 생일, 전화번호 방지', 'YES', '패스워드 설정 시 3자리 이상의 연속숫자, 같은숫자, 생일, 전화번호 방지 사용여부 (default:YES)', '2023-06-09 00:00:00', '로그인');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useOTP', 'OTP 사용여부', 'NO', 'TFA 2중인증 OTP 사용여부 (default:NO)', '2023-03-30 00:00:00', '로그인');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'MaxMessageSize', '메일최대크기', '65536', '메일최대크기 (default:65536)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useZipCodeSearchInApr', '전자결재 민원인주소 검색 사용여부', 'NO', '전자결재>결재정보에서 민원인주소를 입력 시 주소정보 검색을 사용한다.(민원인주소 버튼: 결재정보>수신자>민원인주소입력 버튼, 전자결재G에서 재기안이 아닐 때 버튼 활성화)YES: 이름+우편번호검색+상세주소 입력NO: 이름 입력 (default: NO)', '2017-01-06 00:00:00', '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useZipCodeSearch', '우편번호 검색 사용여부', 'YES', '사용자 정보 관리, 주소록에서 우편번호 검색을 사용한다. (우편번호 검색 버튼 활성화)YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseTodoMemo', '업무관리 메모기능 사용여부', 'YES', '업무관리 모듈 내 메모기능을 사용한다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '업무관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseShowEmailAddrOnPrint', '메일 인쇄 시 주소 포함여부', 'YES', '메일 인쇄 시 보낸사람, 받는사람의 메일주소를 포함하여 인쇄한다.YES: 메일주소 포함NO: 메일주소 포함안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSearchContent', '메일 내용검색 사용여부', 'YES', '메일 간단검색 시 내용 검색이 가능하다. (메일리스트 화면 우측 상단 검색 셀렉트박스)YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseRunTime', '게시판 RunTime 표시여부', 'NO', '게시판 리스트 하단에 런타임 표시 기능을 사용한다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UserInfo_RelayG_Type', '유통 중계문서 문서 정의', 'MHT', '결재문서 접수 시 유통 중계문서 변환 양식을 정의한다.MHT: MHT 접수기 사용HWP: 한글 접수기 사용공백: 사용안함 (default: MHT)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UserInfo_Enforce', '시행문 변환 정의', '3', '* 2024-04-16 기준 분석 결과 : 소스코드 상에서 전체 주석처리되거나 테넌트 컨피그 파라미터를 아예 전달하지 않는 등 정상적으로 사용되지 않는 값으로 확인, 차후 수정 가능성이 있어 테넌트 컨피그 레코드는 유지함. * 기존 테넌트 컨피그 설명 : 1: 단순 변환 후 인쇄2: 시행문 변환 후 심사용3: 시행문 변환 후 바로 발송용(*추후개발) (default: 3)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UserInfo_ApprovalG_VIEW', '문서 열람 권한 정의', 'YYY', '문서 열람 권한을 정의한다. 권한을 체크 할 경우 Y로 권한을 체크하지 않을 경우 N으로 각 자리를 채운다. 비공개 문서인 경우, 이곳에 속하면 열람 가능. 속하지 않으면, 2번, 3번을 추가로 체크. 부분공개 문서인 경우, 이곳에 속하면 열람 가능. 속하지 않으면, 2번, 3번을 추가로 체크.공개 문서인 경우, 2번 3번을 추가로 체크.첫번째자리 Y/N: 공개/부분공개/비공개 권한 체크두번째자리 Y/N: 보안등급 권한 체크세번째자리 Y/N: 열람권한 체크 (default: YYY)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useReSend', '메일 재작성 사용여부', 'YES', '보낸 메일의 재작성 기능을 사용한다.YES: 사용NO: 사용안함메일>보낸편지함메일>보낸편지함>메일읽기 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useReform', '전자결재 폼빌더 양식 작성 가능 여부', 'NO', '전자결재 양식 추가 시에 폼빌더 작성기를 활성화할 수 있는지에 대한 여부를 설정한다. 이미 폼빌더 양식으로 추가 됐다면 옵션을 비활성화해도 폼빌더 양식으로서 동작한다. (default : NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useReceiveInfoName', '수신부서 표기 타입', '0', '수신부서 지정 시 부서 이름 끝에 "장"을 붙인다. 0: 부서이름만 표기 1: 부서이름+장으로 표기 2: 상위부서(부서이름+장)으로 표기 (default: 0)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useReceiveDocNo', '접수 시 채번방식 설정', 'NO', '결재문서 접수 시 채번 붙이는 때를 설정한다. (전자결재G)YES: 접수/편철/전결 시 채번NO: 최종결재/편철/전결 시 채번 (default: NO)', '2017-01-06 00:00:00', '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useReceiptExternal', '외부메일 수신확인 지원여부', 'YES', '외부메일 수신확인을 지원한다.YES: 지원NO: 지원안함 (default: YES)', '2024-11-13 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useQuestion', '전자설문 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UsePreviewSubTreeForEmail', '하위 편지함 오픈 설정 사용여부', 'YES', '메일>환경설정에서 하위편지함 자동 열기 설정을 사용한다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseOnlyInnerMail', '메일 내부망만 사용여부', 'NO', '메일을 내부망에서만 사용한다. 외부메일 관련 설정은 모두 숨김. YES: 내부만 사용NO: 내부+외부 사용 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMobileViewer', '모바일 뷰어', '0', '0: 파일 다운로드. 1: SAT 뷰어 사용, 2: 쿠쿠닥스 뷰어 사용 (default: 0)', '2017-01-06 00:00:00', '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMobileMailOnly', '모바일 메일만 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMemo', '메모 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMasteradminLogin', '최고관리자 암호 로그인', 'NO', 'masteradmin 비밀번호로 모든 로그인이 가능하다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseMailZipEucKr', '메일 내보내기 시 zip 인코딩 타입', 'NO', '메일/편지함 내보내기 시 zip 인코딩 타입을 설정한다. utf-8로 압축했을 경우 윈도우 기본 프로그램으로 압축을 풀면 실패하여 euc-kr로 압축할 수 있도록 옵션처리YES: euc-krNO: utf-8 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailWriteSenderClick', '보낸사람에게 바로 메일보내기 사용여부', 'YES', '메일리스트에서 보낸사람 클릭 시 메일 작성 팝업이 뜬다. 사용하지 않으면 행선택.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailReceiveScreen', '수신확인 리스트 사용여부', 'YES', '수신확인 리스트 화면을 사용한다. 메일화면 왼쪽에 수신확인 메뉴가 표출된다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailNewWindow', '메일 읽기 아이콘 사용여부', 'NO', '메일리스트에서 단일 클릭으로 메일 읽기 팝업이 뜨는 아이콘을 사용한다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailLinkHostname', '대용량첨부/보안메일 링크의 hostname 지정여부', 'NO', '대용량첨부메일 및 보안메일의 경우 어느 hostname으로 접속해도 설정된 mailLinkHostname 컨피그 값으로 링크가 만들어진다.YES: mailLinkHostname 링크 사용NO: 사용자의 그룹웨어 접속 hostname으로 링크 사용 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseMailBoxBackUp', '편지함 내보내기/가져오기 사용여부', 'YES', '메일 왼쪽 편지함에서 마우스 오른쪽 클릭 시 편지함 내보내기/가져오기가 가능하다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailAddrAutoComplete', '메일 수신인 자동완성 사용여부', 'YES', '메일쓰기>받는사람, 참조, 숨은참조에 수신인 이름 입력 시 자동완성 기능을 사용한다 YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'usePlainForDefaultTextOption', '기본 메일 본문 형식을 PlainText로 사용여부', 'NO', '메일 환경설정의 메일본문형식을 PlainText를 default로 설정한다. YES: 사용NO: 사용안함 (default: NO)', '2019-05-23 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useLoginCookieSSO', 'loginCookieSSO 로그인 쿠키 추가생성', 'NO', 'loginCookieSSO라는 쿠키에 도메인으로 설정하여 로그인 쿠키 하나 추가로 생성NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useLetter', '메일 편지지 기능 사용여부', 'YES', 'YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useLadder', '사다리게임 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useIPAccess', '접속 IP 관리 허용여부', 'NO', '접속 IP 관리 기능을 사용하면 모든 사용자가 차단되고 등록한 사용자만 그룹웨어에 접속 가능하다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseInitMailSign', '메일 서명 자동 등록여부', 'NO', '사용자 생성 시 메일 서명 테이블에 있는 초기 메일 서명을 해당 사용자의 메일 서명으로 등록한다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseInitInboxRule', '초기 메일 자동분류 등록여부', 'NO', '사용자 생성 시 메일 자동분류 테이블에 들어있는 초기 자동분류 룰을 해당 사용자의 자동분류 룰로 등록한다. 룰에 포함된 편지함이 사용자에게 없을 경우 편지함을 자동 생성한다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useImapMoveCommand', '메일 이동 시 IMAP MOVE 커맨드 사용여부', 'YES', '메일 이동 시 IMAP MOVE 커맨드를 사용한다. 사용하지 않으면 IMAP COPY 커맨드를 사용한다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useHWP', 'HWP 양식작성기 사용유무', 'NO', 'HWP 양식을 작성하고 사용할 수 있다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useWebHWP', '웹 한글 기안기 사용유무', 'YES', 'useHWP가 YES인 경우 웹한글기안기 사용유무. YES: 사용 NO: 사용안함 (default : YES)', '2020-10-08 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'webHWPUrl', '웹 한글 기안기 url', 'http://hedit.kaoni.com:8080/webhwpctrl/', '웹 한글 기안기 url', '2020-02-26 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseEncryptZipForEmail', '메일 내보내기/가져오기 암호화 사용여부', 'NO', '메일 내보내기/가져오기 시 압축파일을 암호화한다. YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseEmpNumberLogin', '사번 로그인', 'NO', '사용자 아이디 대신 사번으로 로그인한다.YES: 사용NO: 사용안함*tbl_usermaster 테이블의 extensionAttribute14 컬럼 (default: NO)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useEditApprDoc', '전체 진행문서 편집기능 사용여부', 'NO', '전체문서조회(진행문서)에서 편집모드로 들어가 편집이 가능하다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseDisablePopImap', 'POP3/IMAP 설정 미사용여부', 'NO', 'POP3/IMAP 사용여부를 설정할 수 있는 기능을 활성화한다. YES: 사용안함NO: 사용 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseDefaultFoldersForLangOnly', '사용자 언어에 따른 기본 편지함만 표출', 'NO', '사용자 언어별로 각각 다른 이름의 편지함이 생성되는 데 현재 언어에 맞는 편지함만 보이도록한다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useCabinet', '캐비닛 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useBottomFrameOnly', '하단프레임만 DIM 처리', 'NO', '레이어 팝업이 띄워질 때 탑메뉴와 따로 하단프레임만 DIM 처리된다. 사용하지 않으면 탑메뉴도 DIM 처리됨.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseBizmekaTalk', '비즈메카톡과의 연동여부', 'NO', '그룹웨어 계정으로 비즈메카톡 계정을 동기화 할 수 있다.YES: 연동NO: 연동안함 (default: NO)', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseBizmekaSpambox', '비즈메카 스팸편지함과의 연동여부', 'NO', 'YES: 연동NO: 연동안함 (default: NO)', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useBallotSystem', '투표 모듈 사용여부', 'NO', '투표모듈을 사용한다. 투표모듈 사용 시 투표 포틀렛에 투표모듈이, 사용안할 시 퀵폴이 표출된다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAutoSaveMailAddress', '외부메일 자동 주소록 등록', 'NO', '외부로 메일을 보낼 시 주소록에 저장되지 않은 외부메일이면 개인주소록에 자동으로 등록한다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useApprovalKlib', '전자결재완료 문서를 KLIB 암호화 저장', 'NO', '전자결재완료시 문서, 첨부파일을 KLIB 으로 암호화할 것인지의 여부(default : NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useApprovalKlibBackup', '전자결재완료 문서 KLIB 암호화시 원본 백업', 'NO', '전자결재 관련 파일을 KLIB 으로 암호화할 때 원본 파일을 백업할지에 대한 여부(default : NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseAnyoneEdit', '주소록, 일정 편집 권한 오픈여부', 'NO', '모든 사용자가 부서/회사 주소록과 일정을 추가 및 수정 가능하다. 사용하지 않을 시 부서관리자와 회사관리자에게 권한이 있다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '주소록');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAllUserOldMailDeletePeriod', '받은편지함 메일 보관기간', '0', '월 단위로 받은편지함 메일 보관기간을 지정한다. 지정한 기간이 지난 메일은 모두 삭제한다.0: 삭제안함*useAllUserOldMailDelete 옵션의 값이 YES일 때 사용가능 (default: 0)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAllUserOldMailDelete', '받은편지함 오래된 메일 자동 삭제', 'NO', '받은편지함에서 오래된 메일을 자동으로 삭제하는 기능을 사용한다. useAllUserOldMailDeletePeriod 옵션에서 지정한 기간에 의해 삭제된다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAllowTextSelection', '전자결재 문서 내용 드래그 가능여부', 'YES', 'YES: 드래그 가능NO: 드래그 불가능 (default: YES)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAdvancedMailSearch', '속도 개선 메일검색 기능 사용여부', 'YES', '메일검색 테이블을 이용하여 속도가 개선된 메일검색 기능을 사용한다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAdminBujae', '관리자의 부재자 설정 사용여부', 'YES', '관리자 페이지에서 특정 사용자의 부재자 설정이 가능하다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useEzTalkNotification', '전자결재 톡알림', 'NO', '전자결재 관련 알림을 ezTalk으로 보낸다. YES:사용, NO:사용안함 (default: NO)', '2019-10-19 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAdvancedEachMail', '개별발신 성능 향상 방식 적용', 'YES', '개별발신 성능 향상 방식 적용 YES:사용, NO:사용안함 (default: NO)', '2019-12-08 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useShowAllCompanies', '조직도 그룹사 전체 표시', 'NO', '메일쓰기 수신자지정창 조직도, 직원조회 조직도 등에서 그룹사 전체 표시 여부. YES: 표시, NO:미표시 (default: NO)', '2019-10-21 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailDeletedId', 'james_mail_deleted_id 테이블 사용여부', 'NO', 'james_mail_deleted_id 테이블 사용여부 (default: NO)', '2019-12-29 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_SECUREMAIL', '보안메일 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'Use_Portal', '포탈 모듈 사용여부', 'YES', 'YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_OCS', 'MS OCS 사용여부', 'NO', 'ms ocs 2007 사용여부YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'Use_MultiData', '멀티언어 사용여부', 'YES', 'YES: 사용NO: 사용안함 (default: YES)     * 2024-05-22(해당 컨피그를 확인한 시점) 기준으로 게시판 모듈에서만 사용중인 것으로 확인됨', '2017-01-06 00:00:00', '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_JOURNAL', '업무일지 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_HTTPS', 'HTTPS 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_HTMLMODE', '에디터 HTML 모드 사용여부', 'YES', '에디터의 HTML 모드를 사용한다. 관리자 화면에서는 설정에 관계없이 무조건 사용한다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'Use_FromAddress', '발신인 주소 선택 사용여부', 'NO', '발신인이 멀티 메일 도메인을 가지고 있을 때 메일쓰기에서 보내는 사람의 메일 주소 선택이 가능하다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_FileExtension', '첨부파일 확장자명 제한', '7z,alz,avi,bmp,csv,cur,doc,docx,eml,gif,hwp,hwpx,hwt,jpeg,jpg,log,mht,mov,mp4,odt,pdf,png,ppt,pptx,rar,tif,txt,wmv,xls,xlsx,zip', '업로드 가능한 첨부파일의 확장자명을 설정한다. ex) exe|jpg*: 제한하지 않음 (모든 확장자 허용) (default: *)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_DirectSign', '부서 협조/합의 직접서명 사용여부', 'NO', '전자결재 부서 협조/합의 접수 시 직접서명을 사용한다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_BOARD_LEFTMENU_COUNT', '게시판 왼쪽 메뉴 총 개수 표시', 'YES', '게시판 왼쪽 메뉴에 각 게시판의 게시문 개수를 표시한다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_ATTITUDE', '근태관리 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_AdditionalROle', '겸직부서에 따른 일괄결재 제한', 'NO', '전자결재에서 겸직부서 선택에 따라 현재 부서의 일괄결재만 가능하다.YES: 겸직부서 선택에 따라 일괄결재제한NO: 겸직부서 상관없이 모두 일괄결재 가능 (default: NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_AD', 'Active Directory 사용 유무', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'totBigSizeMailAttachLimit', '메일 대용량 첨부파일 최대 크기', '800', 'MB 단위로 대용량 첨부파일의 최대 크기를 지정한다.0: 대용량 첨부파일 사용안함 (default: 800)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'Site_OpenYear', '전자결재 시작 년도 설정', '2017', '전자결재 리스트에서 년도별 셀렉트박스의 시작 년도를 설정한다. (default: 2017)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'signImageType', '이미지 서명 시 사인칸 타입', 'IMAGE', '이미지 서명 시 사인칸에 표시할 타입을 설정한다.IMAGE: 서명이미지만 표시NAME: 서명이미지+서명인 이름 함께 표시 (default: IMAGE)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'SignImageSizeLimit', '결재 서명이미지 파일 최대 크기', '10', 'KB 단위로 결재 서명 이미지 파일의의 최대 크기를 지정한다. (default: 10)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'signImageSize', '전자결재 사인이미지 크기', '50/50', '전자결재 사인칸의 이미지 크기를 설정한다. width/height 로 표기한다. (default: 50/50)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'apprReuseConfig', '전자결재 재사용 환경설정', '0', '전자결재에서 재사용시 설정. 0:문서의 모든 내용 재사용 1:에디터 본문만 재사용 default:모든 내용 재사용(0)', '2018-11-21 00:00:00', '전자결재S');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'receptGubunYN', '전자결재 수신자탭 표출 타입', 'N', '전자결재G 결재정보에서 양식종류에 따라 수신자탭이 보여지는 타입을 정한다Y: 시행문일 경우 외부탭, 수신문일 경우 조직도탭이 표출N: 양식종류에 상관없이 외부탭, 조직도탭 모두 표출 (default: N)', '2017-01-06 00:00:00', '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'portalEnv', '개인설정 메뉴표출 범위', '0', '환경설정>개인설정의 메뉴가 보여지는 범위를 정한다.0: 테마설정+초기화면설정1: 테마설정2: 초기화면설정3: 모두 안보임*패키지가 스탠다드고 firstScreen_Mail이 NO일때만 적용 (default: 0)', '2017-01-06 00:00:00', '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'PersonalAgreeReturnType', '개인병렬 협조/합의 반송 처리 타입', '1', '개인병렬 협조/합의자가 반송한 경우 처리 타입을 정의한다.1: 반송해도 다음 결재권자에게 진행문서로 전달2. 한 명이라도 반송한 경우 원 기안자에게 반송 (default: 1)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ONELINE_REPLY_ENABLE', '게시판 댓글 FLAG', '1', '커뮤니티 게시판의 댓글 FLAG0: 사용안함1: 사용 (default: 1)', '2017-01-06 00:00:00', '커뮤니티');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'MyBoardTopFlag', '게시판 마이게시판 위치', 'YES', '게시판 왼쪽 메뉴에서 마이게시판의 위치를 설정한다.YES:상단 / NO:하단 (default: YES) *2024-05-22(해당 컨피그를 확인한 시점) 기준으로 즐겨찾기 메뉴는 상단 고정이 스펙', '2017-01-06 00:00:00', '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'mobileUseMailAddrAutoComplete', '모바일 메일 이름 자동완성 기능 사용여부', 'YES', '모바일에서 메일쓰기>받는사람, 참조, 숨은참조에 수신인 이름 입력 시 자동완성 기능을 사용한다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'MineViewYN', '결재진행문서 표출 타입', 'NO', '결재진행문서에 문서가 보여지는 타입을 설정한다.YES: 결재 순서가 본인인 문서만 표출NO: 결재선에 본인이 존재하는 모든 문서 표출 (default: NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'mailLinkHostname', '대용량첨부메일/보안메일 링크의 hostname', '', '대용량첨부메일 및 보안메일 링크의 hostname을 설정한다. (port번호 포함, 80포트는 생략)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'MailInnerDomain', '내부 메일도메인', 'jtest.kaoni.com', '내부 메일 도메인 리스트. 세미콜론으로 도메인을 구분하며 메인 메일도메인은 필수로 포함한다. (세미콜론(;)으로 도메인 구분, 주 메일 도메인 필수로 포함, alias 도메인 사용할 경우 포함) (default: jtest.kaoni.com)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'MailAttachLimit', '메일 일반 첨부파일 최대 크기', '10', 'MB 단위로 메일 일반 첨부파일의 최대 크기를 지정한다. (default: 10)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'mailMaxReceiverCount', '메일 최대 수신자 수', '200', '메일 발송 시 최대 수신자 수를 지정한다. (default: 200)', '2019-03-21 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'MailBigSizeAttachDownloadLimitCount', '대용량첨부 다운로드 횟수 제한', '0', '대용량첨부 다운로드 횟수 제한, 0일 경우 무제한', '2020-03-12 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'MailBigSizeAttachLimitCount', '대용량첨부 개수 제한', '0', '대용량첨부 개수 제한, 0일 경우 무제한', '2020-03-12 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LoginMailLogKeepPeriod', '로그인, 메일 로그 보존기간', '3', '월 단위로 로그인 기록과 메일 수발신 로그를 보존하는 기간을 지정한다. 지정한 기간이 지나면 삭제한다. (default: 3)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LicenseKey', '라이센스키', '', '라이센스 키', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangSecondary5', '멀티언어5(서브)', '', '', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangSecondary4', '멀티언어4(서브)', '英语', '', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangSecondary3', '멀티언어3(서브)', '英語', '', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangSecondary2', '멀티언어2(서브)', 'English', '', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'LangSecondary1', '멀티언어1(서브)', '영문', '시스템 언어에 따른 멀티언어(서브) 셋팅', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'JunGyulFlag', '전자결재 전결 처리 타입', '1', '전결 처리 타입을 정의한다.1: 전결자 이후 결재자들도 사인칸에 등록. 전결자가 결재하면 전결자 사인칸에 전결표시하고 최종결재자 사인칸에 전결자 서명을 입력한다.4: 전결자 이후 결재자들은 사인칸에 미등록. 전결자가 결재하면 전결자 사인칸에 전결자 서명을 입력한다. (default: 1)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'isDefaultReceiptExternal', '메일 수신확인 범위 기본값', 'YES', '메일쓰기>메일옵션>추적설정에서 기본값으로 사용할 타입을 설정한다.YES: 외부용을 기본값으로 사용NO: 내부용을 기본값으로 사용*useReceiptExternal 옵션이 YES 일 때 사용가능 (default: YES)', '2024-11-13 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'IS_READ_DELETE', '읽은 메일 회수기능 사용여부', 'NO', '메일 회수 시 수신자가 읽은 메일도 회수가 가능하다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'INDIVIDUALMAILUSER', '메일 개별발신 최대 인원', '200', '명 단위로 메일 개별발신 보낼 수 있는 최대 인원 수를 지정한다.0: 개별발신 사용 안함 (default: 5)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'HWPToolbar', '한글양식기 상단툴바 사용여부', '100001', '한글양식기에서 상단 편집 툴바를 라인별로 사용하면 1 사용하지 않으면 0으로 설정한다. (default: 100001)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'hideSusin', '전자결재 부서수신함 사용여부', 'Y', '전자결재 왼쪽 메뉴에서 부서수신함을 표출한다.Y: 사용N: 사용안함 (default: Y)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'FormProcSpelling', '폼프로세서 맞춤법 검사', '0', 'FORM 에디터 사용 시 폼프로세서 맞춤법 검사 버튼을 활성화한다.1: 사용0: 사용안함 (default: 0) * 2024-05-07 기준으로 표준모듈 master 브랜치에서 더이상 사용되지 않음', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'forceCallBack_YN', '강제회수 사용여부', 'NO', '전자결재에서 상위결재자가 결재한 문서도 회수 할 수 있다.YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'firstScreen_Mail', '초기화면 메일만 표출', 'NO', '초기 화면에 메일 모듈을 표출한다. YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ezTalkSyncServerUrl', '톡서버 전체 사용자 연동 URL', 'http://10.0.102.8:31032/api/sync/org', '톡서버 전체 사용자 연동 URL (default: http://10.0.102.8:31032/api/sync/org)', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ezTalkSyncServerUrlForSingle', '톡서버 단일 사용자 연동 URL', 'http://10.0.102.8:31032/api/sync/user', '톡서버 단일 사용자 연동 URL (default: http://10.0.102.8:31032/api/sync/user)', '2022-01-26 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ezTalkGateNoticeBoardId2', '비즈메카톡 사내공지게시판 아이디2', '0', '비즈메카톡에서 호출하는 두 번째 사내공지게시판 아이디 (default: 0) * 2024-05-17 기준으로 표준모듈 master 브랜치에서 더이상 사용되지 않음', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ezTalkGateNoticeBoardId', '비즈메카톡 사내공지게시판 아이디', '0', '비즈메카톡에서 호출하는 사내공지게시판 아이디 (default: 0) * 2024-05-17 기준으로 표준모듈 master 브랜치에서 더이상 사용되지 않음', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ezOffice365ClientSecret', 'Office365 Client Secret Key', '', 'Office365 Client Secret Key', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ezOffice365ClientId', 'Office365 Client Id', '', 'Office365 Client Id', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ezOffice365Auth', 'Office365와의 인증 연동여부', 'NO', 'YES: 연동NO: 연동안함 (default: NO)', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'editorFontStyle', '에디터 기본 폰트 스타일', '굴림|10pt', '에디터에서 기본으로 설정되는 폰트 스타일을 설정한다. 수직바(|)로 글꼴과 크기를 구분하며, 사용자 언어(lang)가 한글일 경우에만 적용된다. (default: 굴림|10pt)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'EDITOR', '에디터 타입', 'KUKUDOCS', 'CK, NAMO, TAGFREE, FORM, POLARIS, DEXT, KUKUDOCS 중 사용할 에디터를 설정한다. (default: KUKUDOCS)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'draftJunGyulFlag', '전자결재 사인칸 전결자 표시', '1', '전자결재 기안 시 사인칸에 전결자 텍스트를 표시한다.1: 사용0: 사용안함 (default: 1)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'dotNetUrl', '닷넷 모듈 URL', '', '', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'dotNetIntegration', '닷넷 모듈과의 연동여부', 'NO', 'YES/NO (default: NO)', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'DomainName', '메인 메일도메인', 'jtest.kaoni.com', '메인 메일도메인 (불변) (default: jtest.kaoni.com)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'docNumZeroCnt', '문서 일련번호 제로필 수', '2', '문서 일련번호의 최소 길이를 설정한다. 새로 작성된 문서의 일련번호 길이가 부족하면 앞자리에 0이 붙는다. (default: 2)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'defaultForDisablePopImap', 'POP3/IMAP 기본값', 'YES', 'POP3/IMAP 허용 여부의 기본값을 설정한다.YES: 사용안함이 기본값NO: 사용함이 기본값*UseDisablePopImap 컨피그 값이 YES일 경우 적용 (default: YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'daliyDocNumYN', '채번 초기화 주기', 'NO', '채번 초기화 주기를 설정한다.YES: 매일 채번 초기화NO: 매년 채번 초기화 (default: NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'containLow', '직원 수 카운트 시 하위부서 포함 여부', 'NO', '조직도에서 하위부서 직원 수도 포함하여 표시한다.YES: 현재부서/현재부서+하위부서 직원 수로 표시NO: 현재부서 직원수만 표시 (default: NO)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ChkOldBrowser', '오래된 브라우저 체크여부', 'YES', 'IE10 이전 버전을 사용할 경우 로그인을 막는다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'changePassword', '비밀번호 변경 이벤트 발생여부', '1', '패스워드 변경 기한 지났을 때 변경알림이 로그인 페이지에서 나타남 1:나타남 2:나타나지 않음(default:1)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'chamjoAfterYN', '최종결재자 이후 참조 추가', 'YES', '전자결재 결재정보에서 최종결재자 이후 참조 추가가 가능하다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'BizmekaCompanyId', '비즈메카 연동을 위한 회사 ID', 'withkt', ' (default: withkt)', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'BizmekaAdminPw', '비즈메카 연동을 위한 관리자 PW', '193A68920F2AE8A807A6DCBD34E2580E0237C6BB746141140BBA6D661108546035EA3C2E7698E3C192494456DFF551BAE637ED4292A9DB7C71F8FE0AD747DD302C60D7FDEE9FAD4BE872104578CA822833EB4B87703811556778DC22FA9FB7FC4CCC18C17F62E83A8663F5E62DB3735D37462422737A172F382875DF88FF96D6', ' (default: 193A68920F2AE8A807A6DCBD34E2580E0237C6BB746141140BBA6D661108546035EA3C2E7698E3C192494456DFF551BAE637ED4292A9DB7C71F8FE0AD747DD302C60D7FDEE9FAD4BE872104578CA822833EB4B87703811556778DC22FA9FB7FC4CCC18C17F62E83A8663F5E62DB3735D37462422737A172F382875DF88FF96D6)', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'BizmekaAdminId', '비즈메카 연동을 위한 관리자 ID', '27F8EA7760FDB7F338AC7CFBCD0FC0328B8F4C9BD665BDAEE11B987E727CFA2EDDFD229560CC9001F993FA50896A1C40B44CEC40CB4962476374183313EAC1B07F66B19E14252C4ECBA3B8E8B9DA54B7EA6AA1814B4DAC082E614A375D99983270A7758FB12986143874A26A606D0FE2C96213863D9145BC997796FA1C7B36C2', ' (default: 27F8EA7760FDB7F338AC7CFBCD0FC0328B8F4C9BD665BDAEE11B987E727CFA2EDDFD229560CC9001F993FA50896A1C40B44CEC40CB4962476374183313EAC1B07F66B19E14252C4ECBA3B8E8B9DA54B7EA6AA1814B4DAC082E614A375D99983270A7758FB12986143874A26A606D0FE2C96213863D9145BC997796FA1C7B36C2)', '2017-01-06 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'BigSizeMailAttachLimit', '메일 대용량 첨부파일로의 자동전환 크기', '10', 'MB 단위로 메일의 일반 첨부파일이 대용량 첨부파일로 변경되는 크기를 지정한다.MailAttachLimit 과 함께 변경 (default: 10)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'BigSizeMailAttachDelDay', '메일 대용량 첨부파일 보존기간', '14', '일 단위로 보존기간을 지정한다. 지정한 기간이 지나면 메일 대용량 첨부파일을 삭제한다. (default: 14)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'attachFileNameMaxLength', '첨부파일명 최대 길이', '100', '글자 단위로 확장자 포함한 최대 길이를 지정한다. (default: 100)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ApprTotalAttachLimit', '전자결재 (일반 + 대용량) 첨부파일 총합의 최대 크기', '50', 'MB 단위로 전자결재 (일반 + 대용량) 첨부파일 총합의 최대 크기를 지정한다. 0: 무제한 (default: 50)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'APPROVLEFTCOUNT', '전자결재 왼쪽 메뉴 총 개수 표시', 'YES', '전자결재 왼쪽 결재문서 메뉴에서 총 문서 개수를 표시한다.YES: 사용NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'approvalForDoc', '전체문서 조회 사용여부', 'N', '전체, 회사, 결재조회 관리자가 전체문서 조회 할 수 있는 기능을 사용한다.Y: 사용N: 사용안함 (default: N)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ApprovalFlag', '전자결재 타입', 'S', 'G: 전자결재 공공S: 전자결재 일반 (default: S)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'allApproveYN', '모두결재 표출 순서', 'N', ' 사용안함- 전자결재에서 모두 결재시 다음 결재문서를 보여주는 순서를 정한다. 시작하는 문서는 선택한 문서가 된다.Y: 기안일이 오래된 문서부터 결재N: 기안일이 최근인 문서부터 결재 (default: N)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ADJACENT_ITEMS_ENABLE', '인접 게시글 표시', '1', '게시글 조회 시 다음글, 이전글을 표시하고 바로 이동 가능하게 한다.1: 사용0: 사용안함 (default: 1)', '2017-01-06 00:00:00', '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'addLastKyulJeYN', '최종결재선 결재유형 허용 범위', '0', '전자결재 결재정보에서 최종결재자 유형으로 합의를 추가할 수 있는지 설정한다. 0:불가능, 1:개인순차합의만 허용, 2:개인순차합의와 부서순차합의 모두 허용 (default: 0)', '2017-01-06 00:00:00', '전자결재S');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useWebfolder', '웹폴더 기능 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useWebfolderVersionHistory', '웹폴더 버전관리 사용 여부', 'YES', 'YES: 사용, NO: 사용안함 (default: YES)', '2021-05-10 00:00:00', '웹폴더');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'howToSendOffer', '기안자를 발송의뢰 담당자로 지정', '0', '전자결재에서 발송의뢰 할 때 심사자를 선택하는 팝업이 뜨지 않고 기안자가 바로 발송의뢰 담당자로 지정된다.1: 사용0: 사용안함 (심사자 선택) (default: 0)', '2017-01-06 00:00:00', '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_COMMUNITY', '커뮤니티 모듈 사용여부', 'YES', 'YES: 사용 NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '커뮤니티');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useFidoAccessMenu', 'FIDO인증 관리 화면 여부(default: NO)', 'NO', 'FIDO인증 관리 화면', '2024-05-28 00:00:00', '로그인');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useIPAccessMenu', '접속 IP 관리 화면 여부', 'YES', 'YES: 사용 (default)', '2018-09-28 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_ezPMS', '프로젝트관리 기능 사용여부', 'NO', 'YES: 사용 NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'viewCompany','결재문서리스트 회사 이름 표출 여부','0','전자결재 리스트에 회사명 표출 여부 1:보여줌 그외:안보여줌', '2018-09-28 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSeparatedLargeFileFolder', '분리된 대용량 첨부파일 폴더 사용여부', 'YES', 'YES: 사용 (default:YES)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useCountryIP', '메일 보낸사람 국기 표시 여부', 'NO', '메일 리스트에서 보낸사람 앞에 국기를 표시한다. YES: 사용 (default:NO)', '2017-01-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'chkSchedulePublic', '일정등록 > 개인일정 공개범위 기본값 설정 여부', 'OFF', '일정작성 > 개인일정의 일정 공개 기본값 설정 기능 사용 여부 ON : 일정 공개/비공개 기본값 설정 기능 사용 OFF : 일정 비공개 기본값 설정 (default: OFF)', '2018-10-25 00:00:00', '일정관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMobileManagemant','모바일 설정 통합 사용 여부','NO','모바일 설정 사용여부 YES:사용함 NO:사용안함 (default : NO) (관리자)', '2018-10-25 00:00:00', '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAllowUserMobileManagement','모바일 설정 유저의 사용 여부 ','YES','유저의 모바일 설정 사용여부 YES: 사용 NO: 사용안함 (default: YES) (유저)', '2018-10-25 00:00:00', '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useScheduleIcs', '일정관리 ICS파일 가져오기 기능 사용 여부', 'NO', '일정관리에서 ICS파일 가져오기 기능 사용 여부 YES: 사용 / NO: 사용안함 (default: NO)', '2018-10-30 00:00:00', '일정관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSharedMailbox', '공유사서함 기능 사용 여부', 'YES', '메일에서 공유사서함 기능 사용 여부 YES: 사용 / NO: 사용안함 (default: YES)', '2019-12-09 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useRDBOnlyMailList', '메일목록 표시 RDB 쿼리 사용', 'YES', '메일목록 표시 RDB 쿼리 사용 여부 YES: 사용 / NO: 사용안함 (default: YES)', '2020-12-28 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useShareApproval', '전자결재 공유결재자', 'NO', '전자결재 공유결재자 사용 유무. YES: 사용 NO: 사용안함',  '2018-11-27 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSyncServer', '수동 인사정보 동기화 사용 여부', 'NO', '수동 인사정보 동기화 사용 여부. YES: 사용 NO: 사용안함', '2018-11-29 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ezSyncServerUrl', 'ezSyncServer 인사정보 동기화 호출 url', 'http://127.0.0.1:9091/ezSyncServer/std/syncAccounts', 'ezSyncServer 인사정보 동기화 요청 url', '2018-11-29 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useModuleUsage', '모듈별 모니터링 사용여부', 'NO', '관리자>시스템에서 모듈별 사용량을 조회하는 모니터링 기능을 사용한다. (default: NO)', '2017-01-06 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useActiveX', 'ActiveX 사용여부', 'NO', '그룹웨어 접속 시 ActiveX를 설치하고 사용한다. (default: NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'systemCountryCode', '현재국가코드', 'KR', '메일리스트 > 국기표시시 현재국가코드 나타냄 (default: KR), 시스템 국가는 useShowSystemCountry 설정이 YES일 때만 표시', '2018-12-20 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useShowSystemCountry', 'systemCountryCode와 .eml파일의 국가코드가 같을시 국기 표시할지 여부', 'NO', 'systemCountryCode와 .eml파일의 국가코드가 같을시 국기 표시할지 여부 YES: 현재 국가도 국기표시 NO: 현재 국가는 표시하지 않음 (default: NO)', '2018-12-20 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'dotNetTotalNotification', '닷넷 모듈의 통합알림 사용 여부', 'NO', 'YES/NO (default: NO)', '2019-01-08 00:00:00', '연동');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseOfficeApproval', '오피스 결재 사용 여부', 'NO', 'YES: 사용 NO: 사용안함 (default: NO)', '2017-01-06 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSurvey', '전자설문 리뉴얼 모듈 사용여부', 'YES', 'YES: 사용NO: 사용안함 (default: YES)', '2019-06-26 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'usePortalAutoRefreshInterval', '포탈 자동 새로고침 간격', '5', '포탈 자동 새로고침 간격(분 단위), 단 0이면 새로고침 사용안함', '2019-01-08 00:00:00', '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'Pop3MaxFetchSize', 'pop3 외부메일 확인 최대 개수', '40', 'pop3 외부메일 확인시 최대로 가져올 수 있는 메일 개수 제한 (default: 40)', '2019-01-08 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'mobileRedirection', '모바일 기기로 접속시 리다이렉션할 주소', '*', '모바일 기기로 접속시 리다이렉션할 주소. 단, *면 사용 안함', '2019-01-08 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSession', '세션 유지 시간', '0', '세션 유지 시간. 단, 0이면 세션 사용 안함 (default: 0)', '2018-12-20 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSessionMobile', '세션 유지 시간 모바일', '0', '세션 유지 시간. 단, 0이면 세션 사용 안함 (default: 0)', '2019-01-08 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseEnforceSihang', '시행문변환 관인등록 옵션 (일반버전 .mht용)', 'YES', 'YES: 사용 (관리자 > 전자결재 > 관인대장 메뉴 표시 ) NO: 사용안함 (default : YES)', '2019-09-17 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useUtilTalk', '유틸메뉴 톡설치(메신저설치) 사용여부', 'NO', '포탈 탑메뉴 유틸메뉴에 톡설치 기능을 사용한다.YES: 사용NO: 사용안함 (default: NO)', '2019-09-20 00:00:00', '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'talkFilePath', '톡 설치 프로그램 위치', '/files/ezEKP-20190916.tar.gz', '톡 설치 프로그램 위치', '2019-09-20 00:00:00', '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useTotalSearch', '통합검색 사용여부', 'NO', '포탈 탑메뉴 유틸메뉴 옆에 통합검색 기능을 사용한다.YES: 사용NO: 사용안함 (default: NO)', '2019-10-04 00:00:00', '포탈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_CIRCULAR', '회람판 모듈 사용여부', 'NO', 'YES: 사용 NO: 사용안함 (default: YES)', '2017-01-06 00:00:00', '회람판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailWriteRecipientAdditional', '메일쓰기 수신인 추가 정보 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2019-12-10 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'mailWriteRecipientAdditionalFormat', '메일쓰기 수신인 추가 정보 포맷', ' (%s)', '자바 String.format에 들어가는 형태로 입력', '2019-12-10 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'mailWriteRecipientAdditionalParameters', '메일쓰기 수신인 추가 정보 파라미터', 'description','OrganUserVO 프로터피를 세미콜론으로 구분하여 입력 (default:부서)', '2019-12-10 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useCopyrightMenu', '수취인안내설정 관리 화면 여부', 'YES', 'YES: 사용 NO: 사용안함 (default: NO)', '2019-03-04 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSignatureTemplate', '서명템플릿', 'YES', '서명 템플릿 관리 사용여부 (default: YES)', '2019-12-09 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'spamSniperAuthIv', '스팸스나이퍼 ', 'Admin@spam123456', 'spamSniper Iv ', '2019-11-21 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'spamSniperAuthKey', '스팸스나이퍼 인증키', 'Admin@spam123456', 'spamSniper key', '2019-11-21 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'spamSniperUnixTime', '스팸스나이퍼 유효기간', '0', '스팸스나이퍼 인증 유효기간으로 초 단위로 입력', '2020-04-01 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'spamSniperUrl', '스팸스나이퍼 url', 'https://spam-demo.jiransecurity.com/personal/index.php', '스팸스나이퍼 url', '2019-11-21 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSpamSniper', '스팸스나이퍼 사용여부', 'NO', '스팸편지함 사용(default:YES, 사용안함 : NO)', '2019-11-21 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailConfirm', '메일 완료/완료취소', 'NO', '메일 완료/완료취소 기능 사용 여부(default: NO)', '2020-01-28 00:00:00', '메일');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSpamOut', '스팸아웃 사용여부', 'NO', '스팸편지함 사용(default:YES, 사용안함 : NO)', '2019-11-18 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'spamOutLoginURI', '스팸아웃 서버 ID 로그인 주소', 'http://spam-demo.ked.com/src/id_direct.php?user=%s&tok=abcdefghijklmnopqrstuvwxyz', '스팸아웃 서버의 스팸편지함으로 ID 로그인을 할 수 있는 URI, %s 로 파라미터를 넣을 수 있게 한다.', '2019-11-18 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAnnualSusinYN', '근태 휴가계 연동 결재 완료 시점', '0', '0:수신부서결재 사용, 1:내부결제사용 : 0이면 개인연차현황에서 완료처리가 되는 시점이 수신부서 결재완료, 1이면 내부결재 완료시 결재완료', '2020-01-23 14:00:00', '근태관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useUserDefinedDL', '사용자 정의 공용배포그룹 사용 여부', 'NO', '사용자 정의 공용배포그룹 사용 여부 (default:NO)', '2020-02-10 14:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useApprMail', '승인메일 기능 사용여부', 'NO', '승인메일 기능 사용여부(default: NO)', '2024-02-26 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'apprMailKeepLogPeriod', '승인메일 자동삭제,로그보존 기간', '3', '승인메일 자동삭제,로그보존 기간(default: 3, 단위: 개월)', '2024-03-14 00:00:00', '메일');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailAliasSettingOnLogin', '첫 로그인 시 이메일ID 설정 여부', 'NO', 'NO: 개인정보설정, 첫로그인에서 이메일ID 설정 불가능, YES: 개인정보설정, 첫 로그인 시 이메일ID 설정 가능', '2020-02-06 14:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useImageConvertServer', '그룹웨어에서 이미지 변환 솔루션 사용 ', '0', '0 : 사용안함, 1 : SAT', '2020-03-12 14:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'SATimageConvertServerURL', 'SAT 변환 솔루션 URL ', 'http://jmocha.kaoni.com:8080/DG_viewer/viewer/document/docviewer.do', 'IP 또는 PORT는 사이트에 맞게 변경', '2020-03-12 14:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'webfolderHostUrlForSAT', 'SAT 변환 솔루션에서 웹폴더 파일을 다운로드 하는 포트까지의 Rest API URL', 'http://jmocha.kaoni.com', '프로토콜://호스트이름:포트(생략가능)', '2021-06-14 00:00:00', '웹폴더');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAnnualScheduleYN', '근태현황 일정관리 연동', '0', '0:근태현황 일정관리 미연동, 1:근태현황 부서일정 연동, 2:근태현황 회사일정 연동', '2020-02-24 00:00:00', '근태관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'workspaceHostUrl', '협업의 호스트이름 까지의 주소', 'http://space.kaoni.com', '프로토콜://호스트이름', '2020-02-26 00:00:00', '협업');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'workspaceContextRootUrl', '협업으로 호출할 /ezWorkspace 이전까지의 주소', 'http://space.kaoni.com/myoffice', '프로토콜://호스트이름/myoffice', '2020-02-26 00:00:00', '협업');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useLoginStop', '사용자정지 사용여부', 'YES', '사용자정지 기능 사용여부(YES/NO)', '2020-04-03 00:00:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'HackingAdminID', '해킹의심메일 신고 관리자 계정', 'masteradmin', '해킹의심메일 신고 관리자 계정', '2020-04-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useHackingMailReport', '해킹의심메일 신고 기능 사용 여부', 'NO', '해킹의심메일 신고 기능 사용 여부(YES/NO)', '2020-04-06 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useExternalMailServer', '외부메일 사용 여부', 'NO', '메일 모듈 사용 여부. YES: 외부메일 사용 NO: 내부메일 사용(default: NO)', '2020-04-03 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USEPASSWORDRESET', 'NO', 'YES: 사용NO: 사용안함 (DEFAULT: YES)', '비밀번호 초기화 기능 사용여부', '2020-04-28 00:00:00', '로그인');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'USE_MATTITUDE', '모바일 근태관리 모듈 사용여부', 'NO', 'YES: 사용NO: 사용안함 (default: NO)', '2020-06-30 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'attitudeMapApiKey', '근태관리 지도 api key(미사용시 빈값)', '', '근태관리 지도 api key', '2020-06-30 00:00:00', '기타모듈');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useDeptSearchCab', '처리과 검색 조건 사용여부', 'NO', '기록물철등록부에서 검색 시 처리과 검색을 사용한다. YES:사용함 NO:사용안함 (default: NO)', '2020-07-13 00:00:00', '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useSchedule', 'YES: 사용 NO: 사용안함', 'YES', '일정 모듈 사용 여부', '2020-05-13 00:00:00', '일정관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useResource', 'YES: 사용 NO: 사용안함', 'YES', '자원관리 모듈 사용 여부', '2020-05-13 00:00:00', '자원관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useBoard', '게시판 모듈 사용 여부', 'YES', 'YES: 사용 NO: 사용안함 (default: YES)', '2020-05-13 00:00:00', '게시판');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useToDo', 'YES: 사용 NO: 사용안함', 'YES', '업무관리 모듈 사용 여부', '2020-05-13 00:00:00', '업무관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseAutoDeleteOfRetireUser', '퇴직자 자동삭제', 'NO', 'n일 이후 퇴직자 자동삭제 사용여부(default: NO)', '2020-09-14 00:00:00', '조직도');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'autoDeleteOfRetireUserLimit', '퇴직자 자동삭제', '0', 'n일 이후 퇴직자 자동삭제 : n일 설정(default: 0, 0=사용안함)', '2020-09-14 00:00:00', '조직도');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useExternalMailServerAddress', '외부메일 서버 주소 ', '0.0.0.0', '외부메일 서버 주소 (default:0.0.0.0)', '2020-09-29 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useExternalMailServerAuth', '외부메일 서버 인증 사용여부 ', 'NO', '외부메일 서버 인증 사용여부(default: NO)', '2020-09-29 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useExternalMailServerUserId', '외부메일 서버 인증 id', 'authId', '외부메일 서버 인증 id (ex: test@test.com)', '2020-09-29 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useExternalMailServerUserPw', '외부메일 서버 인증 pass', 'authId', '외부메일 서버 인증 pass (ex: password123)', '2020-09-29 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'autoSendOfferFlag', '내부시행문 자동발송의뢰 옵션', '0', '자동발송의뢰 사용 시 기안부서 최종결재가 끝나면 기안자의 미처리문서함에 도착한다. 0: 자동발송의뢰 사용안함, 1: 자동발송의뢰 사용함 (내부시행문, 민원인시행문만 자동발송의뢰) (default: 0)', '2020-11-23 00:00:00', '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useDeleteMailBlob', '메일 blob 삭제 스케줄러 사용여부', 'NO', '메일 blob 삭제 스케줄러 사용여부 (default:NO)', '2021-02-19 00:00:00', '메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useCar', 'YES: 사용 NO: 사용안함', 'NO', '차량관리 모듈 사용 여부', '2021-07-12 00:00:00', '차량관리');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ApprNonElecRecType', '전자결재G 비전자문서등록 양식 확장자', 'HWP', '전자결재 G버전의 비전자문서 등록 시, 양식 확장자를 설정한다. (MHT 또는 HWP) (default : HWP)', '2021-04-07 00:00:00', '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'copyReadCountBoardItem', '게시물 복사/이동 시 조회정보 유지기능', 'MOVE', '게시물 복사/이동 시 조회수, 조회자정보 유지 여부  COPY : 복사 시 조회정보 유지 MOVE : 이동 시 조회정보 유지 (default) ALL : 복사, 이동 시 조회정보 유지 NO : 사용안함', '2019-12-17 00:00:00', '게시판');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useApprCodeCont', '분류코드문서함 사용유무(전자결재 일반)', 'YES', '전자결재 분류코드문서함 사용유무', '2021-05-21 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useApprFormCont', '양식별문서함 사용유무(전자결재 일반)', 'YES', '전자결재 양식별문서함 사용유무', '2021-05-21 00:00:00', '전자결재');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailApprNoti', '전자결재에서 알림 메일 기능 사용 여부', 'YES', '전자결재에서 알림 메일 기능 사용 여부  YES: 사용 NO: 사용안함 (default : YES) * 2024-05-07 기준으로 표준모듈 master 브랜치에서 더이상 사용되지 않음', '2020-05-30 00:00:00', '전자결재');
INSERT INTO tbl_tenant_config (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAddrDupliCheck', '주소록 가져오기 시 기존주소록 중복체크 사용여부', 'YES', '주소록 가져오기 시 기존주소록 중복체크 사용여부(default: YES)', '2023-05-16 00:00:00', '주소록');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME,PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ApprAttachCntLimitMax', '전자결재 첨부파일 개수제한 최대 크기', '5', '전자결재 첨부파일 개수제한 설정의 최대값을 지정한다. (default: 100)', '2020-05-19 00:00:00', '전자결재');

-- 전자결재 첨부파일 - SAT뷰어사용 관련 변수 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useApprImageConvert', '전자결재 첨부파일 이미지 변환솔루션 사용', '0', '전자결재 첨부파일 이미지 변환솔루션 사용  여부  1: 사용 0: 사용안함 (default : 0)', '2021-06-15 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'apprConvertExt', '이미지 변환솔루션 사용할 전자결재 첨부파일 확장자 모음', 'xlsx:xls:pdf:hwp:doc', '이미지 변환할 확장자 모음 (default : xlsx, xls, pdf, hwp, doc) / 구분자 : ', '2021-06-15 00:00:00', '전자결재');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useOrgListCheckBox', '조직도 리스트 체크박스 표시', 'NO', '조직도 리스트 체크박스 표시 (메일,주소록) (default:NO)', '2021-11-10 00:00:00', '메일');

-- 전자결재G 일괄기안 테넌트 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useDraftAll', '웹한글 일괄기안 사용여부', 'NO', 'YES: 사용 NO: 사용안함 (default : NO)', '2022-02-25 00:00:00', '전자결재G');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'androidAppVersion', 'Mobile App Android Version', '1.0.0', 'Mobile App Android Version', '2021-11-10 00:00:00', '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'iosAppVersion', 'Mobile App IOS Version', '1.0.0', 'Mobile App IOS Version', '2021-11-10 00:00:00', '모바일');

-- 전자결재 리스트 우측 미리보기 테넌트 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAprPreview', '전자결재 리스트 우측 미리보기 사용여부', 'YES', '전자결재 리스트 우측에 미리보기 영역을 표출한다. YES: 사용  NO: 사용안함 (default: NO)', '2022-07-01 09:00:00', '전자결재');

-- 전자결재 기록물 등록 시 결재권자 칼럼(APRMEMBERTITLE)에 최종결재자명 또는 최종결재자 직위를 삽입하는 옵션 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'recordAprMemberTitleType', '전자결재 기록물등록 시 결재권자 칼럼에 결재자명 또는 직위를 삽입', 'TITLE', '전자결재 기록물등록 시 결재권자 칼럼에 결재자명 또는 직위를 삽입한다. NAME: 최종결재자명  TITLE: 최종결재자직위 (default: NAME)', '2022-07-26 09:00:00', '전자결재');

-- 다국어 사용 여부 설정 : 일본어 3, 중국어 4, 베트남어 5, 인도네시아어 6 (언어코드, 국가코드 참고 https://help.ads.microsoft.com/#apex/18/ko/10004/-1, http://www.lingoes.net/en/translator/langcode.htm)
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useJapanese', '일본어 사용여부', 'YES', '일본어 사용여부(YES: 사용, NO: 사용안함, default: YES) 언어코드 ja : Japanese, 국가코드 JP : Japan', '2023-08-18 17:40:00', '환경설정');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useChinese', '중국어 사용여부', 'NO', '중국어 사용여부(YES: 사용, NO: 사용안함, default: NO) 언어코드 zh : Chinese (中文 Zhōngwén), 국가코드 CN : Mainland China 중국 대륙(간체자)', '2023-11-17 10:40:00', '환경설정');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useVietnamese', '베트남어 사용여부', 'NO', '베트남어 사용여부(YES: 사용, NO: 사용안함, default: NO) 언어코드 vi : Vietnamese, 국가코드 VN : Viet Nam', '2024-01-17 00:00:00', '환경설정');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useIndonesian', '인도네시아어 사용여부', 'NO', '인도네시아어 사용여부(YES: 사용, NO: 사용안함, default: NO) 언어코드 id : Indonesian, 국가코드 ID : Indonesia', '2024-01-17 00:00:00', '환경설정');

-- 메일 태그 기능 사용 여부 설정
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useMailTag', '메일 태그 기능 사용 여부', 'YES', '메일 태그 기능 사용 여부 (기본값: NO)', '2022-10-05 00:00:00', '메일');

-- 전자결재G 관리자단 좌측메뉴 기록물철 자동생성 메뉴 표출여부 테넌트 컨피그 추가 (스케줄러가 아닌 반자동 생성)
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useRegisterCabinetSemiAuto', '전자결재G 관리자단 좌측메뉴 기록물철 자동생성 메뉴 표출여부', 'NO', '전자결재G 관리자단 좌측메뉴에 기록물철 자동생성 메뉴를 표출한다. (현재 연도의 종료 예정 기록물철을 그대로 복사하여 원하는 생산연도의 기록물철로 생성하는 기능 사용 여부) YES: 사용  NO: 사용안함 (default: NO)', '2022-12-27 00:00:00', '전자결재G');

-- 전자결재 가변결재선 기본 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'UseDynamicAprLine', '전자결재 가변결재선 사용여부', '0', '0/1 (0:사용안함, 1:사용함) (default: 0)', '2022-12-29 00:00:00', '전자결재');

-- 메일 자동전달 외부 주소 허용 여부 설정
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useBlockExternalForwardAddress', '외부주소 사용여부', 'NO', 'YES: 외부주소 허용하지 않음, NO: 외부주소 허용 (기본값: NO)', '2023-04-06 00:00:00', '메일');

-- 전자결재 기결재통과 옵션 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'usePassAprLine', '전자결재 기결재통과 사용여부', 'NO', '전자결재 기결재통과 기능을 사용한다. YES:사용  NO:사용안함 (default: NO)', '2023-06-22 00:00:00', '전자결재');

-- 전자결재 첨부파일 미리보기  옵션 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useAprFilePrvw', '결재문서 첨부파일 미리보기 기능 사용 여부', '1', '결재문서 첨부파일 미리보기 기능 사용 여부 0: 사용 안함, 1: 사용', '2023-06-29 00:00:00', '전자결재');
-- 게시판 첨부파일 미리보기  옵션 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useBoardFilePrvw', '게시판 첨부파일 미리보기 기능 사용 여부', '1', '게시판 첨부파일 미리보기 기능 사용 여부 0: 사용 안함, 1: 사용 (default: 0)', '2023-06-29 00:00:00', '게시판');

-- 전자결재 서명 데이터 재맵핑 시점 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'apprSignRemapApplyTime', '전자결재 서명 데이터 재맵핑 시점', DATE_FORMAT(UTC_TIMESTAMP(), '%Y-%m-%d %H:%i:%s'), '결재서명 데이터를 재맵핑하기 위해, TBL_SIGNINFO 테이블에 정상적인 데이터 삽입을 보장하는 시점을 정의한다. 해당 시점 이후에 기안된 문서들이 결재서명 재맵핑 대상이 된다. (UTC 시간, %Y-%m-%d %H:%i:%s 형식)', sysdate(), '전자결재');

-- 권한을 겸직/사용자 기준으로 설정 옵션 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'permissionBasisDeptYN', '조직도 권한부여 기준 설정', 'N', '조직도 > 권한 설정 시 Y: 사용자/겸직부서를 기준으로 권한을 부여한다 // N: 사용자만을 기준으로 권한을 부여한다.(Default: N)', '2023-08-16 00:00:00', '조직도');

-- 전자결재 재기안 시 반송의견 유지여부 컨피그 추가 (관련 기능은 2020년 4월에 추가됨)
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useRedraftOpinionKeep', '전자결재 반송의견 재기안 시 유지 여부', 'NO', '전자결재 반송문서 재기안 시 반송의견을 유지하는 기능을 사용한다. YES:사용 NO:사용안함 (default: NO)', '2024-03-27 00:00:00', '전자결재');
-- 전자설문 종료 후 게시기간 설정 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'SurveyPostingMaxPeriod', '전자설문 종료 후 게시기간 설정', '999', '전자설문 설문 종료 후 게시기간 최대일자를 설정한다. (default:999)', '2024-03-26 00:00:00', '전자설문');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'switchUserCompany', '포탈 유저 회사 변경 기능', 'N', '유저의 사간 겸직 변경 허용 여부. Y:허용 그외: 불가', '2023-11-03 00:00:00', '포탈');

-- 메일 개별발신 티폴트 사용여부 옵션 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useEachMailDefault', '메일 개별발신 디폴트 사용여부 ', 'NO', '시스템 > 패러메터 > 개별발신 디폴트 사용  메일쓰기 시 개별발신 사용을 디폴트로 설정한다. 사용 : YES , 사용안함 : NO (default : NO)', '2024-01-31 00:00:00', '메일');

-- 누락된 컨피그 추가 (문서24 관련)
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'useDoc24', '문서24 사용여부', 'YES', '문서24 사용여부 YES:사용함 NO:사용안함 (default:NO)', '2021-03-16 00:00:00', '전자결재');
-- 만료게시물 조회가능 여부
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'endDateOptionConfig', 'NOPE', '게시판 게시물 리스트 조회 시 만료게시물 조회가능 여부 / NOPE:불가, ADMIN:관리자만 조회가능, ALWAYS:전부 조회 가능 (default:NOPE)', '만료게시물 조회가능 여부', '2024-05-24 00:00:00', '게시판');

INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (@tenant_id_value, 'Top', 'useCopyright', 'NO');
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (@tenant_id_value, 'Top', 'ExpirePassPeriod', '0');
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (@tenant_id_value, 'Top', 'MaxAllowedCountOfLoginFail', '0');
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (@tenant_id_value, 'Top', 'UsePasswordPatternPolicy', 'NO');
-- 중복 로그인 허용 (기본값: YES, 허용)
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (@tenant_id_value, 'Top', 'useMultiLogin', 'YES');
-- 중복 로그인 비허용시 PC, Mobile 통합 체크 (기본값: NO, 따로 체크)
INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (@tenant_id_value, 'Top', 'useMobileIntergratedMultiLogin', 'NO');
-- 전자결재 > 지정반송 사용여부 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'ReturnByDesignationUsed', '지정반송 사용여부', 'NO', '지정반송 사용여부 (default:NO)', '2024-06-18 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'MyBoardScrapFlag', '게시판 스크랩기능 사용여부', 'TYPE1', 'NONE: 사용안함 / TYPE1: 마이게시판 하위 스크랩함 / TYPE2: 게시판 트리 하위 개인화 스크랩함 (default:TYPE1)', '2023-06-14 00:00:00', '게시판');

INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (@tenant_id_value, 'Top', 'useFidoSession', 'NO');

-- Board insert 
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',1,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',3,'제목','Title','件名','标题','TITLE',400,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',4,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',5,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',6,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('0',7,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',1,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',2,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',3,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',4,'제목','Title','件名','标题','TITLE',500,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',5,'회사','Company','会社','公司','WRITERCOMPANYNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',6,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',7,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',8,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('1',9,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',1,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',3,'제목','Title','件名','标题','TITLE',500,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',4,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',5,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('2',6,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',1,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',3,'제목','Title','件名','标题','TITLE',300,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',4,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',5,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',6,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('3',7,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',1,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',2,'제목','Title','件名','标题','TITLE',600,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',3,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',4,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',5,'게시일','Registered','掲示日','发布日期','WRITEDATE',120,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('4',6,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',1,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',3,'제목','Title','件名','标题','TITLE',400,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',4,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',5,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',6,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('5',7,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',1,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',2,'제목','Title','件名','标题','TITLE',600,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',3,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',4,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',5,'게시일','Registered','掲示日','发布日期','WRITEDATE',120,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('7',6,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',1,'첨부','Attach','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',2,'게시판명','Board','掲示板名','布告板名称','BOARDNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',3,'제목','Title','件名','标题','TITLE',400,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',4,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',5,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',6,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('A',7,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',1,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',3,'게시판명','Board','掲示板名','布告板名称','BOARDNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',4,'제목','Title','件名','标题','TITLE',400,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',5,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',6,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',7,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('M',8,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',1,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',3,'게시판명','Board','掲示板名','布告板名称','BOARDNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',4,'제목','Title','件名','标题','TITLE',400,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',5,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',6,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',7,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('N',8,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',1,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',2,'제목','Title','件名','标题','TITLE',400,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',3,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',4,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',5,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('S',6,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);

-- 게시판 > 최근게시물
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('R',0,'CHECK','CHECK','CHECK','CHECK','ITEMID',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('R',1,'No','No','No','No','DOCNO',30,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('R',2,'첨부','Attachments','添付','附加','ATTACHMENTS',20,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('R',3,'게시판명','Board','掲示板名','布告板名称','BOARDNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('R',4,'제목','Title','件名','标题','TITLE',400,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('R',5,'부서','Department','部署','部门','WRITERDEPTNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('R',6,'게시자','Writer','作成者','写作者','WRITERNAME',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('R',7,'게시일','Registered','掲示日','发布日期','WRITEDATE',100,'Y',@tenant_id_value);
Insert into TBL_BOARD_ITEM_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,VIEW_FG,TENANT_ID) values ('R',8,'조회수','View','ヒット数','查询数','READCOUNT',50,'Y',@tenant_id_value);

INSERT INTO TBL_BOARD_BOARDINFO (BOARDID, BOARDNAME, BOARDNAME2, BOARDNAME3, BOARDNAME4, TREEVIEWORDER, BOARDLEVEL, PARENTBOARDID, BOARDDESCRIPTION, ITEMEXPIRES, ATTACHSIZELIMIT, REPLYNOTIFY, BOARDGROUPID, ALERTPOSTITEM, GUBUN, URL, DELETEAFTER, BOARDCOLOR, BOARDNO, PORTLET, TENANT_ID, COMPANYID) VALUES ('{YYYYYYYY-YYYY-YYYY-YYYY-YYYYYYYYYYYY}', '최근게시물', 'Recent BoardItem', '最近の投稿', '最近的帖子', -2, 0, 'None', NULL, 0, NULL, 0, NULL, 0, 0, NULL, 0, NULL, 0, 'N', @tenant_id_value, 'Top');

-- Community Insert

Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('AA','a','t1496',1,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CC','a','t1497',2,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CE','a','t1498',3,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CG','a','t1499',4,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CI','a','t1500',5,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CK','a','t1501',6,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CM','a','t1502',7,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CO','a','t1503',8,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EC','a','t1504',9,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EE','a','t1505',10,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EG','a','t1506',11,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EI','a','t1507',12,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('ZA','a','t1508',22,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('AA','b','t1509',1,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CC','b','t1510',2,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EC','b','t1511',3,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('GC','b','t1512',4,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('IC','b','t1513',5,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('KC','b','t1514',6,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('MC','b','t1515',7,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('OC','b','t1516',8,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('QC','b','t1517',9,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EK','a','t1518',13,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('ZC','b','t1519',10,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('AA','c','t1520',1,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('CC','c','t1521',2,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('EC','c','t1522',3,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('GC','c','t1523',4,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('IC','c','t1524',5,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('KC','c','t1525',6,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('MC','c','t1526',7,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('OC','c','t1527',8,@tenant_id_value);
Insert into TBL_C_CATEGORY (C_CODE,C_CAT,C_NAME,C_ORDER,TENANT_ID) values ('ZA','c','t1528',9,@tenant_id_value);

-- approvalG Insert
INSERT INTO TBL_LastDocID  (lastDocID, COMPANYID, TENANT_ID) VALUES ('0                ','Top',@tenant_id_value);

INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'100', N'001','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'200', N'002','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'300', N'003','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'300', N'014','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'300', N'018','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'500', N'011','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'500', N'015','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'600', N'012','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'610', N'019','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (NULL , N'022','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (NULL , N'023','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'700', N'031','Top',@tenant_id_value);
INSERT INTO   TBL_CONTAINERTODOCSTATE  (ContainerTypeID,  DocumentState, COMPANYID, TENANT_ID) VALUES (N'700', N'032','Top',@tenant_id_value);

-- ----------------------------------------
-- TENANT_ID 추가시 TENANT_ID 수정해서 INSERT
-- -- ---------------------------------------

INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (1, UUID(), 'processinfo', 'F0001', '문서정보', 'ROOT','Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (2, UUID(),'headcampaign', 'F0002', '머리표제', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (3, UUID(),'doctitle', 'F0003', '문서제목', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (4,	UUID(), 'body', 'F0004', '본문', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (5,	UUID(), 'docnumber', 'F0005', '문서번호', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (6,	UUID(), 'grouping', 'F0006', '분류기호', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (7, UUID(),'publication', 'F0007', '공개유무', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (8,	UUID(), 'securitylevel', 'F0008', '보안등급', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (9,	UUID(), 'keepperiod', 'F0009', '보존년한', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (10,UUID(), 'docsummary', 'F0010', '문서요약', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (11,UUID(), 'senddate', 'F0011', '발신일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (12,UUID(), 'enforcedate', 'F0012', '시행일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (13,UUID(), 'memo', 'F0013', '의견', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (14,UUID(), 'zipcode', 'F0014', '우편번호', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (15,UUID(), 'telephone', 'F0015', '전화', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (16,UUID(), 'junkyul', 'F0016', '전결/대결', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (17,UUID(), 'address', 'F0017', '주소', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (18,UUID(), 'sealsign', 'F0018', '관인날인', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (19,UUID(), 'noseal', 'F0019', '관인생략', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (20,UUID(), 'receiptnumber', 'F0056', '접수번호', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='processinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (21,UUID(), 'draftinfo', 'F0020', '기안부서 정보', 'ROOT','Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (22,UUID(), 'draftername', 'F0021', '기안자 성명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (23,UUID(), 'department', 'F0022', '기안자 부서명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (24,UUID(), 'position', 'F0023', '기안자 직위', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (25,UUID(), 'email', 'F0024', '기안자 Email', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (26,UUID(), 'draftdate', 'F0025', '기안일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (27,UUID(), 'lastKyulName', 'F0026', '최종결재자명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (28,UUID(), 'lastKyuljikwee', 'F0027', '최종결재자직위', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (29,UUID(), 'chief', 'F0028', '기관장', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (30,UUID(), 'deptshortedname', 'F0029', '부서약어', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='draftinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (31,UUID(), 'receiptinfo', 'F0030', '수신 정보', 'ROOT','Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (32,UUID(), 'recipient', 'F0031', '수신', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (33,UUID(), 'recipients', 'F0032', '수신처', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (34,UUID(), 'refer', 'F0033', '참조', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (35,UUID(), 'seal', 'F0034', '발신처명의', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (36,UUID(), 'receiptdate', 'F0035', '접수일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='receiptinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (37,UUID(), 'approvalinfo', 'F0036', '기안결재 사인정보', 'ROOT','Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (38,UUID(), 'sign', 'F0037', '결재사인', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (39,UUID(), 'approdept', 'F0038', '결재자부서명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (40,UUID(), 'jikwe', 'F0039', '결재자직위', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (41,UUID(), 'seumyung', 'F0040', '결재자명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (42,UUID(), 'seumyungdate', 'F0041', '결재일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (43,UUID(), 'habyuisign', 'F0042', '합의자 사인', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (44,UUID(), 'habyui', 'F0043', '합의자 부서명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (45,UUID(), 'habyuipositon', 'F0044', '합의자 직위', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (46,UUID(), 'habyuija', 'F0045', '합의자명', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (47,UUID(), 'habyuidate', 'F0046', '합의일자', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (48,UUID(), 'gongram', 'F0047', '공람사인', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='approvalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (49,UUID(), 'recvapprovalinfo', 'F0048', '수신결재 사인정보', 'ROOT','Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (50,UUID(), '1sign', 'F0049', '결재사인1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (51,UUID(), '1approdept', 'F0050', '결재자부서명1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (52,UUID(), '1jikwe', 'F0051', '결재자직위1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (53,UUID(), '1seumyung', 'F0052', '결재자명1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (54,UUID(), '1seumyungdate', 'F0053', '결재일자1', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='recvapprovalinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (55,UUID(), 'userdefinedinfo', 'F0054', '사용자 지정', 'ROOT','Top',@tenant_id_value);
INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (56,UUID(), '', 'F0055', '사용자정의정보', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='userdefinedinfo' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'Top'),'Top',@tenant_id_value);
-- INSERT INTO    TBL_FORMPROPERTY  (SN, CODE,  ID,  NAME,  DESCRIPTION,  UPPERCODE, COMPANYID, TENANT_ID) VALUES (57,UUID(), 'free', 'F0057', '사용자정의정보', (SELECT CODE FROM    TBL_FORMPROPERTY T WHERE ID='userdefinedinfo' AND TENANT_ID = 0 AND COMPANYID = 'Top'),'Top',@tenant_id_value);

INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','003','수신문','1','수신문','Receipt','受信文','收件文件','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','004','연계기안','1','시행문','Linked Draft',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','005','협조','1','부서합의','Agreement(personal)','合意','起案书','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','006','감사','0','감사문서','Audit','監査','审查','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A24','001','0','1','문서보기를 위한 기한을 설정.','0','0','0','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A25','0  ','회송처리','1','0:원기안부서, 1:이전 수신부서','Return','회송처리','회송처리','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A25','001','0','1','구분','0','0','0','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A26','0  ','대리결재사인헤드','1','대리결재사인헤드','Deputy approval sign','대리결재사인헤드','대리결재사인헤드','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A26','001','代','1','대리결재사인헤드','Deputy','代','代','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A27','0  ','수신처구분','1','0:부서,1:부서/사람','Receiver type','수신처구분','수신처구분','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A27','001','부서','1','부서','Dept','부서','부서','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A27','002','부서/사람','0','부서/사람','Dept/Personnel','부서/사람','부서/사람','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A28','0  ','조직도구분','0','조직도 구분','Organ type','조직도구분','조직도구분','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A28','001','001','1','조직도 직위','001','001','001','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A28','002','002','0','조직도 직책','002','002','002','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A28','003','003','0','조직도 직위/직책','003','003','003','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A29','0  ','개인수신처','0',null,'Personal receiver','개인수신처','개인수신처','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A29','001','개인수신처구분','0','1:수신처리기, 0:결재진행관리기','Personal receiver type','개인수신처구분','개인수신처구분','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A30','0  ','문서채번룰','1','문서채번시 적용되는 룰 정의','Doc. numbering rule','문서채번룰','문서채번룰','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A30','001','11S','1','x1 - 채번범위 (0:전체, 1:부서별, 2:양시함별) x2 - 분류기호 사용여부(0:사용안함, 1:사용함) x3 - 초기화 시점 (N: 초기화안함, M: 월별, Y:년별)','11S','11S','11S','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A30','002','0000','1','문서번호 FORMAT','0000','0000','0000','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A30','003','0','1','회계종료월 (예: 2007.3~2008.2 이 회계년도이면 2를 넣는다. 1~12월이면 0을 넣는다)로 채번 및 기록물등록년도에 이용된다','0','0','0','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A31','0  ','결재처리제한','0','결재처리 되지 않는 문서리스트 제한','Restrict approval','결재처리제한','결재처리제한','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A31','001','3','0','N일 이상 지체되는 결재문서','3','3','3','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A32','0  ','전결처리방법','0','전결처리방법 정의','Arbitrary decision','전결처리방법','전결처리방법','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A32','001','100','1','x1 - 전결자 (0:사인, 1:전결표시)x2 - 전결이후 결재자(0:표시안함, 1: 전결표시)x3 - 최종결재자(0:사인, 1:전결표시)','100','100','100','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A33','0  ','결재칸Split 유무','0','결재한 Split  유무확인','Sign box Split Y/n','결재칸Split 유무','결재칸Split 유무','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A33','001','N','1','사용유무','N','N','N','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A33','002','FIX','1','FIX : 칸고정, DIV : 칸나눔으로 처리','FIX','FIX','FIX','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A34','0  ','문서링크','0','합의/감사 문서 Link','Doc. link','문서링크','문서링크','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A34','001','9','1','0:사용안함,1:합의,2:감사,9:전체적용','9','9','9','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A35','0  ','수신함보내기','0','수신함으로 바로 보내기','Send to receiving box','수신함보내기','수신함보내기','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A35','001','0','1','0:사용안함,1:사용함. 1이면 완료쪽으로 Copy','0','0','0','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A35','002','G','1','G버전 Flag. "G"면 심사시에만 문서 발송. (G 정부버전, S 대학버전)','G','G','G','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A35','003','Y','1','G버전 폐기 Flag. "Y"면 완료후 보존기간 경과한 문서 폐기 대상. 그외는 이관된 기록물철은 모두 폐기대상.','Y','Y','Y','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','0  ','변환문서','0','변환문서URL','Conversion doc.','변환문서','변환문서','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','001','/files/upload_approvalG/form/2003000007.mht','1','합의문서','/files/upload_approvalG/form/2003000007.mht','/files/upload_approvalG/form/2003000007.mht','/files/upload_approvalG/form/2003000007.mht','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','002','/upload_approvalG/S907000/form/2006000001.hwp','1','감사문서','/upload_approval/S907000/form/2003000008.mht','/upload_approvalG/S907000/form/2006000001.hwp','/upload_approvalG/S907000/form/2006000001.hwp','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','003','/files/upload_approvalG/form/relay001.hwp','1','유통문서(중계)','/files/upload_approvalG/form/relay001.hwp','/files/upload_approvalG/form/relay001.hwp','/files/upload_approvalG/form/relay001.hwp','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','004','/upload_approvalG/S907000/form/2006000001.hwp','1','행정문서(연계)','/upload_approvalG/S907000/form/2006000001.hwp','/upload_approvalG/S907000/form/2006000001.hwp','/upload_approvalG/S907000/form/2006000001.hwp','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','005','/upload_approvalG/S907000/form/2006000001.hwp','1','전자기안문','/upload_approvalG/S907000/form/2006000001.hwp','/upload_approvalG/S907000/form/2006000001.hwp','/upload_approvalG/S907000/form/2006000001.hwp','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','006','/ekp/Upload_ApprovalG/','1','Document Path','/ekp/Upload_ApprovalG/','//ekp/Upload_ApprovalG/','//ekp/Upload_ApprovalG/','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A36','007','2005000015;','1','(전자기안문양식아이디1);(전자기안문양식아이디2);.....','2005000015;','2005000015;','2005000015;','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A37','0  ','그룹사용','0','참조그룹사용','그룹사용',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A37','001','junsign','1','사인ID 값. null 값이면 사용안함','junsign',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A38','0  ','특정인 결재처리','0','특정인에 대한 결재 사인처리를 한다.','Sign on specific person','특정인 결재처리','특정인 결재처리','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A38','001','1','1','참조사용유무 0:사용안함,1:사용함','1','1','1','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A39','0  ','첨부문서Filter',null,'첨부할 문서 종류를 제한한다.','Attachment filter','첨부문서Filter','첨부문서Filter','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A39','001','NONE','1','NONE(대문자) : 사용안함 , ;로 구분한다.','NONE','NONE','NONE','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A39','002','50','1','단위:메가','50','50','50','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A40','0  ','감사부서정의','0','감사부서 정의','Define audit dept.','감사부서정의','감사부서정의','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A40','001','S907002','1','20630감사부서ID 리스트, 부서1;부서2;부서3;..부서N','S907002','S907002','S907002','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A43','0  ','노티유무','0','노티유무','Notify Y/n','노티유무','노티유무','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A43','001','Y','1','N:사용안함,Y:사용','Y','Y','Y','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A44','0  ','최근결재선정보','1','최근 결재선 정보 사용유무','Last approval line','최근결재선정보','최근결재선정보','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A44','001','1','1','결재선 : 0:사용안함,1:사용함','1','1','1','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A44','002','0','1','수신처 : 0:사용안함,1:사용함','1','0','0','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A50','0  ','공개/비공개 정의','0','공개비공개정의(ALL : 모든 사람, DEPT : 부서원 + 결재선, LINE : 결재선, DRAFT : 기안자만)','공개/비공개 정의E','공개/비공개 정의','공개/비공개 정의','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A50','1  ','ALL','1','공개','ALL','ALL','ALL','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A50','2  ','DEPT','1','부분공개','DEPT','DEPT','DEPT','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A50','3  ','LINE','1','비공개','LINE','LINE','LINE','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','0  ','보안등급정의','0','보안등급정의','보안등급정의',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','001','1;1등급;100','1','임시;이름;코드','1;Level 1;100','1;Level 1;100','1;Level 1;100','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','002','1;2등급;200','1',null,'1;Level 2;200','1;Level 2;200','1;Level 2;200','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','003','1;3등급;300','1',null,'1;Level 3;300','1;Level 3;300','1;Level 3;300','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','006','1;준영구;100','1',null,'1;Semi-permanence;100','1;準永久;100','1;准永久;100','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','007','1;영구;1000','1',null,'1;Permanence;1000','1;永久;1000','1;永久;1000','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A53','0  ','수신처그룹기호','0','수신처그룹구분기호 정의','Receiver group symbol','수신처그룹기호','수신처그룹기호','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A53','001','SG_','1','수신처 그룹 앞부분에 사용할 필드명. COM에서 사용. 스크립트 부분 동기화 필요','SG_','SG_','SG_','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A53','002','Y','1','수신처 그룹 확장(수신처 저장시 확장여부). Y는 사용. N은 사용안함','Y','Y','Y','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A54','0  ','배부대장처리방법','0','배부대장 처리방법','Dist. box proc. method','배부대장처리방법','배부대장처리방법','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A54','001','Y','1','Y:기존 데이터 업데이트, N:신규데이터생성','Y','Y','Y','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A54','002','Y','1','Y:다중배부 문서 재배부요청 시 한개의 문서만 남김, N:다중배부문서 재배부요청시 문서변화 없음','Y','Y','Y','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A55','0  ','자동발송의뢰코드','0','민원인 주소가 존재할 때에 자동 발송의뢰 하는 루틴 옵션. (계명대 특수 옵션)','Auto send req. code','자동발송의뢰코드','자동발송의뢰코드','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A55','001','S904000','1','민원인 주소일때에 이 부서로 자동 발신을 의뢰한다.','S904000','S904000','S904000','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A56','0  ','공람발송관련','0','수신처 공람발송 순차/병렬여부 설정','Public display','공람발송관련','공람발송관련','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A56','001','Y','1','Y면 병렬, 그외는 순차 공람.','Y','Y','Y','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A57','0  ','내양식함관련','0','내양식함 기능 사용 여부','My forms','내양식함관련','내양식함관련','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A57','001','Y','1','내양식함기능 사용여부 (Y는 사용. 그외는 사용안함)','Y','Y','Y','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','0  ','수신처상태','0','ProcessYN Flag','Receiver state','수신처상태','수신처상태','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','A  ','도착','1','도착 (Arrived)','Arrived','到着','到达','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','B  ','발송의뢰반송','1','발송의뢰반송(Return Offered)','Return Offered','送信依頼拒否','拒绝发送请求','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','E  ','전송실패','1','전송 실패 (Error)','Error','送信エラー','传输失败','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','H  ','회송','1','회송 (HweSong)','Return','返送','返回','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','I  ','접수','1','접수 (Inter..)','Reception progress','受付','收到','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','N  ','대기','1','발신 대기 (Not Yet)','No receipt','待機','待机','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','O  ','발송의뢰','1','발송 의뢰 (Offered)','Offered','送信依頼','发送请求','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','R  ','수신','1','수신 (Received)','Received','受信','接待','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','S  ','발송','1','발송 (Sent)','Sent','送信','送货','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','T  ','재발송대기','1','재발송대기 (Try Again)','Try Again','再送待ち','不满等待','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','V  ','도달','1','도달 (arriVed)','arriVed','到達','抵达','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A60','Y  ','수신완료','1','수신완료 (Yes)','Reception complete','受信完了','接收完成','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('F01','0  ','플로우','0','플로우관련 업무 정의','Flow','플로우','플로우','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('F01','001','Y','1','수발신문을 발신함으로 보낸다.','Y','Y','Y','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('F01','002','O','1','D:DSN연결;O:OleDB 연결','O','O','O','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J01','0  ','조직도소팅순서','1','조직도소팅순서','Organ order','조직도소팅순서','조직도소팅순서','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J01','001','이름순서','0','이름순서','Name Order','Name Order','Name Order','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J01','002','TREE ORDER LIST','0','조직도 순서리스트','TREE ORDER LIST','TREE ORDER LIST','TREE ORDER LIST','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J01','003','사번','0','사번','EmpNo','EmpNo','EmpNo','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','000','사원리스트','4','사원리스트순서사용여부','Personnel list','사원리스트','사원리스트','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','001','성명','1','사원명','Name','氏名','姓名','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','002','부서','1','부서명','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','003','직위','1','사원직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','004','전화번호','1','전화번호','Phone no.','電話番号','电话号码','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J02','005','회사','1','회사명','Company','会社','公司','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('J03','002','KMTESTOrganName','1','KMTESTOrganName',null,null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L01','0  ','다국어처리','0','다국어코드값','Multi-lang.','다국어처리','다국어처리','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L01','001','파일','1','File','File','ファイル','File','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L01','002','문서','1','Document','Document','Document','Document','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L02','001','문서함명리스트','0','NULL','Doc. folder name','文書フォルダ名','Doc. folder name','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L03','001','개인문서함','1','개인문서함-GetUserContTree()','Personal doc. folder','Personal doc. folder','Personal doc. folder','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L03','002','문서함명','1','부서문서함-GetDeptContTree()','Dept. doc. folder','文書フォルダ名','Dept. doc. folder','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L04','001','부서명','1','부서명-GetContUseDeptInfo()','Dept. name','Dept. name','Dept. name','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','001','코드','1','GetItemCode_Item()','Code','Code','Code','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','002','기능명칭','1','GetItemCode_Item()','Name','Name','Name','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','004','1;4등급;400','1',null,'1;Level 4;400','1;Level 4;400','1;Level 4;400','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','003','보존기간','1','GetItemCode_Item()','Keeping period','Keeping period','Keeping period','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','004','보안등급','1','GetItemCode_Item()','Security level','Security level','Security level','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A51','005','1;5등급;500','1',null,'1;Level 5;500','1;Level 5;500','1;Level 5;500','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','0  ','보존년한정의','0','보존연한정의','Archive year','보존년한정의','보존년한정의','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','001','1;1년;1','1',null,'1;1 year;1','1;1年;1','1;1年;1','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','002','1;2년;2','0',null,'1;2 year;2','1;2年;2','1;2年;2','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','003','1;3년;3','1',null,'1;3 year;3','1;3年;3','1;3年;3','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','004','1;5년;5','1',null,'1;5 year;5','1;5年;5','1;5年;5','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A52','005','1;10년;10','1',null,'1;10 year;10','1;10年;10','1;10年;10','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L05','005','공개여부','1','GetItemCode_Item()','Public','Public','Public','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','001','결재문서','1','결재알림시 사용','Approval doc.','결재문서','결재문서','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','002','문서도착','1','결재알림시 사용','Doc. arrival','문서도착','문서도착','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','003','문서완료','1','결재알림시 사용','Finish doc.','문서완료','문서완료','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','004','문서반송','1','결재알림시 사용','Return doc.','문서반송','문서반송','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','005','문서보류','1','결재알림시 사용','Hold doc.','문서보류','문서보류','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','006','문서발송','1','결재알림시 사용','Send doc.','문서발송','문서발송','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','007','수신문서','1','결재알림시 사용','Receiving doc.','수신문서','수신문서','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','008','지정문서','1','결재알림시 사용','Designated doc.','지정문서','지정문서','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','009','회송문서','1','결재알림시 사용','Returned doc.','회송문서','회송문서','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','010','문서회수','1','결재알림시 사용','Withdraw doc.','문서회수','문서회수','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','011','결재노티','1','결재알림시 사용','Notify approval','결재노티','결재노티','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','012','배부문서','1','결재알림시 사용','Distribute doc.','배부문서','배부문서','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','013','재지정요청','1','결재알림시 사용','Redesignation req.','재지정요청','재지정요청','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('L06','014','재배부요청','1','결재알림시 사용','Redistribution req.','재배부요청','재배부요청','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','007','신청','0','신청문서','Application','申し込み','申请','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','008','대외접수','0','대외문서접수','Receipt(outside)','対外受付','对外接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','009','대외발송','0','대외문서발송','Sending(outside)','対外送信','对外发送','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','0  ','문서상태','0','문서상태','Doc. status','文書区分','文書区分','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','001','품의','1','품의','Draft','稟議','评价','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','002','협조','1','협조','Agreement(personal)','協力','合作','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','003','준법감시','1','감사','Audit','遵法監視','监督','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','004','발송의뢰','0','심사','Request send','審査','审查','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','011','수신','1','수신','Receipt','受信','收件','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','012','합의','1','협조/합의','Agreement','合意','起案书','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','013','시행','0','시행','Enforcement','施行','执行','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','014','사전감사','0','감사(검사부)','Audit(dept.)','監査','审查','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','015','공람','0','공람','Display','回覧','传阅','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','016','회람1','0','회람','Circular','回覧','传阅','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','017','참조','1','참조','Reference','参照','抄送','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','018','사후공람','1','사후감사','Public viewing(After-approval)','事後供覧','事后共览','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','019','발송','1','발송','Sending','送信','发送','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','020','신청','1','신청','Application','施行','执行','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','022','대외접수','1','대외문서접수','Receipt(outside)','対外受付','对外接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','023','대외발송','1','대외문서발송','Sending(outside)','対外送信','对外发送','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','031','반송','1','반송','Rejection','差し戻し','退回','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A02','032','회송','1','회송','Returning','返送','退回','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','0  ','결재방법','0','결재방법','결재방법',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','001','결재','1','일반','Approval','決裁','审批','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','002','확인','1','확인','Confirmation','確認','確認','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','003','결재안함','0','결재안함','Skip-approval','決裁しない','不审批','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','004','전결','1','전결','Pre-approval','専決','先决','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','005','준법감시','0','감사','Audit','遵法監視','监督','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','006','발송의뢰','0','심사','Request Sending','審査','审查','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','007','참조','0','참조','Reference','参照','抄送','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','008','개인순차합의','1','개인순차협조','Agreement(personal)','個人順次合意','个人顺序协议','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','009','개인병렬합의','1','개인병렬협조','Parallel agreement(personal)','個人並列合意','个人并行协议','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','011','부서순차합의','1','부서순차협조','Sequential agreement(dept.)','部署順次合意','顺序协议(部门)','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','012','부서병렬합의','1','부서병렬협조','Parallel agreement(dept.)','部署並列合意','并行的协议(部门)','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','013','사전감사','0','감사','Pre-audit','監査','审查','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','014','수신','0','제일제당수신','Receipt','受信','收件','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','015','공람','0','후결','Display','回覧','传阅','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','016','대결','1','대결','Deputy','代決','待决','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','017','회람','0','공람','Circular reference','回覧','传阅','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','018','기안','1','기안','Draft','起案','起草','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A03','019','검토','1','검토','Examination','検討','评论','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','0  ','결재처리상태','0','결재처리상태','결재처리상태',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','000','미결','1','기안처리하지 않은 문서','Not approved','未決','未決','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','001','대기','1','대기','Waiting','待機','待机','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','002','진행','1','진행','In progress','進行中','进行中','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','003','승인','1','승인','Approved','決裁','审批','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','004','반송','1','반송','Rejected','差し戻し','退回','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','005','보류','1','보류','Hold','保留','保存','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','006','회수','1','회수','Withdrew','引き戻し','回收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','010','완료','1','완료','Completed','完了','完成','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','011','도착','1','도착','Arrived','到着','到达','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','012','미접수','1','지정','Designated','未受付','未接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','013','접수','1','접수','Received','受付','接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','014','배부','1','배부','Distributed','転送','发行','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','015','회송','1','회송','Returned','返送','退回','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','016','접수','1','수신진행','Received','受信進行','进行接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','017','수신완료','1','수신완료','Completed(receipt)','受信完了','接收完成','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','018','발신','1','수신부서미접수','Sending','未受付','未接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','019','전송실패','1','전송실패','Sending failure','送信エラー','传输失败','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','020','수신','1','전송성공','Receipt','受信','接待','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','021','도달','1','도달(G중계)','Arrived','到達','到达','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A04','022','재요청','1','재발신요청','ReRequest','ジェヨチョン','再生','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','0  ','사인종류','1','사인종류','Sign type','사인종류','사인종류','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','001','PIC','1','일반결재','PIC','PIC','PIC','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','002','PIC','1','개인순차협조','PIC','PIC','PIC','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','003','PIC','1','개인병렬협조','PIC','PIC','PIC','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','004','NAME','1','부서순차협조','NAME','NAME','NAME','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','005','NAME','1','부서병렬협조','NAME','NAME','NAME','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','006','PIC','1','공람','PIC','PIC','PIC','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','007',null,'1','전결',null,null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','008',null,'1','대결',null,null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A05','009','DNAME','1','후결','DNAME','DNAME','DNAME','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A13','0  ','결재TYPE','1','결재형식','결재TYPE','결재TYPE','결재TYPE','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A13','001','001','0','사용자와부서분리','001','001','001','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A13','002','002','1','사용자와부서가 통합','002','002','002','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A15','0  ','UI폼형식처리','1','UI폼형식처리','UI Form format','UI폼형식처리','UI폼형식처리','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A15','001','yyyy.mm.dd hh:mm','1','년-월-일','yyyy.mm.dd hh:mm','yyyy.mm.dd hh:mm','yyyy.mm.dd hh:mm','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A15','002','.','1','사인일자 형식','.','.','.','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','0  ','의견종류','1','의견종류','의견종류',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','000','추가의견','1','추가의견','Add','追加','追加意见','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','001','일반의견','1','일반의견','General','一般','一般意见','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','002','반송의견','1','반송의견','Rejection','差し戻し','退回意见','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','003','보류의견','1','보류의견','Holding','保留','保存意见','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','004','회송의견','1','회송의견','Returning','返送','退回意见','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','005','지시사항','1','지시사항','Instructions','指示','说明','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','006','메모','1','메모','Memo','メモ','备忘录','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A17','008','재배부요청','1','재배부요청','재배부요청','재배부요청','재배부요청','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A18','0  ','결재날짜순서','1','리스트ORDERBY','Approval date order','결재날짜순서','결재날짜순서','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A18','001','DESC','1','결재문서(ASC,DESC)','DESC','DESC','DESC','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A18','002','DESC','1','문서함(ASC,DESC)','DESC','DESC','DESC','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A19','0  ','첨부공유유무','0','첨부공유유무확인','Share attachment Y/n','첨부공유유무','첨부공유유무','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A19','001','0','1','0 : 별도, 1: 공유','0','0','0','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A20','0  ','첨부/의견 display','1','첨부/의견 유무Dispaly','Display attachment/comment','첨부/의견 display','첨부/의견 display','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A20','001','Y','1','유','Y','Y','Y','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A20','002','N','1','무','N','N','N','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','000','확장기능사용유무','0',null,'Use expanded function Y/n','확장기능사용유무','확장기능사용유무','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','001','보안등급','1',null,'Security level','보안등급','보안등급','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','002','보존기간','0',null,'Archive term','보존기간','보존기간','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','003','키워드','0',null,'Keyword','키워드','키워드','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','004','0','1','공개여부. 0:사용안함, 1: 사용','0','0','0','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A22','005','결재선포함','1','보안등급쿼리시 결재선에 있는 사람은 보안등급 무시 여부(1 : 무시. 2 : 보안등급이 우선함)','Include approval line','결재선포함','결재선포함','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A23','000','대리결재유무','0','대리결재유무','Arbitrary approval Y/n','대리결재유무','대리결재유무','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A23','001','대리결재','1','0:사용X, 1:사용O','Arbitrary approval','대리결재','대리결재','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A24','0  ','문서보기 기한 설정',null,null,'Set doc. open term','문서보기 기한 설정','문서보기 기한 설정','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','0  ','문서종류','0','문서종류','문서종류',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','001','시행문','1','기안문','Enforcement','施行文','执行文件','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('A01','002','내부결재','1','보고문','Inner Approval','報告文','报告书','Top',@tenant_id_value);

-- approvalS 필요한것만 간추려야함
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','0','문서종류','0','문서종류(DocType)','문서종류',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','001','기안문','1','기안문','Approval','起案文','起案文','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','002','보고문','1','보고문','Report','報告文','报告书','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','003','수신문','1','수신문','Received','受信文','收件文','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','004','시행문','1','시행문','Enforcement','施行文','执行文件','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','005','부서합의','0','기안문','agreement','起案文','起案文','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','006','감사문서','0','감사','Inspect','監査','审查','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','007','신청문서','0','신청','application','申請','申请','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','008','대외문서접수','0','대외접수','Receive outside','対外受付','对外接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA01','009','대외문서발송','0','대외발송','Send outside','対外送信','对外发送','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','0  ','결재방법','0','결재방법','결재방법',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','001','결재','1','일반','Approval','決裁','审批','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','002','확인','1','확인','Confirmation','確認','確認','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','003','결재안함','0','결재안함','Skip-approval','決裁しない','不审批','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','004','전결','1','전결','Pre-approval','専決','先决','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','005','준법감시','0','감사','Audit','遵法監視','监督','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','006','발송의뢰','0','심사','Request Sending','審査','审查','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','007','참조','1','참조','Reference','参照','抄送','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','008','개인순차합의','1','개인순차협조','Agreement(personal)','個人順次合意','个人顺序协议','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','009','개인병렬합의','1','개인병렬협조','Parallel agreement(personal)','個人並列合意','个人并行协议','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','011','부서순차합의','1','부서순차협조','Sequential agreement(dept.)','部署順次合意','顺序协议(部门)','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','012','부서병렬합의','1','부서병렬협조','Parallel agreement(dept.)','部署並列合意','并行的协议(部门)','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','013','사전감사','0','감사','Pre-audit','監査','审查','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','014','수신','0','제일제당수신','Receipt','受信','收件','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','015','회람','0','회람','Circular reference','回覧','传阅','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','016','대결','0','대결','Deputy','代決','待决','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','018','기안','0','기안','Draft','起案','起草','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','019','검토','0','검토','Examination','検討','评论','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA03','040','후결','0','후결','After-approval','後決','후결','Top',@tenant_id_value);

INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '0  ', '사인종류', 'Sign type', '사인종류', '사인종류', '1', '사인종류', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '001', 'PIC', 'PIC', 'PIC', 'PIC', '1', '일반결재', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '002', 'PIC', 'PIC', 'PIC', 'PIC', '1', '개인순차협조', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '003', 'PIC', 'PIC', 'PIC', 'PIC', '1', '개인병렬협조', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '004', 'NAME', 'NAME', 'NAME', 'NAME', '1', '부서순차협조', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '005', 'NAME', 'NAME', 'NAME', 'NAME', '1', '부서병렬협조', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '006', 'PIC', 'PIC', 'PIC', 'PIC', '1', '공람', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '007', NULL, NULL, NULL, NULL, '1', '전결', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '008', NULL, NULL, NULL, NULL, '0', '대결', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA05', '009', 'DNAME', 'DNAME', 'DNAME', 'DNAME', '0', '후결', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA13', '0  ', '결재TYPE', 'Approval Type', '결재TYPE', '결재TYPE', '1', '결재형식', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA13', '001', '1', '1', '1', '1', '0', '사용자와부서분리', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA13', '002', '2', '2', '2', '2', '1', '사용자와부서가 통합', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA15', '0  ', 'UI폼형식처리', 'UI Form format', 'UI폼형식처리', 'UI폼형식처리', '1', 'UI폼형식처리', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA15', '001', 'yyyy.mm.dd hh:mm', 'yyyy.mm.dd hh:mm', 'yyyy.mm.dd hh:mm', 'yyyy.mm.dd hh:mm', '1', '년-월-일', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA15', '002', '.', '.', '.', '.', '1', '사인일자 형식', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '0  ', '의견종류', 'Comment type', '의견종류', '의견종류', '1', '의견종류', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '001', '일반의견', 'General', '일반의견', '일반의견', '1', '일반의견', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '002', '반송의견', 'Rejection', '반송의견', '반송의견', '1', '반송의견', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '003', '보류의견', 'Holding', '보류의견', '보류의견', '1', '보류의견', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA17', '004', '회송의견', 'Returning', '회송의견', '회송의견', '1', '회송의견', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA18', '0  ', '결재날짜순서', 'Approval date order', '결재날짜순서', '결재날짜순서', '1', '리스트ORDERBY', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA18', '001', 'DESC', 'DESC', 'DESC', 'DESC', '1', '결재문서(ASC,DESC)', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA18', '002', 'DESC', 'DESC', 'DESC', 'DESC', '1', '문서함(ASC,DESC)', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA19', '0  ', '첨부공유유무', 'Share attachment Y/n', '첨부공유유무', '첨부공유유무', '0', '첨부공유유무확인', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA19', '001', '0', '0', '0', '0', '1', '0 : 별도, 1: 공유', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA20', '0  ', '첨부/의견 display', 'Display attachment/comment', '첨부/의견 display', '첨부/의견 display', '1', '첨부/의견 유무Dispaly', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA20', '001', 'Y', 'Y', 'Y', 'Y', '1', '유', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA20', '002', 'N', 'N', 'N', 'N', '1', '무', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '0  ', '확장기능사용유무', 'Use explanded function Y/n', '확장기능사용유무', '확장기능사용유무', '0', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '001', '보안등급', 'Security level', '보안등급', '보안등급', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '002', '보존기간', 'Archive term', '보존기간', '보존기간', '0', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '003', '키워드', 'Keyword', '키워드', '키워드', '0', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '004', '1', '1', '1', '1', '1', '공개여부. 0:사용안함, 1: 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA22', '005', '결재선포함', 'Include approval line', '결재선포함', '결재선포함', '1', '보안등급쿼리시 결재선에 있는 사람은 보안등급 무시 여부(1 : 무시. 2 : 보안등급이 우선함)', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA23', '0  ', '대리결재유무', 'Arbitrary approval Y/n', '대리결재유무', '대리결재유무', '0', '대리결재유무', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA23', '001', '대리결재', 'Arbitrary approval', '대리결재', '대리결재', '1', '0:사용X, 1:사용O', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA24', '0  ', '문서보기 기한 설정', 'Set doc. open term', '문서보기 기한 설정', '문서보기 기한 설정', ' ', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA24', '001', NULL, '0', '0', '0', '1', '문서보기를 위한 기한을 설정.', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA25', '0  ', '회송처리', 'Returning', '회송처리', '회송처리', '1', '0:원기안부서, 1:이전 수신부서, 2:원기안부서회송하고, 재기안모드로 변신~ ^^;', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA25', '001', '2', '2', '2', '2', '1', '구분', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA25', '002', 'Y', 'Y', 'Y', 'Y', '1', '반송시 자동으로 반송함에 등록을 하는지 여부. (회송이 아니라 반송임!) Y면 동작', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA25', '003', 'Y', 'Y', 'Y', 'Y', '1', '감사 회송시 감사함에 회송문서를 남기는지 여부. Y면 남긴다.', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA26', '0  ', '대리결재사인헤드', 'Arbitrary sign head', '대리결재사인헤드', '대리결재사인헤드', '1', '대리결재사인헤드', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA26', '001', '代', '代', '代', '代', '1', '대리결재사인헤드', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA27', '0  ', '수신처구분', 'Receiver', '수신처구분', '수신처구분', '1', '0:부서,1:부서/사람', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA27', '001', '부서', 'Dept', '부서', '부서', '1', '부서', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA27', '002', '부서/사람', 'Dept/Personnel', '부서/사람', '부서/사람', '0', '부서/사람', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA28', '0  ', '조직도구분', 'Organ type', '조직도구분', '조직도구분', '0', '조직도 구분', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA28', '001', '1', '1', '1', '1', '1', '조직도 직위', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA28', '002', '2', '2', '2', '2', '0', '조직도 직책', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA28', '003', '3', '3', '3', '3', '0', '조직도 직위/직책', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA29', '0  ', '개인수신처', 'Personal receiver', '개인수신처', '개인수신처', '0', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA29', '001', '개인수신처구분', 'Personal receiver type', '개인수신처구분', '개인수신처구분', '0', '1:수신처리기, 0:결재진행관리기', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA30', '0  ', '문서채번룰', 'Doc. numbering rule', '문서채번룰', '문서채번룰', '1', '문서채번시 적용되는 룰 정의', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA30', '001', '10S', '10S', '10S', '10S', '1', 'x1 - 채번범위 (0:전체, 1:부서별, 2:양시함별) x2 - 분류기호 사용여부(0:사용안함, 1:사용함) x3 - 초기화 시점 (N: 초기화안함, M: 월별, Y:년별)', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA30', '002', '0', '0', '0', '0', '1', '문서번호 FORMAT', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA30', '003', '1', '1', '1', '1', '1', 'S일때 리프레쉬달', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA31', '0  ', '결재처리제한', 'Restrict approval', '결재처리제한', '결재처리제한', '0', '결재처리 되지 않는 문서리스트 제한', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA31', '001', '3', '3', '3', '3', '0', 'N일 이상 지체되는 결재문서', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA32', '0  ', '전결처리방법', 'Arbitrary decision', '전결처리방법', '전결처리방법', '0', '전결처리방법 정의', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA32', '001', '100', '100', '100', '100', '1', 'x1 - 전결자 (0:사인, 1:전결표시)x2 - 전결이후 결재자(0:표시안함, 1: 전결표시)x3 - 최종결재자(0:사인, 1:전결표시)', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA33', '0  ', '결재칸Split 유무', '결재칸Split 유무', 'Sign box split Y/n', '결재칸Split 유무', '0', '결재한 Split  유무확인', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA33', '001', 'Y', 'Y', 'Y', 'Y', '1', '사용유무', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA33', '002', 'FIX', 'FIX', 'FIX', 'FIX', '1', 'FIX : 칸고정, DIV : 칸나눔으로 처리', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA34', '0  ', '문서링크', 'Doc. link', '문서링크', '문서링크', '0', '합의/감사 문서 Link', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA34', '001', '9', '9', '9', '9', '1', '0:사용안함,1:합의,2:감사,9:전체적용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA34', '002', '2004000004;2004000006;2004000005', '2004000004;2004000006;2004000005', '2004000004;2004000006;2004000005', '2004000004;2004000006;2004000005', '1', '감사시에변환안하는양식아이디(;로구분)', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA35', '0  ', '수신함보내기', 'Send to receiving box', '수신함보내기', '수신함보내기', '0', '수신함으로 바로 보내기', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA35', '001', '0', '0', '0', '0', '1', '0:사용안함,1:사용함', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA36', '0  ', '변환문서', '변환문서E', '변환문서', '변환문서', '0', '변환문서URL', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA36', '001', '/upload_approval/S907000/form/2016000068.mht', '/upload_approval/S907000/form/2016000068.mht', '/upload_approval/S907000/form/2016000068.mht', '/upload_approval/S907000/form/2016000068.mht', '1', '합의문서', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA36', '002', '/upload_approval/S907000/form/2003000008.mht', '/upload_approval/S907000/form/2003000008.mht', '/upload_approval/S907000/form/2003000008.mht', '/upload_approval/S907000/form/2003000008.mht', '1', '감사문서', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA37', '0  ', '그룹사용', '그룹사용E', '그룹사용', '그룹사용', '0', '참조그룹사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA37', '001', 'junsig', 'junsig', 'junsig', 'junsig', '1', '사인ID 값. null 값이면 사용안함', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA38', '0  ', '특정인 결재처리', 'Sign on specific person', '특정인 결재처리', '특정인 결재처리', '0', '특정인에 대한 결재 사인처리를 한다.', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA38', '001', '1', '1', '1', '1', '1', '참조사용유무 0:사용안함,1:사용함', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA39', '0  ', '첨부문서Filter', 'Attachment filter', '첨부문서Filter', '첨부문서Filter', ' ', '첨부할 문서 종류를 제한한다.', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA39', '001', 'NONE', 'NONE', 'NONE', 'NONE', '1', 'NONE(대문자) : 사용안함 , ;로 구분한다.', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA39', '002', '50', '50', '50', '50', '1', '단위:메가', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA40', '0  ', '감사부서정의', 'Define audit dept.', '감사부서정의', '감사부서정의', '0', '감사부서 정의', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA40', '001', 'sb', 'sb', 'sb', 'sb', '1', '20630감사부서ID 리스트, 부서1;부서2;부서3;..부서', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA43', '0  ', '노티유무', 'Notify Y/n', '노티유무', '노티유무', '0', '노티유무', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA43', '001', 'Y', 'Y', 'Y', 'Y', '1', 'N:사용안함,Y:사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA44', '0  ', '최근결재선정보', 'Last approval line', '최근결재선정보', '최근결재선정보', '1', '최근 결재선 정보 사용유무', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA44', '001', '1', '1', '1', '1', '1', '결재선 : 0:사용안함,1:사용함', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA44', '002', '1', '1', '1', '1', '1', '수신처 : 0:사용안함,1:사용함', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA45', '0  ', '문서바로발송', 'Send immediately', '문서바로발송', '문서바로발송', '0', '문서바로발송여부', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA45', '001', '기안문-품의시', 'After consultation', '기안문-품의시', '기안문-품의시', '1', '0 : 바로 발송. 1 - 바로발송아님. 시행문변환해야함.', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '0  ', '보안등급정의', 'Set security level', '보안등급정의', '보안등급정의', '0', '보안등급정의', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '001', '1;1등급;100', '1;Level 1;100', '1;1等級;100', '1;1等級;100', '1', '임시;이름;코드', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '002', '1;2등급;200', '1;Level 2;200', '1;2等級;200', '1;2等級;200', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '003', '1;3등급;300', '1;Level 3;300', '1;3等級;300', '1;3等級;300', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '004', '1;4등급;400', '1;Level 4;400', '1;4等級;400', '1;4等級;400', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA51', '005', '1;5등급;500', '1;Level 5;500', '1;5等級;500', '1;5等級;500', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '0  ', '보존년한정의', NULL, NULL, NULL, '0', '보존연한정의', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '001', '1;1년;1', '1;1 year;1', '1;1年;1', '1;1年;1', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '002', '1;2년;2', '1;2 year;2', '1;2年;2', '1;2年;2', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '003', '1;3년;3', '1;3 year;3', '1;3年;3', '1;3年;3', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '004', '1;5년;5', '1;5 year;5', '1;5年;5', '1;5年;5', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '005', '1;10년;10', '1;10 year;10', '1;10年;10', '1;10年;10', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '006', '1;준영구;100', '1;Semi-permanence;100', '1;準永久;100', '1;准永久;100', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA52', '007', '1;영구;1000', '1;Permanence;1000', '1;永久;1000', '1;永久;1000', '1', NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA53', '0  ', '수신처그룹기호', 'Receiver group symbol', '수신처그룹기호', '수신처그룹기호', '0', '수신처그룹구분기호 정의', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA53', '001', 'SG_', 'SG_', 'SG_', 'SG_', '1', '수신처 그룹 앞부분에 사용할 필드명. COM에서 사용. 스크립트 부분 동기화 필요', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA53', '002', 'Y', 'Y', 'Y', 'Y', '1', '수신처 그룹 확장(수신처 저장시 확장여부). Y는 사용. N은 사용안함', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '0  ', '특별문서함구분', 'Special folder type', '특별문서함구분', '특별문서함구분', '0', '특별문서함구분코드입니다.', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '001', '결재할문서', 'To be process', '決裁する文書', '批准文件', '1', '결재할문서', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '002', '기안한문서', 'Proposed', '決裁済み', '草案文件', '1', '기안한문서', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '003', '결재진행문서', 'In progress', '決裁進捗文書', '批准执行文件', '1', '결재진행문서', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '004', '부서수신함', 'Dept. receipt folder', '部署受信フォルダ', '部门收信箱', '1', '부서수신함', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SA60', '005', '심사할문서', 'To be inspect', '審査する文書', '审查文件', '1', '심사할문서', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SF01', '0  ', '플로우', 'Flow', '플로우', '플로우', '0', '플로우관련 업무 정의', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SF01', '001', 'Y', 'Y', 'Y', 'Y', '1', '수발신문을 발신함으로 보낸다.', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SF01', '002', 'O', 'O', 'O', 'O', '1', 'D:DSN연결;O:OleDB 연결', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL01', '0  ', '다국어처리', 'Multi-lang.', '다국어처리', '다국어처리', '0', '다국어코드값', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL01', '001', '파일', 'File', 'ファイル', '文件夹', '1', 'file', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL01', '002', '문서', 'Document', '文書', '文件', '1', 'document', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL02', '001', '문서함명', 'Doc. folder name', '文書フォルダ名', '文件夹名', '1', '문서함-GetUseContInfo()', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL03', '001', '개인문서함', 'Personal doc. folder', '個人文書フォルダ', '个人文件夹', '1', '개인문서함-GetUserContTree()', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL03', '002', '문서함명', 'Dept. doc. folder', '文書フォルダ名', '文件夹名', '1', '부서문서함-GetDeptContTree()', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL04', '001', '부서명', 'Dept. name', '部署名', '部门名', '1', '부서명-GetContUseDeptInfo()', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '001', '코드', 'Code', 'コード', '代码', '1', 'GetItemCode_Item()', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '002', '기능명칭', 'Name', '機能名称', '功能名称', '1', 'GetItemCode_Item()', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '003', '보존기간', 'Keeping period', '保存期間', '保留时间', '1', 'GetItemCode_Item()', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '004', '보안등급', 'Security level', '保安等級', '安全级别', '1', 'GetItemCode_Item()', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL05', '005', '공개여부', 'Public', '公開可否', '是否共享', '1', 'GetItemCode_Item()', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '001', '결재문서', 'Approval doc.', '決済文書', '결재문서', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '002', '문서도착', 'Doc. arrival', '文書到着', '문서도착', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '003', '문서완료', 'Finish doc.', '決済完了文書', '문서완료', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '004', '문서반송', 'Reject doc.', '文書搬送', '문서반송', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '005', '문서보류', 'Hold doc.', '文書保留', '문서보류', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '006', '문서발송', 'Send doc.', '文書送信', '문서발송', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '007', '수신문서', 'Receiving doc.', '受信文書', '수신문서', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '008', '지정문서', 'Designated doc.', '指定文書', '지정문서', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '009', '회송문서', 'Returned doc.', '返送文書', '회송문서', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '010', '문서회수', 'Withdraw doc.', '文書引き戻し', '문서회수', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('SL06', '011', '결재노티', 'Notify approval', '決済完了通知', '결재노티', '1', '결재알림시 사용', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('ST01', '0  ', '재기안 의견유무', 'Re-draft comment Y/n', '재기안 의견유무', '재기안 의견유무', '1', '재기안시 반송의견 삭제 유/무( Y : 삭제 or N : 삭제안함 )', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1, CODE2, NAME, NAME2, NAME3, NAME4, ISUSE, DESCRIPT, COMPANYID, TENANT_ID) VALUES ('ST01', '001', 'N', 'N', 'N', 'N', '1', '재기안시 반송의견 삭제 유/무( Y : 삭제 or N : 삭제안함 )', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '0', 	'0',	'문서상태(DocState)',	'문서상태','Doc. status','文書区分','文書区分',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '001',	'1',	'품의',			'품의',	'Draft',	'稟議',	'评价',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '002',	'1',	'협조',			'협조',	'Agreement(personal)',	'協力',	'合作',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '003',	'0',	'감사',			'준법감시',	'Audit',	'遵法監視',	'监督',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '004',	'1',	'심사',			'심사',	'Request send',	'審査',	'심사_ZH',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '011',	'1',	'수신',			'수신',	'Receipt',	'受信',	'收件',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '012',	'1',	'협조/합의',	'합의',	'Draft',	'合意',	'합의_ZH',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '013',	'0',	'시행',			'시행',	'Enforcement',	'施行',	'执行',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '014',	'0',	'감사(검사부)',	'감사',	'Audit(dept.)',	'監査',	'审查',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '015',	'0',	'공람',			'공람',	'Display',	'回覧',	'传阅',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '016',	'0',	'회람',			'회람',	'Circular',	'回覧',	'传阅',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '017',	'0',	'참조',			'참조',	'Reference',	'参照',	'抄送',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '018',	'0',	'사후감사',		'사후공람',	'Public viewing(After-approval)',	'事後供覧',	'事后共览',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '019',	'1',	'발송',		'발송',	'Sending',	'送信',	'发送',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '020',	'0',	'신청',		'시행',	'Application',	'施行',	'执行',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '022',	'0',	'대외문서접수','대외접수',	'Receipt(outside)',	'対外受付',	'对外接收', 'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '023',	'0',	'대외문서발송','대외발송',	'Sending(outside)',	'対外送信',	'对外发送',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '024',	'1',	'수신배부',		'배부',	'Distributed',	'転送',		'发行',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '031',	'0',	'반송',			'반송',	'Rejection',	'差し戻し',	'退回',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,ISUSE,DESCRIPT,NAME,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA02', '032',	'0',	'회송',			'회송',	'Returning',	'返送',	'退回',	'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','0  ','결재처리상태','0','결재처리상태','결재처리상태',null,null,'Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','000','미결','1','기안처리하지 않은 문서','Not approved','未決','未決','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','001','대기','1','대기','Waiting','待機','待机','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','002','진행','1','진행','In progress','進行中','进行中','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','003','승인','1','승인','Approved','決裁','审批','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','004','반송','1','반송','Rejected','差し戻し','退回','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','005','보류','1','보류','Hold','保留','保存','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','006','회수','1','회수','Withdrew','引き戻し','回收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','010','완료','1','완료','Completed','完了','完成','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','011','도착','1','도착','Arrived','到着','到达','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','012','지정','1','지정','Designated','指定','未接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','013','접수','1','접수','Received','受付','接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','014','배부','1','배부','Distributed','転送','发行','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','015','회송','1','회송','Returned','返送','退回','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','016','접수','1','수신진행','Received','受信進行','进行接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','017','수신완료','1','수신완료','Completed(receipt)','受信完了','接收完成','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','018','발신','1','수신부서미접수','Sending','未受付','未接收','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','019','전송실패','1','전송실패','Sending failure','送信エラー','传输失败','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','020','수신','1','전송성공','Receipt','受信','接待','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','021','도달','1','도달(G중계)','Arrived','到達','到达','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('SA04','022','재요청','1','재발신요청','ReRequest','ジェヨチョン','再生','Top',@tenant_id_value);

-- G
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',1,'제목',400,null,'DocTitle',null,null,'서버저장문서','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',2,'기안부서',120,null,'WriterDeptName',null,null,'기안부서','기안부서','Dept.(draft)','起案部署','傳出部門委託','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',3,'기안자',100,null,'WriterName',null,null,'기안자','기안자','Drafter','起案者','傳出贊助商','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',4,'저장일시',100,null,'StartDate',null,null,'저장일시','저장일시','Save Date','保存日時','保存日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',5,'양식명',100,null,'FormName',null,null,'양식명','양식명','Form title','様式名','样式名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',6,'첨부',30,null,'HASATTACHYN',null,null,'서버저장문서','첨부','Attach','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',7,'공개',30,null,'ISPUBLIC',null,null,'서버저장문서','공개','Public','公開','公开','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',1,'순번',35,'TBL_APRLINEINFO','AprMemberSN',null,null,'결재선정보(진행)','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',2,'성명',120,'TBL_APRLINEINFO','AprMemberName',null,null,'결재선정보(진행)','성명','Name','氏名','姓名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',3,'직위',100,'TBL_APRLINEINFO','AprMemberJobTitle',null,null,'결재선정보(진행)','직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',4,'부서',130,'TBL_APRLINEINFO','AprMemberDeptName',null,null,'결재선정보(진행)','부서명','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',5,'결재유형',100,'TBL_APRLINEINFO','AprType',null,null,'결재선정보(진행)','결재방법','Type','処理類型','批准类型','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',6,'결재상태',80,'TBL_APRLINEINFO','AprState',null,null,'결재선정보(진행)','결재상태','Status','ステータス','批准状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('011',7,'결재일시',130,'TBL_APRLINEINFO','ProcessDate',null,null,'결재선정보(진행)','결재일시','Date','処理日時','批准日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',1,'순번',35,'TBL_ENDAPRLINEINFO','AprMemberSN',null,null,'결재선정보(완료)','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',2,'성명',100,'TBL_ENDAPRLINEINFO','AprMemberName',null,null,'결재선정보(완료)','성명','Name','氏名','姓名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',3,'직위',100,'TBL_ENDAPRLINEINFO','AprMemberJobTitle',null,null,'결재선정보(완료)','직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',4,'부서',120,'TBL_ENDAPRLINEINFO','AprMemberDeptName',null,null,'결재선정보(완료)','부서명','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',5,'결재유형',120,'TBL_ENDAPRLINEINFO','AprType',null,null,'결재선정보(완료)','결재방법','Type','処理類型','批准类型','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',6,'결재상태',70,'TBL_ENDAPRLINEINFO','AprState',null,null,'결재선정보(완료)','결재상태','Status','ステータス','批准状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',7,'결재일시',150,'TBL_ENDAPRLINEINFO','ProcessDate',null,null,'결재선정보(완료)','결재일시','Date','処理日時','批准日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',8,'대리자',110,'TBL_EXPENDAPRLINE','proxyusername',null,null,'결재선정보(완료)','대리결재자이름','Deputy','代理者','代理者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',9,'대리자직위',100,'TBL_EXPENDAPRLINE','proxyuserjobtitle',null,null,'결재선정보(완료)','대리결재자직위','Title(deputy)','代理者の役職','代理者职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',10,'대리자부서',120,'TBL_EXPENDAPRLINE','proxyuserdeptname',null,null,'결재선정보(완료)','대리결재자부서','Dept.(deputy)','代理者の部署','代理者部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',1,'순번',35,'TBL_APRLINEINFO','AprMemberSN',null,null,'결재선정보(코딩)','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',2,'성명',120,'TBL_APRLINEINFO','AprMemberName',null,null,'결재선정보(코딩)','성명','Name','氏名','姓名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',3,'직위',50,'TBL_APRLINEINFO','AprMemberJobTitle',null,null,'결재선정보(코딩)','직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',4,'부서',130,'TBL_APRLINEINFO','AprMemberDeptName',null,null,'결재선정보(코딩)','부서명','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',5,'결재유형',120,'TBL_APRLINEINFO','AprType',null,null,'결재선정보(코딩)','결재방법','Type','処理類型','批准类型','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',6,'결재상태',70,'TBL_APRLINEINFO','AprState',null,null,'결재선정보(코딩)','결재상태','Status','ステータス','批准状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('013',7,'결재일시',140,'TBL_APRLINEINFO','ProcessDate',null,null,'결재선정보(코딩)','결재일시','Date','処理日時','批准日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('014',1,'순번',35,'TBL_APRLINEINFO','AprMemberSN',null,null,'결재선정보(공람)','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('014',2,'성명',100,'TBL_APRLINEINFO','AprMemberName',null,null,'결재선정보(공람)','성명','Name','氏名','姓名', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('014',3,'직위',100,'TBL_APRLINEINFO','AprMemberJobTitle',null,null,'결재선정보(공람)','직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('014',4,'부서',300,'TBL_APRLINEINFO','AprMemberDeptName',null,null,'결재선정보(공람)','부서명','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('014',5,'공람일시',300,'TBL_APRLINEINFO','ProcessDate',null,null,'결재선정보(공람)','공람일시','Date','供覧日時','供览日时','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('015',1,'순번',35,'TBL_APRLINEINFO','AprMemberSN',null,null,'결재선정보(공람)','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('015',2,'성명',100,'TBL_APRLINEINFO','AprMemberName',null,null,'결재선정보(공람)','성명','Name','氏名','姓名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('015',3,'직위',100,'TBL_APRLINEINFO','AprMemberJobTitle',null,null,'결재선정보(공람)','직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('015',4,'부서',300,'TBL_APRLINEINFO','AprMemberDeptName',null,null,'결재선정보(공람)','부서명','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) VALUES ('015',5,'공람일시',300,'TBL_APRLINEINFO','ProcessDate',null,null,'결재선정보(공람)','공람일시','Date','供覧日時','供览日时','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',1,'순번',35,'TBL_RECEIPTPOINTINFO','DeptMemberSN',null,null,'수신처정보(진행)','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',2,'수신자명',200,'TBL_RECEIPTPOINTINFO','ReceiptPointName',null,null,'수신처정보(진행)','수신부서명','Dept.','受信部署名','收信部门名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',3,'수신자성명',200,'TBL_RECEIPTPOINTINFO','ReceiptMemberName',null,null,'수신처정보(진행)','수신자성명','Name','受信者氏名','收信创建名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',4,'승인상태',100,'TBL_RECEIPTPOINTINFO','ProcessYN',null,null,'수신처정보(진행)','처리여부','Status','ステータス','承认状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('021',5,'승인일자',180,'TBL_RECEIPTPOINTINFO','ProcessDate',null,null,'수신처정보(진행)','처리일자','Date','処理日時','承认日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',1,'순번',35,'TBL_ENDRECEIPTPOINTINFO','DeptMemberSN',null,null,'수신처정보(완료)','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',2,'수신자명',200,'TBL_ENDRECEIPTPOINTINFO','ReceiptPointName',null,null,'수신처정보(완료)','수신부서명','Dept.','受信部署名','收信部门名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',3,'수신자성명',200,'TBL_ENDRECEIPTPOINTINFO','ReceiptMemberName',null,null,'수신처정보(완료)','수신자성명','Name','受信者氏名','收信创建名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',4,'승인상태',100,'TBL_ENDRECEIPTPOINTINFO','ProcessYN',null,null,'수신처정보(완료)','처리여부','Status','ステータス','承认状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('022',5,'승인일자',180,'TBL_ENDRECEIPTPOINTINFO','ProcessDate',null,null,'수신처정보(완료)','처리일자','Date','処理日時','承认日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('023',1,'순번',35,'TBL_RECEIPTPOINTINFO','DeptMemberSN',null,null,'수신처정보(코딩)','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('023',2,'수신자명',200,'TBL_RECEIPTPOINTINFO','ReceiptPointName',null,null,'수신처정보(코딩)','수신부서명','Dept','受信部署名','收信部门名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('024',1,'순번',35,'TBL_RECEIPTPOINTINFO','DeptMemberSN',null,null,'수신처정보(재발송)','순번','SN','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('024',2,'수신자명',200,'TBL_RECEIPTPOINTINFO','ReceiptPointName',null,null,'수신처정보(재발송)','수신부서명','Dept.','受信部署名','收信部门名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('024',3,'발송상태',100,'TBL_RECEIPTPOINTINFO','ProcessYN',null,null,'수신처정보(재발송)','발송상태','ProcessYN','送信進行状況','発送進行状況','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',1,'구분',55,'TBL_APROPINIONINFO','OpinionGB',null,null,'의견정보(진행)','의견구분','Type','区分','区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',2,'성명',100,'TBL_APROPINIONINFO','UserName',null,null,'의견정보(진행)','작성자','Name','氏名','姓名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',3,'내용',300,'TBL_APROPINIONINFO','Content',null,null,'의견정보(진행)','의견내용','Content','内容','内容','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',4,'직위',100,'TBL_APROPINIONINFO','UserJobTitle',null,null,'의견정보(진행)','작성자직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('031',5,'부서',100,'TBL_APROPINIONINFO','UserDeptName',null,null,'의견정보(진행)','작성자부서명`','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',1,'구분',55,'TBL_ENDAPROPINIONINFO','OpinionGB',null,null,'의견정보(완료)','의견구분','Type','区分','区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',2,'성명',100,'TBL_ENDAPROPINIONINFO','UserName',null,null,'의견정보(완료)','작성자','Name','氏名','姓名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',3,'내용',300,'TBL_ENDAPROPINIONINFO','Content',null,null,'의견정보(완료)','의견내용','Content','内容','内容','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',4,'직위',100,'TBL_ENDAPROPINIONINFO','UserJobTitle',null,null,'의견정보(완료)','작성자직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('032',5,'부서',100,'TBL_ENDAPROPINIONINFO','UserDeptName',null,null,'의견정보(완료)','작성자부서명`','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('033',1,'구분',55,'TBL_APROPINIONINFO','OpinionGB',null,null,'의견정보(진행UI)','의견구분','Type','区分','区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('033',2,'성명',100,'TBL_APROPINIONINFO','UserName',null,null,'의견정보(진행UI)','작성자','Name','氏名','姓名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('033',3,'직위',100,'TBL_APROPINIONINFO','UserJobTitle',null,null,'의견정보(진행UI)','작성자직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('033',4,'부서',100,'TBL_APROPINIONINFO','UserDeptName',null,null,'의견정보(진행UI)','작성자부서명`','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('034',1,'구분',55,'TBL_ENDAPROPINIONINFO','OpinionGB',null,null,'의견정보(완료UI)','의견구분','Type','区分','区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('034',2,'성명',100,'TBL_ENDAPROPINIONINFO','UserName',null,null,'의견정보(완료UI)','작성자','Name','氏名','姓名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('034',3,'직위',100,'TBL_ENDAPROPINIONINFO','UserJobTitle',null,null,'의견정보(완료UI)','작성자직위','Title','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('034',4,'부서',100,'TBL_ENDAPROPINIONINFO','UserDeptName',null,null,'의견정보(완료UI)','작성자부서명`','Dept.','部署','部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('041',1,'첨부자',80,'TBL_APRATTACHINFO','AttachUserName',null,null,'첨부파일정보(진행UI)','첨부자명','User','添付者','附件者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('041',2,'파일이름',250,'TBL_APRATTACHINFO','DisplayName',null,null,'첨부파일정보(진행UI)','디스플래이명','Filename','ファイル名','文件名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('041',3,'파일크기',100,'TBL_APRATTACHINFO','AttachFileSize',null,null,'첨부파일정보(진행UI)','파일크기','Size','ファイルサイズ','文件大小','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('041',4,'쪽수',40,'TBL_APRATTACHINFO','PageNum',null,null,'첨부파일정보(진행UI)','쪽수','PageNum','ページ数','頁數','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('042',1,'문서명',300,'TBL_APRDOCATTACHINFO','AttachDocName',null,null,'첨부문서정보(진행UI)','문서명','Form title','文書名','文件名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('043',1,'구분',35,null,'AttachType',null,null,'첨부정보','구분','Type','区分','区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('043',2,'첨부이름',200,null,'AttachName',null,null,'첨부정보','첨부이름','Filename','添付名','附件名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('043',3,'첨부자',100,null,'AttachUserName',null,null,'첨부정보','첨부자명','User','添付者','附件者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('043',4,'첨부자부서명',100,null,'AttachUserDeptName',null,null,'첨부정보','첨부자부서명','Dept.','添付者部署名','附件者部门名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',1,'문서번호',150,'TBL_ENDAPRDOCINFO','DocNo',null,null,'개인문서함리스트','문서번호','Doc. No.','文書番号','文件号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',2,'제목',350,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'개인문서함리스트','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',3,'기안자',100,'TBL_ENDAPRDOCINFO','WriterName',null,null,'개인문서함리스트','기안자이름','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',4,'완료일시',100,'TBL_ENDAPRDOCINFO','EndDate',null,null,'개인문서함리스트','완료일시','Date completed','完了日時','结束日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',5,'문서명',160,'TBL_ENDAPRDOCINFO','FormName',null,null,'개인문서함리스트','양식이름','Form title','文書名','文件名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('051',6,'등록일자',100,'TBL_USERCONTLIST','LinkDate',null,null,'개인문서함리스트','등록일자','Date registered','登録日時','注册日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',1,'문서번호',150,'TBL_ENDAPRDOCINFO','DocNo',null,null,'부서문서함리스트','문서번호','Doc. No.','文書番号','文件号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',2,'제목',350,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'부서문서함리스트','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',3,'기안자',100,'TBL_ENDAPRDOCINFO','WriterName',null,'null','부서문서함리스트','기안자이름','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',4,'완료일시',100,'TBL_ENDAPRDOCINFO','EndDate',null,null,'부서문서함리스트','완료일시','Date completed','完了日時','结束日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',5,'문서명',160,'TBL_ENDAPRDOCINFO','FormName',null,null,'부서문서함리스트','양식이름','Form title','文書名','文件名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('052',6,'등록일자',100,'TBL_DEPTCONTLIST','LinkDate',null,null,'부서문서함리스트','등록일자','Date registered','登録日時','注册日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',1,'변경내용',60,'TBL_HISTORYATTACHINFO','ModifyFlag',null,null,'첨부파일이력리스트','변경내용','Content','変更内容','变更内容','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',2,'첨부이름',200,'TBL_HISTORYATTACHINFO','AttachFileDisplayName',null,null,'첨부파일이력리스트','첨부이름','Filename','添付名','附件名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',3,'첨부사이즈',80,'TBL_HISTORYATTACHINFO','AttachFileSize',null,null,'첨부파일이력리스트','첨부사이즈','Size','添付サイズ','附件大小','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',4,'변경일자',120,'TBL_HISTORYATTACHINFO','ModifyDate',null,null,'첨부파일이력리스트','변경일자','Date','変更日時','变更日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',5,'변경자',80,'TBL_HISTORYATTACHINFO','AttachUserName',null,null,'첨부파일이력리스트','변경자','User','変更者','変更者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('061',6,'페이지',40,'TBL_HISTORYATTACHINFO','PageNum',null,null,'첨부파일이력리스트','페이지','PageNum','ページ','頁','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',1,'변경순번',60,'TBL_HISTORYLINEINFO','ModifySN',null,null,'결재선이력리스트','변경순번','No.','変更順番','变更序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',2,'변경일자',100,'TBL_HISTORYLINEINFO','ModifyDate',null,null,'결재선이력리스트','변경일자','Date','変更日時','变更日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',3,'변경자',100,'TBL_HISTORYLINEINFO','ModifyUserName',null,null,'결재선이력리스트','변경자','User','変更者','変更者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',4,'변경자직위',100,'TBL_HISTORYLINEINFO','ModifyUserJobTitle',null,null,'결재선이력리스트','변경자직위','Title','変更者役職','变更者职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('062',5,'변경자부서',100,'TBL_HISTORYLINEINFO','ModifyUserDeptName',null,null,'결재선이력리스트','변경자부서','Dept.','変更者部署','变更者部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',1,'결재순번',60,'TBL_HISTORYLINEINFO','AprMemberSN',null,null,'결재선이력상세리스트','결재순번','No.','決裁順番','批准序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',2,'결재방법',60,'TBL_HISTORYLINEINFO','AprType',null,null,'결재선이력상세리스트','결재방법','Type','決裁方法','批准方法','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',3,'결재상태',60,'TBL_HISTORYLINEINFO','AprState',null,null,'결재선이력상세리스트','결재상태','Status','ステータス','批准状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',4,'결재자이름',100,'TBL_HISTORYLINEINFO','AprMemberName',null,null,'결재선이력상세리스트','결재자이름','Name','決裁者','批准者名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',5,'결재자직위',100,'TBL_HISTORYLINEINFO','AprMemberJobTitle',null,null,'결재선이력상세리스트','결재자직위','Title','決裁者役職','批准者职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',6,'결재자부서',100,'TBL_HISTORYLINEINFO','AprMemberDeptName',null,null,'결재선이력상세리스트','결재자부서명','Dept.','決裁者部署','批准者部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',7,'보고자',50,'TBL_HISTORYLINEINFO','isBriefUserYN',null,null,'결재선이력상세리스트','보고자','Reporter','報告者','报告者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('063',8,'발의자',50,'TBL_HISTORYLINEINFO','isProposerYN',null,null,'결재선이력상세리스트','발의자','Proposer','発意者','倡议者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',1,'변경순번',60,'TBL_HISTORYDOCINFO','ChangeSN',null,null,'문서이력리스트','변경순번','No.','変更順番','变更序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',2,'변경일자',100,'TBL_HISTORYDOCINFO','ChangeDate',null,null,'문서이력리스트','변경일자','Date','変更日時','变更日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',3,'변경자이름',100,'TBL_HISTORYDOCINFO','ChangeUserName',null,null,'문서이력리스트','변경자이름','Name','変更者','变更者名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',4,'변경자직위',100,'TBL_HISTORYDOCINFO','ChangeUserJobTitle',null,null,'문서이력리스트','변경자직위','Title','変更者役職','变更者职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('064',5,'변경자부서',100,'TBL_HISTORYDOCINFO','ChangeUserDeptName',null,null,'문서이력리스트','변경자부서','Dept.','変更者部署','变更者部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',1,'순번',50,null,'DeptMemberSN',null,null,'수신처리스트','순번','SN','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',2,'수신자',100,null,'ReceiptPointName',null,null,'수신처리스트','수신부서','Dept.','受信者氏名','收信创建名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',3,'승인유무',70,null,'ProcessYN',null,null,'수신처리스트','승인유무','ProcessYN','承認の有無','立即批准','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',4,'승인일자',100,null,'ProcessDate',null,null,'수신처리스트','승인일자','ProcessDate','処理日時','承认日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('065',5,'수신자',80,null,'ReceiptMemberName',null,null,'수신처리스트','수신자','Name','受信者氏名','收信创建名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('066',1,'수신자',100,'TBL_HISTORYRECEIPTINFO','ReceiptDeptName',null,null,'수신처이력리스트','수신처','Dept.','受信者氏名','收信创建名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('066',2,'상태',80,'TBL_HISTORYRECEIPTINFO','Status',null,null,'수신처이력리스트','상태','Status','ステータス','状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('066',3,'일자',100,'TBL_HISTORYRECEIPTINFO','StatusDate',null,null,'수신처이력리스트','일자','Date','日','日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',1,'배부번호',70,'TBL_DOCDELIVERY','sn',null,null,'배부대장리스트','배부번호','SN','転送番号','分配數量','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',2,'문서번호',120,'TBL_DOCDELIVERY','DocNumber',null,null,'배부대장리스트','문서번호','Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',3,'제목',200,'TBL_DOCDELIVERY','DocTitle',null,null,'배부대장리스트','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',4,'배부일자',130,'TBL_DOCDELIVERY','ReceiptDate',null,null,'배부대장리스트','배부일자','ReceiptDate','転送日時','分派日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',5,'배부과',80,'TBL_DOCDELIVERY','Organ',null,null,'배부대장리스트','배부과','Organ','転送課','分佈及','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',6,'처리과',80,'TBL_DOCDELIVERY','ManageDept',null,null,'배부대장리스트','처리과','Manage Dept.','処理課','加工','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('067',7,'인수자',80,'TBL_DOCDELIVERY','ChargeName',null,null,'배부대장리스트','인수자','Charge Name','引受者','引受者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',1,'제목',300,'TBL_APRDOCINFO','DocTitle',null,null,'관리자 진행문서','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',2,'기안부서',135,'TBL_APRDOCINFO','WriterDeptName',null,null,'관리자 진행문서','기안부서','Dept.(draft)','起案部署','起草部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',3,'기안자',60,'TBL_APRDOCINFO','WriterName',null,null,'관리자 진행문서','기안자','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',4,'기안일시',160,'TBL_APRDOCINFO','StartDate',null,null,'관리자 진행문서','기안일시','Date(draft)','起案日時','起草日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',5,'상태',50,'TBL_APRDOCINFO','FunctionType',null,null,'관리자 진행문서','상태','Status','ステータス','状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('081',6,'양식명',160,'TBL_EXPAPRDOCINFO','FormName',null,null,'관리자 진행문서','양식명','Form title','様式名','样式名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',1,'문서번호',150,'TBL_ENDAPRDOCINFO','DocNo',null,null,'관리자 완료문서','문서번호','Doc. No.','文書番号','文件号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',2,'제목',350,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'관리자 완료문서','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',3,'기안자',100,'TBL_ENDAPRDOCINFO','WriterName',null,null,'관리자 완료문서','기안자','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',4,'기안부서',100,'TBL_ENDAPRDOCINFO','WriterDeptName',null,null,'관리자 완료문서','기안부서명','Dept.(draft)','起案部署','起草部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',5,'완료일시',160,'TBL_ENDAPRDOCINFO','EndDate',null,null,'관리자 완료문서','완료일시','Date completed','完了日時','结束日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',6,'양식명',150,'TBL_ENDAPRDOCINFO','FormName',null,null,'관리자 완료문서','양식명','Form title','様式名','样式名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('082',7,'이관',30,'TBL_EXPENDAPRDOCINFO','EDMSYN',null,'NoUse','관리자 완료문서','EDMS이관여부','Transfer','移管','移交','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('091',1,'순번',55,'TBL_ADMINRECEIPTGROUP_MAIN','MAINID',null,'NoUse','수신처그룹정보','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('091',2,'수신자그룹',250,'TBL_ADMINRECEIPTGROUP_MAIN','MAINNAME',null,null,'수신처그룹정보','수신처그룹명','Receiving Dept. Group','受信先グループ','集团电话','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('092',1,'순번',55,'TBL_ADMINRECEIPTGROUP_SUB','SUBID',null,'NoUse','수신처그룹소속부서정보','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('092',2,'부서아이디',250,'TBL_ADMINRECEIPTGROUP_SUB','DEPTID',null,'NoUse','수신처그룹소속부서정보','부서아이디','Dept. ID','部署ID','部门 ID','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('092',3,'부서명',250,'TBL_ADMINRECEIPTGROUP_SUB','DEPTNAME',null,null,'수신처그룹소속부서정보','부서명','Dept. Name','部署名','部门名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('092',4,'회사아이디',250,'TBL_ADMINRECEIPTGROUP_SUB','companyID',null,'NoUse','수신처그룹소속부서정보','회사아이디','Company ID','会社ID','公司 ID','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',1,'코드',80,'TBL_TASKCODEHISTORY','TaskCode',null,null,'단위업무이력','단위업무코드','Code','コード','线','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',2,'명칭',100,'TBL_TASKCODEHISTORY','TaskName',null,null,'단위업무이력','단위업무명','Name','名称','指定','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',3,'적용일자',150,'TBL_TASKCODEHISTORY','ApplyDate',null,null,'단위업무이력','적용일자.변경일자','ApplyDate','適用日','生效日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',4,'변경항목',120,'TBL_TASKCODEHISTORY','ChangeFactor',null,null,'단위업무이력','변경항목','ChangeFactor','変更項目','更改主题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',5,'변경전값',150,'TBL_TASKCODEHISTORY','BeforeValue',null,null,'단위업무이력','변경전 데이터','BeforeValue','変更前の値','数据前的变化。','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('093',6,'변경후값',150,'TBL_TASKCODEHISTORY','AfterValue',null,null,'단위업무이력','변경후 데이터','AfterValue','変更後の値','更改后的数据','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',1,'단위업무명',0,'TASKNAME',null,null,null,'단위업무이력관리','단위업무명','Unit task name','単位業務名','单位商业名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',2,'보존연한',0,'KEEPINGPERIOD','CODE',null,null,'단위업무이력관리','보존연한','Archiving term','保存年限','保存完好的软','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',3,'보존연한책정사유',0,'KPREASON',null,null,null,'단위업무이력관리','보존연한책정사유','Reason of archiving term','보존연한책정사유J','보존연한책정사유C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',4,'보존방법',0,'KEEPINGMETHOD','CODE',null,null,'단위업무이력관리','보존방법','Archiving way','保存方法','如何保存','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',5,'보존장소',0,'KEEPINGPLACE','CODE',null,null,'단위업무이력관리','보존장소','Storage','保存場所','保护区','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',6,'비치기록물',0,'DISPLAYRECFLAG','CODE',null,null,'단위업무이력관리','비치기록물','Collocated Records','비치기록물J','비치기록물C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',7,'비치기록물이관시기',0,'DISPLAYRECTRASTIME',null,null,null,'단위업무이력관리','비치기록물이관시기','Collocated Records Transfer Time','비치기록물이관시기J','비치기록물이관시기C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',8,'이관후예상열람빈도',0,'EXDISPLAYFREQUENCY','CODE',null,null,'단위업무이력관리','이관후예상열람빈도','Expected open frequency','이관후예상열람빈도J','이관후예상열람빈도C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',9,'특수목록위치',0,'SPECIALCATALOGFLAG','CODE',null,null,'단위업무이력관리','특수목록위치','Special list location','특수목록위치J','특수목록위치C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',10,'제1특수목록',0,'SC1',null,null,null,'단위업무이력관리','제1특수목록','1st Special lists','제1특수목록J','제1특수목록C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',11,'제2특수목록',0,'SC2',null,null,null,'단위업무이력관리','제2특수목록','2nd Special lists','제2특수목록J','제2특수목록C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',12,'제3특수목록',0,'SC3',null,null,null,'단위업무이력관리','제3특수목록','3rd Special lists','제3특수목록J','제3특수목록C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',13,'주요열람용도',0,'DISPLAYUSAGE',null,null,null,'단위업무이력관리','주요열람용도','Major reading purpose','주요열람용도J','주요열람용도C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',14,'단위업무설명',0,'DESCRIPTION',null,null,null,'단위업무이력관리','단위업무설명','Unit task description','단위업무설명J','단위업무설명C','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('094',15,'소기능',0,'SUBCATEGORYCODE','CODE',null,null,'단위업무이력관리','소기능','Small function','二次カテゴリコード','次要类别代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',1,'이름',140,'TITLE',null,null,null,'Simple기록물철','이름','Name','綴じ名','名稱','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',2,'생산연도',50,'PRODUCTIONYEAR',null,null,null,'Simple기록물철','생산연도','Productionyear','生産年度','生产年度','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',3,'단위업무명(분류코드)',160,'TASKNAME',null,null,null,'Simple기록물철','단위업무명(분류코드)','Taskname','単位業務名','单位业务名称','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',4,'형태',100,'RECTYPECODE',null,null,null,'Simple기록물철','형태','FORM','形態','表','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',5,'연번',50,'REGSERIALNO',null,null,null,'Simple기록물철','연번','SN.','連番','序列号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('095',6,'권호수',40,'VOLUMENO',null,null,null,'Simple기록물철','권호수','VOL.','巻号数','卷湖','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',1,'대기능',140,null,null,null,null,'기록물철리스트','대기능','MajorCategoryCode','主なカテゴリコード','主要类别代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',2,'중기능',140,null,null,null,null,'기록물철리스트','중기능','MiddleCategoryCode','中間のカテゴリコード','中间类别代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',3,'소기능',140,null,null,null,null,'기록물철리스트','소기능','MinorCategoryCode','二次カテゴリコード','次要类别代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',4,'단위업무명',140,null,null,null,null,'기록물철리스트','단위업무명','Unit task name','単位業務名','单位商业名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',5,'이름',140,null,null,null,null,'기록물철리스트','이름','Name','綴じ名','名稱','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',6,'형태',100,null,null,null,null,'기록물철리스트','형태','Rectype','形態','表','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',7,'연번',50,null,null,null,null,'기록물철리스트','연번','NO.','連番','序列号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('096',8,'권호수',40,null,null,null,null,'기록물철리스트','권호수','VoluMemo','巻号数','卷湖','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('097',1,'단위업무',65,null,null,null,null,'단위업무리스트','단위업무','UNIT WORKING','単位業務','单位商业','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('097',2,'단위업무명',120,null,null,null,null,'단위업무리스트','단위업무명','Unit task name','単位業務名','单位商业名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('097',3,'보존연한',60,null,null,null,null,'단위업무리스트','보존연한','KEEPING PERIOD','保存年限','保存完好的软','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('097',4,'임시',40,null,null,null,null,'단위업무리스트','임시','TEMPORARY','臨時','临时','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',1,'처리과명',100,'VTASKCLASS','PROCESSDEPTNAME',null,null,'단위업무리스트(full)','처리과명','PROCDEPT NAME','処理部署名','加工名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',2,'단위업무명',150,'VTASKCLASS','TASKNAME',null,null,'단위업무리스트(full)','단위업무명','Unit task name','単位業務名','单位商业名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',3,'단위업무코드',80,'VTASKCLASS','TASKCODE',null,null,'단위업무리스트(full)','단위업무코드','UNITWORKING CODE','単位業務コード','工作单位代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',4,'임시',40,'VTASKCLASS','TEMPFLAG',null,null,'단위업무리스트(full)','임시','TEMP','臨時','临时','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',5,'대기능명',100,'VTASKCLASS','CNAME',null,null,'단위업무리스트(full)','대기능명','MAJOR','大機能','大機能','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',6,'중기능명',100,'VTASKCLASS','MCNAME',null,null,'단위업무리스트(full)','중기능명','MIDDLE','中機能','中機能','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',7,'소기능명',100,'VTASKCLASS','SCNAME',null,null,'단위업무리스트(full)','소기능명','MINOR','小機能','小機能','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',8,'보존기간',55,'VTASKCLASS','KEEPINGPERIOD',null,null,'단위업무리스트(full)','보존기간','KEEPING PERIOD','保存期間','年龄','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',9,'보존방법',180,'VTASKCLASS','KEEPINGMETHOD',null,null,'단위업무리스트(full)','보존방법','CONSERVATION METHOD','保存方法','如何保存','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',10,'보존장소',80,'VTASKCLASS','KEEPINGPLACE',null,null,'단위업무리스트(full)','보존장소','CONSERVATION PLACE','保存場所','保护区','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',11,'비치',40,'VTASKCLASS','DISPLAYRECFLAG',null,null,'단위업무리스트(full)','비치','STOCKED','備付','備付','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('098',12,'특수목록',55,'VTASKCLASS','SPECIALCATALOGFLAG',null,null,'단위업무리스트(full)','특수목록','SPECIAL LIST','特殊リスト','特别名单','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',1,'버전',40,null,null,null,null,'기록물철변경이력정보','버전','Ver','Ver.','版本','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',2,'제목',180,null,null,null,null,'기록물철변경이력정보','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',3,'기록물 형태',100,null,null,null,null,'기록물철변경이력정보','기록물 형태','DocForm','記録物の形態','纪录片的形式','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',4,'변경영역',100,null,null,null,null,'기록물철변경이력정보','변경영역','ModifyArea','変更領域','变化领域版本','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',5,'변경자',80,null,null,null,null,'기록물철변경이력정보','변경자','Modifier','変更者','変更者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('099',6,'변경일자',80,null,null,null,null,'기록물철변경이력정보','변경일자','ModifiedDate','変更日時','变更日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('100',1,'순번',40,null,null,null,null,'결재선템플릿','순번','No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('100',2,'결재유형',70,null,null,null,null,'결재선템플릿','결재유형','ApprovalType','処理類型','批准类型','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('100',3,'결재자',70,null,null,null,null,'결재선템플릿','결재자','Approver','決裁者','批准者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('101',1,'코드',60,null,null,null,null,'단위업무 소기능(소분류)','코드','CODE','コード','线','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('101',2,'이름',120,null,null,null,null,'단위업무 소기능(소분류)','이름','Name','綴じ名','名稱','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('102',1,'부서코드',70,null,null,null,null,'단위업무 사용 부서','부서코드','DEPTCODE','部署コード','部门代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('102',2,'부서명',130,null,null,null,null,'단위업무 사용 부서','부서명','DEPTNAME','部署名','部门名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',1,'버전',30,null,null,null,null,'기록물 변경이력정보','버전','Ver.','Ver.','版本','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',2,'제목',170,null,null,null,null,'기록물 변경이력정보','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',3,'등록일자',100,null,null,null,null,'기록물 변경이력정보','등록일자','Regdate','登録日時','注册日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',4,'쪽수',35,null,null,null,null,'기록물 변경이력정보','쪽수','Page','ページ数','頁數','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',5,'결재권자',80,null,null,null,null,'기록물 변경이력정보','결재권자','Approval person','決裁権者','审批','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',6,'기안자',80,null,null,null,null,'기록물 변경이력정보','기안자','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',7,'시행일자',70,null,null,null,null,'기록물 변경이력정보','시행일자','Enforce date.','施行日','生效日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',8,'수신자(발신자)',90,null,null,null,null,'기록물 변경이력정보','수신자(발신자)','Recipient(Sender)','受信者（起案者）','受信者(送信者)','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',9,'변경영역',80,null,null,null,null,'기록물 변경이력정보','변경영역','Modifyarea','変更領域','变化领域版本','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',10,'변경자',60,null,null,null,null,'기록물 변경이력정보','변경자','Modifier','変更者','変更者','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('103',11,'변경일자',70,null,null,null,null,'기록물 변경이력정보','변경일자','Modified date','変更日時','变更日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('104',1,'열람시간',150,null,null,null,null,'기록물 열람이력정보','열람시간','ReadingTime','閲覧時間','时间','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('104',2,'열람자',100,null,null,null,null,'기록물 열람이력정보','열람자','Reader','閲覧者','观众','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('104',3,'부서명',120,null,null,null,null,'기록물 열람이력정보','부서명','DeptName','部署名','部门名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('104',4,'직위',120,null,null,null,null,'기록물 열람이력정보','직위','Position','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('105',1,'수 신 자',200,null,null,null,null,'수신처 템플릿 상세 리스트','수 신 자','Receiver','受信先','收 件 人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('106',1,'문서함리스트',250,null,null,null,null,'부서 문서함리스트','문서함리스트','DocFormList','文書フォルダリスト','一提到文件清单','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('107',1,'부서명',100,null,null,null,null,'사용자별 문서 결재 건수','부서명','APRMEMBERDEPTNAME','部署名','部门名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('107',2,'직위',80,null,null,null,null,'사용자별 문서 결재 건수','직위','APRMEMBERJOBTITLE','役職','职位','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('107',3,'기안자',80,null,null,null,null,'사용자별 문서 결재 건수','기안자','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('107',4,'결재건수',60,null,null,null,null,'사용자별 문서 결재 건수','결재건수','APRCOUNT','決裁件数','批准件数','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('108',1,'발신부서',150,null,null,null,null,'부서별 발송/수신건수','발신부서','SENTDEPTNAME','送信部署','发送部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('108',2,'수신부서',150,null,null,null,null,'부서별 발송/수신건수','수신부서','RECEVDEPTNAME','送信部署','发送部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('108',3,'건수',40,null,null,null,null,'부서별 발송/수신건수','건수','APRCOUNT','件数','件数','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('109',1,'양식리스트',215,'TBL_FORMINFO','FormName','FormName',null,'양식리스트','양식명','Form list','様式リスト','样式列表','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('110',1,'성명',100,null,null,null,null,'업무담당자지정','성명','Name','綴じ名','名稱','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('111',1,'문서상태',100,null,null,null,null,'문서함 문서상태 등록','문서상태','Doc. status','文書区分','文件状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('111',2,'문서함명',100,null,null,null,null,'문서함 문서상태 등록','문서함명','Dept. doc. folder','文書フォルダ名','Dept. doc. folder','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',1,'제목',380,'VAPRDOINGDOCLIST','DocTitle',null,null,'결재할 문서','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',2,'회사',120,'VAPRDOINGDOCLIST','companyName',null,null,'결재할 문서','회사','Company','会社','公司','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',3,'기안부서',120,'VAPRDOINGDOCLIST','WriterDeptName',null,null,'결재할 문서','기안부서','Dept.(draft)','起案部署','起草部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',4,'기안자',100,'VAPRDOINGDOCLIST','WriterName',null,null,'결재할 문서','기안자','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',5,'기안일시',100,'VAPRDOINGDOCLIST','StartDate',null,null,'결재할 문서','기안일시','Date(draft)','起案日時','起草日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',6,'상태',60,'VAPRDOINGDOCLIST','FunctionType',null,null,'결재할 문서','상태','Status','ステータス','状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',7,'양식명',100,'VAPRDOINGDOCLIST','FormName',null,null,'결재할 문서','양식명','Form title','様式名','样式名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',8,'첨부',30,'VAPRDOINGDOCLIST','HASATTACHYN',null,null,'결재할 문서','첨부','Attach','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',9,'공개',30,'VAPRDOINGDOCLIST','ISPUBLIC',null,null,'결재할 문서','공개','Public','公開','公开','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',1,'제목',380,'VAPRWILLDOCLIST','DocTitle',null,null,'기안한 문서','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',2,'회사',120,'VAPRWILLDOCLIST','companyName',null,null,'기안한 문서','회사','Company','会社','公司','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',3,'기안부서',120,'VAPRWILLDOCLIST','WriterDeptName',null,null,'기안한 문서','기안부서','Dept.(draft)','起案部署','起草部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',4,'기안자',100,'VAPRWILLDOCLIST','WriterName',null,null,'기안한 문서','기안자','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',5,'기안일시',100,'VAPRWILLDOCLIST','StartDate',null,null,'기안한 문서','기안일시','Date(draft)','起案日時','起草日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',6,'상태',60,'VAPRWILLDOCLIST','FunctionType',null,null,'기안한 문서','상태','Status','ステータス','状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',7,'양식명',100,'VAPRWILLDOCLIST','FormName',null,null,'기안한 문서','양식명','Form title','様式名','样式名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',8,'첨부',30,'VAPRWILLDOCLIST','HASATTACHYN',null,null,'기안한 문서','첨부','Attach','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',9,'공개',30,'VAPRWILLDOCLIST','ISPUBLIC',null,null,'기안한 문서','공개','Public','公開','公开','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',1,'제목',380,'VAPRWILLDOCLIST','DocTitle',null,null,'결재진행문서','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',2,'회사',120,'VAPRWILLDOCLIST','companyName',null,null,'결재진행문서','회사','Company','会社','公司','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',3,'기안부서',120,'VAPRWILLDOCLIST','WriterDeptName',null,null,'결재진행문서','기안부서','Dept.(draft)','起案部署','起草部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',4,'기안자',100,'VAPRWILLDOCLIST','WriterName',null,null,'결재진행문서','기안자','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',5,'기안일시',100,'VAPRWILLDOCLIST','StartDate',null,null,'결재진행문서','기안일시','Dept.(draft)','起案日時','起草日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',6,'상태',60,'VAPRWILLDOCLIST','FunctionType',null,null,'결재진행문서','상태','Status','ステータス','状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',7,'양식명',100,'VAPRWILLDOCLIST','FormName',null,null,'결재진행문서','양식명','Form title','様式名','样式名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',8,'첨부',30,'VAPRWILLDOCLIST','HASATTACHYN',null,null,'결재진행문서','첨부','Attach','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',9,'공개',30,'VAPRWILLDOCLIST','ISPUBLIC',null,null,'결재진행문서','공개','Public','公開','公开','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',1,'제목',320,'TBL_APRDOCINFO','DocTitle',null,null,'수신문서처리기','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',2,'문서상태',70,'TBL_APRRECEIPTPROCESSINFO','DocState',null,null,'수신문서처리기','문서상태','Doc. status','文書区分','文件状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',3,'결재상태',70,'TBL_APRRECEIPTPROCESSINFO','AprState',null,null,'수신문서처리기','결재상태','Approval status','ステータス','批准状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',4,'기안자',70,'TBL_APRDOCINFO','WriterName',null,null,'결재진행문서','기안자','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',5,'발신부서',100,'TBL_APRRECEIPTPROCESSINFO','SentDeptName',null,null,'수신문서처리기','발신부서','Dept. sent','送信部署','发送部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',6,'수신부서',100,'TBL_APRRECEIPTPROCESSINFO','ReceivedDeptName',null,null,'수신문서처리기','도착부서','Date recevied','受信部署','收信部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',7,'수신일자',100,'TBL_APRRECEIPTPROCESSINFO','ProcessDate',null,null,'수신문서처리기','도착일자','ProcessDate','到着日付','接收日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',8,'양식명',100,'TBL_APRDOCINFO','FormName',null,null,'수신문서처리기','양식명','Form Name','様式名','样式名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',9,'첨부',30,'TBL_APRDOCINFO','HASATTACHYN',null,null,'수신문서처리기','첨부','Attach','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',10,'공개',30,'TBL_APRDOCINFO','ISPUBLIC',null,null,'수신문서처리기','공개','Public','公開','公开','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',1,'제목',300,'TBL_APRDOCINFO','DocTitle',null,null,'심사진행기','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',2,'문서상태',80,'TBL_APRRECEIPTPROCESSINFO','DocState',null,null,'심사진행기','문서상태','Doc. status','文書区分','文件状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',3,'결재상태',80,'TBL_APRRECEIPTPROCESSINFO','AprState',null,null,'심사진행기','결재상태','Approval status','ステータス','批准状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',4,'발신부서',100,'TBL_APRRECEIPTPROCESSINFO','SentDeptName',null,null,'심사진행기','발신부서','Dept. sent','送信部署','发送部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',5,'도착일자',150,'TBL_APRRECEIPTPROCESSINFO','ProcessDate',null,null,'심사진행기','도착일자','Date recevied','到着日付','接收日','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',6,'첨부',30,'TBL_APRRECEIPTPROCESSINFO','HASATTACHYN',null,null,'심사진행기','첨부','Attach','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',7,'공개',30,'TBL_APRRECEIPTPROCESSINFO','ISPUBLIC',null,null,'심사진행기','공개','Public','公開','公开','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',1,'문서번호',150,'TBL_ENDAPRDOCINFO','DocNo',null,null,'문서함문서','문서번호','Doc. No.','文書番号','文件号','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',2,'제목',350,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'문서함문서','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',3,'기안자',100,'TBL_ENDAPRDOCINFO','WriterName',null,null,'문서함문서','기안자','Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',4,'회사',100,'TBL_ENDAPRDOCINFO','companyName',null,null,'결재할 문서','회사','Company','会社','公司','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',5,'기안부서',100,'TBL_ENDAPRDOCINFO','WriterDeptName',null,null,'문서함문서','기안부서명','Dept.(draft)','起案部署','起草部门','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',6,'완료일시',160,'TBL_ENDAPRDOCINFO','EndDate',null,null,'문서함문서','완료일시','Date completed','完了日時','结束日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',7,'양식명',150,'TBL_ENDAPRDOCINFO','FormName',null,null,'문서함문서','양식명','Form title','様式名','样式名','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',8,'이관',30,'TBL_EXPENDAPRDOCINFO','EDMSYN',null,'NoUse','문서함문서','EDMS이관여부','Transfer','移管','移交','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',9,'첨부',30,'TBL_EXPENDAPRDOCINFO','HASATTACHYN',null,null,'문서함문서','첨부','Attach','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',10,'공개',30,'TBL_EXPENDAPRDOCINFO','ISPUBLIC',null,null,'문서함문서','공개','Public','公開','公开','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',1,'제목',300,'TBL_ENDAPRDOCINFO','DocTitle',null,null,'발송대기문서','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',2,'발신의뢰부서',150,'TBL_ENDAPRDOCINFO','WriterDeptName',null,null,'발송대기문서','기안부서','Dept.(draft)','送信依頼部門','傳出部門委託','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',3,'발신의뢰자',150,'TBL_ENDAPRDOCINFO','WriterName',null,null,'발송대기문서','기안자','Drafter','送信依頼者','傳出贊助商','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',4,'발신의뢰일자',150,'TBL_ENDAPRDOCINFO','EndDate',null,null,'발송대기문서','완료일자','Date(draft)','送信依頼日','日期的傳出請求','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',5,'상태',100,'TBL_ENDRECEIPTPOINTINFO','ProcessYN',null,null,'발송대기문서','발송대기상태','Status','ステータス','状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',6,'양식명',150,'TBL_ENDAPRDOCINFO','FormName',null,null,'발송대기문서','양식명','Form title','様式名','样式名','Top',@tenant_id_value);

-- S
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 1, '제목', 'Title', 'タイトル', '标题', 300, 'VAPRDOINGDOCLIST', 'DocTitle', NULL, NULL, '결재할 문서', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 2, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 135, 'VAPRDOINGDOCLIST', 'WriterDeptName', NULL, NULL, '결재할 문서', '기안부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 3, '기안자', 'Drafter', '起案者', '起草人', 70, 'VAPRDOINGDOCLIST', 'WriterName', NULL, NULL, '결재할 문서', '기안자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 4, '수신일자', 'ProcessDate', '到着日時', '接收日', 160, 'VAPRDOINGDOCLIST', 'StartDate', NULL, NULL, '결재할 문서', '기안일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 5, '상태', 'Status', 'ステータス', '状态', 50, 'VAPRDOINGDOCLIST', 'FunctionType', NULL, NULL, '결재할 문서', '상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 6, '문서명', 'Form title', '文書名', '文件名', 100, 'VAPRDOINGDOCLIST', 'FormName', NULL, NULL, '결재할 문서', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 7, '첨부', 'Attach', '添付', '附件', 50, 'VAPRDOINGDOCLIST', 'HASATTACHYN', NULL, NULL, '결재할 문서', '첨부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S001', 8, '공개', 'Public', '公開', '公开', 50, 'VAPRDOINGDOCLIST', 'ISPUBLIC', NULL, NULL, '결재할 문서', '공개', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 1, '제목', 'Title', 'タイトル', '标题', 300, 'VAPRWILLDOCLIST', 'DocTitle', NULL, NULL, '기안한 문서', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 2, '회사', 'Company', '会社', '公司', 135, 'VAPRWILLDOCLIST', 'companyName', NULL, NULL, '결재할 문서', '회사', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 3, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 135, 'VAPRWILLDOCLIST', 'WriterDeptName', NULL, NULL, '기안한 문서', '기안부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 4, '기안자', 'Drafter', '起案者', '起草人', 70, 'VAPRWILLDOCLIST', 'WriterName', NULL, NULL, '기안한 문서', '기안자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 5, '기안일시', 'Date(draft)', '起案日時', '起草日期', 160, 'VAPRWILLDOCLIST', 'StartDate', NULL, NULL, '기안한 문서', '기안일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 6, '상태', 'Status', 'ステータス', '状态', 50, 'VAPRWILLDOCLIST', 'FunctionTypeName', NULL, NULL, '기안한 문서', '상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 7, '문서명', 'Form title', '文書名', '文件名', 100, 'VAPRWILLDOCLIST', 'FormName', NULL, NULL, '기안한 문서', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 8, '첨부', 'Attach', '添付', '附件', 50, 'VAPRWILLDOCLIST', 'HASATTACHYN', NULL, NULL, '기안한 문서', '첨부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S002', 9, '공개', 'Public', '公開', '公开', 50, 'VAPRWILLDOCLIST', 'ISPUBLIC', NULL, NULL, '기안한 문서', '공개', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 1, '제목', 'Title', 'タイトル', '标题', 300, 'VAPRWILLDOCLIST', 'DocTitle', NULL, NULL, '결재진행문서', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 2, '회사', 'Company', '会社', '公司', 135, 'VAPRWILLDOCLIST', 'companyName', NULL, NULL, '결재할 문서', '회사', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 3, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 135, 'VAPRWILLDOCLIST', 'WriterDeptName', NULL, NULL, '결재진행문서', '기안부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 4, '기안자', 'Drafter', '起案者', '起草人', 70, 'VAPRWILLDOCLIST', 'WriterName', NULL, NULL, '결재진행문서', '기안자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 5, '기안일시', 'Dept.(draft)', '起案日時', '起草日期', 160, 'VAPRWILLDOCLIST', 'StartDate', NULL, NULL, '결재진행문서', '기안일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 6, '상태', 'Status', 'ステータス', '状态', 50, 'VAPRWILLDOCLIST', 'FunctionTypeName', NULL, NULL, '결재진행문서', '상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 7, '문서명', 'Form title', '文書名', '文件名', 100, 'VAPRWILLDOCLIST', 'FormName', NULL, NULL, '결재진행문서', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 8, '첨부', 'Attach', '添付', '附件', 50, 'VAPRWILLDOCLIST', 'HASATTACHYN', NULL, NULL, '결재진행문서', '첨부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S003', 9, '공개', 'Public', '公開', '公开', 50, 'VAPRWILLDOCLIST', 'ISPUBLIC', NULL, NULL, '결재진행문서', '공개', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 1, '제목', 'Title', 'タイトル', '标题', 300, 'TBL_APRDOCINFO', 'DocTitle', NULL, NULL, '수신문서처리기', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 2, '문서상태', 'Doc. status', '文書区分', '文件状态', 110, 'TBL_APRRECEIPTPROCESSINFO', 'DocStateName', NULL, NULL, '수신문서처리기', '문서상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 3, '결재상태', 'Approval status', '進行段階', '批准状态', 110, 'TBL_APRRECEIPTPROCESSINFO', 'AprState', NULL, NULL, '수신문서처리기', '결재상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 4, '발신부서', 'Dept. sent', '送信部署', '发送部门', 100, 'TBL_APRRECEIPTPROCESSINFO', 'SentDeptName', NULL, NULL, '수신문서처리기', '발신부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 5, '도착일자', 'Date recevied', '到着日付', '接收日', 150, 'TBL_APRRECEIPTPROCESSINFO', 'ProcessDate', NULL, NULL, '수신문서처리기', '도착일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 6, '양식명', 'Form title', '様式名', '样式名', 100, 'TBL_APRDOCINFO', 'FormName', NULL, NULL, '수신문서처리기', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 7, '첨부', 'Attach', '添付', '附件', 50, 'TBL_APRDOCINFO', 'HASATTACHYN', NULL, NULL, '수신문서처리기', '첨부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S004', 8, '공개', 'Public', '公開', '公开', 50, 'TBL_APRDOCINFO', 'ISPUBLIC', NULL, NULL, '수신문서처리기', '공개', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 1, '제목', 'Title', 'タイトル', '标题', 400, 'TBL_APRDOCINFO', 'DocTitle', NULL, NULL, '심사진행기', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 2, '문서상태', 'Doc. status', '文書区分', '文件状态', 110, 'TBL_APRRECEIPTPROCESSINFO', 'DocStateName', NULL, NULL, '심사진행기', '문서상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 3, '결재상태', 'Approval status', '進行段階', '批准状态', 110, 'TBL_APRRECEIPTPROCESSINFO', 'AprState', NULL, NULL, '심사진행기', '결재상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 4, '발신부서', 'Dept. sent', '送信部署', '发送部门', 100, 'TBL_APRRECEIPTPROCESSINFO', 'SentDeptName', NULL, NULL, '심사진행기', '발신부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 5, '도착일자', 'Date recevied', '到着日付', '接收日', 150, 'TBL_APRRECEIPTPROCESSINFO', 'ProcessDate', NULL, NULL, '심사진행기', '도착일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 6, '첨부', 'Attach', '添付', '附件', 50, 'TBL_APRRECEIPTPROCESSINFO', 'HASATTACHYN', NULL, NULL, '심사진행기', '첨부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S005', 7, '공개', 'Public', '公開', '公开', 50, 'TBL_APRRECEIPTPROCESSINFO', 'ISPUBLIC', NULL, NULL, '심사진행기', '공개', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 1, '순번', 'SN', 'SN', 'SN', 50, 'No_Table', 'SN', NULL, NULL, '', '', 'Top', @tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 2, '문서번호', 'Doc. No.', '文書番号', '文件号', 140, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '문서함문서', '문서번호', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 3, '제목', 'Title', 'タイトル', '标题', 320, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '문서함문서', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 4, '기안자', 'Drafter', '起案者', '起草人', 90, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '문서함문서', '기안자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 5, '회사', 'Company', '会社', '公司', 110, 'TBL_ENDAPRDOCINFO', 'companyName', NULL, NULL, '결재할 문서', '회사', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 6, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 110, 'TBL_ENDAPRDOCINFO', 'WriterDeptName', NULL, NULL, '문서함문서', '기안부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 7, '완료일시', 'Date completed', '完了日時', '结束日期', 110, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '문서함문서', '완료일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 8, '양식명', 'Form title', '様式名', '样式名', 100, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '문서함문서', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 9, '이관', 'Transfer', '移管', '移交', 50, 'TBL_EXPENDAPRDOCINFO', 'EDMSYN', NULL, 'NoUse', '문서함문서', 'EDMS이관여부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 10, '구분', 'Type', '区分', '区分', 50, 'TBL_ENDAPRDOCINFO', 'DocStateName', NULL, NULL, '문서함문서', '문서상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 11, '발송상태', 'Sending status', '送信状態', '发送状态', 50, NULL, 'SendFlag', NULL, NULL, '문서함문서', '발송상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 12, '첨부', 'Attach', '添付', '附件', 20, NULL, 'HASATTACHYN', NULL, NULL, '문서함문서', '첨부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S006', 13, '공개', 'Public', '公開', '公开', 20, NULL, 'ISPUBLIC', NULL, NULL, '문서함문서', '공개', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 1, '제목', 'Title', 'タイトル', '标题', 300, 'TBL_TMPAPRDOCINFO', 'DocTitle', NULL, NULL, '서버저장문서', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 2, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 130, 'TBL_TMPAPRDOCINFO', 'WriterDeptName', NULL, NULL, '서버저장문서', '기안부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 3, '기안자', 'Drafter', '起案者', '起草人', 120, 'TBL_TMPAPRDOCINFO', 'WriterName', NULL, NULL, '서버저장문서', '기안자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 4, '기안일시', 'Date(draft)', '起案日時', '起草日期', 130, 'TBL_TMPAPRDOCINFO', 'StartDate', NULL, NULL, '서버저장문서', '기안일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 5, '문서명', 'Form title', '文書名', '文件名', 100, 'TBL_TMPEXPAPRDOCINFO', 'FormName', NULL, NULL, '서버저장문서', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 6, '첨부', 'Attach', '添付', '附件', 50, 'TBL_APRDOCINFO', 'HASATTACHYN', NULL, NULL, '서버저장문서', '첨부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S007', 7, '공개', 'Public', '公開', '公开', 50, 'TBL_APRDOCINFO', 'ISPUBLIC', NULL, NULL, '서버저장문서', '공개', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_APRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(진행)', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 2, '성명', 'Name', '氏名', '姓名', 120, 'TBL_APRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(진행)', '성명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_APRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(진행)', '직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 4, '부서', 'Dept.', '部署', '部门', 130, 'TBL_APRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(진행)', '부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 5, '결재유형', 'Type', '処理類型', '批准类型', 100, 'TBL_APRLINEINFO', 'AprType', NULL, NULL, '결재선정보(진행)', '결재방법', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 6, '결재상태', 'Status', '進行段階', '批准状态', 80, 'TBL_APRLINEINFO', 'AprState', NULL, NULL, '결재선정보(진행)', '결재상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S011', 7, '결재일시', 'Date', '処理日時', '批准日', 130, 'TBL_APRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(진행)', '결재일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_ENDAPRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(완료)', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 2, '성명', 'Name', '氏名', '姓名', 120, 'TBL_ENDAPRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(완료)', '성명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_ENDAPRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(완료)', '직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 4, '부서', 'Dept.', '部署', '部门', 130, 'TBL_ENDAPRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(완료)', '부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 5, '결재유형', 'Type', '処理類型', '批准类型', 100, 'TBL_ENDAPRLINEINFO', 'AprType', NULL, NULL, '결재선정보(완료)', '결재방법', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 6, '결재상태', 'Status', '進行段階', '批准状态', 80, 'TBL_ENDAPRLINEINFO', 'AprState', NULL, NULL, '결재선정보(완료)', '결재상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 7, '결재일시', 'Date', '処理日時', '批准日', 130, 'TBL_ENDAPRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(완료)', '결재일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 8, '대리자', 'Deputy', '代理者', '代理者', 110, 'TBL_EXPENDAPRLINE', 'proxyusername', NULL, NULL, '결재선정보(완료)', '대리결재자이름', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 9, '대리자직위', 'Title(deputy)', '代理者の役職', '代理者职位', 90, 'TBL_EXPENDAPRLINE', 'proxyuserjobtitle', NULL, NULL, '결재선정보(완료)', '대리결재자직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S012', 10, '대리자부서', 'Dept.(deputy)', '代理者の部署', '代理者部门', 120, 'TBL_EXPENDAPRLINE', 'proxyuserdeptname', NULL, NULL, '결재선정보(완료)', '대리결재자부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_APRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(코딩)', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 2, '성명', 'Name', '氏名', '姓名', 120, 'TBL_APRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(코딩)', '성명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 3, '직위', 'Title', '役職', '职位', 50, 'TBL_APRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(코딩)', '직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 4, '부서', 'Dept.', '部署', '部门', 130, 'TBL_APRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(코딩)', '부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 5, '결재유형', 'Type', '処理類型', '批准类型', 120, 'TBL_APRLINEINFO', 'AprType', NULL, NULL, '결재선정보(코딩)', '결재방법', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 6, '결재상태', 'Status', '進行段階', '批准状态', 80, 'TBL_APRLINEINFO', 'AprState', NULL, NULL, '결재선정보(코딩)', '결재상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S013', 7, '결재일시', 'Date', '処理日時', '批准日', 130, 'TBL_APRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(코딩)', '결재일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_APRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(회람)', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_APRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(회람)', '성명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_APRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(회람)', '직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 4, '부서', 'Dept.', '部署', '部门', 300, 'TBL_APRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(회람)', '부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S014', 5, '회람일시', 'Date', '回覧日時', '批准日(수정해야됨)', 300, 'TBL_APRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(회람)', '회람일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_APRLINEINFO', 'AprMemberSN', NULL, NULL, '결재선정보(회람)', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_APRLINEINFO', 'AprMemberName', NULL, NULL, '결재선정보(회람)', '성명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_APRLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선정보(회람)', '직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 4, '부서', 'Dept.', '部署', '部门', 300, 'TBL_APRLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선정보(회람)', '부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S015', 5, '회람일시', 'Date', '回覧日時', '批准日(수정해야됨)', 300, 'TBL_APRLINEINFO', 'ProcessDate', NULL, NULL, '결재선정보(회람)', '회람일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_RECEIPTPOINTINFO', 'DeptMemberSN', NULL, NULL, '수신처정보(진행)', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 2, '수신부서명', 'Dept.', '受信部署名', '收信部门名', 120, 'TBL_RECEIPTPOINTINFO', 'ReceiptPointName', NULL, NULL, '수신처정보(진행)', '수신부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 3, '수신자성명', 'Name', '受信者氏名', '收信创建名', 120, 'TBL_RECEIPTPOINTINFO', 'ReceiptMemberName', NULL, NULL, '수신처정보(진행)', '수신자성명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 4, '승인상태', 'Status', 'ステータス', '承认状态', 100, 'TBL_RECEIPTPOINTINFO', 'ProcessYN', NULL, NULL, '수신처정보(진행)', '처리여부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S021', 5, '승인일자', 'Date', '処理日時', '承认日', 180, 'TBL_RECEIPTPOINTINFO', 'ProcessDate', NULL, NULL, '수신처정보(진행)', '처리일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_ENDRECEIPTPOINTINFO', 'DeptMemberSN', NULL, NULL, '수신처정보(완료)', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 2, '수신부서명', 'Dept.', '受信部署名', '收信部门名', 120, 'TBL_ENDRECEIPTPOINTINFO', 'ReceiptPointName', NULL, NULL, '수신처정보(완료)', '수신부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 3, '수신자성명', 'Name', '受信者氏名', '收信创建名', 120, 'TBL_ENDRECEIPTPOINTINFO', 'ReceiptMemberName', NULL, NULL, '수신처정보(완료)', '수신자성명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 4, '승인상태', 'Status', 'ステータス', '承认状态', 100, 'TBL_ENDRECEIPTPOINTINFO', 'ProcessYN', NULL, NULL, '수신처정보(완료)', '처리여부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S022', 5, '승인일자', 'Date', '処理日時', '承认日', 180, 'TBL_ENDRECEIPTPOINTINFO', 'ProcessDate', NULL, NULL, '수신처정보(완료)', '처리일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S023', 1, '순번', 'No.', '順番', '序号', 35, 'TBL_RECEIPTPOINTINFO', 'DeptMemberSN', NULL, NULL, '수신처정보(코딩)', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S023', 2, '수신부서명', 'Dept', '受信部署名', '收信部门名', 200, 'TBL_RECEIPTPOINTINFO', 'ReceiptPointName', NULL, NULL, '수신처정보(코딩)', '수신부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S023', 3, '수신자성명', 'Name', '受信者氏名', '收信创建名', 200, 'TBL_RECEIPTPOINTINFO', 'ReceiptMemberName', NULL, NULL, '수신처정보(진행)', '수신자성명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 1, '구분', 'Type', '区分', '区分', 55, 'TBL_APROPINIONINFO', 'OpinionGBName', NULL, NULL, '의견정보(진행)', '의견구분', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_APROPINIONINFO', 'UserName', NULL, NULL, '의견정보(진행)', '작성자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 3, '내용', 'Content', '内容', '内容', 300, 'TBL_APROPINIONINFO', 'Content', NULL, NULL, '의견정보(진행)', '의견내용', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 4, '직위', 'Title', '役職', '职位', 100, 'TBL_APROPINIONINFO', 'UserJobTitle', NULL, NULL, '의견정보(진행)', '작성자직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S031', 5, '부서', 'Dept.', '部署', '部门', 100, 'TBL_APROPINIONINFO', 'UserDeptName', NULL, NULL, '의견정보(진행)', '작성자부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 1, '구분', 'Type', '区分', '区分', 55, 'TBL_ENDAPROPINIONINFO', 'OpinionGBName', NULL, NULL, '의견정보(완료)', '의견구분', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_ENDAPROPINIONINFO', 'UserName', NULL, NULL, '의견정보(완료)', '작성자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 3, '내용', 'Content', '内容', '内容', 300, 'TBL_ENDAPROPINIONINFO', 'Content', NULL, NULL, '의견정보(완료)', '의견내용', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 4, '직위', 'Title', '役職', '职位', 100, 'TBL_ENDAPROPINIONINFO', 'UserJobTitle', NULL, NULL, '의견정보(완료)', '작성자직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S032', 5, '부서', 'Dept.', '部署', '部门', 100, 'TBL_ENDAPROPINIONINFO', 'UserDeptName', NULL, NULL, '의견정보(완료)', '작성자부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S033', 1, '구분', 'Type', '区分', '区分', 55, 'TBL_APROPINIONINFO', 'OpinionGBName', NULL, NULL, '의견정보(진행UI)', '의견구분', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S033', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_APROPINIONINFO', 'UserName', NULL, NULL, '의견정보(진행UI)', '작성자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S033', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_APROPINIONINFO', 'UserJobTitle', NULL, NULL, '의견정보(진행UI)', '작성자직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S033', 4, '부서', 'Dept.', '部署', '部门', 100, 'TBL_APROPINIONINFO', 'UserDeptName', NULL, NULL, '의견정보(진행UI)', '작성자부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S034', 1, '구분', 'Type', '区分', '区分', 55, 'TBL_ENDAPROPINIONINFO', 'OpinionGBName', NULL, NULL, '의견정보(완료UI)', '의견구분', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S034', 2, '성명', 'Name', '氏名', '姓名', 100, 'TBL_ENDAPROPINIONINFO', 'UserName', NULL, NULL, '의견정보(완료UI)', '작성자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S034', 3, '직위', 'Title', '役職', '职位', 100, 'TBL_ENDAPROPINIONINFO', 'UserJobTitle', NULL, NULL, '의견정보(완료UI)', '작성자직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S034', 4, '부서', 'Dept.', '部署', '部门', 100, 'TBL_ENDAPROPINIONINFO', 'UserDeptName', NULL, NULL, '의견정보(완료UI)', '작성자부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S041', 1, '첨부자', 'User', '添付者', '附件者', 100, 'TBL_APRATTACHINFO', 'AttachUserName', NULL, NULL, '첨부파일정보(진행UI)', '첨부자명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S041', 2, '파일이름', 'Filename', 'ファイル名', '文件名', 200, 'TBL_APRATTACHINFO', 'AttachFileName', NULL, NULL, '첨부파일정보(진행UI)', '디스플래이명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S041', 3, '파일크기', 'Size', 'ファイルサイズ', '文件大小', 100, 'TBL_APRATTACHINFO', 'AttachFileSize', NULL, NULL, '첨부파일정보(진행UI)', '파일크기', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S042', 1, '문서명', 'Form title', '文書名', '文件名', 300, 'TBAPRDOCATTACHINFO', 'AttachDocName', NULL, NULL, '첨부문서정보(진행UI)', '문서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S043', 1, '구분', 'Type', '区分', '区分', 180, NULL, 'AttachType', NULL, NULL, '첨부정보', '구분', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S043', 2, '첨부이름', 'Filename', '添付名', '附件名', 700, NULL, 'AttachName', NULL, NULL, '첨부정보', '첨부이름', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S043', 3, '첨부자', 'User', '添付者', '附件者', 450, NULL, 'AttachUserName', NULL, NULL, '첨부정보', '첨부자명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S043', 4, '첨부자부서명', 'Dept.', '添付者部署名', '附件者部门名', 200, NULL, 'AttachUserDeptName', NULL, NULL, '첨부정보', '첨부자부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '개인문서함리스트', '문서번호', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 2, '제목', 'Title', 'タイトル', '标题', 380, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '개인문서함리스트', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '개인문서함리스트', '기안자이름', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 4, '완료일시', 'Date completed', '完了日時', '结束日期', 100, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '개인문서함리스트', '완료일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 5, '양식명', 'Form title', '様式名', '样式名', 100, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '개인문서함리스트', '양식이름', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 6, '등록일자', 'Date registered', '登録日付', '注册日期', 50, 'TBL_USERCONTLIST', 'LinkDate', NULL, NULL, '개인문서함리스트', '등록일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 7, '첨부', 'Attach', '添付', '附件', 30, 'TBL_USERCONTLIST', 'HASATTACHYN', NULL, NULL, '개인문서함리스트', '첨부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S051', 8, '공개', 'Public', '公開', '公开', 30, 'TBL_USERCONTLIST', 'ISPUBLIC', NULL, NULL, '개인문서함리스트', '공개', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '부서문서함리스트', '문서번호', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 2, '제목', 'Title', 'タイトル', '标题', 350, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '부서문서함리스트', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '부서문서함리스트', '기안자이름', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 4, '완료일시', 'Date completed', '完了日時', '结束日期', 160, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '부서문서함리스트', '완료일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 5, '문서명', 'Form title', '文書名', '文件名', 160, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '부서문서함리스트', '양식이름', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S052', 6, '등록일자', 'Date registered', '登録日付', '注册日期', 160, 'TBL_DEPTCONTLIST', 'LinkDate', NULL, NULL, '부서문서함리스트', '등록일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '문서함문서', '문서번호', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 2, '제목', 'Title', 'タイトル', '标题', 350, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '문서함문서', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '문서함문서', '기안자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 4, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 100, 'TBL_ENDAPRDOCINFO', 'WriterDeptName', NULL, NULL, '문서함문서', '기안부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 5, '완료일시', 'Date completed', '完了日時', '结束日期', 160, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '문서함문서', '완료일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S056', 6, '문서명', 'Form title', '文書名', '文件名', 150, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '문서함문서', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '문서함문서', '문서번호', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 2, '제목', 'Title', 'タイトル', '标题', 350, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '문서함문서', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '문서함문서', '기안자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 4, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 100, 'TBL_ENDAPRDOCINFO', 'WriterDeptName', NULL, NULL, '문서함문서', '기안부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 5, '등록일시', 'Date registered', '登録日時', '注册日', 160, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '문서함문서', '완료일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S057', 6, '문서명', 'Form title', '文書名', '文件名', 150, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '문서함문서', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 1, '변경내용', 'Content', '変更内容', '变更内容', 60, 'TBL_HISTORYATTACHINFO', 'ModifyFlag', NULL, NULL, '첨부파일이력리스트', '변경내용', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 2, '첨부이름', 'Filename', '添付名', '附件名', 200, 'TBL_HISTORYATTACHINFO', 'AttachFileDisplayName', NULL, NULL, '첨부파일이력리스트', '첨부이름', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 3, '첨부사이즈', 'Size', '添付サイズ', '附件大小', 80, 'TBL_HISTORYATTACHINFO', 'AttachFileSize', NULL, NULL, '첨부파일이력리스트', '첨부사이즈', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 4, '변경일자', 'Date', '変更日付', '变更日', 120, 'TBL_HISTORYATTACHINFO', 'ModifyDate', NULL, NULL, '첨부파일이력리스트', '변경일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S061', 5, '변경자', 'User', '変更者', '变更者', 80, 'TBL_HISTORYATTACHINFO', 'AttachUserName', NULL, NULL, '첨부파일이력리스트', '변경자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 1, '변경순번', 'No.', '順番', '变更序号', 60, 'TBL_HISTORYLINEINFO', 'ModifySN', NULL, NULL, '결재선이력리스트', '변경순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 2, '변경일자', 'Date', '変更日付', '变更日', 100, 'TBL_HISTORYLINEINFO', 'ModifyDate', NULL, NULL, '결재선이력리스트', '변경일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 3, '변경자', 'User', '変更者', '变更者', 100, 'TBL_HISTORYLINEINFO', 'ModifyUserName', NULL, NULL, '결재선이력리스트', '변경자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 4, '변경자직위', 'Title', '変更者役職', '变更者职位', 100, 'TBL_HISTORYLINEINFO', 'ModifyUserJobTitle', NULL, NULL, '결재선이력리스트', '변경자직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S062', 5, '변경자부서', 'Dept.', '部署', '变更者部门', 100, 'TBL_HISTORYLINEINFO', 'ModifyUserDeptName', NULL, NULL, '결재선이력리스트', '변경자부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 1, '결재순번', 'No.', '決裁順番', '批准序号', 60, 'TBL_HISTORYLINEINFO', 'AprMemberSN', NULL, NULL, '결재선이력상세리스트', '결재순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 2, '결재방법', 'Type', '決裁方法', '批准方法', 60, 'TBL_HISTORYLINEINFO', 'AprType', NULL, NULL, '결재선이력상세리스트', '결재방법', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 3, '결재상태', 'Status', '進行段階', '批准状态', 60, 'TBL_HISTORYLINEINFO', 'AprState', NULL, NULL, '결재선이력상세리스트', '결재상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 4, '결재자이름', 'Name', '決裁者', '批准者名', 100, 'TBL_HISTORYLINEINFO', 'AprMemberName', NULL, NULL, '결재선이력상세리스트', '결재자이름', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 5, '결재자직위', 'Title', '決裁者役職', '批准者职位', 100, 'TBL_HISTORYLINEINFO', 'AprMemberJobTitle', NULL, NULL, '결재선이력상세리스트', '결재자직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 6, '결재자부서', 'Dept.', '決裁者部署', '批准者部门', 100, 'TBL_HISTORYLINEINFO', 'AprMemberDeptName', NULL, NULL, '결재선이력상세리스트', '결재자부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 7, '보고자', 'Reporter', 'レポーター', '报告者', 50, 'TBL_HISTORYLINEINFO', 'isBriefUserYN', NULL, 'nouse', '결재선이력상세리스트', '보고자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S063', 8, '발의자', 'Proposer', '発議者', '倡议者', 50, 'TBL_HISTORYLINEINFO', 'isProposerYN', NULL, 'nouse', '결재선이력상세리스트', '발의자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 1, '변경순번', 'No.', '順番', '变更序号', 60, 'TBL_HISTORYDOCINFO', 'ChangeSN', NULL, NULL, '문서이력리스트', '변경순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 2, '변경일자', 'Date', '変更日付', '变更日', 100, 'TBL_HISTORYDOCINFO', 'ChangeDate', NULL, NULL, '문서이력리스트', '변경일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 3, '변경자이름', 'Name', '変更者氏名', '变更者名', 100, 'TBL_HISTORYDOCINFO', 'ChangeUserName', NULL, NULL, '문서이력리스트', '변경자이름', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 4, '변경자직위', 'Title', '変更者役職', '变更者职位', 100, 'TBL_HISTORYDOCINFO', 'ChangeUserJobTitle', NULL, NULL, '문서이력리스트', '변경자직위', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S064', 5, '변경자부서', 'Dept.', '部署', '变更者部门', 100, 'TBL_HISTORYDOCINFO', 'ChangeUserDeptName', NULL, NULL, '문서이력리스트', '변경자부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 1, '제목', 'Title', 'タイトル', '标题', 300, 'TBL_APRDOCINFO', 'DocTitle', NULL, NULL, '관리자 진행문서', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 2, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 135, 'TBL_APRDOCINFO', 'WriterDeptName', NULL, NULL, '관리자 진행문서', '기안부서', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 3, '기안자', 'Drafter', '起案者', '起草人', 50, 'TBL_APRDOCINFO', 'WriterName', NULL, NULL, '관리자 진행문서', '기안자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 4, '기안일시', 'Date(draft)', '起案日時', '起草日期', 160, 'TBL_APRDOCINFO', 'StartDate', NULL, NULL, '관리자 진행문서', '기안일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 5, '상태', 'Status', 'ステータス', '状态', 50, 'TBL_APRDOCINFO', 'FunctionTypeName', NULL, NULL, '관리자 진행문서', '상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S081', 6, '문서명', 'Form title', '文書名', '文件名', 160, 'TBEXPAPRDOCINFO', 'FormName', NULL, NULL, '관리자 진행문서', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 150, 'TBL_ENDAPRDOCINFO', 'DocNo', NULL, NULL, '관리자 완료문서', '문서번호', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 2, '제목', 'Title', 'タイトル', '标题', 350, 'TBL_ENDAPRDOCINFO', 'DocTitle', NULL, NULL, '관리자 완료문서', '제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 3, '기안자', 'Drafter', '起案者', '起草人', 100, 'TBL_ENDAPRDOCINFO', 'WriterName', NULL, NULL, '관리자 완료문서', '기안자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 4, '기안부서', 'Dept.(draft)', '起案部署', '起草部门', 100, 'TBL_ENDAPRDOCINFO', 'WriterDeptName', NULL, NULL, '관리자 완료문서', '기안부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 5, '완료일시', 'Date completed', '完了日時', '结束日期', 160, 'TBL_ENDAPRDOCINFO', 'EndDate', NULL, NULL, '관리자 완료문서', '완료일시', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 6, '양식명', 'Form title', '様式名', '样式名', 150, 'TBL_ENDAPRDOCINFO', 'FormName', NULL, NULL, '관리자 완료문서', '양식명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S082', 7, '이관', 'Transfer', '移管', '移交', 30, 'TBL_EXPENDAPRDOCINFO', 'EDMSYN', NULL, NULL, '관리자 완료문서', 'EDMS이관여부', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 1, '문서번호', 'Doc. No.', '文書番号', '文件号', 130, NULL, 'DocNo', NULL, NULL, '연동문서', '문서번호', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 2, '제목', 'Title', 'タイトル', '标题', 250, NULL, 'DocTitle', NULL, NULL, '연동문서', '문서제목', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 3, '상태', 'Status', 'ステータス', '状态', 100, NULL, 'Status', NULL, NULL, '연동문서', '문서상태', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 4, '기안일자', 'Date drated', '起案日付', '起草日', 150, NULL, 'StartDate', NULL, NULL, '연동문서', '기안일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S083', 5, '완료일자', 'Date completed', '完了日付', '结束日', 150, NULL, 'EndDate', NULL, NULL, '연동문서', '완료일자', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S091', 1, '순번', 'No.', '順番', '序号', 55, 'TBL_ADMINRECEIPTGROUP_MAIN', 'MAINID', NULL, 'NoUse', '수신처그룹정보', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S091', 2, '수신처그룹', 'Receiving Dept. Group', '受信先グループ', '收信组', 250, 'TBL_ADMINRECEIPTGROUP_MAIN', 'MAINNAME', NULL, NULL, '수신처그룹정보', '수신처그룹명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S092', 1, '순번', 'No.', '順番', '序号', 55, 'TBL_ADMINRECEIPTGROUP_SUB', 'SUBID', NULL, 'NoUse', '수신처그룹소속부서정보', '순번', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S092', 2, '부서아이디', 'Dept. ID', '部署ID', '部门 ID', 250, 'TBL_ADMINRECEIPTGROUP_SUB', 'DEPTID', NULL, 'NoUse', '수신처그룹소속부서정보', '부서아이디', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S092', 3, '부서명', 'Dept. Name', '部署名', '部门名', 250, 'TBL_ADMINRECEIPTGROUP_SUB', 'DEPTNAME', NULL, NULL, '수신처그룹소속부서정보', '부서명', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S092', 4, '회사아이디', 'Company ID', '会社ID', '公司 ID', 250, 'TBL_ADMINRECEIPTGROUP_SUB', 'companyID', NULL, 'NoUse', '수신처그룹소속부서정보', '회사아이디', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S101', 1, '양식리스트', 'Form list', '様式リスト', '样式列表', 250, 'tbFormInfo', 'FORMNAME', NULL, NULL, '양식', '양식리스트', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S102', 1, '순번', 'No.', '順番', '序号', 40, 'TBL_LINTEMPLETDETAIL', 'APRMEMBERSN', NULL, NULL, '순번', '결재선템플릿내결재선정보', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S102', 2, '결재유형', 'Type', '処理類型', '批准类型', 70, 'TBL_LINTEMPLETDETAIL', 'APRTYPE', NULL, NULL, '결재유형', '결재선템플릿내결재선정보', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S102', 3, '결재자', 'Processor', '決裁者', '批准者', 120, 'TBL_LINTEMPLETDETAIL', 'APRMEMBERNAME', NULL, NULL, '결재자', '결재선템플릿내결재선정보', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S103', 1, '수 신 처', 'Receiving Dept.', '受信先', '收信人', 200, 'TBL_DEPTTEMPLETDETAIL', 'APRMEMBERDEPTNAME', NULL, NULL, '수신처', '수신처템플릿내수신처정보', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S103', 2, '수 신 자', 'Name', '受信者', '接受者', 100, 'TBL_DEPTTEMPLETDETAIL', 'APRMEMBERNAME', NULL, NULL, '수신자', '수신처템플릿내수신처정보', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 1, '부서명', 'Dept. name', '部署名', '部门名', 100, 'TBL_ENDAPRLINEINFO', 'APRMEMBERDEPTNAME', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 2, '직위', 'Title', '役職', '职位', 80, 'TBL_ENDAPRLINEINFO', 'APRMEMBERJOBTITLE', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 3, '결재자', 'Approval perso', '決裁者', '批准者', 80, 'TBL_ENDAPRLINEINFO', 'APRMEMBERNAME', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 4, '결재방법', 'Approval type', '決裁方法', '批准方法', 80, 'TBL_ENDAPRLINEINFO', 'APRTYPE', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S104', 5, '결재건수', 'The number of approval', '決裁件数', '批准件数', 60, 'TBL_ENDAPRLINEINFO', 'APRCOUNT', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S105', 1, '발신부서', 'Sending dept.', '送信部署', '发送部门', 150, 'TBL_ENDRECEIPTPROCESSINFO', 'SENTDEPTNAME', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S105', 2, '건수', 'The number of cases', '件数', '件数', 40, 'TBL_ENDRECEIPTPROCESSINFO', 'APRCOUNT', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S106', 1, '수신부서', 'Receiving dept.', '受信部署', '收信部门', 150, 'TBL_ENDRECEIPTPROCESSINFO', 'RECEIVEDDEPTNAME', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S106', 2, '건수', 'The number of cases', '件数', '件数', 40, 'TBL_ENDRECEIPTPROCESSINFO', 'APRCOUNT', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S107', 1, '발신부서', 'Sending dept.', '送信部署', '发送部门', 150, 'TBL_ENDRECEIPTPROCESSINFO', 'SENTDEPTNAME', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S107', 2, '수신부서', 'Receiving dept.', '受信部署', '收信部门', 150, 'TBL_ENDRECEIPTPROCESSINFO', 'RECEIVEDDEPTNAME', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S107', 3, '건수', 'The number of cases', '件数', '件数', 40, 'TBL_ENDRECEIPTPROCESSINFO', 'APRCOUNT', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);  
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S108', 1, '문서상태', 'Doc. status', '文書区分', '文件状态', 100, NULL, NULL, NULL, NULL, '문서함관리', '문서함관리', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S108', 2, '문서함명', 'Doc. folder name', '文書フォルダ名', '文件夹名', 100, NULL, NULL, NULL, NULL, '문서함관리', '문서함관리', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S109', 1, '소속문서함', 'Special doc. folder type', '所属文書フォルダ', '所属文件夹', 100, NULL, NULL, NULL, NULL, '문서함관리-특수문서함', '문서함관리-특수문서함', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S109', 2, '문서함명', 'Special doc. folder name', '文書フォルダ名', '文件夹名', 100, NULL, NULL, NULL, NULL, '문서함관리-특수문서함', '문서함관리-특수문서함', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S109', 3, '서브쿼리', 'Query', 'サーブクイーリー', '查询', 100, NULL, NULL, NULL, NULL, '문서함관리-특수문서함', '문서함관리-특수문서함', 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 2, '코드', 'Code', 'コード', '代码', 70, NULL, 'ITEMCODE', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 3, '기능명칭', 'Name', '機能名', '功能名称', 180, NULL, 'ITEMNAME', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 4, '보존기간', 'Keeping period', '保存期間', '保留时间', 70, NULL, 'ITEMLIMIT', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 5, '보안등급', 'Security level', '保安等級', '安全级别', 70, NULL, 'ITEMSECURITY', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('S200', 6, '공개여부', 'Public', '公開設定', '是否共享', 60, NULL, 'ITEMPUBLIC', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 1, '문서분류', 'Classified document', '文書の分類', '文件分类', 105, NULL, 'GROUPNAME', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 2, '코드', 'Code', 'コード', '代码', 50, NULL, 'ITEMCODE', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 3, '기능명칭', 'Name', '機能名', '功能名称', 180, NULL, 'ITEMNAME', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 4, '보존기간', 'Keeping period', '保存期間', '保留时间', 80, NULL, 'ITEMLIMIT', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 5, '보안등급', 'Security level', '保安等級', '安全级别', 80, NULL, 'ITEMSECURITY', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('SU200', 6, '공개여부', 'Public', '公開設定', '是否共享', 60, NULL, 'ITEMPUBLIC', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('083', 1, '문서번호', NULL, NULL, NULL, 150, NULL, 'DocNo', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('083', 2, '제목', NULL, NULL, NULL, 400, NULL, 'DocTitle', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('083', 3, '공개여부', NULL, NULL, NULL, 50, NULL, 'OpenFlag', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('083', 4, '목록공개', NULL, NULL, NULL, 50, NULL, 'ListOpenFlag', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('083', 5, '열람제한일자', NULL, NULL, NULL, 100, NULL, 'OpenLimitDate', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('083', 6, '수정일자', NULL, NULL, NULL, 140, NULL, 'UpdateDate', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('083', 7, '생성일자', NULL, NULL, NULL, 140, NULL, 'CreateDate', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('083', 8, '작성자', NULL, NULL, NULL, 100, NULL, 'WriterName', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('083', 9, '기안부서', NULL, NULL, NULL, 140, NULL, 'WriterDeptName', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('084', 1, '변경자 부서', NULL, NULL, NULL, 200, NULL, 'ModifierDeptName', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('084', 2, '변경자', NULL, NULL, NULL, 200, NULL, 'ModifierName', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION (ListType, SN, NAME, Name2, Name3, Name4, Width, TableName, ColName, ColAlias, DType, TypeDesc, FieldDesc, COMPANYID, TENANT_ID) VALUES ('084', 3, '변경일', NULL, NULL, NULL, 300, NULL, 'ModifyDate', NULL, NULL, NULL, NULL, 'Top',@tenant_id_value);


INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물 이관목록',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',2,'문서번호',80,null,'CONCAT(CONCAT(TBL_RECORD.ProcessDeptName,''-''),TRIM(LEADING''0'' FROM TBL_RECORD.RegisterNo))','DispRegisterNo','Default','기록물 이관목록',null,'Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',3,'제목',220,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','RecTitle','Default','기록물 이관목록',null,'Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',4,'기록물 형태',110,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.RegisterType','RegisterType','dtRegisterType','기록물 이관목록',null,'DocForm','記録物の形態','纪录片的形式','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',5,'쪽수',40,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.NumOfPage','NumOfPage','Default','기록물 이관목록',null,'PageNum','ページ数','頁數','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',6,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(TBL_CABINET.ProcessDeptCode),''-''),TBL_CABINET.TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물 이관목록',null,'DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',7,'공개구분',95,'TBL_RECORD','TBL_RECORD.PublicityCode','PublicityCode','dtPubCode','기록물 이관목록',null,'PublicityCode','公開区分','公共区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('005',8,'공개제한부분',90,'TBL_RECORD','TBL_RECORD.LimitRange','LimitRange','Default','기록물 이관목록',null,'LimitRange','公開制限の部分','部分公众有限公司','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',1,'순번',65,null,null,'dtSerialNum','dtSerialNum','기록물철 이관목록',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',2,'분류번호',200,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물철 이관목록',null,'DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',3,'제목',260,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 이관목록',null,'Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',4,'건수',80,'GetCabPageStaTbl2','NVL(GetNumOfRec(TBL_CABINET.CabinetID),0)','NumOfRec','Default','기록물철 이관목록',null,'APRCOUNT','件数','件数','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',5,'쪽수',80,'GetCabPageStaTbl2','NVL(GetNumOfPage(TBL_CABINET.CabinetID),0)','PageOfRec','Default','기록물철 이관목록',null,'PageNum','ページ数','頁數','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('006',6,'기록물 형태',110,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','기록물철 이관목록',null,'DocForm','記録物の形態','纪录片的形式','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',1,'일련번호',55,null,null,'dtSerialNum','dtSerialNum','기록물 이관연기 목록',null,'SerialNum','シリアル番号','序列号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',2,'문서번호',100,null,'CONCAT(CONCAT(TBL_RECORD.ProcessDeptName, ''-''), TRIM(LEADING''0'' FROM TBL_RECORD.RegisterNo))','DispRegisterNo','Default','기록물 이관연기 목록',null,'Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',3,'제목',220,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','Title','Default','기록물 이관연기 목록',null,'Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',4,'생산연도',80,'TBL_RECORD','TBL_RECORD.RegisterYear','RegisterYear','Default','기록물 이관연기 목록',null,'RegisterYear','生産年度','生产年份','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',5,'이관연도',80,'TBL_CABINETCLASS','Case TBL_CABINET.DisplayRecFlag When ''1'' Then Year(TBL_CABINET.DisplayEndDate)||1 Else TBL_CABINET.ExTransYear End','TransYear','Default','기록물 이관연기 목록',null,'TransYear','移管年度','移民一年','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('007',6,'연기사유',250,'TBL_CABINETCLASS','Case TBL_CABINET.DisplayRecFlag When ''1'' Then TBL_CABINET.DisplayReason Else TBL_CABINET.TransDelayReason End','DisplayReason','Default','기록물 이관연기 목록',null,'DisplayReason','延期の理由','吸烟的原因','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',1,'일련번호',55,null,null,'dtSerialNum','dtSerialNum','기록물철 이관연기 목록',null,'SerialNum','シリアル番号','序列号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물철 이관연기 목록',null,'DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 이관연기 목록',null,'Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',4,'생산연도',60,'TBL_CABINETCLASS','TBL_CABINETCLASS.ProductionYear','ProductionYear','ProductionYear','기록물철 이관연기 목록',null,'RegisterYear','生産年度','生产年份','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',5,'이관연도',60,'TBL_CABINETCLASS','Case DisplayRecFlag When ''1'' Then Year(TBL_CABINETCLASS.DisplayEndDate)||1 Else TBL_CABINETCLASS.ExTransYear End','TransYear','Default','기록물철 이관연기 목록',null,'TransYear','移管年度','移民一年','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('008',6,'연기사유',235,'TBL_CABINETCLASS','Case DisplayRecFlag When ''1'' Then TBL_CABINETCLASS.DisplayReason Else TBL_CABINETCLASS.TransDelayReason End','DisplayReason','Default','기록물철 이관연기 목록',null,'DisplayReason','延期の理由','吸烟的原因','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','정리대상기록물철',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','정리대상기록물철','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','정리대상기록물철','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',4,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','정리대상기록물철',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',5,'종료연도',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.ExpirationYear','EndYear','Default','정리대상기록물철',null,'EndYear','終了年度','年退出','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',6,'편철확인',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.TerminateFlag','TerminateFlag','dtBool','정리대상기록물철',null,'TerminateFlag','編綴','编辑拼写','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',7,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','정리대상기록물철',null,'STOCKED','備付','備付','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',8,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','정리대상기록물철',null,'KEEPING PERIOD','保存期間','年龄','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',9,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','정리대상기록물철',null,'CONSERVATION METHOD','保存方法','如何保存','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',10,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','정리대상기록물철',null,'Storage','保存場所','保护区','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('009',11,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','정리대상기록물철',null,'RegisterDate','登録日','注册','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','종료연기의뢰기록물철',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','종료연기의뢰기록물철','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','종료연기의뢰기록물철','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',4,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','종료연기의뢰기록물철',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',11,'연기신청',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.DelayEndYFlag','DelayEndYFlag','Default','종료연기의뢰기록물철',null,'DelayFlag','延期申請','延期请求','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',6,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','종료연기의뢰기록물철',null,'STOCKED','備付','備付','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',7,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','종료연기의뢰기록물철',null,'KEEPING PERIOD','保存期間','年龄','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',8,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','종료연기의뢰기록물철',null,'CONSERVATION METHOD','保存方法','如何保存','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',9,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','종료연기의뢰기록물철',null,'Storage','保存場所','保护区','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('010',10,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','종료연기의뢰기록물철',null,'RegisterDate','登録日','注册','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물철 생상현황보고',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',2,'분류번호',180,null,null,'dtCabClassNo','dtCabClassNo','기록물철 생상현황보고','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 생상현황보고','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',4,'상태',80,null,null,'TransStatus','Default',null,null,'Status','ステータス','状态','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',5,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','기록물철 생상현황보고',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',6,'종료연도',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.ExpirationYear','ExpirationYear','Default','기록물철 생상현황보고',null,'EndYear','終了年度','年退出','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',7,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','기록물철 생상현황보고',null,'STOCKED','備付','備付','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',8,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','기록물철 생상현황보고',null,'KEEPING PERIOD','保存期間','年龄','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',9,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','기록물철 생상현황보고',null,'CONSERVATION METHOD','保存方法','如何保存','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',10,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','기록물철 생상현황보고',null,'Storage','保存場所','保护区','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P01',11,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','기록물철 생상현황보고',null,'RegisterDate','登録日','注册','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',1,'순번',30,null,null,'dtSerialNum','dtSerialNum','기록물 생상현황보고',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',2,'등록구분',120,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.RegisterType','RegisterType','dtRegisterType','기록물 생상현황보고',null,'RegisterType','登録区分','招生区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',3,'등록일',100,'TBL_RECORD','TBL_RECORD.RegisterDate','RegisterDate','RegisterDate','기록물 생상현황보고',null,'RegisterDate','登録日','注册','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',4,'문서번호',100,null,null,'RegisterNo','RegisterNo','기록물 생상현황보고',null,'Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',5,'첨부번호',55,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.SeperateAttachNo','SeperateAttachNo','Default','기록물 생상현황보고',null,'SepAttachNo','添付番号','附件编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',6,'제목',200,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','Title','Default','기록물 생상현황보고',null,'Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',7,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(TBL_CABINET.ProcessDeptCode),''-''),TBL_CABINET.TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','dtCabClassNo','dtCabClassNo','기록물 생상현황보고','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',8,'결재권자',80,'TBL_RECORD','TBL_RECORD.AprMemberTitle','AprMemberTitle','Default','기록물 생상현황보고',null,'Approval person','決裁権者','审批','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',9,'기안자',80,'TBL_RECORD','TBL_RECORD.DrafterName','DrafterName','Default','기록물 생상현황보고',null,'Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P02',10,'첨부',40,'TBL_RECORD','TBL_RECORD.AttachFlag','AttachFlag','dtBool','기록물 생상현황보고','첨부여부','AttachFlag','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',1,'처리과코드',80,null,null,'ProcessDeptCode','Default','기록물철 등록부 변경이력','처리과기관코드','ProcessDeptCode','処理とコード','处理和代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',2,'단위업무코드',80,null,null,'TaskCode','Default',null,null,'UNITWORKING CODE','単位業務コード','工作单位代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',3,'생산년도',60,null,null,'ProductionYear','Default',null,null,'ProductionYear','生産年度','生产年份','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',4,'등록일련번호',80,null,null,'RegSerialNo','Default',null,null,'RegSerialNo','登録のシリアル番号','注册序列号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',5,'권호수',60,null,null,'VolumeNo','Default',null,null,'VOL.','巻号数','卷湖','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',6,'변경전 기록물철제목',200,null,null,'oTitle','Default',null,null,'BeforeTitle','変更前の見出し','前更改名称','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',7,'변경후 기록물철제목',200,null,null,'nTitle','Default',null,null,'AfterTitle','変更後の見出し','变更后的标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',8,'변경전 기록물형태',120,null,null,'oRecTypeCode','Default',null,null,'BeforeRecTypeCode','変更前の形式','表前的变化。','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',9,'변경후 기록물형태',120,null,null,'nRecTypeCode','Default',null,null,'AfterRecTypeCode','変更後の形','表变更后','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',10,'변경일자',120,null,null,'ModifyDate','Default',null,null,'Modified date','変更日時','变更日','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',11,'변경사유',250,null,null,'ModifyReason','Default',null,null,'ModifyReason','変更の理由','更改原因','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P03',12,'변경자',120,null,null,'ModifierName','Default','기록물등록대장 변경이력',null,'User','変更者','変更者','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',1,'처리과코드',80,null,null,'ProcessDeptCode','Default',null,null,'ProcessDeptCode','処理とコード','处理和代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',2,'생산년도',60,null,null,'RegisterYear','Default',null,null,'ProductionYear','生産年度','生产年份','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',3,'문서번호',120,null,null,'RegisterNo','Default',null,null,'Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',4,'분리번호',60,null,null,'SeperateAttachNo','Default',null,null,'SeperateAttachNo','分割番号','卸下数','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',5,'변경전 등록일자',120,null,null,'oRegisterDate','Default',null,null,'BeforeDate','変更前の登録日','日期前更改。','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',6,'변경후 등록일자',120,null,null,'nRegisterDate','Default',null,null,'AfterDate','変更後の登録日','日期的变更登记后。','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',7,'변경전 제목',200,null,null,'oTitle','Default',null,null,'BeforeTitle','変更前の見出し','前更改名称','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',8,'변경후 제목',200,null,null,'nTitle','Default',null,null,'AfterTitle','変更後の見出し','变更后的标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',9,'변경전쪽수',70,null,null,'oNumOfPage','Default',null,null,'BeforePage','変更前の改','表前的网页。','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',10,'변경후쪽수',70,null,null,'nNumOfPage','Default',null,null,'AfterPage','変更後の改','变更后网页','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',11,'변경전 결재권자',120,null,null,'oAprMemTitle','Default',null,null,'BeforeApprover','変更前の決裁権者','审批前更改。','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',12,'변경후 결재권자',120,null,null,'nAprMemTitle','Default',null,null,'AfterApprover','変更後決裁権者','审批后的变化','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',13,'변경전 기안자',120,null,null,'oDrafter','Default',null,null,'BeforeDrafter','変更前の首謀者','策划前的变化。','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',14,'변경후 기안자',120,null,null,'nDrafter','Default',null,null,'AfterDrafter','変更後首謀者','策划变更后','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',15,'변경전 시행일자',100,null,null,'oExecuteDate','Default',null,null,'BeforeExecuteDate','変更前の施行日','生效日期前更改。','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',16,'변경후 시행일자',100,null,null,'nExecuteDate','Default',null,null,'AfterExecuteDate','変更後の施行日','变更后的生效日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',17,'변경전 수신자',120,null,null,'oRMemName','Default',null,null,'BeforeRecevName','変更前の受信者','接收机前更改。','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',18,'변경후 수신자',120,null,null,'nRMemName','Default',null,null,'AfterRecevName','変更後の受信者','收件人变更后','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',19,'변경일자',100,null,null,'ModifyDate','Default',null,null,'Modified date','変更日時','变更日','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',20,'변경사유',200,null,null,'ModifyReason','Default',null,null,'ModifyReason','変更の理由','更改原因','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P04',21,'변경자',120,null,null,'ModifierName','Default',null,null,'User','変更者','変更者','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',1,'특수목록위치',100,null,null,'SCLocation','Default',null,null,'Special list location','특수목록위치J','특수목록위치C','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',2,'기록물철분류번호',150,null,null,'ClassifyNo_Cab','Default',null,null,'ClassifyNo_Cab','ドキュメンタリー鉄の分類番号','铁的记录数分类','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',3,'기록물등록번호',150,null,null,'ClassifyNo_Rec','Default',null,null,'ClassifyNo_Rec','ドキュメンタリーの登録番号','记录登记号码','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',4,'일련번호',80,null,null,'SerialNo','Default',null,null,'SerialNum','シリアル番号','序列号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',5,'특수목록#1',150,null,null,'SC1','Default',null,null,'Special List # 1','特殊なリスト＃1','特别名单＃1','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',6,'특수목록#2',150,null,null,'SC2','Default',null,null,'Special List # 2','特殊なリスト＃2','特别名单＃2','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P05',7,'특수목록#3',150,null,null,'SC3','Default',null,null,'Special List # 3','特殊なリスト＃3','特别名单＃3','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',1,'처리과기관코드',120,null,null,'ProcessDeptCode','Default',null,null,'ProcessDeptCode','処理の機関コード','处理和机构法规','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',2,'생산년도',80,null,null,'RegisterYear','Default',null,null,'ProductionYear','生産年度','生产年份','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',3,'문서번호',150,null,null,'RegisterNo','Default',null,null,'Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',4,'첨부일련번호',100,null,null,'AttFileSN','Default',null,null,'AttFileSN','添付のシリアル番号','附加的序列号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P06',5,'쪽수',80,null,null,'NumOfPage','Default',null,null,'PageNum','ページ数','頁數','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',1,'기관코드',120,null,null,'OrganCode','dtOrganCode',null,null,'OrganCode','機関コード','机构代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',2,'접수년도',80,null,null,'ReceiptY','Default',null,null,'ReceiptYear','受付年','新年招待会','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',3,'배부일련번호',80,null,null,'SN','Default',null,null,'AllocationSN','分配のシリアル番号','序列号的分配','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',4,'접수일자',120,null,null,'ReceiptD','Default',null,null,'ReceptionDate','受付日','日期的收据','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',5,'생산기관등록번호',150,null,null,'OrgDocNumCode','Default',null,null,'OrgDocNumCode','生産機関登録番号','生产管理局注册号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',6,'제목',200,null,null,'DocTitle','Default',null,null,'Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',7,'받은 처리과코드',120,null,null,'ManageDeptID','Default',null,null,'ManageDeptID','された処理とコード','接受治疗和代码','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',8,'받은 처리과명',150,null,null,'ManageDept','Default',null,null,'ManageDept','された処理科名','而接受治疗名','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',9,'배부일자',120,null,null,'DeliveryD','Default',null,null,'ReceiptDate','転送日時','分派日期','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('P07',10,'인수자',120,null,null,'ChargeName','Default',null,null,'Charge Name','引受者','引受者','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물 대장',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',2,'등록구분',120,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.RegisterType','RegisterType','dtRegisterType','기록물 대장',null,'RegisterType','登録区分','招生区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',3,'등록일',100,'TBL_RECORD','TBL_RECORD.RegisterDate','RegisterDate','dtDateTime','기록물 대장',null,'RegisterDate','登録日','注册','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',4,'문서번호',80,'TBL_ENDAPRDOCINFO','TBL_ENDAPRDOCINFO.DOCNO','DispRegisterNo','Default','기록물 대장',null,'Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
-- INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',4,'문서번호',80,null,'CONCAT(CONCAT((SELECT CASE WHEN EXTENSIONATTRIBUTE6 IS NOT NULL AND EXTENSIONATTRIBUTE6 != '''' THEN EXTENSIONATTRIBUTE6 ELSE DISPLAYNAME END  FROM TBL_DEPTMASTER WHERE CN = TBL_RECORD.ProcessDeptCode AND TENANT_ID = TBL_RECORD.TENANT_ID), ''-''), SUBSTR(TBL_RECORD.RegisterNo, -2)) ','DispRegisterNo','Default','기록물 대장',null,'Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
-- INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',5,'첨부번호',55,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.SeperateAttachNo','SeperateAttachNo','Default','기록물 대장',null,'SepAttachNo','添付番号','附件编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',5,'제목',300,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','RecTitle','Default','기록물 대장',null,'Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',6,'기록물철명',150,'TBL_CABINETCLASS','TBL_CABINET.Title','RecName','dtClassTitle','기록물 대장',null,'RecName','記録物名','档案名称','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',7,'기안자',70,'TBL_RECORD','TBL_RECORD.DrafterName','DrafterName','Default','기록물 대장',null,'Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',8,'수신자(발신자)',90,'TBL_RECORD','TBL_RECORD.ReceiptMemberName','ReceiptName','Default','기록물 대장',null,'Recipient(Sender)','受信者（起案者）','受信者(送信者)','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',9,'결재권자',80,'TBL_RECORD','TBL_RECORD.AprMemberTitle','AprMemberTitle','Default','기록물 대장',null,'Approval person','決裁権者','审批','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',10,'시행번호',180,null,'ENDDOCNO.DOCNO','SihangNo','dtSihangNO','기록물 대장',null,'SihangNo','施行番号','试行编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',11,'첨부',40,'TBL_RECORD','TBL_RECORD.AttachFlag','AttachFlag','dtBool','기록물 대장','첨부여부','AttachFlag','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',12,'수신',40,'TBL_RECORD','CASE WHEN TBL_ENDAPRDOCINFO.DocType = ''003'' AND TBL_SEPERATEATTACH.RegisterType = ''1'' THEN ''발송'' ELSE ''없음'' END','ReSendFlag','Default','기록물 대장','수신문 발송여부','ReSendFlag','受信','接待区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('001',13,'반려',40,'TBL_RECORD','TBL_RECORD.RejectFlag','RejectFlag','dtBool','기록물 대장','반려여부','RejectFlag','差し戻し','伴侣区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물철 대장',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물철 대장','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 대장','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',4,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','기록물철 대장',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',5,'종료연도',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.ExpirationYear','EndYear','Default','기록물철 대장',null,'EndYear','終了年度','年退出','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',6,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','기록물철 대장',null,'STOCKED','備付','備付','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',7,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','기록물철 대장',null,'KEEPING PERIOD','保存期間','年龄','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',8,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','기록물철 대장',null,'CONSERVATION METHOD','保存方法','如何保存','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',9,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','기록물철 대장',null,'Storage','保存場所','保护区','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',10,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','기록물철 대장',null,'RegisterDate','登録日','注册','Top',@tenant_id_value);
-- INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',11,'이관여부',60,null,'fGetCabTransStatus(TBL_CABINET.TransferFlag, 1) ','TransferFlag','Default','기록물철 대장','이관여부','TransferFlag','移管有無','无论是转移','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',11,'이관여부',60,null,'''미전송''','TransferFlag','Default','기록물철 대장','이관여부','TransferFlag','移管有無','无论是转移','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('002',12,'연기신청',60,null,'Case TransDelayFlag When ''1'' Then ''Y'' Else ''N'' End','DelayFlag','Default','기록물철 대장','이관연기여부','DelayFlag','延期申請','延期请求','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',1,'순번',30,null,null,'dtSerialNum','dtSerialNum','기록물 생상현황보고',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',2,'등록구분',110,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.RegisterType','RegisterType','dtRegisterType','기록물 생상현황보고',null,'RegisterType','登録区分','招生区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',3,'등록일',100,'TBL_RECORD','TBL_RECORD.RegisterDate','RegisterDate','dtDateTime','기록물 생상현황보고',null,'RegisterDate','登録日','注册','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',4,'문서번호',80,null,'CONCAT(CONCAT(TBL_RECORD.ProcessDeptName, ''-''), TRIM(LEADING''0'' FROM TBL_RECORD.RegisterNo))','DispRegisterNo','Default','기록물 생상현황보고',null,'Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',5,'첨부번호',55,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.SeperateAttachNo','SeperateAttachNo','Default','기록물 생상현황보고',null,'SepAttachNo','添付番号','附件编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',6,'제목',200,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','RecTitle','Default','기록물 생상현황보고',null,'Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',7,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(TBL_CABINET.ProcessDeptCode),''-''),TBL_CABINET.TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물 생상현황보고','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',8,'결재권자',80,'TBL_RECORD','TBL_RECORD.AprMemberTitle','AprMemberTitle','Default','기록물 생상현황보고',null,'Approval person','決裁権者','审批','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',9,'기안자',80,'TBL_RECORD','TBL_RECORD.DrafterName','DrafterName','Default','기록물 생상현황보고',null,'Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',10,'수신자(발신자)',90,'TBL_RECORD','TBL_RECORD.ReceiptMemberName','ReceiptName','Default','기록물 생상현황보고',null,'Recipient(Sender)','受信者（起案者）','受信者(送信者)','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('003',11,'첨부',40,'TBL_RECORD','TBL_RECORD.AttachFlag','AttachFlag','dtBool','기록물 생상현황보고','첨부여부','AttachFlag','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',1,'순번',40,null,null,'dtSerialNum','dtSerialNum','기록물철 생상현황보고',null,'No.','順番','序号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',2,'분류번호',180,null,'CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(TRIM(ProcessDeptCode),''-''),TaskCode),''-''),ProductionYear),''-''),TRIM(LEADING''0'' FROM RegSerialNo)),''(''),TRIM(LEADING''0'' FROM VolumeNo)),'')'')','DispClassNo','Default','기록물철 생상현황보고','기록물철 분류번호','DispClassNo','分類番号','分类编号','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',3,'제목',200,'TBL_CABINETCLASS','TBL_CABINETCLASS.Title','Title','Default','기록물철 생상현황보고','제목','Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',4,'기록물형태',85,'TBL_CABINETCLASS','TBL_CABINETCLASS.RecTypeCode','RecTypeCode','dtRecTypeCode','기록물철 생상현황보고',null,'RecTypeCode','記録物の類型','纪录片的形式','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',5,'종료연도',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.ExpirationYear','EndYear','Default','기록물철 생상현황보고',null,'EndYear','終了年度','年退出','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',6,'비치',40,'TBL_CABINETCLASS','TBL_CABINETCLASS.DisplayRecFlag','DisplayRecFlag','dtBool','기록물철 생상현황보고',null,'STOCKED','備付','備付','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',7,'보존기간',55,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPeriod','KeepingPeriod','dtKeepPeriod','기록물철 생상현황보고',null,'KEEPING PERIOD','保存期間','年龄','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',8,'보존방법',160,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingMethod','KeepingMethod','dtKeepMethod','기록물철 생상현황보고',null,'CONSERVATION METHOD','保存方法','如何保存','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',9,'보존장소',80,'TBL_CABINETCLASS','TBL_CABINETCLASS.KeepingPlace','KeepingPlace','dtKeepPlace','기록물철 생상현황보고',null,'Storage','保存場所','保护区','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('004',10,'등록일',70,'TBL_CABINET','TBL_CABINET.CreateDate','CreateDate','dtDate','기록물철 생상현황보고',null,'RegisterDate','登録日','注册','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',1,'문서번호',110,null,'CONCAT(CONCAT(TBL_RECORD.ProcessDeptName, ''-''), SUBSTR(TBL_RECORD.RegisterNo, -6))','DispRegisterNo','Default','열람문서함',null,'Doc. No.','登録番号','註冊號','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',2,'제목',200,'TBL_SEPERATEATTACH','TBL_SEPERATEATTACH.Title','RecTitle','Default','열람문서함',null,'Title','タイトル','标题','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',3,'기안자',50,'TBL_RECORD','TBL_RECORD.DrafterName','DrafterName','Default','열람문서함',null,'Drafter','起案者','起草人','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',4,'기안부서',70,'TBL_ENDAPRDOCINFO','TBL_ENDAPRDOCINFO.WriterDeptName','WriterDeptName','Default','열람문서함',null,'Dept.(draft)','起案部署','起草部门','Top', @tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',5,'등록일',100,'TBL_RECORD','TBL_RECORD.RegisterDate','RegisterDate','dtDateTime','열람문서함',null,'RegisterDate','登録日','注册','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',6,'문서명',80,'TBL_EXPENDAPRDOCINFO','TBL_EXPENDAPRDOCINFO.FormName','FormName','Default','열람문서함',null,'Form title','文書名','文件名','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',7,'첨부',40,'TBL_RECORD','TBL_RECORD.AttachFlag','AttachFlag','dtBool','열람문서함','첨부여부','AttachFlag','添付','附件','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',8,'공개',40,'TBL_ENDAPRDOCINFO','TBL_ENDAPRDOCINFO.ISPUBLIC','IsPublic','Default','열람문서함',null,'Public','公開','公开','Top', @tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',9,'반려',40,'TBL_RECORD','TBL_RECORD.RejectFlag','RejectFlag','dtBool','열람문서함','반려여부','RejectFlag','差し戻し','伴侣区分','Top',@tenant_id_value);
INSERT INTO TBL_LISTINFO (LISTTYPE,SN,NAME,WIDTH,TABLENAME,COLNAME,COLALIAS,DTYPE,TYPEDESC,FIELDDESC,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('012',10,'수신',40,'TBL_RECORD','CASE WHEN TBL_ENDAPRDOCINFO.DocType = ''003'' AND TBL_SEPERATEATTACH.RegisterType = ''1'' THEN ''발송'' ELSE ''없음'' END','ReSendFlag','Default','열람문서함','발송여부','ReSendFlag','受信','接待区分','Top',@tenant_id_value);

INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','1','일반문서',1,'일반문서','기록물형태 코드(기록물철)','General Documents','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','2','도면류',1,'도면류',null,'Drawings kinds','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','3','사진/필름류',1,'사진/필름류',null,'Photo/Film kinds','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','4','녹음/동영상류',1,'녹음/동영상류',null,'Recording/Video kinds','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('000','5','카드류',1,'카드류',null,'Card kinds','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('001','1','원본과 보존매체 함께 보존',1,'원본과 보존매체 함께 보존','보존방법(기록물철)','Conservation and preservation of the original with the media','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('001','2','원본 폐기, 보존매체만 보존',1,'원본 폐기, 보존매체만 보존',null,'The original disposal, preservation bojonmaecheman','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('001','3','원본을 그대로 보존',1,'원본을 그대로 보존',null,'Preserving the original','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('002','1','자료관',1,'자료관','보존장소(기록물철)','Archives','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('002','2','전문관리기관',1,'전문관리기관',null,'Management agency specializing in','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','1','일반문서 생산/발송',1,'일반문서 생산/발송','등록구분(기록물)','General document production/shipment','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','2','일반문서 접수',1,'일반문서 접수',null,'General Documents received','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','3','도면류 생산/발송',1,'도면류 생산/발송',null,'Drawings kinds production/shipment','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','4','도면류 접수',1,'도면류 접수',null,'Drawings received','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','5','사진/필름류',1,'사진/필름류',null,'Photo/Film kinds','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','6','녹음/동영상류',1,'녹음/동영상류',null,'Recording/Video kinds','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','7','카드류 생산/접수',1,'카드류 생산/접수',null,'Card Kinds Production/Reception','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('003','8','카드류 이첩발송',1,'카드류 이첩발송',null,'Cards sent yicheop','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','01','1년',1,'1년','보존년한','1 year','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','03','3년',1,'3년',null,'3 years','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','05','5년',1,'5년',null,'5 years','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','10','10년',1,'10년',null,'10 years','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','20','30년',1,'30년',null,'30 years','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','30','준영구',1,'준영구',null,'Semi-permanence','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('004','40','영구',1,'영구',null,'Permanence','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','1','대통령관련 기록물',1,'대통령관련 기록물','특수기록물(기록물)','President Related Records','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','2','비밀기록물',1,'비밀기록물',null,'Confidential Records','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','3','개별관리 기록물',1,'개별관리 기록물',null,'Individual Management Records','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','4','저작권보호 기록물',1,'저작권보호 기록물',null,'Copyright Records','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('005','5','특수규격기록물',1,'특수규격기록물',null,'Documentary special specifications','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','1','1등급',1,'1등급','공개등급','1 Level','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','2','2등급',1,'2등급',null,'2 Level','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','3','3등급',1,'3등급',null,'3 Level','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','4','4등급',1,'4등급',null,'4 Level','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','5','5등급',1,'5등급',null,'5 Level','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','6','6등급',1,'6등급',null,'6 Level','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','7','7등급',1,'7등급',null,'7 Level','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('006','8','8등급',1,'8등급',null,'8 Level','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('007','1','채번 구분필드1',1,'채번 구분필드1 이용여부','회사단위 채번','채번 구분필드1','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('007','2','채번 구분필드2',1,'채번 구분필드2 이용여부','부서단위 채번','채번 구분필드2','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('007','3','채번 구분필드3',0,'채번 구분필드3 이용여부',null,'채번 구분필드3','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('007','4','채번 구분시간',1,'0: 이용하지 않음, 1:연도별 구분, 2: 월별 구분',null,'채번 구분시간','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DA','녹음테이프 카세트',1,'녹음테이프 카세트','녹음/동영상류 시청각 기록물 코드','Cassette tape recording of','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DB','녹음테이프 릴',1,'녹음테이프 릴',null,'Reel tape recording','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DC','녹음테이프 카트리지',1,'녹음테이프 카트리지',null,'Cartridge tape recording','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DD','DVD',1,'DVD',null,'DVD','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DF','음반 SP',1,'음반 SP',null,'Music SP','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DG','음반 LP',1,'음반 LP',null,'Music LP','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DH','음반 CD',1,'음반 CD',null,'Music CD','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DJ','음반 LD',1,'음반 LD',null,'Music LD','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DK','음반 DAT',1,'음반 DAT',null,'Music DAT','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DN','영화필름',1,'영화필름',null,'Movie Film','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DO','비디오 CD',1,'비디오 CD',null,'Video CD','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DP','비디오 LD',1,'비디오 LD',null,'Video LD','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('008','DQ','비디오 테이프',1,'비디오 테이프',null,'Video tape','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CR','슬라이드 필름세트(영상)',1,'슬라이드 필름세트(영상)','사진/필름류 시청각 기록물 코드','A set of slides (pictures)','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CS','사진 CD',1,'사진 CD',null,'Photo CD','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CT','사진/필름',1,'사진/필름',null,'Photo / Film','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CU','인화된 사진',1,'인화된 사진',null,'Printed Photo','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CV','슬라이드사진(비영상)',1,'슬라이드사진(비영상)',null,'Slide photos (Non-imaging)','Top',@tenant_id_value);
INSERT INTO TBL_CABINETCODELIST (CODETYPE,CODE,NAME,ISUSED,CODEDESCRIPTION,TYPEDESCRIPTION,NAME2,COMPANYID, TENANT_ID) values ('009','CY','그림',1,'그림',null,'Picture','Top',@tenant_id_value);

INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDXS',		'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'INIT',						'문서 로딩시(기안, 접수기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_SIGN_INIT',			'문서 로딩시(결재기)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DOCNUM_BEFORE',			'문서번호 채번직전(모든화면최종결재시)',			'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DOCNUM_AFTER',				'문서번호 채번직후(모든화면최종결재시)',			'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DRAFTSAVE_BEFORE',			'기안상신직전(기안기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DRAFTSAVE_AFTER',			'기안상신직후(기안기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'DOCNUM_END',				'최종결재직후(기안기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_SIGN_BEFORE',		'중간결재자 사인직전(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_SIGN_AFTER',		'중간결재자 사인직후(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_END_AFTER',			'중간결재자 결재성공시(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'MIDDLE_END_FAIL',			'중간결재자 결재실패시(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'LAST_SIGN_BEFORE',			'최종결재자 사인직전(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'LAST_SIGN_AFTER',			'최종결재자 사인직후(결재기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'END_FAIL',					'결재완료 실패시(모든화면 최종결재시)',			'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'SUSIN_DRAFTSAVE_BEFORE',	'접수문서 접수직전(접수기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'SUSIN_DRAFTSAVE_AFTER',	'접수문서 접수직후(접수기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'SUSIN_DOCNUM_END',			'접수문서 접수후(접수기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'LAST_SEND_BEFORE',			'최종결재직전(기안기)',					'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'LAST_END_AFTER',			'최종결재직후(수신문서접수기)',				'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'BANSONG_BEFORE',			'반송직전(결재기)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'BANSONG_AFTER',			'반송성공시(결재기)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'BANSONG_FAIL',				'반송실패시(결재기)',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSIDX',			'HESONG_BEFORE',			'회송직전',						'PROCESSIDXS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIMES',		'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'DRAFT',					'기안결재시 호출(기안문)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'REDRAFT',					'재기안시 호출(재기안시기안기에서)',			'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'SUSIN',					'수신문서상태 호출(수신문)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'HAPYUI',					'합의문서상태 호출(합의문)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'CHAMJO',					'참조문서상태 호출(미구현)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'GONGRAM',					'공람문서상태 호출(미구현)',					'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'GAMSA',					'사후감사문서상태 호출(미구현)',				'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('PROCESSTIME',		'B_GAMSA',					'사전감사문서상태 호출(미구현)',				'PROCESSTIMES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('CONNSTRINGFLAGS',	'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('CONNSTRINGFLAG',		'CS',						'커넥션 정보(없으면 자동)',					'CONNSTRINGFLAGS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('CONNSTRINGFLAG',		'UI',						'화면 다이얼로그 정보',						'CONNSTRINGFLAGS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPES',			'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPE',			'Q',						'쿼리 실행',							'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPE',			'NA',						'UI가 없는 aspx',						'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPE',			'UA',						'UI가 있는 aspx(xml String을 전달)',		'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('QUERYTYPE',			'UA_EX',					'UI가 있는 aspx(xml Document를 전달)',	'QUERYTYPES');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('KEYKINDS',			'',							'',									'ROOT');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('KEYKIND',			'single',					'필드개체',							'KEYKINDS');
INSERT INTO TBL_FORMCONNINFO (CONNNODE, CONNINFO, DESCRIPTION, UPPERNODE) VALUES ('KEYKIND',			'table',					'테이블지원(미구현)',						'KEYKINDS');

-- circular insert

Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',0,'CHECK','CHECK','CHECK',NULL,'ITEMID',20,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',1,NULL,NULL,NULL,NULL,'IMPORTANCE',28,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',2,NULL,NULL,NULL,NULL,'CONFIRMSTATUS',28,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',3,NULL,NULL,NULL,NULL,'COMMENTSTATUS',28,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',4,NULL,NULL,NULL,NULL,'HASFILE',28,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',5,'제목','Title','タイトル',NULL,'TITLE',350,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',6,'작성자','Membername','作成者',NULL,'MEMBERNAME',100,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',7,'등록일','Regdate','登録日',NULL,'REGDATE',140,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',8,'확인','Confirm','確認',NULL,'CONFIRM',55,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('N',9,'상태','Status','ステータス',NULL,'STATUS',75,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',0,'CHECK','CHECK','CHECK',NULL,'ITEMID',20,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',1,NULL,NULL,NULL,NULL,'IMPORTANCE',28,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',2,NULL,NULL,NULL,NULL,'CONFIRMSTATUS',28,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',3,NULL,NULL,NULL,NULL,'HASFILE',28,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',4,'제목','Title','タイトル',NULL,'TITLE',350,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',5,'작성자','Membername','作成者',NULL,'MEMBERNAME',100,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',6,'등록일','Regdate','登録日',NULL,'REGDATE',140,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',7,'확인','Confirm','確認',NULL,'CONFIRM',55,@tenant_id_value);
Insert into TBL_CIRCULAR_LISTOPTION (LISTTYPE,SN,NAME1,NAME2,NAME3,NAME4,COLNAME,WIDTH,TENANTID) VALUES ('T',8,'상태','Status','ステータス',NULL,'STATUS',75,@tenant_id_value);

-- ------------------------ 업무일지 ---------------------------------
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t05','Top',@tenant_id_value);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t06','Top',@tenant_id_value);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t07','Top',@tenant_id_value);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t08','Top',@tenant_id_value);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t09','Top',@tenant_id_value);
Insert into tbl_journal_form_type (type_id,company_id,tenant_id) values ('ezJournal.t10','Top',@tenant_id_value);

Insert into tbl_journal_form (tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) values (@tenant_id_value,'일일업무일지(기본)',
'<div>
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
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
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
                        </td>
                        <td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
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
</p>'
,'ezJournal.t05',UTC_TIMESTAMP(),'기본일일업무일지','Top','basic');

Insert into tbl_journal_form (tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) values (@tenant_id_value,'주간업무일지(기본)',
'<div>
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
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
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
                        </td>
                        <td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
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
</p>'
,'ezJournal.t06',UTC_TIMESTAMP(),'기본주간업무일지','Top','basic');

Insert into tbl_journal_form (tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) values (@tenant_id_value,'월간업무일지(기본)',
'<div>
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
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
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
                        </td>
                        <td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
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
</p>'
,'ezJournal.t07',UTC_TIMESTAMP(),'기본월간업무일지','Top','basic');

Insert into tbl_journal_form (tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) VALUES (@tenant_id_value,'분기업무일지(기본)',
'<div>
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
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
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
                        </td>
                        <td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
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
</p>'
,'ezJournal.t08',UTC_TIMESTAMP(),'기본분기업무일지','Top','basic');

Insert into tbl_journal_form (tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) VALUES (@tenant_id_value,'반기업무일지(기본)',
'<div>
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
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
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
                        </td>
                        <td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
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
</p>'
,'ezJournal.t09',UTC_TIMESTAMP(),'기본반기업무일지','Top','basic');

Insert into tbl_journal_form (tenant_id,form_name,form_content,type_id,form_date,form_info,company_id,form_status) VALUES (@tenant_id_value,'연간업무일지(기본)',
'<div>
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
                           <td width="115" style="width: 115px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-left-width: 1px; border-top-style: solid; border-left-style: solid;">
                              <p align="center" style="font-family: 맑은 고딕; font-size: 13px;">
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
                        </td>
                        <td width="520" height="38" style="width: 520px; height: 38px; vertical-align: middle; border-top-color: rgb(0, 0, 0); border-right-color: rgb(0, 0, 0); border-left-color: rgb(0, 0, 0); border-top-width: 1px; border-right-width: 1px; border-left-width: 1px; border-top-style: solid; border-right-style: solid; border-left-style: solid; background-color: #edf3f8;">
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
</p>'
,'ezJournal.t10',UTC_TIMESTAMP(),'기본연간업무일지','Top','basic');

-- webfolder fileType 
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('1','document','doc','/images/webfolder/msWord.png',@tenant_id_value,'문서');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('2','document','docx','/images/webfolder/msWord.png',@tenant_id_value,'문서');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('3','document','xls','/images/webfolder/msExcel.png',@tenant_id_value,'문서');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('4','document','xlsx','/images/webfolder/msExcel.png',@tenant_id_value,'문서');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('5','document','ppt','/images/webfolder/msPowerpoint.png',@tenant_id_value,'문서');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('6','document','pptx','/images/webfolder/msPowerpoint.png',@tenant_id_value,'문서');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('7','music','mp3','/images/webfolder/mp3.png',@tenant_id_value,'음악');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('8','image','gif','/images/webfolder/gif.png',@tenant_id_value,'그림');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('9','image','jpeg','/images/webfolder/jpeg.png',@tenant_id_value,'그림');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('10','image','jpg','/images/webfolder/jpg.png',@tenant_id_value,'그림');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('11','zip','zip','/images/webfolder/zip.png',@tenant_id_value,'압축파일');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('12','zip','rar','/images/webfolder/rar.png',@tenant_id_value,'압축파일');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('13','zip','iso','/images/webfolder/iso.png',@tenant_id_value,'압축파일');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('14','document','pdf','/images/webfolder/pdf.png',@tenant_id_value,'문서');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('15','document','hwp','/images/webfolder/hwp.png',@tenant_id_value,'문서');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('16','image','png','/images/webfolder/png.png',@tenant_id_value,'그림');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('17','folder','folder','/images/webfolder/fldr.png',@tenant_id_value,'폴더');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('18','video','mp4','/images/webfolder/mp4.png',@tenant_id_value,'영상');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('19','video','mkv','/images/webfolder/mkv.png',@tenant_id_value,'영상');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('20','video','flv','/images/webfolder/flv.png',@tenant_id_value,'영상');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('21','unknown','unknown','/images/webfolder/unknown.png',@tenant_id_value,'기타');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('22','document','txt','/images/webfolder/txt.png',@tenant_id_value,'문서');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('23','video','avi','/images/webfolder/video.png',@tenant_id_value,'영상');
INSERT INTO TBL_WEBFOLDER_FILETYPE (TYPE_ID,TYPE_NAME,FILE_EXT,TYPE_ICON,TENANT_ID,TYPE_NAME2) values ('24','video','wmv','/images/webfolder/video.png',@tenant_id_value,'영상');

-- webfolder capacity 용량
INSERT INTO TBL_WEBFOLDER_CONFIG VALUES(@tenant_id_value,'*',1,1,1,1);

-- attitude(근태) form데이터
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (0,@tenant_id_value,'폼1','form1','<tr><th>성명</th><td id=\"writerName\" style=\"\"></td></tr><tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"3\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"><input id=\"Stimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /> ~<input id=\"Etimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /></span></td></tr><tr> <th>연락처</th> <td id=\"mobile\" style=\"\"><input name=\"mobile\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"50\"></td> </tr><tr> <th>업무대리</th> <td id=\"bizsub\" style=\"\"><input name=\"bizsub\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"120\"></td></tr>','<tr><th>Name</th><td id="writerName" style=""></td></tr><tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="3"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /> ~<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>Contact information</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>Substitute</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (1,@tenant_id_value,'폼2','form2','<tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"2\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"><input id=\"Stimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /></span></td></tr>','<tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="2"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (2,@tenant_id_value,'폼3','form3','<tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"2\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"><input id=\"Stimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /></span></td></tr>','<tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="2"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (3,@tenant_id_value,'폼4','form4','<tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"2\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"><input id=\"Stimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /></span></td></tr>','<tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="2"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (4,@tenant_id_value,'폼5','form5','<tr><th>성명</th><td id=\"writerName\" style=\"\"></td></tr><tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"1\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"></span></td></tr><tr> <th>연락처</th> <td id=\"mobile\" style=\"\"><input name=\"mobile\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"50\"></td> </tr><tr> <th>업무대리</th> <td id=\"bizsub\" style=\"\"><input name=\"bizsub\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"120\"></td></tr>','<tr><th>Name</th><td id="writerName" style=""></td></tr><tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="1"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"></span></td></tr><tr> <th>Contact information</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>Substitute</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (5,@tenant_id_value,'폼6','form6','<tr><th>성명</th><td id=\"writerName\" style=\"\"></td></tr><tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"2\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"><input id=\"Stimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /></span></td></tr><tr> <th>연락처</th> <td id=\"mobile\" style=\"\"><input name=\"mobile\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"50\"></td> </tr><tr> <th>업무대리</th> <td id=\"bizsub\" style=\"\"><input name=\"bizsub\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"120\"></td></tr>','<tr><th>Name</th><td id="writerName" style=""></td></tr><tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="2"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>Contact information</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>Substitute</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (6,@tenant_id_value,'폼7','form7','<tr><th>성명</th><td id=\"writerName\" style=\"\"></td></tr><tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"3\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"><input id=\"Stimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /> ~<input id=\"Etimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /></span></td></tr><tr> <th>연락처</th> <td id=\"mobile\" style=\"\"><input name=\"mobile\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"50\"></td> </tr><tr> <th>업무대리</th> <td id=\"bizsub\" style=\"\"><input name=\"bizsub\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"120\"></td></tr>','<tr><th>Name</th><td id="writerName" style=""></td></tr><tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="3"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /> ~<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>Contact information</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>Substitute</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (7,@tenant_id_value,'폼8','form8','<tr><th>성명</th><td id=\"writerName\" style=\"\"></td></tr><tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"4\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"> ~ <input type=\"text\" id=\"Edatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"></span></td></tr><tr> <th>근무지</th> <td id=\"region\" style=\"\"><input name=\"region\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"200\"></td> </tr><tr> <th>연락처</th> <td id=\"mobile\" style=\"\"><input name=\"mobile\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"50\"></td> </tr><tr> <th>업무대리</th> <td id=\"bizsub\" style=\"\"><input name=\"bizsub\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"120\"></td></tr>','<tr><th>Name</th><td id="writerName" style=""></td></tr><tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="4"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></span></td></tr><tr> <th>Workplace</th> <td id="region" style=""><input name="region" type="text" style="width:98%" value=""  maxlength="200"></td> </tr><tr> <th>Contact information</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>Substitute</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (8,@tenant_id_value,'폼9','form9','<tr><th>성명</th><td id=\"writerName\" style=\"\"></td></tr><tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"5\"><input name=\"checkbox\" type=\"checkbox\" id=\"alldaycheck\" style=\"height:22px;\" onclick=\"allday_change()\" value=\"1\">하루종일 <input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"><input id=\"Stimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /> ~ <input type=\"text\" id=\"Edatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"><input id=\"Etimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /></span></td></tr><tr> <th>근무지</th> <td id=\"region\" style=\"\"><input name=\"region\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"200\"></td> </tr><tr> <th>연락처</th> <td id=\"mobile\" style=\"\"><input name=\"mobile\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"50\"></td> </tr><tr> <th>업무대리</th> <td id=\"bizsub\" style=\"\"><input name=\"bizsub\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"120\"></td></tr>','<tr><th>Name</th><td id="writerName" style=""></td></tr><tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="5"><input name="checkbox" type="checkbox" id="alldaycheck" style="height:22px;" onclick="allday_change()" value="1">All day <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>Workplace</th> <td id="region" style=""><input name="region" type="text" style="width:98%" value=""  maxlength="200"></td> </tr><tr> <th>Contact information</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>Substitute</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (9,@tenant_id_value,'폼10','form10','<tr><th>성명</th><td id=\"writerName\" style=\"\"></td></tr><tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"4\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"> ~ <input type=\"text\" id=\"Edatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"></span></td></tr><tr> <th>연락처</th> <td id=\"mobile\" style=\"\"><input name=\"mobile\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"50\"></td> </tr><tr> <th>업무대리</th> <td id=\"bizsub\" style=\"\"><input name=\"bizsub\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"120\"></td></tr>','<tr><th>Name</th><td id="writerName" style=""></td></tr><tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="4"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~ <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly"></span></td></tr><tr> <th>Contact information</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr><tr> <th>Substitute</th> <td id="bizsub" style=""><input name="bizsub" type="text" style="width:98%" value=""  maxlength="120"></td></tr>');
INSERT INTO TBL_ATTITUDE_FORM (FORM_ID, TENANT_ID, FORM_NAME, FORM_NAME2, FORM_HTML, FORM_HTML2) VALUES (10,@tenant_id_value,'폼11','form11','<tr><th>성명</th><td id=\"writerName\" style=\"\"></td></tr><tr><th>일시 </th><td colspan=\"2\" id=\"attiTime\"><span id=\"periodblock\" datetype=\"3\"><input type=\"text\" id=\"Sdatepicker\" style=\"width:80px;text-align:center\" readonly=\"readonly\"><input id=\"Stimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /> ~<input id=\"Etimepicker\" type=\"text\" class=\"time\" style=\"width:43px;margin-left:10px;text-align:center;\" /></span></td></tr><tr> <th>연락처</th> <td id=\"mobile\" style=\"\"><input name=\"mobile\" type=\"text\" style=\"width:98%\" value=\"\"  maxlength=\"50\"></td> </tr>','<tr><th>Name</th><td id="writerName" style=""></td></tr><tr><th>Date </th><td colspan="2" id="attiTime"><span id="periodblock" datetype="3"><input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"><input id="Stimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /> ~<input id="Etimepicker" type="text" class="time" style="width:43px;margin-left:10px;text-align:center;" /></span></td></tr><tr> <th>Contact information</th> <td id="mobile" style=""><input name="mobile" type="text" style="width:98%" value=""  maxlength="50"></td> </tr>');

-- attitude conf
INSERT INTO TBL_ATTITUDE_CONF (COMPANY_ID, TENANT_ID, WORK_STARTTIME, WORK_ENDTIME, CLOSED_DAY, ATTITUDE_MOD_APPL, CLOSED_DATE_ATTITUDE, CONF_SET_DATE) VALUES ('Top',@tenant_id_value, '00:00', '09:00', '1,0,0,0,0,0,1', '1', '1', now());

-- attitude Type
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A01', 'Top',@tenant_id_value, '출근', 'check in', '1', 'inOut', null, 1);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A02', 'Top',@tenant_id_value, '지각', 'late', '1', 'inOut', null, 2);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A03', 'Top',@tenant_id_value, '퇴근', 'check out', '1', 'inOut', null, 3);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A07', 'Top',@tenant_id_value, '휴근', 'working Holiday', '1', 'inOut', null, 6);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A04', 'Top',@tenant_id_value, '외근', 'outside work', '1', 'trip', null, 8);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A06', 'Top',@tenant_id_value, '외출', 'outing', '1', 'trip', null, 6);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A05', 'Top',@tenant_id_value, '휴가', 'vacation', '1', 'refresh', null, 0);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A09', 'Top',@tenant_id_value, '출장', 'business trip', '1', 'trip', null, 7);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A10', 'Top',@tenant_id_value, '파견', 'dispatch', '1', 'trip', null, 7);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A08', 'Top',@tenant_id_value, '조퇴', 'early leave', '1', 'absence', null, 5);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A17', 'Top',@tenant_id_value, '결근', 'absenteeism', '1', 'absence', null, 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A11', 'Top',@tenant_id_value, '연차', 'annual leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A12', 'Top',@tenant_id_value, '오전반차', 'morning off', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A13', 'Top',@tenant_id_value, '오후반차', 'afternoon off', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A14', 'Top',@tenant_id_value, '공가', 'official leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A15', 'Top',@tenant_id_value, '오전공가', 'morning official leave', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A16', 'Top',@tenant_id_value, '오후공가', 'after official leave', '1', 'refresh', 'A05', 4);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A18', 'Top',@tenant_id_value, '산휴', 'maternity leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A19', 'Top',@tenant_id_value, '경조', 'congratulation and condolence leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A20', 'Top',@tenant_id_value, '병가', 'sick leave', '1', 'refresh', 'A05', 9);
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID) VALUES ('A21', 'Top',@tenant_id_value, '반반차', 'half off', '1', 'refresh', 'A05', 4);
		    		
-- ezPMS fixed holiday
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('신정', 'New Year''s Day', '01-01', 1, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('3·1절', 'Samiljeol', '03-01', 1, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('어린이날', 'Children''s Day', '05-05', 1, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('현충일', 'Memorial Day', '06-06', 1, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('광복절', 'National Liberation Day', '08-15', 1, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('개천절', 'Foundation Day', '10-03', 1, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('한글날', 'Hangul Proclamation Day', '10-09', 1, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('성탄절', 'Christmas', '12-25', 1, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('설날', 'Lunar New Year', '01-01', 2, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('설날', 'Lunar New Year', '01-02', 2, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('석가탄신일', 'Buddha''s Birthday', '04-08', 2, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('추석', 'Thanksgiving Day', '08-14', 2, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('추석', 'Thanksgiving Day', '08-15', 2, 'kor');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('추석', 'Thanksgiving Day', '08-16', 2, 'kor');

INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('元旦', '元旦', '01-01', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('元旦', '元旦', '01-01', 2, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('建国記念の日', '建国記念の日', '02-11', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('春分の日', '春分の日', '03-20', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('昭和の日', '昭和の日', '04-29', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('憲法記念日', '憲法記念日', '05-03', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('みどりの日', 'みどりの日', '05-04', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('こどもの日', 'こどもの日', '05-05', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('山の日', '山の日', '08-11', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('秋分の日', '秋分の日', '09-23', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('文化の日', '文化の日', '11-03', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('勤労感謝の日', '勤労感謝の日', '11-23', 1, 'jap');
INSERT INTO TBL_PMS_FIXEDHOLIDAY(HOLIDAY_NAME, HOLIDAY_NAME2, HOLIDAY, SOLARLUNAR, COUNTRY) VALUES ('天皇誕生日', '天皇誕生日', '12-23', 1, 'jap');

-- nonElecRec initData
Insert into TBL_FORMINFO (FORMCONTID,FORMID,FORMNAME,FORMNAME2,FORMDOCTYPE,FORMDESCRIPTION,FORMFILELOCATION,FORMCONNFLAG,FORMORDER,TENANT_ID,COMPANYID,FORMDRAFTALLFLAG) values ('2018000000','2018000000','비전자문서양식','비전자문서양식','003','비전자문서양식','/fileroot/0/files/upload_approvalG/Top/form/2018000000.hwp','N',null,@tenant_id_value,'Top','1');
Insert into TBL_FORMINFO (FORMCONTID,FORMID,FORMNAME,FORMNAME2,FORMDOCTYPE,FORMDESCRIPTION,FORMFILELOCATION,FORMCONNFLAG,FORMORDER,TENANT_ID,COMPANYID,FORMDRAFTALLFLAG) values ('2021000000','2021000000','비전자문서양식','비전자문서양식','003','비전자문서양식','/fileroot/0/files/upload_approvalG/Top/form/2021000000.mht','N',null,@tenant_id_value,'Top','1');

-- 날씨 도시 데이터
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('10','1832157','Reisui','여수','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('7','1833747','Ulsan','울산','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('2','1835235','Daejeon','대전','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('3','1835329','Daegu','대구','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('1','1835848','Seoul','서울','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('4','1838524','Busan','부산','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('9','1841811','Gwangju','광주','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('5','1843137','Kang-neung','강릉','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('6','1845136','Chuncheon','춘천','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('8','1845457','Jeonju','전주','1',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('11','1846266','Jeju','제주도','1',NULL,NULL);

-- 미국
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('1', '5128638', 'New York','뉴욕', 	'2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('2', '5186266', 'Dallas', '댈러스', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('3', '5186794', 'Denver', '댄버', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('4', '5368361', 'Los Angeles', '로스앤젤레스', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('5', '5664535', 'Manhattan', '맨해튼', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('6', '4930956', 'Boston', '보스턴', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('7', '5110253', 'Bronx', '브롱크스', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('8', '5110302', 'Brooklyn', '브루클린', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('9', '5392171', 'San Jose', '산호세', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('10', '4726311', 'San Diego', '샌디에이고', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('11', '4171771', 'San Antonio', '샌안토니오', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('12', '4887398', 'Chicago', '시카고', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('13', '4883772', 'Atlanta', '애틀랜타', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('14', '5016884', 'Austin', '오스틴', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('15', '4140963', 'Washington D.C.', '워싱턴 D.C.', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('16', '4188985', 'Columbus', '콜롬버스', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('17', '5133268', 'Queens', '퀸스', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('18', '4905873', 'Phoenix', '피닉스', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('19', '5131095', 'Philadelphia', '필라델피아', '2');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('20', '5194369', 'Houston', '휴스턴', '2');

-- 일본
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('1','1850147','Tokyo','東京','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('3','1853909','Osaka-shi','大阪市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('4','1854383','Okayama-shi','岡山市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('13','1855431','Niigata-shi','新潟市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('10','1856057','Nagoya-shi','名古屋市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('11','1856215','Nagano-shi','長野市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('5','1857910','Kyoto','京都市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('6','1860827','Kagoshima-shi','鹿児島市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('8','1862415','Hiroshima-shi','広島市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('7','1863967','Fukuoka-shi','福岡市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('9','1926099','Matsuyama-shi','松山市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('12','2112923','Fukushima-shi','福島市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('15','2128295','Sapporo-shi','札幌市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('14','2130658','Aomori-shi','青森市','3',NULL,NULL);
INSERT INTO `tbl_weather` (`SN`,`CITYCODE`,`CITYNAME`,`DISPLAYCITYNAME`,`PRIMARYLANG`,`CURRENTWEATHER`,`TODAYWEATHER`) VALUES ('2','6697514','Asahi','旭市','3',NULL,NULL);

-- 중국
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('1', '1809858', 'Guangzhou', '광저우', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('2', '1809461', 'Guiyang', '구이양', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('3', '1799869', 'Nanning', '난닝', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('4', '1799962', 'Nanjing', '난징', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('5', '1800163', 'Nanchang', '난창', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('6', '1804430', 'Lanzhou', '란저우', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('7', '1816670', 'Beijing', '베이징', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('8', '1796236', 'Shanghai', '상하이', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('9', '2034937', 'shenyang', '선양', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('10', '1795268', 'Shijiazhuang', '스자좡', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('11', '1805753', 'jinan', '지난', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('12', '1815549', 'changsha', '창사', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('13', '1815771', 'changchun', '창춘', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('14', '1815286', 'Chengdu', '청두', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('15', '1814906', 'chongqing', '충칭', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('16', '1804651', 'kunming', '쿤밍', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('17', '1810821', 'Fuzhou', '푸저우', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('18', '2037013', 'harbin', '하얼빈', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('19', '1808926', 'Hangzhou', '항저우', '4');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES('20', '1808722', 'Hefei', '허페이', '4');

-- 베트남
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('1', '1586203', 'Can Tho', '깐토', '5');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('2', '1568574', 'Kui bitch', '꾸이년', '5');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('3', '1572151', 'Nha Trang', '냐짱', '5');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('4', '1905468', 'Da Nang', '다낭', '5');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('5', '8201616', 'barbie', '바비', '5');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('6', '1587923', 'Bien Hoa', '비엔호아', '5');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('7', '1581130', 'Hanoi', '하노이', '5');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('8', '1581298', 'Haiphong', '하이퐁', '5');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('9', '1566083', 'ho chi minh', '호찌민', '5');
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('10', '1580240', 'Hue', '후에', '5');

-- 인도네시아
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('1', '1645528', 'denpasar', '덴파사르', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('2', '8144495', 'Depok', '드폭', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('3', '1622786', 'Makassar', '마카사르', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('4', '1214520', 'medan', '메단', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('5', '8144723', 'Batam', '바탐', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('6', '1624917', 'Bandar Lampung', '반다르람풍', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('7', '1650357', 'Bandung', '반둥', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('8', '1650213', 'Banjarmasin', '반자르마신', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('9', '7780016', 'Bogor', '보고르', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('10', '8018250', 'Surabaya', '수라바야', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('11', '1627896', 'semarang', '스마랑', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('12', '1651531', 'Ambon', '암본', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('13', '1642911', 'Jakarta', '자카르타', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('14', '1642858', 'Jambi', '잠비', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('15', '1625084', 'Tangerang', '탕에랑', 6);
INSERT INTO TBL_WEATHER(SN, CITYCODE, CITYNAME, DISPLAYCITYNAME, PRIMARYLANG) VALUES ('16', '1633070', 'Palembang', '팔렘방', 6);

-- 포탈 개인화
INSERT INTO TBL_PORTAL_THEME (theme_id, theme_name, theme_name2, theme_name3, theme_content, theme_content2, theme_content3, theme_content4, theme_content5, theme_content6) VALUES (1, '기본형', 'Default Type', 'きほんがた', '소식 및 상단영역이 있는 디자인의 테마입니다.', 'A theme with a design that includes news and a top area.', 'ニュースやトップエリアのあるデザインのテーマです。', '这是一个包含新闻和顶部区域的设计主题。', 'A theme with a design that includes news and a top area.', 'A theme with a design that includes news and a top area.');
INSERT INTO TBL_PORTAL_THEME (theme_id, theme_name, theme_name2, theme_name3, theme_content, theme_content2, theme_content3, theme_content4, theme_content5, theme_content6) VALUES (2, '바로가기형', 'Shortcut Type', 'ショートカットがた', '위쪽에 정보 및 바로가기가 있는 디자인의 테마입니다.', 'A theme with information and shortcuts at the top.', '上部に情報やショートカットがあるデザインのテーマです。', '该主题的设计在顶部包含信息和快捷方式。', 'A theme with information area and shortcuts at the top.', 'A theme with information area and shortcuts at the top.');
INSERT INTO TBL_PORTAL_THEME (theme_id, theme_name, theme_name2, theme_name3, theme_content, theme_content2, theme_content3, theme_content4, theme_content5, theme_content6) VALUES (3, '정보분리형', 'Information Separation Type', 'じょうほうぶんりがた', '정보 관련 고정영역이 없이 포틀릿에 집중할 수 있는 테마입니다.', 'A theme that allows to focus on portlets without any fixed areas related to information.', '情報関連の固定領域がなくてもポートレットに集中できるテーマです。', '该主题允许您专注于 portlet，而无需任何与信息相关的固定区域。', 'A theme that allows to focus on portlets without any fixed areas related to information.', 'A theme that allows to focus on portlets without any fixed areas related to information.');
-- 모바일 테마
INSERT INTO TBL_PORTAL_THEME (theme_id, theme_name, theme_name2, theme_name3, theme_content, theme_content2, theme_content3, theme_content4, theme_content5, theme_content6) VALUES (4, '테마4', 'Theme4', 'Theme4', '모바일용 포틀릿 테마 입니다.', 'Theme For Mobile', 'モバイルのテーマ', '手机主题', 'Theme For Mobile', 'Theme For Mobile');

INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (0, '/ezNewPortal/newPortalPortalPage.do', 'G', '', 0, 'portal');
UPDATE TBL_PORTAL_MENU SET menu_id = 0 WHERE menu_url = '/ezNewPortal/newPortalPortalPage.do';
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

INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (15, 4, '/ezNewPortal/getCustomBoardInfo.do', 'G', -2, 'fixLeft');
INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (16, 4, '/ezNewPortal/getCustomBoardInfo.do', 'G', -1, 'fixRight');
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
INSERT INTO TBL_PORTAL_THEME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, THEME_USED, THEME_DEFAULT) VALUES ('Top',@tenant_id_value, 1, 1, 1);
INSERT INTO TBL_PORTAL_THEME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, THEME_USED, THEME_DEFAULT) VALUES ('Top',@tenant_id_value, 2, 1, 0);
INSERT INTO TBL_PORTAL_THEME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, THEME_USED, THEME_DEFAULT) VALUES ('Top',@tenant_id_value, 3, 1, 0);

INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',@tenant_id_value, 1, 1, 1, 1);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',@tenant_id_value, 1, 2, 1, 0);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',@tenant_id_value, 1, 3, 1, 0);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',@tenant_id_value, 1, 4, 1, 0);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',@tenant_id_value, 2, 5, 1, 1);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',@tenant_id_value, 2, 7, 1, 0);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',@tenant_id_value, 3, 6, 1, 1);
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',@tenant_id_value, 3, 8, 1, 0);
-- 모바일 포틀릿
INSERT INTO TBL_PORTAL_FRAME_COMP (COMPANY_ID, TENANT_ID, THEME_ID, FRAME_ID, FRAME_USED, FRAME_DEFAULT) VALUES ('Top',@tenant_id_value, 4, 9, 1, 1);

INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 1, 1, 1, 1);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 2, 1, 1, 2);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 3, 1, 1, 3);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 4, 1, 1, 4);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 5, 1, 1, 5);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 6, 1, 1, 6);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 7, 1, 1, 7);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 8, 1, 1, 8);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 9, 1, 1, 9);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 10, 1, 1, 10);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 11, 1, 1, 11);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 12, 1, 1, 12);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 13, 1, 1, 13);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 14, 1, 1, 14);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 15, 1, 1, 15);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 16, 1, 1, 16);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 17, 1, 1, 17);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 18, 1, 1, 18);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 19, 1, 1, 19);
INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER) VALUES ('Top',@tenant_id_value, 20, 1, 1, 20);
				
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (0, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (1, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (2, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (3, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (4, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (5, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (6, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (7, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (8, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (9, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (10, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (11, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (12, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (13, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (14, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (15, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (16, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (17, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (18, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (19, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, sn) VALUES (20, 'Top',@tenant_id_value, 'Top', 1, 0, 1);

INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (1, 1, 'Top',@tenant_id_value, '메일');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (1, 2, 'Top',@tenant_id_value, 'Email');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (1, 3, 'Top',@tenant_id_value, 'メール');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (1, 4, 'Top',@tenant_id_value, '邮件');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (1, 5, 'Top',@tenant_id_value, 'Email');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (1, 6, 'Top',@tenant_id_value, 'Email');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (2, 1, 'Top',@tenant_id_value, '일정관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (2, 2, 'Top',@tenant_id_value, 'Schedule');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (2, 3, 'Top',@tenant_id_value, '日程管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (2, 4, 'Top',@tenant_id_value, '日程管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (2, 5, 'Top',@tenant_id_value, 'Schedule');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (2, 6, 'Top',@tenant_id_value, 'Schedule');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (3, 1, 'Top',@tenant_id_value, '전자결재');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (3, 2, 'Top',@tenant_id_value, 'Approval');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (3, 3, 'Top',@tenant_id_value, '電子決裁');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (3, 4, 'Top',@tenant_id_value, '电子审批');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (3, 5, 'Top',@tenant_id_value, 'Approval');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (3, 6, 'Top',@tenant_id_value, 'Approval');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (4, 1, 'Top',@tenant_id_value, '게시판');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (4, 2, 'Top',@tenant_id_value, 'Board');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (4, 3, 'Top',@tenant_id_value, '掲示板');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (4, 4, 'Top',@tenant_id_value, '公告栏');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (4, 5, 'Top',@tenant_id_value, 'Board');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (4, 6, 'Top',@tenant_id_value, 'Board');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (5, 1, 'Top',@tenant_id_value, '커뮤니티');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (5, 2, 'Top',@tenant_id_value, 'Community');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (5, 3, 'Top',@tenant_id_value, 'コミュニティ');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (5, 4, 'Top',@tenant_id_value, '社区');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (5, 5, 'Top',@tenant_id_value, 'Community');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (5, 6, 'Top',@tenant_id_value, 'Community');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (6, 1, 'Top',@tenant_id_value, '자원관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (6, 2, 'Top',@tenant_id_value, 'Resource');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (6, 3, 'Top',@tenant_id_value, '設備管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (6, 4, 'Top',@tenant_id_value, '资源管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (6, 5, 'Top',@tenant_id_value, 'Resource');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (6, 6, 'Top',@tenant_id_value, 'Resource');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (7, 1, 'Top',@tenant_id_value, '회람판');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (7, 2, 'Top',@tenant_id_value, 'Circular');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (7, 3, 'Top',@tenant_id_value, '回覧板');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (7, 4, 'Top',@tenant_id_value, '圆板');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (7, 5, 'Top',@tenant_id_value, 'Circular');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (7, 6, 'Top',@tenant_id_value, 'Circular');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (8, 1, 'Top',@tenant_id_value, '업무일지');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (8, 2, 'Top',@tenant_id_value, 'Journal');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (8, 3, 'Top',@tenant_id_value, 'ジャーナル');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (8, 4, 'Top',@tenant_id_value, '工作日志');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (8, 5, 'Top',@tenant_id_value, 'Journal');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (8, 6, 'Top',@tenant_id_value, 'Journal');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (9, 1, 'Top',@tenant_id_value, '근태관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (9, 2, 'Top',@tenant_id_value, 'Attendance');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (9, 3, 'Top',@tenant_id_value, '勤怠管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (9, 4, 'Top',@tenant_id_value, '考勤管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (9, 5, 'Top',@tenant_id_value, 'Attendance');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (9, 6, 'Top',@tenant_id_value, 'Attendance');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (10, 1, 'Top',@tenant_id_value, '웹폴더');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (10, 2, 'Top',@tenant_id_value, 'WebFolder');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (10, 3, 'Top',@tenant_id_value, 'Webフォルダ');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (10, 4, 'Top',@tenant_id_value, '网络文件夹');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (10, 5, 'Top',@tenant_id_value, 'WebFolder');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (10, 6, 'Top',@tenant_id_value, 'WebFolder');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (11, 1, 'Top',@tenant_id_value, '캐비넷');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (11, 2, 'Top',@tenant_id_value, 'Cabinet');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (11, 3, 'Top',@tenant_id_value, 'キャビネット');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (11, 4, 'Top',@tenant_id_value, '杂品柜');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (11, 5, 'Top',@tenant_id_value, 'Cabinet');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (11, 6, 'Top',@tenant_id_value, 'Cabinet');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (12, 1, 'Top',@tenant_id_value, '프로젝트관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (12, 2, 'Top',@tenant_id_value, 'PMS');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (12, 3, 'Top',@tenant_id_value, 'プロジェクト管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (12, 4, 'Top',@tenant_id_value, '项目管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (12, 5, 'Top',@tenant_id_value, 'PMS');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (12, 6, 'Top',@tenant_id_value, 'PMS');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (13, 1, 'Top',@tenant_id_value, '주소록');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (13, 2, 'Top',@tenant_id_value, 'Contacts');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (13, 3, 'Top',@tenant_id_value, 'アドレス帳');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (13, 4, 'Top',@tenant_id_value, '地址簿');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (13, 5, 'Top',@tenant_id_value, 'Contacts');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (13, 6, 'Top',@tenant_id_value, 'Contacts');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (14, 1, 'Top',@tenant_id_value, '설문조사');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (14, 2, 'Top',@tenant_id_value, 'Poll');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (14, 3, 'Top',@tenant_id_value, '電子アンケート');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (14, 4, 'Top',@tenant_id_value, '问卷调查');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (14, 5, 'Top',@tenant_id_value, 'Poll');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (14, 6, 'Top',@tenant_id_value, 'Poll');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (15, 1, 'Top',@tenant_id_value, '투표');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (15, 2, 'Top',@tenant_id_value, 'Vote');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (15, 3, 'Top',@tenant_id_value, '投票');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (15, 4, 'Top',@tenant_id_value, '投票');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (15, 5, 'Top',@tenant_id_value, 'Vote');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (15, 6, 'Top',@tenant_id_value, 'Vote');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (16, 1, 'Top',@tenant_id_value, '사다리게임');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (16, 2, 'Top',@tenant_id_value, 'LadderGame');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (16, 3, 'Top',@tenant_id_value, 'はしごゲーム');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (16, 4, 'Top',@tenant_id_value, '天梯游戏');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (16, 5, 'Top',@tenant_id_value, 'LadderGame');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (16, 6, 'Top',@tenant_id_value, 'LadderGame');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (17, 1, 'Top',@tenant_id_value, '업무관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (17, 2, 'Top',@tenant_id_value, 'Tasks');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (17, 3, 'Top',@tenant_id_value, 'タスク管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (17, 4, 'Top',@tenant_id_value, '工作管理');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (17, 5, 'Top',@tenant_id_value, 'Tasks');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (17, 6, 'Top',@tenant_id_value, 'Tasks');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (18, 1, 'Top',@tenant_id_value, '메모');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (18, 2, 'Top',@tenant_id_value, 'Notes');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (18, 3, 'Top',@tenant_id_value, 'メモ帳');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (18, 4, 'Top',@tenant_id_value, '记事本');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (18, 5, 'Top',@tenant_id_value, 'Notes');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (18, 6, 'Top',@tenant_id_value, 'Notes');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (19, 1, 'Top',@tenant_id_value, '전자설문');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (19, 2, 'Top',@tenant_id_value, 'Survey');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (19, 3, 'Top',@tenant_id_value, '電子アンケート');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (19, 4, 'Top',@tenant_id_value, '电子问卷');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (19, 5, 'Top',@tenant_id_value, 'Survey');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (19, 6, 'Top',@tenant_id_value, 'Survey');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (20, 1, 'Top',@tenant_id_value, '차량관리');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (20, 2, 'Top',@tenant_id_value, 'Car');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (20, 3, 'Top',@tenant_id_value, '自動車');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (20, 4, 'Top',@tenant_id_value, '自動車');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (20, 5, 'Top',@tenant_id_value, 'Car');
INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (20, 6, 'Top',@tenant_id_value, 'Car');

INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, CONNECTION_URL, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 15, 4, '/ezNewPortal/getCustomBoardInfo.do', 1, -2, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, CONNECTION_URL, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 16, 4, '/ezNewPortal/getCustomBoardInfo.do', 1, -1, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 1, 1, 1, 2, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 2, 4, 1, 1, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 4, 15, 1, 3, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 5, 0, 1, 4, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 6, 2, 1, 5, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 7, 3, 1, 6, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 8, 3, 1, 7, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 9, 4, 1, 8, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 10, 4, 1, 9, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 11, 5, 1, 10, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 12, 0, 1, 11, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 14, 0, 1, 13, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 26, 0, 1, 14, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 34, 0, 1, 15, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 36, 0, 1, 16, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 47, 4, 1, 17, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 49, 0, 1, 18, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 51, 6, 1, 21, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 70, 10, 1, 22, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 73, 19, 1, 20, null);
-- 모바일 포틀릿
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 76, 4, 1, 1, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 77, 4, 1, 2, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 78, 2, 1, 3, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 79, 6, 1, 4, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 80, 3, 1, 5, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 81, 1, 1, 6, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 82, 4, 1, 7, null);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 83, 4, 1, 8, null);
                
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (15, 4, 1, @tenant_id_value, 'Top', '고정 포틀릿');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (15, 4, 2, @tenant_id_value, 'Top', 'fixed portlet');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (15, 4, 3, @tenant_id_value, 'Top', '固定ポートレット');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (15, 4, 4, @tenant_id_value, 'Top', '固定门户组件');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (15, 4, 5, @tenant_id_value, 'Top', 'portlet cố định');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (15, 4, 6, @tenant_id_value, 'Top', 'portlet tetap');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (16, 4, 1, @tenant_id_value, 'Top', '고정 포틀릿');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (16, 4, 2, @tenant_id_value, 'Top', 'fixed portlet');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (16, 4, 3, @tenant_id_value, 'Top', '固定ポートレット');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (16, 4, 4, @tenant_id_value, 'Top', '固定门户组件');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (16, 4, 5, @tenant_id_value, 'Top', 'portlet cố định');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (16, 4, 6, @tenant_id_value, 'Top', 'portlet tetap');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (1, 1, 1, @tenant_id_value, 'Top', '받은 메일');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (1, 1, 2, @tenant_id_value, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (1, 1, 3, @tenant_id_value, 'Top', '受信トレイ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (1, 1, 4, @tenant_id_value, 'Top', '收件邮件');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (1, 1, 5, @tenant_id_value, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (1, 1, 6, @tenant_id_value, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (2, 4, 1, @tenant_id_value, 'Top', '공지사항');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (2, 4, 2, @tenant_id_value, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (2, 4, 3, @tenant_id_value, 'Top', 'お知らせ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (2, 4, 4, @tenant_id_value, 'Top', '公告');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (2, 4, 5, @tenant_id_value, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (2, 4, 6, @tenant_id_value, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (4, 15, 1, @tenant_id_value, 'Top', '투표');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (4, 15, 2, @tenant_id_value, 'Top', 'Vote');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (4, 15, 3, @tenant_id_value, 'Top', '投票');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (4, 15, 4, @tenant_id_value, 'Top', '投票');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (4, 15, 5, @tenant_id_value, 'Top', 'Vote');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (4, 15, 6, @tenant_id_value, 'Top', 'Vote');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (5, 0, 1, @tenant_id_value, 'Top', '빠른설문');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (5, 0, 2, @tenant_id_value, 'Top', 'Quick Poll');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (5, 0, 3, @tenant_id_value, 'Top', '簡単アンケート');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (5, 0, 4, @tenant_id_value, 'Top', '快速民意测验');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (5, 0, 5, @tenant_id_value, 'Top', 'Quick Poll');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (5, 0, 6, @tenant_id_value, 'Top', 'Quick Poll');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (6, 2, 1, @tenant_id_value, 'Top', '일정');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (6, 2, 2, @tenant_id_value, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (6, 2, 3, @tenant_id_value, 'Top', '日程');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (6, 2, 4, @tenant_id_value, 'Top', '附表');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (6, 2, 5, @tenant_id_value, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (6, 2, 6, @tenant_id_value, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (7, 3, 1, @tenant_id_value, 'Top', '결재리스트');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (7, 3, 2, @tenant_id_value, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (7, 3, 3, @tenant_id_value, 'Top', '電子決裁リスト');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (7, 3, 4, @tenant_id_value, 'Top', '批准名单');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (7, 3, 5, @tenant_id_value, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (7, 3, 6, @tenant_id_value, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (8, 3, 1, @tenant_id_value, 'Top', '즐겨찾기양식');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (8, 3, 2, @tenant_id_value, 'Top', 'Favorite Forms');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (8, 3, 3, @tenant_id_value, 'Top', 'お気に入り様式');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (8, 3, 4, @tenant_id_value, 'Top', '常用表格');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (8, 3, 5, @tenant_id_value, 'Top', 'Favorite Forms');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (8, 3, 6, @tenant_id_value, 'Top', 'Favorite Forms');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (9, 4, 1, @tenant_id_value, 'Top', '포토 갤러리');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (9, 4, 2, @tenant_id_value, 'Top', 'Photo Gallery');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (9, 4, 3, @tenant_id_value, 'Top', 'フォトギャラリー');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (9, 4, 4, @tenant_id_value, 'Top', '相片集');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (9, 4, 5, @tenant_id_value, 'Top', 'Photo Gallery');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (9, 4, 6, @tenant_id_value, 'Top', 'Photo Gallery');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (10, 4, 1, @tenant_id_value, 'Top', '즐겨찾기 게시판');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (10, 4, 2, @tenant_id_value, 'Top', 'Favorite Boards');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (10, 4, 3, @tenant_id_value, 'Top', 'お気に入り掲示板');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (10, 4, 4, @tenant_id_value, 'Top', '宠儿委员会');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (10, 4, 5, @tenant_id_value, 'Top', 'Favorite Boards');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (10, 4, 6, @tenant_id_value, 'Top', 'Favorite Boards');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (11, 5, 1, @tenant_id_value, 'Top', '커뮤니티');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (11, 5, 2, @tenant_id_value, 'Top', 'Community');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (11, 5, 3, @tenant_id_value, 'Top', 'コミュニティ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (11, 5, 4, @tenant_id_value, 'Top', '社区联络小组');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (11, 5, 5, @tenant_id_value, 'Top', 'Community');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (11, 5, 6, @tenant_id_value, 'Top', 'Community');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (12, 0, 1, @tenant_id_value, 'Top', '도움말');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (12, 0, 2, @tenant_id_value, 'Top', 'Help');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (12, 0, 3, @tenant_id_value, 'Top', 'ヘルプ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (12, 0, 4, @tenant_id_value, 'Top', '救命呀');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (12, 0, 5, @tenant_id_value, 'Top', 'Help');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (12, 0, 6, @tenant_id_value, 'Top', 'Help');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (14, 0, 1, @tenant_id_value, 'Top', '날씨');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (14, 0, 2, @tenant_id_value, 'Top', 'Weather');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (14, 0, 3, @tenant_id_value, 'Top', '天気');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (14, 0, 4, @tenant_id_value, 'Top', '天气');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (14, 0, 5, @tenant_id_value, 'Top', 'Weather');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (14, 0, 6, @tenant_id_value, 'Top', 'Weather');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (26, 0, 1, @tenant_id_value, 'Top', '생일자');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (26, 0, 2, @tenant_id_value, 'Top', 'birthday');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (26, 0, 3, @tenant_id_value, 'Top', '誕生者');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (26, 0, 4, @tenant_id_value, 'Top', '诞辰辰');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (26, 0, 5, @tenant_id_value, 'Top', 'birthday');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (26, 0, 6, @tenant_id_value, 'Top', 'birthday');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (34, 0, 1, @tenant_id_value, 'Top', '슬라이드 이미지');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (34, 0, 2, @tenant_id_value, 'Top', 'Slide Image');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (34, 0, 3, @tenant_id_value, 'Top', 'スライド画像');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (34, 0, 4, @tenant_id_value, 'Top', '幻灯片图像');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (34, 0, 5, @tenant_id_value, 'Top', 'Slide Image');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (34, 0, 6, @tenant_id_value, 'Top', 'Slide Image');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (36, 0, 1, @tenant_id_value, 'Top', '사용자 정보');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (36, 0, 2, @tenant_id_value, 'Top', 'user Info');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (36, 0, 3, @tenant_id_value, 'Top', 'ユーザ情報');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (36, 0, 4, @tenant_id_value, 'Top', '用户资料');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (36, 0, 5, @tenant_id_value, 'Top', 'user Info');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (36, 0, 6, @tenant_id_value, 'Top', 'user Info');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (47, 4, 1, @tenant_id_value, 'Top', '동영상 게시판');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (47, 4, 2, @tenant_id_value, 'Top', 'Movie Board');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (47, 4, 3, @tenant_id_value, 'Top', '動画掲示板');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (47, 4, 4, @tenant_id_value, 'Top', '电影展板');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (47, 4, 5, @tenant_id_value, 'Top', 'Movie Board');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (47, 4, 6, @tenant_id_value, 'Top', 'Movie Board');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (49, 0, 1, @tenant_id_value, 'Top', '카운트');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (49, 0, 2, @tenant_id_value, 'Top', 'Count');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (49, 0, 3, @tenant_id_value, 'Top', 'カウント');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (49, 0, 4, @tenant_id_value, 'Top', '数一数二');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (49, 0, 5, @tenant_id_value, 'Top', 'Count');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (49, 0, 6, @tenant_id_value, 'Top', 'Count');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (51, 6, 1, @tenant_id_value, 'Top', '자원관리');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (51, 6, 2, @tenant_id_value, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (51, 6, 3, @tenant_id_value, 'Top', '設備管理');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (51, 6, 4, @tenant_id_value, 'Top', '教学资源');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (51, 6, 5, @tenant_id_value, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (51, 6, 6, @tenant_id_value, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (70, 10, 1, @tenant_id_value, 'Top', '개인폴더');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (70, 10, 2, @tenant_id_value, 'Top', 'My Folder');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (70, 10, 3, @tenant_id_value, 'Top', 'Webフォルダ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (70, 10, 4, @tenant_id_value, 'Top', '个人文件夹');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (70, 10, 5, @tenant_id_value, 'Top', 'My Folder');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (70, 10, 6, @tenant_id_value, 'Top', 'My Folder');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (73, 19, 1, @tenant_id_value, 'Top', '전자설문');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (73, 19, 2, @tenant_id_value, 'Top', 'Survey');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (73, 19, 3, @tenant_id_value, 'Top', '電子アンケート');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (73, 19, 4, @tenant_id_value, 'Top', '电子问卷');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (73, 19, 5, @tenant_id_value, 'Top', 'Survey');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (73, 19, 6, @tenant_id_value, 'Top', 'Survey');
-- 모바일 포틀릿
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 1, @tenant_id_value, 'Top', '고정 포틀릿');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 2, @tenant_id_value, 'Top', 'fixed portlet');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 3, @tenant_id_value, 'Top', '固定ポートレット');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 4, @tenant_id_value, 'Top', '固定门户组件');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 5, @tenant_id_value, 'Top', 'portlet cố định');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (76, 4, 6, @tenant_id_value, 'Top', 'portlet tetap');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 1, @tenant_id_value, 'Top', '고정 포틀릿');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 2, @tenant_id_value, 'Top', 'fixed portlet');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 3, @tenant_id_value, 'Top', '固定ポートレット');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 4, @tenant_id_value, 'Top', '固定门户组件');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 5, @tenant_id_value, 'Top', 'portlet cố định');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (77, 4, 6, @tenant_id_value, 'Top', 'portlet tetap');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 1, @tenant_id_value, 'Top', '일정');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 2, @tenant_id_value, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 3, @tenant_id_value, 'Top', '日程');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 4, @tenant_id_value, 'Top', '附表');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 5, @tenant_id_value, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (78, 2, 6, @tenant_id_value, 'Top', 'Schedule');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 1, @tenant_id_value, 'Top', '자원관리');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 2, @tenant_id_value, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 3, @tenant_id_value, 'Top', '設備管理');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 4, @tenant_id_value, 'Top', '教学资源');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 5, @tenant_id_value, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (79, 6, 6, @tenant_id_value, 'Top', 'Resource');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 1, @tenant_id_value, 'Top', '결재리스트');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 2, @tenant_id_value, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 3, @tenant_id_value, 'Top', '電子決裁リスト');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 4, @tenant_id_value, 'Top', '批准名单');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 5, @tenant_id_value, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (80, 3, 6, @tenant_id_value, 'Top', 'Approval List');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 1, @tenant_id_value, 'Top', '받은 메일');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 2, @tenant_id_value, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 3, @tenant_id_value, 'Top', '受信トレイ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 4, @tenant_id_value, 'Top', '收件邮件');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 5, @tenant_id_value, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (81, 1, 6, @tenant_id_value, 'Top', 'Mail');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 1, @tenant_id_value, 'Top', '공지사항');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 2, @tenant_id_value, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 3, @tenant_id_value, 'Top', 'お知らせ');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 4, @tenant_id_value, 'Top', '公告');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 5, @tenant_id_value, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (82, 4, 6, @tenant_id_value, 'Top', 'Notice');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 1, @tenant_id_value, 'Top', '포토 갤러리');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 2, @tenant_id_value, 'Top', 'Photo Gallery');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 3, @tenant_id_value, 'Top', 'フォトギャラリー');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 4, @tenant_id_value, 'Top', '相片集');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 5, @tenant_id_value, 'Top', 'Photo Gallery');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (83, 4, 6, @tenant_id_value, 'Top', 'Photo Gallery');

INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 15, 1, -2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 15, 1, -2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 15, 1, -2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 16, 1, -1, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 16, 1, -1, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 16, 1, -1, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 1, 1, 1, 1, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 2, 1, 2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 4, 1, 3, 15, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 5, 1, 4, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 6, 1, 5, 2, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 7, 1, 6, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 8, 1, 7, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 9, 1, 8, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 10, 1, 9, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 11, 1, 10, 5, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 12, 1, 11, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 14, 1, 12, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 26, 1, 13, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 34, 1, 14, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 36, 1, 15, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 47, 1, 16, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 48, 1, 17, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 49, 1, 18, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 51, 1, 21, 6, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 70, 1, 22, 10, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 73, 1, 20, 19, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 1, 1, 1, 1, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 2, 1, 2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 4, 1, 3, 15, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 5, 1, 4, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 6, 1, 5, 2, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 7, 1, 6, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 8, 1, 7, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 9, 1, 8, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 10, 1, 9, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 11, 1, 10, 5, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 12, 1, 11, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 14, 1, 12, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 26, 1, 13, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 34, 1, 14, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 36, 1, 15, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 47, 1, 16, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 48, 1, 17, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 49, 1, 18, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 51, 1, 21, 6, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 70, 1, 22, 10, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 73, 1, 20, 19, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 1, 1, 1, 1, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 2, 1, 2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 4, 1, 3, 15, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 5, 1, 4, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 6, 1, 5, 2, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 7, 1, 6, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 8, 1, 7, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 9, 1, 8, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 10, 1, 9, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 11, 1, 10, 5, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 12, 1, 11, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 14, 1, 12, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 26, 1, 13, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 34, 1, 14, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 36, 1, 15, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 47, 1, 16, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 48, 1, 17, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 49, 1, 18, 0, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 51, 1, 21, 6, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 70, 1, 22, 10, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 73, 1, 20, 19, 0);
-- 모바일 포틀릿 
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, @tenant_id_value, 'Top', 76, 1, 1, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, @tenant_id_value, 'Top', 77, 1, 2, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, @tenant_id_value, 'Top', 78, 1, 3, 2, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, @tenant_id_value, 'Top', 79, 1, 4, 6, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, @tenant_id_value, 'Top', 80, 1, 5, 3, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, @tenant_id_value, 'Top', 81, 1, 6, 1, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, @tenant_id_value, 'Top', 82, 1, 7, 4, 0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, @tenant_id_value, 'Top', 83, 1, 8, 4, 0);
				
INSERT INTO TBL_PORTAL_THEME_AUTH (THEME_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (1, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_THEME_AUTH (THEME_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (2, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_THEME_AUTH (THEME_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (3, 'Top',@tenant_id_value, 'Top', 1, 0, 1);
INSERT INTO TBL_PORTAL_THEME_AUTH (THEME_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (4, 'Top',@tenant_id_value, 'Top', 1, 0, 1);

INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (15, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (16, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (1, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (2, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (4, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (5, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (6, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (7, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (8, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (9, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (10, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (11, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (12, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (14, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (26, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (34, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (36, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (47, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (49, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (51, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (70, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (73, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
-- 모바일 포틀릿 권한
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (76, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (77, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (78, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (79, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (80, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (81, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (82, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (83, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');

UPDATE TBL_CODELIST SET ISUSE = 1 WHERE CODE1 = 'A03' AND CODE2 = '005' AND TENANT_ID = @tenant_id_value AND COMPANYID = 'TOP';
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'absenceAllClear', 'NO', '부재설정 해제 팝업(전자결재화면로드시)에서 겸직부재설정까지 해제할지 여부 (default: NO)', '겸직일괄해제설정', TIMESTAMP '2020-12-09 20:30:53.000000', '전자결재G');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'serverName', 'jtest.kaoni.com', '모바일 결재시 메일 링크 주소값 (:portno)', '웹서버 네임', TIMESTAMP '2021-03-12 00:00:00.000000', '모바일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'useSusinSchedulerYn', '수신문서 전달 스케쥴러 사용여부', 'N', 'Y: 사용 N: 사용안함 (default: N)', '2021-03-02 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'useSusinSchedulerTime', '5', '스케쥴러 동작주기 분 (default: 5)', '수신문서 전달 스케쥴러 주기', '2021-03-03 00:00:00.000', '전자결재');
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('D24','001','','1','','문서24 URL','문서24 URL','문서24 URL','Top',@tenant_id_value);
INSERT INTO TBL_CODELIST (CODE1,CODE2,NAME,ISUSE,DESCRIPT,NAME2,NAME3,NAME4,COMPANYID, TENANT_ID) values ('D24','002','','1','','문서24 API_KEY','문서24 API_KEY','문서24 API_KEY','Top',@tenant_id_value);
INSERT INTO TBL_LISTOPTION
(LISTTYPE, SN, NAME, WIDTH, TABLENAME, COLNAME, COLALIAS, DTYPE, TYPEDESC, FIELDDESC, NAME2, NAME3, NAME4, DELFLAG, TENANT_ID, COMPANYID)
VALUES
('112', 1, '수신자', 200, NULL, 'RECEIPTDEPTNAME', NULL, NULL, '수신자', NULL, 'Receiver', '受信者' , '受信者', NULL,@tenant_id_value, 'Top'),
('112', 2, '상태', 100, NULL, 'STATUS', NULL, NULL, '상태', NULL, 'Status', 'ステータス', 'ステータス', NULL,@tenant_id_value, 'Top'),
('112', 3, '일자', 300, NULL, 'STATUSDATE', NULL, NULL, '일자', NULL, 'Date', '日付', '日付', NULL,@tenant_id_value, 'Top');

-- 2023.08.17 한슬기 전자결재 첨부파일 관련 config추가(해당 데이터는 ezFlow의 init 메서드에서 tenant_id = 0으로 넣어주고있으나, 멀티테넌트 사용을 위해 스크립트에 추가)
INSERT INTO tbl_tenant_config(TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE)
VALUES(@tenant_id_value, 'ApprAttachLimit', '10', 'MB 단위로 전자결재 일반 첨부파일 총합의 최대 크기를 지정한다. (default: 10)', '전자결재 일반 첨부파일 총합의 최대 크기', '2023-03-07 14:33:29.000', '전자결재');
INSERT INTO tbl_tenant_config(TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE)
VALUES(@tenant_id_value, 'ApprBigSizeAttachDownloadLimitCount', '0', '대용량첨부 다운로드 횟수 제한, 0일 경우 무제한 (default: 0)', '전자결재 대용량첨부 다운로드 횟수 제한', '2023-03-07 14:33:29.000', '전자결재');
INSERT INTO tbl_tenant_config(TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE)
VALUES(@tenant_id_value, 'ApprBigSizeAttachLimitCount', '0', '대용량첨부 개수 제한, 0일 경우 무제한 (default: 0)', '전자결재 대용량첨부 개수 제한', '2023-03-07 14:33:29.000', '전자결재');
INSERT INTO tbl_tenant_config(TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE)
VALUES(@tenant_id_value, 'BigSizeApprAttachDelDay', '14', '일 단위로 보존기간을 지정한다. 지정한 기간이 지나면 대용량 첨부파일을 삭제한다. (default: 14)', '전자결재 대용량 첨부파일 보존기간', '2023-03-07 14:33:29.000', '전자결재');
INSERT INTO tbl_tenant_config(TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE)
VALUES(@tenant_id_value, 'BigSizeApprAttachLimit', '800', 'MB 단위로 대용량 첨부파일의 최대 크기를 지정한다.0: 대용량 첨부파일 사용안함 (default: 800)', '전자결재 대용량 첨부파일 최대 크기', '2023-03-07 14:33:29.000', '전자결재');

INSERT INTO tbl_tenant_config(TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE)
VALUES(@tenant_id_value, 'useSecondaryLang', 'NO', '메일 부재설정회신, 용량 경고 메일 등 primarylang이 아닌 무조건 외국어 사용해야하는 컨피그', '제2 외국어 기본으로 사용여부', '2023-08-03 00:00:00.000', '메일');

-- 2023-09-06 김대현 init()으로 실행하여 생성되는 데이터 init_data에 넣어줌 
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value,'HwpSecurityNum','Kaoni2023!','hwp배포용 문서 비밀번호','hwp배포용 문서 비밀번호','2023-05-31 00:00:00','전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value,'useAdminIPAccess','NO','관리자 페이지 IP 제한(default: NO)','관리자 IP 제한','2020-04-27 00:00:00','시스템');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value,'useExternalMailServerPort','25','외부메일 서버 smtp 포트 (deafult:25)','외부메일 서버  smtp 포트 ','2021-03-29 00:00:00','메일');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value,'useHolidayCheckYN','0','0: 휴일 출/퇴근 체크 미사용, 1: 휴일 출/퇴근 체크 사용 (default: 0)','휴일 출/퇴근 체크 사용여부','2020-05-21 00:00:00','근태관리');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value,'useHwpDownSecurity','Y','Y: 사용 N: 사용안함 (default: Y)','통합pc저장, 메일 발송, 게시판 게시 시 hwp 결재파일 배포용 문서로 저장','2023-05-31 00:00:00','전자결재');

INSERT INTO TBL_PORTAL_PORTLET (PORTLET_ID, MENU_ID, PORTLET_URL, PORTLET_TYPE, DEFAULT_ORDER, PORTLETCODE) VALUES (74,3,'/ezNewPortal/chartPortlet.do','G',24,'chart');
INSERT INTO TBL_PORTAL_PORTLET (PORTLET_ID, MENU_ID, PORTLET_URL, PORTLET_TYPE, DEFAULT_ORDER, PORTLETCODE) VALUES (75,4,'/ezNewPortal/tabBoardPortlet.do','G',23,'tabBoard');

INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID, ISADD, ISDEL) VALUES ('A24','Top',@tenant_id_value,'대체휴무','alternate holiday','1','refresh','A05',9,'0','0');
INSERT INTO TBL_ATTITUDE_TYPE (TYPE_ID, COMPANY_ID, TENANT_ID, TYPE_NAME, TYPE_NAME2, ISUSE, IMG_PATH, PARENT_ID, FORM_ID, ISADD, ISDEL) VALUES ('A25','Top',@tenant_id_value,'퇴근','outCom','1','inOut',NULL,3,'0','0');

INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value,74,3,1,24,NULL);
INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value,75,4,1,23,NULL);

INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1,@tenant_id_value,'Top',74,1,24,3,0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1,@tenant_id_value,'Top',75,1,23,4,0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2,@tenant_id_value,'Top',74,1,24,3,0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2,@tenant_id_value,'Top',75,1,23,4,0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3,@tenant_id_value,'Top',74,1,24,3,0);
INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3,@tenant_id_value,'Top',75,1,23,4,0);

INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (74,3,'1',@tenant_id_value,'Top','전자문서 차트');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (74,3,'2',@tenant_id_value,'Top','chart');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (74,3,'3',@tenant_id_value,'Top','図表');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (74,3,'4',@tenant_id_value,'Top','图表');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (74,3,'5',@tenant_id_value,'Top','chart');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (74,3,'6',@tenant_id_value,'Top','chart');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (75,4,'1',@tenant_id_value,'Top','탭게시판');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (75,4,'2',@tenant_id_value,'Top','tabBoard');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (75,4,'3',@tenant_id_value,'Top','タブボード');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (75,4,'4',@tenant_id_value,'Top','标签板');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (75,4,'5',@tenant_id_value,'Top','tabBoard');
INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (75,4,'6',@tenant_id_value,'Top','tabBoard');

INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (74,'Top',@tenant_id_value,'Top',1,0,0);
INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN) VALUES (75,'Top',@tenant_id_value,'Top',1,0,0);

-- 모바일 외부메일 포틀릿 추가
-- INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (84, 1, '/mobile/ezNewPortal/receivedMailPortlet.do', 'MG', 6, 'mReceivedmail2');
-- INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 84, 1, 1, 9, null);
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 1, @tenant_id_value, 'Top', '외부 메일함');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 2, @tenant_id_value, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 3, @tenant_id_value, 'Top', '受信トレイ');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 4, @tenant_id_value, 'Top', '收件邮件');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 5, @tenant_id_value, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (84, 1, 6, @tenant_id_value, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (4, @tenant_id_value, 'Top', 84, 1, 9, 1, 0);
-- INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (84, 'Top',@tenant_id_value, 'Top', 1, 0, 1, 'Y');

-- 모바일 우측 탭 외부메일 버튼 추가
-- INSERT INTO TBL_PORTAL_MENU (menu_id, menu_url, menu_type, icon_url, default_order, menucode) VALUES (34, '/mobile/ezEmail/mailList.do?folderId=INBOX&mail2=Y', 'MG', 'iconCommon icon_outmail', 24, 'mMail');
-- INSERT INTO TBL_PORTAL_MENU_COMP (COMPANY_ID, TENANT_ID, MENU_ID, MENU_USED, COMPANY_LANG, COMPANY_ORDER, ICON_URL, OPENTYPE) VALUES ('8000',@tenant_id_value, 34, 1, 1, 22, 'iconCommon icon_outmail', 1);
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 1, '8000', 0, '외부메일');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 2, '8000', 0, 'E-Mail');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 3, '8000', 0, 'メール');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 4, '8000', 0, '邮件');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 5, '8000', 0, 'E-Mail');
-- INSERT INTO TBL_PORTAL_MENU_NAME (MENU_ID, MENU_LANG, COMPANY_ID, TENANT_ID, MENU_NAME) VALUES (34, 6, '8000', 0, 'E-Mail');
-- INSERT INTO TBL_PORTAL_MENU_AUTH (MENU_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (34, '8000', @tenant_id_value, '8000', 1, 0, 0, 'Y');

-- 포탈 외부메일 포틀릿 추가
-- INSERT INTO TBL_PORTAL_PORTLET (portlet_id, menu_id, portlet_url, portlet_type, default_order, portletcode) VALUES (20, 1, '/ezNewPortal/receivedMailPortlet2.do', 'G', 25, 'receivedmail2');
-- INSERT INTO TBL_PORTAL_PORTLET_COMP (COMPANY_ID, TENANT_ID, PORTLET_ID, MENU_ID, PORTLET_USED, PORTLET_ORDER, BOARD_ID) VALUES ('Top',@tenant_id_value, 20, 1, 1, 25, null);
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 1, @tenant_id_value, 'Top', '외부 메일함');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 2, @tenant_id_value, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 3, @tenant_id_value, 'Top', '受信トレイ');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 4, @tenant_id_value, 'Top', '收件邮件');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 5, @tenant_id_value, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_PORTLET_NAME (PORTLET_ID, MENU_ID, PORTLET_LANG, TENANT_ID, COMPANY_ID, PORTLET_NAME) VALUES (20, 1, 6, @tenant_id_value, 'Top', 'Mail');
-- INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (1, @tenant_id_value, 'Top', 20, 1, 25, 1, 0);
-- INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (2, @tenant_id_value, 'Top', 20, 1, 25, 1, 0);
-- INSERT INTO TBL_PORTAL_THEME_PORTLET (THEME_ID, TENANT_ID, COMPANY_ID, PORTLET_ID, PORTLET_USED, PORTLET_ORDER, MENU_ID, IS_FIXED) VALUES (3, @tenant_id_value, 'Top', 20, 1, 25, 1, 0);
-- INSERT INTO TBL_PORTAL_PORTLET_AUTH (PORTLET_ID, COMPANY_ID, TENANT_ID, USER_ID, ACCESS_YN, USER_TYPE, SN, SUBDEPT_PERMITTED) VALUES (20, 'Top', @tenant_id_value, 'Top', 1, 0, 1, 'Y');

INSERT INTO TBL_COMPANY_CONFIG (TENANT_ID, COMPANY_ID, PROPERTY_NAME, PROPERTY_VALUE) VALUES (@tenant_id_value, 'Top', 'useChkPrevPwd', 'NO'); 

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangTertiary1', '멀티언어1', '일본어', '시스템 언어에 따른 멀티언어 셋팅(일본어)', '2023-11-27 14:30:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangTertiary2', '멀티언어2', 'Japanese', '', '2023-11-27 14:30:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangTertiary3', '멀티언어3', '日本語', '', '2023-11-27 14:30:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangTertiary4', '멀티언어4', '日语', '', '2023-11-27 14:30:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangTertiary5', '멀티언어5', '', '', '2023-11-27 14:30:00', '일반');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangQuaternary1', '멀티언어1', '중문', '시스템 언어에 따른 멀티언어 셋팅(중국어)', '2023-11-27 14:30:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangQuaternary2', '멀티언어2', 'Chinese', '', '2023-11-27 14:30:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangQuaternary3', '멀티언어3', '中文', '', '2023-11-27 14:30:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangQuaternary4', '멀티언어4', '中文', '', '2023-11-27 14:30:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'LangQuaternary5', '멀티언어5', '', '', '2023-11-27 14:30:00', '일반');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'useOrganHideFlag', 'NO', '조직도 사용자,부서 숨김 기능의 사용 여부 YES: 사용 NO: 사용안함 (default)', '조직도 사용자,부서 숨김 기능', '2024-06-05 11:30:00', '조직도');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'useWorkspaceSchedule', '협업 일정 연동 여부', 'NO', 'YES: 사용 NO: 사용안함', '2024-05-22 00:00:00', '협업');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'delAttachByOthers', '0', '결재에서 첨부를 올린사람 이외의 사람도 삭제가능여부를  결정하는 테넌트 값(0 : 불가 1 : 허용), (default:0) ', '결재에서 첨부파일을 다른사람이 지울수있는 여부', '2021-03-05 00:00:00', '전자결재');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'useShowAuthCode', 'NO', 'SMS비밀번호 초기화기능에서 인증코드,임시비밀번호 표출 여부 YES: 사용 NO: 사용안함 (default)', '인증번호,임시비밀번호 표출여부', '2024-07-02 00:00:00', '로그인');

INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE) VALUES (@tenant_id_value, 'usePortletSize', 'Y', 'Y: 사용 N: 사용안함 (default: Y)', '포탈 포틀릿 커스텀 사이즈 사용 여부', '2023-11-20 00:00:00', '포탈');

INSERT INTO TBL_PORTAL_PORTLET_SIZE (SIZE_ID, CLASS_SIZE) VALUES (0, 'one_by_one');
INSERT INTO TBL_PORTAL_PORTLET_SIZE (SIZE_ID, CLASS_SIZE) VALUES (1, 'two_by_one');
INSERT INTO TBL_PORTAL_PORTLET_SIZE (SIZE_ID, CLASS_SIZE) VALUES (2, 'one_by_two');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'notiStoragePeriod', '통합알림 데이터 보관 기간', '10', '통합알림 데이터 보관 기간(default: 10)(일)', '2024-04-25 00:00:00', '통합알림');
INSERT INTO TBL_TENANT_CONFIG (TENANT_ID, PROPERTY_NAME, CONFIG_NAME, PROPERTY_VALUE, DESCRIPTION, REGDATE, CONFIG_TYPE) VALUES(@tenant_id_value, 'notiPollingInterval', '통합알림 데이터 새로고침 주기', '60000', '통합알림 데이터 새로고침 주기 설정(단위는 밀리초)', '2024-04-25 00:00:00', '통합알림');
--2023.09.11 - 한태훈 - 일정관리 > 미리알림 방식(닷넷 통합 알림, 자바 메일) 선택 테넌트 컨피그 추가
INSERT INTO TBL_TENANT_CONFIG(TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE)
VALUES(@tenant_id_value, 'useDotNetNoticeForReminder', 'NO', 'YES : 미리알림 기능 이용시 닷넷 통합알림 기능 사용, NO : 미리알림 기능 이용시 자바 메일 기능 사용(DEFAULT : NO); 닷넷 통합 알림 이용시 config.properties에 닷넷 통합알림 DB 접속 정보 기입', '미리알림 시 닷넷 알림 사용 여부', '2023-09-11 00:00:00.000', '일정관리');

--2023.09.11 - 한태훈 - 일정관리 > 미리알림 시 하루종일 일정의 시작 시각
INSERT INTO TBL_TENANT_CONFIG(TENANT_ID, PROPERTY_NAME, PROPERTY_VALUE, DESCRIPTION, CONFIG_NAME, REGDATE, CONFIG_TYPE)
VALUES(@tenant_id_value, 'allDaySTimeForReminder', '09:00', 'HH24:MM 형식으로 미리알림 시 하루종일 일정의 시작 시각 설정가능(MM은 00 또는 30만 가능)', '미리알림 시 하루종일 일정의 시작 시각 세팅', '2023-09-15 00:00:00.000', '일정관리');

INSERT INTO TBL_BOARD_ITEM_LISTOPTION (LISTTYPE, SN, NAME1, NAME2, NAME3, NAME4, COLNAME, WIDTH, VIEW_FG, TENANT_ID)
	VALUES
('E', 0, 'CHECK', 'CHECK', 'CHECK', 'CHECK', 'ITEMID', 20, 'Y', @tenant_id_value),
('E', 1, '첨부', 'Attachments', '添付', '附加', 'ATTACHMENTS', 30, 'Y', @tenant_id_value),
('E', 2, '게시판명', 'Board', '掲示板名', '布告板名称', 'BOARDNAME', 100, 'Y', @tenant_id_value),
('E', 3, '제목', 'Title', '件名', '标题', 'TITLE', 400, 'Y', @tenant_id_value),
('E', 4, '부서', 'Department', '部署', '部门', 'WRITERDEPTNAME', 100, 'Y', @tenant_id_value),
('E', 5, '게시자', 'Writer', '作成者', '写作者', 'WRITERNAME', 100, 'Y', @tenant_id_value),
('E', 6, '게시일', 'Registered', '掲示日', '发布日期', 'WRITEDATE', 100, 'Y', @tenant_id_value),
('E', 7, '조회수', 'View', 'ヒット数', '查询数', 'READCOUNT', 50, 'Y', @tenant_id_value);

INSERT INTO TBL_BOARD_BOARDINFO	(BOARDID, BOARDNAME, BOARDNAME2, BOARDNAME3, BOARDNAME4, TREEVIEWORDER, BOARDLEVEL, PARENTBOARDID, BOARDDESCRIPTION, ITEMEXPIRES, ATTACHSIZELIMIT, REPLYNOTIFY, BOARDGROUPID, ALERTPOSTITEM, GUBUN, URL, DELETEAFTER, BOARDCOLOR, BOARDNO, PORTLET, TENANT_ID, COMPANYID) VALUES ('{ZZZZZZZZ-ZZZZ-ZZZZ-ZZZZ-ZZZZZZZZZZZZ}', '전체게시물', 'ALL BoardItem', '全ての投稿 ', '所有帖子',  -3, 0, 'None', NULL, 0, NULL, 0, NULL, 0, 0, NULL, 0, NULL, 0, 'N', @tenant_id_value, 'Top');

INSERT INTO TBL_WEATHER_CITY VALUES (1832157, '여수', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1832157, 'Reisui', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1832157, 'ヨス', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1832157, '呂秀', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1832157, 'Reisui', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1832157, 'Reisui', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1833747, '울산', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1833747, 'Ulsan', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1833747, 'ウルサン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1833747, '蔚山', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1833747, 'Ulsan', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1833747, 'Ulsan', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1835235, '대전', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1835235, 'Daejeon', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1835235, 'テジョン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1835235, '大田', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1835235, 'Daejeon', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1835235, 'Daejeon', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1835329, '대구', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1835329, 'Daegu', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1835329, 'テグ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1835329, '大邱', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1835329, 'Daegu', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1835329, 'Daegu', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1835848, '서울', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1835848, 'Seoul', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1835848, 'ソウル', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1835848, '首爾', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1835848, 'Seoul', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1835848, 'Seoul', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1838524, '부산', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1838524, 'Busan', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1838524, 'プサン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1838524, '屍速列車', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1838524, 'Busan', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1838524, 'Busan', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1841811, '광주', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1841811, 'Gwangju', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1841811, 'クァンジュ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1841811, '光州', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1841811, 'Gwangju', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1841811, 'Gwangju', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1843137, '강릉', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1843137, 'Kang-neung', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1843137, 'カンヌン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1843137, '江陵', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1843137, 'Kang-neung', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1843137, 'Kang-neung', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1845136, '춘천', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1845136, 'Chuncheon', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1845136, 'ツンチョン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1845136, '春千', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1845136, 'Chuncheon', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1845136, 'Chuncheon', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1845457, '전주', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1845457, 'Jeonju', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1845457, 'ジョンジュ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1845457, '全州', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1845457, 'Jeonju', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1845457, 'Jeonju', 6);

INSERT INTO TBL_WEATHER_CITY VALUES (1846266, '제주도', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1846266, 'Jeju', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1846266, 'チェジュド', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1846266, '濟州島', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1846266, 'Jeju', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1846266, 'Jeju', 6);

/* [ USA ] */
-- 뉴욕
INSERT INTO TBL_WEATHER_CITY VALUES (5128638, '뉴욕', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5128638, 'New York', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5128638, 'ニュヨク', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5128638, '紐約', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5128638, 'New York', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5128638, 'New York', 6);

-- 댈러스
INSERT INTO TBL_WEATHER_CITY VALUES (5186266, '댈러스', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5186266, 'Dallas', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5186266, 'デルロス', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5186266, '達拉斯', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5186266, 'Dallas', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5186266, 'Dallas', 6);

-- 덴버
INSERT INTO TBL_WEATHER_CITY VALUES (5186794, '덴버', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5186794, 'Denver', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5186794, 'デンボ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5186794, '丹佛', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5186794, 'Denver', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5186794, 'Denver', 6);

-- 로스앤젤레스
INSERT INTO TBL_WEATHER_CITY VALUES (5368361, '로스앤젤레스', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5368361, 'Los Angeles', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5368361, 'ロスエンゼルレス', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5368361, '洛杉磯', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5368361, 'Los Angeles', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5368361, 'Los Angeles', 6);

-- 맨해튼
INSERT INTO TBL_WEATHER_CITY VALUES (5664535, '맨해튼', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5664535, 'Manhattan', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5664535, 'メンヘトゥン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5664535, '曼哈頓', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5664535, 'Manhattan', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5664535, 'Manhattan', 6);

-- 보스턴
INSERT INTO TBL_WEATHER_CITY VALUES (4930956, '보스턴', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (4930956, 'Boston', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (4930956, 'ボストン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (4930956, '波士頓', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (4930956, 'Boston', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (4930956, 'Boston', 6);

-- 브롱크스
INSERT INTO TBL_WEATHER_CITY VALUES (5110253, '브롱크스', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5110253, 'Bronx', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5110253, 'ブロンクス', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5110253, '布朗克斯', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5110253, 'Bronx', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5110253, 'Bronx', 6);

-- 브루클린
INSERT INTO TBL_WEATHER_CITY VALUES (5110302, '브루클린', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5110302, 'Brooklyn', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5110302, 'ブルクルリン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5110302, '布魯克林', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5110302, 'Brooklyn', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5110302, 'Brooklyn', 6);

-- 산호세
INSERT INTO TBL_WEATHER_CITY VALUES (5392171, '산호세', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5392171, 'San Jose', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5392171, 'サンホセ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5392171, '聖荷西', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5392171, 'San Jose', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5392171, 'San Jose', 6);

-- 샌디에이고
INSERT INTO TBL_WEATHER_CITY VALUES (4726311, '샌디에이고', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (4726311, 'San Diego', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (4726311, 'センディエイゴ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (4726311, '聖地牙哥', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (4726311, 'San Diego', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (4726311, 'San Diego', 6);

-- 샌안토니오
INSERT INTO TBL_WEATHER_CITY VALUES (4171771, '샌안토니오', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (4171771, 'San Antonio', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (4171771, 'センアントニオ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (4171771, '聖安東尼奧', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (4171771, 'San Antonio', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (4171771, 'San Antonio', 6);

-- 시카고
INSERT INTO TBL_WEATHER_CITY VALUES (4887398, '시카고', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (4887398, 'Chicago', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (4887398, 'シカゴ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (4887398, '芝加哥', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (4887398, 'Chicago', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (4887398, 'Chicago', 6);

-- 애틀랜타
INSERT INTO TBL_WEATHER_CITY VALUES (4883772, '애틀랜타', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (4883772, 'Atlanta', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (4883772, 'エトゥルレンタ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (4883772, '亞特蘭大', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (4883772, 'Atlanta', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (4883772, 'Atlanta', 6);

-- 오스틴
INSERT INTO TBL_WEATHER_CITY VALUES (5016884, '오스틴', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5016884, 'Austin', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5016884, 'オスティン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5016884, '奧斯汀', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5016884, 'Austin', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5016884, 'Austin', 6);

-- 워싱턴 D.C.
INSERT INTO TBL_WEATHER_CITY VALUES (4140963, '워싱턴 D.C.', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (4140963, 'Washington D.C.', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (4140963, 'ウォシントン　d。c。', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (4140963, '워싱턴 D.C.', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (4140963, 'Washington D.C.', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (4140963, 'Washington D.C.', 6);

-- 콜롬버스
INSERT INTO TBL_WEATHER_CITY VALUES (4188985, '콜롬버스', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (4188985, 'Columbus', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (4188985, 'コルロムボス', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (4188985, '哥倫布', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (4188985, 'Columbus', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (4188985, 'Columbus', 6);

-- 퀸스
INSERT INTO TBL_WEATHER_CITY VALUES (5133268, '퀸스', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5133268, 'Queens', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5133268, 'クィンス', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5133268, '皇后區', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5133268, 'Queens', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5133268, 'Queens', 6);

-- 피닉스
INSERT INTO TBL_WEATHER_CITY VALUES (4905873, '피닉스', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (4905873, 'Phoenix', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (4905873, 'ピニクス', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (4905873, '鳳凰', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (4905873, 'Phoenix', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (4905873, 'Phoenix', 6);

-- 필라델피아
INSERT INTO TBL_WEATHER_CITY VALUES (5131095, '필라델피아', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5131095, 'Philadelphia', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5131095, 'ピルラデルピア', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5131095, '費城', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5131095, 'Philadelphia', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5131095, 'Philadelphia', 6);

-- 휴스턴
INSERT INTO TBL_WEATHER_CITY VALUES (5194369, '휴스턴', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (5194369, 'Houston', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (5194369, 'ヒュストン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (5194369, '休士頓', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (5194369, 'Houston', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (5194369, 'Houston', 6);



/* [ Japan ] */
-- 도쿄
INSERT INTO TBL_WEATHER_CITY VALUES (1850147, '도쿄', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1850147, 'Tokyo', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1850147, '東京', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1850147, '東京', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1850147, 'Tokyo', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1850147, 'Tokyo', 6);

-- 오사카
INSERT INTO TBL_WEATHER_CITY VALUES (1853909, '오사카', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1853909, 'Osaka-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1853909, '大阪市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1853909, '大阪市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1853909, 'Osaka-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1853909, 'Osaka-shi', 6);

-- 오카야마
INSERT INTO TBL_WEATHER_CITY VALUES (1854383, '오카야마', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1854383, 'Okayama-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1854383, '岡山市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1854383, '岡山市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1854383, 'Okayama-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1854383, 'Okayama-shi', 6);

-- 니가타
INSERT INTO TBL_WEATHER_CITY VALUES (1855431, '니가타', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1855431, 'Niigata-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1855431, '新潟市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1855431, '新潟市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1855431, 'Niigata-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1855431, 'Niigata-shi', 6);

-- 나고야
INSERT INTO TBL_WEATHER_CITY VALUES (1856057, '나고야', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1856057, 'Nagoya-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1856057, '名古屋市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1856057, '名古屋市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1856057, 'Nagoya-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1856057, 'Nagoya-shi', 6);

-- 교토
INSERT INTO TBL_WEATHER_CITY VALUES (1857910, '교토', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1857910, 'Kyoto', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1857910, '京都市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1857910, '京都市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1857910, 'Kyoto', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1857910, 'Kyoto', 6);

-- 가고시마
INSERT INTO TBL_WEATHER_CITY VALUES (1860827, '가고시마', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1860827, 'Kagoshima-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1860827, '鹿児島市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1860827, '鹿兒島市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1860827, 'Kagoshima-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1860827, 'Kagoshima-shi', 6);

-- 히로시마
INSERT INTO TBL_WEATHER_CITY VALUES (1862415, '히로시마', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1862415, 'Hiroshima-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1862415, '広島市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1862415, '廣島市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1862415, 'Hiroshima-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1862415, 'Hiroshima-shi', 6);

-- 후쿠오카
INSERT INTO TBL_WEATHER_CITY VALUES (1863967, '후쿠오카', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1863967, 'Fukuoka-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1863967, '福岡市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1863967, '福岡市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1863967, 'Fukuoka-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1863967, 'Fukuoka-shi', 6);

-- 마츠야마
INSERT INTO TBL_WEATHER_CITY VALUES (1926099, '마츠야마', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1926099, 'Matsuyama-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1926099, '松山市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1926099, '松山市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1926099, 'Matsuyama-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1926099, 'Matsuyama-shi', 6);

-- 후쿠시마
INSERT INTO TBL_WEATHER_CITY VALUES (2112923, '후쿠시마', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (2112923, 'Fukushima-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (2112923, '福島市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (2112923, '福島市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (2112923, 'Fukushima-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (2112923, 'Fukushima-shi', 6);

-- 삿포로
INSERT INTO TBL_WEATHER_CITY VALUES (2128295, '삿포로', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (2128295, 'Sapporo-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (2128295, '札幌市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (2128295, '札幌市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (2128295, 'Sapporo-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (2128295, 'Sapporo-shi', 6);

-- 아오모리
INSERT INTO TBL_WEATHER_CITY VALUES (2130658, '아모리', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (2130658, 'Aomori-shi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (2130658, '青森市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (2130658, '青森市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (2130658, 'Aomori-shi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (2130658, 'Aomori-shi', 6);

-- 아사이
INSERT INTO TBL_WEATHER_CITY VALUES (6697514, '아사이', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (6697514, 'Asahi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (6697514, '旭市', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (6697514, '朝日', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (6697514, 'Asahi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (6697514, 'Asahi', 6);



/* [ China ] */
-- 광저우
INSERT INTO TBL_WEATHER_CITY VALUES (1809858, '광저우', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1809858, 'Guangzhou', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1809858, 'グァンゾウ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1809858, '廣州', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1809858, 'Guangzhou', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1809858, 'Guangzhou', 6);

-- 구이양
INSERT INTO TBL_WEATHER_CITY VALUES (1809461, '구이양', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1809461, 'Guiyang', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1809461, 'グイヤン', 3);
    INSERT INTO TBL_WEATHER_CITY VALUES (1809461, '貴陽', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1809461, 'Guiyang', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1809461, 'Guiyang', 6);

-- 난닝
INSERT INTO TBL_WEATHER_CITY VALUES (1799869, '난닝', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1799869, 'Nanning', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1799869, 'ナンニン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1799869, '南寧', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1799869, 'Nanning', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1799869, 'Nanning', 6);

-- 난징
INSERT INTO TBL_WEATHER_CITY VALUES (1799962, '난징', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1799962, 'Nanjing', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1799962, 'ナンジン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1799962, '南京', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1799962, 'Nanjing', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1799962, 'Nanjing', 6);

-- 난창
INSERT INTO TBL_WEATHER_CITY VALUES (1800163, '난창', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1800163, 'Nanchang', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1800163, 'ナン차ン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1800163, '南昌', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1800163, 'Nanchang', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1800163, 'Nanchang', 6);

-- 란저우
INSERT INTO TBL_WEATHER_CITY VALUES (1804430, '란저우', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1804430, 'Lanzhou', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1804430, 'ランゾウ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1804430, '蘭州', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1804430, 'Lanzhou', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1804430, 'Lanzhou', 6);

-- 베이징
INSERT INTO TBL_WEATHER_CITY VALUES (1816670, '베이징', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1816670, 'Beijing', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1816670, 'ベイジン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1816670, '北京', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1816670, 'Beijing', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1816670, 'Beijing', 6);

-- 상하이
INSERT INTO TBL_WEATHER_CITY VALUES (1796236, '상하이', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1796236, 'Shanghai', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1796236, 'サンハイ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1796236, '上海', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1796236, 'Shanghai', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1796236, 'Shanghai', 6);

-- 선양
INSERT INTO TBL_WEATHER_CITY VALUES (2034937, '선양', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (2034937, 'shenyang', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (2034937, 'ソンヤン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (2034937, '瀋陽', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (2034937, 'shenyang', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (2034937, 'shenyang', 6);

-- 스자좡
INSERT INTO TBL_WEATHER_CITY VALUES (1795268, '스자좡', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1795268, 'Shijiazhuang', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1795268, 'スザズァン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1795268, '石家莊', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1795268, 'Shijiazhuang', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1795268, 'Shijiazhuang', 6);

-- 지난
INSERT INTO TBL_WEATHER_CITY VALUES (1805753, '지난', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1805753, 'jinan', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1805753, 'ジナン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1805753, '濟南', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1805753, 'jinan', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1805753, 'jinan', 6);

-- 창사
INSERT INTO TBL_WEATHER_CITY VALUES (1815549, '창사', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1815549, 'changsha', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1815549, '차ンサ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1815549, '長沙', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1815549, 'changsha', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1815549, 'changsha', 6);

-- 창춘
INSERT INTO TBL_WEATHER_CITY VALUES (1815771, '창춘', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1815771, 'changchun', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1815771, '차ンツン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1815771, '長春', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1815771, 'changchun', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1815771, 'changchun', 6);

-- 청두
INSERT INTO TBL_WEATHER_CITY VALUES (1815286, '청두', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1815286, 'Chengdu', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1815286, 'チョンドゥ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1815286, '成都', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1815286, 'Chengdu', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1815286, 'Chengdu', 6);

-- 충칭
INSERT INTO TBL_WEATHER_CITY VALUES (1814906, '충칭', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1814906, 'chongqing', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1814906, 'ツンチン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1814906, '重慶', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1814906, 'chongqing', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1814906, 'chongqing', 6);

-- 쿤밍
INSERT INTO TBL_WEATHER_CITY VALUES (1804651, '쿤밍', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1804651, 'kunming', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1804651, 'クンミン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1804651, '昆明', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1804651, 'kunming', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1804651, 'kunming', 6);

-- 푸저우
INSERT INTO TBL_WEATHER_CITY VALUES (1810821, '푸저우', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1810821, 'Fuzhou', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1810821, 'プゾウ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1810821, '福州', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1810821, 'Fuzhou', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1810821, 'Fuzhou', 6);

-- 하얼빈
INSERT INTO TBL_WEATHER_CITY VALUES (2037013, '하얼빈', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (2037013, 'harbin', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (2037013, 'ハオルビン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (2037013, '哈爾濱', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (2037013, 'harbin', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (2037013, 'harbin', 6);

-- 항저우
INSERT INTO TBL_WEATHER_CITY VALUES (1808926, '항저우', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1808926, 'Hangzhou', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1808926, 'ハンゾウ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1808926, '杭州', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1808926, 'Hangzhou', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1808926, 'Hangzhou', 6);

-- 허페이
INSERT INTO TBL_WEATHER_CITY VALUES (1808722, '허페이', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1808722, 'Hefei', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1808722, 'ホペイ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1808722, '合肥', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1808722, 'Hefei', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1808722, 'Hefei', 6);



/* [ Vietnam ] */
-- 깐토
INSERT INTO TBL_WEATHER_CITY VALUES (1586203, '깐토', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1586203, 'Can Tho', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1586203, 'カント', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1586203, '芹苴', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1586203, 'Can Tho', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1586203, 'Can Tho', 6);

-- 꾸이년
INSERT INTO TBL_WEATHER_CITY VALUES (1568574, '꾸이년', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1568574, 'Kui bitch', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1568574, 'クイニョン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1568574, '奎母狗', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1568574, 'Kui bitch', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1568574, 'Kui bitch', 6);

-- 냐짱
INSERT INTO TBL_WEATHER_CITY VALUES (1572151, '냐짱', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1572151, 'Nha Trang', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1572151, 'ニャ차ン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1572151, '芽莊', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1572151, 'Nha Trang', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1572151, 'Nha Trang', 6);

-- 다낭
INSERT INTO TBL_WEATHER_CITY VALUES (1905468, '다낭', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1905468, 'Da Nang', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1905468, 'ダナン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1905468, '峴港', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1905468, 'Da Nang', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1905468, 'Da Nang', 6);

-- 바비
INSERT INTO TBL_WEATHER_CITY VALUES (8201616, '바비', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (8201616, 'barbie', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (8201616, 'バビ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (8201616, '芭比', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (8201616, 'barbie', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (8201616, 'barbie', 6);

-- 비엔호아
INSERT INTO TBL_WEATHER_CITY VALUES (1587923, '비엔호아', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1587923, 'Bien Hoa', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1587923, 'ビエンホア', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1587923, '邊和', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1587923, 'Bien Hoa', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1587923, 'Bien Hoa', 6);

-- 하노이
INSERT INTO TBL_WEATHER_CITY VALUES (1581130, '하노이', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1581130, 'Hanoi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1581130, 'ハノイ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1581130, '河內', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1581130, 'Hanoi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1581130, 'Hanoi', 6);

-- 하이퐁
INSERT INTO TBL_WEATHER_CITY VALUES (1581298, '하이퐁', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1581298, 'Haiphong', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1581298, 'ハイポン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1581298, '海防市', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1581298, 'Haiphong', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1581298, 'Haiphong', 6);

-- 호찌민
INSERT INTO TBL_WEATHER_CITY VALUES (1566083, '호찌민', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1566083, 'ho chi minh', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1566083, 'ホチミン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1566083, '胡志明', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1566083, 'ho chi minh', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1566083, 'ho chi minh', 6);

-- 후에
INSERT INTO TBL_WEATHER_CITY VALUES (1580240, '후에', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1580240, 'Hue', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1580240, 'フエ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1580240, '色調', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1580240, 'Hue', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1580240, 'Hue', 6);



/* [ Indonesia ] */
-- 덴파사르
INSERT INTO TBL_WEATHER_CITY VALUES (1645528, '덴파사르', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1645528, 'denpasar', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1645528, 'デンパサル', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1645528, '登巴薩', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1645528, 'denpasar', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1645528, 'denpasar', 6);

-- 드폭
INSERT INTO TBL_WEATHER_CITY VALUES (8144495, '드폭', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (8144495, 'Depok', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (8144495, 'ドゥポク', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (8144495, '德波克', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (8144495, 'Depok', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (8144495, 'Depok', 6);

-- 마카사르
INSERT INTO TBL_WEATHER_CITY VALUES (1622786, '마카사르', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1622786, 'Makassar', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1622786, 'マカサル', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1622786, '望加錫', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1622786, 'Makassar', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1622786, 'Makassar', 6);

-- 메단
INSERT INTO TBL_WEATHER_CITY VALUES (1214520, '메단', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1214520, 'medan', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1214520, 'メダン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1214520, '棉蘭', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1214520, 'medan', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1214520, 'medan', 6);

-- 바탐
INSERT INTO TBL_WEATHER_CITY VALUES (8144723, '바탐', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (8144723, 'Batam', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (8144723, 'バタム', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (8144723, '巴淡島', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (8144723, 'Batam', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (8144723, 'Batam', 6);

-- 반다르람풍
INSERT INTO TBL_WEATHER_CITY VALUES (1624917, '반다르람풍', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1624917, 'Bandar Lampung', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1624917, 'バンダルラムプン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1624917, '班達楠榜', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1624917, 'Bandar Lampung', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1624917, 'Bandar Lampung', 6);

-- 반둥
INSERT INTO TBL_WEATHER_CITY VALUES (1650357, '반둥', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1650357, 'Bandung', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1650357, 'バンドゥン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1650357, '萬隆', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1650357, 'Bandung', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1650357, 'Bandung', 6);

-- 반자르마신
INSERT INTO TBL_WEATHER_CITY VALUES (1650213, '반자르마신', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1650213, 'Banjarmasin', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1650213, 'バンザルマシン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1650213, '馬辰', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1650213, 'Banjarmasin', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1650213, 'Banjarmasin', 6);

-- 보고르
INSERT INTO TBL_WEATHER_CITY VALUES (7780016, '보고르', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (7780016, 'Bogor', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (7780016, 'ボゴル', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (7780016, '茂物', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (7780016, 'Bogor', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (7780016, 'Bogor', 6);

-- 수라바야
INSERT INTO TBL_WEATHER_CITY VALUES (8018250, '수라바야', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (8018250, 'Surabaya', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (8018250, 'スラバヤ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (8018250, '泗水', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (8018250, 'Surabaya', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (8018250, 'Surabaya', 6);

-- 스마랑
INSERT INTO TBL_WEATHER_CITY VALUES (1627896, '스마랑', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1627896, 'semarang', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1627896, 'スマラン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1627896, '三寶壟', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1627896, 'semarang', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1627896, 'semarang', 6);

-- 암본
INSERT INTO TBL_WEATHER_CITY VALUES (1651531, '암본', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1651531, 'Ambon', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1651531, 'アムボン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1651531, '安汶', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1651531, 'Ambon', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1651531, 'Ambon', 6);

-- 자카르타
INSERT INTO TBL_WEATHER_CITY VALUES (1642911, '자카르타', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1642911, 'Jakarta', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1642911, 'ザカルタ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1642911, '雅加達', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1642911, 'Jakarta', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1642911, 'Jakarta', 6);

-- 잠비
INSERT INTO TBL_WEATHER_CITY VALUES (1642858, '잠비', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1642858, 'Jambi', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1642858, 'ザムビ', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1642858, '佔碑', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1642858, 'Jambi', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1642858, 'Jambi', 6);

-- 탕에랑
INSERT INTO TBL_WEATHER_CITY VALUES (1625084, '탕에랑', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1625084, 'Tangerang', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1625084, 'タンエラン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1625084, '坦格朗', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1625084, 'Tangerang', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1625084, 'Tangerang', 6);

-- 팔렘방
INSERT INTO TBL_WEATHER_CITY VALUES (1633070, '팔렘방', 1);
INSERT INTO TBL_WEATHER_CITY VALUES (1633070, 'Palembang', 2);
INSERT INTO TBL_WEATHER_CITY VALUES (1633070, 'パルレムバン', 3);
INSERT INTO TBL_WEATHER_CITY VALUES (1633070, '大麥克', 4);
INSERT INTO TBL_WEATHER_CITY VALUES (1633070, 'Palembang', 5);
INSERT INTO TBL_WEATHER_CITY VALUES (1633070, 'Palembang', 6);
