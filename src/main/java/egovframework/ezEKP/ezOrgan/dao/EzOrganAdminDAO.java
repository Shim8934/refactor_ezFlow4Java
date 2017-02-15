package egovframework.ezEKP.ezOrgan.dao;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzOrganAdminDAO")
public class EzOrganAdminDAO extends EgovAbstractDAO {

    private static final Logger logger = LoggerFactory.getLogger(EzOrganAdminDAO.class);
            
    @Autowired
    private Properties config;

    @Autowired
    private EzEmailUtil ezEmailUtil;
    
    private List<OrganDeptVO> getCompanyListForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("tenantID");
        String isPrimary = (String)map.get("lang");
        
        logger.debug("getCompanyListForJMocha started. tenantId=" + tenantId + ",isPrimary=" + isPrimary);
        
        List<OrganDeptVO> returnValue = new ArrayList<OrganDeptVO>();
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "isPrimary=" + isPrimary;
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getCompanyList";
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
                    JSONArray result = (JSONArray)responseObj.get("result");
                    
                    if (result != null) {
                        for (int i = 0; i < result.size(); i++) {
                            JSONObject itemObj = (JSONObject)result.get(i);
                            OrganDeptVO deptVO = new OrganDeptVO();
                            
                            deptVO.setCn((String)itemObj.get("companyId"));
                            deptVO.setDisplayName((String)itemObj.get("displayname"));
                            deptVO.setDisplayName2((String)itemObj.get("displayname2"));
                            
                            returnValue.add(deptVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("getCompanyListForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;               
    }
    
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getCompanyListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganDeptVO>) list("EzOrganAdminDAO.getCompanyList", map);
    }
    
	public List<OrganDeptVO> getCompanyList(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getCompanyListForJMocha(map);
        } else {
            return getCompanyListForLocal(map);
        }       
	}

    private List<OrganUserVO> getAddJobListForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");
        String companyId = (String)map.get("v_COMPANYID");
        String isPrimary = (String)map.get("v_LANGDATA");
        
        logger.debug("getAddJobListForJMocha started. tenantId=" + tenantId + ",companyId=" + companyId + ",isPrimary=" + isPrimary);
        
        List<OrganUserVO> returnValue = new ArrayList<OrganUserVO>();
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "companyId=" + companyId;
        String param3 = "isPrimary=" + isPrimary;
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getAddJobList";
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
                    JSONArray result = (JSONArray)responseObj.get("result");
                    
