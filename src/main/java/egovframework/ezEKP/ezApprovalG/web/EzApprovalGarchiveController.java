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
	@RequestMapping(value = "/ezApprovalG/cabinetmain.do"  ,produces="text/xml;charset=utf-8")
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
	
}
