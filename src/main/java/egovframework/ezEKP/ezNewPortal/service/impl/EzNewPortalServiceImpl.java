package egovframework.ezEKP.ezNewPortal.service.impl;

import java.io.File;
import java.io.InputStreamReader;
import java.lang.reflect.Field;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.Optional;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import egovframework.ezEKP.ezApprovalG.vo.ApprGProxyVO;
import egovframework.ezEKP.ezApprovalG.vo.PortletAprInfoVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserSwitchVO;
import egovframework.ezEKP.ezNewPortal.vo.QuickLinkVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuAuthorUserVO;
import egovframework.ezEKP.ezNewPortal.vo.ConnectPortletDTO;
import egovframework.ezEKP.ezNewPortal.vo.DeptViewVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserSwitchVO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezNewPortal.vo.PortalTopVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalTopVO.TopFrameType;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.client.ClientHttpRequestFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.ibm.icu.util.Calendar;
import com.ibm.icu.util.ChineseCalendar;

import egovframework.ezEKP.ezBoard.dao.EzBoardDAO;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.type.PortletAprListType;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezNewPortal.dao.EzNewPortalDAO;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.FrameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuAuthVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuNameVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalBoardTreeVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalLogoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletAuthVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletNameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeAuthVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezNewPortal.vo.WeatherVO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganGroupVO;
import egovframework.ezEKP.ezOrgan.vo.OrganJobVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzNewPortalService")
public class EzNewPortalServiceImpl implements EzNewPortalService {
	private static final Logger logger = LoggerFactory.getLogger(EzNewPortalServiceImpl.class);
	
	@Resource(name = "EzNewPortalDAO")
	private EzNewPortalDAO ezNewPortalDAO;

	@Autowired
	private EzCommonService ezCommonService;

	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzApprovalGService ezApprovalGService;

	@Autowired
	private EzOrganDAO ezOrganDAO;

	@Resource(name  ="EzOrganAdminDAO")
	private EzOrganAdminDAO ezOrganAdminDAO;
	
