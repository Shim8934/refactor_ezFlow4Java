package egovframework.ezMobile.ezOption.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.ezMobile.ezOption.dao.MOptionDAO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezPortal.web.MPortalController;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MOptionService")
public class MOptionServiceImpl extends EgovAbstractServiceImpl implements MOptionService {

	private static final Logger logger = LoggerFactory.getLogger(MPortalController.class);

	@Resource(name = "MOptionDAO")
	private MOptionDAO mOptionDAO;
	
	@Override
	public String saveOption(String id, String langFlag, String dpBoardCnt, String resourceChk, String resourceYN, int tenantId) throws Exception {
		logger.debug("saveOption started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		MOptionDAO.insertOption(map);
		logger.debug("saveOption ended");
		return null;
	}
}
