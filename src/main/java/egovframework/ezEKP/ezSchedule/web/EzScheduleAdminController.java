package egovframework.ezEKP.ezSchedule.web;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleAdminService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
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
 *    ----------    ------      -------------------    
 *    2017.01.20	장진혁 개발 완료
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
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzScheduleService ezScheduleService;
		
	@Autowired
	private LoginService loginService;
			
	@Autowired
	private EzOrganService ezOrganService;
	
	/**
	 * 관리자 일정관리 메인화면 호출함수
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleMain.do")
	public String  scheduleAdminMain() throws Exception {
		
		logger.debug("============ scheduleAdminMain started ============");
		
		return "/admin/ezSchedule/scheduleMain";
	}
	
	/**
	 * 관리자 일정관리 왼쪽화면 호출함수
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleLeft.do")
	public String  scheduleAdminLeft() throws Exception {
		
		logger.debug("============ scheduleAdminLeft started ============");
		
		return "/admin/ezSchedule/scheduleLeft";
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 화면
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminShareManage.do")
	public String  scheduleAdminShareManage() throws Exception {
		
		logger.debug("============ scheduleAdminShareManage started ============");
		
		return "/admin/ezSchedule/scheduleAdminShareManage";
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 리스트 데이터
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleGetShareManage.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String  scheduleGetShareManage(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO) throws Exception {
		
		logger.debug("============ scheduleGetShareManage started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
				
		String result = ezScheduleAdminService.scheduleGetShareManage(loginVO.getPrimary(), loginVO.getTenantId());
		
		return result;
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 작성 팝업
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminPopupShareDept.do")
	public String  scheduleAdminPopupShareDept(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminPopupShareDept started ============");
		
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
	public void  scheduleDelShareDept(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleDelShareDept started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);		
		String id = request.getParameter("id");		
		
		ezScheduleAdminService.scheduleDelShareDept(id, loginSimpleVO.getTenantId());
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 저장 버튼 클릭
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleSaveShareDept.do")
	@ResponseBody
	public void  scheduleSaveShareDept(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, OrganDeptVO organDeptVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleSaveShareDept started ============");
		
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

		ezScheduleAdminService.scheduleSaveShareDept(userID, userName, userName2, deptID, deptName, deptName2, tenantID);
	}
	
	/**
	 * 관리자 일정관리 기념일관리
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminHolidayManage.do")	
	public String scheduleAdminHolidayManage(@CookieValue("loginCookie") String loginCookie, OrganDeptVO organDeptVO, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleAdminHolidayManage started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		StringBuilder companySel = new StringBuilder();
		StringBuilder companyList = new StringBuilder();
		String primary = userInfo.getPrimary();
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(primary, userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
				companyList.append(deptVOs.get(k).getCn() + "," +deptVOs.get(k).getDisplayName() + ";");
			}
		}
		model.addAttribute("primary", primary);
		model.addAttribute("companySel", companySel);
		model.addAttribute("companyList", companyList);
		
		return "/admin/ezSchedule/scheduleAdminHolidayManage";
	}
	
	/**
	 * 관리자 일정관리 기념일관리 기념일 삭제
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleDelHoliday.do")
	@ResponseBody
	public void scheduleDelHoliday(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleDelHoliday started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String hID = request.getParameter("holidayID");
		
		ezScheduleAdminService.scheduleDelHoliday(hID, loginSimpleVO.getTenantId());
	}
	
	/**
	 * 관리자 일정관리 기념일관리 사용여부 체크박스 선택
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleChangeHolidayUse.do")
	@ResponseBody
	public void scheduleChangeHolidayUse(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleChangeHolidayUse started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String hID = request.getParameter("holidayID");
		String isUse = request.getParameter("isUse");
		
		ezScheduleAdminService.scheduleChangeHolidayUse(hID, isUse, loginSimpleVO.getTenantId());
	}
	
	/**
	 * 관리자 일정관리 기념일관리 기념일 등록 팝업
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminPopupHoliday.do")	
	public String scheduleAdminPopupHoliday(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleAdminPopupHoliday started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String option = "";
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String name2 = request.getParameter("name2");
		String isSolar = request.getParameter("isSolar");
		String date = request.getParameter("date");
		String isRepeat = request.getParameter("isRepeat");
		String isRest = request.getParameter("isRest");
		String company = request.getParameter("company");		
		StringBuilder companySel = new StringBuilder();
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());		
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				if (deptVOs.get(k).getCn().equals(company)) {
					option = " selected";
				} else {
					option = "";
				}
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'" + option + ">" + deptVOs.get(k).getDisplayName() + "</option>");
			}
		}
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("companySel", companySel);
		model.addAttribute("id", id);
		model.addAttribute("name", name);
		model.addAttribute("name2", name2);
		model.addAttribute("isSolar", isSolar);
		model.addAttribute("date", date);
		model.addAttribute("isRepeat", isRepeat);
		model.addAttribute("isRest", isRest);
		
		return "/admin/ezSchedule/scheduleAdminPopupHoliday";
	}
	
	/**
	 * 관리자 일정관리 기념일관리 기념일 등록 버튼 클릭
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleSaveHoliday.do")
	@ResponseBody
	public void scheduleSaveHoliday(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleSaveHoliday started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String holidayName = request.getParameter("holidayName");
		String holidayName2 = request.getParameter("holidayName2");
		String holidayDate = request.getParameter("holidayDate");
		String isSolar = request.getParameter("isSolar");
		String isRepeat = request.getParameter("isRepeat");
		String isRest = request.getParameter("isRest");		
		String companyID = request.getParameter("companyID");
		
		String type = request.getParameter("type");
		String holidayID = request.getParameter("holidayID");
		
		if (type.equals("0")) {
			ezScheduleAdminService.scheduleSaveHoliday(holidayName, holidayName2, holidayDate, isSolar, isRepeat, isRest, companyID, loginSimpleVO.getTenantId());
		} else {
			ezScheduleAdminService.scheduleUpdateHoliday(holidayName, holidayName2, holidayDate, isSolar, isRepeat, isRest, companyID, loginSimpleVO.getTenantId(), holidayID);
		}		
	}
	
	/**
	 * 관리자 일정관리 음력날짜 사용
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminLunarUse.do")
	public String  scheduleAdminLunarUse(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminLunarUse started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		StringBuilder companySel = new StringBuilder();
		StringBuilder companyList = new StringBuilder();
		String primary = userInfo.getPrimary();
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(primary, userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
				companyList.append(deptVOs.get(k).getCn() + "," +deptVOs.get(k).getDisplayName() + ";");
			}
		}
		model.addAttribute("primary", primary);
		model.addAttribute("companySel", companySel);
		model.addAttribute("companyList", companyList);
		
		return "/admin/ezSchedule/scheduleAdminLunarUse";
	}
	
	/**
	 * 관리자 일정관리 음력날짜 사용여부 변경
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleSaveLunarUse.do")
	@ResponseBody
	public void	scheduleSaveLunarUse(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleSaveLunarUse started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);		
		String cID = request.getParameter("COMPANYID");
		String lunarUse = request.getParameter("LUNARUSE");
		
		String count = ezScheduleService.scheduleGetLunarUse(cID, loginSimpleVO.getTenantId());
		
		if (count.equals("0")) {
			ezScheduleAdminService.scheduleInsertLunarUse(cID, lunarUse, loginSimpleVO.getTenantId());
		} else {
			ezScheduleAdminService.scheduleUpdateLunarUse(cID, lunarUse, loginSimpleVO.getTenantId());
		}
	}
	
	/**
	 * 관리자 일정관리 이전날짜 등록관리
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminRegi.do")
	public String  scheduleAdminRegi(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminRegi started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		StringBuilder companySel = new StringBuilder();
		StringBuilder companyList = new StringBuilder();
		String primary = userInfo.getPrimary();
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(primary, userInfo.getTenantId());
		
		for (int k = 0; k < deptVOs.size(); k++) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || deptVOs.get(k).getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + deptVOs.get(k).getCn() + "'>" + deptVOs.get(k).getDisplayName() + "</option>");
				companyList.append(deptVOs.get(k).getCn() + "," +deptVOs.get(k).getDisplayName() + ";");
			}
		}
		model.addAttribute("primary", primary);
		model.addAttribute("companySel", companySel);
		model.addAttribute("companyList", companyList);
		
		return "/admin/ezSchedule/scheduleAdminRegi";
	}
	
	/**
	 * 관리자 일정관리 이전날짜 등록관리 사용여부 변경
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleSaveRegi.do")
	@ResponseBody
	public void	scheduleSaveRegi(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleSaveRegi started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);		
		String cID = request.getParameter("COMPANYID");
		String regi = request.getParameter("PREVIOSLYREGIUSE");
		
		String count = ezScheduleService.scheduleGetRegi(cID, loginSimpleVO.getTenantId());
		
		if (count.equals("0")) {
			ezScheduleAdminService.scheduleInsertRegi(cID, regi, loginSimpleVO.getTenantId());
		} else {
			ezScheduleAdminService.scheduleUpdateRegi(cID, regi, loginSimpleVO.getTenantId());
		}
	}
	
}
