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
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
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
	    String brdGbn = "";
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
		
		if(req.getParameter("boardGbn") != null) {
			brdGbn = req.getParameter("boardGbn");
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
		//nodes2.item(0).setTextContent("SELECT_NO");
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
	@RequestMapping(value = "/ezResource/scheduleGet.do")
	public String scheduleGet(@RequestBody String xmlStr,HttpServletRequest req, Model model) throws Exception {
		String resID = "";
		String cmd = "";
		String type = "";
		String viewType = "";
		String approveFlag = "";
		String writerName = "";
		String writerDept = "";
		String gubun = "P";
		String gubunID = "";
		int page = 0;
		
		try {
			if (req.getParameter("resID") != null) {
				resID = req.getParameter("resID");
			}
			if (req.getParameter("cmd") != null) {
				cmd = req.getParameter("cmd");
			}
			if (req.getParameter("pType") != null) {
				type = req.getParameter("type");
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
						String startDate1 = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDate.substring(6,7), -1), "", "","");
						String endDate1 = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDate.substring(6,7), 1), "", "","");		
						xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate1);
						xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate1);
					}
				}
			}
		} catch (Exception e) {
			 e.printStackTrace();
		}
			return "/ezResource/resMain";
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
		brdNm = brdNm.replace("char(38)", "&");
		String childBrd = getItemList(loginCookie,brdID);
		
		List<ResGetItemListVO> list = ezResourceService.getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getLang());
		brdCount = list.size();
		
		model.addAttribute("childBrd", childBrd);
		model.addAttribute("brdID", brdID);
		model.addAttribute("accessCode", accessCode);
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("brdCount", brdCount);
		
		return "/ezResource/resViewResList2";
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
	
	public String getScheduleXML(String xmlStr, String ownerID, String companyID, String gubun, String pType, String pWriterName, String pWriterDept) {
		String returnStr = "";
		Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
		String sDate = xmlRes.getElementsByTagName("STARTDATETIME").item(0).getTextContent().trim();
		String eDate = xmlRes.getElementsByTagName("ENDDATETIME").item(0).getTextContent().trim();
		String app = xmlRes.getElementsByTagName("APP").item(0).getTextContent().trim();
		
		
		return "";
	}
	
	public String getScheduleList(String ownerID, String companyID, String groupID, String gubun, String sDate, String eDate, String pType, String pWriterName, String pWriterDept) throws Exception {
		StringBuilder returnStr = new StringBuilder();
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
		String returnSchdule = "";
		if (pType.equals("")) {
			List<ResGetScheduleListVO> getScheduleList = ezResourceService.getScheduleList(ownerID, companyID, todayStartStr, todayEndStr, pWriterName, pWriterDept);
			
			for (int i=0; i<getScheduleList.size(); i++) {
				returnSchdule = commonUtil.getQueryResult(getScheduleList.get(i));
			}
			
		} else if (pType.equals("MAIN")) {
			List<ResGetScheduleListMainVO> getScheduleListMain = ezResourceService.getScheduleListMain(ownerID, companyID, todayStartStr, todayEndStr);
			for (int i=0; i<getScheduleListMain.size(); i++) {
				returnSchdule = commonUtil.getQueryResult(getScheduleListMain.get(i));
			}
		}
		
		Document returnDom1 = commonUtil.convertStringToDocument(returnSchdule);
		
		for (int m=0; m<returnDom1.getElementsByTagName("ROW").getLength(); m++) {
			returnStr.append("<ROW>");
			returnStr.append("<num>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(0).getTextContent()+"</num>");
			returnStr.append("<pnum>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(1).getTextContent()+"</pnum>");
			returnStr.append("<ownerID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(2).getTextContent()+"</ownerID>");
			returnStr.append("<title><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(3).getTextContent()+"]]></title>");
			returnStr.append("<location><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(4).getTextContent()+"]]></location>");
			returnStr.append("<timeDisplay><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(5).getTextContent()+"]]></timeDisplay>");
			returnStr.append("<startDate>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(6).getTextContent()+"</startDate>");
			returnStr.append("<endDAte>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(7).getTextContent()+"</endDAte>");
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
		
		String returnRepetition = "";
		
		if (pType.equals("")) {
			List<ResGetScheduleListVO> getScheduleListRept= ezResourceService.getScheduleListRepetiti(ownerID, companyID, todayStartStr, todayEndStr, pWriterName, pWriterDept);
			returnRepetition = commonUtil.getQueryResult(getScheduleListRept);
		} else {
			List<ResGetScheduleListMainVO> getScheduleListReptMain = ezResourceService.getScheduleListRepetitim(ownerID, companyID, todayStartStr);
			returnRepetition = commonUtil.getQueryResult(getScheduleListReptMain);
		}
		
		Document returnRepetitionDom = commonUtil.convertStringToDocument(returnRepetition);
		for (int i=0; i<returnRepetitionDom.getElementsByTagName("ROW").getLength(); i++) {
			String reCompanyID = returnRepetitionDom.getElementsByTagName("COMPANYID").item(i).getTextContent();
			String reNum = returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent();
			String reOwnerID = returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent();
		}
		return "";
	}
	
	public String getRepDeteTimes(String companyID, String num, String ownerID, String sDate, String eDate) throws Exception {
		String returnStr = "";
		String returnRepetition = "";
		
		
		return "";
	}
}
