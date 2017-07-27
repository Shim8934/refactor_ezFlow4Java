package egovframework.ezMobile.ezApprovalG.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezMobile.ezApprovalG.dao.MApprovalGDAO;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGTLVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
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
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Override
	public List<MApprovalGDocInfoVO> getDoApproveList(MCommonVO userInfo, String type, String searchText, String listSize, String lastDate) throws Exception {
		logger.debug("getDoApproveList started");

		String userIDS = "'" + userInfo.getUserId() + "'";
		String proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
		
		if (proxyOption.equals("1")) {
			userIDS = ezApprovalGService.getProxyUser(userInfo.getUserId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", userIDS);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffSet()));
		map.put("searchText", searchText);
		map.put("listSize", listSize);
		map.put("lastDate", lastDate);
		map.put("type", type);
		map.put("userId", userInfo.getUserId());
		
		List<MApprovalGDocInfoVO> approvalGDocInfoVOs = MApprovalGDAO.getDoApproveList(map);

		logger.debug("getDoApproveList ended");
		
		return approvalGDocInfoVOs;
	}

	@Override
	public int getDoApproveListCount(MCommonVO userInfo, String pListType, String pSearchText) throws Exception {
		logger.debug("getDoApproveListCount started");

		String userIDS = "'" + userInfo.getUserId() + "'";
		String proxyOption = "";
		
		if (pListType.equals("DO")) {
			proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
			if (proxyOption.equals("1")) {
				userIDS = ezApprovalGService.getProxyUser(userInfo.getUserId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet());
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", userIDS);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("searchText", pSearchText);

		int listCount = MApprovalGDAO.getDoApproveListCount(map);
		
		logger.debug("getDoApproveListCount ended");
		
		return listCount;
	}

	@Override
	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, String pListType, LoginVO userInfo) throws Exception {
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

	@Override
	public String getMHTBody(String pDocID, String pListType, String realPath, String domain, LoginVO userInfo) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("getMHTBody started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("listType", pListType);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		
		String docHref = MApprovalGDAO.getAprDocHref(map);
		logger.debug("docHref : " + docHref);
		String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", userInfo.getTenantId()) + commonUtil.separator;
		String filePath = realPath + uploadModule;
        
        File file = new File(filePath);
        if (!file.exists()) {
        	file.mkdirs();
        }
        
        String m_strMHT = "";
        
        try {
        	m_strMHT = ezCommonService.loadMHTFile(realPath + docHref);
		} catch (Exception e) {
			e.printStackTrace();
			m_strMHT= "";
		}
        
        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, userInfo.getLocale(), domain);
        logger.debug("strHTML : " + strHTML);
        
        Document doc = Jsoup.parse(strHTML);
        
        String bodyHTML = doc.getElementById("body").html();

		logger.debug("getMHTBody ended");
		
		return bodyHTML;
	}

	@Override
	public String getAprCommentCount(String pDocID, String pListType, LoginVO userInfo) throws Exception {
		logger.debug("getAprCommentCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("listType", pListType);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		
		String commentCount = MApprovalGDAO.getAprCommentCount(map);

		logger.debug("getAprCommentCount ended");
		
		return commentCount;
	}

	@Override
	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, String pListType, LoginVO userInfo) throws Exception {
		logger.debug("getOpinionInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("listType", pListType);
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		
		List<MApprovalGOpinionInfoVO> approvalGOpinionInfoVOs = MApprovalGDAO.getOpinionInfo(map);

		logger.debug("getOpinionInfo ended");
		
		return approvalGOpinionInfoVOs;
	}

	@Override
	public void saveOpinionInfo(String pDocID, String pContent, String pOpinionGB, LoginVO userInfo) throws Exception {
		logger.debug("saveOpinionInfo started");

		String rtnVal = ezApprovalGService.deleteOpinionInfo(pDocID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		if (rtnVal.equals("TRUE")) {
			if (pContent != null && !pContent.equals("")) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("docID", pDocID);
				map.put("content", pContent);
				map.put("opinionGB", pOpinionGB);
				map.put("userID", userInfo.getId());
				map.put("tenantID", userInfo.getTenantId());
				map.put("companyID", userInfo.getCompanyID());
				
				MApprovalGDAO.insertOpinionInfo(map);
				MApprovalGDAO.updateDocOpinionInfo(map);
			}
		}

		logger.debug("saveOpinionInfo ended");
	}

	@Override
	public List<MApprovalGTLVO> getTimeLineList(LoginVO userInfo, String sessionDate) throws Exception {
		logger.debug("getTimeLineList started");

		if (sessionDate == null || sessionDate.equals("")) {
			sessionDate = commonUtil.getTodayUTCTime("");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sessionDate", sessionDate);
		map.put("userID", userInfo.getId());
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		
		List<MApprovalGTLVO> approvalGTLVOs = MApprovalGDAO.getTimeLineList(map);

		logger.debug("getTimeLineList ended");
		
		return approvalGTLVOs;
	}
	
}
