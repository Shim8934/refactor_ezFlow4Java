package egovframework.ezEKP.ezSurvey.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.compress.utils.IOUtils;
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
import egovframework.ezEKP.ezSurvey.service.EzSurveyRestService;

@Service
public class EzSurveyRestServiceImpl implements EzSurveyRestService {
	@Autowired
	private Properties config;
	
	private static final Logger logger = LoggerFactory.getLogger(EzSurveyRestServiceImpl.class);
	
	@Override
	public JSONObject getDeptSubNodes(HttpServletRequest request, String userId, String deptId, String level) throws Exception {
		String url                = "/rest/ezsurvey/sub-tree/" + deptId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("level", level);
		JSONObject resultBody = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getCompanyTree(HttpServletRequest request, String userId, String companyId) throws Exception {
		String url                = "/rest/ezsurvey/company-tree/comp/" + companyId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",    userId);
		param.put("companyId", companyId);
		JSONObject resultBody = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	public JSONObject getJsonResult(String restUrl, Map<String, Object> param, HttpServletRequest request, String methodType, JSONObject jsonParam){
		String gwServerUrl = config.getProperty("config.surveyGwServerURL");
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
		
		JSONObject resultBody         = null;
		
		try {
			ResponseEntity<String> result = rest.exchange(builder.build().encode().toUri(), method, entity, String.class);
			JSONParser jp                 = new JSONParser();
			
			try {
				resultBody = (JSONObject) jp.parse(result.getBody());
			}
			catch (org.json.simple.parser.ParseException e) {
				e.printStackTrace();
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return resultBody;
	}
	
	@Override
	public JSONObject getDeptMembers(HttpServletRequest request, String userId, String deptId, String currentPage) throws Exception {
		String url                = "/rest/ezsurvey/dept-member/" + deptId;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		param.put("currentPage", currentPage);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getUserListType(HttpServletRequest request, String userId) throws Exception {
		String url                = "/rest/ezsurvey/list-type/userid/" + userId + "/get";
		JSONObject resultBody     = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}

	@Override
	public JSONObject getSearchMember(HttpServletRequest request, String userId, String srchOption, String srchValue, String currentPage) throws Exception {
		String url                = "/rest/ezsurvey/search-member";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		param.put("srchOption",  srchOption);
		param.put("srchValue",   srchValue);
		param.put("currentPage", currentPage);
		
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@Override
	public JSONObject getUserPreviewConfig(HttpServletRequest request, String userId) throws Exception {
		String url            = "/rest/ezsurvey/config/id/" + userId;
		JSONObject resultBody = getJsonResult(url, null, request, "get", null);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject saveUserConfig(HttpServletRequest request, String userId, String prevMode, String listCount, String contentWPrev, String contentHPrev) throws Exception {
		String url                = "/rest/ezsurvey/config/id/" + userId;
		JSONObject jsonBody       = new JSONObject();
		jsonBody.put("prevMode",  prevMode);
		jsonBody.put("listCount", listCount);
		jsonBody.put("contentW",  contentWPrev);
		jsonBody.put("contentH",  contentHPrev);
		
		JSONObject resultBody     = getJsonResult(url, null, request, "put", jsonBody);
		
		return resultBody;
	}
	
	@Override
	public JSONObject saveSurveyItem(HttpServletRequest request, JSONObject surveyItem) throws Exception {
		String url            = "/rest/ezsurvey/survey-item/save";
		logger.debug(surveyItem.toJSONString());
		
		JSONObject resultBody = getJsonResult(url, null, request, "put", surveyItem);
		return resultBody;
	}
	
	@Override
	public JSONObject getSurveyItems(HttpServletRequest request, String userId, String pageMode, String title, String creatorName, String startDate, String endDate, String column, String order, String srchMode, String srchOption, String listCntSize, String currentPage) throws Exception {
		String url                = "/rest/ezsurvey/survey-item/get";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId",      userId);
		param.put("title",       title);
		param.put("pageMode",    pageMode);
		param.put("creatorName", creatorName);
		param.put("startDate",   startDate);
		param.put("endDate",     endDate);
		param.put("column",      column);
		param.put("order",       order);
		param.put("srchMode",    srchMode);
		param.put("srchOption",  srchOption);
		param.put("listCntSize", listCntSize);
		param.put("currentPage", currentPage);
		JSONObject resultBody     = getJsonResult(url, param, request, "get", null);
		return resultBody;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject uploadAttachFile(MultipartHttpServletRequest request, String userId, List<MultipartFile> multiFiles) throws Exception {
		String gwServerUrl                              = config.getProperty("config.surveyGwServerURL");
		String url                                      = gwServerUrl + "/rest/ezsurvey/attachfile/file-upload";
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
			e.printStackTrace();
		}
		
		return resultBody;
	}
	
	@Override
	public JSONObject deleteAttachFile(HttpServletRequest request, String userId, String filePath) throws Exception {
		String url                = "/rest/ezsurvey/attachfile/file-delete";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("filePath", filePath);
		JSONObject resultBody     = getJsonResult(url, param, request, "delete", null);
		return resultBody;
	}
	
	@Override
	public void downloadAttachFile(HttpServletRequest request, HttpServletResponse response, String userId, String filePath, String fileName) throws Exception {
		String gwServerUrl = config.getProperty("config.surveyGwServerURL");
		String url         = gwServerUrl + "/rest/ezsurvey/attachfile/file-download";
		
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
	
	private class MultipartFileResource extends InputStreamResource {
		private String filename;
		
		public MultipartFileResource(InputStream inputStream, String filename) {
			super(inputStream);
			this.filename = filename;
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
	
	private class BnkResourceHttpMessageConverter extends ResourceHttpMessageConverter {
		@Override
		protected Long getContentLength(Resource resource, MediaType contentType) throws IOException {
			Long contentLength = super.getContentLength(resource, contentType);
			
			return contentLength == null || contentLength < 0 ? null : contentLength;
		}
	}
}
