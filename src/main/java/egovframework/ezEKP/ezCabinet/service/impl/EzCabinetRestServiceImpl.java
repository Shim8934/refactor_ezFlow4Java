package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
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
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService;

@Service
public class EzCabinetRestServiceImpl implements EzCabinetRestService {
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCabinetRestServiceImpl.class);
	
	@Override
	public JSONObject checkCabinetAdmin(HttpServletRequest request, String userId) throws Exception {
		String url            = "/rest/ezcabinet/check-admin/" + userId;
		JSONObject resultBody = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getCompanyList(HttpServletRequest request, String userId) throws Exception {
		String url            = "/rest/ezcabinet/company-list/" + userId;
		JSONObject resultBody = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getDeptSubNodes(HttpServletRequest request, String userId, String deptId, String level) throws Exception {
		String url                = "/rest/ezcabinet/sub-tree/" + deptId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("level", level);
		JSONObject resultBody = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getCompanyTree(HttpServletRequest request, String userId, String companyId) throws Exception {
		String url                = "/rest/ezcabinet/company-tree/comp/" + companyId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		JSONObject resultBody = getJsonResult(url, param, request, "get", null);
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
	public JSONObject getCompanyCapacity(HttpServletRequest request, String companyId) throws Exception {
		String url            = "/rest/ezcabinetadmin/capcity/id/" + companyId + "/comp";
		JSONObject resultBody = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject saveCompanyCapacity(HttpServletRequest request, String capacityType, String newCapacity, String companyId) throws Exception {
		String url                = "/rest/ezcabinetadmin/capcity/id/" + companyId + "/comp";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("newCapacity",  newCapacity);
		param.put("capacityType", capacityType);
		JSONObject resultBody = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getUserCapacity(HttpServletRequest request, String currPage, String companyId, String userId, String searchStr, String searchOpt, String column, String order, String listCnt) throws Exception {
		String url                = "/rest/ezcabinetadmin/capcity/id/" + companyId + "/person";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("currPage",  currPage);
		param.put("userId",    userId);
		param.put("searchStr", searchStr);
		param.put("searchOpt", searchOpt);
		param.put("column",    column);
		param.put("order",     order);
		param.put("listCnt",   listCnt);
		
		JSONObject resultBody = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject saveUserCapacity(HttpServletRequest request, List<String> userList, String capacityType, String newCapacity, String companyId) throws Exception {
		String url                = "/rest/ezcabinetadmin/capcity/person";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("newCapacity",  newCapacity);
		param.put("capacityType", capacityType);
		param.put("companyId",    companyId);
		param.put("userList",     String.join(",", userList));
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getModuleListForAdmin(HttpServletRequest request, String companyId) throws Exception {
		String url            = "/rest/ezcabinetadmin/module/id/" + companyId + "/comp";
		JSONObject resultBody = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject saveModulesSetting(HttpServletRequest request, JSONArray moduleList, String companyId) throws Exception {
		String url                = "/rest/ezcabinetadmin/module/id/" + companyId + "/comp";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("modules", moduleList);
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getModuleListForUser(HttpServletRequest request, String userId) {
		String url            = "/rest/ezcabinet/module/id/" + userId + "/person";
		JSONObject resultBody = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject saveModulesSettingForUser(HttpServletRequest request, JSONArray moduleList, String userId) throws Exception {
		String url                = "/rest/ezcabinet/module/id/" + userId + "/person";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("modules", moduleList);
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getUserCapacity(HttpServletRequest request, String userId) throws Exception {
		String url            = "/rest/ezcabinet/capacity/" + userId;
		JSONObject resultBody = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getUserPreviewConfig(HttpServletRequest request, String userId) throws Exception {
		String url            = "/rest/ezcabinet/config/id/" + userId;
		JSONObject resultBody = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject saveUserConfig(HttpServletRequest request, String userId, String prevMode, String listCount, String contentWPrev, String contentHPrev) throws Exception {
		String url                = "/rest/ezcabinet/config/id/" + userId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("prevMode",  prevMode);
		param.put("listCount", listCount);
		param.put("contentW",  contentWPrev);
		param.put("contentH",  contentHPrev);
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getMyCabinetTree(HttpServletRequest request, String currentNode, String userId) throws Exception {
		String url                = "/rest/ezcabinet/mycabinet/id/" + userId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("cabinetId", currentNode);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getCabinetSubNodes(HttpServletRequest request, String userId, String nodeId) throws Exception {
		String url                = "/rest/ezcabinet/cabinet/id/" + nodeId + "/sub-node";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",   userId);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject addCabinet(HttpServletRequest request, String userId, String parentId, String cabinetName1, String cabinetName2) throws Exception {
		String url                = "/rest/ezcabinet/cabinet/add";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",   userId);
		param.put("parentId", parentId);
		param.put("cabName1", cabinetName1);
		param.put("cabName2", cabinetName2);
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject renameCabinet(HttpServletRequest request, String userId, String cabinetId, String cabinetName1, String cabinetName2) throws Exception {
		String url                = "/rest/ezcabinet/cabinet/rename";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",    userId);
		param.put("cabinetId", cabinetId);
		param.put("cabName1",  cabinetName1);
		param.put("cabName2",  cabinetName2);
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}

	@Override
	public JSONObject deleteCabinet(HttpServletRequest request, String userId, String cabinetId) throws Exception {
		String url                = "/rest/ezcabinet/cabinet/delete";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",    userId);
		param.put("cabinetId", cabinetId);
		JSONObject resultBody     = getJsonResult(url, param, request, "delete", null);
		return resultBody;
	}
}
