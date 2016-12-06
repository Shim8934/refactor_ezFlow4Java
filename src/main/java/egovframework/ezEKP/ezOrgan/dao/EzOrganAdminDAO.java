package egovframework.ezEKP.ezOrgan.dao;

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
    
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getCompanyList(Map<String, Object> map) throws Exception{
		return (List<OrganDeptVO>) list("EzOrganAdminDAO.getCompanyList", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getAddJobList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getAddJobList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getUserAddJobList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getUserAddJobList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getPermissionList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getPermissionList", map);
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
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getUserCnList() throws Exception {
		return (List<OrganUserVO>) list("EzOrganAdminDAO.userCnList");
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

	public int companyCheck(String cn) throws Exception{		
		return (int) select("EzOrganAdminDAO.companyCheck", cn);
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
	
    private int companyChildCheckForLocal(String cn, int tenantID) throws Exception {
        return (int) select("EzOrganAdminDAO.companyChildCheck", cn);
    }
	
	public int companyChildCheck(String cn, int tenantID) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return companyChildCheckForJMocha(cn, tenantID);
        } else {
            return companyChildCheckForLocal(cn, tenantID);
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
	
    private int userCheckForLocal(String cn, int tenantID) throws Exception{
        return (int) select("EzOrganAdminDAO.userCheck", cn);
    }
	
	public int userCheck(String cn, int tenantID) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return userCheckForJMocha(cn, tenantID);
        } else {
            return userCheckForLocal(cn, tenantID);
        }       
	}
	
	public int getPermissionListCount(Map<String, Object> map) throws Exception{
		select("EzOrganAdminDAO.getPermissionListCount", map);
		int ret = (int) map.get("v_pCount");
		
		return ret;
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
        select("EzOrganAdminDAO.getRetireListCount", map);
        int ret = (int) map.get("v_pCount");
        
        return ret;
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
        insert("EzOrganAdminDAO.insertDBData_company", map);
    }
	
	public void insertDBData_company(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            insertDBData_companyForJMocha(map);
        } else {
            insertDBData_companyForLocal(map);
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
        insert("EzOrganAdminDAO.insertDBData_dept", map);
    }
	
	public void insertDBData_dept(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            insertDBData_deptForJMocha(map);
        } else {
            insertDBData_deptForLocal(map);
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
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            insertDBData_userForJMocha(map);
        } else {
            insertDBData_userForLocal(map);
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
        update("EzOrganAdminDAO.updateDBData_dept", vo);
    }
	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            updateDBData_deptForJMocha(vo);
        } else {
            updateDBData_deptForLocal(vo);
        }       
	}

    private void updateDBData_userForJMocha(OrganUserVO vo) throws Exception {
        logger.debug("updateDBData_userForJMocha started. tenantId=" + vo.getTenantId() + ",userId=" + vo.getCn());

        String param1 = "tenantId=" + vo.getTenantId();
        String param2 = "userId=" + URLEncoder.encode(vo.getCn(), "UTF-8");
        String param3 = "displayName=" + URLEncoder.encode(vo.getDisplayName(), "UTF-8");
        String param4 = "displayName2=" + URLEncoder.encode(vo.getDisplayName2(), "UTF-8");
        String param5 = "title=" + URLEncoder.encode(vo.getTitle(), "UTF-8");
        String param6 = "title2=" + URLEncoder.encode(vo.getTitle2(), "UTF-8");
        String param7 = "telephoneNumber=" + URLEncoder.encode(vo.getTelephoneNumber(), "UTF-8");
        String param8 = "homePhone=" + URLEncoder.encode(vo.getHomePhone(), "UTF-8");
        String param9 = "facsimileTelephoneNumber=" + URLEncoder.encode(vo.getFacsimileTelephoneNumber(), "UTF-8");
        String param10 = "mobile=" + URLEncoder.encode(vo.getMobile(), "UTF-8");
        String param11 = "postalCode=" + URLEncoder.encode(vo.getPostalCode(), "UTF-8");
        String param12 = "streetAddress=" + URLEncoder.encode(vo.getStreetAddress(), "UTF-8");
        String param13 = "extensionAttribute6=" + URLEncoder.encode(vo.getExtensionAttribute6(), "UTF-8");
        String param14 = "extensionAttribute10=" + URLEncoder.encode(vo.getExtensionAttribute10(), "UTF-8");
        String param15 = "extensionAttribute102=" + URLEncoder.encode(vo.getExtensionAttribute102(), "UTF-8");
        String param16 = "extensionAttribute14=" + URLEncoder.encode(vo.getExtensionAttribute14(), "UTF-8");
        String param17 = "extensionAttribute15=" + URLEncoder.encode(vo.getExtensionAttribute15(), "UTF-8");
        String param18 = "birth=" + URLEncoder.encode(vo.getBirth(), "UTF-8");
        String param19 = "birthType=" + URLEncoder.encode(vo.getBirthType(), "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5 + "&" + param6
                    + "&" + param7 + "&" + param8 + "&" + param9 + "&" + param10 + "&" + param11 + "&" + param12
                    + "&" + param13 + "&" + param14 + "&" + param15 + "&" + param16 + "&" + param17 + "&" + param18
                    + "&" + param19;

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
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            updateDBData_userForJMocha(vo);
        } else {
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
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            restoreRetireEntryForJMocha(map);
        } else {
            restoreRetireEntryForLocal(map);
        }       
	}

    private void deleteDBDataForJMocha(Map<String, Object> map) throws Exception {
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
        
        if (reasonCode != 0) {
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
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            deleteDBDataForJMocha(map);
        } else {
            deleteDBDataForLocal(map);
        }       
	}

    private void moveDBDataForJMocha(Map<String, Object> map) throws Exception {
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
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            moveDBDataForJMocha(map);
        } else {
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
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            retireDBDataForJMocha(map);
        } else {
            retireDBDataForLocal(map);
        }       
	}

	public void setAddJob(Map<String, Object> map) throws Exception{
		delete("EzOrganAdminDAO.setAddJob", map);
	}

    public int userCountCheckForJMocha(String cn, int tenantID) throws Exception {
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
	
    public int userCountCheckForLocal(String cn, int tenantID) {
        return (int) select("EzOrganAdminDAO.userCountCheck", cn);
    }
	
	public int userCountCheck(String cn, int tenantID) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return userCountCheckForJMocha(cn, tenantID);
        } else {
            return userCountCheckForLocal(cn, tenantID);
        }       
	}		

}