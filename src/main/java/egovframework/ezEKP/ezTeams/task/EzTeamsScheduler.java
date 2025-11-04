package egovframework.ezEKP.ezTeams.task;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezTeams.dao.EzTeamsDAO;
import egovframework.ezEKP.ezTeams.service.EzTeamsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.utl.fcc.service.CommonUtil;
import org.springframework.web.client.RestTemplate;

@Component
public class EzTeamsScheduler extends EzFileMngUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzTeamsScheduler.class);

	@Autowired
	private CommonUtil commonUtil;

	@Resource(name = "loginService")
    private LoginService loginService;
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Resource(name = "EzTeamsDAO")
	private EzTeamsDAO ezTeamsDAO;

	@Resource(name="EzTeamsService")
	private EzTeamsService ezTeamsService;

	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;

	@Scheduled(cron = "${config.cron.getTeamsIdFromGraphApi}")
	public void getTeamsIdFromGraphApi() throws Exception {

        String useTeams = ezCommonService.getTenantConfig("useTeams", 0);
        if (useTeams == null || !useTeams.equalsIgnoreCase("YES")) {
            return;
        }

        logger.debug("getTeamsIdFromGraphApi started.");

		try {
			String accessToken = ezTeamsService.getToken("publicapp");
			
			HttpHeaders headers = new HttpHeaders();
			headers.setBearerAuth(accessToken);
			headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
			HttpEntity<String> entity = new HttpEntity<>(headers);
			
			RestTemplate restTemplate = new RestTemplate();
			List<Map<String, Object>> allUsers = new ArrayList<>();
			String url = "https://graph.microsoft.com/v1.0/users";
			
			while (url != null) {
				ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
				Map<String, Object> body = response.getBody();

				if (body != null && body.get("value") instanceof List) {
					List<Map<String, Object>> users = (List<Map<String, Object>>) body.get("value");
					allUsers.addAll(users);
				}
				url = (body != null && body.containsKey("@odata.nextLink")) ? (String) body.get("@odata.nextLink") : null;
			}
			
			List<String> upnNameList = ezOrganDAO.getUpnNames();
			if (upnNameList == null) {
				upnNameList = new ArrayList<>();
			}

			int count = 0;
			for (Map<String, Object> user : allUsers) {
				String upn = (String) user.get("userPrincipalName");
				String id = (String) user.get("id");

				if (upn != null && id != null  && upnNameList.contains(upn)) {
					Map<String, Object> param = new HashMap<>();
					param.put("v_UPNNAME", upn);
					param.put("v_TEAMSID", id);

					int result = ezOrganDAO.updateTeamsIdByUpnName(param);
					if (result > 0) {
						count ++;
					}
				}
			}
			logger.debug("TeamsId updated: {}", count);
		} catch (Exception e) {
			logger.error("Error occurred during getTeamsIdFromGraphApi", e);
		}
		logger.debug("getTeamsIdFromGraphApi ended.");
	}


	// Microsoft Graph API를 통해 사용자 presence 정보 가져와 DB에 저장
	@Scheduled(cron = "${config.cron.getPresenceFromGraphApi}")
	public void getPresenceFromGraphApi() throws Exception {

        String useTeams = ezCommonService.getTenantConfig("useTeams", 0);
        if (useTeams == null || !useTeams.equalsIgnoreCase("YES")) {
            return;
        }

        logger.debug("getPresenceFromGraphApi started.");

        List<String> userList = ezTeamsDAO.getTeamsIdList();
        if (userList == null || userList.isEmpty()) {
            return;
        }

        String accessToken = ezTeamsService.getToken("publicapp");

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        for (int i = 0; i < userList.size(); i += 100) {
            List<String> batch = userList.subList(i, Math.min(i + 100, userList.size()));
            List<String> ids = new ArrayList<>(batch);

            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("ids", ids);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            String url = "https://graph.microsoft.com/v1.0/communications/getPresencesByUserId";

            try {
                ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);
                List<Map<String, Object>> presenceList = (List<Map<String, Object>>) response.getBody().get("value");

                for (Map<String, Object> presence : presenceList) {
                    String id = (String) presence.get("id");
                    String availability = (String) presence.get("availability");

                    if (batch.contains(id) && availability != null) {
                        Map<String, Object> param = new HashMap<>();
                        param.put("id", id);
                        param.put("presence", availability);
                        param.put("updateTime", commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"));
                        int updated = ezTeamsDAO.updatePresenceStatus(param);
                        if (updated == 0) {
                            ezTeamsDAO.insertPresenceStatus(param);
                        }
                    }
                }
            } catch (Exception e) {
                logger.warn("getPresenceFromGraphApi failed: {}", e.getMessage());
            }
        }

		logger.debug("getPresenceFromGraphApi ended.");
	}

	@Scheduled(cron = "${config.cron.setAdminAuthToken}")
	public void setAdminAuthToken() throws Exception {

        String useTeams = ezCommonService.getTenantConfig("useTeams", 0);
        if (useTeams == null || !useTeams.equalsIgnoreCase("YES")) {
            return;
        }

        logger.debug("setAdminAuthToken started.");

		int tenantId = 0;

        String teamsTenantId = ezCommonService.getTenantConfig("teamsTenantId", tenantId);
        String teamsClientId = ezCommonService.getTenantConfig("teamsClientId", tenantId);
        String teamsClientSecret = ezCommonService.getTenantConfig("teamsClientSecret", tenantId);
        String adminAccount = ezCommonService.getTenantConfig("m365AdminAccount", tenantId);
        String adminPassword = ezCommonService.getTenantConfig("m365AdminAccountPw", tenantId);

        /*
        try {
            String delegatedToken = ezTeamsService.getDelegatedToken(teamsClientId, teamsTenantId, adminAccount, adminPassword);
            ezTeamsService.saveAuthToken("GRAPH", "delegated", delegatedToken);
        } catch (Exception e) {
            logger.warn("DelegatedToken failure: {}", e.toString());
        }
         */
        try {
            String publicappToken = ezTeamsService.getPublicAppToken(teamsTenantId, teamsClientId, teamsClientSecret);
            ezTeamsService.saveAuthToken("GRAPH", "publicapp", publicappToken);
        } catch (Exception e) {
            logger.warn("PublicAppToken failure: {}", e.toString());
        }

		logger.debug("setAdminAuthToken ended.");
	}
	
}
