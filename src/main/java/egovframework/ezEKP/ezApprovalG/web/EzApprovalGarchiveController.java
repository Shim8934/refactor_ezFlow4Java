package egovframework.ezEKP.ezApprovalG.web;

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
	
}
