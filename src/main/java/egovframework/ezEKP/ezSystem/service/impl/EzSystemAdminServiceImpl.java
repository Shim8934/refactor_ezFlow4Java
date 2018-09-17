package egovframework.ezEKP.ezSystem.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.ResourceAccessException;
import org.springframework.web.client.RestTemplate;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.dao.EzSystemAdminDAO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.util.EzSystemUtil;
import egovframework.ezEKP.ezSystem.vo.AccessIdVO;
import egovframework.ezEKP.ezSystem.vo.CheckName;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.IPBandVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;

@Service("EzSystemAdminService")
public class EzSystemAdminServiceImpl implements EzSystemAdminService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzSystemAdminServiceImpl.class);
	
	@Resource(name="EzSystemAdminDAO")
	EzSystemAdminDAO ezSystemAdminDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Override
	public List<SysParamVO> getSysParam(int tenantID) throws Exception {	
		logger.debug("getSysParam started. tenantID=" + tenantID);
		
		List<SysParamVO> list = ezSystemAdminDAO.getSysParam(tenantID);
		List<SysParamVO> afterList = new ArrayList<SysParamVO>();
		
		for (int i = 0; i < list.size(); i++) {
			try {
				CheckName.valueOf(list.get(i).getName());
				afterList.add(list.get(i));
			} catch (IllegalArgumentException e){}
		}

		logger.debug("getSysParam ended");
		
		return afterList;
	}

	@Override
	public void updateSysParam(int tenantID, List<Map<String, String>> list, Locale locale) throws Exception {
		logger.debug("updateSysParam started. tenantID=" + tenantID);
		
		SysParamVO sysParamVO = new SysParamVO();
		sysParamVO.setTenantID(tenantID);		
		
		for (int i = 0; i < list.size(); i++) {					
			String paramName = list.get(i).get("name");
			String paramValue = list.get(i).get("value");
			
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
			String keyword, String lang, String startDate, String endDate) throws Exception {

		logger.debug("getLoginHist started. tenantID : " + tenantID);
		
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

		List<ConnectionInfoVO> list = ezSystemAdminDAO.getLoginHist(params);
		logger.debug("getLoginHist ended.");
		
		return list;
	}

	@Override
	public int getLoginHistCount(int tenantID, String offset, String keycode, String keyword, String lang, String startDate, String endDate) throws Exception {
		
		logger.debug("getLoginHistCount started. tenantID : " + tenantID);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
				
		logger.debug("getLoginHistCount ended.");
		
		return ezSystemAdminDAO.getLoginHistCount(params);
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
}
