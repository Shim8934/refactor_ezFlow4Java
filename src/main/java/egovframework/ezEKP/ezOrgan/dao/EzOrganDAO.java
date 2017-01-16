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
import egovframework.ezEKP.ezOrgan.vo.OrganProxyVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzOrganDAO")
public class EzOrganDAO extends EgovAbstractDAO {
	
    private static final Logger logger = LoggerFactory.getLogger(EzOrganDAO.class);
            
    @Autowired
    private Properties config;

    @Autowired
    private EzEmailUtil ezEmailUtil;

    private List<OrganDeptVO> getDeptTreeInfoForJMocha(Map<String, Object> map) throws Exception{ 
        String deptId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getDeptTreeInfoForJMocha started. tenantId=" + tenantId + ",deptId=" + deptId + ",isPrimary=" + isPrimary);
        
        List<OrganDeptVO> returnValue = new ArrayList<OrganDeptVO>();
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String param3 = "isPrimary=" + URLEncoder.encode(isPrimary, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getDeptTreeInfo";
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
                            
                            deptVO.setCn((String)itemObj.get("deptId"));
                            deptVO.setDisplayName((String)itemObj.get("displayname"));
                            deptVO.setExtensionAttribute15((String)itemObj.get("orderInfo"));
                            deptVO.setType((String)itemObj.get("type"));
                            
                            returnValue.add(deptVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("getDeptTreeInfoForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;
    }
    
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getDeptTreeInfoForLocal(Map<String, Object> map) throws Exception{ 
        return (List<OrganDeptVO>) list("EzOrganDAO.getDeptTreeInfo", map);
    }
    
	public List<OrganDeptVO> getDeptTreeInfo(Map<String, Object> map) throws Exception{	
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getDeptTreeInfoForJMocha(map);
        } else {
            return getDeptTreeInfoForLocal(map);
        }       
	}

    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getDeptSubTreeInfoForLocal(Map<String, Object> map) {      
        return (List<OrganDeptVO>) list("EzOrganDAO.getDeptSubTreeInfo", map);
    }
	
	public List<OrganDeptVO> getDeptSubTreeInfo(Map<String, Object> map) throws Exception {		
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            // getDeptSubTreeInfo와 getDeptTreeInfo가 동일한 것으로 판단되어 getDeptTreeInfoForJMocha를 호출하도록 함.
            return getDeptTreeInfoForJMocha(map);
        } else {
            return getDeptSubTreeInfoForLocal(map);
        }       
	}

    private List<OrganDeptVO> getDeptMemberListForJMocha(Map<String, Object> map) throws Exception {
        String type = (String)map.get("v_CLASS");
        String deptId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getDeptMemberListForJMocha started. tenantId=" + tenantId + ",deptId=" + deptId 
                + ",isPrimary=" + isPrimary + ",type=" + type);
        
        List<OrganDeptVO> returnValue = new ArrayList<OrganDeptVO>();
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String param3 = "isPrimary=" + URLEncoder.encode(isPrimary, "UTF-8");
        String param4 = "type=" + type;
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getDeptMemberList";
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
                            
                            deptVO.setCn((String)itemObj.get("deptId"));
                            deptVO.setDisplayName((String)itemObj.get("displayname"));
                            deptVO.setExtensionAttribute15((String)itemObj.get("orderInfo"));
                            deptVO.setType((String)itemObj.get("type"));
                            
                            returnValue.add(deptVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("getDeptMemberListForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;       
    }
	
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getDeptMemberListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganDeptVO>) list("EzOrganDAO.getDeptMemberList", map);       
    }
	
