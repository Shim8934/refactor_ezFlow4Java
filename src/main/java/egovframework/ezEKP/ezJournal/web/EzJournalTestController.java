package egovframework.ezEKP.ezJournal.web;

import java.util.Locale;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
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

import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Controller
public class EzJournalTestController {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@RequestMapping(value = "/ezJournal/typeListTest.do")
	public String testJournal(HttpServletRequest req, Model model,@CookieValue("loginCookie") String loginCookie, HttpServletResponse resp, Locale locale) throws Exception {
		LoginVO userInfo = commonUtil.aprUserInfo(loginCookie);
		String companyId = userInfo.getCompanyID();
		int tenantId = userInfo.getTenantId();
		
		String gwServerUrl = config.getProperty("config.mobileGwServerURL");
		String url = gwServerUrl + "/ezJournal/types";
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
		        .queryParam("companyId", companyId)
		        .queryParam("tenantId", tenantId);
		
		RestTemplate rest = new RestTemplate();
		
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("x-user-host", req.getServerName());
		
		HttpEntity<?> entity = new HttpEntity<>(headers);
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), HttpMethod.GET, entity, String.class);
		
		JSONParser jp = new JSONParser();
		JSONObject jsonResult = (JSONObject) jp.parse(result.getBody());
		
		JSONArray typeList = new JSONArray();
		String status = jsonResult.get("status").toString();
		
		if (status.equals("ok")) {
			typeList = (JSONArray) jsonResult.get("data");
			
			model.addAttribute("typeList", typeList);
		} else {
		}
		
		return "test";
	}
}
