package egovframework.ezEKP.ezApprovalG.web;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzApprovalGReformController extends EzFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGReformController.class);

	@Resource(name = "crypto")
	private EgovFileScrty egovFileScrty;

	@Value("#{config['config.reformServerURL']}")
	private String reformServerUrl;

	@RequestMapping(value = "/reform/getDataSourceList.do", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public String getDataSourceList(HttpServletRequest request) throws Exception {
		logger.debug("getDataSourceList started.");

		String result = requestFromReformServer("/reform_server/databind/getDataSourceList", null, HttpMethod.GET);

		logger.debug("result: {}", result);
		logger.debug("getDataSourceList ended.");

		return result;
	}
	
	@RequestMapping(value = "/reform/executeQuery.do", method = RequestMethod.POST, params = { "dataSource", "sqlQuery", "sqlParamList" }, produces = "application/json; charset=utf-8")
	@ResponseBody
	public String executeSqlQuery(HttpServletRequest request, @RequestParam String dataSource, @RequestParam String sqlQuery, @RequestParam String sqlParamList) throws Exception {
		logger.debug("executeSqlQuery started.");

		// sqlQuery 복호화
		Map<String, Object> parameterMap = new HashMap<>();
		parameterMap.put("dataSource", dataSource);
		parameterMap.put("sqlParamList", sqlParamList);
		parameterMap.put("sqlQuery", egovFileScrty.decryptAES(sqlQuery));

		String result = requestFromReformServer("/reform_server/databind", parameterMap, HttpMethod.POST);

		logger.debug("result: {}", result);
		logger.debug("executeSqlQuery ended.");

		return result;
	}

	@RequestMapping(value = "/reform/getEncryptedSQLQuery.do", method = RequestMethod.POST, params = { "sqlQuery" })
	@ResponseBody
	public String getEncryptedSQLQuery(HttpServletRequest request) throws Exception {
		logger.debug("getEncryptedSQLQuery started.");

		String sqlQuery = request.getParameter("sqlQuery");
		logger.debug("sqlQuery: {}", sqlQuery);

		String encryptedQuery = egovFileScrty.encryptAES(sqlQuery);
		logger.debug("encrypted query: {}", encryptedQuery);

		logger.debug("getEncryptedSQLQuery ended.");

		return encryptedQuery;
	}

	private String requestFromReformServer(String url, Map<String, ?> parameter, HttpMethod method) {
		String requestUrl = reformServerUrl + url;

		HttpHeaders httpHeaders = new HttpHeaders();
		httpHeaders.add("Accept", MediaType.APPLICATION_JSON_UTF8_VALUE);

		HttpEntity<?> requestEntity = new HttpEntity<>(httpHeaders);
		UriComponentsBuilder uriBuilder = UriComponentsBuilder.fromHttpUrl(requestUrl);

		if (parameter != null && !parameter.isEmpty()) {
			parameter.entrySet().forEach(entry -> uriBuilder.queryParam(entry.getKey(), entry.getValue()));
		}

		ResponseEntity<String> responseEntity = new RestTemplate().exchange(uriBuilder.build().encode().toUri(), method, requestEntity, String.class);

		return responseEntity.getBody();
	}
}
