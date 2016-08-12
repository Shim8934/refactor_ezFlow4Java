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
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
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
	 * 기록물대장 메뉴 
	 */
	@RequestMapping(value = "/ezApprovalG/cabinetMain.do"  ,produces="text/xml;charset=utf-8")
	public String cabinetmain(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);

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
    	
		String result = ezOrganService.getPropertyList(userInfo.getId(), "extensionAttribute4;extensionAttribute5", userInfo.getLang());
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
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String pDocID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
        String pUserID = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
        String result=ezApprovalGService.sendOfferCheck(pDocID, pUserID, "MUST", userInfo.getCompanyID(), userInfo.getLang());
        
		return "ezApprovalG/apprGcabinetMain";
	}
	
	@RequestMapping(value = "/ezApprovalG/contDocView_NoDoc.do"  ,produces="text/xml;charset=utf-8")
	
	public String contDocView_NoDoc(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
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
		
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result = ezApprovalGService.GetRecordInfo(xmlDom, userInfo.getLang());
		
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/regRecord.do"  ,produces="text/xml;charset=utf-8")
	
	public String regRecord(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		
		userInfo = commonUtil.userInfo(loginCookie);
		String useEditor=config.getProperty("config.EDITOR");
		String useIE11Browser=config.getProperty("config.IE11EDITOR");
		String nonActiveX="YES";
		
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
		
		userInfo = commonUtil.userInfo(loginCookie);
		  model.addAttribute("userInfo", userInfo);
		return "ezApprovalG/apprGsetRecUserRole";
	}
	@RequestMapping(value = "/ezApprovalG/getRecViewerInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecViewerInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		
		userInfo = commonUtil.userInfo(loginCookie);
		System.out.println(xmlPara);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getRecViewer(xmlDom,userInfo.getCompanyID(),userInfo.getLang());
		
	   
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/saveRecUserRole.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String saveRecUserRole(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.saveRecUserRoleInfo(xmlDom,userInfo.getCompanyID(),userInfo.getLang());
	   
		return result;
	}
	
	@RequestMapping(value = "/ezApprovalG/viewRecReadHistory.do"  ,produces="text/xml;charset=utf-8")
	public String viewRecReadHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
	   
		return "ezApprovalG/apprGviewRecReadHistory";
	}
	
	@RequestMapping(value = "/ezApprovalG/getRecReadHistory.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecReadHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model,@RequestBody String xmlPara) throws Exception{
		
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String docID= xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String result=ezApprovalGService.getRecReadHistory(xmlDom, userInfo.getCompanyID(),userInfo.getLang(),docID);
	   
		return result;
	}
	
	/** 기록물등록대장 등록정보 화면 호출*/
	@RequestMapping(value = "/ezApprovalG/viewRecInfo.do"  ,produces="text/xml;charset=utf-8")
	public String viewRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
	    String Use_IE11Browser = "";
		userInfo = commonUtil.userInfo(loginCookie);
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
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getRecordClassInfo(xmlDom,userInfo.getLang());
		return result;
	}
	
	/** 기록물등록대장 변경이력 화면*/
	@RequestMapping(value = "/ezApprovalG/viewRecHistory.do"  ,produces="text/xml;charset=utf-8")
	public String viewRecHistory(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
	    String Use_IE11Browser = "";
		userInfo = commonUtil.userInfo(loginCookie);
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
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		
		String result=ezApprovalGService.getRecordHistory(xmlDom, userInfo.getCompanyID(),userInfo.getLang());
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
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.moveRecord(xmlDom, userInfo.getCompanyID(),userInfo.getLang());
		Document xmlResult = commonUtil.convertStringToDocument(result);
		
		return commonUtil.convertDocumentToString(xmlResult);
	}
	
	/** 기록물등록대장 수정 */
	@RequestMapping(value = "/ezApprovalG/changeRecordInfo.do"  ,produces="text/xml;charset=utf-8")
	
	public String changeRecordInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		String NonActiveX = "Yes";
		userInfo = commonUtil.userInfo(loginCookie);
		  model.addAttribute("userInfo", userInfo);
		return "ezApprovalG/apprGchangeRecordInfo";
	}
	
	/** 기록물등록대장 수정 상세화면 */
	@RequestMapping(value = "/ezApprovalG/getRecordSimpleInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getRecordSimpleInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model , @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String result = ezApprovalGService.getRecordSimpleInfo(xmlDom, userInfo.getCompanyID(),userInfo.getLang());
		return result;
	}
	
	/** 기록물등록대장 수정 상세화면 저장 */
	@RequestMapping(value = "/ezApprovalG/changeRecInfo.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String changeRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model , @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String result = ezApprovalGService.changeRecordInfo(xmlDom, userInfo.getCompanyID(),userInfo.getLang());
		return result;
	}
	
	/** 기록물등록대장  문서출력 화면 호출*/
	@RequestMapping(value = "/ezApprovalG/docListView.do"  ,produces="text/xml;charset=utf-8")
	public String docListView(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		  model.addAttribute("userInfo", userInfo);
			return "ezApprovalG/apprGdocListView";
	}
	
	/** 기록물등록대장  문서출력 상세화면*/
	@RequestMapping(value = "/ezApprovalG/getDeliveryList.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeliveryList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
        String p_DeptID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
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
        
        if(xmlDom.getDocumentElement().getChildNodes().item(6).getTextContent().equals("0")){
        	result = ezApprovalGService.getDeliveryList(p_DeptID, pPageSize, pPageNum, pOrderCell, pOrderOption, pQuery, userInfo.getCompanyID(), userInfo.getLang(), deptcode, deptcode2, title, sregdate, eregdate, debenturer, isdocprint);
        }
        else{

            deptcode = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(0).getTextContent();
            deptcode2 = xmlDom.getDocumentElement().getChildNodes().item(8).getChildNodes().item(1).getTextContent();
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
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.getNewID(userInfo.getCompanyID());
			return result;
	}
	
	/** 기록물등록대장  기록물 등록*/
	@RequestMapping(value = "/ezApprovalG/registerRecord.do"  ,produces="text/xml;charset=utf-8")
	@ResponseBody
	public String registerRecord(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model, @RequestBody String xmlPara) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlPara);
		String result=ezApprovalGService.registerRecord(xmlDom);
			return result;
	}
	
	/** 기록물등록대장  첨부 추가*/
	@RequestMapping(value = "/ezApprovalG/regRecordAttach.do"  ,produces="text/xml;charset=utf-8")
	public String regRecordAttach(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
        String susinAdmin = "";
        String serverName = request.getServerName();
        String poptExt = "";
        String maxSize = "";
        String isBody = "";
        
        String attachFileName = "";
        String hasattach = "NO";
        String docID = "NO";
        String nonActiveX = "YES";
        String realPath = request.getServletContext().getRealPath("");
        docID=request.getParameter("docID") != null ? request.getParameter("docID") : "";
        
        if (userInfo.getRollInfo().indexOf("a=1") > -1) {
    		susinAdmin = "YES";
		} else {
			susinAdmin = "NO";
		}
        String formList = ezApprovalGService.getOptionInfo("A36", "007", userInfo, "CODE");
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
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "/ezApprovalG/apprGprintMetaInfo";
	}
	
	/** 기록물등록대장  등록정보 인쇄 상세화면*/
	@RequestMapping(value = "/ezApprovalG/printMetaInfoContent.do"  ,produces="text/xml;charset=utf-8")
	
	public String printMetaInfoContent(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
//		String pMode = request.getParameter("draftFlag");
		model.addAttribute("userInfo", userInfo);
//		model.addAttribute("pMode", pMode);
		return "/ezApprovalG/apprGprintMetaInfoContent";
	}
	
	/** 기록물등록대장  등록정보 인쇄 상세화면*/
	@RequestMapping(value = "/ezApprovalG/printFormRecInfo.do"  ,produces="text/xml;charset=utf-8")
	
	public String printFormRecInfo(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request ,Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String STRGet_t106 = "";
		String STRGet_t109 = "";
		String STRGet_t445 = "";
		String STRGet_t819 = "";
		String STRGet_t825 = "";
		String STRGet_t827 = "";
		String STRGet_t831 = "";
		String STRGet_t832 = "";
		String STRGet_t836 = "";
		String STRGet_t837 = "";
		String STRGet_t840 = "";
		String STRGet_t845 = "";
		String STRGet_t846 = "";
		String STRGet_t847 = "";
		String STRGet_t848 = "";
		String STRGet_t849 = "";
		String STRGet_t858 = "";
		String STRGet_t859 = "";
		String STRGet_t860 = "";
		String STRGet_t861 = "";
		String STRGet_t862 = "";
        String STRGet_t863 = "";
        String STRGet_t864 = "";
        String STRGet_t865 = "";
        String STRGet_t866 = "";
        String STRGet_t867 = "";
        String STRGet_t868 = "";
        String STRGet_t869 = "";
        String STRGet_t870 = "";
        String STRGet_t871 = "";
        String STRGet_t872 = "";
        String STRGet_t873 = "";
        String STRGet_t874 = "";
        String STRGet_t875 = "";
        String STRGet_t876 = "";
		if(userInfo.getLang().equals("2")){
			 STRGet_t106 = "Subject(Title)";
			 STRGet_t109 = "Public";
			 STRGet_t445 = "Drafter";
			 STRGet_t819 = "Category number";
			 STRGet_t825 = "Default information";
			 STRGet_t827 = "Processing department";
			 STRGet_t831 = "Registration date";
			 STRGet_t832 = "Addtional information";
			 STRGet_t836 = "Modification or not";
			 STRGet_t837 = "Old documentary availability";
			 STRGet_t840 = "Information of class";
			 STRGet_t845 = "Filed";
			 STRGet_t846 = "List transfer year";
			 STRGet_t847 = "List transfer year";
			 STRGet_t848 = "File transfer availability";
			 STRGet_t849 = "File transfer year";
			 STRGet_t858 = "Registry class of documentary";
			 STRGet_t859 = "Registry class";
			 STRGet_t860 = "Registration Number";
			 STRGet_t861 = "Attach separate numbers";
             STRGet_t862 = "Approver";
             STRGet_t863 = "Date of implementation";
             STRGet_t864 = "Receipted user(Sending user)";
             STRGet_t865 = "Distribution number";
             STRGet_t866 = "Production organ registry No.";
             STRGet_t867 = "Return availability";
             STRGet_t868 = "Electronic documentary<br>availability";
             STRGet_t869 = "Production organ of old<br>documentary";
             STRGet_t870 = "Registry number of old documentary";
             STRGet_t871 = "Retention period of old<br>documentary";
             STRGet_t872 = "Summary of audio-visual";
             STRGet_t873 = "Form of audio-visual documentary.";
             STRGet_t874 = "Filed documentary name";
             STRGet_t875 = "Special<br>documentary.";
             STRGet_t876 = "Part of a public limited";
		}
		else{
			 STRGet_t106 = "제목";
			 STRGet_t109 = "공개여부";
			 STRGet_t445 = "기안자";
			 STRGet_t819 = "분류번호";
			 STRGet_t825 = "기본정보";
			 STRGet_t827 = "처리과";
			 STRGet_t831 = "등록일자";
			 STRGet_t832 = "부가정보";
			 STRGet_t836 = "수정여부";
			 STRGet_t837 = "구기록물여부";
			 STRGet_t840 = "분류정보";
			 STRGet_t845 = "편철확정여부";
			 STRGet_t846 = "목록이관여부";
			 STRGet_t847 = "목록이관연도";
			 STRGet_t848 = "파일이관여부";
			 STRGet_t849 = "파일이관연도";
			 STRGet_t858 = "기록물 등록정보";
			 STRGet_t859 = "등록구분";
			 STRGet_t860 = "등록번호";
			 STRGet_t861 = "분리첨부번호";
			 STRGet_t862 = "결재권자";
             STRGet_t863 = "시행일자";
             STRGet_t864 = "수신자(발신자)";
             STRGet_t865 = "배부번호";
             STRGet_t866 = "생산기관등록번호";
             STRGet_t867 = "반려여부";
             STRGet_t868 = "전자기록물여부";
             STRGet_t869 = "구기록물생산기관";
             STRGet_t870 = "구기록물등록번호";
             STRGet_t871 = "구기록물보존기간";
             STRGet_t872 = "시청각 내용요약";
             STRGet_t873 = "시청각기록물형태";
             STRGet_t874 = "기록물철명";
             STRGet_t875 = "특수기록물";
             STRGet_t876 = "공개제한부분";
		}
		String RecID= request.getParameter("ID1");
		String SepAttNo =request.getParameter("ID2");
		String pXml = "<PARAMETERS><RECORDID>" + makeXMLString(RecID.trim()) +
                "</RECORDID><SEPATTACHNO>" + makeXMLString(SepAttNo.trim()) +
                "</SEPATTACHNO><COMPANYID>" + makeXMLString(userInfo.getCompanyID()) +
                // 2010.07.30 다국어
                "</COMPANYID><STRLANG>" + makeXMLString(userInfo.getLang()) + "</STRLANG></PARAMETERS>";
		Document xmlDom = commonUtil.convertStringToDocument(pXml);
		String resultXML = ezApprovalGService.GetRecordInfo(xmlDom, userInfo.getLang());
		String resultXML2 = ezApprovalGService.getRecordClassInfo(xmlDom , userInfo.getLang());
		
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
		
		model.addAttribute("cabTitle", cabTitle);
		model.addAttribute("specialRecCode", specialRecCode);
		model.addAttribute("publicCode", publicCode);
		model.addAttribute("limitRange", limitRange);
		model.addAttribute("confirmFlag", confirmFlag);
		model.addAttribute("catatransFlag", catatransFlag);
		model.addAttribute("catatransYear", catatransYear);
		model.addAttribute("docTransFlag", docTransFlag);
		model.addAttribute("docTransYear", docTransYear);
		
		model.addAttribute("STRGet_t106", STRGet_t106);
		model.addAttribute("STRGet_t109", STRGet_t109);
		model.addAttribute("STRGet_t445", STRGet_t445);
		model.addAttribute("STRGet_t819", STRGet_t819);
		model.addAttribute("STRGet_t825", STRGet_t825);
		model.addAttribute("STRGet_t827", STRGet_t827);
		model.addAttribute("STRGet_t831", STRGet_t831);
		model.addAttribute("STRGet_t832", STRGet_t832);
		model.addAttribute("STRGet_t836", STRGet_t836);
		model.addAttribute("STRGet_t837", STRGet_t837);
		model.addAttribute("STRGet_t840", STRGet_t840);
		model.addAttribute("STRGet_t845", STRGet_t845);
		model.addAttribute("STRGet_t846", STRGet_t846);
		model.addAttribute("STRGet_t847", STRGet_t847);
		model.addAttribute("STRGet_t848", STRGet_t848);
		model.addAttribute("STRGet_t849", STRGet_t849);
		model.addAttribute("STRGet_t858", STRGet_t858);
		model.addAttribute("STRGet_t859", STRGet_t859);
		model.addAttribute("STRGet_t860", STRGet_t860);
		model.addAttribute("STRGet_t861", STRGet_t861);
		model.addAttribute("STRGet_t862", STRGet_t862);
		model.addAttribute("STRGet_t863", STRGet_t863);
		model.addAttribute("STRGet_t864", STRGet_t864);
		model.addAttribute("STRGet_t865", STRGet_t865);
		model.addAttribute("STRGet_t866", STRGet_t866);
		model.addAttribute("STRGet_t867", STRGet_t867);
		model.addAttribute("STRGet_t868", STRGet_t868);
		model.addAttribute("STRGet_t869", STRGet_t869);
		model.addAttribute("STRGet_t870", STRGet_t870);
		model.addAttribute("STRGet_t871", STRGet_t871);
		model.addAttribute("STRGet_t872", STRGet_t872);
		model.addAttribute("STRGet_t873", STRGet_t873);
		model.addAttribute("STRGet_t874", STRGet_t874);
		model.addAttribute("STRGet_t875", STRGet_t875);
		model.addAttribute("STRGet_t876", STRGet_t876);
		
		return "/ezApprovalG/apprGprintFormRecInfo";
	}
}
