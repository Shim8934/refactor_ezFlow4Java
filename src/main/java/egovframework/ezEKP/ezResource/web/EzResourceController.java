package egovframework.ezEKP.ezResource.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 자원관리
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.19    지정석    신규작성
 *
 * @see
 */

@Controller
public class EzResourceController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	
	/**
	 * 자원관리 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/resMain.do")
	public String resMain(HttpServletRequest req, Model model) throws Exception {
		String brdId = "";
		String brdNm = "";
		String brdTopPath = "";
		String pUrl = "";
		String url = "/ezResource/leftResource.do";
		
		if(req.getParameter("brd_id") != null) {
			brdId = req.getParameter("brd_id");
		}
		
		if(req.getParameter("brdnm") != null) {
			brdNm = req.getParameter("brdnm");
		}
		
		if(req.getParameter("brdpath") != null) {
			brdTopPath = req.getParameter("brdpath");
		}
		
		if(brdId == "" || brdId.equals("")) {
			if(brdTopPath == "B" || brdTopPath.equals("")) {
				pUrl = url + "?BoardGbn=" + brdTopPath;
			} else {
				pUrl = url;
			} 
		} else {
			pUrl = url + "?brdId=" + brdId + "&brdNm=" + brdNm + "&boardGbn=M";
		}
		
		model.addAttribute("pUrl", pUrl);
		return "/ezResource/resMain";
	}
	
	/**
	 * 자원관리 좌측메뉴 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/leftResource.do")
	public String resLeftResource(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdId = "";
	    String brdNm = "";
	    String brdGubun = "";
	    String brdGbn = "";
	    String strAccessCode = "";
	    String selectNo = "";
	    
		if(req.getParameter("brdId") != null) {
			brdId = req.getParameter("brdId");
		}
		
		if(req.getParameter("brdNm") != null) {
			brdId = req.getParameter("brdNm");
		}
		
		if(req.getParameter("pbrdGubun") != null) {
			brdGubun = req.getParameter("pbrdGubun");
		}
		
		if(req.getParameter("BoardGbn") != null) {
			brdGbn = req.getParameter("BoardGbn");
		}
		
		//관리자체크
		//if(userInfo.get) {
		//}
		//관리자면 0
		strAccessCode = "0";
		//사용자면 2
		//strAccessCode = "2";
		
		if(req.getParameter("flag") != null) {
			selectNo = req.getParameter("flag");
		}
		
		model.addAttribute("brdId", brdId);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdGubun", brdGubun);
		model.addAttribute("userId", userInfo.getId());
		model.addAttribute("deptId", userInfo.getDeptID());
		model.addAttribute("deptPathCode", userInfo.getDeptPathCode());
		model.addAttribute("companyId", userInfo.getCompanyID());
		model.addAttribute("strAccessCode", strAccessCode);
		model.addAttribute("selectNo", selectNo);
		model.addAttribute("serverName", req.getServerName());
		return "/ezResource/resLeftResource";
	}
	
	/**
	 * 자원관리 정보 호출 함수
	 */
	@RequestMapping(value = "/ezResource/callNodeTreeData.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callNodeTreeData(@RequestBody String xmlReq,HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String selectFlag = "";
		
		if(req.getParameter("flag") != null) {
			selectFlag = req.getParameter("flag");
		}
		Document xmlDom = commonUtil.convertStringToDocument(xmlReq);

		String ret = getSubClsTree(xmlReq, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId());
		
		xmlDom = null;
		Document xmlRet = commonUtil.convertStringToDocument(ret);
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes = (NodeList)xpath.evaluate("//TREEVIEWDATA/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes1 = (NodeList)xpath.evaluate("//TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);
		if(nodes.getLength() != 0) {
			for(int i=0; i<nodes.getLength(); i++) {
				nodes.item(i).setTextContent("TRUE");
				nodes1.item(i).removeChild((Node)xpath.evaluate("//TREEVIEWDATA/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET));
				
				if(selectFlag == "SELECT_NO") {
					if((Node)xpath.evaluate("//TREEVIEWDATA/NODE/SELECT", xmlRet, XPathConstants.NODESET) != null) {
						NodeList nodes2 = (NodeList) xpath.evaluate("//TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);  
						nodes2.item(i).removeChild((Node)xpath.evaluate("//TREEVIEWDATA/NODE/SELECT", xmlRet, XPathConstants.NODESET));
					}
				}
			}
		}
		
		NodeList nodes3 = (NodeList)xpath.evaluate("//NODES/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes4 = (NodeList)xpath.evaluate("//NODES/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes5 = (NodeList)xpath.evaluate("//NODES/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		if(nodes3.getLength() != 0) {
			for(int i=0; i<nodes3.getLength(); i++) {
				nodes3.item(i).setTextContent("TRUE");
				nodes4.item(i).removeChild((Node) nodes5);
			}
		}
		return commonUtil.convertDocumentToString(xmlRet);
	}
	
	public String getSubClsTree(String xmlStr, String langStr, String pComID, String pDeptID, String pUserID) throws Exception {
		String strParentID = "";
		String strCompanyID = "";
        String strAccessFlag = "";
        String strUserID = "";
        String strDeptPath = "";
        String strFirstNode = "";
        String strTreeType = "";
        String returnXML = "";
   
        //Document xmlRes = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
        strParentID = xmlRes.getElementsByTagName("PARENT_ID").item(0).getTextContent().trim();
        strCompanyID = xmlRes.getElementsByTagName("COMPANY_ID").item(0).getTextContent().trim();
        strAccessFlag = xmlRes.getElementsByTagName("ACCESS_FLAG").item(0).getTextContent().trim();
        strFirstNode = xmlRes.getElementsByTagName("FIRST_NODE").item(0).getTextContent().trim();
        strTreeType = xmlRes.getElementsByTagName("TREE_TYPE").item(0).getTextContent().trim();
        
        if(xmlRes.getElementsByTagName("BRDLIST").getLength() > 5) {
        	strUserID = xmlRes.getElementById("BRDLIST").getChildNodes().item(5).getTextContent().trim();
        	strDeptPath = xmlRes.getElementById("BRDLIST").getChildNodes().item(6).getTextContent().trim();
        	strDeptPath = "'" + strDeptPath.replace("," , "', '")+ "'";
        }
        String strXML = "";
        
        List<ResGetAdmSubClsTreeVO> resGetAdmSubClsTree = new ArrayList<ResGetAdmSubClsTreeVO>();
        if(strAccessFlag == "0") {
        	resGetAdmSubClsTree = ezResourceService.getAdmSubClsTree(strParentID, strCompanyID, strTreeType);
        } else {
        	resGetAdmSubClsTree = ezResourceService.getSubClsTree(strParentID, strCompanyID, strTreeType, strUserID, pComID, pDeptID, pUserID);
        }
        
        for(int i=0; i<resGetAdmSubClsTree.size(); i++) {
        	strXML = commonUtil.getQueryResult(resGetAdmSubClsTree.get(i));	
        }
        
        if(strFirstNode == "Y") {
        	String strTreeStyle = "";
        	strTreeStyle = "<TREEVIEWDATA>" +
        						"<TEXTCOLOR>" +
        						"	<NAME>ENTUMTEXTCOLOR</NAME>" +
        						"	<DEFAULT></DEFAULT>" +
        						"	<DEFAULTTEXTCOLOR>black</DEFAULTTEXTCOLOR>" +
        						"   <DEFAULTBGCOLOR>ffffff</DEFAULTBGCOLOR>" +
        						"   <SELECTEDTEXTCOLOR>164AAD</SELECTEDTEXTCOLOR>" +
        						"   <SELECTEDBGCOLOR>ffffff</SELECTEDBGCOLOR>" +
        						"   <HOTTRACKINGTEXTCOLOR>164AAD</HOTTRACKINGTEXTCOLOR>" +
        						"   <HOTTRACKINGBGCOLOR>ffffff</HOTTRACKINGBGCOLOR>" +
        						"</TEXTCOLOR>" +
        						"<NODEICONIMAGE>" +
        						"    <NAME>RESCLASS</NAME>" +
        						"    <DEFAULT></DEFAULT>" +
        						"    <LEAFDEFAULTICON>/images/left/tree_01.gif</LEAFDEFAULTICON>" +
        						"    <LEAFSELECTEDICON>/images/left/tree_01.gif</LEAFSELECTEDICON>" +
        						"    <BRANCHDEFAULTICON>/images/left/tree_01.gif</BRANCHDEFAULTICON>" +
        						"    <BRANCHSELECTEDICON>/images/left/tree_01.gif</BRANCHSELECTEDICON>" +
        						"</NODEICONIMAGE>" +
        						"<NODEICONIMAGE>" +
        						"    <NAME>RESOURCE</NAME>" +
        						"    <DEFAULT></DEFAULT>" +
        						"    <LEAFDEFAULTICON>/images/left/tree_02.gif</LEAFDEFAULTICON>" +
        						"    <LEAFSELECTEDICON>/images/left/tree_02.gif</LEAFSELECTEDICON>";

        	strTreeStyle = strTreeStyle +
        	"    <BRANCHDEFAULTICON>/images/left/tree_02.gif</BRANCHDEFAULTICON>" +
        	"    <BRANCHSELECTEDICON>/images/left/tree_02.gif</BRANCHSELECTEDICON>" +
        	"</NODEICONIMAGE>" +
        	"<HERITAGEICONIMAGE>" +
        	"    <DEFAULT></DEFAULT>" +
        	"    <BLANKICON>/images/left/blank.gif</BLANKICON>" +
        	"    <VERTICALLINEICON>/images/left/vline.gif</VERTICALLINEICON>" +
        	"    <NODEICON>/images/left/02.gif</NODEICON>" +
        	"    <MNODEICON>/images/left/02_minus.gif</MNODEICON>" +
        	"    <PNODEICON>/images/left/02_plus.gif</PNODEICON>" +
        	"    <ROOTNODEICON>/images/left/03.gif</ROOTNODEICON>" +
        	"    <MROOTNODEICON>/images/left/03_minus.gif</MROOTNODEICON>" +
        	"    <PROOTNODEICON>/images/left/03_plus.gif</PROOTNODEICON>" +
        	"    <LASTNODEICON>/images/left/03.gif</LASTNODEICON>" +
        	"    <MLASTNODEICON>/images/left/03_minus.gif</MLASTNODEICON>" +
        	"    <PLASTNODEICON>/images/left/03_plus.gif</PLASTNODEICON>" +
        	"    <FIRSTROOTNODEICON>/images/left/02.gif</FIRSTROOTNODEICON>" +
        	"    <MFIRSTROOTNODEICON>/images/left/02_minus.gif</MFIRSTROOTNODEICON>" +
        	"    <PFIRSTROOTNODEICON>/images/left/02_plus.gif</PFIRSTROOTNODEICON>" +
        	"</HERITAGEICONIMAGE>";

        	returnXML = strTreeStyle;
        } else {
        	returnXML = "<NODES>";
        }
        
        Document returnXmlDom = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        returnXmlDom = commonUtil.convertStringToDocument(strXML);
        XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes = (NodeList)xpath.evaluate("DATA/ROW", returnXmlDom, XPathConstants.NODESET);
		
        if(strFirstNode == "Y") {
        	for(int i=0; i<nodes.getLength(); i++) {
        		if(i == 0) {
        			 returnXML += makeNodesFromADOFlds(nodes.item(i).getNodeName(), true, langStr);
        		} else {
        			returnXML += makeNodesFromADOFlds(nodes.item(i).getNodeName(), false, langStr);
        		}
        	}
        	returnXML += "</TREEVIEWDATA>";
        } else {
        	for(int i=0; i<nodes.getLength(); i++) {
        		returnXML += makeNodesFromADOFlds(nodes.item(i).getNodeValue(), false, langStr);
        	}
        	returnXML += "</NODES>";
        }
		return returnXML;
	}
	
	public String makeNodesFromADOFlds(String xmlStr, boolean blnFirstNode, String langStr) throws Exception{
		Document xmlRes = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		String returnXML = "";
		String strValue = "";
		String strStyle = "";
        String strData1 = "";
        String strData2 = "";
        String strData3 = "";
        String strData4 = "";
        String strData5 = "";
        String strData6 = "";
        String strData7 = "";
        String strData8 = "";
        String strData9 = "";
        String strData10 = "";
        String strData11 = "";
        String strData12 = "";
        String strData13 = "";
        String strData14 = "";
        String strData15 = "";
        int intSubCnt = 0;
        String strIsLeaf = "";
        String strSetNodeIconByName = "";
        
        xmlRes = commonUtil.convertStringToDocument(xmlStr);
        
        strData1 = xmlRes.getElementById("BRD_ID").getTextContent();
        
        if(langStr == "1") {
        	strData2 = xmlRes.getElementById("BRD_NM").getTextContent();
        } else {
        	strData2 = xmlRes.getElementById("BRD_NM"+langStr).getTextContent();
        }
        strData3 = xmlRes.getElementById("BRD_LEVEL").getTextContent();
        strData4 = xmlRes.getElementById("BRD_STEP").getTextContent();
        strData5 = xmlRes.getElementById("BRD_POSTTERM").getTextContent();
        strData6 = xmlRes.getElementById("BRD_UPPER").getTextContent();
        strData7 = xmlRes.getElementById("BRD_GB").getTextContent();
        strData8 = xmlRes.getElementById("BRD_URL").getTextContent();
        strData9 = xmlRes.getElementById("BRD_EXPLAIN").getTextContent();
        strData10 = xmlRes.getElementById("BRD_ACCESS").getTextContent();
        strData11 = xmlRes.getElementById("ATTACH_SIZE").getTextContent();
        strData12 = xmlRes.getElementById("SUB_CLSCNT").getTextContent();
        strData13 = xmlRes.getElementById("SUB_RESCNT").getTextContent();
        strData14 = xmlRes.getElementById("ACCESS_LVL").getTextContent();
        strData15 = xmlRes.getElementById("APPROVEFLAG").getTextContent();
        
        intSubCnt = Integer.parseInt(strData12.trim()) + Integer.parseInt(strData13.trim());
        strValue = strData2;
        strStyle = "font-weight:normal;height:10px;";
        
        returnXML += "<NODE>";
        returnXML += makeXMLElement(strValue, "VALUE", true);
        returnXML += makeXMLElement(strStyle, "STYLE");
        returnXML += makeXMLElement(strData1, "DATA1");
        returnXML += makeXMLElement(strData2, "DATA2", true);
        returnXML += makeXMLElement(strData3, "DATA3");
        returnXML += makeXMLElement(strData4, "DATA4");
        returnXML += makeXMLElement(strData5, "DATA5");
        returnXML += makeXMLElement(strData6, "DATA6");
        returnXML += makeXMLElement(strData7, "DATA7");
        returnXML += makeXMLElement(strData8, "DATA8", true);
        returnXML += makeXMLElement(strData9, "DATA9", true);
        returnXML += makeXMLElement(strData10, "DATA10", true);
        returnXML += makeXMLElement(strData11, "DATA11");
        returnXML += makeXMLElement(strData12, "DATA12");
        returnXML += makeXMLElement(strData13, "DATA13");
        returnXML += makeXMLElement(strData14, "DATA14");
        returnXML += makeXMLElement(strData15, "DATA15");
        
        if(intSubCnt == 0) {
        	strIsLeaf = "TRUE";
        } else {
        	strIsLeaf = "FALSE";
        }
        
        if(strData7 == "1") {
        	strSetNodeIconByName = "RESCLASS";
        } else {
        	strSetNodeIconByName = "RESOURCE";
        }
        
        returnXML += makeXMLElement(strIsLeaf, "ISLEAF");
        returnXML += makeXMLElement(strSetNodeIconByName, "SETNODEICONBYNAME");
        returnXML += makeXMLElement("FALSE", "EXPANDED");
        
        if(blnFirstNode == true) {
        	returnXML += makeXMLElement("", "SELECT", true);
        }
        returnXML += "</NODE>";
		return returnXML;
	}
	
	public String makeXMLElement(String strElementText, String strElementName, boolean blnCData) {
		if(blnCData == true) {
			return "<"+strElementName+"><!CDATA["+strElementText+"]]></"+strElementName+">";
		} else {
			return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
		}
	}
	
	public String makeXMLElement(String strElementText, String strElementName) {
		return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
	}
	
}
