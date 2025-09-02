package egovframework.ezEKP.ezOrgan.web;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.Ellipse2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Random;
import java.util.TimeZone;
import java.util.UUID;

import javax.annotation.PostConstruct;
import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import egovframework.let.utl.rest.JgwResult;
import egovframework.let.utl.rest.Result;
import egovframework.ezEKP.ezOrgan.service.impl.EzOrganAdminServiceImpl;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import org.apache.commons.lang3.BooleanUtils;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailDistributionVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.service.PreResult;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganGroupVO;
import egovframework.ezEKP.ezOrgan.vo.OrganJobVO;
import egovframework.ezEKP.ezOrgan.vo.OrganLoginStopUserVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.vo.PermissionInfoVO;
import egovframework.ezEKP.ezSystem.vo.UserChangeInfoVO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.ezEKP.ezSystem.vo.DeptChangeInfoVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.rest.Rest;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 관리자 - 조직도관리
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.14    장진혁    신규작성
 *
 * @see
 */

@Controller
public class EzOrganAdminController extends EzFileMngUtil {

    private static final Logger logger = LoggerFactory.getLogger(EzOrganAdminController.class);
            
	@Autowired	
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Autowired
	private EzEmailUserAdminService ezEmailUserAdminService;
	
	@Autowired
	private EzBoardAdminService ezBoardAdminService;

	@Autowired
	private EzSystemAdminService ezSystemAdminService;

    @Autowired
    private EzEmailUtil ezEmailUtil;	
    
    @Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
    
    @Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
    
    @Autowired
	private Properties globals;

	@Autowired
	private Rest rest;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;

    @PostConstruct
	public void init() throws Exception {
    	logger.debug("init started.");
    	try {
			// create table
    		ezCommonService.createTables(); // 2024-07-01 김수아 - 테이블 생성 공통함수 추가
			ezCommonService.createTblFidoSession(); //2023-11-23 이사라 - Fido 2차인증 테이블 생성, tbl_tenant_config에 해당 옵션 추가
	    	ezCommonService.createMailTemplateSequence();
    		ezCommonService.createJmochaMailboxProgress();
	    	ezCommonService.createTblSession(); // 2023-11-07 이사라 - DB 기반 세션 테이블 생성
	    	ezCommonService.createUserMailTemplate(); // 2020-07-27 김수아 - 메일 템플릿 테이블 생성
	    	ezCommonService.createMailOutOfOfficeTemplate(); // 2020-07-17 김수아 - 부재중 설정 템플릿 테이블 생성
	    	ezCommonService.createTblCompanyConfig();
	    	ezCommonService.createTblIPAccessID();
	    	ezCommonService.createTblIPAccessIP();
	    	ezCommonService.createJMochaDistributionSub();
	    	ezCommonService.createJMochaMailSignatureTemplate();
	    	ezCommonService.createJobMasterTable();
	    	ezCommonService.createWebfolderToken();
	    	ezCommonService.createPortalThemePortlet();
	    	ezCommonService.createTblUserMultiLogin();
	    	ezCommonService.createJmochaMailCopyright();
	    	ezCommonService.createJamesMailDeletedId();
    		ezCommonService.createRsFavoriteTable(); // 2019-03-28 이석화 - 모바일 오라클 자원관리 즐겨찾기 테이블 생성
	    	ezCommonService.createAttitudeAnnual(); //2019-06-11 주홍선 근태관리 연차관리 기능 테이블 추가
	    	ezCommonService.createThemeAndPortletAuth();
	    	ezCommonService.createTblYearlyDocCount(); // 2021-02-22 박기범 - 차트 통계 테이브 없을시 자동 생성
	    	ezCommonService.createAccessCountry(); //2019-0705 김수아 - 접속 허용 국가 테이블
	    	ezCommonService.createOpenGovTable(); // 2019-07-18 원문공개 테이블 추가
    		ezCommonService.createUserDistributionTable(); // 20200226 사용자 정의 공용배포그룹 테이블 생성
	    	ezCommonService.createResourcePortlet(); // 2019-06-28 황윤호 -자원관리 포틀릿 테이블 추가
	    	ezCommonService.createJmochaBigAttachDownloadLimit(); // 2020-03-12 홍대표 - 메일 대용량 첨부 제한 테이블 추가.
	    	ezCommonService.createPwPolicyTable(); // 2020-04-06 김수아 - tbl_password_policy table
	    	ezCommonService.createPwPolicyPatternTable(); // 2020-04-06 김수아 - tbl_password_policy_Pattern table
	    	ezCommonService.createBoardLike();
	    	ezCommonService.createPersonalPopupUser();
	    	ezCommonService.createAprAttachLimit(); // 2020-05-15 홍승비 - 전자결재 일반 첨부파일 개수제한 테이블 추가 (회사별 데이터)
	    	ezCommonService.createAdminAccessIpTable(); // 2020-04-28 김수아 - 관리자 IP 제한 테이블
			ezCommonService.createTblPermissionChangeInfo(); // 2022-01-18 이사라 - 권한 변경 히스토리 테이블 추가
	    	ezCommonService.createTblShareDocDir(); //2019-10-14 박성빈 - 문서함공유 테이블 추가
	    	ezCommonService.createTblNoticeBoard(); //2020-06-17 홍승비 - 회사별 공지사항 게시판 기능을 위한 NOTICEBOARD 테이블 추가
	    	ezCommonService.createTblTabBoard(); //2020-12-04 탭게시판 등록 용 테이블 추가
	    	ezCommonService.insertApprBigAttachInfo(); //2021-02-10 홍승비 - 전자결재 대용량첨부 컨피그, 칼럼, 테이블 추가
	    	ezCommonService.createSerialnumgenGrant();			// 2021-06-08 김민성 - 전자결재 상위부서 채번 기능 테이블 추가
	    	ezCommonService.createTblCar(); // 2021-07-12 차량관리 테이블 추가
	    	ezCommonService.createTblCarAcl(); // 2021-07-12 차량관리 테이블 추가
	    	ezCommonService.createTblCarAttach(); // 2021-07-12 차량관리 테이블 추가
	    	ezCommonService.createTblCarForm(); // 2021-07-12 차량관리 테이블 추가
    		ezCommonService.createTblScheduleComplete(); // 2021-11-23 홍승비 - 일정 완료여부 레코드 저장 테이블 추가
    		ezCommonService.createTblAdminAccessInfo();	// 2022-01-06 이사라 - 관리자 메뉴 접속 히스토리 테이블 추가
    		ezCommonService.createTblDisableNotiItem(); // 2022-03-11 - 알림환경설정 테이블 추가
			ezCommonService.createTblUserChangeInfo(); // 2023-09-05 장혜연 - 사용자 변경 히스토리 테이블 추가
	    	ezCommonService.createWebfolderFileUserTable(); 			
	    	ezCommonService.createTblWebfolderApplyHistroy();			
			ezCommonService.checkWebfolderEncryptTable(); 				
			ezCommonService.checkWebfolderVersionTable(); 				
	    	ezCommonService.createWebfolderNoInherit(); 				// 권한비상속			
	    	ezCommonService.createTblAprpreview(); //2020-11-18 정소미 - 전자결재 미리보기 설정 테이블 추가
	    	ezCommonService.createTblSerialNoRollback(); // 2022-09-21 홍승비 - 전자결재G > 문서 기록물 레코드 중복삽입 시 에러 롤백방지 기록 테이블 추가
			ezCommonService.addBoardDisLikeFlag(); // 2023-06-14 기민혁 - 게시판 > 싫어요 기능 컬럼 추가  
			ezCommonService.createTblBoardDisLike(); // 2023-06-14 기민혁 - 게시판 > 싫어요 기능 테이블 생성
			ezCommonService.insertScrapTenantConfig(); // 2023-06-14 기민혁 - 게시판 > 마이게시판 하위 나의스크랩 사용 Flag
			ezCommonService.insertScrapTableHeader(); // 2024-06-17 기민혁 - 게시판 > 마이게시판 하위 나의스크랩 테이블 해더 추가
			ezCommonService.createTblBoardScrap(); // 2023-06-15 기민혁 - 게시판 > 마이게시판 스크랩 테이블 생성
			ezCommonService.createTblUserScrapCont(); // 2023-06-15 기민혁 - 게시판 > 나의 스크랩함 cont테이블 생성
			ezCommonService.createTblUserScrapContList(); // 2023-06-15 기민혁 - 게시판 > 나의 스크랩함 list테이블 생성
	    	ezCommonService.createTblBoardReplyReact();	// 2023-07-27 이가은&임정은 - 댓글 좋아요/싫어요 관련 테이블 및 칼럼 추가
			ezCommonService.createTblDbLog(); // 2023-12-11 박기범 - DB 로그 테이블 추가
			ezCommonService.createTblDistributeinfo(); // 2024-08-07 김유진 - 배부이력정보 테이블 추가
			ezCommonService.createExecutiveTable(); // 2024-08-06 이유정 - 임원일정 테이블 추가
            ezCommonService.createJmochaMailBlocked(); // 2024-11-14 김승연 - 메일 열람 차단 테이블 추가
			ezCommonService.addTblCommunityClubguestOnelinereply(); // 2024-10-28 황인경 - 커뮤니티 방명록 댓글 테이블 추가
			ezCommonService.createJmochaCompanyQuota(); // 2024-12-12 김혜림 - 회사별 메일박스 용량 테이블 추가
            ezCommonService.createTblAprAutoSaveConfig(); // 2024-07-10 기민혁 - 전자결재G > 자동 임시저장 컨피그 추가
			ezCommonService.createTblScheduleGather(); // 2023-09-27 임정은 - 일정관리 > 일정 모아보기 그룹 테이블 추가
			ezCommonService.createTblBoardStarRating(); // 2024-10-02 이혜림 - 게시물 별점 평가하기 관련 테이블 및 컬럼 추가
			ezCommonService.createMealPlanTable(); // 2025-01-14 조수빈 - 식단 테이블  추가
			ezCommonService.createTblStatMenu(); // 2025-03-19 박기범 - 메뉴 통계 테이블 추가
			ezCommonService.createUserScheduleTypeConfigTable(); // 2025-04-21 조수빈 - 기본 일정(개인, 부서, 회사)별 사용자 설정 값 저장 테이블 추가
			ezCommonService.createTblCommunityGradeTable(); // 2025-07-10 이유정 - 커뮤니티 > 회원등급 테이블 추가

			// alter table
	    	ezCommonService.alterTableAddColumns(); // 2022-01-19 김은실 - alter 재사용 모듈 추가
	    	ezCommonService.addWebfolderTotalLimit();
	    	ezCommonService.addMemoExtensionColumns(); // 2019-05-14 이석화 - 큰 메모 기능 추가로 컬럼 추가
	    	ezCommonService.addMenuAndPortletCode(); //2019-07-15 유은정 - 메뉴, 포틀릿 호출 로직 개선 위한 컬럼 추가
	    	ezCommonService.addAddressFurigana(); // 2019-12-04 주소록 후리가나 추가 
	    	ezCommonService.insertMobileAttitudeColumn();			// 2020-06-10 김민성 - 모바일 근태관리 기능 추가
	    	ezCommonService.addScehdulegroup(); //2021-02-17 그룹일정의 tbl_schedulegroup 컬럼 추가
	    	ezCommonService.addScheduleMailNotiConfig();		// 2021-02-23 김민성 - 일정메일알림 컨피그 추가
			ezCommonService.addTblUserMultiLoginMobileFlagColumn(); // 2021-03-19 중복로그인 모바일 플래그 컬럼 추가
    		ezCommonService.alterTblConnectionInfo();	// 2021-12-22 이사라 : 로그아웃시간, 상태 컬럼 추가
	    	ezCommonService.addWebfolderLogHistory(); 					// 2020-01-20 웹폴더 파일 이력관리 컬럼추가 
    		ezCommonService.alterTblDevMaster();						//20220315 조진호 - mobile Pin 사용 관련 여부 컬럼 추가 (원래는 Talk에서 관리하는 테이블이나 Talk이 없는 경우 ezEKP DB의 테이블을 사용하기 떄문에 추가)
	    	ezCommonService.addAttitudeFormFormHtml2Column(); // 2023-08-21 조소정 - 근태관리 > 작성 양식 테이블에 영어 버전 양식 컬럼 추가
			ezCommonService.addTblBoardItemNoti(); /* 2023-09-25 민지수 - 게시판 > 공지게시물 > 기간설정 컬럼 추가 */
			ezCommonService.addTblBoardItemTempNoti(); /* 2023-09-25 민지수 - 게시판 > 임시저장 > 공지게시물 > 기간설정 컬럼 추가 */
			ezCommonService.alterRepeatFlagForResourceInfo(); // 2024-05-28 이유정 - 자원관리 > 자원반복예약 허용 설정을 위한 RepeatFlag 컬럼 추가
			ezCommonService.alterSubPermittedForMenuAuth();		/* 2024-05-28 김유진 - 포탈 > 메뉴관리 하위부서 허용여부 컬럼 추가 */
			ezCommonService.alterSubPermittedForPortletAuth();	/* 2024-05-28 김유진 - 포탈 > 포틀릿관리 하위부서 허용여부 컬럼 추가 */
			ezCommonService.alterSubPermittedForThemeAuth();	/* 2024-05-28 김유진 - 포탈 > 테마관리 하위부서 허용여부 컬럼 추가 */
			ezCommonService.alterSubPermittedForQuicklinkAcl(); /* 2024-05-28 김유진 - 포탈 > 빠른링크관리 하위부서 허용여부, 유저타입 컬럼 추가 */
			ezCommonService.alterDocAttachNameCol(); // 2024-06-24 민지수 > 전자결재 > 비전자 기록물 > 본문첨부 파일명 컬럼 추가
			ezCommonService.alterUserThemePagination();
			ezCommonService.alterTblScheduleForShowtop(); /* 2024-06-17 이주원 - 일정관리 > 상단표시 컬럼 추가 */
			ezCommonService.addColumnsRetireTblCompareWithUserTbl(); // 2024-07-09 장혜연 - tbl_usermaster에만 존재하는 컬럼을 조회해 tbl_usermaster_retire에 추가
			ezCommonService.addUserDeptHideFlag(); //2024-07-25 김대현 - 사용자 숨김, 부서 숨김 Flag 컬럼 추가
			ezCommonService.insertInitMobileTheme(); // 2024-07-12 황인경 > 모바일 포탈 > 포틀릿, 테마, 권한 추가
			ezCommonService.alterMenuOpenType();	// 2024-07-23 조수빈 - 관리자 > 메뉴 관리 > url 외부 / 내부 모듈 및 새 탭 열기, 새 창 열기 구분
			ezCommonService.alterSaveFlagForCbShare(); // 2024-06-28 이유정 - 캐비넷 > 캐비넷공유 > 공유자 저장여부 컬럼 추가
			ezCommonService.addTblFormContainerSN(); /* 2024-07-17 기민혁 - 전자결재 > 양식함 순서 컬럼 추가 */
			ezCommonService.alterAddThumbnailForTPI(); /* 2024-10-28 김우철 - 게시판 > 동영상게시판 > 썸네일 추가 여부 컬럼 추가 */
			ezCommonService.alterThumbnailExtForTPI(); /* 2024-10-28 김우철 - 게시판 > 동영상게시판 > 썸네일 확장자 컬럼 추가 */
			ezCommonService.alterAttachmentsForCBoard(); /* 2024-10-18 김우철 - 커뮤니티 > 공지사항 >  첨부 여부 컬럼 추가 */
			ezCommonService.alterUseUpperDeptBox(); /* 2024-07-05 양지혜 - 전자결재 > 상위부서문서함 사용여부 컬럼 추가 */
			ezCommonService.addBoardWriterFlagAndWriterNameType(); // 2025-01-16 임정은 - 게시판 게시물 게시자명선택 사용여부 플래그 및 게시자명선택 타입 컬럼 추가
			ezCommonService.alterTalkNotiTenant(); /* 2025-03-10 유지아 - 톡알림 테이블 tenantId추가 */
			ezCommonService.alterServerNameMain(); /* 2025-05-22 유지아 - servername 테이블 mainyn 추가 */
			ezCommonService.createJournalListLang(); // 2025-05-28 황인경 - 업무일지 양식 다국어 관련 컬럼 추가
			ezCommonService.insertJournalListLang(); // 2025-05-28 황인경 - 업무일지 양식 다국어 관련 데이터 추가
			ezCommonService.alterScheduleDefaultViewCheck(); // 2025-03-21 권기혁 - 일정관리환경설정 기본 화면 사용 여부 컬럼 추가
            ezCommonService.alterTblClubUserGradeColumn();	// 2025-07-10 이유정 - 커뮤니티 > 회원등급 컬럼 추가
            ezCommonService.alterTblClubJoinGradeColumn();	// 2025-07-10 이유정 - 커뮤니티 > 최초가입 등급, 회원목록조회 등급 컬럼 추가

			// tenant config
	    	ezCommonService.insertTblTenantConfig(); // 2020-01-28 useMailConfirm 컨피그 추가 >> 2020-04-28 tbl_tenant_config add
	    	ezCommonService.insertSurveyTenantConfig(); // 2019-06-25 이석화 전자설문 리뉴얼 테넌트 컨피그 추가
	    	ezCommonService.insertMailBigSizeAttachLimit(); // 2020-03-12 홍대표 - 메일 대용량 첨부 제한 컨피그 추가.
	    	ezCommonService.insertAnnualScheduleTenantConfig(); // 2020-02-24 김정언 - useAnnualScheduleYN 컨피그 추가
	    	ezCommonService.insertHolidayCheckTenantConfig(); // 2020-05-21 김정언 - useHolidayCheckYN 컨피그 추가
	    	ezCommonService.createMenuTenantConfig();		// 2020-08-06 김민성 - 메뉴 숨김처리 관련 config 추가
	    	ezCommonService.insertAutoSendOfferFlag(); //2020-11-23 김보혜 전자결재G 문서발송시 발송옵션 추가
	    	ezCommonService.insertApprSatViewerConfig(); // 2021-06-15 심기영 - 전자결재 첨부파일 SAT 뷰어 사용 컨피그 추가
	    	ezCommonService.insertHWPSecurityConfig(); // 2023-05-31 김우철 - 한글 배포용 문서 저장 관련 테넌트 컨피그 2건 추가
	    	ezCommonService.insertPrvwConfig(); // 2023-10-27 조수빈 - 전자결재 / 게시판 모듈 미리보기 테넌트 컨피그 2건 추가
	    	ezCommonService.insertApprSignRemapApplyTime(); // 2023-12-05 홍승비 - 전자결재 > 전자결재 서명 데이터 재맵핑 시점 컨피그 추가
			ezCommonService.insertPermissionBasisDeptYN_Config(); // 2023-08-16 전인하 - PermissionBasisDeptYN 테넌트 컨피그 추가
			ezCommonService.insertTenantConfigLangTertiary(); // 2023-11-27 조소정 - 게시판그룹 일본어 버전 생성 위해 LangTertiary 테넌트 컨피그 추가
			ezCommonService.insertTenantConfigLangQuaternary(); // 2023-11-27 조소정 - 게시판그룹 중국어 버전 생성 위해 LangQuaternary 테넌트 컨피그 추가
			ezCommonService.insertLoadTimeForApprAllConfig(); // 2024-01-11 김우철 - 다안기안 문서 표출 시 글꼴, 스크롤 오류를 해결하기 위한 setTimeout 시간
			ezCommonService.insertUseHideHeaderArea(); // 2024-05-23 김우철 - 헤더 숨기기 기능 사용여부 테넌트 컨피그 추가
			ezCommonService.insertUseReceiptDeptFileAttach(); // 2024-06-04 김우철 - 부서수신함에서 첨부, 문서첨부 기능 사용여부 테넌트 컨피그 추가
			ezCommonService.insertNonUseDocAttachYN(); // 2024-07-02 민지수 - 전자결재 > 비전자문서등록 > 본문첨부 기능 사용여부 테넌트 컨피그 추가
			ezCommonService.insertModuleEditor(); // 2024-09-23 김우철 - 전자결재, 메일을 제외한 에디터 테넌트 컨피그 추가
			ezCommonService.insertServername(); // 2024-12-02 김승연 - servername에 127.0.0.1 값 추가
			ezCommonService.insertResendFormYN(); // 2024-12-04 기민혁 - 전자결재 > 최근서식 사용여부 테넌트 컨피그 추가
			ezCommonService.insertEditVertionYN(); // 2024-12-05 기민혁 - 전자결재 > 본문수정 시 본문버전 변경 기능 사용여부 테넌트 컨피그 추가
			ezCommonService.insertPersonalHideSusinYN(); // 2024-11-26 기민혁 - 전자결재 > 개인수신함 사용여부 테넌트 컨피그 추가
			ezCommonService.insertMealPlanTenantConfig(); // 2025-02-05 조수빈 - 식단 사용 여부 컨피그 추가
			ezCommonService.insertUseSaasYN(); // 2025-05-21 유지아 - 모바일 푸시 알림 테넌트 따라 구분 컨피그 추가
			ezCommonService.inserExtLargeFilesever(); // 2025-05-22 유지아 - 대용량 첨부파일 외부메일 서버 동시 업로드
			ezCommonService.insertUseSendOutState(); // 2024-07-22 양지혜 - 관리자 > 전자결재 > 발송현황 메뉴 표출여부 컨피그 추가
	    	ezCommonService.insertPortalThemePortletInitdata();
	    	ezCommonService.updateTaskUrl();
	    	ezCommonService.updateListOptionData(); //2019-03-06 천성준 - 전자결재 회람수신함 관련 리스트헤더 데이터 임시 업데이트문
			ezCommonService.insertChartPortletInfo(); //2021-02-22 박기범 - 차트 포틀릿 없을시 자동 생성
	    	ezCommonService.addThemeAndPorteltAuthInit(); //2020-02-20 테마별, 포틀릿별 권한 추가
	    	ezCommonService.alterChamjoView(); // 2019-11-21 참조 View 수정
	    	ezCommonService.insertPortletInfo(); // 2019-07-02 자원, 웹폴더, 전자설문 포틀릿 데이터 확인 후 없으면 추가
	    	ezCommonService.setCompanyConfigs(); // 2020-03-30 김수아 - companyConfig 추가
	    	ezCommonService.insertUseExternalMailServerConfig();		// 2020-04-16 김민성 - 메일 기능 사용 관련 컨피그 추가(외부/내부)
	    	ezCommonService.insertReBebuOpinionCode();		// 2020-05-14 홍대표 - 재배부요청 의견 코드 추가
	    	ezCommonService.insertHalfOffAttitudeType(); // 2020-03-16  김정언 - 근태관리 휴가유형 반반차 추가
	    	ezCommonService.insertAlternateHolidayAttitudeType(); // 2020-03-16  김정언 - 근태관리 휴가유형 대체휴무 추가
	    	ezCommonService.insertBeforeOutComeAttitudeType(); // 2020-06-03  김정언 - 근태관리 휴가유형 전일퇴근 추가
	    	ezCommonService.insertTabBoardPortlet(); //2020-12-03 박기범 - 탭게시판포틀릿 추가
	    	ezCommonService.insertApprContainterConfig();		// 2021-05-21 김민성 - 전자결재 양식별문서함, 분류코드문서함 컨피그 추가
    		ezCommonService.addViewTaskOldFlag(); // 2021-08-31 홍승비 - 전자결재 분류코드체계 뷰에 삭제여부(OLDFLAG) 칼럼 추가 (VTASKCLASS, SVTASKCLASS)
    		ezCommonService.insertReceiptHistoryListoption();	// 2022-02-16 정주환 - 수신이력 확인 listoption 추가
			ezCommonService.insertOpinionGB(); // 2023-06-26 민지수 - 전자결재 > 완료문서 의견타입 추가의견 추가
//			ezCommonService.updateWebFolderAndApprovalCheckPermissionCode(); // 2023-10-05 전인하 - 권한 코드 변경으로 인하여 기존 데이터를 새 코드로 변경
			ezCommonService.insertPortalMenuChinese(); // 2023-11-22 조소정 - 포탈 > 기본 탑메뉴 중국어 버전 추가
			ezCommonService.insertPortletNameChinese(); // 2023-11-22 조소정 - 포탈 > 기본 포틀릿명 중국어 버전 추가
			ezCommonService.insertLoadTimeForApprAllConfig(); // 2024-01-11 김우철 - 다안기안 문서 표출 시 글꼴, 스크롤 오류를 해결하기 위한 setTimeout 시간
			ezCommonService.createTblDeptChangeInfo(); // 2024-02-20 장혜연 - tbl_dept_change_info 테이블 추가
			ezCommonService.insertSurveyPostingMaxPeriodConfig(); // 2024-03-26 - 전자설문 종료 후 게시기간 설정 추가
			ezCommonService.alterFileNameForWebfolderHistory(); // 2023-10-18 남진구 - 웹폴더 > 버전관리 > 파일 복원시 파일명 복원을 위한 FILE_NAME 칼럼 추가
			ezCommonService.createTblTotalHistory(); // 2023-06-04 - 통합 PC 다중 파일 저장시 다운로드 로그 남기는 테이블
			ezCommonService.insertdelAttachByOthersConfing(); // 2024-05-23 민지수 - 전자결재 > 첨부 > 첨부 등록자 이외의 사용자가 첨부 삭제가능여부
			ezCommonService.insertApprNonElecRecTypeConfing(); // 2024-05-29 김유진 - 전자결재G 비전자문서등록 양식 확장자 정보
			ezCommonService.insertEndDateOptionConfig(); // 2024-05-29 전인하 - 게시판 > 게시물 리스트 > 만료된 게시물 리스트 표출 가능여부
            ezCommonService.insertRecordHeaderClassTitle(); // 2024-06-11 민지수 - 전자결재 > 기록물대장 > 기록물철명 헤더 추가
    		ezCommonService.insertDocBinderListOption(); // 2024-06-12 전인하 - 전자결재G > 기록물철인계 > 기록물철리스트 리스트헤더 컬럼 추가
			ezCommonService.insertReturnByDesignationUsedConfig(); // 2024-06-24 양지혜 - 전자결재 > 지정반송 사용여부 컨피그 추가
			ezCommonService.insertReadingRecordHeader(); // 2024-06-21 김우철 - 전자결재G > 열람문서함 헤더 추가
            ezCommonService.insertPortalPortletSizeTables(); // 2023-11-20 박기범 - 포탈 포틀릿 사이즈 관련 테이블 추가
            ezCommonService.insertTblPortalTopUser(); // 2024-04-11  TBL_PORTAL_TOP_USER 추가(포탈 top 프레임 타입 설정. 현재는 위, 왼쪽)
            ezCommonService.insertTblPortalTopCompany(); // 2024-05-17 한태훈 - TBL_PORTAL_TOP_COMPANY 추가(포탈 top 프레임 타입 설정. 현재는 위, 왼쪽)
            ezCommonService.alterUseColor();	// 2024-08-20 조수빈 - 포탈 설정 > 모드 설정 컬럼 추가
            ezCommonService.createTblRealTimeNotification(); // 2024-03-28 한태훈 - 통합알림 테이블 추가
            ezCommonService.addNotiStoragePeriodConfig(); // 2024-03-28 한태훈 - 통합알림 보관기간 tenantConfig 추가
            ezCommonService.addNotiPollingIntervalConfig(); // 2024-03-28 한태훈 - 통합알림 데이터 새로고침 간격 tenantConfig 추가
            ezCommonService.insertPortalTopCompanyInitdata(); // 2024-05-17 한태훈 - 포탈 탑 메뉴 위치 설정 회사 기본 데이터 세팅
            ezCommonService.insertFixPortlet(); // 2024-05-17 박기범 - 고정포틀릿 추가
            ezCommonService.addQuickLinkCompanyID(); // 2023-12-15 박차웅 - 퀵링크 tbl_ps_quicklink 테이블 COMPANYID 필드 추가
            ezCommonService.alterThemeInformation(); // 2024-06-20 한태훈 - 테마 설명 내용 수정.
            ezCommonService.alterCompanyMenuIconUrl(); // 2024-07-08 황인경 - 회사별 메뉴 아이콘 추가
            ezCommonService.insertGongRamListOption(); // 2024-06-17 임정은 - 공람 listoption 추가
			ezCommonService.addReminderTimeAtTblScheduleConfig(); //2023-09-04 한태훈 - 일정관리 > 설정 > 미리알림 시간 컬럼 추가
	    	ezCommonService.createTblScheduleReminderScheduler(); // 2023-09-04 한태훈 - 일정관리 > 미리알림 스케줄러 테이블 추가
	    	ezCommonService.insertReminderTenantConfig(); // 2023-09-11 한태훈 - 일정관리 > 미리알림 방식(닷넷 통합 알림, 자바 메일) 선택 테넌트 컨피그, 미리알림 시 하루종일 일정의 시작 시각 설정 테넌트 컨피그 추가
			ezCommonService.alterBoardExtentionAttrByteSize(); // 2024-07-31 전인하 - 게시판 > 확장컬럼 > 저장할 수 있는 데이터 크기 변경 (mysql, oracle 일괄 500자)
			ezCommonService.insertDotNetTotalNotificationConfig(); // 2024-08-21 유길상 닷넷 통합알림 컨피그
//			ezCommonService.updateInProcessJpCodeName3(); // 2024-08-22 유길상 - CODELIST > a04(진행) 일본어 변경 
			ezCommonService.createServeyResultviewPermTbl(); // 2024-07-11 전인하 - 설문 > 지정공개 대상자 리스트 테이블 추가
            ezCommonService.createSystemConfig(); // 2024-07-22 한태훈 - tbl_systemconfig, tbl_systemconfig_type
            ezCommonService.addIsDeleteBlockToSytemConfig();
            ezCommonService.createConnectionMenu(); // 2024-07-22 한태훈 - 연계메뉴 및 연계 포틀릿 기본 시스템 컨피그 추가
            ezCommonService.insertStandardSystemConfigData(); // 2024-07-22 한태훈 - 시스템 컨피그 기본 데이터 추가
            ezCommonService.createEmergencyNotiTable();
            ezCommonService.insertMobileToggleMenus(); // 2024-08-08 조수빈 - 모바일 우측 panel의 기본 toggle menu 데이터 추가
            ezCommonService.updateThemeData(); // 2024-09-02 조수빈 - 테마 변경에 따른 테마 데이터 update
			ezCommonService.createRsScheduleDeptIdColumn(); // 2024-09-03 박기범  - TBL_RS_SCHEDULE deptid 컬럼 추가
	    	ezCommonService.alterTblBoardOneLineChildReply(); // 2023-03-31 이가은 - 게시판 > 게시물 댓글 정보 테이블에 답글 작성/수정기능 컬럼 추가
			ezCommonService.insertBoardReplyCommentEmoticon(); // 2023-11-07 전인하 - 게시판 > 댓글로 이모티콘 삽입 가능 관련 테이블 컬럼 추가
			ezCommonService.createBoardKeywordTable(); // 2024-08-23 전인하 - 게시판 > 키워드 기능 개발
			ezCommonService.createResourceFavoriteTables(); // 2024-08-07 유길상 - 자원관리 즐겨찾기 테이블 추가
			ezCommonService.addBoardAttachmentFlag(); // 2024-10-23 정지은 - 게시판 > 글 작성 시 파일첨부 가능여부 설정
	        ezCommonService.addTblBoardInfoPublicFlag(); // 2024-10-21 박기범 - 게시판 공게여부 컬럼추가
			ezCommonService.insertAllBoardListOption(); // 2024-10-21 한태훈 - 게시판 > 전체게시물 리스트헤더 추가
	    	ezCommonService.insertAllBoardInfo(); // 2024-10-17 한태훈 - 게시판 > 전체게시물 게시판정보 추가
			ezCommonService.addSurveyTotalNotiSentFlag(); // 2024-11-15 한태훈 - 전자설문 > 설문 알림 발송 시 알림 발송 유무 확인 플래그 추가
			ezCommonService.createTblBoardCommentAttachments(); // 2024-10-23 전인하 - 게시판 > 댓글 첨부 테이블 추가
			ezCommonService.insertBoardItemListOptionAN(); // 2024-09-11 이유정 - 게시판 > 최근게시물 리스트헤더 추가
			ezCommonService.insertRecentBoardInfo(); // 2024-09-11 이유정 - 게시판 > 최근게시물 게시판정보 추가
			ezCommonService.addBoardAllNewBoardFlag(); // 2024-10-22 정지은 - 게시판 > 게시물의 최근 게시물 포함 여부 설정(게시판 설정)
			ezCommonService.addBoardAllNewBoardListDate(); // 2024-10-22 정지은 - 게시판 > 게시물의 최근 게시물 일자 설정
			ezCommonService.alterEditVersionHistory(); // 2024-12-10 기민혁 - 전자결재 > 수정버전,수정모드 컬럼 추가
			ezCommonService.insertEditVersionListOption(); // 2024-12-10 기민혁 - 수정버전 리스트 해더 생성
			ezCommonService.insertPersonalSusinListOption(); // 2024-11-28 기민혁 - 개인 수신함 리스트 해더 추가
			ezCommonService.alterBodyHTMLToConnData(); // 2025-01-24 이가은 - 전자결재 > 연동테이블 컬럼명 변경
			ezCommonService.createGongramDeleteHistory(); // 2024-12-27 이가은 - 공람완료문서 삭제 히스토리 테이블 생성
			ezCommonService.addMemberDeptIdScheduleGroupMember(); // 2024-12-27 한태훈 - 일정관리 > 일정 그룹 테이블에 부서컬럼 추가
			ezCommonService.addMemberDeptIdScheduleGatherMember(); // 2024-12-27 한태훈 - 일정관리 > 일정 모아보기 그룹 테이블에 부서컬럼 추가
			ezCommonService.addMailboxProgressStateColumns(); // 2025-05-23 메일 내보내기/가져오기 비동기 컬럼 추가
			ezCommonService.createTblBoardModifyHistory(); // 2024-12-05 한태훈 - 게시판 > 게시판 버전관리 테이블 추가
			ezCommonService.addBoardContentSize(); // 2025-06-16 이혜림 - 게시판 > 본문 크기 컬럼 추가
            ezCommonService.updateMobilePortletMenuId(); // 2024-09-20 황인경 - 모바일 메뉴 권한 별도
			ezCommonService.alterTblRsBrdResMaxDate(); // 2024-08-27 유길상 - 자원관리 > 자원등록 > 최대 예약 가능 기간 컬럼 추
			ezCommonService.alterTblRsBrdResMaxUserCnt(); // 2024-08-27 유길상 - 자원관리 > 자원등록 > 정원 컬럼 추가
			ezCommonService.insertExecutiveScheduleConfig(); // 2025-07-07 이유정 - 일정관리 > 임원일정 조회 가능 범위 설정 컨피그 추가
            ezCommonService.settingCommunityGradeData(); // 2025-07-10 이유정 - 커뮤니티 > 기존 데이터 회원등급에 맞춰 세팅
            ezCommonService.alterTblClubUserAdminAuthColumn(); // 2025-07-15 이유정 - 커뮤니티 > 운영자권한 컬럼 추가
            ezCommonService.alterTblClubUserWithdrawDateColumn(); // 2025-07-23 이유정 - 커뮤니티 > 회원탈퇴일자 컬럼 추가
            ezCommonService.addMailPreviewConfig();//2025-07-24 김대현 - 메일 > 메일 미리보기 기능 추가
			ezCommonService.alterTblUsermasterForTeams(); // 2025-07-29 김혜림 - 팀즈 연동을 위한 TEAMSID 컬럼 추가
			ezCommonService.createAuthTokenTable(); // 2025-07-31 김혜림 - Graph API 인증토큰 저장 테이블 생성
			ezCommonService.createUserPresenceTable(); // 2025-08-04 김혜림 - Graph API Presence 정보 저장 테이블 생성
			ezCommonService.addBoardUsrListShowType(); // 2025-07-10 이혜림 - 게시판 > 게시판 목록 타입 컬럼 추가
			ezCommonService.addBoardListShowType(); // 2025-07-10 이혜림 - 게시판 > 게시판 목록 타입 컬럼 추가
            ezCommonService.alterTblBoardInfoUrlCopyFlag(); // 2025-08-05 이유정 - 게시판 > 게시글 주소복사 컬럼 추가
			ezCommonService.updateGuestAccessibleUris(); // 2025-08-19 양지혜 - 비회원 게시판 허용 URI 데이터 업데이트
		} catch (Exception e) {
    		logger.error(e.getMessage(), e);
    	}
    	logger.debug("init ended.");
    }

