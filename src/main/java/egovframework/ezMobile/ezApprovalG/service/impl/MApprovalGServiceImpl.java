package egovframework.ezMobile.ezApprovalG.service.impl;

import java.util.List;
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
	public List<MApprovalGDocInfoVO> getDoApproveList(LoginVO userInfo, String listType) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("getDoApproveList started");

		String userIDS = "'" + userInfo.getId() + "'";
		String proxyOption = "";
		
		if (listType.equals("1")) {
			proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
			if (proxyOption.equals("1")) {
				userIDS = ezApprovalGService.getProxyUser(userInfo.getId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset());
			}
		}
		
		userInfo.setId(userIDS);
		
		List<MApprovalGDocInfoVO> approvalGDocInfoVOs = MApprovalGDAO.getDoApproveList(userInfo);

		logger.debug("getDoApproveList ended");
		
		return approvalGDocInfoVOs;
	}

}
