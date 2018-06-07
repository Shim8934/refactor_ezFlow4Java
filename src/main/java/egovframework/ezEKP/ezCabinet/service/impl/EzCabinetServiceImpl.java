package egovframework.ezEKP.ezCabinet.service.impl;

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
import egovframework.ezEKP.ezCabinet.service.EzCabinetService;

@Service
public class EzCabinetServiceImpl implements EzCabinetService {
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetServiceImpl.class);
	
	@Autowired
	private Properties config;
	
	@Override
	@SuppressWarnings("unchecked")
	public JSONObject checkCabinetAdmin(HttpServletRequest request, String userId) throws Exception {
		String gwServerUrl    = config.getProperty("config.cabinetGwServerURL");
		String url            = gwServerUrl + "/rest/ezcabinet/check-admin/" + userId;
		JSONObject resultBody = getJsonResult(url, null, request, "get", null);
		String status         = resultBody.get("status").toString();
		JSONObject resultObj  =  new JSONObject();
		
		if (status.equals("ok")) {
			if (resultBody.get("data").toString().equals("1")) {
				resultObj.put("result", "ok");
			}
			else {
				resultObj.put("result", "notok");
				resultObj.put("reason", resultBody.get("reason").toString());
			}
		}
		else {
			resultObj.put("result", "notok");
			resultObj.put("reason", resultBody.get("reason").toString());
		}
		
		logger.debug("Result: " + resultObj.get("result") + " || Reason: " + resultObj.get("reason"));
		
		return resultObj;
	}
	
	public static JSONObject getJsonResult(String restUrl, Map<String, Object> param, HttpServletRequest request, String methodType, JSONObject jsonParam){
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
		
		logger.debug("Run here!");
		
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
}
