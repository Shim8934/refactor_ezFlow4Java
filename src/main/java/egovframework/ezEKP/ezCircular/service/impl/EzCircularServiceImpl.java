package egovframework.ezEKP.ezCircular.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilderFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezResource.dao.EzResourceDAO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzCircularService")
public class EzCircularServiceImpl implements EzCircularService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzCircularServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzResourceDAO")
	private EzResourceDAO ezResourceDAO;
	
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID,String companyID, String treeType, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getAdmSubClsTree(map);
	}

	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("v_P_USERID", pUserID);
		map.put("v_PCOMID", comID);
		map.put("v_PDEPTID", deptID);
		map.put("v_PUSERID", userID);
		map.put("tenantID", tenantID);
		return ezResourceDAO.getSubClsTree(map);
	}
	
	@Override
	public String getSubClsTree(String xmlReq, String langStr, String companyID, String deptID, String userID, int tenantID) throws Exception {
		String strUserID = "";
        String strDeptPath = "";
        String returnXML = "";
   
        Document xmlRes = commonUtil.convertStringToDocument(xmlReq);
        String strParentID = xmlRes.getElementsByTagName("PARENT_ID").item(0).getTextContent().trim();
        String strCompanyID = xmlRes.getElementsByTagName("COMPANY_ID").item(0).getTextContent().trim();
        String strAccessFlag = xmlRes.getElementsByTagName("ACCESS_FLAG").item(0).getTextContent().trim();
        String strFirstNode = xmlRes.getElementsByTagName("FIRST_NODE").item(0).getTextContent().trim();
        String strTreeType = xmlRes.getElementsByTagName("TREE_TYPE").item(0).getTextContent().trim();

        if(xmlRes.getElementsByTagName("BRDLIST").getLength() > 5) {
        	strUserID = xmlRes.getElementById("BRDLIST").getChildNodes().item(5).getTextContent().trim();
        	strDeptPath = xmlRes.getElementById("BRDLIST").getChildNodes().item(6).getTextContent().trim();
        	strDeptPath = "'" + strDeptPath.replace("," , "', '")+ "'";
        }
        
        List<ResGetAdmSubClsTreeVO> resGetAdmSubClsTree = new ArrayList<ResGetAdmSubClsTreeVO>();
        if(strAccessFlag.equals("0")) {
        	resGetAdmSubClsTree = getAdmSubClsTree(strParentID, strCompanyID, strTreeType, tenantID);
        } else {
        	resGetAdmSubClsTree = getSubClsTree(strParentID, strCompanyID, strTreeType, strUserID, companyID, deptID, userID, tenantID);
        }
logger.debug("###" + resGetAdmSubClsTree);
        StringBuilder strTreeStyle = new StringBuilder();
        if(strFirstNode.equals("Y")) {
        	strTreeStyle.append("<TREEVIEWDATA>");
        	strTreeStyle.append("<TEXTCOLOR>");
        	strTreeStyle.append("<NAME>ENTUMTEXTCOLOR</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<DEFAULTTEXTCOLOR>black</DEFAULTTEXTCOLOR>");					
        	strTreeStyle.append("<DEFAULTBGCOLOR>ffffff</DEFAULTBGCOLOR>");
        	strTreeStyle.append("<SELECTEDTEXTCOLOR>164AAD</SELECTEDTEXTCOLOR>");
        	strTreeStyle.append("<SELECTEDBGCOLOR>ffffff</SELECTEDBGCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGTEXTCOLOR>164AAD</HOTTRACKINGTEXTCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGBGCOLOR>ffffff</HOTTRACKINGBGCOLOR>");
        	strTreeStyle.append("</TEXTCOLOR>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESCLASS</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_01.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_01.gif</LEAFSELECTEDICON>");
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_01.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_01.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESOURCE</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_02.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_02.gif</LEAFSELECTEDICON>");
        	
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_02.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_02.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<HERITAGEICONIMAGE>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<BLANKICON>/images/left/blank.gif</BLANKICON>");
        	strTreeStyle.append("<VERTICALLINEICON>/images/left/vline.gif</VERTICALLINEICON>");
        	strTreeStyle.append("<NODEICON>/images/left/02.gif</NODEICON>");
        	strTreeStyle.append("<MNODEICON>/images/left/02_minus.gif</MNODEICON>");
        	strTreeStyle.append("<PNODEICON>/images/left/02_plus.gif</PNODEICON>");
        	strTreeStyle.append("<ROOTNODEICON>/images/left/03.gif</ROOTNODEICON>");
        	strTreeStyle.append("<MROOTNODEICON>/images/left/03_minus.gif</MROOTNODEICON>");
        	strTreeStyle.append("<PROOTNODEICON>/images/left/03_plus.gif</PROOTNODEICON>");
        	strTreeStyle.append("<LASTNODEICON>/images/left/03.gif</LASTNODEICON>");
        	strTreeStyle.append("<MLASTNODEICON>/images/left/03_minus.gif</MLASTNODEICON>");
        	strTreeStyle.append("<FIRSTROOTNODEICON>/images/left/02.gif</FIRSTROOTNODEICON>");
        	strTreeStyle.append("<MFIRSTROOTNODEICON>/images/left/02_minus.gif</MFIRSTROOTNODEICON>");
        	strTreeStyle.append("<PFIRSTROOTNODEICON>/images/left/02_plus.gif</PFIRSTROOTNODEICON>");
        	strTreeStyle.append("</HERITAGEICONIMAGE>");
        
        	returnXML = strTreeStyle.toString();
        } else {
        	strTreeStyle.append("<NODES>");
        	returnXML = strTreeStyle.toString();
        }
        
        if(strFirstNode.equals("Y")) {
        	for(int i=0; i<resGetAdmSubClsTree.size(); i++) {
        		if(i == 0) {
        			 returnXML += makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), true, langStr);
        		} else {
        			returnXML += makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr);
        		}
        	}
        	returnXML += "</TREEVIEWDATA>";
        } else {
        	for(int i=0; i<resGetAdmSubClsTree.size(); i++) {
        		returnXML += makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr);

        	}

        	returnXML += "</NODES>";
        }
		return returnXML;
	}
	
	public String makeNodesFromADOFlds(String xmlStr, boolean blnFirstNode, String langStr) throws Exception{
		String returnXML = "";
        String strData2 = "";
        int intSubCnt = 0;
        String strIsLeaf = "";
        String strSetNodeIconByName = "";
        
        Document xmlRes = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        xmlRes = commonUtil.convertStringToDocument(xmlStr);
        String strData1 = xmlRes.getElementsByTagName("BRDID").item(0).getTextContent();
        
        if(langStr.equals("1")) {
        	strData2 = xmlRes.getElementsByTagName("BRDNM").item(0).getTextContent();
        } else {
        	strData2 = xmlRes.getElementsByTagName("BRDNM"+langStr).item(0).getTextContent();
        }
        String strData3 = xmlRes.getElementsByTagName("BRDLEVEL").item(0).getTextContent();
        String strData4 = xmlRes.getElementsByTagName("BRDSTEP").item(0).getTextContent();
        String strData5 = xmlRes.getElementsByTagName("BRDPOSTTERM").item(0).getTextContent();
        String strData6 = xmlRes.getElementsByTagName("BRDUPPER").item(0).getTextContent();
        String strData7 = xmlRes.getElementsByTagName("BRDGB").item(0).getTextContent();
        String strData8 = xmlRes.getElementsByTagName("BRDURL").item(0).getTextContent();
        String strData9 = xmlRes.getElementsByTagName("BRDEXPLAIN").item(0).getTextContent();
        String strData10 = xmlRes.getElementsByTagName("BRDACCESS").item(0).getTextContent();
        String strData11 = xmlRes.getElementsByTagName("ATTACHSIZE").item(0).getTextContent();
        String strData12 = xmlRes.getElementsByTagName("SUBCLSCNT").item(0).getTextContent();
        String strData13 = xmlRes.getElementsByTagName("SUBRESCNT").item(0).getTextContent();
        String strData14 = xmlRes.getElementsByTagName("ACCESSLVL").item(0).getTextContent();
        String strData15 = xmlRes.getElementsByTagName("APPROVEFLAG").item(0).getTextContent();
  
        intSubCnt = Integer.parseInt(strData12.trim()) + Integer.parseInt(strData13.trim());
        
        String strValue = strData2;
        String strStyle = "font-weight:normal;height:10px;";
        
        returnXML += "<NODE>";
        returnXML += makeXMLElement(strValue, "VALUE", true);
        returnXML += makeXMLElement(strStyle, "STYLE", false);
        returnXML += makeXMLElement(strData1, "DATA1", false);
        returnXML += makeXMLElement(strData2, "DATA2", true);
        returnXML += makeXMLElement(strData3, "DATA3", false);
        returnXML += makeXMLElement(strData4, "DATA4", false);
        returnXML += makeXMLElement(strData5, "DATA5", false);
        returnXML += makeXMLElement(strData6, "DATA6", false);
        returnXML += makeXMLElement(strData7, "DATA7", false);
        returnXML += makeXMLElement(strData8, "DATA8", true);
        returnXML += makeXMLElement(strData9, "DATA9", true);
        returnXML += makeXMLElement(strData10, "DATA10", true);
        returnXML += makeXMLElement(strData11, "DATA11", false);
        returnXML += makeXMLElement(strData12, "DATA12", false);
        returnXML += makeXMLElement(strData13, "DATA13", false);
        returnXML += makeXMLElement(strData14, "DATA14", false);
        returnXML += makeXMLElement(strData15, "DATA15", false);
        
        if(intSubCnt == 0) {
        	strIsLeaf = "TRUE";
        } else {
        	strIsLeaf = "FALSE";
        }
        
        if(strData7.equals("1")) {
        	strSetNodeIconByName = "RESCLASS";
        } else {
        	strSetNodeIconByName = "RESOURCE";
        }
        
        returnXML += makeXMLElement(strIsLeaf, "ISLEAF", false);
        returnXML += makeXMLElement(strSetNodeIconByName, "SETNODEICONBYNAME", false);
        returnXML += makeXMLElement("FALSE", "EXPANDED", false);
        
        if(blnFirstNode == true) {
        	returnXML += makeXMLElement("", "SELECT", true);
        }
        returnXML += "</NODE>";
		return returnXML;
	}
	
	public String makeXMLElement(String strElementText, String strElementName, boolean blnCData) {
		if(blnCData == true) {
			return "<"+strElementName+"><![CDATA["+strElementText+"]]></"+strElementName+">";
		} else {
			return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
		}
	}
	
}
