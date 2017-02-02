package egovframework.ezEKP.ezCommon.dao;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezBoard.vo.BoardAttachVO;
import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCommonDAO")
public class EzCommonDAO extends EgovAbstractDAO{

    private static final Logger logger = LoggerFactory.getLogger(EzCommonDAO.class);
            
    @Autowired
    private Properties config;

    @Autowired
    private EzEmailUtil ezEmailUtil;
    
	public BoardAttachVO getAttachInfo(Map<String, Object> map) throws Exception{
		return (BoardAttachVO) select("EzCommonDAO.getAttachInfo", map);
	}
	
	public ApprovPWDVO getApprovPWD(LoginVO userInfo) throws Exception{
		return (ApprovPWDVO) select("EzCommonDAO.getApprovPWD", userInfo);
	}
	
	public String getContentInfo(Map<String, Object> map) throws Exception{
		return (String) select("EzCommonDAO.getContentInfo", map);
	}

    private String selectUserGetLangForJMocha(String userID, int tenantID) throws Exception {
        logger.debug("selectUserGetLangForJMocha started. tenantID=" + tenantID + ",userID=" + userID);
        
        String returnValue = null;
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "userId=" + URLEncoder.encode(userID, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserLang";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);
        
        String resultCode = "Error";
        int reasonCode = -100; 
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
                
                if (reasonCode == 0) {
                    JSONObject result = (JSONObject)responseObj.get("result");
                    
                    if (result != null) {
                        returnValue = (String)result.get("lang");
                    }                   
                }
            }
        }                       
        
        logger.debug("selectUserGetLangForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;
    }
	
    private String selectUserGetLangForLocal(String userID, int tenantID) throws Exception {
        return (String) select("EzCommonDAO.selectUserGetLang", userID);
    }
	
