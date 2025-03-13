package egovframework.ezEKP.ezNewPortal.web;

import java.math.BigInteger;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.TimeZone;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.UIDFolder;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezNewPortal.vo.ConnectPortletDTO;
import egovframework.ezEKP.ezNewPortal.vo.DeptViewVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalTopVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalTopVO.TopFrameType;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;

import com.nimbusds.openid.connect.sdk.claims.UserInfo;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.PortletAprInfoVO;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.web.EzBoardController;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezEmail.logic.IMAPAccess;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.DeptViewVO;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.FrameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuAuthorUserVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuNameVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalBoardTreeVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalLogoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletNameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezNewPortal.vo.WeatherVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuAuthorUserVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganGroupVO;
import egovframework.ezEKP.ezOrgan.vo.OrganJobVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleGoogleService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.service.impl.EzScheduleCompareUtil;
import egovframework.ezEKP.ezSchedule.vo.ScheduleCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleDeptVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
import egovframework.ezEKP.ezSurvey.service.EzSurveyService;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.SystemConfigTypeVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigVO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.rest.Result;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.w3c.dom.Document;

import javax.annotation.Resource;
import javax.mail.Flags;
import javax.mail.Folder;
import javax.mail.Message;
import javax.mail.UIDFolder;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.stream.Collectors;

@RestController
public class EzNewPortalGWController {
	private static final Logger logger = LoggerFactory.getLogger(EzNewPortalGWController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EzEmailUtil ezEmailUtil;

	@Autowired
	private EzCommonService ezCommonService;

	@Resource(name = "jspw")
	private String jspw;

	@Resource(name = "EzNewPortalService")
	private EzNewPortalService ezNewPortalService;

	@Resource(name = "EzBoardService")
	private EzBoardService ezBoardService;

	@Resource(name = "EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	@Resource(name = "MOptionService")
	private MOptionService mOptionService;

	@Resource(name = "EzPersonalService")
	private EzPersonalService ezPersonalService;

	@Resource(name = "EzCircularService")
	private EzCircularService ezCircularSerivce;

	@Resource(name = "EzScheduleService")
	private EzScheduleService ezScheduleService;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGSerivce;
	
	@Autowired
	private EzSurveyService ezSurveyService;

	@Resource(name = "EzWebFolderService_y")
	private EzWebFolderService_y ezWebFolderService_y; 

	@Autowired
	private Properties config;

	@Autowired
	private EzOrganService ezOrganService;

	@Autowired
	private EzOrganAdminService ezOrganAdminService;

	@Autowired
	private EzEmailService ezEmailService;

	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzScheduleGoogleService googleService;
	
	@Autowired
	private EzSystemAdminService ezSystemAdminService;

	// ///사용자///////
	/**
	 * 포탈개인화 G/W [GET] 사용자별 개인화 정보 조회
	 * 2023-10-30 gbpark0524 : 회사별 포탈 구분을 위한 회사 파라미터 추가.
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/settingInfo/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserPortalSetting(HttpServletRequest request, @PathVariable String userId, Locale locale) throws Exception {
		logger.debug("ezNewPortal G/W getUserPortalSetting started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String jobId = Optional.ofNullable(request.getParameter("jobId")).orElse("");
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			String userLang = commonUtil.getPrimaryData(info.getLang(), info.getTenantId());
			String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", info.getTenantId());
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId + ", portletLang : " + portletLang + ", deptPath : " + deptPath);
			Optional<OrganUserVO> userInfo = ezOrganService.getUserInfo(tenantId, userId, companyId, deptId, jobId, userLang);

			if (!userInfo.isPresent()) {
				throw new Exception("There are no query result about user matching the given conditions.");
			}

			OrganUserVO organUserVO = userInfo.get();

			// 사용자 설정 테마/프레임 가져오기
			UserPortalSettingVO userThemeSetting = ezNewPortalService.getUserPortalSetting(userId, companyId, tenantId, deptPath, portletLang);
			//logger.debug("usedTheme : " + userThemeSetting.getUsedTheme() + ", usedFrame : " + userThemeSetting.getUsedFrame()); // 로그정리 : 서비스에서 찍어 줌
			
			List<PortletInfoVO> portletOrder = ezNewPortalService.getUserPortletList(userThemeSetting.getUsedTheme(), portletLang, userId, tenantId, companyId, deptId, false);
			
			//1. tenant config가 NO인 경우 사용자 포틀릿 순서에서도 나오면 안됨
			//컨피그 : useQuestion(전자설문), useSurvey(전자설문 리뉴얼), useMemo(메모), useLadder(사다리게임), useCabinet(캐비닛), 
			//		 useBallotSystem(투표), USE_JOURNAL(업무일지), USE_CIRCULAR(회람판), USE_ATTITUDE(근태관리)
			//		 useWebfolder(웹폴더),  USE_ezPMS(프로젝트관리), USE_COMMUNITY(커뮤니티), useExternalMailServer(메일)
			String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
			String useSurvey = ezCommonService.getTenantConfig("useSurvey", tenantId);
			String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
			String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
			String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
			String useVote = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
			String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
			String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
			String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
			String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
			String useEzPMS = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
			String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
			String useEzWorkspace = ezNewPortalService.isUseEzWorkspace(companyId, tenantId, userId, deptId);
			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId);
			
			String useSchedule = ezCommonService.getTenantConfig("useSchedule", tenantId);
			String useResource = ezCommonService.getTenantConfig("useResource", tenantId);
			String useBoard = ezCommonService.getTenantConfig("useBoard", tenantId);
			String useToDo = ezCommonService.getTenantConfig("useToDo", tenantId);
			String useCar = ezCommonService.getTenantConfig("useCar", tenantId);
			String useFixBoard = ezCommonService.getTenantConfig("useFixBoard", tenantId);

			boolean usePortletSize = "Y".equals(ezCommonService.getTenantConfig("usePortletSize", tenantId));

			logger.debug("[config] useQuestion : " + useQuestion + ", useSurvey : " + useSurvey + ", useMemo : " + useMemo + ", useCabinet : " + useCabinet
						+ ", useVote : " + useVote + ", useJournal : " + useJournal + ", useCircular : " + useCircular + ", useAttitue : " + useAttitude
						+ ", useWebfolder : " + useWebfolder + ", useEzPMS : " + useEzPMS + ", useCommunity : " + useCommunity + ", useEzWorkspace : " + useEzWorkspace
						+ ", useMail : " + useExternalMailServer);
			if (useAttitude == null || useAttitude.equals("")) {
				useAttitude = "NO";
			}
			
			if (useMemo == null || useMemo.equals("")) {
				useMemo = "YES";
			}
			
			if (useLadder == null || useLadder.equals("")) {
				useLadder = "NO";
			}
			
			if (useCabinet == null || useCabinet.equals("")) {
				useCabinet = "NO";
			}
			
			if (useVote == null || useVote.equals("")) {
				useVote = "YES";
			}
			
			if (useJournal == null || useJournal.equals("")) {
				useJournal = "NO";
			}
			
			if (useCircular == null || useCircular.equals("")) {
				useCircular = "YES";
			}
			
			if (useQuestion == null || useQuestion.equals("")) {
				useQuestion = "NO";
			}
			
			if (useSurvey == null || useSurvey.equals("")) {
				useSurvey = "YES";
			}
			
			if (useWebfolder == null || useWebfolder.equals("")) {
				useWebfolder = "NO";
			}
			
			if (useCommunity == null || useCommunity.equals("")) {
				useCommunity = "YES";
			}
			
			if (useEzPMS == null || useEzPMS.equals("")) {
				useEzPMS = "NO";
			}
			
			if (useExternalMailServer == null || useExternalMailServer.equals("")) {
				useExternalMailServer = "NO";
			}
			
			if (useSchedule == null || useSchedule.equals("")) {
				useSchedule = "YES";
			}
			
			if (useResource == null || useResource.equals("")) {
				useResource = "YES";
			}
			
			if (useBoard == null || useBoard.equals("")) {
				useBoard = "YES";
			}
			
			if (useToDo == null || useToDo.equals("")) {
				useToDo = "YES";
			}

			if (useCar == null || useCar.equals("")) {
				useCar = "NO";
			}

			if (StringUtils.isBlank(useFixBoard)) {
				useFixBoard = "YES";
			}

			if (useQuestion.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("question")));
			}
			
			if (useSurvey.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("survey")));
			}
			
			if (useMemo.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("memo")));
			}
			
			if (useLadder.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("ladder")));
			}
			
			if (useCabinet.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("cabinet")));
			}
			
			if (useVote.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("vote")));
			}
			
			if (useJournal.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("journal")));
			}
			
			if (useCircular.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("circular")));
			}
			
			if (useAttitude.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("attitude")));
			}
			
			if (useWebfolder.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("webfolder")));
			}
			
			if (useEzPMS.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("pms")));
			}
			
			if (useCommunity.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("community")));
			}
			
			if (useSchedule.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("schedule")));
			}
			
			if (useResource.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("resource")));
			}
			
			if (useBoard.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("board")));
			}
			
			if (useToDo.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("task")));
			}
			
			if (useCar.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("car")));
			}

			if (useFixBoard.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("fix")));
			}

			//인터넷 사용이 NO 인 경우에는 weather portlet사용 불가능
			String useInternet = config.getProperty("config.useInternet");
			logger.debug("useInternet=" + useInternet);
			if (useInternet.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getPortletCode() != null && vo.getPortletCode().equals("weather")));
			}
			
			/* 2025-03-07 홍승비 - 협업 메뉴 사용 여부 판별 시 URL이 아닌 메뉴코드를 사용하도록 수정 */
			// 협업 사용여부에 따라 제거 
			if (useEzWorkspace.equals("NO")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("workspace")));
			}

			if (useExternalMailServer.equalsIgnoreCase("YES")) {
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("mail")));
				portletOrder.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("address")));
			}

			List<PortletInfoVO> fixedPortletList = portletOrder.stream()
					.filter(PortletInfoVO::isFixBoard)
					.collect(Collectors.toList());
			portletOrder.removeAll(fixedPortletList);

			if (!usePortletSize) {
				portletOrder.replaceAll(vo -> {
					vo.setClassSize("one_by_one");
					return vo;
				});
			} else {
				Map<Integer, List<String>> avMap = ezNewPortalService.getAvailablePortletSize(userThemeSetting.getUsedTheme(), companyId, tenantId);
				for (PortletInfoVO vo : portletOrder) {
					vo.setListPortletSize(avMap.getOrDefault(vo.getPortletId(), Collections.singletonList("one_by_one")));
				}
			}

			JSONObject data = new JSONObject();
			data.put("fixedPortletList", fixedPortletList);
			data.put("portletOrder", portletOrder);

			
			if (!"1".equals(portletLang) && !"2".equals(portletLang)) {
				List<PortletInfoVO> helpPortlet = portletOrder.stream()
				.filter(vo -> vo.getPortletId() == 12)
				.collect(Collectors.toList());
				portletOrder.removeAll(helpPortlet);
			}
			
			// 회사의 슬라이더 이미지 가져오기
			List<PersonalSliderImageVO> sliderList = ezPersonalService.getSilderList(companyId, "USER", null, tenantId);

			String userName = "";
			String userTitle = "";
			String deptName = "";
			String userPhoto = "";
			//String lastLogin = commonUtil.getDateStringInUTC(info.getLastLogin(), info.getOffSet(), false);
			//String lastLogin = info.getLastLogin();
			String lastLogin = "";
			
			lastLogin = ezOrganService.getLastLogin(userId, info.getTenantId());
			
			if (lastLogin != null) {
				lastLogin = EgovDateUtil.convertDate(lastLogin, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
				lastLogin = commonUtil.getDateStringInUTC(lastLogin, info.getOffSet(), false);
			} else {
				lastLogin = "";
			}


			
			// 회원정보 불러오기
			userName = organUserVO.getDisplayName();
			userTitle = organUserVO.getTitle();
			deptName = organUserVO.getDescription();

			// IP
			String lastLoginIP = ezOrganService.getLoginIP(userId, info.getTenantId());
			
			// 유저이미지
			String imgUrl = ezOrganService.getPropertyValue(userId, "extensionAttribute2", tenantId);

			if (imgUrl != null && !imgUrl.equals("")) {
				userPhoto = commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + imgUrl;
			}

			// 메일, 결재, 일정, 전자설문, 회람판, 근태관리 권한이 있는지 확인
			String useMail = "NO";
			String useApproval = "NO";
			//String useSchedule = "NO";

			// 2. 메뉴에 권한이 있는지 ================ 수정하기 start
			
			List<MenuInfoVO> menuList = ezNewPortalService.getUserMenuList(companyId, tenantId, portletLang, userId, deptId);
			
			boolean isUseQuestionAuth = false;
			boolean isUseSurveyAuth = false;
			boolean isUseScheduleAuth = false;
			
			for (MenuInfoVO mVO : menuList) {
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("approval")) {
					useApproval = "YES";
				} 
				
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("question") && useQuestion.equals("YES")) {
					isUseQuestionAuth = true;
				}
				
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("survey") && useSurvey.equals("YES")) {
					isUseSurveyAuth = true;
				}
				
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("mail")) {
					useMail = "YES";
				}
				
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("schedule") && useSchedule.equals("YES")) {
					isUseScheduleAuth = true;
				}
			}
			
			if (isUseQuestionAuth) {
				useQuestion = "YES";
			} else {
				useQuestion = "NO";
			}
			
			if (isUseSurveyAuth) {
				useSurvey = "YES";
			} else {
				useSurvey = "NO";
			}
			
			if(isUseScheduleAuth) {
				useSchedule = "YES";
			} else {
				useSchedule = "NO";
			}
			
			boolean isUseCircular = false;
			
			for (MenuInfoVO mVO : menuList) {
				
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("circular") && useCircular.equals("YES")) {
					isUseCircular = true;
					break;
				} else {
					isUseCircular = false;
				}
			}
			
			if (isUseCircular) {
				useCircular = "YES";
			} else {
				useCircular = "NO";
			}
			
			boolean isUseAttitude = false;
			
			for (MenuInfoVO mVO : menuList) {
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("attitude") && useAttitude.equals("YES")) {
					isUseAttitude = true;
					break;
				} else {
					isUseAttitude = false;
				}
			}
			
			if (isUseAttitude) {
				useAttitude = "YES";
			} else {
				useAttitude = "NO";
			}
			
			if (useExternalMailServer.equalsIgnoreCase("YES")) {
				useMail = "NO";
			} else {
				useMail = "YES";
			}
			
			logger.debug("useAttitude : " + useAttitude + ", useQuestion : " + useQuestion + ", useSurvey : " + useSurvey + ", useCircular : " + useCircular);
			logger.debug("useMail : " + useMail + ", useApproval : " + useApproval + ", useSchedule : " + useSchedule);
			// =================================== 여기까지 end

			//2019-08-07  자동리프레시 가져오기
			String usePortalAutoRefreshInterval = ezCommonService.getTenantConfig("usePortalAutoRefreshInterval", tenantId);
			logger.debug("usePortalAutoRefreshInterval : " + usePortalAutoRefreshInterval);
			
			if (usePortalAutoRefreshInterval == null || usePortalAutoRefreshInterval.equals("")) {
				logger.debug("userPortalAutoRefreshInterval is none!");
				String propertyName = "usePortalAutoRefreshInterval";
				String propertyValue = "5";
				String description = "포탈 자동 새로고침 간격, 단 0이면 새로고침 사용안함";
				String configName = "포탈 자동 새로고침 간격";
				String configType = "포탈";
				
				ezNewPortalService.addPortalTenantConfig(tenantId, propertyName, propertyValue, description, configName, configType);
				usePortalAutoRefreshInterval = ezCommonService.getTenantConfig("usePortalAutoRefreshInterval", tenantId);
			}
			
			//if ("YES".equals(useEzWorkspace)) {
				String workspaceHostUrl = ezCommonService.getTenantConfig("workspaceHostUrl", tenantId);
				String workspaceContextRootUrl = ezCommonService.getTenantConfig("workspaceContextRootUrl", tenantId);
				
				/* 2025-03-13 홍승비 - 협업 모듈에 고정된 하드코딩 문자열 제거 (ezWorkspace), 테넌트 컨피그 workspaceAppPath로 협업 웹응용프로그램 경로를 분리하여 사용 ("" 또는 "/ezWork" 등) */
				String workspaceAppPath = ezCommonService.getTenantConfig("workspaceAppPath", tenantId);
				
				data.put("workspaceHostUrl", workspaceHostUrl);
				data.put("workspaceContextRootUrl", workspaceContextRootUrl);
				data.put("workspaceAppPath", workspaceAppPath);
			//}
			
			data.put("usedTheme", userThemeSetting.getUsedTheme());
			data.put("usedFrame", userThemeSetting.getUsedFrame());
			data.put("usePaging", userThemeSetting.getUsePaging());