	/**
	 * 조직도관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/organMain.do", method = RequestMethod.GET)
	public String organMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		logger.debug("organMain started.");
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("organMain accessDenied.");
			return "cmm/error/adminDenied";
		} else {
			logger.debug("organMain ended.");
			return "admin/ezOrgan/organMain";
		}
	}
	
	/**
	 * 조직도관리 왼쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/organLeft.do", method = RequestMethod.GET)
	public String organLeft(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", user.getTenantId());
		String cChk = "0";
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		
		if (organAuth.isAuth(AdminAuth.ADMIN_MASTER)) { // 전체 관리자
			cChk = "1";
		}
		
		// set useLetter
		String useLetter = ezCommonService.getTenantConfig("useLetter", user.getTenantId());
		if (useLetter == null || useLetter.equals("")) {
			useLetter = "NO";
		}
		
		String useLoginStop = ezCommonService.getTenantConfig("useLoginStop", user.getTenantId());
		if (useLoginStop == null || useLoginStop.equals("")) {
			useLoginStop = "NO";
		}
				
		logger.debug("useLetter=" + useLetter);
		
		String useSignatureTemplate = ezCommonService.getTenantConfig("useSignatureTemplate", user.getTenantId());
		if (useSignatureTemplate == null || useSignatureTemplate.equals("")) {
			useSignatureTemplate = "NO";
		}
		
		logger.debug("useSignatureTemplate=" + useSignatureTemplate);

		String useCopyrightMenu = ezCommonService.getTenantConfig("useCopyrightMenu", user.getTenantId());
		if (useCopyrightMenu.equals("")) {
			useCopyrightMenu = "NO";
		}
		logger.debug("useCopyrightMenu=" + useCopyrightMenu);
		
		String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", user.getTenantId());
		
		String packageType = commonUtil.getPackageType(user.getTenantId());
		
		model.addAttribute("packageType", packageType.toLowerCase());
		model.addAttribute("dotNetIntegration", dotNetIntegration);
		model.addAttribute("useLetter", useLetter);
		model.addAttribute("useLoginStop", useLoginStop);
		model.addAttribute("useSignatureTemplate", useSignatureTemplate);
		model.addAttribute("useSharedMailbox", useSharedMailbox);
		model.addAttribute("useCopyrightMenu", useCopyrightMenu);
		model.addAttribute("cChk", cChk);
		
		return "admin/ezOrgan/organLeft";
	}
	
	/**
	 * 조직도관리 오른쪽화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/organRight.do", method = RequestMethod.GET)
	public String organRight(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());

		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		String packageType = commonUtil.getPackageType(user.getTenantId());
		String use_approvalG = config.getProperty("config.UserInfo_ApprovalG");
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", user.getTenantId());
		String useSyncServer = ezCommonService.getTenantConfig("useSyncServer", user.getTenantId());
		String useBizmekaTalk = ezCommonService.getTenantConfig("UseBizmekaTalk", user.getTenantId());
		String useDisablePop3Imap = ezCommonService.getTenantConfig("UseDisablePopImap", user.getTenantId());
		String useMobileManagemant = ezCommonService.getTenantConfig("useMobileManagemant", user.getTenantId());
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", user.getTenantId());
		String useOTP = ezCommonService.getTenantConfig("useOTP", user.getTenantId());
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", user.getTenantId());
		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", user.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		String topid = "";
		String deptTreeTopId = "";

		if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
			topid = user.getCompanyID();
			deptTreeTopId = topid;
			useSyncServer = "NO";
			useBizmekaTalk = "NO";
		} else {
			topid = "Top";
			deptTreeTopId = topid + "/organ";
		}
		
		if (useDisablePop3Imap.equals("")) {
			useDisablePop3Imap = "NO";
		}
		
		model.addAttribute("packageType", packageType);
		model.addAttribute("useDisablePopImap", useDisablePop3Imap);
		model.addAttribute("topid", topid);
		model.addAttribute("useOCS", config.getProperty("config.USE_OCS"));
		model.addAttribute("use_approvalG", use_approvalG);
		model.addAttribute("useBizmekaSpambox", useBizmekaSpambox);
		model.addAttribute("useBizmekaTalk", useBizmekaTalk);
		model.addAttribute("deptTreeTopId", deptTreeTopId);
		model.addAttribute("useMobileManagemant", useMobileManagemant);
		model.addAttribute("useSyncServer", useSyncServer);
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("useOTP", useOTP);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		model.addAttribute("useOrganHideFlag", useOrganHideFlag);
		
		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", user.getTenantId());		
		model.addAttribute("dotNetIntegration", dotNetIntegration);
		model.addAttribute("locale", user.getLocale());
		
		return "admin/ezOrgan/organRight";
	}
	
	/**
	 * 조직도관리 회사추가 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/companyInfo.do", method = RequestMethod.GET)
	public String companyInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
	    logger.debug("companyInfo started.");
	    
		userInfo = commonUtil.userInfo(loginCookie);
		
		int tenantID = userInfo.getTenantId();
		
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), tenantID);
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), tenantID);
		
		String selectCN = request.getParameter("selectCN");
        selectCN = selectCN == null ? "" : selectCN;
        String pageType = request.getParameter("pageType");
        pageType = pageType == null ? "add" : pageType;
        logger.debug("selectCN=" + selectCN+ ", pageType=" + pageType);
        
		String tenantDomain = ezCommonService.getTenantConfig("DomainName", tenantID); // primary domain
		String innerDomain = ezEmailService.getMultiDomainList(tenantID); // 전체 도메인 리스트
		String[] domainList = innerDomain.split(";");
		
		String compMail = "";
		if (!pageType.equalsIgnoreCase("add")) {
			OrganDeptVO organCompVO = ezOrganService.getDeptInfo(selectCN, userInfo.getPrimary(), userInfo.getTenantId());		
	        compMail = organCompVO.getMail();
	        logger.debug("compMail={}", compMail);
		}
		
        // user primary domain
        String companyMailDomain = ezCommonService.getCompanyConfig(tenantID, selectCN, "DomainName");
        companyMailDomain = companyMailDomain.equals("") ? tenantDomain : companyMailDomain;
        logger.debug("tenantDomain=" + tenantDomain+ ", companyMailDomain=" + companyMailDomain);
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("tenantDomain", tenantDomain);
		model.addAttribute("domainList", domainList);
		model.addAttribute("companyMailDomain", companyMailDomain);
		model.addAttribute("pageType", pageType);
		model.addAttribute("compMail", compMail);
		
		logger.debug("companyInfo ended.");
		
		return "admin/ezOrgan/companyInfo";
	}
	
	/**
	 * 조직도관리 회사추가 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveCompanyInfo.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String saveCompanyInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("saveCompanyInfo started.");
	    
		String parentCn = request.getParameter("parentCn");
		String cn = request.getParameter("cn");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		String mailId = request.getParameter("mailId");
		String extensionAttribute15 = request.getParameter("extensionAttribute15");
		extensionAttribute15 = extensionAttribute15 != null ? extensionAttribute15 : "";		
		String skipInitData = request.getParameter("skipInitData");
		skipInitData = skipInitData != null ? skipInitData : "";
		String operatorId = request.getParameter("operatorId");
		operatorId = operatorId != null ? operatorId : "";
		String manualFlag = request.getParameter("manualFlag");
		manualFlag = manualFlag != null ? manualFlag : "N";
		String selectDomain = request.getParameter("selectDomain");
		selectDomain = selectDomain != null ? selectDomain : "";
		
		logger.debug("parentCn=" + parentCn + ",cn=" + cn + ",displayName=" + displayName
				+ ",displayName2=" + displayName2 + ",mailId=" + mailId + ",extensionAttribute15=" + extensionAttribute15 
				+ ",skipInitData=" + skipInitData + ",operatorId=" + operatorId + ",manualFlag=" + manualFlag + ", selectDomain=" + selectDomain);
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }
		
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
		
		String domain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		
		logger.debug("domain=" + domain);
		        
		String result = "";
		
		String operatorMailIdPropertyName = "operatorMailId";
		
		// 회사정보를 수정하는 경우
        if (parentCn == null || parentCn.isEmpty()) {
			String mailAddr = cn + "@" + domain;
			
			// 최상위 회사(Top)의 경우에만 이메일 아이디를 변경할 수 있다.
			if (cn.equalsIgnoreCase("Top")) {
				mailAddr = mailId + "@" + domain;
				
				logger.debug("new mailAddr=" + mailAddr);
			}
        	
        	ezOrganAdminService.updateDBData_company(cn, displayName, displayName2, mailAddr, tenantID);
        	
			String existingOperatorMailId = ezCommonService.getCompanyConfig(tenantID, cn, operatorMailIdPropertyName);
        	
        	if (!operatorId.equals("")) {				
				if (!existingOperatorMailId.equals("")) {
					ezCommonService.updateCompanyConfig(tenantID, cn, operatorMailIdPropertyName, operatorId);
				} else {
					ezCommonService.insertCompanyConfig(tenantID, cn, operatorMailIdPropertyName, operatorId);
				}
        	} else {
        		if (!existingOperatorMailId.equals("")) {
        			ezCommonService.deleteCompanyConfig(tenantID, cn, operatorMailIdPropertyName);
        		}
        	}
        // 새로운 회사를 생성하는 경우	
        } else {			
			String ldapPath = "";
			
	        // 사용자, 부서, 퇴직자, 회사 상관없이 기존에 사용되는 아이디를 체크한다.
			// 공용배포그룹ID, 메일ID(alias 메일ID 포함)로 이미 사용중인지도 체크한다.
	        int cnt = ezOrganAdminService.userCheck(cn, tenantID);
	        
	        logger.debug("userCheck cnt=" + cnt);
	        
			if (cnt > 0) {
				result = "PRE";
			} else {
				String mailAddr = cn + "@" + domain;
				
				logger.debug("mailAddr=" + mailAddr);
				
				// skyblue0o0
				int rc = ezEmailUserAdminService.addGroup(mailAddr);
				
				logger.debug("addGroup rc=" + rc);
				
				if (rc == 0) { // addGroup 성공
					
					String groupAddr = parentCn + "@" + domain;
					
					logger.debug("groupAddr=" + groupAddr);
					
					rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
					
					//업무일지 - 일지함 생성
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("tenantId", tenantID);
					param.put("companyId", cn);
					param.put("userId", userInfo.getId());
					JSONObject journalResult = commonUtil.getJsonFromRestApi("/rest/ezjournal/types", param, request, "post", null);
					
					String journalStatus = (String) journalResult.get("status");
					
					if (!journalStatus.equals("ok")) {
						ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
					}
					
					logger.debug("updateGroupAdd rc=" + rc);
					
					if (rc == 0 && journalStatus.equals("ok")) { // updateGroupAdd 성공
						
						// insertDBData_company 실패했을 경우 JMocha에서 회사 다시 삭제.
						try {
							mailAddr = getEmailAddressBasedOnCompanyDomainName(mailAddr, cn, parentCn, userInfo, selectDomain);
							
							ezOrganAdminService.insertDBData_company(cn, displayName, displayName2,
									mailAddr, parentCn, ldapPath, extensionAttribute15, skipInitData, manualFlag, tenantID, userInfo);
							
							// companyConfigs setting
							ezCommonService.setCompanyConfigs();
							
							if (!operatorId.equals("")) {
								ezCommonService.insertCompanyConfig(tenantID, cn, operatorMailIdPropertyName, operatorId);
							} 
							
							// 2024.10.14 한슬기 : 암호정책 디폴트값 설정 (암호패턴 사용, 영문 대/소문자 패턴구분안함, 3개패턴 사용, 8글자 이상)
							String defaultPwPolicyResult = ezSystemAdminService.insertDefaultPwPolicy(tenantID, cn);
							if (!"OK".equals(defaultPwPolicyResult)) {
								result = "PWPOLICY_ERROR";
							}
							
							
							int reasonCode = ezEmailService.saveCompanyMultiDomain(tenantID, cn, selectDomain, selectDomain);
							logger.debug("reasonCode=" + reasonCode);
							
							result = "OK";
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
							commonUtil.getJsonFromRestApi("/rest/ezjournal/types", param, request, "delete", null);

							ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
							ezEmailUserAdminService.removeGroup(mailAddr);
							result = "EMAIL_ERROR";
						}									
					} else {
					    ezEmailUserAdminService.removeGroup(mailAddr);
						result = "EMAIL_ERROR";
					}
				} else {
					result = "EMAIL_ERROR";
				}
				// skyblue0o0 - end
				
			}
        }
		
		logger.debug("saveCompanyInfo ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 회사 & 부서 삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/delDept.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")	
	@ResponseBody
	public String delDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("delDept started.");
	    
	    LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
	    
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }
	    
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);	    
	    
		String cn = request.getParameter("cn");
		String pClass = "group";
		String result = "";

		logger.debug("cn=" + cn);

		// 24.03.18 장혜연 : 부서 변경 히스토리 기록을 위해 삭제 하기 전 부서 명을 조회한다.
		OrganDeptVO deptNm = ezOrganAdminService.getDeptDisplayNm(cn, tenantID);

		// 24.03.18 장혜연 : 부서 변경 히스토리 기록을 위해 삭제 하기 전 상위 부서 cn을 조회한다.
		String parentCn = ezOrganAdminService.getDeptParentCn(cn, tenantID);

		// 제거하고자 하는 회사 혹은 부서 바로 아래에 위치한 자식 부서의 수를 구한다.
		int cnt = ezOrganAdminService.companyChildCheck(cn, tenantID);
		
		// 제거하고자 하는 회사 혹은 부서에 속한 사원의 수를 반환한다.
		int usercnt = ezOrganAdminService.userCountCheck(cn, tenantID);
		
		// 제거하고자 하는 회사 혹은 부서에 속한 퇴직자 수를 구한다.
		int retireUserCnt = ezOrganAdminService.retireUserCountCheck(cn,tenantID);
		
		logger.debug("cnt=" + cnt + ",usercnt=" + usercnt + ",retireUserCnt=" + retireUserCnt);
		
		if (cnt > 0) {
			result = "HASCHILD";
		} else if(usercnt > 0) {
			result = "HASCHILD";
		} else if(retireUserCnt > 0) {
			result = "HASRETIRE";
		} else {			
			// skyblue0o0
			String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
			String mailAddr = cn + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			int rc = ezEmailUserAdminService.removeGroup(mailAddr);
			
			logger.debug("removeGroup rc=" + rc);
			
			if (rc == 0) { // removeGroup 성공				
				OrganDeptVO dept = ezOrganService.getDeptInfo(cn, "1", userInfo.getTenantId());
				String groupAddr = dept.getExtensionAttribute1() + "@" + domain;
				
				logger.debug("groupAddr=" + groupAddr);
				
				// 상위 부서의 이메일 그룹 주소로부터 해당 부서를 삭제한다.
				rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
				
				logger.debug("updateGroupDel rc=" + rc);
				
				if (rc != -100) { // updateGroupDel 성공(부모그룹이나 자식그룹을 찾지 못해도 성공으로 봄.)
					String bizmekaResult = "ERROR";
					
				    try {
						String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
						
						if (useBizmekaSpambox.equals("YES")) {
							String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
							String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
							String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
							
							bizmekaResult = ezEmailUtil.bizmekaDeleteDept(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn);		
							
							logger.debug("bizmekaResult=" + bizmekaResult);
							
							if (!bizmekaResult.equals("OK")) {
								throw new Exception("bizmekaDeleteDept failed");
							}						
						}
				    	
    					ezOrganAdminService.deleteDBData(cn, pClass, tenantID);
    					removeEmailAddressBasedOnCompanyDomainName(cn, dept.getExtensionAttribute2(), userInfo);

						result = "OK";
						// 24.03.18 장혜연 : 부서 삭제 시 부서 변경 히스토리에 기록한다
						if ("OK".equals(result)) {
							DeptChangeInfoVO deptChangeInfo = new DeptChangeInfoVO();
							deptChangeInfo.setDeptChVo(cn, deptNm.getDisplayName(), deptNm.getDisplayName2(), parentCn,
									"", "", "", "delete", ClientUtil.getClientIP(request));
							ezSystemAdminService.insertDeptChangeHist(deptChangeInfo, userInfo);
						}
    				// 예외가 발생하면 그룹 주소를 다시 등록한다.
				    } catch (Exception e) {
				    	logger.error(e.getMessage(), e);
				    	
				        ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				        ezEmailUserAdminService.addGroup(mailAddr);
				        
				        result = "EMAIL_ERROR";
				    }
				} else {
					result = "EMAIL_ERROR";
				}
			} else {
				result = "EMAIL_ERROR";
			}
			// skyblue0o0 - end
			
		}
		
		logger.debug("delDept ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 부서정보 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/deptInfo.do", method = RequestMethod.GET)	
	public String deptInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
	    logger.debug("deptInfo started");
	    
        userInfo = commonUtil.userInfo(loginCookie);
        
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
        
        String selectCN = request.getParameter("selectCN");
        selectCN = selectCN == null ? "" : selectCN;
        String pageType = request.getParameter("pageType");
        pageType = pageType == null ? "add" : pageType;
        logger.debug("selectCN=" + selectCN + ", pageType=" + pageType);
        
        String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), tenantID);
        String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), tenantID);
        String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantID);    
        
        OrganDeptVO organDeptVO = ezOrganService.getDeptInfo(selectCN, userInfo.getPrimary(), userInfo.getTenantId());		
        String deptCompanyID = organDeptVO.getExtensionAttribute2();        
        String deptMail = organDeptVO.getMail();
        logger.debug("deptCompanyID=" + deptCompanyID + ", deptMail=" + deptMail);
        
        String companyMailDomain = ezCommonService.getCompanyConfig(tenantID, deptCompanyID, "DomainName");
        companyMailDomain = pageType.equals("modify") ? deptMail.split("@")[1] : companyMailDomain; // 수정이면 수정할 부서의 도메인
		String companyDomainList = ezCommonService.getCompanyConfig(tenantID, deptCompanyID, "MailInnerDomain");
		String[] domainList = companyDomainList.split(";");
		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId());
       
        model.addAttribute("approvalFlag", approvalFlag);
        model.addAttribute("primary", primary);
        model.addAttribute("secondary", secondary);
        model.addAttribute("locale", userInfo.getLocale());
        model.addAttribute("companyMailDomain", companyMailDomain);
        model.addAttribute("domainList", domainList);
        model.addAttribute("deptMail", deptMail);
        model.addAttribute("pageType", pageType);
        model.addAttribute("useOrganHideFlag", useOrganHideFlag);
        
        logger.debug("deptInfo ended");
        
        return "admin/ezOrgan/deptInfo";
	}

	/**
	 * 조직도관리 부서정보 및 내용 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getEntryInfo.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getEntryInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("getEntryInfo started");
	    
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
	    
		String cn = request.getParameter("cn");
		String proplist = request.getParameter("prop");				
	
		logger.debug("cn=" + cn);
		
		String infoXML = ezOrganAdminService.getPropertyList(cn, proplist, "1", userInfo.getTenantId());		

		logger.debug("getEntryInfo ended");
		
		return infoXML;
	}
	
	/**
	 * 조직도관리 부서정보 수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveDeptInfo.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveDeptInfo(@CookieValue("loginCookie") String loginCookie, OrganDeptVO vo, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("saveDeptInfo started");

		DeptChangeInfoVO deptChangeInfo = new DeptChangeInfoVO();

        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }
        
        int tenantID = userInfo.getTenantId();                              
	    
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		String selectDomain = request.getParameter("selectDomain");
		
		logger.debug("tenantID=" + tenantID + ",domain=" + domain + ",parentCn=" + vo.getParentCn() + ", selectDomain=" + selectDomain); 
		
		String result = "";

        vo.setTenantId(tenantID);
        
        SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        String nowDate = date.format(new Date()); 
        vo.setNowDate(nowDate);
        String cn = vo.getCn();

        // 업데이트 전 부서의 기존 이름을 조회한다
        OrganDeptVO orgDeptNm = ezOrganAdminService.getDeptDisplayNm(cn, tenantID);
        
        // 부서정보를 수정하는 경우
		if (vo.getParentCn() == null || vo.getParentCn().isEmpty()) {

			ezOrganAdminService.updateDBData_dept(vo);

			// 2024-03-20 장혜연 : 부서명 수정 할 경우 부서변경 히스토리에 기록한다.
			if (!vo.getDisplayName().equals(orgDeptNm.getDisplayName())) {
				deptChangeInfo.setDeptChVo(cn, orgDeptNm.getDisplayName(), orgDeptNm.getDisplayName2(),
						vo.getHistParentCn(), vo.getCn(), vo.getDisplayName(), vo.getDisplayName2(), "nameChange",
						ClientUtil.getClientIP(request));
				ezSystemAdminService.insertDeptChangeHist(deptChangeInfo, userInfo);
			}

		// 새로운 부서를 생성하는 경우
		} else {
			
			// 사용자, 부서, 퇴직자, 회사 상관없이 기존에 사용되는 아이디를 체크한다.
			// 공용배포그룹ID, 메일ID(alias 메일ID 포함)로 이미 사용중인지도 체크한다.
			int cnt = ezOrganAdminService.userCheck(cn, tenantID);
			
			logger.debug("cn=" + cn + ",cnt=" + cnt);
			
			if (cnt > 0) {
				result = "PRE";
			} else {

				String mailAddr = cn + "@" + domain;
				
				logger.debug("mailAddr=" + mailAddr);
				
				// skyblue0o0
				int rc = ezEmailUserAdminService.addGroup(mailAddr);
				
				if (rc == 0) { // addGroup 성공
					String groupAddr = vo.getParentCn() + "@" + domain;
					
					logger.debug("groupAddr=" + groupAddr);
					
					rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
					
					if (rc == 0) { // updateGroupAdd 성공						
						String bizmekaResult = "ERROR";
						
						// insertDBData_dept 실패했을 경우 JMocha에서 부서 다시 삭제.
						try {
							String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
							
							if (useBizmekaSpambox.equals("YES")) {
								String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
								String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
								String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
								String parentDeptId = vo.getParentCn();
								
								// 비즈메카에서는 조직도 최상위 회사의 ID가 Top이 아닌 companyId를 사용하므로 상위부서가 Top인 경우 변경한다.
								if (parentDeptId.equals("Top")) {
									parentDeptId = bizmekaCompanyId;
								}
								
								bizmekaResult = ezEmailUtil.bizmekaAddDept(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, 
														cn, vo.getDisplayName(), parentDeptId);		
								
								logger.debug("bizmekaResult=" + bizmekaResult);
								
								if (!bizmekaResult.equals("OK")) {
									throw new Exception("bizmekaAddDept failed");
								}						
							}
							
							mailAddr = getEmailAddressBasedOnCompanyDomainName(mailAddr, cn, vo.getParentCn(), userInfo, selectDomain);
									
							vo.setMail(mailAddr);
							
							ezOrganAdminService.insertDBData_dept(vo);
							result = "OK";	
						} catch (Exception e) {
							ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
							ezEmailUserAdminService.removeGroup(mailAddr);							
							result = "EMAIL_ERROR";
						}
						// 2024-03-20 장혜연 : 부서 추가 시 부서변경히스토리에 기록한다.
						if (result.equals("OK")) {
							deptChangeInfo.setDeptChVo(vo.getCn(), vo.getDisplayName(), vo.getDisplayName2(),
									vo.getParentCn(), "", "", "", "add", ClientUtil.getClientIP(request));
							ezSystemAdminService.insertDeptChangeHist(deptChangeInfo, userInfo);
						}
					}
					else {
						ezEmailUserAdminService.removeGroup(mailAddr);
						result = "EMAIL_ERROR";
					}
				} else {
					result = "EMAIL_ERROR";
				}
				// skyblue0o0 - end
				
			}
		}
		
		logger.debug("saveDeptInfo ended");
		
		return result;
	}
	
	private String getEmailAddressBasedOnCompanyDomainName(
			String originalMailAddr, String cn, String parentCn, LoginVO userInfo, String selectDomain) {
		try {
			// 상위 부서를 통해 Company ID를 구한다.
			OrganDeptVO parentDeptVO = ezOrganService.getDeptInfo(parentCn, userInfo.getPrimary(), userInfo.getTenantId());
			String parentCompanyId = parentDeptVO.getExtensionAttribute2();
			parentCompanyId = parentCompanyId != null ? parentCompanyId : "";
			
			logger.debug("parentCompanyId=" + parentCompanyId);
			
			if (!parentCompanyId.isEmpty()) {
				String companyDomainName = ezCommonService.getCompanyConfig(userInfo.getTenantId(), parentCompanyId, "DomainName");
				companyDomainName = StringUtils.isNotEmpty(selectDomain) ? selectDomain : companyDomainName;
				String tenantDomain = originalMailAddr.split("@")[1];
				logger.debug("companyDomainName=" + companyDomainName + ", tenantDomain=" + tenantDomain);
	
				// 회사별 이메일 도메인명이 설정되어 있으면 tbl_tenant_config에 있는 DomainName 대신에
				// 해당 도메인명을 사용해 이메일 주소를 생성한다.	
				// companyDomainName != tenantDomain > 선택한 도메인이 tenant domain일 경우 아래의 처리는 하지 않는다.
				if (!companyDomainName.isEmpty() && !companyDomainName.equals(tenantDomain)) {
					logger.debug("Setting originalMailAddr based on companyDomainName...");
					
					String newMailAddr = cn + "@" + companyDomainName;
					
					/* jmocha_alias 추가 */
					String targetAddr = cn + "@" + tenantDomain;
					
