package egovframework.ezEKP.ezCommon.dao;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

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
    
	public ApprovPWDVO getApprovPWD(LoginVO userInfo) throws Exception {
		return (ApprovPWDVO) select("EzCommonDAO.getApprovPWD", userInfo);
	}
	
	public String getContentInfo(Map<String, Object> map) throws Exception {
		return (String) select("EzCommonDAO.getContentInfo", map);
	}
	
    private String selectUserGetLangForLocal(String userID, int tenantID) throws Exception {
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	map.put("userID", userID);
    	map.put("tenantID", tenantID);
    	
        return (String) select("EzCommonDAO.selectUserGetLang", map);
    }
	
	public String selectUserGetLang(String userID, int tenantID) throws Exception {
		return selectUserGetLangForLocal(userID, tenantID);       
	}
	
    private String selectUserGetTimeZoneForLocal(String userID, int tenantID) throws Exception {
    	Map<String, Object> map = new HashMap<String, Object>();
    	
    	map.put("userID", userID);
    	map.put("tenantID", tenantID);
    	
        return (String) select("EzCommonDAO.selectUserGetTimeZone", map);
    }
	
	public String selectUserGetTimeZone(String userID, int tenantID) throws Exception {
		return selectUserGetTimeZoneForLocal(userID, tenantID);       
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
	    insertTblUserLocalInfoForJMocha(map);
	    
	    insertTblUserLocalInfoForLocal(map);               
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
	    deleteUserLocalInfoForJMocha(map);
	    
	    deleteUserLocalInfoForLocal(map);               
	}
	
    private int getTenantIdByDomainNameForLocal(Map<String, Object> map) throws Exception {
    	return (Integer) select("EzCommonDAO.getTenantIdByDomainName", map);
    }
	
	public int getTenantIdByDomainName(Map<String, Object> map) throws Exception {
		return getTenantIdByDomainNameForLocal(map);               
	}
		
	@SuppressWarnings("unchecked")
	private List<TenantServerNameVO> getTenantServerNameListForLocal() throws Exception{
		return (List<TenantServerNameVO>) list("EzCommonDAO.getTenantServerNameList");
    }
	
	public List<TenantServerNameVO> getTenantServerNameList() throws Exception {
		return getTenantServerNameListForLocal();               
	}
		
	@SuppressWarnings("unchecked")
	private List<TenantVO> getTenantListForLocal() throws Exception {
		return (List<TenantVO>) list("EzCommonDAO.getTenantList");
    }
	
	public List<TenantVO> getTenantList() throws Exception {
		return getTenantListForLocal();               
	}
	
	@SuppressWarnings("unchecked")
	private Map<String, Object> getTenantConfigsForLocal(int tenantID) throws Exception {
		return (Map<String, Object>) map("EzCommonDAO.getTenantConfigs", tenantID, "PROPERTY_NAME", "PROPERTY_VALUE");
    }
	
	public Map<String, Object> getTenantConfigs(int tenantID) throws Exception {
		return getTenantConfigsForLocal(tenantID);
	}
	
	public String getUserConfigInfo(Map<String, Object> map) throws Exception {
		return (String) select("EzCommonDAO.getUserConfig", map);
	}
	
	public int updateUserConfigInfo(Map<String, Object> map) throws Exception {
		return update("EzCommonDAO.updateUserConfigInfo", map);
	}
	
	public void insertUserConfigInfo(Map<String, Object> map) throws Exception {
		insert("EzCommonDAO.insertUserConfigInfo", map);
	}
	
	public void createTblCompanyConfig() throws Exception {
		try {
			select("EzCommonDAO.checkTblCompanyConfig");
		} catch (Exception e) {
			logger.debug("tbl_company_config doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblCompanyConfig");
		}
	}
	
	public String getCompanyConfig(Map<String, Object> map) throws Exception {
		return (String) select("EzCommonDAO.getCompanyConfig", map);
	}
	
	public void insertCompanyConfig(Map<String, Object> map) throws Exception {
		insert("EzCommonDAO.insertCompanyConfig", map);
	}
	
	public int updateCompanyConfig(Map<String, Object> map) throws Exception {
		return update("EzCommonDAO.updateCompanyConfig", map);
	}
	
	public int deleteCompanyConfig(Map<String, Object> map) throws Exception {
		return delete("EzCommonDAO.deleteCompanyConfig", map);
	}

	public void addMailToJMochaDistribution() throws Exception {
		try {
			select("EzCommonDAO.checkJMochaDistributionMail");
		} catch (Exception e) {
			logger.debug("jmocha_distribution mail column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addMailToJMochaDistribution");
		}
	}
	
	public void addAddJobMasterOrderBy() throws Exception {
		try {
			select("EzCommonDAO.checkAddJobMasterOrderBy");
		} catch (Exception e) {
			logger.debug("tbl_addjobmaster orderby column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addAddJobMasterOrderBy");
		}
	}
	
	public void createTblIPAccessID() throws Exception {
		try {
			select("EzCommonDAO.checkTblIPAccessID");
		} catch (Exception e) {
			logger.debug("tbl_access_id doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblIPAccessID");
		}
	}
	
	public void createTblIPAccessIP() throws Exception {
		try {
			select("EzCommonDAO.checkTblIPAccessIP");
		} catch (Exception e) {
			logger.debug("tbl_access_ip doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblIPAccessIP");
		}
	}
}
