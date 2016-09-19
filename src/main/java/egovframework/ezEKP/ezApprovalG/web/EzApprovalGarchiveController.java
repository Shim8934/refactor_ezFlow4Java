package egovframework.ezEKP.ezApprovalG.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzApprovalGarchiveController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private Properties globals;
	
	@Resource(name = "crypto") 
    private EgovFileScrty egovFileScrty;

	@Resource(name = "EzApprovalGService")
	private EzApprovalGService ezApprovalGService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Autowired
	private EgovMessageSource messageSource;
	
	/*
	 * 기록물대장 리스트
	 */
	@RequestMapping(value = "/ezApprovalG/cabinetMain.do"  ,produces="text/xml;charset=utf-8")
	public String cabinetmain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String sFlag = (request.getParameter("sFlag") != null ? request.getParameter("sFlag") : "");
		String contType = "END";
		String dirpath = config.getProperty("upload_approvalG.ROOT") + commonUtil.separator + userInfo.getCompanyID() + commonUtil.separator + "doc";
		String deptInfo = "";
		String buJaeInfo = "";
		String susinAdmin = "";
    	// OCS 사용 여부
	    String useOcs = config.getProperty("config.USE_OCS");
	    String userEmail = userInfo.getEmail();
	    String use_Editor = config.getProperty("config.EDITOR"); 
	    String use_IE11Browser = config.getProperty("config.IE11EDITOR");
	    String openYear = config.getProperty("config.Site_OpenYear");
	    String nonActiveX = "YES";
	    
        if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && use_IE11Browser.equals("CK")) {
        	use_IE11Browser ="CK";
        }
    	if (userInfo.getRollInfo().indexOf("a=1") > -1) {
    		susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
    	
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getPrimary());
		Document doc = commonUtil.convertStringToDocument(result);
		deptInfo  = doc.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent();
		buJaeInfo = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent().trim();
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("nonActiveX", nonActiveX);
		model.addAttribute("dirpath", dirpath);
		model.addAttribute("deptInfo", deptInfo);
		model.addAttribute("buJaeInfo", buJaeInfo);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userEmail", userEmail);
		model.addAttribute("use_Editor", use_Editor);
		model.addAttribute("openYear", openYear);
		model.addAttribute("contType", contType);
		model.addAttribute("sFlag", sFlag);
		
		return "ezApprovalG/apprGcabinetMain";
	}
	
	@RequestMapping(value = "/ezApprovalG/sendOfferCheck.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String sendOfferCheck(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String pDocID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String pUserID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String result=ezApprovalGService.sendOfferCheck(pDocID, pUserID, "MUST", userInfo.getCompanyID(), userInfo.getLang());
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/contDocView_NoDoc.do"  ,produces="text/xml;charset=utf-8")
	public String contDocView_NoDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID=request.getParameter("docID");
		String docHref=request.getParameter("docHref");
		String docType=request.getParameter("docType");
		String orgDocID=request.getParameter("orgDocID");
		String formID=request.getParameter("formID");;
		String endDir=request.getParameter("endDir");
		String docTitle=request.getParameter("docTitle");
		String listSusin=request.getParameter("listSusin");
		String susinAdmin=request.getParameter("susinAdmin");
		String g_RecID=request.getParameter("g_RecID");
		String g_SepAttNo=request.getParameter("g_SepAttNo");
		String nonActiveX="YES";
		
		if (userInfo.getRollInfo().indexOf("a=1") > -1)
			susinAdmin = "YES";
        else
        	susinAdmin = "NO";
		String accessInfo = config.getProperty("config.UserInfo_ApprovalG_VIEW");
		String pass=ezApprovalGService.getAccessYNG(docID, userInfo.getId(), accessInfo, userInfo.getCompanyID(), userInfo.getLang());
		
		if(pass.equals("<RESULT>TRUE</RESULT>")){
			String readRecXML = "<PARAMETER><DOCID>" + makeXMLString(docID) +
                    "</DOCID><USERID>" + makeXMLString(userInfo.getId()) +
                    "</USERID><USERNAME>" + makeXMLString(userInfo.getDisplayName1()) +
                    "</USERNAME><USERTITLE>" + makeXMLString(userInfo.getTitle1()) +
                    "</USERTITLE><DEPTCODE>" + makeXMLString(userInfo.getDeptID()) +
                    "</DEPTCODE><DEPTNAME>" + makeXMLString(userInfo.getDeptName1()) +
                    "</DEPTNAME><COMPANYID>" + makeXMLString(userInfo.getCompanyID()) +
                    "</COMPANYID><USERNAME2>" + makeXMLString(userInfo.getDisplayName2()) +
                    "</USERNAME2><USERTITLE2>" + makeXMLString(userInfo.getTitle2()) +
                    "</USERTITLE2><DEPTNAME2>" + makeXMLString(userInfo.getDeptName2()) +
                    "</DEPTNAME2></PARAMETER>";
			ezApprovalGService.saveRecReadHist(readRecXML);
		}
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("nonActiveX", nonActiveX);
		model.addAttribute("docHref", docHref);
		model.addAttribute("docType", docType);
		model.addAttribute("orgDocID", orgDocID);
		model.addAttribute("formID", formID);
		model.addAttribute("endDir", endDir);
		model.addAttribute("docTitle", docTitle);
		model.addAttribute("listSusin", listSusin);
		model.addAttribute("g_RecID", g_RecID);
		model.addAttribute("g_SepAttNo",g_SepAttNo);
		return "ezApprovalG/apprGcontDocView_NoDoc";
	}
	
	public String makeXMLString(String orgString) throws Exception{
		return orgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecordInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecordInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.GetRecordInfo(xmlDom, userInfo.getPrimary());
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/regRecord.do"  ,produces="text/xml;charset=utf-8")
	public String regRecord(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String useEditor=config.getProperty("config.EDITOR");
		String useIE11Browser=config.getProperty("config.IE11EDITOR");
	     if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && useIE11Browser.equals("CK")) {
	    	 useIE11Browser ="CK";
	     }
	     Date dt = new Date();
	     SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm"); 
	     String regY=sdf.format(dt).toString().substring(0,4);
	     String regM=sdf.format(dt).toString().substring(5,7);
	     String regD=sdf.format(dt).toString().substring(8,10);
	     String regH=sdf.format(dt).toString().substring(11,13);
	     String regMi=sdf.format(dt).toString().substring(14,16);
	     model.addAttribute("userInfo", userInfo);
	     model.addAttribute("useEditor", useEditor);
	     model.addAttribute("regY", regY);
	     model.addAttribute("regM", regM);
	     model.addAttribute("regD", regD);
	     model.addAttribute("regH", regH);
	     model.addAttribute("regMi", regMi);
	     return "ezApprovalG/apprGregrecord";
	}
	 
	@RequestMapping(value = "/ezApprovalG/setRecUserRole.do"  ,produces="text/xml;charset=utf-8")
	public String setRecUserRole(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		  model.addAttribute("userInfo", userInfo);
		return "ezApprovalG/apprGsetRecUserRole";
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecViewerInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecViewerInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getRecViewer(xmlDom,userInfo.getLang());
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/saveRecUserRole.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String saveRecUserRole(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.saveRecUserRoleInfo(xmlDom,userInfo.getLang());
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/viewRecReadHistory.do"  ,produces="text/xml;charset=utf-8")
	public String viewRecReadHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezApprovalG/apprGviewRecReadHistory";
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecReadHistory.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecReadHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getRecReadHistory(xmlDom);
		return result;
	}
	
	/** 기록물등록대장 등록정보 화면 호출*/
	@RequestMapping(value = "/ezApprovalG/viewRecInfo.do"  ,produces="text/xml;charset=utf-8")
	public String viewRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
	    String Use_IE11Browser = "";
		userInfo = commonUtil.aprUserInfo(loginCookie);
		   if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && Use_IE11Browser.equals("CK")) {
			   Use_IE11Browser ="CK";
	        }
		   model.addAttribute("userInfo", userInfo);
		return "ezApprovalG/apprGviewRecInfo";
	}
	
	/** 기록물등록대장 등록정보 화면 분류정보 탭*/
	@RequestMapping(value = "/ezApprovalG/getRecClassInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecClassInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getRecordClassInfo(xmlDom);
		return result;
	}
	
	/** 기록물등록대장 변경이력 화면*/
	@RequestMapping(value = "/ezApprovalG/viewRecHistory.do"  ,produces="text/xml;charset=utf-8")
	public String viewRecHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
	    String Use_IE11Browser = "";
		userInfo = commonUtil.aprUserInfo(loginCookie);
		   if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && Use_IE11Browser.equals("CK")) {
			   Use_IE11Browser ="CK";
	        }
		   model.addAttribute("userInfo", userInfo);
			return "ezApprovalG/apprGviewRecHistory";
	}
	
	/** 기록물등록대장 변경이력 화면 상세정보*/
	@RequestMapping(value = "/ezApprovalG/getRecordHistory.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecordHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,Locale locale, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String result=ezApprovalGService.getRecordHistory(xmlDom,userInfo);
		Document xmlResult = commonUtil.convertStringToDocument(result);
		
		if (xmlResult.getElementsByTagName("ROW") != null){
			for (int k = 0; k < xmlResult.getElementsByTagName("ROW").getLength(); k++) {
				if (!xmlResult.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getChildNodes().item(0).getTextContent().trim().equals("")) {
				xmlResult.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getChildNodes().item(0).setTextContent(messageSource.getMessage(("ezApprovalG."+xmlResult.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getChildNodes().item(0).getTextContent().trim()),locale));
				}
			}
		}
		return commonUtil.convertDocumentToString(xmlResult);
	}
	
	/** 기록물등록대장 이동 */
	@RequestMapping(value = "/ezApprovalG/moveRecord.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String moveRecord(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,Locale locale, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.moveRecord(xmlDom,userInfo.getLang());
		Document xmlResult = commonUtil.convertStringToDocument(result);
		
		return commonUtil.convertDocumentToString(xmlResult);
	}
	
	/** 기록물등록대장 수정 */
	@RequestMapping(value = "/ezApprovalG/changeRecordInfo.do"  ,produces="text/xml;charset=utf-8")
	public String changeRecordInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezApprovalG/apprGchangeRecordInfo";
	}
	
	/** 기록물등록대장 수정 상세화면 */
	@RequestMapping(value = "/ezApprovalG/getRecordSimpleInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecordSimpleInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model , @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String result = ezApprovalGService.getRecordSimpleInfo(xmlDom,userInfo.getLang());
		return result;
	}
	
	/** 기록물등록대장 수정 상세화면 저장 */
	@RequestMapping(value = "/ezApprovalG/changeRecInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String changeRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model , @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String result = ezApprovalGService.changeRecordInfo(xmlDom,userInfo.getLang());
		return result;
	}
	
	/** 기록물등록대장  문서출력 화면 호출*/
	@RequestMapping(value = "/ezApprovalG/docListView.do"  ,produces="text/xml;charset=utf-8")
	public String docListView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "ezApprovalG/apprGdocListView";
	}
	
	/** 기록물등록대장  문서출력 상세화면*/
	@RequestMapping(value = "/ezApprovalG/getDeliveryList.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeliveryList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String p_DeptID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent().trim();
        String pPageNum = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String pPageSize = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
        String pOrderCell = xmlDom.getDocumentElement().getChildNodes().item(3).getTextContent();
        String pOrderOption = xmlDom.getDocumentElement().getChildNodes().item(4).getTextContent();
        String pQuery = xmlDom.getDocumentElement().getChildNodes().item(5).getTextContent();
        String isdocprint = xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent();
        String result = "";
        String deptcode = "";
        String deptcode2 = "";
        String title = "";
        String sregdate = "";
        String eregdate = "";
        String debenturer = "";
        
        if(xmlDom.getDocumentElement().getChildNodes().item(7).getTextContent().equals("0")){
        	result = ezApprovalGService.getDeliveryList(p_DeptID, pPageSize, pPageNum, pOrderCell, pOrderOption, pQuery, userInfo.getCompanyID(), userInfo.getLang(), deptcode, deptcode2, title, sregdate, eregdate, debenturer, isdocprint);
        }
        else{
            deptcode = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(0).getTextContent().trim();
            deptcode2 = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(1).getTextContent().trim();
            title = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(2).getTextContent().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
            sregdate = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(3).getTextContent();
            eregdate = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(4).getTextContent();
            debenturer = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(5).getTextContent().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
            result = ezApprovalGService.getDeliveryList(p_DeptID, pPageSize, pPageNum, pOrderCell, pOrderOption, pQuery, userInfo.getCompanyID(), userInfo.getLang(), deptcode, deptcode2, title, sregdate, eregdate, debenturer, isdocprint);
        }
			return result;
	}
	
	/** 기록물등록대장  새 DocID 생성*/
	@RequestMapping(value = "/ezApprovalG/createNewDocId.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String createNewDocId(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getNewID(userInfo.getCompanyID());
			return result;
	}
	
	/** 기록물등록대장  기록물 등록*/
	@RequestMapping(value = "/ezApprovalG/registerRecord.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String registerRecord(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.registerRecord(xmlDom);
		return result;
	}
	
	/** 기록물등록대장  첨부 추가*/
	@RequestMapping(value = "/ezApprovalG/regRecordAttach.do"  ,produces="text/xml;charset=utf-8")
	public String regRecordAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
        String susinAdmin = "";
        String serverName = request.getServerName();
        String poptExt = "";
        String maxSize = "";
        String isBody = "";
        
        String hasattach = "NO";
        String docID = "NO";
        String realPath = request.getServletContext().getRealPath("");
        docID=request.getParameter("docID") != null ? request.getParameter("docID") : "";
        
        if (userInfo.getRollInfo().indexOf("a=1") > -1) {
    		susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
		poptExt = ezApprovalGService.getOptionInfo("A39", "001", userInfo, "CODE");
		maxSize = ezApprovalGService.getOptionInfo("A39", "002", userInfo, "CODE");
		
		String dirPath = realPath + config.getProperty("upload_approvalG.ROOT") + commonUtil.separator;
		  
	    model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("serverName", serverName);
		model.addAttribute("poptExt", poptExt);
	    model.addAttribute("maxSize", maxSize);
		model.addAttribute("isBody", isBody);
		model.addAttribute("hasattach", hasattach);
		model.addAttribute("docID", docID);
		model.addAttribute("dirPath", dirPath);
		return "/ezApprovalG/apprGregRecordAttach";
	}
	
	
	/** 기록물등록대장  등록정보 인쇄*/
	@RequestMapping(value = "/ezApprovalG/printMetaInfo.do"  ,produces="text/xml;charset=utf-8")
	public String printMetaInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "/ezApprovalG/apprGprintMetaInfo";
	}
	
	/** 기록물등록대장  등록정보 인쇄 상세화면*/
	@RequestMapping(value = "/ezApprovalG/printMetaInfoContent.do"  ,produces="text/xml;charset=utf-8")
	public String printMetaInfoContent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "/ezApprovalG/apprGprintMetaInfoContent";
	}
	
	/** 기록물등록대장  등록정보 인쇄 상세화면*/
	@RequestMapping(value = "/ezApprovalG/printFormRecInfo.do"  ,produces="text/xml;charset=utf-8")
	public String printFormRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);

		String RecID= request.getParameter("ID1");
		String SepAttNo =request.getParameter("ID2");
		String pXml = "<PARAMETERS><RECORDID>" + makeXMLString(RecID.trim()) +
                "</RECORDID><SEPATTACHNO>" + makeXMLString(SepAttNo.trim()) +
                "</SEPATTACHNO><COMPANYID>" + makeXMLString(userInfo.getCompanyID()) +
                // 2010.07.30 다국어
                "</COMPANYID><STRLANG>" + makeXMLString(userInfo.getLang()) + "</STRLANG></PARAMETERS>";
		Document xmlDom = commonUtil.convertStringToDocument(pXml);
		String resultXML = ezApprovalGService.GetRecordInfo(xmlDom, userInfo.getLang());
		String resultXML2 = ezApprovalGService.getRecordClassInfo(xmlDom);
		
		Document oBXml = commonUtil.convertStringToDocument(resultXML);
		String title = oBXml.getElementsByTagName("TITLE").item(0).getTextContent().trim();
		String regType= oBXml.getElementsByTagName("REGTYPE").item(0).getTextContent().trim();
		String deptName= oBXml.getElementsByTagName("DEPTNAME").item(0).getTextContent().trim();
		String regNo= oBXml.getElementsByTagName("REGNO").item(0).getTextContent().trim();
		String sepAttachNo= oBXml.getElementsByTagName("SEPATTACHNO").item(0).getTextContent().trim();
		String drafter = oBXml.getElementsByTagName("DRAFTER").item(0).getTextContent().trim();
		String aprMember= oBXml.getElementsByTagName("APRMEMBER").item(0).getTextContent().trim();
		String regDate = oBXml.getElementsByTagName("REGDATE").item(0).getTextContent().trim();
		String executeDate = oBXml.getElementsByTagName("EXECUTEDATE").item(0).getTextContent().trim();
		String receiptMember = oBXml.getElementsByTagName("RECEIPTMEMBER").item(0).getTextContent().trim();
		String deliveryNo = oBXml.getElementsByTagName("DELIVERYNO").item(0).getTextContent().trim();
		String produceDeptSn = oBXml.getElementsByTagName("PRODUCEDEPTSN").item(0).getTextContent().trim();
		String modifyFlag = oBXml.getElementsByTagName("MODIFYFLAG").item(0).getTextContent().trim();
		String rejectFalge = oBXml.getElementsByTagName("REJECTFLAG").item(0).getTextContent().trim();
		String electronicFlag = oBXml.getElementsByTagName("ELECTRONICFLAG").item(0).getTextContent().trim();
		String oldFlag = oBXml.getElementsByTagName("OLDFLAG").item(0).getTextContent().trim();
		String oldProduceDept = oBXml.getElementsByTagName("OLDPRODUCEDEPT").item(0).getTextContent().trim();
		String oldRecNo = oBXml.getElementsByTagName("OLDRECNO").item(0).getTextContent().trim();
		String oldRecKp = oBXml.getElementsByTagName("OLDRECKP").item(0).getTextContent().trim();
		String avSummary = oBXml.getElementsByTagName("AVSUMMARY").item(0).getTextContent().trim();
		String avType = oBXml.getElementsByTagName("AVTYPE").item(0).getTextContent().trim();
		
		Document oCXml = commonUtil.convertStringToDocument(resultXML2);
		String cabClassID = oCXml.getElementsByTagName("CABCLASSID").item(0).getTextContent().trim(); 
		String cabTitle = oCXml.getElementsByTagName("CABTITLE").item(0).getTextContent().trim();
		String specialRecCode = oCXml.getElementsByTagName("SPECIALRECCODE").item(0).getTextContent().trim();
		String publicCode = oCXml.getElementsByTagName("PUBLICCODE").item(0).getTextContent().trim();
		String limitRange = oCXml.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim();
		String confirmFlag = oCXml.getElementsByTagName("CONFIRMFLAG").item(0).getTextContent().trim();
		String catatransFlag = oCXml.getElementsByTagName("CATATRANSFLAG").item(0).getTextContent().trim();
		String catatransYear = oCXml.getElementsByTagName("CATATRANSYEAR").item(0).getTextContent().trim();
		String docTransFlag = oCXml.getElementsByTagName("DOCTRANSFLAG").item(0).getTextContent().trim();
		String docTransYear = oCXml.getElementsByTagName("DOCTRANSYEAR").item(0).getTextContent().trim();
		
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("title", title);
		model.addAttribute("regType", regType);
		model.addAttribute("deptName", deptName);
		model.addAttribute("regNo", regNo);
		model.addAttribute("sepAttachNo", sepAttachNo);
		model.addAttribute("drafter", drafter);
		model.addAttribute("aprMember", aprMember);
		model.addAttribute("regDate", regDate);
		model.addAttribute("executeDate", executeDate);
		model.addAttribute("receiptMember", receiptMember);
		model.addAttribute("deliveryNo", deliveryNo);
		model.addAttribute("produceDeptSn", produceDeptSn);
		model.addAttribute("modifyFlag", modifyFlag);
		model.addAttribute("rejectFalge", rejectFalge);
		model.addAttribute("electronicFlag", electronicFlag);
		model.addAttribute("oldFlag", oldFlag);
		model.addAttribute("oldProduceDept", oldProduceDept);
		model.addAttribute("oldRecNo", oldRecNo);
		model.addAttribute("oldRecKp", oldRecKp);
		model.addAttribute("avSummary", avSummary);
		model.addAttribute("avType", avType);
		model.addAttribute("cabClassID", cabClassID);
		model.addAttribute("cabTitle", cabTitle);
		model.addAttribute("specialRecCode", specialRecCode);
		model.addAttribute("publicCode", publicCode);
		model.addAttribute("limitRange", limitRange);
		model.addAttribute("confirmFlag", confirmFlag);
		model.addAttribute("catatransFlag", catatransFlag);
		model.addAttribute("catatransYear", catatransYear);
		model.addAttribute("docTransFlag", docTransFlag);
		model.addAttribute("docTransYear", docTransYear);
		
		
		return "/ezApprovalG/apprGprintFormRecInfo";
	}
	
	/** 기록물등록대장 재발송*/
	@RequestMapping(value = "/ezApprovalG/ezSelectSusin.do"  ,produces="text/xml;charset=utf-8")
	public String ezSelectSusin(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String susinAdmin ="";
		String serverName = request.getServerName();
		String susinXML="";
		
    	if (userInfo.getRollInfo().indexOf("a=1") > -1) {
    		susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
    	if(userInfo.getLang().equals("1")){
    		susinXML="/xml/ezApprovalG/TreeViewEndAddDept.xml";
    	}
    	else{
    		susinXML="/xml/ezApprovalG/TreeViewEndAddDept" + userInfo.getLang() + ".xml";
    	}
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("susinAdmin", susinAdmin);
		model.addAttribute("serverName", serverName);
		model.addAttribute("susinXML", susinXML);
		
		return "/ezApprovalG/apprGezSelectSusin";
	}
	
	/** 기록물등록대장 발송의뢰*/
	@RequestMapping(value = "/ezApprovalG/ezSelectOne.do"  ,produces="text/xml;charset=utf-8")
	public String ezSelectOne(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String susinAdmin ="";
		String serverName = request.getServerName();
		String susinXML="";
		String mDeptInfo="";
		
    	if (userInfo.getRollInfo().indexOf("a=1") > -1) {
    		susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
    	
    	String searchList ="extensionAttribute4::" + userInfo.getCompanyID().trim();
    	String strRetXml = ezOrganService.getSearchList(searchList, "" , "" , "group" , 100 , userInfo.getLang());
    	Document xmlResult = commonUtil.convertStringToDocument(strRetXml); 
    	
    	if(xmlResult.getElementsByTagName("DATA2").getLength() > 0){
    		mDeptInfo = xmlResult.getElementsByTagName("DATA2").item(0).getTextContent();
    	}
    	model.addAttribute("userInfo", userInfo);
    	model.addAttribute("susinAdmin", susinAdmin);
    	model.addAttribute("serverName", serverName);
    	model.addAttribute("susinXML", susinXML);
    	model.addAttribute("mDeptInfo", mDeptInfo);
		return "/ezApprovalG/apprGezSelectOne";
	}
	
	/** 기록물철등록부 발송의뢰 저장1*/
	@RequestMapping(value = "/ezApprovalG/updateReceiptOffer.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String updateReceiptOffer(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent();
		String orgDocID = xmlDom.getElementsByTagName("OrgDocID").item(0).getTextContent();
		String result=ezApprovalGService.updateReceiptOffer(docID,orgDocID,userInfo.getCompanyID());
		return result;
	}
	
	/** 기록물철등록부 발송의뢰 저장2*/
	@RequestMapping(value = "/ezApprovalG/sendOfferG.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String sendOfferG(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
   		String realPath = request.getServletContext().getRealPath("");
		String dirPath =  realPath + config.getProperty("upload_approvalG.ROOT") + commonUtil.separator;
		String result=ezApprovalGService.doSendOffer(xmlDom,dirPath , userInfo.getCompanyID(), userInfo.getLang());
		return result;
	}
	
	/** 기록물철등록부 화면*/
	@RequestMapping(value = "/ezApprovalG/getCabinetList.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getCabinetList(xmlDom,userInfo);
		return result;
	}
	
	/** 기록물철등록부 철등록*/
	@RequestMapping(value = "/ezApprovalG/regCabinet.do"  ,produces="text/xml;charset=utf-8")
	public String regCabinet(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "/ezApprovalG/apprGregCabinet";
	}
	
	/** 기록물철등록부 상세보기*/
	@RequestMapping(value = "/ezApprovalG/viewCabInfo.do"  ,produces="text/xml;charset=utf-8")
	public String viewCabInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String IE11="";
		  if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0)) {
	        	IE11 ="YES";
	        }
		model.addAttribute("IE11", IE11);
		model.addAttribute("userInfo", userInfo);
			return "/ezApprovalG/apprGviewCabInfo";
	}
	
	/** 기록물철등록부 상세보기*/
	@RequestMapping(value = "/ezApprovalG/getCabinetDetailInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetDetailInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getCabinetDetailInfo(xmlDom);
		return result;
	}
	
	/** 기록물철등록부 상세보기 특수목록탭*/
	@RequestMapping(value = "/ezApprovalG/getCabSCInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getCabSCInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getCabScInfo(xmlDom);
		return result;
	}
	
	/** 기록물철등록부 상세보기 인쇄*/
	@RequestMapping(value = "/ezApprovalG/printFormCabInfo.do"  ,produces="text/xml;charset=utf-8")
	public String printFormCabInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		  String STRGet_t106 = "";
          String STRGet_t117 = "";
          String STRGet_t573 = "";
          String STRGet_t574 = "";
          String STRGet_t576 = "";
          String STRGet_t577 = "";
          String STRGet_t599 = "";
          String STRGet_t600 = "";
          String STRGet_t816 = "";
          String STRGet_t819 = "";
          String STRGet_t825 = "";
          String STRGet_t826 = "";
          String STRGet_t827 = "";
          String STRGet_t828 = "";
          String STRGet_t829 = "";
          String STRGet_t830 = "";
          String STRGet_t831 = "";
          String STRGet_t832 = "";
          String STRGet_t833 = "";
          String STRGet_t834 = "";
          String STRGet_t835 = "";
          String STRGet_t836 = "";
          String STRGet_t837 = "";
          String STRGet_t838 = "";
          String STRGet_t839 = "";
          String STRGet_t840 = "";
          String STRGet_t841 = "";
          String STRGet_t842 = "";;
          String STRGet_t843 = "";
          String STRGet_t844 = "";
          String STRGet_t845 = "";
          String STRGet_t846 = "";
          String STRGet_t847 = "";
          String STRGet_t848 = "";
          String STRGet_t849 = "";
          String STRGet_t850 = "";
          String STRGet_t851 = "";
          String STRGet_t852 = "";
          String STRGet_t853 = "";
          String STRGet_t854 = "";
          String STRGet_t855 = "";
          String STRGet_t856 = "";
		  userInfo = commonUtil.aprUserInfo(loginCookie);
			String cabinetID= request.getParameter("ID1");
			String pXml = "<PARAMETERS><CABINETID>" + makeXMLString(cabinetID.trim()) +
                    "</CABINETID><COMPANYID>" + makeXMLString(userInfo.getCompanyID()) +
                    "</COMPANYID><STRTYPE>" + makeXMLString(userInfo.getLang()) + "</STRTYPE></PARAMETERS>";
			
			Document xmlDom = commonUtil.convertStringToDocument(pXml);
			String resultXML = ezApprovalGService.getCabinetPrintInfo(xmlDom,userInfo.getLang());
			Document oXml = commonUtil.convertStringToDocument(resultXML);
			
			String title = oXml.getElementsByTagName("TITLE").item(0).getTextContent().trim();
			String cabClassID= oXml.getElementsByTagName("CABCLASSID").item(0).getTextContent().trim();
			String recType= oXml.getElementsByTagName("RECTYPE").item(0).getTextContent().trim();
			String deptName= oXml.getElementsByTagName("DEPTNAME").item(0).getTextContent().trim();
			String taskName= oXml.getElementsByTagName("TASKNAME").item(0).getTextContent().trim();
			String produceY = oXml.getElementsByTagName("PRODUCEY").item(0).getTextContent().trim();
			String regSn = oXml.getElementsByTagName("REGSN").item(0).getTextContent().trim();
			String volNo = oXml.getElementsByTagName("VOLNO").item(0).getTextContent().trim();
			String regDate = oXml.getElementsByTagName("REGDATE").item(0).getTextContent().trim();
			String numOfRec = oXml.getElementsByTagName("NUMOFREC").item(0).getTextContent().trim();
			String numOfPage = oXml.getElementsByTagName("NUMOFPAGE").item(0).getTextContent().trim();
			String numOfFile = oXml.getElementsByTagName("NUMOFFILE").item(0).getTextContent().trim();
			
			String modifyFlag = oXml.getElementsByTagName("MODIFYFLAG").item(0).getTextContent().trim();
			String oldFlag = oXml.getElementsByTagName("OLDFLAG").item(0).getTextContent().trim();
			String oldCreateOrgan = oXml.getElementsByTagName("OLDCREATEORGAN").item(0).getTextContent().trim();
			String oldClassNo = oXml.getElementsByTagName("OLDCLASSNO").item(0).getTextContent().trim();
			String endY = oXml.getElementsByTagName("ENDY").item(0).getTextContent().trim();
			String keepPeriod = oXml.getElementsByTagName("KEEPPERIOD").item(0).getTextContent().trim();
			String keepMethod = oXml.getElementsByTagName("KEEPMETHOD").item(0).getTextContent().trim();
			String keepPlace = oXml.getElementsByTagName("KEEPPLACE").item(0).getTextContent().trim();
			String dispEndDate = oXml.getElementsByTagName("DISPENDDATE").item(0).getTextContent().trim();
			String dispReason = oXml.getElementsByTagName("DISPREASON").item(0).getTextContent().trim();
			String cabCharger = oXml.getElementsByTagName("CABCHARGER").item(0).getTextContent().trim();
			String confirmFlag = oXml.getElementsByTagName("CONFIRMFLAG").item(0).getTextContent().trim();
			String cataTransFlag = oXml.getElementsByTagName("CATATRANSFLAG").item(0).getTextContent().trim();
			String cataTransYear = oXml.getElementsByTagName("CATATRANSYEAR").item(0).getTextContent().trim();
			String docTransFlag = oXml.getElementsByTagName("DOCTRANSFLAG").item(0).getTextContent().trim();
			String docTransYear = oXml.getElementsByTagName("DOCTRANSYEAR").item(0).getTextContent().trim();
			String cabTransFlag = oXml.getElementsByTagName("CABTRANSFLAG").item(0).getTextContent().trim();
			String transDate = oXml.getElementsByTagName("TRANSDATE").item(0).getTextContent().trim();
			
			String tDeptName = oXml.getElementsByTagName("TDEPTNAME").item(0).getTextContent().trim();
			String tDeptCode = oXml.getElementsByTagName("TDEPTCODE").item(0).getTextContent().trim();
			String tTaskName = oXml.getElementsByTagName("TTASKNAME").item(0).getTextContent().trim();
			String tTaskCode = oXml.getElementsByTagName("TTASKCODE").item(0).getTextContent().trim();
			String tProduceY = oXml.getElementsByTagName("TPRODUCEY").item(0).getTextContent().trim();
			String tRegSn = oXml.getElementsByTagName("TREGSN").item(0).getTextContent().trim();
			String tVolNo = oXml.getElementsByTagName("TVOLNO").item(0).getTextContent().trim();
			
			model.addAttribute("STRGet_t106", STRGet_t106);
			model.addAttribute("STRGet_t117", STRGet_t117);
			model.addAttribute("STRGet_t573", STRGet_t573);
			model.addAttribute("STRGet_t574", STRGet_t574);
			model.addAttribute("STRGet_t576", STRGet_t576);
			model.addAttribute("STRGet_t577", STRGet_t577);
			model.addAttribute("STRGet_t599", STRGet_t599);
			model.addAttribute("STRGet_t600", STRGet_t600);
			model.addAttribute("STRGet_t816", STRGet_t816);
			model.addAttribute("STRGet_t819", STRGet_t819);
			model.addAttribute("STRGet_t825", STRGet_t825);
			model.addAttribute("STRGet_t826", STRGet_t826);
			model.addAttribute("STRGet_t827", STRGet_t827);
			model.addAttribute("STRGet_t828", STRGet_t828);
			model.addAttribute("STRGet_t829", STRGet_t829);
			model.addAttribute("STRGet_t830", STRGet_t830);
			model.addAttribute("STRGet_t831", STRGet_t831);
			model.addAttribute("STRGet_t832", STRGet_t832);
			model.addAttribute("STRGet_t833", STRGet_t833);
			model.addAttribute("STRGet_t834", STRGet_t834);
			model.addAttribute("STRGet_t835", STRGet_t835);
			model.addAttribute("STRGet_t836", STRGet_t836);
			model.addAttribute("STRGet_t837", STRGet_t837);
			model.addAttribute("STRGet_t838", STRGet_t838);
			model.addAttribute("STRGet_t839", STRGet_t839);
			model.addAttribute("STRGet_t840", STRGet_t840);
			model.addAttribute("STRGet_t841", STRGet_t841);
			model.addAttribute("STRGet_t842", STRGet_t842);
			model.addAttribute("STRGet_t843", STRGet_t843);
			model.addAttribute("STRGet_t844", STRGet_t844);
			model.addAttribute("STRGet_t845", STRGet_t845);
			model.addAttribute("STRGet_t846", STRGet_t846);
			model.addAttribute("STRGet_t847", STRGet_t847);
			model.addAttribute("STRGet_t848", STRGet_t848);
			model.addAttribute("STRGet_t849", STRGet_t849);
			model.addAttribute("STRGet_t850", STRGet_t850);
			model.addAttribute("STRGet_t851", STRGet_t851);
			model.addAttribute("STRGet_t852", STRGet_t852);
			model.addAttribute("STRGet_t853", STRGet_t853);
			model.addAttribute("STRGet_t854", STRGet_t854);
			model.addAttribute("STRGet_t855", STRGet_t855);
			model.addAttribute("STRGet_t856", STRGet_t856);
			model.addAttribute("title", title);
			model.addAttribute("cabClassID", cabClassID);
			model.addAttribute("recType", recType);
			model.addAttribute("deptName", deptName);
			model.addAttribute("taskName", taskName);
			model.addAttribute("produceY", produceY);
			model.addAttribute("regSn", regSn);
			model.addAttribute("volNo", volNo);
			
			model.addAttribute("regDate", regDate);
			model.addAttribute("numOfRec", numOfRec);
			model.addAttribute("numOfPage", numOfPage);
			model.addAttribute("numOfFile", numOfFile);
			model.addAttribute("modifyFlag", modifyFlag);
			model.addAttribute("oldFlag", oldFlag);
			model.addAttribute("oldCreateOrgan", oldCreateOrgan);
			model.addAttribute("oldClassNo", oldClassNo);
			model.addAttribute("endY", endY);
			model.addAttribute("keepPeriod", keepPeriod);
			model.addAttribute("keepMethod", keepMethod);
			model.addAttribute("keepPlace", keepPlace);
			model.addAttribute("dispEndDate", dispEndDate);
			model.addAttribute("dispReason", dispReason);
			model.addAttribute("cabCharger", cabCharger);
			model.addAttribute("confirmFlag", confirmFlag);
			model.addAttribute("cataTransFlag", cataTransFlag);
			model.addAttribute("cataTransYear", cataTransYear);
			model.addAttribute("docTransFlag", docTransFlag);
			model.addAttribute("docTransYear", docTransYear);
			model.addAttribute("cabTransFlag",cabTransFlag);
			model.addAttribute("transDate", transDate);
			model.addAttribute("tDeptName", tDeptName);
			model.addAttribute("tDeptCode", tDeptCode);
			model.addAttribute("tTaskName", tTaskName);
			model.addAttribute("tTaskCode", tTaskCode);
			model.addAttribute("tProduceY", tProduceY);
			model.addAttribute("tRegSn", tRegSn);
			model.addAttribute("tVolNo", tVolNo);
			
			return "/ezApprovalG/apprGprintFormCabInfo";
	}
	
	/** 기록물철등록부 수정버튼*/
	@RequestMapping(value = "/ezApprovalG/changeCabinetInfo.do"  ,produces="text/xml;charset=utf-8")
	public String changeCabinetInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "/ezApprovalG/apprGchangeCabinetInfo";
	}
	
	/** 기록물철등록부 수정버튼*/
	@RequestMapping(value = "/ezApprovalG/getCabinetSimpleInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetSimpleInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getCabinetSimpleInfo(xmlDom);
		return result ;
	}
	
	/** 기록물철등록부 수정 등록*/
	@RequestMapping(value = "/ezApprovalG/changeCabInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String changeCabInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.changeCabinetInfo(xmlDom);
		return result ;
	}
	
	/** 기록물철등록부 이력보기 화면*/
	@RequestMapping(value = "/ezApprovalG/viewCabHistory.do"  ,produces="text/xml;charset=utf-8")
	public String viewCabHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "/ezApprovalG/apprGviewCabHistory";
	}
	
	/** 기록물철등록부 이력보기 화면 상세내용*/
	@RequestMapping(value = "/ezApprovalG/getCabinetHistory.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getCabinetHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getCabinetHistory(xmlDom, userInfo);
		return result;
	}
	
	/** 기록물철등록부 검색 화면 */
	@RequestMapping(value = "/ezApprovalG/searchCab.do"  ,produces="text/xml;charset=utf-8")
	public String searchCab(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder yearOption = new StringBuilder("");
		int curYear = Integer.parseInt(EgovDateUtil.getTodayTime().substring(0, 4));
		yearOption.append("<Option Value=\"\"></Option>");
		
		for (int i=curYear; i>=curYear-5; i--){
			yearOption.append("<Option Value=\"" + Integer.toString(i) + "\">" + Integer.toString(i) + "</Option>");
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("yearOption", yearOption.toString());
		return "/ezApprovalG/apprGsearchCab";
	}
	
	/** 기록물철등록부 업무담당자 지정  */
	@RequestMapping(value = "/ezApprovalG/setTaskChrger.do"  ,produces="text/xml;charset=utf-8")
	public String setTaskChrger(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "/ezApprovalG/apprGsetTaskChrger";
	}
	
	/** 기록물철등록부 업무담당자지정 상세내용  */
	@RequestMapping(value = "/ezApprovalG/getTaskCharger.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getTaskCharger(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getTaskCharger(xmlDom,userInfo.getLang());
		return result;
	}
	
	/** 기록물철등록부 업무담당자지정 저장  */
	@RequestMapping(value = "/ezApprovalG/saveCabRoleInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String saveCabRoleInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.saveCabRoleInfo(xmlDom);
		return result;
	}
	
	/** 기록물배부대장 검색  */
	@RequestMapping(value = "/ezApprovalG/searchDelivery.do"  ,produces="text/xml;charset=utf-8")
	public String searchDelivery(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		return "ezApprovalG/apprGsearchDelivery";
	}
	
	/** 기록물배부대장 추가배부  */
	@RequestMapping(value = "/ezApprovalG/getCheckEndHref.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getCheckEndHref(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent();
		String result = "FALSE";
		String strXml = ezApprovalGService.getDocInfo(docID, "END", "Href", userInfo.getCompanyID());
		Document resultXML = commonUtil.convertStringToDocument(strXml);
		
		if(resultXML.getElementsByTagName("HREF").getLength()>0){
			if(!resultXML.getElementsByTagName("HREF").item(0).getTextContent().trim().equals("")){
				result = "TRUE";
			}
		}
		return "<Result>"+result+"</Result>";
	}
	
	/** 기록물배부대장 추가배부  */
	@RequestMapping(value = "/ezApprovalG/addBebu.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String addBebu(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String realPath = request.getServletContext().getRealPath("");
		String dirpath = realPath + config.getProperty("upload_approvalG.ROOT") + commonUtil.separator ;
		String result = ezApprovalGService.addBebu(xmlDom, dirpath , userInfo.getCompanyID(), userInfo.getLang());
		return result;
	}
	
	/** 기록물등록대장 재발송  */
	@RequestMapping(value = "/ezApprovalG/selectReceipts.do"  ,produces="text/xml;charset=utf-8")
	public String selectReceipts(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		String docID = request.getParameter("pDocID");
		String serverName = request.getServerName();
		model.addAttribute("docID", docID);
		model.addAttribute("serverName", serverName);
		return "ezApprovalG/apprGezSelectReceipts";
	}
	
	/** 기록물등록대장 재발송 완료  */
	@RequestMapping(value = "/ezApprovalG/resendEndDoc.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String resendEndDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
	    String realPath = request.getServletContext().getRealPath("");
		String dirPath = realPath + config.getProperty("upload_approvalG.ROOT") + commonUtil.separator;
		String result = ezApprovalGService.doReSendDoc(xmlDom,dirPath,userInfo.getLang());
		
		return result;
	}
	
	/** 기록물등록대장 등록정보 특수목록 탭  */
	@RequestMapping(value = "/ezApprovalG/getRecSCInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecSCInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.aprUserInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.getRecSCInfo(xmlDom,userInfo.getLang(),userInfo);
		
		return result;
	}
}
