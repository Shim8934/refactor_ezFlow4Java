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
		String result=ezApprovalGService.getRecordClassInfo(xmlDom, userInfo.getCompanyID(),userInfo.getLang());
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
}