	public String selectUserGetLang(String userID, int tenantID) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return selectUserGetLangForJMocha(userID, tenantID);
        } else {
            return selectUserGetLangForLocal(userID, tenantID);
        }       
	}

    private String selectUserGetTimeZoneForJMocha(String userID, int tenantID) throws Exception{
        logger.debug("selectUserGetTimeZoneForJMocha started. tenantID=" + tenantID + ",userID=" + userID);
        
        String returnValue = null;
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "userId=" + URLEncoder.encode(userID, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserTimeZone";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);
        
        String resultCode = "Error";
        int reasonCode = -100; 
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
                
                if (reasonCode == 0) {
                    JSONObject result = (JSONObject)responseObj.get("result");
                    
                    if (result != null) {
                        returnValue = (String)result.get("timeZone");
                    }                   
                }
            }
        }                       
        
        logger.debug("selectUserGetTimeZoneForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;
    }
	
    private String selectUserGetTimeZoneForLocal(String userID, int tenantID) throws Exception{
        return (String) select("EzCommonDAO.selectUserGetTimeZone", userID);
    }
	
	public String selectUserGetTimeZone(String userID, int tenantID) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return selectUserGetTimeZoneForJMocha(userID, tenantID);
        } else {
            return selectUserGetTimeZoneForLocal(userID, tenantID);
        }       
	}
	
	public String getTenantConfig(Map<String, Object> map) throws Exception{
		return (String) select("EzCommonDAO.getTenantConfig", map);
	}

    private void insertTblUserLocalInfoForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String userId = (String)map.get("userID");
        String timeZone = (String)map.get("timeZone");
        String lang = (String)map.get("lang");
        
        logger.debug("insertTblUserLocalInfoForJMocha started. tenantId=" + tenantId + ",userId=" + userId
                + ",timeZone=" + timeZone + ",lang=" + lang);

        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "timeZone=" + URLEncoder.encode(timeZone, "UTF-8");
        String param4 = "lang=" + URLEncoder.encode(lang, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/addUserLocalInfo";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);

        String resultCode = "Error";
        int reasonCode = -100; // 웹서비스로부터 아무런 응답을 받지 못하거나 OK 응답이 오지 않은 경우를 의미
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
            }
        }                       
        
        logger.debug("insertTblUserLocalInfoForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Inserting User Local Info Failed!");
        }
    }
	
    private void insertTblUserLocalInfoForLocal(Map<String, Object> map) throws Exception {
        insert("EzCommonDAO.insertTblUserLocalInfo",map);
    }
	
	public void insertTblUserLocalInfo(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            insertTblUserLocalInfoForJMocha(map);
        } else {
            insertTblUserLocalInfoForLocal(map);
        }               
	}

    private void deleteUserLocalInfoForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String userId = (String)map.get("userID");
        
        logger.debug("deleteUserLocalInfoForJMocha started. tenantId=" + tenantId + ",userId=" + userId);

        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/deleteUserLocalInfo";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);

        String resultCode = "Error";
        int reasonCode = -100; // 웹서비스로부터 아무런 응답을 받지 못하거나 OK 응답이 오지 않은 경우를 의미
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
            }
        }                       
        
        logger.debug("deleteUserLocalInfoForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Deleting User Local Info Failed!");
        }
    }
	
    private void deleteUserLocalInfoForLocal(Map<String, Object> map) throws Exception {
        delete("EzCommonDAO.deleteUserLLocalInfo",map);
    }
	
	public void deleteUserLocalInfo(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            deleteUserLocalInfoForJMocha(map);
        } else {
            deleteUserLocalInfoForLocal(map);
        }               
	}

	private int getTenantIdByDomainNameForJMocha(Map<String, Object> map) throws Exception{
		String domainName = (String)map.get("DOMAIN_NAME");
		
        logger.debug("getTenantIdByDomainNameForJMocha started. domainName=" + domainName);
        
        int returnValue = -1;
        
        String inputParams = "domainName=" + URLEncoder.encode(domainName, "UTF-8");
        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getTenantIdByDomainName";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);
        
        String resultCode = "Error";
        int reasonCode = -100; 
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
                
                if (reasonCode == 0) {
                    returnValue = ((Long)responseObj.get("result")).intValue();
                }
            }
        }                       
        
        logger.debug("getTenantIdByDomainNameForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;
    }
	
    private int getTenantIdByDomainNameForLocal(Map<String, Object> map) throws Exception{
    	return (Integer) select("EzCommonDAO.getTenantIdByDomainName", map);
    }
	
	public int getTenantIdByDomainName(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getTenantIdByDomainNameForJMocha(map);
        } else {
            return getTenantIdByDomainNameForLocal(map);
        }               
	}
	
	private List<TenantServerNameVO> getTenantServerNameListForJMocha() throws Exception{
		logger.debug("getTenantServerNameListForJMocha started.");
        
		List<TenantServerNameVO> list = new ArrayList<TenantServerNameVO>();

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getTenantServerList";
        String response = ezEmailUtil.getWebServiceResult(requestURL, null);

        logger.debug("response=" + response);
        
        String resultCode = "Error";
        int reasonCode = -100; 
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
                
                if (reasonCode == 0) {
                    JSONArray resultArray = (JSONArray)responseObj.get("result");
                    
                    for (int i=0; i<resultArray.size(); i++) {
                		JSONObject obj = (JSONObject)resultArray.get(i);
                		
                		TenantServerNameVO vo = new TenantServerNameVO();
                		
                		vo.setTenantId(((Long)obj.get("tenantId")).intValue());
                		vo.setServerName((String)obj.get("serverName"));
                		
        				list.add(vo);
                	}
                }
            }
        }                       
        
        for(TenantServerNameVO vo : list) {
        	logger.debug("tenantId=" + vo.getTenantId() + ",serverName=" + vo.getServerName());
        }
        
        logger.debug("getTenantServerNameListForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return list;
    }
	
	@SuppressWarnings("unchecked")
	private List<TenantServerNameVO> getTenantServerNameListForLocal() throws Exception{
		return (List<TenantServerNameVO>) list("EzCommonDAO.getTenantServerNameList");
    }
	
	public List<TenantServerNameVO> getTenantServerNameList() throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getTenantServerNameListForJMocha();
        } else {
            return getTenantServerNameListForLocal();
        }               
	}
	
	private List<TenantVO> getTenantListForJMocha() throws Exception{
		logger.debug("getTenantList started.");
        
		List<TenantVO> list = new ArrayList<TenantVO>();

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getTenantList";
        String response = ezEmailUtil.getWebServiceResult(requestURL, null);

        logger.debug("response=" + response);
        
        String resultCode = "Error";
        int reasonCode = -100; 
                
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);

            resultCode = (String)responseObj.get("resultCode");     
            
            if (resultCode.equals("OK")) {
                reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
                
                if (reasonCode == 0) {
                    JSONArray resultArray = (JSONArray)responseObj.get("result");
                    
                    for (int i=0; i<resultArray.size(); i++) {
                		JSONObject obj = (JSONObject)resultArray.get(i);
                		
                		TenantVO vo = new TenantVO();
                		
                		vo.setTenantId(((Long)obj.get("tenantId")).intValue());
                		vo.setTenantName((String)obj.get("tenantName"));
                		
        				list.add(vo);
                	}
                }
            }
        }                       
        
        for(TenantVO vo : list) {
        	logger.debug("tenantId=" + vo.getTenantId() + ",tenantName=" + vo.getTenantName());
        }
        
        logger.debug("getTenantList ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return list;
    }
	
	@SuppressWarnings("unchecked")
	private List<TenantVO> getTenantListForLocal() throws Exception{
		return (List<TenantVO>) list("EzCommonDAO.getTenantList");
    }
	
	public List<TenantVO> getTenantList() throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getTenantListForJMocha();
        } else {
            return getTenantListForLocal();
        }               
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getTenantConfigs(int tenantID) throws Exception {
		return (Map<String, Object>) map("EzCommonDAO.getTenantConfigs", tenantID, "PROPERTY_NAME", "PROPERTY_VALUE");
	}
	
}
