package egovframework.ezEKP.ezResource.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezResource.dao.EzResourceAdminDAO;
import egovframework.ezEKP.ezResource.service.EzResourceAdminService;
import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import egovframework.ezEKP.ezResource.vo.ResGetSubClsListVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzResourceAdminService")
public class EzResourceAdminServiceImpl implements EzResourceAdminService {

	@Resource(name="EzResourceAdminDAO")
	private EzResourceAdminDAO ezResourceAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<ResGetSubClsListVO> getSubClsList(String parentID, String companyID, String userID, String deptPath) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_UserID", userID);
		map.put("v_P_DeptPath", deptPath);
		return ezResourceAdminDAO.getSubClsList(map);
	}

	@Override
	public List<ResGetSubClsListVO> getAdmSubClsList(String parentID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		return ezResourceAdminDAO.getAdmSubClsList(map);
	}

	@Override
	public List<ResGetClsAclListVO> getClsAclList(String brdID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		return ezResourceAdminDAO.getClsAclList(map);
	}

	@Override
	public int delResAcll(String resID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_RESID", resID);
		map.put("v_P_COMPANYID", companyID);
		return ezResourceAdminDAO.delResAcll(map);
	}

	@Override
	public void addClsData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall,String brdNm,
			String brdExplain, String accessNoty, String companyID, String brdNm2, String isCompany) throws Exception {
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
		ezResourceAdminDAO.addClsData(map);
	}

	@Override
	public void saveACL(String resID, String deptYn, String sdaYn, String memberNam, String memberID, String accessLvl, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_ResID", resID);
		map.put("v_P_Dept_YN", deptYn);
		map.put("v_P_SDA_YN", sdaYn);
		map.put("v_P_Member_nam", memberNam);
		map.put("v_P_Member_ID", memberID);
		map.put("v_P_Access_lvl", accessLvl);
		map.put("v_P_CompanyID", companyID);
		ezResourceAdminDAO.saveACL(map);
	}

	@Override
	public void modifyClsData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, 
			String brdExplain, String accessNoty, String companyID, String brdNm2) throws Exception {
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
		ezResourceAdminDAO.modifyClsData(map);
	}

	@Override
	public void chgClsOrder(String sourceID, String targetID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_SourceID", sourceID);
		map.put("v_P_TargetID", targetID);
		map.put("v_P_CompanyID", companyID);
		ezResourceAdminDAO.chgClsOrder(map);
	}

	@Override
	public void moveCls(String sourceID, String parentID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_SourceID", sourceID);
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		ezResourceAdminDAO.moveCls(map);
	}

	@Override
	public void delClsData(String brdID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		ezResourceAdminDAO.delClsData(map);
	}
	
	@Override
	public ResGetSubClsListVO getBrdInfo(int brdID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		return ezResourceAdminDAO.getBrdInfo(map);
	}
	
	@Override
	public int getSubResCnt(String resID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resID", resID);
		map.put("companyID", companyID);
		return ezResourceAdminDAO.getSubResCnt(map);
	}
	
	@Override
	public int getSubClsCnt(String resID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resID", resID);
		map.put("companyID", companyID);
		return ezResourceAdminDAO.getSubClsCnt(map);
	}

	public boolean addClsData(String xmlStr) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		try {
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
			
			addClsData(classGB, deptID, deptNm, ownerID, ownerNm, ownerPos, ownerCall, brdNm, brdExplain, accessNoty, companyID, brdNm2, isCompany);
			return true;
			
		} catch (Exception e) {
			return false;
		}
	}
	
	public boolean modifyClsData(String xmlStr) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		try {
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
			
			modifyClsData(classGB, deptID, deptNm, ownerID, ownerNm, ownerPos, ownerCall, brdNm, brdExplain, accessNoty, companyID, brdNm2);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public String getSubCntOfCls(String xmlStr) {
		String resID = "";
		String companyID = "";
		int resCnt = 0;
		int clsCnt = 0;
		StringBuilder returnXML = new StringBuilder();
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		try {
			resID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(0).getTextContent().trim();
			companyID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(1).getTextContent().trim();
			
			resCnt = getSubResCnt(resID, companyID);
			clsCnt = getSubClsCnt(resID, companyID);
			
			returnXML.append("<RTN_DATA>");
			returnXML.append("<ERRCHK>True</ERRCHK>");
			returnXML.append("<ERRDESC></ERRDESC>");
			returnXML.append("<SUBRESCNT>" + resCnt + "</SUBRESCNT>");
			returnXML.append("<SUBCLSCNT>" + clsCnt + "</SUBCLSCNT>");
			returnXML.append("</RTN_DATA>");
		} catch (Exception e) {
			e.printStackTrace(); 
		}
		return returnXML.toString();
	}
	
	public boolean blnMoveCls(String srcBrdID, String targetBrdID, String strPara) throws Exception {
		try {
			moveCls(srcBrdID, targetBrdID, strPara);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	public boolean blnChgClsOrder(String currID, String nextID, String companyID) throws Exception {
		try {
			chgClsOrder(currID, nextID, companyID);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	public String getSubClsList(String xmlStr, String langStr) throws Exception {
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
				List<ResGetSubClsListVO> admSubClsList = getAdmSubClsList(parentID, companyID);
				strXML += "<DATA>";
				for (int i=0; i<admSubClsList.size(); i++) {
					strXML += commonUtil.getQueryResult(admSubClsList.get(i));	
				}
				strXML += "</DATA>";
			} else {
				List<ResGetSubClsListVO> subClsList = getSubClsList(parentID, companyID, userID, deptPath);
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
						returnXML += "<" + elementName + ">" + elementValue + "</" + elementName + ">";
					} else {
						returnXML += "<" + elementName + ">" + elementValue + "</" + elementName + ">";
					}
				}
				returnXML += "</ROWNODE>";
			}
			returnXML += "</SUBCLSLIST>";
		} catch (Exception e) {
			
		}
		return returnXML;
	}
	
	public boolean delClsData(String xmlStr) throws Exception{
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String strBrdID = "";
		String strCompanyID = "";

		try {
			strBrdID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent();
			strCompanyID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent();
			
			delClsData(strBrdID, strCompanyID);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public String getClsACLList(String xmlStr) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String strBrdID = "";
		String strCompanyID = "";
		String returnXML = "";

		try {
			strBrdID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(0).getTextContent().trim();
			strCompanyID = xmlRes.getElementsByTagName("PARA_DATA").item(0).getChildNodes().item(1).getTextContent().trim();
			
			List<ResGetClsAclListVO> clsACLList = getClsAclList(strBrdID, strCompanyID);
			
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnXML;
	}
	
	public boolean saveACLLst(String xmlStr) throws Exception {
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		boolean bDelete = false;
		
		String resID = "";
		String deptYN = "";
		String SDAYN = "";
		String memberNam = "";
		String memberID = "";
		String accessLvl = "";
		String companyID = "";
		
		try {
			for (int i=0; i<xmlRes.getElementsByTagName("ROW_DATA").getLength(); i++) {
				resID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("ResID").getTextContent();
				deptYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Dept_YN").getTextContent();
				SDAYN = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("SDA_YN").getTextContent();
				memberNam = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_nam").getTextContent();
				memberID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Member_ID").getTextContent();
				accessLvl = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("Access_lvl").getTextContent();
				companyID = xmlRes.getElementsByTagName("ROW_DATA").item(i).getAttributes().getNamedItem("CompanyID").getTextContent();
				
				if (bDelete == false) {
					delResAcll(resID, companyID);
					bDelete = true;
				}
				saveACL(resID, deptYN, SDAYN, memberNam, memberID, accessLvl, companyID);
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
}
