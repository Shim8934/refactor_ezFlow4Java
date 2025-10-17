package egovframework.ezEKP.ezOrgan.dao;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.naming.NamingEnumeration;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.BasicAttribute;
import javax.naming.directory.BasicAttributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.ModificationItem;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import egovframework.ezEKP.ezOrgan.vo.OrganAddJobVO;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.util.ADConnection;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganGroupVO;
import egovframework.ezEKP.ezOrgan.vo.OrganJobVO;
import egovframework.ezEKP.ezOrgan.vo.OrganLoginStopUserVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSystem.vo.PermissionInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unused")
@Repository("EzOrganAdminDAO")
public class EzOrganAdminDAO extends EgovAbstractDAO {

    private static final Logger logger = LoggerFactory.getLogger(EzOrganAdminDAO.class);
    /**
     * Active Directory
     * - 유저 환경 변수
     * */
	private static final int UF_ACCOUNTENABLE = 0x0001;
	private static final int UF_ACCOUNTDISABLE = 0x0002;
	private static final int UF_PASSWD_NOTREQD = 0x0020;
	private static final int UF_PASSWD_CANT_CHANGE = 0x0040;
	private static final int UF_NORMAL_ACCOUNT = 0x0200;
	private static final int UF_DONT_EXPIRE_PASSWD = 0x10000;
	private static final int UF_PASSWORD_EXPIRED = 0x800000;
	
	/**
	 * Active Directory
	 * - 부서 환경 변수
	 * */
	private static final int BUILTIN_LOCAL_GROUP = 0x00000001;
	private static final int ACCOUNT_GROUP       = 0x00000002;
	private static final int RESOURCE_GROUP      = 0x00000004;
	private static final int UNIVERSAL_GROUP     = 0x00000008;
	private static final int APP_BASIC_GROUP     = 0x00000010;
	private static final int APP_QUERY_GROUP     = 0x00000020;
	private static final int SECURITY_ENABLED    = 0x80000000;
            
    @Autowired
    private Properties config;

    @Autowired
    private EzEmailUtil ezEmailUtil;
    
    @Autowired
    private ADConnection conn;  
    
