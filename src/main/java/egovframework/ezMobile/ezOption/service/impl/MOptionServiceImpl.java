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
		
		info.setUserId(userId);
		
		LOGGER.debug("commonInfo ended");
		
		return info;
	}	
	
}
