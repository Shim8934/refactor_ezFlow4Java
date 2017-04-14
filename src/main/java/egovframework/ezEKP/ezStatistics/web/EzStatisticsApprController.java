package egovframework.ezEKP.ezStatistics.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/** 
 * @Description [Controller] 전자결재 통계
 * @author 오픈솔루션팀 황윤진
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.11.24    황윤진         신규작성
 *
 * @see
 */

@Controller
public class EzStatisticsApprController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzOrganAdminService")
	private EzOrganAdminService ezOrganAdminService;
	
	@Resource(name = "EzStatisticsAdminService")
	private EzStatisticsAdminService ezStatisticsAdminService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsApprController.class);

	/**
		결재 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsApprMain.do")
	public String statisticsApprMain(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsApprMain started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "' value2='" + vo.getDisplayName() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsApprMain ended");
		
		return "ezStatistics/statisticsApprMain";
	}
	
	/**
	 * 액셀저장
	 */
	@RequestMapping(value = "/ezStatistics/excelExportOut.do")
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response, HttpServletRequest request) throws IOException {
		logger.debug("excelExportOut started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		response.setContentType("application/vnd.ms-excel");
		response.setCharacterEncoding("UTF-8");
		response.addHeader("Content-Disposition", "attachment;filename=" + EgovDateUtil.getTodayTime().substring(0, 10) + "_" + userInfo.getDeptID() + ".xls");
		
		if (request.getParameter("saveExcelData") != null) {
			PrintWriter writer = response.getWriter();
			
			writer.println(request.getParameter("saveExcelData"));
		}

		logger.debug("excelExportOut ended");
	}
	
	/**
	 * 결재 통계 현황 표출
	 */
	@RequestMapping(value = "/ezStatistics/getStatisticsAprMain.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprMain(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getStatisticsAprMain started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		
		String result = ezStatisticsAdminService.getMainList(statApprVO);

		logger.debug("getStatisticsAprMain ended");
		
		return result;
	}
	
	/**
	 * 양식별 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMonForm.do")
	public String statisticsMonForm(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsMonForm started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsMonForm ended");
		
		return "ezStatistics/statisticsMonForm";
	}
	
	/**
	 * 양식별 통계 현황 표출
	 */
	@RequestMapping(value = "/ezStatistics/getStatisticsAprMon.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprMon(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getStatisticsAprMon started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		
		String result = ezStatisticsAdminService.getCountList(statApprVO);

		logger.debug("getStatisticsAprMon ended");
		
		return result;
	}
	
	/**
	 * 양식 관련 통계 현황 표출
	 */
	@RequestMapping(value = "/ezStatistics/getFormInfo.do", produces ="text/xml;charset=utf-8")
	@ResponseBody
	public String getFormInfo(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getFormInfo started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		statApprVO.setLang(userInfo.getLang());
		
		String result = ezStatisticsAdminService.getFormInfo(statApprVO);

		logger.debug("getFormInfo ended");
		
		return result;
	}
	
	/**
	 * 부서별 결재처리시간 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsTimeDept.do")
	public String statisticsTimeDept(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsTimeDept started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsTimeDept ended");
		
		return "ezStatistics/statisticsTimeDept";
	}
	
	/**
	 * 부서별 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMonDept.do")
	public String statisticsMonDept(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsMonDept started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsMonDept ended");
		
		return "ezStatistics/statisticsMonDept";
	}
	
	/**
	 * 결재처리시간 표출
	 */
	@RequestMapping(value = "/ezStatistics/getStatisticsAprTime.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprTime(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getStatisticsAprTime started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		
		String result = ezStatisticsAdminService.getTimeList(statApprVO);
		
		logger.debug("getStatisticsAprTime ended");
		
		return result;
	}
	
	/**
	 * 이름중복체크 호출
	 */
	@RequestMapping(value = "/ezStatistics/checkName2.do")
	public String checkName2() {
		logger.debug("checkName2 started");

		logger.debug("checkName2 ended");
		
		return "ezStatistics/statisticsCheckName2";
	}
	
	/**
	 * 개인별 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsMonUser.do")
	public String statisticsMonUser(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsMonUser started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsMonUser ended");
		
		return "ezStatistics/statisticsMonUser";
	}
	
	/**
	 * 양식별 통계 현황 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsTimeForm.do")
	public String statisticsTimeForm(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsTimeForm started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsTimeForm ended");

		return "ezStatistics/statisticsTimeForm";
	}
	
	/**
	 * 개인별 결재처리 시간 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsTimeUser.do")
	public String statisticsTimeUser(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsTimeUser started");
		
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsTimeUser ended");

		return "ezStatistics/statisticsTimeUser";
	}
	
	/**
	 * 양식별 통계 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsForm.do")
	public String statisticsForm(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsForm started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsForm ended");

		return "ezStatistics/statisticsForm";
	}
	
	/**
	 * 통계 표출
	 */
	@RequestMapping(value = "/ezStatistics/getStatisticsAprSearch.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprSearch(@CookieValue("loginCookie") String loginCookie, StatApprVO statApprVO) {
		logger.debug("getStatisticsAprSearch started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		
		String result = ezStatisticsAdminService.getSearchList(statApprVO);
		
		logger.debug("getStatisticsAprSearch ended");
		
		return result;
	}
	
	/**
	 * 부서별 통계 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsDept.do")
	public String statisticsDept(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsDept started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("statisticsDept ended");

		return "ezStatistics/statisticsDept";
	}
	
	/**
	 * 개인별 통계 호출
	 */
	@RequestMapping(value = "/ezStatistics/statisticsUser.do")
	public String statisticsUser(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("statisticsUser started");

		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
		
		StringBuilder companySel = new StringBuilder();
		
		for (OrganDeptVO vo : deptVOs) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) {
				companySel.append("<option value='" + vo.getCn() + "'>");
				companySel.append(vo.getDisplayName());
				companySel.append("</option>");
			}
		}
		
		String topid = "";
		
		if (userInfo.getRollInfo().indexOf("c=1") == -1) {
			topid = userInfo.getCompanyID();
		} else {
			topid = "Top";
		}
		
		model.addAttribute("companyID", topid);					
		model.addAttribute("companySel", companySel);
		model.addAttribute("userInfo", userInfo);

		logger.debug("statisticsUser ended");
		
		return "ezStatistics/statisticsUser";
	}
}
