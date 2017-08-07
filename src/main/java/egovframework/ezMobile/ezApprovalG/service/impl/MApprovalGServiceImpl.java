package egovframework.ezMobile.ezApprovalG.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezApprovalG.dao.MApprovalGDAO;
import egovframework.ezMobile.ezApprovalG.service.MApprovalGService;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAbsenteeInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAprLineInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGAttachInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGDocInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGTLVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("MApprovalGService")
public class MApprovalGServiceImpl extends EgovAbstractServiceImpl implements MApprovalGService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MApprovalGServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name = "MApprovalGDAO")
	private MApprovalGDAO mApprovalGDAO;
	
	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Override
	public List<MApprovalGDocInfoVO> getDoApproveList(MCommonVO userInfo, String type, String searchText, String listSize, String lastDate) throws Exception {
		LOGGER.debug("getDoApproveList started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String mainViewYN = ezCommonService.getTenantConfig("MineViewYN", userInfo.getTenantId());
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
		map.put("approvalFlag", approvalFlag);
		map.put("userId", userInfo.getUserId());
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("mainViewYN", mainViewYN);
		
		List<MApprovalGDocInfoVO> approvalGDocInfoVOs = mApprovalGDAO.getDoApproveList(map);

		LOGGER.debug("getDoApproveList ended");
		
		return approvalGDocInfoVOs;
	}

	@Override
	public int getDoApproveListCount(MCommonVO userInfo, String type, String searchText) throws Exception {
		LOGGER.debug("getDoApproveListCount started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String userIDS = "'" + userInfo.getUserId() + "'";
		String proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
		
		if (proxyOption.equals("1")) {
			userIDS = ezApprovalGService.getProxyUser(userInfo.getUserId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", userIDS);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("searchText", searchText);
		map.put("userId", userInfo.getUserId());
		map.put("type", type);
		map.put("approvalFlag", approvalFlag);

		int listCount = mApprovalGDAO.getDoApproveListCount(map);
		
		LOGGER.debug("getDoApproveListCount ended");
		
		return listCount;
	}

	@Override
	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAprLineInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffSet()));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGAprLineInfoVO> approvalGAprLineInfoVOs = mApprovalGDAO.getAprLineInfo(map);

		LOGGER.debug("getAprLineInfo ended");
		
		return approvalGAprLineInfoVOs;
	}

	@Override
	public String getMHTBody(String pDocID, String realPath, String domain, MCommonVO userInfo, Locale locale) throws Exception {
		LOGGER.debug("getMHTBody started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		String docHref = mApprovalGDAO.getAprDocHref(map);
		LOGGER.debug("docHref : " + docHref);
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
        
        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain);
        LOGGER.debug("strHTML : " + strHTML);
        
        Document doc = Jsoup.parse(strHTML);
        
        String bodyHTML = doc.getElementById("body").html();

		LOGGER.debug("getMHTBody ended");
		
		return bodyHTML;
	}

	@Override
	public String getOpinionCount(String pDocID, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAprCommentCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		String commentCount = mApprovalGDAO.getAprCommentCount(map);

		LOGGER.debug("getAprCommentCount ended");
		
		return commentCount;
	}

	@Override
	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getOpinionInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGOpinionInfoVO> approvalGOpinionInfoVOs = mApprovalGDAO.getOpinionInfo(map);

		LOGGER.debug("getOpinionInfo ended");
		
		return approvalGOpinionInfoVOs;
	}

	@Override
	public int mSetOpinionInfo(String pDocID, String pContent, String pOpinionGB, MCommonVO userInfo, String pType) throws Exception {
		LOGGER.debug("saveOpinionInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("content", pContent);
		map.put("opinionGB", pOpinionGB);
		map.put("userID", userInfo.getUserId());
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		int result = 0;
		int resultRow = mApprovalGDAO.deleteOpinionInfo(map);
		
		if (pType.equals("INSERT")) {
			if (pContent != null && !pContent.equals("")) {
				map.put("hasOpinionYN", "Y");
				
				mApprovalGDAO.insertOpinionInfo(map);
				
				result = mApprovalGDAO.updateDocOpinionInfo(map);
			} else {
				map.put("hasOpinionYN", "N");
				
				result = mApprovalGDAO.updateDocOpinionInfo(map);
			}
		} else if (pType.equals("UPDATE")) {
			if (resultRow > 0) {
				mApprovalGDAO.insertOpinionInfo(map);
			}
		} else if (pType.equals("DELETE")) {
			if (resultRow > 0) {
				map.put("hasOpinionYN", "N");
				
				result = mApprovalGDAO.updateDocOpinionInfo(map);
			}
		}

		LOGGER.debug("saveOpinionInfo ended");
		
		return result;
	}

	@Override
	public List<MApprovalGAttachInfoVO> getAttachList(String docId, String type, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAttachList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("type", type);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGAttachInfoVO> approvalGAttachInfoVOs = mApprovalGDAO.getAttachList(map);

		LOGGER.debug("getAttachList ended");
		
		return approvalGAttachInfoVOs;
	}
	
	@Override
	public MApprovalGAbsenteeInfoVO getAbsenteeInfo(MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAbsenteeInfo started");

		String absenteeInfo = mApprovalGDAO.getAbsenteeInfo(userInfo);
		
		MApprovalGAbsenteeInfoVO absenteeInfoVO = new MApprovalGAbsenteeInfoVO();
		
		if (absenteeInfo != null && !absenteeInfo.equals("")) {
			String[] absenteeInfoArry = absenteeInfo.split(":");
			
			absenteeInfoVO.setAbsenteeId(absenteeInfoArry[0]);
			absenteeInfoVO.setAbsenteeName(absenteeInfoArry[1]);
			absenteeInfoVO.setAbsenteeDeptId(absenteeInfoArry[2]);
			absenteeInfoVO.setStartDate(absenteeInfoArry[3] + ":" + absenteeInfoArry[4]);
			absenteeInfoVO.setEndDate(absenteeInfoArry[5] + ":" + absenteeInfoArry[6]);
		}

		LOGGER.debug("getAbsenteeInfo ended");
		
		return absenteeInfoVO;
	}

	@Override
	public int setAbsenteeInfo(MApprovalGAbsenteeInfoVO absenteeInfoVO) throws Exception {
		LOGGER.debug("setAbsenteeInfo started");

		int result = mApprovalGDAO.setAbsenteeInfo(absenteeInfoVO);

		LOGGER.debug("setAbsenteeInfo ended");
		
		return result;
	}

	@Override
	public int checkPass(MCommonVO userInfo, String shaEncPassword) throws Exception {
		LOGGER.debug("checkPass started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("password", shaEncPassword);
		map.put("userID", userInfo.getUserId());
		map.put("tenantID", userInfo.getTenantId());
		
		int resultCode = mApprovalGDAO.checkPass(map);

		LOGGER.debug("checkPass ended");
		
		return resultCode;
	}

	@Override
	public List<MApprovalGTLVO> getTimeLineList(LoginVO userInfo, String sessionDate) throws Exception {
		LOGGER.debug("getTimeLineList started");

		if (sessionDate == null || sessionDate.equals("")) {
			sessionDate = commonUtil.getTodayUTCTime("");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("sessionDate", sessionDate);
		map.put("userID", userInfo.getId());
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		
		List<MApprovalGTLVO> approvalGTLVOs = mApprovalGDAO.getTimeLineList(map);

		LOGGER.debug("getTimeLineList ended");
		
		return approvalGTLVOs;
	}

	@Override
	public MApprovalGDocInfoVO getAprDocInfo(String docId, String type, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getAprDocInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		
		MApprovalGDocInfoVO approvalGDocInfoVO = new MApprovalGDocInfoVO();
		
		if (type.equals("APR") || type.equals("BAN") || type.equals("CHECK")) {
			approvalGDocInfoVO = mApprovalGDAO.getAprDocInfo(map);
		}

		LOGGER.debug("getAprDocInfo ended");
		
		return approvalGDocInfoVO;
	}

	@Override
	public String getDocState(String docId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getDocState started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		
		String docState = mApprovalGDAO.getDocState(map);

		LOGGER.debug("getDocState ended");
		
		return docState;
	}
	
}