                    if (result != null) {
                        for (int i = 0; i < result.size(); i++) {
                            JSONObject itemObj = (JSONObject)result.get(i);
                            OrganUserVO userVO = new OrganUserVO();
                            
                            userVO.setCn((String)itemObj.get("userId"));
                            userVO.setDisplayName((String)itemObj.get("displayname"));
                            userVO.setDescription(((String)itemObj.get("description")));
                            userVO.setTitle((String)itemObj.get("title"));
                            userVO.setMail((String)itemObj.get("mail"));
                            userVO.setTelephoneNumber((String)itemObj.get("telephoneNumber"));
                            userVO.setCompany((String)itemObj.get("company"));
                            userVO.setExtensionAttribute4((String)itemObj.get("extensionAttribute4"));
                            
                            returnValue.add(userVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("getAddJobListForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;                       
    }
	
    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getAddJobListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.getAddJobList", map);
    }
	
	public List<OrganUserVO> getAddJobList(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getAddJobListForJMocha(map);
        } else {
            return getAddJobListForLocal(map);
        }       
	}

    private List<OrganUserVO> getUserAddJobListForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");
        String userId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        
        logger.debug("getUserAddJobListForJMocha started. tenantId=" + tenantId + ",userId=" + userId + ",isPrimary=" + isPrimary);
        
        List<OrganUserVO> returnValue = new ArrayList<OrganUserVO>();
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + userId;
        String param3 = "isPrimary=" + isPrimary;
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserAddJobList";
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
                    JSONArray result = (JSONArray)responseObj.get("result");
                    
                    if (result != null) {
                        for (int i = 0; i < result.size(); i++) {
                            JSONObject itemObj = (JSONObject)result.get(i);
                            OrganUserVO userVO = new OrganUserVO();
                            
                            userVO.setCn((String)itemObj.get("userId"));
                            userVO.setDepartment((String)itemObj.get("deptId"));
                            userVO.setTitle((String)itemObj.get("title"));
                            userVO.setDisplayName((String)itemObj.get("displayName"));
                            userVO.setDescription((String)itemObj.get("deptName"));
                            userVO.setCompany((String)itemObj.get("companyName"));
                            userVO.setTitle1((String)itemObj.get("title1"));
                            userVO.setTitle2((String)itemObj.get("title2"));
                            
                            returnValue.add(userVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("getUserAddJobListForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;                               
    }
	
    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getUserAddJobListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.getUserAddJobList", map);
    }
	
	public List<OrganUserVO> getUserAddJobList(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getUserAddJobListForJMocha(map);
        } else {
            return getUserAddJobListForLocal(map);
        }       
	}
	
    private List<OrganUserVO> getPermissionListForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");
        String companyId = (String)map.get("v_COMPANYID");
        String type = (String)map.get("v_TYPE");
        String isPrimary = (String)map.get("v_LANGDATA");
        int startRow = (int)map.get("v_PSTARTROW");
        int endRow = (int)map.get("v_PENDROW");
        
        logger.debug("getPermissionListForJMocha started. tenantId=" + tenantId + ",companyId=" + companyId 
                + ",type=" + type + ",isPrimary=" + isPrimary + ",startRow=" + startRow
                + ",endRow=" + endRow);
        
        List<OrganUserVO> returnValue = new ArrayList<OrganUserVO>();
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "companyId=" + companyId;
        String param3 = "type=" + type;
        String param4 = "isPrimary=" + isPrimary;
        String param5 = "startRow=" + startRow;
        String param6 = "endRow=" + endRow;
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5 + "&" + param6;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getPermissionList";
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
                    JSONArray result = (JSONArray)responseObj.get("result");
                    
                    if (result != null) {
                        for (int i = 0; i < result.size(); i++) {
                            JSONObject itemObj = (JSONObject)result.get(i);
                            OrganUserVO userVO = new OrganUserVO();
                            
                            userVO.setCn((String)itemObj.get("userId"));
                            userVO.setDisplayName((String)itemObj.get("displayname"));
                            userVO.setDescription(((String)itemObj.get("description")));
                            userVO.setTitle((String)itemObj.get("title"));
                            userVO.setMail((String)itemObj.get("mail"));
                            userVO.setTelephoneNumber((String)itemObj.get("telephoneNumber"));
                            userVO.setCompany((String)itemObj.get("company"));
                            userVO.setExtensionAttribute1((String)itemObj.get("extensionAttribute1"));
                            
                            returnValue.add(userVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("getPermissionListForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;               
    }
	
    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getPermissionListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.getPermissionList", map);
    }
	
	public List<OrganUserVO> getPermissionList(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getPermissionListForJMocha(map);
        } else {
            return getPermissionListForLocal(map);
        }       
	}

    private List<OrganUserVO> getRetireListForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");
        int page = (Integer)map.get("v_PAGE");
        int rowPerPage = (Integer)map.get("v_ROWPERPAGE");
        
        logger.debug("getRetireListForJMocha started. tenantId=" + tenantId + ",page=" + page 
                + ",rowPerPage=" + rowPerPage);
        
        List<OrganUserVO> returnValue = new ArrayList<OrganUserVO>();
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "page=" + page;
        String param3 = "rowPerPage=" + rowPerPage;
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getRetiredUserList";
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
                    JSONArray result = (JSONArray)responseObj.get("result");
                    
                    if (result != null) {
                        for (int i = 0; i < result.size(); i++) {
                            JSONObject itemObj = (JSONObject)result.get(i);
                            OrganUserVO userVO = new OrganUserVO();
                            
                            userVO.setCn((String)itemObj.get("userId"));
                            userVO.setDisplayName((String)itemObj.get("displayName"));
                            userVO.setDisplayName2((String)itemObj.get("displayName2"));
                            userVO.setDescription((String)itemObj.get("deptName"));  
                            userVO.setDescription2((String)itemObj.get("deptName2"));
                            userVO.setTitle((String)itemObj.get("title"));
                            userVO.setTitle2((String)itemObj.get("title2"));  
                            userVO.setExtensionAttribute10((String)itemObj.get("role"));
                            userVO.setExtensionAttribute102((String)itemObj.get("role2")); 
                            userVO.setExtensionAttribute14((String)itemObj.get("empCode"));
                            userVO.setUpdateDT((String)itemObj.get("updateDt"));
                            
                            returnValue.add(userVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("getRetireListForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;               
    }
	
    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getRetireListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.getRetireList", map);
    }
	
	public List<OrganUserVO> getRetireList(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getRetireListForJMocha(map);
        } else {
            return getRetireListForLocal(map);
        }       
	}

    private List<OrganUserVO> getUserCnListForJMocha(int tenantID) throws Exception {
        logger.debug("getUserCnListForJMocha started. tenantID=" + tenantID);
        
        List<OrganUserVO> returnValue = new ArrayList<OrganUserVO>();
        
        String param1 = "tenantId=" + tenantID;
        String inputParams = param1;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserIdList";
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
                    JSONArray result = (JSONArray)responseObj.get("result");
                    
                    if (result != null) {
                        for (int i = 0; i < result.size(); i++) {
                            JSONObject itemObj = (JSONObject)result.get(i);
                            OrganUserVO userVO = new OrganUserVO();
                            
                            userVO.setCn((String)itemObj.get("userId"));
                            
                            returnValue.add(userVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("getUserCnListForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;                       
    }
    
    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getUserCnListForLocal(int tenantID) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.userCnList");
    }
    
    public List<OrganUserVO> getUserCnList(int tenantID) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getUserCnListForJMocha(tenantID);
        } else {
            return getUserCnListForLocal(tenantID);
        }       
    }	

    private OrganUserVO getUserInfoForJMocha(Map<String, Object> map) throws Exception {
        String userId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("EzOrganAdminDAO.getUserInfoForJMocha started. tenantId=" + tenantId + ",userId=" + userId + ",isPrimary=" + isPrimary);
        
        OrganUserVO userVO = null;
                
        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "isPrimary=" + URLEncoder.encode(isPrimary, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserInfo";
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
                        userVO = new OrganUserVO();
                                
                        userVO.setCn((String)result.get("userId"));                        
                        userVO.setDisplayName((String)result.get("displayname"));
                        userVO.setDisplayName1((String)result.get("displayname1"));
                        userVO.setDisplayName2((String)result.get("displayname2"));
                        userVO.setMail((String)result.get("mail"));
                        userVO.setMailNickName((String)result.get("mailNickname"));
                        userVO.setUpnName((String)result.get("upnname"));
                        userVO.setDepartment((String)result.get("deptId"));
                        userVO.setDescription((String)result.get("description"));
                        userVO.setDescription1((String)result.get("description1"));
                        userVO.setDescription2((String)result.get("description2"));
                        userVO.setPhysicalDeliveryOfficeName((String)result.get("physicalDeliveryOfficename"));
                        userVO.setCompany((String)result.get("company"));
                        userVO.setCompany1((String)result.get("company1"));
                        userVO.setCompany2((String)result.get("company2"));
                        userVO.setTitle((String)result.get("title"));
                        userVO.setTitle1((String)result.get("title1"));
                        userVO.setTitle2((String)result.get("title2"));                  
                        userVO.setTelephoneNumber((String)result.get("telephoneNumber"));
                        userVO.setHomePhone((String)result.get("homePhone"));
                        userVO.setMobile((String)result.get("mobile"));
                        userVO.setFacsimileTelephoneNumber((String)result.get("facsimileTelephoneNumber"));
                        userVO.setStreetAddress((String)result.get("streetAddress"));
                        userVO.setPostalCode((String)result.get("postalCode"));
                        userVO.setInfo((String)result.get("info"));                        
                        userVO.setExtensionAttribute1((String)result.get("extensionattribute1"));
                        userVO.setExtensionAttribute2((String)result.get("extensionattribute2"));
                        userVO.setExtensionAttribute3((String)result.get("extensionattribute3"));
                        userVO.setExtensionAttribute4((String)result.get("extensionattribute4"));
                        userVO.setExtensionAttribute5((String)result.get("extensionattribute5"));
                        userVO.setExtensionAttribute6((String)result.get("extensionattribute6"));
                        userVO.setExtensionAttribute7((String)result.get("extensionattribute7"));
                        userVO.setExtensionAttribute8((String)result.get("extensionattribute8"));
                        userVO.setExtensionAttribute9((String)result.get("extensionattribute9"));
                        userVO.setExtensionAttribute10((String)result.get("extensionattribute10"));
                        userVO.setExtensionAttribute101((String)result.get("extensionattribute101"));
                        userVO.setExtensionAttribute102((String)result.get("extensionattribute102"));
                        userVO.setExtensionAttribute11((String)result.get("extensionattribute11"));
                        userVO.setExtensionAttribute12((String)result.get("extensionattribute12"));
                        userVO.setExtensionAttribute13((String)result.get("extensionattribute13"));
                        userVO.setExtensionAttribute14((String)result.get("extensionattribute14"));
                        userVO.setExtensionAttribute15((String)result.get("extensionattribute15"));
                        userVO.setAdsPath((String)result.get("adsPath"));                        
                        userVO.setUpdateDT((String)result.get("updatedt"));
                        userVO.setType((String)result.get("type"));
                        userVO.setDisplayNamePrintable((String)result.get("displaynamePrintable"));
                        userVO.setPositionCD((String)result.get("positionCD"));
                        userVO.setBirth((String)result.get("birth"));
                        userVO.setBirthType((String)result.get("birthType"));
                    }                   
                }
            }
        }                       
        
        logger.debug("EzOrganAdminDAO.getUserInfoForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return userVO;        
    }
	
    private OrganUserVO getUserInfoForLocal(Map<String, Object> map) throws Exception {
        return (OrganUserVO) select("EzOrganAdminDAO.getUserInfo", map);
    }
	
	public OrganUserVO getUserInfo(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getUserInfoForJMocha(map);
        } else {
            return getUserInfoForLocal(map);
        }       
	}
	
    private OrganUserVO getRetireEntryInfoForJMocha(Map<String, Object> map) throws Exception {
        String userId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("EzOrganAdminDAO.getRetireEntryInfoForJMocha started. tenantId=" + tenantId + ",userId=" + userId + ",isPrimary=" + isPrimary);
        
        OrganUserVO userVO = null;
                
        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "isPrimary=" + URLEncoder.encode(isPrimary, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getRetiredUserInfo";
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
                        userVO = new OrganUserVO();
                                
                        userVO.setCn((String)result.get("userId"));                        
                        userVO.setDisplayName((String)result.get("displayname"));
                        userVO.setDisplayName1((String)result.get("displayname1"));
                        userVO.setDisplayName2((String)result.get("displayname2"));
                        userVO.setMail((String)result.get("mail"));
                        userVO.setMailNickName((String)result.get("mailNickname"));
                        userVO.setUpnName((String)result.get("upnname"));
                        userVO.setDepartment((String)result.get("deptId"));
                        userVO.setDescription((String)result.get("description"));
                        userVO.setDescription1((String)result.get("description1"));
                        userVO.setDescription2((String)result.get("description2"));
                        userVO.setPhysicalDeliveryOfficeName((String)result.get("physicalDeliveryOfficename"));
                        userVO.setCompany((String)result.get("company"));
                        userVO.setCompany1((String)result.get("company1"));
                        userVO.setCompany2((String)result.get("company2"));
                        userVO.setTitle((String)result.get("title"));
                        userVO.setTitle1((String)result.get("title1"));
                        userVO.setTitle2((String)result.get("title2"));                  
                        userVO.setTelephoneNumber((String)result.get("telephoneNumber"));
                        userVO.setHomePhone((String)result.get("homePhone"));
                        userVO.setMobile((String)result.get("mobile"));
                        userVO.setFacsimileTelephoneNumber((String)result.get("facsimileTelephoneNumber"));
                        userVO.setStreetAddress((String)result.get("streetAddress"));
                        userVO.setPostalCode((String)result.get("postalCode"));
                        userVO.setInfo((String)result.get("info"));                        
                        userVO.setExtensionAttribute1((String)result.get("extensionattribute1"));
                        userVO.setExtensionAttribute2((String)result.get("extensionattribute2"));
                        userVO.setExtensionAttribute3((String)result.get("extensionattribute3"));
                        userVO.setExtensionAttribute4((String)result.get("extensionattribute4"));
                        userVO.setExtensionAttribute5((String)result.get("extensionattribute5"));
                        userVO.setExtensionAttribute6((String)result.get("extensionattribute6"));
                        userVO.setExtensionAttribute7((String)result.get("extensionattribute7"));
                        userVO.setExtensionAttribute8((String)result.get("extensionattribute8"));
                        userVO.setExtensionAttribute9((String)result.get("extensionattribute9"));
                        userVO.setExtensionAttribute10((String)result.get("extensionattribute10"));
                        userVO.setExtensionAttribute101((String)result.get("extensionattribute101"));
                        userVO.setExtensionAttribute102((String)result.get("extensionattribute102"));
                        userVO.setExtensionAttribute11((String)result.get("extensionattribute11"));
                        userVO.setExtensionAttribute12((String)result.get("extensionattribute12"));
                        userVO.setExtensionAttribute13((String)result.get("extensionattribute13"));
                        userVO.setExtensionAttribute14((String)result.get("extensionattribute14"));
                        userVO.setExtensionAttribute15((String)result.get("extensionattribute15"));
                        userVO.setAdsPath((String)result.get("adsPath"));                        
                        userVO.setUpdateDT((String)result.get("updatedt"));
                        userVO.setType((String)result.get("type"));
                        userVO.setDisplayNamePrintable((String)result.get("displaynamePrintable"));
                        userVO.setPositionCD((String)result.get("positionCD"));
                        userVO.setBirth((String)result.get("birth"));
                        userVO.setBirthType((String)result.get("birthType"));
                    }                   
                }
            }
        }                       
        
