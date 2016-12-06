package egovframework.ezEKP.ezApproval.web;

import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApproval.service.EzApprovalAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;


/** 
 * @Description [Controller] 전자결재 일반
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.11.30    황윤진         신규작성
 *
 * @see
 */

@Controller
public class EzApprovalAdminController {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private EzApprovalAdminService ezApprovalAdminService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource messageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalAdminController.class);
	
	@RequestMapping(value = "/admin/ezApproval/apprMain.do")
	public String apprMain(Model model, HttpServletRequest request) {
		logger.debug("apprMain started");
		
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isIEBrowser = browser.indexOf("IE") > -1 ? true : false;
		
		model.addAttribute("isIEBrowser", isIEBrowser);
		
		logger.debug("apprMain ended");
		
		return "admin/ezApproval/apprMain";
	}
	
	@RequestMapping(value = "/admin/ezApproval/apprLeft.do")
	public String apprLeft(Model model, HttpServletRequest request) throws Exception{
		logger.debug("apprLeft started");
		
		String browser = ClientUtil.getClientInfo(request, "browser");
		boolean isIEBrowser = browser.indexOf("IE") > -1 ? true : false;
		
		model.addAttribute("isIEBrowser", isIEBrowser);
		
		logger.debug("apprLeft ended");
		
		return "admin/ezApproval/apprLeft";
	}
	
	@RequestMapping(value = "/admin/ezApproval/formAdmin.do")
	public String formAdmin(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		logger.debug("formAdmin started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String editor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String multiDataNum = commonUtil.getMultiData(userInfo.getLang());
		String useReform = ezCommonService.getTenantConfig("Usereform", userInfo.getTenantId());
		String docType = ezApprovalAdminService.getDocType("", userInfo);
		StringBuilder companySel = new StringBuilder();
		String[] docs;
		
		if (docType.split("t").length != 0) {
			docs = docType.split("t");
			
			for (int k = 1; k < docs.length; k++) {
				docs[k] = "t" + docs[k].split("<")[0];
				docType = docType.replace(docs[k], messageSource.getMessage("ezApproval." + docs[k], userInfo.getLocale()));
			}
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("companySel", companySel);
		model.addAttribute("editor", editor);
		model.addAttribute("multiDataNum", multiDataNum);
		model.addAttribute("useReform", useReform);
		model.addAttribute("docType", docType);
		
		logger.debug("formAdmin ended");
		
		return "/admin/ezApproval/apprFormAdmin";
	}
	
	@RequestMapping(value = "/admin/ezApproval/MCont.do")
	public String MCont(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception{
		logger.debug("MCont started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		StringBuilder companySel = new StringBuilder();
		String topID = "";
		String serverName = request.getServerName();
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1 && userInfo.getRollInfo().indexOf("k=1") == -1) {
			return "main/warning";
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topID = userInfo.getCompanyID();
		} else {
			topID = "Top";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getLang(), userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		
		model.addAttribute("topID", topID);
		model.addAttribute("companySel", companySel);
		model.addAttribute("serverName", serverName);
		
		logger.debug("MCont ended");
		
		return "admin/ezApproval/apprMCont";
	}

	@RequestMapping(value = "/admin/ezApproval/MgetContinfo.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MgetContinfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		logger.debug("MgetContinfo started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("comID");
		String result = ezApprovalAdminService.getContainerInfoManage(deptID, "LIST", companyID, userInfo);
		
		logger.debug("MgetContinfo ended");
		
		return result;
	}
	
	@RequestMapping(value = "/admin/ezApproval/MContType.do")
	public String MContType(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		logger.debug("MContType started");
		
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		
		String langPrimary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String langSecondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		
		logger.debug("MContType ended");
		
		return "admin/ezApproval/apprMContType";
	}
	
	@RequestMapping(value = "/admin/ezApproval/MLgetDoctype.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String MLgetDoctype() {
		logger.debug("MLgetDoctype started");
		logger.debug("MLgetDoctype ended");
		return "";
	}
}
