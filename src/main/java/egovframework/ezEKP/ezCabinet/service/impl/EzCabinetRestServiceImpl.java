package egovframework.ezEKP.ezCabinet.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.io.IOUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.ClientHttpRequest;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.ResourceHttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.ResponseExtractor;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
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
		param.put("userId",    userId);
		param.put("companyId", companyId);
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
	public JSONObject saveUserDefaultCapacity(HttpServletRequest request, List<String> userList, String companyId) throws Exception {
		String url                = "/rest/ezcabinetadmin/defaultCapcity/person";
		Map<String, Object> param = new HashMap<String, Object>();
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
	public JSONObject checkUserActiveModules(HttpServletRequest request, String userId, String module) throws Exception {
		String url            = "/rest/ezcabinet/module/id/" + userId + "/active-check";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("module", module);
		JSONObject resultBody = getJsonResult(url, param, request, "get", null);
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
	public JSONObject getAllCabinetTree(HttpServletRequest request, String currentNode, String userId) throws Exception {
		String url                = "/rest/ezcabinet/allcabinet/id/" + userId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("cabinetId", currentNode);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getRelatedCabinetTree(HttpServletRequest request, String userId, String currentNode) throws Exception {
		String url                = "/rest/ezcabinet/relatedcabinet/id/" + userId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("mode", currentNode);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getSharedCabinetTree(HttpServletRequest request, String userId) throws Exception {
		String url                = "/rest/ezcabinet/sharedcabinet/id/" + userId;
		JSONObject resultBody     = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getMyShareCabinetTree(HttpServletRequest request, String userId, String currentNode) throws Exception {
		String url                = "/rest/ezcabinet/myshare/id/" + userId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("currentNode", currentNode);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getUserSharedCabinet(HttpServletRequest request, String userId, String shareId) throws Exception {
		String url                = "/rest/ezcabinet/sharedcabinet/shareid/" + shareId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
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
	public JSONObject addCabinet(HttpServletRequest request, String userId, String parentId, String cabinetName1) throws Exception {
		String url                = "/rest/ezcabinet/cabinet/add";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",   userId);
		param.put("parentId", parentId);
		param.put("cabName1", cabinetName1);
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject renameCabinet(HttpServletRequest request, String userId, String cabinetId, String cabinetName1) throws Exception {
		String url                = "/rest/ezcabinet/cabinet/rename";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",    userId);
		param.put("cabinetId", cabinetId);
		param.put("cabName1",  cabinetName1);
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
	
	@Override
	public JSONObject moveCabinet(HttpServletRequest request, String userId, String cabinetId, String parentId, String mode) throws Exception {
		String url                = "/rest/ezcabinet/cabinet-move/mode/" + mode;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",    userId);
		param.put("cabinetId", cabinetId);
		param.put("parentId",  parentId);
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject uploadAttachFile(MultipartHttpServletRequest request, String userId, List<MultipartFile> multiFiles) throws Exception {
		String gwServerUrl                              = config.getProperty("config.cabinetGwServerURL");
		String url                                      = gwServerUrl + "/rest/ezcabinet/attachfile/file-upload";
		SimpleClientHttpRequestFactory requestFactory   = new SimpleClientHttpRequestFactory();
		requestFactory.setBufferRequestBody(false);
		RestTemplate restTemplate                       = new RestTemplate(requestFactory);
		List<HttpMessageConverter<?>> messageConverters = restTemplate.getMessageConverters();
		
		for (int i = 0; i < messageConverters.size(); i++) {
			HttpMessageConverter<?> messageConverter = messageConverters.get(i);
			
			if (messageConverter.getClass().equals(ResourceHttpMessageConverter.class)) {
				messageConverters.set(i, new BnkResourceHttpMessageConverter());
			}
		}
		
		MultiValueMap<String, Object> map = new LinkedMultiValueMap<String, Object>();
		JSONObject jsonObject             = new JSONObject();
		JSONArray jsonArray               = new JSONArray();
		
		for (MultipartFile file: multiFiles) {
			JSONObject fileJson = new JSONObject();
			
			fileJson.put("originalFilename", file.getOriginalFilename());
			jsonArray.add(fileJson);
			map.add("files", new MultipartFileResource(file.getInputStream(), file.getOriginalFilename()));
		}
		
		jsonObject.put("nameArray", jsonArray);
		
		map.add("data", jsonObject);
		
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.MULTIPART_FORM_DATA);
		headers.set("host-name", request.getServerName());
		
		HttpEntity<MultiValueMap<String, Object>> entity = new HttpEntity<MultiValueMap<String, Object>>(map, headers);
		UriComponentsBuilder builder                     = UriComponentsBuilder.fromHttpUrl(url);
		ResponseEntity<String> result                    = restTemplate.exchange(builder.build().encode().toUri(), HttpMethod.POST, entity, String.class);
		JSONParser jp                                    = new JSONParser();
		JSONObject resultBody                            = null;
		
		try {
			resultBody = (JSONObject) jp.parse(result.getBody());
		}
		catch (org.json.simple.parser.ParseException e) {
			logger.error(e.getMessage(), e);
		}
		
		return resultBody;
	}
	
	@Override
	public JSONObject deleteAttachFile(HttpServletRequest request, String userId, String filePath) throws Exception {
		String url                = "/rest/ezcabinet/attachfile/file-delete";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("filePath", filePath);
		JSONObject resultBody     = getJsonResult(url, param, request, "delete", null);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveItem(HttpServletRequest request, String userId, String cabinetId, String title, String summary, String fileArray, String relatedArr) throws Exception {
		String url                = "/rest/ezcabinet/item/id/" + cabinetId + "/add";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("title",      title);
		jsonBody.put("summary",    summary);
		jsonBody.put("fileArray",  fileArray);
		jsonBody.put("relatedArr", relatedArr);
		jsonBody.put("userId",     userId);
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@Override
	public JSONObject getCabinetInfo(HttpServletRequest request, String userId, String cabinetId) throws Exception {
		String url                = "/rest/ezcabinet/cabinet/id/" + cabinetId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getShareCabinetInfo(HttpServletRequest request, String userId, String cabinetId) throws Exception {
		String url                = "/rest/ezcabinet/share-cabinet/id/" + cabinetId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject deleteItems(HttpServletRequest request, String userId, List<String> itemList) throws Exception {
		String url                = "/rest/ezcabinet/item/delete";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",   userId);
		param.put("itemList", String.join(",", itemList));
		JSONObject resultBody     = getJsonResult(url, param, request, "delete", null);
		return resultBody;
	}
	
	@Override
	public JSONObject moveItems(HttpServletRequest request, String userId, String cabinetId, String mode, List<String> itemList) throws Exception {
		String url                = "/rest/ezcabinet/item-move/mode/" + mode;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",    userId);
		param.put("cabinetId", cabinetId);
		param.put("itemList",  String.join(",", itemList));
		JSONObject resultBody     = getJsonResult(url, param, request, "put", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getCabinetItems(HttpServletRequest request, String userId, String cabinetId, String title, String summary, String recursive, String creatorName, String startDate, String endDate, String column, String order, String srchMode, String srchOption, String listCntSize, String currentPage) throws Exception {
		String url                = "/rest/ezcabinet/item/id/" + cabinetId + "/get";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		param.put("title",       title);
		param.put("summary",     summary);
		param.put("recursive",   recursive);
		param.put("creatorName", creatorName);
		param.put("startDate",   startDate);
		param.put("endDate",     endDate);
		param.put("column",      column);
		param.put("order",       order);
		param.put("srchMode",    srchMode);
		param.put("srchOption",  srchOption);
		param.put("listCntSize", listCntSize);
		param.put("currentPage", currentPage);
		
		JSONObject resultBody = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	private static class MultipartFileResource extends InputStreamResource {
		private String filename;
		
		public MultipartFileResource(InputStream inputStream, String filename) {
			super(inputStream);
			this.filename = filename;
		}
		
		@Override
		public boolean equals(Object obj) {
			if (!super.equals(obj)) {
				return false;
			}
			
			MultipartFileResource fobj = (MultipartFileResource) obj;
			return filename.equals(fobj.getFilename());
		}
		
		@Override
		public int hashCode() {
			return 53 + filename.hashCode();
		}
		
		@Override
		public String getFilename() {
			return this.filename;
		}
		
		@Override
		public long contentLength() throws IOException {
			return -1;
		}
	}
	
	private static class BnkResourceHttpMessageConverter extends ResourceHttpMessageConverter {
		@Override
		protected Long getContentLength(Resource resource, MediaType contentType) throws IOException {
			Long contentLength = super.getContentLength(resource, contentType);
			
			return contentLength == null || contentLength < 0 ? null : contentLength;
		}
	}
	
	@Override
	public JSONObject getCabinetFiles(HttpServletRequest request, String userId, String cabinetId, String currentPage) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/id/" + cabinetId + "/get";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		param.put("currentPage", currentPage);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getFilesBySearching(HttpServletRequest request, String userId, String itemTitle, String currentPage) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/search";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("title",  itemTitle);
		param.put("currentPage", currentPage);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public void downloadAttachFile(HttpServletRequest request, HttpServletResponse response, String userId, String filePath, String fileName) throws Exception {
		String gwServerUrl = config.getProperty("config.cabinetGwServerURL");
		String url         = gwServerUrl + "/rest/ezcabinet/attachfile/file-download";
		
		UriComponentsBuilder builder  = UriComponentsBuilder.fromHttpUrl(url)
				.queryParam("userAgent", request.getHeader("User-Agent"))
				.queryParam("userId",    userId)
				.queryParam("fileName",  fileName)
				.queryParam("filePath",  filePath);
		
		RestTemplate rest = new RestTemplate();
		RequestCallback requestCallback = new RequestCallback() {
			@Override
			public void doWithRequest(ClientHttpRequest req) throws IOException {
				req.getHeaders().setAccept(Arrays.asList(MediaType.APPLICATION_OCTET_STREAM, MediaType.ALL));
				req.getHeaders().set("host-name", request.getServerName());
			}
		};
		
		// Streams the response instead of loading it all in memory
		ResponseExtractor<Void> responseExtractor = res -> {
			response.setHeader("Content-Type", "application/zip");
			response.setHeader("Content-Disposition", res.getHeaders().get("Content-Disposition").get(0));
			
			IOUtils.copy(res.getBody(), response.getOutputStream());
			
			response.getOutputStream().flush();
			response.getOutputStream().close();
			
			return null;
		};
		
		rest.execute(builder.build().encode().toUri(), HttpMethod.GET, requestCallback, responseExtractor);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedEmail(HttpServletRequest request, String userId, String title, String summary, String mailTitle, String sender, String attach, String mode, String cabinetId, String content, String receiver, String forward, String dateTime) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/email";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",   userId);
		jsonBody.put("title",    title);
		jsonBody.put("summary",  summary);
		jsonBody.put("mailTitle",mailTitle);
		jsonBody.put("sender",   sender);
		jsonBody.put("attach",   attach);
		jsonBody.put("mode",     mode);
		jsonBody.put("content",  content);
		jsonBody.put("receiver", receiver);
		jsonBody.put("forward",  forward);
		jsonBody.put("dateTime", dateTime);
		jsonBody.put("cabinet",  cabinetId);
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject modifyRelatedItem(HttpServletRequest request, String userId, String itemId, String title, String summary, String relatedList) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/modify/id/" + itemId;
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",  userId);
		jsonBody.put("title",   title);
		jsonBody.put("summary", summary);
		jsonBody.put("relate",  relatedList);
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedGroupAdress(HttpServletRequest request, String userId, String title, String summary, String mode, String cabinetId, String groupName,String content, String createUser, String createDate, String changeUser, String changeDate) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/address-group";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",     userId);
		jsonBody.put("title",      title);
		jsonBody.put("summary",    summary);
		jsonBody.put("mode",       mode);
		jsonBody.put("groupName",  groupName);
		jsonBody.put("content",    content);
		jsonBody.put("createUser", createUser);
		jsonBody.put("createDate", createDate);
		jsonBody.put("changeUser", changeUser);
		jsonBody.put("changeDate", changeDate);
		jsonBody.put("cabinet",    cabinetId);
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedNormalAdress(HttpServletRequest request, String userId, String title, String summary, String mode, String cabinetId, String createUser, String createDate, String changeUser, String changeDate, String company, String department, String position, String email, String compNumber, String userNumber, String faxNumber, String homePage, String companyZip, String compAddr, String homeZip, String homeAddr, String memo) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/address-normal";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",     userId);
		jsonBody.put("title",      title);
		jsonBody.put("summary",    summary);
		jsonBody.put("mode",       mode);
		jsonBody.put("cabinet",    cabinetId);
		jsonBody.put("createUser", createUser);
		jsonBody.put("createDate", createDate);
		jsonBody.put("changeUser", changeUser);
		jsonBody.put("changeDate", changeDate);
		jsonBody.put("company",    company);
		jsonBody.put("department", department);
		jsonBody.put("position",   position);
		jsonBody.put("email",      email);
		jsonBody.put("compNumber", compNumber);
		jsonBody.put("userNumber", userNumber);
		jsonBody.put("faxNumber",  faxNumber);
		jsonBody.put("homePage",   homePage);
		jsonBody.put("companyZip", companyZip);
		jsonBody.put("compAddr",   compAddr);
		jsonBody.put("homeZip",    homeZip);
		jsonBody.put("homeAddr",   homeAddr);
		jsonBody.put("memo",       memo);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedResource(HttpServletRequest request, String userId, String title, String summary, String mode, String cabinetId, String resTitle, String content, String createUser, String resDate, String resItem) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/resource";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",     userId);
		jsonBody.put("title",      title);
		jsonBody.put("summary",    summary);
		jsonBody.put("mode",       mode);
		jsonBody.put("cabinet",    cabinetId);
		jsonBody.put("resTitle",   resTitle);
		jsonBody.put("createUser", createUser);
		jsonBody.put("resDate",    resDate);
		jsonBody.put("resItem",    resItem);
		jsonBody.put("content",    content);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedSchedule(HttpServletRequest request, String userId, String title, String summary, String mode, String cabinetId, String scheduleTitle, String createUser, String createDate, String scheduleDate, String location, String publicstatus, String groupname, String attendant, String scheduletype, String attach, String content) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/schedule";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",        userId);
		jsonBody.put("title",         title);
		jsonBody.put("summary",       summary);
		jsonBody.put("mode",          mode);
		jsonBody.put("cabinet",       cabinetId);
		jsonBody.put("scheduleTitle", scheduleTitle);
		jsonBody.put("createUser",    createUser);
		jsonBody.put("createDate",    createDate);
		jsonBody.put("scheduleDate",  scheduleDate);
		jsonBody.put("location",      location);
		jsonBody.put("publicstatus",  publicstatus);
		jsonBody.put("groupname",     groupname);
		jsonBody.put("attendant",     attendant);
		jsonBody.put("scheduletype",  scheduletype);
		jsonBody.put("attach",        attach);
		jsonBody.put("content",       content);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveRelatedTodo(HttpServletRequest request, String userId, String title, String mode, String cabinetId, String createUser, String createDate, String priority, String memo, String tasktype, String executor, String shareList, String attach, String content) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/todo";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",     userId);
		jsonBody.put("title",      title);
		jsonBody.put("mode",       mode);
		jsonBody.put("cabinet",    cabinetId);
		jsonBody.put("createUser", createUser);
		jsonBody.put("createDate", createDate);
		jsonBody.put("priority",   priority);
		jsonBody.put("memo",       memo);
		jsonBody.put("tasktype",   tasktype);
		jsonBody.put("executor",   executor);
		jsonBody.put("shareList",  shareList);
		jsonBody.put("attach",     attach);
		jsonBody.put("content",    content);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject savePhotoBoard(HttpServletRequest request, String userId, String title, String summary, String boardTitle, String mode, String cabinetId, String createUser, String createDate, String descript, String boardId, String itemId) throws Exception {
		String url                = "/rest/ezcabinet/relate-item/save/photo-board";
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("userId",     userId);
		jsonBody.put("title",      title);
		jsonBody.put("summary",    summary);
		jsonBody.put("boardTitle", boardTitle);
		jsonBody.put("mode",       mode);
		jsonBody.put("cabinet",    cabinetId);
		jsonBody.put("createUser", createUser);
		jsonBody.put("createDate", createDate);
		jsonBody.put("descript",   descript);
		jsonBody.put("boardId",    boardId);
		jsonBody.put("itemId",     itemId);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		return resultBody;
	}
}
