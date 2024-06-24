package egovframework.ezEKP.ezResource.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezResource.dao.EzResourceAdminDAO;
import egovframework.ezEKP.ezResource.service.EzResourceAdminService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSubClsListVO;
import egovframework.ezEKP.ezResource.vo.ResScheduleRepetitionVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzResourceAdminService")
public class EzResourceAdminServiceImpl extends EgovAbstractServiceImpl implements EzResourceAdminService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzResourceAdminServiceImpl.class);
	
	@Resource(name="EzResourceAdminDAO")
	private EzResourceAdminDAO ezResourceAdminDAO;
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<ResGetSubClsListVO> getSubClsList(String parentID, String companyID, String userID, String deptPath, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_UserID", userID);
		map.put("v_P_DeptPath", deptPath);
		map.put("tenantID", tenantID);
		return ezResourceAdminDAO.getSubClsList(map);
	}

	@Override
	public List<ResGetSubClsListVO> getAdmSubClsList(String parentID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceAdminDAO.getAdmSubClsList(map);
	}

	@Override
	public List<ResGetClsAclListVO> getClsAclList(String brdID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceAdminDAO.getClsAclList(map);
	}

	@Override
	public void delResAcll(String resID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_RESID", resID);
		map.put("v_P_COMPANYID", companyID);
		map.put("tenantID", tenantID);
		ezResourceAdminDAO.delResAcll(map);
	}

	@Override
	public void addClsData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall,String brdNm,
			String brdExplain, String accessNoty, String companyID, String brdNm2, String isCompany, int tenantID, String ownerNm2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ClassGB", classGB);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_AccessNoty", accessNoty);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("v_P_IS_COMPANY", isCompany);
		map.put("tenantID", tenantID);
		map.put("v_P_OwnerNm2", ownerNm2);
		
		int brdID = 0;
		
		if (isCompany.equals("Y")) {
			brdID = 1;
		} else {
			brdID = ezResourceAdminDAO.addClsData_S1(map); 
		}
		
		int brdLevel = ezResourceAdminDAO.addClsData_S2(map);
		int brdStep = ezResourceAdminDAO.addClsData_S3(map);
		
		map.put("v_Brd_ID", brdID);
		map.put("v_Brd_Level", brdLevel);
		map.put("v_Brd_Step", brdStep);
		ezResourceAdminDAO.addClsData_I1(map);
		ezResourceAdminDAO.addClsData_I2(map);
		ezResourceAdminDAO.addClsData_I3(map);
		//ezResourceAdminDAO.addClsData(map);
	}

	@Override
	public void saveACL(String resID, String deptYn, String sdaYn, String memberNam, String memberNam2, String memberID, String accessLvl, String companyID, int tenantID) throws Exception {
		logger.debug("saveACL Start");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ResID", resID);
		map.put("v_P_Dept_YN", deptYn);
		map.put("v_P_SDA_YN", sdaYn);
		map.put("v_P_Member_nam", memberNam);
		map.put("v_P_Member_nam2", memberNam2);
		map.put("v_P_Member_ID", memberID);
		map.put("v_P_Access_lvl", accessLvl);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);
		
		int result = ezResourceAdminDAO.saveACL_U(map);
		logger.debug("result="+result);
		if (result == 0) {
			ezResourceAdminDAO.saveACL(map);
		}
		logger.debug("saveACL End");
		//ezResourceAdminDAO.saveACL(map);
	}

	@Override
	public void modifyClsData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, 
			String brdExplain, String accessNoty, String companyID, String brdNm2, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_AccessNoty", accessNoty);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("tenantID", tenantID);
		ezResourceAdminDAO.modifyClsData(map);
	}

	@Override
	public void chgClsOrder(String sourceID, String targetID, String companyID, int tenantID) throws Exception {
		logger.debug("chgClsOrder started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_SourceID", sourceID);
		map.put("v_P_TargetID", targetID);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);
		
		int sourceStep = ezResourceAdminDAO.chgClsOrder_S1(map);
		int targetStep = ezResourceAdminDAO.chgClsOrder_S2(map);
		logger.debug("sourceStep="+sourceStep);
		logger.debug("targetStep="+targetStep);
		
		map.put("v_SourceStep", targetStep);
		map.put("v_TargetStep", sourceStep);
		ezResourceAdminDAO.chgClsOrder_U1(map);
		ezResourceAdminDAO.chgClsOrder_U2(map);

		logger.debug("chgClsOrder ended");
		//ezResourceAdminDAO.chgClsOrder(map);
	}

	@Override
	public void moveCls(String sourceID, String parentID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_SourceID", sourceID);
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);
		
		int targetRef = ezResourceAdminDAO.moveCls_S1(map);
		int targetLevel = ezResourceAdminDAO.moveCls_S2(map);
		int targetStep = ezResourceAdminDAO.moveCls_S3(map);
		
		map.put("v_TargetRef", targetRef);
		map.put("v_TargetLevel", targetLevel);
		map.put("v_TargetStep", targetStep);
		ezResourceAdminDAO.moveCls(map);
		
		moveSubCls(Integer.parseInt(sourceID), targetLevel+1, tenantID);
		//ezResourceAdminDAO.moveCls(map);
		
		
	}
	
	public void moveSubCls (int parentID, int targetLevel, int tenantID) throws Exception  {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_TargetLevel", targetLevel);
		map.put("tenantID", tenantID);
		//Integer brdID = ezResourceAdminDAO.moveSubCls_S1(map);
		
		List<Integer> brdIDList = ezResourceAdminDAO.moveSubCls_S1(map);
		
		ezResourceAdminDAO.moveSubCls_U1(map);
		
		/*while (brdID != null) {
			moveSubCls(brdID, targetLevel+1, tenantID);
		}*/
		
		
		
		for (int i=0; i<brdIDList.size(); i++) {
			moveSubCls(brdIDList.get(i), targetLevel+1, tenantID);
		}
		
	}

	@Override
	public void delClsData(String brdID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		map.put("tenantID", tenantID);
		
		ezResourceAdminDAO.delClsData_D1(map);
		ezResourceAdminDAO.delClsData_U1(map);
		ezResourceAdminDAO.delClsData_D2(map);
		ezResourceAdminDAO.delClsData_D4(map);
		ezResourceAdminDAO.delClsData_D5(map);
		//ezResourceAdminDAO.delClsData(map);
	}
	
	@Override
	public ResGetSubClsListVO getBrdInfo(int brdID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceAdminDAO.getBrdInfo(map);
	}
	
	@Override
	public int getSubResCnt(String resID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resID", resID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceAdminDAO.getSubResCnt(map);
	}
	
	@Override
	public int getSubClsCnt(String resID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resID", resID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		return ezResourceAdminDAO.getSubClsCnt(map);
	}

	public boolean addClsData(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		
		String classGB = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		String deptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		String deptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		String ownerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		String ownerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		String ownerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
		String ownerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		String brdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
		String brdExplain = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		String accessNoty = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
		String companyID = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
		String brdNm2 = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
		String ownerNm2 = xmlRes.getElementsByTagName("DATA").item(12).getTextContent().trim();
		String isCompany = "";
		
		if (xmlRes.getElementsByTagName("ISCOMPANY").getLength() > 0) {
			isCompany = xmlRes.getElementsByTagName("ISCOMPANY").item(0).getTextContent();
		}
		
		addClsData(classGB, deptID, deptNm, ownerID, ownerNm, ownerPos, ownerCall, brdNm, brdExplain, accessNoty, companyID, brdNm2, isCompany, tenantID, ownerNm2);
		return true;
	}
	
	public boolean modifyClsData(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		
		String classGB = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
		String deptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
		String deptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
		String ownerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
		String ownerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
		String ownerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
		String ownerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
		String brdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent();
		String brdExplain = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
		String accessNoty = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
		String companyID = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
		String brdNm2 = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
		
		modifyClsData(classGB, deptID, deptNm, ownerID, ownerNm, ownerPos, ownerCall, brdNm, brdExplain, accessNoty, companyID, brdNm2, tenantID);
		return true;
	}
	
	public String getSubCntOfCls(String xmlStr, int tenantID) throws Exception {
		String resID = "";
		String companyID = "";
		int resCnt = 0;
		int clsCnt = 0;
		StringBuilder returnXML = new StringBuilder();
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		
		resID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(0).getTextContent().trim();
		companyID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(1).getTextContent().trim();
		
		resCnt = getSubResCnt(resID, companyID, tenantID);
		clsCnt = getSubClsCnt(resID, companyID, tenantID);
		
		returnXML.append("<RTN_DATA>");
		returnXML.append("<ERRCHK>True</ERRCHK>");
		returnXML.append("<ERRDESC></ERRDESC>");
		returnXML.append("<SUBRESCNT>" + resCnt + "</SUBRESCNT>");
		returnXML.append("<SUBCLSCNT>" + clsCnt + "</SUBCLSCNT>");
		returnXML.append("</RTN_DATA>");
	
		return returnXML.toString();
	}
	
	public boolean blnMoveCls(String srcBrdID, String targetBrdID, String strPara, int tenantID) throws Exception {
		moveCls(srcBrdID, targetBrdID, strPara, tenantID);
		return true;
	}
	
	public boolean blnChgClsOrder(String currID, String nextID, String companyID, int tenantID) throws Exception {
		chgClsOrder(currID, nextID, companyID, tenantID);
		return true;
	}
	
	public String getSubClsList(String xmlStr, String langStr, int tenantID) throws Exception {
		String parentID = "";
		String companyID = "";
		String accessFlag = "";
		String userID = "";
		String deptPath = "";
		StringBuilder strXMLBld = new StringBuilder();
		StringBuilder returnXMLBld = new StringBuilder();
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		try {
			parentID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(0).getTextContent().trim();
			companyID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(1).getTextContent().trim();
			
			if (xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().getLength() > 2) {
				accessFlag = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(2).getTextContent().trim();
				userID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(3).getTextContent().trim();
				deptPath = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(4).getTextContent().trim();
			} else {
				accessFlag = "0";
			}
			deptPath = "'" + deptPath.trim().replace(",", "', '") + "'";
			
			if (accessFlag.equals("0")) {
				List<ResGetSubClsListVO> admSubClsList = getAdmSubClsList(parentID, companyID, tenantID);
				strXMLBld.append("<DATA>");
				
				for (int i=0; i<admSubClsList.size(); i++) {
					strXMLBld.append(commonUtil.getQueryResult(admSubClsList.get(i)));
				}
				
				strXMLBld.append("</DATA>");
			}
			else {
				List<ResGetSubClsListVO> subClsList = getSubClsList(parentID, companyID, userID, deptPath, tenantID);
				strXMLBld.append("<DATA>");
				
				for (int i=0; i<subClsList.size(); i++) {
					strXMLBld.append(commonUtil.getQueryResult(subClsList.get(i)));
				}
				
				strXMLBld.append("</DATA>");
			}
			
			returnXMLBld.append("<SUBCLSLIST>");
			
			Document returnXMLDom = commonUtil.convertStringToDocument(strXMLBld.toString());
			for (int i=0; i<returnXMLDom.getElementsByTagName("ROW").getLength(); i++) {
				returnXMLBld.append("<ROWNODE>");
				
				for (int j=0; j<returnXMLDom.getElementsByTagName("ROW").item(i).getChildNodes().getLength(); j++) {
					String elementName = returnXMLDom.getElementsByTagName("ROW").item(i).getChildNodes().item(j).getNodeName();
					String elementValue = returnXMLDom.getElementsByTagName("ROW").item(i).getChildNodes().item(j).getTextContent();
					
					if (elementName.equals("BRDNM") && !langStr.equals("1")) {
						elementValue = returnXMLDom.getElementsByTagName("BRDNM2").item(i).getTextContent();
						returnXMLBld.append("<" + elementName + "><![CDATA[" + elementValue + "]]></" + elementName + ">");
					} else {
						returnXMLBld.append("<" + elementName + "><![CDATA[" + elementValue + "]]></" + elementName + ">");
					}
				}
				
				returnXMLBld.append("</ROWNODE>");
			}
			
			returnXMLBld.append("</SUBCLSLIST>");
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		return returnXMLBld.toString();
	}
	
	public boolean delClsData(String xmlStr, int tenantID) throws Exception{
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String strBrdID = "";
		String strCompanyID = "";

		strBrdID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent();
		strCompanyID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent();
		
		delClsData(strBrdID, strCompanyID, tenantID);
		return true;
		
	}
	
	public String getClsACLList(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String strBrdID = "";
		String strCompanyID = "";
		
		strBrdID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(0).getTextContent().trim();
		strCompanyID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(1).getTextContent().trim();
		
		List<ResGetClsAclListVO> clsACLList = getClsAclList(strBrdID, strCompanyID, tenantID);
		
		StringBuilder returnXMLBld = new StringBuilder();
		returnXMLBld.append("<RTN_DATA>");
		for (int i=0; i<clsACLList.size(); i++) {
			returnXMLBld.append("<NODE>");
			returnXMLBld.append("<ATTRIBUTE>" + clsACLList.get(i).getDeptYn()  + "</ATTRIBUTE>");
			returnXMLBld.append("<ATTRIBUTE>" + clsACLList.get(i).getSdaYn() + "</ATTRIBUTE>");
			returnXMLBld.append("<ATTRIBUTE>" + commonUtil.cleanValue(clsACLList.get(i).getMemberNam()) + "</ATTRIBUTE>");
			returnXMLBld.append("<ATTRIBUTE>" + clsACLList.get(i).getMemberID() + "</ATTRIBUTE>");	
			returnXMLBld.append("<ATTRIBUTE>" + clsACLList.get(i).getAccessLvl() + "</ATTRIBUTE>");
			returnXMLBld.append("<ATTRIBUTE>" + commonUtil.cleanValue(clsACLList.get(i).getMemberNam2()) + "</ATTRIBUTE>");
			returnXMLBld.append("</NODE>");
		}
		
		returnXMLBld.append("</RTN_DATA>");
		return returnXMLBld.toString();
	}
	
	
	public boolean saveACLLst(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		boolean bDelete = false;
		
		String resID = "";
		String deptYN = "";
		String SDAYN = "";
		String memberNam = "";
		String memberNam2 = "";
		String memberID = "";
		String accessLvl = "";
		String companyID = "";

/*		2021-05-07 남학선 권한대상 전체 삭제시 삭제가 안되는 문제 수정.
		권한을 다 지우면 ResID, CompanyID만 가져오므로 나머지는 조건으로 처리함.*/
		//logger.debug("ROW_DATA length : " + xmlRes.getElementsByTagName("ROW_DATA").getLength());
		for (int i=0; i<xmlRes.getElementsByTagName("ROW_DATA").getLength(); i++) {
			resID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("ResID").getTextContent();
			companyID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("CompanyID").getTextContent();

			if (bDelete == false) {
				delResAcll(resID, companyID, tenantID);
				bDelete = true;
			}

			if(xmlRes.getElementsByTagName("ALL_DELETE").item(0).getTextContent().equalsIgnoreCase("NO")){
				deptYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Dept_YN").getTextContent();
				SDAYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("SDA_YN").getTextContent();
				memberNam = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_nam").getTextContent();
				memberNam2 = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_nam2").getTextContent();
				memberID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_ID").getTextContent();
				accessLvl = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Access_lvl").getTextContent();
				saveACL(resID, deptYN, SDAYN, memberNam, memberNam2, memberID, accessLvl, companyID, tenantID);
			}
		}
		return true;
	}
	

	public boolean userResPermissionCheck(String xmlStr, int tenantID) throws Exception {
		logger.debug("userResPermissionCheck start");
		
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		
		String resID = xmlRes.getElementsByTagName("ROW_DATA").item(0).getAttributes().getNamedItem("ResID").getTextContent();
		String companyID = xmlRes.getElementsByTagName("ROW_DATA").item(0).getAttributes().getNamedItem("CompanyID").getTextContent();
		
		int brdCnt = ezResourceService.getBrdCnt(Integer.parseInt(resID), companyID, tenantID);
		
		// 하위 자원이 없으면 삭제 가능
		if(brdCnt == 0) {
			logger.debug("There is no child resources");
			return true;
		}
		
		/* 2024-08-06 홍승비 - 다국어 처리된 칼럼을 사용하지 않는 호출이므로, 임의 언어 파라미터를 고정하여 전달 (기존 칼럼 셀렉트 유지) */
		List<ResBrdListVO> brdList = ezResourceService.getBrdList(brdCnt, Integer.parseInt(resID), companyID, "1", tenantID);
		
		for(int j=0; j<brdList.size(); j++) {
			String[] ownerList = brdList.get(j).getOwnerID().split(",");
			if(ownerList.length > 0 && xmlRes.getElementsByTagName("ALL_DELETE").item(0).getTextContent().equalsIgnoreCase("NO")){
				//logger.debug("ROW_DATA length : " + xmlRes.getElementsByTagName("ROW_DATA").getLength());
				for(int k=0; k<ownerList.length; k++) {
					boolean flag = false;
					logger.debug("current resource manager : " + ownerList[k]);
					for (int i=0; i<xmlRes.getElementsByTagName("ROW_DATA").getLength(); i++) {
						String memberID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_ID").getTextContent();
						String deptYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Dept_YN").getTextContent();

						// 권한 중 everyone이 있는 경우 true로 리턴
						if(memberID.equals("everyone")) {
							logger.debug("This Resource Group has everyone privilege");
							return true;
						}

						if(deptYN.equals("Y")) {
							if(memberID.equals(ownerList[k])) {
								logger.debug("user id : " + memberID + ", This user has access privilege");
								flag = true;
							}
						}
						else {
							// 부서 권한 체크
							String deptSDA = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("SDA_YN").getTextContent();
							String deptID = ezOrganService.getUserOrgDeptId(ownerList[k], tenantID, companyID);

							if(memberID.equals(deptID)) {		// 현재 부서
								logger.debug("dept id : " + memberID + ", This dept has access privilege");
								flag = true;
							}
							else {					// 상위 부서
								String deptPath = ezOrganService.getDeptPath(deptID, tenantID);

								List<String> deptIds = new ArrayList<String>();
								Collections.addAll(deptIds, deptPath.split(","));
								//deptIds.remove(0);				// companyID 삭제
								if(deptIds.size() > 0) {
									Collections.reverse(deptIds);
									deptIds.remove(0);				// 부서 ID 삭제

									for(int l=0; l<deptIds.size(); l++) {
										if(memberID.equals(deptIds.get(l)) && deptSDA.equals("Y")) {		// 현재 부서
											logger.debug("dept(2) id : " + memberID + ", This dept has access privilege");
											flag = true;
										}
									}
								}

								// 사내 겸직 권한 체크
								List<OrganUserVO> userAddJobList = ezOrganAdminService.getUserAddJobList(ownerList[k], "1", tenantID);

								for(int m=0; m<userAddJobList.size(); m++) {
									if(userAddJobList.get(m).getDepartment().equals(memberID)) {
										logger.debug("add job dept id : " + memberID + ", This dept has access privilege");
										flag = true;
									}

									String addJobDeptPath = ezOrganService.getDeptPath(userAddJobList.get(m).getDepartment(), tenantID);

									List<String> addJobDeptIds = new ArrayList<String>();
									Collections.addAll(addJobDeptIds, addJobDeptPath.split(","));
									//addJobDeptIds.remove(0);				// companyID 삭제
									if(addJobDeptIds.size() > 0) {
										Collections.reverse(addJobDeptIds);
										addJobDeptIds.remove(0);				// 부서 ID 삭제

										for(int l=0; l<addJobDeptIds.size(); l++) {
											if(memberID.equals(addJobDeptIds.get(l)) && deptSDA.equals("Y")) {		// 현재 부서
												logger.debug("add job dept(2) id : " + memberID + ", This dept has access privilege");
												flag = true;
											}
										}
									}
								}
							}
						}
					}
					if(!flag) {
						logger.debug("This user has no access privilege. save fail");
						return false;
					}
				}
			} else {
				logger.debug("This resource has only one owner(self)....");
				return true;
			}
		}
		
		logger.debug("userResPermissionCheck end");
		return true;
	}
	
	@Override
	public String getScheduleXML(String xmlStr, String ownerID, String companyID, int tenantID, String pType, String offset) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String sDate = xmlRes.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String eDate = xmlRes.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
		String nDate = xmlRes.getElementsByTagName("NOWTIME").item(0).getTextContent();
		
		sDate = sDate.replace(".", "-");
		eDate = eDate.replace(".", "-");
		
		String startDateLimit = sDate + " 00:00:01";
		String endDateLimit = eDate + " 23:59:59";
		
		String startDate = commonUtil.getDateStringInUTC(startDateLimit, offset, true);
		String endDate = commonUtil.getDateStringInUTC(endDateLimit, offset, true);
		String nowDate = commonUtil.getDateStringInUTC(nDate, offset, true);
		logger.debug("startDate={}", startDate);
		logger.debug("endDate={}", endDate);
		logger.debug("nowDate={}", nowDate);
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		Date now = sdf.parse(nDate);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate.replace(".", "-"));
		map.put("v_PENDDATE", endDate.replace(".", "-"));
		map.put("v_PNOWDATE", nowDate.replace(".", "-"));
		map.put("v_PTYPE", pType);
		map.put("tenantID", tenantID);
		
		List<ResGetScheduleVO> getScheduleList = ezResourceAdminDAO.getScheduleList(map);
		List<ResGetScheduleVO> getScheduleListRept = ezResourceAdminDAO.getScheduleListRepetiti(map);
		
		if (getScheduleListRept.size() > 0) {
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd");
			for (int i = 0; i < getScheduleListRept.size(); i++) {
				String reCompanyID = getScheduleListRept.get(i).getCompanyID();
				int reNum = getScheduleListRept.get(i).getNum();
				String reOwnerID = getScheduleListRept.get(i).getOwnerID();
				
				// tbl_schedulerepetition에서 정보 가져옴
				ResGetScheduleRepetitionVO vo = ezResourceService.getRepDateTimes(reOwnerID, reCompanyID, reNum, tenantID);
				
				if (vo != null) {
					
					vo.setStartDateTime(commonUtil.getDateStringInUTC(vo.getStartDateTime(), offset, false));
					vo.setEndDateTime(commonUtil.getDateStringInUTC(vo.getEndDateTime(), offset, false));
					
					// ResGetScheduleRepetitionVO -> ResScheduleRepetitionVO
					ResScheduleRepetitionVO rvo = ezResourceService.resStruct(vo);
					
					// 반복예약의 반복되는 날짜리스트 뽑아옴
					List<Date[]> returnRepDateTimes = ezResourceService.getRepDateTimes(rvo, sDate, eDate, offset);
					
					// 반복예약 중에 삭제된 예약 가져옴
					List<String> deletedDateStrList = ezResourceService.getDeletedRepScheduleDate(reNum, reCompanyID, reOwnerID, tenantID);
					logger.debug("deletedDateStrList.size=" + deletedDateStrList.size());
					
					for (int j = 0; j < deletedDateStrList.size(); j++) {
						deletedDateStrList.set(j, (commonUtil.getDateStringInUTC(deletedDateStrList.get(j), offset, false)).substring(0,10));
					}
					
					for (Date[] dateArr : returnRepDateTimes) {
						
						// 삭제된 예약이면 넘어감
						if (deletedDateStrList.contains(format2.format(dateArr[0]))) {		// 날짜만 비교하도록 수정
							continue;
						}
						
						if (pType.equals("end")) {
							if (dateArr[1] == null) {
								continue;
							} else {
								if (dateArr[1].after(now)) {
									continue;
								}
							}
						} else {
							if (dateArr[1] == null) {
								continue;
							} else {
								if (dateArr[1].before(now)) {
									continue;
								}
							}
						}
						
						ResGetScheduleVO temp = new ResGetScheduleVO();

						temp.setNum(getScheduleListRept.get(i).getNum());
						temp.setpNum(getScheduleListRept.get(i).getNum());
						temp.setOwnerID(getScheduleListRept.get(i).getOwnerID());
						temp.setTitle(getScheduleListRept.get(i).getTitle());
						temp.setLocation(getScheduleListRept.get(i).getLocation());
						temp.setTimeDisplay(getScheduleListRept.get(i).getTimeDisplay());
						temp.setStartDate(commonUtil.getDateStringInUTC(format.format(dateArr[0]), offset, true));
						temp.setEndDate(commonUtil.getDateStringInUTC(format.format(dateArr[1]), offset, true));
						temp.setAlertTime(getScheduleListRept.get(i).getAlertTime());
						temp.setReFlag(getScheduleListRept.get(i).getReFlag());
						temp.setGresFlag(getScheduleListRept.get(i).getGresFlag());
						temp.setWriterID(getScheduleListRept.get(i).getWriterID());
						temp.setImportance(getScheduleListRept.get(i).getImportance());
						temp.setEntryList(getScheduleListRept.get(i).getEntryList());
						temp.setAllDay(getScheduleListRept.get(i).getAllDay());
						temp.setWriteDay(commonUtil.getDateStringInUTC(getScheduleListRept.get(i).getWriteDay(), offset, true));
						temp.setAttachFlag(getScheduleListRept.get(i).getAttachFlag());
						temp.setCharacterID(getScheduleListRept.get(i).getCharacterID());
						temp.setApproveFlag(getScheduleListRept.get(i).getApproveFlag());
						temp.setReturnFlag(getScheduleListRept.get(i).getReturnFlag());
						temp.setOwnerNm(getScheduleListRept.get(i).getOwnerNm());
						temp.setDeptNm(getScheduleListRept.get(i).getDeptNm());
						temp.setNowDate(commonUtil.getDateStringInUTC(getScheduleListRept.get(i).getNowDate(), offset, true));
						temp.setUseApprove(getScheduleListRept.get(i).getUseApprove());
						temp.setUseReturn(getScheduleListRept.get(i).getUseReturn());
						
						getScheduleList.add(temp);
					}
				}
			}
		}
		
		//자원별 일정 정렬
	    //시간순, 제목순
        Collections.sort(getScheduleList, new Comparator<ResGetScheduleVO>() {
			@Override
			public int compare(ResGetScheduleVO o1, ResGetScheduleVO o2) {
				if (o1.getAllDay().compareTo(o2.getAllDay()) == 0) {
					if (o1.getStartDate().compareTo(o2.getStartDate()) == 0) {
						if (o1.getEndDate().compareTo(o2.getEndDate()) == 0) {
							return o1.getTitle().compareTo(o2.getTitle());
						} else {
							return o1.getEndDate().compareTo(o2.getEndDate());
						}
					} else {
						return o1.getStartDate().compareTo(o2.getStartDate());
					}	
				} else {
					return o1.getAllDay().compareTo(o2.getAllDay());
				}
			}
		});
		
		StringBuilder returnScheduleBld = new StringBuilder();
		returnScheduleBld.append("<DATA>");
		
		for (ResGetScheduleVO vo :  getScheduleList) {
			returnScheduleBld.append(commonUtil.getQueryResult(vo));
		}
		
		returnScheduleBld.append("</DATA>");
		
		Document returnDom = commonUtil.convertStringToDocument(returnScheduleBld.toString());
		
		StringBuilder returnStr = new StringBuilder();
		returnStr.append("<DATA>");
		
		if (returnDom != null) {
			for (int m = 0; m < returnDom.getElementsByTagName("ROW").getLength(); m++) {
				returnStr.append("<ROW>");
				returnStr.append("<num>" + returnDom.getElementsByTagName("NUM").item(m).getTextContent() + "</num>");
				returnStr.append("<pnum>" + returnDom.getElementsByTagName("PNUM").item(m).getTextContent() + "</pnum>");
				returnStr.append("<ownerID>" + returnDom.getElementsByTagName("OWNERID").item(m).getTextContent() + "</ownerID>");
				returnStr.append("<title><![CDATA[" + returnDom.getElementsByTagName("TITLE").item(m).getTextContent() + "]]></title>");
				returnStr.append("<location><![CDATA[" + returnDom.getElementsByTagName("LOCATION").item(m).getTextContent() + "]]></location>");
				returnStr.append("<timeDisplay><![CDATA[" + returnDom.getElementsByTagName("TIMEDISPLAY").item(m).getTextContent() + "]]></timeDisplay>");
				returnStr.append("<startDate>" + commonUtil.getDateStringInUTC(returnDom.getElementsByTagName("STARTDATE").item(m).getTextContent(), offset, false) + "</startDate>");
				returnStr.append("<endDate>" + commonUtil.getDateStringInUTC(returnDom.getElementsByTagName("ENDDATE").item(m).getTextContent(), offset, false) + "</endDate>");
				returnStr.append("<alertTime>" + returnDom.getElementsByTagName("ALERTTIME").item(m).getTextContent() + "</alertTime>");
				returnStr.append("<reFlag>" + returnDom.getElementsByTagName("REFLAG").item(m).getTextContent() + "</reFlag>");
				returnStr.append("<gresFlag>" + returnDom.getElementsByTagName("GRESFLAG").item(m).getTextContent() + "</gresFlag>");
				returnStr.append("<writerID>" + returnDom.getElementsByTagName("WRITERID").item(m).getTextContent() + "</writerID>");
				returnStr.append("<importance>" + returnDom.getElementsByTagName("IMPORTANCE").item(m).getTextContent() + "</importance>");
				returnStr.append("<entryList>" + returnDom.getElementsByTagName("ENTRYLIST").item(m).getTextContent() + "</entryList>");
				returnStr.append("<allDay>" + returnDom.getElementsByTagName("ALLDAY").item(m).getTextContent() + "</allDay>");
				returnStr.append("<writeDay>" + commonUtil.getDateStringInUTC(returnDom.getElementsByTagName("WRITEDAY").item(m).getTextContent(), offset, false) + "</writeDay>");
				returnStr.append("<attachFlag>" + returnDom.getElementsByTagName("ATTACHFLAG").item(m).getTextContent() + "</attachFlag>");
				returnStr.append("<characterID>" + returnDom.getElementsByTagName("CHARACTERID").item(m).getTextContent() + "</characterID>");
				returnStr.append("<useApprove><![CDATA[" + returnDom.getElementsByTagName("USEAPPROVE").item(m).getTextContent() + "]]></useApprove>");
				returnStr.append("<useReturn><![CDATA[" + returnDom.getElementsByTagName("USERETURN").item(m).getTextContent() + "]]></useReturn>");
				returnStr.append("<approveFlag>" + returnDom.getElementsByTagName("APPROVEFLAG").item(m).getTextContent() + "</approveFlag>");
				returnStr.append("<returnFlag>" + returnDom.getElementsByTagName("RETURNFLAG").item(m).getTextContent() + "</returnFlag>");
				returnStr.append("<nowDate>" + commonUtil.getDateStringInUTC(returnDom.getElementsByTagName("NOWDATE").item(m).getTextContent(), offset, false) + "</nowDate>");
				returnStr.append("<ownerNM><![CDATA[" + returnDom.getElementsByTagName("OWNERNM").item(m).getTextContent() + "]]></ownerNM>");
				returnStr.append("<deptNM><![CDATA[" + returnDom.getElementsByTagName("DEPTNM").item(m).getTextContent() + "]]></deptNM>");
				returnStr.append("</ROW>");
			}
		}
		
		returnStr.append("</DATA>");
		
		return returnStr.toString();
	}
	
}
