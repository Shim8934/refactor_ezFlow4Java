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

import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService_m;

@Service
public class EzCabinetRestServiceImpl_m implements EzCabinetRestService_m {
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetRestServiceImpl_m.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedApproval(HttpServletRequest request, String userId, String mode, String cabinetId, String divContent, String doctitle, String lstAttachLink, String otherAttachLk) {
		String url                = "/rest/ezcabinet/relate-item/save/apprv";
		JSONObject jsonParam      = new JSONObject();
		jsonParam.put("content",       divContent);
		jsonParam.put("userId",        userId);
		jsonParam.put("mode",          mode);
		jsonParam.put("cabinetId",     cabinetId);
		jsonParam.put("doctitle",      doctitle);
		jsonParam.put("lstAttachLink", lstAttachLink);
		jsonParam.put("otherAttachLk", otherAttachLk);
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonParam);
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
}

