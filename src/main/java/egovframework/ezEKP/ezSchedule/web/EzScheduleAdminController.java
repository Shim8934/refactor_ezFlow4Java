package egovframework.ezEKP.ezSchedule.web;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleAdminService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

/** 
 * @Description [Controller] 스케쥴
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------    
 *    2017.01.20	장진혁 개발
 *
 * @see
 */

@Controller
public class EzScheduleAdminController {
	private static final Logger logger = LoggerFactory.getLogger(EzScheduleAdminController.class);

	@Autowired
	private CommonUtil commonUtil;
			
	@Autowired
	private EzScheduleAdminService ezScheduleAdminService;
		
	@Autowired
	private LoginService loginService;
			
	@Autowired
	private EzOrganService ezOrganService;
	
	/**
	 * 관리자 일정관리 메인화면 호출함수
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleMain.do")
	public String  scheduleAdminMain() throws Exception {			
		return "/admin/ezSchedule/scheduleMain";
	}
	
	/**
	 * 관리자 일정관리 왼쪽화면 호출함수
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleLeft.do")
	public String  scheduleAdminLeft() throws Exception {			
		return "/admin/ezSchedule/scheduleLeft";
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 화면 호출함수
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminShareManage.do")
	public String  scheduleAdminShareManage() throws Exception {			
		return "/admin/ezSchedule/scheduleAdminShareManage";
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 리스트 데이터
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleGetShareManage.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String  scheduleGetShareManage(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO) throws Exception {
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
				
		String result = ezScheduleAdminService.scheduleGetShareManage(loginSimpleVO.getLang());
		
		return result;
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 작성 팝업
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminPopupShareDept.do")
	public String  scheduleAdminPopupShareDept(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		String lang = loginSimpleVO.getLang();
		
		model.addAttribute("lang", lang);
		
		return "/admin/ezSchedule/scheduleAdminPopupShareDept";
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 리스트 삭제
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleDelShareDept.do")
	@ResponseBody
	public void  scheduleDelShareDept(HttpServletRequest request) throws Exception {
		String id = request.getParameter("id");
		
		ezScheduleAdminService.scheduleDelShareDept(id);		
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 공유추가 버튼 클릭
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleSaveShareDept.do")
	@ResponseBody
	public void  scheduleSaveShareDept(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, OrganDeptVO organDeptVO, HttpServletRequest request) throws Exception {
		loginVO = commonUtil.userInfo(loginCookie);
		
		int tenantID = loginVO.getTenantId();
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		
		loginVO.setId(userID);
		loginVO.setDn("NOPASSWORD");
		loginVO.setTenantId(tenantID);
		
		LoginVO user = loginService.selectUser(loginVO);
		
		String userName = user.getDisplayName1();
		String userName2 = user.getDisplayName2();
		
		organDeptVO = ezOrganService.getDeptInfo(deptID, loginVO.getPrimary(), tenantID);
		
		String deptName = organDeptVO.getDisplayName();
		String deptName2 = organDeptVO.getDisplayName2();

		ezScheduleAdminService.scheduleSaveShareDept(userID, userName, userName2, deptID, deptName, deptName2);
	}


	
}
