package egovframework.ezEKP.ezCar.web;

import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCar.service.EzCarAdminService;
import egovframework.ezEKP.ezCar.service.EzCarService;
import egovframework.ezEKP.ezCar.vo.CarGetSubClsListVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 차량관리 관리자
 * @author 솔루션2팀 서미배,서한별
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2021.07.06    서한별    신규작성
 *
 * @see
 */

@Controller
public class EzCarAdminController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzCarAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzCarService")
	private EzCarService ezCarService;
	
	@Resource(name="EzCarAdminService")
	private EzCarAdminService ezCarAdminService;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	/**
	 * 자원관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezCar/carMain.do", method = RequestMethod.GET)
	public String carMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String crossPage = "/admin/ezCar/gwBoardListManagelistLeft.do";
		model.addAttribute("crossPage", crossPage);
		return "admin/ezCar/carMain";
	}
	
	/**
	 * 자원관리 좌측화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezCar/gwBoardListManagelistLeft.do", method = RequestMethod.GET)
	public String gwBoardListManagelistLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req,Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String selectNo = "";
		String adminYN = "";
		
		if (req.getParameter("flag") != null) {
			selectNo = req.getParameter("selectNo");
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
			adminYN = "YES";
		}
		
		model.addAttribute("adminYN", adminYN);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("selectNo", selectNo);
		return "admin/ezCar/carGwBoardListManageListLeft";
	}
	
	/**
	 * 자원관리 관리자 정보 실행 함수
	 */
	@RequestMapping(value = "/admin/ezCar/callManagerDepthNode.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callManagerDepthNode(@RequestBody String xmlStr,HttpServletRequest req,Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("callManagerDepthNode Start");
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String selectFlag = "";
		StringBuilder strXML = new StringBuilder();
		Document xmlRet = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		
		if (req.getParameter("flag") != null) {
			selectFlag = req.getParameter("flag");
		}
		logger.debug("xmlStr="+xmlStr);
		String ret = ezCarService.getSubClsTree(xmlStr, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
		xmlRet = commonUtil.convertStringToDocument(ret);
		
		if (xmlRet.getElementsByTagName("EXPANDED").getLength() <= 0) {
			strXML.append("<PARADATA>");
			strXML.append("<DATA>0</DATA>");
			strXML.append("<DATA>"+userInfo.getDeptID()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getDeptName1()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getId()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getDisplayName1()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getTitle1()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getPhone()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getCompanyName1()+"</DATA>");
			strXML.append("<DATA></DATA>");
			strXML.append("<DATA></DATA>");
			strXML.append("<DATA>"+userInfo.getCompanyID()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getCompanyName2()+"</DATA>");
			strXML.append("<ISCOMPANY>Y</ISCOMPANY>");
			strXML.append("</PARADATA>");
			
			//ezCarAdminService.addClsData(strXML.toString(), userInfo.getTenantId());
			
			ret = ezCarService.getSubClsTree(xmlStr, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
			
			xmlRet = commonUtil.convertStringToDocument(ret);
		}
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes1 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes2 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes3 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA12", xmlRet, XPathConstants.NODESET);
		NodeList nodes4 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/ISLEAF", xmlRet, XPathConstants.NODESET);
		NodeList nodes5 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SELECT", xmlRet, XPathConstants.NODESET);
		NodeList nodes16 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes17 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes18 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA10", xmlRet, XPathConstants.NODESET);
			
		NodeList nodes7 = (NodeList)xpath.evaluate("NODES/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes8 = (NodeList)xpath.evaluate("NODES/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes9 = (NodeList)xpath.evaluate("NODES/NODE/DATA12", xmlRet, XPathConstants.NODESET);
		NodeList nodes10 = (NodeList)xpath.evaluate("NODES/NODE/ISLEAF", xmlRet, XPathConstants.NODESET);
		NodeList nodes11 = (NodeList)xpath.evaluate("NODES/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes13 = (NodeList)xpath.evaluate("NODES/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes14 = (NodeList)xpath.evaluate("NODES/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes15 = (NodeList)xpath.evaluate("NODES/NODE/DATA10", xmlRet, XPathConstants.NODESET);
			
		if (nodes.getLength() != 0) {
			for (int i=0; i<nodes.getLength(); i++) {
				nodes1.item(i).removeChild((Node) nodes2.item(i));
				
				if (nodes3.item(i).getTextContent().equals("0")) {
					nodes4.item(i).setTextContent("TRUE");
				}
				
				if(nodes5.item(i).getTextContent().equals("")) {
					nodes5.item(i).setTextContent(" ");
				}
				
				if(nodes16.item(i).getTextContent().equals("")) {
					nodes16.item(i).setTextContent(" ");
				}
				if(nodes17.item(i).getTextContent().equals("")) {
					nodes17.item(i).setTextContent(" ");
				}
				if(nodes18.item(i).getTextContent().equals("")) {
					nodes18.item(i).setTextContent(" ");
				}
					
				//좌측 리로드할때는 선택 안되도록
				if (selectFlag.equals("SELECT_NO")) {
					if (nodes5.getLength() != 0) {
						nodes1.item(i).removeChild((Node) nodes5.item(i));
					}
				}
			}
		}
		if (nodes7.getLength() != 0) {
			for (int i=0; i<nodes7.getLength(); i++) {
				nodes8.item(i).removeChild((Node) nodes11.item(i));
				
				if (nodes9.item(i).getTextContent().equals("0")) {
					nodes10.item(i).setTextContent("TRUE");
				}
				if(nodes13.item(i).getTextContent().equals("")) {
					nodes13.item(i).setTextContent(" ");
				}
				if(nodes14.item(i).getTextContent().equals("")) {
					nodes14.item(i).setTextContent(" ");
				}
				if(nodes15.item(i).getTextContent() == null || nodes15.item(i).getTextContent().equals("")) {
					nodes15.item(i).setTextContent(" ");
				}
				
			}
		}
		
		logger.debug("xmlRet="+commonUtil.convertDocumentToString(xmlRet));
		logger.debug("callManagerDepthNode End");
		return commonUtil.stripScriptTags(commonUtil.convertDocumentToString(xmlRet)).replaceAll("onerror=alert", "");
	}
	
	
	/**
	 * 자원관리 센터화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezCar/gwBoardListManagelistCenter.do", method = RequestMethod.GET)
	public String gwBoardListManagelistCenter(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		return "admin/ezCar/carGwBoardListManageListCenter";
	}
	
	
	/**
	 * 자원관리 일반설정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezCar/gwBoardListRegComBoard.do", method = RequestMethod.GET)
	public String gwBoardListRegComBoard(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String brdID = "";
		String companyID = "";
		String langPrimary = "";
		String langSecondary = "";
		
		langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
			
		if (req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		if (req.getParameter("selCompanyID") != null) {
			companyID = req.getParameter("selCompanyID");
		}
			
		CarGetSubClsListVO getBrdInfo = ezCarAdminService.getBrdInfo(Integer.parseInt(brdID), companyID, userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("getBrdInfo", getBrdInfo);
		model.addAttribute("brdID", brdID);
		model.addAttribute("selCompanyID", companyID);
		model.addAttribute("adminFg", "YES");
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		return "admin/ezCar/carGwBoardListRegComBoard";
	}
	
	/**
	 * 자원관리 일반설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezCar/callBrdMod.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdMod(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlStr) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		boolean returnValue = ezCarAdminService.modifyClsData(commonUtil.detectPathTraversal(xmlStr), userInfo.getTenantId());
		return String.valueOf(returnValue);
	}
	
	/**
	 * 자원관리 하위분류등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezCar/gwBoardListRegSubBoard.do", method = RequestMethod.GET)
	public String gwBoardListRegSubBoard(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String brdID = "";
		String brdNm = "";
		String brdLevel = "";
		String brdStep = "";
		String brdGroup = "";
		String selCompanyID = "";
		String langPrimary = "";
		String langSecondary = "";
		
		langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
			
		if (req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		if (req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		if (req.getParameter("brdLevel") != null) {
			brdLevel = req.getParameter("brdLevel");
		}
		if (req.getParameter("brdStep") != null) {
			brdStep = req.getParameter("brdStep");
		}
		if (req.getParameter("brdGroup") != null) {
			brdGroup = req.getParameter("brdGroup");
		}
		if (req.getParameter("selCompanyID") != null) {
			selCompanyID = req.getParameter("selCompanyID");
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("brdID", brdID);
		model.addAttribute("upNm", brdNm);
		model.addAttribute("upLevel", brdLevel);
		model.addAttribute("upStep", brdStep);
		model.addAttribute("brdGroup", brdGroup);
		model.addAttribute("selCompanyID", selCompanyID);
		model.addAttribute("adminFg", "YES");
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		
		return "admin/ezCar/carGwBoardListRegSubBoard";
	}
	
	/**
	 * 자원관리 하위분류 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezCar/callCarNew.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callCarNew(@CookieValue("loginCookie") String loginCookie,@RequestBody String xmlStr) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		boolean returnValue = ezCarAdminService.addClsData(commonUtil.detectPathTraversal(xmlStr), userInfo.getTenantId());
		return String.valueOf(returnValue);
	}
	
	
	/**
	 * 자원관리 권한설정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezCar/gwBoardPostRegBoardRightMain.do", method = RequestMethod.GET)
	public String gwBoardPostRegRightMain(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model, Locale locale) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String brdID = "";
		String brdNm = "";
		String brdGb = "";
		String selCompanyID = "";
		StringBuilder strXMLPara = new StringBuilder();
		String strRtnXML = "";
		String strVal = "";
		String optAdmLvl = "";
		String optUserLvl = "";
		String strOptions = "";
		
		brdID = req.getParameter("brdID");
		brdNm = req.getParameter("brdNm");
		brdGb = req.getParameter("brdGb");
		selCompanyID = req.getParameter("selCompanyID");
		
		strXMLPara.append("<PARA_DATA>");
		strXMLPara.append("<NODE>" + brdID + "</NODE>");
		strXMLPara.append("<NODE>" + selCompanyID + "</NODE>");
		strXMLPara.append("</PARA_DATA>");
		
		strRtnXML = ezCarAdminService.getClsACLList(strXMLPara.toString(), userInfo.getTenantId());
		
		Document xmlRet = commonUtil.convertStringToDocument(strRtnXML);
		
		for (int i=0; i<xmlRet.getElementsByTagName("NODE").getLength(); i++) {
			String strDeptYn = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(0).getTextContent();
			String strSDAYN = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(1).getTextContent();
			String memberNam = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(2).getTextContent();
			String memberID = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(3).getTextContent();
			String accessLvl = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(4).getTextContent();
			
			if (accessLvl.equals("1")) {
				strVal = memberNam + " - (" + egovMessageSource.getMessage("ezResource.t115", locale);
				optAdmLvl = "checked";
				optUserLvl = "";
			} else if (accessLvl.equals("2")) {
				strVal = memberNam + " - (" + egovMessageSource.getMessage("ezResource.t116", locale);
				optAdmLvl = "";
				optUserLvl = "checked";
			}
			 strOptions = strOptions + "<OPTION";
             strOptions = strOptions + " Dept_YN='" + strDeptYn + "'";
             strOptions = strOptions + " SDA_YN='" + strSDAYN + "'";
             strOptions = strOptions + " Member_nam='" + memberNam + "'";
             strOptions = strOptions + " Member_ID='" + memberID + "'";
             strOptions = strOptions + " Access_lvl='" + accessLvl + "'>" + strVal;
             strOptions = strOptions + "</OPTION>";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("brdID", brdID);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdGb", brdGb);
		model.addAttribute("companyID", selCompanyID);
		model.addAttribute("strOptions", strOptions);
		model.addAttribute("optAdmLvl", optAdmLvl);
		model.addAttribute("optUserLvl", optUserLvl);
		
		return "admin/ezCar/carGwBoardPostRegBoardRightMain";
	}
	
	/**
	 * 자원관리 권한설정 - 사용자추가 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezCar/popup/gwBoardPostRegBoardRight.do", method = RequestMethod.GET)
	public String gwBoardPostRegRight(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String useOCS = config.getProperty("config.USE_OCS");
		model.addAttribute("useOCS", useOCS);
		return "admin/ezCar/popup/carGwBoardPostRegBoardRight";
	}
	
	
	/**
	 * 자원관리 권한설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezCar/callBrdMng.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdMng(@RequestBody String xmlStr, @CookieValue("loginCookie") String  loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		boolean check = ezCarAdminService.userResPermissionCheck(xmlStr, userInfo.getTenantId());
		
		if(!check) {
			return "NO";
		}
			
		boolean result = ezCarAdminService.saveACLLst(xmlStr, userInfo.getTenantId());
		
		return String.valueOf(result);
	}
	
	
	/**
	 * 자원관리 분류삭제 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezCar/gwBoardPostBoardDel.do", method = RequestMethod.GET)
	public String gwBoardPostBoardDel(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req,
			Model model, Locale locale, HttpServletResponse resp) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String brdID = "";
		String upNm = "";
		String companyID = "";
		StringBuilder tempStr = new StringBuilder();
		String pWrnMsg = "";
		boolean blnChkDelBtn = false;

		brdID = req.getParameter("brdID");
		upNm = commonUtil.stripScriptTags(req.getParameter("brdNm")).replaceAll("onerror=alert", "");
		companyID = req.getParameter("selCompanyID");

		blnChkDelBtn = false;
		if (!brdID.equals("1")) {
			tempStr.append("<PARA_DATA>");
			tempStr.append("<DATA>" + brdID + "</DATA>");
			tempStr.append("<DATA>" + companyID + "</DATA>");
			tempStr.append("</PARA_DATA>");

			String strRtnXML = ezCarAdminService.getSubCntOfCls(tempStr.toString(), userInfo.getTenantId());
			Document xmlRet = commonUtil.convertStringToDocument(strRtnXML);

			String strErrChk = xmlRet.getElementsByTagName("ERRCHK").item(0).getTextContent();
			int intSubResCnt = Integer.parseInt(xmlRet.getElementsByTagName("SUBRESCNT").item(0).getTextContent());
			int intSubClsCnt = Integer.parseInt(xmlRet.getElementsByTagName("SUBCLSCNT").item(0).getTextContent());

			if (strErrChk.equals("True")) {
				if (intSubResCnt > 0 || intSubClsCnt > 0) {
					pWrnMsg = "<dd style='font-size:15px'>" + egovMessageSource.getMessage("ezResource.t66", locale)
							+ " <b>'" + intSubClsCnt + "'</b> "
							+ egovMessageSource.getMessage("ezResource.t67", locale);
					pWrnMsg = pWrnMsg + egovMessageSource.getMessage("ezResource.t68", locale) + " <b>'" + intSubResCnt
							+ "'</b> " + egovMessageSource.getMessage("ezResource.t69", locale)
							+ egovMessageSource.getMessage("ezResource.t9900005", locale) + " <br>";
					pWrnMsg = pWrnMsg + egovMessageSource.getMessage("ezResource.t70", locale) + "</dd>";
				} else {
					/*
					 * pWrnMsg = egovMessageSource.getMessage("ezResource.t71", locale) +
					 * " <b style='overflow:hidden;text-overflow:ellipsis;display:-webkit-box;-webkit-line-clamp:5;-webkit-box-orient:vertical;word-wrap:break-word;' >'"
					 * + upNm + "'</b> " + egovMessageSource.getMessage("ezResource.t72", locale) +
					 * " <BR>";
					 */
					pWrnMsg = "<dd style='font-size:15px'>" + egovMessageSource.getMessage("ezResource.t71", locale)
							+ " <b style='overflow:hidden;text-overflow:ellipsis;display:contents;-webkit-line-clamp:5;-webkit-box-orient:vertical;word-wrap:break-word;' >'"
							+ upNm + "'</b><br> " + egovMessageSource.getMessage("ezResource.t72", locale)
							+ " <BR></dd>";
					blnChkDelBtn = true;
				}
			} else {
				resp.setCharacterEncoding("utf-8");
				resp.getWriter().write(egovMessageSource.getMessage("ezResource.t73", locale));
			}
		} else {
			pWrnMsg = "<dd>" + egovMessageSource.getMessage("ezResource.t74", locale) + "</dd>";
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("brdID", brdID);
		model.addAttribute("upNm", upNm);
		model.addAttribute("selCompanyID", companyID);
		model.addAttribute("pWrnMsg", pWrnMsg);
		model.addAttribute("blnChkDelBtn", String.valueOf(blnChkDelBtn));

		return "admin/ezCar/carGwBoardPostBoardDel";
	}

	
	
	/**
	 * 자원관리 분류삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezCar/callBrdDel.do", method = RequestMethod.POST, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdDel(@RequestBody String xmlStr, @CookieValue("loginCookie") String loginCookie)
			throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		boolean result = ezCarAdminService.delClsData(xmlStr, userInfo.getTenantId());
		return String.valueOf(result);
	}
	
}
