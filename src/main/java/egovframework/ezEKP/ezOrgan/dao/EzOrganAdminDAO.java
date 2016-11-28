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

	public int userCheck(String cn) throws Exception{
		return (int) select("EzOrganAdminDAO.userCheck", cn);
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

	public void insertDBData_user(Map<String, Object> map) throws Exception{
		insert("EzOrganAdminDAO.insertDBData_user", map);
	}
	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception{
		update("EzOrganAdminDAO.updateDBData_dept", vo);
	}
	
	public void updateDBData_user(OrganUserVO vo) throws Exception{
		update("EzOrganAdminDAO.updateDBData_user", vo);
	}
	
	public void updateProperty(Map<String, Object> map) throws Exception{
		update("EzOrganAdminDAO.updateProperty", map);
	}
	
	public void restoreRetireEntry(Map<String, Object> map) throws Exception{
		update("EzOrganAdminDAO.restoreRetireEntry", map);
	}
	
	public void deleteDBData(Map<String, Object> map) throws Exception{
		delete("EzOrganAdminDAO.deleteDBData", map);
	}

	public void moveDBData(Map<String, Object> map) throws Exception{
		delete("EzOrganAdminDAO.moveDBData", map);
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