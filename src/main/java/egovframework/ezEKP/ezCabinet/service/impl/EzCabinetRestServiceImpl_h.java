package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
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
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService_h;

@Service
public class EzCabinetRestServiceImpl_h implements EzCabinetRestService_h{
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetRestServiceImpl_h.class);
	
	@Autowired
	private Properties config;
	
	@Override
	public JSONObject getDeptMembers(HttpServletRequest request, String userId, String deptId, String currentPage) throws Exception {
		String url                = "/rest/ezCabinet/dept-member/" + deptId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		param.put("currentPage", currentPage);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getShareUserList(HttpServletRequest request, String userId, String cabinetId) throws Exception {
		String url                = "/rest/ezCabinet/share/cabinetId/" + cabinetId + "/get";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	public JSONObject getJsonResult(String restUrl, Map<String, Object> param, HttpServletRequest request, String methodType, JSONObject jsonParam){
		String gwServerUrl = config.getProperty("config.cabinetGwServerURL");
		restUrl            = gwServerUrl + restUrl;
		logger.debug("Rest Url: " + restUrl);
		HttpHeaders headers = new HttpHeaders();
		headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<?> entity         = new HttpEntity<>(jsonParam, headers);
		UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(restUrl);
		
		if (param != null) {
			for(String key : param.keySet()){
				builder.queryParam(key, param.get(key));
			}
		}
		
		RestTemplate rest = new RestTemplate();
		HttpMethod method = null;
		
		switch (methodType) {
			case "get"   : method = HttpMethod.GET   ; break;
			case "put"   : method = HttpMethod.PUT   ; break;
			case "post"  : method = HttpMethod.POST  ; break;
			case "delete": method = HttpMethod.DELETE; break;
			default      : method = HttpMethod.GET   ; break;
		}
		
		ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), method, entity, String.class);
		JSONParser jp                 = new JSONParser();
		JSONObject resultBody         = null;
		
		try {
			resultBody = (JSONObject) jp.parse(result.getBody());
		}
		catch (org.json.simple.parser.ParseException e) {
			e.printStackTrace();
		}
		
		return resultBody;
	}

	@Override
	public JSONObject getUserListType(HttpServletRequest request, String userId) throws Exception {
		String url                = "/rest/ezCabinet/list-type/userid/" + userId + "/get";
		JSONObject resultBody     = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}

	@Override
	public JSONObject saveUserListType(HttpServletRequest request, String userId, String listType) throws Exception {
		String url                = "/rest/ezCabinet/list-type/userid/" + userId + "/save";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("listType", listType);
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}

	@Override
	public JSONObject getSearchMember(HttpServletRequest request, String userId, String srchOption, String srchValue, String currentPage) throws Exception {
		String url                = "/rest/ezCabinet/search-member";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		param.put("srchOption",  srchOption);
		param.put("srchValue",   srchValue);
		param.put("currentPage", currentPage);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
}
