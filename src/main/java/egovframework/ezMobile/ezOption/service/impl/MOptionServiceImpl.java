package egovframework.ezMobile.ezOption.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.ezMobile.ezOption.dao.MOptionDAO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezPortal.web.MPortalController;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MOptionService")
public class MOptionServiceImpl extends EgovAbstractServiceImpl implements MOptionService {

	private static final Logger LOGGER = LoggerFactory.getLogger(MPortalController.class);

	@Resource(name = "MOptionDAO")
	private MOptionDAO mOptionDAO;	
	
	@Override
	public String saveOption(String id, String langFlag, String dpBoardCnt, String resourceChk, String resourceYN, int tenantId) throws Exception {
		LOGGER.debug("saveOption started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		mOptionDAO.insertOption(map);
		
		LOGGER.debug("saveOption ended");
		
		return null;
	}

	@Override
	public MCommonVO commonInfo(String serverName, String userId) throws Exception {
		LOGGER.debug("commonInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("serverName", serverName);
		map.put("userId", userId);
		
		MCommonVO info = mOptionDAO.commonInfo(map);
				
		LOGGER.debug("commonInfo ended");
		
		return info;
	}

	@Override
	public MOptionVO optionInfo(String userId, int tenantId) throws Exception {
		LOGGER.debug("optionInfo started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		MOptionVO info = mOptionDAO.optionInfo(map);
				
		LOGGER.debug("optionInfo ended");
		
		return info;
	}

	@Override
	public void insertOption(String uid, String timeZone, String lang, String mainType, String listCnt, String useSearch, String useSecurity, int tenantId) throws Exception {
		LOGGER.debug("insertOption started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", uid);
		map.put("timeZone", timeZone);
		map.put("lang", lang);
		map.put("mainType", mainType);
		map.put("listCnt", listCnt);
		map.put("useSearch", useSearch);
		map.put("useSecurity", useSecurity);
		map.put("tenantId", tenantId);			
		
		mOptionDAO.insertOption(map);
				
		LOGGER.debug("insertOption ended");				
	}

	@Override
	public void updateOption(String userId, String timeZone, String lang,
			String mainType, String listCnt, String useSearch,
			String useSecurity, int tenantId) throws Exception {
		
		LOGGER.debug("updateOption started");	
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("timeZone", timeZone);
		map.put("lang", lang);
		map.put("mainType", mainType);
		map.put("listCnt", listCnt);
		map.put("useSearch", useSearch);
		map.put("useSecurity", useSecurity);
		map.put("tenantId", tenantId);
		
		mOptionDAO.updateOption(map);
		
		LOGGER.debug("updateOption ended");	
		
	}
	
	
	
}
