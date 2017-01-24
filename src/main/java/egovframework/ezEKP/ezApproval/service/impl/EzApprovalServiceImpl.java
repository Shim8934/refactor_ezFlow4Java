package egovframework.ezEKP.ezApproval.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApproval.dao.EzApprovalDAO;
import egovframework.ezEKP.ezApproval.service.EzApprovalAdminService;
import egovframework.ezEKP.ezApproval.service.EzApprovalService;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocViewVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzApprovalServiceImpl implements EzApprovalService{

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties apprCode;
	
	@Autowired
	private EzApprovalDAO ezApprovalDAO;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzApprovalAdminService ezApprovalAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalServiceImpl.class);
	
	@Override
	public List<ApprContInfoVO> getUseContInfo(ApprContInfoVO apprContInfoVO) throws Exception{
		logger.debug("getUseContInfo started");
		// OwnFlag :  0 -자기 부서의 문서함,  1 -타부서의 문서함,  2 -전부 
		logger.debug("ownFlag = " + apprContInfoVO.getOwnFlag());
		
		List<ApprContInfoVO> apprContInfoVOs = new ArrayList<ApprContInfoVO>();
		
		if (apprContInfoVO.getOwnFlag().equals("1")) {
			apprContInfoVOs = ezApprovalDAO.getUserContInfo(apprContInfoVO); 
		} else {
			apprContInfoVOs = ezApprovalDAO.getUserContInfo1(apprContInfoVO); 
		}
		
		if (apprContInfoVO.getOwnFlag().equals("2")) {
			List<ApprContInfoVO> tempApprContInfoVOs = ezApprovalDAO.getUserContInfo(apprContInfoVO);
			
			for (int k = 0; k < tempApprContInfoVOs.size(); k++) {
				tempApprContInfoVOs.get(k).setContainerTypeName(commonUtil.makeListField(ezOrganService.getPropertyValue(tempApprContInfoVOs.get(k).getContainerOwnDepID(), "displayName" + apprContInfoVO.getLang(), apprContInfoVO.getTenantID())) + "_" + commonUtil.makeListField(tempApprContInfoVOs.get(k).getContainerTypeName()));
				
				apprContInfoVOs.add(tempApprContInfoVOs.get(k));
			}
		}
		
		logger.debug("getUseContInfo ended");
		
		return apprContInfoVOs;
	}

	@Override
	public List<ApprDocInfoVO> getCodeContainer(LoginVO userInfo) throws Exception {
		logger.debug("getCodeContainer started");
		
		List<ApprDocInfoVO> apprDocInfoVOs = ezApprovalDAO.getCodeContainer(userInfo);
		
		for (int k = 0; k < apprDocInfoVOs.size(); k++) {
			apprDocInfoVOs.get(k).setItemName(commonUtil.cleanValue(apprDocInfoVOs.get(k).getItemName()));
		}
		logger.debug("getCodeContainer ended");
		
		return apprDocInfoVOs;
	}

	@Override
	public String getUserContTree(LoginVO userInfo, String parentContID) throws Exception {
		logger.debug("getUserContTree started");
		logger.debug("parentContID :: " + parentContID);
		
		StringBuilder rtnXML = new StringBuilder();
		String strLangDeptDocFolder = ezApprovalAdminService.getCode2Name("L03", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentContID", parentContID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("userID", userInfo.getId());
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalDAO.getUserContTree(map);
		
		if (parentContID.equals("ROOT")) {
			rtnXML.append("<TREEVIEWDATA>");
		} else {
			rtnXML.append("<NODES>");
		}
		
		if (apprContInfoVOs.size() > 0) {
			if (parentContID.equals("ROOT")) {
				rtnXML.append("<NODE>");
				rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprContInfoVOs.get(0).getUserContName()) + "</VALUE>");
				rtnXML.append("<DATA1>" + apprContInfoVOs.get(0).getUserContID() + "</DATA1>");
				rtnXML.append("<DATA2>" + parentContID + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprContInfoVOs.get(0).getDescription()) + "</DATA3>");
				rtnXML.append("<DATA4>" + userInfo.getId() + "</DATA4>");
				rtnXML.append("<ISLEAF>" + getUserContTreeLeaf(apprContInfoVOs.get(0).getUserContID(), userInfo.getTenantId()) + "</ISLEAF>");
				rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
				rtnXML.append(getUserContTree(userInfo, apprContInfoVOs.get(0).getUserContID()));
				rtnXML.append("</NODE>");
			} else {
				for (int k = 0; k < apprContInfoVOs.size(); k++) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprContInfoVOs.get(k).getUserContName()) + "</VALUE>");
					rtnXML.append("<DATA1>" + apprContInfoVOs.get(k).getUserContID() + "</DATA1>");
					rtnXML.append("<DATA2>" + parentContID + "</DATA2>");
					rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprContInfoVOs.get(k).getDescription()) + "</DATA3>");
					rtnXML.append("<DATA4>" + userInfo.getId() + "</DATA4>");
					rtnXML.append("<ISLEAF>" + getUserContTreeLeaf(apprContInfoVOs.get(k).getUserContID(), userInfo.getTenantId()) + "</ISLEAF>");
					rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("</NODE>");
				}
			}
		} else {
			if (parentContID.equals("ROOT")) {
				String newContID = createUserCont(userInfo, parentContID, strLangDeptDocFolder);
				
				if (!newContID.equals("")) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + userInfo.getDisplayName() + "</VALUE>");
					rtnXML.append("<DATA1>" + newContID + "</DATA1>");
					rtnXML.append("<DATA2>" + parentContID+ "</DATA2>");
                    rtnXML.append("<DATA3>" + strLangDeptDocFolder + "</DATA3>");
                    rtnXML.append("<DATA4>" + userInfo.getId() + "</DATA4>");
                    rtnXML.append("<ISLEAF>" + getUserContTreeLeaf(newContID, userInfo.getTenantId()) + "</ISLEAF>");
                    rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("</NODE>");
				}
			}
		}
		
		if (parentContID.equals("ROOT")) {
			rtnXML.append("</TREEVIEWDATA>");
		} else {
			rtnXML.append("</NODE>");
		}
		
		logger.debug("getUserContTree ended");
		
		return rtnXML.toString();
	}
	
	private String createUserCont(LoginVO userInfo, String parentContID, String description) {
		logger.debug("createUserCont started");
		
		String rtnValue = "";
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		
		apprContInfoVO.setUserContName(userInfo.getDisplayName());
		apprContInfoVO.setParentContID(parentContID);
		apprContInfoVO.setDescription(description);
		apprContInfoVO.setUserID(userInfo.getId());
		apprContInfoVO.setTenantID(userInfo.getTenantId());
		
		try {
			String maxContainerID = ezApprovalDAO.createUserCont(apprContInfoVO);
			
			rtnValue = maxContainerID;
		} catch (Exception e) {
			rtnValue = "";
		}
		
		logger.debug("createUserCont ended");
		
		return rtnValue;
	}

	private String getUserContTreeLeaf(String userContID, int tenantID) {
		logger.debug("getUserContTreeLeaf started");
		
		String isLeaf = "FALSE";
		
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		apprContInfoVO.setUserContID(userContID);
		apprContInfoVO.setTenantID(tenantID);
		
		try {
			int leafCount = ezApprovalDAO.getUserContTreeLeaf(apprContInfoVO);
			
			if (leafCount > 0) {
				isLeaf = "FALSE";
			} else {
				isLeaf = "TRUE";
			}
			
		} catch (Exception e) {
			return "FALSE";
		}
		
		logger.debug("getUserContTreeLeaf ended");
		
		return isLeaf;
	}
	
	@Override
	public String getDeptContTree(LoginVO userInfo, String parentContID) throws Exception {
		logger.debug("getDeptContTree started");
		logger.debug("parentContID :: " + parentContID);
		
		StringBuilder rtnXML = new StringBuilder();
		String strLangDeptDocFolder = ezApprovalAdminService.getCode2Name("L03", "002", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentContID", parentContID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("deptID", userInfo.getDeptID());
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalDAO.getDeptContTree(map);
		
		if (parentContID.equals("ROOT")) {
			rtnXML.append("<TREEVIEWDATA>");
		} else {
			rtnXML.append("<NODES>");
		}
		
		if (apprContInfoVOs.size() > 0) {
			if (parentContID.equals("ROOT")) {
				rtnXML.append("<NODE>");
				rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprContInfoVOs.get(0).getDeptContName()) + "</VALUE>");
				rtnXML.append("<DATA1>" + apprContInfoVOs.get(0).getDeptContID() + "</DATA1>");
				rtnXML.append("<DATA2>" + parentContID + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprContInfoVOs.get(0).getDescription()) + "</DATA3>");
				rtnXML.append("<DATA4>" + userInfo.getDeptID() + "</DATA4>");
				rtnXML.append("<DATA5>" + apprContInfoVOs.get(0).getSn() + "</DATA5>");
				rtnXML.append("<DATA6>" + apprContInfoVOs.get(0).getManageUserID() + "</DATA6>");
				rtnXML.append("<ISLEAF>" + getDeptContTreeLeaf(apprContInfoVOs.get(0).getDeptContID(), userInfo.getTenantId()) + "</ISLEAF>");
				rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
				rtnXML.append(getDeptContTree(userInfo, apprContInfoVOs.get(0).getDeptContID()));
				rtnXML.append("</NODE>");
			} else {
				for (int k = 0; k < apprContInfoVOs.size(); k++) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprContInfoVOs.get(k).getDeptContName()) + "</VALUE>");
					rtnXML.append("<DATA1>" + apprContInfoVOs.get(k).getDeptContID() + "</DATA1>");
					rtnXML.append("<DATA2>" + parentContID + "</DATA2>");
					rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprContInfoVOs.get(k).getDescription()) + "</DATA3>");
					rtnXML.append("<DATA4>" + userInfo.getDeptID() + "</DATA4>");
					rtnXML.append("<DATA5>" + apprContInfoVOs.get(k).getSn() + "</DATA5>");
					rtnXML.append("<DATA6>" + apprContInfoVOs.get(k).getManageUserID() + "</DATA6>");
					rtnXML.append("<ISLEAF>" + getUserContTreeLeaf(apprContInfoVOs.get(k).getUserContID(), userInfo.getTenantId()) + "</ISLEAF>");
					rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("</NODE>");
				}
			}
		} else {
			if (parentContID.equals("ROOT")) {
				String newContID = createDeptCont(userInfo, parentContID, "1", strLangDeptDocFolder, "");
				
				if (!newContID.equals("")) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + userInfo.getDisplayName() + "</VALUE>");
					rtnXML.append("<DATA1>" + newContID + "</DATA1>");
					rtnXML.append("<DATA2>" + parentContID+ "</DATA2>");
                    rtnXML.append("<DATA3>" + strLangDeptDocFolder + "</DATA3>");
                    rtnXML.append("<DATA4>" + userInfo.getDeptID() + "</DATA4>");
                    rtnXML.append("<ISLEAF>" + getDeptContTreeLeaf(newContID, userInfo.getTenantId()) + "</ISLEAF>");
                    rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("</NODE>");
				}
			}
		}
		
		if (parentContID.equals("ROOT")) {
			rtnXML.append("</TREEVIEWDATA>");
		} else {
			rtnXML.append("</NODE>");
		}
		
		logger.debug("getDeptContTree ended");
		
		return rtnXML.toString();
	}
	
	private String createDeptCont(LoginVO userInfo, String parentContID, String sn, String description, String manageUserID) {
		logger.debug("createDeptCont started");
		
		String rtnValue = "";
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		
		apprContInfoVO.setDeptContName(userInfo.getDeptName());
		apprContInfoVO.setParentContID(parentContID);
		apprContInfoVO.setSn(sn);
		apprContInfoVO.setDescription(description);
		apprContInfoVO.setDeptID(userInfo.getDeptID());
		apprContInfoVO.setManageUserID(manageUserID);
		apprContInfoVO.setTenantID(userInfo.getTenantId());
		
		try {
			String maxContainerID = ezApprovalDAO.createDeptCont(apprContInfoVO);
			
			rtnValue = maxContainerID;
		} catch (Exception e) {
			rtnValue = "";
		}
		
		logger.debug("createDeptCont ended");
		
		return rtnValue;
	}

	private String getDeptContTreeLeaf(String deptContID, int tenantID) {
		logger.debug("getDeptContTreeLeaf started");
		
		String isLeaf = "FALSE";
		
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		apprContInfoVO.setDeptContID(deptContID);
		apprContInfoVO.setTenantID(tenantID);
		
		try {
			int leafCount = ezApprovalDAO.getDeptContTreeLeaf(apprContInfoVO);
			
			if (leafCount > 0) {
				isLeaf = "FALSE";
			} else {
				isLeaf = "TRUE";
			}
			
		} catch (Exception e) {
			return "FALSE";
		}
		
		logger.debug("getDeptContTreeLeaf ended");
		
		return isLeaf;
	}

	@Override
	public List<ApprContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception {
		logger.debug("getSpecialContTree started");
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalDAO.getSpecialContTree(userInfo);
		
//		for (int k = 0; k < apprContInfoVOs.size(); k++) {
//			apprContInfoVOs.get(k).setContType("SC" + apprContInfoVOs.get(k).getContType());
//		}
		
		logger.debug("getSpecialContTree ended");
		
		return apprContInfoVOs;
	}
	
	@Override
	public String getListContainer(LoginVO userInfo) throws Exception {
		logger.debug("getListContainer started");
		
		String apprCont = "";
		String retCont  = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("staDSPumYui", apprCode.getProperty("appr.staDSPumYui"));
		map.put("staDSBalsin", apprCode.getProperty("appr.staDSBalsin"));
		map.put("deptID", userInfo.getDeptID());
		map.put("tenantID", userInfo.getTenantId());
		
		List<String> containerIDList = ezApprovalDAO.getListContainerCont(map);
		
		for (int k = 0; k < containerIDList.size(); k++) {
			if (k == 0) {
				apprCont += "'" + commonUtil.cleanValue(containerIDList.get(k)) + "'";
			} else {
				apprCont += ",'" + commonUtil.cleanValue(containerIDList.get(k)) + "'";
			}
		}
		
		map.put("staDSBansong", apprCode.getProperty("appr.staDSBansong"));
		
		containerIDList = ezApprovalDAO.getListContainer(map);
		
		for (int k = 0; k < containerIDList.size(); k++) {
			if (k == 0) {
				retCont += "'" + commonUtil.cleanValue(containerIDList.get(k)) + "'";
			} else {
				retCont += ",'" + commonUtil.cleanValue(containerIDList.get(k)) + "'";
			}
		}
		
		logger.debug("getListContainer ended");
		
		return "<CONTAINER><APPRCONT>" + apprCont + "</APPRCONT><RETNCONT>" + retCont + "</RETNCONT></CONTAINER>";
	}

	@Override
	public String getWebPartList(String listType, LoginVO userInfo, String listCount, String mode, String userFlag, String subQuery) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("getWebPartList started");

		String strMultiData = commonUtil.getMultiData(userInfo.getLang());
		String userIDs = "'" + userInfo.getId() + "'";
		String proxyOption = "";
		String resultXML = "";
		
		if (listType.equals("1")) {
			proxyOption = getIsUse("A23", "001", userInfo.getCompanyID(), userInfo.getTenantId());
			
			if (proxyOption.equals("1")) {
				userIDs = getProxyUser(userInfo.getId(), userInfo.getLang(), userInfo.getOffset(), userInfo.getTenantId());
			}
		}
		
		if (mode.equals("COUNT")) {
			int totalCount = getAprDocCount(listType, userInfo, userIDs, userFlag, subQuery, null);
			
			resultXML = "<RESULT>" + totalCount + "</RESULT>";
		} else if (mode.equals("LEFT")) {
			resultXML = getAprLeftCount(listType, userInfo, userIDs, userFlag, subQuery);
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("listType", listType);
			map.put("strLang", strMultiData);
			map.put("listCount", listCount);
			map.put("userDeptID", userInfo.getDeptID());
			map.put("userID", userInfo.getId());
			map.put("userIDs", userIDs);
			map.put("userFlag", userFlag);
			map.put("companyID", userInfo.getCompanyID());
			map.put("tenantID", userInfo.getTenantId());
			map.put("staASBangSong", apprCode.getProperty("appr.staASBanSong"));
			map.put("staASJinHang", apprCode.getProperty("appr.staASJinHang"));
			map.put("staASJiJung", apprCode.getProperty("appr.staASJiJung"));
			map.put("staASWheSong", apprCode.getProperty("appr.staASWheSong"));
			map.put("staASDoJak", apprCode.getProperty("appr.staASDoJak"));
			map.put("staASBaeBu", apprCode.getProperty("appr.staASBaeBu"));
			map.put("subQuery", subQuery);
			
			List<ApprDocViewVO> apprDocViewVOs = ezApprovalDAO.getWebPartList(map);
			
			StringBuffer sb = new StringBuffer();
	        sb.append("<DATA>");
	        
	        for (int i = 0; i < apprDocViewVOs.size(); i++) {
				sb.append(commonUtil.getQueryResult(apprDocViewVOs.get(i)));
			}
			sb.append("</DATA>");
			
			resultXML = sb.toString();
		}
		
		logger.debug("getWebPartList ended");
		
		return resultXML;
	}

	private String getAprLeftCount(String listType, LoginVO userInfo, String userIDs, String userFlag, String subQuery) throws Exception {
		logger.debug("getAprLeftCount started");
		
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), userInfo.getOffset(), false);
		String lastDate = nowDate.substring(0, 10) + " 00:00:01";
		nowDate = nowDate.substring(0, 10) + " 23:59:59";

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listType", listType);
		map.put("userDeptID", userInfo.getDeptID());
		map.put("userID", userInfo.getId());
		map.put("userIDs", userIDs);
		map.put("userFlag", userFlag);
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());
		map.put("staASBangSong", apprCode.getProperty("appr.staASBanSong"));
		map.put("staASJinHang", apprCode.getProperty("appr.staASJinHang"));
		map.put("staASJiJung", apprCode.getProperty("appr.staASJiJung"));
		map.put("staASWheSong", apprCode.getProperty("appr.staASWheSong"));
		map.put("staASDoJak", apprCode.getProperty("appr.staASDoJak"));
		map.put("staASBaeBu", apprCode.getProperty("appr.staASBaeBu"));
		map.put("subQuery", subQuery);
		map.put("lastDate", commonUtil.getDateStringInUTC(lastDate, userInfo.getOffset(), true));
		map.put("nowDate", commonUtil.getDateStringInUTC(nowDate, userInfo.getOffset(), true));
		
		List<String> leftCounts = ezApprovalDAO.getLeftDocCount(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < leftCounts.size(); i++) {
			sb.append(commonUtil.getQueryResult(leftCounts.get(i)));
		}
		sb.append("</DATA>");

		logger.debug("getAprLeftCount ended");
		
		return sb.toString();
	}

	private int getAprDocCount(String listType, LoginVO userInfo, String userIDs, String userFlag, String subQuery, Document queryData) throws Exception {
		logger.debug("getAprDocCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("listType", listType);
		map.put("userDeptID", userInfo.getDeptID());
		map.put("userID", userInfo.getId());
		map.put("userIDs", userIDs);
		map.put("userFlag", userFlag);
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());
		map.put("staASBangSong", apprCode.getProperty("appr.staASBanSong"));
		map.put("staASJinHang", apprCode.getProperty("appr.staASJinHang"));
		map.put("staASJiJung", apprCode.getProperty("appr.staASJiJung"));
		map.put("staASWheSong", apprCode.getProperty("appr.staASWheSong"));
		map.put("staASDoJak", apprCode.getProperty("appr.staASDoJak"));
		map.put("staASBaeBu", apprCode.getProperty("appr.staASBaeBu"));
		map.put("subQuery", subQuery);
		
		if (queryData != null) {
			if (queryData.getElementsByTagName("DOCNO").item(0) != null) {
				map.put("docNO", queryData.getElementsByTagName("DOCNO").item(0).getTextContent());
			} else {
				map.put("docNO", "");
			}
			if (queryData.getElementsByTagName("DOCTITLE").item(0) != null) {
				map.put("docTitle", queryData.getElementsByTagName("DOCTITLE").item(0).getTextContent());
			} else {
				map.put("docTitle", "");
			}
			if (queryData.getElementsByTagName("WRITERNAME").item(0) != null) {
				map.put("writerName", queryData.getElementsByTagName("WRITERNAME").item(0).getTextContent());
			} else {
				map.put("writerName", "");
			}
			if (queryData.getElementsByTagName("WRITERDEPTNAME").item(0) != null) {
				map.put("writerDeptName", queryData.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
			} else {
				map.put("writerDeptName", "");
			}
			if (queryData.getElementsByTagName("KEYWORD").item(0) != null) {
				map.put("keyWord", queryData.getElementsByTagName("KEYWORD").item(0).getTextContent());
			} else {
				map.put("keyWord", "");
			}
		}
		
		int rtnValue = ezApprovalDAO.getAprDocCount(map);

		logger.debug("getAprDocCount ended");
		
		return rtnValue;
	}

	private String getProxyUser(String userID, String lang, String offset, int tenantID) throws Exception {
		logger.debug("getProxyUser started");

		String rtnXML = ezOrganService.getSearchList("LEFT_extensionAttribute5::" + userID + ":", "displayName", "displayName;extensionAttribute5", "user", 5, commonUtil.getPrimaryData(lang), tenantID);
		Document xmlDom = commonUtil.convertStringToDocument(rtnXML);
		
		int nodeLength = xmlDom.getElementsByTagName("DATA2").getLength();
		boolean chkFirst = false;
		String rtnVal = "";
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm"), offset, false);
		
		if (nodeLength > 0) {
			for (int k = 0; k < nodeLength; k++) {
				String bujaeInfo = xmlDom.getElementsByTagName("DATA4").item(k).getTextContent();
				String[] bujae = bujaeInfo.split(":");
				
				if (bujae.length >= 5) {
					//TODO: 눈으로 확인바람
					if (bujae[3].replace("/", ":").substring(0, 16).compareTo(nowDate) <= 0 && bujae[4].replace("/", ":").substring(0, 16).compareTo(nowDate) >= 0 ) {
						if (!chkFirst) {
							rtnVal = "'" + xmlDom.getElementsByTagName("DATA2").item(k).getTextContent() + "'";
							chkFirst = true;
						} else {
							rtnVal += ",'" + xmlDom.getElementsByTagName("DATA2").item(k).getTextContent() + "'";
						}
					}
				}
			}
			
			if (!chkFirst) {
				rtnVal = "'" + userID + "'";
			} else {
				rtnVal += ",'" + userID + "'";
			}
		} else {
			rtnVal = "'" + userID + "'";
		}

		logger.debug("getProxyUser ended");
		
		return rtnVal;
	}

	private String getIsUse(String code1, String code2, String companyID, int tenantID) throws Exception {
		logger.debug("getIsUse started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("code1", code1);
		map.put("code2", code2);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		String rtnValue = ezApprovalDAO.getIsUse(map);

		logger.debug("getIsUse ended");
		
		return rtnValue;
	}
	
}
