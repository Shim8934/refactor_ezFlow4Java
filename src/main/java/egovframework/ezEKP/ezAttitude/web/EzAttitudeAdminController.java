package egovframework.ezEKP.ezAttitude.web;

import java.util.Date;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeAdminController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeController.class);

	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;

	@Resource(name = "crypto")
	private EgovFileScrty egovFileScrty;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "egovMessageSource")
	private EgovMessageSource egovMessageSource;

	/**
	 * 관리자 근태관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeMain.do")
	public String attitudeMain(@CookieValue("loginCookie") String loginCookie,
			LoginVO userInfo) {
		LOGGER.debug("attitudeMain started");

		userInfo = commonUtil.checkAdmin(loginCookie);

		if (userInfo == null) {
			return "cmm/error/adminDenied";
		}

		LOGGER.debug("attitudeMain ended");
		return "/admin/ezAttitude/attitudeMain";
	}

	/**
	 * 관리자 근태관리 좌측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeLeft.do")
	public String attitudeLeft() {
		return "/admin/ezAttitude/attitudeLeft";
	}

	/**
	 * 관리자 근태관리 우측 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezAttitude/attitudeRight.do")
	public String attitudeRight() {
		return "/admin/ezAttitude/attitudeRight";
	}

	/**
	 * 근태 수정 신청 현황
	 */
	@RequestMapping(value="/admin/ezAttitude/manageAttModAppList.do")
	public String adminGetAttModAppList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate) throws Exception {
		LOGGER.debug("adminAttModAppList started");

		int totalAtt = 0;
		int currentPage = 1;
		int totalPages = 0;
//		int pageSize = 15;
//		int startPoint = 0;
//		int endPoint = 15;
		String adminFlag = "true";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		LoginVO auth = commonUtil.checkAdmin(loginCookie);
        
        boolean checkAdmin = auth == null ? false : true;
		
        if (!checkAdmin) {
        	return "cmm/error/adminDenied";
        }
        
		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		
		if (startDate == null || endDate == null) {

			String localDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 10);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Calendar cal = Calendar.getInstance();
			
			String searchStartDate = localDate + " 00:00:00";
			String searchEndDate = localDate + " 23:59:59";
			
			Date startDateforNull = sdf.parse(searchStartDate);
			
			cal = Calendar.getInstance();
			cal.setTime(startDateforNull);
			cal.add(Calendar.DAY_OF_MONTH, -7);
			
			searchStartDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
			searchEndDate = commonUtil.getDateStringInUTC(searchEndDate, offset, true);
			
			startDate = searchStartDate.substring(0, 10);
			endDate = searchEndDate.substring(0, 10);
		}
		/*
//		Date startDate = sdf.parse(searchStartDate);
		
//		cal = Calendar.getInstance();
//		cal.setTime(startDate);
//		cal.add(Calendar.DAY_OF_MONTH, -7);
//		
//		searchStartDate = commonUtil.getDateStringInUTC(sdf.format(cal.getTime()), offset, true);
//		searchEndDate = commonUtil.getDateStringInUTC(searchEndDate, offset, true);
//		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes/count";
									
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", apprUserName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("sysLang", sysLang)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", pageNum)
				.queryParam("adminFlag", adminFlag)
				.queryParam("checkAdmin", checkAdmin)
				.queryParam("type", type);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		JSONArray list = new JSONArray();
		
		if(status.equals("ok")){
			totalAtt = Integer.parseInt(resultBody.get("data").toString());
		}
		
		totalPages = (totalAtt + pageSize - 1)/pageSize;
		url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
		builder = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("companyId", userInfo.getCompanyID())
				.queryParam("tenantId", userInfo.getTenantId())
				.queryParam("apprUserName", apprUserName)
				.queryParam("startDate", startDate)
				.queryParam("endDate", endDate)
				.queryParam("sysLang", sysLang)
				.queryParam("offset", offsetMin)
				.queryParam("pageNum", pageNum)
				.queryParam("adminFlag", adminFlag)
				.queryParam("checkAdmin", checkAdmin)
				.queryParam("type", type);
		
		if (totalPages == 0 || totalPages == 1) {
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			jp = new JSONParser();
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			data = new JSONObject();
			list = new JSONArray();
			
			if(status.equals("ok")){
				data = (JSONObject) resultBody.get("data");
				list = (JSONArray) data.get("list");
				model.addAttribute("list", list);
			}
		}
		else {
			if (currentPage < totalPages) {
				startPoint = (currentPage - 1)*pageSize;
				endPoint = currentPage*pageSize;
				
			}
			else {
				if (currentPage > totalPages) {
					currentPage = totalPages;
				}
				startPoint = (currentPage - 1) * pageSize;
				endPoint = totalAtt;
			}
			
			builder = UriComponentsBuilder.fromHttpUrl(url)
					.queryParam("companyId", userInfo.getCompanyID())
					.queryParam("tenantId", userInfo.getTenantId())
					.queryParam("apprUserName", apprUserName)
					.queryParam("startDate", startDate)
					.queryParam("endDate", endDate)
					.queryParam("sysLang", sysLang)
					.queryParam("offset", offsetMin)
					.queryParam("pageNum", pageNum)
					.queryParam("startPoint", startPoint)
					.queryParam("endPoint", endPoint)
					.queryParam("adminFlag", adminFlag)
					.queryParam("checkAdmin", checkAdmin)
					.queryParam("type", type);
			
			result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
			
			jp = new JSONParser();
			
			resultBody = (JSONObject) jp.parse(result.getBody());
			
			status = resultBody.get("status").toString();
			
			data = new JSONObject();
			list = new JSONArray();
			
			if(status.equals("ok")){
				data = (JSONObject) resultBody.get("data");
				list = (JSONArray) data.get("list");
				model.addAttribute("list", list);
			}
		}
		
		url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
		result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		jp = new JSONParser();
		
		resultBody = (JSONObject) jp.parse(result.getBody());
		
		status = resultBody.get("status").toString();
		
		data = new JSONObject();
		list = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			model.addAttribute("list", list);
		}
		*/
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("totalAtt", totalAtt);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		model.addAttribute("adminFlag", adminFlag);
		model.addAttribute("checkAdmin", checkAdmin);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		LOGGER.debug("attModAppList ended");
		
		return "/ezAttitude/attModAppList";
	}

}
