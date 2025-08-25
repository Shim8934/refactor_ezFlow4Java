package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;
import javax.servlet.http.HttpServletRequest;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
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
public class EzCabinetRestServiceImpl_m extends EgovAbstractServiceImpl implements EzCabinetRestService_m {
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetRestServiceImpl_m.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedApproval(HttpServletRequest request, String userId, String mode, String cabinetId, String divContent, String doctitle, String summary, String lstAttachLink, String otherAttachLk) {
		String url                = "/rest/ezcabinet/relate-item/save/apprv";
		JSONObject jsonParam      = new JSONObject();
		jsonParam.put("content",   divContent);
		jsonParam.put("userId",    userId);
		jsonParam.put("mode",      mode);
		jsonParam.put("cabinetId", cabinetId);
		jsonParam.put("title",     doctitle);
		jsonParam.put("summary",   summary);
		jsonParam.put("attach",    lstAttachLink);
		jsonParam.put("other",     otherAttachLk);
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonParam);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedJournal(HttpServletRequest request, String userId, String cabinetId, String mode, String title, String summary, String journalTitle, String createDate, String journalWriter, String journalType, String formName, String content, String attach) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/jounl";
		JSONObject jsonParam      = new JSONObject();
		jsonParam.put("userId",        userId);
		jsonParam.put("cabinetId",     cabinetId);
		jsonParam.put("mode",          mode);
		jsonParam.put("title",         title);
		jsonParam.put("summary",       summary);
		jsonParam.put("journalTitle",  journalTitle);
		jsonParam.put("createDate",    createDate);
		jsonParam.put("journalWriter", journalWriter);
		jsonParam.put("journalType",   journalType);
		jsonParam.put("formName",      formName);
		jsonParam.put("content",       content);
		jsonParam.put("attach",        attach);
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
			for (Entry<String, Object> entry : param.entrySet()) {
				builder.queryParam(entry.getKey(), entry.getValue());
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
			logger.error(e.getMessage(), e);
		}
		
		return resultBody;
	}
}

