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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.dao.EzNewPortalDAO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.user.login.vo.TenantVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCommonDAO")
public class EzCommonDAO extends EgovAbstractDAO {

    private static final Logger logger = LoggerFactory.getLogger(EzCommonDAO.class);

    @Value("#{globals['Globals.DbType']}")
	private String dbType;

    @Autowired
    private Properties config;

    @Autowired
    private EzEmailUtil ezEmailUtil;
    
    //2019.01.21 유은정 - 동적 테이블 생성시 초기데이터 삽입 관련 추가
    @Autowired
    private EzOrganAdminDAO ezOrganAdminDAO;
    
    @Autowired
    private EzNewPortalDAO ezNewPortalDAO;
    
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
	
	public void deleteMultiLoginUser(Map<String, Object> map) throws Exception {
		update("EzCommonDAO.deleteMultiLoginUser", map);
	}
	
	public String selectMultiLoginUser(Map<String, Object> map) throws Exception {
		return (String) select("EzCommonDAO.selectMultiLoginUser", map);
	}
	
	public void createTblUserMultiLogin() throws Exception {
		try {
			select("EzCommonDAO.checkTblUserMultiLogin");
		} catch (Exception e) {
			logger.debug("tbl_user_multilogin doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblUserMultiLogin");
		}
	}
	
	public void createTblCompanyConfig() throws Exception {
		try {
			select("EzCommonDAO.checkTblCompanyConfig");
		} catch (Exception e) {
			logger.debug("tbl_company_config doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblCompanyConfig");
		}
	}
	
