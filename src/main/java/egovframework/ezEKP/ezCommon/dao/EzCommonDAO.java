package egovframework.ezEKP.ezCommon.dao;

import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Optional;
import java.util.Properties;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezCommon.vo.CompanyInfoVO;
import egovframework.ezEKP.ezCommon.vo.TblColumnsInfoVO;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.dao.EzNewPortalDAO;
import egovframework.ezEKP.ezNewPortal.vo.PortalTopVO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezSystem.vo.CountryVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.user.login.vo.TenantServerNameVO;
import egovframework.let.user.login.vo.TenantVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;

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

    @Autowired
	private Properties globals;
    
	public ApprovPWDVO getApprovPWD(LoginVO userInfo) throws Exception {
		return (ApprovPWDVO) select("EzCommonDAO.getApprovPWD", userInfo);
	}
	
	public String getContentInfo(Map<String, Object> map) throws Exception {
		return (String) select("EzCommonDAO.getContentInfo", map);
	}
	
	public void createTblSession() throws Exception {
		try {
			select("EzCommonDAO.checkTblSession");
		} catch (Exception e) {
			logger.debug("tbl_session doesn't exist. creating the table...");

			update("EzCommonDAO.createTblSession");
		}
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

	public String getAnyTblAnyColumns(Map<String, Object> map) throws Exception{
		return (String) select("EzCommonDAO.getAnyTblAnyColumns", map);
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
//	    insertTblUserLocalInfoForJMocha(map);
	    
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
//	    deleteUserLocalInfoForJMocha(map);
	    
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
	
	public int checkHasUserConfigProperty(Map<String, Object> map) throws Exception {
		return (int) select("EzCommonDAO.checkHasUserConfigProperty", map);
	}

	public int updateUserConfigInfo(Map<String, Object> map) throws Exception {
		return update("EzCommonDAO.updateUserConfigInfo", map);
	}
	
	public void insertUserConfigInfo(Map<String, Object> map) throws Exception {
		insert("EzCommonDAO.insertUserConfigInfo", map);
	}

	public void deleteUserConfigInfo(Map<String, Object> map) throws Exception {
		delete("EzCommonDAO.deleteUserConfigInfo", map);
	}
	
	public void deleteMultiLoginUser(Map<String, Object> map) throws Exception {
		update("EzCommonDAO.deleteMultiLoginUser", map);
	}
	
	public String selectMultiLoginUser(Map<String, Object> map) throws Exception {
		return (String) select("EzCommonDAO.selectMultiLoginUser", map);
	}
	
	public boolean getPermissionGroupAccessYN(Map<String, Object> map) throws Exception {
		int permit = (int) select("EzCommonDAO.getPermissionGroupAccessYN", map);
		
		if (permit > 0) {
			return true;
		} else {
			if (map.get("applySubDeptYN").toString().equals("true")) {
				permit = (int) select("EzCommonDAO.getPermissionGroupAccessSubDeptY", map);
				
				if (permit > 0) {
					return true;
				}
			}
		}
		
		return false;
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
	
	/* 2022-01-19 김은실 - alter 재사용 모듈 추가 */
	public void alterTableAddColumns(Map<String, Object> map) throws Exception {
		try {
			select("EzCommonDAO.alterTableCheckColumn", map);

		} catch (Exception e) {
			String column = (String) map.get("COLUMN");
			logger.debug("{} {} column doesn't exist. creating the column...", map.get("TABLE"), (column != null)? column : map.get("COLUMN_MYSQL"));

			update("EzCommonDAO.alterTableAddColumn", map);

			// 1. PRIMARY 수정이 필요한 경우
			String primary = (String) map.get("PRIMARY");

			if (StringUtils.isNotBlank(primary)) {
				update("EzCommonDAO.alterTableDropPrimary", map);

				String constraint = (String) map.get("CONSTRAINT"); // CONSTRAINT NAME : PRIMARY KEY를 생성하는 데에 꼭 필요치는 않다.
				logger.debug("CONSTRAINT={} PRIMARY KEY={}", constraint, primary);

				if (StringUtils.isNotBlank(constraint)) {
					/**
					 * ALTER TABLE $TBL_NAME$ ADD CONSTRAINT $제약조건이름$ PRIMARY KEY(...); 으로 생성한 경우를 제외하고
					 * 혹시나
					 * 1. CREATE UNIQUE INDEX $제약조건이름$ ON $TBL_NAME$ (...);
					 * 2. ALTER TABLE $TBL_NAME$ ADD CONSTRAINT $제약조건이름$ PRIMARY KEY(...); 와 같이
					 * PRIMARY KEY 와 INDEX 를 각각 생성한 경우 INDEX $제약조건이름$ 을 따로 DROP 해주는 과정이 필요하다.
					 * 만약 같은 이름의 인덱스가 이미 있다면 drop할 것이고, 해당 이름의 인덱스가 없다면 Exception 발생하며 그냥 지나가면 된다.
					 */
					try { update("EzCommonDAO.alterTableDropIndex", map); } catch (Exception none) {}
				}

				update("EzCommonDAO.alterTableAddPrimary", map);
			}

			// 2. 초기 데이터 업데이트가 필요한 경우
			String update = (String) map.get("UPDATE");

			if (StringUtils.isNotBlank(update)) {
				logger.debug("UPDATE={}", update);

				update("EzCommonDAO.alterTableInitData", map);
			}
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
	
	public void createPortalThemePortlet() {
		try {
			select("EzCommonDAO.checkPortalThemePortlet");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme_portlet doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblPortalThemePortlet");
		}
	}

	public void insertPortalThemePortletInitdata() {
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
					logger.error(e1.getMessage(), e1);
				}
			}
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

	public void createJmochaMailCopyright() {
		try {
			select("EzCommonDAO.checkJmochaMailCopyright");
		} catch (Exception e) {
			logger.debug("jmocha_mail_copyright doesn't exist. creating the table...");
			
			update("EzCommonDAO.createJmochaMailCopyright");
		}
	}

	public void createJamesMailDeletedId() {
		try {
			select("EzCommonDAO.checkJamesMailDeletedId");
		} catch (Exception e) {
			logger.debug("james_mail_deleted_id doesn't exist. creating the table...");
			
			update("EzCommonDAO.createJamesMailDeletedId");
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
			logger.error(e.getMessage(), e);
		}
	}
	
	public void createBoardLike() throws Exception {
		try {
			select("EzCommonDAO.checkTblBoardLike");
		} catch (Exception e) {
			logger.debug("tbl_board_like doesn't exist. creating the table...");
			
			update("EzCommonDAO.createBoardLike");
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
	
	public void createTblResourcePortlet() throws Exception {
		try {
			select("EzCommonDAO.checkResourcePortlet");
		} catch (Exception e) {
			logger.debug("tbl_rs_persportlet doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblResourcePortlet");
		}
	}

	public void insertSurveyTenantConfig(Map<String, Object> map) throws Exception{
		String propertyValue = (String) select("EzCommonDAO.checkSurveyTenantConfig");
		
		if (propertyValue == null) {
			logger.debug("survey tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertSurveyTenantConfig",map);
		}
	}

	@SuppressWarnings("unchecked")
	public List<CompanyInfoVO> getAllCompanyIds() {
		return (List<CompanyInfoVO>) list("EzCommonDAO.getAllCompanyIds");
	}
	
	public void insertPortletInfo(Map<String, Object> map) {
		String url = checkPortlet(map);

		if (url == null) {
			try {
					insert("EzCommonDAO.insertPortlet",map);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
	}
	
	private String checkPortlet(Map<String, Object> map) {
		return (String) select("EzCommonDAO.checkPortlet", map);
	}
	
	public void insertRsPortletInfo(Map<String, Object> map) {
		String companyId = checkPortletForComapny(map);

		if (companyId == null) {
			try {
				logger.debug("insert resource portlet data");
				insert("EzCommonDAO.insertPortletComp",map);
				insert("EzCommonDAO.insertRsPortletName",map);
				insert("EzCommonDAO.insertPortalThemePortlet",map);
				insert("EzCommonDAO.insertPortalPortletAuth",map);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
		
	}
	
	public void insertWfPortletInfo(Map<String, Object> map) {
		String companyId = checkPortletForComapny(map);
		
		if (companyId == null) {
			try {
				logger.debug("insert webfolder portlet data");
				insert("EzCommonDAO.insertPortletComp",map);
				insert("EzCommonDAO.insertWfPortletName",map);
				insert("EzCommonDAO.insertPortalThemePortlet",map);
				insert("EzCommonDAO.insertPortalPortletAuth",map);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
		
	}
	
	public void insertSvPortletInfo(Map<String, Object> map) {
		String companyId = checkPortletForComapny(map);
		
		try {
			if (companyId == null) {
				logger.debug("insert survey portlet data");
				insert("EzCommonDAO.insertPortletComp",map);
				insert("EzCommonDAO.insertSvPortletName",map);
				insert("EzCommonDAO.insertPortalThemePortlet",map);
				insert("EzCommonDAO.insertPortalPortletAuth",map);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
	}
	
	private String checkPortletForComapny(Map<String, Object> map) {
		return (String) select("EzCommonDAO.checkPortletForComapny", map);
	}

	public void createTblThemeAuth() {
		try {
			select("EzCommonDAO.checkTblThemeAuth");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme_auth doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblThemeAuth");
			
			List<OrganDeptVO> initList = ezNewPortalDAO.getInitCompanyListThemeAuth();
			
			if (initList != null ) {
				int initListCount = initList.size();
				logger.debug("initListCount : " + initListCount);
				
				for (int i = 0; i < initListCount; i++) {
					int tenantId = initList.get(i).getTenantId();
					String companyId = initList.get(i).getCn();
					
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("tenantID", tenantId);
					map.put("companyID", companyId);
					
					try {
						ezOrganAdminDAO.insertCompanyInfo_I31(map);
					} catch (Exception e1) {
						logger.error(e1.getMessage(), e1);
					}
				}
			}
		}
	}

	public void createTblPortletAuth() {
		try {
			select("EzCommonDAO.checkTblPortletAuth");
		} catch (Exception e) {
			logger.debug("tbl_portal_portlet_auth doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblPortletAuth");
			
			List<OrganDeptVO> initList = ezNewPortalDAO.getInitCompanyListPortletAuth();
			
			if (initList != null ) {
				int initListCount = initList.size();
				logger.debug("initListCount : " + initListCount);
				
				for (int i = 0; i < initListCount; i++) {
					int tenantId = initList.get(i).getTenantId();
					String companyId = initList.get(i).getCn();
					
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("tenantID", tenantId);
					map.put("companyID", companyId);
					
					try {
						ezOrganAdminDAO.insertCompanyInfo_I32(map);
					} catch (Exception e1) {
						logger.error(e1.getMessage(), e1);
					}
				}
			}
		}
	}

	public void addMenuCode() {
		try {
			select("EzCommonDAO.checkMenuCode");
		} catch (Exception e) {
			logger.debug("tbl_portal_menu menucode doesn't exist. creating the column...");
			
			update("EzCommonDAO.addMenuCode");
			update("EzCommonDAO.updateMenuCode");
		}
	}
	
	public void addPortletCode() {
		try {
			select("EzCommonDAO.checkPortletCode");
		} catch (Exception e) {
			logger.debug("tbl_portal_portlet portletcode doesn't exist. creating the column...");
			
			update("EzCommonDAO.addPortletCode");
			update("EzCommonDAO.updatePortletCode");
		}
	}
	
	@SuppressWarnings("unchecked")
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
	
	public void createPersonalPopupUser() {
		try {
			select("EzCommonDAO.checkTblPsPopupUser");
		} catch (Exception e) {
			logger.debug("tbl_ps_popup_user doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblPsPopupUser");
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<LoginVO> getPermissionGroupMembers(Map<String, Object> map) throws Exception {
		return (List<LoginVO>) list("EzCommonDAO.getPermissionGroupMembers", map);
	}

	public void alterChamjoView() {
		try {
			if ((int) select("EzCommonDAO.checkAlterChamjoView") <= 0) {
				update("EzCommonDAO.alterAprDoingView");
				update("EzCommonDAO.alterChamjoView");
			}
		} catch (Exception e) {
			logger.debug("alterChamjoView() ERROR...");
			logger.error(e.getMessage(), e);
		}
	}
	
	public void addAddressFurigana() {
		try {
			select("EzCommonDAO.checkAddressFurigana"); 
		} catch (Exception e) {
			update("EzCommonDAO.addAddressFurigana");
			logger.debug("JMOCHA_ADDRESS_INFO S_FURIGANA doesn't exist. creating the column...");
			logger.error(e.getMessage(), e);
		}
	}

	public void createOpenGovTable() throws Exception {
		try {
			select("EzCommonDAO.checkTblOpenGovDocInfo");
		} catch (Exception e) {
			logger.debug("tbl_opengovdocinfo doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblOpenGovDocInfo");
		}
		
		try {
			select("EzCommonDAO.checkTblOpenGovfileInfo");
		} catch (Exception e) {
			logger.debug("tbl_opengovfileinfo doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblOpenGovFileInfo");
		}
	}
	
	public int checkDeptId(Map<String, Object> map) {
		return (int) select("EzCommonDAO.checkDeptId", map);
	}

	public void createRsFavoriteTable() {
		try {
			if (globals.getProperty("Globals.DbType").equals("oracle")) {
				select("EzCommonDAO.checkTblRsFavorite");
			}
		} catch (Exception e) {
			logger.debug("tbl_rs_favorite doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblRsFavorite");
		}
	}

	public void createUserDistributionTable() {
		Map<String, String> map = new HashMap<>();
		
		map.put("EzCommonDAO.checkUserDlTable", "EzCommonDAO.createUserDlTable");
		map.put("EzCommonDAO.checkUserDlMemberTable", "EzCommonDAO.createUserDlMemberTable");
		map.put("EzCommonDAO.checkUserDlApplyTable", "EzCommonDAO.createUserDlApplyTable");
		
		for (Entry<String, String> entry : map.entrySet()) {
			try {
				select(entry.getKey());
			} catch (Exception e) {
				String keyVal = entry.getValue();
				logger.debug("{} started.", keyVal);
				
				try {
					update(keyVal);
				} catch (Exception ex) {
					// oracle 11g xe 오류
					if (ex.getMessage().contains("ORA-00972")) {
						logger.debug("{} skip, cause=oracle 11g xe error: {}", keyVal, ex.getMessage());
					} else {
						logger.error(ex.getMessage(), ex);
					}
				}
			}

		}
	}
			
	public void insertTblTenantConfig(Map<String, Object> map) {
		try {
			if (getTenantConfig(map) == null) {throw new Exception(); }
		} catch (Exception e) {
			logger.debug("tbl_tenant_config. add config...");
			insertUseSession(map);
		}
	}

	public void insertThemeAuthInit(Map<String, Object> map) {
		String companyId = checkThemeAuthInit(map);
		
		try {
			if (companyId == null) {
				logger.debug("tbl_theme_auth data doesn't exist. insert the data of " + map.get("companyId") + "...");
				insert("EzCommonDAO.insertThemeAuthInit", map);
			}
			// 2024-07-12 황인경 - 모바일 포탈 > 회사별 테마 권한 init 추가
			if ((int)select("EzCommonDAO.checkMobileThemeInitAuth", map) < 1) {
				logger.debug("tbl_theme_auth MobileFrameInitAuth doesn't exist. insert the data of " + map.get("companyId") + "...");
				insert("EzCommonDAO.insertMobileThemeInitAuth", map);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
	}
	
	public String checkThemeAuthInit(Map<String, Object> map) {
		return (String) select("EzCommonDAO.checkThemeAuthInit", map);
	}
	
	public void insertPortletAuthInit(Map<String, Object> map) {
		String companyId = checkPortletAuthInit(map);
		
		try {
			if (companyId == null) {
				logger.debug("tbl_portlet_auth data doesn't exist. insert the data of " + map.get("companyId") + "...");
				insert("EzCommonDAO.insertPortletAuthInit", map);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	public String checkPortletAuthInit(Map<String, Object> map) {
		return (String) select("EzCommonDAO.checkPortletAuthInit", map);
	}

	public String checkSurveyMenu() {
		return (String) select("EzCommonDAO.checkSurveyMenu");
	}

	public void insertSurveyMenu() {
		try {
			insert("EzCommonDAO.insertSurveyMenu");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}

	public void insertSurveyMenuInfo(Map<String, Object> map) {
		try {
			insert("EzCommonDAO.insertSurveyMenuComp", map);
			insert("EzCommonDAO.insertSurveyMenuAuth", map);
			insert("EzCommonDAO.insertSurveyMenuName", map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	/**
	 * 오라클 11g에서는 30 글자를 넘어가는 테이블을 생성할 수 없는데, 30자를 넘어가던 해당 테이블을 30자 이내로 변경하는 코드가 들어간다.<br>
	 * CREATE 또는 RENAME 으로 동작한다.
	 */
	public void createJmochaBigAttachDownloadLimit() throws Exception {
		try {
			select("EzCommonDAO.checkJmochaBigAttachDownloadLimit_new");
		} catch (Exception e) {
			try {
				select("EzCommonDAO.checkJmochaBigAttachDownloadLimit_old");

				logger.debug("jmocha_bigattach_download_limit already exist. table name has been changed to jmocha_bigattach_down_limit...");

				update("EzCommonDAO.renameJmochaBigAttachDownloadLimitToNew");
			} catch (Exception e2) {
				logger.debug("jmocha_bigattach_down_limit doesn't exist. creating the table...");

				update("EzCommonDAO.createJmochaBigAttachDownloadLimit");
			}
		}
	}

	public void insertMailBigSizeAttachLimit() throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkMailBigSizeAttachLimitTenantConfig");
		
		if (propertyValue == null) {
			logger.debug("mail big size attach limit tenant config doesn't exist. insert data...");
			update("EzCommonDAO.insertMailBigSizeAttachLimit");
		}
	}
		
	public void createPwPolicyTable() throws Exception {
		try {
			select("EzCommonDAO.checkPwPolicy");
		} catch (Exception e) {
			logger.debug("tbl_password_policy doesn't exist. creating the table...");
			
			update("EzCommonDAO.createPwPolicy");
		}
	}

	public void createPwPolicyPatternTable() throws Exception {
		try {
			select("EzCommonDAO.checkPwPolicyPattern");
		} catch (Exception e) {
			logger.debug("tbl_password_policy_Pattern doesn't exist. creating the table...");
			
			update("EzCommonDAO.createPwPolicyPattern");
		}
	}
	
	public void createTblShareDocDir() throws Exception {
		try {
			select("EzCommonDAO.checkTblShareDocDir");
		} catch (Exception e) {
			logger.debug("tbl_share_doc_dir doesn't exist. creating the table...");
			update("EzCommonDAO.createTblShareDocDir");
		}
	}
	
	public void insertUseExternalMailServerConfig(Map<String, Object> map) throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkMailTenantConfig");
		
		if (propertyValue == null) {
			logger.debug("useExternalMailServer tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertSurveyTenantConfig",map);
		}
	}
	
	public void createAdminAccessIpTable() throws Exception {
		try {
			select("EzCommonDAO.checkTblAdminAccessIpTable");
		} catch (Exception e) {
			logger.debug("tbl_admin_access_ip table doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblAdminAccessIpTable");
			
			if (dbType.equalsIgnoreCase("oracle") || dbType.equalsIgnoreCase("tibero")) {
				try {
					int cnt = (int) select("EzCommonDAO.checkTblAdminAccessIpSequence");
					if (cnt < 1) {throw new Exception(); }
				} catch (Exception ee) {
					// logger.error(ee.getMessage(), ee);
					logger.debug("TBL_ADMIN_ACCESS_IP Sequence doesn't exist. creating the Sequence...");
					
					update("EzCommonDAO.createTblAdminAccessIpSequence");
				}
			}
		}
	}

	public void insertReBebuOpinionCode(Map<String, Object> map) {
		String companyId = checkReBebuOpinionCode(map);
		
		try {
			if (companyId == null) {
				logger.debug("ReBebuOpinionCode data doesn't exist. insert the data of " + map.get("companyId") + "...");
				insert("EzCommonDAO.insertReBebuOpinionCode", map);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
	}
	
	public String checkReBebuOpinionCode(Map<String, Object> map) {
		return (String) select("EzCommonDAO.checkReBebuOpinionCode", map);
	}

	public void insertAnnualScheduleTenantConfig(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkAnnualScheduleTenantConfig");
		
		if (propertyValue == null) {
			logger.debug("useAnnualScheduleYN tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertAnnualScheduleTenantConfig",map);
		}
	}

	public void insertHalfOffAttitudeType(Map<String, Object> map) {
		String companyId = (String) select("EzCommonDAO.checkHalfOffAttitudeTypeForCompany", map);

		if (companyId == null) {
			logger.debug("attitude_type 'half off' doesn't exist. insert data...");
			insert("EzCommonDAO.insertHalfOffAttitudeType",map);
		}
	}

	public void insertHolidayCheckTenantConfig(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkHolidayCheckTenantConfig");
		
		if (propertyValue == null) {
			logger.debug("useHolidayCheckYN tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertHolidayCheckTenantConfig",map);
		}
	}

	public void createAprAttachLimit() {
		try {
			select("EzCommonDAO.checkAprAttachLimit");
		} catch (Exception e) {
			logger.debug("tbl_aprattachlimit doesn't exist. creating the table...");
			
			update("EzCommonDAO.createAprAttachLimit");
		}
	}

	public void insertAlternateHolidayAttitudeType(Map<String, Object> map) {
		String companyId = (String) select("EzCommonDAO.checkAlternateHolidayAttitudeTypeForCompany", map);

		if (companyId == null) {
			logger.debug("attitude_type 'alternate holiday' doesn't exist. insert data...");
			insert("EzCommonDAO.insertAlternateHolidayAttitudeType",map);
		}
	}

	public void insertBeforeOutComeAttitudeType(Map<String, Object> map) {
		String companyId = (String) select("EzCommonDAO.checkBeforeOutComeAttitudeTypeForCompany", map);

		if (companyId == null) {
			logger.debug("attitude_type_id 'A25' doesn't exist. insert data...");
			insert("EzCommonDAO.insertBeforeOutComeAttitudeType",map);
		}
	}
	
	public void insertMobileAttitudeColumn() throws Exception {
		try {
			select("EzCommonDAO.checkMobileAttitudeColumn");
		} catch (Exception e) {
			logger.debug("tbl_attitude attend_type column doesn't exist. creating the column...");
			
			update("EzCommonDAO.createMobileAttitudeColumn");
		}
	}
	
	public void createTblNoticeBoard() {
		try {
			select("EzCommonDAO.checkTblNoticeBoard");
		} catch (Exception e) {
			logger.debug("tbl_board_noticeboard doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblNoticeBoard");
		}
	}
	
	public void insertMobileAttitudeConfig(Map<String, Object> map) throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkMobileAttitudeConfig", map);
		
		if (propertyValue == null) {
			logger.debug("USE_MATTITUDE tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertSurveyTenantConfig", map);
		}
	}
	
	public void insertAttitudeGPSConfig(Map<String, Object> map) throws Exception {
		//2023-09-12 김대현 attitudeMapApiKey값은 사용하지 않으면 null이기 때문에 property_name을 return시킴
		String propertyValue = (String) select("EzCommonDAO.checkAttitudeGPSConfig", map);
		
		if (propertyValue == null) {
			logger.debug("attitudeMapApiKey tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertSurveyTenantConfig", map);
		}
	}

	public void createMenuTenantConfig(Map<String, Object> map) throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkTenantConfig", map);
		
		if (propertyValue == null) {
			logger.debug("menu tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertSurveyTenantConfig", map);
		}
	}

   public void addScehdulegroup() {
	   try {
		   select("EzCommonDAO.addScehdulegroup");
	   } catch (Exception e) {
		   logger.debug("tbl_schedulegroup MODIFYDATE, PRECREATORID, PRECREATORNAME, PRECCREATORNAME2 column doesn't exist. creating the column...");
		   
		   update("EzCommonDAO.updateScehdulegroup");
	   }
   }
   
   public void insertAutoSendOfferFlag() {
       try {
           int rowCnt = (int) select("EzCommonDAO.checkAutoSendOfferFlag");
           if (rowCnt == 0) {
               logger.debug("tbl_tenant_config autoSendOfferFlag data doesn't exist. creating the data...");
               insert("EzCommonDAO.insertAutoSendOfferFlag");
           }
       } catch (Exception e) {
           logger.error(e.getMessage(), e);
       }
   }

   public void createTblTabBoard() {
		try {
			select("EzCommonDAO.checkTblTabBoard");
		} catch (Exception e) {
			logger.debug("tbl_board_tabboard doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblTabBoard");
		}
	}
	
	public int checkPortletCodeString(String code) {
		return (int) select("EzCommonDAO.checkPortletCodeString", code);
	}

	public void insertTabBoardPortletInfo(Map<String, Object> map) {
		String companyId = checkPortletForComapny(map);

		if (companyId == null) {
			try {
				logger.debug("insert TabBoard portlet data");
				insert("EzCommonDAO.insertPortletComp",map);
				insert("EzCommonDAO.insertPortletName",map);
				insert("EzCommonDAO.insertPortalThemePortlet",map);
				insert("EzCommonDAO.insertPortalPortletAuth",map);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}

	}

	public int getNewPortletId() {
		return (int) select("EzCommonDAO.getNewPortletId");
	}
	// 2020-12-04 포틀릿 코드도 같이 추가하는 로직 추가 - 박기범
	public void insertPortletWithCode(Map<String, Object> map) {
		String url = checkPortlet(map);

		if (url == null) {
			try {
					insert("EzCommonDAO.insertPortletWithCode",map);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
	}

	// 전자결재 대용량첨부 관련 컨피그 5개
	public void insertApprBigAttachConfig(Map<String, Object> map) {
		String apprAttachLimit = (String) select("EzCommonDAO.getApprAttachLimit", map);
		if (apprAttachLimit == null) {
			logger.debug("apprAttachLimit tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertApprAttachLimit", map);
		}

		String bigSizeApprAttachLimit = (String) select("EzCommonDAO.getBigSizeApprAttachLimit", map);
		if (bigSizeApprAttachLimit == null) {
			logger.debug("bigSizeApprAttachLimit tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertBigSizeApprAttachLimit", map);
		}

		String apprBigSizeAttachDownloadLimitCount = (String) select("EzCommonDAO.getApprBigSizeAttachDownloadLimitCount", map);
		if (apprBigSizeAttachDownloadLimitCount == null) {
			logger.debug("apprBigSizeAttachDownloadLimitCount tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertApprBigSizeAttachDownloadLimitCount", map);
		}

		String apprBigSizeAttachLimitCount = (String) select("EzCommonDAO.getApprBigSizeAttachLimitCount", map);
		if (apprBigSizeAttachLimitCount == null) {
			logger.debug("apprBigSizeAttachLimitCount tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertApprBigSizeAttachLimitCount", map);
		}

		String bigSizeApprAttachDelDay = (String) select("EzCommonDAO.getBigSizeApprAttachDelDay", map);
		if (bigSizeApprAttachDelDay == null) {
			logger.debug("apprAttachLimit tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertBigSizeApprAttachDelDay", map);
		}
	}

	// 전자결재 대용량첨부 관련 컬럼 3개
	public void addApprBigAttachColumn() {
        try {
            select("EzCommonDAO.checkApprBigAttachColumn_APR");
        } catch (Exception e) {
            logger.debug("tbl_aprattachinfo ISBIGATTACH, ISBIGATTACHDEL, SAVEDATE column doesn't exist. creating the column...");
            update("EzCommonDAO.updateApprBigAttachColumn_APR");
        }
        try {
            select("EzCommonDAO.checkApprBigAttachColumn_END");
        } catch (Exception e) {
            logger.debug("tbl_endattachinfo ISBIGATTACH, ISBIGATTACHDEL, SAVEDATE column doesn't exist. creating the column...");
            update("EzCommonDAO.updateApprBigAttachColumn_END");
        }
        try {
            select("EzCommonDAO.checkApprBigAttachColumn_TMP");
        } catch (Exception e) {
            logger.debug("tbl_tmpattachinfo ISBIGATTACH, ISBIGATTACHDEL, SAVEDATE column doesn't exist. creating the column...");
            update("EzCommonDAO.updateApprBigAttachColumn_TMP");
        }
	}

	// 전자결재 대용량첨부 관련 TBL_APRBIGATTACH_DOWNLOADINFO 테이블
	public void createApprBigAttachTable() {
		try {
			select("EzCommonDAO.checkApprBigAttachTable");
		} catch (Exception e) {
			logger.debug("TBL_APRBIGATTACH_DOWNLOADINFO doesn't exist. creating the table...");
			update("EzCommonDAO.createApprBigAttachTable");
		}
	}
	
	// 일정관리 알림메일 기능 추가
	public void addScheduleMailNotiConfig() {
	   try {
		   select("EzCommonDAO.checkScheduleMailNotiConfig");
	   } catch (Exception e) {
		   logger.debug("tbl_scheduleconfig InvitationMail, CancellationMail, AttendanceMail, RejectedMail column doesn't exist. creating the column...");
		   
		   update("EzCommonDAO.updateScheduleMailNotiConfig");
	   }
    }
	
	//전자결재 양식별문서함, 분류코드문서함 컨피그 추가
	public void insertApprContainterConfig(Map<String, Object> map) {
		map.put("property", "USEAPPRFORMCONT");
		String useApprFormCont = (String) select("EzCommonDAO.getTenantConfig", map);
		if (useApprFormCont == null) {
			logger.debug("useApprFormCont tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertApprFormCont", map);
		}
		
		map.put("property", "USEAPPRCODECONT");
		String useApprCodeCont = (String) select("EzCommonDAO.getTenantConfig", map);
		if (useApprCodeCont == null) {
			logger.debug("useApprCodeCont tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertApprCodeCont", map);
		}
	}

	public void createTblYearlyDocCount() throws Exception {
		try {
			select("EzCommonDAO.checkTblYearlyDocCount");
		} catch (Exception e) {
			logger.debug("tbl_yearlydoccount doesn't exist. creating the table...");

			update("EzCommonDAO.createTblYearlyDocCount");
		}
	}

	public int checkChartPortletInfo() {
		return (int) select("EzCommonDAO.checkChartPortletInfo");
	}

	public void insertPortletInfoData(Map<String, Object> map) {
		String companyId = checkPortletForComapny(map);

		if (companyId == null) {
			try {
				logger.debug("insert portlet data:" + Optional.ofNullable(map.get("portletName1")).orElse(""));
				insert("EzCommonDAO.insertPortletComp",map);
				insert("EzCommonDAO.insertPortletName",map);
				insert("EzCommonDAO.insertPortalThemePortlet",map);
				insert("EzCommonDAO.insertPortalPortletAuth",map);
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}

	}

	public void addTblUserMultiLoginMobileFlagColumn() {
		try {
			select("EzCommonDAO.checkTblUserMultiLoginMobileFlagColumn");
		} catch (Exception e) {
			logger.debug("tbl_user_multilogin mobile_flag column doesn't exist. creating the column...");

			update("EzCommonDAO.addTblUserMultiLoginMobileFlagColumn");
			update("EzCommonDAO.dropTblUserMultiLoginPrimaryKey");
			update("EzCommonDAO.addTblUserMultiLoginPrimaryKey");
		}
	}
	
	public void createTblFidoSession() throws Exception {
		try {
			select("EzCommonDAO.checkTblFidoSession");
		} catch (Exception e) {
			logger.debug("tbl_fido_session doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblFidoSession");
		}
	}

	public void createMailTemplateSequence() throws Exception {
		if (dbType.equalsIgnoreCase("oracle")) {
			try {
				int cnt = (int) select("EzCommonDAO.checkMailTemplateSequence");
				if (cnt < 1) {throw new Exception(); }
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				logger.debug("MailTemplateSequence doesn't exist. creating the Sequence...");
				
				update("EzCommonDAO.createMailTemplateSequence");
			}
		}
	}

	public void createMailboxProgressTable() {
		try {
			select("EzCommonDAO.checkJmochaMailboxProgress");
		} catch (Exception e) {
			logger.debug("jmocha_mailbox_progress doesn't exist. creating the table...");
			update("EzCommonDAO.createJmochaMailboxProgress");
		}
	}

	public void createWebfolderFileUserTable() {
		try {
			select("EzCommonDAO.selectWebfolderFileUserTable");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_fileUser table doesn't exist. creating the table...");
			update("EzCommonDAO.createtWebfolderFileUserTable");
		}
		
		if (dbType.equalsIgnoreCase("oracle")) {
			try {
				update("EzCommonDAO.createWebfolderFolderUserSeq");
			} catch (Exception e) {
				logger.debug("createWebfolderFolderUserSeq sequence exist.");
			} 
			
			try {
				update("EzCommonDAO.createWebfolderFileUserSeq");
			} catch (Exception e) {
				logger.debug("createWebfolderFileUserSeq sequence exist.");
			} 
			
			try {
				update("EzCommonDAO.createWebfolderFolderIdSeq");
			} catch (Exception e) {
				logger.debug("createWebfolderFolderIdSeq sequence exist.");
			} 
			
			try {
				update("EzCommonDAO.createWebfolderFileIdSeq");
			} catch (Exception e) {
				logger.debug("createWebfolderFileIdSeq sequence exist.");
			} 
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getPermissionGroupIdListOfUser(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzCommonDAO.getPermissionGroupIdListOfUser", map);
	}
	
	public void createTblWebfolderApplyHistroy() throws Exception {
		Map<String, String> map = new HashMap<>();
		
		map.put("EzCommonDAO.checkTblWebfolderApplyHistroy", "EzCommonDAO.createTblWebfolderApplyHistroy");
		map.put("EzCommonDAO.checkTblWebfolderApplyHistroyMember", "EzCommonDAO.createTblWebfolderApplyHistroyMember");
		
		for (Entry<String, String> entry : map.entrySet()) {
			try {
				select(entry.getKey());
			} catch (Exception e) {
				String keyVal = entry.getValue();
				logger.debug("{} started.", keyVal);
				
				try {
					update(keyVal);
				} catch (Exception ex) {
					// oracle 11g xe 오류
					if (ex.getMessage().contains("ORA-00972")) {
						logger.debug("{} skip, cause=oracle 11g xe error: {}", keyVal, ex.getMessage());
					} else {
						logger.error(ex.getMessage(), ex);
					}
				}
			}
		}
	}
	
	public void checkWebfolderEncryptTable() {
		try {
			select("EzCommonDAO.checkWebfolderEncryptedFileTable");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_encrypted_file table doesn't exist. creating the table...");
			update("EzCommonDAO.createWebfolderEncryptedFileTable");
		}

		try {
			select("EzCommonDAO.checkWebfolderEncryptionFolderTable");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_enc_folder table doesn't exist. creating the table...");
			update("EzCommonDAO.createWebfolderEncryptionFolderTable");
		}
	}
	
	public void checkWebfolderVersionTable() {
		try {
			select("EzCommonDAO.checkWebfolderVersionTable");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_version table doesn't exist. creating the table...");
			update("EzCommonDAO.createWebfolderVersionTable");
		}
	}
	
	public void addWebfolderLogHistory() {
		try {
            select("EzCommonDAO.checkWebfolderFileHistoryColumn");
        } catch (Exception e) {
            logger.debug("tbl_webfolder_history file_id column doesn't exist. creating the column...");
            update("EzCommonDAO.addWebfolderLogHistory");
        }
		
	}
	
	public void createWebfolderNoInherit() {
		try {
			select("EzCommonDAO.selectWebfolderNoInherit");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_no_inherit table doesn't exist. creating the table...");
			update("EzCommonDAO.createtWebfolderNoInherit");
		}
	}
	
	public void createSerialnumgenGrant() {
		try {
			select("EzCommonDAO.checkSerialnumgenGrant");
		} catch (Exception e) {
			logger.debug("tbl_serialnumgen_grant doesn't exist. creating the table...");
			update("EzCommonDAO.createSerialnumgenGrant");
		}
	}
	
	// 전자결재 첨부파일 이미지 변환 여부 및 변환할 확장자 파일 모음 컨피그 추가
	public void insertApprSatViewerConfig(Map<String, Object> map) {
		map.put("property", "USEAPPRIMAGECONVERT");
		String useApprImageConvert = (String) select("EzCommonDAO.getTenantConfig", map);
		if (useApprImageConvert == null) {
			logger.debug("useApprImageConvert tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertUseApprImageConvert", map);
		}
		
		map.put("property", "APPRCONVERTEXT");
		String apprConvertExt = (String) select("EzCommonDAO.getTenantConfig", map);
		if (apprConvertExt == null) {
			logger.debug("apprConvertExt tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertApprConvertExt", map);
		}
	}

    public void insertTblCodelistA54002() {
        try {
            int cnt = (int) select("EzCommonDAO.checkTblCodelistA54002");
            if (cnt == 0) {
                insert("EzCommonDAO.insertTblCodelistA54002");
            }
        } catch (Exception e) {logger.debug("e.message=" + e.getMessage());}
    }
    
	public void createTblCar() {
		try {
			select("EzCommonDAO.checkTblCar");
		} catch (Exception e) {
			logger.debug("tbl_car doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblCar");
		}
	}

	public void createTblCarAcl(){
		try {
			select("EzCommonDAO.checkTblCarAcl");
		} catch (Exception e) {
			logger.debug("tbl_car_acl doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblCarAcl");
		}
	}

	public void createTblCarAttach()  {
		try {
			select("EzCommonDAO.checkTblCarAttach");
		} catch (Exception e) {
			logger.debug("tbl_car_attach doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblCarAttach");
		}
	}

	public void createTblCarForm()  {
		try {
			select("EzCommonDAO.checkTblCarForm");
		} catch (Exception e) {
			logger.debug("tbl_car_form doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblCarForm");
		}
	}

	// 분류코드체계 (대분류, 중분류, 소분류) 별 삭제여부 플래그 추가
	public void addViewTaskOldFlag() { // vtaskclass
		try {
			select("EzCommonDAO.checkViewTaskOldFlagTop");
		} catch (Exception e) {
			logger.debug("vtaskclass OLDFLAG_TOP doesn't exist. creating the column...");
			
			update("EzCommonDAO.addViewTaskOldFlags");
		}
	}
	
	public void addSViewTaskOldFlag() { // svtaskclass
		try {
			select("EzCommonDAO.checkSViewTaskOldFlagTop");
		} catch (Exception e) {
			logger.debug("svtaskclass OLDFLAG_TOP doesn't exist. creating the column...");
			
			update("EzCommonDAO.addSViewTaskOldFlags");
		}
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, String>> getTenantConfigList(Map<String, Object> map) throws Exception{
		return (List<Map<String, String>>) list("EzCommonDAO.getTenantConfigList", map);
	}
	
	public void createTblScheduleComplete() {
		try {
			select("EzCommonDAO.checkTblScheduleComplete");
		} catch (Exception e) {
			logger.debug("TBL_SCHEDULE_COMPLETE doesn't exist. creating the table...");
			update("EzCommonDAO.createTblScheduleComplete");
		}
	}
	
	/* 2021-12-22 이사라 : 로그아웃시간, 상태 컬럼 추가  */
	public void alterTblConnectionInfo() {
		logger.debug("If disconnecttime and status columns doesn't exist in TBL_CONNECTION_INFO, creating the columns...");
		update("EzCommonDAO.alterTblConnectionInfo");
	}

	public void createTblAdminAccessInfo() {
		logger.debug("If TBL_ADMIN_ACCESS_INFO doesn't exist, creating the table...");
		update("EzCommonDAO.createTblAdminAccessInfo");
	}
	
	public void createMailOutOfOfficeTemplate() throws Exception {
		try {
			select("EzCommonDAO.checkMailOutOfOfficeTemplate");
		} catch (Exception e) {
			logger.debug("jmocha_mail_outofoffice_tem doesn't exist. creating the table...");
			
			update("EzCommonDAO.createMailOutOfOfficeTemplate");
		}
	}

	public void createUserMailTemplate() throws Exception {
		try {
			select("EzCommonDAO.checkUserMailTemplate");
		} catch (Exception e) {
			logger.debug("jmocha_user_mail_template doesn't exist. creating the table...");
			
			update("EzCommonDAO.createUserMailTemplate");
		}
	}

	public void createTblPermissionChangeInfo() {
		logger.debug("If TBL_PERMISSION_CHANGE_INFO doesn't exist, creating the table...");
		update("EzCommonDAO.createTblPermissionChangeInfo");
	}

	public void insertReceiptHistoryListoption(Map<String, Object> map) throws Exception {
		String companyId = checkReceiptHistoryListoption(map);
		
		try {
			if (companyId == null) {
				logger.debug("TBL_LISTOPTION data doesn't exist. insert the data of " + map.get("companyId") + "...");
				insert("EzCommonDAO.insertReceiptHistoryListoption", map);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}

	private String checkReceiptHistoryListoption(Map<String, Object> map) {
		return (String) select("EzCommonDAO.checkReceiptHistoryListoption", map);
	}
	
	public void alterTblDevMaster() {
		try {
			update("EzCommonDAO.alterTblDevMaster");
		} catch (Exception e) {
			logger.debug("alterTblDevMaster() ERROR...");
			logger.error(e.getMessage(), e);
		}
	}
	
	public void createTblAprpreview() {
		try {
			select("EzCommonDAO.checkTblAprpreview");
		} catch (Exception e) {
			logger.debug("tbl_aprpreview doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblAprpreview");
		}
	}
	
	public void createTblDisableNotiItem() {
		try {
			select("EzCommonDAO.checkTblDisableNotiItem");
		} catch (Exception e) {
			logger.debug("tbl_user_noti_disable_item doesn't exist. creating the table...");
			try {
				update("EzCommonDAO.createTblDisableNotiItem");
			} catch (Exception ex) {
				logger.debug("pk_tbl_usermaster doesn't primary key of tbl_usermaster...");
				update("EzCommonDAO.createTblDisableNotiItem_exception_try");

				logger.debug("try one more creating the table...");
				update("EzCommonDAO.createTblDisableNotiItem");
			}
		}
	}

	public void createTblSerialNoRollback() {
		try {
			select("EzCommonDAO.chkTblSerialNoRollback");
		} catch (Exception e) {
			logger.debug("TBL_SERIAL_NOROLLBACK table doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblSerialNoRollback");
		}
	}

	public void createTblBoardDisLike() throws Exception {
		try {
			select("EzCommonDAO.checkTblBoardDisLike");
		} catch (Exception e) {
			logger.debug("tbl_board_dislike doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblBoardDisLike");
		}
	}
	
	public void insertHWPSecurityConfig() throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkHWPDownSecurityConfig");
		String propertyValue2 = (String) select("EzCommonDAO.checkHWPSecurityNumConfig");
		
		if (propertyValue == null) {
			logger.debug("HWPDownSecurity tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertHWPDownSecurityConfig");
		}
		
		if (propertyValue2 == null) {
			logger.debug("HWPSecurityNum tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertHWPSecurityNumConfig");
		}
	}

	// 2023-08-21 조소정 - 근태관리 > 작성 양식 테이블에 영어 버전 양식 컬럼 추가
	public void addAttitudeFormFormHtml2Column() {
		try {
			select("EzCommonDAO.checkFormHtml2Column");
		} catch (Exception e) {
			logger.debug("TBL_ATTITUDE_FORM FORM_HTML2 column doesn't exist. creating the column...");

			update("EzCommonDAO.addAttitudeFormFormHtml2Column");
			update("EzCommonDAO.updateAttitudeFormFormHtml2Column");
		}
		
		// 2023-10-12 조소정 - 근태관리 > 작성 양식 테이블 영어 버전 양식 컬럼값 추가
		try {
			Object formHtml2 = select("EzCommonDAO.checkFormHtml2Column");

		    if (formHtml2 == null) {
				logger.debug("TBL_ATTITUDE_FORM FORM_HTML2 column is empty. insert data...");
				
				update("EzCommonDAO.updateAttitudeFormFormHtml2Column");
		    }
		} catch (Exception e) {
		    logger.error(e.getMessage(), e);
		}
	}

	public void createTblUserChangeInfo() {
		try {
			select("EzCommonDAO.checkTblUserChangeInfo");
		} catch (Exception e) {
			logger.debug("TBL_USER_CHANGE_INFO table doesn't exist. creating the table...");

			update("EzCommonDAO.createTblUserChangeInfo");
		}
	}

	/* 2023-06-26 민지수 - codelist에 완료문서 추가의견타입 추가 */
	public void insertOpinionGB(Map<String, Object> map) {
		String companyId = (String) select("EzCommonDAO.checkCodeListTypeForCompany", map);

		if (companyId == null) {
			logger.debug("Opinion_type_id 'A17' doesn't exist. insert data...");
			insert("EzCommonDAO.insertOpinionGB",map);
		}
	}
	
	// 2023-10-05 전인하 - 권한 코드 변경으로 인하여 기존 데이터를 변경하는 메소드
    public void updateWebFolderAndApprovalCheckPermissionCode() throws Exception {
		update("EzCommonDAO.updateWebFolderAndApprovalCheckPermissionCode1");
		update("EzCommonDAO.updateWebFolderAndApprovalCheckPermissionCode2");
		update("EzCommonDAO.updateWebFolderAndApprovalCheckPermissionCode3");
    }		

	/* 2023-07-27 이가은&임정은 - 댓글 좋아요/싫어요 관련 테이블 및 칼럼 추가 */
	public void createTblBoardReplyReact() throws Exception {
		// 게시판 > 댓글 좋아요/싫어요 반응여부 저장 테이블 추가
		try {
			select("EzCommonDAO.checkTblBoardReplyReact");
		} catch (Exception e) {
			logger.debug("tbl_board_reply_react doesn't exist. creating the table...");

			update("EzCommonDAO.createTblBoardReplyReact");
		}
	}

	/* 2023-09-25 민지수 - 게시판 > 공지게시물 > 기간설정 컬럼 추가 */
	public void addTblBoardItemNoti(Map<String, Object> map) {
		try {
			select("EzCommonDAO.checkTblBoardItemNotiColumn");
		} catch (Exception e) {
			logger.debug("tbl_board_item NTSTARTDATE,NTENDDATE column doesn't exist. creating the column...");
			update("EzCommonDAO.addTblBoardItemNotiColumn");
			update("EzCommonDAO.addTblBoardItemNoti",map);
		}

	}

	/* 2023-09-25 민지수 - 게시판 > 임시저장 > 공지게시물 > 기간설정 컬럼 추가 */
	public void addTblBoardItemTempNoti(Map<String, Object> map) {
		try {
			select("EzCommonDAO.checkTblBoardItemTempNotiColumn");
		} catch (Exception e) {
			logger.debug("tbl_board_item_temp NTSTARTDATE,NTENDDATE column doesn't exist. creating the column...");
			update("EzCommonDAO.addTblBoardItemTempNotiColumn");
			update("EzCommonDAO.addTblBoardItemTempNoti",map);
		}

	}

	public void insertPrvwConfig() {
		String useAprFilePrvw = (String) select("EzCommonDAO.checkUseAprFilePrvwConfig");
		String useBoardFilePrvw = (String) select("EzCommonDAO.checkUseBoardFilePrvwConfig");
		
		if (useAprFilePrvw == null) {
			logger.debug("useAprFilePrvw tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertUseAprFilePrvwConfig");
		}
		
		if (useBoardFilePrvw == null) {
			logger.debug("useBoardFilePrvw tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertUseBoardFilePrvwConfig");
		}
	}
	
	/* 2023-12-05 홍승비 - 전자결재 > 전자결재 서명 데이터 재맵핑 시점 컨피그 추가 */
	public void insertApprSignRemapApplyTime(Map<String, Object> map) {
		String apprSignRemapApplyTime = (String) select("EzCommonDAO.getTenantConfig", map);
		
		if (apprSignRemapApplyTime == null) {
			logger.debug("apprSignRemapApplyTime tenant config doesn't exist. insert data...");
			
			map.put("property", "apprSignRemapApplyTime");
			insert("EzCommonDAO.insertApprSignRemapApplyTime", map);
		}
	}
	
	public void insertPermissionBasisDeptYN_Config()  throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkPermissionBasisDeptYN_Config");
		if (propertyValue == null) {
			logger.debug("PermissionBasisDeptYN tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertPermissionBasisDeptYN_Config");
		}
	}

	public void createTblDbLog() {
		try {
			select("EzCommonDAO.checkTblDbLog");
		} catch (Exception e) {
			logger.debug("TBL_DB_LOG table doesn't exist. creating the table...");

			update("EzCommonDAO.createTblDbLog");
		}
	}

    /* 2023-11-22 조소정 - 포탈 > 기본 탑메뉴 중국어 버전 추가 - 테넌트 아이디 SELECT */
	public String getPortalMenuTenantList() throws Exception {
		return (String) select("EzCommonDAO.getPortalMenuTenantList");
	}

    /* 2023-11-22 조소정 - 포탈 > 기본 탑메뉴 중국어 버전 추가 - 회사 아이디 SELECT */
	public String getPortalMenuCompanyList(Map<String, Object> map) throws Exception {
		return (String) select("EzCommonDAO.getPortalMenuCompanyList", map);
	}

    /* 2023-11-22 조소정 - 포탈 > 기본 탑메뉴 중국어 버전 추가 */
	public void insertPortalMenuChinese(Map<String, Object> map2) throws Exception {
		try {
			String checkMenuChinese = (String) select("EzCommonDAO.checkPortalMenuChinese", map2);

			if (checkMenuChinese == null) {
				logger.debug("TBL_PORTAL_MENU_NAME chinese version doesn't exist. insert data... ");

				insert("EzCommonDAO.insertPortalMenuChinese", map2);
			}
		} catch (Exception e) {
			logger.debug("insertPortalMenuChinese() ERROR...");
			logger.error(e.getMessage(), e);
		}
	}

    /* 2023-11-22 조소정 - 포탈 > 기본 포틀릿명 중국어 버전 추가 - 테넌트 아이디 SELECT */
	public String getPortletNameTenantList() throws Exception {
		return (String) select("EzCommonDAO.getPortletNameTenantList");
	}

    /* 2023-11-22 조소정 - 포탈 > 기본 포틀릿명 중국어 버전 추가 - 회사 아이디 SELECT */
	public String getPortletNameCompanyList(Map<String, Object> map) {
		return (String) select("EzCommonDAO.getPortletNameCompanyList", map);
	}

    /* 2023-11-22 조소정 - 포탈 > 기본 포틀릿명 중국어 버전 추가 */
	public void insertPortletNameChinese(Map<String, Object> map2) {
		try {
			String checkNameChinese = (String) select("EzCommonDAO.checkPortletNameChinese", map2);

			if (checkNameChinese == null) {
				logger.debug("TBL_PORTAL_PORTLET_NAME chinese version doesn't exist. insert data... ");

				insert("EzCommonDAO.insertPortletNameChinese", map2);
			}
		} catch (Exception e) {
			logger.debug("insertPortletNameChinese() ERROR...");
			logger.error(e.getMessage(), e);
		}
	}

	// 2023-11-27 조소정 - 게시판그룹 일본어 버전 생성 위해 LangTertiary 테넌트 컨피그 추가	
	public void insertTenantConfigLangTertiary(Map<String, Object> map) {
		String LangTertiary = (String) select("EzCommonDAO.checkTenantConfigLangTertiary", map);
		if (LangTertiary == null) {
			logger.debug("LangTertiary tenant config doesn't exist. insert data...");
			
			insert("EzCommonDAO.insertTenantConfigLangTertiary", map);
		}
	}

	// 2023-11-27 조소정 - 게시판그룹 중국어 버전 생성 위해 LangQuaternary 테넌트 컨피그 추가
	public void insertTenantConfigLangQuaternary(Map<String, Object> map) {
		String LangQuaternary = (String) select("EzCommonDAO.checkTenantConfigLangQuaternary", map);
		if (LangQuaternary == null) {
			logger.debug("LangQuaternary tenant config doesn't exist. insert data...");
			
			insert("EzCommonDAO.insertTenantConfigLangQuaternary", map);
		}
	}
	
	public void insertLoadTimeForApprAllConfig() {
		String propertyValue = (String) select("EzCommonDAO.checkLoadTimeForApprAllConfig");
		
		if (propertyValue == null) {
			logger.debug("loadTimeForApprAllConfig tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertLoadTimeForApprAllConfig");
		}
	}

	public void createTblDeptChangeInfo() throws Exception {
		try {
			select("EzCommonDAO.checkTblDeptChangeInfo");
		} catch (Exception e) {
			logger.debug("tbl_dept_dept_info doesn't exist. creating the table...");

			update("EzCommonDAO.createTblDeptChangeInfo");
		}
	}

	public void insertSurveyPostingMaxPeriodConfig(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkSurveyPostingMaxPeriodConfig", map);

		if (propertyValue == null) {
			logger.debug("SurveyPostingMaxPeriodConfig tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertSurveyPostingMaxPeriodConfig", map);
		}
	}

	public void alterFileNameForWebfolderHistory() {
		try {
			select(("EzCommonDAO.checkFileNameColumnForHistory"));
		} catch (Exception e) {
			logger.debug("TBL_WEBFOLDER_FOLDER_HISTORY FILE_NAME column doesn't exist. creating the column...");

			update("EzCommonDAO.alterFileNameForWebfolderHistory");
		}
	}

	/** 2023-06-26 한태훈 - 통합 PC 저장 이력 남기는 tbl_total_history 테이블 만들기(차후 다른 목적으로도 쓰일 수 있음.) */
	public void createTblTotalHistory() {
		try {
			select("EzCommonDAO.chkTblTotalHistory");
		} catch (Exception e) {
			logger.debug("TBL_TOTAL_HISTORY table doesn't exist. creating the table...");

			update("EzCommonDAO.createTblTotalHistory");
		}
	}

	/* 2024-05-23 민지수 - 전자결재 > 첨부 > 첨부 등록자 이외의 사용자가 첨부 삭제가능여부 */
	public void insertdelAttachByOthersConfing(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkDelAttachByOthersConfing", map);

		if (propertyValue == null) {
			logger.debug("delAttachByOthers tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertDelAttachByOthersConfing", map);
		}
	}

	// 2024-05-28 이유정 - 자원관리 > 자원반복예약 허용 설정을 위한 RepeatFlag 컬럼 추가
	public void alterRepeatFlagForResourceInfo() {
		try {
			select(("EzCommonDAO.checkRepeatFlagColumnForResourceInfo"));
		} catch (Exception e) {
			logger.debug("TBL_RS_BRD REPEATFLAG column doesn't exist. creating the column...");

			update("EzCommonDAO.alterRepeatFlagForResourceInfo");
		}
	}

	public void insertEndDateOptionConfig(Map<String, Object> map) throws Exception {
		String endDateOptionConfig = (String) select("EzCommonDAO.checkEndDateOptionConfig", map);
		if (endDateOptionConfig == null) {
			logger.debug("endDateOptionConfig tenant config doesn't exist. insert data...");

			insert("EzCommonDAO.insertEndDateOptionConfig", map);
		}
	}

	// 2024-05-23 김우철 - 헤더 숨기기 기능 사용 여부 테넌트 컨피그 추가
	public void insertUseHideHeaderArea(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkUseHideHeaderArea", map);

		if (propertyValue == null) {
			logger.debug("useHideHeaderArea tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertUseHideHeaderArea", map);
		}
	}

	/* 2024-05-28 김유진 - 포탈 메뉴,포틀릿,테마,빠른링크 > 하위부서 허용여부 컬럼 추가, 빠른링크 > 유저타입 컬럼 추가 */
	public void alterSubPermittedForMenuAuth() {
		try {
			select(("EzCommonDAO.checkSubPermittedForMenuAuth"));
		} catch (Exception e) {
			logger.debug("tbl_portal_menu_auth subdept_permitted column doesn't exist. creating the column...");
			update("EzCommonDAO.alterSubPermittedForMenuAuth");
			update("EzCommonDAO.updateSubPermittedForMenuAuth"); // 기존 스펙상 부서 선택 시 하위부서 허용이 고정임으로 부서일 경우 허용으로 값 변경
		}
	}
	public void alterSubPermittedForPortletAuth() {
		try {
			select(("EzCommonDAO.checkSubPermittedForPortletAuth"));
		} catch (Exception e) {
			logger.debug("tbl_portal_portlet_auth subdept_permitted column doesn't exist. creating the column...");
			update("EzCommonDAO.alterSubPermittedForPortletAuth");
			update("EzCommonDAO.updateSubPermittedForPortletAuth");
		}
	}
	public void alterSubPermittedForThemeAuth() {
		try {
			select(("EzCommonDAO.checkSubPermittedForThemeAuth"));
		} catch (Exception e) {
			logger.debug("tbl_portal_theme_auth subdept_permitted column doesn't exist. creating the column...");
			update("EzCommonDAO.alterSubPermittedForThemeAuth");
			update("EzCommonDAO.updateSubPermittedForThemeAuth");
		}
	}
	public void alterSubPermittedForQuicklinkAcl() {
		try {
			select(("EzCommonDAO.checkSubPermittedForQuicklinkAcl"));
		} catch (Exception e) {
			logger.debug("tbl_ps_quicklink_acl subdept_permitted, user_type column doesn't exist. creating the column...");
			update("EzCommonDAO.alterSubPermittedForQuicklinkAcl");
			update("EzCommonDAO.updateSubPermittedForQuicklinkAcl"); // 유저,부서,직위,직책,그룹권한 user_type 세팅, 부서일 경우 허용으로 값 변경
		}
	}
	/* 2024-05-29 김유진 - tenant_config 작업; 전자결재G 비전자문서등록 양식 확장자 정보추가 */
	public void insertApprNonElecRecTypeConfing(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkApprNonElecRecTypeConfing", map);

		if (propertyValue == null) {
			logger.debug("apprNonElecRecType tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertApprNonElecRecTypeConfing", map);
		}
	}
	public void addUserDeptHideFlag() {
		try {
			select("EzCommonDAO.checkUserHideFlag");
		} catch (Exception e) {
			logger.debug("tbl_usermaster userHideFlag Columns doesn't exist. creating the column...");
	
			update("EzCommonDAO.addUserHideFlag");
		}

		try {
			select("EzCommonDAO.checkAddJobHideFlag");
		} catch (Exception e) {
			logger.debug("tbl_addjobmaster userHideFlag Columns doesn't exist. creating the column...");

			update("EzCommonDAO.addAddJobHideFlag");
		}
	
		try {
			select("EzCommonDAO.checkDeptHideFlag");
		} catch (Exception e) {
			logger.debug("tbl_deptmaster deptHideFlag Columns doesn't exist. creating the column...");
	
			update("EzCommonDAO.addDeptHideFlag");
		}
		
	}

	public void createTable(String tableName) throws Exception {
		String queryId 		= "";
		String chkColumn 	= "TENANT_ID";
		
		switch(tableName) {
			case "jmocha_appr_allowed_domain": 			queryId = "EzCommonDAO.createJmochaApprAllowedDomain"; break;
			case "jmocha_appr_user": 					queryId = "EzCommonDAO.createJmochaApprUser"; break;
			case "jmocha_appr_history": 				queryId = "EzCommonDAO.createJmochaApprHistory"; break;
			case "jmocha_appr_comp_history": 			queryId = "EzCommonDAO.createJmochaApprCompHistory"; break;
			case "jmocha_address_last_sent": 			queryId = "EzCommonDAO.createJmochaAddressLastSent"; break;
		}
		
		try {
			checkTable(chkColumn, tableName);
		} catch (Exception e) {
			logger.debug("{} doesn't exist. creating the table...", tableName);
			update(queryId);
		}
	}
	
	private void checkTable(String column, String tableName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COLUMN", column);
		map.put("v_TABLE", tableName);

		select("EzCommonDAO.checkTable", map);
	}
	
    public void insertRecordHeaderClassTitle(Map<String, Object> map) throws Exception {
        String companyId = (String) select("EzCommonDAO.checkRecordHeadereOption", map);
        try {
            if (companyId == null) {
                // 2024-06-21 민지수 전자결재 > 기록물등록대장 헤더 > 기록물철명 존재하지 않는 경우 001 타입에 대한 헤더 지운 후 Insert 작업 (PrimaryKey 중복 오류)
                delete ("EzCommonDAO.deleteRecordHeader",map);
                logger.debug("ReName option doesn't exist. insert data...");
                insert("EzCommonDAO.insertRecordHeaderClassTitle", map);
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
    }

	// 2024-06-04 김우철 - 부서수신함에서 첨부, 문서첨부 기능 사용 여부 테넌트 컨피그 추가
	public void insertUseReceiptDeptFileAttach(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkUseReceiptDeptFileAttach", map);

		if (propertyValue == null) {
			logger.debug("useReceiptDeptFileAttach tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertUseReceiptDeptFileAttach", map);
		}
	}

	public void insertDocBinderListOption(Map<String, Object> map) {
		int optionCount = (int) select("EzCommonDAO.checkExistDocBinderListOption", map);
		if (optionCount < 5) {
			logger.debug("DocBinder List Header Option doesn't exist. insert data...");
			delete("EzCommonDAO.delDocBinderListOption", map);
			insert("EzCommonDAO.insertDocBinderListOption", map);
		}
	}

	// 2024-06-24 양지혜 - 전자결재 > 지정반송 사용여부 컨피그
	public void insertReturnByDesignationUsedConfig(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.getTenantConfig", map);

		if (propertyValue == null) {
			logger.debug("insertReturnByDesignationUsedConfig tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertReturnByDesignationUsedConfig", map);
		}
	}

	@SuppressWarnings("unchecked")
	public List<TblColumnsInfoVO> selectColumnsOnlyExistTblUsermaster () {
		return (List<TblColumnsInfoVO>) list("EzCommonDAO.selectColumnsOnlyExistTblUsermaster");
	}
	
	public void alterDocAttachNameCol() throws Exception {
		try {
			select(("EzCommonDAO.checkDocAttachNameCol"));
		} catch (Exception e) {
			logger.debug("In TBL_RECORD_TEMP doesn't exist DocAttach column. creating the column...");

			update("EzCommonDAO.alterDocAttachNameCol");
		}
	}

	// 2024-07-02 민지수 - 전자결재 > 비전자문서 등록 > 본문첨부 기능 사용여부 테넌트 컨피그 추가
	public void insertNonUseDocAttachYN(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkNonUseDocAttachYN", map);

		if (propertyValue == null) {
			logger.debug("NonUseDocAttachYN tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertNonUseDocAttachYN", map);
		}
	}

	public void insertReadingRecordHeader(Map<String, Object> map) {
		int optionCount = (int) select("EzCommonDAO.checkReadingRecordHeader", map);
		if (optionCount < 10) {
			logger.debug("ReadingRecord List Header doesn't exist. insert data...");
			delete("EzCommonDAO.delReadingRecordHeader", map);
			insert("EzCommonDAO.insertReadingRecordHeader", map);
		}
	}

	public void insertPortalPortletSizeTables() {
		try {
			select("EzCommonDAO.checkTblPortalPortletSize");
		} catch (Exception e) {
			update("EzCommonDAO.createPortalPortletSize");
			update("EzCommonDAO.createPortalPortletCompanySize");
			update("EzCommonDAO.createPortalPortletUserSize");
			insert("EzCommonDAO.insertUsePortletSize");
			insert("EzCommonDAO.insertPortalPortletSizeDefault");
		}
	}

	public void insertTblPortalTopUser() {
		try {
			select("EzCommonDAO.checkTblPortalTopUser");
		} catch (Exception e) {
			logger.debug("TBL_PORTAL_TOP_USER doesn't exist. creating the table...");

			update("EzCommonDAO.createTblPortalTopUser");
		}
	}
	// 2024-03-28 한태훈 > 통합알림 테이블 생성 메소드
	public void createTblRealTimeNotification() throws Exception {
		try {
			select("EzCommonDAO.checkTblRealTimeNotification");
		} catch (Exception e) {
			logger.debug("tbl_realtime_notification doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblRealTimeNotification");
		}
	}
	
	// 2024-03-28 한태훈 > 통합알림 보관기간 테넌트 컨피그 생성 메소드
	public void addNotiStoragePeriodConfig(Map<String, Object> map) throws Exception {
		String notiStoragePeriod = (String) select("EzCommonDAO.getNotiStoragePeriodConfig", map);
		if (notiStoragePeriod == null) {
			logger.debug("notiStoragePeriod tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.addNotiStoragePeriodConfig", map);
		}
	}
	
	// 2024-03-28 한태훈 > 통합알림 데이터 폴링 주기 설정 테넌트 컨피그 생성 메소드
	public void addNotiPollingIntervalConfig(Map<String, Object> map) throws Exception {
		String notiPollingInterval = (String) select("EzCommonDAO.getNotiPollingIntervalConfig", map);
		if (notiPollingInterval == null) {
			logger.debug("notiPollingInterval tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.addNotiPollingIntervalConfig", map);
		}
	}

    public void insertFixPortlet() {
        try {
            select("EzCommonDAO.checkFixPortlet");
        } catch (Exception e) {
            logger.debug("TBL_PORTAL_TOP_USER doesn't exist. creating the table...");

            update("EzCommonDAO.createTblPortalTopUser");
        }
    }

	// 2024-05-17 한태훈 > 포탈 > 회사별 탑메뉴 위치 설정 테이블 생성 메소드
	public void insertTblPortalTopCompany() {
		try {
			select("EzCommonDAO.checkTblPortalTopCompany");
		} catch (Exception e) {
			logger.debug("TBL_PORTAL_TOP_Company doesn't exist. creating the table...");

			update("EzCommonDAO.createTblPortalTopCompany");
		}
	}

	// 2024-05-17 한태훈 > 포탈 > 회사별 탑메뉴 위치 설정 기본값 입력 메소드(기본값 : 0 - 상단)
	public void insertPortalTopCompanyInitdata() {
		List<OrganDeptVO> initList = ezNewPortalDAO.getInitCompanyListForTopMenu();
		if (initList != null ) {
			int initListCount = initList.size();

			for (int i = 0; i < initListCount; i++) {
				int tenantId = initList.get(i).getTenantId();
				String companyId = initList.get(i).getCn();
				
				PortalTopVO companyMenuDisplayMode = new PortalTopVO();
				companyMenuDisplayMode.setTenantID(tenantId);
				companyMenuDisplayMode.setCompanyID(companyId);
				companyMenuDisplayMode.setType(0);
				
				try {
					ezNewPortalDAO.insertTopMenuDisplayModeForCompany(companyMenuDisplayMode);
				} catch (Exception e1) {
					logger.error(e1.getMessage(), e1);
				}
			}
		}
	}

    public void addQuickLinkCompanyID() {
        try {
            select("EzCommonDAO.checkQuickLinkCompanyID");
        } catch (Exception e) {
            logger.debug("tbl_ps_quicklink copmpanyid doesn't exist. creating the column...");

            update("EzCommonDAO.addQuickLinkCompanyID");
        }
    }

	public void alterUserThemePagination() throws Exception {
		try {
			select("EzCommonDAO.checkUserThemePagination");
		} catch (Exception e) {
			logger.debug("In TBL_PORTAL_THEME_USER doesn't exist usePaging column. creating the column...");

			update("EzCommonDAO.alterUserThemePagination");
		}
	}
	
	public String checkThemeInformation() {
		return (String) select("EzCommonDAO.checkThemeInformation");
	}
	
	public void alterThemeInformation(Map<String, Object> map) throws Exception {
		try {
			update("EzCommonDAO.alterThemeInformation", map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return;
		}
	}
	
	public void alterCompanyMenuIconUrl() throws Exception {
		try {
			select("EzCommonDAO.checkCompanyMenuIconUrl");
		} catch (Exception e) {
			logger.debug("In TBL_PORTAL_MENU_COMP doesn't exist icon_url column. creating the column...");
			update("EzCommonDAO.alterCompanyMenuIconUrl");
			return;
		}
	}

	// 2024-06-17 이주원 - 일정관리 > 상단표시 컬럼 추가
	public void alterTblScheduleForShowtop() {
		try {
			select(("EzCommonDAO.checkTblScheduleForShowtop"));
		} catch (Exception e) {
			logger.debug("tbl_schedule showtop column doesn't exist. creating the column...");
			update("EzCommonDAO.alterTblScheduleForShowtop");
		}
	}
	

	public void insertGongRamListOption(Map<String, Object> map) throws Exception {
		map.put("listOption", "014"); // APR
		String companyId = checkGongRamListOption(map);

		try {
			if (companyId == null) {
				logger.debug("TBL_LISTOPTION data doesn't exist. insert the data of " + map.get("companyId") + "...");
				insert("EzCommonDAO.insertGongRamListOption", map);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		map.put("listOption", "015"); // END
		companyId = checkGongRamListOption(map);

		try {
			if (companyId == null) {
				logger.debug("TBL_LISTOPTION data doesn't exist. insert the data of " + map.get("companyId") + "...");
				insert("EzCommonDAO.insertGongRamListOption", map);
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}

	private String checkGongRamListOption(Map<String, Object> map) {
		return (String) select("EzCommonDAO.checkGongRamListOption", map);
	}
	
	/** 2023-09-01 한태훈 - 일정관리 > 미리알림 > tbl_schedule_reminder_scheduler 테이블 생성  */
	public void createTblScheduleReminderScheduler() throws Exception {
		try {
			select("EzCommonDAO.checkScheduleReminderScheduler");
		} catch (Exception e) {
			logger.debug("TBL_SCHEDULE_REMINDER_SCHEDULER doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblScheduleReminderScheduler");
		}
	}
	
	/** 2023-09-07 한태훈 - 일정관리 > 설정 > 미리알림 시간 설정 컬럼 추가 */
	public void addReminderTimeAtTblScheduleConfig() throws Exception {
		try {
			select("EzCommonDAO.checkReminderTimeColumnAtTblScheduleConfig");
		} catch (Exception e) {
			logger.debug("TBL_SCHEDULECONFIG REMINDERTIME column doesn't exist. creating the column...");
			
			update("EzCommonDAO.addReminderTimeAtTblScheduleConfig");
		}
	}
	
	/** 2023-09-11 한태훈 - 일정관리 > 미리알림 > 하루종일 일정의 시작 시각 설정 테넌트 컨피그 추가 */
	public void insertReminderTenantConfig(Map<String, Object> map) throws Exception{
		map.put("property", "allDaySTimeForReminder");
		String allDaySTimeForReminder = (String) select("EzCommonDAO.getAllDaySTimeTenantConfig", map);

		if (allDaySTimeForReminder == null) {
			logger.debug("allDaySTimeForReminder tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertAllDaySTimeForReminderTenantConfig", map);
		}
	}
	

	// 2024-06-28 이유정 - 캐비넷 > 캐비넷공유 > 공유자 저장여부 컬럼 추가
	public void alterSaveFlagForCbShare() {
		try {
			select(("EzCommonDAO.checkSaveFlagForCbShare"));
		} catch (Exception e) {
			logger.debug("TBL_CB_SHARE SAVEFLAG column doesn't exist. creating the column...");

			update("EzCommonDAO.alterSaveFlagForCbShare");
		}
	}

    public void alterBoardExtentionAttrByteSize() {
		String[] tables = {"TBL_BOARD_ITEM", "TBL_BOARD_ITEM_TEMP"};
		String[] columns = {"EXTENSIONATTRIBUTE6", "EXTENSIONATTRIBUTE7", "EXTENSIONATTRIBUTE8", "EXTENSIONATTRIBUTE9", "EXTENSIONATTRIBUTE10"};
		String oracleDataType = "NVARCHAR2(500)";
		String mysqlDataType = "VARCHAR(500)";
		
		for (String tbl : tables) {
			for (String column : columns) {
				Map<String, Object> map = new HashMap<>();
				map.put("table", tbl);
				map.put("column", column);
				map.put("dataTypeOracle", oracleDataType);
				map.put("dataTypeMysql", mysqlDataType);
				logger.debug("alter tbl " + tbl + " column " + column + " ...");
				update("EzCommonDAO.alterBoardExtentionAttrByteSize", map);
			}
		}
    }
    
    // 2024-08-21 유길상 닷넷 통합알림 컨피그
	public void insertDotNetTotalNotificationConfig(Map<String, Object> map) {
		map.put("property", "dotNetTotalNotification");
		String allDaySTimeForReminder = (String) select("EzCommonDAO.getDotNetTotalNotificationConfig", map);

		if (allDaySTimeForReminder == null) {
			logger.debug("dotNetTotalNotification tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertDotNetTotalNotificationConfig", map);
		}
	}
	
	// 2025-01-13 유길상 - 일본어 다국어처리 모두 진행중으로 변경되어 있는 것 수정 진행 추후 삭제 예정
	public void updateInProcessJpCodeName3() {
		List<HashMap<String,Object>> codeList= (List<HashMap<String,Object>>) list("EzCommonDAO.selectInProcessJpCodeName3");
		for (Map<String, Object> code : codeList) {
			update("EzCommonDAO.updateInProcessJpCodeName3",code);
		}
	}

	public void createTblDistributeinfo() {
		try {
			select("EzCommonDAO.checkTblDistributeinfo");
		} catch (Exception e) {
			logger.debug("TBL_DISTRIBUTEINFO table doesn't exist. creating the table...");
			update("EzCommonDAO.createTblDistributeinfo");
		}
	}

	// 2024-08-06 이유정 - 임원일정 > 테이블 추가
	public void createExecutiveTable() throws Exception {
		try {
			select("EzCommonDAO.checkExecutiveTable");
		} catch (Exception e) {
			logger.debug("tbl_executive doesn't exist. creating the table...");

			update("EzCommonDAO.createExecutiveTable");
		}
	}

	// 2024-07-11 전인하 - 설문 > 지정공개 대상자 리스트 테이블 추가
	public void createServeyResultviewPermTbl() {
		try {
			select("EzCommonDAO.checkServeyResultviewPermTbl");
		} catch (Exception e) {
			logger.debug("TBL_SERVEY_RESULTVIEWPERMISSION doesn't exist. creating the table...");

			update("EzCommonDAO.createServeyResultviewPermTbl");
		}
	}

	/* 2024-07-17 기민혁 - 전자결재 > 양식함 순서 컬럼 추가 */
	public void addTblFormContainerSN() {
		try {
			select("EzCommonDAO.checkTblFormContainerSN");
		} catch (Exception e) {
			logger.debug("tbl_formcontainer SN column doesn't exist. creating the column...");
			update("EzCommonDAO.addTblFormContainerSN");
		}

	}
	
	public void insertMobileTheme() throws Exception {
		if ((int)select("EzCommonDAO.checkMobileTheme") < 1) {
			logger.debug("insertMobileTheme mobile Theme doesn't exist. insert data...");
			insert("EzCommonDAO.insertMobileTheme");
		}
	}
	
	public void insertMobileFrame() throws Exception {
		if ((int)select("EzCommonDAO.checkMobileFrame") < 1) {
			logger.debug("insertMobileFrame mobile Frame doesn't exist. insert data...");
			insert("EzCommonDAO.insertMobileFrame");
		}
	}
	
	public void insertMobileFrameComp(Map<String, Object> map) throws Exception {
		logger.debug("insertMobileFrameComp started.");
		try {
			insert("EzCommonDAO.insertMobileFrameComp", map);
			logger.debug("insertMobileFrameComp ended.");
		} catch (Exception e) {
			logger.debug("insertMobileFrameComp failed.");
		}
	}
	
	public void insertMobileThemeComp(Map<String, Object> map) throws Exception {
		if ((int)select("EzCommonDAO.checkMobileThemeInitComp", map) < 1) {
			logger.debug("insertMobileThemeComp mobile ThemeCompany doesn't exist. insert data...");
			insert("EzCommonDAO.insertMobileThemeInitComp", map);
		}
	}
	
	public void resetMobileUser() throws Exception {
		logger.debug("resetMobileUser started.");
		try {
			update("EzCommonDAO.resetMobileUser");
			logger.debug("resetMobileUser ended.");
		} catch (Exception e) {
			logger.debug("resetMobileUser failed.");
		}
	}
	
	public void alterMenuOpenType() throws Exception {
		try {
			select("EzCommonDAO.checkMenuOpenType");
		} catch (Exception e) {
			logger.debug("In TBL_PORTAL_MENU_COMP doesn't exist openType column. creating the column...");
			
			update("EzCommonDAO.alterMenuOpenType");
		}
	}
	
	public void createTblSystemConfig() throws Exception {
		try {
			select("EzCommonDAO.chkTblSystemConfig");
		} catch (Exception e) {
			logger.debug("TBL_SYSTEMCONFIG table doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblSystemConfig");
		}		
	}
	
	public void createTblSystemConfigType() throws Exception {
		try {
			select("EzCommonDAO.chkTblSystemConfigType");
		} catch (Exception e) {
			logger.debug("TBL_SYSTEMCONFIG_TYPE table doesn't exist. creating the table...");
			update("EzCommonDAO.createTblSystemConfigType");
		}		
	}
	
	public void addConnectionIDtoTblPortalPortletComp() throws Exception {
		try {
			select("EzCommonDAO.checkConnectionId");
		} catch (Exception e) {
			logger.debug("TBL_PORTAL_PORTLET_COMP table doesn't have connection_id column. altering table...");
			update("EzCommonDAO.createConnectionIdOnTblPortalPortletComp");
		}
	}
	
	public String checkConnectionMenu() throws Exception {
		return (String) select("EzCommonDAO.checkConnectionMenu");
	}
	
	public void insertConnectionMenu() throws Exception {
		try {
			insert("EzCommonDAO.insertConnectionMenu");
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}		
	}
	
	public void insertConnectMenuInfo(Map<String, Object> map) throws Exception {
		try {
			insert("EzCommonDAO.insertConnectionMenuComp", map);
			insert("EzCommonDAO.insertConnectionMenuAuth", map);
			insert("EzCommonDAO.insertConnectionMenuName", map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	public void insertStandardSystemConfigData(Map<String, Object> map) {
		int totalConfigCnt = (Integer) select("EzCommonDAO.selectSystemConfigTotalCnt", map);
		if (totalConfigCnt <= 0) {
			int portletSystemConfigCnt = (Integer) select("EzCommonDAO.chkPortletSystemConfigType", map);
			
			if (portletSystemConfigCnt <= 0) {
				insert("EzCommonDAO.insertPortletSystemConfigType", map);
			}
			
			insert("EzCommonDAO.insertStandardSystemConfigData", map);
		}
		
	}
	
	public void createTblNotiEmergencyCompany() throws Exception {
		try {
			select("EzCommonDAO.chkTblNotiEmergencyCompany");
		} catch (Exception e) {
			logger.debug("TBL_NOTI_EMERGENCY_COMPANY table doesn't exist. creating the table...");
			update("EzCommonDAO.createTblNotiEmergencyCompany");
		}	
	}
	
	public void createTblNotiEmergencyItem() throws Exception {
		try {
			select("EzCommonDAO.chkTblNotiEmergencyItem");
		} catch (Exception e) {
			logger.debug("TBL_NOTI_EMERGENCY_ITEM table doesn't exist. creating the table...");
			update("EzCommonDAO.createTblNotiEmergencyItem");
		}	
	}
	
	public void createTblNotiEmergencyPermission() throws Exception {
		try {
			select("EzCommonDAO.chkTblNotiEmergencyPermission");
		} catch (Exception e) {
			logger.debug("TBL_NOTI_EMERGENCY_PERMISSION table doesn't exist. creating the table...");
			update("EzCommonDAO.createTblNotiEmergencyPermission");
		}	
	}
	
	public boolean hasMobileMenus() throws Exception {
		try {
			
			if ((int) select("EzCommonDAO.chkMobileMenus") > 0) {
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			return false;
		}
	}
	
	public int getNewMenuId() throws Exception {
		return (int) select("EzCommonDAO.getNewMenuId");
	}
	
	public void insertMobileMenus(int menuId) throws Exception {
		insert("EzCommonDAO.insertMobileMenus", menuId);
	}
	
	public void insertCompanyMobileMenus(Map<String, Object> param) {
		insert("EzCommonDAO.insertCompanyMobileMenus", param);
	}
	
	public void insertCompanyMobileMenuNames(Map<String, Object> param) {
		insert("EzCommonDAO.insertCompanyMobileMenuNames", param);
	}
	
	public void insertMobileMenusAuth(Map<String, Object> param) {
		insert("EzCommonDAO.insertMobileMenusAuth", param);
	}
	
	public void alterUseColor() {
		try {
			select("EzCommonDAO.checkUseColor");
		} catch (Exception e) {
			logger.debug("In TBL_PORTAL_TOP_USER doesn't exist useColor column. creating the column...");
			
			update("EzCommonDAO.alterUseColor");
		}
	}

	public void updateThemeData() {
		try {
			if ((int) select("EzCommonDAO.chkThemeName") > 1) {
				update("EzCommonDAO.updateTheme1");
				update("EzCommonDAO.updateTheme2");
				update("EzCommonDAO.updateTheme3");
			}
		} catch (Exception e) {
			logger.debug("An error occurred while updating the theme data.");
		}
	}

	public void createRsScheduleDeptIdColumn() throws Exception {
		try {
			select("EzCommonDAO.checkRsScheduleDeptIdColumn");
		} catch (Exception e) {
			logger.debug("TBL_RS_SCHEDULE DEPTID column doesn't exist. creating the column...");

			update("EzCommonDAO.createRsScheduleDeptIdColumn");
		}
	}

	/* 2023-03-30 이가은 - 게시판 > 게시물 댓글 정보 테이블에 답글 작성/수정기능 컬럼 추가 */
	public void alterTblBoardOneLineChildReply() throws Exception {
		try {
			select("EzCommonDAO.checkTblBoardOneLineChildReply");
		} catch (Exception e) {
			logger.debug("tbl_board_onelinereply replylevel doesn't exist. creating the column...");

			update("EzCommonDAO.alterTblBoardOneLineChildReply");
		}
	}

	/* 2023-11-07 전인하 - 댓글 이모티콘 삽입 칼럼 추가 */
	public void insertBoardReplyCommentEmoticon() throws Exception {
		try {
			select("EzCommonDAO.checkTblBoardOneReplyImageContentColumn");
		} catch (Exception e) {
			logger.debug("tbl_board_onelinereply imageContent doesn't exit. creatin the column...");

			update("EzCommonDAO.insertTblBoardOneReplyImageContentColumn");
		}
	}
	public void addBoardDisLikeFlag() throws Exception {
		try {
			select("EzCommonDAO.checkTblBoardInfoDisLikeFlag");
		} catch (Exception e) {
			logger.debug("tbl_board_info dislikeFlag doesn't exist. creating the column...");
			
			update("EzCommonDAO.addBoardDisLikeFlag");
		}
	}

	public void createBoardKeywordTable() throws Exception {
		try {
			select("EzCommonDAO.checkBoardKeywordTable");
		} catch (Exception e) {
			logger.debug("tbl_board_keyword doesn't exist. creating the table...");
			update("EzCommonDAO.createBoardKeywordTable");
		}
		
		try {
			select("EzCommonDAO.checkBoardItemKeywordTable");
		} catch (Exception e) {
			logger.debug("tbl_board_boardItem_keyword doesn't exist. creating the table...");
			update("EzCommonDAO.createBoardItemKeywordTable");
		}
		
		if (dbType.equalsIgnoreCase("oracle") || dbType.equalsIgnoreCase("tibero")) {
			int cnt = (int) select("EzCommonDAO.checkBoardKeywordSequence");
			if (cnt < 1) {
				logger.debug("tbl_board_keyword Sequence doesn't exist. creating the Sequence...");
				update("EzCommonDAO.createBoardKeywordSequence");
			}
		}
	}
	
    // 2024-08-07 유길상 - 자원관리 즐겨찾기 카테고리 테이블 추가
    public void createTblRsFavCat() {
		try {
			select("EzCommonDAO.checkTblRsFavCat");
		} catch (Exception e) {
			logger.debug("tbl_rs_fav_cat doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblRsFavCat");
		}
	}
    
    // 2024-08-07 유길상 - 자원관리 즐겨찾기 카테고리 자원 정보 테이블
	public void createTblRsCatBrd() {
		try {
			select("EzCommonDAO.checkTblRsCatBrd");
		} catch (Exception e) {
			
			logger.debug("tbl_rs_cat_brd doesn't exist. creating the table...");
			update("EzCommonDAO.createTblRsCatBrd");
		}
	}
 	
	public void alterCommItemPhotoItemContent() {
		try {
			select("EzCommonDAO.checkCommItemPhotoItemContent");
		} catch (Exception e) {
			logger.debug("TBL_COMM_ITEM PHOTOITEMCONTENT column doesn't exist. creating the column...");
	
			update("EzCommonDAO.alterCommItemPhotoItemContent");
		}
	}

	public void addBoardAttachmentFlag() {
		try {
			select("EzCommonDAO.checkBoardAttachmentFlag");
		} catch (Exception e) {
			logger.debug("tbl_board_info attachmentFlag doesn't exist. creating the column...");

			update("EzCommonDAO.addBoardAttachmentFlag");
		}
	}
    
	public void addTblBoardInfoPublicFlag() {
		try {
			select("EzCommonDAO.checkTblBoardInfoPublicFlag");
		} catch (Exception e) {
			logger.debug("tbl_board_info publicFlag doesn't exist. creating the column...");
			update("EzCommonDAO.addTblBoardInfoPublicFlag");
			update("EzCommonDAO.addTblBoardItemPublicFlag");
			update("EzCommonDAO.addTblBoardItemTempPublicFlag");
		}
	}
	
	/* 2024-10-21 한태훈 - 게시판 > 최근게시물 리스트헤더 추가 */
	public void insertAllBoardListOption(Map<String, Object> map) {
		String allBoardListOption = (String) select("EzCommonDAO.checkAllBoardListOption", map);
		if (allBoardListOption == null) {
			logger.debug("allBoardListOption doesn't exist. insert data...");
			insert("EzCommonDAO.insertAllBoardListOption", map);
		}
	}
	
	/* 2024-10-17 한태훈 - 게시판 > 전체게시물 게시판정보 추가 */
	public void insertAllBoardInfo(Map<String, Object> map) {
		String allBoardInfo = (String) select("EzCommonDAO.checkAllBoardInfo", map);

		if (allBoardInfo == null) {
			logger.debug("allBoardInfo doesn't exist. insert data...");
			insert("EzCommonDAO.insertAllBoardInfo", map);
		}
	}
	
	public void addSurveyTotalNotiSentFlag() {
		try {
			select("EzCommonDAO.checkSurveyTotalNotiSentFlag");
		} catch (Exception e) {
			logger.debug("tbl_survey totalnoti_sent_flag doesn't exist. creating the column...");

			update("EzCommonDAO.addSurveyTotalNotiSentFlag");
		}
	}

	public void createJmochaMailBlocked() throws Exception {
		try {
			select("EzCommonDAO.checkJmochaMailBlocked");
		} catch (Exception e) {
			logger.debug("tbl_c_board attachments column doesn't exist. creating the column...");
			update("EzCommonDAO.createJmochaMailBlocked");
		}
	}

	public void createJmochaCompanyQuota() throws Exception {
		try {
			select("EzCommonDAO.checkJmochaCompanyQuota");
		} catch (Exception e) {
			logger.debug("Table JMOCHA_COMPANY_QUOTA doesn't exist. Creating the table...");
			update("EzCommonDAO.createJmochaCompanyQuota");
		}
	}
	
	public void insertModuleEditor(Map<String, Object> map) throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkModuleEditor", map);

		if (propertyValue == null) {
			logger.debug("ModuleEditor tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertModuleEditor", map);
		}
	}
	
	public void insertServername() throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkServername");

		if (propertyValue == null) {
			logger.debug("127.0.0.1 tenant servername doesn't exist. insert data...");
			insert("EzCommonDAO.insertServername");
		}
	}
	
	public void insertScrapTenantConfig(Map<String, Object> map) throws Exception{
		String propertyValue = (String) select("EzCommonDAO.checkScrapTenantConfig", map);
		
		if (propertyValue == null) {
			logger.debug("Scrap tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertScrapTenantConfig",map);
		}
	}

	public void insertScrapTableHeader(Map<String, Object> map) throws Exception{
		String propertyValue = (String) select("EzCommonDAO.insertScrapTableHeaderCheck", map);

		if (propertyValue == null) {
			logger.debug("ScrapTableHeader doesn't exist. insert data...");
			insert("EzCommonDAO.insertScrapTableHeader",map);
		}
	}
	
	public void createTblBoardScrap() throws Exception {
		try {
			select("EzCommonDAO.checkTblBoardScrap");
		} catch (Exception e) {
			logger.debug("tbl_boarditem_scrap doesn't exist. creating the table...");

			update("EzCommonDAO.createTblBoardScrap");
		}
	}
	
	public void createTblUserScrapCont() throws Exception {
		try {
			select("EzCommonDAO.checkTblUserScrapCont");
		} catch (Exception e) {
			logger.debug("tbl_userscrapcont doesn't exist. creating the table...");

			update("EzCommonDAO.createTblUserScrapCont");
		}
	}
	
	public void createTblUserScrapContList() throws Exception {
		try {
			select("EzCommonDAO.checkTblUserScrapContList");
		} catch (Exception e) {
			logger.debug("tbl_userscrapcontlist doesn't exist. creating the table...");

			update("EzCommonDAO.createTblUserScrapContList");
		}
	}
	public void createTblBoardCommentAttachments() {
		try {
			select("EzCommonDAO.chkTblBoardCommentAttachExist");
		} catch (Exception e) {
			logger.debug("tbl TBL_BOARD_COMMENT_ATTACHMENTS doesn't exist. creating the tbl...");

			update("EzCommonDAO.createTblBoardCommentAttach");
		}
	}
	
	public void alterAddThumbnailForTPI() throws Exception {
		try {
			select(("EzCommonDAO.checkAddThumbnailForTPI"));
		} catch (Exception e) {
			logger.debug("tbl_photo_imageitem addThumbnail column doesn't exist. creating the column...");
			update("EzCommonDAO.alterAddThumbnailForTPI");
		}
	}
	
	public void alterThumbnailExtForTPI() throws Exception {
		try {
			select(("EzCommonDAO.checkThumbnailExtForTPI"));
		} catch (Exception e) {
			logger.debug("tbl_photo_imageitem thumbnailExt column doesn't exist. creating the column...");
			update("EzCommonDAO.alterThumbnailExtForTPI");
		}
	}
		
	public void alterAttachmentsForCBoard() throws Exception {
		try {
			select(("EzCommonDAO.checkAttachmentsForCBoard"));
		} catch (Exception e) {
			logger.debug("tbl_c_board attachments column doesn't exist. creating the column...");
			update("EzCommonDAO.alterAttachmentsForCBoard");
		}
	}

	public void addIsDeleteBlockToSytemConfig() throws Exception {
		try {
			select("EzCommonDAO.checkIsDeleteBlock");
		} catch (Exception e) {
			logger.debug("tbl_systemconfig isdeleteblock column doesn't exist. creating the column...");
			update("EzCommonDAO.createIsDeleteBlock");
		}		
	}

	public void addTblCommunityClubguestOnelinereply() {
		try {
			select("EzCommonDAO.checkTblCommunityClubguestOnelinereply");
		} catch (Exception e) {
			logger.debug("In TBL_C_CLUBGUEST_ONELINEREPLY doesn't exist. creating the table...");

			update("EzCommonDAO.createTblCommunityClubguestOnelinereply");
		}
	}
	
	/* 2024-09-11 이유정 - 게시판 > 최근게시물 리스트헤더 추가 */
	public void insertBoardItemListOptionAN(Map<String, Object> map) {
		String boardItemListOptionAN = (String) select("EzCommonDAO.checkBoardItemListOptionAN", map);

		if (boardItemListOptionAN == null) {
			logger.debug("BoardItemListOptionAN doesn't exist. insert data...");
			insert("EzCommonDAO.insertBoardItemListOptionAN", map);
		}
	}
	
	/* 2024-09-11 이유정 - 게시판 > 최근게시물 게시판정보 추가 */
	public void insertRecentBoardInfo(Map<String, Object> map) {
		String recentBoardInfo = (String) select("EzCommonDAO.checkRecentBoardInfo", map);

		if (recentBoardInfo == null) {
			logger.debug("RecentBoardInfo doesn't exist. insert data...");
			insert("EzCommonDAO.insertRecentBoardInfo", map);
		}
	}
	
	public void addBoardAllNewBoardFlag() {
		try {
			select("EzCommonDAO.checkBoardAllNewBoardFlag");
		} catch (Exception e) {
			logger.debug("tbl_board_info allNewBoardFlag doesn't exist. creating the column...");

			update("EzCommonDAO.addBoardAllNewBoardFlag");
		}
	}

	public void addBoardAllNewBoardListDate() {
		try {
			select("EzCommonDAO.checkAllNewBoardListDate");
		} catch (Exception e) {
			logger.debug("tbl_board_configuration allNewBoardListDate doesn't exist. creating the column...");

			update("EzCommonDAO.addBoardAllNewBoardListDate");
		}
	}

	public void insertAprAutoSaveConfig(Map<String, Object> map) throws Exception{
		String propertyValue = (String) select("EzCommonDAO.checkAprAutoSaveConfig",map);

		if (propertyValue == null) {
			logger.debug("AprAutoSaveConfig doesn't exist. insert data...");
			insert("EzCommonDAO.insertAprAutoSaveConfig",map);
		}
	}

	// 2024-12-04 기민혁 - 전자결재 > 최근서식 사용여부 테넌트 컨피그 추가
	public void insertResendFormYN(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkResendFormYN", map);

		if (propertyValue == null) {
			logger.debug("ResendFormYN tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertResendFormYN", map);
		}
	}

	// 2024-12-05 기민혁 - 전자결재 > 본문수정 시 본문버전 변경 기능 사용여부 테넌트 컨피그 추가
	public void insertEditVertionYN(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkEditVertionYN", map);

		if (propertyValue == null) {
			logger.debug("EditVertionYN tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertEditVertionYN", map);
		}
	}

	// 2024-12-10 기민혁 - 전자결재 > 수정버전,수정모드 컬럼 추가
	public void alterEditVersionHistory() {
		try {
			select("EzCommonDAO.checkEditVersionHistory");
		} catch (Exception e) {
			logger.debug("In TBL_HISTORYDOCINFO doesn't exist checkEditVersionHistory column. creating the column...");

			update("EzCommonDAO.alterEditVersionHistory");
		}
	}

	// 2024-12-10 기민혁 - 수정버전 리스트 해더 생성
	public void insertEditVersionListOption(Map<String, Object> map) {
		String optionCheck = (String) select("EzCommonDAO.checkEditVersionListOption", map);

		if (optionCheck == null) {
			logger.debug("EditVersionList Header Option doesn't exist. insert data...");
			insert("EzCommonDAO.insertEditVersionListOption", map);
		}
	}

	// 2024-11-26 기민혁 - 전자결재 > 개인수신함 사용여부 테넌트 컨피그 추가
	public void insertPersonalHideSusinYN(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkPersonalHideSusinYN", map);

		if (propertyValue == null) {
			logger.debug("PersonalHideSusinYN tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertPersonalHideSusinYN", map);
		}
	}
	
	// 2024-11-28 기민혁 - 개인 수신함 리스트 해더 추가
	public void insertPersonalSusinListOption(Map<String, Object> map) {
		String optionCheck = (String) select("EzCommonDAO.checkPersonalSusinListOption", map);
		
		if (optionCheck == null) {
			logger.debug("PersonalSusinList Header Option doesn't exist. insert data...");
			insert("EzCommonDAO.inserPersonalSusinListOption", map);
		}
	}

	/* 2024-07-05 양지혜 - 전자결재 > 상위부서문서함 사용여부 컬럼 추가 */
	public void alterUseUpperDeptBox() {
		try {
			select(("EzCommonDAO.checkUseUpperDeptBox"));
		} catch (Exception e) {
			logger.debug("TBL_DEPTMASTER USEUPPERDEPTBOX column doesn't exist. creating the column...");

			update("EzCommonDAO.alterUseUpperDeptBox");
		}
	}

	/* 2025-03-10 유지아 - 톡알림 테이블 tenantId추가 */
	public void alterTalkNotiTenant() {
		try {
			select(("EzCommonDAO.checkTalkNotiTenant"));
		} catch (Exception e) {
			logger.debug("talk_tblnotification tenantId column doesn't exist. creating the column...");

			update("EzCommonDAO.alterTalkNotiTenant");
		}
	}

	public void alterServerNameMain() {
		try {
			select(("EzCommonDAO.checkServerNameMain"));
		} catch (Exception e) {
			logger.debug("tbl_tenant_servername mainyn column doesn't exist. creating the column...");

			update("EzCommonDAO.alterServerNameMain");
		}
	}

	public void alterBodyHTMLToConnData() {
		try {
			select(("EzCommonDAO.checkBodyHTMLToConnData"));
		} catch (Exception e) {
			logger.debug("TBL_CONNDATA BODYHTML column doesn't exist. changing the column...");

			update("EzCommonDAO.changeBodyHTMLToConnData");
		}
	}
	
	// 2024-12-27 이가은 - 공람완료문서 삭제 히스토리 테이블 생성
	public void createGongramDeleteHistory() {
		try {
			select("EzCommonDAO.checkGongramDeleteHistory");
		} catch (Exception e) {
			logger.debug("createGongramDeleteHistory doesn't exist. creating the table...");
			update("EzCommonDAO.createGongramDeleteHistory");
		}
	}

	public void alterBoardInfoWriterFlag() {
		try {
			select("EzCommonDAO.checkBoardInfoWriterFlag");
		} catch (Exception e) {
			logger.debug("tbl_board_boardinfo writerflag doesn't exist. creating the column...");

			update("EzCommonDAO.alterBoardInfoWriteFlag");
		}
	}

	public void alterBoardItemWriterNameType() {
		try {
			select("EzCommonDAO.checkBoardItemWriterNameType");
		} catch (Exception e) {
			logger.debug("tbl_board_item writerNameType doesn't exist. creating the column...");

			update("EzCommonDAO.addBoardItemWriterNameType");
		}
	}

    public void alterBoardItemTempWriterNameType() {
		try {
			select("EzCommonDAO.checkBoardItemTempWriterNameType");
		} catch (Exception e) {
			logger.debug("tbl_board_item_temp writerNameType doesn't exist. creating the column...");

			update("EzCommonDAO.addBoardItemTempWriterNameType");
		}
    }

	// 2023-09-27 임정은 - 일정관리 > 일정 모아보기 그룹 테이블 추가
	public void createTblScheduleGather() {
		try {
			select("EzCommonDAO.checkTblScheduleGather");
		} catch (Exception e) {
			logger.debug("tbl_schedulegather doesn't exist. creating the table...");

			update("EzCommonDAO.createTblScheduleGather");
		}
		try {
			select("EzCommonDAO.checkTblScheduleGatherMember");
		} catch (Exception e) {
			logger.debug("tbl_schedulegathermember doesn't exist. creating the table...");

			update("EzCommonDAO.createTblScheduleGatherMember");
		}
	}

	public void addMemberDeptIdScheduleGroupMember() throws Exception {
		try {
			select("EzCommonDAO.checkMemberDeptIdAtScheduleGroupMember");
		} catch (Exception e) {
			logger.debug("TBL_SCHEDULEGROUPMEMBER MEMBERDEPTID doesn't exist. creating the column...");
			
			update("EzCommonDAO.addMemberDeptIdScheduleGroupMember");
		}
	}
	
	public void addMemberDeptIdScheduleGatherMember() throws Exception {
		try {
			select("EzCommonDAO.checkMemberDeptIdAtScheduleGatherMember");
		} catch (Exception e) {
			logger.debug("TBL_SCHEDULEGATHERMEMBER MEMBERDEPTID doesn't exist. creating the column...");
			
			update("EzCommonDAO.addMemberDeptIdScheduleGatherMember");
		}
	}

	public void createTblBoardStarRating() throws Exception {
		// 게시판 > 별점 평가하기 여부 저장 테이블 추가
		try {
			select("EzCommonDAO.checkTblBoardStarRatingItem");
		} catch (Exception e) {
			logger.debug("tbl_board_item_rating doesn't exist. creating the table...");

			update("EzCommonDAO.createTblBoardStarRatingItem");
		}

		// 게시판 > 게시물 별 총점, 평균 저장 테이블 추가
		try {
			select("EzCommonDAO.checkTblBoardStarRatingSummary");
		} catch (Exception e) {
			logger.debug("tbl_board_item_rating_summary doesn't exist. creating the table...");

			update("EzCommonDAO.createTblBoardStarRatingSummary");
		}

		// 게시판 > 별점 평가하기 사용여부 옵션 칼럼 추가
		try {
			select("EzCommonDAO.checkTblBoardInfoStarRatingFlag");
		} catch (Exception e) {
			logger.debug("tbl_board_info starRatingFlag doesn't exist. creating the column...");

			update("EzCommonDAO.addBoardStarRatingFlag");
		}
	}
	
	public void createMealPlanTable() {
		try {
			select("EzCommonDAO.checkMealPlanTable");
		} catch (Exception e) {
			logger.debug("Table TBL_MEAL_PLAN doesn't exist. Creating the table...");
			update("EzCommonDAO.createMealPlanTable");
		}
	}

	public void insertMealPlanTenantConfig(int tenantId) {
		String propertyValue = (String) select("EzCommonDAO.checkUseMealPlan", tenantId);

		if (propertyValue == null) {
			logger.debug("UseMealPlan doesn't exist. insert data...");
			insert("EzCommonDAO.insertUseMealPlan", tenantId);
		}
	}

	public void insertMealPlanBoardInfo(int tenantId) throws Exception{
		String propertyValue = (String) select("EzCommonDAO.checkHasMealPlanBoard", tenantId);
		
		if (propertyValue == null) {
			logger.debug("MealPlanBoard doesn't exist. insert data...");
			insert("EzCommonDAO.insertMealPlanBoard", tenantId);
		}
	}

	public void createTblStatMenu() {
		try {
			select("EzCommonDAO.checkTblStatMenuUser");
		} catch (RuntimeException e) {
			logger.debug("TBL_STAT_MENU_USER doesn't exist. creating the table...");

			update("EzCommonDAO.createTblStatMenuUser");
		}

		try {
			select("EzCommonDAO.checkTblStatMenuUserMonth");
		} catch (RuntimeException e) {
			logger.debug("TBL_STAT_MENU_USER_MONTH doesn't exist. creating the table...");

			update("EzCommonDAO.createTblStatMenuUserMonth");
		}

		try {
			select("EzCommonDAO.checkTblStatMenuDept");
		} catch (RuntimeException e) {
			logger.debug("TBL_STAT_MENU_DEPT doesn't exist. creating the table...");

			update("EzCommonDAO.createTblStatMenuDept");
		}


		try {
			select("EzCommonDAO.checkTblStatMenuDeptMonth");
		} catch (RuntimeException e) {
			logger.debug("TBL_STAT_MENU_DEPT_MONTH doesn't exist. creating the table...");

			update("EzCommonDAO.createTblStatMenuDeptMonth");
		}
	}

	public void insertUseSaasYN() {
		String propertyValue = (String) select("EzCommonDAO.checkUseSaasYN");

		if (propertyValue == null) {
			logger.debug("useSaasYN doesn't exist. insert data...");
			insert("EzCommonDAO.insertUseSaasYN");
		}
	}

	public void inserExtLargeFilesever() {
		String propertyValue = (String) select("EzCommonDAO.checkUseExtLargeFilesever");

		if (propertyValue == null) {
			logger.debug("useExternalLargeFileServer doesn't exist. insert data...");
			insert("EzCommonDAO.inserUseExtLargeFilesever");
		}

		String propertyValue2 = (String) select("EzCommonDAO.checkExtLargeFileseverUrl");

		if (propertyValue2 == null) {
			logger.debug("externalFileServerUrl doesn't exist. insert data...");
			insert("EzCommonDAO.inserExtLargeFileseverUrl");
		}
	}

	public String getMobileLang(String userID, int tenantID)  throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
    	
    	map.put("userID", userID);
    	map.put("tenantID", tenantID);
    	
        return (String) select("EzCommonDAO.getMobileLang", map);
	}
	public void createJournalListLang() {
		try {
			select("EzCommonDAO.checkJournallListLang");
		} catch (RuntimeException e) {
			logger.debug("checkJourlListLang doesn't exist. insert data...");
		
			// 컬럼 생성
			update("EzCommonDAO.createJournalListLang");
		}
	}
	
	public void insertJournalListLang(Map<String, Object> map1, Map<String, Object> map2, Map<String, Object> map3, Map<String, Object> map4, Map<String, Object> map5, Map<String, Object> map6) {
		int journalListLangCnt = (int) select("EzCommonDAO.countJournalListLang");
		
		// 기본양식 다국어 데이터 삽입
		if (journalListLangCnt < 1) {
			update("EzCommonDAO.insertDailyJournalListLang", map1);
			update("EzCommonDAO.insertWeekJournalListLang", map2);
			update("EzCommonDAO.insertMonthlyJournalListLang", map3);
			update("EzCommonDAO.insertQuarterJournalListLang", map4);
			update("EzCommonDAO.insertHalfYearJournalListLang", map5);
			update("EzCommonDAO.insertAnnualJournalListLang", map6);
		}
	}
	
	public void alterScheduleDefaultViewCheck() {
		try {
			select("EzCommonDAO.checkScheduleDefaultViewCheck");
		} catch (Exception e) {
			logger.debug("tbl_scheduleconfig defaultviewcheck doesn't exist. creating the column...");

			update("EzCommonDAO.addScheduleDefaultViewCheck");
		}
		
	}

	public void createUserScheduleTypeConfigTable() {
		try {
			select("EzCommonDAO.checkUserScheduleTypeConfigTable");
		} catch (Exception e) {
			logger.debug("TBL_USER_SCHEDULE_TYPE_CONFIG doesn't exist. creating the table...");

			update("EzCommonDAO.createUserScheduleTypeConfigTable");
		}
	}

	public void addMailboxProgressStateColumns() {
		try {
			select("EzCommonDAO.checkMailboxProgressStateColumns");
		} catch (Exception ignore) {
			logger.debug("JMOCHA_MAILBOX_PROGRESS.STATE, STATE_DESCRIPTION column doesn't exist. creating the column...");
			update("EzCommonDAO.addMailboxProgressStateColumns");
		}
	}

	// 2024-12-05 한태훈 - 게시판 > 게시판 버전관리 테이블 추가
	public void createTblBoardModifyHistory() throws Exception {
		try {
			select("EzCommonDAO.checkTblBoardModifyHistory");
		} catch (Exception e) {
			
			logger.debug("tbl_board_modifyhistory doesn't exist. creating the table...");
			update("EzCommonDAO.createTblBoardModifyHistory");
		}
	}

	/* 2024-07-22 양지혜 - 관리자 > 전자결재 > 발송현황 메뉴 표출여부 */
	public void insertUseSendOutState(Map<String, Object> map) throws Exception {
		String propertyValue = (String) select("EzCommonDAO.getTenantConfig", map);

		if (propertyValue == null) {
			logger.debug("useSendOutState tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertUseSendOutState", map);
		}
	}


	// 2025-06-16 이혜림 - 게시판 > 본문 크기 컬럼 추가
	public void addBoardContentSize() {
		try {
			select("EzCommonDAO.checkAddBoardContentSize");
		} catch (Exception e) {
			logger.debug("In TBL_Board_Configuration doesn't exist ContentSize column. creating the column...");

			update("EzCommonDAO.addBoardContentSize");
		}
	}
	
	public void updateMobilePortletMenuId() throws Exception {
		try {
			if ((int)select("EzCommonDAO.checkMobilePortletMenuId") == 1) {
				logger.debug("checkMobilePortletMenuId mobile menuId insert wrong Data. update data...");
				// portlet
				update("EzCommonDAO.updateMobileMenuBoardId");
				update("EzCommonDAO.updateMobileMenuApprovalId");
				update("EzCommonDAO.updateMobileMenuMailId");
				update("EzCommonDAO.updateMobileMenuResourceId");
				update("EzCommonDAO.updateMobileMenuScheduleId");
				// portlet_comp
				update("EzCommonDAO.updateMobileMenuBoardIdComp");
				update("EzCommonDAO.updateMobileMenuApprovalIdComp");
				update("EzCommonDAO.updateMobileMenuMailIdComp");
				update("EzCommonDAO.updateMobileMenuResourceIdComp");
				update("EzCommonDAO.updateMobileMenuScheduleIdComp");
				// portlet_name
				update("EzCommonDAO.updateMobileMenuBoardIdName");
				update("EzCommonDAO.updateMobileMenuApprovalIdName");
				update("EzCommonDAO.updateMobileMenuMailIdName");
				update("EzCommonDAO.updateMobileMenuResourceIdName");
				update("EzCommonDAO.updateMobileMenuScheduleIdName");
				// portlet_user
				update("EzCommonDAO.updateMobileMenuBoardIdUser");
				update("EzCommonDAO.updateMobileMenuApprovalIdUser");
				update("EzCommonDAO.updateMobileMenuMailIdUser");
				update("EzCommonDAO.updateMobileMenuResourceIdUser");
				update("EzCommonDAO.updateMobileMenuScheduleIdUser");
				// portlet_user
				update("EzCommonDAO.updateMobileMenuBoardIdUser");
				update("EzCommonDAO.updateMobileMenuApprovalIdUser");
				update("EzCommonDAO.updateMobileMenuMailIdUser");
				update("EzCommonDAO.updateMobileMenuResourceIdUser");
				update("EzCommonDAO.updateMobileMenuScheduleIdUser");
				// portlet_theme
				update("EzCommonDAO.updateMobileMenuBoardIdTheme");
				update("EzCommonDAO.updateMobileMenuApprovalIdTheme");
				update("EzCommonDAO.updateMobileMenuMailIdTheme");
				update("EzCommonDAO.updateMobileMenuResourceIdTheme");
				update("EzCommonDAO.updateMobileMenuScheduleIdTheme");
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}
	
	// 2024-08-27 유길상 - 자원관리 > 자원등록 > 최대 예약 가능 기간 컬럼 추가
	public void alterTblRsBrdResMaxDate() {
		try {
			select("EzCommonDAO.checkTblRsBrdResMaxDate");
		} catch (Exception e) {
			logger.debug("TBL_RS_BRD RES_MAX_DATE column doesn't exist. creating the column...");
			
			update("EzCommonDAO.alterTblRsBrdResMaxDate");
		}
	}
	
	// 2024-08-27 유길상 - 자원관리 > 자원등록 > 최대 예약 가능 기간 컬럼 추가
	public void alterTblRsBrdResMaxUserCnt() {
		try {
			select("EzCommonDAO.checkTblRsBrdResMaxUserCnt");
		} catch (Exception e) {
			logger.debug("TBL_RS_BRD RES_MAX_USER_CNT column doesn't exist. creating the column...");
			
			update("EzCommonDAO.alterTblRsBrdResMaxUserCnt");
		}
	}
	
	 /* 2023-10-30 조소정 - 게시판 사용안함 여부 컬럼 추가 */
	 public void addBoardNotUsedFlag() throws Exception {
		 try {
			 select("EzCommonDAO.checkBoardNotUsedFlag");
		 } catch (Exception e) {
			 logger.debug("tbl_board_info notusedflag doesn't exist. creating the column...");
	
	         update("EzCommonDAO.addBoardNotUsedFlag");
	     }
	 }

	// 2025-07-07 이유정 - 일정관리 > 임원일정 조회 가능 범위 설정 컨피그 추가
	public void insertExecutiveScheduleConfig(Map<String, Object> map) {
		String executiveScheduleConfig = (String) select("EzCommonDAO.checkExecutiveScheduleConfig", map);

		if (executiveScheduleConfig == null) {
			logger.debug("useExecSchedulePublic tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertExecutiveScheduleConfig", map);
		}
	}

	public void alterTblClubUserGradeColumn() {
		try {
			select("EzCommonDAO.checkTblClubUserGradeColumn");
		} catch (Exception e) {
			logger.debug("In TBL_C_CLUBUSER doesn't exist GRADE column. creating the column...");

			update("EzCommonDAO.alterTblClubUserGradeColumn");
		}
	}

	public void alterTblClubJoinGradeColumn() {
		try {
			select("EzCommonDAO.checkTblClubJoinGradeColumn");
		} catch (Exception e) {
			logger.debug("In TBL_C_CLUB doesn't exist JOIN_GRADE, MEMLIST_READGRADE column. creating the column...");

			update("EzCommonDAO.alterTblClubJoinGradeColumn");
		}
	}

	public void createTblCommunityGradeTable() throws Exception {
		try {
			select("EzCommonDAO.checkTblCommunityGradeTable");
		} catch (Exception e) {
			logger.debug("TBL_C_GRADE doesn't exist. creating the table...");

			update("EzCommonDAO.createTblCommunityGradeTable");
		}
	}

	public void delCommBrdManageData() throws Exception {
		try {
			if ((int) select("EzCommonDAO.checkCommBrdManageData1") > 0) {
				logger.debug("Deleting data from TBL_COMM_BOARDMANAGE...");

				delete("EzCommonDAO.delCommBrdManageData");
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}

	public void updateCommBrdManageData() throws Exception {
		try {
			if ((int) select("EzCommonDAO.checkCommBrdManageData2") > 0) {
				logger.debug("Updating data from TBL_COMM_BOARDMANAGE...");

				update("EzCommonDAO.updateCommBrdManageData");
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}

	public void updateClubUserGrade() throws Exception {
		try {
			if ((int) select("EzCommonDAO.checkClubUserGrade") > 0) {
				logger.debug("Updating data from TBL_C_CLUBUSER...");

				update("EzCommonDAO.updateClubUserGrade");
			}
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
	}

	public List<CommunityClubVO> selectClubsNotInGradeList() throws Exception {
		return (List<CommunityClubVO>) list("EzCommonDAO.selectClubsNotInGradeList");
	}

    // 2025-07-15 이유정 - 커뮤니티 > 운영자권한 컬럼 추가
    public void alterTblClubUserAdminAuthColumn() {
        try {
            select("EzCommonDAO.checkTblClubUserAdminAuthColumn");
        } catch (Exception e) {
            logger.debug("In TBL_C_CLUBUSER doesn't exist ADMIN_AUTH column. creating the column...");

			update("EzCommonDAO.alterTblClubUserAdminAuthColumn");
		}
	}

	// 2025-07-23 이유정 - 커뮤니티 > 회원탈퇴일자 컬럼 추가
	public void alterTblClubUserWithdrawDateColumn() {
		try {
			select("EzCommonDAO.checkTblClubUserWithdrawDateColumn");
		} catch (Exception e) {
			logger.debug("In TBL_C_CLUBUSER doesn't exist C_WITHDRAWDATE column. creating the column...");

			update("EzCommonDAO.alterTblClubUserWithdrawDateColumn");
		}
	}

	//2025-02-13 김대현 - 메일 > 메일 미리보기 기능 추가
	public void addMailPreviewConfig(Map<String, Object> map) {
		String propertyValue = (String) select("EzCommonDAO.checkMailPreviewConfig" ,map);
		
		if (propertyValue == null) {
			logger.debug("tbl_tenant_config useMailPreviewConfig doesn't exist. creating the column...");

			update("EzCommonDAO.addMailPreviewConfig",map);
		}
	}

	public void alterTblUsermasterForTeams() throws Exception {
		try {
			select("EzCommonDAO.checkTeamsIdColumn");
		} catch (Exception e) {
			logger.debug("tbl_usermaster TeamsId doesn't exist. creating the column...");
			update("EzCommonDAO.addTeamsIdColumn");
		}
	}

	public void createAuthTokenTable() {
		try {
			select("EzCommonDAO.checkAuthTokenTable");
		} catch (Exception e) {
			logger.debug("Table TBL_AUTHTOKEN doesn't exist. Creating the table...");
			update("EzCommonDAO.createAuthTokenTable");
		}
	}

	public void createUserPresenceTable() {
		try {
			select("EzCommonDAO.checkUserPresenceTable");
		} catch (Exception e) {
			logger.debug("Table TBL_USERPRESENCE doesn't exist. Creating the table...");
			update("EzCommonDAO.createUserPresenceTable");
		}
	}
	
}
