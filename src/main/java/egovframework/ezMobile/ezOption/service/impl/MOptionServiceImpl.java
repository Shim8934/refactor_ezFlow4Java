package egovframework.ezMobile.ezOption.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezMobile.ezOption.dao.MOptionDAO;
import egovframework.ezMobile.ezOption.service.MOptionService;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.ezMobile.ezOption.vo.MOptionVO;
import egovframework.ezMobile.ezPortal.vo.MPortalTimeLineVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MOptionService")
public class MOptionServiceImpl extends EgovAbstractServiceImpl implements MOptionService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MOptionServiceImpl.class);

	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "MOptionDAO")
	private MOptionDAO mOptionDAO;	
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;

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
	public void insertOption(String uid, String timeZone, String lang, String mainType, String listCnt, String useSecurity, int tenantId) throws Exception {
		LOGGER.debug("insertOption started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", uid);
		map.put("timeZone", timeZone);
		map.put("lang", lang);
		map.put("mainType", mainType);
		map.put("listCnt", listCnt);		
		map.put("useSecurity", useSecurity);
		map.put("tenantId", tenantId);			
		
		mOptionDAO.insertOption(map);
				
		LOGGER.debug("insertOption ended");				
	}

	@Override
	public void updateOption(String userId, String timeZone, String lang, String mainType, String listCnt, String useSecurity, int tenantId) throws Exception {
		LOGGER.debug("updateOption started");	
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("timeZone", timeZone);
		map.put("lang", lang);
		map.put("mainType", mainType);
		map.put("listCnt", listCnt);		
		map.put("useSecurity", useSecurity);
		map.put("tenantId", tenantId);
		
		mOptionDAO.updateOption(map);
		
		LOGGER.debug("updateOption ended");	
	}

	@Override
	public List<MPortalTimeLineVO> getTimeLineList(MCommonVO info, String sessionDate, String listCnt) throws Exception {
		LOGGER.debug("getTimeLineList started");
		
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
		map.put("userIDS", userIDS);
		map.put("tenantID", info.getTenantId());
		map.put("companyID", info.getCompanyId());
		map.put("primary", info.getPrimary());		
		
		List<MPortalTimeLineVO> mPortalTimeLineVOs = mOptionDAO.getTimeLineList(map);

		LOGGER.debug("getTimeLineList ended");
		
		return mPortalTimeLineVOs;
	}
}
