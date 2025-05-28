package egovframework.ezMobile.ezOption.service.impl;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezMobile.ezOption.dao.MOptionDAO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezPortal.vo.MPortalTimeLineVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MOptionService")
public class MOptionServiceImpl extends EgovAbstractServiceImpl implements MOptionService {
	private static final Logger logger = LoggerFactory.getLogger(MOptionServiceImpl.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
    private Properties config;
	
	@Autowired
    private EzEmailUtil ezEmailUtil;
	
	@Resource(name = "MOptionDAO")
	private MOptionDAO mOptionDAO;	
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;

	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;

	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;

	@Override
	public MCommonVO commonInfo(String serverName, String userId) throws Exception {
		logger.debug("commonInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("serverName", serverName);
		map.put("userId", userId);
		
		MCommonVO info = mOptionDAO.commonInfo(map);
				
		if (info != null) {
			String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", info.getTenantId());
			
			// 사용자의 언어가 설정되어 있지 않을 때는 시스템의 Primary Lang을 사용하도록 한다.			
			if (info.getLang() == null) {				
				info.setLang(primaryLang);
			}
			
			if (primaryLang.equals(info.getLang())) {
				info.setPrimary("1");
			} else {
				info.setPrimary("2");				
			}
			
			// 20210305 조진호 - 	모바일 그룹웨어를 한번도 로그인 하지 않은 사용자는 TBL_USERMOBILEINFO TABLE에 DATA가 없어서 lang과 timeZone(offset)이 Null이라 추가 해줌. 
			//					offset이 Null 경우 mobile gateway api 호출시 데이터 반환 하지 못함
			if (info.getOffSet() == null) {
				info.setOffSet("235|+09:00");
			}

			if (info.getLastLogin() != null) {
				info.setLastLogin(commonUtil.getDateStringInUTC(info.getLastLogin(), info.getOffSet(), false));
			}
		}
		
		logger.debug("commonInfo ended");
		
		return info;
	}

	@Override
	public MOptionVO optionInfo(String userId, int tenantId) throws Exception {
		logger.debug("optionInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		MOptionVO info = mOptionDAO.optionInfo(map);

		logger.debug("optionInfo ended");
		
		return info;
	}

	@Override
	public void insertOption(String uid, String timeZone, String lang, String mainType, String listCnt, String useSecurity, int tenantId) throws Exception {
		logger.debug("insertOption started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", uid);
		map.put("timeZone", timeZone);
		map.put("lang", lang);
		map.put("mainType", mainType);
		map.put("listCnt", listCnt);		
		map.put("useSecurity", useSecurity);
		map.put("tenantId", tenantId);			
		
		mOptionDAO.insertOption(map);
				
		logger.debug("insertOption ended");				
	}

	/**
	 * 현재 MOptionGWController.optionUpdate() 에서만 사용 중인데,
	 * "NO".equalsIgnoreCase(dotNetIntegration) 일 때 : pinState의 값이 empty가 아니다.
	 */
	@Override
	public void updateOption(String userId, String timeZone, String lang, String mainType, String listCnt, String useSecurity, int tenantId, String deviceId, String pinState, String pin, String biometric,String pinChange) throws Exception {
		logger.debug("updateOption started");	
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("timeZone", timeZone);
		map.put("lang", lang);
		map.put("mainType", mainType);
		map.put("listCnt", listCnt);		
		map.put("useSecurity", useSecurity);
		map.put("tenantId", tenantId);
		
		mOptionDAO.updateOption(map);
		
		if (!pinState.isEmpty()) {
			updateDevicePinfInfo(deviceId, pinState, pin, biometric, tenantId, userId, pinChange);
		}
		
		logger.debug("updateOption ended");	
	}

	@Override
	public List<MPortalTimeLineVO> getTimeLineList(MCommonVO info, String sessionDate, String listCnt, String approvalAccess, String boardAccess) throws Exception {
		logger.debug("getTimeLineList started");
		
		String userIDS = "'" + info.getUserId() + "'";
		String proxyOption = ezApprovalGService.getIsUse("A23", "001", info.getCompanyId(), info.getLang(), info.getTenantId());
		
		if (proxyOption.equals("1")) {
			userIDS = ezApprovalGService.getProxyUser(info.getUserId(), info.getLang(), info.getTenantId(), info.getOffSet());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listCnt", Integer.parseInt(listCnt));
		map.put("sessionDate", sessionDate);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("deptID", info.getDeptId());
		map.put("userID", info.getUserId());
		map.put("offset", commonUtil.getMinuteUTC(info.getOffSet()));
		
		/* 2024-07-09 홍승비 - SQL Injection 수정 > 사용자ID 리스트는 문자열 대신 배열로 전달 */
		map.put("userIDS", userIDS.replace("'", "").replace(" ", "").split(","));
		map.put("tenantID", info.getTenantId());
		map.put("companyID", info.getCompanyId());
		map.put("primary", info.getPrimary());		
		map.put("approvalAccess", approvalAccess);
		map.put("boardAccess", boardAccess);
		
		List<MPortalTimeLineVO> mPortalTimeLineVOs = mOptionDAO.getTimeLineList(map);

		logger.debug("getTimeLineList ended");
		
		return mPortalTimeLineVOs;
	}

	@Override
	public MCommonVO commonInfoWeb(String serverName, String userId) throws Exception {
		logger.debug("commonInfoWeb started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("serverName", serverName);
		map.put("userId", userId);
		
		MCommonVO info = mOptionDAO.commonInfoWeb(map);
				
		if (info != null) {
			String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", info.getTenantId());
			
			// 사용자의 언어가 설정되어 있지 않을 때는 시스템의 Primary Lang을 사용하도록 한다.			
			if (info.getLang() == null) {				
				info.setLang(primaryLang);
			}
			
			if (primaryLang.equals(info.getLang())) {
				info.setPrimary("1");
			} else {
				info.setPrimary("2");				
			}

			// dhlee : 20220928 - 흔하지는 않지만 PC 그룹웨어에 로그인하지 않은 상태에서 Gateway Server API를 호출하는 경우를 대비해 디폴트값을 설정하도록 함.
			if (info.getOffSet() == null) {
				info.setOffSet("235|+09:00");
			}
			// dhlee : 20220928 - end
		}
		
		logger.debug("commonInfoWeb ended");
		
		return info;
	}

	public void updateDevicePinfInfo(String deviceId, String pinState, String pin, String biometric, int tenantId, String userId, String pinChange) throws Exception {
		logger.debug("updateDevicePinfInfo started.");
		logger.debug("deviceId={},userId={},pinState={},pin={},biometric={},pinchange={}",deviceId,userId,pinState,pin,biometric,pinChange);

		String tenantIdParam = "tenantId=" + tenantId;
		String deviceIdParam = "deviceId=" + URLEncoder.encode(deviceId, "UTF-8");
		String userIdParam = "userId=" + URLEncoder.encode(userId, "UTF-8");
		String pinStateParam = "pinState=" + URLEncoder.encode(pinState, "UTF-8");
		String pinParam = "pin=" + URLEncoder.encode(pin, "UTF-8");
		String biometricParam = "biometric=" + URLEncoder.encode(biometric, "UTF-8");
		String pinChangeParam = "pinChange=" + URLEncoder.encode(pinChange, "UTF-8");
		String inputParams = tenantIdParam + "&" + deviceIdParam + "&" + pinStateParam + "&" + pinParam + "&" + biometricParam + "&" + userIdParam + "&" +pinChangeParam;
		logger.debug("inputParams=" + inputParams);
		
		try {
			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/ezTalkGate/updateDevicePinfInfo", inputParams);
			logger.debug("strJson=" + strJson);
			
			JSONParser parser = new JSONParser();
			JSONObject object = (JSONObject)parser.parse(strJson);
	        
	        if (!object.get("resultCode").equals("OK") || ((Long)object.get("reasonCode")).intValue() != 0) {
	        	throw new Exception("JGwServer ERROR");
	        }
		} catch (Exception e) {
			logger.debug("[JGW-SERVER ERROR] updateDevicePinfInfo.");
		}

		logger.debug("updateDevicePinfInfo ended.");
	}
	
	@Override
	public String getDevicePinfInfo(String deviceId, String userId) throws Exception {
		logger.debug("getDevicePinfInfo started.");
		logger.debug("deviceId=" + deviceId + ", userId=" + userId);

		String deviceIdParam = "deviceId=" + URLEncoder.encode(deviceId, "UTF-8");
		String userIdParam = "userId=" + URLEncoder.encode(userId, "UTF-8");
		String inputParams = deviceIdParam + "&" + userIdParam;
		logger.debug("inputParams=" + inputParams);
		
		JSONObject jsonObject = new JSONObject();
		
		try {
			String strJson = ezEmailUtil.getWebServiceResult(config.getProperty("config.JGwServerURL") + "/ezTalkGate/getUserMobileDevicePinInfo", inputParams);
			logger.debug("strJson=" + strJson);
			
			JSONParser parser = new JSONParser();
			jsonObject = (JSONObject)parser.parse(strJson);
	        
	        if (!jsonObject.get("resultCode").equals("OK")) {
	        	throw new Exception("JGwServer ERROR");
	        }
		} catch (Exception e) {
			logger.debug("[JGW-SERVER ERROR] getDevicePinfInfo.");
		}

		logger.debug("getDevicePinfInfo ended.");

		return jsonObject.toJSONString();
	}
	
	// 2024-07-25 조수빈 - EzNewPortalServiceImpl.getUserMenuList()의 로직을 변형하여 모바일 메뉴 반환 구현
	@Override
	public List<MenuInfoVO> getMobileMenuList(Map<String, Object> userInfoMap) throws Exception {
		logger.debug("[Service] getMobileMenuList started");
		userInfoMap.put("mobile", "mobile");
		
		String deptPath = ezOrganService.getDeptPath((String) userInfoMap.get("deptId"), Integer.parseInt((String) userInfoMap.get("tenantId")));
		
		//path 거꾸로 돌려야해서
		List<String> deptIds = Arrays.asList(deptPath.split(","));
		Collections.reverse(deptIds);
		
		//유저권한체크
		userInfoMap.put("userType", "USER");
		List<MenuInfoVO> result = mOptionDAO.getMenuForUser(userInfoMap);
		
		//전체체크필요없어서 id만
		List<Integer> menuIds = new ArrayList<Integer>();
		
		for (MenuInfoVO vo : result) {
			menuIds.add(vo.getMenuId());
		}
		
		result.removeIf(vo -> !vo.isAccessYN());
		
		// 직위 직책 체크
		userInfoMap.put("userType", "PERMISSION");
		List<MenuInfoVO> permissionResult = mOptionDAO.getMenuForUser(userInfoMap);
		
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
		userInfoMap.put("userType", "DEPT");
		for(String pathId : deptIds) {
			userInfoMap.put("deptId", pathId);
			
			if (pathId.equals(userInfoMap.get("deptId"))) {
				userInfoMap.put("isUserDept", true);
			} else {
				userInfoMap.put("isUserDept", false);
			}
			
			deptResult = mOptionDAO.getMenuForUser(userInfoMap);
			
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

		logger.debug("[Service] getMobileMenuList ended");
		return result;
	}
	
}
