package egovframework.ezEKP.ezTeams.service.impl;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezTeams.dao.EzTeamsDAO;
import egovframework.ezEKP.ezTeams.service.EzTeamsService;
import egovframework.ezEKP.ezTeams.vo.TeamsPresenceVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.microsoft.aad.msal4j.*;

import java.util.Collections;

import javax.annotation.Resource;
import java.util.Map;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.xml.sax.InputSource;

import java.io.StringReader;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.concurrent.CompletableFuture;

import org.apache.commons.lang3.StringUtils;

@Service("EzTeamsService")
public class EzTeamsServiceImpl implements EzTeamsService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzTeamsServiceImpl.class);

	@Resource(name = "EzTeamsDAO")
	private EzTeamsDAO ezTeamsDAO;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	/**
	 * Graph API용 Application 권한 토큰 발급 (직접 HTTP 호출 방식) - getPublicAppToken으로 대체할지 고민 중 
	 */
	public String getGraphApiToken(int tenantId) throws Exception {
		RestTemplate restTemplate = new RestTemplate();
		
		String teamsClientId = ezCommonService.getTenantConfig("teamsClientId", tenantId);
		String teamsClientSecret = ezCommonService.getTenantConfig("teamsClientSecret", tenantId);
		String teamsTenantId = ezCommonService.getTenantConfig("teamsTenantId", tenantId);
		String tokenEndpoint = "https://login.microsoftonline.com/" + teamsTenantId + "/oauth2/v2.0/token";
		logger.debug("clientId = {}, clientSecret = {}, teamsTenantId = {}, tokenEndpoint = {}", teamsClientId, teamsClientSecret, teamsTenantId, tokenEndpoint);
		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
		form.add("client_id", teamsClientId);
		form.add("client_secret", teamsClientSecret);
		form.add("scope", "https://graph.microsoft.com/.default");
		form.add("grant_type", "client_credentials");

		HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(form, headers);
		ResponseEntity<Map> response = restTemplate.postForEntity(tokenEndpoint, request, Map.class, teamsTenantId);

		return (String) response.getBody().get("access_token");
	}

	/**
	 * Microsoft Graph API용 Application 권한 토큰 발급 (MSAL4J 사용)
	 */
	@Override
	public String getPublicAppToken(String teamsTenant, String appId, String appSecret) throws Exception {
		logger.debug("getPublicAppToken started");

        String authority = "https://login.microsoftonline.com/" + teamsTenant;
        String graphScope = "https://graph.microsoft.com/.default";

        IClientCredential credential = ClientCredentialFactory.createFromSecret(appSecret);
        ConfidentialClientApplication app = ConfidentialClientApplication.builder(appId, credential).authority(authority).build();

        ClientCredentialParameters parameters = ClientCredentialParameters.builder(Collections.singleton(graphScope)).build();

        CompletableFuture<IAuthenticationResult> future = app.acquireToken(parameters);
        IAuthenticationResult result = future.get();

		logger.debug("getPublicAppToken ended");
		return result.accessToken();
	}

	/**
	 * 사용자 계정(ID/PW) 기반의 Delegated 권한 토큰 발급
	 */
	@Override
	public String getDelegatedToken(String clientId, String tenantId, String username, String password) throws Exception {
		logger.debug("getDelegatedToken started");
		PublicClientApplication pca = PublicClientApplication.builder(clientId)
				.authority("https://login.microsoftonline.com/" + tenantId)
				.build();

		UserNamePasswordParameters parameters = UserNamePasswordParameters.builder(
						Collections.singleton("https://graph.microsoft.com/.default"),
						username,
						password.toCharArray())
				.build();

		IAuthenticationResult result = pca.acquireToken(parameters).join();
		logger.debug("getDelegatedToken ended");
		return result.accessToken();
	}
	
	/**
	 * DB(TBL_AUTHTOKEN)에 저장된 토큰 조회
	 */
	@Override
	public String getToken(String tokenType) throws Exception {
		logger.debug("getToken started");
		String token = "";

		try {
			Map<String, Object> param = new HashMap<>();
			param.put("APITYPE", "GRAPH");
			param.put("TOKENTYPE", tokenType);

			List<String> resultList = ezTeamsDAO.getToken(param);

			if (resultList != null && !resultList.isEmpty()) {
				token = resultList.get(0);
			}
		} catch (Exception ex) {
			logger.error("[getToken] Exception: {}", ex.toString());
		}

		logger.debug("getToken ended");
		return token;
	}

	/**
	 * DB(TBL_USERPRESENCE)에서 Teams 사용자의 Presence 정보 조회
	 */
	@Override
	public String getPresenceList(String requestXml) throws Exception {
		logger.debug("getPresenceList started");

		if (StringUtils.isBlank(requestXml)) {
			return "";
		}

		try {
			List<String> userIdList  = new ArrayList<>();

			DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
			Document doc = dBuilder.parse(new InputSource(new StringReader(requestXml)));

			NodeList nodes = doc.getElementsByTagName("USERID");
			for (int i = 0; i < nodes.getLength(); i++) {
				String uid = nodes.item(i).getTextContent().trim();
				if (StringUtils.isNotBlank(uid)) {
					userIdList.add(uid);
				}
			}

			if (userIdList.isEmpty()) {
				return "";
			}

			List<TeamsPresenceVO> result = ezTeamsDAO.getPresenceList(userIdList);

			StringBuilder xml = new StringBuilder();
			xml.append("<DATA>");
			for (TeamsPresenceVO row : result) {
				xml.append("<ROW>");
				xml.append("<CN>").append(row.getCn()).append("</CN>");
				xml.append("<PRESENCE>").append(row.getPresence()).append("</PRESENCE>");
				xml.append("<UPNNAME>").append(row.getUpnname()).append("</UPNNAME>");
				xml.append("<TEAMSID>").append(row.getTeamsid()).append("</TEAMSID>");
				xml.append("</ROW>");
			}
			xml.append("</DATA>");
			return xml.toString();

		} catch (Exception e) {
			logger.error("getPresenceList error", e);
			return "ERROR";
		}
	}

	@Override
	public void saveAuthToken(String apiType, String tokenType, String token) {
		try {
			int count = ezTeamsDAO.checkAuthToken(apiType, tokenType);

			Map<String, Object> paramMap = new HashMap<>();
			paramMap.put("APITYPE", apiType);
			paramMap.put("TOKENTYPE", tokenType);
			paramMap.put("TOKEN", token);

			if (count == 0) {
				ezTeamsDAO.insertAuthToken(paramMap);
			} else {
				ezTeamsDAO.updateAuthToken(paramMap);
			}
		} catch (Exception e) {
			logger.error("saveAuthToken error", e);
		}
	}
	
}