        logger.debug("EzOrganAdminDAO.getRetireEntryInfoForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return userVO;                
    }
	
    private OrganUserVO getRetireEntryInfoForLocal(Map<String, Object> map) throws Exception {
        return (OrganUserVO) select("EzOrganAdminDAO.getRetireEntryInfo", map);
    }
	
	public OrganUserVO getRetireEntryInfo(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getRetireEntryInfoForJMocha(map);
        } else {
            return getRetireEntryInfoForLocal(map);
        }       
	}

	public int companyCheck(Map<String, Object> map) throws Exception{		
		return (int) select("EzOrganAdminDAO.companyCheck", map);
	}

    private int companyChildCheckForJMocha(String cn, int tenantID) throws Exception {
        logger.debug("companyChildCheckForJMocha started. tenantID=" + tenantID + ",cn=" + cn);
        
        int returnValue = 0;
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "deptId=" + URLEncoder.encode(cn, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getDeptSubDeptCnt";
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
                        returnValue = ((Long)result.get("count")).intValue();
                    }                   
                }
            }
        }                       
                
        logger.debug("companyChildCheckForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;        
    }
	
    private int companyChildCheckForLocal(Map<String, Object> map) throws Exception {
        String cn = (String)map.get("cn");
        int tenantID = (Integer)map.get("tenantID");
        
        logger.debug("companyChildCheckForLocal started. cn=" + cn + ",tenantID=" + tenantID);
        
        int childCheck = (int) select("EzOrganAdminDAO.companyChildCheck", map);
        
        logger.debug("companyChildCheckForLocal started. childCheck=" + childCheck);
                
        return childCheck;
    }
	
    // 지정된 부서 바로 아래에 위치한 자식 부서의 수를 반환한다.
	public int companyChildCheck(String cn, int tenantID) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return companyChildCheckForJMocha(cn, tenantID);
        } else {
        	Map<String,Object> map = new HashMap<String, Object>();
        	map.put("cn", cn);
        	map.put("tenantID", tenantID);
            return companyChildCheckForLocal(map);
        }       
	}

    private int userCheckForJMocha(String cn, int tenantID) throws Exception{
        logger.debug("userCheckForJMocha started. cn=" + cn + ",tenantID=" + tenantID);
        
        int returnValue = 0;
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "userId=" + URLEncoder.encode(cn, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/checkUserExists";
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
                        returnValue = ((Long)result.get("userCount")).intValue();
                    }                   
                }
            }
        }                       
                
        logger.debug("userCheckForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;             
    }
	
    private int userCheckForLocal(Map<String, Object> map) throws Exception {
        String cn = (String)map.get("cn");
        int tenantID = (Integer)map.get("tenantID");
        
        logger.debug("userCheckForLocal started. cn=" + cn + ",tenantID=" + tenantID);
        
        int check = (int) select("EzOrganAdminDAO.userCheck", map);
        
        logger.debug("userCheckForLocal started. check=" + check);
                
        return check;
    }
	
	public int userCheck(String cn, int tenantID) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return userCheckForJMocha(cn, tenantID);
        } else {
        	Map<String, Object> map = new HashMap<String, Object>();
        	
        	map.put("cn", cn);
        	map.put("tenantID", tenantID);
        	
            return userCheckForLocal(map);
        }       
	}
	
    private int getPermissionListCountForJMocha(Map<String, Object> map) throws Exception {
        String companyId = (String)map.get("v_COMPANYID");
        String type = (String)map.get("v_TYPE");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getPermissionListCountForJMocha started. companyId=" + companyId 
                + ",type=" + type + ",tenantId=" + tenantId);
        
        int returnValue = 0;
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
        String param3 = "type=" + URLEncoder.encode(type, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getPermissionListCount";
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
                        returnValue = ((Long)result.get("count")).intValue();
                    }                   
                }
            }
        }                       
                
        logger.debug("getPermissionListCountForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;                     
    }
	
    private int getPermissionListCountForLocal(Map<String, Object> map) throws Exception {
        return (int) select("EzOrganAdminDAO.getPermissionListCount", map);
    }
	
	public int getPermissionListCount(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getPermissionListCountForJMocha(map);
        } else {
            return getPermissionListCountForLocal(map);
        }       
	}

    private int getRetireListCountForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getRetireListCountForJMocha started. tenantId=" + tenantId);
        
        int returnValue = 0;
        
        String param1 = "tenantId=" + tenantId;
        String inputParams = param1;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getRetiredUserCount";
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
                        returnValue = ((Long)result.get("count")).intValue();
                    }                   
                }
            }
        }                       
                
        logger.debug("getRetireListCountForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;        
    }
	
    private int getRetireListCountForLocal(Map<String, Object> map) throws Exception {
        return (int)select("EzOrganAdminDAO.getRetireListCount", map);
    }
	
	public int getRetireListCount(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getRetireListCountForJMocha(map);
        } else {
            return getRetireListCountForLocal(map);
        }       	    
	}

    private void insertDBData_companyForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String companyId = (String)map.get("v_CN");
        String displayName = (String)map.get("v_DISPLAYNAME");
        String displayName2 = (String)map.get("v_DISPLAYNAME2");
        String mail = (String)map.get("v_MAIL");
        String parentCn = (String)map.get("v_PARENTCN");
        String ldapPath = (String)map.get("v_LDAPPATH");
        
        logger.debug("insertDBData_companyForJMocha started. tenantId=" + tenantId + ",companyId=" + companyId + ",parentCn=" + parentCn);

        String param1 = "tenantId=" + tenantId;
        String param2 = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
        String param3 = "displayName=" + URLEncoder.encode(displayName, "UTF-8");
        String param4 = "displayName2=" + URLEncoder.encode(displayName2, "UTF-8");
        String param5 = "mail=" + URLEncoder.encode(mail, "UTF-8");
        String param6 = "parentCn=" + URLEncoder.encode(parentCn, "UTF-8");
        String param7 = "ldapPath=" + URLEncoder.encode(ldapPath, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5 + "&" + param6
                    + "&" + param7;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/addCompany";
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
        
        logger.debug("insertDBData_companyForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Adding Company Failed!");
        }
    }
	
    private void insertDBData_companyForLocal(Map<String, Object> map) throws Exception {
    	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	date.setTimeZone(TimeZone.getTimeZone("GMT"));
    	String nowDate = date.format(new Date());
    	map.put("nowDate", nowDate);
        insert("EzOrganAdminDAO.insertDBData_company", map);
    }
	
	public void insertDBData_company(Map<String, Object> map) throws Exception {        
        insertDBData_companyForJMocha(map);

        if (config.getProperty("config.IsJMochaStandAlone").equals("NO")) {
            try {
                insertDBData_companyForLocal(map);
            // 로컬 등록이 실패하면 JMocha User Repository에 등록한 것을 삭제한다.
            } catch (Exception e) {
                e.printStackTrace();
                
                map.put("v_CLASS", "group");
                deleteDBDataForJMocha(map);
                
                throw e;
            }
        }
	}

    private void insertDBData_deptForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String deptId = (String)map.get("v_CN");
        String displayName = (String)map.get("v_DISPLAYNAME");
        String displayName2 = (String)map.get("v_DISPLAYNAME2");
        String mail = (String)map.get("v_MAIL");
        String parentCn = (String)map.get("v_PARENTCN");
        String extensionAttribute4 = (String)map.get("v_EXTATTR4");
        String extensionAttribute5 = (String)map.get("v_EXTATTR5");
        String extensionAttribute6 = (String)map.get("v_EXTATTR6");
        String extensionAttribute8 = (String)map.get("v_EXTATTR8");
        String extensionAttribute9 = (String)map.get("v_EXTATTR9");
        String extensionAttribute10 = (String)map.get("v_EXTATTR10");
        String extensionAttribute15 = (String)map.get("v_EXTATTR15");
        String ldapPath = (String)map.get("v_LDAPPATH");
        
        logger.debug("insertDBData_deptForJMocha started. tenantId=" + tenantId + ",deptId=" + deptId + ",parentCn=" + parentCn);

        String param1 = "tenantId=" + tenantId;
        String param2 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String param3 = "displayName=" + URLEncoder.encode(displayName, "UTF-8");
        String param4 = "displayName2=" + URLEncoder.encode(displayName2, "UTF-8");
        String param5 = "mail=" + URLEncoder.encode(mail, "UTF-8");
        String param6 = "parentCn=" + URLEncoder.encode(parentCn, "UTF-8");
        String param7 = "extensionAttribute4=" + URLEncoder.encode(extensionAttribute4, "UTF-8");
        String param8 = "extensionAttribute5=" + URLEncoder.encode(extensionAttribute5, "UTF-8");
        String param9 = "extensionAttribute6=" + URLEncoder.encode(extensionAttribute6, "UTF-8");
        String param10 = "extensionAttribute8=" + URLEncoder.encode(extensionAttribute8, "UTF-8");
        String param11 = "extensionAttribute9=" + URLEncoder.encode(extensionAttribute9, "UTF-8");
        String param12 = "extensionAttribute10=" + URLEncoder.encode(extensionAttribute10, "UTF-8");
        String param13 = "extensionAttribute15=" + URLEncoder.encode(extensionAttribute15, "UTF-8");        
        String param14 = "ldapPath=" + URLEncoder.encode(ldapPath, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5 + "&" + param6
                    + "&" + param7 + "&" + param8 + "&" + param9 + "&" + param10 + "&" + param11 + "&" + param12
                    + "&" + param13 + "&" + param14;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/addDept";
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
        
        logger.debug("insertDBData_deptForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Adding Department Failed!");
        }
    }
	
    private void insertDBData_deptForLocal(Map<String, Object> map) throws Exception {
    	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	date.setTimeZone(TimeZone.getTimeZone("GMT"));
    	String nowDate = date.format(new Date());
    	map.put("nowDate", nowDate);
    	
        insert("EzOrganAdminDAO.insertDBData_dept", map);
    }
	
	public void insertDBData_dept(Map<String, Object> map) throws Exception {
	    insertDBData_deptForJMocha(map);

	    if (config.getProperty("config.IsJMochaStandAlone").equals("NO")) {	   
	        try {
	            insertDBData_deptForLocal(map);
	        // 로컬 등록이 실패하면 JMocha User Repository에 등록한 것을 삭제한다.
	        } catch (Exception e) {
                e.printStackTrace();
                
                map.put("v_CLASS", "group");
                deleteDBDataForJMocha(map);
                
                throw e;	            
	        }
	    }
	}

    private void insertDBData_userForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String userId = (String)map.get("v_CN");
        String displayName = (String)map.get("v_DISPLAYNAME");
        String displayName2 = (String)map.get("v_DISPLAYNAME2");
        String mail = (String)map.get("v_MAIL");
        String mailNickName = (String)map.get("v_MAILNICKNAME");
        String upnName = (String)map.get("v_UPNNAME");
        String parentCn = (String)map.get("v_PARENTCN");
        String title = (String)map.get("v_TITLE");
        String title2 = (String)map.get("v_TITLE2");
        String telephoneNumber = (String)map.get("v_TELEPHONE");
        String homePhone = (String)map.get("v_HOMEPHONE");
        String facsimileTelephoneNumber = (String)map.get("v_FAX");
        String mobile = (String)map.get("v_MOBILE");
        String postalCode = (String)map.get("v_POSTALCODE");
        String streetAddress = (String)map.get("v_ADDRESS");
        String extensionAttribute6 = (String)map.get("v_EXTATTR6");
        String extensionAttribute10 = (String)map.get("v_EXTATTR10");
        String extensionAttribute102 = (String)map.get("v_EXTATTR102");
        String extensionAttribute14 = (String)map.get("v_EXTATTR14");
        String extensionAttribute15 = (String)map.get("v_EXTATTR15");
        String ldapPath = (String)map.get("v_LDAPPATH");
        String birth = (String)map.get("v_BIRTH");
        String birthType = (String)map.get("v_BIRTHTYPE");
        String password = (String)map.get("v_PASS");
        
        logger.debug("insertDBData_userForJMocha started. tenantId=" + tenantId + ",userId=" + userId + ",parentCn=" + parentCn);

        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "displayName=" + URLEncoder.encode(displayName, "UTF-8");
        String param4 = "displayName2=" + URLEncoder.encode(displayName2, "UTF-8");
        String param5 = "mail=" + URLEncoder.encode(mail, "UTF-8");
        String param6 = "mailNickName=" + URLEncoder.encode(mailNickName, "UTF-8");
        String param7 = "upnName=" + URLEncoder.encode(upnName, "UTF-8");
        String param8 = "parentCn=" + URLEncoder.encode(parentCn, "UTF-8");
        String param9 = "title=" + URLEncoder.encode(title, "UTF-8");
        String param10 = "title2=" + URLEncoder.encode(title2, "UTF-8");
        String param11 = "telephoneNumber=" + URLEncoder.encode(telephoneNumber, "UTF-8");
        String param12 = "homePhone=" + URLEncoder.encode(homePhone, "UTF-8");
        String param13 = "facsimileTelephoneNumber=" + URLEncoder.encode(facsimileTelephoneNumber, "UTF-8");
        String param14 = "mobile=" + URLEncoder.encode(mobile, "UTF-8");
        String param15 = "postalCode=" + URLEncoder.encode(postalCode, "UTF-8");
        String param16 = "streetAddress=" + URLEncoder.encode(streetAddress, "UTF-8");
        String param17 = "extensionAttribute6=" + URLEncoder.encode(extensionAttribute6, "UTF-8");
        String param18 = "extensionAttribute10=" + URLEncoder.encode(extensionAttribute10, "UTF-8");
        String param19 = "extensionAttribute102=" + URLEncoder.encode(extensionAttribute102, "UTF-8");
        String param20 = "extensionAttribute14=" + URLEncoder.encode(extensionAttribute14, "UTF-8");
        String param21 = "extensionAttribute15=" + URLEncoder.encode(extensionAttribute15, "UTF-8");
        String param22 = "ldapPath=" + URLEncoder.encode(ldapPath, "UTF-8");
        String param23 = "birth=" + URLEncoder.encode(birth, "UTF-8");
        String param24 = "birthType=" + URLEncoder.encode(birthType, "UTF-8");
        String param25 = "password=" + URLEncoder.encode(password, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5 + "&" + param6
                    + "&" + param7 + "&" + param8 + "&" + param9 + "&" + param10 + "&" + param11 + "&" + param12
                    + "&" + param13 + "&" + param14 + "&" + param15 + "&" + param16 + "&" + param17 + "&" + param18
                    + "&" + param19 + "&" + param20 + "&" + param21 + "&" + param22 + "&" + param23 + "&" + param24
                    + "&" + param25;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/addUser";
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
        
        logger.debug("insertDBData_userForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Adding User Failed!");
        }
    }
	
    private void insertDBData_userForLocal(Map<String, Object> map) throws Exception {
        insert("EzOrganAdminDAO.insertDBData_user", map);
    }
	
	public void insertDBData_user(Map<String, Object> map) throws Exception {
	    insertDBData_userForJMocha(map);

	    if (config.getProperty("config.IsJMochaStandAlone").equals("NO")) {	   
	        try {
	            insertDBData_userForLocal(map);
            // 로컬 등록이 실패하면 JMocha User Repository에 등록한 것을 삭제한다.
            } catch (Exception e) {
                e.printStackTrace();
                
                map.put("v_CLASS", "user");
                deleteDBDataForJMocha(map);
                
                throw e;                
            }            
	    }
	}
	
    private void updateDBData_deptForJMocha(OrganDeptVO vo) throws Exception {
        logger.debug("updateDBData_deptForJMocha started. tenantId=" + vo.getTenantId() + ",deptId=" + vo.getCn());

        String param1 = "tenantId=" + vo.getTenantId();
        String param2 = "deptId=" + URLEncoder.encode(vo.getCn(), "UTF-8");
        String param3 = "displayName=" + URLEncoder.encode(vo.getDisplayName(), "UTF-8");
        String param4 = "displayName2=" + URLEncoder.encode(vo.getDisplayName2(), "UTF-8");
        String param5 = "extensionAttribute4=" + URLEncoder.encode(vo.getExtensionAttribute4(), "UTF-8");
        String param6 = "extensionAttribute5=" + URLEncoder.encode(vo.getExtensionAttribute5(), "UTF-8");
        String param7 = "extensionAttribute6=" + URLEncoder.encode(vo.getExtensionAttribute6(), "UTF-8");
        String param8 = "extensionAttribute8=" + URLEncoder.encode(vo.getExtensionAttribute8(), "UTF-8");
        String param9 = "extensionAttribute9=" + URLEncoder.encode(vo.getExtensionAttribute9(), "UTF-8");
        String param10 = "extensionAttribute10=" + URLEncoder.encode(vo.getExtensionAttribute10(), "UTF-8");
        String param11 = "extensionAttribute15=" + URLEncoder.encode(vo.getExtensionAttribute15(), "UTF-8");        
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5 + "&" + param6
                    + "&" + param7 + "&" + param8 + "&" + param9 + "&" + param10 + "&" + param11;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/updateDept";
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
        
        logger.debug("updateDBData_deptForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Updating Dept Failed!");
        }                
    }
	
    private void updateDBData_deptForLocal(OrganDeptVO vo) throws Exception {
        logger.debug("updateDBData_deptForLocal started. tenantId=" + vo.getTenantId() + ",deptId=" + vo.getCn());
        
        update("EzOrganAdminDAO.updateDBData_dept", vo);
        
        logger.debug("updateDBData_deptForLocal ended.");
    }
    	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception {        
	    updateDBData_deptForJMocha(vo);

	    if (config.getProperty("config.IsJMochaStandAlone").equals("NO")) {	    
            updateDBData_deptForLocal(vo);       
	    }
	}

    private void updateDBData_userForJMocha(OrganUserVO vo) throws Exception {
        logger.debug("updateDBData_userForJMocha started. tenantId=" + vo.getTenantId() + ",userId=" + vo.getCn());

        String param1 = "tenantId=" + vo.getTenantId();
        String param2 = "userId=" + URLEncoder.encode(vo.getCn(), "UTF-8");
        String inputParams = param1 + "&" + param2;
        
        if (vo.getDisplayName() != null) {
            String param = "displayName=" + URLEncoder.encode(vo.getDisplayName(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getDisplayName2() != null) {
            String param = "displayName2=" + URLEncoder.encode(vo.getDisplayName2(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getTitle() != null) {
            String param = "title=" + URLEncoder.encode(vo.getTitle(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getTitle2() != null) {
            String param = "title2=" + URLEncoder.encode(vo.getTitle2(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getTelephoneNumber() != null) {
            String param = "telephoneNumber=" + URLEncoder.encode(vo.getTelephoneNumber(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getHomePhone() != null) {
            String param = "homePhone=" + URLEncoder.encode(vo.getHomePhone(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getFacsimileTelephoneNumber() != null) {
            String param = "facsimileTelephoneNumber=" + URLEncoder.encode(vo.getFacsimileTelephoneNumber(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getMobile() != null) {
            String param = "mobile=" + URLEncoder.encode(vo.getMobile(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getPostalCode() != null) {
            String param = "postalCode=" + URLEncoder.encode(vo.getPostalCode(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getStreetAddress() != null) {
            String param = "streetAddress=" + URLEncoder.encode(vo.getStreetAddress(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getExtensionAttribute1() != null) {
            String param = "extensionAttribute1=" + URLEncoder.encode(vo.getExtensionAttribute1(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getExtensionAttribute2() != null) {
            String param = "extensionAttribute2=" + URLEncoder.encode(vo.getExtensionAttribute2(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getExtensionAttribute3() != null) {
            String param = "extensionAttribute3=" + URLEncoder.encode(vo.getExtensionAttribute3(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getExtensionAttribute6() != null) {
            String param = "extensionAttribute6=" + URLEncoder.encode(vo.getExtensionAttribute6(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getExtensionAttribute10() != null) {
            String param = "extensionAttribute10=" + URLEncoder.encode(vo.getExtensionAttribute10(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getExtensionAttribute102() != null) {
            String param = "extensionAttribute102=" + URLEncoder.encode(vo.getExtensionAttribute102(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getExtensionAttribute14() != null) {
            String param = "extensionAttribute14=" + URLEncoder.encode(vo.getExtensionAttribute14(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getExtensionAttribute15() != null) {
            String param = "extensionAttribute15=" + URLEncoder.encode(vo.getExtensionAttribute15(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getBirth() != null) {
            String param = "birth=" + URLEncoder.encode(vo.getBirth(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getBirthType() != null) {
            String param = "birthType=" + URLEncoder.encode(vo.getBirthType(), "UTF-8");
            inputParams += "&" + param;
        }
        if (vo.getInfo() != null) {
            String param = "info=" + URLEncoder.encode(vo.getInfo(), "UTF-8");
            inputParams += "&" + param;
        }

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/updateUser";
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
        
        logger.debug("updateDBData_userForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Updating User Failed!");
        }        
    }
	
    private void updateDBData_userForLocal(OrganUserVO vo) throws Exception {
        update("EzOrganAdminDAO.updateDBData_user", vo);
    }
	
	public void updateDBData_user(OrganUserVO vo) throws Exception {
	    updateDBData_userForJMocha(vo);

	    if (config.getProperty("config.IsJMochaStandAlone").equals("NO")) { 	    
            updateDBData_userForLocal(vo);       
	    }
	}
	
    private void updatePropertyForJMocha(Map<String, Object> map) throws Exception{
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String cn = (String)map.get("v_CN");
        String type = (String)map.get("v_CLASS");
        String propName = (String)map.get("v_PROPNAME");
        String propValue = (String)map.get("v_PROPVALUE");
        
        logger.debug("updatePropertyForJMocha started. tenantId=" + tenantId + ",cn=" + cn + ",type=" + type
                + ",propName=" + propName + ",propValue=" + propValue);

        String param1 = "tenantId=" + tenantId;
        String param2 = "cn=" + URLEncoder.encode(cn, "UTF-8");
        String param3 = "type=" + URLEncoder.encode(type, "UTF-8");
        String param4 = "propName=" + URLEncoder.encode(propName, "UTF-8");
        String param5 = "propValue=" + URLEncoder.encode(propValue, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/updateEntityPropertyValue";
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
        
        logger.debug("updatePropertyForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Updating Property Failed!");
        }
    }
	
    private void updatePropertyForLocal(Map<String, Object> map) throws Exception{
        update("EzOrganAdminDAO.updateProperty", map);
    }
	
	public void updateProperty(Map<String, Object> map) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            updatePropertyForJMocha(map);
        } else {
            updatePropertyForLocal(map);
        }       
	}

    private void restoreRetireEntryForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String userId = (String)map.get("v_CN");
        String parentCn = (String)map.get("v_PARENTCN");
        
        logger.debug("restoreRetireEntryForJMocha started. tenantId=" + tenantId + ",userId=" + userId + ",parentCn=" + parentCn);
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "parentCn=" + URLEncoder.encode(parentCn, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/restoreUser";
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
            }
        }                       
                
        logger.debug("restoreRetireEntryForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
    }
	
    private void restoreRetireEntryForLocal(Map<String, Object> map) throws Exception {
        update("EzOrganAdminDAO.restoreRetireEntry", map);
    }
	
	public void restoreRetireEntry(Map<String, Object> map) throws Exception{
	    restoreRetireEntryForJMocha(map);

	    if (config.getProperty("config.IsJMochaStandAlone").equals("NO")) {	    
            restoreRetireEntryForLocal(map);       
	    }
	}

    public void deleteDBDataForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String cn = (String)map.get("v_CN");
        String targetClass = (String)map.get("v_CLASS");
        
        logger.debug("deleteDBDataForJMocha started. tenantId=" + tenantId + ",cn=" + cn + ",targetClass=" + targetClass);

        String param1 = "tenantId=" + tenantId;
        String param2 = null;

        String requestURL = null;
                
        if (targetClass.equals("group")) {
            param2 = "deptId=" + URLEncoder.encode(cn, "UTF-8");
            requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/deleteDept";
        } else {
            param2 = "userId=" + URLEncoder.encode(cn, "UTF-8");
            requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/deleteUser";
        }
        
        String inputParams = param1 + "&" + param2;
        
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
        
        logger.debug("deleteDBDataForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        // reasonCode가 -1인 경우는 삭제하려던 레코드가 없는 경우이며 이 경우 성공으로 취급한다. 
        if (reasonCode != 0 && reasonCode != -1) {
            if (targetClass.equals("group")) {
                throw new Exception("Deleting Department Failed!");
            } else {
                throw new Exception("Deleting User Failed!");
            }
        }        
    }
	
    private void deleteDBDataForLocal(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteDBData", map);
    }
	
	public void deleteDBData(Map<String, Object> map) throws Exception {
	    deleteDBDataForJMocha(map);

	    if (config.getProperty("config.IsJMochaStandAlone").equals("NO")) {	    
            deleteDBDataForLocal(map);       
	    }
	}

    public void moveDBDataForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String parentCn = (String)map.get("v_PARENTCN");
        String cn = (String)map.get("v_CN");
        String targetClass = (String)map.get("v_CLASS");
        
        logger.debug("moveDBDataForJMocha started. tenantId=" + tenantId + ",cn=" + cn + ",targetClass=" + targetClass
                    + ",parentCn=" + parentCn);

        String param1 = "tenantId=" + tenantId;
        String param2 = null;
        String param3 = "parentCn=" + URLEncoder.encode(parentCn, "UTF-8");

        String requestURL = null;
        
        if (targetClass.equals("group")) {
            param2 = "deptId=" + URLEncoder.encode(cn, "UTF-8");
            requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/moveDept";
        } else {
            param2 = "userId=" + URLEncoder.encode(cn, "UTF-8");
            requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/moveUser";
        }
        
        String inputParams = param1 + "&" + param2 + "&" + param3;
        
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
        
        logger.debug("moveDBDataForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            if (targetClass.equals("group")) {
                throw new Exception("Moving Dept Failed!");
            } else {
                throw new Exception("Moving User Failed!");
            }
        }                
    }
	
    private void moveDBDataForLocal(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.moveDBData", map);
    }
	
	public void moveDBData(Map<String, Object> map) throws Exception {	    
	    moveDBDataForJMocha(map);

	    if (config.getProperty("config.IsJMochaStandAlone").equals("NO")) {	    
            moveDBDataForLocal(map);       
	    }
	}

    private void retireDBDataForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String userId = (String)map.get("v_CN");
        
        logger.debug("retireDBDataForJMocha started. tenantId=" + tenantId + ",userId=" + userId);
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/retireUser";
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
            }
        }                       
                
        logger.debug("retireDBDataForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
    }
	
    private void retireDBDataForLocal(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.retireDBData", map);
    }
	
	public void retireDBData(Map<String, Object> map) throws Exception {
	    retireDBDataForJMocha(map);

	    if (config.getProperty("config.IsJMochaStandAlone").equals("NO")) {	    
            retireDBDataForLocal(map);       
	    }
	}

    private void setAddJobForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String userId = (String)map.get("v_CN");
        String deptId = (String)map.get("v_DEPTID");
        String title1 = (String)map.get("v_TITLE1");
        String title2 = (String)map.get("v_TITLE2");
        
        logger.debug("setAddJobForJMocha started. tenantId=" + tenantId + ",userId=" + userId
                + ",deptId=" + deptId + ",title1=" + title1 + ",title2=" + title2);
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String param4 = "title1=" + URLEncoder.encode(title1, "UTF-8");
        String param5 = "title2=" + URLEncoder.encode(title2, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/setAddJob";
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
            }
        }                       
                
        logger.debug("setAddJobForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
    }
	
    private void setAddJobForLocal(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.setAddJob", map);
    }
	
	public void setAddJob(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            setAddJobForJMocha(map);
        } else {
            setAddJobForLocal(map);
        }       
	}

    private void deleteAddJobForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String userId = (String)map.get("v_CN");
        String deptId = (String)map.get("v_DEPTID");
        
        logger.debug("deleteAddJobForJMocha started. tenantId=" + tenantId + ",userId=" + userId
                + ",deptId=" + deptId);
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/deleteAddJob";
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
            }
        }                       
                
        logger.debug("deleteAddJobForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
    }
    
    private void deleteAddJobForLocal(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteAddJob", map);
    }
    
    public void deleteAddJob(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            deleteAddJobForJMocha(map);
        } else {
            deleteAddJobForLocal(map);
        }
    }
	
    private int userCountCheckForJMocha(String cn, int tenantID) throws Exception {
        logger.debug("userCountCheckForJMocha started. tenantID=" + tenantID + ",cn=" + cn);
        
        int returnValue = 0;
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "deptId=" + URLEncoder.encode(cn, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getDeptUserCount";
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
                        returnValue = ((Long)result.get("count")).intValue();
                    }                   
                }
            }
        }                       
                
        logger.debug("userCountCheckForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;
    }
	    
    private int userCountCheckForLocal(Map<String, Object> map) {
        String cn = (String)map.get("cn");
        int tenantID = (Integer)map.get("tenantID");
        
        logger.debug("userCountCheckForLocal started. cn=" + cn + ",tenantID=" + tenantID);
        
        int userCount = (int) select("EzOrganAdminDAO.userCountCheck", map);
        
        logger.debug("userCountCheckForLocal started. userCount=" + userCount);
        
        return userCount;
    }
	
    // 지정된 부서에 속한 사원의 수를 반환한다.
	public int userCountCheck(String cn, int tenantID) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return userCountCheckForJMocha(cn, tenantID);
        } else {
        	Map<String, Object> map = new HashMap<String, Object>();
        	map.put("cn", cn);
        	map.put("tenantID", tenantID);
            return userCountCheckForLocal(map);
        }       
	}
	
	private void setUserPrimaryMailForJMocha(String cn, int tenantID, String email) throws Exception {
        logger.debug("setUserPrimaryMailForJMocha started. cn=" + cn + ",tenantId=" + tenantID
                + ",email=" + email);
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "userId=" + URLEncoder.encode(cn, "UTF-8");
        String param3 = "email=" + URLEncoder.encode(email, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/setUserMail";
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
            }
        }                       
                
        logger.debug("setUserPrimaryMailForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
	}
	
	private void setUserPrimaryMailForLocal(String cn, int tenantID, String email) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("TENANT_ID", tenantID);
		map.put("CN", cn);
		map.put("MAIL", email);
		
		update("EzOrganAdminDAO.setUserMail", map);
    }
	
	public void setUserPrimaryMail(String cn, int tenantID, String email) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
        	setUserPrimaryMailForJMocha(cn, tenantID, email);
        } else {
        	setUserPrimaryMailForLocal(cn, tenantID, email);
        }
    }
	
	public void restoreRetireEntry_D (Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.restoreRetireEntry_D", map);
	}
							
	public void moveGroupUser_U (Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.moveGroupUser_U", map);
	}
	
	public void setAddJob_I (Map<String, Object> map) throws Exception {
		insert("EzOrganAdminDAO.setAddJob_I", map);
	}
		
	public void retireDBData_I (Map<String, Object> map) throws Exception {
		insert("EzOrganAdminDAO.retireDBData_I", map);
	}
	
	public void retireDBData_D3(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.retireDBData_D3", map);
    }
			
	public void deleteDBData_D1(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteDBData_D1", map);
    }
			
	public void deleteDBData_D4(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteDBData_D4", map);
    }
	
	public void deleteDBData_D5(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteDBData_D5", map);
    }
		
	public OrganDeptVO moveDBData_S (Map<String, Object> map) throws Exception {
		return (OrganDeptVO)select("EzOrganAdminDAO.moveDBData_S", map);
	}
	
	public OrganDeptVO moveDBData_S1 (Map<String, Object> map) throws Exception {
		return (OrganDeptVO)select("EzOrganAdminDAO.moveDBData_S1", map);
	}
	
	public void moveDBData_U1(Map<String, Object> map) throws Exception {
        update("EzOrganAdminDAO.moveDBData_U1", map);
    }
	
	public void moveDBData_U2(Map<String, Object> map) throws Exception {
        update("EzOrganAdminDAO.moveDBData_U2", map);
    }
	
	public void moveDBData_U3(Map<String, Object> map) throws Exception {
        update("EzOrganAdminDAO.moveDBData_U3", map);
    }
	
	public String getUserInfo_S1 (Map<String, Object> map) throws Exception{
		return (String)select("EzOrganAdminDAO.getUserInfo_S1",map);
	}
	
	public OrganUserVO getUserInfo_S2 (Map<String, Object> map) throws Exception{
		return (OrganUserVO)select("EzOrganAdminDAO.getUserInfo_S2",map);
	}
	
	public void updateProperty_U (Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateProperty_U", map);
	}
	
    public void updateUserDeptDisplayName(OrganDeptVO vo) throws Exception {
        logger.debug("updateUserDeptDisplayName started.");
        logger.debug("displayName=" + vo.getDisplayName() + ",displayName2=" + vo.getDisplayName2());
        
        update("EzOrganAdminDAO.updateUserDeptDisplayName", vo);
        
        logger.debug("updateUserDeptDisplayName ended.");
    }	
		
}