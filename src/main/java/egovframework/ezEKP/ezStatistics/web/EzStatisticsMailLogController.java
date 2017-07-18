package egovframework.ezEKP.ezStatistics.web;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;

import oracle.jdbc.proxy.annotation.GetDelegate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;


/**
 * 메일 상세 내역 컨트롤러
 * @author 김유진
 * 
 */
@Controller
public class EzStatisticsMailLogController {

	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMailLogController.class);
	
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzStatisticsAdminService ezStatisticsAdminService;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	//**/ 수신
	@RequestMapping(value = "/ezStatistics/statisticsMailRecieveLogList.do")
	public String getStatMailRecieveLogMain()throws Exception {
		return "/ezStatistics/statisticsMailRecieveLog";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezStatistics/statisticsMailLogList.do")
	public String getStatMailLogList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {
		
		logger.debug("getStatMailLogList controller started.");
		// 관리자 로그인 체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie); 
		
		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}
		
		String tenantId = String.valueOf(userInfo.getTenantId()); 
		String pageNo = request.getParameter("pageNo");
		int pageSize = 20;
		
		int currentPage = Integer.parseInt(pageNo);
		
		if ( Integer.valueOf(pageNo) != -1 ) {
			pageNo = String.valueOf((Integer.parseInt(pageNo) -1) * pageSize);
		}
		
		String mailLogType = request.getParameter("mailLogType");
		String searchStartTime = request.getParameter("searchStartTime")  + "00:00:00";
		String searchEndTime = request.getParameter("searchEndTime") + "23:59:59";
		String searchField = request.getParameter("searchField");
		String searchValue = request.getParameter("searchValue");
		String isPrimaryLang = "2";
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String startDate = request.getParameter("searchStartTime");
		String endDate = request.getParameter("searchEndTime");
		
		
		if (!searchStartTime.isEmpty()) {
			searchStartTime = searchStartTime.replaceAll("[^0-9]", "");
		}
		
		if (!searchEndTime.isEmpty()) {
			searchEndTime = searchEndTime.replaceAll("[^0-9]", "");
		}

		if (userInfo.getLang().equals(sysLang)) {
			isPrimaryLang = userInfo.getLang();
		} else { 
			isPrimaryLang = sysLang;
		}

		Map<String, Object> resultMap = ezStatisticsAdminService.getMailLogList(tenantId, pageNo, String.valueOf(pageSize), 
				mailLogType, searchStartTime, searchEndTime, searchField, searchValue, isPrimaryLang);
		
		List<Map<String, Object>> mailLogList = (List<Map<String, Object>>) resultMap.get("mailLogList");
		
		int totalCount = (int) resultMap.get("totalCount");
		int totalPage = totalCount / pageSize;
		
		if ((totalPage * pageSize) != totalCount && (totalCount % pageSize) != 0) {
			totalPage = totalPage + 1;
		}
		
		currentPage = Math.min(currentPage, totalPage);
		
		model.addAttribute("mailLogList", mailLogList);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("searchField", searchField);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("isPrimaryLang", isPrimaryLang);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		logger.debug("getStatMailLogList controller ended.");
		
		return "json";
	}
	
	//**/ 발신	
	@RequestMapping(value = "/ezStatistics/statisticsMailSendLogList.do")
	public String getStatMailSendLogMain() throws Exception {
		return "/ezStatistics/statisticsMailSendLog";
	}
	
	//**/ 엑셀내려받기
	@RequestMapping(value = "/ezStatistics/statisticsExcelExportMailLogList.do")
	public String excelExportMailLogList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletRequest response)  throws Exception {
		logger.debug("excelExportMailLogList controller started.");
		
		
		
		logger.debug("excelExportMailLogList controller ended.");
		return null;
	}
}
