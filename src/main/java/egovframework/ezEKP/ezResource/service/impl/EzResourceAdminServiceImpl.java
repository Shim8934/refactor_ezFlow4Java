package egovframework.ezEKP.ezResource.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezResource.dao.EzResourceAdminDAO;
import egovframework.ezEKP.ezResource.service.EzResourceAdminService;
import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import egovframework.ezEKP.ezResource.vo.ResGetSubClsListVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzResourceAdminService")
public class EzResourceAdminServiceImpl extends EgovAbstractServiceImpl implements EzResourceAdminService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzResourceAdminServiceImpl.class);
	
	@Resource(name="EzResourceAdminDAO")
	private EzResourceAdminDAO ezResourceAdminDAO;
	
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
			String brdExplain, String accessNoty, String companyID, String brdNm2, String isCompany, int tenantID) throws Exception {
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
	public void saveACL(String resID, String deptYn, String sdaYn, String memberNam, String memberID, String accessLvl, String companyID, int tenantID) throws Exception {
		logger.debug("saveACL Start");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ResID", resID);
		map.put("v_P_Dept_YN", deptYn);
		map.put("v_P_SDA_YN", sdaYn);
		map.put("v_P_Member_nam", memberNam);
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
		String isCompany = "";
		
		if (xmlRes.getElementsByTagName("ISCOMPANY").getLength() > 0) {
			isCompany = xmlRes.getElementsByTagName("ISCOMPANY").item(0).getTextContent();
		}
		
		addClsData(classGB, deptID, deptNm, ownerID, ownerNm, ownerPos, ownerCall, brdNm, brdExplain, accessNoty, companyID, brdNm2, isCompany, tenantID);
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
		String brdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
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
		String returnXML = "";
		String strXML = "";
		
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
				strXML += "<DATA>";
				for (int i=0; i<admSubClsList.size(); i++) {
					strXML += commonUtil.getQueryResult(admSubClsList.get(i));	
				}
				strXML += "</DATA>";
			} else {
				List<ResGetSubClsListVO> subClsList = getSubClsList(parentID, companyID, userID, deptPath, tenantID);
				strXML += "<DATA>";
				for (int i=0; i<subClsList.size(); i++) {
					strXML += commonUtil.getQueryResult(subClsList.get(i));
				}
				strXML += "</DATA>";
			}
			returnXML += "<SUBCLSLIST>";
		
			Document returnXMLDom = commonUtil.convertStringToDocument(strXML);
			for (int i=0; i<returnXMLDom.getElementsByTagName("ROW").getLength(); i++) {
				returnXML += "<ROWNODE>";
				
				for (int j=0; j<returnXMLDom.getElementsByTagName("ROW").item(i).getChildNodes().getLength(); j++) {

					String elementName = returnXMLDom.getElementsByTagName("ROW").item(i).getChildNodes().item(j).getNodeName();
					String elementValue = returnXMLDom.getElementsByTagName("ROW").item(i).getChildNodes().item(j).getTextContent();
					
					if (elementName.equals("BRDNM") && !langStr.equals("1")) {
						elementValue = returnXMLDom.getElementsByTagName("BRDNM2").item(i).getTextContent();
						returnXML += "<" + elementName + "><![CDATA[" + elementValue + "]]></" + elementName + ">";
					} else {
						returnXML += "<" + elementName + "><![CDATA[" + elementValue + "]]></" + elementName + ">";
					}
				}
				returnXML += "</ROWNODE>";
			}
			returnXML += "</SUBCLSLIST>";
		} catch (Exception e) {
			
		}
		return returnXML;
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
		String returnXML = "";

		strBrdID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(0).getTextContent().trim();
		strCompanyID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(1).getTextContent().trim();
		
		List<ResGetClsAclListVO> clsACLList = getClsAclList(strBrdID, strCompanyID, tenantID);
		
		returnXML += "<RTN_DATA>";
		for (int i=0; i<clsACLList.size(); i++) {
			returnXML += "<NODE>";
			returnXML += "<ATTRIBUTE>" + clsACLList.get(i).getDeptYn()  + "</ATTRIBUTE>";
			returnXML += "<ATTRIBUTE>" + clsACLList.get(i).getSdaYn()  + "</ATTRIBUTE>";
			returnXML += "<ATTRIBUTE>" + clsACLList.get(i).getMemberNam()  + "</ATTRIBUTE>";
			returnXML += "<ATTRIBUTE>" + clsACLList.get(i).getMemberID()  + "</ATTRIBUTE>";
			returnXML += "<ATTRIBUTE>" + clsACLList.get(i).getAccessLvl()  + "</ATTRIBUTE>";
			returnXML += "</NODE>";
		}
		returnXML += "</RTN_DATA>";
		
		return returnXML;
	}
	
	
	public boolean saveACLLst(String xmlStr, int tenantID) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		boolean bDelete = false;
		
		String resID = "";
		String deptYN = "";
		String SDAYN = "";
		String memberNam = "";
		String memberID = "";
		String accessLvl = "";
		String companyID = "";
		
		for (int i=0; i<xmlRes.getElementsByTagName("ROW_DATA").getLength(); i++) {
			resID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("ResID").getTextContent();
			deptYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Dept_YN").getTextContent();
			SDAYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("SDA_YN").getTextContent();
			memberNam = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_nam").getTextContent();
			memberID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_ID").getTextContent();
			accessLvl = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Access_lvl").getTextContent();
			companyID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("CompanyID").getTextContent();
			
			if (bDelete == false) {
				delResAcll(resID, companyID, tenantID);
				bDelete = true;
			}
			saveACL(resID, deptYN, SDAYN, memberNam, memberID, accessLvl, companyID, tenantID);
		}
		return true;
	}
}