	public void createReformFlagColumn() throws Exception {
		try {
			select("EzCommonDAO.checkReformFlagColumn");
		} catch (Exception e) {
			logger.debug("tbl_forminfo reformflag column doesn't exist. creating the column...");
			
			update("EzCommonDAO.createReformFlagColumn");
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
	
	public void insertMultiLoginUser(Map<String, Object> map) throws Exception {
		insert("EzCommonDAO.insertMultiLoginUser", map);
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
	
	public void addAddJobMasterProxy() throws Exception {
		try {
			select("EzCommonDAO.checkAddAddJobMasterProxy");
		} catch (Exception e) {
			logger.debug("tbl_addjobmaster proxy column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addAddJobMasterProxy");
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
	
	public void createJMochaDistributionSub() throws Exception {
		try {
			select("EzCommonDAO.checkJmochaDistributionSub");
		} catch (Exception e) {
			logger.debug("jmocha_distribution_sub doesn't exist. creating the table...");
			
			update("EzCommonDAO.createJmochaDistributionSub");
		}
	}

	public void addUserMasterManualFlag() throws Exception {
		try {
			select("EzCommonDAO.checkUserMasterManualFlag");
		} catch (Exception e) {
			logger.debug("tbl_usermaster MANUAL_FLAG column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addUserMasterManualFlag");
		}
	}
	
	public void addDeptMasterManualFlag() throws Exception {
		try {
			select("EzCommonDAO.checkDeptMasterManualFlag");
		} catch (Exception e) {
			logger.debug("tbl_deptmaster MANUAL_FLAG column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addDeptMasterManualFlag");
		}
	}
	
	public void addAddJobMasterManualFlag() throws Exception {
		try {
			select("EzCommonDAO.checkAddJobMasterManualFlag");
		} catch (Exception e) {
			logger.debug("tbl_addjobmaster MANUAL_FLAG column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addAddJobMasterManualFlag");
		}
	}
	
	public void createJmochaMailSignatureTemplate() throws Exception {
		try {
			select("EzCommonDAO.checkJMochaMailSignatureTemplate");
		} catch (Exception e) {
			logger.debug("tbl_access_id doesn't exist. creating the table...");
			
			update("EzCommonDAO.createJMochaMailSignatureTemplate");
		}
	}
		
	public void createJobMasterTable() throws Exception {
		try {
			select("EzCommonDAO.checkTblUserJobMaster");
		} catch (Exception e) {
			logger.debug("tbl_user_jobmaster doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblUserJobMaster");
		}
	}
	
	/*세션 사용 시간 get*/
	public String getUseSession(Map<String, Object> map) {
		return (String) select("EzCommonDAO.getUseSession", map);
	}
	
	/*세션 사용 row가 없을 시 생성*/
	public void insertUseSession(Map<String, Object> map) {
		insert ("EzCommonDAO.insertUseSession", map);
	}
	
	public void addUserMasterPasswordUpdateDT() throws Exception {
		try {
			select("EzCommonDAO.checkUserMasterPasswordUpdateDT");
		} catch (Exception e) {
			logger.debug("tbl_usermaster PASSWORD_UPDATEDT column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addUserMasterPasswordUpdateDT");
		}
	}

	public void addJobMasterJobID() throws Exception {
		try {
			select("EzCommonDAO.checkAddJobMasterJobID");
		} catch (Exception e) {
			logger.debug("tbl_addjobmaster jobid column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addAddJobMasterJobID");
		}
	}

	public void createWebfolderToken() {
		try {
			select("EzCommonDAO.checkWebfolderToken");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_token doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblWebfolderToken");
		}
	}
	
	public void addJmochaMailGenenalPreviewMailImage() {
		try {
			select("EzCommonDAO.checkJmochaMailGenenalPreviewMailImage");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_token doesn't exist. creating the table...");
			
			update("EzCommonDAO.addJmochaMailGenenalPreviewMailImage");
		}
	}
	
	public void addPortalThemePortletIsFixed() {
		try {
			select("EzCommonDAO.checkPortalThemePortletIsFixed");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme_portlet isFixed column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addPortalThemePortletIsFixed");
		}
	}
	
	public void addUserMasterMailBoxQuota() {
		try {
			select("EzCommonDAO.checkUserMasterMailBoxQuota");
		} catch (Exception e) {
			logger.debug("tbl_usermaster mailBoxQuota doesn't exist. creating the column...");
			
			update("EzCommonDAO.addUserMasterMailBoxQuota");
		}
	}
	
	public void addHolidayFlag() {
		try {
			select("EzCommonDAO.checkHolidayFlag");
		} catch (Exception e) {
			logger.debug("tbl_holidayList HolidayFlag doesn't exist. creating the column...");
			
			update("EzCommonDAO.addHolidayFlag");
		}
	}
	
	public void addHolidayRepeat() {
		try {
			select("EzCommonDAO.checkHolidayRepeat");
		} catch (Exception e) {
			logger.debug("tbl_holidayList HolidayRepeat doesn't exist. creating the column...");
			
			update("EzCommonDAO.addHolidayRepeat");
		}
	}
	
	public void createPortalThemePortlet() {
		try {
			select("EzCommonDAO.checkPortalThemePortlet");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme_portlet doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblPortalThemePortlet");
		}
	}

	public void insertPortalThemePortletInitdata() {
		// TODO Auto-generated method stub

		//insert init data
		List<OrganDeptVO> initList = ezNewPortalDAO.getInitCompanyList();
		
		if (initList != null ) {
			int initListCount = initList.size();
			
			for (int i = 0; i < initListCount; i++) {
				int tenantId = initList.get(i).getTenantId();
				String companyId = initList.get(i).getCn();
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("tenantID", tenantId);
				map.put("companyID", companyId);
				
				try {
					ezOrganAdminDAO.insertCompanyInfo_I30(map);
				} catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		}
	}
	
	public void addJournalFormDelFlag() {
		try {
			select("EzCommonDAO.checkJournalFormDelFlag");
		} catch (Exception e) {
			logger.debug("tbl_journal_form JournalFormDelFlag doesn't exist. creating the column...");
			
			update("EzCommonDAO.addJournalFormDelFlag");
		}
	}

	public void updateTaskUrl() {
		try {
			String taskUrl = select("EzCommonDAO.checkTaskUrl").toString();
			
			if (taskUrl == null) {
				logger.debug("Task url has to update... update task module url...");
				
				update("EzCommonDAO.updateTaskUrl");
			}
		} catch (Exception e) {
			logger.debug("Task url has to update... update task module url...");
			
			update("EzCommonDAO.updateTaskUrl");
		}
	}

	public void addPortalPortletUserPortletUsed() {
		try {
			select("EzCommonDAO.checkAddPortalPortletUserPortletUsed");
		} catch (Exception e) {
			logger.debug("tbl_portal_portlet_user portlet_used doesn't exist. creating the column...");
			
			update("EzCommonDAO.addPortalPortletUserPortletUsed");
		}
		
	}

	public void addPortalPortletUserThemeId() {
		try {
			select("EzCommonDAO.checkPortalPortletUserThemeId");
		} catch (Exception e) {
			logger.debug("tbl_portal_portlet_user theme_id doesn't exist. creating the column...");
			
			update("EzCommonDAO.addPortalPortletUserThemeId");
			update("EzCommonDAO.deletePortalPortletUserPrimaryKey");
			update("EzCommonDAO.addPortalPortletUserPrimaryKey");
		}
	}
	
	public void addTblPortalThemeUserIsDefault() {
		try {
			select("EzCommonDAO.checkAddTblPortalThemeUserIsDefault");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme_user is_default doesn't exist. creating the column...");
			
			update("EzCommonDAO.addTblPortalThemeUserIsDefault");
		}
	}
	
	public void updateListOptionData() {
		try {
			if ((int) select("EzCommonDAO.checkListOptionData1") > 0) {
				update("EzCommonDAO.updateListOptionData1");
			}
			if ((int) select("EzCommonDAO.checkListOptionData2") > 0) {
				update("EzCommonDAO.updateListOptionData2");
			}
		} catch (Exception e) {
			logger.debug("updateListOptionData() ERROR...");
			e.printStackTrace();
		}
	}

	public void addQuickLinkLinkOrder() {
		try {
			select("EzCommonDAO.checkQuickLinkLinkOrder");
		} catch (Exception e) {
			logger.debug("tbl_ps_quicklink linkorder doesn't exist. creating the column...");
			
			update("EzCommonDAO.addQuickLinkLinkOrder");
		}
	}

	public void addComCloseCompanyId() {
		try {
			select("EzCommonDAO.checkComCloseCompanyId");
		} catch (Exception e) {
			logger.debug("tbl_c_comclose companyid doesn't exist. creating the column...");
			
			update("EzCommonDAO.addComCloseCompanyId");
		}
	}

	public void addWebfolderTotalLimit() {
		try {
			select("EzCommonDAO.checkWebfolderTotalLimit");
		} catch (Exception ex) {
			logger.debug("tbl_webfolder_config company_total_limit, department_total_limit, user_total_limit doesn't exist. creating the column...");
			
			if (dbType.equalsIgnoreCase("oracle")) {
				// rename column
				update("EzCommonDAO.renameWebfolderConfigTotalLimit");
				// add column
				update("EzCommonDAO.addWebfolderConfigTotalLimit");
			} else {
				update("EzCommonDAO.createWebfolderConfigTotalLimit");
			}
		}
		
		try {
			select("EzCommonDAO.checkWebfolderUserCnType");
		} catch (Exception ex) {
			logger.debug("tbl_webfolder_user type doesn't exist. creating the column...");
			
			if (dbType.equalsIgnoreCase("oracle")) {
				// add nullable column
				update("EzCommonDAO.addWebfolderUserCnTypeColumn");
				// update all rows type = 'U'
				update("EzCommonDAO.updateWebfolderUserCnType");
				// modify nullable to not null
				update("EzCommonDAO.modifyWebfolderUserCnTypeColumn");
				// primary key change
				update("EzCommonDAO.dropWebfolderUserPrimaryKey");
				update("EzCommonDAO.addWebfolderUserPrimaryKey");
			} else {
				update("EzCommonDAO.createWebfolderUserCnTypeColumn");
				update("EzCommonDAO.updateWebfolderUserCnType");
			}
		}
	}

	public void addMemoExtensionColumns() {
		try {
			select("EzCommonDAO.checkExtensionColumns");
		} catch (Exception e) {
			logger.debug("tbl_memo_config addMemoextensionColumns doesn't exist. creating the column...");
			
			update("EzCommonDAO.addMemoExtensionColumns");
		}
	}
		
	public void addMsgInMailSearch() {
		try {
			if ((int) select("EzCommonDAO.checkMsgInMailSearch") == 0) {
				update("EzCommonDAO.updateMsgInMailSearch");
			}
		} catch (Exception e) {
			logger.debug("addMsgInMailSearch() ERROR...");
			e.printStackTrace();
		}
	}

	public void addFormVersion() {
		try {
			select("EzCommonDAO.checkFormVersionColumnOfForminfo");
		} catch (Exception e) {
			logger.debug("tbl_forminfo formVersion doesn't exist. creating the column...");
			update("EzCommonDAO.addFormVersionColumnOfForminfo");
		}
		try {
			select("EzCommonDAO.checkFormVersionColumnOfExpendaprdocinfo");
		} catch (Exception e) {
			logger.debug("tbl_expendaprdocinfo formVersion doesn't exist. creating the column...");
			update("EzCommonDAO.addFormVersionColumnOfExpendaprdocinfo");
		}
		try {
			select("EzCommonDAO.checkFormVersionColumnOfExpaprdocinfo");
		} catch (Exception e) {
			logger.debug("tbl_expaprdocinfo formVersion doesn't exist. creating the column...");
			update("EzCommonDAO.addFormVersionColumnOfExpaprdocinfo");
		}
		try {
			select("EzCommonDAO.checkFormVersionColumnOfTmpexpaprdocinfo");
		} catch (Exception e) {
			logger.debug("tbl_tmpexpaprdocinfo formVersion doesn't exist. creating the column...");
			update("EzCommonDAO.addFormVersionColumnOfTmpexpaprdocinfo");
		}
	}
	
	public void createTblAttitudeAnnual() throws Exception {
		try {
			select("EzCommonDAO.checkTblAttitudeAnnual");
		} catch (Exception e) {
			logger.debug("tbl_attitude_annual doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblAttitudeAnnual");
		}
	}
	
	public void createTblAttitudeAnnualCanappl() throws Exception {
		try {
			select("EzCommonDAO.checkTblAttitudeAnnualCanappl");
		} catch (Exception e) {
			logger.debug("tbl_attitude_annual_canappl doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblAttitudeAnnualCanappl");
		}
	}
	
	public void createTblAttitudeAnnualConf() throws Exception {
		try {
			select("EzCommonDAO.checkTblAttitudeAnnualConf");
		} catch (Exception e) {
			logger.debug("tbl_attitude_annual_conf doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblAttitudeAnnualConf");
		}
	}
	
	public void createTblAttitudeAnnualHistory() throws Exception {
		try {
			select("EzCommonDAO.checkTblAttitudeAnnualHistory");
		} catch (Exception e) {
			logger.debug("tbl_attitude_annual_history doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblAttitudeAnnualHistory");
		}
	}
	
	public void createTblAttitudeAprConn() throws Exception {
		try {
			select("EzCommonDAO.checkTblAttitudeAprConn");
		} catch (Exception e) {
			logger.debug("tbl_attitude_apr_conn doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblAttitudeAprConn");
		}
	}

	public void addThemeContent2() {
		try {
			select("EzCommonDAO.checkThemeContent2");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme themeContent2 doesn't exist. creating the column...");
			
			update("EzCommonDAO.addThemeContent2");
			update("EzCommonDAO.insertThemeContent2");
		}
	}

	public void addThemeContent3() {
		try {
			select("EzCommonDAO.checkThemeContent3");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme themeContent3 doesn't exist. creating the column...");
			
			update("EzCommonDAO.addThemeContent3");
			update("EzCommonDAO.insertThemeContent3");
		}
	}

	public List<CountryVO> getCountryInfo(Map<String, Object> map) throws Exception {
		return (List<CountryVO>) list("EzCommonDAO.getCountryInfo",map);
	}

	public void createTblAccessCountry() throws Exception {
		try {
			select("EzCommonDAO.checkTblAccessCountry");
		} catch (Exception e) {
			logger.debug("tbl_Access_Country doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblAccessCountry");
		}
	}
	
	public void addSnMenuAuth() {
		try {
			select("EzCommonDAO.checkSnMenuAuth");
		} catch (Exception e) {
			logger.debug("tbl_portal_menu_auth sn doesn't exist. creating the column...");
			
			update("EzCommonDAO.snMenuAuth");
		}
	}
}