    @Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
        
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> getCompanyListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganDeptVO>) list("EzOrganAdminDAO.getCompanyList", map);
    }
    
	public List<OrganDeptVO> getCompanyList(Map<String, Object> map) throws Exception {
		return getCompanyListForLocal(map);       
	}
	
    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getAddJobListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.getAddJobList", map);
    }
	
	public List<OrganUserVO> getAddJobList(Map<String, Object> map) throws Exception {
		return getAddJobListForLocal(map);       
	}
	
    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getUserAddJobListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.getUserAddJobList", map);
    }
	
	public List<OrganUserVO> getUserAddJobList(Map<String, Object> map) throws Exception {
		return getUserAddJobListForLocal(map);       
	}
		
	@SuppressWarnings("unchecked")
	private int getAddJobCountInOneDeptForLocal(Map<String, Object> map) throws Exception {
		return (int) select("EzOrganAdminDAO.getAddJobCountInOneDept", map);
	}

	public int getAddJobCountInOneDept(Map<String, Object> map) throws Exception {
		return getAddJobCountInOneDeptForLocal(map);
	}

    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getPermissionListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.getPermissionList", map);
    }
	
	public List<OrganUserVO> getPermissionList(Map<String, Object> map) throws Exception {
		return getPermissionListForLocal(map);       
	}
	
    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getRetireListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.getRetireList", map);
    }
	
	public List<OrganUserVO> getRetireList(Map<String, Object> map) throws Exception {
		return getRetireListForLocal(map);       
	}
    
    @SuppressWarnings("unchecked")
    private List<OrganUserVO> getUserCnListForLocal(int tenantID) throws Exception {
        return (List<OrganUserVO>) list("EzOrganAdminDAO.userCnList", tenantID);
    }
    
    @SuppressWarnings("unchecked")
	public List<OrganUserVO> getAllUserCnList(int tenantID) throws Exception {
    	return (List<OrganUserVO>) list("EzOrganAdminDAO.allUserList", tenantID);
    }
    
    // 퇴직자 포함하여 사용자 아이디 목록을 반환한다.
    public List<OrganUserVO> getUserCnList(int tenantID) throws Exception {
    	return getUserCnListForLocal(tenantID);       
    }	
   
    private int getUserCountForLocal(int tenantID) throws Exception {
        return (int) select("EzOrganAdminDAO.userCount", tenantID);
    }

    // 퇴직자 포함하여 사용자 아이디 개수를 반환한다.
    public int getUserCount(int tenantID) throws Exception {
    	return getUserCountForLocal(tenantID);       
    }	
    	
    private OrganUserVO getUserInfoForLocal(Map<String, Object> map) throws Exception {
        return (OrganUserVO) select("EzOrganAdminDAO.getUserInfo", map);
    }
	
	public OrganUserVO getUserInfo(Map<String, Object> map) throws Exception {
		return getUserInfoForLocal(map);       
	}
		
    private OrganUserVO getRetireEntryInfoForLocal(Map<String, Object> map) throws Exception {
        return (OrganUserVO) select("EzOrganAdminDAO.getRetireEntryInfo", map);
    }
	
	public OrganUserVO getRetireEntryInfo(Map<String, Object> map) throws Exception {
		return getRetireEntryInfoForLocal(map);       
	}

	public int companyCheck(Map<String, Object> map) throws Exception{		
		return (int) select("EzOrganAdminDAO.companyCheck", map);
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
    	Map<String,Object> map = new HashMap<String, Object>();
    	map.put("cn", cn);
    	map.put("tenantID", tenantID);
    	
        return companyChildCheckForLocal(map);       
	}
	
	private int userCheckForJMocha(Map<String, Object> map) throws Exception {
		String cn = (String)map.get("cn");
        int tenantID = (Integer)map.get("tenantID");
        
        logger.debug("userCheckForJMocha started. cn=" + cn + ",tenantID=" + tenantID);

        String param1 = "tenantId=" + tenantID;
        String param2 = "mailId=" + URLEncoder.encode(cn, "UTF-8");
        String inputParams = param1 + "&" + param2;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzEmail/checkMailId";
        String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);

        logger.debug("response=" + response);

        int result = 0;
        
        if (response != null) {
            JSONParser jsonParser = new JSONParser();
            JSONObject responseObj = (JSONObject)jsonParser.parse(response);
            
            String resultCode = (String)responseObj.get("resultCode");
            int reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
            
            if (resultCode.equals("OK") && reasonCode == 0) {
            	result = ((Long)responseObj.get("result")).intValue();
            } else {
            	logger.debug("resultCode=" + resultCode + ",reasonCode=" + reasonCode);
            	throw new Exception("JGwServer /jMochaEzEmail/checkMailId Failed!");
            }
        }
        
        logger.debug("userCheckForJMocha ended. result=" + result);
        return result;
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
    	int result = 0;
		Map<String, Object> map = new HashMap<String, Object>();
    	
    	map.put("cn", cn);
    	map.put("tenantID", tenantID);
    	
    	result = userCheckForLocal(map);
    	
    	// 모든 Inner Domain에 대해 cn@Inner Domain이 이미 존재하는 지를 체크하였으나
    	// 특정 Inner Domain에서 Alias로 사용되는 아이디인 경우에도 Full 주소로 중복되는 것이
    	// 아니라면 등록 가능하도록 하기 위해 제거함.
    	/* 
    	if (result == 0) {
    		result = userCheckForJMocha(map);
    	}
    	*/
    	
        return result;    
	}

	public boolean isDuplicateLoginId(String userId, String id, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();

		map.put("tenantId", tenantId);
		map.put("userId", userId);
		map.put("id", id);

		int count = (int) select("EzOrganAdminDAO.getDuplicateLoginIdCount", map);

		logger.debug("isDuplicateLoginId id={}, count={}", id, count);

		return count > 0;
	}

    private int getPermissionListCountForLocal(Map<String, Object> map) throws Exception {
        return (int) select("EzOrganAdminDAO.getPermissionListCount", map);
    }
	
	public int getPermissionListCount(Map<String, Object> map) throws Exception {
		return getPermissionListCountForLocal(map);       
	}
	
    private int getRetireListCountForLocal(Map<String, Object> map) throws Exception {
        return (int)select("EzOrganAdminDAO.getRetireListCount", map);
    }
	
	public int getRetireListCount(Map<String, Object> map) throws Exception {
		return getRetireListCountForLocal(map);       	    
	}

    /*private void insertDBData_companyForJMocha(Map<String, Object> map) throws Exception {
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
    }*/
	
    private void insertDBData_companyForLocal(Map<String, Object> map) throws Exception {
        insert("EzOrganAdminDAO.insertDBData_company", map);
    }
	
	public void insertDBData_company(Map<String, Object> map) throws Exception {        
        /*insertDBData_companyForJMocha(map);*/

        try {
            insertDBData_companyForLocal(map);
        // 로컬 등록이 실패하면 JMocha User Repository에 등록한 것을 삭제한다.
        } catch (Exception e) {
        	logger.debug("insertDBData_company insert fail");
            logger.error(e.getMessage(), e);
            
            /*map.put("v_CLASS", "group");
            deleteDBDataForJMocha(map);*/
            
            throw e;
        }
	}

    /*private void insertDBData_deptForJMocha(Map<String, Object> map) throws Exception {
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
    }*/
	
    private void insertDBData_deptForLocal(Map<String, Object> map) throws Exception {
    	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	date.setTimeZone(TimeZone.getTimeZone("GMT"));
    	String nowDate = date.format(new Date());
    	map.put("nowDate", nowDate);
    	
        insert("EzOrganAdminDAO.insertDBData_dept", map);
    }

	public OrganDeptVO selectValueByParentCN(Map<String, Object> map) {
		return (OrganDeptVO) select("EzOrganAdminDAO.selectValueByParentCN", map);
	}

	public void insertDBData_dept(Map<String, Object> map) throws Exception {
	   /* insertDBData_deptForJMocha(map);*/
	   
        try {
            insertDBData_deptForLocal(map);
            /**
             * Active Directory
             * - 부서 추가
             * */
            if (ezCommonService.getTenantConfig("USE_AD", (Integer)map.get("v_TENANT_ID")).equalsIgnoreCase("YES")) {
            	DirContext ctx = conn.setConnection();
            	insertDeptInAD(ctx, map);
            }
        // 로컬 등록이 실패하면 JMocha User Repository에 등록한 것을 삭제한다.
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            /*
            map.put("v_CLASS", "group");
            deleteDBDataForJMocha(map);*/
            
            throw e;	            
        }
	}
	
	public void updateDBData_deptOrder(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateDBData_deptOrder", map);
	}
	
	public void updateDBData_deptOrderIsNull(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateDBData_deptOrderIsNull", map);
	}
	
    private void insertDBData_userForLocal(Map<String, Object> map) throws Exception {
        insert("EzOrganAdminDAO.insertDBData_user", map);
    }
	
	public void insertDBData_user(Map<String, Object> map) throws Exception {
	   /* insertDBData_userForJMocha(map);*/
	   
        try {
            insertDBData_userForLocal(map);
            //AD를 사용하는 경우 AD에도 사용자 추가
            if (ezCommonService.getTenantConfig("USE_AD", (Integer)map.get("v_TENANT_ID")).equalsIgnoreCase("YES")) {
            	DirContext ctx = conn.setConnection();
            	insertUserInAD(ctx, map);
            }
        // 로컬 등록이 실패하면 JMocha User Repository에 등록한 것을 삭제한다.
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
            /*
            map.put("v_CLASS", "user");
            deleteDBDataForJMocha(map);*/
            
            throw e;                
        }            
	}
	
	public void updateDBData_userOrder(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateDBData_userOrder", map);
	}
	
	public void updateDBData_addjobmasterOrder(Map<String, Object> map) throws Exception {
		update ("EzOrganAdminDAO.updateDBData_addjobmasterOrder", map);
	}
	
	public void updateDBData_userOrderIsNull(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateDBData_userOrderIsNull", map);
	}
	
    /*private void updateDBData_companyForJMocha(Map<String, Object> map) throws Exception {
        int tenantId = (Integer)map.get("v_TENANT_ID");        
        String companyId = (String)map.get("v_CN");
        String displayName = (String)map.get("v_DISPLAYNAME");
        String displayName2 = (String)map.get("v_DISPLAYNAME2");
        String mail = (String)map.get("v_MAIL");
    	
        logger.debug("updateDBData_companyForJMocha started. tenantId=" + tenantId + ",companyId=" + companyId);

        String param1 = "tenantId=" + tenantId;
        String param2 = "companyId=" + URLEncoder.encode(companyId, "UTF-8");
        String param3 = "displayName=" + URLEncoder.encode(displayName, "UTF-8");
        String param4 = "displayName2=" + URLEncoder.encode(displayName2, "UTF-8");
        String param5 = "mail=" + URLEncoder.encode(mail, "UTF-8");
        String inputParams = param1 + "&" + param2 + "&" + param3 + "&" + param4 + "&" + param5;

        String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaEzHrMaster/updateCompany";
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
        
        logger.debug("updateDBData_companyForJMocha ended. resultCode=" + resultCode + ",reasonCode=" + reasonCode);        
        
        if (reasonCode != 0) {
            throw new Exception("Updating Company Failed!");
        }                
    }*/
    
    private void updateDBData_companyForLocal(Map<String, Object> map) throws Exception {
        update("EzOrganAdminDAO.updateDBData_company", map);
    }
    	
	public void updateDBData_company(Map<String, Object> map) throws Exception {        
	    /*updateDBData_companyForJMocha(map);*/
	    
	    updateDBData_companyForLocal(map);       
	}
	
    /*private void updateDBData_deptForJMocha(OrganDeptVO vo) throws Exception {
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
    }*/
	
    private void updateDBData_deptForLocal(OrganDeptVO vo) throws Exception {
        logger.debug("updateDBData_deptForLocal started. tenantId=" + vo.getTenantId() + ",deptId=" + vo.getCn());
        
        update("EzOrganAdminDAO.updateDBData_dept", vo);
        
        logger.debug("updateDBData_deptForLocal ended.");
    }
    	
	public void updateDBData_dept(OrganDeptVO vo) throws Exception {        
	    /*updateDBData_deptForJMocha(vo);*/
	    
	    updateDBData_deptForLocal(vo);       
	}

    /*private void updateDBData_userForJMocha(OrganUserVO vo) throws Exception {
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
        if (vo.getExtensionAttribute7() != null) {
        	String param = "extensionAttribute7=" + URLEncoder.encode(vo.getExtensionAttribute7(), "UTF-8");
        	inputParams += "&" + param;
        }
        if (vo.getExtensionAttribute8() != null) {
        	String param = "extensionAttribute8=" + URLEncoder.encode(vo.getExtensionAttribute8(), "UTF-8");
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
        if (vo.getExtensionAttribute7() != null) {
            String param = "extensionAttribute7=" + URLEncoder.encode(vo.getExtensionAttribute7(), "UTF-8");
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
    }*/
	
    private void updateDBData_userForLocal(OrganUserVO vo) throws Exception {
        update("EzOrganAdminDAO.updateDBData_user", vo);
    }
	
	public void updateDBData_user(OrganUserVO vo) throws Exception {
	    /*updateDBData_userForJMocha(vo);*/
 	    
        updateDBData_userForLocal(vo);
        // AD에도 내용을 수정
        if (ezCommonService.getTenantConfig("USE_AD", vo.getTenantId()).equalsIgnoreCase("YES")) {
        	DirContext ctx = conn.setConnection();            	
        	if (!vo.getCn().equalsIgnoreCase("MASTERADMIN")) {
        		logger.debug("update Active Directory data....");
        		updateUserInAD(ctx, vo, "user");
        	}            	
        }
	}
		
	public void updateDBData_userPermission(OrganUserVO vo) throws Exception {
        update("EzOrganAdminDAO.updateDBData_userPermission", vo);		
	}
	
    private void updatePropertyForLocal(Map<String, Object> map) throws Exception{
        update("EzOrganAdminDAO.updateProperty", map);
    }
	
	public void updateProperty(Map<String, Object> map) throws Exception{
		updatePropertyForLocal(map);       
	}
	
	public void updateProperty_addJob(Map<String, Object> map) throws Exception{
        update("EzOrganAdminDAO.updateProperty_addJob", map);
	}

	public void updateJobTitleOrder(Map<String, Object> map) throws Exception{
		update("EzOrganAdminDAO.updateJobTitleOrder", map);
	}

    /*private void restoreRetireEntryForJMocha(Map<String, Object> map) throws Exception {
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
    }*/
	
    private void restoreRetireEntryForLocal(Map<String, Object> map) throws Exception {
        //moveGroupUser_U(map);
    	restoreRetireEntry_I(map);
    }
	
	public void restoreRetireEntry(Map<String, Object> map) throws Exception{
	    /*restoreRetireEntryForJMocha(map);*/
	    
    	try {
    		restoreRetireEntryForLocal(map);
    		
    		/**
    		 * Active Directory
    		 * - 퇴직자 복구
    		 * */
    		if (ezCommonService.getTenantConfig("USE_AD", (Integer)map.get("v_TENANT_ID")).equalsIgnoreCase("YES")) {
    			DirContext ctx = conn.setConnection();
    			//retireUserInAD(ctx, map);	    
    			restoreUserInAD(ctx, map);
    		}
    	} catch (Exception e) {
    		/*// Local에서의 복원 작업이 실패하면 JMocha 테이블에서 다시 퇴직처리를 한다.
    		retireDBDataForJMocha(map);*/
    		
    		throw e;
    	}
	}

    /*public void deleteDBDataForJMocha(Map<String, Object> map) throws Exception {
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
    }*/
	
    private void deleteDBDataForLocal(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteDBData", map);
    }
	
	public void deleteDBData(Map<String, Object> map) throws Exception {
	    deleteDBDataForLocal(map);       
	}

    /*public void moveDBDataForJMocha(Map<String, Object> map) throws Exception {
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
    }*/
	
    private void moveDBDataForLocal(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.moveDBData", map);
    }
	
	public void moveDBData(Map<String, Object> map) throws Exception {	    
	   /* moveDBDataForJMocha(map);*/
	    
	    moveDBDataForLocal(map);       
	}

    /*private void retireDBDataForJMocha(Map<String, Object> map) throws Exception {
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
    }*/
		
	/*public void retireDBData(Map<String, Object> map) throws Exception {
	    retireDBDataForJMocha(map);
	}*/
	
	public void retireDBData(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.retireDBData", map);
	}
	
    private void setAddJobForLocal(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.setAddJob", map);
    }
	
	public void setAddJob(Map<String, Object> map) throws Exception {
		setAddJobForLocal(map);       
	}
    
    private void deleteAddJobForLocal(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteAddJob", map);
    }
    
    public void deleteAddJob(Map<String, Object> map) throws Exception {
    	deleteAddJobForLocal(map);
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
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("cn", cn);
    	map.put("tenantID", tenantID);
    	
        return userCountCheckForLocal(map);       
	}
		
	private void setUserPrimaryMailForLocal(String cn, int tenantID, String email) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("TENANT_ID", tenantID);
		map.put("CN", cn);
		map.put("MAIL", email);
		
		update("EzOrganAdminDAO.setUserMail", map);
    }
	
	public void setUserPrimaryMail(String cn, int tenantID, String email) throws Exception {
		setUserPrimaryMailForLocal(cn, tenantID, email);
    }
	
	public void restoreRetireEntry_D (Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.restoreRetireEntry_D", map);
	}

	public void restoreRetireEntry_I (Map<String, Object> map) throws Exception {
		insert("EzOrganAdminDAO.restoreRetireEntry", map);
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
	
	public void deleteDBData_D6(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteDBData_D6", map);
    }

 	public void deleteCompany_D5(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D5", map);
    }

	public void deleteCompany_D6(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D6", map);
    }
	
	public void deleteCompany_D7(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D7", map);
    }
	
	public void deleteCompany_D8(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D8", map);
    }
	
	public void deleteCompany_D9(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D9", map);
    }
	
	public void deleteCompany_D10(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D10", map);
    }
	
	public void deleteCompany_D11(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D11", map);
    }
	
	public void deleteCompany_D12(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D12", map);
    }
	
	public void deleteCompany_D13(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D13", map);
    }
	
	public void deleteCompany_D14(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D14", map);
    }
	
	public void deleteCompany_D15(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D15", map);
    }
	
	public void deleteCompany_D16(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D16", map);
    }
	
	public void deleteCompany_D17(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D17", map);
    }
	
	public void deleteCompany_D18(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D18", map);
    }
	
	public void deleteCompany_D19(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deleteCompany_D19", map);
    }
	
	public void deleteCompany_D20(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D20", map);
	}
	
	public void deleteCompany_D21(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D21", map);
	}

	public void deleteCompany_D23(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D23", map);
	}
	
	public void deleteCompany_D24(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D24", map);
	}
	
	public void deleteCompany_D25(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D25", map);
	}
	
	public void deleteCompany_D26(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D26", map);
	}
	
	public void deleteCompany_D27(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D27", map);
	}
	
	public void deleteCompany_D28(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D28", map);
	}
	
	public void deleteCompany_D29(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D29", map);
	}
	
	public void deleteCompany_D30(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D30", map);
	}
	
	public void deleteCompany_D31(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D31", map);
	}
	
	public void deleteCompany_D32(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D32", map);
	}

	public void deleteCompany_D33(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D33", map);
	}

	public void deleteCompany_D34(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D34", map);
	}
	
	public void deleteCompany_D35(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D35", map);
	}
	
	public void deleteCompany_D36(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D36", map);
	}
	
	public void deleteCompany_D37(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D37", map);
	}
	
	public void deleteCompany_D38(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D38", map);
	}
	
	public void deleteCompany_D39(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompany_D39", map);
	}
	
	public void deleteCompanyInfo_IKMS7(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompanyInfo_IKMS7", map);
	}
	
	public void deleteCompanyInfo_IJHS1(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompanyInfo_IJHS1", map);
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
        logger.debug("displayName = {}, displayName = {}, nowDate = {}", vo.getDisplayName(), vo.getDisplayName2(), vo.getNowDate());
        
        update("EzOrganAdminDAO.updateUserDeptDisplayName", vo);
        
        logger.debug("updateUserDeptDisplayName ended.");
    }

    public void updateUserCompanyDisplayName(Map<String, Object> map) throws Exception {
        logger.debug("updateUserCompanyDisplayName started.");
        
        update("EzOrganAdminDAO.updateUserCompanyDisplayName", map);
        
        logger.debug("updateUserCompanyDisplayName ended.");
    }

    public void updateDeptCompanyDisplayName(Map<String, Object> map) throws Exception {
        logger.debug("updateDeptCompanyDisplayName started.");
        
        update("EzOrganAdminDAO.updateDeptCompanyDisplayName", map);
        
        logger.debug("updateDeptCompanyDisplayName ended.");
    }

    public void insertCompanyInfo_I6(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I6", map);
    }
    
    public void insertCompanyInfo_I7(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I7", map);
    }
    
    public void insertCompanyInfo_I8(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I8", map);
    }
    
    public void insertCompanyInfo_I9(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I9", map);
    }
    
    public void insertCompanyInfo_I10(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I10", map);
    }
    
    public void insertCompanyInfo_I11(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I11", map);
    }
    
    public void insertCompanyInfo_I12_separate(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I12_separate", map);
    }

	@SuppressWarnings("unchecked")
	public Map<String, String> getCodeMap(Map<String, Object> map) {
		Map<String, String> codeMap = new LinkedHashMap<>();

		String[] ids = {
				"processinfo",
				"draftinfo",
				"receiptinfo",
				"approvalinfo",
				"recvapprovalinfo",
				"userdefinedinfo"
		};

		for (String id : ids) {
			map.put("id", id);
			String code = (String) select("EzOrganAdminDAO.selectCodeById", map);
			codeMap.put(id, code); // key = id, value = code
		}

		return codeMap;
	}


    public void insertCompanyInfo_I12(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I12", map);
    }
    
    public void insertCompanyInfo_I13(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I13", map);
    }
    
    public void insertCompanyInfo_I14(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I14", map);
    }
    
    public void insertCompanyInfo_I15(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I15", map);
    }
    
    public void insertCompanyInfo_I16(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I16", map);
    }
    
    public void insertCompanyInfo_I17(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I17", map);
    }
    
    public void insertCompanyInfo_I18(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I18", map);
    }
    
    public void insertCompanyInfo_I19(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I19", map);
    }
    public void insertCompanyInfo_I20(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I20", map);
    }
    public void insertCompanyInfo_I21(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I21", map);
    }

    public void insertCompanyInfo_I23(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I23", map);
    }
    
    public void insertCompanyInfo_I24(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I24", map);
    }
    
    public void insertCompanyInfo_I25(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I25", map);
    }
    
    public void insertCompanyInfo_I26(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I26", map);
    }
    
    public void insertCompanyInfo_I27(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I27", map);
    }
    
    public void insertCompanyInfo_I28(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I28", map);
    }
    
    public void insertCompanyInfo_I29(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I29", map);
    }
    
    public void insertCompanyInfo_I30(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I30", map);
    }

	public void insertCompanyInfo_I31(Map<String, Object> map) {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I31", map);
	}

	public void insertCompanyInfo_I32(Map<String, Object> map) {
    	insert("EzOrganAdminDAO.insertCompanyInfo_I32", map);
	}
    
	public void insertCompanyInfo_I33(Map<String, Object> map) {
		insert("EzOrganAdminDAO.insertCompanyInfo_I33", map);
	}
	
    public void insertCompanyInfo_IJHS1(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_IJHS1", map);
    }

    public void insertCompanyInfo_IKMS7(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertCompanyInfo_IKMS7", map);
    }
    
	/**
	 * 그룹웨어 계정으로 비즈메카톡 계정을 동기화한다.
	 */    
    public void syncWithBizmekaTalkAccounts(int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("TENANT_ID", tenantID);
		
		update("EzOrganAdminDAO.talk_SP_CONN_COMPANY", map);
		update("EzOrganAdminDAO.talk_SP_CONN_DEPT", map);
		update("EzOrganAdminDAO.talk_SP_CONN_USER", map);
		update("EzOrganAdminDAO.talk_SP_CONN_ADDJOB", map);
		update("EzOrganAdminDAO.talk_SP_CONN_DEFAULTSVRID", map);
		update("EzOrganAdminDAO.talk_SP_CONN_UPDATETHUMNAILPROFILE", map);
    }
    
    /**
     * Active Directory
     * - AD의 모든 그룹 혹은 그룹의 모든 사용자 추출
     * - type : ObjectClass 타입 -> user || group
     * - colum : attribute
     * */
    @SuppressWarnings("rawtypes")
    public ArrayList<HashMap<String, Object>> getAllADdata(DirContext ctx, String type, String column, String value) throws Exception {
    	logger.debug("getAllADdata started.");
    	logger.debug("type : " + type + " column : " + column);
    	ArrayList<HashMap<String, Object>> arrayList = new ArrayList<HashMap<String,Object>>();

    	/**
    	 * 기본 Distinguished Name
    	 * */
    	String searchBase = "OU=" + config.getProperty("config.Company_Name") + ", OU=TopGroup, DC=" 
    				+ config.getProperty("config.Common_Name1");

    	String splitDC[] = config.getProperty("config.Common_Name2").split("\\.");
    	for (String dn : splitDC) {
    		searchBase += ", DC=" + dn;
    	}
    	logger.debug("searchBase : " + searchBase);
    	
    	String filter = "(&(objectClass="+ type +")("+ column +"="+ value +")(cn=*))";
    	logger.debug("filter : " + filter);
    	
    	SearchControls sc = new SearchControls();    	
    	sc.setSearchScope(SearchControls.SUBTREE_SCOPE);//조직도 뎁스 관련    	    	
    	sc.setReturningAttributes(new String[] {"cn", "distinguishedName", column});
    	
    	NamingEnumeration results = ctx.search(searchBase, filter, sc);
    	
    	
    	while (results.hasMoreElements()) {
    		HashMap<String, Object> map = new HashMap<String, Object>();
    		SearchResult sr = (SearchResult)results.next();
    		
    		NamingEnumeration attrs = sr.getAttributes().getAll();

    		while (attrs.hasMoreElements()) {    			
    			Attribute attribute = (Attribute) attrs.nextElement();
    			map.put(attribute.getID(), attribute.get());    			
    		}  
    		arrayList.add(map);
    		logger.debug("map : " +  map.toString());
    		logger.debug("map.cn : " +  map.get("cn").toString());
    	}    	    	
    	
    	//logger.debug("map : " +  map.toString());
    	
    	logger.debug("getAllADdata ended.");
    	return arrayList;
    }
    
    /**
     * Active Directory
     * - AD의 원하는 Attribute 값 가져오기
     * */
    @SuppressWarnings("rawtypes")
    public String getADdata(DirContext ctx, String cn, String type, String column) throws Exception { 
     	logger.debug("getADdata started.");
    	String result = "";
    	String typeKR = "";
    	String col = "";
    	
    	if (column.equalsIgnoreCase("dn")) {
    		column = "distinguishedName";
    	}
    	
    	if (type.equalsIgnoreCase("user")) {
    		typeKR = "사용자";
    	} else if (type.equalsIgnoreCase("group") || type.equalsIgnoreCase("dept")) {
    		typeKR = "부서";
    		type = "group";
    	} else if (type.equalsIgnoreCase("isMember")) {
    		type = "group";
    		col = "member";
    	}
    	/**
    	 * 기본 Distinguished Name
    	 * */
    	String defaultPath = "OU=" + config.getProperty("config.Company_Name") + ",OU=TopGroup,DC=" 
    				+ config.getProperty("config.Common_Name1");

    	String splitDC[] = config.getProperty("config.Common_Name2").split("\\.");
    	for (String dn : splitDC) {
    		defaultPath += ", DC=" + dn;
    	}
    			
    	logger.debug("searchBase : " + defaultPath);
    	/**
    	 * 검색에 사용될 filter
    	 * */
    	String filter = "";
    	
    	if (col.equalsIgnoreCase("")) {
    		filter = "(&(objectClass="+ type +")(cn=" + cn.trim() + "))";
    	} else {
    		filter = "("+ col +"=CN=" + cn + ",OU=부서,"+ defaultPath + ")";
    	}
    	
    	logger.debug("filter : " + filter);
    	SearchControls sc = new SearchControls();
    	sc.setSearchScope(SearchControls.SUBTREE_SCOPE);//조직도 뎁스 관련
    	//sc.setSearchScope(SearchControls.ONELEVEL_SCOPE);
    	
    	/**
    	 * 추출하고자 하는 컬럼 데이터 리스트
    	 * */
    	sc.setReturningAttributes(new String[] {"cn", "sAMAccountName", column});
    	
    	/**
    	 * filter를 이용한 쿼리 작성
    	 * */
    	NamingEnumeration results = ctx.search(defaultPath, filter, sc);

    	while (results.hasMoreElements()) {
    		SearchResult sr = (SearchResult)results.next();
    		result = sr.getAttributes().get(column).toString();
    	}
    	
    	if (result.equalsIgnoreCase("") || result == null) {
    		result = "NOTHING";
    	} else {
    		result = result.split(":")[1];
    	}
    	
    	logger.debug("result : " + result);
    	logger.debug("getADdata ended.");
    	
    	return result.trim();
    }
    
    /**
     * Active Directory
     * - 부서 추가
     * */    
    public void insertDeptInAD(DirContext ctx, Map<String, Object> map) throws Exception {
    	logger.debug("insertDeptInAD started.");
    	
    	String baseDN = ", OU=부서, OU=" + config.getProperty("config.Company_Name") +
    			", OU=TopGroup, DC=" + config.getProperty("config.Common_Name1");

		String splitDC[] = config.getProperty("config.Common_Name2").split("\\.");
    	for (String dn : splitDC) {
    		baseDN += ", DC=" + dn;
    	}
    	
    	    	
    	baseDN = "cn="+ map.get("v_CN").toString() + baseDN;
    	logger.debug("<<<baseDN : " + baseDN);
    	    	
    	Attributes container = new BasicAttributes(true);
    	Attribute objClasses = new BasicAttribute("objectClass");

    	objClasses.add("group");
    	container.put(objClasses);
    	container.put(new BasicAttribute( "cn", map.get("v_CN") ));
    	container.put(new BasicAttribute( "name", map.get("v_CN") ));
    	container.put(new BasicAttribute( "sAMAccountName", map.get("v_CN") ));
    	container.put(new BasicAttribute( "displayName", map.get("v_DISPLAYNAME").toString().trim() ));
    	container.put(new BasicAttribute( "description", map.get("v_DISPLAYNAME").toString().trim() ));
    	container.put(new BasicAttribute( "groupType", Integer.toString( ACCOUNT_GROUP + SECURITY_ENABLED ) ));
    	    	

    	if (!map.get("v_EXTATTR4").toString().equalsIgnoreCase("")) {
    		container.put(new BasicAttribute( "extensionAttribute4", map.get("v_EXTATTR4") ));
    	}   	
    	
    	if (!map.get("v_EXTATTR5").toString().equalsIgnoreCase("")) {
    		container.put(new BasicAttribute( "extensionAttribute5", map.get("v_EXTATTR5") ));
    	}  
    	
    	if (!map.get("v_EXTATTR6").toString().equalsIgnoreCase("")) {
    		container.put(new BasicAttribute( "extensionAttribute6", map.get("v_EXTATTR6") ));
    	}    
    	
    	if (!map.get("v_EXTATTR8").toString().equalsIgnoreCase("")) {
    		container.put(new BasicAttribute( "extensionAttribute8", map.get("v_EXTATTR8") ));
    	} 
    	
    	if (!map.get("v_EXTATTR9").toString().equalsIgnoreCase("")) {
    		container.put(new BasicAttribute( "extensionAttribute9", map.get("v_EXTATTR9") ));
    	} 
    	if (!map.get("v_EXTATTR10").toString().equalsIgnoreCase("")) {
    		container.put(new BasicAttribute( "extensionAttribute10", map.get("v_EXTATTR10") ));
    	}  
    	
    	if (!map.get("v_EXTATTR15").toString().equalsIgnoreCase("")) {
    		container.put(new BasicAttribute( "extensionAttribute15", map.get("v_EXTATTR15") ));
    	}            	
    	
    	ctx.createSubcontext(baseDN, container);
    	
    	/**
    	 * parentCN의 dn이 나올 경우 -> 하위 부서
    	 * parentCN의 dn이 nothing인 경우 -> 최상위 부서
    	 * */
    	String isTOP = getADdata(ctx, map.get("v_PARENTCN").toString(), "group", "dn");
    	logger.debug("isTOP : " + isTOP);    	
    	
    	// 하위부서 추가
    	if (!isTOP.equalsIgnoreCase("NOTHING")) {
        	ModificationItem mod[] = new ModificationItem[1];
        	mod[0] = new ModificationItem(DirContext.ADD_ATTRIBUTE, new BasicAttribute("member", baseDN));
        	ctx.modifyAttributes(isTOP, mod);        
    	} 	
    	
    	logger.debug("insertDeptInAD ended.");
    }
    
    /**
     * Active Directory
     * - 부서 정보 수정
     * */
    public void updateDeptInAD(DirContext ctx, OrganDeptVO vo) throws Exception {
    	logger.debug("updateDeptInAD started.");
    	
    	String getDN = getADdata(ctx, vo.getCn(), "group", "dn");
    	logger.debug("getDN : " + getDN);
    	
    	ModificationItem[] mods = new ModificationItem[9];
    	List<ModificationItem> mItems = new ArrayList<ModificationItem>();
    	
    	mods[0] = chkADAttribute(ctx, getDN, "displayName", vo.getDisplayName());
    	mods[1] = chkADAttribute(ctx, getDN, "extensionAttribute4", vo.getExtensionAttribute4());
    	mods[2] = chkADAttribute(ctx, getDN, "extensionAttribute5", vo.getExtensionAttribute5());
    	mods[3] = chkADAttribute(ctx, getDN, "extensionAttribute6", vo.getExtensionAttribute6());
    	mods[4] = chkADAttribute(ctx, getDN, "extensionAttribute8", vo.getExtensionAttribute8());
    	mods[5] = chkADAttribute(ctx, getDN, "extensionAttribute9", vo.getExtensionAttribute9());
    	mods[6] = chkADAttribute(ctx, getDN, "extensionAttribute10", vo.getExtensionAttribute10());
    	mods[7] = chkADAttribute(ctx, getDN, "extensionAttribute15", vo.getExtensionAttribute15());
    	mods[8] = chkADAttribute(ctx, getDN, "description", vo.getDisplayName());
    	
		// attribute 값이 null 이 아닌 경우 추출.
    	for (int i = 0; i < mods.length; i ++) {
    		if ( mods[i] != null ) {
    			mItems.add(mods[i]);
    		}
    	}
    	
    	ModificationItem[] items = new ModificationItem[mItems.size()];
    	items = mItems.toArray(items);
    	
    	ctx.modifyAttributes(getDN, items);
    	
    	// 부서 내부의 유저 정보 가져오기
    	ArrayList<HashMap<String, Object>> list = getAllADdata(ctx, "user", "department", vo.getCn());
    	
    	// 부서 유저의 description 변경
    	OrganUserVO userVO = new OrganUserVO();
    	for (int i = 0; i < list.size(); i ++ ) {
  		
    		userVO.setCn(list.get(i).get("cn").toString());
    		userVO.setDescription(vo.getDisplayName());
    		userVO.setDepartment(vo.getCn());
    		
    		updateUserInAD(ctx, userVO, "dept");
    	}    	
    	logger.debug("updateDeptInAD ended.");
    }
    
    /**
     * Active Directory
     * - 부서 정보 삭제
     * */
    public void deleteDeptInAD(DirContext ctx, String cn) throws Exception {
    	logger.debug("deleteDeptInAD started.");
    	
    	String getDN = getADdata(ctx, cn, "group", "dn");
    	
    	logger.debug("getDN : " + getDN);
    	
    	// 부서원이 없을 때 만 부서 삭제
    	// 그룹이 존재하는 경우에만 삭제
    	if (!getDN.equalsIgnoreCase("NOTHING")) {
    		ctx.unbind(getDN);
    	}    	
    	logger.debug("deleteDeptInAD ended.");
    }
    
    /**
     * Active Directory
     * - 부서의 부서 이동
     * */
	public void moveDeptInAD(DirContext ctx, Map<String, Object> map, String dept) throws Exception {
    	logger.debug("moveDeptInAD started.");
    	
    	logger.debug("map.getCN : " + map.get("v_CN").toString());  //현재 부서
    	logger.debug("map.getPARENT : " + map.get("v_PARENTCN").toString()); //이동할 부서
    	logger.debug("dept : " + dept); //이동할 부서
    	
    	// 현재 부서가 속한 부모 부서ID 추출
    	String parDeptID = getADdata(ctx, map.get("v_CN").toString(), "isMember", "cn");
    	// 현재 부서가 속한 부모 부서의 dn
    	String parDept = getADdata(ctx, parDeptID, "group", "dn");    	
    	// 작업이 진행되고 있는 부서의 dn
    	String curDept = getADdata(ctx, map.get("v_CN").toString(), "group", "dn");
    	// 이동될 부서의 dn
    	String movDept = getADdata(ctx, dept, "group", "dn");
    	
    	logger.debug("parDept : " + parDept); 
    	logger.debug("curDept : " + curDept);
    	logger.debug("movDept : " + movDept);
    	
    	/**
    	 * 1. 부모 부서의 member에서 현재 부서를 삭제하기
    	 *  - 필요내용 : 부모 부서의 dn, 현재 부서의 dn
    	 * 2. 현재 부서를 이동 부서의 member에 추가하기
    	 *  - 필요내용 : 이동 부서의 dn, 현재 부서의 dn
    	 * */
    	// 부모 부서의 dn이 없다는 것 -> 최상위 부서에서 이동한다는 뜻.
    	// 부모 부서의 dn이 있다는 것 -> 하위 부서에서 이동한다는 뜻.    	
    	if (!parDept.equalsIgnoreCase("NOTHING")) {
        	ModificationItem[] delDept = new ModificationItem[1];
        	delDept[0] = new ModificationItem(DirContext.REMOVE_ATTRIBUTE, new BasicAttribute("member", curDept));
        	ctx.modifyAttributes(parDept, delDept);
    	}
    	
    	// movDept의 dn이 존재하는 경우, 이동할 부서의 member에 현재 부서 dn 추가
    	if (!movDept.equalsIgnoreCase("NOTHING")) {
        	ModificationItem[] addDept = new ModificationItem[1];
        	addDept[0] = new ModificationItem(DirContext.ADD_ATTRIBUTE, new BasicAttribute("member", curDept));
        	ctx.modifyAttributes(movDept, addDept);            	
    	} 
    	
    	logger.debug("moveDeptInAD ended.");
    }
    
    /*
     * Active Directory
     * - 유저 추가
     * */   
    public void insertUserInAD(DirContext ctx, Map<String, Object> map) throws Exception {
    	logger.debug("insertUserInAD started.");    	
    	
    	String baseDN = ", OU=" + config.getProperty("config.Company_Name") + ", OU=TopGroup, DC=" 	+ config.getProperty("config.Common_Name1");
    	
		String splitDC[] = config.getProperty("config.Common_Name2").split("\\.");
    	for (String dn : splitDC) {
    		baseDN += ", DC=" + dn;
    	}

    	Attributes container = new BasicAttributes(true);
    	Attribute objClasses = new BasicAttribute("objectClass");
    	
    	
		/**
		 * v_CN에는 유저 아이디 정보
		 * v_PARENTCN에는 그룹 아이디 정보
		 * */
		String userDN = ", OU=사용자" + baseDN;   
		String domainName = config.getProperty("config.Domain_Name");    		
		String quotedPassword = "\"" + map.get("v_INSERTADPASS") + "\"";
		
	    byte[] pwdArray = quotedPassword.getBytes("UTF-16LE");

    	objClasses.add("user");    
    	
    	container.put(objClasses);
    	container.put(new BasicAttribute( "userPrincipalName", map.get("v_CN") + "@" + domainName ));
    	container.put(new BasicAttribute( "cn", map.get("v_CN") ));
    	container.put(new BasicAttribute( "sn", map.get("v_CN") ));
    	container.put(new BasicAttribute( "displayName", map.get("v_DISPLAYNAME") == null ? map.get("v_DISPLAYNAME2") : map.get("v_DISPLAYNAME") ));
    	container.put(new BasicAttribute( "mail", map.get("v_CN") + "@" +  domainName ));
    	container.put(new BasicAttribute( "unicodePwd", pwdArray )); 
    	container.put(new BasicAttribute( "sAMAccountName", map.get("v_CN") ));
    	container.put(new BasicAttribute( "userAccountControl", Integer.toString( UF_NORMAL_ACCOUNT + UF_DONT_EXPIRE_PASSWD ) ));
    	
    	String description = getADdata(ctx, map.get("v_PARENTCN").toString(), "group", "displayName");
    	
    	//부서 정보 추가 하기.
    	container.put(new BasicAttribute( "description", description.trim() )); // 부서명
    	container.put(new BasicAttribute( "department", map.get("v_PARENTCN") ));  // 부서id

    	
	    if (!map.get("v_TITLE").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "title", map.get("v_TITLE") ));
		} 
		if (!map.get("v_TELEPHONE").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "telephoneNumber", map.get("v_TELEPHONE") ));
		}
		if (!map.get("v_HOMEPHONE").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "homePhone", map.get("v_HOMEPHONE") ));
		} 
		if (!map.get("v_FAX").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "facsimileTelephoneNumber", map.get("v_FAX") ));
		}
		if (!map.get("v_MOBILE").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "mobile", map.get("v_MOBILE") ));
		}
		if (!map.get("v_POSTALCODE").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "postalCode", map.get("v_POSTALCODE") ));
		}
		if (!map.get("v_ADDRESS").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "postalAddress", map.get("v_ADDRESS") ));
		}
		if (!map.get("v_EXTATTR6").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "extensionAttribute6", map.get("v_EXTATTR6") ));
		}
		if (!map.get("v_EXTATTR10").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "extensionAttribute10", map.get("v_EXTATTR10") ));
		}
		if (!map.get("v_EXTATTR14").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "extensionAttribute14", map.get("v_EXTATTR14") ));
		}
		if (!map.get("v_EXTATTR15").toString().equalsIgnoreCase("")) {
			container.put(new BasicAttribute( "extensionAttribute15", map.get("v_EXTATTR15") ));
		}   	

    	userDN = new StringBuffer().append("CN=").append(map.get("v_CN")).append(userDN).toString();
    	ctx.createSubcontext(userDN, container);
    	
    	/**
    	 * 해당 부서에 추가
    	 * CN=부서명, OU=부서(그룹명), OU=회사명, OU=TopGroup, DC=도메인명(@앞부분), DC=도메인명(@뒷부분)
    	 * v_PARENTCN 값으로 사용
    	 * */
    	String dn = getADdata(ctx, map.get("v_PARENTCN").toString(), "group", "dn");
    	logger.debug("<<<DN : " + dn );
    	ModificationItem mod[] = new ModificationItem[1];
    	mod[0] = new ModificationItem(DirContext.ADD_ATTRIBUTE, new BasicAttribute("member", userDN));
    	ctx.modifyAttributes(dn, mod);        	
    	
    	logger.debug("insertUserInAD ended."); 
    }
    
    /**
     * Active Directory
     * - 사용자 내용 수정
     * */
	public void updateUserInAD(DirContext ctx, OrganUserVO vo, String passBy) throws Exception {
    	logger.debug("updateUserInAD started.");   
    	
    	List<ModificationItem> mItems = new ArrayList<ModificationItem>();
    	String getDN = getADdata(ctx, vo.getCn(), "user", "dn");
    	
    	logger.debug("getDN : " + getDN.trim() );
    	
    	// 사원 정보 메뉴에서 수정하는 경우
    	if (passBy.equalsIgnoreCase("user")) {
    		
	    	ModificationItem[] mods = new ModificationItem[12];
	    	
	    	mods[0] = chkADAttribute(ctx, getDN,"displayName", vo.getDisplayName());
	    	mods[1] = chkADAttribute(ctx, getDN, "title", vo.getTitle());
	    	mods[2] = chkADAttribute(ctx, getDN, "extensionAttribute6", vo.getExtensionAttribute6());
	    	mods[3] = chkADAttribute(ctx, getDN, "extensionAttribute10", vo.getExtensionAttribute10());
	    	mods[4] = chkADAttribute(ctx, getDN, "extensionAttribute14", vo.getExtensionAttribute14());
	    	mods[5] = chkADAttribute(ctx, getDN, "extensionAttribute15", vo.getExtensionAttribute15());
	    	mods[6] = chkADAttribute(ctx, getDN, "telephoneNumber", vo.getTelephoneNumber());
	    	mods[7] = chkADAttribute(ctx, getDN, "homePhone", vo.getHomePhone());
	    	mods[8] = chkADAttribute(ctx, getDN, "facsimileTelephoneNumber", vo.getFacsimileTelephoneNumber());
	    	mods[9] = chkADAttribute(ctx, getDN, "mobile", vo.getMobile());
	    	mods[10] = chkADAttribute(ctx, getDN, "postalCode", vo.getPostalCode());
	    	mods[11] = chkADAttribute(ctx, getDN, "postalAddress", vo.getStreetAddress());
	    	
	    	// attribute 값이 null 이 아닌 경우 추출.
	    	for (int i = 0; i < mods.length; i ++) {
	    		if ( mods[i] != null ) {
	    			mItems.add(mods[i]);
	    		}
	    	}
	    	
	    	ModificationItem[] items = new ModificationItem[mItems.size()];
	    	items = mItems.toArray(items);
	    	
	    	ctx.modifyAttributes(getDN, items);
	    
	    // 부서 정보를 수정하는 경우 -> 해당 사원들의 부서 정보도 변경 되어야한다.
    	} else if (passBy.equalsIgnoreCase("dept")) {
    		
    		ModificationItem[] mods = new ModificationItem[2];
    		
    		mods[0] = chkADAttribute(ctx, getDN, "department", vo.getDepartment());
    		mods[1] = chkADAttribute(ctx, getDN, "description", vo.getDescription());
    		
    		ctx.modifyAttributes(getDN, mods);
    	// 퇴직자 처리하는 경우
    	} else if (passBy.equalsIgnoreCase("retire")) {
    		//현재의 dn을 retire쪽으로 변경
    		String retireDN = "CN="+ vo.getCn() + ",OU=Retire,OU="+config.getProperty("config.Company_Name")+",OU=TopGroup,DC="
    				+config.getProperty("config.Common_Name1");

    		String splitDC[] = config.getProperty("config.Common_Name2").split("\\.");
	    	for (String dn : splitDC) {
	    		retireDN += ", DC=" + dn;
	    	}
    		
    		logger.debug("retireDN : " + retireDN);
    		ctx.rename(getDN, retireDN);	
    	} else if (passBy.equalsIgnoreCase("restore")) {
    		/**
    		 * 1. 부서의 이동 PARENTCN : 이동할 부서, CN : 현재 유저ID
    		 * 2. 해당 부서에 사용자 등록
    		 * 3. 기존 부서에서 사용자 삭제
    		 * */
    		String curDN = getADdata(ctx, vo.getCn(), "user", "dn");
    		String movDN = "CN="+ vo.getCn() + ",OU=사용자,OU="+config.getProperty("config.Company_Name")+",OU=TopGroup,DC="
    				+config.getProperty("config.Common_Name1");
			String splitDC[] = config.getProperty("config.Common_Name2").split("\\.");
	    	for (String dn : splitDC) {
	    		movDN += ", DC=" + dn;
	    	}
	    	
    		logger.debug("curDN : " + curDN);
    		logger.debug("movDN: " + movDN);

    		Map<String, Object> map = new HashMap<String, Object>();
    		map.put("v_CN", vo.getCn());
    		
    		moveUserInAD(ctx, map, vo.getParentCn());
    		
    		ctx.rename(curDN, movDN);    		
    	}
    	
    	logger.debug("updateUserInAD started.");       	
    }

    /**
     * Active Directory
     * - 사용자 삭제
     * */
    public void deleteUserInAD(DirContext ctx, String cn) throws Exception {
    	logger.debug("deleteUserInAD started.");   
    	
    	String getDN = getADdata(ctx, cn, "user", "dn");
    	
    	logger.debug("getDN : " + getDN);
    	
    	// 빈 부서를 지울 경우, 유저가 없기 때문에 분기를 태운다.
    	if (!getDN.equalsIgnoreCase("NOTHING")) {
    		ctx.unbind(getDN);
    	}   	
    	
    	logger.debug("deleteUserInAD started.");       	
    }    
    
    /**
     * Active Directory
     * - 데이터 수정을 위한 Attribute 확인.
     * dn : distinguished name
     * attr : 변경될 attribute
     * value : 새로 변경되는 내용
     * */
	public ModificationItem chkADAttribute(DirContext ctx, String dn, String attr, String value) throws Exception {
	
		ModificationItem mod;
    	String [] arr = {attr};
    	Attributes container = new BasicAttributes(true);   
    	    	 		
		container = ctx.getAttributes(dn, arr);
		/**
		 * container.size() == 0 은 attr로 넘어온 값을 지닌 attribute가 존재하지 않은 경우.
		 * */
		logger.debug("container.size() : " + container.size());
		if (container.size() == 0) {
			//현재 attribute가 존재하지 않음 && value값이 존재함
			if (value != null && !value.equalsIgnoreCase("")) {
				mod = new ModificationItem(DirContext.ADD_ATTRIBUTE, new BasicAttribute(attr, value));
			//현재 attribute가 존재하지 않음 && value값이 존재하지 않음. 또다시 빈값이 들어온 경우
			} else {
				mod = null;
			}
		} else {
			//현재 attribute가 존재하는 경우 && value값이 존재하지 않는 경우.
	    	if ( value == null || value.equalsIgnoreCase("") ) {
	    		//mod = new ModificationItem(ctx.REPLACE_ATTRIBUTE, new BasicAttribute(attr, "empty"));
	    		mod = new ModificationItem(DirContext.REMOVE_ATTRIBUTE, new BasicAttribute(attr));
	    	//현재 attribute가 존재하는 경우 && value값지 존재하는 경우
	    	} else {    		
	    		mod = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute(attr, value));
	    	}    
		}		
    	return mod;
    }

    /**
     * Active Directory
     * - 유저의 부서이동
     * dept : 변경될 부서ID
     * */
	public void moveUserInAD(DirContext ctx, Map<String, Object> map, String dept) throws Exception {
    	logger.debug("moveUserInAD started.");
    	// 현재 유저 dn
    	String curUser = getADdata(ctx, map.get("v_CN").toString(), "user", "dn");
    	// 현재 유저의 department
    	String userDept = getADdata(ctx, map.get("v_CN").toString(), "user", "department");
    	// 현재 부서 dn
    	String curDept = getADdata(ctx, userDept.trim(), "group", "dn");
    	// 옮길 부서 dn
    	String movDept = getADdata(ctx, dept, "group", "dn");
    	// 옮길 부서 displayName
    	String movDisplay = getADdata(ctx, dept, "group", "displayName");
    	
    	logger.debug("curUser : " + curUser);
    	logger.debug("userDept : " + userDept.trim());
    	logger.debug("curDept : " + curDept);
    	logger.debug("movDept : " + movDept);
    	logger.debug("movDisplay : " + movDisplay);
    	
    	/**
    	 * 유저의 attibute값 변경
    	 * 1. department -> 옮길 부서id
    	 * 2. description -> 옮길 부서명
    	 * */
    	ModificationItem[] mods = new ModificationItem[2];
    	
    	mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("department", dept.trim() ));
    	mods[1] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("description", movDisplay.trim() ));
    	ctx.modifyAttributes(curUser, mods);
    	
    	/**
    	 * 1. 본래 부서에 유저 제거
    	 * 2. 변경 부서에 유저 추가 
    	 * */    	
    	ModificationItem[] delUser = new  ModificationItem[1];    	
    	delUser[0] = new ModificationItem(DirContext.REMOVE_ATTRIBUTE, new BasicAttribute("member", curUser));
    	ctx.modifyAttributes(curDept, delUser);
    	
    	String newDN = getADdata(ctx, map.get("v_CN").toString(), "user", "dn");
    	
    	logger.debug("newDN : " + newDN);
    	
    	ModificationItem[] addUser = new ModificationItem[1];
    	addUser[0] = new ModificationItem(DirContext.ADD_ATTRIBUTE, new BasicAttribute("member", newDN));
    	ctx.modifyAttributes(movDept, addUser);
    	
    	logger.debug("moveUserInAD ended.");
    }
    
    /**
     * Active Directory
     * - 퇴직자 처리
     * */
    public void retireUserInAD(DirContext ctx, Map<String, Object> map) throws Exception {
    	logger.debug("retireUserInAD started.");
    	//empty VO 생성.
    	OrganUserVO vo = new OrganUserVO();

    	vo.setCn(map.get("v_CN").toString());
    	
    	updateUserInAD(ctx, vo, "retire");
    	
    	logger.debug("retireUserInAD ended.");
    }
    
    /**
     * Active Directory
     * - 퇴직자 복구
     * */
    public void restoreUserInAD(DirContext ctx, Map<String, Object> map) throws Exception {
    	logger.debug("restoreUserInAD started.");
    	
    	OrganUserVO vo = new OrganUserVO();
    	
    	vo.setParentCn(map.get("v_PARENTCN").toString());
    	vo.setCn(map.get("v_CN").toString());
    	
    	updateUserInAD(ctx, vo, "restore");    	
    	
    	logger.debug("restoreUserInAD ended.");
    }
    
    /**
     * Active Directory
     * - 유저 패스워드 변경
     * */
    public void changePasswordInAD(DirContext ctx, LoginVO vo) throws Exception {
    	logger.debug("changePasswordInAD started.");   
    	
    	String getDN = getADdata(ctx, vo.getId(), "user", "dn");
    	
    	logger.debug("getDN : " + getDN );
    	
    	String quotedPassword = "\"" + vo.getPassword() + "\"";
    	
    	byte[] pwdArray = quotedPassword.getBytes("UTF-16LE");
    	
    	ModificationItem[] mods = new ModificationItem[2];

    	mods[0] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("unicodePwd", pwdArray));
    	mods[1] = new ModificationItem(DirContext.REPLACE_ATTRIBUTE, new BasicAttribute("userAccountControl", Integer.toString( UF_NORMAL_ACCOUNT + UF_DONT_EXPIRE_PASSWD ) ));

    	ctx.modifyAttributes(getDN, mods);
    	// 한 번만 실행하면 직전 패스워드로도 로그인이 되어 두 번 수행함
    	ctx.modifyAttributes(getDN, mods);    
    	
    	logger.debug("changePasswordInAD started."); 
    }
	
	// 사용자 이름,부서 목록을 반환한다.
    @SuppressWarnings("unchecked")
	public List<OrganUserVO> getUserList(Map<String, Object> map) throws Exception {
    	return (List<OrganUserVO>) list("EzOrganAdminDAO.userList", map);
    }	
    
    // 사용자 이름,부서 목록개수를 반환한다.
    public int getUserCount(Map<String, Object> map) throws Exception {
    	return (int) select("EzOrganAdminDAO.getUserCount", map);        
    }
    
    //삭제처리된 유저의 데이터를 저장한다. 2018-06-04 홍대표
    public void insertDelUserDBData_I (Map<String, Object> map) throws Exception {
		insert("EzOrganAdminDAO.insertDelUserDBData_I", map);
	}
    
    //삭제처리된 유저의 데이터를 삭제한다. 2018-06-04 홍대표
    public void deleteDelUserDBData_I (Map<String, Object> map) throws Exception {
    	delete("EzOrganAdminDAO.deleteDelUserDBData_I", map);
    }
    
    public void setTitle(Map<String, Object> map) throws Exception {
    	insert("EzOrganAdminDAO.insertTitle", map);
    }

	public OrganJobVO getTitleByJobID(Map<String, Object> map) throws Exception {
		return (OrganJobVO) select("EzOrganAdminDAO.selectTitleByJobID", map);
	}
    
    @SuppressWarnings("unchecked")
	public List<OrganJobVO> getTitleList(Map<String, Object> map) throws Exception {
		return (List<OrganJobVO>) list("EzOrganAdminDAO.selectTitleList", map);
	}
    
    public OrganJobVO getTitleInfo(Map<String, Object> map) throws Exception {
		return (OrganJobVO) select("EzOrganAdminDAO.selectTitleInfo", map);
	}
    
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getExportUserList(Map<String, Object> map) {
		return (List<OrganUserVO>)list("EzOrganAdminDAO.getExportUserList", map);
	}
	
	public void updateTitle(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateTitle", map);
	}
	
	public void updateTitle2(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateTitle2", map);
	}
	
	public void updateTitle3(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateTitle3", map);
	}
	
	public void deleteTitle(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteTitle", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getTitleUserList(Map<String, Object> map) throws Exception {
		return (List<OrganUserVO>) list("EzOrganAdminDAO.selectTitleUserList", map);
	}
	
	public int getTitleListCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzOrganAdminDAO.selectTitleListCnt", map);
	}
	
	public int getTitleUserListCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzOrganAdminDAO.selectTitleUserListCnt", map);
	}
	
	public int getTitleUserListCnt2(Map<String, Object> map) throws Exception {
		return (int) select("EzOrganAdminDAO.selectTitleUserListCnt2", map);
	}
	
	public int getTitleCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzOrganAdminDAO.selectTitleCnt", map);
	}

	public int getAddJobCount(Map<String, Object> map) throws Exception{
		return (int) select("EzOrganAdminDAO.getAddJobCount", map);
	}
	
	public void setAddJobCount(Map<String, Object> map) throws Exception{
		update("EzOrganAdminDAO.getAddJobCount", map);
	}

	public String getCompanyName(Map<String, Object> map) throws Exception {
		return (String) select ("EzOrganAdminDAO.getCompanyName", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getDeptAddJobUserList(Map<String, Object> map) throws Exception {
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getDeptAddJobUserList", map);
	}
	
	public void setPermissionGroupList(Map<String, Object> map) throws Exception {
		insert("EzOrganAdminDAO.setPermissionGroupList", map);
	}
	
	public void updatePermissionGroupList(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updatePermissionGroupList", map);
	}
	
	public void setPermissionGroupInfo(Map<String, Object> map) throws Exception {
		insert("EzOrganAdminDAO.setPermissionGroupInfo", map);
	}
	
	public void deletePermissionGroupList(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deletePermissionGroupList", map);
    }
	
	public void deletePermissionGroupInfo(Map<String, Object> map) throws Exception {
        delete("EzOrganAdminDAO.deletePermissionGroupInfo", map);
    }
	
	public int getPermissionGroupListCount(Map<String, Object> map) throws Exception {
        return (int)select("EzOrganAdminDAO.getPermissionGroupListCount", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<OrganGroupVO> getPermissionGroupList(Map<String, Object> map) throws Exception {
        return (List<OrganGroupVO>) list("EzOrganAdminDAO.getPermissionGroupList", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<OrganGroupVO> getPermissionGroupInfo(Map<String, Object> map) throws Exception {
        return (List<OrganGroupVO>) list("EzOrganAdminDAO.getPermissionGroupInfo", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<OrganGroupVO> getGroupList(Map<String, Object> map) throws Exception {
        return (List<OrganGroupVO>) list("EzOrganAdminDAO.getGroupList", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<OrganJobVO> getTitleList_group(Map<String, Object> map) throws Exception {
		return (List<OrganJobVO>) list("EzOrganAdminDAO.selectTitleList_group", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganGroupVO> getGroupListBoard(Map<String, Object> map) throws Exception {
        return (List<OrganGroupVO>) list("EzOrganAdminDAO.getGroupListBoard", map);
    }
	
	@SuppressWarnings("unchecked")
	public List<OrganLoginStopUserVO> getLoginStopUserList(Map<String, Object> map) throws Exception {
		return (List<OrganLoginStopUserVO>) list("EzOrganAdminDAO.getLoginStopUserList", map);
	}
	
    public int getLoginStopUserListCount(Map<String, Object> map) throws Exception {
    	return (int) select("EzOrganAdminDAO.getLoginStopUserListCount", map);        
    }
    
    public void insertStopUser(Map<String, Object> map) throws Exception {
    	insert ("EzOrganAdminDAO.insertStopUser", map);
    }
    
    public void deleteStopUser(Map<String, Object> map) throws Exception {
    	delete ("EzOrganAdminDAO.deleteStopUser", map);
    }
    
    public int checkStopUser(Map<String, Object> map) throws Exception {
    	return (int) select ("EzOrganAdminDAO.checkStopUser", map);
    }

    public void setDeptPrimaryMail (Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.setDeptMail", map);
	}
	
	public void deleteCompanyConfig(Map<String, Object> map) throws Exception {
		delete("EzOrganAdminDAO.deleteCompanyConfig", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getNotUseMobileUserList(int tenantId) {
		return (List<String>) list("EzOrganAdminDAO.getNotUseMobileUserList", tenantId);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getAutoDeleteOfRetireUserList(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzOrganAdminDAO.getAutoDeleteOfRetireUserList", map);
	}

	@SuppressWarnings("unchecked")
	public void insertPermissionChHist(PermissionInfoVO vo) throws Exception {
		update("EzOrganAdminDAO.insertPermissionChHist", vo);
	}
	
	public OrganUserVO getUserDeptInfo(OrganUserVO vo) throws Exception {
		return (OrganUserVO) select("EzOrganAdminDAO.getUserDeptInfo", vo);
	}
	
	public OrganDeptVO getDeptDisplayNm(OrganDeptVO vo) throws Exception {
		return (OrganDeptVO) select("EzOrganAdminDAO.getDeptDisplayNm",vo);
	}

	public String getDeptParentCn(OrganDeptVO vo) throws Exception {
		return (String) select("EzOrganAdminDAO.getDeptParentCn",vo);
	}
	
	public OrganUserVO getAddJobInfo(Map<String, Object> map) throws Exception {
		return (OrganUserVO) select ("EzOrganAdminDAO.getAddJobInfo",map);
	}

	public List<OrganUserVO> getExportAddJobList(Map<String, Object> map) throws Exception {
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getExportAddJobList", map);
	}

	public List<OrganUserVO> getExportPermissionsList(Map<String, Object> map) throws Exception {
		return (List<OrganUserVO>) list("EzOrganAdminDAO.getExportPermissionsList", map);
	}
	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/사용자 기준으로 권한 설정 옵션 사용하면서 권한 변경 시 권한 히스토리 삽입
	public void insertPermissionChHistBasisDept(PermissionInfoVO vo) throws Exception {
		update("EzOrganAdminDAO.insertPermissionChHistBasisDept", vo);
	}

	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 권한 삽입 대상의 원직/겸직 여부 확인
	public int isThisAddJob(HashMap<String, Object> map) throws Exception {
		return (int) select("EzOrganAdminDAO.isThisAddJob", map);
	}

	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 원직일 경우의 권한 삽입
	public void updatePermissionIntoUserMaster(HashMap<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updatePermissionIntoUserMaster", map);
	}

	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직일 경우의 권한 삽입
	public void updatePermissionIntoAddJobMaster(HashMap<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updatePermissionIntoAddJobMaster", map);
	}

	public int getUserJobCheckCount(Map<String, Object> map) throws Exception {
		return (int) select("EzOrganAdminDAO.getUserJobCheckCount", map);
	}

	// 지정된 부서에 속한 퇴직자 수를 반환한다.
	public int retireUserCountCheck(String cn, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cn", cn);
		map.put("tenantID", tenantID);

		return retireUserCountCheckForLocal(map);
	}

	private int retireUserCountCheckForLocal(Map<String, Object> map) {
		String cn = (String)map.get("cn");
		int tenantID = (Integer)map.get("tenantID");

		logger.debug("retireUserCountCheckForLocal started. cn=" + cn + ",tenantID=" + tenantID);

		int userCount = (int) select("EzOrganAdminDAO.retireUserCountCheck", map);

		logger.debug("retireUserCountCheckForLocal started. userCount=" + userCount);

		return userCount;
	}
	
	public String getUserExtension15(Map<String, Object> map) throws Exception {
		return (String) Optional.ofNullable(select("EzOrganAdminDAO.getUserExtension15",map)).orElseGet(() -> "0");
	}

	public String getDeptExtension15(Map<String, Object> map) throws Exception {
		 return (String) Optional.ofNullable(select("EzOrganAdminDAO.getDeptExtension15",map)).orElseGet(() -> "0");
	}

	// 2024-05-17 한태훈 > 회사 탑메뉴 설정 위치 기본값 세팅 (기본값 : 0 = 메뉴 위치 상단)
	public void insertCompanyTopMenuInfo(Map<String, Object> map) {
		insert("EzOrganAdminDAO.insertCompanyTopMenuInfo", map);
	}

	// 2024-05-27 관리자 > 조직도 > 겸직 사용자 상세정보 내용 호출 함수
	public OrganAddJobVO getAddJobPorpValue(Map<String, Object> map) throws Exception {
		return (OrganAddJobVO) select("EzOrganAdminDAO.getAddJobPorpValue", map);
	}
	
	public void updateAddJobInfo(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateAddJobInfo", map);
	}
	
	// 2024-07-23 한태훈 > 회사 추가시 연계메뉴 및 기본 시스템 컨피그 추가
	public void insertConnectMenuForNewCompany(Map<String, Object> map) {
		insert("EzOrganAdminDAO.insertConnectMenuForCompany", map);
		insert("EzOrganAdminDAO.insertConnectMenuAuthForCompany", map);
		insert("EzOrganAdminDAO.insertConnectionMenuNameForCompany", map);
		insert("EzOrganAdminDAO.insertSystemConfigTypeForCompany", map);
		insert("EzOrganAdminDAO.insertDefaultSystemConfigForCompany", map);
	}

	public void insertMobileMenuForNewCompany(Map<String, Object> map) throws Exception {
		insert("EzOrganAdminDAO.insertMobileMenuForNewComp", map);
		insert("EzOrganAdminDAO.insertMobileMenuAuthForNewComp", map);
		insert("EzOrganAdminDAO.insertMobileMenuNameForNewComp", map);
	}

	public void resetLoginCnt(Map<String, Object> map) throws Exception {
		update("EzOrganAdminDAO.updateResetLoginCnt", map);
	}
}