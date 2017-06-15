package egovframework.ezMobile.ezApprovalG.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezMobile.ezApprovalG.dao.MApprovalGDAO;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MApprovalGService")
public class MApprovalGServiceImpl extends EgovAbstractServiceImpl implements MApprovalGService {
	private static final Logger logger = LoggerFactory.getLogger(MApprovalGServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "MApprovalGDAO")
	private MApprovalGDAO MApprovalGDAO;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Override
	public List<MApprovalGDocInfoVO> getDoApproveList(LoginVO userInfo, String pListType, String pSearchText) throws Exception {
		logger.debug("getDoApproveList started");

		String userIDS = "'" + userInfo.getId() + "'";
		String proxyOption = "";
		
		if (pListType.equals("1")) {
			proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
			if (proxyOption.equals("1")) {
				userIDS = ezApprovalGService.getProxyUser(userInfo.getId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", userIDS);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("searchText", pSearchText);
		
		List<MApprovalGDocInfoVO> approvalGDocInfoVOs = MApprovalGDAO.getDoApproveList(map);

		logger.debug("getDoApproveList ended");
		
		return approvalGDocInfoVOs;
	}

	@Override
	public int getDoApproveListCount(LoginVO userInfo, String pListType, String pSearchText) throws Exception {
		logger.debug("getDoApproveListCount started");

		String userIDS = "'" + userInfo.getId() + "'";
		String proxyOption = "";
		
		if (pListType.equals("1")) {
			proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
			if (proxyOption.equals("1")) {
				userIDS = ezApprovalGService.getProxyUser(userInfo.getId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", userIDS);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		map.put("searchText", pSearchText);

		int listCount = MApprovalGDAO.getDoApproveListCount(map);
		
		logger.debug("getDoApproveListCount ended");
		
		return listCount;
	}

	@Override
	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, String pListType, LoginVO userInfo) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("getAprLineInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("listType", pListType);
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffset()));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		
		List<MApprovalGAprLineInfoVO> approvalGAprLineInfoVOs = MApprovalGDAO.getAprLineInfo(map);

		logger.debug("getAprLineInfo ended");
		
		return approvalGAprLineInfoVOs;
	}

	
}
