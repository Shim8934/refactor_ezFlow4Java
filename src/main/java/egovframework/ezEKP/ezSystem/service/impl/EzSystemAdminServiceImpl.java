package egovframework.ezEKP.ezSystem.service.impl;

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.concurrent.atomic.AtomicLong;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
import egovframework.ezEKP.ezSystem.dao.EzSystemAdminDAO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.util.EzSystemUtil;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.CheckName;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.DataForModulesEnum;
import egovframework.ezEKP.ezSystem.vo.DeptChangeInfoVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.ezEKP.ezSystem.vo.ModuleSizeVO;
import egovframework.ezEKP.ezSystem.vo.PasswordPolicyVO;
import egovframework.ezEKP.ezSystem.vo.PermissionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigTypeVO;
import egovframework.ezEKP.ezSystem.vo.SystemConfigVO;
import egovframework.ezEKP.ezSystem.vo.UserChangeInfoVO;
import egovframework.let.main.vo.MainVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzSystemAdminService")
public class EzSystemAdminServiceImpl extends EgovAbstractServiceImpl implements EzSystemAdminService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzSystemAdminServiceImpl.class);
	
	@Resource(name="EzSystemAdminDAO")
	EzSystemAdminDAO ezSystemAdminDAO;
	
	@Resource(name="EzCommonDAO")
	EzCommonDAO ezCommonDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<SysParamVO> getSysParam(int tenantID) throws Exception {	
		logger.debug("getSysParam started. tenantID=" + tenantID);
		
		List<SysParamVO> list = ezSystemAdminDAO.getSysParam(tenantID);
		List<SysParamVO> afterList = new ArrayList<SysParamVO>();
		
		for (int i = 0; i < list.size(); i++) {
			try {
				CheckName.valueOf(list.get(i).getName());
				afterList.add(list.get(i));
			} catch (IllegalArgumentException e){logger.debug("e.message=" + e.getMessage());}
		}

		logger.debug("getSysParam ended");
		
		return afterList;
	}
	
	@Override
	public void updateSysParam(int tenantID, List<Map<String, String>> list, Locale locale, String companyID) throws Exception {
		logger.debug("updateSysParam started. tenantID=" + tenantID);
		
		SysParamVO sysParamVO = new SysParamVO();
		sysParamVO.setTenantID(tenantID);		
		
		for (int i = 0; i < list.size(); i++) {					
			String paramName = list.get(i).get("name");
			String paramValue = list.get(i).get("value");
			
			if (paramName.equals("LicenseKey")) {
				String newPackageType = commonUtil.licenseKeyDEC(paramValue);
				String oldPackageType = commonUtil.getPackageType(tenantID);
				if (newPackageType.equals(oldPackageType)) {
					// continue; 2022-10-20 이사라 - PackageType 값이 동일하면 for문을 빠져나가는 오류로 주석처리
				} else {
					// 바뀌었을때 새로운 packageType으로 디비 메뉴 맞춰줘야하는 것 추가
					//updateNewPortalMenuByPackageType(newPackageType, tenantID, companyID);
				}
			}

			if (paramName.equals("useSession") || paramName.equals("useSessionMobile")) {
				int sessionParam = Integer.parseInt(paramValue);
				paramValue = Integer.toString(sessionParam);
			}
			
			if (paramName.equals("notiPollingInterval")) {
				int notiIntervalParam = Integer.parseInt(paramValue) * (1000 * 60);
				paramValue = Integer.toString(notiIntervalParam);
			}
			
			sysParamVO.setName(paramName);
			sysParamVO.setValue(paramValue);
			
			ezSystemAdminDAO.updateSysParam(sysParamVO);
			
			if (paramName.equals("MailAttachLimit")) {
				sysParamVO.setName("BigSizeMailAttachLimit");
				sysParamVO.setValue(paramValue);				
				ezSystemAdminDAO.updateSysParam(sysParamVO);				
			} else if (paramName.equals("PrimaryLang")) {
				if (paramValue.equals("1")) {
					sysParamVO.setName("LangPrimary1");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.korean1", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
					
					sysParamVO.setName("LangPrimary2");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.korean2", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
										
					sysParamVO.setName("LangPrimary3");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.korean3", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
					
					sysParamVO.setName("LangPrimary4");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.korean4", locale));			
					ezSystemAdminDAO.updateSysParam(sysParamVO);
					
					sysParamVO.setName("LangSecondary1");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english1", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);	
					
					sysParamVO.setName("LangSecondary2");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english2", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);										

					sysParamVO.setName("LangSecondary3");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english3", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);										

					sysParamVO.setName("LangSecondary4");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english4", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);															
				} else if (paramValue.equals("3")) {
					sysParamVO.setName("LangPrimary1");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.japanese1", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
					
					sysParamVO.setName("LangPrimary2");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.japanese2", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
										
					sysParamVO.setName("LangPrimary3");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.japanese3", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
					
					sysParamVO.setName("LangPrimary4");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.japanese4", locale));			
					ezSystemAdminDAO.updateSysParam(sysParamVO);
					
					sysParamVO.setName("LangSecondary1");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english1", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);	
					
					sysParamVO.setName("LangSecondary2");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english2", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);										

					sysParamVO.setName("LangSecondary3");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english3", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);										

					sysParamVO.setName("LangSecondary4");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english4", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);															
				}				
			}
		}
		
		logger.debug("updateSysParam ended");
	}

	@Override
	public List<ConnectionInfoVO> getLoginHist(int tenantID, String offset, int startPage, int maxItemPerPage, String keycode, 
			String keyword, String keycodeForStatus, String lang, String startDate, String endDate, String companyId) throws Exception {

		logger.debug("getLoginHist started. tenantID : " + tenantID);
		
		String companyOracleStr = "";
		if (companyId != null && !companyId.equals("Top/organ")) {
			companyOracleStr = " AND C.COMPANYID ='" + companyId + "'";
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("v_start", startPage);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForStatus", keycodeForStatus);
		params.put("lang", lang); // primary:기본명 / 1:영문명
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getLoginHist ended.");
		List<ConnectionInfoVO> list = ezSystemAdminDAO.getLoginHist(params);
		
		return list;
	}
	
	@Override
	public List<ConnectionInfoVO> getLoginHistNotAdmin(int tenantID, String offset, int startPage, int maxItemPerPage, String keycode, 
			String keyword, String keycodeForStatus, String lang, String startDate, String endDate, String companyId, String userId) throws Exception {
		
		logger.debug("getLoginHist started. tenantID : " + tenantID);
		
		String companyOracleStr = "";
		if (companyId != null && !companyId.equals("Top/organ")) {
			companyOracleStr = " AND C.COMPANYID ='" + companyId + "'";
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("v_start", startPage);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForStatus", keycodeForStatus);
		params.put("lang", lang); // primary:기본명 / 1:영문명
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("companyOracleStr", companyOracleStr);
		params.put("userId", userId);
		
		List<ConnectionInfoVO> list = ezSystemAdminDAO.getLoginHistNotAdmin(params);
		logger.debug("getLoginHist ended.");
		
		return list;
	}

	@Override
	public int getLoginHistCount(int tenantID, String offset, String keycode, String keyword, String keycodeForStatus, String lang, String startDate, String endDate, String companyId) throws Exception {
		
		logger.debug("getLoginHistCount started. tenantID : " + tenantID);

		String companyOracleStr = "";
		if (companyId != null && !companyId.equals("Top/organ")) {
			companyOracleStr = " AND C.COMPANYID ='" + companyId + "'";
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForStatus", keycodeForStatus);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("companyOracleStr", companyOracleStr);
				
		logger.debug("getLoginHistCount ended.");
		
		return ezSystemAdminDAO.getLoginHistCount(params);
	}
	
	@Override
	public int getLoginHistCountNotAdmin(int tenantID, String offset, String keycode, String keyword, String keycodeForStatus, String lang, 
			String startDate, String endDate, String companyId, String userId) throws Exception {
		
		logger.debug("getLoginHistCount started. tenantID : " + tenantID);
		
		String companyOracleStr = "";
		if (companyId != null && !companyId.equals("Top/organ")) {
			companyOracleStr = " AND C.COMPANYID ='" + companyId + "'";
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForStatus", keycodeForStatus);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("companyOracleStr", companyOracleStr);
		params.put("userId", userId);
		
		logger.debug("getLoginHistCount ended.");
		
		return ezSystemAdminDAO.getLoginHistCountNotAdmin(params);
	}

	/**
	 * 서버 리스트 가져오기
	 * */
	public ArrayList<String> getServerInfo(String ip, String curServer, String serverName, ArrayList<String> getServerList) throws Exception {
		
		logger.debug("getSysIngo started.");
		
		RestTemplate rest = new RestTemplate();
		HttpHeaders headers = new HttpHeaders();
		ArrayList<String> serverList = new ArrayList<String>();
		
		headers.set("Accpet", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", serverName);

		/**
		 * 각 서버별 정보를 ArrayList에 저장.
		 * 1. 자신의 정보 및 기타 서버 정보 저장.
		 * 2. 기타 서버 정보는 getServerList에 저장된 정보를 바탕으로 RESTful로 받아오기.
		 * */
		for (String address : getServerList) {
			logger.debug(address);
			/**
			 * 현재 서버와 serverList의 값이 같은 경우
			 *               OR
			 * config에 서버 정보를 저장하지 않은 경우(자신에 대한 작업만 하면 됨)
			 * */
			if (curServer == null || curServer.equalsIgnoreCase(address) || address.equalsIgnoreCase("EMPTY")) {
 				serverList.add(EzSystemUtil.getSysInfo(ip));					
			} else {					
				String sysInfoUrl = address + "/ezSystem/util/getSysInfo";
				HttpEntity<?> entity = new HttpEntity<>(headers);
				try {
					ResponseEntity<String> sysInfo = rest.postForEntity(sysInfoUrl, entity, String.class);
					serverList.add(sysInfo.getBody());
					logger.debug("sysInfo : " + sysInfo.getBody());
				} catch(ResourceAccessException e) {
					String errorMsg = "{\"getSysInfo\":[{\"hostname\":\""+ address +" is Down\",\"memory\":\"NULL\",\"os\":\"NULL\",\"cpu\":\"NULL\",\"version\":\"NULL\"}]}";
					serverList.add(errorMsg);
					logger.debug("sysInfo : " + errorMsg);
				}
			}
		}			
			
		logger.debug("getSysInfo ended.");
		
		return serverList;
	}

	@Override
	public void deleteLoginHist(int keepLogPeriod, int tenantID) throws Exception {
	    logger.debug("deleteLoginHist started. keepLogPeriod=" + keepLogPeriod + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_KEEP_LOG_PERIOD", keepLogPeriod*30);
        map.put("v_TENANT_ID", tenantID);		
        
        ezSystemAdminDAO.deleteLoginHist(map);
        
        logger.debug("deleteLoginHist ended.");
	}	

	/**
	 * 시스템의 정보 가져오기
	 * */
	@SuppressWarnings("unchecked")
	public String getSysMonitorInfo(String ip, String serverName, String address, boolean chkServer) throws Exception {
		
		logger.debug("getSysMonitorInfo started.");
		
		String result ="";

		if (chkServer) {
			
			JSONObject jObj = new JSONObject();
			JSONArray jArr = new JSONArray();
			
			String osInfo = EzSystemUtil.getSysInfo(ip);
			String cpuInfo = EzSystemUtil.getCpuInfo(ip);
			String memoryInfo = EzSystemUtil.getMemoryInfo(ip);
			String fileSysInfoList  = EzSystemUtil.getFileSysInfo(ip);
			String diskioInfo = EzSystemUtil.getDiskioInfo(ip);
			String netTrafficList = EzSystemUtil.getNetDataInfo(ip);
			
			jArr.add(osInfo);
			jArr.add(cpuInfo);
			jArr.add(memoryInfo);
			jArr.add(fileSysInfoList);
			jArr.add(diskioInfo);
			jArr.add(netTrafficList);
			
			jObj.put("getSysMonitorInfo", jArr);
			
			result = jObj.toString();
		} else {
			RestTemplate rest = new RestTemplate();
			HttpHeaders headers = new HttpHeaders();	
			
			headers.set("Accpet", MediaType.APPLICATION_JSON_VALUE);
			headers.set("x-user-host", serverName);		
			/**
			 * ajax로 해당 div의 순번을 가져온다.
			 * div순번 -> config에 저장된 순번
			 * config에 저장된 서버 정보로 데이터 가져오기.
			 * */
			String sysInfoUrl = address + "/ezSystem/util/getSysMonitorInfo";
			HttpEntity<?> entity = new HttpEntity<>(headers);
			
			ResponseEntity<String> sysMonitorInfo = rest.postForEntity(sysInfoUrl, entity, String.class);
			logger.debug("<<<sysMonitorInfo : " + sysMonitorInfo.getBody());
			
			result = sysMonitorInfo.getBody();
		}

		logger.debug("getSysMonitorInfo started.");
		
		return result;
	}
	
	@Override
	public void updateSystemIPAllow(String allowResult, int tenantID) throws Exception {
		logger.debug("updateSystemIPAllow started. tenantID=" + tenantID + ", allowResult=" + allowResult);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tenantID", tenantID);
		params.put("value", allowResult);
		
		ezSystemAdminDAO.updateSystemIPAllow(params);
		
		logger.debug("updateSystemIPAllow ended");
	}
	
	@Override
	public List<IPBandVO> getAllIPBand(int tenantID) throws Exception {
		logger.debug("getAllIPBand started. tenantID=" + tenantID);
		
		List<IPBandVO> list = ezSystemAdminDAO.getAllIPBand(tenantID);
		
		logger.debug("getAllIPBand ended.");
		return list;
	}
	
	@Override
	public void insertIPBand(int tenantID, String ipAddress, String access, String explanation) throws Exception {
		logger.debug("insertIPBand started.");
		logger.debug("tenantID=" + tenantID + ", ipAddress=" + ipAddress + ", access=" + access + ", explanation=" + explanation);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tenantID", tenantID);
		params.put("ipAddress", ipAddress);
		params.put("access", access);
		params.put("explanation", explanation);
		
		ezSystemAdminDAO.insertIPBand(params);
		
		logger.debug("insertIPBand ended.");
	}
	
	@Override
	public IPBandVO getSystemIPBand(String ipNo) throws Exception {
		logger.debug("getSystemIPBand started.");
		logger.debug("ipNo=" + ipNo);
		
		IPBandVO ipBand = ezSystemAdminDAO.getSystemIPBand(ipNo);
		
		logger.debug("getSystemIPBand ended.");
		
		return ipBand;
	}
	
	@Override
	public void updateIPBand(String ipNo, String ipAddress, String access, String explanation) throws Exception {
		logger.debug("updateIPBand started.");
		logger.debug("ipNo=" + ipNo + ", ipAddress=" + ipAddress + ", access=" + access + ", explanation=" + explanation);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ipNo", ipNo);
		params.put("ipAddress", ipAddress);
		params.put("access", access);
		params.put("explanation", explanation);
		
		ezSystemAdminDAO.updateIPBand(params);
		
		logger.debug("updateIPBand ended.");
	}
	
	@Override
	public void deleteIPBand(String ipNo) throws Exception {
		logger.debug("deleteIPBand started.");
		logger.debug("ipNo=" + ipNo);
		
		String[] ipNoList = ipNo.split(",");
		List<String> list = new ArrayList<String>();
		
		for (int i = 0; i < ipNoList.length; i++) {
			list.add(ipNoList[i]);
		}
		
		ezSystemAdminDAO.deleteIPBand(list);
		
		logger.debug("deleteIPBand ended.");
	}
	
	@Override
	public List<AccessIdVO> getAllAccessList(String primaryLang, int tenantID, String companyID) throws Exception {
		logger.debug("getAllAccessList started.");
		logger.debug("primaryLang=" + primaryLang + ", tenantID=" + tenantID + ", companyID=" + companyID);
		
		if (primaryLang.equals("1")) {
			primaryLang = "";
		}
		List<AccessIdVO> list;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tenantID", tenantID);
		params.put("companyID", companyID);
		params.put("lang", primaryLang);
		
		list = ezSystemAdminDAO.getAllAccessList(params);
		
		logger.debug("getAllAccessList ended.");
		return list;
	}
	
	@Override
	public void deleteAccessId(String accessNo) throws Exception {
		logger.debug("deleteAccessId started.");
		logger.debug("accessNo=" + accessNo);
		
		String[] accessNoList = accessNo.split(",");
		List<String> list = new ArrayList<String>();
		
		for (int i = 0; i < accessNoList.length; i++) {
			list.add(accessNoList[i]);
		}
		
		ezSystemAdminDAO.deleteAccessId(list);
		
		logger.debug("deleteAccessId ended.");
	}
	
	@Override
	public List<AccessIdVO> getAllAccessListDept(String primaryLang, int tenantID, String companyID) throws Exception {
		logger.debug("getAllAccessListDept started.");
		logger.debug("primaryLang=" + primaryLang + ", tenantID=" + tenantID + ", companyID=" + companyID);
		
		if (primaryLang.equals("1")) {
			primaryLang = "";
		}
		List<AccessIdVO> list;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tenantID", tenantID);
		params.put("companyID", companyID);
		params.put("lang", primaryLang);
		
		list = ezSystemAdminDAO.getAllAccessListDept(params);
		
		logger.debug("getAllAccessListDept ended.");
		return list;
	}
	
	@Override
	public List<String> getAllAccessListCom (int tenantID) throws Exception {
		logger.debug("getAllAccessListCom started.");
		logger.debug("tenantID=" + tenantID);
		
		List<String> allUser = ezSystemAdminDAO.getAllAccessListUserCompare(tenantID);
		List<String> allDept = ezSystemAdminDAO.getAllAccessListDeptCompare(tenantID);
		List<String> allList = new ArrayList<String>();
		
		for (int i = 0; i < allUser.size(); i++) {
			allList.add(allUser.get(i));
		}
		
		for (int i = 0; i <allDept.size(); i++) {
			allList.add(allDept.get(i));
		}
		
		logger.debug("allList=" + allList.toString());
		logger.debug("getAllAccessListCom ended.");
		return allList;
	}
	
	@Override
	public void insertAccessId(int tenantID, String cn) throws Exception {
		logger.debug("insertAccessId started.");
		logger.debug("tenantID=" + tenantID + ", cn=" + cn);
		
		String[] cnList = cn.split(";");
		
		for (int i = 0; i < cnList.length; i++) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("tenantID", tenantID);
			params.put("cn", cnList[i]);
			ezSystemAdminDAO.insertAccessId(params);
		}
		
		logger.debug("insertAccessId ended.");
	}
	
	/** 
	 * 각 모듈별 스토리지 사용량과 데이터베이스 사용량, 총 사용량을 구한다.
	 * @param moduleNamesStr
	 * @param realPath
	 * @param userInfo
	 *  */
	@Override
	public ModuleSizeVO getModuleUsage(List<String> moduleNames, String realPath, LoginVO userInfo) throws Exception {
		logger.debug("getModuleUsage started.");
		
		ModuleSizeVO moduleSizeVO = new ModuleSizeVO(true);
		int tenantId = userInfo.getTenantId();
		
		long totalStorageSize = 0;
		long totalTableSize = 0;
		
		for(String moduleName : moduleNames) {
			ModuleSizeVO tempModuleSizeVO = getModuleUsage(moduleName, realPath, tenantId);
			
			totalStorageSize += tempModuleSizeVO.getStorageSize();
			totalTableSize += tempModuleSizeVO.getTableSize();
			
			moduleSizeVO.putModuleMap(moduleName, tempModuleSizeVO);
		}
		
		moduleSizeVO.putModuleMap("total", setModuleSize(totalStorageSize, totalTableSize));
		
		logger.debug("getModuleUsage ended.");
		
		return moduleSizeVO;
	}
	
	public ModuleSizeVO getModuleUsage(String moduleName, String realPath, int tenantId) throws Exception {
		DataForModulesEnum module = DataForModulesEnum.valueOf(moduleName.toUpperCase());
		
		long storageSize = 0;
		long tableSize = 0;
		
		// get file size
		if(module.getFilerootName() != null) {
			int filerootNameLen = module.getFilerootName().length;
			AtomicLong storageSizeByte = new AtomicLong(0);
			
			for(int i = 0; i < filerootNameLen; i++) {
				String uploadPath = commonUtil.getUploadPath(module.getFilerootName()[i], tenantId);
				
				Path filePath = Paths.get((commonUtil.detectPathTraversal(realPath + uploadPath)));
				if(filePath.toFile().exists()) {
					Files.walkFileTree(filePath, new SimpleFileVisitor<Path>() {
						
						@Override
						public FileVisitResult visitFile(Path file,	BasicFileAttributes attrs) throws IOException {
							
							storageSizeByte.addAndGet(attrs.size());
							
							return FileVisitResult.CONTINUE;
						}
						
					});
				}
			}
			
			storageSize = storageSizeByte.longValue();
		}
		// end
		
		// get table size
		tableSize = ezSystemAdminDAO.selectModuleSize(module.getTableName(), module.getNotTableName());
		// end
		
		return setModuleSize(storageSize, tableSize);
	}
	
	/**
	 * 모듈별 사용량을 구해서 ModuleSizeVO에 set한다.
	 * @param storageSize
	 * @param tableSize
	 * */
	public ModuleSizeVO setModuleSize(long storageSize, long tableSize) throws Exception {
		logger.debug("setModuleSize started.");
		
		ModuleSizeVO module = new ModuleSizeVO();
		
		long totalSize = storageSize + tableSize;
		
		module.setStorageSize(storageSize);
		module.setTableSize(tableSize);
		module.setTotalSizePerModule(totalSize);
		
		module.setStorageSizeStr(commonUtil.byteCalculation(String.valueOf(storageSize)));
		module.setTableSizeStr(commonUtil.byteCalculation(String.valueOf(tableSize)));
		module.setTotalSizePerModuleStr(commonUtil.byteCalculation(String.valueOf(totalSize)));
		
		logger.debug("setModuleSize ended.");
		
		return module;
	}
	
	public void deleteWebfolderLog(int keepLogPeriod, int tenantID) throws Exception {
		logger.debug("deleteWebfolderLog started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_KEEP_LOG_PERIOD", keepLogPeriod*60);
        map.put("v_TENANT_ID", tenantID);		
        
        ezSystemAdminDAO.deleteWebfolderLog(map);
        
		logger.debug("deleteWebfolderLog end.");
		
	}

	@Override
	public void setMultiLoginType(String multiLoginType, int tenantID, String companyID, String editType) throws Exception {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("multiLoginType", multiLoginType);
		paramMap.put("tenantID", tenantID);
		paramMap.put("companyID", companyID);
		
		if(editType.equals("")) {
			ezSystemAdminDAO.insertMultiLogintype(paramMap);
		} else {
			ezSystemAdminDAO.updateMultiLogintype(paramMap);
		}
	}

	@Override
	public void updateNewPortalMenuByPackageType(String newPackageType, int tenantID, String companyID) throws Exception {
		logger.debug("updateNewPortalMenuByPackageType start.");
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		Set<String> menuId = new HashSet<String>();

		if (newPackageType.equals("mail")) {
			System.out.println(newPackageType);
			menuId.add("1");
			menuId.add("13");
		} else if (newPackageType.equals("basic")) {
			System.out.println(newPackageType);
			menuId.add("1");
			menuId.add("2");
			menuId.add("4");
			menuId.add("13");
		}
		paramMap.put("menuId", menuId.toArray(new String[menuId.size()]));
		paramMap.put("tenantID", tenantID);
		paramMap.put("companyID", companyID);
		paramMap.put("packageType", newPackageType);
		paramMap.put("menuUse", 0);
		paramMap.put("flagType", "all");
		
		ezSystemAdminDAO.updateMenuChange(paramMap);
		
		if (newPackageType.equals("") || newPackageType.equals("standard")) {
			newPackageType = "standard";
		} else {
			paramMap.put("flagType", "notAll");
		}
		
		paramMap.put("packageType", newPackageType);
		paramMap.put("menuUse", 1);
		
		ezSystemAdminDAO.updateMenuChange(paramMap);
		
		logger.debug("updateNewPortalMenuByPackageType end.");
	}
	
	/*
	 * 접속 허용 국가 리스트
	 */
	@Override
	public String getAccessCountryList(int tenantId)throws Exception {
		logger.debug("getAccessCountryList started");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("tenantId", tenantId);
		
		String accessCountryList = ezSystemAdminDAO.getAccessCountryList(paramMap);
		accessCountryList = accessCountryList == null ? "" : accessCountryList;

		logger.debug("getAccessCountryList ended");
		return accessCountryList;
	}

	/*
	 * 접속 허용 국가 추가
	 */
	@Override
	public void setAccessCountry(int tenantId, String countryCode) throws Exception {
		logger.debug("setAccessCountry started");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("tenantId", tenantId);
		paramMap.put("countryCode", countryCode);
		
		int updateResult = ezSystemAdminDAO.updateAccessCountry(paramMap);
		if (updateResult == 0) {
			logger.debug("update failed. insert AccessCountry");
			ezSystemAdminDAO.setAccessCountry(paramMap);
		}
		
		logger.debug("setAccessCountry ended");
	}

	// 암호 정책 
	@Override
	public Map<String, Object> getPwPolicy(int tenantId, String companyId) throws Exception {
		logger.debug("getPwPolicy started");

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("tenantId", tenantId); 
		paramMap.put("companyId", companyId);
		
		Map<String, Object> returnMap = null;
		
		Map<String, String> pwPolicy = ezSystemAdminDAO.getPwPolicy(paramMap); // 암호 정책
		List<Map<String, Object>> pwPolicyPattern = ezSystemAdminDAO.getPwPolicyPattern(paramMap); // 암호 정책 패턴
		
		if (pwPolicy != null && pwPolicyPattern != null) {
			returnMap = new HashMap<String, Object>();
			returnMap.put("pwPolicy", pwPolicy);
			returnMap.put("pwPolicyPattern", pwPolicyPattern);
		}
		
		logger.debug("getPwPolicy ended");
		return returnMap;
	}

	// 암호 정책 저장
	@Override
	public int updatePwPolicy(int tenantId, String companyId, Map<String, String> patternTypeMap, 
			List<Map<String, Object>> PwPolicyPatternList) throws Exception {
		logger.debug("updatePwPolicy started");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("tenantId", tenantId);
		paramMap.put("companyId", companyId);
		
		PasswordPolicyVO pwPolicyVO = new PasswordPolicyVO();
		pwPolicyVO.setTenantId(tenantId);		
		pwPolicyVO.setCompanyId(companyId);
		pwPolicyVO.setEngCharType(patternTypeMap.get("useEngType"));
		pwPolicyVO.setUseCapitalLetter(patternTypeMap.get("engCapitalLetter"));
		pwPolicyVO.setUseSmallLetter(patternTypeMap.get("engSmallLetter"));
		pwPolicyVO.setUseNumber(patternTypeMap.get("useNumber"));
		pwPolicyVO.setUseSpecial(patternTypeMap.get("useSpecial"));
		logger.debug("pwPolicyVO=" + pwPolicyVO.toString());

		// 암호 정책 설정 저장
		int updateChk = ezSystemAdminDAO.updatePwPolicy(pwPolicyVO);
		if (updateChk <= 0) {
			logger.debug("tbl_password_policy insert.");
			ezSystemAdminDAO.insertPwPolicy(pwPolicyVO);
		}

		// 암호 패턴 설정 삭제 및 저장
		ezSystemAdminDAO.deletePwPolicyPattern(paramMap);
		for (Map<String, Object> patternMap : PwPolicyPatternList) {
			patternMap.putAll(paramMap);
			
			logger.debug("insertPwPolicyPattern. patternMap=" + patternMap.toString());
			ezSystemAdminDAO.insertPwPolicyPattern(patternMap);
		}
		
		logger.debug("updatePwPolicy ended");
		return 0;
	}
	
	// 2024.10.14 한슬기 : 회사생성시 암호정책 디폴트값 설정 (암호패턴 사용, 영문 대/소문자 패턴구분안함, 3개패턴 사용, 8글자 이상)
	@Override
	public String insertDefaultPwPolicy(int tenantID, String companyID) throws Exception {
		String result = "ERROR";
		PasswordPolicyVO pwPolicyVO = new PasswordPolicyVO();
		pwPolicyVO.setTenantId(tenantID);
		pwPolicyVO.setCompanyId(companyID);
		pwPolicyVO.setEngCharType("N");
		pwPolicyVO.setUseCapitalLetter("Y");
		pwPolicyVO.setUseSmallLetter("Y");
		pwPolicyVO.setUseNumber("Y");
		pwPolicyVO.setUseSpecial("Y");
		
		logger.debug("insertPwPolicy. pwPolicyVO={}", pwPolicyVO);
		ezSystemAdminDAO.insertPwPolicy(pwPolicyVO);
		
		// 패턴 -> 영문 대/소문자, 숫자, 특수문자
		int patternNumber = 0; // 패턴사용시 글자수 제한(사용안함)
		int settingNumber = 8; // 패턴사용시 글자수 제한(8글자 이상)
		int pattrernCount = 3; // 사용패턴갯수
		
		Map<String, Object> patternMap = new HashMap<>();
		for (int i = 1; i <= pattrernCount; i++) {
			if (i == pattrernCount) {
				patternNumber = settingNumber;
			}
			// tbl_password_policy_pattern
			patternMap.put("tenantId", tenantID);
			patternMap.put("companyId", companyID);
			patternMap.put("settingCnt", i); // number_of_char
			patternMap.put("settingNumber", patternNumber); // use_pattern_count
			
			logger.debug("insertPwPolicyPattern. patternMap=" + patternMap.toString());
			ezSystemAdminDAO.insertPwPolicyPattern(patternMap);
			
		}
		
		result = "OK";
		
		return result;
	}
	
	// companyConfig 저장
	@Override
	public void updateCompanyConfigParam(int tenantID, List<Map<String, String>> list, String companyID) throws Exception {
		logger.debug("updateCompanyConfig started. tenantID=" + tenantID + ", companyId=" + companyID);
		
		SysParamVO sysParamVO = new SysParamVO();
		sysParamVO.setTenantID(tenantID);		
		sysParamVO.setCompanyID(companyID);
		
		for (int i = 0; i < list.size(); i++) {					
			String paramName = list.get(i).get("name");
			String paramValue = list.get(i).get("value");
			logger.debug("paramName:" + paramName + ", paramValue:" + paramValue);
			
			if (paramName.equals("ExpirePassPeriod") || paramName.equals("MaxAllowedCountOfLoginFail") || paramName.equals("LoginLockedDuration")) {
				int changeInt = Integer.parseInt(paramValue);
				paramValue = Integer.toString(changeInt);
			}
			
			sysParamVO.setName(paramName);
			sysParamVO.setValue(paramValue);
			
			int updateChk = ezSystemAdminDAO.updateCompanyConfigParam(sysParamVO);
			if (updateChk <= 0) {
				logger.debug("inserst companyConfig");
				ezSystemAdminDAO.insertCompanyConfigParam(sysParamVO);
			}
		}
		logger.debug("updateCompanyConfig ended. tenantID=" + tenantID);
	}
	
	@Override
	public List<MainVO> getAdminAccessHist(int tenantID, String offset, int startPage, int maxItemPerPage, String keycode, 
			String keyword, String keycodeForRoll, String lang, String startDate, String endDate, String companyId) throws Exception {

		logger.debug("getAdminAccessHist started. tenantID : {}", tenantID);
		
		String companyOracleStr = "";
		if (!"Top/organ".equals(companyId)) {
			companyOracleStr = " AND C.COMPANYID ='" + companyId + "'";
		}
		
		Map<String, Object> params = new HashMap<>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("v_start", startPage);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForRoll", keycodeForRoll);
		params.put("lang", lang); // primary:기본명 / 1:영문명
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getAdminAccessHist ended.");
		List<MainVO> list = ezSystemAdminDAO.getAdminAccessHist(params);
		
		return list;
	}

	@Override
	public void updateSystemAdminIPAllow(String allowResult, int tenantID) throws Exception {
		logger.debug("updateSystemIPAllow started. tenantID=" + tenantID + ", allowResult=" + allowResult);
		
		SysParamVO sysParamVO = new SysParamVO();
		sysParamVO.setTenantID(tenantID);
		sysParamVO.setValue(allowResult);
		sysParamVO.setName("useAdminIPAccess");
		
		int successChk = ezSystemAdminDAO.updateSystemAdminIPAllow(sysParamVO);
		logger.debug("successChk=" + successChk);
		if (successChk <= 0) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("tenantID", tenantID);
			params.put("confName","useAdminIPAccess"); // property_name
			params.put("property_value",allowResult);
			params.put("config_name","관리자 IP 제한");
			params.put("regdate","2020-04-27 00:00:00");
			params.put("description","관리자 페이지 IP 제한(default: NO)");
			params.put("config_type","시스템");
			params.put("property","useAdminIPAccess"); // property_name

			logger.debug("insert tbl_tenant_config. adminIpAccess");
			ezCommonDAO.insertTblTenantConfig(params);
		}
		
		logger.debug("updateSystemIPAllow ended");
	}
	
	@Override
	public List<IPBandVO> getAdminAccessIPBand(int tenantID) throws Exception {
		logger.debug("getAdminAccessIPBand started. tenantID=" + tenantID);
		List<IPBandVO> list = ezSystemAdminDAO.getAdminAccessIPBand(tenantID);
		
		logger.debug("getAdminAccessIPBand ended.");
		return list;
	}
	
	@Override
	public int getAdminAccessHistCount(int tenantID, String offset, String keycode, String keyword, String keycodeForRoll, String lang, String startDate, String endDate, String companyId) throws Exception {
		
		logger.debug("getAdminAccessHistCount started. tenantID : {}", tenantID);

		String companyOracleStr = "";
		if (!"Top/organ".equals(companyId)) {
			companyOracleStr = " AND C.COMPANYID ='" + companyId + "'";
		}
		
		Map<String, Object> params = new HashMap<>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForRoll", keycodeForRoll);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("companyOracleStr", companyOracleStr);
				
		logger.debug("getAdminAccessHistCount ended.");
		
		return ezSystemAdminDAO.getAdminAccessHistCount(params);
	}
	
	@Override
	public void insertAdminIPBand(int tenantID, String ipAddress, String access, String explanation) throws Exception {
		logger.debug("insertAdminIPBand started.");
		logger.debug("tenantID=" + tenantID + ", ipAddress=" + ipAddress + ", access=" + access + ", explanation=" + explanation);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tenantID", tenantID);
		params.put("ipAddress", ipAddress);
		params.put("access", access);
		params.put("explanation", explanation);
		
		ezSystemAdminDAO.insertAdminIPBand(params);
		
		logger.debug("insertAdminIPBand ended.");
	}
	
	@Override
	public IPBandVO getSystemAdminIPBand(String ipNo) throws Exception {
		logger.debug("getSystemAdminIPBand started.");
		logger.debug("ipNo=" + ipNo);
		
		IPBandVO ipBand = ezSystemAdminDAO.getSystemAdminIPBand(ipNo);
		
		logger.debug("getSystemAdminIPBand ended.");
		
		return ipBand;
	}

	@Override
	public void updateAdminIPBand(String ipNo, String ipAddress, String access, String explanation) throws Exception {
		logger.debug("updateAdminIPBand started.");
		logger.debug("ipNo=" + ipNo + ", ipAddress=" + ipAddress + ", access=" + access + ", explanation=" + explanation);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ipNo", ipNo);
		params.put("ipAddress", ipAddress);
		params.put("access", access);
		params.put("explanation", explanation);
		
		ezSystemAdminDAO.updateAdminIPBand(params);
		
		logger.debug("updateAdminIPBand ended.");
	}

	@Override
	public int isExistSystemAdminIPBand(String ipNo) throws Exception {
		logger.debug("isExistSystemAdminIPBand started.");
		logger.debug("ipNo=" + ipNo);

		String[] ipNoList = ipNo.split(",");
		List<String> list = new ArrayList<String>();

		for (int i = 0; i < ipNoList.length; i++) {
			list.add(ipNoList[i]);
		}

		int isExist = ezSystemAdminDAO.isExistSystemAdminIPBand(list);

		logger.debug("isExistSystemAdminIPBand ended.");

		return isExist;
	}

	@Override
	public String isExistSystemAccess(String deleteList, String type, String useIPAccess, int tenantID) throws Exception {
		logger.debug("isExistSystemAccess started.");
		logger.debug("useIPAccess=" + useIPAccess +", deleteList="+deleteList);

		if ("YES".equalsIgnoreCase(useIPAccess)){
			List<String> userList = getAllAccessListCom(tenantID);
			String countryCodeList = getAccessCountryList(tenantID);
			List<IPBandVO> ipList = getAllIPBand(tenantID);
			int accessIp = 0;
			for(int i = 0; i < ipList.size(); i++) {
				if ("YES".equalsIgnoreCase(ipList.get(i).getAccess())){
					accessIp += 1;
				}
			}
			boolean existCountryList = "".equalsIgnoreCase(countryCodeList) ? false : true;
			boolean existIdList = userList.size() == 0 ? false : true;
			boolean existIpList = accessIp == 0 ? false : true;

			if ("id".equalsIgnoreCase(type)){
				String [] deleteCodeArr = deleteList.isEmpty() ? new String[0] : deleteList.split(",");
				if (deleteCodeArr.length == userList.size()){ //지우려는 거랑 현재 목록 숫자 같은경우
					existIdList = false;
				}
			} else if ("ip".equalsIgnoreCase(type)) {
				String [] deleteCodeArr = deleteList.isEmpty() ? new String[0] : deleteList.split(",");
				for (int i = 0; i < ipList.size(); i++) {
					for (int j = 0; j < deleteCodeArr.length; j++) {
						if (ipList.get(i).getIpNo().equalsIgnoreCase(deleteCodeArr[j])){
							ipList.remove(i);
						}
					}
				}
				int remainAccessIp = 0;
				for(int i = 0; i < ipList.size(); i++) {
					if ("YES".equalsIgnoreCase(ipList.get(i).getAccess())){
						remainAccessIp += 1;
					}
				}
				if (remainAccessIp == 0){ //지우고 남은 것중에 허용ip 수가 0인경우
					existIpList = false;
				}
			} else {
				String [] deleteCodeArr = deleteList.isEmpty() ? new String[0] : deleteList.split(";");
				if (deleteCodeArr.length == 0){ //국가의 경우 전체 목록을 가져오므로 해당 목록이 0인 경우 false
					existCountryList = false;
				} //국가가 목록이 추가되는 순간은 다른 목록(ip,id)들이 있어서 굳이 true로 변환 안해도 됨
			}

			if (!existIdList && !existCountryList && !existIpList){
				return "setAccess";
			}
		}

		logger.debug("isExistSystemAccess ended.");

		return "success";
	}

	@Override
	public void deleteAdminIPBand(String ipNo) throws Exception {
		logger.debug("deleteIPBand started.");
		logger.debug("ipNo=" + ipNo);
		
		String[] ipNoList = ipNo.split(",");
		List<String> list = new ArrayList<String>();
		
		for (int i = 0; i < ipNoList.length; i++) {
			list.add(ipNoList[i]);
		}
		
		ezSystemAdminDAO.deleteAdminIPBand(list);
		
		logger.debug("deleteIPBand ended.");
	}

	@Override
	public List<PermissionInfoVO> getPermissionChHist(int tenantID, String offset, int startPage,
			int maxItemPerPage, String keycode, String keyword, String keycodeForRoll, String lang, String startDate,
			String endDate, String companyId, boolean isMaster) throws Exception {
		logger.debug("getPermissionChHist started. tenantID : {}", tenantID);

		String companyOracleStr = "";
		String isMasterAdmin = "";

		if (!"Top/organ".equals(companyId)) {
			companyOracleStr = " AND C.COMPANYID ='" + companyId + "'";
		}

		if (isMaster) {
			isMasterAdmin = "Y";
		}

		Map<String, Object> params = new HashMap<>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("v_start", startPage);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForRoll", keycodeForRoll);
		params.put("lang", lang); // primary:기본명 / 1:영문명
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("isMasterAdmin", isMasterAdmin);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getPermissionChHist ended.");
		List<PermissionInfoVO> list = ezSystemAdminDAO.getPermissionChHist(params);

		return list;
	}

	@Override
	public int getPermissionChHistCount(int tenantID, String offset, String keycode, String keyword,
			String keycodeForRoll, String lang, String startDate, String endDate, String companyId, boolean isMaster) throws Exception {
		logger.debug("getPermissionChHistCount started. tenantID : {}", tenantID);

		String companyOracleStr = "";
		String isMasterAdmin = "";

		if (!"Top/organ".equals(companyId)) {
			companyOracleStr = " AND C.COMPANYID ='" + companyId + "'";
		}

		if (isMaster) {
			isMasterAdmin = "Y";
		}

		Map<String, Object> params = new HashMap<>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForRoll", keycodeForRoll);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("isMasterAdmin", isMasterAdmin);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getPermissionChHistCount ended.");
		return ezSystemAdminDAO.getPermissionChHistCount(params);
	}

	@Override
	public List<String> getFileExtension(int tenantId) throws Exception {
		logger.debug("getFileExtension started");

		String fileExtension = ezSystemAdminDAO.getFileExtension(tenantId);
		List<String> result = new ArrayList<>(Arrays.asList(fileExtension.split(",")));
		Collections.sort(result);

		logger.debug("getFileExtension ended");

		return result;
	}

	@Override
	public String updateFileExtension(int tenantId, ArrayList<String> updateFileExtensionList) throws Exception {
		logger.debug("updateFileExtension service started");

		Map<String,Object> map = new HashMap<>();
		map.put("tenantId", tenantId);
		
		String updateFileExtension = String.join(",", updateFileExtensionList);
		map.put("fileExtension", updateFileExtension);

		ezSystemAdminDAO.updateFileExtension(map);

		logger.debug("updateFileExtension service ended");
		return "OK";
	}
	
	
	@Override
	public void insertUserChangeHist(UserChangeInfoVO userChangeInfoVO, LoginVO userInfo) throws Exception {
		logger.debug("insertUserChangeHist started.");
		String updateType = userChangeInfoVO.getUpdateType();
		
		if (updateType.equals("clearAddJob") || updateType.equals("grantAddJob")) {
			// 겸직엔 updatedt가 없으므로 겸직 부여, 해제일경우 현재 시각을 구한다 
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    		date.setTimeZone(TimeZone.getTimeZone("GMT"));
    		String nowDate = date.format(new Date());
    		userChangeInfoVO.setUpdatedt(nowDate);
    		userChangeInfoVO.setTargetType("addJob");
		} else if (!updateType.equals("mvDept")) {	
				//targetType이 user일경우 대상부서값이 필요없으므로 ""로 setting 해준다
				userChangeInfoVO.setTargetDeptId("");
				userChangeInfoVO.setTargetDeptNm("");
				userChangeInfoVO.setTargetDeptNm2("");
		}
		//인사연동인 경우 
		if (userChangeInfoVO.getExecutorIp().equals("127.0.0.1")) {
			userChangeInfoVO.setExecutorId("ez_sync"); 
			userChangeInfoVO.setExecutorNm("");
			userChangeInfoVO.setExecutorNm2("");
		}else { // 수동인 경우 
			// 처리자 정보를 userInfo에서 값을 꺼내서 setting 
			userChangeInfoVO.setExecutorId(userInfo.getId()); 
			userChangeInfoVO.setExecutorNm(userInfo.getDisplayName());
			userChangeInfoVO.setExecutorNm2(userInfo.getDisplayName2());
		}
		
		logger.debug("insertUserChangeHist ended.");	
		ezSystemAdminDAO.insertUserChangeHist(userChangeInfoVO);
		
	}
    
	@Override
	public List<UserChangeInfoVO> getUserChHistList(int tenantID, String offset, int startPage, int maxItemPerPage,
			String keyword, String keycode, String keycodeForType, String lang, String startDate, String endDate,
			String companyId, boolean isMaster) throws Exception {
		
		
		logger.debug("getUserChHistList started. tenantID : {}", tenantID);
		
		String companyOracleStr = "";
		String isMasterAdmin = "";

		if (!"Top/organ".equals(companyId)) {
			companyOracleStr = " AND C.COMPANYID ='" + companyId + "'";
		}

		if (isMaster) {
			isMasterAdmin = "Y";
		}

		logger.debug("lang : {} , search_keycode : {} , search_keyword : {} , search_keyType : {}", lang, keycode,keyword,keycodeForType);
		Map<String, Object> params = new HashMap<>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("v_start", startPage);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForType", keycodeForType);
		params.put("lang", lang); // primary:기본명 / 1:영문명
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("isMasterAdmin", isMasterAdmin);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getUserChHistList ended.");
		List<UserChangeInfoVO> list = ezSystemAdminDAO.getUserChHistList(params);
		return list;
	}

	@Override
	public int getUserChHistListCount(int tenantID, String offset, String keyword, String keycode,
			String searchKeycodeForType, String lang, String startDate, String endDate, String companyId,
			boolean isMaster) throws Exception {
		logger.debug("getUserChHistListCount started. tenantID : {}", tenantID);

		String companyOracleStr = "";
		String isMasterAdmin = "";

		if (!"Top/organ".equals(companyId)) {
			companyOracleStr = " AND COMPANYID ='" + companyId + "'";
		}

		if (isMaster) {
			isMasterAdmin = "Y";
		}

		Map<String, Object> params = new HashMap<>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForType", searchKeycodeForType);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("isMasterAdmin", isMasterAdmin);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getUserChHistListCount ended.");

		return ezSystemAdminDAO.getUserChHistListCount(params);
	}

	@Override
	public List<DeptChangeInfoVO> getDeptChHistList(int tenantID, String offset, int startPage, int maxItemPerPage,
			String keyword, String keycode, String keycodeForType, String lang, String startDate, String endDate,
			String companyId, boolean isMaster) throws Exception {
		logger.debug("getDeptChHistList started. tenantID : {}", tenantID);

		String companyOracleStr = "";
		String isMasterAdmin = "";

		if (!"Top/organ".equals(companyId)) {
			companyOracleStr = " AND COMPANYID ='" + companyId + "'";
		}

		if (isMaster) {
			isMasterAdmin = "Y";
		}

		logger.debug("lang : {} , search_keycode : {} , search_keyword : {} , search_keyType : {}", lang, keycode,keyword,keycodeForType);
		Map<String, Object> params = new HashMap<>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("v_start", startPage);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForType", keycodeForType);
		params.put("lang", lang); // primary:기본명 / 1:영문명
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("isMasterAdmin", isMasterAdmin);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getDeptChHistList ended.");
		List<DeptChangeInfoVO> list = ezSystemAdminDAO.getDeptChHistList(params);
		return list;
	}

	@Override
	public int getDeptChHistListCount(int tenantID, String offset, String keyword, String keycode,
			String keycodeForType, String lang, String startDate, String endDate, String companyId,
			boolean isMaster) throws Exception {
		logger.debug("getDeptChHistListCount started. tenantID : {}", tenantID);

		String companyOracleStr = "";
		String isMasterAdmin = "";

		if (!"Top/organ".equals(companyId)) {
			companyOracleStr = " AND COMPANYID ='" + companyId + "'";
		}

		if (isMaster) {
			isMasterAdmin = "Y";
		}

		Map<String, Object> params = new HashMap<>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("search_keycodeForType", keycodeForType);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("isMasterAdmin", isMasterAdmin);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getDeptChHistListCount ended.");

		return ezSystemAdminDAO.getDeptChHistListCount(params);
	}

	@Override
	public void insertDeptChangeHist(DeptChangeInfoVO deptChangeInfoVO, LoginVO userInfo) throws Exception {
		logger.debug("insertDeptChangeHist started.");

		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		deptChangeInfoVO.setUpdatedt(nowDate);

		deptChangeInfoVO.setExecutorId(userInfo.getId());
		deptChangeInfoVO.setExecutorNm(userInfo.getDisplayName());
		deptChangeInfoVO.setExecutorNm2(userInfo.getDisplayName2());

		logger.debug("insertDeptChangeHist ended.");

		ezSystemAdminDAO.insertDeptChangeHist(deptChangeInfoVO);
	}

	@Override
	public List<ConnectionInfoVO> getConnectorList(int tenantID, String offset, int startPage, int maxItemPerPage,
			String keycode, String keyword, String lang, String startDate, String endDate, String companyId)
			throws Exception {
		logger.debug("getConnectorList started. tenantID : " + tenantID);

		String companyOracleStr = "";

		if (companyId != null && !companyId.equals("Top/organ")) {
			companyOracleStr = " AND COMPANYID ='" + companyId + "'";
		}

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("v_start", startPage);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("lang", lang); // primary:기본명 / 1:영문명
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getConnectorList ended.");
		List<ConnectionInfoVO> list = ezSystemAdminDAO.getConnectorList(params);

		return list;
	}

	@Override
	public int getConnectorListCount(int tenantID, String offset, String keycode, String keyword, String lang,
			String startDate, String endDate, String companyId) throws Exception {

		logger.debug("getConnectorListCount started. tenantID : " + tenantID);

		String companyOracleStr = "";

		if (companyId != null && !companyId.equals("Top/organ")) {
			companyOracleStr = " AND COMPANYID ='" + companyId + "'";
		}

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		params.put("companyId", companyId);
		params.put("companyOracleStr", companyOracleStr);

		logger.debug("getConnectorListCount ended.");

		return ezSystemAdminDAO.getConnectorListCount(params);
	}

	@Override
	public void resetThemeAllUser() throws Exception {
		logger.debug("resetThemeAllUser started.");

		ezSystemAdminDAO.updateResetThemeAllCompany(); // 모든 회사 테마 리셋
		ezSystemAdminDAO.deleteThemeAllUser();
		ezSystemAdminDAO.updateResetThemeAllUser();

		logger.debug("resetThemeAllUser ended.");
	}

	@Override
	public void resetPortletAllUser() throws Exception {
		logger.debug("resetPortletAllUser started.");

		ezSystemAdminDAO.deletePortletAllUser();
		ezSystemAdminDAO.deletePortletSizeAllUser();

		logger.debug("resetPortletAllUser ended.");
	}
	
	@Override
	public int getSystemConfigListCount(String searchValue, String typeCode, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("searchValue", searchValue);
		map.put("companyID", companyID);
		map.put("typeCode", typeCode);
		
		return ezSystemAdminDAO.getSystemConfigListCount(map);
	}
	
	@Override
	public int getSystemConfigListCountPopup(String searchValue, String typeCode, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("searchValue", searchValue);
		map.put("companyID", companyID);
		map.put("typeCode", typeCode);
		
		return ezSystemAdminDAO.getSystemConfigListCountPopup(map);
	}
	
	@Override
	public List<SystemConfigVO> getSystemConfigList(String searchValue, String typeCode, String offset, int startRow, int pageCount, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("searchValue", searchValue);
		map.put("typeCode", typeCode);
		map.put("offset", offset);
		map.put("v_STARTNUM", startRow);
		map.put("v_COUNT", pageCount);
		map.put("v_TENANT_ID", tenantID);
		map.put("companyID", companyID);
		
		return (List<SystemConfigVO>) ezSystemAdminDAO.getSystemConfigList(map);
	}
	
	@Override
	public List<SystemConfigVO> getSystemConfigListPopup(String searchValue, String typeCode, String offSet, int startRow, int pageCount, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("searchValue", searchValue);
		map.put("typeCode", typeCode);
		map.put("offSet", offSet);
        map.put("v_STARTNUM", startRow);
        map.put("v_COUNT", pageCount);
		map.put("v_TENANT_ID", tenantID);
		map.put("companyID", companyID);
		
		return (List<SystemConfigVO>) ezSystemAdminDAO.getSystemConfigListPopup(map);
	}
	
	@Override
	public SystemConfigVO getSystemConfig(String CODE, String offset, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("CODE", CODE);
		map.put("v_TENANT_ID", tenantID);
		map.put("companyID", companyID);
		map.put("offset", offset);
		
		return (SystemConfigVO) ezSystemAdminDAO.getSystemConfig(map);
	}
	
	@Override
	public void deletesyStemConfig(String sCode, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("CODE", sCode);
		map.put("v_TENANT_ID", tenantID);
		map.put("companyID", companyID);
		
		ezSystemAdminDAO.deletesyStemConfig(map);
	}
	
	@Override
	public String insertStemConfig(Document doc, String WRITERID, String WRITERNAME, int tenantID) throws Exception {
		logger.debug("insertStemConfig started");
		
		String CODE = doc.getElementsByTagName("CODE").item(0).getTextContent();
		String CODEVALUE = doc.getElementsByTagName("CODEVALUE").item(0).getTextContent();
		String DESCRIPTION = doc.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String typeCode = doc.getElementsByTagName("TYPECODE").item(0).getTextContent();
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("CODE", CODE);
		map.put("CODEVALUE", CODEVALUE);
		map.put("DESCRIPTION", DESCRIPTION);
		map.put("WRITERID", WRITERID);
		map.put("WRITERNAME", WRITERNAME);
		map.put("WRITEDATE", commonUtil.getTodayUTCTime(""));
		map.put("v_TENANT_ID", tenantID);
		map.put("companyID", companyID);
		map.put("typeCode", typeCode);
		try {
			ezSystemAdminDAO.insertStemConfig(map);

			logger.debug("insertStemConfig ended");
			return "OK";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "ERROR : " + e.getMessage();
		}
	}
	
	@Override
	public String updateStemConfig(Document doc, String WRITERID, String WRITERNAME, int tenantID) throws Exception {
		logger.debug("updateStemConfig started");
		
		String CODE = doc.getElementsByTagName("CODE").item(0).getTextContent();
		String CODEVALUE = doc.getElementsByTagName("CODEVALUE").item(0).getTextContent();
		String DESCRIPTION = doc.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String typeCode = doc.getElementsByTagName("TYPECODE").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("CODE", CODE);
		map.put("CODEVALUE", CODEVALUE);
		map.put("DESCRIPTION", DESCRIPTION);
		map.put("WRITERID", WRITERID);
		map.put("WRITERNAME", WRITERNAME);
		map.put("v_TENANT_ID", tenantID);
		map.put("companyID", companyID);
		map.put("WRITEDATE", commonUtil.getTodayUTCTime(""));
		map.put("typeCode", typeCode);
	
		try {
			ezSystemAdminDAO.updateStemConfig(map);

			logger.debug("updateStemConfig ended");
			return "OK";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "ERROR : " + e.getMessage();
		}
	}

	@Override
	public String getSystemConfigTypeList(String searchValue, String offset, int startRow, int pageSize, String searchMode, String primary, String companyID, int tenantId) throws Exception {
		logger.debug("getSystemConfigTypeList started");
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("searchValue", searchValue);
		map.put("startRow", startRow);
		map.put("pageSize", pageSize);
		map.put("v_TENANT_ID", tenantId);
		map.put("companyID", companyID);
		map.put("offset", offset);
		map.put("searchMode", searchMode);
		
		int cnt = getSystemConfigTypeListCount(searchValue, companyID, tenantId);
		List<SystemConfigTypeVO> configTypeList = ezSystemAdminDAO.getSystemConfigTypeList(map);
		
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<ROWS>");
		result.append("<TOTALCNT>");
		result.append(cnt);
		result.append("</TOTALCNT>");
		
		for (int i = 0; i < configTypeList.size(); i++) {
        	SystemConfigTypeVO vo = configTypeList.get(i);
        	result.append("<ROW>");
        	result.append("<CELL>");
        	result.append("<VALUE>" + commonUtil.cleanValue(vo.getTypeCode()) + "</VALUE>");
        	result.append("<DATA1>" + commonUtil.cleanValue(vo.getTypeCode()) + "</DATA1>");
            result.append("<DATA2>" + commonUtil.cleanValue(vo.getTypeName()) + "</DATA2>");
            result.append("<DATA3>" + commonUtil.cleanValue(vo.getTypeName2()) + "</DATA3>");
            result.append("<DATA4>" + commonUtil.cleanValue(vo.getDescription()) + "</DATA4>");
            if (primary.equals("1")) {
            	result.append("<DATA5>" + commonUtil.cleanValue(vo.getWriterName()) + "</DATA5>");
            } else {
            	result.append("<DATA5>" + commonUtil.cleanValue(vo.getWriterName2()) + "</DATA5>");
            }
            result.append("<DATA6>" + commonUtil.cleanValue(vo.getWriteDate()) + "</DATA6>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getTypeName()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getTypeName2()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getDescription()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getWriterName()) + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE>" + commonUtil.cleanValue(vo.getWriteDate().substring(0,10)) + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
		
		logger.debug("getSystemConfigTypeList ended");
		return result.toString();
	}
	
	@Override
	public List<SystemConfigTypeVO> getSystemConfigTypeListNotXml(String searchValue, String offset, int startRow, int pageSize, String searchMode, String companyID, int tenantId) throws Exception {
		logger.debug("getSystemConfigTypeListNotXml started");
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("searchValue", searchValue);
		map.put("startRow", startRow);
		map.put("pageSize", pageSize);
		map.put("v_TENANT_ID", tenantId);
		map.put("companyID", companyID);
		map.put("offset", offset);
		map.put("searchMode", searchMode);
		List<SystemConfigTypeVO> configTypeList = ezSystemAdminDAO.getSystemConfigTypeList(map);
		
		logger.debug("getSystemConfigTypeListNotXml ended");
		return configTypeList;
	}

	@Override
	public int getSystemConfigTypeListCount(String searchValue, String companyID, int tenantId) throws Exception {
		logger.debug("getSystemConfigTypeListCount started");
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("serarchValue", searchValue);
		map.put("v_TENANT_ID", tenantId);
		map.put("companyID", companyID);
		
		int cnt = ezSystemAdminDAO.getSystemConfigTypeListCount(map);
		logger.debug("getSystemConfigTypeListCount ended");
		return cnt;
	}

	@Override
	public void deleteSystemConfigType(String typeCode, String companyID, int tenantId) throws Exception {
		logger.debug("deleteSystemConfigType started");
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantId);
		map.put("companyID", companyID);
		map.put("typeCode", typeCode);
		ezSystemAdminDAO.deleteSystemConfigByTypeCode(map);
		ezSystemAdminDAO.deleteSystemConfigType(map);
		logger.debug("deleteSystemConfigType ended");
	}

	@Override
	public String checkDuplicateCode(String code, int tenantId, String companyID) throws Exception {
		logger.debug("checkDuplicateCode started");
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantId);
		map.put("companyID", companyID);
		map.put("code", code);
		
		int codeCnt = ezSystemAdminDAO.checkDuplicateCode(map);
		String result = "";
		
		if (codeCnt >= 1) {
			result = "DUPLICATE";
		} else {
			result = "AVAILABLE";
		}
		logger.debug("checkDuplicateCode ended");
		return result;
	}

	@Override
	public SystemConfigTypeVO getSystemConfigType(String typeCode, String offset, String companyID, int tenantId) throws Exception {
		logger.debug("getSystemConfigType started");
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantId);
		map.put("companyID", companyID);
		map.put("offset", offset);
		map.put("typeCode", typeCode);
		
		SystemConfigTypeVO result = ezSystemAdminDAO.getSystemConfigType(map);
		logger.debug("getSystemConfigType ended");
		return result;
	}

	@Override
	public String checkDuplicateTypeCode(String typeCode, int tenantId, String companyID) throws Exception {
		logger.debug("checkDuplicateTypeCode started");
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantId);
		map.put("companyID", companyID);
		map.put("typeCode", typeCode);
		
		int codeCnt = ezSystemAdminDAO.checkDuplicateTypeCode(map);
		String result = "";
		
		if (codeCnt >= 1) {
			result = "DUPLICATE";
		} else {
			result = "AVAILABLE";
		}
		logger.debug("checkDuplicateTypeCode ended");
		return result;
	}

	@Override
	public void insertSystemConfigType(String typeCode, String typeName, String typeName2, String description, String writerId, String writerName, String writerName2, int tenantId, String companyId) throws Exception {
		logger.debug("insertSystemConfigType started");
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("typeCode", typeCode);
		map.put("typeName", typeName);
		map.put("typeName2", typeName2);
		map.put("description", description);
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("writerId", writerId);
		map.put("writerName", writerName);
		map.put("writerName2", writerName2);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezSystemAdminDAO.insertSystemConfigType(map);

		logger.debug("insertSystemConfigType ended");
	}

	@Override
	public void updateSystemConfigType(String typeCode, String typeName, String typeName2, String description, String writerId, String writerName, String writerName2, int tenantId, String companyId) throws Exception {
		logger.debug("updateSystemConfigType started");
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("typeCode", typeCode);
		map.put("typeName", typeName);
		map.put("typeName2", typeName2);
		map.put("description", description);
		map.put("writeDate", commonUtil.getTodayUTCTime(""));
		map.put("writerId", writerId);
		map.put("writerName", writerName);
		map.put("writerName2", writerName2);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezSystemAdminDAO.updateSystemConfigType(map);
		
		logger.debug("updateSystemConfigType ended");
	}

	@Override
	public void disableDeleteSystemConfig(String sCode, String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("code", sCode);
		map.put("tenantId", tenantId);
		map.put("companyId", companyID);
		
		ezSystemAdminDAO.disableDeleteSystemConfig(map);
	}

	@Override
	public List<IPBandVO> getFidoAuthenticList(int tenantID, String companyId) throws Exception {
		logger.debug("getFidoAuthenticList started. tenantID : {},  companyId : {}", tenantID, companyId);

		Map<String, Object> map = new HashMap<>();
		map.put("tenantID", tenantID);
		map.put("companyId", companyId);

		List<IPBandVO> list = ezSystemAdminDAO.getFidoAuthenticList(map);

		logger.debug("getFidoAuthenticList ended.");
		return list;
	}
	
	public int getFidoAuthenticInfo(int tenantID, String companyId, String ipAddress) throws Exception {
		logger.debug("getFidoAuthenticInfo started. tenantID : {} companyId : {} ipAddress : {}" + tenantID, companyId, ipAddress);

		Map<String,Object> map = new HashMap<>();
		map.put("tenantID", tenantID);
		map.put("companyId", companyId);
		map.put("ipAddress", ipAddress);

		logger.debug("getFidoAuthenticInfo ended.");
		return ezSystemAdminDAO.getFidoAuthenticInfo(map);
		
	}
	
	@Override
	public IPBandVO getSystemFidoIPBand(String ipNo) throws Exception {
		logger.debug("getSystemFidoIPBand started.");
		logger.debug("ipNo=" + ipNo);

		IPBandVO ipBand = ezSystemAdminDAO.getSystemFidoIPBand(ipNo);

		logger.debug("getSystemFidoIPBand ended.");

		return ipBand;
	}
	
	@Override
	public void insertFidoIPBand(int tenantID, String companyId, String ipAddress, String access, String explanation) throws Exception {
		logger.debug("inserFidoIPBand started.");
		logger.debug("tenantID=" + tenantID + ", companyId=" + companyId + ", ipAddress=" + ipAddress +  ", access=" + access + " explanation=" + explanation);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tenantID", tenantID);
		params.put("companyId", companyId);
		params.put("access", access);
		params.put("ipAddress", ipAddress);
		params.put("explanation", explanation);

		ezSystemAdminDAO.insertFidoIPBand(params);

		logger.debug("inserFidoIPBand ended.");
	}
	
	@Override
	public void updateFidoIPBand(String ipNo, String ipAddress, String access, String explanation) throws Exception {
		logger.debug("updateFidoIPBand started.");
		logger.debug("ipNo=" + ipNo + ", ipAddress=" + ipAddress +  ", access=" + access + ", explanation=" + explanation);

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ipNo", ipNo);
		params.put("ipAddress", ipAddress);
		params.put("access", access);
		params.put("explanation", explanation);

		ezSystemAdminDAO.updateFidoIPBand(params);

	}
	
	@Override
	public void deleteFidoIPBand(String ipNo) throws Exception {
		logger.debug("deleteFidoIPBand started.");
		logger.debug("ipNo=" + ipNo);

		String[] ipNoList = ipNo.split(",");
		List<String> list = new ArrayList<String>();

		for (int i = 0; i < ipNoList.length; i++) {
			list.add(ipNoList[i]);
		}

		ezSystemAdminDAO.deleteFidoIPBand(list);

		logger.debug("deleteFidoIPBand ended.");
	}

}
