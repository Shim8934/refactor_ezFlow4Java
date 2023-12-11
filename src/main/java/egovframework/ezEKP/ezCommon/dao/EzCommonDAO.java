package egovframework.ezEKP.ezCommon.dao;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCommon.vo.ApprovPWDVO;
import egovframework.ezEKP.ezCommon.vo.CompanyInfoVO;
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

    @Autowired
	private Properties globals;
    
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

	/* 2021-09-10 김은실 - 메신저/인사 연동 효율성을 위한: 프로필사진 업데이트시각(PHOTO_UPDATEDT) 컬럼 추가 */
	public void addUserMasterPhotoUpdateDT() throws Exception {
		try {
			select("EzCommonDAO.checkUserMasterPhotoUpdateDT");
		} catch (Exception e) {
			logger.debug("tbl_usermaster PHOTO_UPDATEDT column doesn't exist. creating the column...");

			update("EzCommonDAO.addUserMasterPhotoUpdateDT");
		}
	}

	/* 2022-01-19 김은실 - alter 재사용 모듈 추가 */
	public void alter_AnyTbl_AnyColumns(Map<String, Object> map) throws Exception {
		try {
			select("EzCommonDAO.check_AnyTbl_AnyColumns", map);
		} catch (Exception e) {
			logger.debug("{} {} column doesn't exist. creating the column...", map.get("TBL_NAME"), map.get("COLUMN_NAME"));

			update("EzCommonDAO.add_AnyTbl_AnyColumns", map);
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
	
	public void addBoardLikeFlag() throws Exception {
		try {
			select("EzCommonDAO.checkTblBoardInfoLikeFlag");
		} catch (Exception e) {
			logger.debug("tbl_board_info likeFlag doesn't exist. creating the column...");
			
			update("EzCommonDAO.addBoardLikeFlag");
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
	
	public void addSurveyAlamColums() {
		try {
			select("EzCommonDAO.checkSurveyAlamColums");
		} catch (Exception e) {
			logger.debug("tbl_survey addSurveyAlamColums doesn't exist. creating the column...");
			
			update("EzCommonDAO.addSurveyAlamColums");
		}
	}
		
	public void addMsgInMailSearch() {
		try {
			if ((int) select("EzCommonDAO.checkMsgInMailSearch") == 0) {
				update("EzCommonDAO.updateMsgInMailSearch");
			}
		} catch (Exception e) {
			logger.debug("addMsgInMailSearch() ERROR...");
			logger.error(e.getMessage(), e);
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
	
	public void createTblResourcePortlet() throws Exception {
		try {
			select("EzCommonDAO.checkResourcePortlet");
		} catch (Exception e) {
			logger.debug("tbl_rs_persportlet doesn't exist. creating the table...");
			
			update("EzCommonDAO.createTblResourcePortlet");
		}
	}

	public void addThemeContent2() throws Exception {
		try {
			select("EzCommonDAO.checkThemeContent2");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme themeContent2 doesn't exist. creating the column...");
			
			update("EzCommonDAO.addThemeContent2");
			update("EzCommonDAO.insertThemeContent2");
		}
	}

	public void addThemeContent3() throws Exception {
		try {
			select("EzCommonDAO.checkThemeContent3");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme themeContent3 doesn't exist. creating the column...");
			
			update("EzCommonDAO.addThemeContent3");
			update("EzCommonDAO.insertThemeContent3");
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
	
	public void addSnMenuAuth() {
		try {
			select("EzCommonDAO.checkSnMenuAuth");
		} catch (Exception e) {
			logger.debug("tbl_portal_menu_auth sn doesn't exist. creating the column...");
			
			update("EzCommonDAO.snMenuAuth");
		}
	}
	
	public void addBoardManageTypeColumn() {
		try {
			select("EzCommonDAO.checkBoardManageTypeColumn");
		} catch (Exception e) {
			logger.debug("tbl_board_boardmanage type doesn't exist. creating the column...");
			
			update("EzCommonDAO.addBoardManageTypeColumn");
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
	
	public void addSurveyMailSentFlagColumn() {
		try {
			select("EzCommonDAO.checkSurveyMailSentFlagColumn");
		} catch (Exception e) {
			logger.debug("tbl_survey mail_sent_flag doesn't exist. creating the column...");
			
			update("EzCommonDAO.addSurveyMailSentFlagColumn");
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<LoginVO> getPermissionGroupMembers(Map<String, Object> map) throws Exception {
		return (List<LoginVO>) list("EzCommonDAO.getPermissionGroupMembers", map);
	}

	public void addSnThemeAuth() {
		try {
			select("EzCommonDAO.checkSnThemeAuth");
		} catch (Exception e) {
			logger.debug("tbl_portal_theme_auth sn doesn't exist. creating the column...");
			
			update("EzCommonDAO.snThemeAuth");
		}
	}

	public void addSnPortletAuth() {
		try {
			select("EzCommonDAO.checkSnPortletAuth");
		} catch (Exception e) {
			logger.debug("tbl_portal_portlet_auth sn doesn't exist. creating the column...");
			
			update("EzCommonDAO.snPortletAuth");
		}
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
	
	public void addOpenGovFlag() {
		try {
			select("EzCommonDAO.checkOpenGovFlag");
		} catch (Exception e) {
			logger.debug("tbl_forminfo openGovFlag doesn't exist. creating the column...");

			update("EzCommonDAO.addOpenGovFlag");
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
		
	public void addIsBeforeDoc() throws Exception {
		try {
			select("EzCommonDAO.checkAddIsBeforeDoc");
		} catch (Exception e) {
			logger.debug("tbl_historydocinfo ISBEFOREDOC column doesn't exist. creating the column...");
			
			update("EzCommonDAO.updateAddIsBeforeDoc");
		}
	}

	public void addBeforeDocUrl() throws Exception {
		try {
			select("EzCommonDAO.checkAddBeforeDocUrl");
		} catch (Exception e) {
			logger.debug("tbl_historydocinfo BEFOREDOCURL column doesn't exist. creating the column...");
			
			update("EzCommonDAO.updateAddBeforeDocUrl");
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
	
	public void addAprAttachViewOrder() throws Exception {
		try {
			select("EzCommonDAO.checkAprAttachViewOrder");
		} catch (Exception e) {
			logger.debug("tbl_aprattachinfo VIEWORDER column doesn't exist. creating the column...");
			
			update("EzCommonDAO.updateAprAttachViewOrder");
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
	
	public void addAprEndAttachViewOrder() throws Exception {
		try {
			select("EzCommonDAO.checkAprEndAttachViewOrder");
		} catch (Exception e) {
			logger.debug("tbl_endattachinfo VIEWORDER column doesn't exist. creating the column...");
			
			update("EzCommonDAO.updateAprEndAttachViewOrder");
		}
	}
	
	public void addAprTmpAttachViewOrder() throws Exception {
		try {
			select("EzCommonDAO.checkAprTmpAttachViewOrder");
		} catch (Exception e) {
			logger.debug("tbl_tmpattachinfo VIEWORDER column doesn't exist. creating the column...");
			
			update("EzCommonDAO.updateAprTmpAttachViewOrder");
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

	public void addFormAprOptionColumn() {
		try {
			select("EzCommonDAO.checkFormAprOptionColumn");
		} catch (Exception e) {
			logger.debug("tbl_forminfo APROPTION column doesn't exist. creating the column...");
			
			update("EzCommonDAO.updateFormAprOptionColumn");
		}
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
	
	public void addDocStateIntoLastLines() {
		try {
			select("EzCommonDAO.checkDocStateIntoLastLines");
		} catch (Exception e) {
			logger.debug("TBL_LASTAPRLINE docState column doesn't exist. creating the column...");

			update("EzCommonDAO.updateDocStateIntoLastLines");
			
			// 오라클의 경우, 기존 프라이머리 키 제거하고 새로운 키 삽입하는 동작 추가
			if (globals.getProperty("Globals.DbType").equals("oracle")) {
				update("EzCommonDAO.deleteLastAprLinePrimaryKey");
				update("EzCommonDAO.addLastAprLinePrimaryKey");
			}
		}
	}

	public void addDocStateIntoLastDeptLines() {
		try {
			select("EzCommonDAO.checkDocStateIntoLastDeptLines");
		} catch (Exception e) {
			logger.debug("TBL_LASTDEPTLINE docState column doesn't exist. creating the column...");

			update("EzCommonDAO.updateDocStateIntoLastDeptLines");
			
			// 오라클의 경우, 기존 프라이머리 키 제거하고 새로운 키 삽입하는 동작 추가
			if (globals.getProperty("Globals.DbType").equals("oracle")) {
				update("EzCommonDAO.deleteLastDeptLinePrimaryKey");
				update("EzCommonDAO.addLastDeptLinePrimaryKey");
			}
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
	
	public void alterTblPsApprovNotiMailConf() {
		try {
			select("EzCommonDAO.checkTblPsApprovNotiMailConf");
		} catch (Exception e) {
			logger.debug("tbl_ps_approvnotimailconf linePass doesn't exist. creating the column...");
			
			update("EzCommonDAO.alterTblPsApprovNotiMailConf");
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

	public void insertDailyWorkAttitudeColumn() {
		try {
			select("EzCommonDAO.checkDailyWorkAttitudeColumn");
		} catch (Exception e) {
			logger.debug("tbl_attitude WORK_STATUS column doesn't exist. creating the column...");
			
			update("EzCommonDAO.createDailyWorkAttitudeColumn");
		}
	}
	
	public void createMenuTenantConfig(Map<String, Object> map) throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkTenantConfig", map);
		
		if (propertyValue == null) {
			logger.debug("menu tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertSurveyTenantConfig", map);
		}
	}

	public void addPassAprLineFlagColumn() throws Exception {
		try {
			select("EzCommonDAO.checkFormPassAprLineFlagColumn");
		} catch (Exception e) {
			logger.debug("tbl_forminfo PASSAPRLINEFLAG column doesn't exist. creating the column...");
			
			update("EzCommonDAO.updateFormPassAprLineFlagColumn");
		}
	}

   public void addFormSihangTypeColumn() {
        try {
            select("EzCommonDAO.checkFormSihangTypeColumn");
        } catch (Exception e) {
            logger.debug("tbl_forminfo SIHANGTYPE column doesn't exist. creating the column...");
            
            update("EzCommonDAO.updateFormSihangTypeColumn");
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
	
	public int checkPortletCodeString(Map<String, Object> map) {
		return (int) select("EzCommonDAO.checkPortletCodeString", map);
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
				logger.debug("insert portlet data");
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

	// 2020-10-19 김은실 - 웹폴더 > 하위부서 허용 여부 추가	
	public void addWebfolderUserSubdeptPermittedColumn() throws Exception {
		try {
			select("EzCommonDAO.checkWebfolderUserSubdeptPermittedColumn");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_user SUBDEPT_PERMITTED column doesn't exist. creating the column...");
			
			update("EzCommonDAO.createWebfolderUserSubdeptPermittedColumn");
		}
	}
	
	/* 2020-12-08 김은실 - [카이스트] 웹폴더 > 폴더 담당자 추가 */
	public void addWebfolderUserFolderManagerColumn() throws Exception {
		try {
			select("EzCommonDAO.checkWebfolderUserFolderManagerColumn");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_folderuser FOLDER_MANAGER column doesn't exist. creating the column...");
			// FOLDER_MANAGER : (카이스트) 폴더담당자 (1레벨만 해당)
			update("EzCommonDAO.createWebfolderUserFolderManagerColumn");
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
			select("EzCommonDAO.checkWebfolderFileVersionColumn");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_file VERSION column doesn't exist. creating the column...");
			update("EzCommonDAO.createWebfolderFileVersionColumn");
		}

		try {
			select("EzCommonDAO.checkWebfolderVersionTable");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_version table doesn't exist. creating the table...");
			update("EzCommonDAO.createWebfolderVersionTable");
		}
	}
	
	public void createWebfolderHierarchicalColumns() {
		try {
			select("EzCommonDAO.checkWebfolderFileDepthColumn");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_file DEPTH column doesn't exist. creating the column...");
			update("EzCommonDAO.createWebfolderFileDepthColumn");
		}

		try {
			select("EzCommonDAO.checkWebfolderFileRootIdColumn");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_file ROOT_ID column doesn't exist. creating the column...");
			update("EzCommonDAO.createNullableWebfolderFileRootIdColumn");
			update("EzCommonDAO.updateWebfolderFileRootIdColumn");
		}

		try {
			select("EzCommonDAO.checkWebfolderFileParentIdColumn");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_file PARENT_ID column doesn't exist. creating the column...");
			update("EzCommonDAO.createNullableWebfolderFileParentIdColumn");
			update("EzCommonDAO.updateWebfolderFileParentIdColumn");
		}

		try {
			select("EzCommonDAO.checkWebfolderFileHierarchicalPathColumn");
		} catch (Exception e) {
			logger.debug("tbl_webfolder_file HIERARCHICAL_PATH column doesn't exist. creating the column...");
			update("EzCommonDAO.createNullableWebfolderFileHierarchicalPathColumn");
			update("EzCommonDAO.updateWebfolderFileHierarchicalPathColumn");
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
	
	public void alterWebfolderApplyHistoryAddColumn() {
		try {
			update("EzCommonDAO.alterWebfolderApplyHistoryAddColumn");
		} catch (Exception e) {
			logger.debug("Already exists");
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

	/* 2021-06-21 홍승비 - 게시판 메일알림 옵션 컬럼 추가 */
	public void addBoardMailFGColumn() {
		try {
			select("EzCommonDAO.checkBoardMailFG_PostColumn");
		} catch (Exception e) {
			logger.debug("TBL_Board_BoardInfo MailFG_Post column doesn't exist. creating the column...");
			update("EzCommonDAO.addBoardMailFG_PostColumn");
		}
		try {
			select("EzCommonDAO.checkBoardMailFG_ModColumn");
		} catch (Exception e) {
			logger.debug("TBL_Board_BoardInfo MailFG_Mod column doesn't exist. creating the column...");
			update("EzCommonDAO.addBoardMailFG_ModColumn");
		}
		try {
			select("EzCommonDAO.checkBoardMailFG_CommentColumn");
		} catch (Exception e) {
			logger.debug("TBL_Board_BoardInfo MailFG_Comment column doesn't exist. creating the column...");
			update("EzCommonDAO.addBoardMailFG_CommentColumn");
		}
	}

	/* 2021-06-28 홍승비 - 커뮤니티 공지사항 부모게시물 정보 칼럼 추가 */
	public void addCommNoticeUpperNoColumn() {
		try {
			select("EzCommonDAO.checkCommNoticeUpperNoColumn");
		} catch (Exception e) {
			logger.debug("TBL_C_Board UPPERNO column doesn't exist. creating the column...");
			update("EzCommonDAO.addCommNoticeUpperNoColumn");
		}
	}
		
    public void alterTblAprReceiptProcessInfoAddColumn() {
        try {
            select("EzCommonDAO.checkTblAprReceiptProcessInfoAddColumn");
        } catch (Exception e) {
            logger.debug("tbl_aprreceiptprocessinfo rootdocid column doesn't exist. creating the column...");
            update("EzCommonDAO.alterTblAprReceiptProcessInfoAddColumn");
            update("EzCommonDAO.updateTblAprReceiptProcessInfoRootDocID");
        }
    }
    
    public void alterTblDocDeliveryAddColumn() {
        try {
            select("EzCommonDAO.checkTblDocDeliveryAddColumn");
        } catch (Exception e) {
            logger.debug("tbl_docdelivery extreceptyn column doesn't exist. creating the column...");
            update("EzCommonDAO.alterTblDocDeliveryAddColumn");
            update("EzCommonDAO.updateTblDocDeliveryExtReceptYn");
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
    
    public void addTblAdminReceiptGroupSubExtReceptYnColumn() {
        try {
            select("EzCommonDAO.checkTblAdminReceiptGroupSubExtReceptYnColumn");
        } catch (Exception e) {
            logger.debug("tbl_adminreceiptgroup_sub extreceptyn column doesn't exist. creating the column...");
            
            update("EzCommonDAO.addTblAdminReceiptGroupSubExtReceptYnColumn");
        }
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
	
	public void alterTblAddjobMaster() {
		try {
			if(select("EzCommonDAO.chkAddjobMasterJobIdIsPrimary") == null) {
				update("EzCommonDAO.dropAddjobMasterPrimary");
				logger.debug("addjobMaster drop primary.");
				update("EzCommonDAO.addAddjobMasterPrimary");
				logger.debug("addjobMaster add primary.");
			}
		} catch (Exception e) {
			logger.debug("alterTblAddjobMaster ERROR...");
			logger.error(e.getMessage(), e);
		}
	}
	
	/* 2021-11-12 홍승비 - 커뮤니티 게시판 메일알림 옵션 추가 (게시/수정/댓글알림)  */
	public void addCommMailFGColumn() {
		try {
			select("EzCommonDAO.checkCommMailFG_PostColumn");
		} catch (Exception e) {
			logger.debug("TBL_Comm_BoardInfo MailFG_Post column doesn't exist. creating the column...");
			update("EzCommonDAO.addCommMailFG_PostColumn");
		}
		try {
			select("EzCommonDAO.checkCommMailFG_ModColumn");
		} catch (Exception e) {
			logger.debug("TBL_Comm_BoardInfo MailFG_Mod column doesn't exist. creating the column...");
			update("EzCommonDAO.addCommMailFG_ModColumn");
		}
		try {
			select("EzCommonDAO.checkCommMailFG_CommentColumn");
		} catch (Exception e) {
			logger.debug("TBL_Comm_BoardInfo MailFG_Comment column doesn't exist. creating the column...");
			update("EzCommonDAO.addCommMailFG_CommentColumn");
		}
	}

	/* 2021-11-17 홍승비 - 전자설문 대상자 하위부서 허용여부 플래그 추가 (Y/N) */
	public void addSurveySubDeptYNColumn() {
		try {
			select("EzCommonDAO.checkSurveySubDeptYNColumn");
		} catch (Exception e) {
			logger.debug("tbl_survey_participant SubDeptYN column doesn't exist. creating the column...");
			update("EzCommonDAO.addSurveySubDeptYNColumn");
		}
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

	public void addSusinScheduleOffsetColumn() throws Exception {
		try {
			select("EzCommonDAO.checkSusinScheduleOffsetColumn");
		} catch (Exception e) {
			logger.debug("TBL_SUSINSCHEDULE OFFSET column doesn't exist. creating the column...");
			update("EzCommonDAO.addSusinScheduleOffsetColumn");
		}
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
	
	/* 2022-02-09 홍승비 - 일괄기안 테이블에 임시저장/결재올림 구분용 타입 칼럼 추가 */
	public void addAprDocGroupInfoTypeColumn() {
		try {
			select("EzCommonDAO.checkAprDocGroupInfoTypeColumn");
		} catch (Exception e) {
			logger.debug("TBL_APRDOCGROUPINFO TYPE column doesn't exist. creating the column...");
			update("EzCommonDAO.addAprDocGroupInfoTypeColumn");
		}
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

	/* 2023-08-21 이주원 - 2023-08-21 이주원 - 자원권한 테이블에 유저명 다국어 지원을 위해 MEMBER_NAM2 컬럼 추가 */
	public void alterTblRsResaclAddColumn() {
		try {
			select("EzCommonDAO.checkRsResaclMemberNam2Column");
		} catch (Exception e) {
			logger.debug("TBL_RS_RESACL MEMBER_NAM2 column doesn't exist. creating the column...");
			update("EzCommonDAO.addRsResaclMemberNam2Column");
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
	
	/* 2023-08-31 조소정 - 일정관리 > 일정그룹 테이블에 컬럼 추가(양도일자/그룹색상) */
	public void addScheduleGroupColumn() {
		try {
			select("EzCommonDAO.checkScheduleGroup_TransferDateColumn");
		} catch (Exception e) {
			logger.debug("TBL_SCHEDULEGROUP TRANSFERDATE column doesn't exist. creating the column...");

			update("EzCommonDAO.addScheduleTransferDateColumn");
		}
		try {
			select("EzCommonDAO.checkScheduleGroup_GroupColorColumn");
		} catch (Exception e) {
			logger.debug("TBL_SCHEDULEGROUP GROUPCOLOR column doesn't exist. creating the column...");

			update("EzCommonDAO.addScheduleGroupColorColumn");
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

		// 게시판 > 댓글 좋아요/싫어요 사용여부 옵션 칼럼 추가
		try {
			select("EzCommonDAO.checkTblBoardInfoReactFlag");
		} catch (Exception e) {
			logger.debug("tbl_board_info reactFlag doesn't exist. creating the column...");

			update("EzCommonDAO.addBoardReactFlag");
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
	public void insertPermissionBasisDeptYN_Config()  throws Exception {
		String propertyValue = (String) select("EzCommonDAO.checkPermissionBasisDeptYN_Config");
		if (propertyValue == null) {
			logger.debug("PermissionBasisDeptYN tenant config doesn't exist. insert data...");
			insert("EzCommonDAO.insertPermissionBasisDeptYN_Config");
		}
	}

	public void createColumnRollInfoInAddJobMaster()  throws Exception {
		try {
			select("EzCommonDAO.checkRollInfoInAddJob");
		} catch (Exception e) {
			logger.debug("TBL_ADDJOBMASTER ROLL_INFO column doesn't exist. creating the column... ");

			update("EzCommonDAO.AddRollInfoInAddJobColumn");
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
}
