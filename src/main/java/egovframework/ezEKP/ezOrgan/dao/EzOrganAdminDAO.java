package egovframework.ezEKP.ezOrgan.dao;

import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.Properties;

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
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getRetireList(Map<String, Object> map) throws Exception{
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getRetireList", map);
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
	
	public OrganUserVO getRetireEntryInfo(Map<String, Object> map) throws Exception{
		return (OrganUserVO) select("EzOrganAdminDAO.getRetireEntryInfo", map);
	}

	public int companyCheck(String cn) throws Exception{		
		return (int) select("EzOrganAdminDAO.companyCheck", cn);
	}
	
	public int companyChildCheck(String cn) throws Exception{
		return (int) select("EzOrganAdminDAO.companyChildCheck", cn);
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
	
	public int getRetireListCount(Map<String, Object> map) throws Exception{
		select("EzOrganAdminDAO.getRetireListCount", map);
		int ret = (int) map.get("v_pCount");
		
		return ret;
	}


	public void insertDBData_company(Map<String, Object> map) throws Exception{
		insert("EzOrganAdminDAO.insertDBData_company", map);
	}

	public void insertDBData_dept(Map<String, Object> map) throws Exception{
		insert("EzOrganAdminDAO.insertDBData_dept", map);
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
	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception{
		update("EzOrganAdminDAO.updateDBData_dept", vo);
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
	
	public void updateProperty(Map<String, Object> map) throws Exception{
		update("EzOrganAdminDAO.updateProperty", map);
	}
	
	public void restoreRetireEntry(Map<String, Object> map) throws Exception{
		update("EzOrganAdminDAO.restoreRetireEntry", map);
	}

    private void deleteDBDataForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String userId = (String)map.get("v_CN");
        String targetClass = (String)map.get("v_CLASS");
        
        logger.debug("deleteDBDataForJMocha started. tenantId=" + tenantId + ",userId=" + userId + ",targetClass=" + targetClass);

        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/deleteUser";
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
            throw new Exception("Deleting User Failed!");
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
        String userId = (String)map.get("v_CN");
        String targetClass = (String)map.get("v_CLASS");
        
        logger.debug("moveDBDataForJMocha started. tenantId=" + tenantId + ",userId=" + userId + ",targetClass=" + targetClass
                    + ",parentCn=" + parentCn);

        String param1 = "tenantId=" + tenantId;
        String param2 = "userId=" + URLEncoder.encode(userId, "UTF-8");
        String param3 = "parentCn=" + URLEncoder.encode(parentCn, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/moveUser";
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
            throw new Exception("Moving User Failed!");
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

	public void retireDBData(Map<String, Object> map) throws Exception{
		delete("EzOrganAdminDAO.retireDBData", map);
	}

	public void setAddJob(Map<String, Object> map) throws Exception{
		delete("EzOrganAdminDAO.setAddJob", map);
	}

	public int userCountCheck(String cn) {
		// TODO Auto-generated method stub
		return (int) select("EzOrganAdminDAO.userCountCheck", cn);
	}
		

}