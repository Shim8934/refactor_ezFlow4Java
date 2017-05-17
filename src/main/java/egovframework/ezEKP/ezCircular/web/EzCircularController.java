package egovframework.ezEKP.ezCircular.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

import egovframework.ezEKP.ezCircular.service.EzCircularService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzCircularController {

	private static final Logger logger = LoggerFactory.getLogger(EzCircularController.class);
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzCircularService ezCircularService;
	
	/**
	 * 회람판 메인화면 호출 Method
	 */
	@RequestMapping(value="/ezCircular/circularIndex.do")
	public String main(HttpServletRequest req, Model model) {
		
		logger.debug("Circularmain started");
		
		String func = "";
		String subFunc = "";

		if (req.getParameter("func") != null && !req.getParameter("func").equals("")) {
			func = req.getParameter("func");	
		}
		if (req.getParameter("subFunc") != null && !req.getParameter("subFunc").equals("")) {
			subFunc = req.getParameter("subFunc");	
		}
		
		model.addAttribute("func", func);
		model.addAttribute("subFunc", subFunc);
		
		logger.debug("Circularmain ended");
		
		return "/ezCircular/circularMain";
	}
	
	/**
	 * 회람판 왼쪽화면 호출 Method
	 * @throws Exception 
	 */
	@RequestMapping(value="/ezCircular/circularLeft.do")
	public String circularLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		
		logger.debug("CircularLeft started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String brdNm = "";
		String brdGubun = "";
		String strAccessCode = "";
		String selectNo = "";
		
		if (req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		
		if (req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		
		if (req.getParameter("boardGbn") != null) {
			brdGubun = req.getParameter("boardGbn");
		}
		
		strAccessCode = "0";
		
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
		
		logger.debug("Circularmain ended");
		
		return "/ezCircular/circularLeft";
	}
	
	/**
	 * 자원관리 정보 호출 함수
	 */
	@RequestMapping(value = "/ezCircular/callNodeTreeData.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callNodeTreeData(@RequestBody String xmlReq,HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("callNodeTreeData started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String selectFlag = "";
		
		if(req.getParameter("flag") != null) {
			selectFlag = req.getParameter("flag");
		}
logger.debug("###" + xmlReq);		
		String ret = ezCircularService.getSubClsTree(xmlReq, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
		Document xmlRet = commonUtil.convertStringToDocument(ret);
logger.debug("###" + ret);		
logger.debug("###" + xmlRet);		
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes1 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes2 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SELECT", xmlRet, XPathConstants.NODESET);
		NodeList nodes4 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes5 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes6 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes7 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA10", xmlRet, XPathConstants.NODESET);
		
		NodeList nodes8 = (NodeList)xpath.evaluate("NODES/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes9 = (NodeList)xpath.evaluate("NODES/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes10 = (NodeList)xpath.evaluate("NODES/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes11 = (NodeList)xpath.evaluate("NODES/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes12 = (NodeList)xpath.evaluate("NODES/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes13 = (NodeList)xpath.evaluate("NODES/NODE/DATA10", xmlRet, XPathConstants.NODESET);
		
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
					if(nodes2.item(i) != null) {
						//NodeList nodes3 = (NodeList) xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);  
						nodes1.item(i).removeChild((Node)nodes2.item(0));
					}
				}
			}
		}
		
		if (nodes8 != null && nodes10 != null) {
			for (int i=0; i<nodes8.getLength(); i++) {
				nodes8.item(i).setTextContent("TRUE");
				nodes9.item(i).removeChild((Node)nodes10.item(i));
				if(nodes11.item(i).getTextContent().equals("")) {
					nodes11.item(i).setTextContent("<![CDATA[]]>");
				}
				if(nodes12.item(i).getTextContent().equals("")) {
					nodes12.item(i).setTextContent("<![CDATA[]]>");
				}
				if(nodes13.item(i).getTextContent().equals("")) {
					nodes13.item(i).setTextContent("<![CDATA[]]>");
				}
			}
		}

		logger.debug("callNodeTreeData ended");
		return commonUtil.convertDocumentToString(xmlRet).replace("&lt;", "<").replace("&gt;", ">");
	
	}
	
	/**
	 * 신착/미확인 화면 호출 Method
	 */
	@RequestMapping(value="/ezCircular/circular1.do")
	public String circular1(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular1 started");
		
		
		
		logger.debug("Circular1 ended");
		
		return "/ezCircular/circular1";
	}
	
	/**
	 * 작성분 호출 Method
	 */
	@RequestMapping(value="/ezCircular/circular2.do")
	public String circular2(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular2 started");
		
		
		
		logger.debug("Circular2 ended");
		
		return "/ezCircular/circular2";
	}
	
	/**
	 * 휴지통 화면 호출 Method
	 */
	@RequestMapping(value="/ezCircular/circular3.do")
	public String circular3(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular3 started");
		
		
		
		logger.debug("Circular3 ended");
		
		return "/ezCircular/circular3";
	}
	
	/**
	 * 임시저장 화면 호출 Method
	 */
	@RequestMapping(value="/ezCircular/circular4.do")
	public String circular4(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular4 started");
		
		
		
		logger.debug("Circular4 ended");
		
		return "/ezCircular/circular4";
	}
	
	/**
	 * 확인완료 화면 호출 Method
	 */
	@RequestMapping(value="/ezCircular/circular5.do")
	public String circular5(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("Circular5 started");
		
		
		
		logger.debug("Circular5 ended");
		
		return "/ezCircular/circular5";
	}
	
	/**
	 * 환경설정 화면 호출 Method
	 */
	@RequestMapping(value="/ezCircular/circularConfig.do")
	public String circularConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) {
		
		logger.debug("circularConfig started");
		
		
		
		logger.debug("circularConfig ended");
		
		return "/ezCircular/circularConfig";
	}
}