	public List<OrganDeptVO> getDeptMemberList(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getDeptMemberListForJMocha(map);
        } else {
            return getDeptMemberListForLocal(map);
        }       		
	}
	
    private List<OrganDeptVO> getDeptMemberListPageForJMocha(Map<String, Object> map) throws Exception {
        String type = (String)map.get("v_CLASS");
        String deptId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        String page = (String)map.get("v_PAGE");
        
        logger.debug("getDeptMemberListPageForJMocha started. tenantId=" + tenantId + ",deptId=" + deptId 
                + ",isPrimary=" + isPrimary + ",type=" + type + ",page=" + page);
        
        List<OrganDeptVO> returnValue = new ArrayList<OrganDeptVO>();
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String param3 = "isPrimary=" + URLEncoder.encode(isPrimary, "UTF-8");
        String param4 = "type=" + type;
        String param5 = "page=" + page;
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getDeptMemberListPage";
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
                            
                            deptVO.setCn((String)itemObj.get("deptId"));
                            deptVO.setDisplayName((String)itemObj.get("displayname"));
                            deptVO.setExtensionAttribute15((String)itemObj.get("orderInfo"));
                            deptVO.setType((String)itemObj.get("type"));
                            
                            returnValue.add(deptVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("getDeptMemberListPageForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;              
    }
	
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getDeptMemberListPageForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganDeptVO>) list("EzOrganDAO.getDeptMemberListPage", map);       
    }
	
	public List<OrganDeptVO> getDeptMemberListPage(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getDeptMemberListPageForJMocha(map);
        } else {
            return getDeptMemberListPageForLocal(map);
        }               		
	}
	
    private List<OrganDeptVO> organSearchForJMocha(Map<String, Object> map) throws Exception {
        String strSQL = (String)map.get("strSQL");
        String type = (String)map.get("type");
        String classType = (String)map.get("class");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("organSearchForJMocha started. tenantId=" + tenantId + ",type=" + type 
                + ",classType=" + classType + ",strSQL=" + strSQL);
        
        List<OrganDeptVO> returnValue = new ArrayList<OrganDeptVO>();
        
        String param1 = "type=" + type;
        String param2 = "classType=" + classType;
        String param3 = "sql=" + URLEncoder.encode(strSQL, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getSearchList";
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
                            
                            deptVO.setCn((String)itemObj.get("cn"));
                            deptVO.setDisplayName((String)itemObj.get("displayname"));
                            deptVO.setExtensionAttribute15((String)itemObj.get("orderInfo"));
                            deptVO.setType((String)itemObj.get("type"));
                            
                            returnValue.add(deptVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("organSearchForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;                      
    }   
	
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> organSearchForLocal(Map<String, Object> map) throws Exception {        
        return (List<OrganDeptVO>) list("EzOrganDAO.organSearch", map);
    }   
	
	public List<OrganDeptVO> organSearch(Map<String, Object> map) throws Exception {		
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return organSearchForJMocha(map);
        } else {
            return organSearchForLocal(map);
        }                       
	}	
	
	@SuppressWarnings("unchecked")
	public List<OrganProxyVO> getProxyUserInfo(Map<String, Object> map) throws Exception{
		return (List<OrganProxyVO>) list("EzOrganDAO.getProxyUserInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getBirthUserList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganDAO.getBirthUserList", map);
	}

    private OrganUserVO getTBLUserMasterForJMocha(Map<String, Object> map) throws Exception {
        String userId = (String)map.get("v_CN");
        String deptId = (String)map.get("v_DEPTCD");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getTBLUserMasterForJMocha started. tenantId=" + tenantId + ",userId=" + userId + ",deptId=" + deptId + ",isPrimary=" + isPrimary);
        
        OrganUserVO userVO = new OrganUserVO();
                
        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String param4 = "isPrimary=" + URLEncoder.encode(isPrimary, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserInfoWithAddJob";
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
                        userVO.setCn((String)result.get("userId"));
                        userVO.setDepartment((String)result.get("deptId"));
                        userVO.setDisplayName((String)result.get("displayname"));
                        userVO.setDisplayName1((String)result.get("displayname1"));
                        userVO.setDisplayName2((String)result.get("displayname2"));
                        userVO.setMail((String)result.get("mail"));
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
                        userVO.setExtensionAttribute11((String)result.get("extensionattribute11"));
                        userVO.setExtensionAttribute12((String)result.get("extensionattribute12"));
                        userVO.setExtensionAttribute13((String)result.get("extensionattribute13"));
                        userVO.setExtensionAttribute14((String)result.get("extensionattribute14"));
                        userVO.setExtensionAttribute15((String)result.get("extensionattribute15"));
                        userVO.setAdsPath((String)result.get("adsPath"));                        
                        userVO.setUpdateDT((String)result.get("updatedt"));
                        userVO.setType((String)result.get("type"));
                        userVO.setSipUri((String)result.get("sipUri"));
                    }                   
                }
            }
        }                       
        
        logger.debug("getTBLUserMasterForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return userVO;
    }
	
    private OrganUserVO getTBLUserMasterForLocal(Map<String, Object> map) throws Exception {
        return (OrganUserVO) select("EzOrganDAO.getTBLUserMaster", map);
    }
	
	public OrganUserVO getTBLUserMaster(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getTBLUserMasterForJMocha(map);
        } else {
            return getTBLUserMasterForLocal(map);
        }               
	}

    private OrganDeptVO getTBLDeptMasterForJMocha(Map<String, Object> map) throws Exception {
        String deptId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getTBLDeptMasterForJMocha started. tenantId=" + tenantId + ",deptId=" + deptId + ",isPrimary=" + isPrimary);
        
        OrganDeptVO deptVO = new OrganDeptVO();
                
        String param1 = "tenantId=" + tenantId;
        String param2 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String param3 = "isPrimary=" + URLEncoder.encode(isPrimary, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getDeptInfo";
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
                        deptVO.setCn((String)result.get("deptId"));
                        deptVO.setDepartment((String)result.get("deptId"));
                        deptVO.setDisplayName((String)result.get("displayname"));
                        deptVO.setDeptNM((String)result.get("displayname"));
                        deptVO.setDisplayName1((String)result.get("displayname1"));
                        deptVO.setDisplayName2((String)result.get("displayname2"));
                        deptVO.setMail((String)result.get("mail"));
                        deptVO.setExtensionAttribute1((String)result.get("extensionattribute1"));
                        deptVO.setExtensionAttribute2((String)result.get("extensionattribute2"));
                        deptVO.setExtensionAttribute3((String)result.get("extensionattribute3"));
                        deptVO.setExtensionAttribute4((String)result.get("extensionattribute4"));
                        deptVO.setExtensionAttribute5((String)result.get("extensionattribute5"));
                        deptVO.setExtensionAttribute6((String)result.get("extensionattribute6"));
                        deptVO.setExtensionAttribute7((String)result.get("extensionattribute7"));
                        deptVO.setExtensionAttribute8((String)result.get("extensionattribute8"));
                        deptVO.setExtensionAttribute9((String)result.get("extensionattribute9"));
                        deptVO.setExtensionAttribute10((String)result.get("extensionattribute10"));
                        deptVO.setExtensionAttribute11((String)result.get("extensionattribute11"));
                        deptVO.setExtensionAttribute12((String)result.get("extensionattribute12"));
                        deptVO.setExtensionAttribute13((String)result.get("extensionattribute13"));
                        deptVO.setExtensionAttribute14((String)result.get("extensionattribute14"));
                        deptVO.setExtensionAttribute15((String)result.get("extensionattribute15"));
                        deptVO.setAdsPath((String)result.get("adsPath"));                        
                        deptVO.setUpdateDT((String)result.get("updatedt"));
                        deptVO.setType((String)result.get("type"));
                        deptVO.setTenantId(tenantId);
                    }                   
                }
            }
        }                       
        
        logger.debug("getTBLDeptMasterForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return deptVO;
    }
	
    private OrganDeptVO getTBLDeptMasterForLocal(Map<String, Object> map) throws Exception {
        return (OrganDeptVO) select("EzOrganDAO.getTBLDeptMaster", map);
    }
	
	public OrganDeptVO getTBLDeptMaster(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getTBLDeptMasterForJMocha(map);
        } else {
            return getTBLDeptMasterForLocal(map);
        }       
	}

    private OrganDeptVO getDeptInfoForJMocha(Map<String, Object> map) throws Exception {
        String deptId = (String)map.get("userID");
        String isPrimary = (String)map.get("primary");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getDeptInfoForJMocha started. tenantId=" + tenantId + ",deptId=" + deptId + ",isPrimary=" + isPrimary);
        
        OrganDeptVO deptVO = new OrganDeptVO();
                
        String param1 = "tenantId=" + tenantId;
        String param2 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String param3 = "isPrimary=" + URLEncoder.encode(isPrimary, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getDeptInfo";
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
                        deptVO.setCn((String)result.get("deptId"));
                        deptVO.setDepartment((String)result.get("deptId"));
                        deptVO.setDisplayName((String)result.get("displayname"));
                        deptVO.setDeptNM((String)result.get("displayname"));
                        deptVO.setDisplayName1((String)result.get("displayname1"));
                        deptVO.setDisplayName2((String)result.get("displayname2"));
                        deptVO.setMail((String)result.get("mail"));
                        deptVO.setExtensionAttribute1((String)result.get("extensionattribute1"));
                        deptVO.setExtensionAttribute2((String)result.get("extensionattribute2"));
                        deptVO.setExtensionAttribute3((String)result.get("extensionattribute3"));
                        deptVO.setExtensionAttribute4((String)result.get("extensionattribute4"));
                        deptVO.setExtensionAttribute5((String)result.get("extensionattribute5"));
                        deptVO.setExtensionAttribute6((String)result.get("extensionattribute6"));
                        deptVO.setExtensionAttribute7((String)result.get("extensionattribute7"));
                        deptVO.setExtensionAttribute8((String)result.get("extensionattribute8"));
                        deptVO.setExtensionAttribute9((String)result.get("extensionattribute9"));
                        deptVO.setExtensionAttribute10((String)result.get("extensionattribute10"));
                        deptVO.setExtensionAttribute11((String)result.get("extensionattribute11"));
                        deptVO.setExtensionAttribute12((String)result.get("extensionattribute12"));
                        deptVO.setExtensionAttribute13((String)result.get("extensionattribute13"));
                        deptVO.setExtensionAttribute14((String)result.get("extensionattribute14"));
                        deptVO.setExtensionAttribute15((String)result.get("extensionattribute15"));
                        deptVO.setAdsPath((String)result.get("adsPath"));                        
                        deptVO.setUpdateDT((String)result.get("updatedt"));
                        deptVO.setType((String)result.get("type"));
                        deptVO.setTenantId(tenantId);
                    }                   
                }
            }
        }                       
        
        logger.debug("getDeptInfoForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return deptVO;        
    }

	private OrganDeptVO getDeptInfoForLocal(Map<String, Object> map) {
        return (OrganDeptVO) select("EzOrganDAO.getDeptInfo", map);
    }
	
	public OrganDeptVO getDeptInfo(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getDeptInfoForJMocha(map);
        } else {
            return getDeptInfoForLocal(map);
        }       
	}

    private OrganUserVO getUserInfoForJMocha(Map<String, Object> map) throws Exception{
        String userId = (String)map.get("v_CN");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("EzOrganDAO.getUserInfoForJMocha started. tenantId=" + tenantId + ",userId=" + userId + ",isPrimary=" + isPrimary);
        
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
        
        logger.debug("EzOrganDAO.getUserInfoForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return userVO;
    }
	
    private OrganUserVO getUserInfoForLocal(Map<String, Object> map) throws Exception{
        return (OrganUserVO) select("EzOrganDAO.getUserInfo", map);
    }
	
	public OrganUserVO getUserInfo(Map<String, Object> map) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getUserInfoForJMocha(map);
        } else {
            return getUserInfoForLocal(map);
        }       
	}
	
    private String getMemberListCountForJMocha(Map<String, Object> map) throws Exception {
        String deptId = (String)map.get("v_CN");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getMemberListCountForJMocha started. tenantId=" + tenantId + ",deptId=" + deptId);
        
        int returnValue = 0;
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getDeptMemberListCount";
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
                
        logger.debug("getMemberListCountForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return String.valueOf(returnValue);     
    }
	
    private String getMemberListCountForLocal(Map<String, Object> map) throws Exception {
        return (String) select("EzOrganDAO.getMemberListCount", map);
    }
	
	public String getMemberListCount(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getMemberListCountForJMocha(map);
        } else {
            return getMemberListCountForLocal(map);
        }       
	}
	
    private String getPropertyValueForJMocha(Map<String, Object> map) throws Exception {
        String cn = (String)map.get("v_CN");
        String field = (String)map.get("v_FIELD");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getPropertyValueForJMocha started. tenantId=" + tenantId + ",cn=" + cn + ",field=" + field);
        
        String returnValue = "";
        
        String param1 = "tenantId=" + tenantId;
        String param2 = "cn=" + URLEncoder.encode(cn, "UTF-8");
        String param3 = "field=" + URLEncoder.encode(field, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getEntityPropertyValue";
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
                        returnValue = (String)result.get("value");
                    }                   
                }
            }
        }                       
        
        logger.debug("getPropertyValueForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;        
    }
	
    private String getPropertyValueForLocal(Map<String, Object> map) throws Exception {
        return (String) select("EzOrganDAO.getPropertyValue", map);
    }
	
	public String getPropertyValue(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getPropertyValueForJMocha(map);
        } else {
            return getPropertyValueForLocal(map);
        }       
	}

	public String getSIPUriList(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getSIPUriList", map);
	}

    private String getDeptFullPathForJMocha(String deptID, int tenantID) throws Exception{
        logger.debug("getDeptFullPathForJMocha started. tenantID=" + tenantID + ",deptID=" + deptID);
        
        String returnValue = null;
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "deptId=" + URLEncoder.encode(deptID, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getDeptCdPath";
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
                        returnValue = "top,Top," + (String)result.get("deptCdPath");
                    }                   
                }
            }
        }                       
        
        logger.debug("getDeptFullPathForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;
    }
	
    private String getDeptFullPathForLocal(String deptID, int tenantID) throws Exception{
        return (String) select("EzOrganDAO.getDeptFullPath", deptID);
    }
	
	public String getDeptFullPath(String deptID, int tenantID) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getDeptFullPathForJMocha(deptID, tenantID);
        } else {
            return getDeptFullPathForLocal(deptID, tenantID);
        }       
	}
	
	public String getEncPassword(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getEncPassword", map);
	}
	
	public String getLastLogin(String userID) throws Exception{
		return (String) select("EzOrganDAO.getLastLogin", userID);
	}

    private int deptSubDeptCntForJMocha(String deptID, int tenantID) throws Exception{
        logger.debug("deptSubDeptCntForJMocha started. tenantID=" + tenantID + ",deptID=" + deptID);
        
        int returnValue = 0;
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "deptId=" + URLEncoder.encode(deptID, "UTF-8");
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
                
        logger.debug("deptSubDeptCntForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;     
    }
	
    private int deptSubDeptCntForLocal(String deptID, int tenantId) throws Exception{
        return (int) select("EzOrganDAO.deptSubDeptCnt", deptID);
    }
	
	public int deptSubDeptCnt(String deptID, int tenantId) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return deptSubDeptCntForJMocha(deptID, tenantId);
        } else {
            return deptSubDeptCntForLocal(deptID, tenantId);
        }       
	}

    private OrganUserVO getUserAddjobInfoForJMocha(Map<String, Object> map) throws Exception{
        String userId = (String)map.get("v_PCN");
        String deptId = (String)map.get("v_PDEPT");
        String isPrimary = (String)map.get("v_LANGDATA");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        
        logger.debug("getUserAddjobInfoForJMocha started. tenantId=" + tenantId + ",userId=" + userId 
                + ",deptId=" + deptId + ",isPrimary=" + isPrimary);
        
        OrganUserVO userVO = null;
                
        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "deptId=" + URLEncoder.encode(deptId, "UTF-8");
        String param4 = "isPrimary=" + URLEncoder.encode(isPrimary, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserAddJobInfo";
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
                                                        
                        userVO.setDisplayName((String)result.get("displayname"));
                        userVO.setTitle((String)result.get("title"));
                    }                   
                }
            }
        }                       
        
        logger.debug("getUserAddjobInfoForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return userVO;
    }
	
    private OrganUserVO getUserAddjobInfoForLocal(Map<String, Object> map) throws Exception{
        return (OrganUserVO) select("EzOrganDAO.getUserAddjobInfo", map);
    }
	
	public OrganUserVO getUserAddjobInfo(Map<String, Object> map) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getUserAddjobInfoForJMocha(map);
        } else {
            return getUserAddjobInfoForLocal(map);
        }       
	}

    private List<OrganDeptVO> organSearchListPageForJMocha(Map<String, Object> map) throws Exception{
        String strSQL = (String)map.get("strSQL");
        String type = (String)map.get("type");
        String classType = (String)map.get("class");
        int tenantId = (Integer)map.get("v_TENANT_ID");
        int startRow = (Integer)map.get("startRow");
        int endRow = (Integer)map.get("endRow");
        
        logger.debug("organSearchForJMocha started. tenantId=" + tenantId + ",type=" + type 
                + ",classType=" + classType + ",strSQL=" + strSQL + ",startRow=" + startRow + ",endRow=" + endRow);
        
        List<OrganDeptVO> returnValue = new ArrayList<OrganDeptVO>();
        
        String param1 = "type=" + type;
        String param2 = "classType=" + classType;
        String param3 = "sql=" + URLEncoder.encode(strSQL, "UTF-8");
        String param4 = "startRow=" + startRow;
        String param5 = "endRow=" + endRow;
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getSearchListPage";
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
                            
                            deptVO.setCn((String)itemObj.get("cn"));
                            deptVO.setDisplayName((String)itemObj.get("displayname"));
                            deptVO.setExtensionAttribute15((String)itemObj.get("orderInfo"));
                            deptVO.setType((String)itemObj.get("type"));
                            
                            returnValue.add(deptVO);
                        }
                    }                   
                }
            }
        }                       
                
        logger.debug("organSearchForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;                      
    }
	
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> organSearchListPageForLocal(Map<String, Object> map) throws Exception{
        return (List<OrganDeptVO>) list("EzOrganDAO.organSearchListPage", map);
    }
	
	public List<OrganDeptVO> organSearchListPage(Map<String, Object> map) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return organSearchListPageForJMocha(map);
        } else {
            return organSearchListPageForLocal(map);
        }                       
	}

    private int getSearchListCountForJMocha(Map<String, Object> map) throws Exception {
        String strSQL = (String)map.get("strSQL");
        
        logger.debug("getSearchListCountForJMocha started. strSQL=" + strSQL);
        
        int returnValue = 0;
        
        String param1 = "sql=" + URLEncoder.encode(strSQL, "UTF-8");
        String inputParams = param1;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getSearchListCount";
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
                
        logger.debug("getSearchListCountForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;     
    }
	
    private int getSearchListCountForLocal(Map<String, Object> map) {
        return (int) select("EzOrganDAO.getSearchListCount", map);
    }
	
	public int getSearchListCount(Map<String, Object> map) throws Exception {
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getSearchListCountForJMocha(map);
        } else {
            return getSearchListCountForLocal(map);
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
        update("EzOrganDAO.updateProperty", map);
    }
	
	public void updateProperty(Map<String, Object> map) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            updatePropertyForJMocha(map);
        } else {
            updatePropertyForLocal(map);
        }                       
	}
	
	public void setProxyUserInfo(Map<String, Object> map) throws Exception{
		update("EzOrganDAO.setProxyUserInfo", map);
	}

	public void delProxyUserInfo(Map<String, Object> map) throws Exception{
		delete("EzOrganDAO.delProxyUserInfo", map);
	}

    private String getCNByEmailForJMocha(String email, int tenantID) throws Exception{
        logger.debug("getCNByEmailForJMocha started. email=" + email + ",tenantID=" + tenantID);
        
        String returnValue = null;
        
        String param1 = "tenantId=" + tenantID;
        String param2 = "email=" + URLEncoder.encode(email, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/getUserIdByEmail";
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
                        returnValue = (String)result.get("userId");
                    }                   
                }
            }
        }                       
                
        logger.debug("getCNByEmailForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);
        
        return returnValue;             
    }
	
    private String getCNByEmailForLocal(String email, int tenantID) throws Exception{
        return (String) select("EzOrganDAO.getCNByEmail", email);
    }
	
	public String getCNByEmail(String email, int tenantID) throws Exception{
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            return getCNByEmailForJMocha(email, tenantID);
        } else {
            return getCNByEmailForLocal(email, tenantID);
        }                       
	}

}