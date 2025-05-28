package egovframework.ezEKP.ezStatistics.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
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

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzStatisticsPersonalController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzStatisticsAdminService")
	private EzStatisticsAdminService ezStatisticsAdminService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsPersonalController.class);
	
	@RequestMapping(value="/ezStatistics/statisticsPerSonalMain.do", method = RequestMethod.GET)
	public String statisticsPersonalMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}		
			
		try {
			List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());

			model.addAttribute("list", adminCompanyList);
			model.addAttribute("userCompany", userInfo.getCompanyID());
			model.addAttribute("userInfo", userInfo);
		} catch (Exception e) {
			logger.error("ezStatistics :: ezStatisticsPersonalMain :: " + e.getMessage());
		}
		
		return "ezStatistics/statisticsPersonalMain";
	}
	
	@RequestMapping(value="/ezStatistics/getPersonalMain.do",method=RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getPersnalMain(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model, StatApprVO statApprVO) throws Exception {
        //관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		
		String sDate = doc.getElementsByTagName("SDATE").item(0).getTextContent();
		String eDate = doc.getElementsByTagName("EDATE").item(0).getTextContent();
		String company = doc.getElementsByTagName("COMPANY").item(0).getTextContent();
				
		statApprVO.setStartDate(commonUtil.getDateStringInUTC(sDate + " 00:00:00", userInfo.getOffset(), true));
		statApprVO.setEndDate(commonUtil.getDateStringInUTC(eDate + " 23:59:59", userInfo.getOffset(), true));
		statApprVO.setCompany(company);
		statApprVO.setOffSet(userInfo.getOffset());
		statApprVO.setTenantID(userInfo.getTenantId());
		
		return ezStatisticsAdminService.getConnInfo(statApprVO);
	}
	
	@RequestMapping(value="/ezStatistics/statisticsConnBrowser.do", method = RequestMethod.GET)
	public String statisticsConnBrowserMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}		
				
		try {
			List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
			
			model.addAttribute("list", resultList);
			model.addAttribute("userCompany", userInfo.getCompanyID());
			model.addAttribute("userInfo", userInfo);
		} catch (Exception e) {
			logger.error("ezStatistics :: ezStatisticsPersonalMain :: " + e.getMessage());
		}
		
		return "ezStatistics/statisticsConnBrowserMain";
	}
	
	@RequestMapping(value="/ezStatistics/getStatConnBrowser.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getStatConnBrowser(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model,StatApprVO statApprVO) throws Exception {
        //관리자 권한체크
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		if (user == null) {
			return "cmm/error/adminDenied";
		}
        	    
		logger.debug("getMailMain started");		
		logger.debug("bodyData=" + bodyData);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String sDate = doc.getElementsByTagName("SDATE").item(0).getTextContent();
		String eDate = doc.getElementsByTagName("EDATE").item(0).getTextContent();
		String company = doc.getElementsByTagName("COMPANY").item(0).getTextContent();
		
		statApprVO.setStartDate(commonUtil.getDateStringInUTC(sDate + " 00:00:00", user.getOffset(), true));
		statApprVO.setEndDate(commonUtil.getDateStringInUTC(eDate + " 23:59:59", user.getOffset(), true));
		statApprVO.setCompany(company);
		statApprVO.setTenantID(user.getTenantId());
		
		return ezStatisticsAdminService.getStatConnBrowser(statApprVO);
	}
	
	@RequestMapping(value="/ezStatistics/statisticsConnOS.do", method = RequestMethod.GET)
	public String statisticsConnOSMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}		
				
		try {
			List<OrganDeptVO> resultList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary(), userInfo.getDeptID(), userInfo.getJobId());
			
			model.addAttribute("list", resultList);
			model.addAttribute("userCompany", userInfo.getCompanyID());
			model.addAttribute("userInfo", userInfo);
		} catch (Exception e) {
			logger.error("ezStatistics :: ezStatisticsPersonalMain :: " + e.getMessage());
		}
		
		return "ezStatistics/statisticsConnOSMain";
	}
	
	@RequestMapping(value="/ezStatistics/getStatConnOS.do",method=RequestMethod.POST,
			produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getStatConnOS(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model,StatApprVO statApprVO) throws Exception {
        //관리자 권한체크
		LoginVO user = commonUtil.checkAdmin(loginCookie);
		
		if (user == null) {
			return "cmm/error/adminDenied";
		}
        	    
		logger.debug("getMailMain started");		
		logger.debug("bodyData=" + bodyData);
		
		Document doc = commonUtil.convertStringToDocument(bodyData);
		String sDate = doc.getElementsByTagName("SDATE").item(0).getTextContent();
		String eDate = doc.getElementsByTagName("EDATE").item(0).getTextContent();
		String company = doc.getElementsByTagName("COMPANY").item(0).getTextContent();
		
		statApprVO.setStartDate(commonUtil.getDateStringInUTC(sDate + " 00:00:00", user.getOffset(), true));
		statApprVO.setEndDate(commonUtil.getDateStringInUTC(eDate + " 23:59:59", user.getOffset(), true));
		statApprVO.setCompany(company);
		statApprVO.setTenantID(user.getTenantId());
		
		return ezStatisticsAdminService.getStatConnOS(statApprVO);
	}
	
}
