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
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzStatisticsApprController.class);

	@RequestMapping(value = "/ezStatistics/statisticsApprMain.do")
	public String statisticsApprMain(@CookieValue("loginCookie") String loginCookie, Model model) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		try {
			List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
			
			StringBuilder companySel = new StringBuilder();
			
			for (OrganDeptVO vo : deptVOs) {
				if ((userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) && !vo.getCn().equals("Top")) {
					companySel.append("<option value='" + vo.getCn() + "' value2='" + vo.getDisplayName() + "'>");
					companySel.append(vo.getDisplayName());
					companySel.append("</option>");
				}
			}
			
			model.addAttribute("companySel", companySel);
			model.addAttribute("userInfo", userInfo);
		} catch (Exception e) {
			LOGGER.error("ezStatistics :: ezStatisticsApprMain :: " + e.getMessage());
		}
		
		return "ezStatistics/statisticsApprMain";
	}
	
	@RequestMapping(value = "/ezStatistics/excelExportOut.do")
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, HttpServletResponse response, HttpServletRequest request) throws IOException {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		response.setContentType("application/vnd.ms-excel");
		response.setCharacterEncoding("UTF-8");
		response.addHeader("Content-Disposition", "attachment;filename=" + EgovDateUtil.getTodayTime().substring(0, 10) + "_" + userInfo.getDeptID() + ".xls");
		
		if (request.getParameter("saveExcelData") != null) {
			PrintWriter writer = response.getWriter();
			
			writer.println(request.getParameter("saveExcelData"));
		}
	}
	
	@RequestMapping(value = "/ezStatistics/getStatisticsAprMain.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprMain(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String date = request.getParameter("date");
		String company = request.getParameter("company");
		String result = ezStatisticsAdminService.getTimeList(date, company, userInfo.getTenantId());
		
		return result;
	}
	
	@RequestMapping(value = "/ezStatistics/statisticsMonForm.do")
	public String statisticsMonForm(@CookieValue("loginCookie") String loginCookie, Model model) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		boolean auth = commonUtil.checkAdmin(loginCookie);
		
		if (!auth) {
			return "cmm/error/adminDenied";
		}
		
		try {
			List<OrganDeptVO> deptVOs = ezOrganAdminService.getCompanyList(userInfo.getPrimary(), userInfo.getTenantId());
			
			StringBuilder companySel = new StringBuilder();
			
			for (OrganDeptVO vo : deptVOs) {
				if ((userInfo.getRollInfo().indexOf("c=1") > -1 || vo.getCn().equals(userInfo.getCompanyID())) && !vo.getCn().equals("Top")) {
					companySel.append("<option value='" + vo.getCn() + "'>");
					companySel.append(vo.getDisplayName());
					companySel.append("</option>");
				}
			}
			
			model.addAttribute("companySel", companySel);
			model.addAttribute("userInfo", userInfo);
		} catch (Exception e) {
			LOGGER.error("ezStatistics :: ezStatisticsMonForm :: " + e.getMessage());
		}
		
		return "ezStatistics/statisticsMonForm";
	}
	
	@RequestMapping(value = "/ezStatistics/getStatisticsAprMon.do", produces = "text/xml;charset=utf-8")
	@ResponseBody
	public String getStatisticsAprMon(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, StatApprVO statApprVO) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		
		String result = ezStatisticsAdminService.getCountList(statApprVO);
		
		return result;
	}
	
	@RequestMapping(value = "/ezStatistics/getFormInfo.do", produces ="text/xml;charset=utf-8")
	@ResponseBody
	public String getFormInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, StatApprVO statApprVO) {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		statApprVO.setTenantID(userInfo.getTenantId());
		statApprVO.setLang(userInfo.getLang());
		
		String result = ezStatisticsAdminService.getFormInfo(statApprVO);
		
		return result;
	}
}