//			data.put("portletOrder", portletOrder);
			data.put("sliderList", sliderList);
			data.put("userName", userName);
			data.put("userTitle", userTitle);
			data.put("deptName", deptName);
			data.put("userPhoto", userPhoto);
			data.put("useAttitude", useAttitude);
			data.put("useQuestion", useQuestion);
			data.put("useSurvey", useSurvey);
			data.put("useCircular", useCircular);
			data.put("useEzWorkspace", useEzWorkspace);
			data.put("useMail", useMail);
			data.put("useApproval", useApproval);
			data.put("useSchedule", useSchedule);
			data.put("useBoard", useBoard);
			data.put("useCar", useCar);
			data.put("useResource", useResource);
			data.put("lastLogin", lastLogin);
			data.put("userEmail", info.getEmail());
			data.put("usePortalAutoRefreshInterval", usePortalAutoRefreshInterval);
			data.put("lastLoginIP", lastLoginIP);
			
			/* 2023-06-05 홍승비 - 커뮤니티, 메모, 웹폴더 모듈 사용여부 테넌트 컨피그 추가 */
			data.put("useCommunity", useCommunity);
			data.put("useMemo", useMemo);
			data.put("useWebfolder", useWebfolder);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		logger.debug("ezNewPortal G/W getUserPortalSetting ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 사용자별 포틀릿 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/order/users/{userId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updatePortletOrder(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updatePortletOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			JSONArray portletOrder = (JSONArray) jsonParam.get("updateOrder");
			int themeId = Integer.parseInt(jsonParam.get("themeId").toString());
			String companyId = request.getParameter("companyId");
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId + "portletLang : " + portletLang);
			logger.debug("themeId : " + themeId);
			
			ezNewPortalService.updatePortletOrderUser(userId, companyId, tenantId, portletOrder, portletLang, themeId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updatePortletOrder ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 월별 생일 사원 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/birthday/months/{month:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMonthlyBirthdayEmployees(HttpServletRequest request, @PathVariable int month) throws Exception {
		logger.debug("ezNewPortal G/W getMonthlyBirthdayEmployees started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = info.getCompanyId();
			int tenantId = info.getTenantId();
			int curPage = Integer.parseInt(request.getParameter("birthdayCurPage")) - 1;
			int count = Integer.parseInt(request.getParameter("birthdayCount"));
			int startRow = Math.multiplyExact(curPage, count);
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			logger.debug("curPage : " + curPage + ", count : " + count + ", startRow : " + startRow + ", lang : " + lang);
			
			int birthdayListCount = ezNewPortalService.getMonthlyBirthdayEmployeesCount(companyId, tenantId, month);
			List<PortalUserInfoVO> birthdayList = ezNewPortalService.getMonthlyBirthdayEmployees(companyId, tenantId, month, count, startRow, lang);
			
			logger.debug("birthdayListCount : " + birthdayListCount);

//			if (birthdayListCount != 0) {
//				int page = birthdayListCount / 6;
//				
//				if (page == curPage) {
//					curPage = 0;
//				} else {
//					curPage = Math.addExact(curPage, 1);
//				}
//			}

			JSONObject data = new JSONObject();
			data.put("birthdayList", birthdayList);
			data.put("birthdayListCount", birthdayListCount);
			data.put("birthdayCurPage", curPage + 1);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getMonthlyBirthdayEmployees ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 이달의 우수 사원 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/bestEmployee/months/{month:.+}/{company:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getMonthlyBestEmployee(HttpServletRequest request, @PathVariable int month, @PathVariable String company) throws Exception {
		logger.debug("ezNewPortal G/W getMonthlyBestEmployee started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			Calendar cal = Calendar.getInstance();
			String nowYear = String.valueOf(cal.get(Calendar.YEAR));
			
			String yearAndMonth = nowYear + "-" + month;
			int tenantId = info.getTenantId();
			String lang = commonUtil.getMultiData(info.getLang(), tenantId);
			
			logger.debug("yearAndMonth : " + yearAndMonth);
			PortalUserInfoVO bestEmployee = ezNewPortalService.getMonthlyBestEmployee(yearAndMonth, company, tenantId, lang);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", bestEmployee);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getMonthlyBestEmployee ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 사용자별 테마 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/themes/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserThemeList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("ezNewPortal G/W getUserThemeList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			int tenantId = info.getTenantId();
			String deptId = request.getParameter("deptId");
			String lang = info.getLang();
			
			// deptpath 구하기
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId + ", deptPath : " + deptPath + ", lang : " + lang);
			
			// List<ThemeInfoVO> userThemeList =
			// ezNewPortalService.getUserThemeListr(companyId, tenantId);
			List<ThemeInfoVO> userThemeList = ezNewPortalService.getThemes(false, companyId, tenantId, userId, deptPath, lang);
			UserPortalSettingVO userThemeSetting = ezNewPortalService.getUserPortalSetting(userId, companyId, tenantId, deptPath, lang);
			
			boolean hasUserDefault = false;
			int usedTheme = 0;
			
			for (int i = 0; i < userThemeList.size(); i++) {
				if (userThemeList.get(i).isThemeUsed()) {
					hasUserDefault = true;
				}
			}
			
			if (!hasUserDefault) {
				usedTheme = userThemeSetting.getUsedTheme();
			}
			
			for (int i = 0; i < userThemeList.size(); i++) {
				if (userThemeList.get(i).getThemeId() == usedTheme) {
					userThemeList.get(i).setThemeUsed(true);
					hasUserDefault = true;
				}
			}
			
			// 자신의 default 테마도 없고, 기본테마에도 권한이 없는 경우 themelist의 첫번째를 선택하게 해줌
			if (!hasUserDefault) {
				userThemeList.get(0).setThemeUsed(true);
			}
			 
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userThemeList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getUserThemeList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 사용자별 메뉴 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/menus/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserMenuList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("ezNewPortal G/W getUserMenuList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId") != null ? request.getParameter("companyId") : info.getCompanyId();
			String offset = info.getOffSet();
			int tenantId = info.getTenantId();
			String langType = info.getLang();
			String logoType = "P";
			String deptId = request.getParameter("deptId");
			String jobId = request.getParameter("jobId");
			JSONObject data = new JSONObject();

			/**
			 * 1) 로고
			 */
			int themeColor = ezNewPortalService.getUserColor(userId, companyId, tenantId);
			
			if (themeColor == 3) { // 다크모드
				logoType = "D";
			}
			
			String logoUrl = ezNewPortalService.getPortalLogoInfo(companyId, tenantId, logoType);
			
			if (logoUrl == null || logoUrl.equals("")) {
				if (themeColor == 3) {
					logoUrl = "/images/ezNewPortal/skin/dark/logo_white.png";
				} else {
					logoUrl = "/files/upload_portal/Top/Logo/logo.png";	
				}
			} else {
				logoUrl = commonUtil.getUploadPath("upload_newPortal.ROOT", tenantId) + commonUtil.separator + "uploadFile" + commonUtil.separator + logoUrl;
			}
			
			logger.debug("logoUrl : " + logoUrl);

			/**
			 * 2) 메인메뉴 및 서브메뉴 - 권한체크 - user 순서가 없을 경우 회사 순서로 진행
			 */
			List<MenuInfoVO> menuList = ezNewPortalService.getUserMenuList(companyId, tenantId, langType, userId, deptId);
			
			//tenant config가 NO인 경우 사용자 메뉴 순서에서도 나오면 안됨
			//컨피그 : useQuestion(전자설문), useSurvey(전자설문 리뉴얼), useMemo(메모), useLadder(사다리게임), useCabinet(캐비닛), 
			//		 useBallotSystem(투표), USE_JOURNAL(업무일지), USE_CIRCULAR(회람판), USE_ATTITUDE(근태관리)
			//		 useWebfolder(웹폴더),  USE_ezPMS(프로젝트관리), USE_COMMUNITY(커뮤니티),useCar(차량관리)
			String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
			String useSurvey = ezCommonService.getTenantConfig("useSurvey", tenantId);
			String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
			String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
			String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
			String useVote = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
			String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
			String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
			String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
			String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
			String useEzPMS = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
			String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
			
			String useSchedule = ezCommonService.getTenantConfig("useSchedule", tenantId);
			String useResource = ezCommonService.getTenantConfig("useResource", tenantId);
			String useBoard = ezCommonService.getTenantConfig("useBoard", tenantId);
			String useToDo = ezCommonService.getTenantConfig("useToDo", tenantId);
			String useCar = ezCommonService.getTenantConfig("useCar", tenantId);
			
			// 2020-04-09 김민성 - 메일 메뉴 컨피그 추가
			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId);
			
			if (useAttitude == null || useAttitude.equals("")) {
				useAttitude = "NO";
			}
			
			if (useMemo == null || useMemo.equals("")) {
				useMemo = "YES";
			}
			
			if (useLadder == null || useLadder.equals("")) {
				useLadder = "NO";
			}
			
			if (useCabinet == null || useCabinet.equals("")) {
				useCabinet = "NO";
			}
			
			if (useVote == null || useVote.equals("")) {
				useVote = "YES";
			}
			
			if (useJournal == null || useJournal.equals("")) {
				useJournal = "NO";
			}
			
			if (useCircular == null || useCircular.equals("")) {
				useCircular = "YES";
			}
			
			if (useQuestion == null || useQuestion.equals("")) {
				useQuestion = "NO";
			}
			
			if (useWebfolder == null || useWebfolder.equals("")) {
				useWebfolder = "NO";
			}
			
			if (useCommunity == null || useCommunity.equals("")) {
				useCommunity = "YES";
			}
			
			if (useEzPMS == null || useEzPMS.equals("")) {
				useEzPMS = "NO";
			}
			
			if (useExternalMailServer == null || useExternalMailServer.equals("")) {
				useExternalMailServer = "NO";
			}
			
			if (useSurvey == null || useSurvey.equals("")) {
				useSurvey = "YES";
			}
			
			if (useSchedule == null || useSchedule.equals("")) {
				useSchedule = "YES";
			}
			
			if (useResource == null || useResource.equals("")) {
				useResource = "YES";
			}
			
			if (useBoard == null || useBoard.equals("")) {
				useBoard = "YES";
			}
			
			if (useToDo == null || useToDo.equals("")) {
				useToDo = "YES";
			}
			
			if (useCar == null || useCar.equals("")) {
				useCar = "NO";
			}
			
			if (useQuestion.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("question")));
			}
			
			if (useMemo.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("memo")));
			}
			
			if (useLadder.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("ladder")));
			}
			
			if (useCabinet.equals("NO")) {
				menuList.removeIf(vo -> vo.getMenuCode() != null && (vo.getMenuCode().equals("cabinet")));
			}
			
			if (useVote.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("vote")));
			}
			
			if (useJournal.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("journal")));
			}
			
			if (useCircular.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("circular")));
			}
			
			if (useAttitude.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("attitude")));
			}
			
			if (useWebfolder.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("webfolder")));
			}
			
			if (useEzPMS.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("pms")));
			}
			
			if (useCommunity.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("community")));
			}
			
			if (useExternalMailServer.equalsIgnoreCase("YES")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("mail")));
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("address")));
			}
			
			if (useSurvey.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("survey")));
			}
			
			if (useSchedule.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("schedule")));
			}
			
			if (useResource.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("resource")));
			}
			
			if (useBoard.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("board")));
			}
			
			if (useToDo.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("task")));
			}
			
			if (useCar.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("car")));
			}
			
			// 20200326 조진호 - 패키지 타입이 메일인 경우 메일,주소록을 제외한 모든 메뉴 제거
			String packageType = commonUtil.getPackageType(info.getTenantId());
			
			if (packageType.equals(CommonUtil.PT_MAIL)) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && !vo.getMenuCode().equals("mail") && !vo.getMenuCode().equals("address")));
				menuList.removeIf(vo -> ("A".equalsIgnoreCase(vo.getMenuType())));
			}
			
			data.put("menuList", menuList);
			/**
			 * 3) 유틸메뉴 - 관리자 권한의 유무 - DB에서 가져오지 말고 그냥 다 출력
			 */
			String roleInfo = "user";
			
			// 전체관리자, 회사관리자, 웹폴더관리자면 관리자 버튼이 나타나도록 추가 -> 관리자 안에서 웹폴더관리자는 웹폴더 관리만 나타나도록 수정
			OrganAuth organAuth = commonUtil.makeOrganAuth(userId, tenantId, deptId, jobId);
			if (organAuth.isAuth(AdminAuth.ADMIN_MASTER) 
					|| organAuth.isAuth(AdminAuth.COMPANY_MANAGER, companyId) 
					|| organAuth.isAuth(AdminAuth.WEB_FOLDER_MANAGER, companyId)) {
				roleInfo = "admin";
				// 권한 없는 사람이 강제로 주소를 치고 들어가는 상황을 대비해 admin 주소는 서버에서 올리는 걸로.
				data.put("utilAdminUrl", "/admin/main.do");
			}
			//2019-09-20 메신저 다운로드 부분 추가
			String useUtilTalk = ezCommonService.getTenantConfig("useUtilTalk", tenantId);
			if (useUtilTalk == null || useUtilTalk.equals("")) {
				useUtilTalk = "NO";
			} else {
				String talkFilePath = ezCommonService.getTenantConfig("talkFilePath", tenantId);				
				data.put("talkFilePath", talkFilePath);
			}
			data.put("useUtilTalk", useUtilTalk);
			//2019-10-04 통합검색 부분 추가
			String useTotalSearch = ezCommonService.getTenantConfig("useTotalSearch", tenantId);
			if (useTotalSearch == null || useTotalSearch.equals("")) {
				useTotalSearch = "NO";
			}
			data.put("useTotalSearch", useTotalSearch);
			
			
			/**
			 * 4) 팝업 공지
			 */
			List<PersonalGetPopUpListUserVO> popupNotiList = ezPersonalService.getPopUpListUserWithAuth(companyId, tenantId, offset, userId, deptId);
			data.put("popupNotiList", popupNotiList);
			
			data.put("logoUrl", logoUrl);
			data.put("roleInfo", roleInfo);
			
			//한글기안기 activeX 설치할지 확인하는 용도
			String useActiveX = ezCommonService.getTenantConfig("useActiveX", tenantId);
			
			if(useActiveX == null || useActiveX.equals("")) {
				useActiveX = "NO";
			}
			
			data.put("useActiveX", useActiveX);

			/**
			 * 5) 탑메뉴 유저 설정
			 * 디폴트는 TOP. 디폴트 설정을 넣을경우 여기 변경
			 */
			Optional<TopFrameType> topFrameInfo = ezNewPortalService.getPortalTopFrameInfo(userId, companyId, tenantId);
			
			data.put("menuDisplayMode", topFrameInfo.orElse(TopFrameType.TOP).getCode());
			
			/**
			 * 6) 사용자별 선택 색상(모드) 조회
			 */
			data.put("useColor", ezNewPortalService.getUserColor(userId, companyId, tenantId));
			
			//end

			//logger.debug("TopMenu Data : " + data.toJSONString()); // 로그정리 : EzNewPortalController 에서 중복으로 로깅
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getUserMenuList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 개인 메뉴 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/menus/order/users/{userId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserMenuOrder(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jObj) throws Exception {
		logger.debug("ezNewPortal G/W updateUserMenuOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);	
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			int tenantId = info.getTenantId();
			String langType = info.getLang();			
			JSONObject data = new JSONObject();

			ezNewPortalService.updateUserMenuOrder(companyId, info.getTenantId(), userId, jObj);
			
			// 리스트 다시 받아서 출력
			List<MenuInfoVO> menuList = ezNewPortalService.getUserMenuList(companyId, tenantId, langType, userId, deptId);
			// List<MenuInfoVO> compMenuList = new ArrayList<MenuInfoVO>();
//			List<MenuInfoVO> resultMenuList = new ArrayList<MenuInfoVO>();
//			for (MenuInfoVO mVO : userMenuList) {
//				boolean resultAuth = ezNewPortalService.getCheckAuth(mVO.getMenuId(), userId, deptId, companyId, tenantId);
//				logger.debug(mVO.getMenuId() + "번의 resultAuth 결과 : " + resultAuth);
//				if (resultAuth) {
//					resultMenuList.add(mVO);
//				}
//			}
			
			//tenant config가 NO인 경우 사용자 메뉴 순서에서도 나오면 안됨
			//컨피그 : useQuestion(전자설문), useMemo(메모), useLadder(사다리게임), useCabinet(캐비닛), 
			//		 useBallotSystem(투표), USE_JOURNAL(업무일지), USE_CIRCULAR(회람판), USE_ATTITUDE(근태관리)
			//		 useWebfolder(웹폴더),  USE_ezPMS(프로젝트관리), USE_COMMUNITY(커뮤니티),useCar(차량관리)
			String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
			String useSurvey = ezCommonService.getTenantConfig("useSurvey", tenantId);
			String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
			String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
			String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
			String useVote = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
			String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
			String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
			String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
			String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
			String useEzPMS = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
			String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
			String useCar = ezCommonService.getTenantConfig("useCar", tenantId);
			String useSchedule = ezCommonService.getTenantConfig("useSchedule", tenantId);
			String useResource = ezCommonService.getTenantConfig("useResource", tenantId);
			String useBoard = ezCommonService.getTenantConfig("useBoard", tenantId);
			String useToDo = ezCommonService.getTenantConfig("useToDo", tenantId);
			

			if (useAttitude == null || useAttitude.equals("")) {
				useAttitude = "NO";
			}
			
			if (useMemo == null || useMemo.equals("")) {
				useMemo = "YES";
			}
			
			if (useLadder == null || useLadder.equals("")) {
				useLadder = "NO";
			}
			
			if (useCabinet == null || useCabinet.equals("")) {
				useCabinet = "NO";
			}
			
			if (useVote == null || useVote.equals("")) {
				useVote = "YES";
			}
			
			if (useJournal == null || useJournal.equals("")) {
				useJournal = "NO";
			}
			
			if (useCircular == null || useCircular.equals("")) {
				useCircular = "YES";
			}
			
			if (useQuestion == null || useQuestion.equals("")) {
				useQuestion = "NO";
			}
			
			if (useWebfolder == null || useWebfolder.equals("")) {
				useWebfolder = "NO";
			}
			
			if (useCommunity == null || useCommunity.equals("")) {
				useCommunity = "YES";
			}
			
			if (useEzPMS == null || useEzPMS.equals("")) {
				useEzPMS = "NO";
			}
			
			if (useCar == null || useCar.equals("")) {
				useCar = "NO";
			}
			
			if (useQuestion.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("question")));
			}
			
			if (useMemo.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("memo")));
			}
			
			if (useLadder.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("ladder")));
			}
			
			if (useCabinet.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("cabinet")));
			}
			
			if (useVote.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("vote")));
			}
			
			if (useJournal.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("journal")));
			}
			
			if (useCircular.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("circular")));
			}
			
			if (useAttitude.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("attitude")));
			}
			
			if (useWebfolder.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("webfolder")));
			}
			
			if (useEzPMS.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("pms")));
			}
			
			if (useCommunity.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("community")));
			}
			
			if (useCar.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("car")));
			}
			
			if (useSurvey == null || useSurvey.equals("")) {
				useSurvey = "YES";
			}

			if (useSchedule == null || useSchedule.equals("")) {
				useSchedule = "YES";
			}
			
			if (useResource == null || useResource.equals("")) {
				useResource = "YES";
			}

			if (useBoard.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("board")));
			}
			
			if (useToDo.equals("NO")) {
				menuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("task")));
			}
			
			data.put("menuList", menuList);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateUserMenuOrder ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [DELETE] 개인 메뉴 순서 초기화
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/menus/order/users/{userId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteUserMenuOrder(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("ezNewPortal G/W deleteUserMenuOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			int tenantId = info.getTenantId();
			String langType = info.getLang();			
			JSONObject data = new JSONObject();
			
			ezNewPortalService.deleteUserMenuOrder(companyId, info.getTenantId(), userId);
			// 초기화 하면 회사에서 지정한 메뉴 순서로 출력
			List<MenuInfoVO> compMenuList = ezNewPortalService.getUserMenuList(companyId, tenantId, langType, userId, deptId);
			
			//tenant config가 NO인 경우 사용자 메뉴 순서에서도 나오면 안됨
			//컨피그 : useQuestion(전자설문), useMemo(메모), useLadder(사다리게임), useCabinet(캐비닛), 
			//		 useBallotSystem(투표), USE_JOURNAL(업무일지), USE_CIRCULAR(회람판), USE_ATTITUDE(근태관리)
			//		 useWebfolder(웹폴더),  USE_ezPMS(프로젝트관리), USE_COMMUNITY(커뮤니티), useCar(차량관리)
			String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
			String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
			String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
			String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
			String useVote = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
			String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
			String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
			String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
			String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
			String useEzPMS = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
			String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
			String useCar = ezCommonService.getTenantConfig("useCar", tenantId);

			if (useAttitude == null || useAttitude.equals("")) {
				useAttitude = "NO";
			}
			
			if (useMemo == null || useMemo.equals("")) {
				useMemo = "YES";
			}
			
			if (useLadder == null || useLadder.equals("")) {
				useLadder = "NO";
			}
			
			if (useCabinet == null || useCabinet.equals("")) {
				useCabinet = "NO";
			}
			
			if (useVote == null || useVote.equals("")) {
				useVote = "YES";
			}
			
			if (useJournal == null || useJournal.equals("")) {
				useJournal = "NO";
			}
			
			if (useCircular == null || useCircular.equals("")) {
				useCircular = "YES";
			}
			
			if (useQuestion == null || useQuestion.equals("")) {
				useQuestion = "NO";
			}
			
			if (useWebfolder == null || useWebfolder.equals("")) {
				useWebfolder = "NO";
			}
			
			if (useCommunity == null || useCommunity.equals("")) {
				useCommunity = "YES";
			}
			
			if (useEzPMS == null || useEzPMS.equals("")) {
				useEzPMS = "NO";
			}
			
			if (useCar == null || useCar.equals("")) {
				useCar = "NO";
			}
			
			if (useQuestion.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("question")));
			}
			
			if (useMemo.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("memo")));
			}
			
			if (useLadder.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("ladder")));
			}
			
			if (useCabinet.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("cabinet")));
			}
			
			if (useVote.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("vote")));
			}
			
			if (useJournal.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("journal")));
			}
			
			if (useCircular.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("circular")));
			}
			
			if (useAttitude.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("attitude")));
			}
			
			if (useWebfolder.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("webfolder")));
			}
			
			if (useEzPMS.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("pms")));
			}
			
			if (useCommunity.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("community")));
			}
			
			if (useCar.equals("NO")) {
				compMenuList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("car")));
			}
			
			data.put("menuList", compMenuList);
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W deleteUserMenuOrder ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 퀵링크 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/quickLink/company/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getQuickLinkList(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getQuickLinkList started.");
		JSONObject result = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			//int page = Integer.parseInt(request.getParameter("page"));
			String pPage = request.getParameter("page");
			int page = pPage.isEmpty() ? 0 : Integer.parseInt(pPage);
			int limit = 6; // 한 페이지에 뿌려지는 리스트 개수 // 다르게 처리할 수 있는 방법 찾아보기
			int tenantId = info.getTenantId();
			JSONObject data = new JSONObject();
			String userId = request.getParameter("userId");
			String deptId = request.getParameter("deptId");

			// 2024-05-17 김유진 - 퀵링크 list, cnt 가져오기
			Map<String, Object> map = ezNewPortalService.getQuickLinkList(companyId, tenantId, page, limit, userId, deptId);
			data.put("quickLinkList", map.get("quickLinkList"));
			data.put("totalPageCnt", map.get("totalPageCnt"));
			
//			int totalPageCnt = ezNewPortalService.getQuickLinkTotalPageCnt(companyId, tenantId, limit, userId, deptId);
//			data.put("totalPageCnt", totalPageCnt);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getQuickLinkList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 테마 프레임 리스트 및 사용자 지정 프레임 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/frames/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserFrameList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("ezNewPortal G/W getUserFrameList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			int tenantId = info.getTenantId();
			JSONObject data = new JSONObject();
			List<?> frameList = ezNewPortalService.getUserFrameListAndSelectedFrame(companyId, tenantId, userId);

			data.put("frameList", frameList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getUserFrameList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 사용자 프레임 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/frames/users/{userId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserFrame(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jObj) throws Exception {
		logger.debug("ezNewPortal G/W updateUserFrame started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");

			ezNewPortalService.updateUserUsedFrame(userId, tenantId, companyId, jObj);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateUserFrame ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 개인별 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPortletList(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("ezNewPortal G/W getPortletList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String portletLang = info.getLang();

			JSONObject data = new JSONObject();
			
			int themeId = ezNewPortalService.getThemeId(userId, companyId, tenantId);
			
			List<PortletInfoVO> portletList = ezNewPortalService.getUserPortletList(themeId, portletLang, userId, tenantId, companyId, deptId, true);
			
			//tenant config가 NO인 경우 포틀릿 리스트에서도 나오면 안됨
			//컨피그 : useQuestion(전자설문), useMemo(메모), useLadder(사다리게임), useCabinet(캐비닛), 
			//		 useBallotSystem(투표), USE_JOURNAL(업무일지), USE_CIRCULAR(회람판), USE_ATTITUDE(근태관리)
			//		 useWebfolder(웹폴더),  USE_ezPMS(프로젝트관리), USE_COMMUNITY(커뮤니티), useCar(차량관리)
			String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
			String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
			String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
			String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
			String useVote = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
			String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
			String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
			String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
			String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
			String useEzPMS = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
			String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
			String useCar = ezCommonService.getTenantConfig("useCar", tenantId);
			
			if (useAttitude == null || useAttitude.equals("")) {
				useAttitude = "NO";
			}
			
			if (useMemo == null || useMemo.equals("")) {
				useMemo = "YES";
			}
			
			if (useLadder == null || useLadder.equals("")) {
				useLadder = "NO";
			}
			
			if (useCabinet == null || useCabinet.equals("")) {
				useCabinet = "NO";
			}
			
			if (useVote == null || useVote.equals("")) {
				useVote = "YES";
			}
			
			if (useJournal == null || useJournal.equals("")) {
				useJournal = "NO";
			}
			
			if (useCircular == null || useCircular.equals("")) {
				useCircular = "YES";
			}
			
			if (useQuestion == null || useQuestion.equals("")) {
				useQuestion = "NO";
			}
			
			if (useWebfolder == null || useWebfolder.equals("")) {
				useWebfolder = "NO";
			}
			
			if (useCommunity == null || useCommunity.equals("")) {
				useCommunity = "YES";
			}
			
			if (useEzPMS == null || useEzPMS.equals("")) {
				useEzPMS = "NO";
			}
			
			if (useCar == null || useCar.equals("")) {
				useCar = "NO";
			}
			
			if (useQuestion.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("question")));
			}
			
			if (useMemo.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("memo")));
			}
			
			if (useLadder.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("ladder")));
			}
			
			if (useCabinet.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("cabinet")));
			}
			
			if (useVote.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("vote")));
			}
			
			if (useJournal.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("journal")));
			}
			
			if (useCircular.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("circular")));
			}
			
			if (useAttitude.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("attitude")));
			}
			
			if (useWebfolder.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("webfolder")));
			}
			
			if (useEzPMS.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("pms")));
			}
			
			if (useCommunity.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("community")));
			}
			
			if (useCar.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("car")));
			}

			//인터넷 사용이 NO 인 경우에는 weather portlet사용 불가능
			String useInternet = config.getProperty("config.useInternet");
			
			if (useInternet.equals("NO")) {
				portletList.removeIf(vo -> (vo.getPortletCode() != null && vo.getPortletCode().equals("weather")));
			}
			
			if (!"1".equals(portletLang) && !"2".equals(portletLang)) {
				List<PortletInfoVO> helpPortlet = portletList.stream()
				.filter(vo -> vo.getPortletId() == 12)
				.collect(Collectors.toList());
				portletList.removeAll(helpPortlet);
			}
			
			data.put("portletList", portletList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getPortletList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 포틀릿 개인별 사용/미사용 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/users/{userId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserPortletSetting(HttpServletRequest request, @PathVariable String userId, @RequestBody JSONObject jObj) throws Exception {
		logger.debug("ezNewPortal G/W updateUserPortletSetting started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");

			ezNewPortalService.updateUserUsedPortlet(userId, tenantId, companyId, jObj);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateUserPortletSetting ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 사용자별 테마 적용
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/themes/{themeId}/users/{userId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserThemeSetting(HttpServletRequest request, @PathVariable String userId, @PathVariable int themeId) throws Exception {
		logger.debug("ezNewPortal G/W updateUserThemeSetting started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			int tenantId = info.getTenantId();
			int frameDefault = 0;
			
			if (themeId == 1) {
				frameDefault = 1;
			} else if (themeId == 2) {
				frameDefault = 5;
			} else if (themeId == 3) {
				frameDefault = 8;
			}
			
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			logger.debug("usedTheme : " + themeId + "usedFrame : " + frameDefault);
			
			ezNewPortalService.updateUserThemeSetting(themeId, frameDefault, userId, tenantId, companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateUserThemeSetting ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [DELETE] 사용자 테마 설정 초기화
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/themes/users/{userId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteUserThemeSetting(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("ezNewPortal G/W deleteUserThemeSetting started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			int tenantId = info.getTenantId();
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			
			ezNewPortalService.deleteUserThemeSetting(userId, tenantId, companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W deleteUserThemeSetting ended.");
		return result;
	}

	// /////////////////////추가////////////////////////
	/**
	 * 포탈개인화 G/W [GET] 사용자별 읽지 않은 메일, 결재할 문서, 전자설문, 오늘일정, 회람판 개수 불러오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/settingInfo/unreadCounts/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUnreadCounts(HttpServletRequest request, @PathVariable String userId, Locale locale) throws Exception {
		logger.debug("ezNewPortal G/W getUnreadCounts started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			if (companyId == null || "".equalsIgnoreCase(companyId)){
				companyId = info.getCompanyId();
			}
			String deptId = request.getParameter("deptId");
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();
			String offset = info.getOffSet();
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat adf = new SimpleDateFormat("yyyy-MM-dd");
			String nowDate = adf.format(cal.getTime());
			String offsetMin = commonUtil.getMinuteUTC(info.getOffSet());
			// String userEmail = userId + "@" + ezCommonService.getTenantConfig("DomainName", tenantId);
			// String password = jspw;
			//String useQuestion = request.getParameter("useQuestion");
			String useSurvey = request.getParameter("useSurvey");
			String useCircular = request.getParameter("useCircular");
			String useMail = request.getParameter("useMail");
			String useApproval = request.getParameter("useApproval");
			String useSchedule = request.getParameter("useSchedule");
			//2020-02-24 김정언
			String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", tenantId);
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			
			JSONObject data = new JSONObject();

			logger.debug("useSurvey : " + useSurvey + ", useCircular : " + useCircular + ", useMail : " + useMail + ", useApproval : " + useApproval + ", useSchedule : " + useSchedule);
			
			if ("YES".equals(useSurvey)) {
				int surveyCnt = ezSurveyService.getSurveyIngCnt(info);
				data.put("surveyCnt", surveyCnt);
			}

			// 오늘 일정 개수 불러오기
			if ("YES".equals(useSchedule)) {
				String startDate = nowDate + " 00:00:00";
				String endDate = nowDate + " 23:59:59";
				String startTime = commonUtil.getDateStringInUTC(nowDate + " 00:00:00", offset, true);
				String endTime = commonUtil.getDateStringInUTC(nowDate + " 23:59:59", offset, true);
				String indiList = "";
				String pidList = "";
				String pidListSub = "";
				String indiListSub = "";

				List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(userId, portletLang, tenantId, companyId);
				List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(userId, portletLang, tenantId, companyId);
				List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(userId, portletLang, tenantId, companyId);
				List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, tenantId, companyId);

				indiList = "'" + userId + "'";

				if (tList != null && tList.size() > 0) {
					for (int i = 0; i < tList.size(); i++) {
						if (i == 0) {
							indiListSub += ",";
						}
						ScheduleSecretaryVO schedule = tList.get(i);
						indiListSub += "\'" + schedule.getSecId() + "\',";
					}
				}

				pidList = "'" + deptId + "'," + "'" + companyId + "'";

				if (dList != null && dList.size() > 0) {
					for (int i = 0; i < dList.size(); i++) {
						if (tList == null || tList.size() <= 0) {
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleDeptVO schedule = dList.get(i);
						pidListSub += "\'" + schedule.getDeptId() + "\',";
					}
				}

				if (cList != null && cList.size() > 0) {
					for (int i = 0; i < cList.size(); i++) {
						if (dList == null || dList.size() <= 0) {
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleCumulerVO schedule = cList.get(i);
						pidListSub += "\'" + schedule.getDeptId() + "\',";
					}
				}

				if (gList != null && gList.size() > 0) {
					for (int i = 0; i < gList.size(); i++) {
						if ((dList == null || dList.size() <= 0) && (cList == null || cList.size() <= 0)) {
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleGroupListVO schedule = gList.get(i);
						pidListSub += "\'" + schedule.getGroupId() + "\',";
					}
				}

				if (indiListSub == null || indiListSub.equals("")) {
					indiListSub = ",\'\'";
				} else {
					indiListSub = indiListSub.substring(0, indiListSub.length() - 1);
				}

				indiList += indiListSub;

				if (pidListSub == null || pidListSub.equals("")) {
					pidListSub = ",\'\'";
				} else {
					pidListSub = pidListSub.substring(0, pidListSub.length() - 1);
				}

				pidList += pidListSub;
				List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, "", startTime, endTime, startDate, endDate, offsetMin, "", "", "", tenantId, companyId, userId, deptId, useAnnualScheduleYN);
				
				// 구글연동 일정 가져오기(포탈 카운트)
				LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
				String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", userInfo.getTenantId());
				if(useGoogleCalendar.equals("YES")) {
					List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, "", userInfo, userInfo.getId(), "member", userInfo.getDisplayName());		
					sList.addAll(googleList);
				}
				
				int scheduleCount = sList.size();
				data.put("scheduleCount", scheduleCount);
			}

			// 회람판 개수 불러오기
			if ("YES".equals(useCircular)) {
				int circularCount = ezCircularSerivce.getListCount("newCircular", userId, tenantId, companyId);
				data.put("circularCount", circularCount);
			}

			// 결재할 문서 개수 불러오기
			if ("YES".equals(useApproval)) {
				String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantId);
				String lang = portletLang;
				int approvalCount = ezNewPortalService.getApprovalDoingListCount(userId, companyId, tenantId, info.getOffSet(), approvalFlag, lang);
				data.put("approvalCount", approvalCount);
			}

			// 읽지 않은 메일 가져오기
			if ("YES".equals(useMail)) {
				int unreadMailCount = 0;

				String userEmail = userId + "@" + ezCommonService.getTenantConfig("DomainName", tenantId);
				String password = jspw;
				String url = "/rest/ezPortal/portlets/unreadMailCount";

				HashMap<String, Object> param = new HashMap<String, Object>();
				param.put("userEmail", userEmail);
				param.put("password", password);
				param.put("locale", locale);

				JSONObject resultBody = commonUtil.getJsonFromRestApi(url, param, request, "get", null);
				String useMailServer2 =  config.getProperty("config.useMailServer2");
				if ("Y".equalsIgnoreCase(useMailServer2)){
					resultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.MailServerURL2"), url, param, request, "get", null);
				}

				String result2 = resultBody.get("status").toString();
				if (result2.equals("ok")) {
					String mailCount = String.valueOf(resultBody.get("unreadMailCount"));
					unreadMailCount = Integer.parseInt(mailCount);
					logger.debug("unreadMailCount = " + unreadMailCount);
				}

				data.put("unreadMailCount", unreadMailCount);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getUserPortalSetting ended.");
		return result;
	}
	
	//사용자 초기화면 정보 조회 + 메모 모듈 사용여부
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/startpage/users/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getUserStartPage(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("ezNewPortal G/W getUserStartPage started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			int tenantId = info.getTenantId();
			JSONObject data = new JSONObject();

			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			
			MenuInfoVO startPage = ezNewPortalService.getUserStartPage(userId, tenantId, companyId);
			//logger.debug("startMenuId : " + startPage.getMenuId());

			boolean memoAuth = ezNewPortalService.getCheckAuth(18, userId, deptId, companyId, tenantId);
			String useMemo = "";
			useMemo = ezCommonService.getTenantConfig("useMemo", info.getTenantId());
			
			if (useMemo == null || useMemo.equals("")) {
				useMemo = "YES";
			}
			
			if (useMemo.equals("YES")) {
				if (memoAuth) {
					useMemo = "YES";
				} else {
					useMemo = "NO";
				}
			}
			
			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId);
			if (useExternalMailServer == null || useExternalMailServer.equals("")) {
				useExternalMailServer = "NO";
			}
			
			String useContextmenu = ezCommonService.getTenantConfig("USE_CONTEXTMENU", tenantId);
			if (useContextmenu == null || useContextmenu.equals("")) {
				useContextmenu = "YES";
			}
			
			logger.debug("useMemo : " + useMemo + ", useExternalMailServer : " + useExternalMailServer);
			
			String useWebHWP = ezCommonService.getTenantConfig("useWebHWP", tenantId);
			if (useWebHWP == null || useWebHWP.equals("")) {
				useWebHWP = "NO";
			}
			
			data.put("useMemo", useMemo);
			data.put("startPage", startPage);
			data.put("useExternalMailServer", useExternalMailServer);
			data.put("useContextmenu", useContextmenu);
			data.put("useWebHWP", useWebHWP);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getUserStartPage ended.");
		return result;
	}
	
	//사용자 초기화면 설정 실행
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/startpage/menus/{menuId}/users/{userId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateUserStartPage (HttpServletRequest request, @PathVariable String userId, @PathVariable int menuId) {
		logger.debug("ezNewPortal G/W getUserStartPage started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			String companyId = request.getParameter("companyId");
			int tenantId = info.getTenantId();
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			logger.debug("menuId : " + menuId);
			
			ezNewPortalService.updateUserStartPage(menuId, userId, tenantId, companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getUserStartPage ended.");
		return result;
	}
	// ///관리자///////
	/**
	 * 포탈개인화 G/W [GET] 회사 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezportal/companies", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyList(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getCompanyList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String deptId = request.getParameter("deptId");
			String jobId = Optional.ofNullable(request.getParameter("jobId")).orElse("");

			String primary = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
			int tenantId = userInfo.getTenantId();
			String usePrimaryLangOnly = config.getProperty("config.UsePrimaryLangOnly");
			String lang = commonUtil.getMultiData(userInfo.getLang(), tenantId);

			if (StringUtils.isBlank(lang)) {
				lang = "1";
			}
			
			result.put("userCompany", userInfo.getCompanyID());
			result.put("lang",lang);

			List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userId, userInfo.getTenantId(), userInfo.getLang(), deptId, jobId);
			
			result.put("data", adminCompanyList);
			result.put("primary", primary);
			result.put("usePrimaryLangOnly", usePrimaryLangOnly);
			result.put("status", "ok");
			result.put("code", 0);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCompanyList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 테마 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezportal/themes/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyThemes(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getCompanyThemes} started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String lang = userInfo.getLang();
			
			List<ThemeInfoVO> themeList = ezNewPortalService.getThemes(true, companyId, userInfo.getTenantId(), userId, null, lang);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", themeList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCompanyThemes ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 테마 상세정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyThemeInfo(HttpServletRequest request, @PathVariable int themeId, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getCompanyThemeInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			String lang = userInfo.getLang();
			
			if (lang == null || lang.equals("")) {
				lang = "1";
			}
			
			ThemeInfoVO themeInfo = ezNewPortalService.getThemeInfo(themeId, companyId, tenantId, lang);
			List<FrameInfoVO> frameInfos = ezNewPortalService.getFrames(themeId, companyId, tenantId);
			
			JSONObject data = new JSONObject();
			
			data.put("themeInfo", themeInfo);
			data.put("frameInfos", frameInfos);
			
			result.put("data", data);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCompanyThemeInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 회사별 테마 상세정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyThemeInfo(HttpServletRequest request, @PathVariable int themeId, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updateCompanyThemeInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			JSONObject themeInfo = (JSONObject) jsonParam.get("themeInfo");
			JSONArray frameInfos = (JSONArray) jsonParam.get("frameInfos");
			logger.debug("frameInfos = " + frameInfos.toString());

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			
			ezNewPortalService.updateThemeInfo(themeInfo, frameInfos, companyId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateCompanyThemeInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 기본 테마 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/default/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyDefaultTheme(HttpServletRequest request, @PathVariable int themeId, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W updateCompanyDefaultTheme started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			
			ezNewPortalService.updateCompanyDefaultTheme(themeId, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateCompanyDefaultTheme ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 메뉴 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyMenus(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getCompanyMenus started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String type = request.getParameter("type");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			String menuLang = userInfo.getLang();
			List<MenuInfoVO> menuInfos = ezNewPortalService.getMenus(companyId, userInfo.getTenantId(), menuLang, type);
			
			//tenant config가 NO인 경우 관리자 메뉴 관리에서도 나오면 안됨
			//컨피그 : useQuestion(전자설문), useMemo(메모), useLadder(사다리게임), useCabinet(캐비닛), 
			//		 useBallotSystem(투표), USE_JOURNAL(업무일지), USE_CIRCULAR(회람판), USE_ATTITUDE(근태관리)
			//		 useWebfolder(웹폴더),  USE_ezPMS(프로젝트관리), USE_COMMUNITY(커뮤니티), useCar(차량관리)
			String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
			String useSurvey = ezCommonService.getTenantConfig("useSurvey", tenantId);
			String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
			String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
			String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
			String useVote = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
			String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
			String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
			String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
			String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
			String useEzPMS = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
			String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId);

			String useSchedule = ezCommonService.getTenantConfig("useSchedule", tenantId);
			String useResource = ezCommonService.getTenantConfig("useResource", tenantId);
			String useBoard = ezCommonService.getTenantConfig("useBoard", tenantId);
			String useToDo = ezCommonService.getTenantConfig("useToDo", tenantId);
			String useCar = ezCommonService.getTenantConfig("useCar", tenantId);
			
			if (useAttitude == null || useAttitude.equals("")) {
				useAttitude = "NO";
			}
			
			if (useMemo == null || useMemo.equals("")) {
				useMemo = "YES";
			}
			
			if (useLadder == null || useLadder.equals("")) {
				useLadder = "NO";
			}
			
			if (useCabinet == null || useCabinet.equals("")) {
				useCabinet = "NO";
			}
			
			if (useVote == null || useVote.equals("")) {
				useVote = "YES";
			}
			
			if (useJournal == null || useJournal.equals("")) {
				useJournal = "NO";
			}
			
			if (useCircular == null || useCircular.equals("")) {
				useCircular = "YES";
			}
			
			if (useQuestion == null || useQuestion.equals("")) {
				useQuestion = "NO";
			}
			
			if (useSurvey == null || useSurvey.equals("")) {
				useSurvey = "YES";
			}
			
			if (useWebfolder == null || useWebfolder.equals("")) {
				useWebfolder = "NO";
			}
			
			if (useCommunity == null || useCommunity.equals("")) {
				useCommunity = "YES";
			}
			
			if (useEzPMS == null || useEzPMS.equals("")) {
				useEzPMS = "NO";
			}
			
			if (useExternalMailServer == null || useExternalMailServer.equals("")) {
				useExternalMailServer = "NO";
			}
			
			if (useSchedule == null || useSchedule.equals("")) {
				useSchedule = "YES";
			}
			
			if (useResource == null || useResource.equals("")) {
				useResource = "YES";
			}
			
			if (useBoard == null || useBoard.equals("")) {
				useBoard = "YES";
			}
			
			if (useToDo == null || useToDo.equals("")) {
				useToDo = "YES";
			}
			if (useCar == null || useCar.equals("")) {
				useCar = "NO";
			}
			
			if (useQuestion.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("question")));
			}
			
			if (useSurvey.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("survey")));
			}
			
			if (useMemo.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("memo")));
			}
			
			if (useLadder.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("ladder")));
			}
			
			if (useCabinet.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("cabinet")));
			}
			
			if (useVote.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("vote")));
			}
			
			if (useJournal.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("journal")));
			}
			
			if (useCircular.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("circular")));
			}
			
			if (useAttitude.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("attitude")));
			}
			
			if (useWebfolder.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("webfolder")));
			}
			
			if (useEzPMS.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("pms")));
			}
			
			if (useCommunity.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("community")));
			}
			
			if (useExternalMailServer.equalsIgnoreCase("YES")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("mail")));
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("address")));
			}
			
			if (useSchedule.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("schedule")));
			}
			
			if (useResource.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("resource")));
			}
			
			if (useBoard.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("board")));
			}
			
			if (useToDo.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("task")));
			}
			
			if (useCar.equals("NO")) {
				menuInfos.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("car")));
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", menuInfos);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezNewPortal G/W getCompanyMenus ended.");
		
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 회사별 메뉴 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/order/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyMenuOrder(HttpServletRequest request, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updateCompanyMenuOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
				
			JSONArray menus = (JSONArray) jsonParam.get("menus");
			ezNewPortalService.udpateMenuOrder(menus, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateCompanyMenuOrder ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [GET] 회사별 메뉴 상세정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyMenuInfo(HttpServletRequest request, @PathVariable String companyId, @PathVariable int menuId) throws Exception {
		logger.debug("ezNewPortal G/W getCompanyMenuInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			String usePrimaryLangOnly = config.getProperty("config.UsePrimaryLangOnly");
			String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);
			String menuLang = userInfo.getLang();
			
			// 2023-11-22 조소정 - 관리자 > 포탈 > 메뉴관리 > 일본어, 중국어 사용 여부에 따라 메뉴명 표출/미표출 구현
			String useJapanese = ezCommonService.getTenantConfig("useJapanese", tenantId);
			String useChinese = ezCommonService.getTenantConfig("useChinese", tenantId);
			String useVietnamese = ezCommonService.getTenantConfig("useVietnamese", tenantId);
			String useIndonesian = ezCommonService.getTenantConfig("useIndonesian", tenantId);
			
			MenuInfoVO menuInfo = ezNewPortalService.getMenuInfo(menuId, companyId, tenantId, menuLang);
			List<MenuNameVO> menuNames = ezNewPortalService.getMenuNames(menuId, usePrimaryLangOnly, primaryLang, companyId, tenantId, useJapanese, useChinese, useVietnamese, useIndonesian);
			
			int menuNamesCount = menuNames.size();
			JSONObject data = new JSONObject();
			data.put("menuInfo", menuInfo);
			
			if (menuNamesCount > 2) {
				List<MenuNameVO> menuNamesWithOrder = new ArrayList<MenuNameVO>();
				
				// 사용 언어가 가장 먼저 위치하도록 순서 조정.
				menuNamesWithOrder.add(menuNames.get(Integer.parseInt(primaryLang) - 1));
				
				for (MenuNameVO vo : menuNames) {
					if (!vo.getMenuLang().equals(primaryLang)) {
						menuNamesWithOrder.add(vo);
					}
				}
				
				data.put("menuNames", menuNamesWithOrder);
			} 
			data.put("menuNames", menuNames);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCompanyMenuInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 회사별 메뉴 상세정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyMenuInfo(HttpServletRequest request, @PathVariable String companyId, @PathVariable int menuId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updateCompanyMenuInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			JSONObject menuInfo =(JSONObject) jsonParam.get("menuInfo");
			JSONArray menuNames = (JSONArray) jsonParam.get("menuNames");
			
			ezNewPortalService.updateCompanyMenuInfo(menuId, menuInfo, menuNames, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateCompanyMenuInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 메뉴별 권한 정보 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/authorities/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyMenuAuth(HttpServletRequest request, @PathVariable int menuId, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getCompanyMenuAuth started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String lang = commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
			
			Map<String, Object> resultMap = ezNewPortalService.getMenuAuth(menuId, companyId, userInfo.getTenantId(), lang);
			
			JSONObject data = new JSONObject();
			
			data.put("menuAuthsY", resultMap.get("menuAuthsY"));
			data.put("menuAuthsN", resultMap.get("menuAuthsN"));
			
			result.put("data", data);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCompanyMenuAuth ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 메뉴별 권한 정보 수정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/authorities/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyMenuAuth(HttpServletRequest request, @PathVariable int menuId, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updateCompanyMenuAuth started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			JSONArray menuAuths = (JSONArray) jsonParam.get("menuAuths");
			
			ezNewPortalService.updateMenuAuth(menuAuths, menuId, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateCompanyMenuAuth ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [POST] 메뉴 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/companies/{companyId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertCompanyMenu(HttpServletRequest request, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W insertCompanyMenu started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			JSONObject menuInfo =(JSONObject) jsonParam.get("menuInfo");
			JSONArray menuNames = (JSONArray) jsonParam.get("menuNames");
			JSONArray menuAuths = (JSONArray) jsonParam.get("menuAuths");
			
			ezNewPortalService.insertMenu(menuInfo, menuNames, menuAuths, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W insertCompanyMenu ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [DELETE] 메뉴 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/{menuId}/companies/{companyId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteCompanyMenu(HttpServletRequest request, @PathVariable int menuId, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W deleteCompanyMenu started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			ezNewPortalService.deleteMenu(menuId, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W deleteCompanyMenu ended.");
		return result;
	}
	
	/** 구해안 start
	 * 포탈개인화 G/W [GET] 회사별 포틀릿 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyPortletList(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getCompanyPortletList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String lang = info.getLang();
			
			JSONObject data = new JSONObject();
			String webType = request.getParameter("type");

			List<PortletInfoVO> portletList = ezNewPortalService.getPortletList(companyId, tenantId, Integer.parseInt(lang), webType);
			
			//1. tenant config가 NO인 경우 관리자 포틀릿 관리에서도 나오면 안됨
			//컨피그 : useQuestion(전자설문), useMemo(메모), useLadder(사다리게임), useCabinet(캐비닛), 
			//		 useBallotSystem(투표), USE_JOURNAL(업무일지), USE_CIRCULAR(회람판), USE_ATTITUDE(근태관리)
			//		 useWebfolder(웹폴더),  USE_ezPMS(프로젝트관리), USE_COMMUNITY(커뮤니티), useCar(차량관리)
			String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
			String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
			String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
			String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
			String useVote = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
			String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
			String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
			String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
			String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
			String useEzPMS = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
			String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId);
			
			String useSchedule = ezCommonService.getTenantConfig("useSchedule", tenantId);
			String useResource = ezCommonService.getTenantConfig("useResource", tenantId);
			String useBoard = ezCommonService.getTenantConfig("useBoard", tenantId);
			String useSurvey = ezCommonService.getTenantConfig("useSurvey", tenantId);
			String useCar = ezCommonService.getTenantConfig("useCar", tenantId);
			
			String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", tenantId);

			if (useAttitude == null || useAttitude.equals("")) {
				useAttitude = "NO";
			}
			
			if (useMemo == null || useMemo.equals("")) {
				useMemo = "YES";
			}
			
			if (useLadder == null || useLadder.equals("")) {
				useLadder = "NO";
			}
			
			if (useCabinet == null || useCabinet.equals("")) {
				useCabinet = "NO";
			}
			
			if (useVote == null || useVote.equals("")) {
				useVote = "YES";
			}
			
			if (useJournal == null || useJournal.equals("")) {
				useJournal = "NO";
			}
			
			if (useCircular == null || useCircular.equals("")) {
				useCircular = "YES";
			}
			
			if (useQuestion == null || useQuestion.equals("")) {
				useQuestion = "NO";
			}
			
			if (useWebfolder == null || useWebfolder.equals("")) {
				useWebfolder = "NO";
			}
			
			if (useCommunity == null || useCommunity.equals("")) {
				useCommunity = "YES";
			}
			
			if (useEzPMS == null || useEzPMS.equals("")) {
				useEzPMS = "NO";
			}
			
			if (useExternalMailServer == null || useExternalMailServer.equals("")) {
				useExternalMailServer = "NO";
			}
			
			if (useSchedule == null || useSchedule.equals("")) {
				useSchedule = "YES";
			}
			
			if (useResource == null || useResource.equals("")) {
				useResource = "YES";
			}
			
			if (useBoard == null || useBoard.equals("")) {
				useBoard = "YES";
			}
			
			if (useSurvey == null || useSurvey.equals("")) {
				useSurvey = "YES";
			}

			if (useCar == null || useCar.equals("")) {
				useCar = "NO";
			}
			
			if (useQuestion.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("question")));
			}
			
			if (useMemo.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("memo")));
			}
			
			if (useLadder.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("ladder")));
			}
			
			if (useCabinet.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("cabinet")));
			}
			
			if (useVote.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("vote")));
			}
			
			if (useJournal.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("journal")));
			}
			
			if (useCircular.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("circular")));
			}
			
			if (useAttitude.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("attitude")));
			}
			
			if (useWebfolder.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("webfolder")));
			}
			
			if (useEzPMS.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("pms")));
			}
			
			if (useCommunity.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("community")));
			}
			
			if (useExternalMailServer.equalsIgnoreCase("YES")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("mail")));
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("address")));
			}
			
			if (useSchedule.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("schedule")));
			}
			
			if (useResource.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("resource")));
			}
			
			if (useBoard.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("board")));
			}
			
			if (useSurvey.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("survey")));
			}
			
			if (useCar.equals("NO")) {
				portletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("car")));
			}
			

			//인터넷 사용이 NO 인 경우에는 weather portlet사용 불가능
			String useInternet = config.getProperty("config.useInternet");
			
			if (useInternet.equals("NO")) {
				portletList.removeIf(vo -> (vo.getPortletCode() != null && vo.getPortletCode().equals("weather")));
			}
			
			for (PortletInfoVO pvo : portletList) {
				List<PortletNameInfoVO> portletNameList = ezNewPortalService.getPortletNameList(companyId, tenantId, pvo.getPortletId());
				
				int menuNamesCount = portletNameList.size();
				if (menuNamesCount > 2) {
					List<PortletNameInfoVO> portletNamesWithOrder = new ArrayList<PortletNameInfoVO>();
					
					// 사용 언어가 가장 먼저 위치하도록 순서 조정.
					portletNamesWithOrder.add(portletNameList.get(Integer.parseInt(primaryLang) - 1));
					
					for (PortletNameInfoVO vo : portletNameList) {
						if (!vo.getPortletLang().equals(primaryLang)) {
							portletNamesWithOrder.add(vo);
						}
					}
					
					pvo.setPortletNameList(portletNamesWithOrder);
				} 
				else {
					pvo.setPortletNameList(portletNameList);
				}
			}
						
			data.put("PortletList", portletList);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCompanyPortletList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 회사별 포틀릿 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/order/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyPortletOrder(HttpServletRequest request, @RequestBody JSONObject jsonParam, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W updateCompanyPortletOrder started.");
		JSONObject result = new JSONObject();

		try {
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, jsonParam.get("userId").toString());
			int tenantId = info.getTenantId();
			
			JSONArray portletList = (JSONArray) jsonParam.get("portlets");
			
			ezNewPortalService.updateCompanyPortletOrder(portletList, tenantId, companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateCompanyPortletOrder ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 회사별 포틀릿 상세조회 ------ 사용 안함
	 */
	/*@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPortletInfo(HttpServletRequest request, @PathVariable int portletId, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getCompanyPortletInfo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCompanyPortletInfo ended.");
		return result;
	}*/

	/**
	 * 포탈개인화 G/W [POST] 포틀릿 추가
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/companies/{companyId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertPortlet(HttpServletRequest request, @RequestBody JSONObject jsonParam, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W insertCompanyPortlet started.");
		JSONObject result = new JSONObject();
		
		try {
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			String userId = jsonParam.get("userId").toString();
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			String webType = "";
			if (jsonParam.get("type").toString() != null) {
				webType = jsonParam.get("type").toString();
			}
			
			JSONObject portletInfo = new JSONObject();
			portletInfo.put("boardId", jsonParam.get("boardId"));
			portletInfo.put("portletUsed", jsonParam.get("portletUsed"));
			portletInfo.put("connectionUrl", jsonParam.get("connectionUrl"));
			portletInfo.put("menuId", jsonParam.get("menuId"));
			portletInfo.put("type", webType);
			portletInfo.put("portletCode", jsonParam.get("portletCode"));
			portletInfo.put("connectionId", jsonParam.get("connectionId"));
			
			JSONArray portletNames = (JSONArray) jsonParam.get("nameList");
			
			ezNewPortalService.insertPortlet(portletInfo, portletNames, companyId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W insertCompanyPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [DELETE] 포틀릿 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deletePortlet(HttpServletRequest request, @PathVariable int portletId, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W deleteCompanyPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			int menuId = Integer.parseInt(request.getParameter("menuId"));
			
			ezNewPortalService.deletePortlet(portletId, menuId, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W deleteCompanyPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [PATCH] 포틀릿 상세정보 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/{portletId}/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updatePortletInfo(HttpServletRequest request, @RequestBody JSONObject jsonParam, @PathVariable int portletId, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W updatePortletInfo started.");
		JSONObject result = new JSONObject();
		JSONParser jp = new JSONParser();
		jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
		
		String userId = jsonParam.get("userId").toString();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			int tenantId = info.getTenantId();
			//String portletLang = info.getLang();
			JSONObject portletInfo = new JSONObject();
			portletInfo.put("portletId", jsonParam.get("portletId"));
			portletInfo.put("boardId", jsonParam.get("boardId"));
			portletInfo.put("portletUsed", jsonParam.get("portletUsed"));
			portletInfo.put("connectionUrl", jsonParam.get("connectionUrl"));
			portletInfo.put("menuId", jsonParam.get("menuId"));
			portletInfo.put("portletCode", jsonParam.get("portletCode"));
			portletInfo.put("connectionId", jsonParam.get("connectionId"));
			
			JSONArray portletNames = (JSONArray) jsonParam.get("nameList");
			ezNewPortalService.updateCompanyPortletInfo(portletInfo, portletNames, companyId, tenantId);

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updatePortletInfo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 게시판 트리 호출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/boards/tree/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getBoardTree(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getBoardTree started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String parentBoardId = request.getParameter("parentBoardId");
			String lang = commonUtil.getLangData(info.getLang());
			String portletBoardId = request.getParameter("portletBoardId");
			String portletBoardGroupID = "";
			
			List<PortalBoardTreeVO> boardTree = ezNewPortalService.getBoardTree(parentBoardId, companyId, tenantId);
			
			//html clean value
			int boardTreeCount = boardTree.size();
			for (int i = 0; i < boardTreeCount; i++) {
				PortalBoardTreeVO boardInfo= boardTree.get(i);
				
				String boardName;

				if (lang.equals("")) {
				    boardName = boardInfo.getBoardName1();
				} else if (lang.equals("3")) {
				    boardName = boardInfo.getBoardName3();
				} else {
				    boardName = boardInfo.getBoardName2();
				}

				boardInfo.setText(boardName.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("</", "&lt;/"));

				if (!boardInfo.getParent().equals("top")) {
					if (boardInfo.getTopParent().equals("top")) {
						boardInfo.setParent("#");
					}
				}
				
				boardTree.set(i, boardInfo);
			}
			
			if (portletBoardId != null && !"".equals(portletBoardId)) {
				List<BoardVO> portletBoardGroupIDList = ezBoardService.getLeft_BoardSTD(portletBoardId, tenantId);
				portletBoardGroupID = portletBoardGroupIDList == null || portletBoardGroupIDList.isEmpty() ? "" : portletBoardGroupIDList.get(0).getBoardGroupId();
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", boardTree);
			result.put("portletBoardGroupID", portletBoardGroupID);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			result.put("portletBoardGroupID", "");
		}
		logger.debug("ezNewPortal G/W getBoardTree ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 로고 불러오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/logos/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCompanyLogo(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getCompanyLogo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO userInfo = new LoginVO();
			int tenantId = 0;
			
			if (userId == null) {
				tenantId = ezNewPortalService.getTnenantIdByServerName(serverName);
			} else {
				userInfo = commonUtil.getUserForGw(userId, serverName);
				tenantId = userInfo.getTenantId();
				result.put("userCompany", userInfo.getCompanyID());
				result.put("lang", userInfo.getLang());
			}
			
			

			String loginLogoUrl = "";
			String portalLogoUrl = "";
			String darkLogoUrl = "";
			boolean loginLogoUrlDefault = true;
			boolean portalLogoUrlDefault = true;
			boolean darkLogoUrlDefault = true;
			
			//로그인 가져오기
			if (companyId != null) {
				loginLogoUrl = ezNewPortalService.getPortalLogoInfo(null, tenantId, "L");
				portalLogoUrl = ezNewPortalService.getPortalLogoInfo(companyId, tenantId, "P");
				darkLogoUrl = ezNewPortalService.getPortalLogoInfo(companyId, tenantId, "D");
			}
			
			if (loginLogoUrl == null || loginLogoUrl.equals("")) {
				loginLogoUrl = "/images/kr/login/logo.svg";
				loginLogoUrlDefault = true;
			} else {
				loginLogoUrl = commonUtil.getUploadPath("upload_newPortal.ROOT", tenantId) + commonUtil.separator + "uploadFile" + commonUtil.separator + loginLogoUrl;
				loginLogoUrlDefault = false;
			}
			
			if (portalLogoUrl == null || portalLogoUrl.equals("")) {
				portalLogoUrl = "/files/upload_portal/Top/Logo/logo.png";
				portalLogoUrlDefault = true;
			} else {
				portalLogoUrl = commonUtil.getUploadPath("upload_newPortal.ROOT", tenantId) + commonUtil.separator + "uploadFile" + commonUtil.separator + portalLogoUrl;
				portalLogoUrlDefault = false;
			}
			
			if (darkLogoUrl == null || darkLogoUrl.equals("")) {
				darkLogoUrl = "/images/ezNewPortal/skin/dark/logo_white.png";
				darkLogoUrlDefault = true;
			} else {
				darkLogoUrl = commonUtil.getUploadPath("upload_newPortal.ROOT", tenantId) + commonUtil.separator + "uploadFile" + commonUtil.separator + darkLogoUrl;
				darkLogoUrlDefault = false;
			}
			
			List<PortalLogoVO> logoList = new ArrayList<PortalLogoVO>();
			
			PortalLogoVO loginLogo = new PortalLogoVO();
			loginLogo.setLogoType("L");
			loginLogo.setLogoUrl(loginLogoUrl);
			loginLogo.setLogoDefault(loginLogoUrlDefault);
			
			logoList.add(loginLogo);
			
			PortalLogoVO portalLogo = new PortalLogoVO();
			portalLogo.setLogoType("P");
			portalLogo.setLogoUrl(portalLogoUrl);
			portalLogo.setLogoDefault(portalLogoUrlDefault);
			
			logoList.add(portalLogo);

			PortalLogoVO darkLogo = new PortalLogoVO();
			darkLogo.setLogoType("D");
			darkLogo.setLogoUrl(darkLogoUrl);
			darkLogo.setLogoDefault(darkLogoUrlDefault);

			logoList.add(darkLogo);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", logoList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCompanyLogo ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [POST] 로고 등록하기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/logos/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateCompanyLogo(HttpServletRequest request, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updateCompanyLogo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, jsonParam.get("userId").toString());
			int tenantId = info.getTenantId();
			String logoType = jsonParam.get("logoType").toString();
			String logoUrl = jsonParam.get("logoUrl").toString();
			
			ezNewPortalService.updateCompanyLogo(companyId, tenantId, logoType, logoUrl);
			
			String addedLogoUrl = ezNewPortalService.getPortalLogoInfo(companyId, tenantId, logoType);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", addedLogoUrl);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateCompanyLogo ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [DELETE] 로고 삭제하기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/logos/{logoType}/companies/{companyId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteLogo(HttpServletRequest request, @PathVariable String logoType, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W deleteLogo started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId").toString());
			int tenantId = info.getTenantId();
			
			ezNewPortalService.deleteCompanyLogo(companyId, tenantId, logoType);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W deleteLogo ended.");
		return result;
	}
	
	// ///포틀릿///////구해안
	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 게시판 즐겨찾기 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/boardFavorites", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFavoriteBoardPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getFavoriteBoardPortlet started.");
		JSONObject result = new JSONObject();

		String boardId = request.getParameter("boardId");
		int listCnt = Integer.parseInt(request.getParameter("listCnt"));
		int currentPage = Integer.parseInt(request.getParameter("currentPage"));
		
		JSONObject data = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String offset = commonUtil.getMinuteUTC(info.getOffSet());
			// 2023-07-28 황인경 즐겨찾기 포틀릿 > 게시판 작성자 > 다국어 지원 추가
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			info.setCompanyId(companyId);
			info.setDeptId(deptId);

			data.put("boardId", boardId);

			BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardId, info.getTenantId());
			String guBun = boardPropertyVO.getGuBun();
			// Q&A 의 일반 유저일 경우 일반 게시판과 다른 리스트
			boolean isQnANormal = "5".equals(guBun);
			if (isQnANormal) {
				// 해당 게시판 관리자가 아니면 Q&A 게시판 로직으로 변경
				isQnANormal = !ezBoardService.isBoardAdmin(boardId, info.getUserId(), info.getDeptId(), info.getCompanyId(), info.getTenantId(), info.getRollInfo());
			}
			
			int totalPages = 0;
			int startRow = 0;
			int totalCnt = 0;
			if (boardId.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")) { // 새게시물
				totalCnt = ezNewPortalService.getFavNewItemListCnt(info.getUserId(), info.getTenantId(), info.getCompanyId(), commonUtil.getTodayUTCTime(""), offset);
				totalPages  = (totalCnt + listCnt - 1) / listCnt;
				currentPage = currentPage > totalPages ? totalPages : currentPage;
				currentPage = currentPage == 0         ? 1          : currentPage;
				startRow  = (currentPage - 1) * listCnt;
				
				List<FavoriteBoardVO> favNewList = ezNewPortalService.getFavNewItemList(info.getUserId(), info.getTenantId(), info.getCompanyId(), commonUtil.getTodayUTCTime(""), startRow, listCnt, offset);

				for (FavoriteBoardVO fvo : favNewList) {
					// 2023-07-28 황인경 - 포탈 > 즐겨찾기 포틀릿 > 작성자 > 다국어 지원 추가
					if (!lang.equals("")) {
						fvo.setWriterName(fvo.getWriterName2());
					}
					logger.debug("resultList : " + fvo.getItemId());
				}
				
				data.put("favList", favNewList);
				data.put("totalCnt", totalCnt);
				data.put("currentPage", currentPage);

			} else if (isQnANormal) { // Q&A 게시판
				totalCnt = ezNewPortalService.getBoardPortletTotalCnt(info.getUserId(), info.getTenantId(), boardId, info.getCompanyId(), info.getOffSet(), isQnANormal);
				totalPages  = (totalCnt + listCnt - 1) / listCnt;
				currentPage = currentPage > totalPages ? totalPages : currentPage;
				currentPage = currentPage == 0         ? 1          : currentPage;
				startRow  = (currentPage - 1) * listCnt;
				
				List<BoardListVO> boardList = ezNewPortalService.getBoardPortletInfo(info.getUserId(), info.getTenantId(),	boardId, listCnt, info.getCompanyId(), info.getOffSet(), isQnANormal, startRow);
				data.put("favList", boardList);
				data.put("totalCnt", totalCnt);
				data.put("currentPage", currentPage);
			} else { // 일반게시판
				totalCnt = ezNewPortalService.getFavItemListCnt(boardId, info.getTenantId(), info.getCompanyId(), offset);
				totalPages  = (totalCnt + listCnt - 1) / listCnt;
				currentPage = currentPage > totalPages ? totalPages : currentPage;
				currentPage = currentPage == 0         ? 1          : currentPage;
				startRow  = (currentPage - 1) * listCnt;
				
				List<FavoriteBoardVO> favList = ezNewPortalService.getFavItemList(boardId, info.getTenantId(), info.getCompanyId(), startRow, listCnt, offset);

				for (FavoriteBoardVO fvo : favList) {
					// 2023-07-28 황인경 - 포탈 > 즐겨찾기 포틀릿 > 작성자 > 다국어 지원 추가
					if (!lang.equals("")) {
						fvo.setWriterName(fvo.getWriterName2());
					}
					logger.debug("resultList : " + fvo.getItemId());
				}
				data.put("favList", favList);
				data.put("totalCnt", totalCnt);
				data.put("currentPage", currentPage);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			data.put("totalCnt", 0);
			data.put("currentPage", 1);
			result.put("data", data);
		}
		logger.debug("ezNewPortal G/W getFavoriteBoardPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 게시판 즐겨찾기 포틀릿 탭 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/boardFavorites/lists", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFavoriteBoardPortletList(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getFavoriteBoardPortletList started.");
		JSONObject result = new JSONObject();
		String userId = request.getParameter("userId");
		String mode = request.getParameter("mode");
		String companyId = request.getParameter("companyId");

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			// 2023-12-01 조소정 - 사용자 설정 언어에 따라 포틀릿 탭리스트 표출되도록 수정
			String lang = commonUtil.getLangData(info.getLang());
			
			List<BoardMyFavoriteVO> resultList = ezBoardService.get_favoriteList(userId, mode, companyId, tenantId, lang);

			for (BoardMyFavoriteVO fvo : resultList) {
				logger.debug("resultList : " + fvo.getBoardId());
			}

			JSONObject data = new JSONObject();
			data.put("resultList", resultList);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getFavoriteBoardPortletList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 커뮤니티 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/community", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCommunityPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getCommunityPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			String companyId = request.getParameter("companyId");
			int tenantId = info.getTenantId();
			JSONObject data = new JSONObject();
			String lang = info.getLang();
			int listSize = Integer.parseInt(request.getParameter("listSize"));
			int currentPage = Integer.parseInt(request.getParameter("currentPage"));
			
			int communityTotalCnt = ezNewPortalService.getCommunityListTotalCnt(companyId, tenantId);
			int totalPages  = (communityTotalCnt + listSize - 1) / listSize;
			currentPage = currentPage > totalPages ? totalPages : currentPage;
			currentPage = currentPage == 0         ? 1          : currentPage;
			int startRow  = (currentPage - 1) * listSize;

			List<CommunityMyCommunityVO> CommunityList = ezNewPortalService.getCommunityList(lang, startRow, listSize, companyId, tenantId);
			// int CommuSize = CommunityList.size();
			//
			// if (CommuSize == 0) {
			// data.put("CommunityList", CommunityList);
			// } else if (CommuSize == 1) {
			// data.put("CommunityList", CommunityList);
			// if (CommunityList.get(0).getC_ClubGubun() != null &&
			// CommunityList.get(0).getC_ClubGubun().equals("3")) {
			//
			// String memberChk =
			// ezNewPortalService.getMemberChk(CommunityList.get(0).getC_ClubNo(),
			// userId, tenantId);
			//
			// data.put("memberChk", memberChk);
			// }
			// } else {
			// data.put("CommunityList", CommunityList);
			// for (int i = 0; i < 2; i++) {
			//
			// if (CommunityList.get(i).getC_ClubGubun() != null &&
			// CommunityList.get(i).getC_ClubGubun().equals("3")) {
			// String memberChk0 =
			// ezNewPortalService.getMemberChk(CommunityList.get(i).getC_ClubNo(),
			// userId, tenantId);
			// String memberChk1 =
			// ezNewPortalService.getMemberChk(CommunityList.get(i).getC_ClubNo(),
			// userId, tenantId);
			//
			// data.put("memberChk0", memberChk0);
			// data.put("memberChk1", memberChk1);
			// }
			//
			// String bannerSrc = "";
			//
			// if
			// (CommunityList.get(i).getC_Logo_Thumbnail().trim().indexOf("default_logo_type")
			// > -1) {
			// bannerSrc = "/images/ezCommunity/logo/" +
			// CommunityList.get(i).getC_Logo_Thumbnail().trim();
			// } else {
			// bannerSrc = "/ezCommon/downloadAttach.do?filePath=" +
			// commonUtil.getUploadPath("upload_community.LOGO",
			// tenantId)+commonUtil.separator+CommunityList.get(i).getC_Logo_Thumbnail();
			// }
			// }
			// }
			String commuPath = commonUtil.getUploadPath("upload_community.LOGO", tenantId);

			data.put("CommunityList", CommunityList);
			data.put("CommuSize", communityTotalCnt);
			data.put("commuPath", commuPath);
			data.put("currentPage", currentPage);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCommunityPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 커뮤니티 허가여부
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/community/permits", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject communityPermit(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getCommunityPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			int tenantId = info.getTenantId();
			JSONObject data = new JSONObject();
			String clubNo = request.getParameter("clubNo");

			String memberChk = ezNewPortalService.getCommunityPermit(clubNo, userId, tenantId);

			data.put("memberChk", memberChk);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getCommunityPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 받은 메일 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/receivedMail", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getReceivedMainPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getReceivedMainPortlet started.");
		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();

		String password = jspw;
		String userId = request.getParameter("userId");

		try {
			String serverName = request.getHeader("x-user-host");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			Locale locale = info.getLocale();

			// start

			String folderPath = "INBOX";
			IMAPAccess ia = null;

			try {
				// get user credentials

				String domainName = ezCommonService.getTenantConfig("DomainName", info.getTenantId());
				String userAccount = userId + "@" + domainName;

				logger.debug("userEmail=" + userAccount);

				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userAccount, password, egovMessageSource, locale, 40 * 1000,
						20 * 1000, ezEmailUtil);

				long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();

				double mailboxUsage = storageUsageAndLimit[0]; // in KBs
				double mailboxQuota = storageUsageAndLimit[1]; // in KBs

				// 재은 수정
				String[] mailUse = ezEmailUtil.getMailUsage(mailboxUsage, mailboxQuota);
				String mailPercent = "";
				String mailboxDetail = "";
				String mailboxQuotaStr = "";

				if (mailUse != null) {
					mailPercent = mailUse[0];
					mailboxDetail = mailUse[1];
					mailboxQuotaStr = mailUse[2];
				}

				logger.debug("mailPercent=" + mailPercent + ",mailboxDetail=" + mailboxDetail + ",mailboxQuotaStr=" + mailboxQuotaStr);

				Folder folder = ia.getFolder(folderPath);
				
				int unreadCount = 0;
				int totalCount = 0;

				// set mailCount
				int mailCount = Integer.parseInt(request.getParameter("mailCount") != null ? request.getParameter("mailCount") : "0");
				int currPage = Integer.parseInt(request.getParameter("currPage") != null ? request.getParameter("currPage") : "0");
				int startRow = (currPage - 1) * mailCount;
				
				// if (unreadCount < mailCount) {
				// mailCount = unreadCount;
				// }

				List<Map<Object, String>> mailList = new ArrayList<Map<Object, String>>();
				String useRDBOnlyMailList = ezCommonService.getTenantConfig("useRDBOnlyMailList", info.getTenantId());

				if (useRDBOnlyMailList.equals("YES")) {
					Map<String, Object> extraMap = new HashMap<String, Object>();
					List<Map<String, String>> messageList = ezEmailUtil.searchFolderUsingRDBOnly(userAccount, folderPath, null, null, null, new Date(), false,
							false, false, "receivedDate", false, startRow, mailCount, false, extraMap, info.getTenantId(), false, "");

					unreadCount = (int)extraMap.get("mailboxUnreadMailCount");
					totalCount = (int)extraMap.get("totalCount");

					for (Map<String, String> mailInfo : messageList) {
						// href
						String href = mailInfo.get("MAIL_ID");

						// received date
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
						Date receivedDate = sdf.parse(mailInfo.get("MAIL_DATE"));
						sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
						String receivedDateStr = sdf.format(receivedDate);

						receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffset(), false);

						// sender
						String sender = ezEmailUtil.getNameOrAddress(mailInfo.get("SENDER"));

						// subject
						String subject =  mailInfo.get("SUBJECT");
						subject = (subject != null) ? subject : "";

//						if ("1".equals(mailInfo.get("MAIL_IS_SECURED"))) {
//							subject = "<img src=\"/images/email/secureMail/security_icon.gif\" width=\"15px\" />" + subject;
//						}

						String securedMail = String.valueOf("1".equals(mailInfo.get("MAIL_IS_SECURED")));

						int readFlag = "1".equals(mailInfo.get("MAIL_IS_SEEN")) ? 1 : 0;
						String readClass = "";

						if (readFlag == 0) {
							readClass = "mail_close";
						} else {
							readClass = "mail_open";
						}

						Map<Object, String> mailMap = new HashMap<Object, String>();
						mailMap.put("href", href);
						mailMap.put("receivedDateStr", receivedDateStr.substring(5));
						mailMap.put("sender", sender);
						mailMap.put("subject", subject);
						mailMap.put("readClass", readClass);
						mailMap.put("securedMail", securedMail);

						mailList.add(mailMap);
					}
				} else {
					// Folder.getUnreadMessageCount() 메소드 동작 방식이 folder가 open 상태일 때는 읽지 않은 메일 갯수를 IMAP search 명령을
					// 통해 비효율적으로 구하는 관계로 folder open 전에 호출함. open 상태가 아닐 때는 IMAP status 명령을 사용하며 status 명령이
					// 더 효율적임.
					unreadCount = ia.getUnreadCount(folderPath);
					totalCount = ia.getTotalCount(folderPath);
					folder.open(Folder.READ_ONLY);

					Message[] messages = ezEmailUtil.searchFolder(ia, userAccount, folder, "", "", null, new Date(), false, false, false, "receivedDate", false, startRow, mailCount, false, null, info.getTenantId(), "");

					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					sdf.setTimeZone(TimeZone.getTimeZone("GMT"));

					int messagesLength = messages.length;

					for (int i = 0; i < messagesLength; i++) {
						Message message = messages[i];
						UIDFolder uidFolder = (UIDFolder) message.getFolder();

						// href
						String href = "INBOX/" + uidFolder.getUID(message);

						// received date
						Date receivedDate = message.getReceivedDate();
						String receivedDateStr = sdf.format(receivedDate);
						receivedDateStr = commonUtil.getDateStringInUTC(receivedDateStr, info.getOffset(), false);

						// sender
						String sender = ezEmailUtil.getFromNameOrAddressOfMessage(message);

						// subject
						String subject = ezEmailUtil.getSubject(message);
						subject = (subject != null) ? subject : "";

//						if ("1".equals(ezEmailUtil.hasSecureMailFlag(message))) {
//							subject = "<img src=\"/images/email/secureMail/security_icon.gif\" width=\"15px\" />" + subject;
//						}

						String securedMail = String.valueOf("1".equals(ezEmailUtil.hasSecureMailFlag(message)));

						int readFlag = message.isSet(Flags.Flag.SEEN) ? 1 : 0;
						String readClass = "";

						if (readFlag == 0) {
							readClass = "mail_close";
						} else {
							readClass = "mail_open";
						}

						Map<Object, String> mailMap = new HashMap<Object, String>();
						mailMap.put("href", href);
						mailMap.put("receivedDateStr", receivedDateStr.substring(5));
						mailMap.put("sender", sender);
						mailMap.put("subject", subject);
						mailMap.put("readClass", readClass);
						mailMap.put("securedMail", securedMail);

						mailList.add(mailMap);
					}
				}

				data.put("mailList", mailList);
				data.put("unreadCount", unreadCount);
				data.put("mailboxQuotaStr", mailboxQuotaStr);
				data.put("mailboxDetail", mailboxDetail);
				data.put("mailPercent", mailPercent);
				data.put("currPage", currPage);
				data.put("totalCount", totalCount);

			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getReceivedMainPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 투표 정보 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/vote", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getVotePortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getVotePortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String rollInfo = request.getParameter("rollInfo");
			String userType = rollInfo.indexOf("c=1") > -1 || rollInfo.indexOf("k=1") > -1 ? "admin" : "user";

			// deptpath 구하기
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);

			// 진행중인 투표 중 내가 참여하고 있는 투표의 개수
			int voteCount = ezNewPortalService.getVotePortletCount(userId, companyId, deptPath, tenantId, userType, deptId);

			JSONObject data = new JSONObject();
			data.put("voteCount", voteCount);

			if (voteCount != 0) {
				// 투표 정보 가져오기
				PollQuestionVO pollQuestion = ezNewPortalService.getVotePortletInfo(userId, companyId, deptPath, tenantId, userType);
				int qstId = pollQuestion.getQstId();

				logger.debug("qstId : " + qstId);
				List<PollAnswerVO> pollAnswer = ezNewPortalService.getVotePortletAnswer(qstId, tenantId);
				int pollAnswerCount = 0;

				for (int i = 0; i < pollAnswer.size(); i++) {
					pollAnswerCount += pollAnswer.get(i).getVotesNumber();
				}

				data.put("qstId", qstId);
				data.put("title", pollQuestion.getTitle());
				data.put("pollAnswer", pollAnswer);
				data.put("pollAnswerCount", pollAnswerCount);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getVotePortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 포토게시판 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/photoBoard", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPhotoBoardPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getPhotoBoardPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String rollInfo = info.getRollInfo();
			int tenantId = info.getTenantId();
			int portletId = Integer.parseInt(request.getParameter("portletId")); // 포토게시판의  포틀릿 아이디
			int currentPage = Integer.parseInt(request.getParameter("currentPage"));
			int photoCount = Integer.parseInt(request.getParameter("photoCount"));
			String portletLang = info.getLang();
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			deptPath = "everyone,top,Top," + deptPath + "," + userId;
			JSONObject data = new JSONObject();

			// 회사의 포토게시판의 포틀릿 정보 가져오기
			PortletInfoVO portlet = ezNewPortalService.getCompanyPortletInfo(companyId, tenantId, portletId, portletLang);
			String boardId = portlet.getPortletBoardId();
			data.put("boardId", boardId);
			data.put("portletName", portlet.getPortletName());
			
			if (boardId == null) {
				data.put("access", false);
				data.put("photoBoardList", null);
				data.put("totalCnt", 0);
				data.put("currentPage", 1);
			} else {
				// 게시판 권한 체크
				boolean accessCheck = boardAuthCheck(boardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);
				if (!accessCheck) {
					data.put("access", "false");
					data.put("photoBoardList", null);
					data.put("totalCnt", 0);
					data.put("currentPage", 1);
				} else {
					// 권한이 true이면 boardList불러오기
					int totalCnt = ezNewPortalService.getPhotoBoardPortletTotalCnt(tenantId, boardId, info.getOffset());
					int totalPages  = (totalCnt + photoCount - 1) / photoCount;
					currentPage = currentPage > totalPages ? totalPages : currentPage;
					currentPage = currentPage == 0         ? 1          : currentPage;
					int startRow  = (currentPage - 1) * photoCount;
					
					List<BoardItemVO> photoBoardList = ezNewPortalService.getPhotoBoardPortletInfo(tenantId, boardId, startRow, photoCount, info.getOffset());
					if (photoBoardList.get(0).getAddThumbnail() != null && photoBoardList.get(0).getAddThumbnail().equals("Y")) {
						String path = photoBoardList.get(0).getFilePath().substring(0, photoBoardList.get(0).getFilePath().lastIndexOf("/") + 1);
						String fileName = photoBoardList.get(0).getFilePath().substring(photoBoardList.get(0).getFilePath().lastIndexOf("/") + 1);
						fileName = "s_" + fileName.substring(0, fileName.lastIndexOf(".")) + "." + photoBoardList.get(0).getThumbnailExt();
						String thumbnailPath = path + fileName;
						photoBoardList.get(0).setThumbnailPath(thumbnailPath);
					}
					data.put("access", "true");
					data.put("photoBoardList", photoBoardList);
					data.put("totalCnt", totalCnt);
					data.put("currentPage", currentPage);
				}
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getPhotoBoardPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 공지사항 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/notice", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getNoticePortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getNoticePortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			deptPath = "everyone,top,Top," + deptPath + "," + userId;
			String rollInfo = info.getRollInfo();
			int portletId = Integer.parseInt(request.getParameter("portletId"));
			int currentPage = Integer.parseInt(request.getParameter("currentPage"));
			int listCntSize = Integer.parseInt(request.getParameter("listCntSize"));
			String portletLang = info.getLang();
			int totalCnt = 0;
//			int limit = 12; // 공지사항 갯수
			
			// 회사의 포토게시판의 포틀릿 정보 가져오기
			PortletInfoVO portlet = ezNewPortalService.getCompanyPortletInfo(companyId, tenantId, portletId, portletLang);
			String boardId = portlet.getPortletBoardId();

			// 게시판 권한 체크
			boolean accessCheck = boardAuthCheck(boardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);
			
			// 여기에 데이터를 put해서 넘기면 됨.
			JSONObject data = new JSONObject();
			data.put("boardId", boardId); // 포틀릿 정보 중 boardId 가져오기
			
			if (boardId == null) {
				data.put("access", "false");
			} else {
				if (!accessCheck) {
					data.put("access", "false");
				} else {
					BoardMyFavoriteVO brdVo = new BoardMyFavoriteVO();
					brdVo.setBoardId(boardId);
					brdVo.setUserId(userId);
					brdVo.setType("1");
					brdVo.setTenantID(tenantId);
					brdVo.setNowDate(commonUtil.getTodayUTCTime(""));
					totalCnt = ezBoardService.getBrdTotalItemCount(brdVo);
					// 권한이 true이면 boardList불러오기
					List<BoardListVO> noticeList = new ArrayList<BoardListVO>();
					noticeList = ezNewPortalService.getNoticePortletList(companyId, tenantId, info.getOffset(), info.getLang(), currentPage, listCntSize, portletId);
					
					if (currentPage > 1 && noticeList.size() < 1) {
						currentPage--;
						ezNewPortalService.getNoticePortletList(companyId, tenantId, info.getOffset(), info.getLang(), currentPage, listCntSize, portletId);
					}
					
					int noticeCount = noticeList.size();
					
					for (int i = 0; i < noticeCount; i++) {
						String writeDate = noticeList.get(i).getWriteDate();
						
						noticeList.get(i).setWriteDate(commonUtil.getDateStringInUTC(writeDate, info.getOffset(), false));
					}
					
					data.put("currentPage", currentPage);
					data.put("access", "true");
					data.put("noticeList", noticeList);
				}
				
			}
			
			data.put("totalCnt", totalCnt);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		logger.debug("ezNewPortal G/W getNoticePortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 설문조사 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/poll", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPollPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getPollPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String offset = info.getOffSet();
			int tenantId = info.getTenantId();
			List<Map<String, Object>> answerList = new ArrayList<Map<String, Object>>();
			// 2023-07-28 황인경 - 포탈 > 빠른 설문 포틑릿 > 설문제목 다국어 지원 추가 
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			
			PersonalLightPollVO pollInfo = new PersonalLightPollVO();
			pollInfo = ezNewPortalService.getPollPortlet(companyId, tenantId, request.getParameter("userId"), offset);
			
			if (pollInfo == null) {
				result.put("status", "empty");
				result.put("code", 0);
				result.put("data", "");
				return result;
			}
			
			// 2023-07-28 황인경 - 포탈 > 빠른 설문 포틑릿 > 설문제목 다국어 지원 추가 
			if (!lang.equals("")) {
				pollInfo.setPollTitle(pollInfo.getPollTitle2());
			}
			
			int itemSeq = pollInfo.getItemSeq();
			List<PersonalLightPollVO> pollResult = ezNewPortalService.getPollPortletResult(companyId, tenantId, itemSeq);

			answerList = ezNewPortalService.getAssemblePollData(pollInfo, pollResult);

			JSONObject data = new JSONObject();
			data.put("pollInfo", pollInfo);
			data.put("answerList", answerList);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getPollPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 전자결재(결재할 문서, 반송 문서, 기안 문서)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/approvallist", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getApprovalListPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getApprovalListPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			String type = request.getParameter("type");
			int tenantId = info.getTenantId();
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantId);
			String companyId = request.getParameter("companyId");

			JSONObject data = ezNewPortalService.getApprovalList(userId, companyId, tenantId, info.getOffset(), type, approvalFlag, info.getLang());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getApprovalListPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 즐겨찾기 양식
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/favoriteforms", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getFavoriteForms(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getFavoriteForms started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			List<ApprGFormVO> list = ezNewPortalService.getFavoriteForms(userId, companyId, info.getTenantId(), deptId);
			
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());
			int listCount = list.size();
			
			for (int i = 0; i < listCount; i++) {
				if (lang != null && !lang.equals("")) {
					list.get(i).setFormName(list.get(i).getFormName2());
				}
			}
			
			JSONObject data = new JSONObject();
			data.put("resultList", list);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getFavoriteForms ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 즐겨찾기양식 (결재할문서 통계)
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/approvalstatistics", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getApprovalStatisticsPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getApprovalStatisticsPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			Map<String, Object> resultMap = ezNewPortalService.getApprovalStatistics(userId, info.getCompanyID(), info.getTenantId());

			JSONObject data = new JSONObject();
			data.put("hour", resultMap.get("hour"));
			data.put("day", resultMap.get("day"));
			data.put("week", resultMap.get("week"));
			data.put("month", resultMap.get("month"));
			data.put("other", resultMap.get("other"));

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getApprovalStatisticsPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 일정관리 리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/schedulelist", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getSchedulePortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getSchedulePortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			
			String offset = info.getOffSet();
			String offSetMin = commonUtil.getMinuteUTC(offset);
			
			String startDate = (request.getParameter("STARTDATE") == null || request.getParameter("STARTDATE").equals("")) ? request.getParameter("selectDate") : request.getParameter("STARTDATE");
			String endDate = (request.getParameter("ENDDATE") == null || request.getParameter("ENDDATE").equals("")) ? request.getParameter("selectDate") : request.getParameter("ENDDATE");
			String idList = (request.getParameter("IDLIST") == null || request.getParameter("IDLIST").equals("")) ? "T" : request.getParameter("IDLIST");
			
			String indiList = "";
			String pidList = "";
			String pidListSub = "";
			String indiListSub = "";
			
			if(startDate != null && !startDate.equals("")) {
				String[] sDate = startDate.split("-");
				String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
				String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
				
				startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
			}
			
			if(endDate != null && !endDate.equals("")) {
				String[] eDate = endDate.split("-");		
				String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
				String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
				
				endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
			}
			
			String utcStartTime = commonUtil.getDateStringInUTC(startDate, offset, true);
			String utcEndTime = commonUtil.getDateStringInUTC(endDate, offset, true);
			
			String lang = info.getPrimary();
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			//2020-02-24 김정언
			String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", tenantId);
			
			List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(userId, lang, tenantId ,companyId);
			List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(userId, lang, tenantId ,companyId);
			List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(userId, lang, tenantId, companyId);
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, info.getTenantId() ,companyId);
			
			if (idList == null) {
				idList = "";
			}
			
			//2018-06-08 구해안 T인 경우를 제외하고 나머지는 id값 그대로 가공해서 넘기기
			if (idList.equals("T") || idList.equals("")) {
				indiList = "'" + userId + "'";
				
				if(tList != null && tList.size()>0){
					for (int i = 0; i < tList.size(); i++) {
						if (i == 0) {
							indiListSub += ",";
						}			
						ScheduleSecretaryVO data = tList.get(i);			
						indiListSub += "\'" + data.getSecId()+ "\',";			
					}				
				}
				
				pidList = "'" + deptId + "'," + "'" + companyId + "'";
				
				
				if(dList != null && dList.size()>0){
					for (int i = 0; i < dList.size(); i++) {
						if(tList == null || tList.size()<=0){
							if (i == 0) {
								pidListSub += ",";
							}	
						}
						ScheduleDeptVO data = dList.get(i);			
						pidListSub += "\'" + data.getDeptId()+ "\',";				
					}				
				}
				
				if(cList != null && cList.size()>0 ){
					for (int i = 0; i < cList.size(); i++) {							
						if(dList == null || dList.size()<=0){
							if (i == 0) {
								pidListSub += ",";
							}	
						}
						ScheduleCumulerVO data = cList.get(i);			
						pidListSub += "\'" + data.getDeptId()+ "\',";				
					}				
				}
				
				for (int i = 0; i < gList.size(); i++) {
					if((dList == null || dList.size()<=0) && (cList == null || cList.size()<=0)){
						if (i == 0) {
							pidListSub += ",";
						}
					}
						ScheduleGroupListVO data = gList.get(i);			
						pidListSub += "\'" + data.getGroupId() + "\',";
						
						/*if (i != gList.size()-1) {
							pidListSub += ",";
						}*/
					}
				
				if(indiListSub == null || indiListSub.equals("")){
					indiListSub = ",\'\'";
				}else{				
					indiListSub = indiListSub.substring(0, indiListSub.length()-1);
				}
				
				indiList += indiListSub;
				
				if(pidListSub == null || pidListSub.equals("")){
					pidListSub = ",\'\'";
				}else{				
					pidListSub = pidListSub.substring(0, pidListSub.length()-1);
				}
				
				if (pidList != null && pidListSub != null && pidListSub.substring(0,1) != ",") {
					pidList += ",\'\'";
				}
				
				pidList += pidListSub;
				
			} else if(idList.equals("chkAllFalse")) {
				indiList = "";
				pidList = "\'\'";
			} else if (idList.equals("P")) {
				indiList = "'" + userId + "'";
				pidList = "";
			}else {
				pidList = idList;
			}		
			
			List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, "", utcStartTime, utcEndTime, startDate, endDate, offSetMin, "", "", "", tenantId, companyId, userId, deptId, useAnnualScheduleYN);		
			
			// 구글연동 일정 가져오기(포탈 일정포틀릿)
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", userInfo.getTenantId());
			if(useGoogleCalendar.equals("YES")) {
				List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, "", userInfo, userInfo.getId(), "member", userInfo.getDisplayName());		
				sList.addAll(googleList);
			}
			
			Collections.sort(sList, new EzScheduleCompareUtil());
			
			logger.debug("status: OK / sList size : {}", sList.size());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", sList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getSchedulePortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 날씨
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/weather", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getWeatherPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getWeatherPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			int tenantID = info.getTenantId();
			int userLocalLang = Integer.parseInt(ezNewPortalService.getUserLocalLang(userId, tenantID));
			String countryCode = request.getParameter("countryCode") == null ?
								 (
									 ezNewPortalService.getCountryCode(userId, tenantID) != null && !ezNewPortalService.getCountryCode(userId, tenantID).isEmpty() ?
									 ezNewPortalService.getCountryCode(userId, tenantID) :
									 String.valueOf(userLocalLang)
								 ) :
								 request.getParameter("countryCode");
			String cityCode = request.getParameter("cityCode");
			
			if (cityCode == null || cityCode.equals("")) {
				cityCode = ezNewPortalService.getUserCityCode(info.getId(), tenantID);

				if (cityCode == null || cityCode.equals("")) {
					cityCode = "none";
				}
			} else {
				ezNewPortalService.setUserCityCode(info.getId(), tenantID, cityCode, countryCode);

				if (cityCode.equals("none")) {
					cityCode = ezNewPortalService.getFirstCityCode(countryCode);
				}
				
				ezNewPortalService.setUserCityCode(info.getId(), tenantID, cityCode, countryCode);
			}
			
			JSONObject data = new JSONObject();
			Map<String, Object> resultMap = ezNewPortalService.getWeather(cityCode, userLocalLang, countryCode);
			List<WeatherVO> cityList = ezNewPortalService.getCityList(userLocalLang, countryCode);

			data.put("lang", info.getLang());
			data.put("cityList", cityList);
			
			if (info.getLang().equals("2")) {
				data.put("displayName", resultMap.get("CITYNAME"));
			} else {
				data.put("displayName", resultMap.get("DISPLAYCITYNAME"));
			}
			
			data.put("currentWeather", resultMap.get("CURRENTWEATHER"));
			data.put("todayWeather", resultMap.get("TODAYWEATHER"));
			data.put("cityCode", resultMap.get("CITYCODE"));
			data.put("countryCode", countryCode);

			String[] todayArr = resultMap.get("TODAYWEATHER").toString().split("!");
			
			String todayHours = "";
			
			StringBuffer buffer = new StringBuffer();
			
			for (int i = 0; i < todayArr.length; i++) {
				String TodayDate = todayArr[i].split(";")[2];
				String TodayDateUTC = commonUtil.getDateStringInUTC(TodayDate, info.getOffset(), false);
				
				buffer.append(TodayDateUTC.substring(11, 13) + ";");
			}
			
			todayHours = buffer.toString();
			
			data.put("todayHours", todayHours.substring(0, todayHours.length() - 1));
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getWeatherPortlet ended.");
		return result;
	}

	// //////board 권한 체크
	public boolean boardAuthCheck(String boardId, String deptPath, int tenantId, String companyId, String deptId, String userId, String rollInfo) throws Exception {
 		logger.debug("boardAuthCheck started");
		boolean authCheck = false;
		String[] deptPathSplit = deptPath.split(",");
		int deptPathCount = deptPathSplit.length;

		try {
			if (ezBoardService.isBoardAdmin(boardId, userId, deptId, companyId, tenantId, rollInfo)) {
				authCheck = true;
			} else {
				for (int i = 0; i < deptPathCount; i++) {
					String deptPathId = deptPathSplit[i];
					BoardPropertyVO authInfo = ezBoardAdminService.getACL(boardId, deptPathId, tenantId);
					
					if (authInfo == null) {
						
					} else {
						String access = authInfo.getAccess_();
						String deptAcl = authInfo.getBoardGroupACL();
						
						if (i == deptPathCount - 1) {
							deptAcl = "Y";
						}
						
						if (access.equals("1")) {
							if (deptAcl.equals("Y")) {
								authCheck = true;
							}
							
							if (authInfo.getAccessID().equals(deptId)) {
								authCheck = true;
							}
						} else if (access.equals("0") && deptAcl.equals("Y")) {
							authCheck = false;
						}
					}
					
					
					/*String authCompare = ezNewPortalService.getBoardAuthCheck(boardId, deptPathId, tenantId, companyId);

					if (authCompare != null) {
						if (authCompare.equals("true")) {
							authCheck = true;
						} else {
							authCheck = false;
						}
					}*/
				}
			}
		} catch (Exception e) {
			logger.debug("boardAuthCheck error");
		}

		logger.debug("authCheck : " + authCheck);
		logger.debug("boardAuthCheck ended");
		return authCheck;
	}
	
	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 슬라이드 이미지
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/slideimages", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getslideimagesPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getslideimagesPortlet started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String companyId = request.getParameter("companyId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			List<PersonalSliderImageVO> sliderList = ezPersonalService.getSilderList(companyId, "USER", null, info.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", sliderList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getslideimagesPortlet ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 유저정보
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/userinfomations", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getuserInfomationsPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getuserInfomationsPortlet started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String jobId = request.getParameter("jobId");
			String lang = request.getParameter("lang");
			
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			OrganUserVO userInfo = ezOrganService.getUserInfo(info.getTenantId(), userId, companyId, deptId, jobId, lang).orElseThrow(NoSuchFieldException::new);
			
			
			String userName = "";
			String userTitle = "";
			String deptName = "";
			String userPhoto = "";
			String userEmail = "";

			userName = userInfo.getDisplayName();
			userTitle = userInfo.getTitle();
			deptName = userInfo.getDescription();
			userEmail = info.getEmail();
			
			// 유저이미지
			String imgUrl = ezOrganService.getPropertyValue(userId, "extensionAttribute2", info.getTenantId());

			if (imgUrl != null && !imgUrl.equals("")) {
				userPhoto = commonUtil.getUploadPath("upload_personal.PHOTO", info.getTenantId()) + commonUtil.separator + imgUrl;
			}
			
			String useAttitude = "NO";
			//근태 사용여부
			String useAttitude2 = ezCommonService.getTenantConfig("USE_ATTITUDE", info.getTenantId());
			
			if (useAttitude2 == null || useAttitude2.equals("")) {
				useAttitude2 = "NO";
			}
			
			if (useAttitude2.equals("YES")) {
				List<MenuInfoVO> menuList = ezNewPortalService.getUserMenuList(info.getCompanyId(), info.getTenantId(), info.getLang(), userId, info.getDeptId());
				
				for (MenuInfoVO mVO : menuList) {
					if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("attitude") && useAttitude2.equals("YES")) {
						useAttitude = "YES";
					}	
				}
			}
			
			//마지막(최종)접속시간
			String lastLogin = "";
			
			lastLogin = ezOrganService.getLastLogin(userId, info.getTenantId());
			
			if (lastLogin != null) {
				lastLogin = EgovDateUtil.convertDate(lastLogin, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "");
				lastLogin = commonUtil.getDateStringInUTC(lastLogin, info.getOffSet(), false);
			} else {
				lastLogin = "";
			}
			
			// IP
			String lastLoginIP = ezOrganService.getLoginIP(userId, info.getTenantId());

			JSONObject data = new JSONObject();
			data.put("useAttitude", useAttitude);
			data.put("userName", userName);
			data.put("userTitle", userTitle);
			data.put("deptName", deptName);
			data.put("userPhoto", userPhoto);
			data.put("userEmail", userEmail);
			data.put("lastLogin", lastLogin);
			data.put("lastLoginIP", lastLoginIP);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getuserInfomationsPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 카운트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/count/{userId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getCountPortlet(HttpServletRequest request, @PathVariable String userId, Locale locale) throws Exception {
		logger.debug("ezNewPortal G/W getCountPortlet started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();
			//2020-02-24 김정언
			String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", tenantId);
			
			// 메일, 결재, 일정, 전자설문, 회람판, 근태관리 권한이 있는지 확인
//			String useQuestion = "NO";
			String useSurvey = "NO";
			String useCircular = "NO";
			String useMail = "NO";
			String useApproval = "NO";
			String useSchedule = "NO";

			// 1. tenantConfig가 YES인지 -- 회람판(USE_CIRCULAR), 근태관리(USE_ATTITUDE),
			// 전자설문(useQuestion)
//			useQuestion = ezCommonService.getTenantConfig("useQuestion", info.getTenantId());
			useSurvey = ezCommonService.getTenantConfig("useSurvey", info.getTenantId());
			useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", info.getTenantId());
			useSchedule = ezCommonService.getTenantConfig("useSchedule", info.getTenantId());
			
			// 2020-04-09 김민성 - 메일 config 추가
			String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", tenantId);
			
			// 2. 메뉴에 권한이 있는지 ================ 수정하기 start
//			if (useQuestion == null || useQuestion.equals("")) {
//				useQuestion = "NO";
//			}
			
			if (useSurvey == null || useSurvey.equals("")) {
				useSurvey = "YES";
			}
			
			if (useCircular == null || useCircular.equals("")) {
				useCircular = "YES";
			}
			
			List<MenuInfoVO> menuList = ezNewPortalService.getUserMenuList(companyId, tenantId, portletLang, userId, deptId);
			
//			boolean isUseQuestionAuth = false;
			boolean isUseSurveyAuth = false;
			boolean isUseScheduleAuth = false;
			
			for (MenuInfoVO mVO : menuList) {
				if (mVO.getMenuCode() != null) {
					if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("survey") && useSurvey.equals("YES")) {
						isUseSurveyAuth = true;
					}
					
					if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("approval")) {
						useApproval = "YES";
					} 
					
					if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("mail")) {
						useMail = "YES";
					}
					
					if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("schedule") && useSchedule.equals("YES")) {
						isUseScheduleAuth = true;
					}
				}
			}
			
//			if (isUseQuestionAuth) {
//				useQuestion = "YES";
//			} else {
//				useQuestion = "NO";
//			}
			
			if (isUseSurveyAuth) {
				useSurvey = "YES";
			} else {
				useSurvey = "NO";
			}
			
			if (isUseScheduleAuth) {
				useSchedule = "YES";
			} else {
				useSchedule = "NO";
			}
			
			boolean isUseCircular = false;
			
			for (MenuInfoVO mVO : menuList) {
				
				if (mVO.getMenuCode() != null && mVO.getMenuCode().equals("circular") && useCircular.equals("YES")) {
					isUseCircular = true;
					break;
				} else {
					isUseCircular = false;
				}
			}
			
			if (isUseCircular) {
				useCircular = "YES";
			} else {
				useCircular = "NO";
			}
			
			if(useExternalMailServer.equalsIgnoreCase("YES")) {
				useMail = "NO";
			} else {
				useMail = "YES";
			}
			
			String offset = info.getOffSet();
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat adf = new SimpleDateFormat("yyyy-MM-dd");
			String nowDate = adf.format(cal.getTime());
			String offsetMin = commonUtil.getMinuteUTC(info.getOffSet());
			String userEmail = userId + "@" + ezCommonService.getTenantConfig("DomainName", tenantId);
			String password = jspw;
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);
			
			JSONObject data = new JSONObject();

			logger.debug("useSurvey : " + useSurvey + ", useCircular : " + useCircular + ", useMail : " + useMail + ", useApproval : " + useApproval + ", useSchedule : " + useSchedule);
			
			if (useSurvey.equals("YES")) {
				int surveyCnt = ezSurveyService.getSurveyIngCnt(info);
				data.put("surveyCnt", surveyCnt);
			}

			// 오늘 일정 개수 불러오기
			if (useSchedule.equals("YES")) {
				String startDate = nowDate + " 00:00:00";
				String endDate = nowDate + " 23:59:59";
				String startTime = commonUtil.getDateStringInUTC(nowDate + " 00:00:00", offset, true);
				String endTime = commonUtil.getDateStringInUTC(nowDate + " 23:59:59", offset, true);
				String indiList = "";
				String pidList = "";
				String pidListSub = "";
				String indiListSub = "";

				List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(userId, portletLang, tenantId, companyId);
				List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(userId, portletLang, tenantId, companyId);
				List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(userId, portletLang, tenantId, companyId);
				List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, tenantId, companyId);

				indiList = "'" + userId + "'";
				
				StringBuffer buffer = new StringBuffer();
				
				if (tList != null && tList.size() > 0) {
					for (int i = 0; i < tList.size(); i++) {
						if (i == 0) {
							buffer.append(",");
						}
						ScheduleSecretaryVO schedule = tList.get(i);
						buffer.append("\'" + schedule.getSecId() + "\',");
					}
				}
				
				indiListSub = buffer.toString();
				
				pidList = "'" + deptId + "'," + "'" + companyId + "'";

				if (dList != null && dList.size() > 0) {
					for (int i = 0; i < dList.size(); i++) {
						if (tList == null || tList.size() <= 0) {
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleDeptVO schedule = dList.get(i);
						pidListSub += "\'" + schedule.getDeptId() + "\',";
					}
				}

				if (cList != null && cList.size() > 0) {
					for (int i = 0; i < cList.size(); i++) {
						if (dList == null || dList.size() <= 0) {
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleCumulerVO schedule = cList.get(i);
						pidListSub += "\'" + schedule.getDeptId() + "\',";
					}
				}

				if (gList != null && gList.size() > 0) {
					for (int i = 0; i < gList.size(); i++) {
						if ((dList == null || dList.size() <= 0) && (cList == null || cList.size() <= 0)) {
							if (i == 0) {
								pidListSub += ",";
							}
						}
						ScheduleGroupListVO schedule = gList.get(i);
						pidListSub += "\'" + schedule.getGroupId() + "\',";
					}
				}

				if (indiListSub == null || indiListSub.equals("")) {
					indiListSub = ",\'\'";
				} else {
					indiListSub = indiListSub.substring(0, indiListSub.length() - 1);
				}

				indiList += indiListSub;

				if (pidListSub == null || pidListSub.equals("")) {
					pidListSub = ",\'\'";
				} else {
					pidListSub = pidListSub.substring(0, pidListSub.length() - 1);
				}

				pidList += pidListSub;
				List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, "", startTime, endTime, startDate, endDate, offsetMin, "", "", "", tenantId, companyId, userId, deptId, useAnnualScheduleYN);

				// 구글연동 일정 가져오기(포탈 카운트 포틀릿)
				LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
				String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", userInfo.getTenantId());
				if(useGoogleCalendar.equals("YES")) {
					List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, "", userInfo, userInfo.getId(), "member", userInfo.getDisplayName());		
					sList.addAll(googleList);
				}
				
				int scheduleCount = sList.size();
				data.put("scheduleCount", scheduleCount);
			}

			// 회람판 개수 불러오기
			if (useCircular.equals("YES")) {
				int circularCount = ezCircularSerivce.getListCount("newCircular", userId, tenantId, companyId);
				data.put("circularCount", circularCount);
			}

			// 결재할 문서 개수 불러오기
			if (useApproval.equals("YES")) {
				//기존 webPartListCount가 제대로 나오지 않아 전체 리스트에서 count 가져오기
				String appr1 = "";
				String appr2 = "";
				String appr3 = "";
				String appr4 = "";
				
				String susinAdmin = "user";
				String nowDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, true);
				
				if (info.getRollInfo() != null && info.getRollInfo().indexOf("a=1") > -1 || ezOrganService.isProxyUser(info.getTenantId(), userId, nowDateTime).equals("1")) {
					susinAdmin = "admin";
				}
				String approvalTotalCount = ezApprovalGSerivce.getWebPartList("1", userId, deptId, "", "LEFT", susinAdmin, companyId, portletLang, tenantId, offset);
				logger.debug("approvalTotalCount : " + approvalTotalCount);
				
				Document docXML = commonUtil.convertStringToDocument(approvalTotalCount);
				
				for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
					if (k==0) {
						appr1 = docXML.getElementsByTagName("COUNT1").item(0).getTextContent();
					} else if (k==1) {
						appr2 = docXML.getElementsByTagName("COUNT2").item(0).getTextContent();
					} else if (k==2) {
						appr3 = docXML.getElementsByTagName("COUNT3").item(0).getTextContent();
					} else if (k==3) {
						appr4 = docXML.getElementsByTagName("COUNT4").item(0).getTextContent();
					} else if (k>3) {
						break;
					}
				}
				// 2020-12-03 이혁진 포틀릿에 있는 결재할 문서 숫자 대결자로 지정되었을때 숫자 반영하게 변경
				String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantId);
				String lang = portletLang;
				int approvalCount = ezNewPortalService.getApprovalDoingListCount(userId, companyId, tenantId, info.getOffSet(), approvalFlag, lang);
