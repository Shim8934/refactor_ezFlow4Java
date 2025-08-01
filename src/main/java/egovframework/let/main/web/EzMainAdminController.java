package egovframework.let.main.web;

import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.main.service.MainService;
import egovframework.let.main.vo.MainVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzMainAdminController {
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="mainService")
	private MainService mainService;

	@Resource(name = "loginService")
	private LoginService loginService;
	
    @Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;    
    
	private static final Logger logger = LoggerFactory.getLogger(EzMainAdminController.class);
	
	@RequestMapping(value="/admin/main.do")
	public String adminMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception{
		// 2022-01-07 이사라 - 관리자 메뉴 접속 내역 로그 입력
		MainVO adminVO = new MainVO();
		
		LoginVO user = commonUtil.userInfo(loginCookie);
		String uid = user.getId();
		int tenantId = user.getTenantId();

		// 전체관리자와 회사관리자 외 다른 관리자는 제외
		LoginVO loginVO = new LoginVO();

		loginVO.setId(uid);
		loginVO.setTenantId(tenantId);
		loginVO.setDn("NOPASSWORD");

		OrganAuth organAuth = commonUtil.makeOrganAuth(uid, tenantId, user.getDeptID(), user.getJobId());
		if (organAuth.isAuth(OrganAuth.AdminAuth.ADMIN_MASTER) || organAuth.isAuth(OrganAuth.AdminAuth.COMPANY_MANAGER) || organAuth.isAuth(OrganAuth.AdminAuth.WEB_FOLDER_MANAGER)) {
			adminVO.setUserid(uid);
			adminVO.setTenant_id(tenantId);
			adminVO.setAccessip(ClientUtil.getClientIP(request));
			adminVO.setAccessagent(ClientUtil.getClientInfo(request, "agent"));
			adminVO.setAccessos(ClientUtil.getClientInfo(request, "os"));
			adminVO.setAccessbrowser(ClientUtil.getClientInfo(request, "browser"));

			mainService.insertAdminLog(adminVO);

			return "admin/adminMain";
			
		} else {
			// 2024.02.14 한슬기 : 회사관리자/전체관리자가 아닌 경우 관리자 페이지에 접근 불가
			return "redirect:/ezNewPortal/newPortalMain.do";
		}
		
	}
	
	@RequestMapping(value="/admin/top.do")
	public String adminTop(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
		LoginVO userInfo = commonUtil.userInfo(loginCookie); 
		
		String use_approvalG = config.getProperty("config.UserInfo_ApprovalG");
		String use_ezDMS = config.getProperty("config.Use_ezDMS");
		String use_portal = ezCommonService.getTenantConfig("Use_Portal", userInfo.getTenantId());
		String firstScreenMail = ezCommonService.getTenantConfig("firstScreen_Mail", userInfo.getTenantId());
		//2018-07-26 김보미 - 저널, 애티튜드 추가
		String use_attitude = ezCommonService.getTenantConfig("USE_ATTITUDE", userInfo.getTenantId());
		String use_journal = ezCommonService.getTenantConfig("USE_JOURNAL", userInfo.getTenantId());
		//2018-09-18 유은정 - ezPMS 추가
		String use_ezPMS = ezCommonService.getTenantConfig("USE_ezPMS", userInfo.getTenantId());
		/* 2018-09-19 홍승비 - 커뮤니티 사용여부 컨피그 추가  */
		String use_community = ezCommonService.getTenantConfig("USE_COMMUNITY", userInfo.getTenantId());
		String AdminActiveX = config.getProperty("config.AdminActiveX");
		String useHWP = ezCommonService.getTenantConfig("useHWP", userInfo.getTenantId());
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		// String approvalFlag = ezCommonService.getTenantConfig("approvalFlag", userInfo.getTenantId());
		String useWebfolder = ezCommonService.getTenantConfig("useWebfolder", userInfo.getTenantId());
		
		String useSchedule = ezCommonService.getTenantConfig("useSchedule", userInfo.getTenantId());
		String useResource = ezCommonService.getTenantConfig("useResource", userInfo.getTenantId());
		String useBoard = ezCommonService.getTenantConfig("useBoard", userInfo.getTenantId());
		String useCar = ezCommonService.getTenantConfig("useCar", userInfo.getTenantId());
		
		// 2020-04-10 김민성 - 메일 컨피그 추가
		String useExternalMailServer = ezCommonService.getTenantConfig("useExternalMailServer", userInfo.getTenantId());
		if (useExternalMailServer == null || useExternalMailServer.equals("")) {
			useExternalMailServer = "NO";
		}
		
		if (useExternalMailServer.equalsIgnoreCase("YES")) {
			model.addAttribute("use_mail", "NO");
		} else {
			model.addAttribute("use_mail", "YES");
		}
		
		model.addAttribute("use_approvalG", use_approvalG);
		model.addAttribute("use_ezDMS", use_ezDMS);
		model.addAttribute("use_portal", use_portal);
		model.addAttribute("firstScreen_Mail", firstScreenMail);
		//2018-07-26 김보미 - 저널, 애티튜드 추가
		model.addAttribute("use_attitude", use_attitude);
		model.addAttribute("use_journal", use_journal);
		//2018-09-18 유은정 - ezPMS 추가
		model.addAttribute("use_ezPMS", use_ezPMS);
		/* 2018-09-19 홍승비 - 커뮤니티 사용여부 컨피그 추가  */
		model.addAttribute("use_community", use_community);
		model.addAttribute("use_webfolder", useWebfolder);
		model.addAttribute("useCar", useCar);
		
		
		if (firstScreenMail == null || firstScreenMail.equals("")) {
			model.addAttribute("firstScreen_Mail", "NO");
		}
		//2018-07-26 김보미 - 저널, 애티튜드 널일때 처리

		if (use_attitude == null || use_attitude.equals("")) {
			model.addAttribute("use_attitude", "YES");
		}
		if (use_journal == null || use_journal.equals("")) {
			model.addAttribute("use_journal", "YES");
		}
		if (use_community == null || use_community.equals("")) {
			model.addAttribute("use_community", "YES");
		}

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());
		if (organAuth.isAuth(OrganAuth.AdminAuth.ADMIN_MASTER) || organAuth.isAuth(OrganAuth.AdminAuth.COMPANY_MANAGER)) {
			model.addAttribute("admin", "admin");
		} 
		
		if (useSchedule == null || useSchedule.equals("")) {
			useSchedule = "YES";
		} 
		
		if (useResource == null || useResource.equals("")) {
			useResource = "YES";
		} 
		
		if (useBoard == null || useBoard.equals("")) {
			useBoard = "YES";
		} 
		//baonk added
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("f=1") > -1) {
			model.addAttribute("isWFAdmin", "YES");
		}
		//end

		String useActiveX = ezCommonService.getTenantConfig("useActiveX", userInfo.getTenantId());
		if(useActiveX == null || useActiveX.equals("")) {
			useActiveX = "NO";
		}
		
		model.addAttribute("AdminActiveX", AdminActiveX);
		model.addAttribute("useHWP", useHWP);
		model.addAttribute("useActiveX", useActiveX);
		
        String packageType = commonUtil.getPackageType(userInfo.getTenantId());
        
        model.addAttribute("packageType", packageType);
        model.addAttribute("useCabinet", use_cabinet);
        
        model.addAttribute("useSchedule", useSchedule);
        model.addAttribute("useResource", useResource);
        model.addAttribute("useBoard", useBoard);
		
		return "admin/adminTop";
	}	
	
	/* 2020-05-07 김수아 - 관리자 IP 제한 기능
		접근 제한 화면
	*/
	@RequestMapping(value="/admin/accessBlockToAdmin.do")
	public String accessBlockToAdmin(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		logger.debug("accessBlockToAdmin started.");
		String blockMsg = egovMessageSource.getMessage("ezSystem.ksa10", locale);
		
		model.addAttribute("blockMsg", blockMsg);
		
		return "cmm/error/accessBlock";
	}
	
	@RequestMapping(value="/admin/adminDenied.do")
	public String adminDeniedPage(@CookieValue("loginCookie") String loginCookie, Locale locale, HttpServletRequest request, Model model) throws Exception{
		return "cmm/error/adminDenied";
	}
}
