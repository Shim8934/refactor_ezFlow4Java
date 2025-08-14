package egovframework.ezEKP.ezTeams.service;

public interface EzTeamsService {
    
    public String getGraphApiToken(int tenantId) throws Exception;

    public String getDelegatedToken(String clientId, String tenantId, String username, String password) throws Exception;
    
    public String getPresenceList(String requestXml) throws Exception;

    public String getPublicAppToken(String tenant, String appId, String appSecret) throws Exception;

    public String getToken(String tokenType) throws Exception;
    
    public void saveAuthToken(String apiType, String tokenType, String token) throws Exception;
    
}
