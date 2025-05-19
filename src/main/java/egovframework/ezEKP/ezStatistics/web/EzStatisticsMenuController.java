package egovframework.ezEKP.ezStatistics.web;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.ezEKP.ezStatistics.vo.StatChartVO;
import egovframework.ezEKP.ezStatistics.vo.StatisticVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.time.Month;
import java.time.Year;
import java.time.format.TextStyle;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Controller
public class EzStatisticsMenuController {

	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsMenuController.class);

	@Autowired
	CommonUtil commonUtil;

	@Resource(name = "EzStatisticsAdminService")
	private EzStatisticsAdminService ezStatisticsAdminService;

	@RequestMapping(value = "/ezStatistics/statisticsMenuUser.do", method = RequestMethod.GET)
	public String statisticsMenuUser(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.info("statisticsMenuUser started");

		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String topId = "";
		String adminOrganVal = "n";
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (organAuth.isAuth(OrganAuth.AdminAuth.ADMIN_MASTER)) {
			topId = "Top/organ"; // 전체관리자 조직도 전체 트리 보여줌
			adminOrganVal = "y"; // 전체관리자 조직도 전체 검색
		} else if (organAuth.isAuth(OrganAuth.AdminAuth.COMPANY_MANAGER)) {
			topId = userInfo.getCompanyID();
		}

		LocalDate now = LocalDate.now();
		model.addAttribute("monthList", CommonUtil.getMonthList(userInfo.getLocale(), TextStyle.SHORT));
		model.addAttribute("monthVal", now.getMonthValue());
		model.addAttribute("dayList", IntStream.rangeClosed(1, now.lengthOfMonth()).boxed().collect(Collectors.toList()));
		model.addAttribute("dayVal", now.getDayOfMonth());
		model.addAttribute("companyID", topId);
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("adminOrganVal", adminOrganVal);

		logger.info("statisticsMenuUser ended");
		return "ezStatistics/statisticsMenuUser";
	}

	@RequestMapping(value = "/ezStatistics/statisticsMenuDept.do", method = RequestMethod.GET)
	public String statisticsMenuDept(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.info("statisticsMenuDept started");

		//관리자 권한체크
		LoginVO userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		String topId = "";
		String adminOrganVal = "n";
		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (organAuth.isAuth(OrganAuth.AdminAuth.ADMIN_MASTER)) {
			topId = "Top/organ"; // 전체관리자 조직도 전체 트리 보여줌
			adminOrganVal = "y"; // 전체관리자 조직도 전체 검색
		} else if (organAuth.isAuth(OrganAuth.AdminAuth.COMPANY_MANAGER)) {
			topId = userInfo.getCompanyID();
		}

		LocalDate now = LocalDate.now();
		model.addAttribute("monthList", CommonUtil.getMonthList(userInfo.getLocale(), TextStyle.SHORT));
		model.addAttribute("monthVal", now.getMonthValue());
		model.addAttribute("dayList", IntStream.rangeClosed(1, now.lengthOfMonth()).boxed().collect(Collectors.toList()));
		model.addAttribute("dayVal", now.getDayOfMonth());
		model.addAttribute("companyID", topId);
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("adminOrganVal", adminOrganVal);

		logger.info("statisticsMenuDept ended");
		return "ezStatistics/statisticsMenuDept";
	}

	@PostMapping(value = "/ezStatistics/clickEvent.do")
	@ResponseBody
	public void collectClickEvent(@CookieValue(value = "loginCookie", required = false) String loginCookie, HttpServletRequest request, @RequestBody StatisticVO statisticVO) {
		statisticVO.setIp(ClientUtil.getClientIP(request));

		if (StringUtils.isNotEmpty(loginCookie)) {
			statisticVO.setUserInfo(commonUtil.userInfo(loginCookie));
		}
		ezStatisticsAdminService.collectAccessEvent(statisticVO);
	}

	@GetMapping(value = "/ezStatistics/statMenuUserMonthly.do")
	@ResponseBody
	public StatChartVO getStatMenuUserMonthly(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											  @RequestParam(required = false) String menuId, @RequestParam String companyId,
											  @RequestParam String year, @RequestParam String userId
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuUserMonthly(commonUtil.userInfo(loginCookie), companyId, userId,
				Year.parse(year), menuId);
	}

	@GetMapping(value = "/ezStatistics/statMenuUserDaily.do")
	@ResponseBody
	public StatChartVO getStatMenuUserDaily(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											@RequestParam(required = false) String menuId, @RequestParam String companyId,
											@RequestParam String year, @RequestParam int month, @RequestParam String userId
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuUserDaily(commonUtil.userInfo(loginCookie), companyId, userId,
				Year.parse(year), Month.of(month), menuId);
	}

	@GetMapping(value = "/ezStatistics/statMenuUserHourly.do")
	@ResponseBody
	public StatChartVO getStatMenuUserHourly(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											 @RequestParam(required = false) String menuId, @RequestParam String companyId,
											 @RequestParam String year, @RequestParam int month, @RequestParam int day,
											 @RequestParam String userId
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuUserHourly(commonUtil.userInfo(loginCookie), companyId, userId,
				Year.parse(year), Month.of(month), day, menuId);
	}

	@GetMapping(value = "/ezStatistics/statMenuDeptMonthly.do")
	@ResponseBody
	public StatChartVO getStatMenuDeptMonthly(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											  @RequestParam(required = false) String menuId, @RequestParam String companyId,
											  @RequestParam String year, @RequestParam String deptId
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuDeptMonthly(commonUtil.userInfo(loginCookie), companyId, deptId,
				Year.parse(year), menuId);
	}

	@GetMapping(value = "/ezStatistics/statMenuDeptDaily.do")
	@ResponseBody
	public StatChartVO getStatMenuDeptDaily(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											@RequestParam(required = false) String menuId, @RequestParam String companyId,
											@RequestParam String year, @RequestParam int month, @RequestParam String deptId
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuDeptDaily(commonUtil.userInfo(loginCookie), companyId, deptId,
				Year.parse(year), Month.of(month), menuId);
	}

	@GetMapping(value = "/ezStatistics/statMenuDeptHourly.do")
	@ResponseBody
	public StatChartVO getStatMenuDeptHourly(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											 @RequestParam(required = false) String menuId, @RequestParam String companyId,
											 @RequestParam String year, @RequestParam int month, @RequestParam int day,
											 @RequestParam String deptId
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuDeptHourly(commonUtil.userInfo(loginCookie), companyId, deptId,
				Year.parse(year), Month.of(month), day, menuId);
	}

	@GetMapping(value = "/ezStatistics/statMenuUserForMonth.do")
	@ResponseBody
	public StatChartVO getStatMenuUserForMonth(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											   @RequestParam String companyId, @RequestParam String userId,
											   @RequestParam String year, @RequestParam int month
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuUserForMonth(commonUtil.userInfo(loginCookie), companyId, userId,
				Year.parse(year), Month.of(month));
	}

	@GetMapping(value = "/ezStatistics/statMenuUserForDay.do")
	@ResponseBody
	public StatChartVO getStatMenuUserForDay(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											 @RequestParam String companyId, @RequestParam String userId,
											 @RequestParam String year, @RequestParam int month, @RequestParam int day
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuUserForDay(commonUtil.userInfo(loginCookie), companyId, userId,
				Year.parse(year), Month.of(month), day);
	}

	@GetMapping(value = "/ezStatistics/statMenuUserForHour.do")
	@ResponseBody
	public StatChartVO getStatMenuUserForHour(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											  @RequestParam String companyId, @RequestParam String userId,
											  @RequestParam String year, @RequestParam int month, @RequestParam int day, @RequestParam int hour
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuUserForHour(commonUtil.userInfo(loginCookie), companyId, userId,
				Year.parse(year), Month.of(month), day, hour);
	}

	@GetMapping(value = "/ezStatistics/statMenuDeptForMonth.do")
	@ResponseBody
	public StatChartVO getStatMenuDeptForMonth(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											   @RequestParam String companyId, @RequestParam String deptId,
											   @RequestParam String year, @RequestParam int month
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuDeptForMonth(commonUtil.userInfo(loginCookie), companyId, deptId,
				Year.parse(year), Month.of(month));
	}

	@GetMapping(value = "/ezStatistics/statMenuDeptForDay.do")
	@ResponseBody
	public StatChartVO getStatMenuDeptForDay(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											 @RequestParam String companyId, @RequestParam String deptId,
											 @RequestParam String year, @RequestParam int month, @RequestParam int day
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuDeptForDay(commonUtil.userInfo(loginCookie), companyId, deptId,
				Year.parse(year), Month.of(month), day);
	}

	@GetMapping(value = "/ezStatistics/statMenuDeptForHour.do")
	@ResponseBody
	public StatChartVO getStatMenuDeptForHour(@CookieValue(value = "loginCookie", required = false) String loginCookie,
											  @RequestParam String companyId, @RequestParam String deptId,
											  @RequestParam String year, @RequestParam int month, @RequestParam int day, @RequestParam int hour
	) throws Exception {

		return ezStatisticsAdminService.getStatMenuDeptForHour(commonUtil.userInfo(loginCookie), companyId, deptId,
				Year.parse(year), Month.of(month), day, hour);
	}
}
