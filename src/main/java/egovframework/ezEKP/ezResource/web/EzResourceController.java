package egovframework.ezEKP.ezResource.web;

import java.text.SimpleDateFormat;
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
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListTermVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
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
		String brdID = "";
		String brdNm = "";
		String brdTopPath = "";
		String pUrl = "";
		String url = "/ezResource/leftResource.do";
		
		if(req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		
		}
		if(req.getParameter("brdNm") != null) {
			 brdNm = req.getParameter("brdnm");
		}
		
		if(req.getParameter("brdPath") != null) {
			brdTopPath = req.getParameter("brdpath");
		}
		
		if(brdID.equals("")) {
			if(brdTopPath.equals("B")) {
				pUrl = url + "?BoardGbn=" + brdTopPath;
			} else {
				pUrl = url;
			} 
		} else {
			pUrl = url + "?brdID=" + brdID + "&brdNm=" + brdNm + "&boardGbn=M";
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
		String brdID = "";
	    String brdNm = "";
	    String brdGubun = "";
	    //String brdGbn = "";
	    String strAccessCode = "";
	    String selectNo = "";
	    
		if(req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		
		if(req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		
		if(req.getParameter("pbrdGubun") != null) {
			brdGubun = req.getParameter("pbrdGubun");
		}
		
		/*if(req.getParameter("boardGbn") != null) {
			brdGbn = req.getParameter("boardGbn");
		}*/
		
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
		
		model.addAttribute("brdID", brdID);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdGubun", brdGubun);
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("deptPathCode", userInfo.getDeptPathCode());
		model.addAttribute("companyID", userInfo.getCompanyID());
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
		
		String ret = getSubClsTree(xmlReq, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId());
		Document xmlRet = commonUtil.convertStringToDocument(ret);
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes1 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes2 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SELECT", xmlRet, XPathConstants.NODESET);
		NodeList nodes4 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes5 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes6 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes7 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA10", xmlRet, XPathConstants.NODESET);
		
		if(nodes.getLength() != 0) {
			for(int i=0; i<nodes.getLength(); i++) {
				nodes.item(i).setTextContent("TRUE");
				nodes1.item(i).removeChild((Node) nodes4.item(i));
				if(nodes2.item(0).getTextContent().equals("")) {
					nodes2.item(0).setTextContent("<![CDATA[]]>");
				}
				
				if(nodes5.item(i).getTextContent().equals("")) {
					nodes5.item(i).setTextContent("<![CDATA[]]>");
				}
				
				if(nodes6.item(i).getTextContent().equals("")) {
					nodes6.item(i).setTextContent("<![CDATA[]]>");
				}
				
				if(nodes7.item(i).getTextContent().equals("")) {
					nodes7.item(i).setTextContent("<![CDATA[]]>");
				}
				
				if(selectFlag.equals("SELECT_NO")) {
					if(nodes2.getLength() > 0) {
						NodeList nodes3 = (NodeList) xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);  
						nodes3.item(i).removeChild((Node)nodes2.item(0));
					}
				}
			}
		}
		
		return commonUtil.convertDocumentToString(xmlRet).replace("&lt;", "<").replace("&gt;", ">");
	}
	
	/**
	 * 스케줄 정보 호출 함수
	 */
	@ResponseBody
	@RequestMapping(value = "/ezResource/scheduleGet.do")
	public String scheduleGet(@RequestBody String xmlStr,HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String reVal = "";
		String resID = "";
		String cmd = "";
		String type = "";
		String viewType = "";
		String approveFlag = "";
		String writerName = "";
		String writerDept = "";
		String gubun = "P";
		String groupID = "";
		int page = 0;
		
		try {
			if (req.getParameter("resID") != null) {
				resID = req.getParameter("resID");
			}
			if (req.getParameter("cmd") != null) {
				cmd = req.getParameter("cmd");
			}
			if (req.getParameter("pType") != null) {
				type = req.getParameter("pType");
			}
			if (req.getParameter("viewType") != null) {
				viewType = req.getParameter("viewType");
			}
			if (req.getParameter("page") != null) {
				page = Integer.parseInt(req.getParameter("page"));
			}
			
			
			Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
			if (cmd.equals("get")) {
				String startDate = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
				String endDate = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();

				if (viewType.equals("list")) {
					approveFlag = xmlDom.getElementsByTagName("APPROVEFLAG").item(0).getTextContent();
					writerName = xmlDom.getElementsByTagName("WRITERNAME").item(0).getTextContent();
					writerDept = xmlDom.getElementsByTagName("WRITERDEPT").item(0).getTextContent();
				}
			
				if (type.equals("") || type == null) {
					xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate.substring(0, 10));
					xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate.substring(0, 10));
				} else {
					if (type.equals("MAIN")) {
						xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate.substring(0, 10));
						xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate.substring(0, 10));
					} else {
						String startDate1 = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDate.substring(0,10), -1, ""), "yyyyMMdd", "yyyy-MM-dd","");
						String endDate1 = EgovDateUtil.convertDate(EgovDateUtil.addDay(endDate.substring(0,10), 1, ""), "yyyyMMdd", "yyyy-MM-dd","");
						
						xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate1);
						xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate1);
					}
				}
				reVal = getScheduleXML(xmlStr, resID, userInfo.getCompanyID(), groupID, gubun, type, writerName, writerDept);
				
				/*Document xmlDom2 = commonUtil.convertStringToDocument(reVal);
				for (int i=0; i<xmlDom2.getDocumentElement().getChildNodes().getLength(); i++) {
					
				}*/
			}
		} catch (Exception e) {
			 e.printStackTrace();
		}
			return reVal.toString();
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
        
        List<ResGetAdmSubClsTreeVO> resGetAdmSubClsTree = new ArrayList<ResGetAdmSubClsTreeVO>();
        if(strAccessFlag.equals("0")) {
        	resGetAdmSubClsTree = ezResourceService.getAdmSubClsTree(strParentID, strCompanyID, strTreeType);
        } else {
        	resGetAdmSubClsTree = ezResourceService.getSubClsTree(strParentID, strCompanyID, strTreeType, strUserID, pComID, pDeptID, pUserID);
        }

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
        	strTreeStyle.append("<PLASTNODEICON>/images/left/03_plus.gif</PLASTNODEICON>");
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
        
        if(strData7.equals("1")) {
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
			return "<"+strElementName+"><![CDATA["+strElementText+"]]></"+strElementName+">";
		} else {
			return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
		}
	}
	
	public String makeXMLElement(String strElementText, String strElementName) {
		return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
	}
	
	@RequestMapping(value = "/ezResource/viewResList2.do")
	public String viewResList2(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String accessCode = "";
		String brdNm = "";
		int brdCount;
		String useEditor = "";
		
		if(req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		
		if(req.getParameter("accessCode") != null) {
			accessCode = req.getParameter("accessCode");
		}
		
		if(req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		
		String adminFg = getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId()); 
		brdNm = brdNm.replace("chr(38)", "&");
		String childBrd = getItemList(loginCookie,brdID);
		
		List<ResGetItemListVO> list = ezResourceService.getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getLang());
		brdCount = list.size();
		
		for (int i=0; i<brdCount; i++) {
			childBrd += list.get(i).getBrdID() + "/" + list.get(i).getBrdNm() + "/" + list.get(i).getApproveFlag() + ",";
		}
		
		model.addAttribute("childBrd", childBrd);
		model.addAttribute("brdID", brdID);
		model.addAttribute("accessCode", accessCode);
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("brdCount", brdCount);
		model.addAttribute("useEditor", useEditor);
		
		return "/ezResource/resViewResList2";
	}
	
	@RequestMapping(value = "/ezResource/viewResList.do")
	public String viewResList(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		/*String strXML = "";
		String brdID = "";
		String accessCode = "";
		String brdNm = "";
		String sortGbn = "";
		String curPage = "";
		String adminFg = "";
		String chkCtrl = "";
		int pageSize = 15;
		int totalCnt = 0;
		int totalPage = 0;
		int limitLine = 0;
		
		if (req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		if (req.getParameter("accessCode") != null) {
			accessCode = req.getParameter("accessCode");
		}
		if (req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		if (req.getParameter("sortGbn") != null) {
			sortGbn = req.getParameter("sortGbn");
		}
		if (req.getParameter("goToPage") != null) {
			curPage = req.getParameter("goToPage");
		}*/
		
		return "/ezResource/resViewResList";
	}
	
	public String getAdminFlag(String companyID, String brdID, String userID) throws Exception {
		String accessLvl = "";
		try {
			ResGetAdminFlagVO resGetAdminFlag = ezResourceService.getAdminFlag(companyID, brdID, userID);
			String strXML = commonUtil.getQueryResult(resGetAdminFlag);
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
		
			if(xmlDom.getElementsByTagName("ROW") != null) {
				for(int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
					accessLvl = xmlDom.getElementsByTagName("ACCESSLVL").item(i).getTextContent().trim();
				}
			}
		
			if(accessLvl.trim().equals("1")) {
				return "Y";
			} else if(accessLvl.trim().equals("2")) {
				return "U";
			} else {
				return "";
			}
		} catch (Exception e) {
			return "";
		}
	}
	
	public String getItemList(@CookieValue("loginCookie") String loginCookie,String brdID) throws Exception {
		String childBrd = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		List<ResGetItemListVO> list = ezResourceService.getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getLang());
		
		for(int i=0; i<list.size(); i++) {
			childBrd += list.get(i).getBrdID()+"/"+list.get(i).getBrdNm()+"/"+list.get(i).getApproveFlag()+",";
		}
		
		return childBrd;
	}
	
	@SuppressWarnings("deprecation")
	public String getScheduleXML(String xmlStr, String ownerID, String companyID, String groupID, String gubun, String pType, String pWriterName, String pWriterDept) throws Exception {
		StringBuilder returnStr = new StringBuilder();
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			String sDate = xmlRes.getElementsByTagName("STARTDATETIME").item(0).getTextContent().trim();
			String eDate = xmlRes.getElementsByTagName("ENDDATETIME").item(0).getTextContent().trim();
			String app = xmlRes.getElementsByTagName("APP").item(0).getTextContent().trim();
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			String scheRs = getScheduleList(ownerID, companyID, groupID, gubun, sDate, eDate, pType, pWriterName, pWriterDept);
			Document scheRSDom = commonUtil.convertStringToDocument(scheRs);
System.out.println("scheRs:"+scheRs);
			returnStr.append("<root>");
			
			for (int i=0; i<scheRSDom.getElementsByTagName("ROW").getLength(); i++) {
				String num = scheRSDom.getElementsByTagName("num").item(i).getTextContent();
				String pNum = scheRSDom.getElementsByTagName("pnum").item(i).getTextContent();
				String ownerIDStr = scheRSDom.getElementsByTagName("ownerID").item(i).getTextContent();
				String writerIDStr = scheRSDom.getElementsByTagName("writerID").item(i).getTextContent();
				String title = scheRSDom.getElementsByTagName("title").item(i).getTextContent();
				String loc = scheRSDom.getElementsByTagName("location").item(i).getTextContent();
				String startDateTime = scheRSDom.getElementsByTagName("startDate").item(i).getTextContent();
				String endDateTime = scheRSDom.getElementsByTagName("endDate").item(i).getTextContent();
				String reFlag = scheRSDom.getElementsByTagName("reFlag").item(i).getTextContent();
				String gresFlag = scheRSDom.getElementsByTagName("gresFlag").item(i).getTextContent();
				String allDay = scheRSDom.getElementsByTagName("allDay").item(i).getTextContent();
				String writeDay = scheRSDom.getElementsByTagName("writeDay").item(i).getTextContent();
				String jobTitle = "";
				String jobTitle2 = "";
				
				if (pType.equals("") || pType == null) {
					 jobTitle = scheRSDom.getElementsByTagName("jobtitle").item(i).getTextContent();
					 jobTitle2 = scheRSDom.getElementsByTagName("jobtitle2").item(i).getTextContent();
				}
				if (app.equals("0")) {
					returnStr.append("<appointment>");
					
					returnStr.append("<dtstart>"+EgovDateUtil.convertDate(startDateTime, "yyyyMMdd", "yyyy-MM-dd HH:mm:ss","")+"</dtstart>");
					returnStr.append("<dtend>"+EgovDateUtil.convertDate(endDateTime, "yyyyMMdd", "yyyy-MM-dd HH:mm:ss","")+"</dtend>");
					returnStr.append("<alldayevent>"+allDay+"</alldayevent>");
					
					String timeDisplay = scheRSDom.getElementsByTagName("timeDisplay").item(i).getTextContent(); 
					if (timeDisplay.equals("1")) {
						timeDisplay = "Busy";
					} else if (timeDisplay.equals("2")) {
						timeDisplay = "Tentative";
					} else if (timeDisplay.equals("3")) {
						timeDisplay = "OOF";
					} else if (timeDisplay.equals("4")) {
						timeDisplay = "Free";
					} else {
						timeDisplay = "";
					}
					returnStr.append("<busystatus>"+timeDisplay+"</busystatus>");
					returnStr.append("</appointment>");
				} else {
					returnStr.append("<appointment>");
					returnStr.append("<number>" + num + "</number>");
					
					if (pNum.equals("Null") || pNum.equals("NULL")) {
						pNum = "";
					}
					returnStr.append("<pnumber>" + pNum + "</pnumber>");
					returnStr.append("<owner_id>" + ownerIDStr + "</owner_id>");
					
					if (writerIDStr.equals("Null") || writerIDStr.equals("NULL")) {
						writerIDStr = "";
					}
					returnStr.append("<writer_id>" + writerIDStr + "</writer_id>");
					
					if (title.equals("Null") || title.equals("NULL")) {
						title = "";
					}
					returnStr.append("<subject><![CDATA[" + title + "]]></subject>");
					returnStr.append("<instancetype>" + reFlag + "</instancetype>");
					
					if (loc.equals("Null") || loc.equals("NULL")) {
						loc = "";
					}
					returnStr.append("<location><![CDATA[" + loc + "]]></location>");
					returnStr.append("<dtstart>"+EgovDateUtil.convertDate(startDateTime, "yyyyMMdd", "yyyy-MM-dd HH:mm:ss","")+"</dtstart>");
					returnStr.append("<dtend>"+EgovDateUtil.convertDate(endDateTime, "yyyyMMdd", "yyyy-MM-dd HH:mm:ss","")+"</dtend>");
					returnStr.append("<dstartTime>"+(format.parse(startDateTime).getHours()*60 +format.parse(startDateTime).getMinutes())+"</dstartTime>");
					returnStr.append("<dendTime>"+(format.parse(endDateTime).getHours()*60 +format.parse(endDateTime).getMinutes())+"</dendTime>");
					returnStr.append("<dsDaytype>"+(int)format.parse(startDateTime).getDay()+"</dsDaytype>");
					returnStr.append("<deDaytype>"+(int)format.parse(endDateTime).getDay()+"</deDaytype>");
					returnStr.append("<alldayevent>"+ allDay +"</alldayevent>");
					
					String timeDisplay = scheRSDom.getElementsByTagName("timeDisplay").item(i).getTextContent();
					
					if (timeDisplay.equals("1")) {
						timeDisplay = "Busy";
					} else if (timeDisplay.equals("2")) {
						timeDisplay = "Tentative";
					} else if (timeDisplay.equals("3")) {
						timeDisplay = "OOF";
					} else if (timeDisplay.equals("4")) {
						timeDisplay = "Free";
					} else {
						timeDisplay = "";
					}
					returnStr.append("<busystatus>"+ timeDisplay +"</busystatus>");
					if (gresFlag.equals("Null") || gresFlag.equals("NULL")) {
						gresFlag = "";
					}
					returnStr.append("<groupflag>"+ gresFlag +"</groupflag>");
					returnStr.append("<gubunFlag>"+ gubun +"</gubunFlag>");
					returnStr.append("<importance>"+ scheRSDom.getElementsByTagName("importance").item(i).getTextContent() +"</importance>");
					returnStr.append("<approveFlag>"+ scheRSDom.getElementsByTagName("approveFlag").item(i).getTextContent() +"</approveFlag>");
					returnStr.append("<owner_nm><![CDATA[" + scheRSDom.getElementsByTagName("owner_nm").item(i).getTextContent() + "]]></owner_nm>");
					returnStr.append("<dept_name><![CDATA[" + scheRSDom.getElementsByTagName("dept_name").item(i).getTextContent() + "]]></dept_name>");
					returnStr.append("<writeDay>"+ writeDay +"</writeDay>");
					
					if (pType.equals("") || pType == null) {
						returnStr.append("<owner_nm2><![CDATA[" + scheRSDom.getElementsByTagName("owner_nm2").item(i).getTextContent() + "]]></owner_nm2>");
						returnStr.append("<dept_name2><![CDATA[" + scheRSDom.getElementsByTagName("dept_name2").item(i).getTextContent() + "]]></dept_name2>");
						returnStr.append("<jobtitle><![CDATA[" +jobTitle + "]]></jobtitle>");
						returnStr.append("<jobtitle2><![CDATA[" + jobTitle2 + "]]></jobtitle2>");
					}
					returnStr.append("</appointment>");
				}
			}
			returnStr.append("</root>");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnStr.toString();
	}
	
	public String getScheduleList(String ownerID, String companyID, String groupID, String gubun, String sDate, String eDate, String pType, String pWriterName, String pWriterDept) throws Exception {
		StringBuilder returnStr = new StringBuilder();
		String reCompanyID = "";
		String reOwnerID = "";
		String reNum = "";
		try {
			returnStr.append("<DATA>");
			String todayStartStr = "";
			String todayEndStr = "";
			if (pType.equals("MAIN")) {
				todayStartStr = eDate + " 23:59:59";
				todayEndStr = sDate + " 00:00:01";
			} else {
				todayStartStr = eDate + " 00:00:01";
				todayEndStr = sDate;
			}
			String returnSchedule = "";
			try {
				if (pType.equals("")) {
					List<ResGetScheduleListVO> getScheduleList = ezResourceService.getScheduleList(ownerID, companyID, todayStartStr, todayEndStr, pWriterName, pWriterDept);
					for (int i=0; i<getScheduleList.size(); i++) {
						returnSchedule += commonUtil.getQueryResult(getScheduleList.get(i));
					}
					
				} else if (pType.equals("MAIN")) {
	
					List<ResGetScheduleListMainVO> getScheduleListMain = ezResourceService.getScheduleListMain(ownerID, companyID, todayStartStr, todayEndStr);

					for (int i=0; i<getScheduleListMain.size(); i++) {
						returnSchedule += commonUtil.getQueryResult(getScheduleListMain.get(i));
					}
				}
			
				Document returnDom1 = commonUtil.convertStringToDocument(returnSchedule);
				
				if (returnDom1 != null) {
					for (int m=0; m<returnDom1.getElementsByTagName("ROW").getLength(); m++) {
						returnStr.append("<ROW>");
						returnStr.append("<num>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(0).getTextContent()+"</num>");
						returnStr.append("<pnum>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(1).getTextContent()+"</pnum>");
						returnStr.append("<ownerID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(2).getTextContent()+"</ownerID>");
						returnStr.append("<title><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(3).getTextContent()+"]]></title>");
						returnStr.append("<location><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(4).getTextContent()+"]]></location>");
						returnStr.append("<timeDisplay><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(5).getTextContent()+"]]></timeDisplay>");
						returnStr.append("<startDate>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(6).getTextContent()+"</startDate>");
						returnStr.append("<endDate>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(7).getTextContent()+"</endDate>");
						returnStr.append("<alertTime>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(8).getTextContent()+"</alertTime>");
						returnStr.append("<reFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(9).getTextContent()+"</reFlag>");
						returnStr.append("<gresFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(10).getTextContent()+"</gresFlag>");
						returnStr.append("<writerID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(11).getTextContent()+"</writerID>");
						returnStr.append("<content><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(12).getTextContent()+"]]></content>");
						returnStr.append("<importance>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(13).getTextContent()+"</importance>");
						returnStr.append("<entryList>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(14).getTextContent()+"</entryList>");
						returnStr.append("<allDay>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(15).getTextContent()+"</allDay>");
						returnStr.append("<writeDay>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(16).getTextContent()+"</writeDay>");
						returnStr.append("<attachFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(17).getTextContent()+"</attachFlag>");
						returnStr.append("<characterID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(18).getTextContent()+"</characterID>");
						returnStr.append("<approveFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(19).getTextContent()+"</approveFlag>");
						returnStr.append("<owner_nm><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(20).getTextContent()+"]]></owner_nm>");
						returnStr.append("<dept_name><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(21).getTextContent()+"]]></dept_name>");
						if (pType.equals("")) {
							returnStr.append("<owner_nm2><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(21).getTextContent()+"]]></owner_nm2>");
							returnStr.append("<dept_name2><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(22).getTextContent()+"]]></dept_name2>");
							returnStr.append("<jobtitle><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(23).getTextContent()+"]]></jobtitle>");
							returnStr.append("<jobtitle2><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(24).getTextContent()+"]]></jobtitle2>");
						}
						returnStr.append("</ROW>");
					}
					
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			String returnRepetition = "";
			
			if (pType.equals("")) {
				List<ResGetScheduleListVO> getScheduleListRept= ezResourceService.getScheduleListRepetiti(ownerID, companyID, todayStartStr, todayEndStr, pWriterName, pWriterDept);
				returnRepetition += commonUtil.getQueryResult(getScheduleListRept);
			} else {
				List<ResGetScheduleListMainVO> getScheduleListReptMain = ezResourceService.getScheduleListRepetitim(ownerID, companyID, todayStartStr);

				returnRepetition = "<DATA>";
				for(int j=0; j<getScheduleListReptMain.size(); j++) {
					returnRepetition += commonUtil.getQueryResult(getScheduleListReptMain.get(j));
				}
				returnRepetition += "</DATA>";
			}
			
			Document returnRepetitionDom = commonUtil.convertStringToDocument(returnRepetition);

			if (returnRepetitionDom != null) {
				for (int i=0; i<returnRepetitionDom.getElementsByTagName("ROW").getLength(); i++) {
					 reCompanyID = returnRepetitionDom.getElementsByTagName("COMPANYID").item(i).getTextContent();
					 reNum = returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent();
					 reOwnerID = returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent();
					
					String returnRepDateTimes = getRepDeteTimes(reCompanyID, reNum, reOwnerID, sDate, eDate);
	System.out.println("returnRepDateTimes:"+returnRepDateTimes);
					if (!returnRepDateTimes.trim().equals("")) {
						Document returnRepDateTimesDom = commonUtil.convertStringToDocument(returnRepDateTimes);

						for (int j=0; j<returnRepDateTimesDom.getElementsByTagName("f_sDate").getLength(); j++) {
							String fSDate = returnRepDateTimesDom.getElementsByTagName("f_sDate").item(j).getTextContent().substring(0, 8);
							String fEDate = returnRepDateTimesDom.getElementsByTagName("f_eDate").item(j).getTextContent().substring(0, 8);
							
							ResGetScheduleListTermVO getScheduleListTerm = ezResourceService.getScheduleListTerm(Integer.parseInt(reNum), companyID, reOwnerID, fSDate.substring(0,  8)+" 23:59:59", fEDate, pWriterName, pWriterDept);
							
							if (getScheduleListTerm != null) {
								if (!getScheduleListTerm.getReFlag().equals("4")) {
									String reStartDate = getScheduleListTerm.getStartDate().substring(11, 19);
									String reEndDate = getScheduleListTerm.getEndDate().substring(11, 19);
									
									String reSDate = fSDate + reStartDate;
									String reEDate = fEDate + reEndDate;
									
									returnStr.append("<ROW>");
									returnStr.append("<num>" + getScheduleListTerm.getNum() + "</num>");
									returnStr.append("<pnum>" + getScheduleListTerm.getpNum() + "</pnum>");
									returnStr.append("<ownerID>" + getScheduleListTerm.getOwnerID() + "</ownerID>");
									returnStr.append("<title>" + getScheduleListTerm.getTitle() + "</title>");
									returnStr.append("<location>" + getScheduleListTerm.getLocation() + "</location>");
									returnStr.append("<timeDisplay>" + getScheduleListTerm.getTimeDisplay() + "</timeDisplay>");
									returnStr.append("<startDate>" + reSDate + "</startDate>");
									returnStr.append("<endDate>" + reEDate + "</endDate>");
									returnStr.append("<alertTime>" + getScheduleListTerm.getAlertTime() + "</alertTime>");
									returnStr.append("<reFlag>" + getScheduleListTerm.getReFlag() + "</reFlag>");
									returnStr.append("<gresFlag>" + getScheduleListTerm.getgResFlag() + "</gresFlag>");
									returnStr.append("<writerID>" + getScheduleListTerm.getWriterID() + "</writerID>");
									returnStr.append("<content>" + getScheduleListTerm.getContent() + "</content>");
									returnStr.append("<importance>" + getScheduleListTerm.getImportance() + "</importance>");
									returnStr.append("<entryList>" + getScheduleListTerm.getEntryList() + "</entryList>");
									returnStr.append("<allDay>" + getScheduleListTerm.getAllDay() + "</allDay>");
									returnStr.append("<writeDay>" + getScheduleListTerm.getWriteDay() + "</writeDay>");
									returnStr.append("<attachFlag>" + getScheduleListTerm.getAttachFlag() + "</attachFlag>");
									returnStr.append("<characterID>" + getScheduleListTerm.getCharacterID() + "</characterID>");
									returnStr.append("<approveFlag>" + getScheduleListTerm.getApproveFlag() + "</approveFlag>");
									returnStr.append("<owner_nm>" + getScheduleListTerm.getOwnerNm() + "</owner_nm>");
									returnStr.append("<dept_name>" + getScheduleListTerm.getDeptNm() + "</dept_name>");
									
									if (pType.equals("") || pType == null) {
										returnStr.append("<jobtitle>" + getScheduleListTerm.getJobTitle() + "</jobtitle>");
										returnStr.append("<jobtitle2>" + getScheduleListTerm.getJobTitle2() + "</jobtitle2>");
									}
									returnStr.append("</ROW>");
								}
							} else {
								returnStr.append("<ROW>");
								returnStr.append("<num>" + returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent() + "</num>");
								returnStr.append("<pnum>" + returnRepetitionDom.getElementsByTagName("PNUM").item(i).getTextContent() + "</pnum>");
								returnStr.append("<ownerID>" + returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent() + "</ownerID>");
								returnStr.append("<title>" + returnRepetitionDom.getElementsByTagName("TITLE").item(i).getTextContent() + "</title>");
								returnStr.append("<location>" + returnRepetitionDom.getElementsByTagName("LOCATION").item(i).getTextContent() + "</location>");
								returnStr.append("<timeDisplay>" + returnRepetitionDom.getElementsByTagName("TIMEDISPLAY").item(i).getTextContent() + "</timeDisplay>");
								returnStr.append("<startDate>" + returnRepetitionDom.getElementsByTagName("STARTDATE").item(i).getTextContent() + "</startDate>");
								returnStr.append("<endDate>" + returnRepetitionDom.getElementsByTagName("ENDDATE").item(i).getTextContent() + "</endDate>");
								returnStr.append("<alertTime>" + returnRepetitionDom.getElementsByTagName("ALERTTIME").item(i).getTextContent() + "</alertTime>");
								returnStr.append("<reFlag>" + returnRepetitionDom.getElementsByTagName("REFLAG").item(i).getTextContent() + "</reFlag>");
								returnStr.append("<gresFlag>" + returnRepetitionDom.getElementsByTagName("GRESFLAG").item(i).getTextContent() + "</gresFlag>");
								returnStr.append("<writerID>" + returnRepetitionDom.getElementsByTagName("WRITERID").item(i).getTextContent() + "</writerID>");
								returnStr.append("<content>" + returnRepetitionDom.getElementsByTagName("CONTENT").item(i).getTextContent() + "</content>");
								returnStr.append("<importance>" + returnRepetitionDom.getElementsByTagName("IMPORTANCE").item(i).getTextContent() + "</importance>");
								returnStr.append("<entryList>" + returnRepetitionDom.getElementsByTagName("ENTRYLIST").item(i).getTextContent() + "</entryList>");
								returnStr.append("<allDay>" + returnRepetitionDom.getElementsByTagName("ALLDAY").item(i).getTextContent() + "</allDay>");
								returnStr.append("<writeDay>" + returnRepetitionDom.getElementsByTagName("WRITEDAY").item(i).getTextContent() + "</writeDay>");
								returnStr.append("<attachFlag>" + returnRepetitionDom.getElementsByTagName("ATTACHFLAG").item(i).getTextContent() + "</attachFlag>");
								returnStr.append("<characterID>" + returnRepetitionDom.getElementsByTagName("CHARACTERID").item(i).getTextContent() + "</characterID>");
								returnStr.append("<approveFlag>" + returnRepetitionDom.getElementsByTagName("APPROVEFLAG").item(i).getTextContent() + "</approveFlag>");
								returnStr.append("<owner_nm>" + returnRepetitionDom.getElementsByTagName("OWNERNM").item(i).getTextContent() + "</owner_nm>");
								returnStr.append("<dept_name>" + returnRepetitionDom.getElementsByTagName("DEPTNM").item(i).getTextContent() + "</dept_name>");
								if (pType.equals("") || pType == null) {
									returnStr.append("<owner_nm2>" + returnRepetitionDom.getElementsByTagName("OWNERNM2").item(i).getTextContent() + "</owner_nm2>");
									returnStr.append("<dept_name2>" + returnRepetitionDom.getElementsByTagName("DEPTNM2").item(i).getTextContent() + "</dept_name2>");
									returnStr.append("<jobtitle>" + returnRepetitionDom.getElementsByTagName("JOBTITLE").item(i).getTextContent() + "</jobtitle>");
									returnStr.append("<jobtitle2>" + returnRepetitionDom.getElementsByTagName("JOBTITLE2").item(i).getTextContent() + "</jobtitle2>");
								}
								returnStr.append("</ROW>");
							}
						}
					}
				}
			}
			returnStr.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnStr.toString();
	}
	
	public String getRepDeteTimes(String companyID, String num, String ownerID, String sDate, String eDate) throws Exception {
		String returnStr = "";
		try {
			ResGetRepDateTimesVO getRepDateTimes = ezResourceService.getRepDateTimes(ownerID, companyID, Integer.parseInt(num));
			if (getRepDateTimes != null) {
				String startDateTime = getRepDateTimes.getStartDateTime();
				String endDateTime = getRepDateTimes.getEndDateTime();
	System.out.println("startDateTime:"+startDateTime);
	System.out.println("endDateTime:"+endDateTime);
				
				startDateTime = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "", "");
				endDateTime = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "", "");
System.out.println("reYoil:" + getRepDateTimes.getReYoil());
				String reWay = getRepDateTimes.getReWay();
				String reDay = getRepDateTimes.getReDay();
				String reNum = getRepDateTimes.getReNum();
				String reYoil = getRepDateTimes.getReYoil();
				String reMonth = getRepDateTimes.getReMonth();
				String reOrd = getRepDateTimes.getReOrd();
				String endFlag = getRepDateTimes.getEndFlag();
				String reCount = getRepDateTimes.getReCount();
				
				String freq = reWay.substring(0, 1);
				String sel = reWay.substring(reWay.length()-1, 1);
				
				if (reNum.equals("Null") || reNum.equals("NULL")) {
					reNum = "";
				}
				
				if (reYoil.equals("Null") || reYoil.equals("NULL")) {
					reYoil = "";
				}
				
				if (reDay.equals("Null") || reDay.equals("NULL")) {
					reDay = "";
				}
				
				if (reMonth.equals("Null") || reMonth.equals("NULL")) {
					reMonth = "";
				}
				
				if (reCount.equals("Null") || reCount.equals("NULL")) {
					reCount = "";
				}
				
				StringBuilder reXMLStr = new StringBuilder();
				reXMLStr.append("<recurrence>");
				reXMLStr.append("<frequency>"+freq+"</frequency>");
				reXMLStr.append("<selType>"+sel+"</selType>");
				reXMLStr.append("<endRecurType>"+endFlag+"</endRecurType>");
				reXMLStr.append("<startDateTime>"+startDateTime+"</startDateTime>");
				reXMLStr.append("<endDateTime>"+endDateTime+"</endDateTime>");
				reXMLStr.append("<interval>"+reNum+"</interval>");
				reXMLStr.append("<daysOfWeek>"+reYoil+"</daysOfWeek>");
				reXMLStr.append("<daysOfMonth>"+reDay+"</daysOfMonth>");
				reXMLStr.append("<byPosition>"+reOrd+"</byPosition>");
				reXMLStr.append("<monthsOfYear>"+reMonth+"</monthsOfYear>");
				reXMLStr.append("<instances>"+reCount+"</instances>");
				reXMLStr.append("</recurrence>");
	System.out.println("freq:"+freq);
	System.out.println("reXMLStr:"+reXMLStr.toString());
				if (freq.equals("4")) {
					returnStr = getDailyRepDateTimes(reXMLStr.toString(), sDate, eDate); 
				} else if (freq.equals("5")) {
					returnStr = getWeeklyRepDateTime(reXMLStr.toString(), sDate, eDate);
				} else if (freq.equals("6")) {
					returnStr = getMonthlyRepDateTimes(reXMLStr.toString(), sDate, eDate);
				} else if (freq.equals("7")) {
					returnStr = getYearlyRepDateTimes(reXMLStr.toString(), sDate, eDate);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnStr.toString();
	}
	
	public String getDailyRepDateTimes(String xmlStr, String sDate, String eDate) {
		StringBuilder returnXML = new StringBuilder();
		
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent().trim();
			String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
			String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
			String interval2 = xmlRes.getElementsByTagName("interval").item(0).getTextContent().trim();
			int interval = Integer.parseInt(interval2);
			String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
			String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			
			String tmpSTime = startDateTime.substring(11, 19);
			String tmpETime = endDateTime.substring(11, 19);
			
			String tmpDTStr = startDateTime.substring(0, 10);
			String tmpEDTStr = startDateTime.substring(0, 10);
			
			String tmpSDTStr = tmpDTStr;
			String tmpEDTStr1 = tmpEDTStr;
			
			if (number(tmpSTime) > number(tmpETime)) {
				startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, ""), "yyyy-MM-dd HH:mm:ss", "", "");
				tmpSDTStr = startDateTime.substring(0, 10);
			}
			
			String orgTmpDTStr = tmpDTStr;
			
			int n = 1;
			
			
			returnXML.append("<DATA>");
			
			int temp = 0;
			boolean whileFlag = true;
			while (whileFlag) {
				if (selType.equals("0")) {
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
							
							if (number(tmpDTStr) >= number(orgTmpDTStr)) {
								n = n+1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) >= number(orgTmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
					}
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, interval, ""), "", "", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, interval, ""), "", "", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, interval, ""), "", "", "");
				} else {
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7) {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7) {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
							
							if (number(tmpDTStr) >= number(orgTmpDTStr)) {
								n = n+1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
							break;
						} else if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7) {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					}
					
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				}
				temp++;
				if (temp > 1000) {
					break;
				}
			}
			returnXML.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnXML.toString();
	}
	
	public String getWeeklyRepDateTime (String xmlStr, String sDate, String eDate) {
		StringBuilder returnXML = new StringBuilder();
		
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			
			
			String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
			String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
			String interval2 = xmlRes.getElementsByTagName("interval").item(0).getTextContent().trim();
			int interval = Integer.parseInt(interval2);
			String daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent().trim();
			String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
			String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			
			String tmpSTime = startDateTime.substring(11, 19);
			String tmpETime = endDateTime.substring(11, 19);
			
			String tmpDTStr = startDateTime.substring(0, 10);
			String tmpEDTStr = endDateTime.substring(0, 10);
			
			String tmpSDTStr = tmpDTStr;
			String tmpEDTStr1 = tmpEDTStr;
			
			if (number(tmpSTime) > number(tmpETime)) {
				startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, ""), "", "", "");
				tmpSDTStr = startDateTime.substring(0, 10);
			}
			
			boolean isFirst = true;
			String orgTmpDTStr = tmpDTStr;
			String selDTStr = "";
			int temp = 0;
			int temp2 = 0;
			int n = 1;
			String[] wDay;
			wDay = daysOfWeek.split(",");
			int wDayCnt = wDay.length;
			
			returnXML.append("<DATA>");
			
			boolean whileFlag = true;
			while (whileFlag) {
				selDTStr = tmpDTStr;
				boolean secondWhileFlag = true;
				while (secondWhileFlag == true) {
					for (int i=0; i<wDayCnt; i++) {
						if (wDay[i].equals("")) {
							wDay[i] = "0";
						}
						if (orgTmpDTStr.equals(selDTStr) && weekDay(tmpDTStr) == Integer.parseInt(wDay[i] + 1) && isFirst == true) {
							isFirst = false;
							secondWhileFlag = false;
							break;
						} else if (weekDay(tmpDTStr) < Integer.parseInt(wDay[i]) + 1 || !selDTStr.equals(tmpDTStr)) {
							int tmpWeekDay = weekDay(tmpDTStr);
							
							/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(Integer.parseInt(wDay[i]) + 1 - weekDay(tmpDTStr)).toString();
							tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(Integer.parseInt(wDay[i]) + 1 - tmpWeekDay).toString();
							tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(Integer.parseInt(wDay[i]) + 1 - tmpWeekDay).toString();*/
							
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, Integer.parseInt(wDay[i]) + 1 - weekDay(tmpDTStr), ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, ""), "yyyyMMdd", "yyyyMMdd", "");
							
							secondWhileFlag = false;
							break;
						}
					}
					if (secondWhileFlag == false) {
						break;
					}
					/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(interval * 7).toString();
					tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(interval * 7).toString();
					tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(interval * 7).toString();
					*/
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (interval * 7), ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (interval * 7), ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (interval * 7), ""), "yyyyMMdd", "yyyyMMdd", "");
					
					if (weekDay(tmpDTStr) != 1) {
						int tmpWeekDay = weekDay(tmpDTStr);
						
					/*	tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1 - weekDay(tmpDTStr)).toString();
						tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(1 - tmpWeekDay).toString();
						tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(1 - tmpWeekDay).toString();*/
						
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (1- weekDay(tmpDTStr)), ""), "yyyyMMdd", "yyyyMMdd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (1 - tmpWeekDay), ""), "yyyyMMdd", "yyyyMMdd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (1 - tmpWeekDay), ""), "yyyyMMdd", "yyyyMMdd", "");
					}
					for (int i=0; i<wDayCnt; i++) {
						if (wDay[i].equals("")) {
							wDay[i] = "0";
						}
						if (weekDay(tmpDTStr) != (Integer.parseInt(wDay[i]) + 1)) {
							int tmpWeekDay = weekDay(tmpDTStr);
							
							/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(Integer.parseInt(wDay[i]) + 1 - weekDay(tmpDTStr)).toString();
							tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(Integer.parseInt(wDay[i]) + 1 - tmpWeekDay).toString();
							tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(Integer.parseInt(wDay[i]) + 1 - tmpWeekDay).toString();*/
							
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, Integer.parseInt(wDay[i]) + 1 - weekDay(tmpDTStr), ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, ""), "yyyyMMdd", "yyyyMMdd", "");
						}
					}
					temp2 ++;
					if (temp2 > 1000) {
						break;
					}
				}
				
				if (endRecurType.equals("0")) {
					if (number(tmpDTStr) > number(eDate)) {
						break;
					} else {
						if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
					}
				} else if (endRecurType.equals("1")) {
					if (number(tmpDTStr) > number(eDate) || n > number(instances) * (wDayCnt-1)) {
						break;
					} else {
						if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
						
						if (number(tmpDTStr) >= number(orgTmpDTStr)) {
							n = n +1;
						}
					}
				} else if (endRecurType.equals("2")) {
					if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
						break;
					} else  {
						if ((number(tmpDTStr) > number(eDate) || number(tmpDTStr) >= number(orgTmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1))) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
					}
				}
				temp++;
				if (temp > 1000) {
					break;
				}
			}
			returnXML.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnXML.toString();
	}
	
	@SuppressWarnings("deprecation")
	public String getMonthlyRepDateTimes(String xmlStr, String sDate, String eDate) {
		StringBuilder returnXML = new StringBuilder();
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			
			String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent().trim();
			String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
			String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
			String daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent().trim();
			if (daysOfWeek.equals("")) {
				daysOfWeek = "0";
			}
			String daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent().trim();
			String byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent().trim();
			String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
			String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			String[] wDay = daysOfWeek.split(",");
			String tmpSTime = startDateTime.substring(11, 19);
			String tmpETime = endDateTime.substring(11, 19);
			String tmpDTStr = startDateTime.substring(0, 10);
			String tmpEDTStr = startDateTime.substring(0, 10);
			String tmpSDTStr = tmpDTStr;
			String tmpEDTStr1 = tmpEDTStr;
			
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
			
			if (number(tmpSTime) > number(tmpETime)) {
				startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, ""), "", "", "");
				tmpSDTStr = startDateTime.substring(0, 10);
			}
			String orgtmpDTStr = tmpDTStr;
			int n = 1;
			returnXML.append("<DATA>");
			
			int temp = 0;
			boolean whileFlag = true;
			while(whileFlag) {
				int wDayCnt = wDay.length;
				if (wDayCnt != 0) {
					wDayCnt = wDayCnt - 1;
				}
				if (daysOfWeek.indexOf(",") < 0) {
					wDayCnt = 0;
				}
				if (selType.equals("0")) {
					int datePartDay = format.parse(tmpDTStr).getDate();
					int datePartMonth = format.parse(tmpDTStr).getMonth();
					int datePartYear = format.parse(tmpDTStr).getYear();
					boolean checkLastDate = true;
					
					if (daysOfMonth.equals("31") && (datePartMonth == 2 || datePartMonth == 4 || datePartMonth == 6 || datePartMonth == 9 || datePartMonth == 11)) {
						checkLastDate = false;
					} else if (daysOfMonth.equals("30") && datePartMonth == 2) {
						checkLastDate = false;
					} else if (daysOfMonth.equals("29") && datePartMonth == 2 && !(datePartYear % 4 == 0 && datePartYear % 100 != 0 || datePartYear % 400 == 0)) {
						checkLastDate = false;
					}
					
					if (checkLastDate) {
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, Integer.parseInt(daysOfMonth) - datePartDay, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, Integer.parseInt(daysOfMonth) - datePartDay, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, Integer.parseInt(daysOfMonth) - datePartDay, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						
						if (endRecurType.equals("0")) {
							if (number(tmpDTStr) > number(eDate)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						} else if (endRecurType.equals("1")) {
							if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
								
								if (number(tmpDTStr) >= number(orgtmpDTStr)) {
									n = n+1;
								}
							}
						} else if (endRecurType.equals("2")) {
							if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					}
				} else {
					int count = 1;
					int datePartDay = format.parse(tmpDTStr).getDate();
					
					/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1 - datePartDay).toString();
					tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(1 - datePartDay).toString();
					tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(1 - datePartDay).toString();*/
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1 - datePartDay, ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1 - datePartDay, ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1 - datePartDay, ""), "yyyyMMdd", "yyyyMMdd", "");
					
					String sTmpDTStr = tmpDTStr;
					
					if (!byPosition.equals("-1")) {
						while (true) {
							if (wDayCnt == 0) {
								if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
									break;
								}
							} else if (wDayCnt == 2) {
								if (weekDay(tmpDTStr) == 7) {
									break;
								}
							} else {
								if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7) {
									if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 6) {
										break;
									}
								} else {
									if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
										break;
									}
								}
							}
							count ++;
							
						/*	tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();
							tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(1).toString();
							tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(1).toString();*/
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							
						}
						if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7 && wDayCnt == 5) {
							tmpDTStr = sTmpDTStr;
							wDayCnt = count;
						}
						
						if (!byPosition.equals("1")) {
							if (wDayCnt == 5) {
								if (format.parse(tmpDTStr).getDate() == 1) {
									/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();*/
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
								} else {
									if (weekDay(sTmpDTStr) == 1 || weekDay(sTmpDTStr) == 7) {
										/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();*/
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									} else {
										/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -2) * 7).toString();*/
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -2) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									}
								}
							} 
						} else {
						/*	tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();
							tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();
							tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();*/
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						}
					} else {
						int count1 = 1;
						/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusMonths(1).toString();
						tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();*/
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						
						int tmpWeekDay = weekDay(tmpDTStr);
						
						while (true) {
							if (wDayCnt == 0) {
								if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
									break;
								}
							} else if (wDayCnt == 2) {
								if (weekDay(tmpDTStr) == 7) {
									break;
								}
							} else {
								if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
									break;
								}
							}
							count1++;
							
						/*	tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();
							tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(1).toString();
							tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(1).toString();*/
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						}
						if (wDayCnt == 2) {
							if (tmpWeekDay == 7) {
								wDayCnt = 0;
							}
						} else if (wDayCnt == 5) {
							if (tmpWeekDay == 1 || tmpWeekDay == 7) {
								wDayCnt = 5;
							} else {
								wDayCnt = count1;
							}
						}
					}
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString(); */
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									}
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();*/
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									}
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
							if (number(tmpDTStr) >= number(orgtmpDTStr)) {
								n = n + 1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr1)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
									/*	tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();*/
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									}
									
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
									
									if (tmpDTStr.equals(tmpEDTStr1)) {
										break;
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					}
				}
				/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(interval).toString();
				tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(interval).toString();
				tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(interval).toString();*/
				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				
				temp++;
				if (temp > 1000) {
					break;
				}
			}
			returnXML.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnXML.toString();
	}
	
	@SuppressWarnings("deprecation")
	public String getYearlyRepDateTimes (String xmlStr, String sDate, String eDate) {
		StringBuilder returnXML = new StringBuilder();
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			
			String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent().trim();
			String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
			String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
			String daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent().trim();
			String daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent().trim();
			String byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent().trim();
			String monthsOfYear = xmlRes.getElementsByTagName("monthsOfYear").item(0).getTextContent().trim();
			String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
			String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			String[] wDay = daysOfWeek.split(",");
			String tmpSTime = startDateTime.substring(11, 19);
			String tmpETime = endDateTime.substring(11, 19);
			String tmpDTStr = startDateTime.substring(0, 10);
			String tmpEDTStr = startDateTime.substring(0, 10);
			String tmpSDTStr = tmpDTStr;
			String tmpEDTStr1 = tmpEDTStr;
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			if (number(tmpSTime) > number(tmpETime)) {
				startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, ""), "", "", "");
				tmpSDTStr = startDateTime.substring(0, 10);
			}
			String orgtmpDTStr = tmpDTStr;
			int n = 1;
			returnXML.append("<DATA>");
			
			int temp = 0;
			boolean whileFlag = true;
			while(whileFlag) {
				int wDayCnt = wDay.length;
				if (wDayCnt != 0) {
					wDayCnt = wDayCnt - 1;
				}
				if (daysOfWeek.indexOf(",") < 0) {
					wDayCnt = 0;
				}
				
				int datePartMonth = format.parse(tmpDTStr).getMonth();
				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpDTStr,(Integer.parseInt(monthsOfYear) - datePartMonth), ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpEDTStr,(Integer.parseInt(monthsOfYear) - datePartMonth), ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpSDTStr,(Integer.parseInt(monthsOfYear) - datePartMonth), ""), "yyyyMMdd", "yyyyMMdd", "");
				
				if (selType.equals("0")) {
					int datePartDay = format.parse(tmpDTStr).getDate();
					int datePartYear = format.parse(tmpDTStr).getYear();
					int tmpDatePartMonth = format.parse(tmpDTStr).getMonth();
					boolean checkLastDate = true;
					
					if (daysOfMonth.equals("31") && (tmpDatePartMonth == 2 || tmpDatePartMonth == 4 || tmpDatePartMonth == 6 || tmpDatePartMonth == 9 || tmpDatePartMonth == 11)) {
						checkLastDate = false;
					} else if (daysOfMonth.equals("30") && tmpDatePartMonth == 2) {
						checkLastDate = false;
					} else if (daysOfMonth.equals("29") && tmpDatePartMonth == 2 && !(datePartYear % 4 == 0 && datePartYear % 100 != 0 || datePartYear % 400 == 0)) {
						checkLastDate = false;
					}
					
					if (checkLastDate) {
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(daysOfMonth) - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (Integer.parseInt(daysOfMonth) - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (Integer.parseInt(daysOfMonth) - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
						
						if (endRecurType.equals("0")) {
							if (number(tmpDTStr) > number(eDate)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						} else if (endRecurType.equals("1")) {
							if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
								
								if (number(tmpDTStr) >= number(orgtmpDTStr)) {
									n = n+1;
								}
							}
						} else if (endRecurType.equals("2")) {
							if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					}
				} else {
					int count = 1;
					int datePartDay = format.parse(tmpDTStr).getDate();
					
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (1 - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (1 - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (1 - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
					
					String sTmpDTStr = tmpDTStr;
					
					if (!byPosition.equals("-1")) {
						while (true) {
							if (wDayCnt == 0) {
								if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
									break;
								}
							} else if (wDayCnt == 2) {
								if (weekDay(tmpDTStr) == 7) {
									break;
								}
							} else {
								if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7) {
									if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 6) {
										break;
									}
								} else {
									if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
										break;
									}
								}
							}
							count ++;
							
						/*	tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();
							tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(1).toString();
							tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(1).toString();*/
						}
						if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7 && wDayCnt == 5) {
							tmpDTStr = sTmpDTStr;
							wDayCnt = count;
						}
						
						if (!byPosition.equals("1")) {
							if (wDayCnt == 5) {
								if (format.parse(tmpDTStr).getDate() == 1) {
									/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();*/
								} else {
									if (weekDay(sTmpDTStr) == 1 || weekDay(sTmpDTStr) == 7) {
										/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();*/ 
									} else {
										/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -2) * 7).toString();*/
									}
								}
							} 
						} else {
							/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();
							tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();
							tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays((Integer.parseInt(byPosition) -1) * 7).toString();*/
						}
					} else {
						int count1 = 1;
						/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusMonths(1).toString();
						tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();*/
						
						int tmpWeekDay = weekDay(tmpDTStr);
						
						while (true) {
							if (wDayCnt == 0) {
								if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
									break;
								}
							} else if (wDayCnt == 2) {
								if (weekDay(tmpDTStr) == 7) {
									break;
								}
							} else {
								if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
									break;
								}
							}
							count1++;
							
							/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();
							tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusDays(1).toString();
							tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusDays(1).toString();*/
						}
						if (wDayCnt == 2) {
							if (tmpWeekDay == 7) {
								wDayCnt = 0;
							}
						} else if (wDayCnt == 5) {
							if (tmpWeekDay == 1 || tmpWeekDay == 7) {
								wDayCnt = 5;
							} else {
								wDayCnt = count1;
							}
						}
					}
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();*/ 
									}
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();*/
									}
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
							if (number(tmpDTStr) >= number(orgtmpDTStr)) {
								n = n + 1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr1)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusDays(1).toString();*/
									}
									
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
									
									if (tmpDTStr.equals(tmpEDTStr1)) {
										break;
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					}
				}
				/*tmpDTStr = LocalDateTime.from(format.parse(tmpDTStr).toInstant()).plusYears(1).toString();
				tmpEDTStr = LocalDateTime.from(format.parse(tmpEDTStr).toInstant()).plusYears(1).toString();
				tmpSDTStr = LocalDateTime.from(format.parse(tmpSDTStr).toInstant()).plusYears(1).toString();*/
				
				temp++;
				if (temp > 1000) {
					break;
				}
			}
			returnXML.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnXML.toString();
	}
	
	public int number(String inputStr) {
		try {
			return Integer.parseInt(inputStr.replace("-", "").replace(" ", "").replace(":", "").trim());
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	@SuppressWarnings("deprecation")
	public int weekDay(String inputStr) {
		int returnValue = 0;
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		
		try {
				if (format.parse(inputStr).getDay() == 0) {
					returnValue = 1;
				}
				
				if (format.parse(inputStr).getDay() == 1) {
					returnValue = 2;
				}
				
				if (format.parse(inputStr).getDay() == 2) {
					returnValue = 3;
				}
				
				if (format.parse(inputStr).getDay() == 3) {
					returnValue = 4;
				}
				
				if (format.parse(inputStr).getDay() == 4) {
					returnValue = 5;
				}
				
				if (format.parse(inputStr).getDay() == 5) {
					returnValue = 6;
				}
				
				if (format.parse(inputStr).getDay() == 6) {
					returnValue = 7;
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnValue;
	}
}
