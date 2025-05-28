package egovframework.ezEKP.ezResource.web;

import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezResource.service.EzResourceAdminService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResGetSubClsListVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 자원관리 관리자
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.06.10    지정석    신규작성
 *
 * @see
 */

@Controller
public class EzResourceAdminController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzResourceAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Resource(name="EzResourceAdminService")
	private EzResourceAdminService ezResourceAdminService;
	
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
	@RequestMapping(value = "/admin/ezResource/resourceMain.do", method = RequestMethod.GET)
	public String resourceMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String crossPage = "/admin/ezResource/gwBoardListManagelistLeft.do";
		model.addAttribute("crossPage", crossPage);
		return "admin/ezResource/resMain";
	}
	
	/**
	 * 자원관리 좌측화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardListManagelistLeft.do", method = RequestMethod.GET)
	public String gwBoardListManagelistLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req,Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String selectNo = req.getParameter("flag") != null ? req.getParameter("selectNo") : "";
		String adminYN = "YES";
		
		model.addAttribute("adminYN", adminYN);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("selectNo", selectNo);
		model.addAttribute("selectedCompany", Optional.ofNullable(req.getParameter("selCompany")).orElse(""));
		return "admin/ezResource/resGwBoardListManageListLeft";
	}
	
	/**
	 * 자원관리 센터화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardListManagelistCenter.do", method = RequestMethod.GET)
	public String gwBoardListManagelistCenter(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		return "admin/ezResource/resGwBoardListManageListCenter";
	}
	
	/**
	 * 자원관리 관리자 정보 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callManagerDepthNode.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
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
		String ret = ezResourceService.getSubClsTree(xmlStr, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
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
			
			ezResourceAdminService.addClsData(strXML.toString(), userInfo.getTenantId());
			
			ret = ezResourceService.getSubClsTree(xmlStr, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
			
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
	 * 자원관리 일반설정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardListRegComBoard.do", method = RequestMethod.GET)
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
			
		ResGetSubClsListVO getBrdInfo = ezResourceAdminService.getBrdInfo(Integer.parseInt(brdID), companyID, userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("getBrdInfo", getBrdInfo);
		model.addAttribute("brdID", brdID);
		model.addAttribute("selCompanyID", companyID);
		model.addAttribute("adminFg", "YES");
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		return "admin/ezResource/resGwBoardListRegComBoard";
	}
	
	/**
	 * 자원관리 일반설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callBrdMod.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdMod(@CookieValue("loginCookie") String loginCookie, @RequestBody String xmlStr) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		boolean returnValue = ezResourceAdminService.modifyClsData(commonUtil.detectPathTraversal(xmlStr), userInfo.getTenantId());
		return String.valueOf(returnValue);
	}
	
	/**
	 * 자원관리 하위분류등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardListRegSubBoard.do", method = RequestMethod.GET)
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
		
		return "admin/ezResource/resGwBoardListRegSubBoard";
	}
	
	/**
	 * 자원관리 하위분류 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callBrdNew.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdNew(@CookieValue("loginCookie") String loginCookie,@RequestBody String xmlStr) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		boolean returnValue = ezResourceAdminService.addClsData(commonUtil.detectPathTraversal(xmlStr), userInfo.getTenantId());
		return String.valueOf(returnValue);
	}
	
	/**
	 * 자원관리 권한설정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardPostRegBoardRightMain.do", method = RequestMethod.GET)
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
		
		strRtnXML = ezResourceAdminService.getClsACLList(strXMLPara.toString(), userInfo.getTenantId());
		
		Document xmlRet = commonUtil.convertStringToDocument(strRtnXML);
		
		for (int i=0; i<xmlRet.getElementsByTagName("NODE").getLength(); i++) {
			String strDeptYn = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(0).getTextContent();
			String strSDAYN = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(1).getTextContent();
			String memberNam = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(2).getTextContent();
			String memberID = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(3).getTextContent();
			String accessLvl = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(4).getTextContent();
			String memberNam2 = xmlRet.getElementsByTagName("NODE").item(i).getChildNodes().item(5).getTextContent();

			//2023-08-16 이주원 - 언어설정에 따른 권한대상 텍스트
			String lang = "1";
			if (commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()) != null){
				lang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
			};
			
			if (accessLvl.equals("1")) {
				if ("1".equals(lang)){
					strVal = memberNam + " - (" + egovMessageSource.getMessage("ezResource.t115", locale);
				} else {
					strVal = memberNam2 + " - (" + egovMessageSource.getMessage("ezResource.t115", locale);
				}

				optAdmLvl = "checked";
				optUserLvl = "";
			} else if (accessLvl.equals("2")) {
				if ("1".equals(lang)){
					strVal = memberNam + " - (" + egovMessageSource.getMessage("ezResource.t116", locale);
				} else {
					strVal = memberNam2 + " - (" + egovMessageSource.getMessage("ezResource.t116", locale);
				}

				optAdmLvl = "";
				optUserLvl = "checked";
			}
			 strOptions = strOptions + "<OPTION";
             strOptions = strOptions + " Dept_YN='" + strDeptYn + "'";
             strOptions = strOptions + " SDA_YN='" + strSDAYN + "'";
             strOptions = strOptions + " Member_nam='" + memberNam + "'";
			 strOptions = strOptions + " Member_nam2='" + memberNam2 + "'";
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
		
		return "admin/ezResource/resGwBoardPostRegBoardRightMain";
	}
	
	/**
	 * 자원관리 권한설정 - 사용자추가 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/popup/gwBoardPostRegBoardRight.do", method = RequestMethod.GET)
	public String gwBoardPostRegRight(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String useOCS = config.getProperty("config.USE_OCS");
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("company",
				Optional.ofNullable(req.getParameter("company"))
						.orElse(userInfo.getCompanyID()));
		return "admin/ezResource/popup/resGwBoardPostRegBoardRight";
	}
	
	/**
	 * 자원관리 분류순서조정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardPostRegBoardOrder.do", method = RequestMethod.GET)
	public String gwBoardPostRegBoardOrder(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model, Locale locale,HttpServletResponse resp) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		StringBuilder tempStr = new StringBuilder();
		StringBuilder pSubBrdLstBld = new StringBuilder();
		String pWrnMsg = "";
		String strRtnXML = "";
		String strBrdStep = "";
		String strBrdCount = "";
		String strBrdID = "";
		String strBrdNm = "";
		String strTmp = "";
		String brdID = "";
		String upNm = "";
		String upLevel = "";
		String upStep = "";
		String upCount = "";
		String companyID = "";
		int intSubClsCnt = 0;
		
		brdID = req.getParameter("brdID");
		upNm = req.getParameter("brdNm");
		upLevel = req.getParameter("brdLevel");
		upStep = req.getParameter("brdStep");
		upCount = req.getParameter("brdCount");
		companyID = req.getParameter("selCompanyID");
		
		tempStr.append("<PARA_DATA>");
		tempStr.append("<NODE>"+brdID+"</NODE>");
		tempStr.append("<NODE>"+companyID+"</NODE>");
		tempStr.append("</PARA_DATA>");
		
		strRtnXML = ezResourceAdminService.getSubCntOfCls(tempStr.toString(), userInfo.getTenantId());

		Document xmlRet = commonUtil.convertStringToDocument(strRtnXML);
		
		String strErrChk = xmlRet.getElementsByTagName("ERRCHK").item(0).getTextContent();
		
		intSubClsCnt = Integer.parseInt(xmlRet.getElementsByTagName("SUBCLSCNT").item(0).getTextContent());
		
		if (strErrChk.equals("True")) {
			if (intSubClsCnt <= 1) {
				pWrnMsg = egovMessageSource.getMessage("ezResource.t103", locale);
			} else {
				StringBuilder tempStr2 = new StringBuilder();
				tempStr2.append("<PARA_DATA>");
				tempStr2.append("<NODE>"+brdID+"</NODE>");
				tempStr2.append("<NODE>"+companyID+"</NODE>");
				tempStr2.append("</PARA_DATA>");
				
				strRtnXML = ezResourceAdminService.getSubClsList(tempStr2.toString(), userInfo.getPrimary(), userInfo.getTenantId());
				
				Document objXML2 = commonUtil.convertStringToDocument(strRtnXML);
				
				for (int i=0; i<objXML2.getDocumentElement().getChildNodes().getLength(); i++) {
					strBrdStep = objXML2.getElementsByTagName("BRDSTEP").item(i).getTextContent();
					strBrdCount = objXML2.getElementsByTagName("BRDCOUNT").item(i).getTextContent();
					strBrdID = objXML2.getElementsByTagName("BRDID").item(i).getTextContent();
					strBrdNm = objXML2.getElementsByTagName("BRDNM").item(i).getTextContent();
					
					if (intSubClsCnt == i) {
						strTmp = "Selected";
					} else {
						strTmp = "";
					}
					
					pSubBrdLstBld.append("<OPTION STEP= " + strBrdStep);
					pSubBrdLstBld.append("  COUNT= " + strBrdCount);
					pSubBrdLstBld.append("  VALUE= " + strBrdID + " " + strTmp + ">");
					pSubBrdLstBld.append(strBrdNm + "</OPTION>");
				}
			}
		} else {
			resp.setCharacterEncoding("utf-8");
			resp.getWriter().write(egovMessageSource.getMessage("ezResource.t73", locale));
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("brdID", brdID);
		model.addAttribute("upLevel", upLevel);
		model.addAttribute("upStep", upStep);
		model.addAttribute("upNm", upNm);
		model.addAttribute("upCount", upCount);
		model.addAttribute("selCompanyID", companyID);
		model.addAttribute("pWrnMsg", pWrnMsg);
		model.addAttribute("subBrdLst", pSubBrdLstBld.toString());
		model.addAttribute("intSubClsCnt", intSubClsCnt);
		
		return "admin/ezResource/resGwBoardPostRegBoardOrder";
	}
	
	/**
	 * 자원관리 분류순서조정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callBrdStep.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdStep(@CookieValue("loginCookie") String  loginCookie,HttpServletRequest req) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String currID = req.getParameter("currID");
		String next = req.getParameter("nextID");
		String companyID = req.getParameter("companyID");
		
		boolean result = ezResourceAdminService.blnChgClsOrder(currID, next, companyID, userInfo.getTenantId());
		
		return String.valueOf(result);
	}
	
	/**
	 * 자원관리 분류이동 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardPostBoardMove.do", method = RequestMethod.GET)
	public String gwBoardPostBoardMove(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model, Locale locale, HttpServletResponse resp) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String brdID = req.getParameter("brdID").trim();
		String brdNm = req.getParameter("brdNm").trim();
		String brdLevel = req.getParameter("brdLevel").trim();
		String brdRef = req.getParameter("brdRef").trim();
		String brdUpper = req.getParameter("brdUpper").trim();
		String selCompanyID = req.getParameter("selCompanyID").trim();
		String pWrnMsg = "";
		
		if (!brdID.equals("1")) {
			StringBuilder strXMLPara = new StringBuilder();
			strXMLPara.append("<PARA_DATA>");
			strXMLPara.append("<NODE>" + brdID + "</NODE>");
			strXMLPara.append("<NODE>" + selCompanyID + "</NODE>");
			strXMLPara.append("</PARA_DATA>");
			
			String strRtnXML = ezResourceAdminService.getSubCntOfCls(strXMLPara.toString(), userInfo.getTenantId());
			Document xmlRet = commonUtil.convertStringToDocument(strRtnXML);
			
			String strErrChk = xmlRet.getElementsByTagName("ERRCHK").item(0).getTextContent();
			int intSubResCnt = Integer.parseInt(xmlRet.getElementsByTagName("SUBRESCNT").item(0).getTextContent());
			int intSubClsCnt = Integer.parseInt(xmlRet.getElementsByTagName("SUBCLSCNT").item(0).getTextContent());
			
			if (strErrChk.equals("True")) {
				pWrnMsg = egovMessageSource.getMessage("ezResource.t89", locale) + " '" + brdNm + egovMessageSource.getMessage("ezResource.t90", locale) + " <BR>";
				if (intSubResCnt > 0) {
					pWrnMsg = pWrnMsg + intSubClsCnt + egovMessageSource.getMessage("ezResource.t91", locale) + " <BR>";
					pWrnMsg = pWrnMsg + intSubClsCnt + egovMessageSource.getMessage("ezResource.t92", locale);
				}
			} else {
				resp.setCharacterEncoding("utf-8");
				resp.getWriter().write(egovMessageSource.getMessage("ezResource.t73", locale));
			}
		}
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("brdID", brdID);
		model.addAttribute("brdLevel", brdLevel);
		model.addAttribute("brdRef", brdRef);
		model.addAttribute("brdUpper", brdUpper);
		model.addAttribute("upNm", brdNm);
		model.addAttribute("selCompanyID", selCompanyID);
		model.addAttribute("pWrnMsg", pWrnMsg);
		
		return "admin/ezResource/resGwBoardPostBoardMove";
	}
	
	/**
	 * 자원관리 분류이동 -  대상선택 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/organ.do", method = RequestMethod.GET)
	public String organ(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", req.getServerName());
		return "admin/ezResource/resOrgan";
	}
	
	/**
	 * 자원관리 분류이동 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callBrdMove.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdMove(@CookieValue("loginCookie") String  loginCookie, HttpServletRequest req) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String brdID = req.getParameter("srcID");
		String targetID = req.getParameter("targetID");
		String strPara = req.getParameter("strPara");
		
		boolean result = ezResourceAdminService.blnMoveCls(brdID, targetID, strPara, userInfo.getTenantId());
		return String.valueOf(result);
	}
	
	/**
	 * 자원관리 분류삭제 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardPostBoardDel.do", method = RequestMethod.GET)
	public String gwBoardPostBoardDel(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model,Locale locale,HttpServletResponse resp) throws Exception {
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
			tempStr.append("<DATA>"+brdID+"</DATA>");
			tempStr.append("<DATA>"+companyID+"</DATA>");
			tempStr.append("</PARA_DATA>");
			
			String strRtnXML = ezResourceAdminService.getSubCntOfCls(tempStr.toString(), userInfo.getTenantId());
			Document xmlRet = commonUtil.convertStringToDocument(strRtnXML);
			
			String strErrChk = xmlRet.getElementsByTagName("ERRCHK").item(0).getTextContent();
			int intSubResCnt = Integer.parseInt(xmlRet.getElementsByTagName("SUBRESCNT").item(0).getTextContent());
			int intSubClsCnt = Integer.parseInt(xmlRet.getElementsByTagName("SUBCLSCNT").item(0).getTextContent());
			
			if (strErrChk.equals("True")) {
				if (intSubResCnt > 0 || intSubClsCnt > 0) {
					pWrnMsg = "<dd style='font-size:15px'>" + egovMessageSource.getMessage("ezResource.t66", locale)+ " <b>'" + intSubClsCnt + "'</b> " + egovMessageSource.getMessage("ezResource.t67", locale);
					pWrnMsg = pWrnMsg + egovMessageSource.getMessage("ezResource.t68", locale) + " <b>'" + 
									 intSubResCnt + "'</b> " + egovMessageSource.getMessage("ezResource.t69", locale) + 
									 egovMessageSource.getMessage("ezResource.t9900005", locale) + " <br>";
					pWrnMsg = pWrnMsg + egovMessageSource.getMessage("ezResource.t70", locale) + "</dd>";
				} else {
					/*pWrnMsg = egovMessageSource.getMessage("ezResource.t71", locale) + " <b style='overflow:hidden;text-overflow:ellipsis;display:-webkit-box;-webkit-line-clamp:5;-webkit-box-orient:vertical;word-wrap:break-word;' >'" + upNm + "'</b> " + egovMessageSource.getMessage("ezResource.t72", locale) + " <BR>";*/
					pWrnMsg = "<dd style='font-size:15px'>" + egovMessageSource.getMessage("ezResource.t71", locale) + " <b style='overflow:hidden;text-overflow:ellipsis;display:contents;-webkit-line-clamp:5;-webkit-box-orient:vertical;word-wrap:break-word;' >'" + upNm + "'</b><br> " + egovMessageSource.getMessage("ezResource.t72", locale) + " <BR></dd>";
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
		
		return "admin/ezResource/resGwBoardPostBoardDel";
	}
	
	/**
	 * 자원관리 분류삭제 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callBrdDel.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdDel(@RequestBody String xmlStr, @CookieValue("loginCookie") String  loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		boolean result = ezResourceAdminService.delClsData(xmlStr, userInfo.getTenantId());
		return String.valueOf(result);
	}
	
	/**
	 * 자원관리 권한설정 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callBrdMng.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdMng(@RequestBody String xmlStr, @CookieValue("loginCookie") String  loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		boolean check = ezResourceAdminService.userResPermissionCheck(xmlStr, userInfo.getTenantId());
		
		if(!check) {
			return "NO";
		}
			
		boolean result = ezResourceAdminService.saveACLLst(xmlStr, userInfo.getTenantId());
		
		return String.valueOf(result);
	}
	
	@RequestMapping(value = "/admin/ezResource/gwBoardListStatus.do", method = RequestMethod.GET)
	public String gwBoardListStatus(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
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
		model.addAttribute("deptPathCode", userInfo.getDeptPathCode());
		model.addAttribute("selectedCompany", Optional.ofNullable(req.getParameter("selCompanyID")).orElse(userInfo.getCompanyID()));
		return "admin/ezResource/resGwBoardListStatus";
	}
	
	@RequestMapping(value = "/admin/ezResource/scheduleGet.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGet(@RequestBody String xmlStr, HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("scheduleGet Start");
		logger.debug("xmlStr=" + xmlStr);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String reVal = "";
		String resID = "";
		String type = "";
		String resultXML = "";
		int page = 0;
		
		if (req.getParameter("resID") != null) {
			resID = req.getParameter("resID");
		}
		if (req.getParameter("pType") != null) {
			type = req.getParameter("pType");
		}
		if (req.getParameter("page") != null) {
			page = Integer.parseInt(req.getParameter("page"));
		}
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		// 2023-05-25 이사라 : 시큐어코딩 문자열 비교 오류 수정
		if(StringUtils.isEmpty(xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent())) {
			return "";
		} else if(StringUtils.isEmpty(xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent())) {
			return "";
		}
		
		xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent().substring(0, 10));
		xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent().substring(0, 10));
		xmlDom.getElementsByTagName("NOWTIME").item(0).setTextContent(xmlDom.getElementsByTagName("NOWTIME").item(0).getTextContent());
		
		//스케줄 정보 가져옴
		reVal = ezResourceAdminService.getScheduleXML(commonUtil.convertDocumentToString(xmlDom), resID, userInfo.getCompanyID(), userInfo.getTenantId(), type, userInfo.getOffset());
		logger.debug("getScheduleXML=" + reVal);
		
		Document tempXML = commonUtil.convertStringToDocument(reVal);
			
		for (int i = 0; i < tempXML.getElementsByTagName("ROW").getLength(); i++) {
			Element count = tempXML.createElement("count");
			count.setTextContent(i + "");
			tempXML.getElementsByTagName("ROW").item(i).appendChild(count);
		}
			
		reVal = commonUtil.convertDocumentToString(tempXML);
			
		resultXML += "<root>";
		for (int i = 0; i < tempXML.getElementsByTagName("ROW").getLength(); i++) {
			int startCount = Math.multiplyExact(Math.subtractExact(page, 1), 20);
			int endCount = Math.multiplyExact(page, 20);

			if (Integer.parseInt(tempXML.getElementsByTagName("count").item(i).getTextContent()) >= startCount && Integer.parseInt(tempXML.getElementsByTagName("count").item(i).getTextContent())< endCount) {
				resultXML += "<appointment>";
				resultXML += "<num>" + tempXML.getElementsByTagName("num").item(i).getTextContent() + "</num>";
				resultXML += "<pnum>" + tempXML.getElementsByTagName("pnum").item(i).getTextContent() + "</pnum>";
				resultXML += "<ownerID>" + tempXML.getElementsByTagName("ownerID").item(i).getTextContent() + "</ownerID>";
				resultXML += "<title>" + tempXML.getElementsByTagName("title").item(i).getTextContent() + "</title>";
				resultXML += "<location>" + tempXML.getElementsByTagName("location").item(i).getTextContent() + "</location>";
				resultXML += "<timeDisplay>" + tempXML.getElementsByTagName("timeDisplay").item(i).getTextContent() + "</timeDisplay>";
				resultXML += "<startDate>" + tempXML.getElementsByTagName("startDate").item(i).getTextContent() + "</startDate>";
				resultXML += "<endDate>" + tempXML.getElementsByTagName("endDate").item(i).getTextContent() + "</endDate>";
				resultXML += "<alertTime>" + tempXML.getElementsByTagName("alertTime").item(i).getTextContent() + "</alertTime>";
				resultXML += "<reFlag>" + tempXML.getElementsByTagName("reFlag").item(i).getTextContent() + "</reFlag>";
				resultXML += "<gresFlag>" + tempXML.getElementsByTagName("gresFlag").item(i).getTextContent() + "</gresFlag>";
				resultXML += "<writerID>" + tempXML.getElementsByTagName("writerID").item(i).getTextContent() + "</writerID>";
				resultXML += "<importance>" + tempXML.getElementsByTagName("importance").item(i).getTextContent() + "</importance>";
				resultXML += "<entryList>" + tempXML.getElementsByTagName("entryList").item(i).getTextContent() + "</entryList>";
				resultXML += "<allDay>" + tempXML.getElementsByTagName("allDay").item(i).getTextContent() + "</allDay>";
				resultXML += "<writeDay>" + tempXML.getElementsByTagName("writeDay").item(i).getTextContent() + "</writeDay>";
				resultXML += "<attachFlag>" + tempXML.getElementsByTagName("attachFlag").item(i).getTextContent() + "</attachFlag>";
				resultXML += "<characterID>" + tempXML.getElementsByTagName("characterID").item(i).getTextContent() + "</characterID>";
				resultXML += "<approveFlag>" + tempXML.getElementsByTagName("approveFlag").item(i).getTextContent() + "</approveFlag>";
				resultXML += "<returnFlag>" + tempXML.getElementsByTagName("returnFlag").item(i).getTextContent() + "</returnFlag>";
				resultXML += "<useApprove>" + tempXML.getElementsByTagName("useApprove").item(i).getTextContent() + "</useApprove>";
				resultXML += "<useReturn>" + tempXML.getElementsByTagName("useReturn").item(i).getTextContent() + "</useReturn>";
				resultXML += "<nowDate>" + tempXML.getElementsByTagName("nowDate").item(i).getTextContent() + "</nowDate>";
				resultXML += "<ownerNM>" + tempXML.getElementsByTagName("ownerNM").item(i).getTextContent() + "</ownerNM>";
				resultXML += "<deptNM>" + tempXML.getElementsByTagName("deptNM").item(i).getTextContent() + "</deptNM>";
				resultXML += "<count>" + tempXML.getElementsByTagName("count").item(i).getTextContent() + "</count>";
				resultXML += "</appointment>";
			}
		}
		resultXML += "<totalcount>" + tempXML.getElementsByTagName("ROW").getLength() + "</totalcount>";
		resultXML += "</root>";
		reVal = resultXML;
				
		logger.debug("scheduleGet End");
		return reVal;
	}
}
