package egovframework.ezEKP.ezCabinet.service.impl;

import java.util.HashMap;
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
import egovframework.ezEKP.ezCabinet.service.EzCabinetRestService_h;

@Service
public class EzCabinetRestServiceImpl_h extends EgovAbstractServiceImpl implements EzCabinetRestService_h {
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
	public JSONObject getShareUserList(HttpServletRequest request, String userId, String cabinetId, String searchOpt, String searchValue, String searchFlag) throws Exception {
		String url                = "/rest/ezCabinet/shared-member/cabinetid/" + cabinetId + "/get";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		param.put("searchOpt",   searchOpt);
		param.put("searchValue", searchValue);
		param.put("searchFlag",  searchFlag); // 공유자 검색 Flag
		
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getAncestorShareUserList(HttpServletRequest request, String userId, String cabinetId) throws Exception {
		String url                = "/rest/ezCabinet/shared-ancestor/cabinetid/" + cabinetId + "/get";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		
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
	
	@Override
	public JSONObject saveShareUserList(HttpServletRequest request, String userId, String cabinetId, String userList) throws Exception {
		String url                = "/rest/ezCabinet/shared-member/cabinetId/" + cabinetId + "/save";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		param.put("userList",    userList);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject modifyShareUserList(HttpServletRequest request, String userId, String cabinetId, String userList, String actMode) throws Exception {
		String url                = "/rest/ezCabinet/shared-member/cabinetId/" + cabinetId + "/modify";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",   userId);
		param.put("mode",     actMode);
		param.put("userList", userList);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject checkPermission(HttpServletRequest request, String userId, String itemId, String cabinetId, int permission) throws Exception {
		String url                = "/rest/ezCabinet/check-permission";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",     userId);
		param.put("itemId",     itemId);
		param.put("cabinetId",  cabinetId);
		param.put("permission", permission);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getFileDetail(HttpServletRequest request, String userId, String itemId) throws Exception {
		String url                = "/rest/ezCabinet/file-detail/itemId/" + itemId + "/get";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject cabinetItemInfo(HttpServletRequest request, String userId, String itemId) throws Exception {
		String url                = "/rest/ezCabinet/file-info/itemId/" + itemId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject modifyItem(HttpServletRequest request, String userId, String itemId, String title, String summary, String fileArray, String relatedArr) throws Exception {
		String url                = "/rest/ezcabinet/item/id/" + itemId + "/modify";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("title",      title);
		jsonBody.put("summary",    summary);
		jsonBody.put("fileArray",  fileArray);
		jsonBody.put("relatedArr", relatedArr);
		jsonBody.put("userId",     userId);
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedBoard(HttpServletRequest request, String userId, String mode, String cabinetId, String title, String summary, String boardTitle, String writer, String dateTime, String attach, String content) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/board";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",     userId);
		jsonBody.put("mode",       mode);
		jsonBody.put("cabinet",    cabinetId);
		jsonBody.put("title",      title);
		jsonBody.put("summary",    summary);
		jsonBody.put("boardTitle", boardTitle);
		jsonBody.put("writer",     writer);
		jsonBody.put("dateTime",   dateTime);
		jsonBody.put("attach",     attach);
		jsonBody.put("content",    content);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedOption(HttpServletRequest request, String userId, String mode, String cabinetId, String title, String summary, String optionTitle, String writer, String date, String content, String attach) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/option";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",      userId);
		jsonBody.put("mode",        mode);
		jsonBody.put("cabinet",     cabinetId);
		jsonBody.put("title",       title);
		jsonBody.put("summary",     summary);
		jsonBody.put("optionTitle", optionTitle);
		jsonBody.put("writer",      writer);
		jsonBody.put("date",        date);
		jsonBody.put("content",     content);
		jsonBody.put("attach",      attach);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedCommunity(HttpServletRequest request, String userId, String mode, String cabinetId, String title, String summary, String commuTitle, String writer, String date, String endDate, String content, String attach) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/community";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",     userId);
		jsonBody.put("mode",       mode);
		jsonBody.put("cabinet",    cabinetId);
		jsonBody.put("title",      title);
		jsonBody.put("summary",    summary);
		jsonBody.put("commuTitle", commuTitle);
		jsonBody.put("writer",     writer);
		jsonBody.put("date",       date);
		jsonBody.put("endDate",    endDate);
		jsonBody.put("content",    content);
		jsonBody.put("attach",     attach);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedPhotoCommunity(HttpServletRequest request, String userId, String mode, String cabinetId, String title, String summary,  String commuTitle, String writer, String content) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/photo-community";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",     userId);
		jsonBody.put("mode",       mode);
		jsonBody.put("cabinet",    cabinetId);
		jsonBody.put("title",      title);
		jsonBody.put("summary",    summary);
		jsonBody.put("commuTitle", commuTitle);
		jsonBody.put("writer",     writer);
		jsonBody.put("content",    content);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
}
