package egovframework.ezEKP.ezAttitude.web;

import java.util.List;
import java.util.Locale;
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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzAttitudeKMSController {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzAttitudeController.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzCommonService ezCommonService;
	
	@Resource(name="crypto")
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 근태 수정 신청 현황
	 */
	@RequestMapping(value="/ezAttitude/attModAppList.do")
	public String getAttModAppList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model,
			@RequestParam(required=false)String pageNum,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate) throws Exception {
		LOGGER.debug("attModAppList started");
		
		int totalAtt = 0;
		int currentPage = 1;
		int totalPages = 0;
		int pageSize = 15;
		int startPoint = 0;
		int endPoint = 15;

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
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
				.queryParam("pageNum", pageNum);
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		JSONArray list = new JSONArray();
		
		if(status.equals("ok")){
			LOGGER.debug(resultBody.toJSONString());
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
				.queryParam("pageNum", pageNum);
		
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
					.queryParam("endPoint", endPoint);
			
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
		
		for (int i = 0 ; i < list.size(); i++ ) {
			LOGGER.debug(list.get(i).toString());
		}
		
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("userTimeSet", offset);
		model.addAttribute("offsetMin", offsetMin);
		model.addAttribute("totalAtt", totalAtt);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("totalPages", totalPages);
		
		LOGGER.debug("attModAppList ended");
		
		return "/ezAttitude/attModAppList";
	}
	
	@RequestMapping(value="/ezAttitude/getAttModAppList.do",method=RequestMethod.GET, produces="application/json; charset=UTF-8")
	@ResponseBody
	public JSONObject getAttModAppList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Locale locale, ModelMap modelMap,
			@RequestParam(required=false)String apprUserName,
			@RequestParam(required=false)String startDate,
			@RequestParam(required=false)String endDate) throws Exception {

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String sysLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());

		if (userInfo.getLang().equals(sysLang))  {
			sysLang = "primary";
		}
		
		String offset = userInfo.getOffset();
		String offsetMin = commonUtil.getMinuteUTC(offset);
		
		String gwServerUrl = config.getProperty("config.attitudeGwServerURL");
		String url = gwServerUrl + "/rest/ezattitude/users/"+ userInfo.getId() +"/modifyattitudes";
		
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
				.queryParam("offset", offsetMin);

		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
		
		String status = resultBody.get("status").toString();
		
		JSONObject data = new JSONObject();
		JSONObject resultj = new JSONObject();
		JSONArray list = new JSONArray();
		
		if(status.equals("ok")){
			data = (JSONObject) resultBody.get("data");
			list = (JSONArray) data.get("list");
			resultj.put("list", list);
		}
		
		for (int i = 0 ; i < list.size(); i++ ) {
			LOGGER.debug(list.get(i).toString());
		}
		
		resultj.put("startDate", startDate);
		resultj.put("endDate", endDate);
		
		return resultj;
	}
}
