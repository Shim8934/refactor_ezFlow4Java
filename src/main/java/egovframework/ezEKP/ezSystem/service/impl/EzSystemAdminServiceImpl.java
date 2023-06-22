package egovframework.ezEKP.ezSystem.service.impl;

import java.io.IOException;
import java.lang.reflect.Array;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

import javax.annotation.Resource;

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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.dao.EzCommonDAO;
import egovframework.ezEKP.ezSystem.dao.EzSystemAdminDAO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.util.EzSystemUtil;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.CheckName;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.DataForModulesEnum;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.ezEKP.ezSystem.vo.ModuleSizeVO;
import egovframework.ezEKP.ezSystem.vo.PasswordPolicyVO;
import egovframework.ezEKP.ezSystem.vo.PermissionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;
import egovframework.let.main.vo.MainVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzSystemAdminService")
public class EzSystemAdminServiceImpl implements EzSystemAdminService {
	
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
					updateNewPortalMenuByPackageType(newPackageType, tenantID, companyID);
				}
			}

			if (paramName.equals("useSession") || paramName.equals("useSessionMobile")) {
				int sessionParam = Integer.parseInt(paramValue);
				paramValue = Integer.toString(sessionParam);
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
			
			if (paramName.equals("ExpirePassPeriod") || paramName.equals("MaxAllowedCountOfLoginFail")) {
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
}
