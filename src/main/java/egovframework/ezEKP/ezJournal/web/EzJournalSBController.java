package egovframework.ezEKP.ezJournal.web;

import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzJournalSBController {

	private static final Logger logger = LoggerFactory.getLogger(EzJournalAdminController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	/**
	 * 관리자 일지함 관리
	 */
	@RequestMapping(value = "/admin/ezJournal/formType.do")
	public String formTypeManage(HttpServletRequest request, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse response) throws Exception {
		logger.debug("formType started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezjournal/companies" ;
				
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", request.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);

		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("userId", userInfo.getId())
		        .queryParam("tenantId", userInfo.getTenantId());
		
		RestTemplate rest = new RestTemplate();
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		
		JSONObject resultBody = (JSONObject) jp.parse(result.getBody());
				
		String status = resultBody.get("status").toString();
				
		if (status.equals("ok")) {			
			JSONArray scheduleList = (JSONArray) resultBody.get("data");
			
			model.addAttribute("scheduleListCnt", scheduleList.size());
			model.addAttribute("scheduleList", scheduleList);
		}
		
		logger.debug("formType ended");
		return "admin/ezJournal/fromType";
	}
}
