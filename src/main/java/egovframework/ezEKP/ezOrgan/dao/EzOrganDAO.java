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
    public List<OrganDeptVO> getDeptSubTreeInfoForLocal(Map<String, Object> map) {      
        return (List<OrganDeptVO>) list("EzOrganDAO.getDeptSubTreeInfo", map);
    }
	
	public List<OrganDeptVO> getDeptSubTreeInfo(Map<String, Object> map) throws Exception {		
        if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
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
	
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getDeptMemberListPage(Map<String, Object> map) throws Exception {
		return (List<OrganDeptVO>) list("EzOrganDAO.getDeptMemberListPage", map);		
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> organSearch(Map<String, Object> map) throws Exception {		
		return (List<OrganDeptVO>) list("EzOrganDAO.organSearch", map);
	}	
	
	@SuppressWarnings("unchecked")
	public List<OrganProxyVO> getProxyUserInfo(Map<String, Object> map) throws Exception{
		return (List<OrganProxyVO>) list("EzOrganDAO.getProxyUserInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getBirthUserList(String companyID) throws Exception{
		return (List<OrganUserVO>) list("EzOrganDAO.getBirthUserList", companyID);
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
	
	public String getMemberListCount(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getMemberListCount", map);
	}
	
	public String getPropertyValue(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getPropertyValue", map);
	}

	public String getSIPUriList(Map<String, Object> map) throws Exception{
		return (String) select("EzOrganDAO.getSIPUriList", map);
	}

	public String getDeptFullPath(String deptID) throws Exception{
		return (String) select("EzOrganDAO.getDeptFullPath", deptID);
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

	public OrganUserVO getUserAddjobInfo(Map<String, Object> map) throws Exception{
		return (OrganUserVO) select("EzOrganDAO.getUserAddjobInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> organSearchListPage(Map<String, Object> map) throws Exception{
		// TODO Auto-generated method stub
		return (List<OrganDeptVO>) list("EzOrganDAO.organSearchListPage", map);
	}

	public int getSearchListCount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return (int) select("EzOrganDAO.getSearchListCount", map);
	}

	public void updateProperty(Map<String, Object> map) throws Exception{
		update("EzOrganDAO.updateProperty", map);
	}
	
	public void setProxyUserInfo(Map<String, Object> map) throws Exception{
		update("EzOrganDAO.setProxyUserInfo", map);
	}

	public void delProxyUserInfo(Map<String, Object> map) throws Exception{
		delete("EzOrganDAO.delProxyUserInfo", map);
	}

	public String getCNByEmail(String email) throws Exception{
		return (String) select("EzOrganDAO.getCNByEmail", email);
	}

}