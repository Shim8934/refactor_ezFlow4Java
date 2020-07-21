package egovframework.ezMobile.ezApprovalG.service.impl;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

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
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGLeftVO;
import egovframework.ezMobile.ezApprovalG.vo.MApprovalGOpinionInfoVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

import org.jsoup.Jsoup;
import org.jsoup.select.Elements;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;

@Service("MApprovalGService")
public class MApprovalGServiceImpl extends EgovAbstractServiceImpl implements MApprovalGService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MApprovalGServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;

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
		//2018-11-01 배현상, mobile 공유결재기능 추가
		String shareApprovalFlag = ezCommonService.getTenantConfig("useShareApproval", userInfo.getTenantId());
				
		if (proxyOption.equals("1")) {
			userIDS = ezApprovalGService.getProxyUser(userInfo.getUserId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet());
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", userIDS);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffSet()));
		map.put("searchText", searchText);
		map.put("listSize", Integer.parseInt(listSize));
		map.put("lastDate", lastDate);
		map.put("type", type);
		map.put("approvalFlag", approvalFlag);
		map.put("userId", userInfo.getUserId());
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("mainViewYN", mainViewYN);
		map.put("shareApprovalFlag", shareApprovalFlag);
		
		List<MApprovalGDocInfoVO> approvalGDocInfoVOs = mApprovalGDAO.getDoApproveList(map);

		LOGGER.debug("getDoApproveList ended");
		
		return approvalGDocInfoVOs;
	}

	@Override
	public int getDoApproveListCount(MCommonVO userInfo, String type, String searchText) throws Exception {
		LOGGER.debug("getDoApproveListCount started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String mainViewYN = ezCommonService.getTenantConfig("MineViewYN", userInfo.getTenantId());
		String userIDS = "'" + userInfo.getUserId() + "'";
		String proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
		//2018-11-01 배현상, mobile 공유결재기능 추가
		String shareApprovalFlag = ezCommonService.getTenantConfig("useShareApproval", userInfo.getTenantId());
		
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
		map.put("mainViewYN", mainViewYN);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("shareApprovalFlag", shareApprovalFlag);

		int listCount = mApprovalGDAO.getDoApproveListCount(map);
		
		LOGGER.debug("getDoApproveListCount ended");
		
		return listCount;
	}

	@Override
	public List<MApprovalGAprLineInfoVO> getAprLineInfo(String pDocID, String type, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAprLineInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		map.put("offset", commonUtil.getMinuteUTC(userInfo.getOffSet()));
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		List<MApprovalGAprLineInfoVO> approvalGAprLineInfoVOs = mApprovalGDAO.getAprLineInfo(map);

		LOGGER.debug("getAprLineInfo ended");
		
		return approvalGAprLineInfoVOs;
	}

	@Override
	public String getMHTBody(String pDocID, String realPath, String domain, MCommonVO userInfo, Locale locale, String type, String scheme, String mode) throws Exception {
		LOGGER.debug("getMHTBody started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("mode", mode);
		map.put("approvalFlag", approvalFlag);
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
        
        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain, scheme);
        LOGGER.debug("strHTML : " + strHTML);

		LOGGER.debug("getMHTBody ended");
		
		return strHTML;
	}

	@Override
	public String getOpinionCount(String pDocID, String type, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getAprCommentCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		
		String commentCount = mApprovalGDAO.getAprCommentCount(map);

		LOGGER.debug("getAprCommentCount ended");
		
		return commentCount;
	}

	@Override
	public List<MApprovalGOpinionInfoVO> getOpinionInfo(String pDocID, String type, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getOpinionInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", pDocID);
		map.put("type", type);
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
				if (pContent != null && !pContent.equals("")) {
					map.put("hasOpinionYN", "Y");
					
					mApprovalGDAO.insertOpinionInfo(map);
					
					result = mApprovalGDAO.updateDocOpinionInfo(map);
				} else {
					map.put("hasOpinionYN", "N");
					
					result = mApprovalGDAO.updateDocOpinionInfo(map);
				}
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
	public MApprovalGDocInfoVO getAprDocInfo(String docId, String type, String lang, String companyId, int tenantId, String aprMemberSN, String mode) throws Exception {
		LOGGER.debug("getAprDocInfo started");

		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("type", type);
		map.put("mode", mode);
		map.put("aprMemberSN", aprMemberSN);
		map.put("approvalFlag", approvalFlag);
		map.put("lang", commonUtil.getMultiData(lang, tenantId));
		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		
		MApprovalGDocInfoVO approvalGDocInfoVO = new MApprovalGDocInfoVO();
		
		approvalGDocInfoVO = mApprovalGDAO.getAprDocInfo(map);

		LOGGER.debug("getAprDocInfo ended");
		
		return approvalGDocInfoVO;
	}
	
	@Override
	public MApprovalGDocInfoVO getAprMemberSn(String docId, String type, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getAprDocInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docID", docId);
		map.put("type", type);
		map.put("tenantID", tenantId);
		map.put("companyID", companyId);
		
		MApprovalGDocInfoVO approvalGDocInfoVO = new MApprovalGDocInfoVO();
		
		approvalGDocInfoVO = mApprovalGDAO.getAprMemberSn(map);

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

	@Override
	public MApprovalGLeftVO getLeftCount(String userId, MCommonVO userInfo) throws Exception {
		LOGGER.debug("getLeftCount started");
		
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", userInfo.getTenantId());
		String mainViewYN = ezCommonService.getTenantConfig("MineViewYN", userInfo.getTenantId());
		String userIDS = "'" + userInfo.getUserId() + "'";
		String proxyOption = ezApprovalGService.getIsUse("A23", "001", userInfo.getCompanyId(), userInfo.getLang(), userInfo.getTenantId());
		//2018-11-01 배현상, mobile 공유결재기능 추가
		String useShareApproval = ezCommonService.getTenantConfig("useShareApproval", userInfo.getTenantId());
		
		if (proxyOption.equals("1")) {
			userIDS = ezApprovalGService.getProxyUser(userInfo.getUserId(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffSet());
		}

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("id", userIDS);
		map.put("userId", userId);
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyId());
		map.put("approvalFlag", approvalFlag);
		map.put("mainViewYN", mainViewYN);
		map.put("nowDate", commonUtil.getTodayUTCTime(""));
		map.put("useShareApproval", useShareApproval);
		
		MApprovalGLeftVO approvalGLeftVO = mApprovalGDAO.getLeftCount(map);

		LOGGER.debug("getLeftCount ended");
		
		return approvalGLeftVO;
	}

	@Override
	public int delAbsenteeInfo(String userId, int tenantId) throws Exception {
		LOGGER.debug("delAbsenteeInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantID", tenantId);
		
		int result = mApprovalGDAO.delAbsenteeInfo(map);

		LOGGER.debug("delAbsenteeInfo ended");
		
		return result;
	}

	@Override
	public int getCheckAprState(String docId, String userId,
			String aprMemberSN, String mode, String companyId, int tenantId)
			throws Exception {
		LOGGER.debug("getCheckAprState started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("docId", docId);
		map.put("userId", userId);
		map.put("aprMemberSN", aprMemberSN);
		map.put("mode", mode);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		int result = mApprovalGDAO.getCheckAprState(map);
		
		LOGGER.debug("getCheckAprState ended.");
		
		return result;
	}
	
	/* 2020-07-02 홍승비 - 모바일에서 최종결재 완료 시 서명에 결재날짜 삽입 동작 추가(결재날짜 필드가 없는 경우에만, 웹과 동일하게) */
	public String insertSeumyungdateMobile(String docId, String realPath, String offset, Locale locale, String domain, String scheme, String companyId, int tenantId) throws Exception {
		LOGGER.debug("insertSeumyungdateMobile started");

		String result = "SUCCESS";
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", docId);
			map.put("v_COMPANYID", companyId);
			map.put("v_TENANTID", tenantId);
			
			MApprovalGDocInfoVO endDocInfo = mApprovalGDAO.getEndAprDocInfo(map);
			
			// 최종결재가 완료된 경우, 완료문서의 경로를 찾아서 서명을 업데이트한다.
			if (endDocInfo != null && endDocInfo.getHref() != null) {
				String docHref = endDocInfo.getHref();
				LOGGER.debug("docHref in insertSeumyungdateMobile : " + docHref);
				
				String uploadModule = commonUtil.getUploadPath("upload_common.MHTIMAGE", tenantId) + commonUtil.separator;
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
		        
		        String strHTML = ezCommonService.startMHT2HTML(filePath, m_strMHT, filePath, realPath, locale, domain, scheme);
		        org.jsoup.nodes.Document doc = Jsoup.parse(strHTML); // 셀렉터를 사용하기 위한 파싱
				
		        /* 2020-07-21 홍승비 - 내부결재, 수신결재 분기 추가 */
		        Elements signField = new Elements();
				Elements seumyungDateField = new Elements();
				
				LOGGER.debug("endDocInfo.getDocState() in insertSeumyungdateMobile   ::   " + endDocInfo.getDocState());
		        if (endDocInfo.getDocState().equals("011")) { // 수신결재
		        	signField = doc.select("[id^='1sign']");
					seumyungDateField = doc.select("[id^='1seumyungdate" + signField.size() + "']"); // (수신)최종결재자의 결재날짜
		        } else { // 내부결재
		        	signField = doc.select("[id^='sign']");
					seumyungDateField = doc.select("[id^='seumyungdate" + signField.size() + "']"); // (내부)최종결재자의 결재날짜
		        }
		        
				// 모바일 결재 시 디폴트가 문자서명이므로, 이미지 서명 분기는 생략
				if (signField.size() > 0 && seumyungDateField.size() == 0) { // 서명 필드가 존재하며, 결재날짜 필드가 없는 경우
					String orgSignHtml = signField.get(signField.size() - 1).html();
					String newSignHtml = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy/MM/dd"), offset, false).substring(5,10) + "<br>" + orgSignHtml;
					LOGGER.debug("newSignHtml   ::   " + newSignHtml);
					
					signField.get(signField.size() - 1).html(newSignHtml);
					
					// 수정한 결재문서 html을 다시 mht로 저장한다.
					OutputStream outputStream = null;
	        		OutputStreamWriter output = null;
					String tempHtml = doc.outerHtml();
	        		String convertedMHT = ezCommonService.startHtml2Mht(tempHtml, realPath, locale);
	        		
	        		try {
	        			outputStream = new FileOutputStream(new File(commonUtil.detectPathTraversal(realPath + docHref)));
	        			output = new OutputStreamWriter(outputStream);
	        			output.write(convertedMHT);
	        		} catch (Exception e) {
	        			e.printStackTrace();
	        		} finally {
	        			output.close();
	        			outputStream.close();
	        		}
				}
			} else { // 아직 결재 진행중인 경우, 바로 리턴시킨다. 에러는 아니다.
				LOGGER.debug("insertSeumyungdateMobile ended(Not End Apr)");
				return result;
			}
		} catch (Exception e) {
			e.printStackTrace();
			result = "ERROR";
			
			LOGGER.debug("insertSeumyungdateMobile ended(ERROR)");
			return result;
		}
		
		LOGGER.debug("insertSeumyungdateMobile ended");
		return result;
	}
}