	@Resource(name = "EzBoardDAO")
	private EzBoardDAO ezBoardDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name  ="EzApprovalGDAO")
	private EzApprovalGDAO ezApprovalGDAO;
	
	// public List<BoardListVO> getNoticePortletList(String companyId, int tenantId, int limit, String offset, String lang) throws Exception {
	public List<BoardListVO> getNoticePortletList(String companyId, int tenantId, String offset, String lang, int currentPage, int listCntSize, int portletId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String nowDate = commonUtil.getTodayUTCTime("");
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
//		map.put("limit", limit);
		map.put("portletId", portletId); // 공지사항 포틀릿 ID 는 2
		map.put("nowDate", nowDate);
		
		if (!lang.equals("1")) {
			map.put("lang", "2");
		}
		
		map.put("startRow", (currentPage - 1) * listCntSize);
		map.put("listCount", listCntSize);
		List<BoardListVO> notiList = ezNewPortalDAO.getNoticePortletList(map);

		return notiList;
	}
	@Override
	public PersonalLightPollVO getPollPortlet(String companyId, int tenantId, String userId, String offset) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		/* 2023-01-17 전인하 - 빠른설문 > DB에 들어가는 값이 UTC 시간으로 변경됨에 따라 비교조건도 UTC 시간으로 수정 */
		String nowDate = commonUtil.getTodayUTCTime("");
		// 2018-11-23 황윤호 offset 적용
		// String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("nowDate", nowDate);

		return ezNewPortalDAO.getPollPortlet(map);
	}
	
	public List<PersonalLightPollVO> getPollPortletResult(String companyId, int tenantId, int itemSeq) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("itemSeq", itemSeq);
		
		return ezNewPortalDAO.getPollPortletResult(map);
	}
	
	public List<Map<String, Object>> getAssemblePollData(PersonalLightPollVO poll, List<PersonalLightPollVO> pollResult) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> answerList = new ArrayList<Map<String, Object>>();
		
		Field[] fields = poll.getClass().getDeclaredFields();
		for(int i=0; i<fields.length; i++) {
			fields[i].setAccessible(true);
			try {
				if (fields[i].getName().contains("answer")) {;
					map.put(fields[i].getName(), fields[i].get(poll));
				}
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
		
		for(int i=1; i<=map.size(); i++) {
			Map<String, Object> answerMap = new HashMap<String, Object>();
			answerMap.put("result", i);
			answerMap.put("answer", map.get("answer"+(i)));
			
			Iterator<PersonalLightPollVO> it = pollResult.iterator();
			while (it.hasNext()) {
				PersonalLightPollVO vo = it.next();
				int result = vo.getResult();
				if(result == i) {
					answerMap.put("count", vo.getCount());
				}
			}
			
			answerList.add(answerMap);								
		}
		
		return answerList;
	}
	
	public String getPortalLogoInfo(String companyId, int tenantId, String logoType) throws Exception {
		logger.debug("[Service] getPortalLogoInfo started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("logoType", logoType);
		logger.debug("[Service] getPortalLogoInfo ended");
		return ezNewPortalDAO.getPortalLogoInfo(map);
	}
	
	public List<MenuInfoVO> getUserMenuList(String companyId, int tenantId, String langType, String userId, String deptId) throws Exception {
		logger.debug("[Service] getUserMenuList started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("langType", langType);
		map.put("userId", userId);
		map.put("deptId", "");
		
		/**
		 * 2018-11-21 신규작성
		 */
		
		String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
		
		//path 거꾸로 돌려야해서
		List<String> deptIds = Arrays.asList(deptPath.split(","));
		Collections.reverse(deptIds);
		
		//유저권한체크
		map.put("userType", "USER");
		List<MenuInfoVO> result = ezNewPortalDAO.getMenuForUser(map);
		
		//전체체크필요없어서 id만
		List<Integer> menuIds = new ArrayList<Integer>();
		
		for (MenuInfoVO vo : result) {
			menuIds.add(vo.getMenuId());
		}
		
		result.removeIf(vo -> !vo.isAccessYN());
		
		// 직위 직책 체크
		map.put("userType", "PERMISSION");
		List<MenuInfoVO> permissionResult = ezNewPortalDAO.getMenuForUser(map);
		
		for (MenuInfoVO permissionMenu : permissionResult) {
			int menuId = permissionMenu.getMenuId();
			
			if (menuIds.indexOf(menuId) == -1) {
				menuIds.add(menuId);
				
				if (permissionMenu.isAccessYN()) {
					result.add(permissionMenu);
				}
			}
		}
		
		//부서 및 상위부서권한체크(유저 나 하위부서에서 권한체크걸린건 추가안함
		List<MenuInfoVO> deptResult = null;
		map.put("userType", "DEPT");
		for(String pathId : deptIds) {
			map.put("deptId", pathId);
			
			if (pathId.equals(deptId)) {
				map.put("isUserDept", true);
			} else {
				map.put("isUserDept", false);
			}
			
			deptResult = ezNewPortalDAO.getMenuForUser(map);
			
			//권한잇는것들 && 기존 권한체크안된것들 추가
			for (MenuInfoVO deptMenu : deptResult) {
				int menuId = deptMenu.getMenuId();
				
				if (menuIds.indexOf(menuId) == -1) {
					menuIds.add(menuId);
					
					if (deptMenu.isAccessYN()) {
						result.add(deptMenu);
					}
				}
			}
		}
		//여기까지가 권한체크된 모든 메뉴 리스트
		
		
		
		//order에 따라 다시 소팅
		Collections.sort(result, new Comparator<MenuInfoVO>() {
			@Override
			public int compare(MenuInfoVO o1, MenuInfoVO o2) {
				return Integer.compare(o1.getMenuOrder(), o2.getMenuOrder());
			}
		});

		logger.debug("[Service] getUserMenuList ended");
		return result;
	}
	
	// 사용자 메뉴 순서 변경
	@SuppressWarnings("unchecked")
	public void updateUserMenuOrder(String companyId, int tenantId, String userId, JSONObject jObj) throws Exception {
		logger.debug("[Serivce] updateUserMenuOrder Started");

		// 사용자 메뉴가 존재할 경우, 존재하지 않을 경우로 분기
		Map<String, Object> cntMap = new HashMap<String, Object>();
		cntMap.put("companyId", companyId);
		cntMap.put("tenantId", tenantId);
		cntMap.put("userId", userId);
		
		int cnt = ezNewPortalDAO.getUserMenuOrderCnt(cntMap);
		
		List<Map<String, Object>> list = (ArrayList<Map<String, Object>>) jObj.get("data");

		for(int i=0; i<list.size(); i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyId", companyId);
			map.put("tenantId", tenantId);
			map.put("userId", userId);			
			map.put("menuId", list.get(i).get("menuId"));
			map.put("order", list.get(i).get("order"));
			
			if (cnt < 1) {
				ezNewPortalDAO.insertUserMenuOrder(map);
			} else {
				ezNewPortalDAO.updateUserMenuOrder(map);
			}
		}
		logger.debug("[Serivce] updateUserMenuOrder Ended");
	}
	
	// 사용자 메뉴 순서 삭제
	public void deleteUserMenuOrder(String companyId, int tenantId, String userId) throws Exception {
		logger.debug("[Serivce] deleteUserMenuOrder Started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		ezNewPortalDAO.deleteUserMenuOrder(map);
		
		logger.debug("[Serivce] deleteUserMenuOrder Ended");
	}
	
	// 퀵링크 가져오기
	public  Map<String, Object> getQuickLinkList(String companyId, int tenantId, int page, int limit, String userId, String deptId) throws Exception {
		logger.debug("[Serivce] getQuickLinkList Started");
		
		int offset = (page-1) * limit;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit);
		map.put("offset", offset);
		map.put("userId", userId);
		map.put("deptId", deptId);

		// 2024-05-17 김유진 - 퀵링크 권한 체크 로직 추가
		List<String> quickLinkIds = new ArrayList<>();
		//유저 권한체크
		map.put("userType", "USER");
		List<QuickLinkVO> result = ezNewPortalDAO.getCheckQuickLinkAcl(map);
		for (QuickLinkVO userQuickLink : result) {
			String quickLinkId = userQuickLink.getQuickLinkId();
			logger.debug("getQuickLinkList userQuickLink: " + quickLinkId);
			if (quickLinkIds.indexOf(quickLinkId) == -1) {
				quickLinkIds.add(quickLinkId);
			}
		}
		result.removeIf(vo -> ("N".equals(vo.getViewflag())));

		// 직위,직책 권한체크
		map.put("userType", "PERMISSION");
		List<QuickLinkVO> permissionResult = ezNewPortalDAO.getCheckQuickLinkAcl(map);
		for (QuickLinkVO permissionQuickLink : permissionResult) {
			String quickLinkId = permissionQuickLink.getQuickLinkId();
			logger.debug("getQuickLinkList permissionQuickLink: " + quickLinkId);
			if (quickLinkIds.indexOf(quickLinkId) == -1) {
				quickLinkIds.add(quickLinkId);
				if ("Y".equals(permissionQuickLink.getViewflag())) {
					result.add(permissionQuickLink);
				}
			}
		}

		// 부서 권한체크 - 하위부서부터 체크
		String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
		List<String> deptIds = Arrays.asList(deptPath.split(","));
		Collections.reverse(deptIds);

		List<QuickLinkVO> deptResult = null;
		map.put("userType", "DEPT");
		for(String pathId : deptIds) {
			map.put("deptId", pathId);
			if (pathId.equals(deptId)) {
				map.put("isUserDept", true);
			} else {
				map.put("isUserDept", false);
			}
			deptResult = ezNewPortalDAO.getCheckQuickLinkAcl(map);

			for (QuickLinkVO deptQuickLink : deptResult) {
				String quickLinkId = deptQuickLink.getQuickLinkId();
				if (quickLinkIds.indexOf(quickLinkId) == -1) {
					quickLinkIds.add(quickLinkId);
					if ("Y".equals(deptQuickLink.getViewflag())) {
						result.add(deptQuickLink);
					}
				}
			}
		}

		ArrayList<String> quickLinkIdList = new ArrayList<>();
		for (QuickLinkVO quickLink : result ) {
			quickLinkIdList.add(quickLink.getQuickLinkId());
		}
		if (quickLinkIdList.size() > 0) {
			map.put("quickLinkIdList", quickLinkIdList);
		}

		Map<String, Object> resultMap = new HashMap<>();
		// getQuickLinkTotalPageCnt 총 개수 구하기
		int totalCnt = ezNewPortalDAO.getQuickLinkTotalCnt(map);
		float pageCnt = (float)totalCnt / (float)limit;
		resultMap.put("totalPageCnt", (int) Math.ceil(pageCnt));
		resultMap.put("quickLinkList", ezNewPortalDAO.getQuickLinkList(map));

		logger.debug("[Serivce] getQuickLinkList Ended");
		return resultMap;
	}
	// 퀵링크 전체 페이지 개수 가져오기
	public int getQuickLinkTotalPageCnt(String companyId, int tenantId, int limit, String userId, String deptId) throws Exception {
		logger.debug("[Serivce] getQuickLinkTotalPageCnt Started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("deptId", deptId);
		
		int totalCnt = ezNewPortalDAO.getQuickLinkTotalCnt(map);
		
		float pageCnt = (float)totalCnt / (float)limit;

		logger.debug("[Serivce] getQuickLinkTotalPageCnt Ended");
		return (int) Math.ceil(pageCnt);
	}
	
	public List<?> getUserFrameListAndSelectedFrame(String companyId, int tenantId, String userId) throws Exception {
		logger.debug("[Serivce] getUserFrameListAndSelectedFrame Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		List<FrameInfoVO> frameList = new ArrayList<FrameInfoVO>();
		/**
		 * 1. 회사 프레임리스트 가져오기
		 * 2. 유저 프레임 정보 가져오기
		 * 3. 유저 프레임 정보가 없을 경우 회사에서 선택된 프레임 정보 사용
		 * 4. 유저 프레임 정보가 있을 경우 그대로 사용
		 */
		
		// 1. 유저 프레임 정보 가져오기
		List<FrameInfoVO> userFrame = ezNewPortalDAO.getUserUsableFrameList(map);
		// 유저가 설정한 적이 없을 경우 회사 정보 가져오기
		if(userFrame.size() < 1) {
			List<FrameInfoVO> compFrame = ezNewPortalDAO.getCompUsableFrameList(map);
			frameList = compFrame;
		} else {
			frameList = userFrame;
		}

		logger.debug("[Serivce] getUserFrameListAndSelectedFrame Ended");
		return frameList;
	}
	
	@SuppressWarnings("unchecked")
	public void updateUserUsedFrame(String userId, int tenantId, String companyId, JSONObject jObj) throws Exception {
		logger.debug("[Serivce] updateUserUsedFrame Started");
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> param = (Map<String, Object>) jObj.get("param");
		String themeId = (String) param.get("themeId");
		// 2024-06-11 조수빈 - 한 프레임만 사용하게 됨에 따라 테마에 맞는 해당 프레임을 지정해서 update하도록 수정.
		Object frameId = "";
		
		if (themeId.equals("1")) {
			frameId = "1";
		} else if (themeId.equals("2")) {
			frameId = "5";
		} else if (themeId.equals("3")) {
			frameId = "8";
		} else if (themeId.equals("4")) {
			frameId = "9";
		}
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("frameId", frameId);
		map.put("themeId", themeId);
		map.put("usePaging", param.get("usePaging") == null ? 1 : param.get("usePaging"));
		
		if (!themeId.equals("4")){
			map.put("isDefault", 1);
		} else {
			map.put("isDefault", 0);
		}
		
		map.put("usedTheme", themeId);
		
		logger.debug("map.toString() : " + map.toString());
		
		ezNewPortalDAO.updateUserUsedFrame(map);
		//ezNewPortalDAO.updateUserThemeSetting(map);
		
		logger.debug("[Serivce] updateUserUsedFrame Ended");
	}
	
	@SuppressWarnings("unchecked")
	public void updateUserUsedPortlet(String userId, int tenantId, String companyId, JSONObject jObj) throws Exception {
		logger.debug("[Serivce] updateUserUsedPortlet Started");
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> param = (Map<String, Object>) jObj.get("param");
		// 유저 포틀릿은 delete & insert로 진행
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);		
		
		// 삭제할 때 
		/*ezNewPortalDAO.deleteUserUsedPortlet(map);*/
		
		List<Map<String, Object>> portletList = (List<Map<String, Object>>) param.get("portletList");
		logger.debug("portletList: " + portletList.toString());
		
		for (int i=0; i<portletList.size(); i++) {
			logger.debug(portletList.get(i).toString());
			Map<String, Object> portletMap = new HashMap<String, Object>();
			portletMap.put("userId", userId);
			portletMap.put("tenantId", tenantId);
			portletMap.put("companyId", companyId);
			portletMap.put("portletId", portletList.get(i).get("portletId"));
			portletMap.put("portletOrder", portletList.get(i).get("portletOrder"));
			portletMap.put("menuId", portletList.get(i).get("menuId"));
			portletMap.put("themeId", param.get("themeId"));
			portletMap.put("portletUsed", Boolean.parseBoolean(portletList.get(i).get("portletUsed").toString()));
			
			logger.debug("portletMap:" + portletMap.toString());
			ezNewPortalDAO.insertUserUsedPortlet(portletMap);
		}
		
		
		logger.debug("[Serivce] updateUserUsedPortlet Ended");
	}
	
	/**
	 * config true이면 유저세팅목록조회, false이면 유저별목록조회
	 */
	@Override
	public List<PortletInfoVO> getUserPortletList(int themeId, String portletLang, String userId, int tenantId, String companyId, String deptId, boolean config) throws Exception {
		logger.debug("[Serivce] getUserPortletList Started");
		/**
		 * 2018-11-21 신규작성
		 */
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("userId", userId);
		map.put("deptId", "");
		map.put("themeId", themeId);
		map.put("portletLang", portletLang);
		map.put("config", config);
		
		String lang = commonUtil.getMultiData(portletLang, tenantId);
		map.put("lang", lang);
		
		String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
		
		//path 거꾸로 돌려야해서
		List<String> deptIds = Arrays.asList(deptPath.split(","));
		Collections.reverse(deptIds);
		
		//유저권한체크
		logger.debug("getPortletForUser deptId = " + userId);
		
		map.put("userType", "USER");
		map.put("isDept", "user");
		
		List<PortletInfoVO> result = ezNewPortalDAO.getPortletForUser(map);
		List<PortletAuthVO> authResult = ezNewPortalDAO.getPortletAuthUserList(map);
		
		List<PortletInfoVO> deptResult = null;
		List<PortletAuthVO> deptAuthResult = null;
		
		//전체체크필요없어서 id만
		List<Integer> portletIds = new ArrayList<Integer>();
		List<Integer> portletAuthIds = new ArrayList<Integer>();
		List<Integer> accessYIds = new ArrayList<Integer>();
		
		for (PortletInfoVO vo : result) {
			logger.debug("user portletId = " + vo.getPortletId());
			
			portletIds.add(vo.getPortletId());
		}
		
		for (PortletAuthVO vo : authResult) {
			portletAuthIds.add(vo.getPortletId());
			
			if (vo.isAccessYN()) {
				accessYIds.add(vo.getPortletId());
			}
		}
		
		result.removeIf(vo -> !vo.isAccessYN());
		authResult.removeIf(vo -> !vo.isAccessYN());
		
		//직위 직책 체크 
		map.put("userType", "PERMISSION");
		List<PortletInfoVO> permissionResult = ezNewPortalDAO.getPortletForUser(map);
		List<PortletAuthVO> portletAuthPermissionResult = ezNewPortalDAO.getPortletAuthUserList(map);
		
		for (PortletInfoVO permissionPortlet : permissionResult) {
			int portletId = permissionPortlet.getPortletId();
			
			if (portletIds.indexOf(portletId) == -1) {
				portletIds.add(portletId);
				
				if (permissionPortlet.isAccessYN()) {
					result.add(permissionPortlet);
				}
			}
		}
		
		for (PortletAuthVO permissionPortlet : portletAuthPermissionResult) {
			int portletAuthId = permissionPortlet.getPortletId();
			
			if (portletAuthIds.indexOf(portletAuthId) == -1) {
				portletAuthIds.add(permissionPortlet.getPortletId());
				
				if (permissionPortlet.isAccessYN()) {
					accessYIds.add(permissionPortlet.getPortletId());
				}
			}
		}
		
		//부서 및 상위부서권한체크(유저 나 하위부서에서 권한체크걸린건 추가안함
		map.put("userType", "DEPT");
		for(String pathId : deptIds) {
			map.put("isDept", "dept");
			map.put("deptId", pathId);
			
			logger.debug("getPortletForUser deptId = " + pathId);
			if (pathId.equals(deptId)) {
				map.put("isUserDept", true);
			} else {
				map.put("isUserDept", false);
			}
			
			deptResult = ezNewPortalDAO.getPortletForUser(map);
			deptAuthResult = ezNewPortalDAO.getPortletAuthUserList(map);
			
			//권한잇는것들 && 기존 권한체크안된것들 추가
			for (PortletInfoVO deptPortlet : deptResult) {
				logger.debug("deptPortlet id = " + deptPortlet.getPortletId() + " || isAccessYN = " + deptPortlet.isAccessYN() + " || isUsed = " + deptPortlet.isPortletUsed());
				int portletId = deptPortlet.getPortletId();
								
				if (portletIds.indexOf(portletId) == -1) {
					//logger.debug("portletIds.indexOf(portletId) == -1");
					portletIds.add(portletId);
					
					if (deptPortlet.isAccessYN()) {
						//logger.debug("deptPortlet.isAccessYN()"); // 로그정리
						result.add(deptPortlet);
						//logger.debug("resultSize = " + result.size()); // 로그정리
					}
				}
			}
			
			for (PortletAuthVO deptAuthPortlet : deptAuthResult) {
				logger.debug("deptAuthPortlet id = " + deptAuthPortlet.getPortletId() + " || isAccessYN = " + deptAuthPortlet.isAccessYN());
				int portletId = deptAuthPortlet.getPortletId();
								
				if (portletAuthIds.indexOf(portletId) == -1) {
					//logger.debug("portletAuthIds.indexOf(portletId) == -1");
					portletAuthIds.add(portletId);
					
					if (deptAuthPortlet.isAccessYN()) {
						//logger.debug("portletAuthIds.isAccessYN()");
						accessYIds.add(deptAuthPortlet.getPortletId());
					}
				}
			}
		}
		
		logger.debug("portletSize : {}, portletList : {}", result.size(), result.toString());
		logger.debug("accessYIds : " + accessYIds.toString());
		
		//authResult와 메뉴권한이 있는 portletList와 비교!
		List<PortletInfoVO> resultWithAuth = new ArrayList<PortletInfoVO>();
		int resultSize = result.size();
		
		for (int i = 0; i < resultSize; i++) {
			int resultPortletId = result.get(i).getPortletId();
			
			if (accessYIds.contains(resultPortletId)) {
				resultWithAuth.add(result.get(i));
			}
		}
		
		logger.debug("resultWithAuth : " + resultWithAuth.toString());
		//여기까지가 권한체크된 모든 포틀릿 리스트
		
		//order에 따라 다시 소팅
		Collections.sort(resultWithAuth, new Comparator<PortletInfoVO>() {
			@Override
			public int compare(PortletInfoVO o1, PortletInfoVO o2) {
				return Integer.compare(o1.getPortletOrder(), o2.getPortletOrder());
			}
		});
		
		logger.debug("[Serivce] getUserPortletList Ended");
		
		return resultWithAuth;
	}
	
	@Override
	public int getVotePortletCount(String userId, String companyId, String deptPath, int tenantId, String userType, String deptId) throws Exception {
		logger.debug("[Serivce] getVotePortletCount Started");
		Map<String, Object> map = new HashMap<String, Object>();
		String[] deptArr = deptPath.split(",");
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("deptPath", deptPath);
		map.put("tenantId", tenantId);
		map.put("deptArr", deptArr);
		map.put("userType", userType);
		map.put("deptId", deptId);

		logger.debug("[Serivce] getVotePortletCount Ended");
		return ezNewPortalDAO.getVotePortletCount(map);
	}

	@Override
	public PollQuestionVO getVotePortletInfo(String userId, String companyId, String deptPath, int tenantId, String userType) throws Exception {
		logger.debug("[Serivce] getVotePortletInfo Started");
		Map<String, Object> map = new HashMap<String, Object>();
		String[] deptArr = deptPath.split(",");
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("deptPath", deptPath);
		map.put("tenantId", tenantId);
		map.put("deptArr", deptArr);
		map.put("userType", userType);
		
		logger.debug("[Serivce] getVotePortletInfo Ended");
		return ezNewPortalDAO.getVotePortletInfo(map);
	}

	@Override
	public List<PollAnswerVO> getVotePortletAnswer(int qstId, int tenantId) throws Exception {
		logger.debug("[Serivce] getVotePortletAnswer Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("qstId", qstId);
		map.put("tenantId", tenantId);

		logger.debug("[Serivce] getVotePortletAnswer Ended");
		return ezNewPortalDAO.getVotePortletAnswer(map);
	}

	@Override
	public List<BoardItemVO> getPhotoBoardPortletInfo(int tenantId, String boardId, int startRow, int photoCount, String offset) throws Exception {
		logger.debug("[Serivce] getPhotoBoardPortletInfo Started");
		Map<String, Object> map = new HashMap<String, Object>();
		String nowDate = commonUtil.getTodayUTCTime("");
		map.put("tenantId", tenantId);
		map.put("boardId", boardId);
		map.put("startRow", startRow);
		map.put("photoCount", photoCount);
		map.put("nowDate", nowDate);

		logger.debug("[Serivce] getPhotoBoardPortletInfo Ended");
		return ezNewPortalDAO.getphotoBoardPortletInfo(map);
	}
	
	@Override
	public int getPhotoBoardPortletTotalCnt(int tenantId, String boardId, String offset) throws Exception {
		logger.debug("[Serivce] getPhotoBoardPortletTotalCnt Started");
		Map<String, Object> map = new HashMap<String, Object>();
		String nowDate = commonUtil.getTodayUTCTime("");
		map.put("tenantId", tenantId);
		map.put("boardId", boardId);
		map.put("nowDate", nowDate);
		logger.debug("[Serivce] getPhotoBoardPortletTotalCnt Ended");
		return ezNewPortalDAO.getPhotoBoardPortletTotalCnt(map);
	}

	@Override
	public PortletInfoVO getCompanyPortletInfo(String companyId, int tenantId, int portletId, String portletLang) throws Exception {
		logger.debug("[Serivce] getCompanyPortletInfo Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletId", portletId);
		map.put("portletLang", portletLang);

		logger.debug("[Serivce] getCompanyPortletInfo Ended");
		return ezNewPortalDAO.getCompanyPortletInfo(map);
	}

	@Override
	public String getBoardAuthCheck(String boardId, String accessId, int tenantId, String companyId) throws Exception {
		logger.debug("[Serivce] getBoardAuthCheck Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("boardId", boardId);
		map.put("accessId", accessId);
		
		logger.debug("[Serivce] getBoardAuthCheck Ended");
		return ezNewPortalDAO.getBoardAuthCheck(map);
	}
	
	@Override
	public UserPortalSettingVO getUserPortalSetting(String userId, String companyId, int tenantId, String deptPath, String portletLang) throws Exception {
		logger.debug("[Serivce] getUserPortalSetting Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("lang", portletLang);
		
		UserPortalSettingVO userPortalSetting = ezNewPortalDAO.getUserPortalSetting(map);
		
		if (userPortalSetting == null) {
			List<ThemeInfoVO> themeList = getUserThemeList(companyId, tenantId, userId, deptPath, portletLang);
			userPortalSetting = ezNewPortalDAO.getCompPortalSetting(map);
			
			if (userPortalSetting == null) {
				UserPortalSettingVO tempSetting = new UserPortalSettingVO();
				tempSetting.setUsedFrame("Frame1");
				tempSetting.setUsedTheme(1);
				
				userPortalSetting = tempSetting;
			} else {
				boolean canAccessTheme = false;
				int themeId = userPortalSetting.getUsedTheme();
				
				for (int i = 0; i < themeList.size(); i++) {
					if (themeId == themeList.get(i).getThemeId()) {
						canAccessTheme = true;
					}
				}
				
				if (!canAccessTheme) {
					if (themeList == null || themeList.size() == 0) {
						// 2024-06-05 김유진 - 접근 가능한 userThemeList가 없을 경우, 회사의 기본 테마 가져오기
						userPortalSetting = ezNewPortalDAO.getCompPortalSetting(map);
					} else {
						map.put("usedTheme", themeList.get(0).getThemeId());
						userPortalSetting = ezNewPortalDAO.getUserPortalSetting(map);
						if (userPortalSetting == null) {
							map.put("themeId", themeList.get(0).getThemeId());
							userPortalSetting = ezNewPortalDAO.getCompPortalSetting(map);
						}
					}
				}
			}
			
			// 2024-06-11 조수빈 - 회사 혹은  기준으로 포탈 설정을 가져올 경우 페이징 처리에 대한 값이 없으므로 default 값인 1을 넣는다.
			userPortalSetting.setUsePaging(1);
		} else {
			List<ThemeInfoVO> themeList = getUserThemeList(companyId, tenantId, userId, deptPath, portletLang);
			boolean canAccessTheme = false;
			int themeId = userPortalSetting.getUsedTheme();
			
			for (int i = 0; i < themeList.size(); i++) {
				if (themeId == themeList.get(i).getThemeId()) {
					canAccessTheme = true;
				}
			}
			
			logger.debug("canAccessTheme : " + canAccessTheme);
			
			if (!canAccessTheme) {
				if (themeList == null || themeList.size() == 0) {
					// 2024-06-05 김유진 - 접근 가능한 userThemeList가 없을 경우, 회사의 기본 테마 가져오기
					userPortalSetting = ezNewPortalDAO.getCompPortalSetting(map);
				}  else {
					map.put("usedTheme", themeList.get(0).getThemeId());
					userPortalSetting = ezNewPortalDAO.getUserPortalSetting(map);
					
					if (userPortalSetting == null) {
						map.put("themeId", themeList.get(0).getThemeId());
						userPortalSetting = ezNewPortalDAO.getCompPortalSetting(map);
					}
				}
			}
		}
		
		//logger.debug("final userPortalSetting : " + userPortalSetting.toString()); // 로그정리
		logger.debug("[Serivce] getUserPortalSetting Ended, userPortalSetting={}", userPortalSetting.toString());
		return userPortalSetting;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void updatePortletOrderUser(String userId, String companyId, int tenantId,
			JSONArray portletOrder, String portletLang, int themeId) throws Exception {
		logger.debug("updatePortletOrderUser started.");
		Map<String, Object> map = new HashMap<String, Object>();

		//List<Integer> portletIdList = new ArrayList<Integer>();
		List<Map<String, Object>> sizeList = new ArrayList<Map<String, Object>>();

		//포틀릿 순서 업데이트 (없으면 insert)
		for (Object item : portletOrder) {
			if (item instanceof JSONObject) {
				JSONObject portlet = (JSONObject) item;

				map = new ObjectMapper().readValue(portlet.toJSONString(), Map.class);
				map.put("userId", userId);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				map.put("portletLang", portletLang);
				map.put("themeId", themeId);
				if (themeId != 4) {
					map.put("portletUsed", 1);	
				}
				
				ezNewPortalDAO.updatePortletOrderUser(map);

				/*int portletId = Integer.parseInt(portlet.get("portletId").toString());
				portletIdList.add(portletId);*/

				sizeList.add(new HashMap<>(map));
			}
		}

		boolean usePortletSize = "Y".equals(ezCommonService.getTenantConfig("usePortletSize", tenantId));

		if (usePortletSize && themeId != 4) {
			ezNewPortalDAO.clearPortletSizeUser(map);
			ezNewPortalDAO.insertPortletSizeUser(sizeList);
		}


		//tbl_portal_portlet_user에는 있는데 포틀릿 순서에 없었던 목록 가져오기
		/*map.put("portletIdList", portletIdList);
		
		List<PortletInfoVO> notSelectedPortletList = ezNewPortalDAO.getPortletListNotSelected(map);
		
		if (notSelectedPortletList != null) {
			int portletCount = portletOrder.size();
			int notSelectedPortletListCount = notSelectedPortletList.size();
			
			for (int i = 0; i < notSelectedPortletListCount; i++) {
				portletCount++;
				map.put("portletOrder", portletCount);
				map.put("portletId", notSelectedPortletList.get(i).getPortletId());

				map.put("themeId", themeId);
				map.put("portletUsed", 0);
				
				ezNewPortalDAO.updatePortletOrderUser(map);
			}
		}*/
		/*//portletOrder를 사용자가 설정한 정보가 있는지 확인
		List<PortletInfoVO> userPortletOrder = ezNewPortalDAO.getPortletOrderUser(map);

		if (userPortletOrder == null || userPortletOrder.isEmpty()) {//없으면 insert
			for (int i = 0; i < portletOrderCount; i++) {
				map.put("portletOrder", portletOrder.get(i).get("portletOrder"));
				map.put("portletId", portletOrder.get(i).get("portletId"));
				ezNewPortalDAO.insertPortletOrderUser(map);
			}
			
		} else {//있으면 delete 후 insert
			logger.debug("DAO deletePortletOrderUser started.");
			ezNewPortalDAO.deletePortletOrderUser(map);
			
			logger.debug("DAO insertPortletOrderUser started.");
			for (int i = 0; i < portletOrderCount; i++) {
				map.put("portletOrder", portletOrder.get(i).get("portletOrder"));
				map.put("portletId", portletOrder.get(i).get("portletId"));
				ezNewPortalDAO.insertPortletOrderUser(map);
			}
		}*/
		
		logger.debug("updatePortletOrderUser ended.");
	}

	@Override
	public int getMonthlyBirthdayEmployeesCount(String companyId, int tenantId, int month) throws Exception {
		logger.debug("getMonthlyBirthdayEmployeesCount started.");
		String monthStr = "";

		if (month < 10) {
			monthStr = "0" + month;
		} else {
			monthStr = String.valueOf(month);
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("month", monthStr);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);

		List<PortalUserInfoVO> tempList = ezNewPortalDAO.getMonthlyBirthdayEmployees(map);
		int birthdayListCount = tempList.size();
		List<PortalUserInfoVO> birthdayList = new ArrayList<PortalUserInfoVO>();
		int lunarCount = 0;
		String lastLunarId = "";
		String lastLunarDate = "";
		String lastSolarDate = "";

		logger.debug("convertLunarToSolar started.");

		/*(시작) 2024-02-22 곽동석, 음력 생일자 양력변환 계산 일자 오류 수정 */
		for (int i = 0; i < birthdayListCount; i++) {
			PortalUserInfoVO portalUserInfo = tempList.get(i);

			if (portalUserInfo.isSolar()) {
				birthdayList.add(portalUserInfo);
			} else {
				/*(시작) 2024-02-22 곽동석, 음력 생일자 양력변환 계산 일자 오류 수정 */
				String toSolarDate ="";
				ArrayList toSolarDateSet = convertLunarToSolar(portalUserInfo.getUserBirthday(), month);
				//logger.debug("[getMonthlyBirthdayEmployeesCount] toSolarDateSet >>>>" + toSolarDateSet + " (0)=" + toSolarDateSet.get(0) + " (1)=" + toSolarDateSet.get(1));

				String diffIdx = "";
				for(int j=0; j<2; j++) {
					if (toSolarDateSet.get(j).equals("")) {
						diffIdx = "";
					} else {
						diffIdx = toSolarDateSet.get(j).toString().substring(5, 7);
					}

					if (monthStr.equals(diffIdx)) { //2024-02-07 곽동석, toSolarDateSet(0)의 월과 비교하는 월의 비교값이 같을경우.
						toSolarDate = toSolarDateSet.get(j).toString();
					} else {
						toSolarDate = "";
					}
					//logger.debug("[getMonthlyBirthdayEmployeesCount] toSolarDate >>>>" + toSolarDate);

					//logger.debug("[getMonthlyBirthdayEmployeesCount] diffIdx >>>>" + diffIdx);

					if (!toSolarDate.equals("")) {
						lastLunarId = portalUserInfo.getUserId();
						lastLunarDate = portalUserInfo.getUserBirthday();
						portalUserInfo.setUserBirthday(toSolarDate);
						birthdayList.add(portalUserInfo);
						lastSolarDate = toSolarDate;
						lunarCount++;
					}
				}
				/*(종료) 2024-02-22 곽동석, 음력 생일자 양력변환 계산 일자 오류 수정 */
			}
		}

		if (lunarCount > 0) {
			logger.debug("lunarInThisMonthCount : " + lunarCount + " / last id : " + lastLunarId + " / date : " + lastLunarDate + " > " + lastSolarDate);
		}

		logger.debug("convertLunarToSolar ended.");

		int birthCount = 0;

		if (birthdayList == null || birthdayList.isEmpty()) {
			birthCount = 0;
		} else {
			birthCount = birthdayList.size();
		}

		logger.debug("getMonthlyBirthdayEmployeesCount ended.");
		return birthCount;
	}

	@Override
	public List<PortalUserInfoVO> getMonthlyBirthdayEmployees(String companyId, int tenantId, int month, int count, int startRow,String lang) throws Exception {
		logger.debug("getMonthlyBirthdayEmployees started.");
		String monthStr = "";

		if (month < 10) {
			monthStr = "0" + month;
		} else {
			monthStr = String.valueOf(month);
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("month", monthStr);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		if (lang != null && !lang.equals("") && !lang.equals("1")) {
			map.put("lang", "2");
		}

		List<PortalUserInfoVO> tempList = ezNewPortalDAO.getMonthlyBirthdayEmployees(map);
		int birthdayListCount = tempList.size();
		List<PortalUserInfoVO> birthdayList = new ArrayList<PortalUserInfoVO>();

		for (int i = 0; i < birthdayListCount; i++) {
			PortalUserInfoVO portalUserInfo = tempList.get(i);
			String imgPath = "";
//			logger.debug("portalUserInfo.getUserBirthday() >>>> " + portalUserInfo.getUserBirthday());
			if (portalUserInfo.isSolar()) {
				if (portalUserInfo.getUserImg() != null && !portalUserInfo.getUserImg().equals("")) {
					imgPath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + portalUserInfo.getUserImg();
				} else {
					imgPath = "/images/ezNewPortal/info_pic_none.png";
				}

				portalUserInfo.setUserImg(imgPath);
				birthdayList.add(portalUserInfo);
			} else {
				/*(시작) 2024-02-22 곽동석, 음력 생일자 양력변환 계산 일자 오류 수정 */
				String toSolarDate ="";
				ArrayList toSolarDateSet = convertLunarToSolar(portalUserInfo.getUserBirthday(), month);
				//logger.debug("[getMonthlyBirthdayEmployees] toSolarDateSet >>>>" + toSolarDateSet + " (0)=" + toSolarDateSet.get(0) + " (1)=" + toSolarDateSet.get(1));

				String diffIdx = "";
				for(int j=0; j<2; j++) {
					if (toSolarDateSet.get(j).equals("")) {
						diffIdx = "";
					} else {
						diffIdx = toSolarDateSet.get(j).toString().substring(5, 7);
					}
					//logger.debug("[getMonthlyBirthdayEmployees] diffIdx >>>>" + diffIdx);

					if (monthStr.equals(diffIdx)) { //2024-02-07 곽동석, toSolarDateSet(0)의 월과 비교하는 월의 비교값이 같을경우.
						toSolarDate = toSolarDateSet.get(j).toString();
					} else {
						toSolarDate = "";
					}

					if (!toSolarDate.equals("")) {
						if (portalUserInfo.getUserImg() != null && !portalUserInfo.getUserImg().equals("")) {
							imgPath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + portalUserInfo.getUserImg();
						} else {
							imgPath = "/images/ezNewPortal/info_pic_none.png";
						}

						portalUserInfo.setUserBirthday(toSolarDate);
						portalUserInfo.setUserImg(imgPath);
						birthdayList.add(portalUserInfo);
					}
//					logger.debug("[getMonthlyBirthdayEmployees] toSolarDate >>>>" + toSolarDate);
				}
				/*(종료) 2024-02-22 곽동석, 음력 생일자 양력변환 계산 일자 오류 수정 */
			}
		}

		int birthCount = birthdayList.size();

		//오름차순 정렬
		Collections.sort(birthdayList, new Comparator<PortalUserInfoVO>() {
			@Override
			public int compare(PortalUserInfoVO o1, PortalUserInfoVO o2) {
				return o1.getUserBirthday().split("-")[2].compareTo(o2.getUserBirthday().split("-")[2]);
			}
		});

		if (startRow >= birthCount) {
			startRow = 0;
		}

		List<PortalUserInfoVO> birthdayListLmit = new ArrayList<PortalUserInfoVO>();

		for (int i = startRow; i < startRow + count; i++) {
			if (i < birthCount) {
				birthdayListLmit.add(birthdayList.get(i));
			}
		}
		
		// 2024-05-27 한태훈 > 6초마다 자동페이지네이션 기능 사용하려면 return birthdayListLmit을 해줘야함. 2018년?에 만들어진 기능인데, 호출을 6초마다하는 게 부담이 되니 다른 방법으로 구현하는 것도 좋아보임.

		logger.debug("getMonthlyBirthdayEmployees ended.");
		return birthdayListLmit;
	}

	public static ArrayList convertLunarToSolar(String birthday, int compMonth) {
		/*
		 * 20.05.29 강승구 : 음력변환 오류 수정
		 * 아직 윤달, 평달에 대한 문제 해결 필요
		 */
		/*
		 * 24.02.07 곽동석 : 연 2회 생일자에 대한 로직 추가 수정.
		 * 특정 음력생일자의 경우, 실제로 연 2회 생일자가 있음.
		 * convertLunarToSolar 메서드를 ArrayList로 변경.
		 * 연내 상반기 생일과 하반기 생일값을 추가하기 위함.
		 * ex) 음력 23년 11월 29일은 -> 24년 1월 10일, 23년 11월 29일은 -> 24년 12월 29일 이다.
		 */
		//logger.debug("[convertLunarToSolar] birthday >>>> " + birthday);
		String result = "";
		ArrayList resultSet = new ArrayList(); // 2024.02.07 곽동석, result를 담는 리스트.
		ChineseCalendar cc = new ChineseCalendar();
		java.util.Calendar cal = java.util.Calendar.getInstance();

		String currentYear = String.valueOf(cal.get(1));
		int currentYearInt = Integer.parseInt(currentYear); // 2024.02.07 곽동석, currentYear값 계산.

		/*(시작) 2024.02.07 곽동석, "'for' 'if (i==1)'는 전년도와 지금년도를 비교하여 년2회이상 중복생일자를 확인하기 위함." */
		for (int i=0; i<2; i++) {
			if (i == 1) {
				currentYear = String.valueOf(currentYearInt - 1);
			}
			birthday = currentYear + birthday.substring(4);

			if (birthday.length() == 10) {
				birthday = birthday.replace("-", "");
			}

			cc.set(ChineseCalendar.EXTENDED_YEAR, Integer.parseInt(birthday.substring(0, 4)) + 2637);
			cc.set(ChineseCalendar.MONTH, Integer.parseInt(birthday.substring(4, 6)) - 1);
			cc.set(ChineseCalendar.DAY_OF_MONTH, Integer.parseInt(birthday.substring(6, 8)));
			cc.set(ChineseCalendar.IS_LEAP_MONTH, 0);

			cal.setTimeInMillis(cc.getTimeInMillis());

			String year = String.valueOf(cal.get(Calendar.YEAR));

			/*(시작) 2024-01-12 박수빈 "생일자 음양력 변환 1년 앞당기는 오류 수정"*/
			if (!currentYear.equals(year)) { // 만약 변환한 양력이 올해가 아니라면 작년 생일로 다시 양력변환 시도

				cal = java.util.Calendar.getInstance(); // 객체 초기화
				cc = new ChineseCalendar();

				cal.add(Calendar.YEAR, -1); // 작년으로 생일 재설정
				birthday = cal.get(1) + birthday.substring(4);

				// 음력 -> 양력 계산
				cc.set(ChineseCalendar.EXTENDED_YEAR, Integer.parseInt(birthday.substring(0, 4)) + 2637);
				cc.set(ChineseCalendar.MONTH, Integer.parseInt(birthday.substring(4, 6)) - 1);
				cc.set(ChineseCalendar.DAY_OF_MONTH, Integer.parseInt(birthday.substring(6, 8)));
				cc.set(ChineseCalendar.IS_LEAP_MONTH, 0);

				cal.setTimeInMillis(cc.getTimeInMillis());

				// 변환된 양력 생일에서 연도 추출
				year = String.valueOf(cal.get(Calendar.YEAR));
			}
			/*(종료) 2024-01-12 박수빈 "생일자 음양력 변환 1년 앞당기는 오류 수정"*/

			String month = String.valueOf(cal.get(Calendar.MONTH) + 1);
			String day = String.valueOf(cal.get(Calendar.DAY_OF_MONTH));

			String pad4Str = "0000";
			String pad2Str = "00";

			String retYear = (pad4Str + year).substring(year.length());
			String retMonth = (pad2Str + month).substring(month.length());
			String retDay = (pad2Str + day).substring(day.length());

			result = retYear + "-" + retMonth + "-" + retDay;

			String monthComp = String.valueOf(compMonth);

			String chineseMonth = result.substring(5, 7);

			if (chineseMonth.indexOf("0") == 0) {
				chineseMonth = chineseMonth.substring(1);
			}

			if (!chineseMonth.equals(monthComp)) {
				result = "";
			}

			if (!retYear.equals(String.valueOf(currentYearInt))) { // 비교년도가 다를경우 값을 지운다.
				result = "";
			}
			//logger.debug("[convertLunarToSolar] currentYearInt >>>>" + currentYearInt);
			//logger.debug("[convertLunarToSolar] monthComp >>>>" + monthComp);
			//logger.debug("[convertLunarToSolar] result >>>>" + result);

			resultSet.add(result); // 2024-02-07 곽동석, Array List인 resultSet에 result값을 담는다.

		}

		// '인덱스 0 = 하반기', '인덱스 1 = 상반기' 값이므로 서로의 인덱스를 스위치한다.
		Object temp = resultSet.get(0); // 2024-02-07 곽동석, resultSet(0)과 (1)의 값을 서로 바꾼다(교환).
		resultSet.set(0, resultSet.get(1));
		resultSet.set(1, temp);

		//
		if (resultSet.get(0).equals(resultSet.get(1))) { // resultSet의 두 인덱스 값이 같을경우 인덱스 0의 값만 반환한다.
			resultSet.set(0, "");
		}
		//logger.debug("[convertLunarToSolar] resultSet >>>>" + resultSet);
		return resultSet;

		/*(종료) 2024.02.07 곽동석, "'for' 'if (i==1)'는 전년도와 지금년도를 비교하여 년2회이상 중복생일자를 확인하기 위함." */
	}
	
	@Override
	public PortalUserInfoVO getMonthlyBestEmployee(String yearAndMonth, String companyId, int tenantId, String lang) throws Exception {
		logger.debug("getMonthlyBestEmployee started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("yearAndMonth", yearAndMonth);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("lang", lang);
		String imgPath = "";
		PortalUserInfoVO portalUserInfo = ezNewPortalDAO.getMonthlyBestEmployee(map);
		
		if (portalUserInfo.getUserImg() != null && !portalUserInfo.getUserImg().equals("")) {
			imgPath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + portalUserInfo.getUserImg();
		} else {
			imgPath = "/images/default_pic.gif";
		}
		
		portalUserInfo.setUserImg(imgPath);
		
		logger.debug("getMonthlyBestEmployee ended.");
		return portalUserInfo;
	}

	@Override
	public List<ThemeInfoVO> getUserThemeList(String companyId, int tenantId, String userId, String deptPath, String lang) throws Exception {
		logger.debug("getUserThemeList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("userId", userId);
		//사용자 권한 체크
		map.put("isDept", "user");
		
		//path 거꾸로 돌려야해서
		List<String> deptIds = Arrays.asList(deptPath.split(","));
		Collections.reverse(deptIds);
		String userDeptId = deptIds.get(0);

		map.put("lang", lang);
		
		//유저권한체크
		map.put("userType", "USER");
		List<ThemeInfoVO> result = ezNewPortalDAO.getUserThemeList(map);
		List<ThemeInfoVO> deptResult = null;
		
		//전체체크필요없어서 id만
		List<Integer> themeIds = new ArrayList<Integer>();
		
		for (ThemeInfoVO vo : result) {
			themeIds.add(vo.getThemeId());
		}
		
		result.removeIf(vo -> !vo.isAccessYN());
		
		
		// 직위 직책 체크
		map.put("userType", "PERMISSION");
		List<ThemeInfoVO> permissionResult = ezNewPortalDAO.getUserThemeList(map);
		
		for (ThemeInfoVO permissionTheme : permissionResult) {
			int themeId = permissionTheme.getThemeId();
			
			if (themeIds.indexOf(themeId) == -1) {
				themeIds.add(themeId);
				
				if (permissionTheme.isAccessYN()) {
					result.add(permissionTheme);
				}
			}
		}

		map.put("userType", "DEPT");
		map.put("isDept", "dept");
		//부서 및 상위부서권한체크(유저 나 하위부서에서 권한체크걸린건 추가안함
		for(String pathId : deptIds) {
			map.put("userId", pathId);
			if (pathId.equals(userDeptId)) {
				map.put("isUserDept", true);
			} else {
				map.put("isUserDept", false);
			}

			deptResult = ezNewPortalDAO.getUserThemeList(map);
			
			//권한잇는것들 && 기존 권한체크안된것들 추가
			for (ThemeInfoVO depTheme : deptResult) {
				int menuId = depTheme.getThemeId();
				
				if (themeIds.indexOf(menuId) == -1) {
					themeIds.add(menuId);
					
					if (depTheme.isAccessYN()) {
						result.add(depTheme);
					}
				}
			}
		}
		
		//logger.debug("themeList : " + result.toString()); // 로그정리
		logger.debug("getUserThemeList ended.");
		return result;
	}
	

	/* 2024-06-05 김유진 - 접근 가능한 userThemeList가 없을 경우, 회사의 기본 테마 가져오기 */
	public List<ThemeInfoVO> getCompThemeList(String companyId, int tenantId, String lang) throws Exception {
		logger.debug("getCompThemeList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		List<ThemeInfoVO> result = ezNewPortalDAO.getCompThemeList(map);
		logger.debug("getCompThemeList ended.");
		return result;
	}

	public MenuInfoVO getUserStartPage (String userId, int tenantId, String companyId) throws Exception {
		logger.debug("getUserStartPage started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		logger.debug("getUserStartPage ended.");
		return ezNewPortalDAO.getUserStartPage(map);
	}
	
	public void updateUserStartPage(int menuId, String userId, int tenantId, String companyId) throws Exception {
		logger.debug("updateUserStartPage started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("menuId", menuId);
		
		MenuInfoVO userStartPage = ezNewPortalDAO.getUserStartPage(map);
		
		if (userStartPage == null) {
			logger.debug("DAO insertUserStartPage started.");
			ezNewPortalDAO.insertUserStartPage(map);
		} else {
			logger.debug("DAO updateUserStartPage started.");
			ezNewPortalDAO.updateUserStartPage(map);
		}
		
		
		logger.debug("updateUserStartPage ended.");
	}
	
	public void deleteUserThemeSetting(String userId, int tenantId, String companyId) throws Exception { 
		logger.debug("deleteUserThemeSetting started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezNewPortalDAO.deleteUserThemeSetting(map);
		logger.debug("deleteUserThemeSetting ended.");
	}
	
	public void updateUserThemeSetting(int usedTheme, int usedFrame, String userId, int tenantId, String companyId) throws Exception {
		logger.debug("updateUserThemeSetting started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("usedTheme", usedTheme);
		map.put("usedFrame", usedFrame);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("isDefault", 1);
		
		UserPortalSettingVO portalSetting = ezNewPortalDAO.getUserPortalSetting(map);
		
		if (portalSetting == null) {
			logger.debug("DAO insertUserThemeSetting started.");
			ezNewPortalDAO.insertUserThemeSetting(map);
			ezNewPortalDAO.updateUserThemeSetting(map);
		} else {
			logger.debug("DAO updateUserThemeSetting started.");
			ezNewPortalDAO.updateUserThemeSetting(map);
		}
		
		logger.debug("updateUserThemeSetting ended.");
	}
	
	//관리자부분 ------ boardtree가져오기
	@Override
	public List<PortalBoardTreeVO> getBoardTree(String parentBoardId, String companyId, int tenantId) throws Exception {
		logger.debug("getBoardTree started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentBoardId", parentBoardId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		logger.debug("getBoardTree ended.");
		return ezNewPortalDAO.getBoardTree(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void insertPortlet(JSONObject portletInfo, JSONArray portletNames, String companyId, int tenantId)
			throws Exception {
		logger.debug("insertPortlet started.");
		Map<String, Object> map = new HashMap<>();
		
		//메뉴
		map = new ObjectMapper().readValue(portletInfo.toJSONString(), Map.class);
		map.put("boardId", map.get("boardId") != null? commonUtil.stripScriptTags(map.get("boardId").toString()) : null);
		map.put("connectionId", map.get("connectionId") != null? commonUtil.stripScriptTags(map.get("connectionId").toString()) : null);
		map.put("portletCode", map.get("portletCode") != null? commonUtil.stripScriptTags(map.get("portletCode").toString()) : null);
		String connectionUrl = commonUtil.stripScriptTags(map.get("connectionUrl").toString());
		connectionUrl = commonUtil.detectPathTraversal(connectionUrl);
		connectionUrl = specialCharacterToEmptyString(URLDecoder.decode(connectionUrl, "UTF-8"));
		
		String webType = map.get("type").toString();

		map.put("connectionUrl", connectionUrl);
		map.put("menuId", commonUtil.stripScriptTags(map.get("menuId").toString()));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("type", webType);

		boolean portletUsed = Boolean.parseBoolean(map.get("portletUsed").toString());
		
		//포틀릿 insert 후에 아이디 가져옴
		int portletId = ezNewPortalDAO.insertPortlet(map);
		
		map.put("portletId", portletId);
		map.put("companyLang", 1);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.insertPortletComp(map);
		
		String menuId = portletInfo.get("menuId").toString();
		
		//포틀릿이름
		for (Object item : portletNames) {
			if (item instanceof JSONObject) {
				JSONObject portletNameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(portletNameInfo.toJSONString(), Map.class);
				
				String portletName = commonUtil.stripScriptTags(map.get("portletName").toString());
				portletName = commonUtil.detectPathTraversal(portletName);
				portletName = specialCharacterToEmptyString(portletName);
				
				portletName = portletName.replaceAll("& #40;", "(");
				portletName = portletName.replaceAll("& #41;", ")");

				String portletLang = commonUtil.stripScriptTags(map.get("portletLang").toString());
				portletLang = commonUtil.detectPathTraversal(portletLang);
				portletLang = specialCharacterToEmptyString(portletLang);
				
				map.put("portletName", portletName);
				map.put("portletLang", portletLang);
				
				map.put("menuId", menuId);
				map.put("portletId", portletId);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.insertCompanyPortletNameInfo(map);
			}
		}
		
		map.put("lang", 1);
		//테마별 포틀릿에도 추가
		//테마 리스트 불러오기
		List<ThemeInfoVO> themeList = ezNewPortalDAO.getCompanyThemes(map);
		int themeCount = themeList.size();
		
		//테마별로 넣어주기
		if (webType != null && !webType.equals("mobile")) {
			for (int i = 0; i < themeCount; i ++) {
				if (i != 3) { // 모바일 제외
					map.put("themeId", themeList.get(i).getThemeId());
					map.put("portletUsed", portletUsed);
					map.put("portletId", portletId);
					map.put("isFixed", 0); // default 0
					ezNewPortalDAO.updateThemePortletUsed(map);
				}
			}
		} else {
			map.put("themeId", 4);
			map.put("portletUsed", portletUsed);
			map.put("portletId", portletId);
			map.put("isFixed", 0); // default 0
			ezNewPortalDAO.updateThemePortletUsed(map);
		}
		
		logger.debug("insertPortlet ended.");
	}
	@SuppressWarnings("unchecked")
	@Override
	public void updateCompanyPortletInfo(JSONObject portletInfo, JSONArray portletNames, String companyId, int tenantId)
			throws Exception {
		logger.debug("updateCompanyPortletInfo started.");
		Map<String, Object> map = new HashMap<>();
		
		//메뉴
		map = new ObjectMapper().readValue(portletInfo.toJSONString(), Map.class);
		map.put("portletId", commonUtil.stripScriptTags(map.get("portletId").toString()));
		
		if (map.get("boardId") != null) {
			map.put("boardId", commonUtil.stripScriptTags(map.get("boardId").toString()));
		}
		
		if (map.get("connectionId") != null) {
			map.put("connectionId", map.get("connectionId") != null? commonUtil.stripScriptTags(map.get("connectionId").toString()) : null);
		}
		
		map.put("portletCode", map.get("portletCode") != null? commonUtil.stripScriptTags(map.get("portletCode").toString()) : null);
		
		if (map.get("connectionUrl") != null) {
			String connectionUrl = map.get("connectionUrl").toString();
			
			if (connectionUrl != null) {
				connectionUrl = commonUtil.stripScriptTags(connectionUrl);
				connectionUrl = commonUtil.detectPathTraversal(connectionUrl);
			}
			
			map.put("connectionUrl", connectionUrl);
		}
		
		map.put("menuId", Integer.parseInt(map.get("menuId").toString()));
		map.put("companyLang", 1);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		if (map.get("connectionUrl") != null || map.get("portletCode") != null) {
			ezNewPortalDAO.updateCompanyPortletInfo2(map); //포틀릿 정보 테이블 업데이트
		}
		
		ezNewPortalDAO.updateCompanyPortletInfo(map); //포틀릿 회사관련 정보 테이블 업데이트
		
		String menuId = map.get("menuId").toString();
		
		//포틀릿이름
		for (Object item : portletNames) {
			if (item instanceof JSONObject) {
				JSONObject portletNameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(portletNameInfo.toJSONString(), Map.class);

				String portletName = commonUtil.stripScriptTags(map.get("portletName").toString());
				portletName = commonUtil.detectPathTraversal(portletName);
				portletName = specialCharacterToEmptyString(portletName);
				
				portletName = portletName.replaceAll("& #40;", "(");
				portletName = portletName.replaceAll("& #41;", ")");
				
				String portletLang = commonUtil.stripScriptTags(map.get("portletLang").toString());
				portletLang = commonUtil.detectPathTraversal(portletLang);
				portletLang = specialCharacterToEmptyString(portletLang);
				
				map.put("portletName", portletName);
				map.put("portletLang", portletLang);
				
				map.put("portletId", commonUtil.stripScriptTags(map.get("portletId").toString()));
				
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				map.put("menuId", menuId);
				
				ezNewPortalDAO.updateCompanyPortletNameInfo(map);
			}
		}

		/* 2024-06-13 김유진 - 테마별 포틀릿도 업데이트 */
		map.put("lang", 1);
		List<ThemeInfoVO> themeList = ezNewPortalDAO.getCompanyThemes(map);
		int themeCount = themeList.size();
		for (int i = 0; i < themeCount; i ++) {
			map.put("themeId", themeList.get(i).getThemeId());
			ezNewPortalDAO.updateThemePortlet(map);
		}

		logger.debug("updateCompanyPortletInfo ended.");
		
	}
	@SuppressWarnings("unchecked")
	@Override
	public void updateCompanyPortletOrder(JSONArray portletList, int tenantId, String companyId) throws Exception {
		logger.debug("updateCompanyPortletOrder started.");
		Map<String, Object> map = new HashMap<String, Object>();
		
		//포틀릿 순서
		for (Object item : portletList) {
			if (item instanceof JSONObject) {
				JSONObject portletOrder = (JSONObject) item;
				map = new ObjectMapper().readValue(portletOrder.toJSONString(), Map.class);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateCompanyPortletOrder(map);
				/*ezNewPortalDAO.updateAllThemePortletOrder(map);*/ //테마별 포틀릿 순서에 적용하여 자동 저장
			}
		}
		logger.debug("updateCompanyPortletOrder ended.");
		
	}
	@Override
	public void deletePortlet(int portletId, int menuId, String companyId, int tenantId) throws Exception {
		logger.debug("deletePortlet started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletId", portletId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuId", menuId);
		
		//tbl_portal_portlet_user 지우기
		ezNewPortalDAO.deletePortletUser(map);
		
		//tbl_portal_portlet_name 지우기
		ezNewPortalDAO.deletePortletName(map);
		
		//tbl_portal_portlet_comp 지우기
		ezNewPortalDAO.deletePortletComp(map);
		
		//tbl_portal_portlet 지우기
		ezNewPortalDAO.deletePortlet(map);
		
		ezNewPortalDAO.deleteThemePortlet(map);

		// 2024-04-25 기범 : 포틀릿 삭제시 테마 포틀릿 데이터는 삭제 되지 않던 버그 수정 및 포틀릿 삭제시 권한도 지우도록 추가
		ezNewPortalDAO.deletePortletAuth(map);
		
		logger.debug("deletePortlet ended.");
	}
	
	@Override
	public void updateCompanyLogo(String companyId, int tenantId, String logoType, String logoUrl) {
		logger.debug("updateCompanyLogo started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("logoType", logoType);
		map.put("logoUrl", logoUrl);
		
		ezNewPortalDAO.updateCompanyLogo(map);
		logger.debug("updateCompanyLogo ended.");
	}
	
	@Override
	public List<PortalLogoVO> getCompanyLogoList(String companyId, int tenantId) {
		logger.debug("getCompanyLogoList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<PortalLogoVO> companyLogoList = ezNewPortalDAO.getCompanyLogoList(map);
		logger.debug("getCompanyLogoList ended.");
		return companyLogoList;
	}
	
	@Override
	public int getTnenantIdByServerName(String serverName) throws Exception {
		logger.debug("getTnenantIdByServerName started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("serverName", serverName);
		
		int tenantId = ezNewPortalDAO.getTenantIdByServerName(map);
		logger.debug("getTnenantIdByServerName ended.");
		return tenantId;
	}
	
	@Override
	public void updateCompanyDefaultTheme(int themeId, String companyId, int tenantId) throws Exception {
		logger.debug("updateCompanyDefaultTheme started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("themeId", themeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.updateCompanyDefaultTheme(map);
		logger.debug("updateCompanyDefaultTheme ended.");
	}
	
	@Override
	public void deleteCompanyLogo(String companyId, int tenantId, String logoType) {
		logger.debug("deleteCompanyLogo started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("logoType", logoType);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.deleteCompanyLogo(map);
		logger.debug("deleteCompanyLogo ended.");
	}
	
	@Override
	public List<BoardListVO> getBoardPortletInfo (String userId, int tenantId, String boardId, int itemCount, String companyId, String offset, boolean isQnANormal) throws Exception {
		return getBoardPortletInfo(userId, tenantId, boardId, itemCount, companyId, offset, isQnANormal, 0);
		
	}
	
	@Override
	public List<BoardListVO> getBoardPortletInfo(String userId, int tenantId, String boardId, int itemCount, String companyId, String offset, boolean isQnANormal, int startRow) throws Exception {
		logger.debug("getBoardPortletInfo started.");
		Map<String, Object> map = new HashMap<String, Object>();
		String nowDate = commonUtil.getTodayUTCTime("");
		map.put("boardId", boardId);
		map.put("itemCount", itemCount);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("nowDate", nowDate);
		map.put("userId", userId);
		map.put("isQnANormal", isQnANormal ? "Y" : "N");
		map.put("startRow", startRow);

		logger.debug("getBoardPortletInfo ended.");
		return ezNewPortalDAO.getBoardPortletInfo(map);
	}
	
	@Override
	public int getBoardPortletTotalCnt(String userId, int tenantId, String boardId, String companyId, String offset, boolean isQnANormal) throws Exception {
		logger.debug("getBoardPortletInfo started.");
		Map<String, Object> map = new HashMap<String, Object>();
		String nowDate = commonUtil.getTodayUTCTime("");
		map.put("boardId", boardId);
		map.put("tenantId", tenantId);
		map.put("nowDate", nowDate);
		map.put("userId", userId);
		map.put("isQnANormal", isQnANormal ? "Y" : "N");

		logger.debug("getBoardPortletInfo ended.");
		return ezNewPortalDAO.getBoardPortletTotalCnt(map);
	}

	@Override
	public List<PortletInfoVO> getThemePortletList(int themeId, int tenantId, String companyId, String lang) throws Exception {
		logger.debug("getThemePortletList started.");
		List<PortletInfoVO> themePortletList = new ArrayList<PortletInfoVO>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("themeId", themeId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		if (lang != null) {
			map.put("lang", Integer.parseInt(lang));
		} else {
			map.put("lang", 1);
		}
		
		
		themePortletList = ezNewPortalDAO.getThemePortletList(map);
		logger.debug("getThemePortletList ended.");
		return themePortletList;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void updateThemePortletUsed(int themeId, int tenantId, String companyId, JSONArray themePortletList) throws Exception {
		logger.debug("updateThemePortletUsed started.");
		Map<String, Object> map = new HashMap<String, Object>();
		
		for (Object item : themePortletList) {
			if (item instanceof JSONObject) {
				JSONObject themePortlet = (JSONObject) item;
				
				map = new ObjectMapper().readValue(themePortlet.toJSONString(), Map.class);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				map.put("themeId", themeId);
				
				ezNewPortalDAO.updateThemePortletUsed(map);
			}
		}
		
		logger.debug("updateThemePortletUsed ended.");
	}
	
	@Override
	public Map<String, Object> getThemeAuth(String companyId, int tenantId, int themeId, String lang) throws Exception {
		logger.debug("getThemeAuth started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("themeId", themeId);
		map.put("lang", lang);

		map.put("accessType", "1");
		List<Map<String, Object>> themeAuthsY = ezNewPortalDAO.getThemeAuth(map);
		
		map.put("accessType", "0");		
		List<Map<String, Object>> themeAuthsN = ezNewPortalDAO.getThemeAuth(map);
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("themeAuthsY", themeAuthsY);
		resultMap.put("themeAuthsN", themeAuthsN);
		
		logger.debug("getThemeAuth ended.");
		
		return resultMap;
	}
	@SuppressWarnings("unchecked")
	@Override
	public void updateThemeAuth(JSONArray themeAuths, int themeId, String companyId, int tenantId) throws Exception {
		logger.debug("updateThemeAuth started.");
		logger.debug("themeAuths = " + themeAuths.toString());
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("themeId", themeId);
		
		//update 시 기존에 있던 메뉴 권한 삭제 후 insert
		ezNewPortalDAO.deleteThemeAuth(map);
		int idx = 1;
		
		for (Object item : themeAuths) {
			if (item instanceof JSONObject) {
				JSONObject themeAuth = (JSONObject) item;
				
				map = new ObjectMapper().readValue(themeAuth.toJSONString(), Map.class);
				
				if (map.get("userName") == null) {
					map.put("userName", "");
				} else {
					map.put("userName", commonUtil.stripScriptTags(map.get("userName").toString()));
				}
				
				map.put("userId", commonUtil.stripScriptTags(map.get("userId").toString()));
				map.put("userDeptName", commonUtil.stripScriptTags(map.get("userDeptName") != null? map.get("userDeptName").toString() : ""));
				
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				map.put("themeId", themeId);
				map.put("sn", idx);
				
				ezNewPortalDAO.insertThemeAuth(map);
				
				idx++;
			}
		}
		logger.debug("updateThemeAuth ended.");
	}
	@Override
	public boolean checkThemeAuthNoList(String companyId, int tenantId, String userId, String deptPath, int themeId, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<ThemeInfoVO> themeList = getThemes(true, companyId, tenantId, "", null, lang);
		
		if (themeList == null || themeList.size() == 0) {
			return false;
		}
		
		themeList.removeIf(vo -> (vo.getThemeId() == themeId));
		List<ThemeAuthVO> userThemeDeniedList = new ArrayList<ThemeAuthVO>();
		List<Integer> themeAuthList = new ArrayList<Integer>();
		
		//먼저 사용자 권한 체크
		if (userId != null) {
			map.put("isDept", "user");
			map.put("userId", userId);
			userThemeDeniedList = ezNewPortalDAO.checkThemeAuthNoList(map);
			
			if (userThemeDeniedList != null && userThemeDeniedList.size() != 0) {
				for (ThemeAuthVO themeAuth : userThemeDeniedList) {
					themeAuthList.add(themeAuth.getThemeId());
					
					if (!themeAuth.isAccessYN()) {
						themeList.removeIf(vo -> (vo.getThemeId() == themeAuth.getThemeId()));
					}
					
					logger.debug("themeAuth : " + themeAuth.getThemeId());
					logger.debug("themeAuthList : " + themeAuthList.toString());
					logger.debug("themeList : " + themeList.toString());
				}
			}
		}
		
		if (userId != null && themeList.size() == 0) {
			return false;
		} else {
			map.put("isDept", "dept");
			String[] deptPathArr = deptPath.split(",");
			
			for (int i = deptPathArr.length - 1; i >= 0; i--) {
				map.put("userId", deptPathArr[i]);
				map.put("themeId", themeId);
				
				if (userId == null) {
					List<String> themeAuthInDept = ezNewPortalDAO.checkThemeAuthInDept(map);
					logger.debug("checkThemeAuthInDept deptId : " + deptPathArr[i] + ", themeAuthInDept : " + themeAuthInDept);
					
					if (themeAuthInDept != null && themeAuthInDept.size() > 0) {
						return false;
					}
				}
				
				userThemeDeniedList = ezNewPortalDAO.checkThemeAuthNoList(map);
				
				if (userThemeDeniedList != null && userThemeDeniedList.size() != 0) {
					for (ThemeAuthVO themeAuth : userThemeDeniedList) {
						if (themeAuthList.indexOf(themeAuth.getThemeId()) == -1) {
							themeAuthList.add(themeAuth.getThemeId());
							
							if (!themeAuth.isAccessYN()) {
								themeList.removeIf(vo -> (vo.getThemeId() == themeAuth.getThemeId()));
							}
							
							
							logger.debug("themeAuth : " + themeAuth.getThemeId());
							logger.debug("themeAuthList : " + themeAuthList.toString());
							logger.debug("themeList : " + themeList.toString());
						}
					}
					
					if (themeList.size() == 0) {
						return false;
					}
				}
			}
		}
		
		return true;
	}
	@Override
	public Map<String, Object> getPortletAuth(String companyId, int tenantId, int portletId, String lang) throws Exception {
		logger.debug("getPortletAuth started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletId", portletId);
		map.put("lang", lang);

		map.put("accessType", 1);
		List<Map<String, Object>> portletAuthsY = ezNewPortalDAO.getPortletAuth(map);
		
		map.put("accessType", 0);		
		List<Map<String, Object>> portletAuthsN = ezNewPortalDAO.getPortletAuth(map);
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("portletAuthsY", portletAuthsY);
		resultMap.put("portletAuthsN", portletAuthsN);
		
		logger.debug("getPortletAuth ended.");
		return resultMap;
	}
	@SuppressWarnings("unchecked")
	@Override
	public void updatePortletAuth(JSONArray portletAuths, int portletId, String companyId, int tenantId) throws Exception {
		logger.debug("updatePortletAuth started.");
		logger.debug("portletAuths = " + portletAuths.toString());
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletId", portletId);
		
		//update 시 기존에 있던 메뉴 권한 삭제 후 insert
		ezNewPortalDAO.deletePortletAuth(map);
		int idx = 1;
		
		for (Object item : portletAuths) {
			if (item instanceof JSONObject) {
				JSONObject portletAuth = (JSONObject) item;
				
				map = new ObjectMapper().readValue(portletAuth.toJSONString(), Map.class);
				
				if (map.get("userName") == null) {
					map.put("userName", "");
				} else {
					map.put("userName", commonUtil.stripScriptTags(map.get("userName").toString()));
				}
				
				map.put("userId", commonUtil.stripScriptTags(map.get("userId").toString()));
				map.put("userDeptName", commonUtil.stripScriptTags(map.get("userDeptName") != null ? map.get("userDeptName").toString() : ""));
				
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				map.put("portletId", portletId);
				map.put("sn", idx);
				
				ezNewPortalDAO.insertPortletAuth(map);
				idx++;
			}
		}
		logger.debug("updatePortletAuth ended.");
	}
	/**
	 * 이효진
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getApprovalList(String userId, String companyId, int tenantId, String offset, String type, String approvalFlag, String lang) throws Exception {
		logger.debug("getApprovalList started.");
		logger.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId + " || type = " + type);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("offset",commonUtil.getMinuteUTC(offset));
		
		List<ApprGDocListVO> list = null;
		JSONObject result = new JSONObject();
		
		switch (type) {
		case "doing":
			//결재할
			
			/*대리결제 표시 위해 추가 2019-03-05*/
			String userIDs = "'" + userId + "'";
			String proxyOption = "";
			proxyOption = ezApprovalGService.getIsUse("A23", "001", companyId, lang, tenantId);
			List<ApprGProxyVO> proxyList = null;

			if (proxyOption.equals("1")) {
//				userIDs = ezApprovalGService.getProxyUser(userId, lang, tenantId, offset);
				proxyList = ezApprovalGService.getProxyUserInfo(userId, lang, tenantId, offset);
			}
			
			/* 2024-07-09 홍승비 - SQL Injection 수정 > 사용자ID 리스트는 문자열 대신 배열로 전달 (현재 사용자 ID만 전달됨) */
			map.put("userIDs", userIDs.replace("'", "").replace(" ", "").split(","));
			map.put("proxyList", proxyList);
			
			list = ezNewPortalDAO.getApprovalDoingList(map);
			result.put("list", list);
			
			if (list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					if (approvalFlag.equalsIgnoreCase("G")) {
						map.put("code1", "A04");
					} else {
						map.put("code1", "SA04");
					}
					
					map.put("docId", list.get(i).getDocID());
					map.put("lang", lang.equals("1") ? "" : lang);
					
					//결재선 정보
					List<ApprGDocListVO> list2 = null;
					list2 = assembleApprPortletList(map);
					result.put("aprLines" + i, list2);
				}
			}
			break;
		case "reject":
			//반송
			list = ezNewPortalDAO.getApprovalRejectList(map);
			result.put("list", list);
			
			break;
		case "draft":
			//기안
			list = ezNewPortalDAO.getApprovalDraftList(map);
			result.put("list", list);
			
			break;
		case "display":
			// 공람 / 회람
			list = ezNewPortalDAO.getApprovalDisplayList(map);
			result.put("list", list);
			
			break;
		default:
			break;
		}
		
		logger.debug("getApprovalList ended.");
		
		return result;
	}
	
	private List<ApprGDocListVO> assembleApprPortletList(Map<String, Object> param) throws Exception {
		logger.debug("assembleApprPortletList started.");
		
		List<ApprGDocListVO> ret = new ArrayList<ApprGDocListVO>();
		int index = 0;
		boolean isUser = false;
		
		Iterator<ApprGDocListVO> it = ezNewPortalDAO.getApprovalDoingLines(param).iterator();
		
		/* 2024-07-09 홍승비 - SQL Injection 수정 > 사용자ID 리스트는 문자열 대신 배열로 전달 (현재 사용자 ID만 전달됨) */
		// 대리결재할 id
		String subId = ((String[]) param.get("userIDs"))[0];
		
		while (it.hasNext() && index < 3) {
			ApprGDocListVO vo = it.next();
			
			if (index == 0 && vo.getAprMemberSN().equalsIgnoreCase("1")) {
				ret.add(vo);
				index++;
			} else {
				// 현재 유저 결재선 정보와 바로 뒷 사람 정보까지 넣고 while문 종료!
				if (param.get("userId").toString().equalsIgnoreCase(vo.getAprMemberID()) || subId.equalsIgnoreCase(vo.getAprMemberID())) {
					ret.add(vo);
					index++;
					isUser = true;
				} else if (isUser && ret.size() < 3) {
					ret.add(vo);
					index++;
				}
			}
			
		}
		
		logger.debug("assembleApprPortletList ended.");
		
		return ret;
	}
	
	@Override
	public List<ThemeInfoVO> getThemes(boolean admin, String companyId, int tenantId, String userId, String deptPath, String lang) throws Exception {
		logger.debug("getThemes started. admin = " + admin + " || companyId = " + companyId + " || tenantId = " + tenantId + " || deptPath = " + deptPath + " || lang = " + lang);
		
		List<ThemeInfoVO> list = null;
		
		if (lang == null || lang.equals("")) {
			lang = "1";
		}
		
		if (admin) {
			list = getCompanyThemes(companyId, tenantId, lang);
		} else {
			list = getUserThemeList(companyId, tenantId, userId, deptPath, lang);
			// 2024-06-05 김유진 - 접근 가능한 userThemeList가 없을 경우, 회사의 기본 테마 가져오기
			if (list == null || list.size() == 0) {
				list = getCompThemeList(companyId, tenantId, lang);
			}
		}
		
		logger.debug("getThemes ended.");
		
		return list;
	}
	
	private List<ThemeInfoVO> getCompanyThemes(String companyId, int tenantId, String lang) throws Exception {
		logger.debug("getComapnyThemes started.");
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		List<ThemeInfoVO> list = ezNewPortalDAO.getCompanyThemes(map);
		
		logger.debug("getComapnyThemes ended.");
		
		return list;
	}
	
	@Override
	public ThemeInfoVO getThemeInfo(int themeId, String companyId, int tenantId, String lang) throws Exception {
		logger.debug("getThemeInfo started. themeId = " + themeId + " || companyId = " + companyId + " || tenantId = " + tenantId + " || lang = " + lang);
		
		Map<String, Object> map = new HashMap<>();
		map.put("themeId", themeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
		
		ThemeInfoVO vo = ezNewPortalDAO.getThemeInfo(map);
		
		logger.debug("getThemeInfo ended.");
		
		return vo;
	}
	
	@Override
	public List<FrameInfoVO> getFrames(int themeId, String companyId, int tenantId) throws Exception {
		logger.debug("getFrames started. themeId = " + themeId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("themeId", themeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<FrameInfoVO> list = ezNewPortalDAO.getFrames(map);
		
		logger.debug("getFrames ended.");
		
		return list;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void updateThemeInfo(JSONObject themeInfo, JSONArray frameInfos, String companyId, int tenantId) throws Exception {
		logger.debug("updateThemeInfo started. themeId = " + themeInfo.get("themeId") + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map = new ObjectMapper().readValue(themeInfo.toJSONString(), Map.class);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		if ((boolean)map.get("themeDefault")) {
			ezNewPortalDAO.updateThemeDefault(map);
		}
		
		boolean themeUsed = (boolean) map.get("themeUsed");
		
		ezNewPortalDAO.updateThemeInfo(map);
		
		if (!themeUsed) {
			//현재 테마를 사용하고 있던 사원들의 테마와 프레임을 회사의 기본 테마, 기본 프레임으로 가도록 설정
			ezNewPortalDAO.updateUserThemeAndFrameDefault(map);
		}
		
		for (Object item : frameInfos) {
			if (item instanceof JSONObject) {
				JSONObject frameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(frameInfo.toJSONString(), Map.class);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateFrameInfo(map);
			}
		}
		
		for (Object item : frameInfos) {
			if (item instanceof JSONObject) {
				JSONObject frameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(frameInfo.toJSONString(), Map.class);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				boolean frameUsed = (boolean) map.get("frameUsed");
				
				if (!frameUsed) {
					//사용하지 않는 프레임을 기존에 사용하고 있는 사원들의 프레임 아이디를 변경
					ezNewPortalDAO.updateUserFrameDefault(map);
				}
			}
		}
		
		logger.debug("updateThemeInfo ended.");
	}
	
	@Override
	public List<MenuInfoVO> getMenus(String companyId, int tenantId, String menuLang, String type) throws Exception {
		logger.debug("getMenus started. companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuLang", menuLang);
		map.put("type", type);
		
		List<MenuInfoVO> list = ezNewPortalDAO.getMenus(map);
		
		logger.debug("getMenus ended.");
		
		return list;
	}
	
	@Override
	public MenuInfoVO getMenuInfo(int menuId, String companyId, int tenantId, String menuLang) throws Exception {
		logger.debug("getMenuInfo started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuId", menuId);
		map.put("menuLang", menuLang);
		
		MenuInfoVO vo = ezNewPortalDAO.getMenuInfo(map);
		
		logger.debug("getMenuInfo ended.");
		
		return vo;
	}
	
	public List<MenuNameVO> getMenuNames(int menuId, String usePrimaryLangOnly, String primaryLang, String companyId, int tenantId, String useJapanese, String useChinese, String useVietnamese, String useIndonesian) throws Exception {
		logger.debug("getMenuNames started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuId", menuId);
		map.put("useJapanese", useJapanese);
		map.put("useChinese", useChinese);
		map.put("useVietnamese", useVietnamese);
		map.put("useIndonesian", useIndonesian);
		
		if (usePrimaryLangOnly.equals("YES")) {
			map.put("primaryLang", primaryLang);
		}
		
		List<MenuNameVO> list = ezNewPortalDAO.getMenuNames(map);
		
		logger.debug("getMenuNames ended.");
		
		return list;
	}
	
	@Override
	public Map<String, Object> getMenuAuth(int menuId, String companyId, int tenantId, String lang) throws Exception {
		logger.debug("getMenuAuth started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId + " || lang = " + lang);
		
		Map<String, Object> map = new HashMap<>();
		map.put("menuId", menuId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("lang", lang);
//		map.put("accessType", "Y","N","TOTAL")
		map.put("accessType", "1");
		List<MenuAuthVO> menuAuthsY = ezNewPortalDAO.getMenuAuth(map);
		
		map.put("accessType", "0");		
		List<MenuAuthVO> menuAuthsN = ezNewPortalDAO.getMenuAuth(map);
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("menuAuthsY", menuAuthsY);
		resultMap.put("menuAuthsN", menuAuthsN);
		
		logger.debug("getMenuAuth ended.");
		
		return resultMap;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void updateCompanyMenuInfo(int menuId, JSONObject menuInfo, JSONArray menuNames, String companyId, int tenantId) throws Exception {
		logger.debug("updateCompanyMenuInfo started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		logger.debug("menuInfo = " + menuInfo.toString());
		logger.debug("menuNames = " + menuNames.toString());
		
		boolean menuUsed = (boolean) menuInfo.get("menuUsed");
		
		Map<String, Object> map = new HashMap<>();
		//secure coding 적용
		map.put("menuId", menuId);
		
		String menuUrl = menuInfo.get("menuUrl").toString();
		menuUrl = commonUtil.stripScriptTags(menuUrl);
		menuUrl = commonUtil.detectPathTraversal(menuUrl);
		menuUrl = specialCharacterToEmptyString(menuUrl);
		
		String iconUrl = menuInfo.get("iconUrl").toString();
		iconUrl = commonUtil.stripScriptTags(iconUrl);
		iconUrl = commonUtil.detectPathTraversal(iconUrl);
		iconUrl = specialCharacterToEmptyString(iconUrl);
		
		map.put("menuUrl", menuUrl);
		map.put("menuType", menuInfo.get("menuType"));
		map.put("openType", menuInfo.get("openType"));
		map.put("iconUrl", iconUrl);
		map.put("menuUsed", menuUsed);
		map.put("companyLang", menuInfo.get("companyLang"));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.updateCompanyMenuUsed(map);
		ezNewPortalDAO.updateCompanyMenuInfo(map);
		
		for (Object item : menuNames) {
			if (item instanceof JSONObject) {
				JSONObject menuNameInfo = (JSONObject) item;
				map = new ObjectMapper().readValue(menuNameInfo.toJSONString(), Map.class);
				
				String menuLang = commonUtil.stripScriptTags(map.get("menuLang").toString());
				menuLang = commonUtil.detectPathTraversal(menuLang);
				menuLang = specialCharacterToEmptyString(menuLang);
				
				String menuName = commonUtil.stripScriptTags(map.get("menuName").toString());
				menuName = commonUtil.detectPathTraversal(menuName);
				menuName = specialCharacterToEmptyString(menuName);
				
			    menuName = menuName.replaceAll("& #40;", "(");
			    menuName = menuName.replaceAll("& #41;", ")");
			    
				map.put("menuLang", menuLang);
				map.put("menuName", menuName);
				
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateCompanyMenuNameInfo(map);
			}
		}
		
		if (!menuUsed) {
			//portlet used -> false
			updateMenuPortletUsed(menuId, menuUsed, companyId, tenantId);
		}
		
		logger.debug("updateCompanyMenuInfo ended.");
	}
	
	//메뉴사용여부에 따라 관련포틀릿 사용여부 수정
	private void updateMenuPortletUsed(int menuId, boolean portletUsed, String companyId, int tenantId) throws Exception {
		logger.debug("updateMenuPortletUsed started. menuId = " + menuId + " || menuUsed = " + portletUsed + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("menuId", menuId);
		map.put("portletUsed", portletUsed);
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		
		ezNewPortalDAO.updateMenuPortletUsed(map);
		
		logger.debug("updateMenuPortletUsed ended.");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void updateMenuAuth(JSONArray menuAuths, int menuId, String companyId, int tenantId) throws Exception {
		logger.debug("updateMenuAuth started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		logger.debug("menuAuths = " + menuAuths.toString());
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuId", menuId);
		
		//update 시 기존에 있던 메뉴 권한 삭제 후 insert
		ezNewPortalDAO.deleteMenuAuth(map);
		
		int index = 0;
		
		for (Object item : menuAuths) {
			if (item instanceof JSONObject) {
				JSONObject menuAuth = (JSONObject) item;
				
				map = new ObjectMapper().readValue(menuAuth.toJSONString(), Map.class);
				
				if (map.get("userName") == null) {
					map.put("userName", "");
				} else {
					map.put("userName", commonUtil.stripScriptTags(map.get("userName").toString()));
				}
				
				map.put("userId", commonUtil.stripScriptTags(map.get("userId").toString()));
				map.put("userDeptName", commonUtil.stripScriptTags(""));
				map.put("sn", index);
				
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				map.put("menuId", menuId);
				
				ezNewPortalDAO.updateMenuAuth(map);
				
				index++;
			}
		}
		
		logger.debug("updateMenuAuth ended.");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void insertMenu(JSONObject menuInfo, JSONArray menuNames, JSONArray menuAuths, String companyId, int tenantId) throws Exception {
		logger.debug("insertMenu started.");
		
		Map<String, Object> map = new HashMap<>();
		
		//메뉴
		map = new ObjectMapper().readValue(menuInfo.toJSONString(), Map.class);
		
		//2019.02.19 정보 저장시 secure coding 적용
		String menuUrl = commonUtil.stripScriptTags(map.get("menuUrl").toString());
		menuUrl = commonUtil.detectPathTraversal(menuUrl);
		menuUrl = specialCharacterToEmptyString(menuUrl);
		
		if (map.get("iconUrl") != null) {
			String iconUrl = commonUtil.stripScriptTags(map.get("iconUrl").toString());
			iconUrl = commonUtil.detectPathTraversal(iconUrl);
			iconUrl = specialCharacterToEmptyString(iconUrl);
			
			map.put("iconUrl", iconUrl);
		}
		
		map.put("menuUrl", menuUrl);
		
		//tbl_portal_menu
		int menuId = ezNewPortalDAO.insertMenu(map);
		
		map.put("menuId", menuId);
		map.put("companyLang", 1);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.insertMenuComp(map);
		
		//메뉴이름
		for (Object item : menuNames) {
			if (item instanceof JSONObject) {
				JSONObject menuNameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(menuNameInfo.toJSONString(), Map.class);
				//2019.02.19 정보 저장시 secure coding 적용
				String menuLang = commonUtil.stripScriptTags(map.get("menuLang").toString());
				menuLang = commonUtil.detectPathTraversal(menuLang);
				menuLang = specialCharacterToEmptyString(menuLang);
				
				String menuName = commonUtil.stripScriptTags(map.get("menuName").toString());
				menuName = commonUtil.detectPathTraversal(menuName);
				menuName = specialCharacterToEmptyString(menuName);
				
			    menuName = menuName.replaceAll("& #40;", "(");
			    menuName = menuName.replaceAll("& #41;", ")");
				
				map.put("menuLang", menuLang);
				map.put("menuName", menuName);
				
				map.put("menuId", menuId);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateCompanyMenuNameInfo(map);
			}
		}
		
		//권한은 셀렉트키로 받아서 ezNewPortal.updateCompanyMenuNameInfo
		updateMenuAuth(menuAuths, menuId, companyId, tenantId);
		
		logger.debug("insertMenu ended.");
	}
	
	@Override
	public void deleteMenu(int menuId, String companyId, int tenantId) throws Exception {
		logger.debug("deleteMenu started.");
		
		Map<String, Object> map = new HashMap<>();
		map.put("menuId", menuId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		//deletePortlet ---- 2018-11-07 유은정 개발
		//메뉴아이디에 포함되어있는 포틀릿 아이디 목록 가져오기
		List<Integer> portletList = ezNewPortalDAO.getPortletIdsByMenuId(map);
		int portletListCount = portletList.size();
		
		for (int i = 0; i < portletListCount; i++) {
			int portletId = portletList.get(i);
			map.put("portletId", portletId);
			
			ezNewPortalDAO.deletePortletUser(map);
			ezNewPortalDAO.deletePortletName(map);
			ezNewPortalDAO.deletePortletComp(map);
			ezNewPortalDAO.deletePortlet(map);
		}
		
		ezNewPortalDAO.deleteMenuUser(map);
		ezNewPortalDAO.deleteMenuAuth(map);
		ezNewPortalDAO.deleteMenuNames(map);
		ezNewPortalDAO.deleteMenuComp(map);
		ezNewPortalDAO.deleteMenu(map);
		
		logger.debug("deleteMenu ended.");
	}
	
	@Override
	public void udpateMenuOrder(JSONArray menus, String companyId, int tenantId) throws Exception {
		logger.debug("updateMenuOrder started. companyId = " + companyId + " || tenantId = " + tenantId);
		logger.debug("menus = " + menus.toString());
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		for (Object item : menus) {
			if (item instanceof JSONObject) {
				JSONObject menuInfo = (JSONObject) item;
				map.put("menuId", menuInfo.get("menuId"));
				map.put("companyOrder", menuInfo.get("companyOrder"));
				
				ezNewPortalDAO.updateMenuOrder(map);
			}
		}
		
		logger.debug("updateMenuOrder ended.");
	}
	
	@Override
	public List<ApprGFormVO> getFavoriteForms(String userId, String companyId, int tenantId, String deptId) throws Exception {
		logger.debug("getFavoriteForms started.");
		logger.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId + " || deptId = " + deptId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("deptId", deptId);
		
		List<ApprGFormVO> list = ezNewPortalDAO.getFavoriteForms(map);
		
		logger.debug("getFavoriteForms ended.");
		
		return list;
	}
	
	@Override
	public Map<String, Object> getApprovalStatistics(String userId, String companyId, int tenantId) throws Exception {
		logger.debug("getApprovalStatistics started.");
		logger.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId);		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		Map<String, Object> result = ezNewPortalDAO.getApprovalStatistics(map);
		
		logger.debug("getApprovalStatistics ended.");
		
		return result;
	}
	
	@Override
	public int getThemeId(String userId, String companyId, int tenantId) throws Exception {
		logger.debug("getThemeId started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		int themeId = ezNewPortalDAO.getThemeId(map);
		
		logger.debug("getThemeId ended. themeId = " + themeId);
		
		return themeId;
	}
	
	/** -------------------- */
	
	/**
	 * 구해안
	 */
	
	@Override
	public List<FavoriteBoardVO> getFavNewItemList(String userId, int tenantId, String companyId, String nowDate, int limit, String offset) {
		return getFavNewItemList(userId,tenantId, companyId, nowDate, 0, limit, offset);
	}
	
	@Override
	public List<FavoriteBoardVO> getFavNewItemList(String userId, int tenantId, String companyId, String nowDate, int startRow, int limit, String offset) {
		logger.debug("getFavNewItemList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("nowDate", nowDate);
		map.put("limit", limit);
		map.put("startRow", startRow);
		map.put("v_OFFSETMIN", offset);
		
		List<FavoriteBoardVO> favNewItemList = ezNewPortalDAO.getFavNewItemList(map);
		
		logger.debug("getFavNewItemList ended.");
		return favNewItemList;
	}
	
	@Override
	public int getFavNewItemListCnt(String userId, int tenantId, String companyId, String nowDate, String offset) {
		logger.debug("getFavNewItemListCnt started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("nowDate", nowDate);
		map.put("v_OFFSETMIN", offset);
		
		logger.debug("getFavNewItemListCnt ended.");
		return ezNewPortalDAO.getFavNewItemListCnt(map);
		
	}
	
	@Override
	public List<FavoriteBoardVO> getFavItemList(String boardId, int tenantId, String companyId, int limit, String offset) throws Exception {
		return getFavItemList(boardId, tenantId, companyId, 0, limit, offset);
	}
	
	@Override
	public List<FavoriteBoardVO> getFavItemList(String boardId, int tenantId, String companyId, int startRow, int limit, String offset) throws Exception {
		logger.debug("getFavItemList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		String nowDate = commonUtil.getTodayUTCTime("");
		map.put("boardId", boardId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("limit", limit);
		map.put("startRow", startRow);
		map.put("v_OFFSETMIN", offset);
		map.put("nowDate", nowDate);
		
		List<FavoriteBoardVO> FavItemList = ezNewPortalDAO.getFavItemList(map);
		
		logger.debug("getFavItemList ended.");
		return FavItemList;
		
	}
	
	@Override
	public int getFavItemListCnt(String boardId, int tenantId, String companyId, String offset) throws Exception {
		logger.debug("getFavItemList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		String nowDate = commonUtil.getTodayUTCTime("");
		map.put("boardId", boardId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("nowDate", nowDate);
		logger.debug("getFavItemList ended.");
		return ezNewPortalDAO.getFavItemListCnt(map);
	}
	
	@Override
	public List<CommunityMyCommunityVO> getCommunityList(String lang, int startRow, int listSize, String companyId, int tenantId) throws Exception {
		logger.debug("getCommunityList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANG", commonUtil.getMultiData(lang, tenantId));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("listSize", listSize);
		map.put("startRow", startRow);
		
		List<CommunityMyCommunityVO> CommunityList = ezNewPortalDAO.getCommunityList(map);
		
		logger.debug("getCommunityList ended.");
		return CommunityList;
	}
	
	@Override
	public int getCommunityListTotalCnt(String companyId, int tenantId) throws Exception {
		logger.debug("getCommunityListTotalCnt started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		logger.debug("getCommunityListTotalCnt ended.");
		return ezNewPortalDAO.getCommunityListTotalCnt(map);
	}
	
	@Override
	public String getCommunityPermit(String cNo, String userId, int tenantId) {
		logger.debug("getCommunityPermit started");

		String ret = "1";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("clubNo", cNo);
		map.put("tenantId", tenantId);
		
		CommunityCClubUserVO result = ezNewPortalDAO.getCommunityPermit(map);
		
		if (result != null) {
			ret = "1";
		} else {
			ret = "0";
		}

		logger.debug("getCommunityPermit ended");
		return ret;
	}
	
	@Override
	public List<PortletInfoVO> getPortletList(String companyId, int tenantId, int menuLang, String type) {
		logger.debug("getPortletList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuLang", menuLang);
		map.put("portletType", type);
		
		List<PortletInfoVO> portetList = ezNewPortalDAO.getPortletList(map);
		
		logger.debug("getPortletList ended");
		return portetList;
	}
	
	@Override
	public List<PortletNameInfoVO> getPortletNameList(String companyId, int tenantId, int portletId) throws Exception {

		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletId", portletId);
		
		map.put("useChinese", ezCommonService.getTenantConfig("useChinese", tenantId));
		map.put("useVietnamese", ezCommonService.getTenantConfig("useVietnamese", tenantId));
		map.put("useIndonesian", ezCommonService.getTenantConfig("useIndonesian", tenantId));
		
		List<PortletNameInfoVO> portetList = ezNewPortalDAO.getPortletNameList(map);
		
		return portetList;
	}
	
	@Override
	public void setWeather() throws Exception {
		//weather가 current일 때 현재 날씨 today일 때 시간당 날씨
		logger.debug("setWeather started");
		List<String> primaryLangList = ezNewPortalDAO.getPrimaryLangList();
		List<String> weatherKeyList = ezNewPortalDAO.getWeatherKeyList(primaryLangList.size());
		List<String> cityCodeList = ezNewPortalDAO.getCityCodeList(primaryLangList);
		URL url;
		URL todayUrl;
		InputStreamReader isr;
		JSONObject jsonTemp;

		String cityCode = "";

		if (primaryLangList.isEmpty()) {
			throw new Exception("There is no weather API Key");
		}

//		for (int i = 0; i < weatherKeyList.size(); i++) {
		int cityCodeListSize = cityCodeList.size();
		int limit = cityCodeListSize / 20 + 1;
		int idx = 0;

		/* codeList list must be in range from 1 to 20 */
		for (int cnt = 0; cnt < limit; cnt++) {
			List<String> weatherUpdateTarget = new ArrayList<>();
			StringBuilder weatherQueryList = new StringBuilder();

			while (cityCodeListSize > idx) {
				String tmp = cityCodeList.get(idx);
				weatherUpdateTarget.add(tmp);

				if ((idx + 1) % 20 == 0) {
					weatherQueryList.append(tmp);
					idx++;

					break;
				}

				weatherQueryList.append(
					tmp
				).append(
					","
				);
				idx++;
			}

			url = new URL("http://api.openweathermap.org/data/2.5/group?" + "id=" + weatherQueryList + "&units=metric" + "&appid=" + weatherKeyList.get(0));
			isr = new InputStreamReader(url.openConnection().getInputStream(),"UTF-8");
			
			JSONObject items = (JSONObject) JSONValue.parseWithException(isr); 
			JSONArray jsonCurrentWeatherArr = (JSONArray)items.get("list");
			
			for (int j = 0; j < jsonCurrentWeatherArr.size(); j++) {
				String currentWeather = "";
				JSONObject jsonCurrentWeather = (JSONObject)jsonCurrentWeatherArr.get(j);
				JSONArray jsonTempArr = (JSONArray)jsonCurrentWeather.get("weather");
				jsonTemp = (JSONObject)jsonTempArr.get(0);
				currentWeather += jsonTemp.get("icon").toString() + ";" + jsonTemp.get("main").toString() + ";";
				
				jsonTemp = (JSONObject)jsonCurrentWeather.get("main");
				currentWeather += jsonTemp.get("temp").toString() + ";" + jsonTemp.get("humidity").toString() + ";";
				
				jsonTemp = (JSONObject)jsonCurrentWeather.get("clouds");
				currentWeather += jsonTemp.get("all").toString() + ";";
				
				jsonTemp = (JSONObject)jsonCurrentWeather.get("wind");
				currentWeather += jsonTemp.get("speed").toString();
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("cityCode", weatherUpdateTarget.get(j));
				map.put("currentWeather", currentWeather);

				ezNewPortalDAO.setCurrentWeather(map);
			}
			
			//3시간당 오늘의 날씨
			String todayWeather;
			
			for (String tempCityCode : weatherUpdateTarget) {
				todayWeather = "";
				todayUrl = new URL("http://api.openweathermap.org/data/2.5/forecast?" + "id=" + tempCityCode + "&cnt=5&units=metric" + "&appid=" + weatherKeyList.get(0));
				
				isr = new InputStreamReader(todayUrl.openConnection().getInputStream(),"UTF-8");
				items = (JSONObject) JSONValue.parseWithException(isr);
				
				JSONArray todayArr = (JSONArray)items.get("list");
				
				for (int j = 0; j < todayArr.size(); j++) {
					JSONObject jsonToday = (JSONObject)todayArr.get(j);
					JSONObject jsonTodayWeather = (JSONObject)((JSONArray)jsonToday.get("weather")).get(0);
					
					todayWeather += jsonTodayWeather.get("icon") + ";";
					todayWeather += ((JSONObject)jsonToday.get("main")).get("temp") + ";";
					//dt_txt 는 yyyy-mm-dd hh:mm:ss 형식의 데이터
					todayWeather += jsonToday.get("dt_txt") + "!";
				}
				
				todayWeather = todayWeather.substring(0, todayWeather.length() - 1);
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("cityCode", tempCityCode);
				map.put("todayWeather", todayWeather);
				
				ezNewPortalDAO.setTodayWeather(map);
			}
		}

		logger.debug("setWeather ended");
	}
	
	@Override
	public Map<String, Object> getWeather(String cityCode, int primary, String countryCode) {
		logger.debug("getWeather started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cityCode", cityCode);
		map.put("primaryLang", primary);
		map.put("countryCode", countryCode);
		
		Map<String, Object> result = ezNewPortalDAO.getWeather(map);
		
		logger.debug("getWeather ended.");
		
		return result;
	}
	
	@Override
	public List<WeatherVO> getCityList(int primaryLang, String countryCode) {
		logger.debug("getCityList started.");

		List<WeatherVO> result = ezNewPortalDAO.getCityList(primaryLang, countryCode);
		
		logger.debug("getCityList ended.");
		return result;
	}
	
	@Override
	public String getUserCityCode(String id, int tenantId) throws Exception {
		logger.debug("getUserCityCode started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("userId", id);
		logger.debug("getUserCityCode started.");
		
		return ezNewPortalDAO.getUserCityCode(map);
		
	}
	@Override
	public void setUserCityCode(String id, int tenantId, String cityCode, String countryCode) {
		logger.debug("setUserCityCode started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", id);
		map.put("tenantId", tenantId);
		map.put("cityCode", cityCode);
		map.put("countryCode", countryCode);
		
		ezNewPortalDAO.setUserCityCode(map);
		logger.debug("setUserCityCode started.");
	}
	
	@Override
	public boolean getCheckAuth(int menuId, String userId, String deptId, String companyId, int tenantId) throws Exception {
		logger.debug("getCheckAuth started. menuId : " + menuId);
		
		boolean resultAuth = false;
		int userType = 1;
		
		//첨으로 유저 정보 권한을 받는다
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("menuId", menuId);
		map.put("userId", userId);
		map.put("userType", userType);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		MenuAuthVO userAuth = ezNewPortalDAO.getCheckUserAuth(map);

		if (userAuth != null) {
			//유저 권한이 있으면 바로 리턴
			if (userAuth.isAccessYN() == true) {
				resultAuth = true;
				logger.debug("Auth : userTrue");
				return resultAuth;
			} else {
				resultAuth = false;
				logger.debug("Auth : userFalse");
				return resultAuth;
			}
		} else {
			//유저 권한이 없을때 부서 권한을 탐색한다
			Map<String, Object> map2 = new HashMap<String, Object>();
			userType = 0;
			map2.put("menuId", menuId);
			map2.put("userId", deptId);
			map2.put("userType", userType);
			map2.put("tenantId", tenantId);
			map2.put("companyId", companyId);
			
			MenuAuthVO deptAuth = ezNewPortalDAO.getCheckDeptAuth(map2);
			
			if (deptAuth != null) {
				//유저권한이 없으면 부서권한을 탐색하고 부서권한이 있을 때 바로 리턴 
				if (deptAuth.isAccessYN() == true) {
					resultAuth = true;
					logger.debug("Auth : deptTrue");
					return resultAuth;
				} else {
					resultAuth = false;
					logger.debug("Auth : deptFalse");
					return resultAuth;
				}
			} else {
				Map<String, Object> map3 = new HashMap<String, Object>();
				userType = 0;
				map3.put("menuId", menuId);
				map3.put("userId", companyId);
				map3.put("userType", userType);
				map3.put("tenantId", tenantId);
				map3.put("companyId", companyId);
				//유저, 부서권한 둘다 없을때 마지막으로 회사권한을 탐색한다
				MenuAuthVO comAuth = ezNewPortalDAO.getCheckcomAuth(map3);
				
				if (comAuth != null) {
					//유저든 부서든 둘다 Y,N이 있을때만 company 권한보다 앞서므로 다 권한이 모두 없을 때 마지막에 company를 탐색하였다
					if (comAuth.isAccessYN() == true) {
						logger.debug("Auth : comTrue");
						resultAuth = true;
						return resultAuth;
					} else {
						resultAuth = false;
						logger.debug("Auth : comFalse");
						return resultAuth;
					}
				} else {
					resultAuth = false;
					logger.debug("Auth : NoneFalse");
					return resultAuth;
				}
			}
		}
	}
	
	public List<MenuInfoVO> getAllCompanyMenus(String companyId, int tenantId, String companyLang) throws Exception {
		logger.debug("getAllCompanyMenus started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("langType", companyLang);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<MenuInfoVO> comMenuList = ezNewPortalDAO.getAllCompanyMenus(map);
		
		logger.debug("getAllCompanyMenus ended.");
		return comMenuList;
	};

	public String isUseEzWorkspace(String companyId, int tenantId, String userId, String deptId) throws Exception {
		logger.debug("isUseEzWorkspace started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("userId", userId);
		
		String result = ezNewPortalDAO.isUseEzWorkspace(map);
		
		if (result != null) {
			if (result.equalsIgnoreCase("0")) {
				return "NO";
			}
			return "YES";
		}

		String deptPath = ezOrganService.getDeptPath(deptId, tenantId);
		String[] deptArr = deptPath.split(",");
		
		for (int i=deptArr.length; i > 0; i--) {
			map.put("userId", deptArr[i-1]);

			// 존재하지 않으면 다음 for문 진행
			// 존재하면 true, false 체크해서 처리.
			result = ezNewPortalDAO.isUseEzWorkspace(map);
			
			if (result != null) {
				if (result.equalsIgnoreCase("0")) {
					return "NO";
				}
				return "YES";
			}
		}
		
		logger.debug("isUseEzWorkspace ended.");
		return "NO";
	}
	
	@Override
	public List<PersonalSliderImageVO> getSilderImages(String companyId, int tenantId) throws Exception {
		logger.debug("getSilderImages started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		logger.debug("getSilderImages ended.");
		return ezNewPortalDAO.getSilderImages(map);
	}
	
	@Override
	public void insertSlideImage(String companyId, int tenantId, String imageUrl, String slideImagePath, String fileName, String userId) throws Exception {
		logger.debug("insertSlideImage started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantID", tenantId);
		map.put("companyId", companyId);
		map.put("imageUrl", imageUrl);
		map.put("fileName", fileName);
		map.put("slideImagePath", slideImagePath);
		map.put("regUserId", userId);
		map.put("regDate", commonUtil.getTodayUTCTime(""));
		
		int count = ezNewPortalDAO.getSlideImageMaxSn(map);
		map.put("count", count);
		
		map.put("slideId", "slidePortletImage" + fileName.split("\\.")[0]);
		
		ezNewPortalDAO.insertSilderImages(map);
		
		logger.debug("insertSlideImage ended.");
	}
	
	@Override
	public PersonalSliderImageVO getSlideImageInfo(int tenantId, String companyId, String slideId) throws Exception {
		logger.debug("getSlideImageInfo started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("slideId", slideId);
		
		logger.debug("getSlideImageInfo ended.");
		return ezNewPortalDAO.getSilderImagInfo(map);
	}
	
	@Override
	public void updateSlideImage(String companyId, int tenantId, String imageUrl, String imagePath, String imageName, String userId, String slideId) throws Exception {
		logger.debug("updateSlideImage started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("imageUrl", imageUrl);
		map.put("fileName", imageName);
		map.put("slideImagePath", imagePath);
		map.put("regUserId", userId);
		map.put("regDate", commonUtil.getTodayUTCTime(""));
		map.put("slideId", slideId);
		
		ezNewPortalDAO.updateSilderImage(map);
		
		logger.debug("updateSlideImage ended.");
	}
	
	@Override
	public void deleteSlideImage(int tenantId, String companyId, String slideId) throws Exception {
		logger.debug("deleteSlideImage started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("slideId", slideId);
		
		ezNewPortalDAO.deleteSlideImage(map);
		
		logger.debug("deleteSlideImage ended.");
	}
	
	@Override
	public void updateSlideOrder(JSONArray slideList, String companyId,
			int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		for (Object item : slideList) {
			if (item instanceof JSONObject) {
				JSONObject slideInfo = (JSONObject) item;
				map.put("slideId", slideInfo.get("slideId"));
				map.put("order", slideInfo.get("order"));
				
				ezNewPortalDAO.updateSlideOrder(map);
			}
		}		
	}
	
	public String specialCharacterToEmptyString(String value) {
		value = value.replaceAll("\'", "");
		value = value.replaceAll("\"", "");
		value = value.replaceAll("\\+", "");
		value = value.replaceAll("@", "");
		value = value.replaceAll("\\$", "");
		value = value.replaceAll("AND ", "");
		value = value.replaceAll("OR ", "");
		value = value.replaceAll("and ", "");
		value = value.replaceAll("or ", "");
		value = value.replaceAll(";", "");
		value = value.replaceAll("%", "");
		value = value.replaceAll("#", "");
        value = value.replaceAll("<", "& lt;").replaceAll(">", "& gt;");
        value = value.replaceAll("\\(", "& #40;").replaceAll("\\)", "& #41;");
        value = value.replaceAll("'", "& #39;");
        value = value.replaceAll("eval\\((.*)\\)", "");
        value = value.replaceAll("[\\\"\\\'][\\s]*javascript:(.*)[\\\"\\\']", "\"\"");
        value = value.replaceAll("script", "");
		
		return value;
	}
	
	@Override
	public int getApprovalDoingListCount(String userId, String companyId, int tenantId, String offset, String approvalFlag, String lang) throws Exception {
		logger.debug("getApprovalDoingListCount started.");
		logger.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("offset",commonUtil.getMinuteUTC(offset));
		
		/*대리결제 표시 위해 추가 2019-03-05*/
		String userIDs = "'" + userId + "'";
		String proxyOption = "";
		proxyOption = ezApprovalGService.getIsUse("A23", "001", companyId, lang, tenantId);
		List<ApprGProxyVO> proxyList = null;

		if (proxyOption.equals("1")) {
//			userIDs = ezApprovalGService.getProxyUser(userId, lang, tenantId, offset);
			proxyList = ezApprovalGService.getProxyUserInfo(userId, lang, tenantId, offset);
		}
		
		/* 2024-07-09 홍승비 - SQL Injection 수정 > 사용자ID 리스트는 문자열 대신 배열로 전달 (현재 사용자 ID만 전달됨) */
		map.put("userIDs", userIDs.replace("'", "").replace(" ", "").split(","));
		map.put("proxyList", proxyList);
		int doingListCount = ezNewPortalDAO.getApprovalDoingListCount(map);
		
		return doingListCount;
	}
	
	@Override
	public List<OrganJobVO> getTitleList(String type, int tenantId, String companyId) throws Exception {
		logger.debug("getTitleList started.");
		logger.debug("[params] type = " + type + ", tenantId = " + tenantId + ", companyId = " + companyId);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_TENANTID", tenantId);
		map.put("v_COMPANYID", companyId);
		
		List<OrganJobVO> titleList = ezOrganAdminDAO.getTitleList_group(map);
		logger.debug("getTitleList ended.");
		return titleList;
	}
	
	@Override
	public List<OrganGroupVO> getGroupList(int tenantId, String companyId) throws Exception {
		logger.debug("getGroupList started.");
		logger.debug("[params] tenantId = " + tenantId + ", companyId = " + companyId);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANT_ID", tenantId);
		map.put("v_COMPANY_ID", companyId);
		
		List<OrganGroupVO> groupList = ezOrganAdminDAO.getGroupList(map);
		
		logger.debug("getGroupList ended.");
		return groupList;
	}
	
	@Override
	public List<FileVO> getWebFolderFileList(String folderId, int tenantId, int startRow, int folderListCount) throws Exception {
		logger.debug("getWebFolderFileList started.");
		logger.debug("folderId = " + folderId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("startRow", startRow);
		map.put("folderListCount", folderListCount);
		
		List<FileVO> fileList = ezNewPortalDAO.getWebFolderFileList(map);
		
		logger.debug("getWebFolderFileList ended.");
		return fileList;
	}
	
	@Override
	public int getWebFolderFileListTotalCnt(String folderId, int tenantId) throws Exception {
		logger.debug("getWebFolderFileListTotalCnt started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		
		int fileListTotalCnt = ezNewPortalDAO.getWebFolderFileListTotalCnt(map);
		
		logger.debug("getWebFolderFileListTotalCnt ended.");
		return fileListTotalCnt;
	}
	
//	@Override
//	public void updateThemePortlet(String portletId, int tenantId, String companyId, String menuId) {
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("portletId", portletId);
//		map.put("tenantId", tenantId);
//		map.put("companyId", companyId);
//		map.put("menuId", menuId);
//		
//		ezNewPortalDAO.updateThemePortlet(map);
//	}
	
	@Override
	public void addPortalTenantConfig(int tenantId, String propertyName, String propertyValue, String description, String configName, String configType) throws Exception {
		logger.debug("addPortalTenantConfig started");
		logger.debug("tenantId = " + tenantId + " || propertyName = " + propertyName + " || propertyValue = " + propertyValue + " || description = " + description + " || configName = " + configName + " || configType = " + configType);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("propertyName", propertyName);
		map.put("propertyValue", propertyValue);
		map.put("description", description);
		map.put("configName", configName);
		map.put("configType", configType);
		
		ezNewPortalDAO.addPortalTenantConfig(map);
		
		logger.debug("addPortalTenantConfig ended");
	}
	
	public String getUniqueFileName (String dirPath, String fileName) throws Exception {
		logger.debug("getUniqueFileName started");

		int indexOfDot = fileName.lastIndexOf(".");
		String strName = fileName.substring(0, indexOfDot);
		String strExt = fileName.substring(++indexOfDot);
		
		boolean bExist = true;
		int fileCount = 0;
		
		File file = new File(commonUtil.detectPathTraversal(dirPath + fileName)); 
		
		while (bExist) {
			if (file.exists()) {
				fileCount++;
				fileName = strName + "(" + fileCount + ")." + strExt;
			} else {
				bExist = false;
			}
		}

		logger.debug("getUniqueFileName ended");
		
		return fileName;
	}

	@Override
	public List<DeptViewVO> getDeptViewList(String userId, String companyId, int tenantId, String lang) throws Exception {
		logger.debug("getDeptViewList started");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<DeptViewVO> deptList = ezNewPortalDAO.getDeptViewVO(param);
		for (int i = 0; i < deptList.size(); i++) {
			deptList.get(i).setText(commonUtil.cleanValue(deptList.get(i).getText()));
		}

		logger.debug("getDeptViewList ended");
		return deptList;
	}

	@Override
	public List<MenuAuthorUserVO> getDeptUserList(int tenantId, String key , String value, String companyId, String lang, String curPage) throws Exception{
		logger.debug("getDeptUserList started");
		// 페이징 설정
		int pageSize = 50;
		int page = pageSize * (Integer.parseInt(curPage)-1);
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("key", key.toUpperCase());
		param.put("value", value);
		param.put("companyId", companyId);
		param.put("lang", lang);
		param.put("curPage", page);
		param.put("pageSize", pageSize);
		List<MenuAuthorUserVO> userList = ezNewPortalDAO.getDeptUserList(param);

		logger.debug("getDeptUserList ended");
		return userList;
	}

	public int getDeptUserListCount(int tenantId, String key ,String value, String companyId, String lang) throws Exception{
		logger.debug("getDeptUserListCount started");

		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("key", key.toUpperCase());
		param.put("value", value);
		param.put("companyId", companyId);
		param.put("lang", lang);

		int userListCount = ezNewPortalDAO.getDeptUserListCount(param);

		return userListCount;
	}

	/**
	 * 유저의 모든 본직/겸직 정보를 가져온다.
	 * @param lang
	 * @param userId
	 * @param tenantId
	 * @return egovframework.ezEKP.ezNewPortal.vo.PortalUserSwitchVO
	 * @throws Exception
	 */
	@Override
	public List<PortalUserSwitchVO> getArrayUserJob(String lang, String userId, int tenantId) throws Exception {

		Map<String, Object> map = new HashMap<>();
		map.put("v_CN", userId);
		map.put("v_TENANT_ID", tenantId);
		map.put("v_LANGDATA", lang);

		List<OrganUserVO> allUserInfo = ezOrganDAO.getAllUserInfo(map);
		List<PortalUserSwitchVO> userInfoList = new ArrayList<>();

		for (OrganUserVO vo : allUserInfo) {
			PortalUserSwitchVO portalUserSwitchVO = new PortalUserSwitchVO();
			portalUserSwitchVO.setCompanyId(vo.getCompanyId());
			portalUserSwitchVO.setCompanyName(vo.getCompany());
			portalUserSwitchVO.setCompanyName2(vo.getCompany2());
			portalUserSwitchVO.setDeptId(vo.getDepartment());
			portalUserSwitchVO.setDeptName(vo.getDescription() == null ? "" : vo.getDescription());
			portalUserSwitchVO.setDeptName2(vo.getDescription2() == null ? "" : vo.getDescription2());
			portalUserSwitchVO.setTitle(vo.getTitle() == null ? "" : vo.getTitle());
			portalUserSwitchVO.setTitle2(vo.getTitle2() == null ? "" : vo.getTitle2());
			portalUserSwitchVO.setJobId(vo.getJobID() == null ? "" : vo.getJobID());
			portalUserSwitchVO.setJobType(vo.getJobType() == null ? "" : vo.getJobType());
			userInfoList.add(portalUserSwitchVO);
		}

		return userInfoList;
	}

	@Override
	public void switchAllUserInfo(HttpServletRequest request, HttpServletResponse response, String loginCookie, String companyId, String deptId, String jobId, String jobType) throws Exception {

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		List<PortalUserSwitchVO> list = getArrayUserJob(userInfo.getLang(), userInfo.getId(), userInfo.getTenantId());

		Optional<PortalUserSwitchVO> optionalUserInfoVO = list.stream()
				.filter(vo -> companyId.equals(vo.getCompanyId()) && deptId.equals(vo.getDeptId()) && jobId.equals(vo.getJobId()))
				.findFirst();
		if (!optionalUserInfoVO.isPresent()) throw new Exception("switchAllUserInfo error");
		PortalUserSwitchVO infoVO = optionalUserInfoVO.get();
		ezApprovalGService.changeAprUserInfo(response,
				infoVO.getDeptId(), infoVO.getDeptName(), infoVO.getDeptName2(),
				infoVO.getCompanyName(), infoVO.getCompanyName2(),
				infoVO.getTitle(), infoVO.getTitle2(), infoVO.getCompanyId(), infoVO.getJobId());

		String cookieStr = ezOrganService.changeCookie(loginCookie, infoVO.getDeptId(), infoVO.getCompanyId(), userInfo.getTenantId(), Optional.ofNullable(jobId).orElse(""));
		Cookie cookie = new Cookie("loginCookie", cookieStr);
		cookie.setPath("/");
		response.addCookie(cookie);
	}

	@Override
	public List<String> getAllAvailablePortletSize() {
		return ezNewPortalDAO.getAllAvailablePortletSize();
	}

	@Override
	public Map<Integer, List<String>> getAvailablePortletSize(int themeId, String companyId, int tenantId) {
		Map<String, Object> map = new HashMap<>();
		map.put("themeId", themeId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		List<PortletInfoVO> infoVOList = ezNewPortalDAO.getAvailablePortletSize(map);
		return infoVOList.stream()
				.collect(Collectors.groupingBy(PortletInfoVO::getPortletId,
						Collectors.mapping(PortletInfoVO::getClassSize, Collectors.toList())));
	}

	@Override
	public void updateThemePortletSize(int themeId, int tenantId, String companyId, JSONArray sizeList) {
		Map<String, Object> map = new HashMap<>();
		map.put("themeId", themeId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		try {
			ezNewPortalDAO.clearPortletSize(map);

			ArrayList<Map<String, Object>> arrayList = new Gson().fromJson(sizeList.toJSONString(), new ArrayList<Map<String, Object>>().getClass());
			for (Map<String, Object> sizeMap : arrayList) {
				sizeMap.put("tenantId", tenantId);
				sizeMap.put("themeId", themeId);
				sizeMap.put("companyId", companyId);
			}

			ezNewPortalDAO.insertPortletSizeCompany(arrayList);
		} catch (Exception e) {
			logger.error("updateThemePortletSize error : " + e.getMessage(), e);
		}
	}

	@Override
	public void insertPortalTopFrameInfo(String userID, String companyID, int tenantID, TopFrameType type) throws Exception {
		PortalTopVO vo = new PortalTopVO();
		vo.setTenantID(tenantID);
		vo.setCompanyID(companyID);
		vo.setUserID(userID);
		vo.setType(type.getCode());

		ezNewPortalDAO.updatePortalTopFrameInfo(vo);
	}

	@Override
	public Optional<TopFrameType> getPortalTopFrameInfo(String userID, String companyID, int tenantID) throws Exception {
		PortalTopVO vo = new PortalTopVO();
		vo.setTenantID(tenantID);
		vo.setCompanyID(companyID);
		vo.setUserID(userID);
		
		PortalTopVO menudisplayInfo = ezNewPortalDAO.getUserMenuDisplayMode(vo);
		
		if (menudisplayInfo == null) {
			menudisplayInfo = Optional.ofNullable(ezNewPortalDAO.getTopMenuDisplayModeForCompany(vo)).orElse(new PortalTopVO());
		}
		
		return Optional.ofNullable(menudisplayInfo.getTypeEnum());
	}

	@Override
	public List<BoardListVO> getNewBoardPortletInfo(LoginVO userInfo, String userType, int startRow, int itemCount) throws Exception {
		logger.debug("getNewBoardPortletInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userInfo.getId());
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_TENANTID", userInfo.getTenantId());
		//map.put("iv_PORDERBYSUB", " A.WRITEDATE DESC ");
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("rowCount", itemCount);
		map.put("limit", startRow);
		map.put("userType",userType);
		
		logger.debug("getNewBoardPortletInfo ended");
		return ezNewPortalDAO.getNewBoardPortletInfo(map);
	}
	
	// 2024-05-17 한태훈 - 포탈 > 포탈 탑 메뉴 위치 회사 설정값 가져오는 메소드
	@Override
	public Optional<TopFrameType> getTopMenuDisplayModeForCompany(String companyId, int tenantId) throws Exception {
		logger.debug("getTopMenuDisplayModeForCompany started");
		
		PortalTopVO companyMenuDisplayVO = new PortalTopVO();
		companyMenuDisplayVO.setCompanyID(companyId);
		companyMenuDisplayVO.setTenantID(tenantId);
		PortalTopVO companyMenuDisPlayInfo = Optional.ofNullable(ezNewPortalDAO.getTopMenuDisplayModeForCompany(companyMenuDisplayVO)).orElse(new PortalTopVO());
		
		logger.debug("getTopMenuDisplayModeForCompany ended");
		
		return Optional.ofNullable(companyMenuDisPlayInfo.getTypeEnum());
	}
	
	// 2024-05-17 한태훈 - 포탈 > 포탈 탑 메뉴 위치 회사 설정값 수정하는 메소드
	@Override
	public void updateTopMenuDisplayModeForCompany(int type, String companyId, int tenantId) throws Exception {
		logger.debug("updateTopMenuDisplayModeForCompany started");
		
		PortalTopVO vo = new PortalTopVO();
		vo.setCompanyID(companyId);
		vo.setTenantID(tenantId);
		vo.setType(type);
		
		PortalTopVO companyMenuDiplayMode = ezNewPortalDAO.getTopMenuDisplayModeForCompany(vo);
		
		if (companyMenuDiplayMode == null) {
			ezNewPortalDAO.insertTopMenuDisplayModeForCompany(vo);
		} else {
			ezNewPortalDAO.updateTopMenuDisplayModeForCompany(vo);
		}
		
		logger.debug("updateTopMenuDisplayModeForCompany ended");
	}
	@Override
	public SystemConfigVO getSystemConfig(int portletId, String companyId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("portletId", portletId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		
		SystemConfigVO systemConfig = ezNewPortalDAO.getSystemConfig(map);
		
		return systemConfig;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getConnectPortletData(ConnectPortletDTO connectPortletDto) throws Exception {
		
		JSONParser parser = new JSONParser();
		JSONObject returnObj = new JSONObject();
		JSONObject data = new JSONObject();
		try {
			String result = "";
			JSONObject connectionData = (JSONObject) parser.parse(connectPortletDto.getSystemConfig().getCodeValue());
			
			if (connectionData.get("portletType") != null) {
				data.put("portletType", connectionData.get("portletType").toString());
			}
			// 표준 방식으로 포틀릿 만듦.
			if (connectionData.get("portletType") != null && connectionData.get("portletType").equals("standard")) {
				// #userId#와 같이 지정된 값을 실제 값으로 매핑할 때 필요.
				Map<String, Object> changeDataMap = new HashMap<String, Object>();
				changeDataMap.put("userId", connectPortletDto.getUserId());
				changeDataMap.put("deptId", connectPortletDto.getDeptId());
				changeDataMap.put("companyId", connectPortletDto.getCompanyId());
				changeDataMap.put("startRow", connectPortletDto.getStartRow());
				changeDataMap.put("listCnt", connectPortletDto.getListCnt());
				changeDataMap.put("currentPage", connectPortletDto.getCurrentPage());
				changeDataMap.put("portletId", connectPortletDto.getPortletId());
				changeDataMap.put("endRow", connectPortletDto.getEndRow());
				changeDataMap.put("tenantId", connectPortletDto.getTenantId());
				String viewType = null;
				String linkUrl = null;
				String mobileLinkUrl = null;
				String dataResultType = null;
				String connectType = null;
				String dataResultFormat = null;
				String paging = null;
				String width = null;
				String height = null;
				JSONObject headerParam = null;
				if (connectionData.get("viewType") != null) {
					viewType= connectionData.get("viewType").toString();
				}
				
				if (connectionData.get("linkUrl") != null) {
					linkUrl= changeDataValueForUrl(changeDataMap, connectionData.get("linkUrl").toString());
				}
				
				if (connectionData.get("mobileLinkUrl") != null) {
					mobileLinkUrl= changeDataValueForUrl(changeDataMap, connectionData.get("mobileLinkUrl").toString());
				}
				
				if (connectionData.get("dataResultType") != null) {
					dataResultType = connectionData.get("dataResultType").toString();
				}
				
				if (connectionData.get("dataResultFormat") != null) {
					dataResultFormat = connectionData.get("dataResultFormat").toString();
				}
				
				if (connectionData.get("headerParam") != null) {
					headerParam = (JSONObject) connectionData.get("headerParam");
				}
				
				if (connectionData.get("paging") != null) {
					paging = connectionData.get("paging").toString();
					if (paging.equals("limit")) {
						changeDataMap.put("listCnt", Integer.parseInt(connectionData.get("listCnt").toString()));
						data.put("listCnt", connectionData.get("listCnt").toString());
					}
				}
				
				if (connectionData.get("width") != null) {
					width = connectionData.get("width").toString();
				}
				
				if (connectionData.get("height") != null) {
					height = connectionData.get("height").toString();
				}
				
				data.put("viewType", viewType);
				data.put("linkUrl", linkUrl);
				data.put("mobileLinkUrl", mobileLinkUrl);
				data.put("dataResultType", dataResultType);
				data.put("dataResultFormat", dataResultFormat);
				data.put("paging", paging);
				data.put("width", width);
				data.put("height", height);
				
				if (connectionData.get("connectType") != null) {
					connectType = connectionData.get("connectType").toString();
				}
				
				if (connectType.equalsIgnoreCase("rest")) {
					String restUrl = changeDataValueForUrl(changeDataMap, connectionData.get("restUrl").toString());;
					String httpMethodType = connectionData.get("httpMethodType").toString();
					String dataParam = changeDataValue(changeDataMap, connectionData.get("dataParam").toString());
					String dataParamType = connectionData.get("dataParamType").toString();
					
					result = getDataFromRestApi(restUrl, dataParam, dataParamType, connectPortletDto.getRequest(), httpMethodType, headerParam);
					data.put("portletDataStr", result);
					
				} else if (connectType.equalsIgnoreCase("db")) {
					String dbType = connectionData.get("dbType").toString();
					String dbIp = connectionData.get("dbIp").toString();
					String dbPort = connectionData.get("dbPort").toString();
					String dataBase = connectionData.get("dataBase").toString();
					String dbUser = connectionData.get("dbUser").toString();
					String dbPwd = connectionData.get("dbPwd").toString();
					String dbDataQuery = connectionData.get("dbDataQuery").toString();
					String totalCntQuery = connectionData.get("totalCntQuery").toString();
					String preparedDataQuery = dbDataQuery.replaceAll("#(.*?)#", "?");
					
					String driverClassName = connectionData.get("driverClassName").toString();
					JSONObject dataObj = new JSONObject();
					ResultSet rsData = null;
					try (Connection connection = connDatabase(dbType, dbIp, dbPort, dataBase, driverClassName, dbUser, dbPwd);
						PreparedStatement pstmtData = connection.prepareStatement(preparedDataQuery);) {
						// 데이터 추출
						setDbParamData(changeDataMap, dbDataQuery, pstmtData);
						rsData = pstmtData.executeQuery();
						
						ResultSetMetaData metaData = rsData.getMetaData();
						int sizeOfColumn = metaData.getColumnCount();
						
						Map<String, Object> map;
						String column;
						JSONArray dataList = new JSONArray();
						
						while (rsData.next()) {
							map = new HashMap<String, Object>();
							for (int indexOfcolumn = 0; indexOfcolumn < sizeOfColumn; indexOfcolumn++) {
								column = metaData.getColumnLabel(indexOfcolumn + 1);
								map.put(column, commonUtil.htmlUnescape(rsData.getString(column)));
							}
							dataList.add(map);
						}
						
						dataObj.put("data", dataList);
					} catch (Exception e) {
						logger.error(e.getMessage(), e);
					} finally {
						if (rsData != null) {
							rsData.close();
						}
					}
					
					if (paging.equals("noLimit")) {
						String preparedCntQuery = totalCntQuery.replaceAll("#(.*?)#", "?");
						ResultSet rsCnt = null;
						try (Connection connection = connDatabase(dbType, dbIp, dbPort, dataBase, driverClassName, dbUser, dbPwd);
							PreparedStatement pstmtCnt = connection.prepareStatement(preparedCntQuery);) {
							// 데이터 추출
							int totalCnt = 0;
							setDbParamData(changeDataMap, totalCntQuery, pstmtCnt);
							rsCnt = pstmtCnt.executeQuery();
							if (rsCnt.next()) {
								totalCnt = rsCnt.getInt(1);
								dataObj.put("totalCnt", totalCnt);
							}
						} catch (Exception e) {
							logger.error(e.getMessage(), e);
						} finally {
							if (rsCnt != null) {
								rsCnt.close();
							}
						}
					}
					
					result = dataObj.toString();
				}
				
				data.put("portletDataStr", result);
			} else if (connectionData.get("portletType") != null && connectionData.get("portletType").equals("custom")) {
				// custom한 경우에는 모든 정보를 보낸다.
				data = connectionData;
			}
			
			returnObj.put("status", "ok");
			returnObj.put("data", data);
			returnObj.put("code", 0);
			
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			returnObj.put("status", "error");
			returnObj.put("data", null);
			returnObj.put("code", 1);
		}
		
		return returnObj;
	}
	
	public Connection connDatabase (String type, String ip, String port, String dataBase, String driverClassName, String userId, String userPw) throws Exception {
		String url = "";
		if ( type.equalsIgnoreCase("mssql") ) {
			//url = "jdbc:sqlserver://" + ip + ":" + port + ";DatabaseName=" + database + ";trustServerCertificate=true;encrypt=true";
			url = String.format("jdbc:sqlserver://%s:%s;DatabaseName=%s;trustServerCertificate=true;encrypt=true", ip, port, dataBase);
		} else if ( type.equalsIgnoreCase("oracle") ) {
			//url = "jdbc:oracle:thin:@" + ip + ":" + port + "/" + database;
			url = String.format("jdbc:oracle:thin:@%s:%s/%s", ip, port, dataBase);
		} else {
			//url = "jdbc:mariadb://" + ip + ":" + port + "/" + database;
			url = String.format("jdbc:mariadb://%s:%s/%s", ip, port, dataBase);
		}
		String schema = userId;
		String pwd = userPw;
		
		Connection conn = null;
		
		Class.forName(driverClassName);
		
		conn = DriverManager.getConnection(url, schema, pwd);		
		
		return conn;
	}
	
	public void setDbParamData(Map<String, Object> changeDataMap, String dbQuery, PreparedStatement pstmt) throws Exception {
		String regex = "#(.*?)#";
		Pattern pattern = Pattern.compile(regex);
		Matcher matcher = pattern.matcher(dbQuery);
		
		int idx = 1;
		while (matcher.find()) {
		    String matchStr = matcher.group(1);
		    String[] paramInfo = matchStr.split("::");
		    switch (paramInfo[1]) {
		    case "string":
		    	pstmt.setString(idx, changeDataMap.get(paramInfo[0]).toString());
		    	break;
		    case "int":
		    	pstmt.setInt(idx, (Integer) changeDataMap.get(paramInfo[0]));
		    	break;
		    case "date":
		    	pstmt.setDate(idx, (java.sql.Date) changeDataMap.get(paramInfo[0]));
		    	break;
		    }
		    idx++;
		}
	}
	
	public String changeDataValue(Map<String, Object> changeDataMap, String targetData) throws Exception {
		String result = targetData;
		for (String key : changeDataMap.keySet()) {
			String value = changeDataMap.get(key).toString();
			result = result.replaceAll("#" + key + "#", value);
		}
		
		return result;
	}
	
	public String changeDataValueForUrl(Map<String, Object> changeDataMap, String targetData) throws Exception {
		String result = targetData;
		for (String key : changeDataMap.keySet()) {
			String value = changeDataMap.get(key).toString();
			result = result.replaceAll("#" + key + "#", encodeURIComponent(value));
		}
		
		return result;
	}
	
	public String getDataFromRestApi(String restUrl, String paramString, String paramType, HttpServletRequest request, String methodType, JSONObject headerParam) throws Exception {
		return getDataFromRestApi(restUrl, paramString, paramType, request, methodType, headerParam, -1, -1);
	}
	
	public String getDataFromRestApi(String restUrl, String paramString, String paramType, HttpServletRequest request, String methodType, JSONObject headerParam, int connectionTimeout, int readTimeout) throws Exception {
		logger.debug("getJsonFromRestApi started.");
		String url = restUrl;
		
		HttpHeaders headers = new HttpHeaders();
		
		if (paramType.equalsIgnoreCase("json")) {
			headers.setContentType(MediaType.APPLICATION_JSON);
		} else if (paramType.equalsIgnoreCase("xml")) {
			headers.setContentType(MediaType.APPLICATION_XML);
		}
		
		if (headerParam != null) {
			for (Object key : headerParam.keySet()) {
	            String value = (String) headerParam.get(key);
	            headers.set(key.toString(), value);
	        }
		}
		
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<String> entity = new HttpEntity<>(paramString, headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url);
		
		RestTemplate rest = null;
		
		if (methodType.equals("patch")) {
			ClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
			rest = new RestTemplate(httpRequestFactory);
		} else if (connectionTimeout > 0 || readTimeout > 0) {
			HttpComponentsClientHttpRequestFactory httpRequestFactory = new HttpComponentsClientHttpRequestFactory();
			httpRequestFactory.setConnectTimeout(connectionTimeout);
			httpRequestFactory.setReadTimeout(readTimeout);
			rest = new RestTemplate(httpRequestFactory);
		} else {
			rest = new RestTemplate();
		}
		
		String result = "";
		HttpMethod httpMethod = null;
		methodType = methodType.toLowerCase();
		switch (methodType) {
		case "get": // url로 파람 전송
			httpMethod = HttpMethod.GET;
			break;
		case "put":
			httpMethod = HttpMethod.PUT;
			break;
		case "post":
			httpMethod = HttpMethod.POST;
			break;
		case "delete":
			httpMethod = HttpMethod.DELETE;
			break;
		case "patch":
			httpMethod = HttpMethod.PATCH;
			break;
		}
		result = rest.exchange(builder.build().encode().toUri(), httpMethod, entity, String.class).getBody();
		
		logger.debug("getJsonFromRestApi ended.");
		return result;
	}
	
	private String encodeURIComponent(String s) throws Exception {
	    String result = null;
    	result = URLEncoder.encode(s, "UTF-8")
                         .replaceAll("\\+", "%20")
                         .replaceAll("\\%21", "!")
                         .replaceAll("\\%27", "'")
                         .replaceAll("\\%28", "(")
                         .replaceAll("\\%29", ")")
                         .replaceAll("\\%7E", "~");

	    return result;
	}
	
	// 2024-08-21 조수빈 - 유저 사용 색상(모드) 조회
	@Override
	public int getUserColor(String userId, String companyId, int tenantId) throws Exception {
		PortalTopVO vo = new PortalTopVO();
		vo.setTenantID(tenantId);
		vo.setCompanyID(companyId);
		vo.setUserID(userId);
		
		return ezNewPortalDAO.getUserColor(vo);
	}
	@Override
	public void setUserColorMode(String userId, int tenantId, String companyId, int useColor) {
		Map<String, Object> map = new HashMap<>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("useColor", useColor);
		
		ezNewPortalDAO.setUserColorMode(map);
	}
	
	@Override
	public JSONArray getPortalApprovalList(PortletAprInfoVO portletAprInfoVO) throws Exception {
		logger.debug("getPortalApprovalList started.");

		List<ApprGDocListVO> result = new ArrayList<>();
		JSONArray jsonArray = new JSONArray();
		PortletAprListType portletAprListType = new PortletAprListType();
		int listType = Integer.parseInt(portletAprInfoVO.getListType());

		int aprIngEndType = portletAprListType.getAprIngEndType(listType);
		if (aprIngEndType == 1) {
			result = ezApprovalGService.portletAprDocList(portletAprInfoVO);
		} else {
			result = ezApprovalGService.portletEndAprDocList(portletAprInfoVO);
		}

		Collections.reverse(result);
		jsonArray = convertPortletAprList(changeDocHrefToURL(result, portletAprInfoVO.getUserInfo(), listType), aprIngEndType);

		logger.debug("getPortalApprovalList ended.");

		return jsonArray;
	}
	
	private List<ApprGDocListVO> changeDocHrefToURL(List<ApprGDocListVO> apprGDocListVOList, LoginVO userInfo, int listType) {
		List<ApprGDocListVO> resultList = apprGDocListVOList.stream().peek(docInfo -> {
			try {
				docInfo.setHref(getRedirectUrl(docInfo, userInfo, listType));
				docInfo.setStartDate(getLocalDate(docInfo.getStartDate(), userInfo));
				docInfo.setEndDate(getLocalDate(docInfo.getEndDate(), userInfo));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}).collect(Collectors.toList());
		return resultList;
	}
	
	private String getLocalDate(String startDate, LoginVO userInfo)  throws Exception {
		if (startDate != null && !"".equals(startDate)) {
			startDate = commonUtil.getDateStringInUTC(convertDate(startDate), userInfo.getOffset(), false);
		}
		return startDate;
	}

	public String convertDate(String date) {
		if (date.trim().equals("")) {
			return date;
		}
		return date.substring(0, 19);
	}


	public String getRedirectUrl(ApprGDocListVO docInfo, LoginVO userInfo, int listType) throws Exception {
		String redirectUrl = "";
		String mode = "";
		String docId = docInfo.getDocID();

		try {

			if (listType == PortletAprListType.AprListType.APPR.intValue()) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("companyID", userInfo.getCompanyID());
				map.put("v_TENANTID", userInfo.getTenantId());
				map.put("v_habDocID", docId);

				List<ApprGDocListVO> docState = ezApprovalGDAO.getLastHabYuiDocState(map);
				String functionType = docState.get(0).getFunctionType();
				if ("006".equals(functionType)) {
					mode = "HESU";
				} else if ("004".equals(functionType)){
					mode = "BAN";
				} else {
					mode = "ING";
					LoginVO aprMemberUserInfo = commonUtil.getUserForGw(docInfo.getAprMemberID(), userInfo.getServerName());
					if (aprMemberUserInfo.getId() != null && !"".equals(aprMemberUserInfo.getId())) {
						userInfo = aprMemberUserInfo;
						userInfo.setDeptID(docInfo.getAprMemberDeptID());
					}
				}
			} else if (listType == PortletAprListType.AprListType.APPR_PROGRESSING.intValue()) {
				mode = "PROCESSING";
			} else if (listType == PortletAprListType.AprListType.APPR_END.intValue()) {
				mode = "END";
			} else if (listType == PortletAprListType.AprListType.APPR_GONGRAM.intValue()) {
				mode = "GONGRAM";
			}
			redirectUrl = ezApprovalGService.getRedirectUrl(docId, mode, userInfo);
		} catch (Exception e) {
			logger.error("getRedirectUrl error = {}", e.toString());
			redirectUrl = "";
		}

		logger.debug("getRedirectUrl redirectUrl = {}", redirectUrl);


		return redirectUrl;
	}
	
	
	public JSONArray convertPortletAprList (List<ApprGDocListVO> apprGDocListVOList, int aprIngEndType) throws Exception  {

		JSONArray jArray = new JSONArray();
		String draftDate = "";
		for (ApprGDocListVO apprGDocListVO : apprGDocListVOList) {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("docTitle", apprGDocListVO.getDocTitle());
			jsonObject.put("drafterName", apprGDocListVO.getWriterName());
			
			if (aprIngEndType == 1) {
				draftDate = apprGDocListVO.getStartDate();
			} else {
				draftDate = apprGDocListVO.getEndDate();
			}
			
			jsonObject.put("draftDate", draftDate);
			jsonObject.put("href", apprGDocListVO.getHref());
			jArray.add(jsonObject);
		}

		return jArray;
	}

	@Override
	public int getResportletId() throws Exception {
		return ezNewPortalDAO.getResportletId();
	}

	@Override
	public String getCountryCode(String userID, int tenantID) throws Exception {
		return ezNewPortalDAO.getCountryCode(userID, tenantID);
	}

	@Override
	public String getUserLocalLang(String userID, int tenantID) throws Exception {
		return ezNewPortalDAO.getUserLocalLang(userID, tenantID);
	}

	@Override
	public String getFirstCityCode(String countryCode) throws Exception {
		return ezNewPortalDAO.getFirstCityCode(countryCode);
	}
}