//				int approvalCount = Integer.parseInt(appr1);
				int approvalProgressingCount = Integer.parseInt(appr2);
				int approvalDraftCount = Integer.parseInt(appr3);
				int approvalDeptSusinCount = Integer.parseInt(appr4);
				
				data.put("approvalProgressingCount", approvalProgressingCount);
				data.put("approvalDraftCount", approvalDraftCount);
				data.put("approvalCount", approvalCount);
				data.put("approvalDeptSusinCount", approvalDeptSusinCount);
			}

			// 읽지 않은 메일 가져오기
			if (useMail.equals("YES")) {
				IMAPAccess ia = null;
				String folderName = "INBOX";
				int unreadMailCount = 0;

				try {
					ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userEmail, password, egovMessageSource, locale, ezEmailUtil);
					unreadMailCount = ia.getUnreadCount(folderName);
				} catch (Exception e) {
					logger.debug("e.message=" + e.getMessage());
				} finally {
					if (ia != null) {
						ia.close();
					}
				}
				data.put("unreadMailCount", unreadMailCount);
			}
			
			data.put("useCircular", useCircular);
//			data.put("useQuestion", useQuestion);
			data.put("useSurvey", useSurvey);
			data.put("useMail", useMail);
			data.put("useApproval", useApproval);
			data.put("useSchedule", useSchedule);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		logger.debug("ezNewPortal G/W getCountPortlet ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 커스텀 게시판 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/board", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getBoardPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getBoardPortlet started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String fileName = request.getParameter("fileName");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String rollInfo = info.getRollInfo();
			int tenantId = info.getTenantId();
			int portletId = Integer.parseInt(request.getParameter("portletId"));
			int itemCount = Integer.parseInt(request.getParameter("photoCount"));
			int currentPage = commonUtil.isIntNumber(request.getParameter("currentPage"),1);
			String portletLang = info.getLang();
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			deptPath = "everyone,top,Top," + deptPath + "," + userId;
			JSONObject data = new JSONObject();

			// 회사의 포틀릿 정보 가져오기
			PortletInfoVO portlet = ezNewPortalService.getCompanyPortletInfo(companyId, tenantId, portletId, portletLang);
			String boardId = portlet.getPortletBoardId();
			data.put("boardId", boardId);
			data.put("portletName", portlet.getPortletName());

			// 게시판 권한 체크
			boolean accessCheck = boardAuthCheck(boardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);
			if (!accessCheck) {
				data.put("access", "false");
				data.put("boardList", null);
				data.put("boardListTotalCnt", 0);
				data.put("currentPage", 1);
			} else {
				BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardId, info.getTenantId());
				String guBun = boardPropertyVO.getGuBun();
				// Q&A 의 일반 유저일 경우 일반 게시판과 다른 리스트
				boolean isQnANormal = "5".equals(guBun);
				if (isQnANormal) {
					// 관리자가 아니면 Q&A 게시판 로직으로 변경
					isQnANormal = !ezBoardService.isBoardAdmin(boardId, userId, deptId, companyId, tenantId, rollInfo);
				}

				// 권한이 true이면 boardList불러오기
				int boardListTotalCnt = ezNewPortalService.getBoardPortletTotalCnt(userId, tenantId, boardId, companyId, info.getOffset(), isQnANormal);
				
				int totalPages  = (boardListTotalCnt + itemCount - 1) / itemCount;
				currentPage = currentPage > totalPages ? totalPages : currentPage;
				currentPage = currentPage == 0         ? 1          : currentPage;
				int startRow  = (currentPage - 1) * itemCount;
				
				List<BoardListVO> boardList = ezNewPortalService.getBoardPortletInfo(userId, tenantId, boardId, itemCount, companyId, info.getOffset(), isQnANormal, startRow);
				
				// 리스트 개수로 utc time 적용시키기
				int boardListCount = boardList.size();
				for (int i = 0; i < boardListCount; i++) {
					BoardListVO boardListVO = boardList.get(i);
					String writeDate = boardListVO.getStartDate();
					
					boardListVO.setStartDate(commonUtil.getDateStringInUTC(writeDate, info.getOffset(), false));
					if (StringUtils.isNotBlank(boardListVO.getAttachments()) && "1".equals(boardListVO.getAttachments())) {
						Optional<BoardAttachVO> boardAttach = ezBoardService.getBoardAttachByName(boardListVO.getItemID(), fileName, tenantId);
						boardListVO.setThumbnail(boardAttach.map(BoardAttachVO::getFilePath).orElse(""));
					}
				}


				data.put("access", "true");
				data.put("boardList", boardList);
				data.put("boardListTotalCnt", boardListTotalCnt);
				data.put("currentPage", currentPage);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getBoardPortlet ended.");

		return result;
	}
	/**
	 * 포탈개인화 G/W [GET] 회사별 슬라이드 이미지 목록 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezportal/slideimages/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getSlideImages(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getSlideImages started.");
		JSONObject result = new JSONObject();
							
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
					
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			List<PersonalSliderImageVO> sliderList = ezNewPortalService.getSilderImages(userInfo.getCompanyID(), userInfo.getTenantId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", sliderList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("ezNewPortal G/W getSlideImages ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [POST] 슬라이드이미지 등록하기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezportal/slideimages/companies/{companyId:.+}", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	public JSONObject insertSlideImage(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W insertSlideImage started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String imageUrl = request.getParameter("imageUrl");
			String imagePath = request.getParameter("imagePath");
			String imageName = request.getParameter("imageName");
			
			ezNewPortalService.insertSlideImage(companyId, tenantId, imageUrl, imagePath, imageName, info.getUserId());
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "ok");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W insertSlideImage ended.");
		return result;
	}
	/**
	 * 포탈개인화 G/W [GET] 슬라이드이미지 정보 가져오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezportal/slideimages/{slideId}/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getSlideImageInfo(HttpServletRequest request, @PathVariable String companyId, @PathVariable String slideId) throws Exception {
		logger.debug("ezNewPortal G/W getSlideImageInfo started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			
			PersonalSliderImageVO slideInfo = ezNewPortalService.getSlideImageInfo(tenantId, companyId, slideId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", slideInfo);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getSlideImageInfo ended.");
		return result;
	}
	/**
	 * 포탈개인화 G/W [PUT] 슬라이드이미지 수정하기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezportal/slideimages/{slideId}/companies/{companyId:.+}", method = RequestMethod.PUT, produces = "application/json;charset=utf-8")
	public JSONObject updateSlideImage(HttpServletRequest request, @PathVariable String slideId, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W updateSlideImage started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String imageUrl = request.getParameter("imageUrl");
			String imagePath = request.getParameter("imagePath");
			String imageName = request.getParameter("imageName");
			
			ezNewPortalService.updateSlideImage(companyId, tenantId, imageUrl, imagePath, imageName, info.getUserId(), slideId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "ok");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateSlideImage ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [DELETE] 슬라이드이미지 삭제
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezportal/slideimages/{slideId}/companies/{companyId:.+}", method = RequestMethod.DELETE, produces = "application/json;charset=utf-8")
	public JSONObject deleteSlideImage(HttpServletRequest request, @PathVariable String companyId, @PathVariable String slideId) throws Exception {
		logger.debug("ezNewPortal G/W deleteSlideImage started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			
			ezNewPortalService.deleteSlideImage(tenantId, companyId, slideId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", "ok");
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W deleteSlideImage ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [PATCH] 슬라이드 이미지 순서 변경
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/slideimages/order/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateSlideOrder(HttpServletRequest request, @PathVariable String companyId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updateSlideOrder started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			JSONArray slideList = (JSONArray) jsonParam.get("slideList");
			
			ezNewPortalService.updateSlideOrder(slideList, companyId, userInfo.getTenantId());

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateSlideOrder ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [GET] 테마별 포틀릿 사용 유무 리스트 불러오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/portlets/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getThemePortletList(HttpServletRequest request, @PathVariable String companyId, @PathVariable int themeId) throws Exception {
		logger.debug("ezNewPortal G/W getThemePortletList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			String lang = userInfo.getLang();
			String webType = "";
			List<PortletInfoVO> themePortletList = ezNewPortalService.getThemePortletList(themeId, tenantId, companyId, lang);
			
			if (themePortletList == null || themePortletList.isEmpty()) {
				themePortletList = ezNewPortalService.getPortletList(companyId, tenantId, Integer.parseInt(lang), webType);
			}
			
			//1. tenant config가 NO인 경우 관리자 포틀릿 관리에서도 나오면 안됨
			//컨피그 : useQuestion(전자설문), useMemo(메모), useLadder(사다리게임), useCabinet(캐비닛), 
			//		 useBallotSystem(투표), USE_JOURNAL(업무일지), USE_CIRCULAR(회람판), USE_ATTITUDE(근태관리)
			//		 useWebfolder(웹폴더),  USE_ezPMS(프로젝트관리), USE_COMMUNITY(커뮤니티), useCar(차량관리)
			String useQuestion = ezCommonService.getTenantConfig("useQuestion", tenantId);
			String useMemo = ezCommonService.getTenantConfig("useMemo", tenantId);
			String useLadder = ezCommonService.getTenantConfig("useLadder", tenantId);
			String useCabinet = ezCommonService.getTenantConfig("useCabinet", tenantId);
			String useVote = ezCommonService.getTenantConfig("useBallotSystem", tenantId);
			String useJournal = ezCommonService.getTenantConfig("USE_JOURNAL", tenantId);
			String useCircular = ezCommonService.getTenantConfig("USE_CIRCULAR", tenantId);
			String useAttitude = ezCommonService.getTenantConfig("USE_ATTITUDE", tenantId);
			String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", tenantId);
			String useEzPMS = ezCommonService.getTenantConfig("USE_ezPMS", tenantId);
			String useCommunity = ezCommonService.getTenantConfig("USE_COMMUNITY", tenantId);
			String useCar = ezCommonService.getTenantConfig("useCar", tenantId);
			String useFixBoard = ezCommonService.getTenantConfig("useFixBoard", tenantId);

			if (useAttitude == null || useAttitude.equals("")) {
				useAttitude = "NO";
			}
			
			if (useMemo == null || useMemo.equals("")) {
				useMemo = "YES";
			}
			
			if (useLadder == null || useLadder.equals("")) {
				useLadder = "NO";
			}
			
			if (useCabinet == null || useCabinet.equals("")) {
				useCabinet = "NO";
			}
			
			if (useVote == null || useVote.equals("")) {
				useVote = "YES";
			}
			
			if (useJournal == null || useJournal.equals("")) {
				useJournal = "NO";
			}
			
			if (useCircular == null || useCircular.equals("")) {
				useCircular = "YES";
			}
			
			if (useQuestion == null || useQuestion.equals("")) {
				useQuestion = "NO";
			}
			
			if (useWebfolder == null || useWebfolder.equals("")) {
				useWebfolder = "NO";
			}
			
			if (useCommunity == null || useCommunity.equals("")) {
				useCommunity = "YES";
			}
			
			if (useEzPMS == null || useEzPMS.equals("")) {
				useEzPMS = "NO";
			}
			
			if (useCar == null || useCar.equals("")) {
				useCar = "NO";
			}

			if (StringUtils.isBlank(useFixBoard)) {
				useFixBoard = "YES";
			}

			if (useQuestion.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("question")));
			}
			
			if (useMemo.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("memo")));
			}
			
			if (useLadder.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("ladder")));
			}
			
			if (useCabinet.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("cabinet")));
			}
			
			if (useVote.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("vote")));
			}
			
			if (useJournal.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("journal")));
			}
			
			if (useCircular.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("circular")));
			}
			
			if (useAttitude.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("attitude")));
			}
			
			if (useWebfolder.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("webfolder")));
			}
			
			if (useEzPMS.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("pms")));
			}
			
			if (useCommunity.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("community")));
			}
			
			if (useCar.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getMenuCode() != null && vo.getMenuCode().equals("car")));
			}

			List<PortletInfoVO> fixBoardList = new ArrayList<>();
			themePortletList.forEach(vo -> {
				if (vo.isFixBoard()) {
					fixBoardList.add(vo);
				}
			});

			themePortletList.removeAll(fixBoardList);

			if ("YES".equals(useFixBoard)) {
				result.put("fixBoard", fixBoardList);
			}


			//인터넷 사용이 NO 인 경우에는 weather portlet사용 불가능
			String useInternet = config.getProperty("config.useInternet");
			
			if (useInternet.equals("NO")) {
				themePortletList.removeIf(vo -> (vo.getPortletCode() != null && vo.getPortletCode().equals("weather")));
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", themePortletList);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getThemePortletList ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [PATCH] 테마별 포틀릿 사용 유무 설정
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/portlets/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateThemePortletUsed(HttpServletRequest request, @PathVariable String companyId, @PathVariable int themeId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updateThemePortletUsed started.");
		JSONObject result = new JSONObject();

		try {
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			
			String serverName = request.getHeader("x-user-host");
			String userId = jsonParam.get("userId").toString();

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			boolean usePortletSize = "Y".equals(ezCommonService.getTenantConfig("usePortletSize", tenantId));

			JSONArray themePortletList = (JSONArray)jsonParam.get("themePortletList");
			JSONArray sizeList = (JSONArray)jsonParam.get("sizeList");
			String webType = jsonParam.get("webType").toString();

			ezNewPortalService.updateThemePortletUsed(themeId, tenantId, companyId, themePortletList);

			if (!webType.equals("mobile") && usePortletSize) {
				ezNewPortalService.updateThemePortletSize(themeId, tenantId, companyId, sizeList);
			}

			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W updateThemePortletUsed ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [GET] 직위직책 리스트 불러오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/authorities/titles/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getTitleList(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getTitleList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String type = request.getParameter("type");
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			
			List<OrganJobVO> titleList = ezNewPortalService.getTitleList(type, tenantId, companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", titleList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("ezNewPortal G/W getTitleList ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 웹폴더 포틀릿 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezportal/portlets/getWebFolderFileList", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getWebFolderFileList(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getWebFolderPortlet started.");
		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			int currentPage = Integer.parseInt(request.getParameter("currentPage")); // 1
			int listSize = Integer.parseInt(request.getParameter("listSize")); // 3 or 6
			
			int tenantId = info.getTenantId();
			JSONObject data = new JSONObject();
			
			String folderId = ezWebFolderService_y.folderIdByUserIdAndFolderType(userId, tenantId, "U");
			
			if (folderId == null || folderId.equals("")) {
				String webFolderUrl = "/rest/ezwebfolder/users/" + userId + "/checkRootFolder";
				// 웹폴더 아이디가 한 번도 발급되지 않은 사용자이면 발급할 수 있도록 api 호출
				JSONObject webFolderResultBody = commonUtil.getJsonFromRestApi(config.getProperty("config.webFolderGwServerURL"), webFolderUrl, null, request, "get", null);
				
				folderId = ezWebFolderService_y.folderIdByUserIdAndFolderType(userId, tenantId, "U");
			}
			
			int totalCnt = ezNewPortalService.getWebFolderFileListTotalCnt(folderId, tenantId);

			int totalPages  = (totalCnt + listSize - 1) / listSize;
			currentPage = currentPage > totalPages ? totalPages : currentPage;
			currentPage = currentPage == 0         ? 1          : currentPage;
			int startRow  = (currentPage - 1) * listSize;
			
			List<FileVO> webFolderFileList = ezNewPortalService.getWebFolderFileList(folderId, tenantId, startRow, listSize);
			
			data.put("fileList", webFolderFileList);
			data.put("folderId", folderId);
			data.put("totalCnt", totalCnt);
			data.put("currentPage", currentPage);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("ezNewPortal G/W getWebFolderPortlet ended.");
		return result;
	}

	//2019-06-18 테마별, 포틀릿별 권한 설정 개발
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/authorities/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getThemeAuth(HttpServletRequest request, @PathVariable String companyId, @PathVariable int themeId) throws Exception {
		logger.debug("ezNewPortal G/W getThemeAuth started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			String lang = commonUtil.getMultiData(userInfo.getLang(), tenantId);
			
			Map<String, Object> themeAuth = ezNewPortalService.getThemeAuth(companyId, tenantId, themeId, lang);
			JSONObject data = new JSONObject();
			
			data.put("themeAuthsY", themeAuth.get("themeAuthsY"));
			data.put("themeAuthsN", themeAuth.get("themeAuthsN"));
			
			result.put("data", data);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getThemeAuth ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/authorities/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updateThemeAuth(HttpServletRequest request, @PathVariable String companyId, @PathVariable int themeId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updateThemeAuth started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			JSONArray themeAuths = (JSONArray) jsonParam.get("themeAuths");
			int tenantId = userInfo.getTenantId();
			
			ezNewPortalService.updateThemeAuth(themeAuths, themeId, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("ezNewPortal G/W updateThemeAuth ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [GET] 권한그룹 리스트 불러오기
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menus/authorities/groups/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getGroupList(HttpServletRequest request, @PathVariable String companyId) throws Exception {
		logger.debug("ezNewPortal G/W getGroupList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			
			List<OrganGroupVO> groupList = ezNewPortalService.getGroupList(tenantId, companyId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", groupList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getGroupList ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/themes/{themeId}/authorities/checks/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject checkThemeAuthNoList(HttpServletRequest request, @PathVariable String companyId, @PathVariable int themeId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W checkThemeAuthNoList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			boolean totalCheck = true;
			String lang = userInfo.getLang();
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			JSONArray themeAuths = (JSONArray) jsonParam.get("themeAuths");
			
			for (Object item : themeAuths) {
				if (item instanceof JSONObject) {
					JSONObject themeAuth = (JSONObject) item;
					String authId = themeAuth.get("userId").toString();
					boolean checkThemeAuth = true;
					if (themeAuth.get("accessYN").toString().equals("false")) {
						if (themeAuth.get("userType").toString().equals("true")) {
							LoginVO authInfo = commonUtil.getUserForGw(authId, serverName);
							String deptPath = authInfo.getDeptPathCode();
							
							checkThemeAuth = ezNewPortalService.checkThemeAuthNoList(companyId, tenantId, authId, deptPath, themeId, lang);
							logger.debug("checkThemeAuth : " + checkThemeAuth + ", authId : " + authId + ", tenantId : " + tenantId + ", deptPath : " + deptPath);
						} else if (themeAuth.get("userType").toString().equals("false")) {
							String deptPath = ezOrganService.getDeptPath(authId, tenantId);
							checkThemeAuth = ezNewPortalService.checkThemeAuthNoList(companyId, tenantId, null, deptPath, themeId, lang);
							logger.debug("checkThemeAuth : " + checkThemeAuth + ", authId : " + authId + ", tenantId : " + tenantId + ", deptPath : " + deptPath);
						}
						
						if (!checkThemeAuth) {
							totalCheck = false;
							break;
						}
					}
					
				}
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", totalCheck);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W checkThemeAuthNoList ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/{portletId}/authorities/companies/{companyId:.+}", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPortletAuth(HttpServletRequest request, @PathVariable String companyId, @PathVariable int portletId) throws Exception {
		logger.debug("ezNewPortal G/W getPortletAuth started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			int tenantId = userInfo.getTenantId();
			String lang = commonUtil.getMultiData(userInfo.getLang(), tenantId);
			
			Map<String, Object> portletAuth = ezNewPortalService.getPortletAuth(companyId, tenantId, portletId, lang);

			JSONObject data = new JSONObject();
			
			data.put("portletAuthsY", portletAuth.get("portletAuthsY"));
			data.put("portletAuthsN", portletAuth.get("portletAuthsN"));
			
			result.put("data", data);
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getPortletAuth ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/portlets/{portletId}/authorities/companies/{companyId:.+}", method = RequestMethod.PATCH, produces = "application/json;charset=utf-8")
	public JSONObject updatePortletAuth(HttpServletRequest request, @PathVariable String companyId, @PathVariable int portletId, @RequestBody JSONObject jsonParam) throws Exception {
		logger.debug("ezNewPortal G/W updatePortletAuth started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");

			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			
			JSONParser jp = new JSONParser();
			jsonParam = (JSONObject) jp.parse(jsonParam.toJSONString());
			JSONArray portletAuths = (JSONArray) jsonParam.get("portletAuths");
			int tenantId = userInfo.getTenantId();
			
			ezNewPortalService.updatePortletAuth(portletAuths, portletId, companyId, tenantId);
			
			result.put("status", "ok");
			result.put("code", 0);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		
		logger.debug("ezNewPortal G/W updatePortletAuth ended.");
		return result;
	}
	
	// 2020-01-22 유은정  메뉴코드로 메뉴 권한 체크 관련 로직
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/admin/ezPortal/menu/access", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject checkMenuAuth(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W checkMenuAuth started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String menuCode = request.getParameter("menuCode");
			
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String[] menuArr = menuCode.split(",");
			
			ArrayList<String> menuCodeList = new ArrayList<>(Arrays.asList(menuArr));
			int tenantId = userInfo.getTenantId();
			String deptId = userInfo.getDeptID();
			String companyId = userInfo.getCompanyID();
			String lang = userInfo.getLang();
			
			Map<String, Boolean> menuAccess = commonUtil.checkMenuAccess(menuCodeList, companyId, tenantId, lang, userId, deptId);
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("menuAccess", menuAccess);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W checkMenuAuth ended.");
		return result;
	}

	/**
	 * 포탈개인화 G/W [GET] 포틀릿 - 탭 게시판 포틀릿 조회 - 박기범:2020/12/03
	*/
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/tabBoard", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getTabBoardPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getTabBoardPortlet started.");

		JSONObject result = new JSONObject();
		
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			deptPath = "everyone,top,Top," + deptPath + "," + userId;
			String rollInfo = info.getRollInfo();
			String portletLang = info.getLang();
			//회사의 존재하는 탭게시판 불러오기, 탭ID, boardid, boardname을 리턴한다.
			List<HashMap<String, Object>> tabBoardIdList = ezBoardService.getCompanyTabBoardIDList(companyId, tenantId);
			
			// 전송할 data
			JSONObject data = new JSONObject();
			JSONArray tabList = new JSONArray();
			if (tabBoardIdList.size() > 0) {
				data.put("existence" , "true");
				for (HashMap<String, Object> hashMap : tabBoardIdList) {
					String tabBoardId = hashMap.get("BOARDID").toString();
					// 2023-12-01 조소정 - 포탈 > 포틀릿 > 탭게시판 이름 사용자 설정 언어로 표출되도록 수정
					String tabBoardName;
					
					switch (portletLang) {
				    case "1":
				        tabBoardName = hashMap.get("BOARDNAME").toString();
				        break;
				    case "2":
				        tabBoardName = hashMap.get("BOARDNAME2").toString();
				        break;
				    case "3":
				        tabBoardName = hashMap.get("BOARDNAME3").toString();
				        break;
				    case "4":
				        tabBoardName = hashMap.get("BOARDNAME4").toString();
				        break;
				    default:
				    	tabBoardName = hashMap.get("BOARDNAME").toString();
					}
					
					// 탭게시판 권한 체크
					boolean accessCheckSub = boardAuthCheck(tabBoardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);
					
					if (accessCheckSub) {
						hashMap.put("BOARDNAME", tabBoardName);
						tabList.add(hashMap);
					}
					data.put("portletLang", portletLang);
				}
				data.put("tabList", tabList);
				
			} else {
				data.put("existence" , "false");
			}
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezNewPortal G/W getTabBoardPortlet ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/boardList", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getBoardList(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getBoardList started.");

		JSONObject result = new JSONObject();
		JSONObject data = new JSONObject();
		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			int tenantId = info.getTenantId();
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			deptPath = "everyone,top,Top," + deptPath + "," + userId;
			String rollInfo = info.getRollInfo();
			String boardId = request.getParameter("boardId");
			int listCnt = Integer.parseInt(request.getParameter("listCnt"));
			int currentPage = Integer.parseInt(request.getParameter("currentPage"));
					
			// 탭게시판 권한 체크
			boolean accessCheckSub = boardAuthCheck(boardId, deptPath, tenantId, companyId, deptId, userId, rollInfo);
			
			if (accessCheckSub) {
				BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardId, info.getTenantId());
				String guBun = boardPropertyVO.getGuBun();
				// Q&A 의 일반 유저일 경우 일반 게시판과 다른 리스트
				boolean isQnANormal = "5".equals(guBun);
				if (isQnANormal) {
					// 관리자가 아니면 Q&A 게시판 로직으로 변경
					isQnANormal = !ezBoardService.isBoardAdmin(boardId, userId, deptId, companyId, tenantId, rollInfo);
				}
				
				int totalCnt = ezNewPortalService.getBoardPortletTotalCnt(info.getUserId(), info.getTenantId(), boardId, info.getCompanyId(), info.getOffSet(), isQnANormal);
				int totalPages  = (totalCnt + listCnt - 1) / listCnt;
				currentPage = currentPage > totalPages ? totalPages : currentPage;
				currentPage = currentPage == 0         ? 1          : currentPage;
				int startRow  = (currentPage - 1) * listCnt;
				
				List<BoardListVO> boardList = ezNewPortalService.getBoardPortletInfo(info.getUserId(), info.getTenantId(),	boardId, listCnt, info.getCompanyId(), info.getOffSet(), isQnANormal, startRow);

				int boardListCount = boardList.size();

				for (int i = 0; i < boardListCount; i++) {
					String writeDate = boardList.get(i).getStartDate();
					boardList.get(i).setStartDate(commonUtil.getDateStringInUTC(writeDate, info.getOffSet(), false));
				}
				
				data.put("boardList", boardList);
				data.put("currentPage", currentPage);
				data.put("totalCnt", totalCnt);
				
			} else {
				data.put("boardList", null);
				data.put("currentPage", 1);
				data.put("totalCnt", 0);
			}
			
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("ezNewPortal G/W getBoardList ended.");
		return result;
	}
	
	/**
	 * 포탈개인화 G/W [GET] 2023-06-07 홍승비 - 테마2 > 상단 사용자 정보 영역 좌측 하단 > 회사별 공지사항 게시판 표출
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/theme2NotiBoardItemList", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getTheme2NotiBoardItemList(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getTheme2NotiBoardItemList started.");

		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String boardID = request.getParameter("boardID"); // 회사별 공지사항 게시판ID
			LoginVO info = commonUtil.getUserForGw(userId, serverName);
			String companyId = request.getParameter("companyId");
			String deptId = request.getParameter("deptId");
			String rollInfo = info.getRollInfo();
			int tenantId = info.getTenantId();
			String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
			deptPath = "everyone,top,Top," + deptPath + "," + userId;
			JSONObject data = new JSONObject();
			
			// 게시판 권한 체크
			boolean accessCheck = boardAuthCheck(boardID, deptPath, tenantId, companyId, deptId, userId, rollInfo);

			if (!accessCheck) {
				data.put("access", "false");
			} else {
				BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID, info.getTenantId());
				String guBun = boardPropertyVO.getGuBun();
				// Q&A 의 일반 유저일 경우 일반 게시판과 다른 리스트
				
				boolean isQnANormal = "5".equals(guBun);
				
				if (isQnANormal) {
					// 관리자가 아니면 Q&A 게시판 로직으로 변경
					isQnANormal = !ezBoardService.isBoardAdmin(boardID, userId, deptId, companyId, tenantId, rollInfo);
				}
				// 권한이 true이면 게시물 가져옴 (최대 3개)
				List<BoardListVO> boardList = ezNewPortalService.getBoardPortletInfo(userId, tenantId, boardID, 3, companyId, info.getOffset(), isQnANormal);
				
				// 리스트 개수로 utc time 적용
				int boardListCount = boardList.size();
				
				for (int i = 0; i < boardListCount; i++) {
					String writeDate = boardList.get(i).getStartDate();
					
					boardList.get(i).setStartDate(commonUtil.getDateStringInUTC(writeDate, info.getOffset(), false));
				}
				
				data.put("access", "true");
				data.put("boardList", boardList);
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", data);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getTheme2NotiBoardItemList ended.");

		return result;
	}

	/**
	 * 관리자>포탈>메뉴관리>권한설정 G/W [GET] 부서리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/admin/ezPortal/depts", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getDeptList(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getDeptList started.");

		JSONObject result = new JSONObject();

		try {
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);

			logger.debug("userId : " + userId);
			String companyId = request.getParameter("companyId");

			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			String lang = request.getParameter("lang") != null ? commonUtil.getMultiData(request.getParameter("lang"), info.getTenantId()) : commonUtil.getMultiData(info.getLang(), info.getTenantId());
			List<DeptViewVO> deptList = ezNewPortalService.getDeptViewList(userId, companyId, info.getTenantId(), lang);

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", deptList);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		logger.debug("ezNewPortal G/W getDeptList ended.");
		return result;
	}

	/**
	 * 관리자>포탈>메뉴관리>권한설정 G/W [GET] 사원리스트
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/admin/ezPortal/users", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getUserList(HttpServletRequest request) throws Exception {
		logger.debug("ezPortal G/W getUserList started.");

		JSONObject result = new JSONObject();

		try {
			String key = request.getParameter("key");
			String value = request.getParameter("value");
			String companyId = request.getParameter("companyId");
			String curPage = request.getParameter("curPage");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, request.getParameter("userId"));
			if (companyId == null || companyId.equals("")) {
				companyId = info.getCompanyId();
			}
			String lang = commonUtil.getMultiData(info.getLang(), info.getTenantId());

			List<MenuAuthorUserVO> userList = ezNewPortalService.getDeptUserList(info.getTenantId(), key, value, companyId, lang, curPage);
			int userCount = ezNewPortalService.getDeptUserListCount(info.getTenantId(), key, value, companyId, lang);

			// 하위부서 포함
			String containLow= ezCommonService.getTenantConfig("containLow", info.getTenantId());
			int totalCount2 = 0;

			if (containLow.equals("YES") && key.equals("DEPARTMENT")) {
				totalCount2 = ezOrganService.getMemberListCount2(value, null, totalCount2, containLow, info.getTenantId());
			}

			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", userList);
			result.put("totalCount", userCount);
			result.put("totalCount2", totalCount2);
			result.put("containLow", containLow);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		logger.debug("ezPortal G/W getUserList ended.");
		return result;
	}
	
	// [GET] 2024-05-17 한태훈 - 포탈 > 포탈 탑메뉴 위치 회사 설정값 불러오기
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/admin/ezNewPortal/company/topMenuMode", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getTopMenuDisplayModeForCompany(HttpServletRequest request) throws Exception {
		logger.debug("ezPortal G/W getTopMenuDisplayModeForCompany started.");

		JSONObject result = new JSONObject();
		try {
			String companyId = request.getParameter("companyId");
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			int topMenuDisplayMode = ezNewPortalService.getTopMenuDisplayModeForCompany(companyId, tenantId).orElse(TopFrameType.TOP).getCode();
			
			result.put("code", 0);
			result.put("status", "ok");
			result.put("data", topMenuDisplayMode);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		logger.debug("ezPortal G/W getTopMenuDisplayModeForCompany ended.");
		return result;
	}
	
	// [POST] 2024-05-17 한태훈 - 포탈 > 포탈 탑메뉴 위치 회사 설정값 수정
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/admin/ezNewPortal/company/topMenuMode", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject updateTopMenuDisplayModeForCompany(HttpServletRequest request) throws Exception {
		logger.debug("ezPortal G/W updateTopMenuDisplayModeForCompany started.");

		JSONObject result = new JSONObject();
		try {
			String companyId = request.getParameter("companyId");
			String userId = request.getParameter("userId");
			int type = Integer.parseInt(request.getParameter("type"));
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			ezNewPortalService.updateTopMenuDisplayModeForCompany(type, companyId, tenantId);
			
			result.put("code", 0);
			result.put("status", "ok");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		logger.debug("ezPortal G/W updateTopMenuDisplayModeForCompany ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezPortal/setMenuDisplayMode/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject setUserMenuDisplayMode(HttpServletRequest request, @PathVariable String userId) throws Exception {
		logger.debug("ezPortal G/W setUserMenuDisplayMode started.");

		JSONObject result = new JSONObject();
		try {
			String companyId = request.getParameter("companyId");
			int menuDisplayMode = Integer.parseInt(request.getParameter("menuDisplayMode"));
			
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			ezNewPortalService.insertPortalTopFrameInfo(userId, companyId, tenantId, TopFrameType.fromCode(menuDisplayMode));
			
			result.put("code", 0);
			result.put("status", "ok");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("ezPortal G/W setUserMenuDisplayMode ended.");
		return result;
	}
	
	/**
	 * 포탈 G/W [GET] 포틀릿 - 연계 포틀릿 정보 조회
	 */
	@RequestMapping(value = "/rest/ezPortal/portlets/connect/list", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getConnectPortlet(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getConnectPortlet started.");

		String serverName = request.getHeader("x-user-host");
		String userId = request.getParameter("userId");
		String companyId = request.getParameter("companyId");
		String deptId = request.getParameter("deptId");
		int currentPage = Integer.parseInt((String)request.getParameter("currentPage"));
		int listCnt = Integer.parseInt(request.getParameter("listCnt"));
		MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
		int tenantId = info.getTenantId();
		int portletId = Integer.parseInt(request.getParameter("portletId")); // 포토게시판의
		if (deptId == null || deptId.equals("")) {
			deptId = info.getDeptId();
		}
		
		SystemConfigVO systemConfig = ezNewPortalService.getSystemConfig(portletId, companyId, tenantId);
		ConnectPortletDTO connectPortletDTO = new ConnectPortletDTO();
		connectPortletDTO.setUserId(userId);
		connectPortletDTO.setDeptId(deptId);
		connectPortletDTO.setCompanyId(companyId);
		connectPortletDTO.setSystemConfig(systemConfig);
		connectPortletDTO.setRequest(request);
		connectPortletDTO.setCurrentPage(currentPage);
		connectPortletDTO.setListCnt(listCnt);
		connectPortletDTO.setTenantId(tenantId);
		connectPortletDTO.setPortletId(portletId);
		JSONObject resultData = ezNewPortalService.getConnectPortletData(connectPortletDTO);
		
		logger.debug("ezNewPortal G/W getConnectPortlet ended.");

		return resultData;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/admin/ezPortal/company/systemconfig", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject setUserMenuDisplayMode(HttpServletRequest request) throws Exception {
		logger.debug("ezPortal G/W setUserMenuDisplayMode started.");

		JSONObject result = new JSONObject();
		try {
			String companyId = request.getParameter("companyId");
			String userId = request.getParameter("userId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			List<SystemConfigTypeVO> configTypeList = ezSystemAdminService.getSystemConfigTypeListNotXml("", commonUtil.getMinuteUTC(info.getOffSet()), 0, 0, "ALL", companyId, info.getTenantId());
			
			result.put("code", 0);
			result.put("status", "ok");
			result.put("data", configTypeList);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("ezPortal G/W setUserMenuDisplayMode ended.");
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/rest/ezPortal/colorMode/{useColor}/users/{userId:.+}", method= RequestMethod.POST, produces="application/json;charset=UTF-8")
	public JSONObject setUserColorMode(HttpServletRequest request,@PathVariable int useColor, @PathVariable String userId) throws Exception {
		logger.debug("ezPortal G/W setUserColorMode started.");

		JSONObject result = new JSONObject();
		try {
			String companyId = request.getParameter("companyId");
			String serverName = request.getHeader("x-user-host");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			int tenantId = info.getTenantId();
			
			ezNewPortalService.setUserColorMode(userId, tenantId, companyId, useColor);
			
			result.put("code", 0);
			result.put("status", "ok");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}
		
		logger.debug("ezPortal G/W setUserColorMode ended.");
		return result;
	}
		
	/*
	 * 사이트용 포탈 전자결재 카운트 연계 API
	 */
	@CrossOrigin(origins = "*")
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/ezPortal/portlets/approvalCount", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Result getPortalApprovalCount(HttpServletRequest request, Locale locale) throws Exception {
		logger.debug("ezNewPortal G/W getPortalApprovalCount started.");

		Result result;

		try {

			String host = request.getHeader("host");
			String serverName = "";
			if ( host.contains(":") ) {
				serverName = host.split(":")[0];
			} else {
				serverName = host;
			}

			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			String companyId = info.getCompanyID();
			int tenantId = info.getTenantId();
			String portletLang = info.getLang();
			String deptId = Optional.ofNullable(request.getParameter("deptId")).map(String::toString).orElse(info.getDeptID());
			deptId = deptId.toLowerCase();

			String offset = info.getOffset();
			Calendar cal = Calendar.getInstance();

			SimpleDateFormat adf = new SimpleDateFormat("yyyy-MM-dd");
			String nowDate = adf.format(cal.getTime());
			String offsetMin = commonUtil.getMinuteUTC(info.getOffset());
			String userEmail = userId + "@" + ezCommonService.getTenantConfig("DomainName", tenantId);
			String password = jspw;
			logger.debug("userId : " + userId + ", companyId : " + companyId + ", tenantId : " + tenantId);

			JSONObject data = new JSONObject();


			String approvalCountStr = "";
			String approvalProgressingCountStr = "";
			String approvalDeptSusinCountStr = "";
			String approvalGongRamCountStr = "";
			String approvalMobileCountStr = "";
			String approvalBalsongDaegiCountStr = "";

			String susinAdmin = "user";
			String nowDateTime = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, true);

			if (info.getRollInfo() != null && info.getRollInfo().indexOf("a=1") > -1 || ezOrganService.isProxyUser(info.getTenantId(), userId, nowDateTime).equals("1")) {
				susinAdmin = "admin";
			}
			String approvalTotalCount = ezApprovalGSerivce.getWebPartList("1", userId, deptId, "", "LEFT", susinAdmin, companyId, portletLang, tenantId, offset);
			logger.debug("approvalTotalCount : " + approvalTotalCount);

			Document docXML = commonUtil.convertStringToDocument(approvalTotalCount);

			for (int k = 0; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
				if (k==0) {
					approvalCountStr = docXML.getElementsByTagName("COUNT1").item(0).getTextContent();
				} else if (k==1) {
					approvalProgressingCountStr = docXML.getElementsByTagName("COUNT2").item(0).getTextContent();
				} else if (k==2) {
					approvalDeptSusinCountStr = docXML.getElementsByTagName("COUNT4").item(0).getTextContent();
				} else if (k==3) { //쿼리 변경으로 추가함
					approvalGongRamCountStr = docXML.getElementsByTagName("COUNT99").item(0).getTextContent();
				} else if (k>5) {
					break;
				}
			}
			logger.debug("approvalCountStr : " + approvalCountStr + " / approvalProgressingCountStr : " + approvalProgressingCountStr + " / approvalDeptSusinCountStr : " + approvalDeptSusinCountStr + " / approvalGongRamCountStr : " + approvalGongRamCountStr);
			// 2020-12-03 이혁진 포틀릿에 있는 결재할 문서 숫자 대결자로 지정되었을때 숫자 반영하게 변경
			String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantId);
			String lang = portletLang;
			//int approvalCount = ezNewPortalService.getApprovalDoingListCount(userId, companyId, tenantId, info.getOffSet(), approvalFlag, lang);
			int approvalCount = Integer.parseInt(approvalCountStr);
			int approvalProgressingCount = Integer.parseInt(approvalProgressingCountStr);
			int approvalDeptSusinCount = Integer.parseInt(approvalDeptSusinCountStr);
			int approvalGongRamCount = Integer.parseInt(approvalGongRamCountStr);

			data.put("approvalCount", approvalCount); // 미결
			data.put("approvalProgressingCount", approvalProgressingCount); //진행
			data.put("approvalDeptSusinCount", approvalDeptSusinCount); //접수
			data.put("approvalGongRamCount", approvalGongRamCount); //공람

			result = Result.success(data);
		} catch (Exception e) {
			result = Result.failure();
			e.printStackTrace();
		}
		logger.debug("ezNewPortal G/W getPortalApprovalCount ended.");
		return result;
	}
	
	/**
	 * 사이트용 포탈 전자결재 리스트 연계 API(결재할 문서, 결재진행 문서, 결재완료 문서)
	 */
	@CrossOrigin(origins = "*")
	@RequestMapping(value = "/rest/ezPortal/portlets/approvalLists", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Result getPortalApprovalList(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getPortalApprovalList started.");
		Result result;

		try {
			String host = request.getHeader("host");
			String serverName = "";
			if ( host.contains(":") ) {
				serverName = host.split(":")[0];
			} else {
				serverName = host;
			}

			String userId = request.getParameter("userId");
			LoginVO info = commonUtil.getUserForGw(userId, serverName);

			String type = request.getParameter("type");
			String deptId = Optional.ofNullable(request.getParameter("deptId")).map(String::toString).orElse(info.getDeptID());
			deptId = deptId.toLowerCase();
			info.setDeptID(deptId);
			info.setServerName(serverName);

			PortletAprInfoVO portletAprInfoVO = new PortletAprInfoVO();
			portletAprInfoVO.setListType(type);
			portletAprInfoVO.setDeptID(deptId);
			portletAprInfoVO.setUserInfo(info);
			portletAprInfoVO.setUrl(serverName);

			JSONArray portalApprovalList = ezNewPortalService.getPortalApprovalList(portletAprInfoVO);

			result = Result.success(portalApprovalList);
		} catch (Exception e) {
			result = Result.failure();
			e.printStackTrace();
		}
		logger.debug("ezNewPortal G/W getPortalApprovalList ended.");
		return result;
	}
	
	/**
	 * 사이트용 포탈 게시물 리스트 연계 API
	 */
	@SuppressWarnings("unchecked")
	@CrossOrigin(origins = "*")
	@RequestMapping(value = "/rest/ezBoard/boardItemList", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public Result getBoardItemList(HttpServletRequest request) throws Exception {
		logger.debug("rest getBoardItemList started.");
		Result result;

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			String bId = request.getParameter("bId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String offset = info.getOffSet();
			
			bId = new String(Base64.getDecoder().decode(bId));
			String itemIDEncode = "";
			String boardIDEncode = "";
			
			List<HashMap<String, Object>> boardTopItemList = ezBoardService.getNoticePostItemList(bId, userId, 1, 10, 0, "", "", "1", 0);			
			List<HashMap<String, Object>> boardItemList = ezBoardService.getBoardListItem(bId, userId, 1, 10, 0, "", "", new HashMap<String, String>(), "1", 0);

			JSONArray ja = new JSONArray();			
			int added = 0;
			JSONObject jo = null;
			
			if ( 0 < boardTopItemList.size() ) {
				
				BigInteger readFlagDate = new BigInteger("202305161830");
				
				for ( int i = 0; i < boardTopItemList.size(); i++ ) {
					HashMap<String, Object> item = boardTopItemList.get(i);					
					jo = new JSONObject();
					jo.put("Top", 1);
					
					jo.put("title", (String) item.get("TITLE"));
					jo.put("writerName", (String) item.get("WRITERNAME"));

					String writeDate = commonUtil.getDateStringInUTC((String) item.get("WRITEDATE"), offset, false);
					jo.put("writeDate", writeDate);
					
					String itemID = item.get("ITEMID").toString();
					itemIDEncode = URLEncoder.encode(itemID, "utf-8");
					boardIDEncode = URLEncoder.encode(bId, "utf-8");
					
					String url = "/ezBoard/boardItemView.do?itemID=" + itemIDEncode + "&boardID=" + boardIDEncode + "&location=GENERAL";
					String urlSSO = commonUtil.makeSSOUrl(url, 0);
					jo.put("boardItemUrl", urlSSO);
					jo.put("itemId", (String) item.get("ITEMID"));

					if (null != writeDate) {
						String writeYMDHM = writeDate.replaceAll(" ", "").replaceAll("-", "").replaceAll(":", "")
								.substring(0, 12);
						if (0 <= new BigInteger(writeYMDHM).compareTo(readFlagDate)) {
							jo.put("readFlag", item.get("READFLAG").toString());
						} else {
							jo.put("readFlag", "1");
						}
					} else {
						jo.put("readFlag", "1");
					}

					ja.add(jo);
					
					added += 1;
				}
			}
			
			if ( 0 < boardItemList.size() ) {
				
				for ( int i = 0; i < boardItemList.size(); i++ ) {
					if (added >= 10) {
						break;
					}
					
					HashMap<String, Object> item = boardItemList.get(i);					

					jo = new JSONObject();						
						
					jo.put("Top", 0);

					jo.put("title", (String) item.get("TITLE"));
					jo.put("writerName", (String) item.get("WRITERNAME"));

					String writeDate = commonUtil.getDateStringInUTC((String) item.get("WRITEDATE"), offset, false);
					jo.put("writeDate", writeDate);

					String itemID = item.get("ITEMID").toString();
					itemIDEncode = URLEncoder.encode(itemID, "utf-8");
					boardIDEncode = URLEncoder.encode(bId, "utf-8");
					
					String url = "/ezBoard/boardItemView.do?itemID=" + itemIDEncode + "&boardID=" + boardIDEncode + "&location=GENERAL";
					String urlSSO = commonUtil.makeSSOUrl(url, 0);
					jo.put("boardItemUrl", urlSSO);
					jo.put("itemId", (String) item.get("ITEMID"));

					ja.add(jo);
					added += 1;					
				}
			}
			result = Result.success(ja);
		} catch (Exception e) {
			result = Result.failure();
			e.printStackTrace();
		}
		
		logger.debug("rest getBoardItemList ended.");
		return result;
	}
	
	/**
	 * 사이트용 - 포탈개인화 G/W [GET] 포틀릿 - 일정관리 리스트
	 */
	@CrossOrigin(origins = "*")
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/rest/portlets/ezSchedule/scheduleList", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	public JSONObject getPortletScheduleList(HttpServletRequest request) throws Exception {
		logger.debug("ezNewPortal G/W getPortletScheduleList started.");
		JSONObject result = new JSONObject();

		try {
			String serverName = request.getHeader("x-user-host");
			String userId = request.getParameter("userId");
			MCommonVO info = mOptionService.commonInfoWeb(serverName, userId);
			
			String offset = info.getOffSet();
			String offSetMin = commonUtil.getMinuteUTC(offset);
			
			String startDate = request.getParameter("selectDate");
			String endDate = request.getParameter("selectDate");
			String idList = (request.getParameter("IDLIST") == null || request.getParameter("IDLIST").equals("")) ? "T" : request.getParameter("IDLIST");
			String deptId = Optional.ofNullable(request.getParameter("deptId")).orElse(info.getDeptId());
			String companyId = info.getCompanyId();
			
			String indiList = "";
			String pidList = "";
			String pidListSub = "";
			String indiListSub = "";
			
			if(startDate != null && !startDate.equals("")) {
				String[] sDate = startDate.split("-");
				String sMon = (sDate[1].length() == 1 ? "0" + sDate[1] : sDate[1]);
				String sDay = (sDate[2].length() == 1 ? "0" + sDate[2] : sDate[2]);
				
				startDate = sDate[0] + "-" + sMon + "-" + sDay + " 00:00:00";
			}
			
			if(endDate != null && !endDate.equals("")) {
				String[] eDate = endDate.split("-");		
				String eMon = (eDate[1].length() == 1 ? "0" + eDate[1] : eDate[1]);
				String eDay = (eDate[2].length() == 1 ? "0" + eDate[2] : eDate[2]);
				
				endDate = eDate[0] + "-" + eMon + "-" + eDay  + " 23:59:59";
			}
			
			String utcStartTime = commonUtil.getDateStringInUTC(startDate, offset, true);
			String utcEndTime = commonUtil.getDateStringInUTC(endDate, offset, true);
			
			String lang = info.getPrimary();
			int tenantId = info.getTenantId();
			//2020-02-24 김정언
			String useAnnualScheduleYN = ezCommonService.getTenantConfig("useAnnualScheduleYN", tenantId);
			
			List<ScheduleSecretaryVO> tList = ezScheduleService.getPublicScheduleSec(userId, lang, tenantId ,companyId);
			List<ScheduleDeptVO> dList = ezScheduleService.getPublicScheduleDept(userId, lang, tenantId ,companyId);
			List<ScheduleCumulerVO> cList = ezScheduleService.getPublicScheduleCumuler(userId, lang, tenantId, companyId);
			List<ScheduleGroupListVO> gList = ezScheduleService.getScheduleGroupList(userId, info.getTenantId() ,companyId);
			
			if (idList == null) {
				idList = "";
			}
			
			//2018-06-08 구해안 T인 경우를 제외하고 나머지는 id값 그대로 가공해서 넘기기
			if (idList.equals("T") || idList.equals("")) {
				indiList = "'" + userId + "'";
				
				if(tList != null && tList.size()>0){
					for (int i = 0; i < tList.size(); i++) {
						if (i == 0) {
							indiListSub += ",";
						}			
						ScheduleSecretaryVO data = tList.get(i);			
						indiListSub += "\'" + data.getSecId()+ "\',";			
					}				
				}
				
				pidList = "'" + deptId + "'," + "'" + companyId + "'";
				
				
				if(dList != null && dList.size()>0){
					for (int i = 0; i < dList.size(); i++) {
						if(tList == null || tList.size()<=0){
							if (i == 0) {
								pidListSub += ",";
							}	
						}
						ScheduleDeptVO data = dList.get(i);			
						pidListSub += "\'" + data.getDeptId()+ "\',";				
					}				
				}
				
				if(cList != null && cList.size()>0 ){
					for (int i = 0; i < cList.size(); i++) {							
						if(dList == null || dList.size()<=0){
							if (i == 0) {
								pidListSub += ",";
							}	
						}
						ScheduleCumulerVO data = cList.get(i);			
						pidListSub += "\'" + data.getDeptId()+ "\',";				
					}				
				}
				
				for (int i = 0; i < gList.size(); i++) {
					if((dList == null || dList.size()<=0) && (cList == null || cList.size()<=0)){
						if (i == 0) {
							pidListSub += ",";
						}
					}
						ScheduleGroupListVO data = gList.get(i);			
						pidListSub += "\'" + data.getGroupId() + "\',";
					}
				
				if(indiListSub == null || indiListSub.equals("")){
					indiListSub = ",\'\'";
				}else{				
					indiListSub = indiListSub.substring(0, indiListSub.length()-1);
				}
				
				indiList += indiListSub;
				
				if(pidListSub == null || pidListSub.equals("")){
					pidListSub = ",\'\'";
				}else{				
					pidListSub = pidListSub.substring(0, pidListSub.length()-1);
				}
				
				if (pidList != null && pidListSub != null && pidListSub.substring(0,1) != ",") {
					pidList += ",\'\'";
				}
				
				pidList += pidListSub;
				
			} else if(idList.equals("chkAllFalse")) {
				indiList = "";
				pidList = "\'\'";
			} else if (idList.equals("P")) {
				indiList = "'" + userId + "'";
				pidList = "";
			}else {
				pidList = idList;
			}		
			
			List<ScheduleInfoVO> sList = ezScheduleService.getScheduleList(indiList, pidList, "", utcStartTime, utcEndTime, startDate, endDate, offSetMin, "", "", "", tenantId, companyId, userId, deptId, useAnnualScheduleYN);		
			
			// 구글연동 일정 가져오기(포탈 일정포틀릿)
			LoginVO userInfo = commonUtil.getUserForGw(userId, serverName);
			String useGoogleCalendar = ezCommonService.getTenantConfig("useGoogleCalendar", userInfo.getTenantId());
			if(useGoogleCalendar.equals("YES")) {
				List<ScheduleInfoVO> googleList = googleService.getGoogleScheduleList(startDate, endDate, "", userInfo, userInfo.getId(), "member", userInfo.getDisplayName());		
				sList.addAll(googleList);
			}
			
			Collections.sort(sList, new EzScheduleCompareUtil());
			
			JSONArray jsonArray = new JSONArray();
			String scheduletType = "";
			String scheduleDate = "";
			for (ScheduleInfoVO scheduleInfoVO : sList) {
				JSONObject jsonObject = new JSONObject();
				jsonObject.put("createrName", scheduleInfoVO.getCreatorName());
				jsonObject.put("title", scheduleInfoVO.getTitle());
				jsonObject.put("startDate", scheduleInfoVO.getStartDate());
				jsonObject.put("endDate", scheduleInfoVO.getEndDate());
				
				switch (scheduleInfoVO.getScheduleType()) {
				case "1":
					scheduletType = "개인일정";
					break;
				case "2":
					scheduletType = "부서일정";
					break;
				case "3":
					scheduletType = "회사일정";
					break;
				case "7":
					scheduletType = "그룹일정";
					break;
				default:
					scheduletType = "일정";
					break;
				}
				
				jsonObject.put("type", scheduletType);
				scheduleDate = (scheduleInfoVO.getStartDate()).split(" ")[0];
				
				String url = "/ezSchedule/scheduleRead.do?id=" + scheduleInfoVO.getScheduleId() + "&type=" + scheduleInfoVO.getScheduleType() + 
						"&datetype=" + scheduleInfoVO.getDateType() + "&repeatcount=" + scheduleInfoVO.getRepeatCount() + "&date=" + scheduleDate + "&pattern=0";
				String urlSSO = commonUtil.makeSSOUrl(url, 0);
				jsonObject.put("scheduleUrl", urlSSO);
				
				jsonArray.add(jsonObject);
			}
			
			logger.debug("status: OK / sList size : {}", jsonArray.size());
			result.put("status", "ok");
			result.put("code", 0);
			result.put("data", jsonArray);
		} catch (Exception e) {
			result.put("status", "error");
			result.put("code", 1);
			result.put("data", "");
		}
		logger.debug("ezNewPortal G/W getPortletScheduleList ended.");
		return result;
	}

	@RequestMapping(value="/rest/ezPortal/portlets/unreadMailCount", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject getUnreadMailCount(HttpServletRequest request) throws Exception {
		logger.debug("ezPortal G/W getUnreadMailCount started.");

		JSONObject result = new JSONObject();
		try {
			String userEmail = request.getParameter("userEmail");
			String password = request.getParameter("password");
			String locale = request.getHeader("locale") != null ? request.getHeader("locale") : "";

			int unreadMailCount = 0;
			IMAPAccess ia = null;
			String folderName = "INBOX";

			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"), userEmail, password, egovMessageSource, Locale.forLanguageTag(locale), ezEmailUtil);
				unreadMailCount = ia.getUnreadCount(folderName);
				logger.debug("getUnreadMailCount unreadMailCount = " + unreadMailCount);
			} catch (Exception e) {
				logger.debug("e.message=" + e.getMessage());
			} finally {
				if (ia != null) {
					ia.close();
				}
			}

			result.put("code", 0);
			result.put("status", "ok");
			result.put("unreadMailCount", unreadMailCount);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		logger.debug("ezPortal G/W getUnreadMailCount ended.");
		return result;
	}


	@RequestMapping(value="/rest/ezPortal/portlets/mailGetUse", method= RequestMethod.GET, produces="application/json;charset=UTF-8")
	public JSONObject portalMailGetUse(HttpServletRequest request) throws Exception {
		logger.debug("ezPortal G/W mailGetUse started.");

		JSONObject result = new JSONObject();

		try {
			String userEmail = request.getParameter("userEmail");
			String password = request.getParameter("password");
			String locale = request.getHeader("locale") != null ? request.getHeader("locale") : "";

			IMAPAccess ia = null;
			int mailPercent = 0;
			String mailboxDetail = "";
			String mailboxQuotaStr = "";

			try {
				ia = IMAPAccess.getInstance(config.getProperty("config.MailServerAddress"), config.getProperty("config.IMAPPort"),
						userEmail, password, egovMessageSource, Locale.forLanguageTag(locale), ezEmailUtil);

				long[] storageUsageAndLimit = ia.getStorageUsageAndLimit();

				double mailboxUsage = storageUsageAndLimit[0]; // in KBs
				double mailboxQuota = storageUsageAndLimit[1]; // in KBs

				// 재은 수정
				String[] mailUse = ezEmailUtil.getMailUsage(mailboxUsage, mailboxQuota);

				if (mailUse != null) {
					mailPercent = Integer.parseInt(mailUse[0]);
					mailboxDetail = mailUse[1];
					mailboxQuotaStr = mailUse[2];
				}

				logger.debug("mailPercent=" + mailPercent + ",mailboxDetail=" + mailboxDetail + ",mailboxQuotaStr=" + mailboxQuotaStr);

			} catch (Exception e) {
				logger.debug(e.getMessage());
				logger.error(e.getMessage(), e);
			} finally {
				if (ia != null) {
					ia.close();
				}
			}

			StringBuilder sb = new StringBuilder("<DATA>");
			sb.append("<ROW>");
			sb.append(String.format("<QUOTA>%s</QUOTA>", mailboxQuotaStr));
			sb.append(String.format("<DETAIL>%s</DETAIL>", mailboxDetail));
			sb.append(String.format("<PERCENT>%d</PERCENT>", mailPercent));
			sb.append(String.format("<BAR1>%d</BAR1>", mailPercent * 2));
			sb.append(String.format("<BAR2>%d</BAR2>", 211 - mailPercent * 2));
			sb.append("</ROW>");
			sb.append("</DATA>");

			logger.debug("returnData=" + sb.toString());

			result.put("code", 0);
			result.put("status", "ok");
			result.put("data", sb.toString());
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			result.put("code", 1);
			result.put("status", "error");
			result.put("data", "");
		}

		logger.debug("ezPortal G/W mailGetUse ended.");
		return result;
	}
}
