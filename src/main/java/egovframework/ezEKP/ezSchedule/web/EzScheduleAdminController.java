package egovframework.ezEKP.ezSchedule.web;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleAdminService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupVO;
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
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	
	@Autowired
	private EgovMessageSource msg;
	
	/**
	 * 관리자 일정관리 메인화면 호출함수
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleMain.do", method = RequestMethod.GET)
	public String  scheduleAdminMain() throws Exception {
		
		logger.debug("============ scheduleAdminMain started ============");
		
		return "/admin/ezSchedule/scheduleMain";
	}
	
	/**
	 * 관리자 일정관리 왼쪽화면 호출함수
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleLeft.do", method = RequestMethod.GET)
	public String  scheduleAdminLeft(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminLeft started ============");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String lang = userInfo.getLang();
		String primary = userInfo.getPrimary();
		
		logger.debug("lang : " + lang);
		logger.debug("primary : " + primary);
		
		model.addAttribute("lang", lang);
		
		return "/admin/ezSchedule/scheduleLeft";
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 화면
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminShareManage.do", method = RequestMethod.GET)
	public String  scheduleAdminShareManage(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminShareManage started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary());

		// 관리자 권한이 있는 회사가 하나도 없음
		if (adminCompanyList.isEmpty()) {
			return "cmm/error/adminDenied";
		}

		model.addAttribute("companyList", adminCompanyList);
		model.addAttribute("userInfo", userInfo);
		
		return "/admin/ezSchedule/scheduleAdminShareManage";
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 리스트 데이터
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleGetShareManage.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String  scheduleGetShareManage(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleGetShareManage started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		String companyID = request.getParameter("companyID");
		
		if (companyID == null || companyID.equals("")) {
			companyID = loginVO.getCompanyID();
		}
				
		String result = ezScheduleAdminService.scheduleGetShareManage(loginVO.getPrimary(), loginVO.getTenantId(), companyID);
		
		return result;
	}
	
	/**
	 * 관리자 일정관리 일정공유관리 작성 팝업
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminPopupShareDept.do", method = RequestMethod.GET)
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
	@RequestMapping(value="/admin/ezSchedule/scheduleDelShareDept.do", method = RequestMethod.POST)
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
	@RequestMapping(value="/admin/ezSchedule/scheduleSaveShareDept.do", method = RequestMethod.POST)
	@ResponseBody
	public String scheduleSaveShareDept(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, OrganDeptVO organDeptVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleSaveShareDept started ============");
		
		loginVO = commonUtil.userInfo(loginCookie);
		
		int tenantID = loginVO.getTenantId();
		String userID = request.getParameter("userID");
		String deptID = request.getParameter("deptID");
		String companyID = request.getParameter("companyID");
		
		if (companyID == null || companyID.equals("")) {
			companyID = loginVO.getCompanyID();
		}
		
		int checkCnt = ezScheduleAdminService.scheduleShareCheck(userID, deptID, tenantID, companyID);
		
		if (checkCnt == 0) {
			LoginVO tempLoginVO = new LoginVO();
			tempLoginVO.setId(userID);
			tempLoginVO.setDn("NOPASSWORD");
			tempLoginVO.setTenantId(tenantID);

			LoginVO user = loginService.selectUser(tempLoginVO);
			
			String userName = user.getDisplayName1();
			String userName2 = user.getDisplayName2();
			
			organDeptVO = ezOrganService.getDeptInfo(deptID, loginVO.getPrimary(), tenantID);
			
			String deptName = organDeptVO.getDisplayName();
			String deptName2 = organDeptVO.getDisplayName2();
	
			ezScheduleAdminService.scheduleSaveShareDept(userID, userName, userName2, deptID, deptName, deptName2, tenantID, companyID);
			
			return "SUCCESS";
		} else {
			return "FAIL";
		}
	}
	
	/**
	 * 관리자 일정관리 기념일관리
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminHolidayManage.do", method = RequestMethod.GET)	
	public String scheduleAdminHolidayManage(@CookieValue("loginCookie") String loginCookie, OrganDeptVO organDeptVO, Model model, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleAdminHolidayManage started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String primary = userInfo.getPrimary();
		
		String holidayType = request.getParameter("holidayType");
		String companylist = request.getParameter("companylist");
		
		model.addAttribute("primary", primary);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("holidayType", holidayType);
		model.addAttribute("companylist", companylist);
		
		
		return "/admin/ezSchedule/scheduleAdminHolidayManage";
	}
	
	/**
	 * 관리자 일정관리 기념일관리 기념일 삭제
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleDelHoliday.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleDelHoliday(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		String resultCode = "";
		logger.debug("============ scheduleDelHoliday started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String hID = request.getParameter("holidayID");
		
		ezScheduleAdminService.scheduleDelHoliday(hID, loginSimpleVO.getTenantId());
		
		String dotNetTotalNotification = ezCommonService.getTenantConfig("dotNetTotalNotification", loginSimpleVO.getTenantId());
	    logger.debug("dotNetTotalNotification=" + dotNetTotalNotification);
		
	    if(dotNetTotalNotification.equalsIgnoreCase("yes")) {
	    	
			String holidayIDParam = "holidayID=" + URLEncoder.encode(hID, "UTF-8");
	    
			String inputParams = holidayIDParam;
			
			logger.debug("inputParams=" + inputParams);
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/ezSchedule/scheduleDeleteHoliday";
			String webServiceResultResponse = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + webServiceResultResponse);

			if (webServiceResultResponse != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(webServiceResultResponse);

				resultCode = (String)responseObj.get("resultCode");
				logger.debug("resultCode=" + resultCode);
			}
	    }
	}
	
	/**
	 * 관리자 일정관리 기념일관리 사용여부 체크박스 선택
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleChangeHolidayUse.do", method = RequestMethod.POST)
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
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminPopupHoliday.do", method = RequestMethod.GET)	
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
		String holidayType = request.getParameter("holidayType");
		String holidayFlag = request.getParameter("holidayFlag");
		String holidayRepeat = request.getParameter("holidayRepeat");
		String primary = ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId());
		String secondary = ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId());
		
		if (holidayType == null) {
			logger.debug("holidayType is null");
			return "";
		}
		
		if (holidayType.equals("a")) {
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
			model.addAttribute("companySel", companySel);
		}
		
		model.addAttribute("lang", userInfo.getLang());
		model.addAttribute("id", id);
		model.addAttribute("name", name);
		model.addAttribute("name2", name2);
		model.addAttribute("isSolar", isSolar);
		model.addAttribute("date", date);
		model.addAttribute("isRepeat", isRepeat);
		model.addAttribute("isRest", isRest);
		model.addAttribute("holidayType", holidayType);
		model.addAttribute("holidayFlag", holidayFlag);
		model.addAttribute("holidayRepeat", holidayRepeat);
		model.addAttribute("primary", primary);
		model.addAttribute("secondary", secondary);
		
		return "/admin/ezSchedule/scheduleAdminPopupHoliday";
	}
	
	/**
	 * 관리자 일정관리 기념일관리 기념일 등록 버튼 클릭
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleSaveHoliday.do", method = RequestMethod.POST)
	@ResponseBody
	public void scheduleSaveHoliday(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		String resultCode = "";
		logger.debug("============ scheduleSaveHoliday started ============");
		
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
		
		String holidayName = request.getParameter("holidayName");
		String holidayName2 = request.getParameter("holidayName2");
		String holidayDate = request.getParameter("holidayDate");
		String isSolar = request.getParameter("isSolar");
		String isRepeat = request.getParameter("isRepeat");
		String isRest = request.getParameter("isRest");		
		String companyID = request.getParameter("companyID");
		String holidayFlag = request.getParameter("holidayFlag");
		String holidayRepeat = request.getParameter("holidayRepeat");
		
		String type = request.getParameter("type");
		String holidayID = request.getParameter("holidayID");
		
		if (type.equals("0")) {
			holidayID = ezScheduleAdminService.scheduleSaveHoliday(holidayName, holidayName2, holidayFlag, holidayDate, holidayRepeat, isSolar, isRepeat, isRest, companyID, loginSimpleVO.getTenantId());
		} else {
			ezScheduleAdminService.scheduleUpdateHoliday(holidayName, holidayName2, holidayFlag, holidayDate, holidayRepeat, isSolar, isRepeat, isRest, companyID, loginSimpleVO.getTenantId(), holidayID);
		}
		
		String dotNetTotalNotification = ezCommonService.getTenantConfig("dotNetTotalNotification", loginSimpleVO.getTenantId());
	    logger.debug("dotNetTotalNotification=" + dotNetTotalNotification);
		
	    if(dotNetTotalNotification.equalsIgnoreCase("yes")) {
	    	String holidayNameParam = "holidayName=" + URLEncoder.encode(holidayName, "UTF-8");
			String holidayName2Param = "holidayName2=" + URLEncoder.encode(holidayName2, "UTF-8");
			String holidayDateParam = "holidayDate=" + URLEncoder.encode(holidayDate, "UTF-8");
			String isSolarParam = "isSolar=" + URLEncoder.encode(isSolar, "UTF-8");
			String isRepeatParam = "isRepeat=" + URLEncoder.encode(isRepeat, "UTF-8");
			String isRestParam = "isRest=" + URLEncoder.encode(isRest, "UTF-8");
			String companyIDParam = "companyID=" + URLEncoder.encode(companyID, "UTF-8");
			String holidayRepeatParam = "holidayRepeat=" + URLEncoder.encode(holidayRepeat, "UTF-8");
			String typeParam = "type=" + URLEncoder.encode(type, "UTF-8");
			String holidayIDParam = "holidayID=" + URLEncoder.encode(holidayID, "UTF-8");
	    
			String inputParams = holidayNameParam + "&" + holidayName2Param + "&" + holidayDateParam + "&" +
					isSolarParam + "&" + isRepeatParam + "&" + isRestParam + "&" + companyIDParam + "&" +
					holidayRepeatParam + "&" + typeParam + "&" + holidayIDParam;
			
			logger.debug("inputParams=" + inputParams);
			
			String requestURL = config.getProperty("config.JGwServerURL") + "/ezSchedule/scheduleSaveHoliday";
			String webServiceResultResponse = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

			logger.debug("response=" + webServiceResultResponse);

			if (webServiceResultResponse != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject)jsonParser.parse(webServiceResultResponse);

				resultCode = (String)responseObj.get("resultCode");
				logger.debug("resultCode=" + resultCode);
			}
	    }
	}
	
	/**
	 * 관리자 일정관리 음력날짜 사용
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminLunarUse.do", method = RequestMethod.GET)
	public String  scheduleAdminLunarUse(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminLunarUse started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String primary = userInfo.getPrimary();
		
		List<OrganDeptVO> list = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		List<OrganDeptVO> resultList = new ArrayList<OrganDeptVO>();
		
		for (int i =0 ; i < list.size() ; i++) {
			OrganDeptVO vo = list.get(i);
			
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				resultList.add(vo);
			}
		}
		model.addAttribute("primary", primary);
		model.addAttribute("list", resultList);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		
		return "/admin/ezSchedule/scheduleAdminLunarUse";
	}
	
	/**
	 * 관리자 일정관리 음력날짜 사용여부 변경
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleSaveLunarUse.do", method = RequestMethod.POST)
	@ResponseBody
	public String scheduleSaveLunarUse(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleSaveLunarUse started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			logger.debug("scheduleSaveLunarUse accessDenied");
			return "0";
		}else{
			
			
			loginSimpleVO = commonUtil.userInfoSimple(loginCookie);		
			String cID = loginSimpleVO.getCompanyID();
			String lunarUse = request.getParameter("LUNARUSE");
			
			String count = ezScheduleService.scheduleGetLunarUse(cID, loginSimpleVO.getTenantId());
			
			if (count.equals("0")) {
				ezScheduleAdminService.scheduleInsertLunarUse(cID, lunarUse, loginSimpleVO.getTenantId());
			} else {
				ezScheduleAdminService.scheduleUpdateLunarUse(cID, lunarUse, loginSimpleVO.getTenantId());
			}
			return "1";
		}
		
	}
	
	/**
	 * 관리자 일정관리 이전날짜 등록관리
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminRegi.do", method = RequestMethod.GET)
	public String  scheduleAdminRegi(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminRegi started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String primary = userInfo.getPrimary();

		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary());

		// 관리자 권한이 있는 회사가 하나도 없음
		if (adminCompanyList.isEmpty()) {
			return "cmm/error/adminDenied";
		}
		
		model.addAttribute("primary", primary);
		model.addAttribute("list", adminCompanyList);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		
		return "/admin/ezSchedule/scheduleAdminRegi";
	}
	
	/**
	 * 관리자 일정관리 이전날짜 등록관리 사용여부 변경
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleSaveRegi.do", method = RequestMethod.POST)
	@ResponseBody
	public String scheduleSaveRegi(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleSaveRegi started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "0";
		}else{
			
			loginSimpleVO = commonUtil.userInfoSimple(loginCookie);		
			String cID = request.getParameter("COMPANYID");
			if (cID == null || cID.equals("")){
				cID = loginSimpleVO.getCompanyID();
			}
			cID = commonUtil.detectPathTraversal(cID);
			String regi = request.getParameter("PREVIOSLYREGIUSE");
			
			String count = ezScheduleService.scheduleGetRegi(cID, loginSimpleVO.getTenantId());
			
			if (count.equals("0")) {
				ezScheduleAdminService.scheduleInsertRegi(cID, regi, loginSimpleVO.getTenantId());
			} else {
				ezScheduleAdminService.scheduleUpdateRegi(cID, regi, loginSimpleVO.getTenantId());
			}
			
			return "1";
		}
		
	}
	
	/**
	 * 관리자 일정관리 기념일 등록 탭 페이지(게시판 참조)
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminHolidayTab.do", method = RequestMethod.GET)
	public String  scheduleAdminHolidayTab(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminHolidayTab started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String primary = userInfo.getPrimary();
		
		List<OrganDeptVO> adminCompanyList = ezOrganAdminService.getAdminCompanyList(userInfo.getId(), userInfo.getTenantId(), userInfo.getPrimary());
		
		StringBuffer companyList = new StringBuffer();

        for (OrganDeptVO vo : adminCompanyList) {
            companyList.append(vo.getCn()).append(",").append(vo.getDisplayName()).append(";");
        }
		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("primary", primary);
		model.addAttribute("list", adminCompanyList);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		model.addAttribute("companyList", companyList);
		
		logger.debug("============ scheduleAdminHolidayTab ended ============");
		
		return "/admin/ezSchedule/scheduleAdminHolidyTabList";
	}
	
	/**
	 * 관리자 일정관리 기념일 등록 탭 페이지(게시판 참조)
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminPopupHolidayRepeat.do", method = RequestMethod.GET)
	public String  scheduleAdminPopupHolidayRepeat(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminPopupHolidayRepeat started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String primary = userInfo.getPrimary();
		
		
		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("primary", primary);
		model.addAttribute("userCompany", userInfo.getCompanyID());
		
		logger.debug("============ scheduleAdminPopupHolidayRepeat ended ============");
		
		return "/admin/ezSchedule/scheduleAdminPopupHolidayRepeat";
	}
	
	/**
	 * 관리자 일정관리 그룹관리 탭 페이지
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleAdminGroupTab.do", method = RequestMethod.GET)
	public String  scheduleAdminHolidayTab2(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("============ scheduleAdminGroupTab started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		logger.debug("============ scheduleAdminGroupTab ended ============");
		
		return "/admin/ezSchedule/scheduleAdminGroupTab";
	}

	/**
	 * 일정그룹관리 그리드 리스트  카운트
	 */
	@RequestMapping(value="/admin/ezSchedule/scheduleGroupListCount.do",  method = RequestMethod.POST)
	public String scheduleGroupListCount(@CookieValue("loginCookie") String loginCookie, Model model, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
		
		logger.debug("============ scheduleGroupListCount started ============");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
    	if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
    	
    	String offset = userInfo.getOffset();
    	
		String currPage = request.getParameter("pageNum");
		if (currPage == null || currPage.equals("")) {
			currPage = "1";
		}
		
		int maxItemPerPage = 10; 
		int currentPage = Integer.parseInt(currPage);
		
	
		String searchType2  = request.getParameter("searchType2") != null ? request.getParameter("searchType2") : "" ;
		String searchValue = request.getParameter("searchValue") != null ? request.getParameter("searchValue") : "" ;
		String startDate = request.getParameter("startDate") != null ? request.getParameter("startDate") : "";
		String endDate = request.getParameter("endDate") != null ? request.getParameter("endDate") : "";
		loginSimpleVO = commonUtil.userInfoSimple(loginCookie);

		
		List<ScheduleGroupListVO> myList = new ArrayList<ScheduleGroupListVO>();
		
	    myList = ezScheduleAdminService.getMyGroupList(commonUtil.getMinuteUTC(offset), loginSimpleVO.getId(), loginSimpleVO.getTenantId(),loginSimpleVO.getCompanyID(), searchType2, searchValue, startDate, endDate);
		
	    int totalCount = myList.size();
	    
	    int totalPage = totalCount / maxItemPerPage ;
	    
	    if (totalCount < 1) {
			totalPage = 1;
		} 
	    
	    if ((totalPage * maxItemPerPage) != totalCount && (totalCount % maxItemPerPage) != 0) {
			totalPage = totalPage + 1 ;
		}
	    currentPage = Math.min(currentPage, totalPage);	
	    
	    model.addAttribute("currPage", currentPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("searchType2", searchType2);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
	    return "json";
	}
		
	    /**
	     * 일정그룹관리 그리드 리스트
	     */
	    @RequestMapping(value="/admin/ezSchedule/scheduleGroupList.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	    @ResponseBody
	    public String scheduleGroupList(@CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, HttpServletRequest request) throws Exception {
	    	
	    	logger.debug("============ scheduleGroupList started ============");


	    	LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
	    	if (userInfo == null) {
				return "cmm/error/adminDenied";
			}
	    	
	    	String offset = userInfo.getOffset();
	    	
	    	
	    	String currPage = request.getParameter("pageNum");
			if (currPage == null || currPage.equals("")) {
				currPage = "1";
			}
			
			int maxItemPerPage = 10; 
			int currentPage = Integer.parseInt(currPage);
			int startRow = Math.multiplyExact(Math.subtractExact(currentPage, 1), maxItemPerPage);
			
			
			
	    	String searchType2  = request.getParameter("searchType2") != null ? request.getParameter("searchType2") : "" ;
	    	String searchValue = request.getParameter("searchValue") != null ? request.getParameter("searchValue") : "" ;
	    	String startDate = request.getParameter("startDate") != null ? request.getParameter("startDate") : "";
	    	String endDate = request.getParameter("endDate") != null ? request.getParameter("endDate") : "";
	    	String companyID = request.getParameter("company") != null ? request.getParameter("company") : "";
	    	loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
	    	
	    	
	    	List<ScheduleGroupVO> myList = new ArrayList<ScheduleGroupVO>();


			String primaryData = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());


	    	myList = ezScheduleAdminService.getMyGroupList2(commonUtil.getMinuteUTC(offset), loginSimpleVO.getId(), loginSimpleVO.getTenantId(),companyID, searchType2, searchValue, startDate, endDate, startRow, maxItemPerPage, primaryData);


		
		StringBuilder result = new StringBuilder("<LISTVIEWDATA>");
		result.append("<HEADERS><HEADER><NAME>CHECK</NAME><WIDTH>30</WIDTH></HEADER>");
		/* 2023-09-06 조소정 - 관리자 > 일정관리 > 일정그룹관리 > 그룹 정보 테이블에 그룹 색상, 수정일자 셀 헤더 추가 및 셀 너비 지정 */
		result.append("<HEADER><NAME>GROUPCOLOR</NAME><WIDTH>20</WIDTH></HEADER>");
        result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.t159", loginSimpleVO.getLocale()) + "</NAME></HEADER>");
        result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.t160", loginSimpleVO.getLocale()) + "</NAME></HEADER>");
        result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.shb17", loginSimpleVO.getLocale()) + "</NAME></HEADER>");
        result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.t00002", loginSimpleVO.getLocale()) + "</NAME></HEADER>");
        result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.csj04", loginSimpleVO.getLocale()) + "</NAME></HEADER>");
        result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.shb18", loginSimpleVO.getLocale()) + "</NAME></HEADER>");
        result.append("<HEADER><NAME>" + msg.getMessage("ezSchedule.shb19", loginSimpleVO.getLocale()) + "</NAME></HEADER></HEADERS>");
        result.append("<ROWS>");
		
        for (int i = 0; i < myList.size(); i++) {
        	ScheduleGroupVO data = myList.get(i);

        	if(data.getPrecreatorname() == null){
        		data.setPrecreatorname("");
        	}
        	if(data.getModifydate() == null){
        		data.setModifydate("");
        	}
        	if(data.getPrecreatorid() == null){
        		data.setPrecreatorid("");
        	}
        	if(data.getTransferDate() == null){
        		data.setTransferDate("");
        	}
        	if(data.getGroupColor() == null) {
        		data.setGroupColor("#e9de13");
        	}

			/* 2023-08-07 이주원 - 게시판명에 다국어 기본언어, 멀티언어 적용 */
			String preCreatorInfo = "";
			if (primaryData.equals("1")) {
				preCreatorInfo = data.getPrecreatorname()+"("+data.getPrecreatorid()+")";
			} else {
				preCreatorInfo = data.getPrecreatorname2()+"("+data.getPrecreatorid()+")";
			}

        	if(StringUtils.isEmpty(data.getPrecreatorid())){
        		preCreatorInfo = "";
        	}
        	
        	result.append("<ROW>");
            result.append("<CELL>");
            result.append("<VALUE>CHECK</VALUE>");
            result.append("<DATA1>" + data.getGroupId() + "</DATA1>");
            result.append("<DATA2><![CDATA[" + data.getDescription() + "]]></DATA2>");
            result.append("<DATA3><![CDATA[" + data.getGroupColor() + "]]></DATA3>");
            result.append("</CELL>");
            
            /* 2023-09-06 조소정 - 관리자 > 일정관리 > 일정그룹관리 > 그룹 정보 테이블 바디에 그룹 색상 추가 */
            result.append("<CELL>");
            result.append("<VALUE>GROUPCOLOR</VALUE>");
            result.append("<DATA1><![CDATA[" + data.getGroupColor() + "]]></DATA1>");
            result.append("</CELL>");
            result.append("<CELL>");
            
            int myMemberListCnt = ezScheduleAdminService.getMyGroupMemberListCnt(data.getGroupId(), loginSimpleVO.getLang(), loginSimpleVO.getTenantId(),loginSimpleVO.getCompanyID());
            //String cDate = commonUtil.getDateStringInUTC(data.getCreateDate(),loginSimpleVO.getOffset(),false).substring(0,10);
            // 2023-08-10 황인경 - 관리자 > 일정관리 > 일정그룹관리 > 인원수 다국어 단/복수 처리
            if (myMemberListCnt > 1) {
            	result.append("<VALUE><![CDATA[" + data.getGroupName() + " (" + myMemberListCnt + msg.getMessage("ezSchedule.hik01", loginSimpleVO.getLocale()) + ")" + "]]></VALUE>");
            } else {
            	result.append("<VALUE><![CDATA[" + data.getGroupName() + " (" + myMemberListCnt + msg.getMessage("ezSchedule.t00003", loginSimpleVO.getLocale()) + ")" + "]]></VALUE>");
            }
            
            result.append("</CELL>");
            result.append("<CELL>");
            result.append("<VALUE><![CDATA[" + data.getDescription() + "]]></VALUE>");
            result.append("</CELL>");

			/* 2023-08-07 이주원 - 게시판명에 다국어 기본언어, 멀티언어 적용 */
			if (primaryData.equals("1")) {
				result.append("<CELL>");
				result.append("<VALUE>" + data.getCreatorname()+"("+data.getCreatorid()+")" + "</VALUE>");
				result.append("</CELL>");
			} else {
				result.append("<CELL>");
				result.append("<VALUE>" + data.getCreatorname2() + "(" + data.getCreatorid() + ")" + "</VALUE>");
				result.append("</CELL>");
			}

            result.append("<CELL>");
            result.append("<VALUE>" + data.getCreateDate() + "</VALUE>");
            result.append("</CELL>");
            /* 2023-09-06 조소정 - 관리자 > 일정관리 > 일정그룹관리 > 그룹 정보 테이블 바디 수정일자 표출되도록 수정 */
            result.append("<CELL>");
            result.append("<VALUE>" + data.getModifydate() + "</VALUE>");
            result.append("</CELL>");
            result.append("<CELL>");
           /* result.append("<VALUE>" + data.getPrecreatorname()+"("+data.getPrecreatorid()+")" + "</VALUE>");*/
            result.append("<VALUE>" + preCreatorInfo + "</VALUE>");
            result.append("</CELL>");
            /* 2023-09-06 조소정 - 관리자 > 일정관리 > 일정그룹관리 > 그룹 정보 테이블 바디 양도일자 표출되도록 수정 */
            result.append("<CELL>");
            result.append("<VALUE>" + data.getTransferDate() + "</VALUE>");
            result.append("</CELL>");
            result.append("</ROW>");
        }
        result.append("</ROWS>");
        result.append("</LISTVIEWDATA>");
        
        
		
		return result.toString();
	}
	
	
	
	
}