					String setAliasResult = ezEmailService.setIndividualAliasForMig(cn, userInfo.getTenantId(), targetAddr, newMailAddr);

					if (!setAliasResult.equals("OK")) {
						logger.debug("set Alias address failed.");
					} else {
						originalMailAddr = newMailAddr;
					}
					
					/*// 해당 주소를 Alias 주소로 등록한다.
					int rc = ezEmailUserAdminService.addGroup(newMailAddr);
					
					logger.debug("addGroup rc=" + rc);
					
					if (rc == 0) {
						// 해당 주소의 멤버로 원 이메일 주소를 등록한다.
						rc = ezEmailUserAdminService.updateGroupAdd(newMailAddr, originalMailAddr);
						
						logger.debug("updateGroupAdd rc=" + rc);
						
						if (rc == 0) {
							// 해당 주소로 원 이메일 주소를 교체한다.
							originalMailAddr = newMailAddr;
							
							logger.debug("newMailAddr=" + newMailAddr);
						} else {
							ezEmailUserAdminService.removeGroup(newMailAddr);
						}
					}*/
				}
			}		
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		return originalMailAddr;		
	}
	
	private void removeEmailAddressBasedOnCompanyDomainName(
			String cn, String companyId, LoginVO userInfo) {
		try {
			companyId = companyId != null ? companyId : "";
			
			logger.debug("companyId=" + companyId);
			
			if (!companyId.isEmpty()) {
				String companyDomainName = ezCommonService.getCompanyConfig(userInfo.getTenantId(), companyId, "DomainName");
				logger.debug("companyDomainName=" + companyDomainName);
	
				// 회사별 이메일 도메인명이 설정되어 있으면 해당 도메인명을 기반으로 한 이메일 주소를 james_recipient_rewrite 테이블에서 제거한다.								
				if (!companyDomainName.isEmpty()) {
					logger.debug("Removing Email Address based on companyDomainName...");
					
					// String newMailAddr = cn + "@" + companyDomainName;
					
					// 해당 주소를 james_recipient_rewrite 테이블에서 제거한다.
					// ezEmailUserAdminService.removeGroup(newMailAddr);					

					/* jmocha_alias, james_recipient_rewrite 삭제 */
					int delAliasResult = ezEmailService.deleteIndividualAlias(cn, userInfo.getTenantId());

					if (delAliasResult == -100) {
						logger.debug("delete Alias address failed.");
					}
					
				}
			}		
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}				
	}
	
	/**
	 * 조직도관리 부서이동 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/selectDept.do", method = RequestMethod.GET)	
	public String selectDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		//관리자 권한 체크
		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
				
		String topID = organAuth.isAuth(AdminAuth.ADMIN_MASTER)? "Top" : user.getCompanyID();

        model.addAttribute("companyID", topID);
		
        logger.debug("selectDept ended.");
        
		return "admin/ezOrgan/selectDept";
	}
	
	/**
	 * 조직도관리 부서이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/movDept.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String movDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
	    logger.debug("movDept started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("movDept: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
	    
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);       
	    
		String parentCn = request.getParameter("parentCn");
		String cn = request.getParameter("cn");
		
        logger.debug("parentCn=" + parentCn + ",cn=" + cn);
        
        String result = "OK";
		String bizmekaResult = "ERROR";
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
        String orgParentCn = ezOrganAdminService.getDeptParentCn(cn, tenantID);
		if (useBizmekaSpambox.equals("YES")) {
			String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
			String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
			String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
			String parentDeptId = parentCn;
			
			// 비즈메카에서는 조직도 최상위 회사의 ID가 Top이 아닌 companyId를 사용하므로 상위부서가 Top인 경우 변경한다.
			if (parentDeptId.equals("Top")) {
				parentDeptId = bizmekaCompanyId;
			}
			
			bizmekaResult = ezEmailUtil.bizmekaMoveDept(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn, parentDeptId);		
			
			logger.debug("bizmekaResult=" + bizmekaResult);
			
			if (!bizmekaResult.equals("OK")) {
				result = "EMAIL_ERROR";
			}
		}

		if (result.equals("OK")) {
	        result = ezOrganAdminService.moveEntry(parentCn, cn, "group", userInfo.getOffset(), tenantID);
	        	        
	        logger.debug("moveEntry result=" + result);
	        //2024-03-20 장혜연 : 부서 이동 시 부서변경히스토리에 기록한다.
			if ("OK".equals(result)) {
				DeptChangeInfoVO deptChangeInfo = new DeptChangeInfoVO();
				OrganDeptVO deptNm = ezOrganAdminService.getDeptDisplayNm(cn, tenantID); // 이동 할 부서 명
				OrganDeptVO parentNm = ezOrganAdminService.getDeptDisplayNm(parentCn, tenantID); // 이동 후 상위부서 명

			deptChangeInfo.setDeptChVo(cn, deptNm.getDisplayName(), deptNm.getDisplayName2(), orgParentCn, parentCn,
					parentNm.getDisplayName(), parentNm.getDisplayName2(), "move", ClientUtil.getClientIP(request));
			ezSystemAdminService.insertDeptChangeHist(deptChangeInfo, userInfo);
		}
		
		
	}

		//게시판 트리캐시 삭제
		ezBoardAdminService.trunkBoard(tenantID);
        
		logger.debug("movDept ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 부서검색 시 중복된 부서가 있을 경우 선택 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/checkName2.do", method = RequestMethod.GET)	
	public String checkName2() throws Exception{	
		return "admin/ezOrgan/checkName2";
	}
	
	/**
	 * 조직도관리 부서 표출순서 조정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveOrderList.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveOrderList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
        logger.debug("saveOrderList started.");
        
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	throw new Exception("saveOrderList failed.");
        }        
        
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
        String column = "EXTENSIONATTRIBUTE15";
        String deptID = request.getParameter("deptId");
        String userType = request.getParameter("userType");
		String pClass = request.getParameter("pClass");
		String cn = request.getParameter("cn");
		String[] cnDatas = cn.split(",");
		String[] userTypeDatas = userType.split(",");
		String result = "";
		
		logger.debug("pClass=" + pClass + ",cn=" + cn + ",userType=" + userType);
		
		String pClassTemp = pClass;
		for (int i = 0; i < cnDatas.length; i++) {
			if (pClassTemp.toLowerCase().equals("user")) {
				pClass = userTypeDatas[i];
				column = pClass.equals("addJob") ? "ORDERBY" : "EXTENSIONATTRIBUTE15";
			}

			ezOrganAdminService.updateProperty(cnDatas[i], column, i+"", pClass, tenantID, deptID);	
		}
		
		logger.debug("saveOrderList ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 사원정보 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/userInfo.do", method = RequestMethod.GET)	
	public String userInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
	    logger.debug("userInfo started");
	    
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String lang = userInfo.getLang();		
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		String useAddressOpenAPI = config.getProperty("config.USE_AddressOpenAPI");
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", userInfo.getTenantId());
		String useZipCodeSearch = ezCommonService.getTenantConfig("useZipCodeSearch", userInfo.getTenantId());
		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId());
		
		if (useZipCodeSearch == null || useZipCodeSearch.equals("")) {
			useZipCodeSearch = "YES";
		}
		
		boolean useOnlyInnerMail = "yes".equalsIgnoreCase(ezCommonService.getTenantConfig("UseOnlyInnerMail", userInfo.getTenantId()));
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("lang", lang);
		model.addAttribute("useAddressOpenAPI", useAddressOpenAPI);
		model.addAttribute("birthDay", "");
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("useBizmekaSpambox", useBizmekaSpambox);
		model.addAttribute("useZipCodeSearch", useZipCodeSearch);
		model.addAttribute("locale", userInfo.getLocale());
		model.addAttribute("userPrimary", userInfo.getPrimary());
		model.addAttribute("useOnlyInnerMail", useOnlyInnerMail);
		model.addAttribute("useOrganHideFlag", useOrganHideFlag);

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String securityNode3 = ezApprovalGService.getSecurityType("", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), approvalFlag);

		model.addAttribute("securityNode3", securityNode3);
		model.addAttribute("approvalFlag", approvalFlag);

		logger.debug("userInfo ended");
		
		return "admin/ezOrgan/userInfo";
	}
	
	/**
	 * 조직도관리 서명등록 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/configSignImage.do", method = RequestMethod.GET)	
	public String configSignImage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
	    logger.debug("configSignImage started");
	    
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = request.getParameter("id");
		String userInfo_approvalG = config.getProperty("config.UserInfo_ApprovalG");
		String signImageSize = ezCommonService.getTenantConfig("SignImageSizeLimit", userInfo.getTenantId());
		String sign = "APPROVALSIGN";
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
        
		if (userInfo_approvalG.equals("YES")) {
			sign = "APPROVALGSIGN";
		}
		
		model.addAttribute("userID", userID);
		model.addAttribute("userInfo_approvalG", userInfo_approvalG);
		model.addAttribute("signImageSize", signImageSize);
		model.addAttribute("signPath", sign);
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		logger.debug("configSignImage ended");
		
		return "admin/ezOrgan/configSignImage";
	}
	
	/**
	 * 조직도관리 전자결재 서명 이미지 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getApprovalSignInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getSignImage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		LoginSimpleVO userInfo = commonUtil.userInfoSimple(loginCookie);
		
		String type = request.getParameter("type");
		String fileName = request.getParameter("fileName");
		
		if (type.equals("APPROVALSIGN")) {
			//2016-04-15 장진혁과장 -- Approval Attach 구현 필요
		} else {			
			String filePath = commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + fileName.substring(0, fileName.lastIndexOf("_")) + commonUtil.separator + fileName;
			
			if (fileName != null && !fileName.equals("")) {
				downImage(filePath, request, response);
			}
		}	
	}
	
	/**
	 * 조직도관리 암호관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/inputPassword.do", method = RequestMethod.GET)
	public String inputPassword(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model, Locale locale) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		int tenantId = userInfo.getTenantId();
		
		String companyId = request.getParameter("companyId");
		String userId = request.getParameter("userId");
		logger.debug("companyId={}, userId={}", companyId, userId);
		
		String pwPolicyExplain = commonUtil.getPwPolicyExplain(companyId, tenantId, locale);
		
		model.addAttribute("pwPolicyExplain", pwPolicyExplain);
		model.addAttribute("userId", userId);
		return "admin/ezOrgan/inputPassword";
	}
	
	/**
	 * 조직도관리 새로운 비밀번호 설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/changePassword.do", method = RequestMethod.POST)
	@ResponseBody
	public void changePassword(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("changePassword started.");
	    
		String pw = request.getParameter("password");
		String cn[] = request.getParameter("cn").split(",");
		
		logger.debug("cn=" + request.getParameter("cn")); 
		
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	throw new Exception("changePassword failed.");
        }

        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);		
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		
		logger.debug("domain=" + domain);
		// dhlee - end
		
		for (int i = 0; i < cn.length; i++) {
			ezOrganAdminService.setPasswordWithEmailSystem(cn[i], domain, pw, tenantID);
		}
		
		logger.debug("changePassword ended.");
	}
	
	/**
	 * 조직도관리 OTP초기화 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/otpReset.do", method = RequestMethod.POST, produces = "text/html; charset=utf-8")
	@ResponseBody
	public String otpReset(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("otpReset started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("otpReset: it's not admin");

			return "EMAIL_ERROR";
		}

		int tenantId = userInfo.getTenantId();
		String otpResetUser = request.getParameter("otpResetMultiUserlist");
		String otpResetlist[] = otpResetUser.split(",");
		String result = "OK";

		logger.debug("tenantId={}, otpResetUser={}", tenantId, otpResetUser);

		try {

			for (int i = 0; i < otpResetlist.length; i++) {
				logger.debug("otpResetlist[" + i + "]=" + otpResetlist[i]);

				ezCommonService.updateUserConfigInfo(tenantId, otpResetlist[i], "otpKey", "");
			}

		} catch (Exception e) {
			logger.error("OTP Reset UpdateException : ", e);
			result = "FAIL";
		}

		logger.debug("otpReset ended. reset by {}, result={}", userInfo.getId(), result);

		return result;
	}

	/**
	 * 조직도관리 사원퇴직 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUser.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String retireUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("retireUser started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("retireUser: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
                
        // UUID로 pass 변경
        //String adminPassword = UUID.randomUUID().toString();
        
        int tenantID = userInfo.getTenantId();
        String offset = userInfo.getOffset();
        
        String cnList = request.getParameter("cn");

        logger.debug("tenantID=" + tenantID + ",offset=" + offset +",cnList=" + cnList);
        	    
		String cn[] = cnList.split(",");
		String result = "OK";
		
		// dhlee
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		// dhlee - end
		
		for (int i = 0; i < cn.length; i++) {			
			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			int rc = ezEmailUserAdminService.retireUser(mailAddr);
			
			logger.debug("retireUser rc=" + rc);
			
			List<String> distributionList = null;
			
			if (rc == 0) { // retireUser 성공				
				// 해당 User가 속한 Group Email 주소에서 해당 User를 제거한다.
				OrganUserVO userVO = ezOrganAdminService.getUserInfo(cn[i], userInfo.getPrimary(), tenantID);
				String groupAddr = userVO.getDepartment() + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
				
				logger.debug("updateGroupDel rc=" + rc);
				
				if (rc != -100) { // updateGroupDel 성공(부모(그룹)나 자식(유저)을 찾지못해도 성공으로 봄.)
					try {
						// 로컬 시스템에서 해당 User의 계정을 퇴직처리한다.
						ezOrganAdminService.retireEntry(cn[i], domain, tenantID, offset);
					} catch (Exception e) { // Exception이 발생하면 복구 처리를 한다.
						ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
						ezEmailUserAdminService.restoreUser(mailAddr);
						result = "EMAIL_ERROR";
						break;
					}					
				} else { // updateGroupDel 실패
					// Group Email 주소에서 제거하는 것이 실패하면 해당 User를 복원시키고, Exception을 발생시킨다.
					ezEmailUserAdminService.restoreUser(mailAddr);
					
					logger.debug("removing the user '" + mailAddr + "' from its group email failed.");
					
					result = "EMAIL_ERROR";
					break;					
				}
				// 사용자가 속한 공용배포그룹의 Group Email 주소 목록을 구한다.
				distributionList = ezEmailUserAdminService.getUserDistributionList(mailAddr);
				
				for (String dist : distributionList) {
					logger.debug("dist=" + dist);
					
					// 공용배포그룹의 Group Email 주소로부터 해당 User를 제거한다.
					rc = ezEmailUserAdminService.updateGroupDel(dist, mailAddr);	
					
					logger.debug("updateGroupDel rc=" + rc);							
				}
				
				// 사용자 정의 공용배포그룹 관련 테이블에서 user를 제거한다.
				int delUserDL = ezEmailUserAdminService.deleteAllUserDistributionForMember(mailAddr, domain);
				logger.debug("delUserDl=" + delUserDL); // 0 성공, -1 실패
				
				// 공유사서함 기능 사용 시 공유사서함의 공유자에서 해당 유저를 제외한다.
				String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantID);
	    		
	    		if (useSharedMailbox.equals("YES")) {
	    			rc = ezEmailService.deleteUserFromAllSharedMailbox(cn[i], tenantID);
	    			
	    			logger.debug("deleteUserFromAllSharedMailbox rc=" + rc);
	    		}
				// 메일 자동 전달, 자동분류 설정 삭제
				rc = ezEmailUserAdminService.removeUserMailSetting(mailAddr);
				logger.debug("removeUserMailSetting rc=" + rc);
			}


			//사용자 변경 히스토리 테이블에 insert
			UserChangeInfoVO userChangeInfoVO = new UserChangeInfoVO();
			userChangeInfoVO.setUserId(cn[i]);
			userChangeInfoVO.setTenantId(tenantID);
			userChangeInfoVO.setUpdateType("retire");
			userChangeInfoVO.setExecutorIp(ClientUtil.getClientIP(request));
			userChangeInfoVO.setTargetType("user");
			
			try {
				ezSystemAdminService.insertUserChangeHist(userChangeInfoVO, userInfo);				
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
			
			// dhlee - end
		}
		
		logger.debug("retireUser ended. result=" + result);
		
		return result;
	}
	
	/**
	 * 조직도관리 사원이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/movUser.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String movUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
	    logger.debug("movUser started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("movUser: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
	    
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String parentCn = request.getParameter("parentCn");
		String cn[] = request.getParameter("cn").split(",");
		String result = "OK";
		
		logger.debug("parentCn=" + parentCn);
		
		String bizmekaResult = "ERROR";
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);		
		
		for (int i=0; i < cn.length; i++) {
		    logger.debug("cn[" + i + "]=" + cn[i]);		    
			
			if (useBizmekaSpambox.equals("YES")) {
				String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
				String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
				String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
				String parentDeptId = parentCn;
				
				// 비즈메카에서는 조직도 최상위 회사의 ID가 Top이 아닌 companyId를 사용하므로 상위부서가 Top인 경우 변경한다.
				if (parentDeptId.equals("Top")) {
					parentDeptId = bizmekaCompanyId;
				}
				
				bizmekaResult = ezEmailUtil.bizmekaMoveUser(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn[i], parentDeptId);		
				
				logger.debug("bizmekaResult=" + bizmekaResult);
				
				if (!bizmekaResult.equals("OK")) {
					result = "EMAIL_ERROR";
					break;
				}
			}
			
			// 사용자의 원부서 조회 
			OrganUserVO originDeptInfo = ezOrganAdminService.getUserDeptInfo(cn[i], tenantID);
		    
			result = ezOrganAdminService.moveEntry(parentCn, cn[i], "user", userInfo.getOffset(), tenantID);
				
			logger.debug("moveEntry result=" + result);
			
			if (!result.equals("OK")) {
				break;
			}else {
				
				//2023-07-03 장혜연 사용자 변경 히스토리 테이블에 값 삽입  
				UserChangeInfoVO userChangeInfoVO = new UserChangeInfoVO();
				OrganDeptVO targetDeptNm = ezOrganAdminService.getDeptDisplayNm(parentCn, tenantID);
				userChangeInfoVO.setUserId(cn[i]);
				userChangeInfoVO.setTenantId(tenantID);
				userChangeInfoVO.setManualFlag("Y");
				userChangeInfoVO.setUpdateType("mvDept");
				userChangeInfoVO.setExecutorIp(ClientUtil.getClientIP(request));
				userChangeInfoVO.setDeptId(originDeptInfo.getDepartment()); 
				userChangeInfoVO.setDeptNm(originDeptInfo.getDescription());
				userChangeInfoVO.setDeptNm2(originDeptInfo.getDescription2());
				userChangeInfoVO.setTargetDeptId(parentCn);
				userChangeInfoVO.setTargetDeptNm(targetDeptNm.getDisplayName());
				userChangeInfoVO.setTargetDeptNm2(targetDeptNm.getDisplayName2());
				
				
				try {
					ezSystemAdminService.insertUserChangeHist(userChangeInfoVO, userInfo);				
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
							
			}
	        	
		}
		
		//게시판 트리캐시 삭제
		ezBoardAdminService.trunkBoard(tenantID);
		
		logger.debug("movUser ended.");
		
		return result;
	}
	
	/**
	 * 조직도관리 사원삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/delUser.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String delUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("delUser started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("delUser: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
        
        int tenantID = userInfo.getTenantId();        
        String cnList = request.getParameter("cn");
        
        logger.debug("tenantID=" + tenantID + ",cnList=" + cnList);
	    
        String realPath = commonUtil.getRealPath(request);
        
		String cn[] = cnList.split(",");
		String result = "OK";
		
		// dhlee
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		// dhlee - end
				
		for (int i = 0; i < cn.length; i++) {
			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			// 이메일 계정이 있는 지 확인한다.
			int userExists = ezEmailUserAdminService.checkUserExists(mailAddr);
			int rc = 0;
			
			logger.debug("userExists=" + userExists);
			
			// 박예연 사용자 삭제시 웹폴더 개인 폴더들의 파일 데이터 삭제 추가 
			JSONObject resultBody = null;
			try {
				logger.debug("user delete webfolderData delete. start.");
				Map<String, Object> jsonObj = new HashMap<>();
				jsonObj.put("userId", cn[i]);
				jsonObj.put("adminId", userInfo.getId());
				
				resultBody = commonUtil.getJsonFromWebFolderRestApi("/rest/ezwebfolder/delete-user-alldata", 
						null, request, "post", new JSONObject(jsonObj));
				
				if (!resultBody.get("status").equals("ok")) {
					logger.debug("webfolderDelete error. status is " + resultBody.get("status"));
				}
				logger.debug("user delete webfolderData delete. end.");
			} catch(Exception e)  {
				logger.debug("webfolderDelete error.");
				logger.error(e.getMessage(), e);
			}
			
			if (userExists == 0) { // 이메일 계정이 존재하지 않음.
				// 로컬 시스템 계정을 삭제한다.
				ezOrganAdminService.deleteDBData(cn[i], "user", tenantID);
				ezOrganAdminService.deleteDestUserProfileImage(cn[i], tenantID, realPath); // 2023-02-28 김은실 : 프로필 이미지  삭제
			} else if (userExists == 1 || userExists == 2) { // 1은 유효한 이메일 계정. 2는 퇴직자 계정. (주의: 2는 더이상 사용되지 않으나 그대로 둠)
				List<String> distributionList = null;
				String groupAddr = null;
				
				if (userExists == 1) { // 유효한 이메일 계정이 존재함.						
					// 먼저 퇴직자 처리를 수행한다. 로컬 계정 삭제가 실패할 경우 복구를 위해.
					// 주의) 메일 계정의 퇴직자 처리는 더이상 존재하지 않으나 그대로 둠(퇴직자라도 계속 개인 메일은 수신함).
					rc = ezEmailUserAdminService.retireUser(mailAddr);

					logger.debug("retireUser rc=" + rc);
					
					if (rc == 0) {
						// 사용자가 속한 부서의 Group Email 주소를 구한다.
						OrganUserVO userVO = ezOrganAdminService.getUserInfo(cn[i], userInfo.getPrimary(), userInfo.getTenantId());
						groupAddr = userVO.getDepartment() + "@" + domain;				
						
						// 부서의 Group Email 주소로부터 해당 User를 제거한다.
						rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
						
						logger.debug("updateGroupDel rc=" + rc);
						
						if (rc == -100) { // Group Email 주소에서 제거 실패함.(부모(그룹)나 자식(유저)를 찾지 못한 경우는 성공으로 취급함)
							ezEmailUserAdminService.restoreUser(mailAddr);
							
							logger.debug("removing the user '" + mailAddr + "' from its group email failed.");
							
							result = "EMAIL_ERROR";
							break;
						}						
						
						// 사용자가 속한 공용배포그룹의 Group Email 주소 목록을 구한다.
						distributionList = ezEmailUserAdminService.getUserDistributionList(mailAddr);
						
						for (String dist : distributionList) {
							logger.debug("dist=" + dist);
							
							// 공용배포그룹의 Group Email 주소로부터 해당 User를 제거한다.
							rc = ezEmailUserAdminService.updateGroupDel(dist, mailAddr);	
							
							logger.debug("updateGroupDel rc=" + rc);							
						}
					} else {
						logger.debug("retiring the user '" + mailAddr + "' failed.");
						
						result = "EMAIL_ERROR";
						break;						
					}
				} 
							
				String bizmekaResult = "ERROR";
				
				try {
					String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
					
					// 비즈메카와 연동된 경우에는 비즈메카 API를 이용해 비즈메카 사용자 계정을 삭제한다.
					if (useBizmekaSpambox.equals("YES")) {
						String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
						String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
						String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
						
						bizmekaResult = ezEmailUtil.bizmekaDeleteUser(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn[i]);		
						
						logger.debug("bizmekaResult=" + bizmekaResult);
						
						if (!bizmekaResult.equals("OK")) {
							throw new Exception("bizmekaDeleteUser failed");
						}						
					}
										
					// 로컬 시스템 계정을 삭제한다.
					ezOrganAdminService.deleteDBData(cn[i], "user", tenantID);
					ezOrganAdminService.deleteDestUserProfileImage(cn[i], tenantID, realPath); // 2023-02-28 김은실 : 프로필 이미지  삭제
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
					if (userExists == 1) { // 유효한 이메일 계정이었으면 복구 처리를 수행한다.
						if (distributionList != null) {
							for (String dist : distributionList) {
								logger.debug("dist=" + dist);
								
								// 공용배포그룹의 Group Email 주소에 해당 User를 추가한다.
								rc = ezEmailUserAdminService.updateGroupAdd(dist, mailAddr);	
								
								logger.debug("updateGroupAdd rc=" + rc);							
							}													
						}
						
						ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
						ezEmailUserAdminService.restoreUser(mailAddr);							
					}
					result = "EMAIL_ERROR";
					break;
				}
				
				// 아래 과정에서 에러가 발생하면 복구할 수는 없지만, 이미 유효한 계정이 아니므로
				// 저장 공간은 차지하지만 해당 계정이 사용되지는 않는다. 
				
				// 퇴직자 계정을 삭제한다.
				ezEmailUserAdminService.removeUser(mailAddr);
				
				// 공유사서함 기능 사용 시 공유사서함의 공유자에서 해당 유저를 제외한다.
				String useSharedMailbox = ezCommonService.getTenantConfig("useSharedMailbox", tenantID);
	    		
	    		if (useSharedMailbox.equals("YES")) {
	    			rc = ezEmailService.deleteUserFromAllSharedMailbox(cn[i], tenantID);
	    			logger.debug("deleteUserFromAllSharedMailbox rc=" + rc);
	    		}
				
	    		// 해당 사용자의 alias 메일주소를 삭제한다.
	    		rc = ezEmailService.deleteIndividualAlias(cn[i], tenantID);
	    		logger.debug("deleteIndividualAlias rc=" + rc);
	    		
				// 해당 사용자의 메일박스들을 모두 제거한다.
	    		rc = ezEmailUserAdminService.removeUserAllMailboxes(mailAddr);
	    		logger.debug("removeUserAllMailboxes rc=" + rc);
	    		
				// 해당 사용자의 개인주소록 및 주소록 관련 설정을 모두 제거한다.
	    		rc = ezAddressService.removeUserAddress(mailAddr);
	    		logger.debug("removeUserAddress rc=" + rc);

				// 해당 사용자의 메일자동삭제 설정을 모두 제거한다. -1 = error
	    		rc = ezEmailService.deleteMailDeleteForUser(mailAddr);
	    		logger.debug("deleteMailDeleteForUser rc=" + rc);
	    		
				// 해당 사용자의 메일 템플릿을 모두 제거한다
	    		rc = ezEmailService.deleteUserMailTemplate(mailAddr, "", "all", realPath, tenantID);
	    		logger.debug("deleteMailUserTemplate rc=" + rc);
	    		
	    		// 메일 자동 전달, 자동분류 설정 삭제
				rc = ezEmailUserAdminService.removeUserMailSetting(mailAddr);
				logger.debug("removeUserMailSetting rc=" + rc);
			}
			if("OK".equals(result)) {
				//2023-07-03 장혜연 사용자 변경 히스토리 테이블에 insert  
				UserChangeInfoVO userChangeInfoVO = new UserChangeInfoVO();
				userChangeInfoVO.setUserId(cn[i]);
				userChangeInfoVO.setTenantId(tenantID);
				userChangeInfoVO.setManualFlag("Y");
				userChangeInfoVO.setUpdateType("delete");
				userChangeInfoVO.setExecutorIp(ClientUtil.getClientIP(request));
				userChangeInfoVO.setTargetType("user");
				
				try {
					ezSystemAdminService.insertUserChangeHist(userChangeInfoVO, userInfo);				
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
			
			// dhlee - end
		}		
		
		//게시판 트리캐시 삭제
		ezBoardAdminService.trunkBoard(tenantID);
		
		logger.debug("delUser ended. result=" + result);
		
		return result;
	}
	
	private String checkLicenseKey(int tenantID, String domain) throws Exception {
		String licenseKey = ezCommonService.getTenantConfig("LicenseKey", tenantID);
		
		logger.debug("licenseKey=" + licenseKey);
		
		// 입력된 라이센스키가 발견되지 않는 경우
		if (licenseKey == null || licenseKey.equals("")) {
			logger.debug("No License Key is found.");
			
			return "NO_LICENSE_KEY";
		}
		
		try {
			// 라이센스키를 복호화한다.
			licenseKey = egovFileScrty.decryptAES(licenseKey);
		} catch (Exception e) {
			logger.debug("License Key Decryption failed.");
			
			return "INVALID_LICENSE_KEY";
		}
		
		logger.debug("Decrypted licenseKey=" + licenseKey);
		
		String items[] = licenseKey.split(":");
		
		if (items.length < 2) {
			logger.debug("Number of License Key Items is less than 2");
			
			return "INVALID_LICENSE_KEY";					
		}
		
		String licensedDomainName = items[0];
		
		if (!licensedDomainName.equals(domain)) {
			logger.debug("licensedDomainName=" + licensedDomainName + ",domain=" + domain);
			
			return "INVALID_LICENSE_KEY";										
		}
		
		String licensedUserCountStr = items[1];
		
		int licensedUserCount = 0; 
				
		try {
			licensedUserCount = Integer.parseInt(licensedUserCountStr);
		} catch (NumberFormatException e) {
			logger.debug("Parsing Licensed User Count failed.");
			
			return "INVALID_LICENSE_KEY";										
		}
		
		int userCount = ezOrganAdminService.getUserCount(tenantID);
		
		// masteradmin 사용자를 제외하기 위해 1을 뺀다.
		userCount--;
		// 승인메일 공유사서함이 있으면 해당 계정은 라이센스에서 제외
		Boolean apprSharedExist = BooleanUtils.toBoolean(ezOrganAdminService.userCheck("__approved_mail", tenantID));
		if (apprSharedExist) {
			userCount--;
		}
		
		logger.debug("licensedUserCount=" + licensedUserCount + ",userCount=" + userCount);
				
		if (licensedUserCount <= userCount) {
			logger.debug("Maximum User Count already reached");
			
			return "MAX_USER_REACHED";															
		}
		
		return "OK";
	}
	
	/**
	 * 조직도관리 사원정보 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveUserInfo.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveUserInfo(@CookieValue("loginCookie") String loginCookie, OrganUserVO vo, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception{
	    logger.debug("saveUserInfo started.");
	    
	    LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
	    
        //관리자 권한 체크
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }

        // JMocha Mail Server가 계정이 소문자로 저장될 필요가 있어 
        // 사용자 아이디를 무조건 소문자로 변환한다.
        // 소문자로 저장되기만 하면 메일 수신 시에는 발신자가 대소문자를 혼합해서 보내도
        // 수신에 문제는 없다.
        if (vo.getCn() != null) {
        	vo.setCn(vo.getCn().toLowerCase());
        }
        
	    int tenantID = userInfo.getTenantId();

	    vo.setTenantId(tenantID);
	    
	    SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        date.setTimeZone(TimeZone.getTimeZone("GMT"));
        String nowDate = date.format(new Date()); 
        vo.setNowDate(nowDate);
	    
	    logger.debug("tenantID=" + tenantID + ",parentCn=" + vo.getParentCn());
	    
		String result = "";
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());
		// 전체관리자가 또는 회사관리자가 아닌데 관리자 권한을 설정하려는 경우엔 CHECKPERMISSION을 반환한다.
		// ezSyncServer가 ezFlow를 호출하는 경우엔 loginCookie에 부서 아이디가 없어 부서아아디 체크를 추가함
        if (userInfo.getDeptID() != null && !userInfo.getDeptID().isEmpty() &&
				!organAuth.isAuth(AdminAuth.ADMIN_MASTER) && !organAuth.isAuth(AdminAuth.COMPANY_MANAGER)) {
            result = "CHECKPERMISSION";		
		// 기존 사용자를 수정하는 경우엔 parentCn의 값이 null 혹은 empty string 이다.
        } else if (vo.getParentCn() == null || vo.getParentCn().equals("")) {
        	try {
				String cn = vo.getCn();
				String employeeNumber = vo.getExtensionAttribute14();
				PreResult preResult = ezOrganAdminService.checkDuplicateLoginId(cn, employeeNumber, tenantID);

				logger.debug("pre result={}", preResult);

				if (preResult.succeeded()) {
					ezOrganAdminService.updateDBData_user(vo);
					result = "OK";
				} else {
					result = preResult.toString();
				}
        	} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
        		logger.error(e.getMessage(), e);
        		logger.error(e.getMessage(), e);
        		result = "EMAIL_ERROR";
        	}
			try {
				if ("".equalsIgnoreCase(vo.getExtensionAttribute2())){
					String realPath = commonUtil.getRealPath(request);
					ezOrganAdminService.deleteDestUserProfileImage(userInfo.getId(), userInfo.getTenantId(), realPath);
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}

		// 새로운 사용자를 등록한다.
		} else {
			String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
			String cn = vo.getCn();
						
			logger.debug("domain=" + domain + ",cn=" + cn);
			
			// 사용자, 부서, 퇴직자, 회사 상관없이 기존에 사용되는 아이디를 체크한다.
			// 공용배포그룹ID, 메일ID(alias 메일ID 포함)로 이미 사용중인지도 체크한다.
			// UseEmpNumberLogin이 YES일때는 사번도 중복되는지 검사한다.
			String employeeNumber = vo.getExtensionAttribute14();
			PreResult preResult = ezOrganAdminService.checkDuplicateId(cn, employeeNumber, tenantID);
			
			logger.debug("pre result={}", preResult);
			
			if (preResult.failed()) {
				result = preResult.toString();
			} else {
				// 라이센스키를 체크한다.
				String checkResult = checkLicenseKey(tenantID, domain);
				
				if (!checkResult.equals("OK")) {
					return checkResult;
				}
				
				String mailAddr = cn + "@" + domain;

				// 이메일 시스템에 계정을 생성한다.
				int rc = ezEmailUserAdminService.addUser(mailAddr, vo.getPassword());

				// [국립암센터] POP3/IMAP 사용 설정
				String usePOP3Default = ezCommonService.getTenantConfig("usePOP3Default", tenantID);
				String useIMAPDefault = ezCommonService.getTenantConfig("useIMAPDefault", tenantID);

				JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/setPOP3IMAPConfig")
						.formParam("user_name", mailAddr)
						.formParam("usePOP3Default", usePOP3Default)
						.formParam("useIMAPDefault", useIMAPDefault)
						.exchangeJgwResult();
				
				logger.debug("addUser rc=" + rc);
				
				if (rc == 0) { // addUser 성공
					// 해당 User가 속한 부서의 Group Email 주소에 User를 등록한다.					
					String groupAddr = vo.getParentCn() + "@" + domain;					
					rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
					
					logger.debug("updateGroupAdd rc=" + rc);
					
					if (rc == 0) { // updateGroup 성공												
						String bizmekaResult = "ERROR";
						
						// insertDBData_user 실패했을 경우 JMocha에서 계정 다시 삭제.
						try {
							String useStandardFolderId = config.getProperty("config.useStandardFolderId");
							String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantID);
							
							if (useStandardFolderId != null && useStandardFolderId.equals("YES") && !useExternalMailServer.equalsIgnoreCase("YES")) {							
								createDefaultFolders(loginCookie, mailAddr, locale);
							}

							String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
							
							if (useBizmekaSpambox.equals("YES")) {
								String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
								String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
								String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
								String parentDeptId = vo.getParentCn();
								
								// 비즈메카에서는 조직도 최상위 회사의 ID가 Top이 아닌 companyId를 사용하므로 상위부서가 Top인 경우 변경한다.
								if (parentDeptId.equals("Top")) {
									parentDeptId = bizmekaCompanyId;
								}
								
								bizmekaResult = ezEmailUtil.bizmekaAddUser(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn, "", 
													vo.getDisplayName(), parentDeptId);		
								
								logger.debug("bizmekaResult=" + bizmekaResult);
								
								if (!bizmekaResult.equals("OK")) {
									throw new Exception("bizmekaAddUser failed");
								}
							}
							
							vo.setMail(mailAddr);				
							String userPrincipalName = cn + "@" + domain;
							vo.setUpnName(userPrincipalName);
							
						    String oriPass = vo.getPassword();
							String pass = EgovFileScrty.encryptPassword(vo.getPassword(), cn);
							vo.setPassword(pass);
							
							// 로컬 시스템에 해당 User의 계정을 생성한다.
							ezOrganAdminService.insertDBData_user(vo, oriPass);
														
							result = "OK";
						} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
							logger.error(e.getMessage(), e);
							ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
							ezEmailUserAdminService.removeUser(mailAddr);
							logger.error(e.getMessage(), e);
							result = "EMAIL_ERROR";
						}
					} else {
						// 부서의 Group Email 주소로의 등록에 실패하면 해당 User를 삭제하고 에러를 반환한다.
						ezEmailUserAdminService.removeUser(mailAddr);
						
						result = "EMAIL_ERROR";
					}
				} else {
					result = "EMAIL_ERROR";
				}			
			}
			
			if (result.equals("OK")) {
		        // UseInitMailSign이 YES일 경우 메일 서명 등록
				String useInitMailSign = ezCommonService.getTenantConfig("UseInitMailSign", tenantID);
				if (useInitMailSign.equals("YES")) {
					try {
						setInitMailSign(vo);
					} catch (Exception e) {
						logger.error("setInitMailSign error.");
						logger.error(e.getMessage(), e);
					}
				}
				
				// UseInitInboxRule이 YES일 경우 메일 자동분류 등록
				String useInitInboxRule = ezCommonService.getTenantConfig("UseInitInboxRule", tenantID);
				if (useInitInboxRule.equals("YES")) {
					try {
						setInitInboxRule(loginCookie, vo, locale);
					} catch (Exception e) {
						logger.error("setInitInboxRule error.");
						logger.error(e.getMessage(), e);
					}
				}
				
				if (!"".equals(ClientUtil.getClientIP(request))) {

					logger.debug("saveUserInfo IP : {} ", ClientUtil.getClientIP(request));
				}


				//2023-06-27 장혜연 사용자 변경 히스토리 테이블에 insert
				UserChangeInfoVO userChangeInfoVO = new UserChangeInfoVO();
				userChangeInfoVO.setUserId(cn);
				userChangeInfoVO.setTenantId(tenantID);
				userChangeInfoVO.setUpdateType("add");
				userChangeInfoVO.setExecutorIp(ClientUtil.getClientIP(request));
				userChangeInfoVO.setTargetType("user");
			
				try {
					ezSystemAdminService.insertUserChangeHist(userChangeInfoVO, userInfo);				
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
				}
			}
		}
		
		logger.debug("saveUserInfo ended. result=" + result);
		
		return result;
	}

	/**
	 * 사용자관리 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/totalUserList.do", method = RequestMethod.GET)
	public String totalUserList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		logger.debug("totalUserList started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());
		if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER) && !organAuth.isAuth(AdminAuth.COMPANY_MANAGER)) {
			return "cmm/error/adminDenied";
		}

		String companyID = userInfo.getCompanyID();
		List<OrganDeptVO> deptList = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();

		for (int i = 0; i < deptList.size(); i ++) {
			OrganDeptVO vo = deptList.get(i);
			if(userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(companyID)){
				resultList.add(i, vo);
			}
		};


		model.addAttribute("list", resultList);
		model.addAttribute("companyID", companyID);

		logger.debug("totalUserList ended.");

		return "admin/ezOrgan/totalUserList";
	}

	/**
	 * 사용자관리 - 사용자 목록 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getTotalUserList.do", method = RequestMethod.POST, produces = "text/plain;charset=UTF-8")
	@ResponseBody
	public String getTotalUserList(@CookieValue("loginCookie") String loginCookie,
			@RequestParam(required = false) String searchType,
			@RequestParam(required = false) String searchKeyword,
			Model model,
			HttpServletRequest request) throws Exception {
		logger.debug("getTotalUserList started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if(userInfo == null){
			return "cmm/error/adminDenied";
		}

		String companyID = request.getParameter("companyID");
		String currPage = request.getParameter("pageNum");

		if(currPage == null || currPage.equals("")){
			currPage = "1";
		}

		int maxItemPerPage = 20;
		int currentPage = Integer.parseInt(currPage);
		int startRow = Math.multiplyExact(Math.subtractExact(currentPage, 1), maxItemPerPage);

		if(currentPage == -1){
			startRow = -1;
		}

		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
		searchKeyword = commonUtil.getWildcardEscapedString(searchKeyword, dbName);

		boolean [] searchFor = {true, false, false, false};

		List<ArrayList<String>> userList = new ArrayList<ArrayList<String>>();

		List<OrganUserVO> userCnList = ezOrganAdminService.getUserList(Integer.valueOf(userInfo.getTenantId()), startRow, maxItemPerPage, searchType, searchKeyword, companyID, "", "", searchFor);
		int itemCnt = ezOrganAdminService.getUserCount(userInfo.getTenantId(), searchType, searchKeyword, searchFor, companyID);

		int totalPage = itemCnt / maxItemPerPage;

		if(itemCnt < 1){
			totalPage = 1;
		}

		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1;
		}

		currentPage = Math.min(currentPage, totalPage);

		boolean primary = userInfo.getPrimary().equals("1");

		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<TOTALCNT>" + itemCnt + "</TOTALCNT>");
		result.append("<TOTALPAGE>" + totalPage + "</TOTALPAGE>");
		result.append("<CURRPAGE>" + currentPage + "</CURRPAGE>");
		result.append("<SEARCHTYPE>" + searchType + "</SEARCHTYPE>");
		result.append("<ROWS>");
		
		for(OrganUserVO organUserVO : userCnList){
			
			String userID = organUserVO.getCn();
			String dept = primary ? organUserVO.getDescription() : organUserVO.getDescription2();
			String displayname = primary ? organUserVO.getDisplayName() : organUserVO.getDisplayName2();

			String title = primary ? organUserVO.getTitle() : organUserVO.getTitle2();
			String position = primary ? organUserVO.getExtensionAttribute10() : organUserVO.getExtensionAttribute102();
			String mobile = organUserVO.getMobile();
			String telephone = organUserVO.getTelephoneNumber();
			
			result.append("<ROW>");
			result.append("<CELL>");
			result.append("<DATA1><![CDATA[" 				+ Optional.ofNullable(userID).orElse("") 	  + "]]></DATA1>");
			result.append("<DATA2><![CDATA[" 				+ Optional.ofNullable(displayname).orElse("") + "]]></DATA2>");
			result.append("<DATA3><![CDATA[" 				+ Optional.ofNullable(dept).orElse("")		  + "]]></DATA3>");
			result.append("<DATA4><![CDATA[" 				+ Optional.ofNullable(title).orElse("") 	  + "]]></DATA4>");
			result.append("<DATA5><![CDATA[" 				+ Optional.ofNullable(position).orElse("") 	  + "]]></DATA5>");
			result.append("<DATA6><![CDATA[" 				+ Optional.ofNullable(mobile).orElse("") 	  + "]]></DATA6>");
			result.append("<DATA7><![CDATA[" 				+ Optional.ofNullable(telephone).orElse("")	  + "]]></DATA7>");
			result.append("<CN><![CDATA["					+ organUserVO.getCn()						  + "]]></CN>");
			result.append("<DEPT><![CDATA["					+ organUserVO.getDepartment()				  + "]]></DEPT>");
			result.append("<DISPLAYNAME1><![CDATA["  		+ organUserVO.getDisplayName1()				  + "]]></DISPLAYNAME1>");
			result.append("<DISPLAYNAME2><![CDATA["  		+ organUserVO.getDisplayName2()				  + "]]></DISPLAYNAME2>");
			result.append("<EXTENSIONATTRIBUTE1><![CDATA[" 	+ organUserVO.getExtensionAttribute1()		  + "]]></EXTENSIONATTRIBUTE1>");
			result.append("<EXTENSIONATTRIBUTE2><![CDATA[" 	+ organUserVO.getExtensionAttribute2()		  + "]]></EXTENSIONATTRIBUTE2>");
			result.append("<EXTENSIONATTRIBUTE3><![CDATA[" 	+ organUserVO.getExtensionAttribute3()		  + "]]></EXTENSIONATTRIBUTE3>");
			result.append("<COMPANYID><![CDATA[" 			+ organUserVO.getPhysicalDeliveryOfficeName() + "]]></COMPANYID>");
			result.append("</CELL>");
			result.append("</ROW>");
		}
		
		result.append("</ROWS>");
		result.append("</LISTVIEWDATA>");
		
		
		logger.debug("getTotalUserList ended");

		return result.toString();
	}

	@RequestMapping(value = "/admin/ezOrgan/createDefaultMailFolders.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String createDefaultMailFolders(@CookieValue("loginCookie") String loginCookie, @RequestParam String userEmail, Locale locale) throws Exception{
	    logger.debug("createDefaultMailFolders started. userEmail=" + userEmail + ",locale=" + locale);
	    
	    LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
	    
        //관리자 권한 체크
        if (userInfo == null) {
        	return "EMAIL_ERROR";
        }
        
        String result = "OK";	
        
		String useStandardFolderId = config.getProperty("config.useStandardFolderId");
		
		if (useStandardFolderId != null && useStandardFolderId.equals("YES")) {							
			createDefaultFolders(loginCookie, userEmail, locale);
		}
        
		logger.debug("createDefaultMailFolders ended. result=" + result);
		
		return result;        
	}
	
	/**
	 * 조직도관리 사원정보 사진등록/변경 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/personPicture.do", method = RequestMethod.GET)
	public String personPicture(HttpServletRequest request, HttpServletResponse response,Model model) throws Exception {
	    logger.debug("personPicture started");
	    
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isCrossBrowser = browser.equals("IE9") ? false : true;
		model.addAttribute("isCrossBrowser", isCrossBrowser);
		
		logger.debug("personPicture ended");
		
		return "admin/ezOrgan/personPicture";
	}
	
	/**
	 * 조직도관리 사원정보 사진이미지 파일 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getPersonalInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getPersonalInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("getPersonalInfo started");
	    
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String fileName = request.getParameter("fileName");
		String filePath = commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator + fileName;
		
		logger.debug("filePath=" + filePath);
		
		if (fileName != null && !fileName.equals("")) {
			downImage(filePath, request, response);
		}
		
		logger.debug("getPersonalInfo ended");
	}
		
	/**
	* 조직도관리 사원정보 사진이미지 임시 업로드 실행 함수(Ie9)
	*/
	@SuppressWarnings("unused")
	@RequestMapping(value = "/admin/ezOrgan/signImageUploadIe9.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String signImangeUploadIe9(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
	    logger.debug("signImangeUploadIe9 started");
	    
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String returnVal = "";
		String mode = request.getParameter("mode");
		String userID = request.getParameter("userID");
		String guid = UUID.randomUUID().toString();
		String fileTitle ="" ;
		String sFileData = "";
		String sExt = "";
		String sFolder = "";
		String sPrefix = "";
		String serverPath = "";
		String realPath = request.getServletContext().getRealPath("");
		String tempPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()) + commonUtil.separator;
		String thumbPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator;
		
		if (request.getParameter("guid") != null) {
			guid = request.getParameter("guid");
		}
		if (request.getParameter("name") != null) {
			fileTitle = request.getParameter("name");
		}
		if (request.getParameter("filedata") != null) {
			sFileData = request.getParameter("filedata");
		}
		if (request.getParameter("ext") != null) {
			sExt = request.getParameter("ext");
		}
		if (request.getParameter("dir") != null) {
			sFolder = request.getParameter("dir");
		}
		if (request.getParameter("prefix") != null) {
			userID = request.getParameter("prefix");
		}
		
		String fileName = sExt;
		fileName = commonUtil.detectPathTraversal(userID + "_" + guid + "." + fileName);
	 
		if (mode.equals("PICTURE")) {
			serverPath = thumbPath;
		} else if (mode.equals("TEMP")) {
			serverPath = tempPath;
		} else if (mode.equals("GLOGO")) {
			serverPath = realPath + commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + userID + commonUtil.separator;
		} else {
			serverPath = realPath + commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + userID + commonUtil.separator;
		}
		
		File file = new File(commonUtil.detectPathTraversal(serverPath));
			
		if (!file.exists()) {
			file.mkdirs();
		}
		
		if (!mode.equals("TEMP")) {
			File file1 = new File(commonUtil.detectPathTraversal(tempPath));
			
			if (!file1.exists()) {
				file1.mkdirs();
			}
		}
		
		fileName = fileName.replace("+", "%2b");
        fileName = fileName.replace(";", "%3b");
        fileName = fileName.replace("~", "%7e");
        fileName = fileName.replace("=", "%3d");
        
		InputStream stream = null;
		OutputStream bos = null;         
		
		try {
			stream = request.getInputStream();
			bos = new FileOutputStream(commonUtil.detectPathTraversal(serverPath + fileName));
			int bytesRead = 0;
			byte[] buffer = new byte[BUFF_SIZE];
			
			while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
				bos.write(buffer, 0, bytesRead);
			}
		} catch (Exception e) {
			throw e;                
		} finally {
			if (bos != null) {
				try {
					bos.close();
				} catch (Exception e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			if (stream != null) {
				try {
					stream.close();
				} catch (Exception e) {
					logger.debug("e.message=" + e.getMessage());
				}
			}
			returnVal = "OK_"+ fileName;
		}
		
		//썸네일 생성
        if (mode.equals("PICTURE")) {
        	String thumbnailPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTHUMBNAIL", userInfo.getTenantId());
        	File file2 = new File(commonUtil.detectPathTraversal(serverPath + fileName));
			File thumbnailFolder = new File(commonUtil.detectPathTraversal(thumbnailPath));
			if (!thumbnailFolder.exists()) {
				thumbnailFolder.mkdirs();
			}
			
			File thumbnailFile = new File(commonUtil.detectPathTraversal(thumbnailPath + commonUtil.separator + file2.getName()));
			createThumbnail(file2, thumbnailFile);
        }
		
		logger.debug("signImangeUploadIe9 ended");
				
		return returnVal;
	}
	
	/**
	* 조직도관리 사원정보 사진이미지 임시 업로드 실행 함수
	*/
	@RequestMapping(value = "/admin/ezOrgan/signImageUpload.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String signImangeUpload(MultipartHttpServletRequest request, @CookieValue("loginCookie") String loginCookie) throws Exception {
	    logger.debug("signImangeUpload started");
	    
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String mode = request.getParameter("mode");
		String userID = request.getParameter("userID");
		String guid = UUID.randomUUID().toString();
		MultipartFile multiFile = request.getFile("file1");
		String realPath = request.getServletContext().getRealPath("");				
		String tempPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTEMP", userInfo.getTenantId()) + commonUtil.separator;
		String thumbPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator;
		String serverPath = "";
						
		if (userID.equals("")) {
			userID = userInfo.getId();
		}
		
		try {
			String fileName = multiFile.getOriginalFilename();
			logger.debug("## " + multiFile.getName());
			fileName = fileName.replace("+", "%2b");
			fileName = fileName.replace(";", "%3b");
			String extension = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());

			/* 2021-12-08 홍승비 - 전자결재 서명 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
			String useExtension = ezCommonService.getTenantConfig("USE_FileExtension", userInfo.getTenantId());
			logger.debug("signImangeUpload file extension is : " + extension);
			if (commonUtil.checkImgExtension(extension) == false || (!useExtension.equals("*") && useExtension.toLowerCase().indexOf(extension.toLowerCase()) < 0)) {
				logger.debug("signImangeUpload failed, checkImgExtension return false");
				
				return "UPLOAD_EXT_ERROR";
			}
			
			fileName = commonUtil.detectPathTraversal(userID + "_" + guid + ".");

			if (mode.equals("PICTURE")) {
				serverPath = thumbPath;
			} else if (mode.equals("TEMP")) {
				serverPath = tempPath;
			} else if (mode.equals("GLOGO")) {
				serverPath = realPath + commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + userID + commonUtil.separator;
			} else {
				serverPath = realPath + commonUtil.getUploadPath("upload_approvalG.SIGNIMGS", userInfo.getTenantId()) + commonUtil.separator + userID + commonUtil.separator;
			}
						
			File file = new File(commonUtil.detectPathTraversal(serverPath));
			
			if (!file.exists()) {
				file.mkdirs();
			}
			
			if (!mode.equals("TEMP")) {
				File file1 = new File(commonUtil.detectPathTraversal(tempPath));
				
				if (!file1.exists()) {
					file1.mkdirs();
				}
			}

			writeUploadedFile(multiFile, fileName + extension, tempPath);
			File imageFile = new File(commonUtil.detectPathTraversal(tempPath + fileName + extension));			

			BufferedImage bi = ImageIO.read(imageFile);
			/*2018-04-12이효진  bi.getType으로 지정시 color변경되어 TYPE_4BYTE_ABGR로 지정*/
//            BufferedImage bufferedImage = new BufferedImage(119, 128, bi.getType());
            BufferedImage bufferedImage = new BufferedImage(119, 128, BufferedImage.TYPE_4BYTE_ABGR);
            /*2018-04-12이효진  PNG파일 배경지정*/
//            bufferedImage.createGraphics().drawImage(bi, 0, 0, 119, 128, null);
            bufferedImage.createGraphics().drawImage(bi, 0, 0, 119, 128, Color.WHITE, null);
            
            File file2 = new File(commonUtil.detectPathTraversal(serverPath + fileName + "png"));
            ImageIO.write(bufferedImage, "png", file2);
            //임시 저장 파일 삭제
            deleteFile(tempPath + fileName + extension);
            
            //썸네일 생성
            if (mode.equals("PICTURE")) {
            	String thumbnailPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTOTHUMBNAIL", userInfo.getTenantId());
    			File thumbnailFolder = new File(commonUtil.detectPathTraversal(thumbnailPath));
    			if (!thumbnailFolder.exists()) {
    				thumbnailFolder.mkdirs();
    			}
    			
    			File thumbnailFile = new File(commonUtil.detectPathTraversal(thumbnailPath + commonUtil.separator + file2.getName()));
    			createThumbnail(file2, thumbnailFile);
            }
            
            logger.debug("signImangeUpload ended");

            return fileName + "png";
			
		} catch (Exception e) {
		    logger.debug("signImangeUpload failed");
		    
			return "UPLOAD_ERROR";
		}		
	}
	
	/**
	 * 조직도관리 겸직관리 메뉴 호출 화면
	 */
	@RequestMapping(value = "/admin/ezOrgan/addJobList.do", method = RequestMethod.GET)
	public String addJobList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("addJobList started.");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);		
		
        int tenantID = user.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
		
		//관리자 권한 체크
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER) && !organAuth.isAuth(AdminAuth.COMPANY_MANAGER)) {
			return "cmm/error/adminDenied";
		}
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", user.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		String use_editor = ezCommonService.getTenantConfig("EDITOR", tenantID);
		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(user.getId(), user.getTenantId(), user.getPrimary(), user.getDeptID(), user.getJobId());
		
		model.addAttribute("use_editor", use_editor);
		model.addAttribute("userCompany", user.getCompanyID());
		model.addAttribute("list", resultList);
		model.addAttribute("useExternalMailServer", useExternalMailServer);
		
		logger.debug("addJobList ended.");
		
		return "/admin/ezOrgan/addJobList";
	}
	
	/**
	 * 조직도관리 겸직관리 대상자 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getAddJobList.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getAddJobList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
        logger.debug("getAddJobList started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String companyID = request.getParameter("companyID");
		String strLang = userInfo.getPrimary();
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");
			
		int currentPage = Integer.parseInt(request.getParameter("page")); 
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));
		int startRow = Math.addExact(Math.multiplyExact(pageSize, Math.subtractExact(currentPage, 1)), 1);
		int endRow = Math.multiplyExact(pageSize, currentPage);
		
		searchValue = searchValue.replace("%", "\\%").replace("_", "\\_");
		
		int totalCount = ezOrganAdminService.getAddJobCount(companyID, searchType, searchValue, tenantID, strLang);
		
		List<OrganUserVO> list = ezOrganAdminService.getAddJobList(companyID, strLang, searchType, searchValue, tenantID, totalCount, pageSize, startRow, endRow);
		
		logger.debug("companyID=" + companyID  + ",strLang=" + strLang + ",currentPage=" + currentPage
                + ",pageSize=" + pageSize + ",startRow=" + startRow + ",endRow=" + endRow
                + ",totalCount=" + totalCount);
		
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
        result.append("<ROWS>");
        result.append("<TOTALCNT>");
		result.append(totalCount);
		result.append("</TOTALCNT>");
        for (int i = 0; i < list.size(); i++) {
        	OrganUserVO vo = list.get(i);
        	
        	result.append("<ROW>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCn()) + "</VALUE>");
            result.append("<DATA1>" + commonUtil.cleanValue(vo.getCn()) + "</DATA1>");
            result.append("<DATA2>" + commonUtil.cleanValue(vo.getExtensionAttribute4()) + "</DATA2>");
            result.append("<DATA3>" + commonUtil.cleanValue(vo.getDisplayName()) + "</DATA3>");
            result.append("<DATA4>" + commonUtil.cleanValue(vo.getMail()) + "</DATA4>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCn()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getDisplayName()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getTitle()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getDescription()) + "</VALUE>");
            result.append("</CELL>");                    
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCompany()) + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }                
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
		
        logger.debug("getAddJobList ended.");
        
		return result.toString();
	}
	
	/**
	 * 조직도관리 겸직관리 대상자 상세정보 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getUserAddJobList.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getUserAddJobList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
        logger.debug("getUserAddJobList started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String cn = request.getParameter("cn");
		String strLang = userInfo.getPrimary();
		
		List<OrganUserVO> list = ezOrganAdminService.getUserAddJobList(cn, strLang, tenantID);
		
		StringBuilder result = new StringBuilder();
		result.append("<DATA>");
		
		for (int i = 0; i < list.size(); i++) {
			OrganUserVO vo = list.get(i);
			
			String rows = commonUtil.getQueryResult(vo);
			result.append(rows.toString());
		}
        result.append("</DATA>");
        
        logger.debug("getUserAddJobList ended.");
        
		return result.toString();
	}
	
	/**
	 * 조직도관리 겸직관리 겸직삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveSubTitle.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveSubTitle(@CookieValue("loginCookie") String loginCookie, @RequestBody String data, HttpServletRequest request, Model model) throws Exception{
        logger.debug("saveSubTitle started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "EMAIL_ERROR";
		}

		int tenantID = userInfo.getTenantId();

		logger.debug("tenantID=" + tenantID);
		logger.debug("data=" + data);

		Document doc = commonUtil.convertStringToDocument(data);

		String userID = doc.getElementsByTagName("CN").item(0).getTextContent();
		String titleInfo = "";
		String titleInfoWithManualFlag = "";
		String deleteTitleInfo = "";
		String jobID = "";
		String role = "";
		String roleInfo = "";
		String deleteRoleId = "";
		String delType = doc.getElementsByTagName("DEPTID").item(0).getTextContent().equals("") ? "ALL" : ""; // 삭제타입(ALL인경우
																												// 전체겸직삭제)
		String delJobId = ""; // 2022-07-06 이사라 - 한 부서에 겸직이 2개 이상 있는 경우 1개만 삭제 시 삭제하는 jobId가 필요하여 추가
		boolean isAddJobMoreInOneDept = false;
		List<UserChangeInfoVO> userChInfoList = new ArrayList<UserChangeInfoVO>();
		String updateType = "";
		List<OrganUserVO> newAddJobList = new ArrayList<>();
		boolean isAddRole = doc.getElementsByTagName("ROLEID").getLength() > 0 ? true : false; 
		
		for (int i = 0; i < doc.getElementsByTagName("CN").getLength(); i++) {
			String titleValue = doc.getElementsByTagName("TITLE").item(i).getTextContent();
			String manualFlag = Optional.ofNullable(doc.getElementsByTagName("MANUAL_FLAG").item(i))
					.map(Node::getTextContent).filter(str -> !str.isEmpty()).orElse(null);
			String roleId = Optional.ofNullable(doc.getElementsByTagName("ROLEID").item(i))
					.map(Node::getTextContent).filter(str -> !str.isEmpty()).orElse("0"); 

			if (!titleValue.equals("")) {

				String[] titleArray = titleValue.split(":");

				// Primary 언어 이름만 있는 경우엔 Secondary 언어 이름을 동일하게 설정한다.
				if (titleArray.length == 1) {
					titleValue = titleArray[0] + ":" + titleArray[0];
				}

				if (titleInfo.equals("")) {
					titleInfo = doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + titleValue;
					titleInfoWithManualFlag = titleInfo + ":" + manualFlag;
				} else {
					titleInfo += ";" + doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + titleValue;
					titleInfoWithManualFlag += ";" + doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":"
							+ titleValue + ":" + manualFlag;
				}

				// 기존 겸직정보와 비교하기 위해 수정된 겸직정보를 list에 담아준다
				OrganUserVO organVo = new OrganUserVO();
				String[] title = titleValue.split(":");
				organVo.setDepartment(doc.getElementsByTagName("DEPTID").item(i).getTextContent());
				organVo.setJobID(doc.getElementsByTagName("JOBID").item(i).getTextContent());
				organVo.setRoleId(roleId);
				if(title.length >0) {
					organVo.setTitle(title[0]);
					organVo.setTitle2(title[1]);
				}
				newAddJobList.add(organVo);

			} else { // 선택삭제, 전체겸직삭제인경우

				updateType = "clearAddJob";
				if (doc.getElementsByTagName("DEPTID").item(i).getTextContent().equals("")) { // 전체겸직삭제인경우
					String cn = doc.getElementsByTagName("CN").item(i).getTextContent();
					List<OrganUserVO> organUserVOList = ezOrganAdminService.getUserAddJobList(cn, "1", tenantID);

					for (int j = 0; j < organUserVOList.size(); j++) {
						if (deleteTitleInfo.equals("")) {
							deleteTitleInfo = organUserVOList.get(j).getDepartment() + ":" + titleValue;
						} else {
							deleteTitleInfo += ";" + organUserVOList.get(j).getDepartment() + ":" + titleValue;
						}

						// 2023-07-03 장혜연 겸직 전체 삭제 정보 사용자 변경 히스토리에 들어갈 값 vo에 setting (겸직부서의 직위를 가져오기 위해
						// 겸직정보를 지우기 전에 실행)
						UserChangeInfoVO userChangeInfoVO = new UserChangeInfoVO();
						userChangeInfoVO.setUserChVo(userChangeInfoVO, userID, organUserVOList.get(j).getDepartment(),
								organUserVOList.get(j).getDescription1() + "/" + organUserVOList.get(j).getTitle1(),
								organUserVOList.get(j).getDescription2() + "/" + organUserVOList.get(j).getTitle2(), updateType);
						userChInfoList.add(userChangeInfoVO);
					}

            		logger.debug("cn=" + cn + ",titleInfo=" + titleInfo + ",deleteTitleInfo=" + deleteTitleInfo);

					ezOrganAdminService.updateProperty(cn, "EXTENSIONATTRIBUTE4", titleInfo, "user", tenantID);
					ezOrganAdminService.deleteJob(cn, deleteTitleInfo, tenantID);

					deleteTitleInfo = "";
				} else { // 선택삭제인경우
					if (deleteTitleInfo.equals("")) {
						deleteTitleInfo = doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + titleValue;
						delJobId = doc.getElementsByTagName("JOBID").item(i).getTextContent(); // 아이콘 선택삭제는 1개씩 가능하여
						deleteRoleId = doc.getElementsByTagName("ROLEINFO").item(i).getTextContent(); // 아이콘 선택삭제는 1개씩 가능(직위 동일, 직책만 불일치한 경우 RoleId로 구분)
					// else쪽에는 추가 안함
					} else {
						deleteTitleInfo += ";" + doc.getElementsByTagName("DEPTID").item(i).getTextContent() + ":" + titleValue;
					}

					logger.debug("deleteTitleInfo : {} ", deleteTitleInfo + " deleteRoleId : {} " + deleteRoleId);
				}
			}
			jobID += doc.getElementsByTagName("JOBID").item(i).getTextContent() + ";";	
			// 2023-11-21 장혜연 : 직책명 추가 (primary언어만 있을 경우 role2도 동일하게) 
			if (isAddRole) {
				String orgRole2 = doc.getElementsByTagName("ROLE2").item(i).getTextContent();
				role = Optional.ofNullable(doc.getElementsByTagName("ROLE").item(i))
						.map(Node::getTextContent).filter(str -> !str.isEmpty()).orElse(""); 
				roleInfo += roleId + ":" + role + ":"
						+ (!"".equals(role) && "".equals(orgRole2) ? role : orgRole2) + ";";
			} 
		} // for문완료
		jobID = jobID.substring(0, jobID.length() - 1);
		if (isAddRole) {
			roleInfo = roleInfo.substring(0, roleInfo.length() - 1);			
		}

		// 2022-07-06 이사라 - 한 부서에 겸직이 2개 이상 있는 경우 1개만 삭제 시 rewrite테이블에서 삭제되는 것을 방지하기 위해
		// 이중겸직인지 확인
		if (StringUtils.isNotEmpty(delJobId)) {
			isAddJobMoreInOneDept = ezOrganAdminService.getAddJobCountInOneDept(userID, deleteTitleInfo, tenantID) > 1 ? true : false;
		}

		if (!delType.equals("ALL")) { //전체겸직삭제가 아닌 경우
			logger.debug("userID=" + userID + ",titleInfo=" + titleInfo + ",deleteTitleInfo=" + deleteTitleInfo + ",delJobId=" + delJobId +  ",deleteRoleId=" + deleteRoleId + ",isAddJobMoreInOneDept=" + isAddJobMoreInOneDept);
			
			ezOrganAdminService.updateProperty(userID, "EXTENSIONATTRIBUTE4", titleInfo, "user", tenantID); //usermaster update
		}
		
		if (!deleteTitleInfo.equals("") && !delType.equals("ALL")) { // 선택 삭제일 시 

			// 2023-07-03 장혜연 : 선택 삭제 후 사용자 변경 히스토리에 들어갈 값 setting
			UserChangeInfoVO userChangeInfoVO = new UserChangeInfoVO();
			updateType = "clearAddJob";
			String deletInfo[] = deleteTitleInfo.split(";");

			for (int i = 0; i < deletInfo.length; i++) {
				String deltDeptID[] = deletInfo[i].split(":");
				OrganUserVO jobInfo = ezOrganAdminService.getAddJobInfo(userID, deltDeptID[0], delJobId, deleteRoleId, tenantID);
				userChangeInfoVO.setUserChVo(userChangeInfoVO, userID, deltDeptID[0],
						jobInfo.getDescription() + "/" + jobInfo.getTitle(),
						jobInfo.getDescription1() + "/" + jobInfo.getTitle1(), updateType);

				userChInfoList.add(i, userChangeInfoVO);
			}

			ezOrganAdminService.deleteJob(userID, deleteTitleInfo, tenantID, delJobId, deleteRoleId, isAddJobMoreInOneDept);

		} else {
		    if (!titleInfo.equals("")) { // 겸직 추가, 팝업 수정 일경우
		        List<OrganUserVO> organUserVOList = ezOrganAdminService.getUserAddJobList(userID, "1", tenantID);
		        StringBuilder sbCurrentJobList = new StringBuilder();

		        List<String> currDeptIdList = new ArrayList<String>();
		        // 지정된 사용자의 현재 겸직 목록을 구한다.
		        for (int i = 0; i < organUserVOList.size(); i++) {
		            OrganUserVO organUserVO = organUserVOList.get(i);
		            
		            if (i == 0) {
		                sbCurrentJobList.append(organUserVO.getDepartment() + "::");
		            } else {
		                sbCurrentJobList.append(";" + organUserVO.getDepartment() + "::");
		            }
		            
		            currDeptIdList.add(organUserVO.getDepartment()); 
		        }

				String currentJobList = sbCurrentJobList.toString();
				logger.debug("currentJobList : {} ", currentJobList);
				// 장혜연 2023-09-01 : 기존 겸직과 수정된 겸직을 비교하여 해제된 겸직 정보를 사용자 변경 히스토리 vo에 setting 한다.
				for (OrganUserVO orgAddJob : organUserVOList) {
					boolean isContainedNewList = newAddJobList.stream()
							.anyMatch(newAddJob -> newAddJob.getDepartment().equals(orgAddJob.getDepartment())
									&& newAddJob.getJobID().equals(orgAddJob.getJobID())
									&& newAddJob.getRoleId().equals(orgAddJob.getRoleId()));
					if (!isContainedNewList) {
						UserChangeInfoVO userChVo = new UserChangeInfoVO();
						updateType = "clearAddJob";
						userChVo.setUserChVo(userChVo, userID, orgAddJob.getDepartment(),
								orgAddJob.getDescription1() + "/" + orgAddJob.getTitle(),
								orgAddJob.getDescription2() + "/" + orgAddJob.getTitle2(), updateType);
						userChInfoList.add(userChVo);

					}
				}
				// 장혜연 2023-09-01 : 기존 겸직과 수정된 겸직을 비교하여 부여된 겸직 정보를 사용자 변경 히스토리 vo에 setting 한다.
				for (OrganUserVO newAddJob : newAddJobList) {
					boolean isContainedOrgList = organUserVOList.stream()
							.anyMatch(orgAddJob -> orgAddJob.getDepartment().equals(newAddJob.getDepartment())
									&& orgAddJob.getJobID().equals(newAddJob.getJobID()));
					if (!isContainedOrgList) {
						updateType = "grantAddJob";
						UserChangeInfoVO userChVo = new UserChangeInfoVO();
						OrganDeptVO newDeptNm = ezOrganAdminService.getDeptDisplayNm(newAddJob.getDepartment(), tenantID);
						userChVo.setUserChVo(userChVo, userID, newAddJob.getDepartment(),
								newDeptNm.getDisplayName() + "/" + newAddJob.getTitle(),
								newDeptNm.getDisplayName2() + "/" + newAddJob.getTitle2(), updateType);
						userChInfoList.add(userChVo);
					}
				}

				if (!currentJobList.equals("")) { // 현재 겸직이 존재하는 경우
					// 현재 겸직 목록을 모두 삭제한다.
					ezOrganAdminService.deleteJob(userID, currentJobList, tenantID);
				}

				String sTitle1 = "";
				String sTitle2 = "";
				String pDeptID = "";
				String manualFlag = "";

				String[] addJobinfo = titleInfoWithManualFlag.split(";");
				StringBuilder sb = new StringBuilder();

				for (int i = 0; i < addJobinfo.length; i++) { // 새로추가한 겸직정보와 + 기존겸직정보
					String[] jobInfo = addJobinfo[i].split(":");
					int jobInfoLength = jobInfo.length;
					pDeptID = jobInfo[0];
					sTitle1 = "";
					manualFlag = null;

					if (jobInfoLength > 2) {
						sTitle1 = jobInfo[1];
						manualFlag = jobInfo[jobInfoLength - 1];
					}

					sTitle2 = "";

					if (jobInfoLength > 3) {
						sTitle2 = jobInfo[2];
					} else {
						sTitle2 = sTitle1;
					}

					if (i == 0) {
						sb.append(pDeptID + ":" + sTitle1 + ":" + sTitle2 + ":" + manualFlag);
					} else {
						sb.append(";" + pDeptID + ":" + sTitle1 + ":" + sTitle2 + ":" + manualFlag);
					}

				}

				titleInfoWithManualFlag = sb.toString();

				logger.debug("new titleInfo with manualFlag=" + titleInfoWithManualFlag);

				// 새로운 겸직 목록을 설정한다.
				ezOrganAdminService.addJob(userID, titleInfoWithManualFlag, jobID, roleInfo, tenantID);

			}
		}

		// 2023-07-03 장혜연 공통적으로 들어갈 값들 vo list에 setting 한 후 사용자 변경 히스토리 테이블에 insert 실행
		for (int k = 0; k < userChInfoList.size(); k++) {

			userChInfoList.get(k).setTargetType("addJob");
			userChInfoList.get(k).setExecutorIp(ClientUtil.getClientIP(request));
			userChInfoList.get(k).setManualFlag("Y");
			userChInfoList.get(k).setTenantId(tenantID);

			try {
				ezSystemAdminService.insertUserChangeHist(userChInfoList.get(k), userInfo);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}

		}

		ezBoardAdminService.trunkBoard(tenantID);

		logger.debug("saveSubTitle ended.");

		return "OK";
	}

	/**
	 * 조직도관리 겸직관리 겸직등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/addJobConfig.do", method = RequestMethod.GET)	
	public String addJobConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("addJobConfig started.");
	    
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		//관리자 권한 체크
		if (user == null) {
			return "cmm/error/adminDenied";
		}
		
		String topID = "";        
        String userID = (request.getParameter("userID") != null ? request.getParameter("userID") : "");
        String selCompany = (request.getParameter("companyID") != null ? request.getParameter("companyID") : "");
		String primary = ezCommonService.getTenantConfig("LangPrimary" + user.getLang(), user.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + user.getLang(), user.getTenantId());
		String deptTreeTopId = "";

		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		
		if (organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
			topID = "Top";
			deptTreeTopId = topID + "/organ";
		} else {
			topID = selCompany;
			deptTreeTopId = topID;
		}

		model.addAttribute("topID", topID);
		model.addAttribute("use_ocs", "");
		model.addAttribute("userID", userID);
		model.addAttribute("selCompany", selCompany);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("userInfo", user);
		model.addAttribute("deptTreeTopId", deptTreeTopId);
		
		logger.debug("addJobConfig ended.");
		
		return "admin/ezOrgan/addJobConfig";
	}
	
	/**
	 * 조직도관리 겸직관리 겸직등록 대상부서 선택 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/addjobAdd.do", method = RequestMethod.GET)	
	public String addjobAdd(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("addjobAdd started.");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
		String companyID = request.getParameter("companyID");
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());

		if (organAuth.isAuth(AdminAuth.ADMIN_MASTER) || StringUtils.isBlank(companyID)) {
			companyID = "Top";
		}

		logger.debug("companyID=" + companyID);
		        
		model.addAttribute("companyID", companyID);
		model.addAttribute("userInfo", user);
		
		logger.debug("addjobAdd ended.");
		
		return "admin/ezOrgan/addJobAdd";
	}
	
	/**
	 * 조직도관리 권한관리 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/permissionsList.do", method = RequestMethod.GET)	
	public String permissionsList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("permissionsList started.");
	    
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		//관리자 권한 체크
		if (user == null) {
			return "cmm/error/adminDenied";
		}
		
		String use_editor = ezCommonService.getTenantConfig("EDITOR", user.getTenantId());
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", user.getTenantId());
		String approvalForDoc = ezCommonService.getTenantConfig("approvalForDoc", user.getTenantId());
		
		//2018-07-31 김보미 - 근태 추가
		String use_attitude = ezCommonService.getTenantConfig("USE_ATTITUDE", user.getTenantId());
		String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", user.getTenantId());
		if (use_attitude == null || use_attitude.equals("")) {
			use_attitude = "YES";
		}
		
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", user.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		String useBoard = ezCommonService.getTenantConfig("useBoard", user.getTenantId());
		if (useBoard == null || useBoard.equals("")) {
			useBoard = "YES";
		}
		
		String useSurvey = ezCommonService.getTenantConfig("useSurvey", user.getTenantId());
		if (useSurvey == null || useSurvey.equals("")) {
			useSurvey = "YES";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(user.getId(), user.getTenantId(), user.getPrimary(), user.getDeptID(), user.getJobId());
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		
		String packageType = commonUtil.getPackageType(user.getTenantId());
		
		model.addAttribute("use_editor", use_editor);
		model.addAttribute("userCompany", user.getCompanyID());
		model.addAttribute("list", resultList);
		model.addAttribute("isAdmin", organAuth.isAuth(AdminAuth.ADMIN_MASTER));
        model.addAttribute("approvalFlag", approvalFlag);
        model.addAttribute("approvalForDoc", approvalForDoc);
        //2018-07-31 김보미 - 근태 추가
        model.addAttribute("use_attitude", use_attitude);
        model.addAttribute("useWebfolder", useWebfolder);
        model.addAttribute("packageType", packageType);
        model.addAttribute("useExternalMailServer", useExternalMailServer);
        model.addAttribute("useBoard", useBoard);
        model.addAttribute("useSurvey", useSurvey);
		
		logger.debug("permissionsList ended.");
		
		return "admin/ezOrgan/permissionsList";
	}	
	
	/**
	 * 조직도관리 권한관리 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getPermissionsList.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getPermissionsList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("getPermissionsList started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String companyID = request.getParameter("companyID");
		String type = request.getParameter("type");
		String strLang = userInfo.getPrimary();
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));		
		int startRow = Math.addExact(Math.multiplyExact(pageSize, Math.subtractExact(pageNum, 1)), 1);
        int endRow = Math.multiplyExact(pageSize, pageNum);

		// 2023-07-31 전인하 - 관리자 > 조직도 > 권한 관리 - 욥션에 따른 겸직/부서 별 권한 조회 분기 추가
		String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", userInfo.getTenantId());
        
		searchValue = searchValue.replace("%", "\\%").replace("_", "\\_");
		
        int cnt = ezOrganAdminService.getPermissionListCount(companyID, type, searchType, searchValue, strLang, tenantID, permissionBasisDeptYN);

        logger.debug("companyID=" + companyID + ",type=" + type + ",strLang=" + strLang + ",pageNum=" + pageNum
                + ",pageSize=" + pageSize + ",startRow=" + startRow + ",endRow=" + endRow
                + ",totalCount=" + cnt);
        
        List<OrganUserVO> list = ezOrganAdminService.getPermissionList(companyID, type, searchType, searchValue, strLang, startRow, endRow, tenantID, permissionBasisDeptYN);
        
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<ROWS>");
		result.append("<TOTALCNT>");
		result.append(cnt);
		result.append("</TOTALCNT>");
        
        for (int i = 0; i < list.size(); i++) {
        	OrganUserVO vo = list.get(i);
        	
        	result.append("<ROW>");
        	result.append("<CELL>");
        	result.append("<VALUE>" + commonUtil.cleanValue(vo.getCn()) + "</VALUE>");
            result.append("<DATA1>" + commonUtil.cleanValue(vo.getCn()) + "</DATA1>");
            result.append("<DATA2>" + commonUtil.cleanValue(vo.getExtensionAttribute1()) + "</DATA2>");
            result.append("<DATA3>" + commonUtil.cleanValue(vo.getDisplayName()) + "</DATA3>");
            result.append("<DATA4>" + commonUtil.cleanValue(vo.getMail()) + "</DATA4>");
            result.append("<DATA5>" + commonUtil.cleanValue(vo.getDescription()) + "</DATA5>");
			result.append("<DATA6>" + commonUtil.cleanValue(vo.getDepartment()) + "</DATA6>");
			result.append("<DATA7>" + commonUtil.cleanValue(vo.getJobID()) + "</DATA7>"); // 중복겸직 대응하기 위한 JOBID 데이터 추가
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCn()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getDisplayName()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getTitle()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getDescription()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getMail()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getTelephoneNumber()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getCompany()) + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
        
        logger.debug("getPermissionsList ended.");
        
		return result.toString();
	}
	
	/**
	 * 조직도관리 권한관리 권한등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/permissionsCheck.do", method = RequestMethod.GET)	
	public String permissionsCheck(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("permissionsCheck started.");
	    
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		//관리자 권한 체크
		if (user == null) {
			return "cmm/error/adminDenied";
		}
		
		String userID = (request.getParameter("userID") != null ? request.getParameter("userID") : "");
        String selCompany = (request.getParameter("companyID") != null ? request.getParameter("companyID") : "");
		String topID = "";
		String deptTreeTopId = "";
		String delType = (request.getParameter("DelType") !=null ? request.getParameter("DelType") : "");
		String type = (request.getParameter("type") !=null ? request.getParameter("type") : "");
		String packageType = commonUtil.getPackageType(user.getTenantId());
		String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", user.getTenantId());

        topID = user.getCompanyID();
        deptTreeTopId = selCompany;
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", user.getTenantId());
		String approvalForDoc = ezCommonService.getTenantConfig("approvalForDoc", user.getTenantId());
		//2018-07-31 김보미 - 근태 추가
		String use_attitude = ezCommonService.getTenantConfig("USE_ATTITUDE", user.getTenantId());
		if (use_attitude == null || use_attitude.equals("")) {
			use_attitude = "YES";
		}
		
		String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", user.getTenantId());
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		boolean isAdmin = organAuth.isAuth(AdminAuth.ADMIN_MASTER);
		
		model.addAttribute("packageType", packageType);
		model.addAttribute("userID", userID);
		model.addAttribute("companyID", selCompany);
		model.addAttribute("topID", topID);
		model.addAttribute("userInfo", user);
		model.addAttribute("isAdmin", isAdmin);
		model.addAttribute("approvalFlag", approvalFlag);
		model.addAttribute("approvalForDoc", approvalForDoc);
		model.addAttribute("use_attitude", use_attitude);
		model.addAttribute("deptTreeTopId", deptTreeTopId);
		model.addAttribute("useWebfolder", useWebfolder);
		model.addAttribute("DelType", delType);
		model.addAttribute("type", type);
		model.addAttribute("permissionBasisDeptYN", permissionBasisDeptYN);
		
		logger.debug("permissionsCheck ended.");
		
		return "admin/ezOrgan/permissionsCheck";
	}
	
	/**
	 * 조직도관리 퇴직자관리 메뉴 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUserManage.do", method = RequestMethod.GET)	
	public String retireUserManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("retireUserManage started");

		LoginVO user = commonUtil.userInfo(loginCookie);
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());

		//관리자 권한 체크
		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		String companyId = user.getCompanyID();
		
   		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", user.getTenantId());
   		String dotNetIntegration = ezCommonService.getTenantConfig("dotNetIntegration", user.getTenantId());

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(user.getId(), user.getTenantId(), user.getPrimary(), user.getDeptID(), user.getJobId());
		
   		model.addAttribute("useBizmekaSpambox", useBizmekaSpambox);
		model.addAttribute("dotNetIntegration", dotNetIntegration);
		model.addAttribute("companylist", resultList);
		model.addAttribute("companyId", companyId);
   		
   		logger.debug("retireUserManage ended");
   		
		return "admin/ezOrgan/retireUserManage";
	}	
	
	/**
	 * 조직도관리 퇴직자 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getRetireUserList.do", method = RequestMethod.POST)	
	public String getRetireUserList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("getRetireUserList started");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
        int tenantID = user.getTenantId(); 
        String strLang = user.getPrimary();
        String offset = user.getOffset();
        
        logger.debug("tenantID=" + tenantID + ",strLang=" + strLang + ",offset=" + offset);
		
		int pPageRow = 20;
   		int pPage = (request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1);
   		String searchStartDate = (request.getParameter("searchStartDate") != null ? request.getParameter("searchStartDate") : "");
   		String searchEndDate = (request.getParameter("searchEndDate") != null ? request.getParameter("searchEndDate") : "");
   		String searchKeycode = (request.getParameter("searchKeycode") != null ? request.getParameter("searchKeycode") : "");
   		String searchKeyword = (request.getParameter("searchKeyword") != null ? request.getParameter("searchKeyword") : "");
   		String searchCompanyID = (request.getParameter("searchCompanyID") != null ? request.getParameter("searchCompanyID") : "");
   		
   		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchKeyword = commonUtil.getWildcardEscapedString(searchKeyword, dbName);
   		
   		logger.debug("pPage=" + pPage + ",pPageRow=" + pPageRow);
   		logger.debug("searchStartDate=" + searchStartDate + ",searchEndDate=" + searchEndDate);
   		logger.debug("searchKeycode=" + searchKeycode + ",searchKeyword=" + searchKeyword);
   		
   		int totalCount = ezOrganAdminService.getRetireListCount(pPage, pPageRow, tenantID, searchStartDate, searchEndDate, searchKeycode, searchKeyword, searchCompanyID);
   		int totalPage = 1;

		if (totalCount > 0) {
			if (totalCount > pPageRow) {
				totalPage = totalCount / pPageRow;
				
				if (totalCount % pPageRow != 0) {
				    totalPage++;
				}
			}
		}
		
		logger.debug("totalCount=" + totalCount + ",totalPage=" + totalPage);
		
		List<OrganUserVO> list = ezOrganAdminService.getRetireList(pPage, pPageRow, tenantID, offset, searchStartDate, searchEndDate, searchKeycode, searchKeyword, searchCompanyID);
		
   		model.addAttribute("lang", strLang);
   		model.addAttribute("list", list);
   		model.addAttribute("pPage", pPage);
   		model.addAttribute("totalPage", totalPage);
   		model.addAttribute("totalCount", totalCount);
		
   		logger.debug("getRetireUserList ended");
   		
		return "json";
	}	
	
	/**
	 * 조직도관리 퇴직자관리 복구 기능 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/restoreRetireUser.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String restoreRetireUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    logger.debug("restoreRetireUser started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        if (userInfo == null) {
        	logger.debug("restoreRetireUser: it's not admin");
        	
        	return "EMAIL_ERROR";
        }
        
        int tenantID = userInfo.getTenantId();        
        String cnList = request.getParameter("cn");
        String offset = userInfo.getOffset();
        
        logger.debug("tenantID=" + tenantID + ",cnList=" + cnList + ",offset=" + offset);
	    
		String deptID = request.getParameter("deptID");
		String[] cn = cnList.split(",");
		String result = "OK";
		
		logger.debug("deptID=" + deptID);
		
		// dhlee
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		// dhlee - end
		
		for (int i = 0; i < cn.length; i++) {
			// 2019.08.30 사간 퇴사 지원으로 인한 주석처리
			// OrganUserVO userVO = ezOrganAdminService.getUserInfo(cn[i], "1", tenantID);
			// String userCompId = userVO.getPhysicalDeliveryOfficeName();
			//OrganDeptVO deptVO = ezOrganService.getDeptInfo(deptID, "1", tenantID);
			// String deptCompId = deptVO.getExtensionAttribute2();
			
			// if (!deptCompId.equals(userCompId)) {
			//	logger.debug("Restoration to other companies is not possible.");
			//	logger.debug("userId=" + cn[i] + ",userCompId=" + userCompId + ",deptCompId=" + deptCompId);
			//	logger.debug("restoreRetireUser ended. result=DIFF_COMPANY");
			//	return "DIFF_COMPANY";
			//}

			String checkResult = checkLicenseKey(tenantID, domain);

			if (!checkResult.equals("OK")) {
				return checkResult;
			}

			// dhlee
			String mailAddr = cn[i] + "@" + domain;
			
			logger.debug("mailAddr=" + mailAddr);
			
			int rc = ezEmailUserAdminService.restoreUser(mailAddr);
			
			logger.debug("restoreUser rc=" + rc);

			// [국립암센터] POP3/IMAP 사용 설정
			String usePOP3Default = ezCommonService.getTenantConfig("usePOP3Default", tenantID);
			String useIMAPDefault = ezCommonService.getTenantConfig("useIMAPDefault", tenantID);

			JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/setPOP3IMAPConfig")
					.formParam("user_name", mailAddr)
					.formParam("usePOP3Default", usePOP3Default)
					.formParam("useIMAPDefault", useIMAPDefault)
					.exchangeJgwResult();
			
			if (rc == 0) { // restoreUser 성공				
				// 지정된 부서의 Group Email 주소에 해당 User를 추가한다.
				String groupAddr = deptID + "@" + domain;
				rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
				
				logger.debug("updateGroupAdd rc=" + rc);
				
				if (rc == 0) { // updateGroupAdd 성공
					try {
						// 로컬 시스템에서 해당 User의 복원처리를 수행한다.
						ezOrganAdminService.restoreRetireEntry(cn[i], deptID, tenantID, offset);

						// 사용자의 mail을 실제 주소로 업데이트 한다.
						if (ezEmailUserAdminService.checkUserPrimaryMail(mailAddr, tenantID) != 0) {
							ezOrganAdminService.updateUserMailAddress(cn[i], mailAddr, tenantID);
						}

						//사용자 변경 히스토리 테이블에 insert
						UserChangeInfoVO userChangeInfoVO = new UserChangeInfoVO();
						userChangeInfoVO.setUserId(cn[i]);
						userChangeInfoVO.setTenantId(tenantID);
						userChangeInfoVO.setUpdateType("restore");
						userChangeInfoVO.setExecutorIp(ClientUtil.getClientIP(request));
						userChangeInfoVO.setTargetType("user");

						try {
							ezSystemAdminService.insertUserChangeHist(userChangeInfoVO, userInfo);
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						}
						
						
					} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
						ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
						ezEmailUserAdminService.retireUser(mailAddr);
						
						result = "EMAIL_ERROR";
						break;
					}										
				} else {
					// Group Email 주소로의 추가가 실패하면 해당 User를 다시 퇴직처리하고 Exception을 발생시킨다.
					ezEmailUserAdminService.retireUser(mailAddr);
					
					logger.debug("Adding the user '" + mailAddr + "' to the specified group email '" + groupAddr + "' failed.");
					
					result = "EMAIL_ERROR";
					break;					
				}
			}
			// dhlee - end
		}	
		
		//게시판 트리캐시 삭제
		ezBoardAdminService.trunkBoard(tenantID);
		
		logger.debug("restoreRetireUser ended. result=" + result);
		
		return result;
	}
	
	/**
	 * 조직도관리 퇴직자관리 퇴직사원 상세정보 창 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/retireUserInfo.do", method = RequestMethod.GET)
	public String retireUserInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("retireUserInfo started");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
		//관리자 권한 체크
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER) && !organAuth.isAuth(AdminAuth.COMPANY_MANAGER)) {
			return "cmm/error/adminDenied";
		}
		
        int tenantID = user.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
		
		String id = (request.getParameter("id") == null ? "" : request.getParameter("id"));
		String primary = ezCommonService.getTenantConfig("LangPrimary" + user.getLang(), tenantID);
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + user.getLang(), tenantID);
				
		logger.debug("id=" + id + ",primary=" + primary + ",secondary=" + secondary);
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);		
		model.addAttribute("userID", id);
		
		logger.debug("retireUserInfo ended");
		
		return "admin/ezOrgan/retireUserInfo";
	}	
	
	/**
	 * 조직도관리 퇴직자관리 퇴직사원 상세정보 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getRetireEntryInfo.do", method = RequestMethod.POST)
	public String getRetireEntryInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
        logger.debug("getRetireEntryInfo started.");
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String cn = request.getParameter("cn");	
		
		logger.debug("cn=" + cn);
		
		OrganUserVO vo = ezOrganAdminService.getRetireEntryInfo(cn, "1", tenantID);
		
		model.addAttribute("info", vo);
		
		logger.debug("getRetireEntryInfo ended.");
		
		return "json";
	}	
	
	/**
	 * 조직도관리 메일주소 창 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/configEmail.do", method = RequestMethod.GET)
	public String configEmail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		logger.debug("configEmail started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		//관리자 권한 체크
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
        int tenantID = userInfo.getTenantId();        
        logger.debug("tenantID=" + tenantID);
		
		String userId = (request.getParameter("id") == null ? "" : request.getParameter("id"));
		String configEmailType = request.getParameter("type") == null ? "user" : request.getParameter("type"); // 사용자, 부서, 공용배포그룹, 공유사서함
		String companyId = request.getParameter("companyId") == null ? userInfo.getCompanyID() : request.getParameter("companyId");
		logger.debug("userId=" + userId + ", configEmailType=" + configEmailType + ", companyId=" + companyId);
		
		String primaryAddr = "";
		if (configEmailType.equals("dept")) { // 부서
			OrganDeptVO organDeptVO = ezOrganService.getDeptInfo(userId, userInfo.getPrimary(), tenantID);
			primaryAddr = organDeptVO.getMail();
		} else if (configEmailType.equals("ml")) { // 공용배포그룹
			List<MailDistributionVO> distributionTotalList = 
					ezEmailService.getDistributionSearchListByItem(companyId, tenantID, userId, "groupid");
			
			for (MailDistributionVO vo : distributionTotalList) {
				primaryAddr = vo.getMail();
			}
		} else if (configEmailType.equals("user") || configEmailType.equals("share")) { // 사용자, 공유사서함
			OrganUserVO userVO = ezOrganAdminService.getUserInfo(userId, userInfo.getPrimary(), tenantID);
			primaryAddr = userVO.getMail();
		}
		logger.debug("primaryAddr=" + primaryAddr);

		List<String[]> aliasAddressList = ezEmailService.getAliasAddress(userId, tenantID, "YES", "NO");
		
		StringBuilder sb = new StringBuilder();
		sb.append("<select size='4' name='ListEmail' id='ListEmail' style='height:175px;width:100%;background:none;'>");
		for (String[] aliasAddress : aliasAddressList) {
			if (aliasAddress[0].equals(primaryAddr)) {
				sb.append("<option type='" + aliasAddress[1] + "'>SMTP:" + aliasAddress[0] + " (Primary)</option>");
			} else {
				sb.append("<option type='" + aliasAddress[1] + "'>smtp:" + aliasAddress[0] + "</option>");
			}
		}
		
		sb.append("</select>");
		String listEmailHtml = sb.toString();
		
		model.addAttribute("userId", userId);
		model.addAttribute("listEmailHtml", listEmailHtml);
		model.addAttribute("companyId", companyId);
		model.addAttribute("configEmailType", configEmailType);
		
		logger.debug("configEmail ended.");
		
		return "admin/ezOrgan/configEmail";
	}
	
	/**
	 * 조직도관리 메일주소 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveEmail.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveEmail(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, OrganUserVO organVO) throws Exception{
		logger.debug("saveEmail started.");
		
		String returnValue = "ERROR";
		String bizmekaResult = "ERROR";
		
		try {
			//관리자 권한 체크
			LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
			
			if (userInfo == null) {
				return returnValue;
			}
			
			logger.debug("bodyData=" + bodyData);
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String userId = xmldom.getElementsByTagName("CN").item(0).getTextContent();
			String primaryMail = xmldom.getElementsByTagName("PRIMARYMAIL").item(0).getTextContent();
			int tenantID = userInfo.getTenantId();
			String type = xmldom.getElementsByTagName("TYPE").item(0).getTextContent();
			String companyId = xmldom.getElementsByTagName("COMPANYID").item(0).getTextContent();
			logger.debug("type=" + type + ", companyId=" + companyId);
			
			List<String> mailList = new ArrayList<String>();
			NodeList mailNodeList = xmldom.getElementsByTagName("MAIL");
			
			for (int i=0; i<mailNodeList.getLength(); i++) {
				String mail = mailNodeList.item(i).getTextContent();
				mailList.add(mail.substring(5));
			}
			
			String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
			
			if (useBizmekaSpambox.equals("YES")) {
				String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
				String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
				String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
				
				bizmekaResult = ezEmailUtil.bizmekaEditEmailList(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, 
												userId, primaryMail, mailList);		

				logger.debug("bizmekaResult=" + bizmekaResult);
				
				if (!bizmekaResult.equals("OK")) {
					throw new Exception("bizmekaEditEmailList failed");
				}				
			}
			
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			date.setTimeZone(TimeZone.getTimeZone("GMT"));
			String nowDate = date.format(new Date()); 
			
			returnValue = ezEmailService.setIndividualAlias(userId, tenantID, primaryMail, mailList, type, companyId);
			
			if (returnValue.equals("OK")) {
				// updatedt
				if (type.equals("user") || type.equals("share")) {
					organVO.setCn(userId);
					organVO.setTenantId(tenantID);
					organVO.setNowDate(nowDate);
					
					ezOrganAdminService.updateDBData_user(organVO);
				} else if (type.equals("dept")){
					OrganDeptVO deptVo = ezOrganService.getDeptInfo(userId, userInfo.getPrimary(), tenantID);
					deptVo.setTenantId(tenantID);
					deptVo.setNowDate(nowDate);
					
					if (deptVo.getCn().equals(deptVo.getExtensionAttribute2())) {
						ezOrganAdminService.updateDBData_company(deptVo.getCn(), deptVo.getDisplayName(), deptVo.getDisplayName2(), deptVo.getMail(), deptVo.getTenantId());
					} else {
						ezOrganAdminService.updateDBData_dept(deptVo);
					}
				}
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("saveEmail ended.");
		
		return returnValue;
	}
	
	/**
	 * 조직도관리 메일주소 도메인체크 및 중복체크 실행 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/checkEmail.do", method = RequestMethod.POST)
	@ResponseBody
	public String checkEmail(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData) throws Exception{
		logger.debug("checkEmail started.");
		
		String returnValue = "ERROR";
		
		try {
			//관리자 권한 체크
			LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
			if (userInfo == null) {
				return returnValue;
			}
			int tenantId = userInfo.getTenantId();
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String mail = xmldom.getElementsByTagName("MAIL").item(0).getTextContent();
			returnValue = ezEmailService.checkIndividualAlias(mail,tenantId);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("checkEmail ended.");
		
		return returnValue;
	}
	
    /**
     * 조직도관리 편지함관리 창 호출 함수
     */
    @RequestMapping(value = "/admin/ezOrgan/configUserQuota.do", method = RequestMethod.GET)
    public String configUserQuota(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
        logger.debug("configUserQuota started.");
        
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        
        //관리자 권한 체크
        if (userInfo == null) {
            return "cmm/error/adminDenied";
        }
        int tenantID = userInfo.getTenantId();        
        logger.debug("tenantID=" + tenantID);
        
//        String strCurrentUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
//        String caller = request.getHeader("referer").replace(strCurrentUrl, "");
//        logger.debug("caller=" + caller);
       
        String userId = (request.getParameter("id") == null ? "" : request.getParameter("id"));  
        userId = commonUtil.stripTagSymbols(commonUtil.stripScriptTagsAndFunctions(userId));
        String domainName = ezCommonService.getTenantConfig("DomainName", tenantID);
        String userEmail = userId + "@" + domainName;
                        
        Double[] returnedData = ezEmailUtil.getUserQuota(userEmail);
        
        Double userQuota = returnedData[0];
        
        if (userQuota != null) {
            userQuota = userQuota/1024;
        }

        Double userWarn = returnedData[1];
        
        if (userWarn != null) {
            userWarn = userWarn/1024;
        }
        
        model.addAttribute("userId", userId);
        model.addAttribute("userQuota", userQuota);
        model.addAttribute("userWarn", userWarn);
//        model.addAttribute("caller", caller);
        
        logger.debug("configUserQuota ended.");
        
        return "admin/ezOrgan/configUserQuota";
    }
    
    /**
     * 조직도관리 사용자 편지함용량 저장 실행 함수
     */
    @RequestMapping(value = "/admin/ezOrgan/saveUserQuota.do", method = RequestMethod.POST)
    @ResponseBody
    public String saveUserQuota(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData) throws Exception {
        logger.debug("saveUserQuota started.");
        
        String returnValue = "ERROR";
        
        try {
            //관리자 권한 체크
            LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
            if (userInfo == null) {
                return returnValue;
            }
            
            logger.debug("bodyData=" + bodyData);
            
            Document xmldom = commonUtil.convertStringToDocument(bodyData);
            String userId = xmldom.getElementsByTagName("CN").item(0).getTextContent();
            String useDefault = xmldom.getElementsByTagName("useDefault").item(0).getTextContent();
            String warnStorage = xmldom.getElementsByTagName("warnStorage").item(0).getTextContent();
            String maxStorage = xmldom.getElementsByTagName("maxStorage").item(0).getTextContent();
            
            int tenantID = userInfo.getTenantId();
            String domainName = ezCommonService.getTenantConfig("DomainName", tenantID);
            String userEmail = userId + "@" + domainName;
            
            logger.debug("userEmail=" + userEmail + ",useDefault=" + useDefault 
                    + ",warnStorage=" + warnStorage + ",maxStorage=" + maxStorage);

            // 기본 스토어 설정에 따르는 경우
            if (useDefault.equals("1")) {
                ezEmailUtil.deleteUserQuota(userEmail);
				// 유저 마스터 테이블에 쿼터정보를 업데이트한다.
				Double[] returnedData = ezEmailUtil.getDefaultQuota(domainName);
				double convertMaxStorage = returnedData[0] * 1024;
				ezOrganAdminService.updateProperty(userId, "mailboxquota", String.valueOf(convertMaxStorage), "user", tenantID);
            } else {
                ezEmailUtil.setUserQuota(userEmail, maxStorage, warnStorage);
                double convertMaxStorage = Double.valueOf(maxStorage) * 1024;
				ezOrganAdminService.updateProperty(userId, "mailboxquota", String.valueOf(convertMaxStorage), "user", tenantID);
            }
            
            returnValue = "OK";
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        
        logger.debug("saveUserQuota ended.");
        
        return returnValue;
    }
    
	/**
	 * 그룹웨어 계정으로 비즈메카톡 계정을 동기화한다.
	 */
	@RequestMapping(value = "/admin/ezOrgan/syncWithBizmekaTalkAccounts.do", method = RequestMethod.POST)
	@ResponseBody
	public String syncWithBizmekaTalkAccounts(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("syncWithBizmekaTalkAccounts started.");

		String returnValue = "ERROR";

		try {
			// 전체관리자 권한 체크
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

			if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
				return returnValue;
			}

			JSONObject obj = invokeEzTalkSyncServer(userInfo.getTenantId());

			if ((boolean) obj.get("result") && 0 == (Long) obj.get("resultCode")) {
				returnValue = "OK";
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("syncWithBizmekaTalkAccounts ended.");

		return returnValue;
	}
	
	public JSONObject invokeEzTalkSyncServer(int tenantId) throws Exception {
		String ezTalkServerUrl = ezCommonService.getTenantConfig("ezTalkSyncServerUrl", tenantId);
		JSONObject result = rest.builder().post().url(ezTalkServerUrl).exchangeBody();
		logger.debug("ezTalkSyncServer getWebServerResult={}", result);

		return result;
	}

	public JSONObject invokeEzTalkSyncServerForSingle(String cn, int tenantId) throws Exception {
		String ezTalkServerUrl = ezCommonService.getTenantConfig("ezTalkSyncServerUrlForSingle", tenantId);
		JSONObject result = rest.builder().post().url(ezTalkServerUrl).jsonParam("userId", cn).exchangeBody();
		logger.debug("ezTalkSyncServerForSingle getWebServerResult={}", result);

		return result;
	}

	/**
	 * ezSyncServer를 호출하여 인사 정보를 동기화한다.
	 */
	@RequestMapping(value = "/admin/ezOrgan/syncOrganAccounts.do", method = RequestMethod.POST)
	@ResponseBody
	public String syncOrganAccounts(@CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("syncOrganAccounts started.");
		
		String returnValue = "ERROR";
		
		try {
			// 전체관리자 권한 체크
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

			if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
				return returnValue;
			}
			
			String ezSyncServerUrl = ezCommonService.getTenantConfig("ezSyncServerUrl", userInfo.getTenantId());
			String inputParams = "tenantId=" + userInfo.getTenantId();
			
			String resultCode = ezEmailUtil.getWebServiceResult(ezSyncServerUrl, inputParams);
			
			JSONParser parser = new JSONParser();
			JSONObject obj = (JSONObject) parser.parse(resultCode);
			logger.debug("ezSyncServer getWebServerResult=" + obj.toJSONString());
			
			if (!obj.get("resultCode").equals("ERROR") && obj.get("resultCode") != null) {
				returnValue = "OK";
			}
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("syncOrganAccounts ended.");
		
		return returnValue;
	}
	
	/**
	 * POP3/IMAP 설정 화면을 출력한다.
	 */
	@RequestMapping(value = "/admin/ezOrgan/configPopImap.do", method = RequestMethod.GET)
	public String configPop3Imap(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest req, Model model) throws Exception {
		logger.debug("configPop3Imap started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		String userId = req.getParameter("userId");
		String tenantDomain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String address = userId + "@" + tenantDomain;
		String requestURL = "/jMochaEzEmail/getPOP3IMAPConfig";
		String inputParams = "user_name=" + address;
		String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);

		JSONParser parser = new JSONParser();
		JSONObject responseObj = (JSONObject)parser.parse(getResult);

		if (("OK").equals(responseObj.get("resultCode"))) {
			JSONObject result = (JSONObject) responseObj.get("result");

			String popEnabled = (String) result.get("pop_enabled");
			String imapEnabled = (String) result.get("imap_enabled");

			model.addAttribute("popEnabled", popEnabled);
			model.addAttribute("imapEnabled", imapEnabled);
		}

		logger.debug("configPop3Imap ended.");
		
		return "admin/ezOrgan/configPopImap";
	}
	
	/**
	 * POP3/IMAP 설정된 값을 추가 및 수정 한다.
	 */
	@RequestMapping(value = "/admin/ezOrgan/updatePOP3IMAPConfig.do", method = RequestMethod.POST)
	@ResponseBody
	public Result updatePOP3IMAPConfig(@CookieValue("loginCookie") String loginCookie
			, HttpServletRequest req) throws Exception	 {

		logger.debug("updatePOP3IMAPConfig started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("updatePOP3IMAPConfig accessDenied.");

			return Result.failure();
		}

		String userId = req.getParameter("userId");
		String tenantDomain = ezCommonService.getTenantConfig("DomainName", userInfo.getTenantId());
		String address = userId + "@" + tenantDomain;

		String usePop3 = req.getParameter("usePop3");
		String useImap = req.getParameter("useImap");

		JgwResult jgwResult = rest.jgw().url("/jMochaEzEmail/updatePOP3IMAPConfig")
				.formParam("user_name", address)
				.formParam("usePOP3", usePop3)
				.formParam("useIMAP", useImap)
				.exchangeJgwResult();

		logger.debug("updatePOP3IMAPConfig ended.");

		return jgwResult.succeeded() ? Result.successWithCode(jgwResult.getReasonCode()) : Result.failure();
	}
	
	/**
	 * 회사 추가,수정시 운영자 전자우편 ID 가져오기
	 */
	@RequestMapping(value="/admin/ezOrgan/getComanyConfig.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> getComanyConfig(
			@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		//관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			logger.debug("getComanyConfig accessDenied.");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
		
		String companyID = request.getParameter("cn");
		
		logger.debug("getComanyConfig started.");
		logger.debug("companyID=" + companyID);
		
		int tenantID = auth.getTenantId();
		String operatorMailId = "";
		
		try {
			operatorMailId = ezCommonService.getCompanyConfig(tenantID, companyID, "operatorMailId");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("operatorMailId=" + operatorMailId);
		logger.debug("getComanyConfig ended.");
		return ResponseEntity.ok().body(operatorMailId);
	}
	
	private boolean createThumbnail(File sourceFile, File targetFile) {
		boolean result = false;
		
		try {
			BufferedImage sourceImage = ImageIO.read(sourceFile);
			int w = 100;
		    int h = 100;
		    
		    BufferedImage targetImage = new BufferedImage(w, h, BufferedImage.TYPE_INT_ARGB);

		    Graphics2D g2 = targetImage.createGraphics();
		    g2.setClip(new Ellipse2D.Float(0, 0, w, h));
		    g2.drawImage(sourceImage, 0, 0, w, h, null);
		    g2.dispose();
			
			ImageIO.write(targetImage, "png", targetFile);
			
			result = true;
		} catch (Exception e) {
			logger.debug("fail to create thumbnail : " + sourceFile.getName());
			
			try {
				Files.copy(sourceFile.toPath(), targetFile.toPath());
				logger.debug("copy original File to thumbnail.");
			} catch (IOException e1) {
				logger.error(e1.getMessage(), e1);
			}
		}
		
		return result;
	}
	
	private void setInitMailSign(OrganUserVO vo) throws Exception {
		MailSignatureVO mailSignatureVO = ezEmailService.getInitMailSignature(vo.getTenantId());
		
		if (mailSignatureVO != null) {
			OrganUserVO _vo = ezOrganAdminService.getUserInfo(vo.getCn(), "1", vo.getTenantId());
			
			String content1 = mailSignatureVO.getContent1() == null ? "" : mailSignatureVO.getContent1();
			String content2 = mailSignatureVO.getContent2() == null ? "" : mailSignatureVO.getContent2();
			String content3 = mailSignatureVO.getContent3() == null ? "" : mailSignatureVO.getContent3();
			
			content1 = content1.replace("${company}", _vo.getCompany1()).replace("${engCompany}", _vo.getCompany2()).replace("${name}", _vo.getDisplayName1()).replace("${engName}", _vo.getDisplayName2())
					.replace("${department}", _vo.getDescription1()).replace("${engDepartment}", _vo.getDescription2()).replace("${email}", _vo.getMail())
					.replace("${title}", _vo.getTitle1() == null ? "" : _vo.getTitle1()).replace("${engTitle}", _vo.getTitle2() == null ? "" : _vo.getTitle2())
					.replace("${position}", _vo.getExtensionAttribute101() == null ? "" : _vo.getExtensionAttribute101()).replace("${engPosition}", _vo.getExtensionAttribute102() == null ? "" : _vo.getExtensionAttribute102())
					.replace("${officePhone}", _vo.getTelephoneNumber() == null ? "" : _vo.getTelephoneNumber()).replace("${homePhone}", _vo.getHomePhone() == null ? "" : _vo.getHomePhone())
					.replace("${fax}", _vo.getFacsimileTelephoneNumber() == null ? "" : _vo.getFacsimileTelephoneNumber()).replace("${mobile}", _vo.getMobile() == null ? "" : _vo.getMobile())
					.replace("${zipCode}", _vo.getPostalCode() == null ? "" : _vo.getPostalCode()).replace("${address}", _vo.getStreetAddress() == null ? "" : _vo.getStreetAddress());
		
			content2 = content2.replace("${company}", _vo.getCompany1()).replace("${engCompany}", _vo.getCompany2()).replace("${name}", _vo.getDisplayName1()).replace("${engName}", _vo.getDisplayName2())
					.replace("${department}", _vo.getDescription1()).replace("${engDepartment}", _vo.getDescription2()).replace("${email}", _vo.getMail())
					.replace("${title}", _vo.getTitle1() == null ? "" : _vo.getTitle1()).replace("${engTitle}", _vo.getTitle2() == null ? "" : _vo.getTitle2())
					.replace("${position}", _vo.getExtensionAttribute101() == null ? "" : _vo.getExtensionAttribute101()).replace("${engPosition}", _vo.getExtensionAttribute102() == null ? "" : _vo.getExtensionAttribute102())
					.replace("${officePhone}", _vo.getTelephoneNumber() == null ? "" : _vo.getTelephoneNumber()).replace("${homePhone}", _vo.getHomePhone() == null ? "" : _vo.getHomePhone())
					.replace("${fax}", _vo.getFacsimileTelephoneNumber() == null ? "" : _vo.getFacsimileTelephoneNumber()).replace("${mobile}", _vo.getMobile() == null ? "" : _vo.getMobile())
					.replace("${zipCode}", _vo.getPostalCode() == null ? "" : _vo.getPostalCode()).replace("${address}", _vo.getStreetAddress() == null ? "" : _vo.getStreetAddress());
		
			content3 = content3.replace("${company}", _vo.getCompany1()).replace("${engCompany}", _vo.getCompany2()).replace("${name}", _vo.getDisplayName1()).replace("${engName}", _vo.getDisplayName2())
					.replace("${department}", _vo.getDescription1()).replace("${engDepartment}", _vo.getDescription2()).replace("${email}", _vo.getMail())
					.replace("${title}", _vo.getTitle1() == null ? "" : _vo.getTitle1()).replace("${engTitle}", _vo.getTitle2() == null ? "" : _vo.getTitle2())
					.replace("${position}", _vo.getExtensionAttribute101() == null ? "" : _vo.getExtensionAttribute101()).replace("${engPosition}", _vo.getExtensionAttribute102() == null ? "" : _vo.getExtensionAttribute102())
					.replace("${officePhone}", _vo.getTelephoneNumber() == null ? "" : _vo.getTelephoneNumber()).replace("${homePhone}", _vo.getHomePhone() == null ? "" : _vo.getHomePhone())
					.replace("${fax}", _vo.getFacsimileTelephoneNumber() == null ? "" : _vo.getFacsimileTelephoneNumber()).replace("${mobile}", _vo.getMobile() == null ? "" : _vo.getMobile())
					.replace("${zipCode}", _vo.getPostalCode() == null ? "" : _vo.getPostalCode()).replace("${address}", _vo.getStreetAddress() == null ? "" : _vo.getStreetAddress());
			
			ezEmailService.setMailSignature(vo.getTenantId(), _vo.getCn(), mailSignatureVO.getUseFlag(), content1, content2, content3);
			logger.debug("InitMailSign set.");
		}
	}
	
	private void setInitInboxRule(String loginCookie, OrganUserVO vo, Locale locale) throws Exception {
		//자동분류에 등록된 메일함이 존재하지 않으면 메일함을 생성한다.
		List<String> mailboxList = ezEmailService.getInitInboxRuleMailbox(vo.getTenantId());
		String password = commonUtil.getUserIdAndPassword(loginCookie).get(1);
		
		IMAPAccess ia = null;
		
        try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					vo.getMail(), password, egovMessageSource, locale, ezEmailUtil);
			
			for (int i = 0; i < mailboxList.size(); i++) {
				ia.createFolder(mailboxList.get(i));
			}
		} finally {
			if (ia != null) {
				ia.close();
				ia = null;
			}
		}
		
		ezEmailService.setInitInboxRule(vo.getTenantId(), vo.getCn());
		logger.debug("InitInboxRule set.");
	}
	
	private void createDefaultFolders(String loginCookie, String userEmail, Locale locale) throws Exception {
		String password = commonUtil.getUserIdAndPassword(loginCookie).get(1);		
		IMAPAccess ia = null;
		
        try {
			ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
					userEmail, password, egovMessageSource, locale, ezEmailUtil);
						
			// 기본 폴더들이 없을 때 생성한다.
			ia.getTopLevelFolders(true, false);			
		} finally {
			if (ia != null) {
				ia.close();
				ia = null;
			}
		}		
	}
	
	/**
	 * 관리자가 조직도에서 유저선택 후 모바일 설정 버튼 클릭시 호출되는 메서드 
	 */
	@RequestMapping(value="/admin/ezOrgan/configMobileManaged.do", method = RequestMethod.GET)
	public String adminMobileManaged(@CookieValue("loginCookie") String loginCookie,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("setUserMobileManaged started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		int tenantId = userInfo.getTenantId();
		String userName = request.getParameter("userName");
		String userId = request.getParameter("userId");
		logger.debug("params:userName=" + userName + ", userId=" + userId);
		
		if (userId == null) {
			return "";
		}
		
		String adminOrder = ezCommonService.getUserConfigInfo(tenantId, userId, "adminOrderNotUsedMobileLogin");
		
		if (adminOrder.equals("")) {
			adminOrder = "0";
			ezCommonService.insertUserConfigInfo(tenantId, userId, "adminOrderNotUsedMobileLogin", adminOrder);
		}
		
		// 사용자 기기목록
		String inputParams = "userId=" + userId;
		logger.debug("inputParams=" + inputParams);
		
		JSONParser parser = new JSONParser();
		JSONArray jsonArr = null;
		
		String requestURL = "/ezTalkGate/getUserMobileDeviceList";
		
		String getResult = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + requestURL, inputParams);
		logger.debug("result=" + getResult);
		
		JSONObject resultObj = (JSONObject) parser.parse(getResult);
		
		if (!resultObj.get("data").equals("0")) {
			jsonArr = (JSONArray) resultObj.get("data");
		}
		
		model.addAttribute("deviceInfo", jsonArr);
		model.addAttribute("userName", userName);
		model.addAttribute("userId", userId);
		model.addAttribute("adminOrder", adminOrder);

		logger.debug("setUserMobileManaged ended");
		return "/admin/ezOrgan/configMobileManaged";
	}
	
	/**
	 * 관리자가 유저별 모바일 설정을 한 뒤 확인 버튼을 눌렀을 때 호출되는 메서드 
	 */
	@RequestMapping(value="/admin/ezOrgan/setUserMobileManaged.do", method = RequestMethod.GET)
	@ResponseBody
	public void setUserMobileManaged(@CookieValue("loginCookie") String loginCookie,
			HttpServletRequest request, HttpServletResponse response) {
		logger.debug("setUserMobileManaged started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String returnValue = "OK";
		
		int tenantId = userInfo.getTenantId();
		String userId = request.getParameter("userId");
		String setUsed = request.getParameter("setUsed");
		
		try {
			int updateRow = ezCommonService.updateUserConfigInfo(tenantId, userId, "adminOrderNotUsedMobileLogin", setUsed);
			logger.debug("update count=" + updateRow + " userconfig adminOrderNotUsedMobileLogin=" + setUsed);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		response.addHeader("Result", returnValue);
		logger.debug("setUserMobileManaged ended");
	}

	/*
	 * 직함관리 페이지 호출 메서드
	 * */
	@RequestMapping(value="/admin/ezOrgan/jobInfoList.do", method = RequestMethod.GET, produces="application/text; charset=utf8")
	public String jobTitleList(@CookieValue("loginCookie") String loginCookie, Locale locale, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("jobInfoList started.");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
		
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("list", resultList);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		logger.debug("jobInfoList ended.");
		return "admin/ezOrgan/jobInfoList";
	}
	/*
	 * 직함관리 등록/수정 팝업창 호출 메서드 
	 * */
	@RequestMapping(value="/admin/ezOrgan/jobTitlePopupUI.do", method = RequestMethod.GET, produces="application/text; charset=utf8")
	public String jobTitlePopupUI(@CookieValue("loginCookie") String loginCookie, Locale locale, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("jobTitlePopupUI started.");
		
		userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String jobID = request.getParameter("jobID");
		String type = request.getParameter("type");
		String mode = request.getParameter("mode");
		String companyID = request.getParameter("companyID");
		String maxSort = request.getParameter("maxSort");
		
		int jobCnt = ezOrganAdminService.getTitleListCnt(type, companyID, userInfo.getTenantId());
		
		if (mode != null && mode.equals("Add"))
			jobCnt++;
		
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("companyID", companyID);
		model.addAttribute("jobCnt", jobCnt);
		model.addAttribute("type", type);
		model.addAttribute("mode", mode);
		model.addAttribute("jobID", jobID);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("maxSort", maxSort);

		logger.debug("jobTitlePopupUI ended.");
		return "admin/ezOrgan/jobTitlePopupUi";
	}
	/*
	 * 직함관리 등록/수정 버튼 동작 메서드 
	 * */
	@RequestMapping(value="/admin/ezOrgan/jobTitleAction.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> jobTitleAction(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jobTitleAction started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("jobTitleAction accessDenied.");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}

		String jobID = request.getParameter("jobID");
		String type = request.getParameter("type");
		String mode = request.getParameter("mode");
		String displayName = request.getParameter("displayName1");
		String displayName2 = request.getParameter("displayName2");
		String sort = request.getParameter("sort");
		String maxSort = request.getParameter("maxSort");
		String useFlag = request.getParameter("useFlag");
		String companyID = request.getParameter("companyID");
		
		String result = "";
		if (mode.equals("Add")) {
			result = ezOrganAdminService.setTitle(type, "", displayName, displayName2, useFlag, Integer.parseInt(maxSort), companyID, userInfo.getTenantId());
		} else if (mode.equals("Mod")) {
			result = ezOrganAdminService.updateTitle(type, jobID, displayName, displayName2, useFlag, Integer.parseInt(sort), companyID, userInfo.getTenantId());
		}
		
		logger.debug("Action mode = " + mode + " | " + "Action result = " + result);
		logger.debug("jobTitleAction ended.");
		
		return ResponseEntity.ok().body(result);
	}
	/*
	 * 직함관리 직위/직책 리스트 호출 메서드
	 * */
	@RequestMapping(value="/admin/ezOrgan/jobTitleListView.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
	@ResponseBody
	public String jobTitleListView(@CookieValue("loginCookie") String loginCookie, Locale locale, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("jobTitleListView started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String companyID = request.getParameter("companyID");
		
		String result = ezOrganAdminService.getTitleList(type, companyID, userInfo.getTenantId());
		
		logger.debug("jobTitleListView ended.");
		return result;
	}
	/*
	 * 직함관리 직위/직책 삭제 메서드
	 * */
	@RequestMapping(value="/admin/ezOrgan/jobTitleDelete.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
	@ResponseBody
	public ResponseEntity<String> jobTitleDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("jobTitleListView started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			logger.debug("jobTitleListView accessDenied.");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
		
		String jobIDList = request.getParameter("jobIDList");
		String type = request.getParameter("type");
		String companyID = request.getParameter("companyID");
		
		String result = ezOrganAdminService.deleteTitle(type, jobIDList, companyID, userInfo.getTenantId());
		
		logger.debug("jobTitleListView ended.");
		return ResponseEntity.ok().body(result);
	}
	/*
	 * 직함관리 직위/직책 사용중인 사용자 리스트 호출 메서드
	 * */
	@RequestMapping(value="/admin/ezOrgan/jobTitleUserListView.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
	@ResponseBody
	public String jobTitleUserListView(@CookieValue("loginCookie") String loginCookie, Locale locale, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("jobTitleUserListView started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String jobID = request.getParameter("jobID");
		String type = request.getParameter("type");
		String companyID = request.getParameter("companyID");
		
		String pageSize = request.getParameter("pageSize");
		String pageNum = request.getParameter("pageNum");
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");

		if (pageSize == null)
			pageSize = "";
		
		if (pageNum == null)
			pageNum = "";
		
		if (searchType == null)
			searchType = "";
		
		if (searchValue == null)
			searchValue = "";
		
		searchValue = searchValue.replace("%", "\\%").replace("_", "\\_");
		String result = ezOrganAdminService.getTitleUserList(type, jobID, pageSize, pageNum, searchType, searchValue, userInfo.getPrimary(), companyID, userInfo.getTenantId());
		
		logger.debug("jobTitleUserListView ended.");
		return result;
	}
	/*
	 * 직함관리 직위/직책 사용중인 사용자수 조회 메서드(삭제 시, 사용중인 사용자가 있는지 검사를 위한 메서드 | 직위/직책 사용중이면 삭제 불가함)
	 * */
	@RequestMapping(value="/admin/ezOrgan/jobTitleUserListCnt.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
	@ResponseBody
	public String jobTitleUserListCnt(@CookieValue("loginCookie") String loginCookie, Locale locale, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("jobTitleUserListCnt started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String jobID = request.getParameter("jobID");
		String type = request.getParameter("type");
		String companyID = request.getParameter("companyID");
		
		String result = String.valueOf(ezOrganAdminService.getTitleUserListCnt(type, jobID, companyID, userInfo.getTenantId()));
		
		logger.debug("jobTitleUserListCnt ended.");
		return result;
	}
	/*
	 * 직함관리 직위/직책 갯수 조회 메서드(중복 조회를 하기 위한 메서드)
	 * */
	@RequestMapping(value="/admin/ezOrgan/jobTitleCnt.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
	@ResponseBody
	public String jobTitleCnt(@CookieValue("loginCookie") String loginCookie, Locale locale, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("jobTitleCnt started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String jobID = request.getParameter("jobID");
		String mode = request.getParameter("mode");
		String displayName = request.getParameter("displayName");
		String displayName2 = request.getParameter("displayName2");
		String type = request.getParameter("type");
		String companyID = request.getParameter("companyID");
		
		String result = String.valueOf(ezOrganAdminService.getTitleCnt(type, jobID, mode, displayName, displayName2, companyID, userInfo.getTenantId()));
		
		logger.debug("jobTitleCnt ended.");
		return result;
	}
	/*
	 * 직함관리 직위/직책 정보 조회 메서드(수정 시, 정보를 호출하기 위한 메서드)
	 * */
	@RequestMapping(value="/admin/ezOrgan/jobTitleInfo.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
	@ResponseBody
	public String jobTitleInfo(@CookieValue("loginCookie") String loginCookie, Locale locale, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("jobTitleInfo started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String jobID = request.getParameter("jobID");
		String type = request.getParameter("type");
		String companyID = request.getParameter("companyID");
		
		String rtnXml = ezOrganAdminService.getTitleInfo(type, jobID, companyID, userInfo.getTenantId());
		
		logger.debug("jobTitleInfo ended.");
		return rtnXml;
	}
	/*
	 * 직함관리 유저의 회사를 조회하는 메서드(회사간 겸직 시, 그 회사의 직위/직책을 불러오기 위한 회사 조회)
	 * */
	@RequestMapping(value="/admin/ezOrgan/getUserCompanyID.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
	@ResponseBody
	public String getUserCompanyID(@CookieValue("loginCookie") String loginCookie, Locale locale, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("getUserCompanyID started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String cn = request.getParameter("cn");
		
		OrganUserVO vo = ezOrganAdminService.getUserInfo(cn, userInfo.getPrimary(), userInfo.getTenantId());
		
		String companyID = vo.getPhysicalDeliveryOfficeName();
		
		logger.debug("getUserCompanyID ended.");
		return companyID;
	}

	/**
	 * 직함관리 목록 표출 순서 저장하는 메서드
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveJobTitleListOrder.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public String saveJobTitleListOrder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("saveJobTitleListOrder started.");
		String result = "";
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		int tenantID = userInfo.getTenantId();
		String[] jobIdArray = request.getParameter("jobID").split(",");

		try {
			for (int i = 0; i < jobIdArray.length; i++) {
				int jobId = Integer.parseInt(jobIdArray[i]);
				int order = i + 1;
				ezOrganAdminService.updateJobTitleOrder(jobId, order, tenantID);
			}
			result = "OK"; 
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "ERROR";
		}
		
		logger.debug("saveJobTitleListOrder ended.");
		return result;
	}
	
	@RequestMapping(value="/admin/ezOrgan/getJobOptionInfo.do", method = RequestMethod.POST, produces="application/text; charset=utf8")
	@ResponseBody
	public String getJobOptionInfo(@CookieValue("loginCookie") String loginCookie, Locale locale, LoginVO userInfo, Model model, HttpServletRequest request) throws Exception {
		logger.debug("getJobOptionInfo started.");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String type = request.getParameter("type");
		String companyID = request.getParameter("companyID");
		
		String rtnXml = ezOrganAdminService.getJobOptionInfo(type, companyID, userInfo.getTenantId());
		
		logger.debug("getJobOptionInfo ended.");
		return rtnXml;
	}

	/**
	 * 조직도관리 권한관리 팝업관리 리스트 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/getPopUpPermissionsList.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getPopUpPermissionsList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
	    logger.debug("getPermissionsPopUpList started.");
	    
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantID = userInfo.getTenantId();        
        
        logger.debug("tenantID=" + tenantID);
	    
		String companyID = request.getParameter("companyID");
		String type = request.getParameter("type");
		String strLang = userInfo.getPrimary();
		String searchType = request.getParameter("searchType");
		String searchValue = request.getParameter("searchValue");
		int pageNum = Integer.parseInt(request.getParameter("pageNum"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));		
		int startRow = Math.addExact(Math.multiplyExact(pageSize, Math.subtractExact(pageNum, 1)), 1);
        int endRow = Math.multiplyExact(pageSize, pageNum);
		String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", userInfo.getTenantId());
        
        searchValue = searchValue.replace("%", "\\%").replace("_", "\\_");
                
        int cnt = ezOrganAdminService.getPermissionListCount(companyID, type, searchType, searchValue, strLang, tenantID, permissionBasisDeptYN);

        logger.debug("companyID=" + companyID + ",type=" + type + ",strLang=" + strLang);
        
        List<OrganUserVO> list = ezOrganAdminService.getPermissionList(companyID, type, searchType, searchValue, strLang, startRow, endRow, tenantID, permissionBasisDeptYN);
        
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<ROWS>");
		result.append("<TOTALCNT>");
		result.append(cnt);
		result.append("</TOTALCNT>");
        
        for (int i = 0; i < list.size(); i++) {
        	OrganUserVO vo = list.get(i);
        	
        	result.append("<ROW>");
        	result.append("<CELL>");
        	result.append("<VALUE>" + commonUtil.cleanValue(vo.getDisplayName()) + "</VALUE>");
        	//result.append("<VALUE>" + commonUtil.cleanValue(vo.getCn()) + "</VALUE>");
            result.append("<DATA1>" + commonUtil.cleanValue(vo.getCn()) + "</DATA1>");
            result.append("<DATA2>" + commonUtil.cleanValue(vo.getExtensionAttribute1()) + "</DATA2>");
            result.append("<DATA3>" + commonUtil.cleanValue(vo.getDisplayName()) + "</DATA3>");
            result.append("<DATA4>" + commonUtil.cleanValue(vo.getMail()) + "</DATA4>");
			result.append("<DATA5>" + commonUtil.cleanValue(vo.getDepartment()) + "</DATA5>");
			result.append("<DATA6>" + commonUtil.cleanValue(vo.getJobID()) + "</DATA6>"); // 중복겸직 대응하기 위한 JOBID 데이터 추가
            result.append("</CELL>");
            result.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getDescription()) + "</VALUE></CELL>");

			if (ezOrganAdminService.isThisAddJob(vo.getCn(), tenantID, vo.getDepartment(), vo.getJobID()).equals("Y")) { ; // 관리자 > 조직도 > 권한관리 > 권한등록/수정 > 우측 권한리스트에 직위 컬럼, 겸직 정보 삽입
				result.append("<CELL><VALUE>" + egovMessageSource.getMessage("ezOrgan.psb03", userInfo.getLocale()) + " "+ commonUtil.cleanValue(vo.getTitle()) + "</VALUE></CELL>");
			} else {
				result.append("<CELL><VALUE>" + commonUtil.cleanValue(vo.getTitle()) + "</VALUE></CELL>");
			}
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
        
        logger.debug("getPermissionPopUpsList ended.");
        
		return result.toString();
	}
	

	/**
	 * 조직도관리 권한 등록/삭제
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveUserPermissionInfo.do", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String saveUserPermissionInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, String[] cn, String[] extensionAttribute1, String[] permissionChType, String[] dept, String[] job, String mode) throws Exception{
		logger.debug("saveUserPermissionInfo started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		// 관리자 권한 체크
		if (userInfo == null) {
			return "EMAIL_ERROR";
		}

		int tenantId = userInfo.getTenantId();
		String id = userInfo.getId();
		String ip = ClientUtil.getClientIP(request);
		boolean modeCkh = "mode".equalsIgnoreCase(mode); // 권한 모두 삭제를 제외한 경우
		String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", userInfo.getTenantId());

		// 권한 널체크
		if(extensionAttribute1.length == 0) {
			extensionAttribute1 = new String[1];
			extensionAttribute1[0] = "c=0;k=0;g=0;a=0;i=0;n=0;l=0;w=0;m=0;e=0;"; // 2022-01-25 이사라 - e권한 다음에 ";" 추가
		}

		// 아이디, 권한, 날짜, 테턴트 셋
		List<OrganUserVO> vo = new ArrayList<OrganUserVO>();

		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date()); 

		for(int i=0; i<cn.length; i++) {
			OrganUserVO tempVO = new OrganUserVO();
			tempVO.setCn(cn[i].toLowerCase());
			tempVO.setExtensionAttribute1(extensionAttribute1[i]);
			tempVO.setTenantId(tenantId);
			tempVO.setNowDate(nowDate);
			tempVO.setDepartment(dept[i]);
			tempVO.setJobID(job[i]); // 중복겸직 대응하기 위한 JOBID 데이터 추가
			vo.add(tempVO);
		}

		// 2022-01-19 이사라 - 권한 변경 히스토리 insert 추가
		List<PermissionInfoVO> pvo = new ArrayList<>();

		if (modeCkh) { // 등록 및 해당권한만 삭제
			for (int i = 0; i < cn.length; i++) {
				String statusFromType = permissionChType[i].contains("=1") ? "Y" : "N";
				PermissionInfoVO tmpvo = new PermissionInfoVO();
				tmpvo.setUserId(cn[i].toLowerCase());
				tmpvo.setAdminType(permissionChType[i]);
				tmpvo.setAuthorizedTime(nowDate);
				tmpvo.setStatus(statusFromType);
				tmpvo.setTenant_id(tenantId);
				tmpvo.setAuthorizerId(id);
				tmpvo.setAuthorizerIp(ip);
				tmpvo.setDeptId(dept[i]);
				if (!job[i].equals("empty")) {
					tmpvo.setJobId(job[i]); // 중복겸직 대응하기 위한 JOBID 데이터 추가
				}
				pvo.add(tmpvo);
			}
		} else { // 모든권한 삭제
			String[] rollList = {};

			for (int i = 0; i < cn.length; i++) {
				rollList = permissionChType[i].split(";");
				List<String> permissionRelList = new ArrayList<String>();

				for (String list : rollList) {
					if (list.contains("1")) { // 부여 된 권한만 추출하여 해제 함
						String roll = list.replace("1", "0");
						permissionRelList.add(roll);
					}
				}

				for (String type : permissionRelList) {
					PermissionInfoVO tmpvo = new PermissionInfoVO();
					tmpvo.setUserId(cn[i].toLowerCase());
					tmpvo.setAdminType(type);
					tmpvo.setAuthorizedTime(nowDate);
					tmpvo.setStatus("N");
					tmpvo.setTenant_id(tenantId);
					tmpvo.setAuthorizerId(id);
					tmpvo.setAuthorizerIp(ip);
					tmpvo.setDeptId(dept[i]);
					tmpvo.setJobId(job[i]); // 중복겸직 대응하기 위한 JOBID 데이터 추가
					pvo.add(tmpvo);
				}
			}
		}

		String result = "";		

		try {
			// 2023-07-31 전인하 - 관리자 > 조직도 > 권한 관리 - 욥션에 따른 겸직/부서 별 권한 조작 분기 추가
			if (permissionBasisDeptYN.equals("Y")) {
				ezOrganAdminService.insertPermissionChHistBasisDept(pvo);
				ezOrganAdminService.updatePermissionBasisDept(vo);
			} else {
				ezOrganAdminService.insertPermissionChHist(pvo);
				ezOrganAdminService.updateDBData_user_new(vo);
			}
			result = "OK";
		} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
			logger.error(e.getMessage(), e);
			result = "EMAIL_ERROR";
		}

		return result;
	}
	
	/**
	 * 조직도관리 권한 추가/수정/삭제 (팝업)
	 */
	@RequestMapping(value = "/admin/ezOrgan/saveStoreUserInfo.do", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String saveStoreUserPermissionInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, String parentCn, String[] cn, String[] extensionAttribute1, String[] permissionChType, String[] dept, String[] job) throws Exception{
		logger.debug("saveStoreUserPermissionInfo started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		int tenantId = userInfo.getTenantId();
		String id = userInfo.getId();
		String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", userInfo.getTenantId());

		// 관리자 권한 체크
		if (userInfo == null) {
			return "EMAIL_ERROR";
		}
		
		// 권한 널체크
		if(extensionAttribute1.length == 0) {
			extensionAttribute1 = new String[1];
			extensionAttribute1[0] = "";
		} else { // 2022-01-25 이사라 - ApprovalFlag G 사용 시 추가권한은 ";"없이 입력되어 오류 발생으로 ";" 추가 함
			if (extensionAttribute1 != null){
				for (int i = 0; i < extensionAttribute1.length; i++) {
					String lastChk = extensionAttribute1[i];
					String fullChk = lastChk.substring(lastChk.length() - 1).equals(";") ? lastChk : (lastChk + ";");
					extensionAttribute1[i] = fullChk;
				}
			}
		}

		// 아이디, 권한, 날짜, 테턴트 셋
		List<OrganUserVO> vo = new ArrayList<OrganUserVO>();

		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date()); 

		for(int i=0; i<cn.length; i++) {
			OrganUserVO tempVO = new OrganUserVO();
			tempVO.setCn(cn[i].toLowerCase());
			tempVO.setExtensionAttribute1(extensionAttribute1[i]);
			tempVO.setTenantId(tenantId);
			tempVO.setNowDate(nowDate);
			tempVO.setDepartment(dept[i]);
			tempVO.setJobID(job[i]); // 중복겸직 대응하기 위한 JOBID 데이터 추가
			vo.add(tempVO);
		}

		// 2022-01-19 이사라 - 권한 변경 히스토리 insert 추가
		List<PermissionInfoVO> pvo = new ArrayList<>();

		for (int i = 0; i < cn.length; i++) {
			String statusFromType = permissionChType[i].contains("=1") ? "Y" : "N";
			PermissionInfoVO tmpvo = new PermissionInfoVO();
			tmpvo.setUserId(cn[i].toLowerCase());
			tmpvo.setAdminType(permissionChType[i]);
			tmpvo.setAuthorizedTime(nowDate);
			tmpvo.setStatus(statusFromType);
			tmpvo.setTenant_id(tenantId);
			tmpvo.setAuthorizerId(id);
			tmpvo.setAuthorizerIp(ClientUtil.getClientIP(request));
			tmpvo.setDeptId(dept[i]);
			tmpvo.setJobId(job[i]); // 중복겸직 대응하기 위한 JOBID 데이터 추가
			pvo.add(tmpvo);
		}

		String result = "";

		try {
			// 2023-07-31 전인하 - 관리자 > 조직도 > 권한 관리 - 욥션에 따른 겸직/부서 별 권한 조작 분기 추가
			if (permissionBasisDeptYN.equals("Y")) {
				ezOrganAdminService.insertPermissionChHistBasisDept(pvo);
				ezOrganAdminService.updatePermissionBasisDept(vo);
			} else {
				ezOrganAdminService.insertPermissionChHist(pvo);
				ezOrganAdminService.updateDBData_user_new(vo);
			}
			result = "OK";
		} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
			logger.error(e.getMessage(), e);
			result = "EMAIL_ERROR";
		}

		return result;
	}
	
	/**
	 * 권한관리 삭제 메뉴 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/chooseDeletege.do", method = RequestMethod.GET)
	public String chooseDeletege(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		LoginVO user = commonUtil.userInfo(loginCookie);
		
		String type = (request.getParameter("type") != null ? request.getParameter("type") : "");
		String permissionBasisDeptYN = ezCommonService.getTenantConfig("permissionBasisDeptYN", user.getTenantId());
		model.addAttribute("type", type);
		model.addAttribute("lang", user.getLang());
		model.addAttribute("permissionBasisDeptYN", permissionBasisDeptYN);

		return "admin/ezOrgan/chooseDeletege";
	}

	/**
	 * 조직도관리 겸직관리 겸직등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/addJobUserModify.do", method = RequestMethod.GET)
	public String addJobUserModify(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("addJobUserModify started.");

		LoginVO user = commonUtil.userInfo(loginCookie);
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}

		String topID = "";
		String userID = (request.getParameter("userID") != null ? request.getParameter("userID") : "");
		String userName = (request.getParameter("userName") != null ? request.getParameter("userName") : "");
		String selCompany = (request.getParameter("companyID") != null ? request.getParameter("companyID") : "");
		String primary = ezCommonService.getTenantConfig("LangPrimary" + user.getLang(), user.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + user.getLang(), user.getTenantId());
		String deptTreeTopId = "";

		if (organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
			topID = "Top";
			deptTreeTopId = topID + "/organ";
		} else {
			topID = user.getCompanyID();
			deptTreeTopId = topID;
		}

		model.addAttribute("topID", topID);
		model.addAttribute("use_ocs", "");
		model.addAttribute("userID", userID);
		model.addAttribute("userName", userName);
		model.addAttribute("selCompany", selCompany);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("userInfo", user);
		model.addAttribute("deptTreeTopId", deptTreeTopId);

		logger.debug("addJobUserModify ended.");

		return "admin/ezOrgan/addJobUserModify";
	}

	/**
	 * 조직도관리 겸직관리 겸직등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/addJobCompanyName.do", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> addJobCompanyName(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("addJobCompanyName started.");

		LoginVO user = commonUtil.checkAdmin(loginCookie);
		//관리자 권한 체크
		if (user == null) {
			logger.debug("addJobCompanyName accessDenied.");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}
		String displayName = (request.getParameter("displayName") != null ? request.getParameter("displayName") : "");

		String lang = user.getPrimary();
		String companyName = ezOrganAdminService.getCompanyName(displayName, user.getTenantId(), lang);
		companyName = companyName + ":" + lang;
		logger.debug("addJobCompanyName ended.");
		return ResponseEntity.ok().body(companyName);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/admin/ezOrgan/saveUserImagebyTemp.do", method = RequestMethod.POST, produces="application/json;charset=utf-8")
	@ResponseBody
	public JSONObject saveUserImagebyTemp(@CookieValue("loginCookie") String loginCookie, OrganUserVO vo, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception {
	    logger.debug("saveUserImagebyTemp started.");
	    
	    LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    String realPath = request.getServletContext().getRealPath("");
	    String thumpPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTO", userInfo.getTenantId()) + commonUtil.separator;// comonUtil.separator : /
	    String tempFilename = vo.getExtensionAttribute2();
	    String fileName[] = tempFilename.split("\\.");
	    String fileType = fileName[(fileName.length)-1];
	    
	    String cn = vo.getCn();
	    String newFileName = cn + "." + fileType;
	    String tempFilePath = thumpPath + tempFilename; 
	    String newFilePath = thumpPath + newFileName;
	    vo.setExtensionAttribute2(newFileName);
	    vo.setDoUpdatePhoto(true);		// 2021-09-12 김은실 - 메신저/인사 연동 효율성을 위한: 프로필사진 업데이트시각(PHOTO_UPDATEDT) 업데이트
	    String result = "";
	    JSONObject resultMap = new JSONObject();
	    
		result = saveUserInfo(loginCookie, vo, request, response, locale);
		resultMap.put("status", result);
		
		File oldFile =new File(commonUtil.detectPathTraversal(tempFilePath));
        File newFile =new File(commonUtil.detectPathTraversal(newFilePath));
        
        Path oldFilePathC = Paths.get(tempFilePath);

        logger.debug("oldfile is " + oldFile + " ,newfile is " + newFile);
        
        boolean isMoved = false;
        
        if (!Files.exists(oldFilePathC)) {
        	logger.debug("oldfile is not exists");
			isMoved = oldFile.renameTo(newFile);
		} else {
			logger.debug("oldfile is exists.");
			// cn.jpg형태의 기존 파일 지우고 새로운 파일을 cn.jpg로 renameTo
			newFile.delete();
			isMoved = oldFile.renameTo(newFile);
		}
        
        if (isMoved != true) {
        	logger.debug("saveUserImagebyTemp, tempImage to 'cn.etc' rename fail.");
        }
        resultMap.put("fileName", newFileName);
	    
	    logger.debug("saveUserImagebyTemp ended.");
	    return resultMap;
	}
	
	@RequestMapping(value = "/admin/ezOrgan/groupList.do", method = RequestMethod.GET)
	public String groupList(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("groupList started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(auth.getId(), auth.getTenantId(), auth.getPrimary(), auth.getDeptID(), auth.getJobId());
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", auth.getCompanyID());
		model.addAttribute("useOcs", config.getProperty("config.USE_OCS"));
		
		logger.debug("groupList ended.");

		return "admin/ezOrgan/groupList";
	}

	/**
	 * 조직도관리 사용자정지 메뉴 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/loginStop.do", method = RequestMethod.GET)	
	public String loginStop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
	    logger.debug("loginStop started");
	    
		int rollCheck = 0;
		LoginVO user = commonUtil.userInfo(loginCookie);
		OrganAuth organAuth = commonUtil.makeOrganAuth(user.getId(), user.getTenantId(), user.getDeptID(), user.getJobId());
		if (!(organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER))) {
			return "cmm/error/adminDenied";
		}
		
		if (organAuth.isAuth(AdminAuth.ADMIN_MASTER) || organAuth.isAuth(AdminAuth.COMPANY_MANAGER)) { // 전체 관리자
			rollCheck = 1;
		}

		String companyId = user.getCompanyID();

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(user.getId(), user.getTenantId(), user.getPrimary(), user.getDeptID(), user.getJobId());

		model.addAttribute("companylist", resultList);
		model.addAttribute("companyId", companyId);
		model.addAttribute("rollCheck", rollCheck);
   		
   		logger.debug("loginStop ended");
   		
		return "admin/ezOrgan/loginStop";
	}
	
	@RequestMapping(value = "/admin/ezOrgan/addGroup.do", method = RequestMethod.GET)
	public String addGroup(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("addGroup started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String deptID = auth.getDeptID();
		String cn = request.getParameter("cn") == null ? "" : request
				.getParameter("cn");
		String textName = request.getParameter("name") == null ? "" : request
				.getParameter("name");
		String useOcs = config.getProperty("config.USE_OCS");
		String companyId = request.getParameter("companyId");

		List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(auth.getId(), auth.getTenantId(), auth.getPrimary(), auth.getDeptID(), auth.getJobId());
		
		model.addAttribute("list", resultList);
		model.addAttribute("deptID", deptID);
		model.addAttribute("cn", cn);
		model.addAttribute("textName",URLDecoder.decode(textName, "UTF-8"));
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("companyId", companyId);
		model.addAttribute("dept", auth.getDeptID());
		
		logger.debug("addGroup ended.");

		return "admin/ezOrgan/addGroup";
	}
	
	@RequestMapping(value = "/admin/ezOrgan/addGroupForReference.do", method = RequestMethod.GET)
	public String addGroup2(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, HttpServletRequest request) throws Exception {
		logger.debug("addGroupForReference started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			return "cmm/error/adminDenied";
		}

		String deptID = auth.getDeptID();
		String cn = request.getParameter("cn") == null ? "" : request
				.getParameter("cn");
		String textName = request.getParameter("name") == null ? "" : request
				.getParameter("name");
		String useOcs = config.getProperty("config.USE_OCS");
		String companyId = request.getParameter("companyId");

		model.addAttribute("deptID", deptID);
		model.addAttribute("cn", cn);
		model.addAttribute("textName", textName);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("companyId", companyId);
		model.addAttribute("dept", auth.getDeptID());
		
		logger.debug("addGroupForReference ended.");

		return "admin/ezOrgan/addGroup2";
	}
	
	public String getPermissionGroupID(){
		// 권한그룹의 id를 숫자와 문자를 랜덤상수를 이용하여 생성
		Random rnd = new SecureRandom();
		StringBuffer sb = new StringBuffer();

		for (int i = 0; i < 15; i++) {
			if (rnd.nextBoolean()) {
				sb.append((char) ((int) (rnd.nextInt(26)) + 97));
			} else {
				sb.append((rnd.nextInt(10)));
			}
		}
		return sb.toString();
	}
	
	@RequestMapping(value = "/admin/ezOrgan/setPermissionGroup.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<String> setPermissionGroup(
			@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData) throws Exception {
		logger.debug("setPermissionGroup started.");

		// 관리자 권한체크
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
		if (auth == null) {
			logger.debug("setPermissionGroup accessDenied.");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}

		Document doc = commonUtil.convertStringToDocument(bodyData);
		String companyId = doc.getElementsByTagName("COMPID").item(0).getTextContent();
		String groupName = doc.getElementsByTagName("NAME").item(0).getTextContent();
		String groupID = doc.getElementsByTagName("ID").item(0).getTextContent();
		
		NodeList memberIdList = doc.getElementsByTagName("MEMBERID");
		
		String result = "ERROR";
		
		try {
			int tenantId = auth.getTenantId();
			List<String> memberList = new ArrayList<String>();
			
			// 추가
			// 2023-05-25 이사라 : 시큐어코딩 문자열 비교 오류 수정
			if (StringUtils.isEmpty(groupID)) {
			
				int userCheck = 1;
				
				while (userCheck > 0) {
					groupID = getPermissionGroupID();
					userCheck = ezOrganAdminService.userCheck(groupID, tenantId);
				}
				
				for (int i = 0; i < memberIdList.getLength(); i++) {
					memberList.add(memberIdList.item(i).getTextContent());
				}
				
				result = ezOrganAdminService.insertPermissionGroup(groupID, groupName, auth.getId(), companyId, tenantId, memberList);
			} else {
				for (int i = 0; i < memberIdList.getLength(); i++) {
					memberList.add(memberIdList.item(i).getTextContent());
				}
				
				result = ezOrganAdminService.updatePermissionGroup(groupID, groupName, auth.getId(), companyId, tenantId, memberList);
			}
			
			/* 2019-12-06 홍승비 - 권한그룹 추가, 수정 시 게시판의 트리캐시 삭제 동작 추가 */
			ezBoardAdminService.trunkBoard(tenantId);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("setPermissionGroup ended.");

		return ResponseEntity.ok().body(result);
	}
	@RequestMapping(value = "/admin/ezOrgan/getPermissionGroupList.do", method = RequestMethod.POST)	
	public String getPermissionGroupList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		logger.debug("getPermissionGroupList started");
	    
		LoginVO user = commonUtil.userInfo(loginCookie);
        int tenantID = user.getTenantId(); 
        String strLang = user.getPrimary();
        String offset = user.getOffset();
        
        logger.debug("tenantID=" + tenantID + ",strLang=" + strLang + ",offset=" + offset);
		
		int pPageRow = 20;
   		int pPage = (request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1);
   		String searchKeycode = (request.getParameter("searchKeycode") != null ? request.getParameter("searchKeycode") : "");
   		String searchKeyword = (request.getParameter("searchKeyword") != null ? request.getParameter("searchKeyword") : "");
   		String searchCompanyID = (request.getParameter("searchCompanyID") != null ? request.getParameter("searchCompanyID") : "");
   		
   		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchKeyword = commonUtil.getWildcardEscapedString(searchKeyword, dbName);
   		
   		logger.debug("pPage=" + pPage + ",pPageRow=" + pPageRow);
   		logger.debug("searchKeycode=" + searchKeycode + ",searchKeyword=" + searchKeyword);
   		
   		int totalCount = ezOrganAdminService.getPermissionGroupListCount(tenantID, searchKeycode, searchKeyword, searchCompanyID);
   		int totalPage = 1;

		if (totalCount > 0) {
			if (totalCount > pPageRow) {
				totalPage = totalCount / pPageRow;
				
				if (totalCount % pPageRow != 0) {
				    totalPage++;
				}
			}
		}
		
		logger.debug("totalCount=" + totalCount + ",totalPage=" + totalPage);
		
		List<OrganGroupVO> list = ezOrganAdminService.getPermissionGroupList(pPage, pPageRow, tenantID, offset, searchKeycode, searchKeyword, searchCompanyID);
		
   		model.addAttribute("lang", strLang);
   		model.addAttribute("list", list);
   		model.addAttribute("pPage", pPage);
   		model.addAttribute("totalPage", totalPage);
   		model.addAttribute("totalCount", totalCount);
		
   		logger.debug("getPermissionGroupList ended");
   		
		return "json";
	}
	
	@RequestMapping(value = "/admin/ezOrgan/getPermissionGroupInfo.do", produces = "text/xml;charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getPermissionGroupInfo(
			@CookieValue("loginCookie") String loginCookie, Locale locale,
			Model model, @RequestBody String bodyData) throws Exception {
		logger.debug("getPermissionGroupInfo started.");

		String returnData = "";

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantID = userInfo.getTenantId(); 
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String groupID = doc.getElementsByTagName("GROUPID").item(0).getTextContent();
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();

		try {
			List<OrganGroupVO> list = ezOrganAdminService.getPermissionGroupInfo(groupID, tenantID, companyID);

			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			sb.append("<GROUPNAME>" + list.get(0).getGroupName() + "</GROUPNAME>");
			for (OrganGroupVO vo : list) {
				String pClass = (String) vo.getMemberType();
				String pCn = (String) vo.getMemberID();

				if (pClass.equalsIgnoreCase("DEPT")) {
					OrganDeptVO dept = ezOrganService.getDeptInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());
					if (dept != null) {
						sb.append("<ROW>");
						sb.append("<CLASS>" + pClass + "</CLASS>");
						sb.append("<CN>" + commonUtil.cleanValue(pCn) + "</CN>");
						sb.append("<DISPLAYNAME>"
								+ commonUtil.cleanValue(dept.getDisplayName())
								+ "</DISPLAYNAME>");
						sb.append("<MAIL>"
								+ commonUtil.cleanValue(dept.getMail())
								+ "</MAIL>");
						sb.append("<COMPANY>"
								+ commonUtil.cleanValue(dept.getExtensionAttribute2())
								+ "</COMPANY>");
						sb.append("<DEPT>"
								+ egovMessageSource.getMessage("ezOrgan.t68",
										locale) + "</DEPT>");
						sb.append("<TITLE>"
								+ egovMessageSource.getMessage("ezOrgan.t68",
										locale) + "</TITLE>");
						sb.append("<SUBDEPTYN>"
								+ vo.getSubDeptYN() + "</SUBDEPTYN>");
						sb.append("</ROW>");
					} else {
						
					}

				} else if (pClass.equalsIgnoreCase("USER")) {
					OrganUserVO user = ezOrganAdminService.getUserInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());
					if (user != null) {
						sb.append("<ROW>");
						sb.append("<CLASS>" + pClass + "</CLASS>");
						sb.append("<CN>" + commonUtil.cleanValue(pCn) + "</CN>");
						sb.append("<DISPLAYNAME>"
								+ commonUtil.cleanValue(user.getDisplayName())
								+ "</DISPLAYNAME>");
						sb.append("<MAIL>"
								+ commonUtil.cleanValue(user.getMail())
								+ "</MAIL>");
						sb.append("<COMPANY>"
								+ commonUtil.cleanValue(user.getPhysicalDeliveryOfficeName())
								+ "</COMPANY>");
						sb.append("<DEPT>"
								+ commonUtil.cleanValue(user.getDescription())
								+ "</DEPT>");
						sb.append("<TITLE>"
								+ commonUtil.cleanValue(user.getTitle())
								+ "</TITLE>");
						sb.append("</ROW>");
					} else {
						
					}
				} else if (pClass.equalsIgnoreCase("JIKWI")) {
					OrganJobVO jikwiVO =  ezOrganAdminService.getTitleInfo_group("001", pCn, (String) vo.getMemberCompanyID(), tenantID);
					OrganDeptVO dept = ezOrganService.getDeptInfo(jikwiVO.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
					
					if (jikwiVO != null) {
						sb.append("<ROW>");
						sb.append("<CLASS>" + pClass + "</CLASS>");
						sb.append("<CN>" + commonUtil.cleanValue(pCn) + "</CN>");
						sb.append("<DISPLAYNAME>"
								+ commonUtil.cleanValue(jikwiVO.getDisplayName())
								+ "</DISPLAYNAME>");
						sb.append("<COMPANY>"
								+ commonUtil.cleanValue(jikwiVO.getCompanyID())
								+ "</COMPANY>");
						sb.append("<COMPANYNAME>"
								+ commonUtil.cleanValue(dept.getDisplayName())
								+ "</COMPANYNAME>");
						sb.append("</ROW>");
					}
				} else if (pClass.equalsIgnoreCase("JIKCHEK")) {
					OrganJobVO jikwiVO =  ezOrganAdminService.getTitleInfo_group("002", pCn, vo.getMemberCompanyID(), tenantID);
					OrganDeptVO dept = ezOrganService.getDeptInfo(jikwiVO.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
					
					if (jikwiVO != null) {
						sb.append("<ROW>");
						sb.append("<CLASS>" + pClass + "</CLASS>");
						sb.append("<CN>" + commonUtil.cleanValue(pCn) + "</CN>");
						sb.append("<DISPLAYNAME>"
								+ commonUtil.cleanValue(jikwiVO.getDisplayName())
								+ "</DISPLAYNAME>");
						sb.append("<COMPANY>"
								+ commonUtil.cleanValue(jikwiVO.getCompanyID())
								+ "</COMPANY>");
						sb.append("<COMPANYNAME>"
								+ commonUtil.cleanValue(dept.getDisplayName())
								+ "</COMPANYNAME>");
						sb.append("</ROW>");
					}
				}
			}

			sb.append("</DATA>");
			returnData = sb.toString();

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("getPermissionGroupInfo ended.");

		return returnData;
	}
	
	@RequestMapping(value = "/admin/ezOrgan/deletePermissionGroupList.do", method = RequestMethod.POST, produces = "text/html;charset=utf-8")
	@ResponseBody
	public ResponseEntity<String> deletePermissionGroupList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
	    logger.debug("deletePermissionGroupList started.");
	    
        LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
        String result = "ERROR";

		if (userInfo == null) {
			logger.debug("deletePermissionGroupList accessDenied.");

			return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
		}

        try {
        	int tenantID = userInfo.getTenantId();        
            String groupList = request.getParameter("groupList");
            String companyID = request.getParameter("companyID");
            
            logger.debug("tenantID=" + tenantID + ",cnList=" + groupList);
            ezOrganAdminService.deletePermissionGroup(groupList, companyID, tenantID);
            result = "OK";
            
            /* 2019-12-06 홍승비 - 권한그룹 삭제 시 게시판의 트리캐시 삭제 동작 추가 */
			ezBoardAdminService.trunkBoard(tenantID);
            
        } catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "ERROR";
		}
		
		logger.debug("deletePermissionGroupList ended.");

		return ResponseEntity.ok().body(result);
	}
	
	
	@RequestMapping(value="/admin/ezOrgan/getGroupList.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getGroupList(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("getGroupList started.");
		
		String returnData = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);

			List<OrganGroupVO> list = ezOrganAdminService.getGroupList(userInfo.getTenantId(), userInfo.getCompanyID());
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (OrganGroupVO vo : list) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getGroupName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>");
				sb.append(commonUtil.cleanValue(vo.getGroupID()));
				sb.append("</DATA1>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("getGroupList ended.");
		
		return returnData;
	}
	
	@RequestMapping(value="/admin/ezOrgan/getJikwiList.do", produces = "text/xml; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String getJikwiList(
			@CookieValue("loginCookie") String loginCookie, 
			Locale locale, 
			Model model, 
			HttpServletRequest request) throws Exception{
		logger.debug("getJikwiList started.");
		
		String companyID = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String type = request.getParameter("type");
		logger.debug("companyID = " + companyID + ", type = " + type);
		String result = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);

			result = ezOrganAdminService.getTitleList_group(type, companyID, userInfo.getTenantId(), userInfo.getLang());
			
		} catch (Exception e) {
			result = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("getJikwiList ended.");
		
		return result;
	}
	
	@RequestMapping(value="/admin/ezOrgan/normalUserList.do", method=RequestMethod.GET)
	public String normalUserList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("normalUserList started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyId = userInfo.getCompanyID();
		model.addAttribute("companyId", companyId);
		
		logger.debug("normalUserList ended");
		 
		return "admin/ezOrgan/normalUserList";
	}
	
	@RequestMapping(value="/admin/ezOrgan/stopUserList.do", method=RequestMethod.GET)
	public String stopUserList(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("stopUserList started");
		
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyId = userInfo.getCompanyID();
		model.addAttribute("companyId", companyId);
		
		logger.debug("stopUserList ended");
		 
		return "admin/ezOrgan/stopUserList";
	}
	
	@RequestMapping(value = "/admin/ezOrgan/getLoginStopUserList.do", method = RequestMethod.POST)
	public String getLoginStopUserList( @CookieValue("loginCookie") String loginCookie,
			Model model, HttpServletRequest req,
			@RequestParam(required = false) String searchKeycode,
			@RequestParam(required = false) String searchKeyword) throws Exception {
		logger.debug("getLoginStopUserList started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		String lang = userInfo.getLang();

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String companyId = req.getParameter("companyId");
		String currPage = req.getParameter("pageNum");
		String stopFlag = req.getParameter("stopFlag") != null ? req.getParameter("stopFlag") : "";
		String offset = userInfo.getOffset();
		
		if (currPage == null || currPage.equals("")) {
			currPage = "1";
		}

		int maxItemPerPage = 20; 
		int currentPage = Integer.parseInt(currPage);
		int startRow = Math.multiplyExact(Math.subtractExact(currentPage, 1), maxItemPerPage);
		
		if (currPage.equals("-1")) {
			startRow = -1;
		}
		
		int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
   		searchKeyword = commonUtil.getWildcardEscapedString(searchKeyword, dbName);

		// 모든 사용자의 목록을 가져온다.
		List<OrganLoginStopUserVO> userCnList;
		int itemCnt;
		
		// 사용률로 검색 시에 숫자가 아니면 빈 값으로 리턴하도록 처리
		try {
			userCnList = ezOrganAdminService.getLoginStopUserList(userInfo.getTenantId(), startRow, 
				    maxItemPerPage, searchKeycode, searchKeyword, stopFlag, offset, companyId);
			itemCnt = ezOrganAdminService.getLoginStopUserListCount(userInfo.getTenantId(), searchKeycode, searchKeyword, stopFlag, companyId);
		} catch (Exception ex) {
			logger.error(ex.getMessage(), ex);
			userCnList = new ArrayList<>();
			itemCnt = 0;
		}

		int totalPage = itemCnt / maxItemPerPage;
		
		if (itemCnt < 1) {
			totalPage = 1;
		}
		
		if ((totalPage * maxItemPerPage) != itemCnt && (itemCnt % maxItemPerPage) != 0) {
			totalPage = totalPage + 1;
		}
		
		currentPage = Math.min(currentPage, totalPage);
		
		model.addAttribute("userList", userCnList);
		model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("itemCnt", itemCnt);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("searchKeycode", searchKeycode);
		model.addAttribute("lang",lang);
		model.addAttribute("primary", userInfo.getPrimary());
		logger.debug("getLoginStopUserList ended.");

		return "json";
	}
	
	@RequestMapping(value = "/admin/ezOrgan/insertStopUser.do", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String insertStopUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req) throws Exception{
		logger.debug("insertStopUser started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		// 관리자 권한 체크
		if (userInfo == null) {
			return "EMAIL_ERROR";
		}
		
		String[] cnArr = req.getParameterValues("cn[]");
		String companyId = req.getParameter("companyId");
		
		String result = "";
		
		try {
			ezOrganAdminService.insertStopUser(cnArr, companyId, userInfo.getTenantId());
			result = "OK";
		} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
			logger.error(e.getMessage(), e);
			result = "EMAIL_ERROR";
		}

		logger.debug("insertStopUser ended.");
		return result;
	}
	
	/* 2019-09-19 홍승비 - 게시판 권한설정용 > 그룹권한리스트 호출 시 하위부서 허용/불가 여부도 함께 가져옴 */
	@RequestMapping(value="/admin/ezOrgan/getGroupListBoard.do", produces = "text/xml; charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getGroupListBoard(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("getGroupListBoard started.");
		
		String returnData = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String isAllGroupBoard = request.getParameter("isAllGroupBoard");
			if (isAllGroupBoard == null) {
				isAllGroupBoard = "";
			}
			
			// 셀렉트박스로 선택한 회사가 존재한다면, 그 값을 쿼리에 전달한다.
			String pCompanyID = userInfo.getCompanyID();
			String selectedCompanyID = request.getParameter("selectedCompanyID");
			if (selectedCompanyID != null && !selectedCompanyID.trim().equals("")) {
				pCompanyID = selectedCompanyID;
			}

			List<OrganGroupVO> list = ezOrganAdminService.getGroupListBoard(userInfo.getTenantId(), pCompanyID, isAllGroupBoard);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<LISTVIEWDATA><ROWS>");

			for (OrganGroupVO vo : list) {
				sb.append("<ROW><CELL>");
				
				sb.append("<VALUE>");
				sb.append(commonUtil.cleanValue(vo.getGroupName()));
				sb.append("</VALUE>");
				
				sb.append("<DATA1>");
				sb.append(commonUtil.cleanValue(vo.getGroupID()));
				sb.append("</DATA1>");
				
				sb.append("</CELL></ROW>");
			}
			
			sb.append("</ROWS></LISTVIEWDATA>");
			
			returnData = sb.toString();
			
		} catch (Exception e) {
			returnData = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("getGroupListBoard ended.");
		return returnData;
	}
	
	/* 2019-09-25 홍승비 - 게시판 권한설정용 > 직위,직책 리스트 호출 시 다국어 이름도 함께 가져옴 */
	@RequestMapping(value="/admin/ezOrgan/getJikwiListBoard.do", produces = "text/xml; charset=utf-8", method = RequestMethod.GET)
	@ResponseBody
	public String getJikwiListBoard(@CookieValue("loginCookie") String loginCookie, Locale locale, Model model, HttpServletRequest request) throws Exception{
		logger.debug("getJikwiListBoard started.");
		
		String companyID = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		String type = request.getParameter("type");
		String isAllGroupBoard = request.getParameter("isAllGroupBoard");
		logger.debug("companyID = " + companyID + ", type = " + type + ", isAllGroupBoard = " + isAllGroupBoard);
		
		String result = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			/* 2020-06-08 홍승비 - 그룹사게시판의 권한을 설정하는 경우 쿼리에서 회사아이디 조건을 사용하지 않도록 수정 */
			if (isAllGroupBoard.equals("Y")) {
				companyID = "";
			}

			/* 2020-05-08 홍승비 - 직위, 직책 다국어 표출 시 기본 언어를 체크하도록 수정(현재 언어=기본 언어라면 1, 아니라면 2) */
			result = ezOrganAdminService.getTitleListBoard(type, companyID, userInfo.getTenantId(), commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()));
			
		} catch (Exception e) {
			result = "ERROR";
			logger.error(e.getMessage(), e);
		}

		logger.debug("getJikwiListBoard ended.");
		return result;
	}
	
	@RequestMapping(value = "/admin/ezOrgan/deleteStopUser.do", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public String deleteLoginStopUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req) throws Exception{
		logger.debug("deleteStopUser started.");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		// 관리자 권한 체크
		if (userInfo == null) {
			return "EMAIL_ERROR";
		}
		
		String[] cnArr = req.getParameterValues("cn[]");
		String companyId = req.getParameter("companyId");		
		String result = "";
		
		try {
			ezOrganAdminService.deleteStopUser(cnArr, companyId, userInfo.getTenantId());
			result = "OK";
		} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
			logger.error(e.getMessage(), e);
			result = "EMAIL_ERROR";
		}
		
		logger.debug("deleteStopUser ended.");
		return result;
	}
	
	@RequestMapping(value = "/admin/ezOrgan/permissionGroupUserListView.do", method = RequestMethod.GET)
	public String permissionGroupUserListView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("permissionGroupUserListView started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String groupID = request.getParameter("groupID");
		String companyID = request.getParameter("companyId") != null ? request.getParameter("companyId") : "";
		
		logger.debug("groupID = " + groupID);
		logger.debug("companyID = " + companyID);
		
		int tenantID = userInfo.getTenantId();
		List<OrganGroupVO> groupUserList = ezOrganAdminService.getPermissionGroupInfo(groupID, tenantID, companyID);
		
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		for (OrganGroupVO vo : groupUserList) {
			String pClass = (String) vo.getMemberType();
			String pCn = (String) vo.getMemberID();
			
			Map<String, String> map = new HashMap<String, String>();
			
			if (pClass.equalsIgnoreCase("DEPT")) {
				OrganDeptVO dept = ezOrganService.getDeptInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());
				if (dept != null) {
					map.put("type", egovMessageSource.getMessage("main.t75", locale));
					map.put("company", dept.getExtensionAttribute3());
					map.put("dept", dept.getDisplayName());
					map.put("name", "-");
				}

			} else if (pClass.equalsIgnoreCase("USER")) {
				OrganUserVO user = ezOrganAdminService.getUserInfo(pCn, userInfo.getPrimary(), userInfo.getTenantId());
				if (user != null) {
					map.put("type", egovMessageSource.getMessage("ezSchedule.t999", locale));
					map.put("company", user.getCompany());
					map.put("dept", user.getDescription());
					map.put("name", user.getDisplayName() + "(" + pCn + ")");
				}
				
			} else if (pClass.equalsIgnoreCase("JIKWI")) {
				OrganJobVO jikwiVO =  ezOrganAdminService.getTitleInfo_group("001", pCn, (String) vo.getMemberCompanyID(), tenantID);
				OrganDeptVO dept = ezOrganService.getDeptInfo(jikwiVO.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
				
				if (jikwiVO != null) {
					map.put("type", egovMessageSource.getMessage("ezEmail.t28", locale));
					map.put("company", dept.getExtensionAttribute3());
					map.put("dept", "-");
					map.put("name", jikwiVO.getDisplayName());
				}
			} else if (pClass.equalsIgnoreCase("JIKCHEK")) {
				OrganJobVO jikwiVO =  ezOrganAdminService.getTitleInfo_group("002", pCn, vo.getMemberCompanyID(), tenantID);
				OrganDeptVO dept = ezOrganService.getDeptInfo(jikwiVO.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
				
				if (jikwiVO != null) {
					map.put("type", egovMessageSource.getMessage("ezEmail.t281", locale));
					map.put("company", dept.getExtensionAttribute3());
					map.put("dept", "-");
					map.put("name", jikwiVO.getDisplayName());
				}
			}
			list.add(map);
		}
		
		model.addAttribute("list", list);
		
		logger.debug("permissionGroupUserListView ended.");
		
		return "admin/ezOrgan/permissionGroupUserListView";
	}
	
	/*
	 * 메일주소 > 추가  레이어팝업
	 */
 	@RequestMapping(value = "/admin/ezOrgan/configEmailAdd.do")
 	public String configEmailAdd(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
 		logger.debug("configEmailAdd started.");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		//관리자 권한 체크
		if (userInfo == null) {
 			return "cmm/error/adminDenied";
 		}
 		
 		int tenantID = userInfo.getTenantId();
 		String configEmailCompanyID = request.getParameter("companyId") == null ? userInfo.getCompanyID() : request.getParameter("companyId");
 		logger.debug("tenantID=" + tenantID + ", configEmailCompanyID=" + configEmailCompanyID);
 		
 		String companyDomainList = ezEmailService.getCompanyConfig(tenantID, configEmailCompanyID, "MailInnerDomain");
 		String companyMailDomain = ezEmailService.getCompanyConfig(tenantID, configEmailCompanyID, "DomainName"); 
		String[] domainList = companyDomainList.split(";");
		logger.debug("companyDomainList=" + companyDomainList + ", companyMailDomain=" + companyMailDomain);

 		model.addAttribute("companyMailDomain", companyMailDomain);
 		model.addAttribute("domainList", domainList);
 		
 		logger.debug("configEmailAdd ended.");
 		return "admin/ezOrgan/configEmailAdd";
 	}
 	
 	/*
 	 * 관리자 > 조직도 > 엑셀내려받기
 	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/admin/ezOrgan/exportFileLogs.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject exportFileLogs(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("ezOrgan exportFileLogs start");
		// 기능 확장 시 쓸 수 있음. (선택한 부서부터) 
//		String selectedId     = request.getParameter("selectedId") != null ? request.getParameter("selectedId") : "";	
//		logger.debug("selectedId: " + selectedId);
		String isAddJob = request.getParameter("isAddJob") != null ? request.getParameter("isAddJob"): "";
		String isPermissionsList = request.getParameter("isPermissionsList") != null ? request.getParameter("isPermissionsList") : "";
		String isTotalUserList = request.getParameter("isTotalUserList") != null ? request.getParameter("isTotalUserList") : "";
		
 		LoginVO userInfo = commonUtil.userInfo(loginCookie);
 		JSONObject result = new JSONObject();
 		String rollInfo = userInfo.getRollInfo();
 		boolean isRollC = rollInfo.indexOf("c=1") > -1;		// c:전체
 		boolean isRollK = rollInfo.indexOf("k=1") > -1;		// k:회사
 		//관리자 권한 체크 
 		if (!isRollC && !isRollK) {	
			result.put("status", "error");
			result.put("code", 2);
			return result;
 		}
   		
		try {
			String primary   = userInfo.getPrimary();
			String companyId = isRollC? "" : userInfo.getCompanyID();
			int tenantId     = userInfo.getTenantId();

			String excelPath = "";

			// 겸직 리스트 요청이라면
			if ("Y".equalsIgnoreCase(isAddJob)) {
				List<OrganUserVO> exportAddJobList = ezOrganAdminService.getExportAddJobList(primary, companyId, tenantId);
				String realPath = request.getServletContext().getRealPath("");
				String pDirPath = commonUtil.getUploadPath("upload_ezOrgan.ROOT", tenantId) + commonUtil.separator;
				pDirPath = realPath + pDirPath + "temp" + commonUtil.separator;
				excelPath = ezOrganAdminService.createExcelAddJobList(realPath + commonUtil.separator, pDirPath, exportAddJobList, primary, locale);
			// 권한 리스트 요청
			} else if ("Y".equalsIgnoreCase(isPermissionsList)) {
				List<OrganUserVO> exportPermissionList = ezOrganAdminService.getExportPermissionsList(primary, companyId, tenantId);
				String realPath = request.getServletContext().getRealPath("");
				String pDirPath = commonUtil.getUploadPath("upload_ezOrgan.ROOT", tenantId) + commonUtil.separator;
				pDirPath = realPath + pDirPath + "temp" + commonUtil.separator;
				excelPath = ezOrganAdminService.createExcelPermissionsList(realPath + commonUtil.separator, pDirPath, exportPermissionList, primary, locale, isRollC);
			// 사용자 관리 리스트 요청
			} else if ("Y".equalsIgnoreCase(isTotalUserList)) {
				String searchType = request.getParameter("searchType") != null ? request.getParameter("searchType") : "";
				String searchKeyword = request.getParameter("searchKeyword") != null ? request.getParameter("searchKeyword") : "";
				String companyIdChk = request.getParameter("companyID");
				String currPage = request.getParameter("pageNum");

				if (currPage == null || currPage.equals("")) {
					currPage = "1";
				}

				int maxItemPerPage = 20;
				int currentPage = Integer.parseInt(currPage);
				int startRow = Math.multiplyExact(Math.subtractExact(Integer.parseInt(currPage), 1), maxItemPerPage);

				if (currPage.equals("-1")) {
					startRow = -1;
				}
				int dbName = globals.getProperty("Globals.DbType").equals("mysql") ? 1 : 2;
				searchKeyword = commonUtil.getWildcardEscapedString(searchKeyword, dbName);
				
				boolean [] searchFor = {true, false, false, false};
				
				List<OrganUserVO> totalUserList = ezOrganAdminService.getUserList(tenantId, startRow, maxItemPerPage, searchType, searchKeyword, companyIdChk, "", "", searchFor);
				String realPath              = request.getServletContext().getRealPath("");
				String pDirPath              = commonUtil.getUploadPath("upload_ezOrgan.ROOT", tenantId) + commonUtil.separator;
				pDirPath                     = realPath + pDirPath + "temp" + commonUtil.separator;
				excelPath             = ezOrganAdminService.createExcelTotalUsers(realPath + commonUtil.separator, pDirPath, totalUserList, primary, locale);
			
			//일반사용자 리스트 요청이라면	
			} else {
				List<OrganUserVO> exportUserlist = ezOrganAdminService.getExportUserList(primary, companyId, tenantId);
				String realPath              = request.getServletContext().getRealPath("");
				String pDirPath              = commonUtil.getUploadPath("upload_ezOrgan.ROOT", tenantId) + commonUtil.separator;
				pDirPath                     = realPath + pDirPath + "temp" + commonUtil.separator;
				excelPath             = ezOrganAdminService.createExcelUsers(realPath + commonUtil.separator, pDirPath, exportUserlist, primary, locale);
			}

			if (excelPath.equals("")) {
				result.put("status", "error");
				result.put("code", 1);
				return result;
			}
			
			result.put("status", "ok");
			result.put("path", excelPath);
			result.put("code", 0);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
		}
		
		logger.debug("ezOrgan exportFileLogs end");
		return result;
	}
	
	@RequestMapping(value="/admin/ezOrgan/downloadExcel.do", method = RequestMethod.GET)
	@ResponseBody
	public void downloadExcelReport(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("downloadExcelReport start");
		String fileName     = request.getParameter("fileName") != null ? request.getParameter("fileName") : "";
		fileName = fileName.replaceAll("[\\r\\n]", "");
		String serverName   = request.getServerName()     	   != null ? request.getServerName()     	  : "";
		String userAgent    = request.getHeader("User-Agent")  != null ? request.getHeader("User-Agent")  : "";
		userAgent = userAgent.replaceAll("[\\r\\n]", "");
		
		logger.debug("serverName: " + serverName + " || File Name: " + fileName + " || UserAgent: " + userAgent);
		
		if (serverName.equals("") || fileName.equals("")) {
			logger.debug("downloadAttach illegal arguments!");
			return;
		}
		
		//Get absolute path of the application
		String realPath  = request.getServletContext().getRealPath("");
 		LoginVO userInfo = commonUtil.userInfo(loginCookie);
 		int tenantId     = userInfo.getTenantId();
		
		try {
			ezOrganAdminService.getExcelFile(fileName, realPath, userAgent, response, tenantId);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("downloadExcelReport end");
	}
	
	@RequestMapping(value = "/admin/ezOrgan/trashDept")
	@ResponseBody
	public String trashDept(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception{
		logger.debug("trashDept started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "EMAIL_ERROR";
		}

		int tenantId = userInfo.getTenantId();
		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String cn = request.getParameter("cn");
		String company = request.getParameter("EXTENSIONATTRIBUTE2");
		String trashDeptId = "trash_dept_" + company;
		String mailAddr = trashDeptId + "@" + domain;

		logger.debug("tenantId={}, cn={}, company={}, trashDeptId={}, mailAddr={}", tenantId,cn,company,trashDeptId,mailAddr);
		
		String result = "EMAIL_ERROR";
		
		OrganDeptVO deptNm = ezOrganAdminService.getDeptDisplayNm(cn, tenantId);

		String parentCn = ezOrganAdminService.getDeptParentCn(cn, tenantId);

		try {
			// 제거하고자 하는 회사 혹은 부서 바로 아래에 위치한 자식 부서의 수를 구한다.
			int cnt = ezOrganAdminService.companyChildCheck(cn, tenantId);

			// 제거하고자 하는 회사 혹은 부서에 속한 사원의 수를 반환한다.
			int usercnt = ezOrganAdminService.userCountCheck(cn, tenantId);

			logger.debug("cnt=" + cnt + ",usercnt=" + usercnt);

			if (cnt > 0) {
				result = "HASCHILD";
			} else if (usercnt > 0) {
				result = "HASCHILD";
			} else {
				// 페지부서가 있는지 확인
				int cntUserCheck = ezOrganAdminService.userCheck(trashDeptId, tenantId);

				if (cntUserCheck <= 0) {
					logger.debug("create trashDept started");
					// 폐지부서가 없을시 폐지부서 생성
					OrganDeptVO trashDeptVO = new OrganDeptVO();
					trashDeptVO.setTenantId(tenantId);
					trashDeptVO.setParentCn(company);
					trashDeptVO.setCn(trashDeptId);
					trashDeptVO.setDisplayName("폐지부서");
					trashDeptVO.setDisplayName2("폐지부서");
					trashDeptVO.setMail(mailAddr);
					// 회사 바로 아래 맨 마지막에 위치시킨다.
					trashDeptVO.setExtensionAttribute15("9999");
					// 인사연동 시 공유 사서함 부서를 폐지시키지 않기 위해 manualFlag를 Y로 설정한다.
					trashDeptVO.setManualFlag("Y");
					
					int rc = ezEmailUserAdminService.addGroup(mailAddr);
					
					if (rc != 0) {
						logger.debug("TarashDept add Fail");
						return result;
					}
					
					ezOrganAdminService.insertDBData_dept(trashDeptVO);

					logger.debug("create trashDept ended");
				} 
				
				OrganDeptVO vo = new OrganDeptVO();
				vo.setTenantId(tenantId);
				vo.setCn(cn);
				vo.setExtensionAttribute1(trashDeptId);
				
				logger.debug("cn={}, parentCN={}", cn, trashDeptId);
				
				result = ezOrganAdminService.moveEntry(trashDeptId,cn,"group",userInfo.getOffset(),tenantId);
				// 2024-03-20 장혜연 : 부서 폐지 시 부서변경히스토리에 기록한다.
				if ("OK".equals(result)) {
					DeptChangeInfoVO deptChangeInfo = new DeptChangeInfoVO();
					deptChangeInfo.setDeptChVo(cn, deptNm.getDisplayName(), deptNm.getDisplayName2(), parentCn, "", "",
							"", "abolition", ClientUtil.getClientIP(request));
					ezSystemAdminService.insertDeptChangeHist(deptChangeInfo, userInfo);
				}
			}

		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("trashDept ended");
		return result;
	}

	@RequestMapping(value = "/admin/ezOrgan/getUserJobCheck", method = RequestMethod.POST)
	@ResponseBody
	public int getUserJobCheck(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("getUserJobCheck started.");

		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String cn = request.getParameter("cn");
		String deptId = request.getParameter("deptId");
		String jobId = request.getParameter("jobId");
		String roleId = request.getParameter("roleId");
		
		int result = ezOrganAdminService.userJobCheck(cn, deptId, jobId, roleId, userInfo.getTenantId());

		logger.debug("getUserJobCheck ended. result = " + result);

		return result;
	}

	/**
	 * 조직도관리 겸직정보 팝업 호출 함수
	 */
	@RequestMapping(value = "/admin/ezOrgan/addJobInfo.do", method = RequestMethod.GET)
	public String addJobInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("addJobInfo started");

		userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String lang = userInfo.getLang();
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());

		String useAddressOpenAPI = config.getProperty("config.USE_AddressOpenAPI");
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", userInfo.getTenantId());
		String useZipCodeSearch = ezCommonService.getTenantConfig("useZipCodeSearch", userInfo.getTenantId());
		String useOrganHideFlag = ezCommonService.getTenantConfig("useOrganHideFlag", userInfo.getTenantId());

		if (useZipCodeSearch == null || useZipCodeSearch.equals("")) {
			useZipCodeSearch = "YES";
		}
		
		boolean useOnlyInnerMail = "yes".equalsIgnoreCase(ezCommonService.getTenantConfig("UseOnlyInnerMail", userInfo.getTenantId()));
		String deptId = request.getParameter("selectDeptId");
		String jobId = request.getParameter("jobId");
		
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		model.addAttribute("lang", lang);
		model.addAttribute("useAddressOpenAPI", useAddressOpenAPI);
		model.addAttribute("birthDay", "");
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("useBizmekaSpambox", useBizmekaSpambox);
		model.addAttribute("useZipCodeSearch", useZipCodeSearch);
		model.addAttribute("locale", userInfo.getLocale());
		model.addAttribute("userPrimary", userInfo.getPrimary());
		model.addAttribute("useOnlyInnerMail", useOnlyInnerMail);
		model.addAttribute("deptId", deptId);
		model.addAttribute("jobId", jobId);
		model.addAttribute("useOrganHideFlag", useOrganHideFlag);

		logger.debug("addJobInfo ended");

		return "admin/ezOrgan/addJobInfo";
	}

	@RequestMapping(value = "/admin/ezOrgan/getEntryAddJobInfo.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getEntryAddJobInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
									 HttpServletResponse response) throws Exception {
		logger.debug("getEntryAddJobInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String language = userInfo.getLang();

		int tenantID = userInfo.getTenantId();
		logger.debug("tenantID={}", tenantID);

		String cn = request.getParameter("cn");
		String deptId = request.getParameter("deptId");
		String jobId = request.getParameter("jobId");
		//String deptId = ezOrganAdminService.getUserInfo(cn, userInfo.getPrimary(), tenantID).getDepartment();
		String prop = request.getParameter("prop");

		String entryAddJobInfo = ezOrganAdminService.getEntryAddJobInfo(cn, deptId, language, jobId, tenantID, prop);

		logger.debug("getEntryAddJobInfo ended");
		return entryAddJobInfo;
	}

	@RequestMapping(value = "/admin/ezOrgan/updateAddJobInfo.do", method = RequestMethod.POST, produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String saveAddJobInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request,
									 HttpServletResponse response) throws Exception {
		logger.debug("updateAddJobInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String result = "OK";
		// loginCookie 체크
		if (userInfo == null) {
			return "EMAIL_ERROR";
		}

		int tenantID = userInfo.getTenantId();
		logger.debug("tenantID={}", tenantID);

		String cn = request.getParameter("cn");
		String deptId = request.getParameter("deptId");
		String jobId = request.getParameter("jobId");
		String userTreeFlag = request.getParameter("userTreeFlag");
		String orderBy = request.getParameter("orderBy");
		
		try {
			ezOrganAdminService.updateAddJobInfo(cn, deptId, jobId, tenantID, orderBy, userTreeFlag);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result = "ERROR";
		}
		
		logger.debug("updateAddJobInfo ended");
		return result;
	}

	@RequestMapping(value = "/admin/ezOrgan/getCompanies.do", method=RequestMethod.GET)
	public String getCompanys(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("getCompanys started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String lang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), lang, userInfo.getDeptID(), userInfo.getJobId());
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		model.addAttribute("userCompany", userInfo.getCompanyID());
		model.addAttribute("list", adminCompanyList);
		model.addAttribute("isMaster", organAuth.isAuth(AdminAuth.ADMIN_MASTER));

		logger.debug("getCompanys ended.");

		return "json";
	}

	@RequestMapping(value = "/admin/ezOrgan/loginCntReset.do", method=RequestMethod.POST)
	@ResponseBody
	public void loginCntReset(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		logger.debug("loginCntReset started.");

	String cn = request.getParameter("cn");

		logger.debug("cn=" + request.getParameter("cn"));

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			throw new Exception("loginCntReset failed.");
		}

		int tenantID = userInfo.getTenantId();

		logger.debug("tenantID=" + tenantID);
		ezOrganAdminService.resetLoginCnt(cn, tenantID);

		logger.debug("loginCntReset ended.");
	}
}
