package egovframework.ezEKP.ezOrgan.service.impl;

import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;
import java.util.UUID;

import javax.annotation.Resource;
import javax.naming.directory.DirContext;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.util.ADConnection;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezResource.dao.EzResourceAdminDAO;
import egovframework.let.user.login.dao.LoginDAO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Service("EzOrganAdminService")
public class EzOrganAdminServiceImpl implements EzOrganAdminService {
	
    private static final Logger logger = LoggerFactory.getLogger(EzOrganAdminServiceImpl.class);
    
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzEmailUserAdminService ezEmailUserAdminService;
	
	@Autowired
	private EzOrganDAO ezOrganDao;
		
	@Autowired
	private EzOrganAdminDAO ezOrganAdminDao;
	
	@Autowired
	private LoginDAO loginDAO;
		
	@Autowired	
	private CommonUtil commonUtil;
	
    @Autowired
    private EzCommonService ezCommonService;
    
    @Autowired
    private EzEmailUtil ezEmailUtil;
    
    @Autowired
    private ADConnection conn;
    
    @Autowired
    private Properties config;
    
	@Resource(name="EzResourceAdminDAO")
	private EzResourceAdminDAO ezResourceAdminDAO;
    
	@Override
	public List<OrganDeptVO> getCompanyList(String lang, int tenantID) throws Exception {
	    logger.debug("getCompanyList started");
	    
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("lang", lang);
		map.put("tenantID", tenantID);
		
		List<OrganDeptVO> companyList = ezOrganAdminDao.getCompanyList(map);
		
		logger.debug("getCompanyList ended");
		
		return companyList;
	}
	
	@Override
	public List<OrganUserVO> getAddJobList(String companyID, String strLang, int tenantID) throws Exception {
	    logger.debug("getAddJobList started");
	    logger.debug("companyID=" + companyID + ",strLang=" + strLang + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_LANGDATA", strLang);
		
		List<OrganUserVO> addJobList = ezOrganAdminDao.getAddJobList(map);
		
		logger.debug("getAddJobList ended");
		
		return addJobList;
	}

	@Override
	public List<OrganUserVO> getUserAddJobList(String cn, String strLang, int tenantID) throws Exception {
	    logger.debug("getUserAddJobList started");
	    logger.debug("cn=" + cn + ",strLang=" + strLang + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_LANGDATA", strLang);
		
		List<OrganUserVO> userAddJobList = ezOrganAdminDao.getUserAddJobList(map);
		
		logger.debug("getUserAddJobList ended");
		
		return userAddJobList;
	}
	
	@Override
	public List<OrganUserVO> getPermissionList(String companyID, String type, String searchType, String searchValue, String strLang, int startRow, int endRow, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TYPE", type);
		map.put("v_LANGDATA", strLang);
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
        map.put("v_STARTNUM", startRow - 1);
        map.put("v_COUNT", endRow - startRow + 1);
        map.put("searchType", searchType);
        map.put("searchValue", searchValue);
		
		return ezOrganAdminDao.getPermissionList(map);
	}

	@Override
	public List<OrganUserVO> getRetireList(int pPage, int pPageRow, int tenantID, String companyId)	throws Exception {
        logger.debug("getRetireList started");
        logger.debug("pPage=" + pPage + ",pPageRow=" + pPageRow + ",tenantID=" + tenantID + ",companyId=" + companyId);
	    
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_PAGE", pPage);
		map.put("v_ROWPERPAGE", pPageRow);
		map.put("v_STARTROW", pPageRow*(pPage - 1));
		map.put("companyId", companyId);
				
		List<OrganUserVO> retireList = ezOrganAdminDao.getRetireList(map);
		
        logger.debug("getRetireList ended");
		
		return retireList;
	}

	// 퇴직자 포함하여 사용자 아이디 목록을 반환한다.
    @Override
    public List<OrganUserVO> getUserCnList(int tenantID) throws Exception {     
        
    	return ezOrganAdminDao.getUserCnList(tenantID);
    }

    // 퇴직자 포함하여 사용자 아이디 개수를 반환한다.
    @Override
    public int getUserCount(int tenantID) throws Exception {     
        return ezOrganAdminDao.getUserCount(tenantID);
    }
    
    // 사원 혹은 부서의 지정된 속성 목록을 XML 형식으로 반환한다.
	@Override
	public String getPropertyList(String pCN, String pPropList, String pLangCode, int tenantID) throws Exception {
	    logger.debug("getPropertyList started");
	    logger.debug("pCN=" + pCN + ",pPropList=" + pPropList + ",pLangCode=" + pLangCode + ",tenantID=" + tenantID);
	    
		String propvalue = "";
		String DataType = "user";
		Object vo = null;
		StringBuilder propinfo = new StringBuilder("<DATA>");
		
		// 지정된 pCN이 사원인지 확인하고 사원이면 해당 사원의 정보를 가져온다.
		vo = getUserInfo(pCN, pLangCode, tenantID);

		// 사원이 아닌 경우 부서 정보를 가져온다. 
		if (vo == null) {
			Map<String, Object> map1 = new HashMap<String, Object>();
			
			map1.put("userID", pCN);
			map1.put("primary", pLangCode);
			map1.put("v_TENANT_ID", tenantID);
			
			vo = ezOrganDao.getDeptInfo(map1);
			DataType = "group";
		}
		
		// 지정된 속성 목록중 특정 속성에 대해 Primary 언어와 Secondary 언어용 속성을 추가 확장한다.
		pPropList = ezOrganService.convertAddandConvert(DataType, pPropList);
		String[] proplist = pPropList.split(";");
	
		// 각 속성을 XML 태그 및 값으로 변환한다.
		for (String propname : proplist) {
		    // VO 객체에 있는 속성이 아닌 경우엔 DB로부터 값을 읽어들인다.
            if (ezOrganService.checkDBColum(propname.toUpperCase()) == false) {
                propvalue = ezOrganService.getPropertyValue(pCN, propname, tenantID);
                propinfo.append("<" + propname.toUpperCase() + ">" + commonUtil.cleanValue(propvalue) + "</" + propname.toUpperCase() + ">");
            // VO 객체에 있는 속성인 경우에는 VO 객체로부터 값을 읽어들인다.
            } else if (!propname.toUpperCase().equals("")) {
            	Field field = vo.getClass().getDeclaredField(propname);
            	field.setAccessible(true);          	            		
            	
            	propinfo.append("<" + propname.toUpperCase() + ">" + (field.get(vo) != null ? commonUtil.cleanValue(String.valueOf(field.get(vo))) : "") + "</" + propname.toUpperCase() + ">");            	            	            	                
            }
        }
		
        propinfo.append("</DATA>");
  
        logger.debug("propinfo=" + propinfo);
        logger.debug("getPropertyList ended");
        
        return propinfo.toString();
	}

	@Override
	public String moveEntry(String parentCn, String cn, String type, int tenantID) throws Exception {
	    logger.debug("moveEntry started");
	    logger.debug("parentCn=" + parentCn + ",cn=" + cn + ",type=" + type + ",tenantID=" + tenantID);
	    
		String result = "";
		
		if (parentCn.equals(cn)) {
			result = "SAME";
		}else{
			// skyblue0o0
			String oldGroupAddr = "";
			String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
			
			if (type.equalsIgnoreCase("group")) {
				OrganDeptVO dept = ezOrganService.getDeptInfo(cn, "1", tenantID);
				oldGroupAddr = dept.getExtensionAttribute1() + "@" + domain;
			} else {
				OrganUserVO userVO = getUserInfo(cn, "1", tenantID);
				oldGroupAddr = userVO.getDepartment() + "@" + domain;
			}
			
			String newGroupAddr = parentCn + "@" + domain;
			String mailAddr = cn + "@" + domain;
			
			int rc = ezEmailUserAdminService.updateGroupMove(oldGroupAddr, newGroupAddr, mailAddr);
			
			if (rc == 0) { // 성공
				try {
					moveDBData(parentCn, cn, type, tenantID);
		            result = "OK";
				} catch (Exception e) {
					ezEmailUserAdminService.updateGroupMove(newGroupAddr, oldGroupAddr, mailAddr);
					result = "EMAIL_ERROR";
				}				
			} else {
				result = "EMAIL_ERROR";
			}
			// skyblue0o0 - end
			
		}
		
		logger.debug("moveEntry ended");
		
		return result;
	}
	
	@Override
	public void updateProperty(String cn, String column, String number, String pClass, int tenantID) throws Exception {
	    logger.debug("updateProperty started");
	    logger.debug("cn=" + cn + ",column=" + column + ",number=" + number + ",pClass=" + pClass + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_CLASS", pClass);
		map.put("v_PROPNAME", column);
		map.put("v_PROPVALUE", number);
		
        // 사원의 경우
    	if (pClass.toLowerCase().equals("user")) {
    		ezOrganAdminDao.updateProperty(map);
    	// 부서의 경우
    	} else {
    		ezOrganAdminDao.updateProperty_U(map);
    	}       
		
		logger.debug("updateProperty ended");
	}

	public void moveDBData(String parentCn, String cn, String type, int tenantID) throws Exception {
        logger.debug("moveDBData started");
        logger.debug("parentCn=" + parentCn + ",cn=" + cn + ",type=" + type + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_PARENTCN", parentCn);
		map.put("v_CN", cn);
		map.put("v_CLASS", type);
		
		logger.debug("type="+type);
		
        ezOrganAdminDao.moveDBDataForJMocha(map);
        
    	if (type.toLowerCase().equals("group")) {
    		OrganDeptVO dept = ezOrganAdminDao.moveDBData_S(map);
    		OrganDeptVO dept1 = ezOrganAdminDao.moveDBData_S1(map);
    		
    		logger.debug("dept=" + dept.toString());
    		logger.debug("dept1=" + dept1.toString());
    		
    		map.put("v_COMPNM2", dept.getCompNm2());
    		map.put("v_EXTENSIONATTRIBUTE4", dept.getExtensionAttribute4());
    		map.put("v_EXTENSIONATTRIBUTE2", dept.getExtensionAttribute2());
    		
    		if (dept.getDeptLevel() != null) {
    		    try {
        		    int deptLevel = Integer.parseInt(dept.getDeptLevel()) + 1;
        		    map.put("v_DEPTLEVEL", deptLevel);
    		    } catch (NumberFormatException e) {
    		        map.put("v_DEPTLEVEL", null);
    		    }
    		} else {
    		    map.put("v_DEPTLEVEL", null);
    		}
    		
    		map.put("v_EXTENSIONATTRIBUTE3", dept.getExtensionAttribute3());
    		map.put("v_DEPT_CD_PATH", dept.getDept_Cd_Path());
    		map.put("v_DEPT_CD_PATH_OLD", dept1.getDept_Cd_Path());
    		
    		ezOrganAdminDao.moveDBData_U1(map);
    		ezOrganAdminDao.moveDBData_U2(map);
    		ezOrganAdminDao.moveDBData_U3(map);
    		
    		/**
    		 * Active Directory
    		 * - 부서의 부서이동
    		 * */
    		if(ezCommonService.getTenantConfig("USE_AD", (Integer)map.get("v_TENANT_ID")).equalsIgnoreCase("YES")) {
    			DirContext ctx = conn.setConnection();
    			ezOrganAdminDao.moveDeptInAD(ctx, map, parentCn);
    		}
    	} else {
	    	ezOrganAdminDao.moveGroupUser_U(map);
	    	
	    	/**
	    	 * Active Directory
	    	 * - 유저의 부서 이동
	    	 * */
	    	if (ezCommonService.getTenantConfig("USE_AD", (Integer)map.get("v_TENANT_ID")).equalsIgnoreCase("YES")) {
	    		DirContext ctx = conn.setConnection();
	    		ezOrganAdminDao.moveUserInAD(ctx, map, parentCn);    	    		
	    	}
    	}
		
		logger.debug("moveDBData ended");
	}

	@Override
	public void setPassword(String cn, String password, int tenantID) throws Exception {
		String pwd = EgovFileScrty.encryptPassword(password, cn);
		
		LoginVO loginVO = new LoginVO();		
		loginVO.setId(cn);
		loginVO.setPassword(pwd);
		loginVO.setTenantId(tenantID);
		
		loginDAO.updatePassword(loginVO);
		
		if (ezCommonService.getTenantConfig("USE_AD", tenantID).equalsIgnoreCase("YES")) {
			DirContext ctx = conn.setConnection();
			// Active Direcrtory 사용자 비밀번호
			loginVO.setPassword(password);
			ezOrganAdminDao.changePasswordInAD(ctx, loginVO);
		}
	}
	
	@Override
	public void setPasswordExceptAD(String cn, String password, int tenantID) throws Exception {
		String pwd = EgovFileScrty.encryptPassword(password, cn);
		
		LoginVO loginVO = new LoginVO();		
		loginVO.setId(cn);
		loginVO.setPassword(pwd);
		loginVO.setTenantId(tenantID);
		
		loginDAO.updatePassword(loginVO);

	}	
	
	@Override
	public void setPasswordWithEmailSystem(String cn, String domain, String password, int tenantID) throws Exception {
		logger.debug("setPasswordWithEmailSystem started");
		logger.debug("cn=" + cn + ",domain=" + domain + ",tenantID=" + tenantID);
		
		String mailAddr = cn + "@" + domain;
		
		logger.debug("mailAddr=" + mailAddr);
		
		// 기존 이메일 계정의 Encrypt된 암호를 가져온다.
		String existingEncryptedPassword = ezEmailUserAdminService.getEncryptedUserPassword(mailAddr);
		
		if (existingEncryptedPassword != null) {
			// 이메일 계정의 암호를 새 암호로 설정한다.
			int rc = ezEmailUserAdminService.updateUserPassword(mailAddr, password);
			
			logger.debug("updateUserPassword rc=" + rc);
			
			if (rc == 0) { // updateUserPassword 성공													
				try {
					// 로컬 시스템에서 해당 User의 암호를 변경한다.
					setPassword(cn, password, tenantID);
					commonUtil.resetLoginFailAttempts(cn, tenantID);
				} catch (Exception e) { // Exception이 발생하면 취소 처리를 한다.
					ezEmailUserAdminService.updateUserPasswordWithEncryptedPassword(mailAddr, existingEncryptedPassword);
					
					throw e;
				}										
			} else {
				throw new Exception("setting the user '" + mailAddr + "' password failed.");
			}
		} else {
			throw new Exception("getting the user '" + mailAddr + "' encrypted password failed.");
		}		
		
		logger.debug("setPasswordWithEmailSystem ended");
	}
	
	@Override
	public void retireEntry(String cn, String domain, String adminPassword, int tenantID) throws Exception {
	    logger.debug("retireEntry started");
	    logger.debug("cn=" + cn + ",domain=" + domain + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		
		// 퇴직자의 암호를 현재 관리자의 암호와 동일하게 변경한다.
		// 이후 과정에서 에러가 발생했을 때 암호를 롤백할 방법이 없는 문제가 있다. 
		setPasswordWithEmailSystem(cn, domain, adminPassword, tenantID);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		
		map.put("nowDate", nowDate);
		
	    ezOrganAdminDao.retireDBData_I(map);
	    ezOrganAdminDao.retireDBData(map);
	    ezOrganAdminDao.retireDBData_D3(map);
	    
	    /**
	     * Active Directory
	     * - 퇴작자 처리
	     * */
	    if (ezCommonService.getTenantConfig("USE_AD", tenantID).equalsIgnoreCase("YES")) {
	    	DirContext ctx = conn.setConnection();
	    	ezOrganAdminDao.retireUserInAD(ctx, map);
	    }       
		
		logger.debug("retireEntry ended");
	}	

	@Override
	public int companyCheck(String cn, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("cn", cn);
		map.put("tenantID", tenantID);
		return ezOrganAdminDao.companyCheck(map);
	}

	// 지정된 부서 바로 아래에 위치한 자식 부서의 수를 반환한다.
	@Override
	public int companyChildCheck(String cn, int tenantID) throws Exception {
		return ezOrganAdminDao.companyChildCheck(cn, tenantID);
	}

	@Override
	public int userCheck(String cn, int tenantID) throws Exception {
		return ezOrganAdminDao.userCheck(cn, tenantID);
	}
	
	@Override
	public int getRetireListCount(int pPage, int pPageRow, int tenantID, String companyId) throws Exception {
	    logger.debug("getRetireListCount started");
	    logger.debug("pPage=" + pPage + ",pPageRow=" + pPageRow + ",tenantID=" + tenantID + ",companyId=" + companyId);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_PAGE", pPage);
		map.put("v_ROWPERPAGE", pPageRow);
		map.put("companyId", companyId);
		
		logger.debug("getRetireListCount ended");
		
		return ezOrganAdminDao.getRetireListCount(map);
	}

	@Override
	public int getPermissionListCount(String companyID, String type, String searchType, String searchValue, String strLang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TYPE", type);
		map.put("v_LANGDATA", strLang);
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		
		return ezOrganAdminDao.getPermissionListCount(map);
	}

	@Override
	public void insertDBData_company(String cn, String displayName,	String displayName2, String mailAddr,
					String parentCn, String ldapPath, String extensionAttribute15, String skipInitData,
					int tenantID, LoginVO userInfo) throws Exception {
	    logger.debug("insertDBData_company started");
	    logger.debug("cn=" + cn + ",displayName=" + displayName + ",displayName2=" + displayName2
	    		+ ",extensionAttribute15=" + extensionAttribute15 + ",skipInitData=" + skipInitData
	    		+ ",parentCn=" + parentCn + ",tenantID=" + tenantID);
	    
        if (displayName2 == null || displayName2.equals("")) {
            displayName2 = displayName;
        }
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_MAIL", mailAddr);
		map.put("v_PARENTCN", parentCn);
		map.put("v_LDAPPATH", ldapPath);		
		map.put("v_EXTENSIONATTRIBUTE15", extensionAttribute15);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		ezOrganAdminDao.insertDBData_company(map);
		
		if (!skipInitData.equals("YES")) {
			try {
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("tenantID", tenantID);
				map1.put("companyID", cn);
				map1.put("companyName", displayName);
				map1.put("companyName2", displayName2);
				map1.put("userID", userInfo.getId());
				map1.put("userName", userInfo.getName());
				map1.put("nowDate", nowDate);
				map1.put("portalUUID", UUID.randomUUID().toString());
				map1.put("topMenuKoUUID", UUID.randomUUID().toString());
				map1.put("topMenuJaUUID", UUID.randomUUID().toString());
				map1.put("topMenuEnUUID", UUID.randomUUID().toString());
				map1.put("topMenuKoSubUUID", UUID.randomUUID().toString());
				map1.put("topMenuJaSubUUID", UUID.randomUUID().toString());
				map1.put("topMenuEnSubUUID", UUID.randomUUID().toString());
				map1.put("topMenuKoSub2UUID", UUID.randomUUID().toString());
				map1.put("topMenuJaSub2UUID", UUID.randomUUID().toString());
				map1.put("topMenuEnSub2UUID", UUID.randomUUID().toString());
				map1.put("topMenuLogoKoUUID", UUID.randomUUID().toString());
				map1.put("topMenuLogoJaUUID", UUID.randomUUID().toString());
				map1.put("topMenuLogoEnUUID", UUID.randomUUID().toString());
				
				for (int i = 0; i < 112; i++) {
					map1.put("menuItemUUID"+String.valueOf(i), UUID.randomUUID().toString());
				}
				
				for (int i = 0; i < 19; i++) {
					map1.put("portalItemUID"+i, UUID.randomUUID().toString());
				}
				
				ezOrganAdminDao.insertCompanyInfo_I1(map1);
				ezOrganAdminDao.insertCompanyInfo_I2(map1);
				ezOrganAdminDao.insertCompanyInfo_I3(map1);
				ezOrganAdminDao.insertCompanyInfo_I4(map1);
				ezOrganAdminDao.insertCompanyInfo_I5(map1);
				ezOrganAdminDao.insertCompanyInfo_I6(map1);
				ezOrganAdminDao.insertCompanyInfo_I7(map1);
				ezOrganAdminDao.insertCompanyInfo_I8(map1);
				ezOrganAdminDao.insertCompanyInfo_I9(map1);
				ezOrganAdminDao.insertCompanyInfo_I10(map1);
				ezOrganAdminDao.insertCompanyInfo_I11(map1);
				ezOrganAdminDao.insertCompanyInfo_I12(map1);
				ezOrganAdminDao.insertCompanyInfo_I13(map1);
				ezOrganAdminDao.insertCompanyInfo_I14(map1);
				ezOrganAdminDao.insertCompanyInfo_I15(map1);
				ezOrganAdminDao.insertCompanyInfo_I16(map1);
				ezOrganAdminDao.insertCompanyInfo_I17(map1);
				ezOrganAdminDao.insertCompanyInfo_I18(map1);
				ezOrganAdminDao.insertCompanyInfo_I19(map1);
				
				ezOrganAdminDao.insertCompanyInfo_IKMS(map1);
				ezOrganAdminDao.insertCompanyInfo_IKMS2(map1);
				ezOrganAdminDao.insertCompanyInfo_IKMS3(map1);
				ezOrganAdminDao.insertCompanyInfo_IKMS4(map1);
				ezOrganAdminDao.insertCompanyInfo_IKMS5(map1);
				ezOrganAdminDao.insertCompanyInfo_IKMS6(map1);
				ezOrganAdminDao.insertCompanyInfo_IKMS7(map1);
				
				//회사등록시 근태설정(근태규율관리) 기본값 insert
				ezOrganAdminDao.insertCompanyInfo_I20(map1);
				map1.put("lang", userInfo.getLang());
				ezOrganAdminDao.insertCompanyInfo_I21(map1);
            // 로컬 등록이 실패하면 JMocha User Repository에 등록한 것을 삭제한다.
            } catch (Exception e) {
                e.printStackTrace();
                
                map.put("v_CLASS", "group");
                ezOrganAdminDao.deleteDBDataForJMocha(map);
                
                throw e;
            }			
		}
		
		logger.debug("insertDBData_company ended");
	}

	@Override
	public void updateDBData_company(String cn, String displayName, String displayName2, String mailAddr, int tenantID) throws Exception {
	    logger.debug("updateDBData_company started");
	    logger.debug("cn=" + cn + ",displayName=" + displayName + ",displayName2=" + displayName2 + ",mailAddr=" + mailAddr 
	            + ",tenantID=" + tenantID);
	    
        if (displayName2 == null || displayName2.equals("")) {
            displayName2 = displayName;
        }
		
        if (cn.equalsIgnoreCase("Top")) {
        	OrganDeptVO dept = ezOrganService.getDeptInfo(cn, "1", tenantID);
        	String curMailAddr = dept.getMail();
        	
        	logger.debug("Top curMailAddr=" + curMailAddr + ",new mailAddr=" + mailAddr);
        	
        	// 최상위 회사(Top)의 이메일 주소가 변경된 경우 새롭게 그룹 이메일 주소를 등록한다.
        	if (!curMailAddr.equals(mailAddr)) {
        		logger.debug("New Top Email Address");
        		
        		int atSignPos = curMailAddr.indexOf("@");
        		String curMailId = curMailAddr.substring(0, atSignPos);
        		String mailDomain = curMailAddr.substring(atSignPos + 1);
        		String newMailId = mailAddr.substring(0, mailAddr.indexOf("@"));
        		
        		// 현재 이메일 아이디가 Top이 아니라면 해당 그룹 이메일 주소를 제거한다.
        		if (!curMailId.equalsIgnoreCase("Top")) {
        			ezEmailUserAdminService.removeGroup(curMailAddr);
        		}
        		
        		// 새 이메일 아이디가 Top이 아니라면 해당 그룹 이메일 주소를 새롭게 등록하고
        		// 멤버로 Top@domain 이메일 주소를 등록한다.
        		if (!newMailId.equalsIgnoreCase("Top")) {
        			ezEmailUserAdminService.addGroup(mailAddr);
        			ezEmailUserAdminService.updateGroupAdd(mailAddr, "Top@" + mailDomain);
        		}        		
        	}
        }
        
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_MAIL", mailAddr);
        
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		ezOrganAdminDao.updateDBData_company(map);
			
		ezOrganAdminDao.updateUserCompanyDisplayName(map);
		ezOrganAdminDao.updateDeptCompanyDisplayName(map);
	
		OrganDeptVO vo = new OrganDeptVO();
		
		vo.setTenantId(tenantID);
		vo.setCn(cn);
		vo.setDisplayName(displayName);
		vo.setDisplayName2(displayName2);
		
		ezOrganAdminDao.updateUserDeptDisplayName(vo);
		
		map.put("v_BOARD_ID", 1);
		ezResourceAdminDAO.updateBoardName(map);
		
        logger.debug("updateDBData_company ended");
	}
	
	@Override
	public void insertDBData_dept(OrganDeptVO vo) throws Exception {
	    logger.debug("insertDBData_dept started");
	    logger.debug("tenantId=" + vo.getTenantId() + ",cn=" + vo.getCn() + ",displayName=" + vo.getDisplayName()
	            + ",displayName2=" + vo.getDisplayName2() + ",parentCn=" + vo.getParentCn());
	    
        if (vo.getDisplayName2() == null || vo.getDisplayName2().equals("")) {
            vo.setDisplayName2(vo.getDisplayName());
        }
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", vo.getTenantId());
		map.put("v_CN", vo.getCn());
		map.put("v_DISPLAYNAME", vo.getDisplayName());
		map.put("v_DISPLAYNAME2", vo.getDisplayName2());
		map.put("v_MAIL", vo.getMail());
		map.put("v_PARENTCN", vo.getParentCn());
		map.put("v_EXTATTR4", vo.getExtensionAttribute4() != null ? vo.getExtensionAttribute4() : "");
		map.put("v_EXTATTR5", vo.getExtensionAttribute5() != null ? vo.getExtensionAttribute5() : "");
		map.put("v_EXTATTR6", vo.getExtensionAttribute6() != null ? vo.getExtensionAttribute6() : "");
		map.put("v_EXTATTR8", vo.getExtensionAttribute8() != null ? vo.getExtensionAttribute8() : "");
		map.put("v_EXTATTR9", vo.getExtensionAttribute9() != null ? vo.getExtensionAttribute9() : "");
		map.put("v_EXTATTR10", vo.getExtensionAttribute10() != null ? vo.getExtensionAttribute10() : "");
		map.put("v_EXTATTR15", vo.getExtensionAttribute15() != null ? vo.getExtensionAttribute15() : "");	
		map.put("v_EXTATTR11", vo.getExtensionAttribute11() != null ? vo.getExtensionAttribute11() : "");
		map.put("v_LDAPPATH", "");
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		ezOrganAdminDao.insertDBData_dept(map);
		
		logger.debug("insertDBData_dept ended");
	}
	
	@Override
	public void insertDBData_user(OrganUserVO vo, String oriPass) throws Exception {
        logger.debug("insertDBData_user started");
        logger.debug("tenantId=" + vo.getTenantId() + ",cn=" + vo.getCn() + ",displayName=" + vo.getDisplayName()
                + ",displayName2=" + vo.getDisplayName2() + ",parentCn=" + vo.getParentCn());
	    
        if (vo.getDisplayName2() == null || vo.getDisplayName2().equals("")) {
            vo.setDisplayName2(vo.getDisplayName());
        }

        if (vo.getTitle2() == null || vo.getTitle2().equals("")) {
            vo.setTitle2(vo.getTitle());
        }

        if (vo.getExtensionAttribute102() == null || vo.getExtensionAttribute102().equals("")) {
            vo.setExtensionAttribute102(vo.getExtensionAttribute10());
        }
        
		Map<String, Object> map = new HashMap<String, Object>();
		        
        map.put("v_TENANT_ID", vo.getTenantId());		
		map.put("v_CN", vo.getCn());
		map.put("v_DISPLAYNAME", vo.getDisplayName());
		map.put("v_DISPLAYNAME2", vo.getDisplayName2());
		map.put("v_MAIL", vo.getMail());
		map.put("v_MAILNICKNAME", vo.getMailNickName() != null ? vo.getMailNickName() : "");
		map.put("v_UPNNAME", vo.getUpnName());
		map.put("v_PARENTCN", vo.getParentCn());
		map.put("v_TITLE", vo.getTitle() != null ? vo.getTitle() : "");
		map.put("v_TITLE2", vo.getTitle2() != null ? vo.getTitle2() : "");
		map.put("v_TELEPHONE", vo.getTelephoneNumber() != null ? vo.getTelephoneNumber() : "");
		map.put("v_HOMEPHONE", vo.getHomePhone() != null ? vo.getHomePhone() : "");
		map.put("v_FAX", vo.getFacsimileTelephoneNumber() != null ? vo.getFacsimileTelephoneNumber() : "");
		map.put("v_MOBILE", vo.getMobile() != null ? vo.getMobile() : "");
		map.put("v_POSTALCODE", vo.getPostalCode() != null ? vo.getPostalCode() : "");
		map.put("v_ADDRESS", vo.getStreetAddress() != null ? vo.getStreetAddress() : "");
		
		if (vo.getExtensionAttribute1() == null || vo.getExtensionAttribute1().equals("")) {
			map.put("v_EXTATTR1", "c=0;k=0;g=0;a=0;i=0;n=0;l=0;w=0;m=0;");
		} else {
			map.put("v_EXTATTR1", vo.getExtensionAttribute1());
			
		}
		
		map.put("v_EXTATTR6", vo.getExtensionAttribute6() != null ? vo.getExtensionAttribute6() : "");
		map.put("v_EXTATTR10", vo.getExtensionAttribute10() != null ? vo.getExtensionAttribute10() : "");
		map.put("v_EXTATTR102", vo.getExtensionAttribute102() != null ? vo.getExtensionAttribute102() : "");
		map.put("v_EXTATTR14", vo.getExtensionAttribute14() != null ? vo.getExtensionAttribute14() : "");
		map.put("v_EXTATTR15", vo.getExtensionAttribute15() != null ? vo.getExtensionAttribute15() : "");
		
		// 코린도에서 extensionAttribute11 필드를 한국인, 현지인 구분에 사용하여 추가함
		map.put("v_EXTATTR11", vo.getExtensionAttribute11() != null ? vo.getExtensionAttribute11() : "");
		
		map.put("v_LDAPPATH", "");
		map.put("v_BIRTH", vo.getBirth() != null ? vo.getBirth() : "");		
		map.put("v_BIRTHTYPE", vo.getBirthType() != null ? vo.getBirthType() : "");
		map.put("v_PASS", vo.getPassword());
		map.put("v_INSERTADPASS", oriPass);
				
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		ezOrganAdminDao.insertDBData_user(map);
				
		logger.debug("insertDBData_user ended");
	}

    @Override
    public void updateDBData_user(OrganUserVO vo) throws Exception {
        logger.debug("updateDBData_user started");
        logger.debug("tenantId=" + vo.getTenantId() + ",cn=" + vo.getCn() + ",displayName=" + vo.getDisplayName()
                + ",displayName2=" + vo.getDisplayName2() + ",parentCn=" + vo.getParentCn());
                
        if (vo.getDisplayName2() == null || vo.getDisplayName2().equals("")) {
            vo.setDisplayName2(vo.getDisplayName());
        }

        if (vo.getTitle2() == null || vo.getTitle2().equals("")) {
            vo.setTitle2(vo.getTitle());
        }

        if (vo.getExtensionAttribute102() == null || vo.getExtensionAttribute102().equals("")) {
            vo.setExtensionAttribute102(vo.getExtensionAttribute10());
        }
        
        ezOrganAdminDao.updateDBData_user(vo);
        
        logger.debug("updateDBData_user ended");
    }   
	
	@Override
    public void updateDBData_userPermission(OrganUserVO vo) throws Exception {
        logger.debug("updateDBData_userPermission started");
        logger.debug("tenantId=" + vo.getTenantId() + ",cn=" + vo.getCn());
                        
        ezOrganAdminDao.updateDBData_userPermission(vo);
        
        logger.debug("updateDBData_userPermission ended");
    }   
    
	@Override
	public void updateDBData_dept(OrganDeptVO vo) throws Exception {
	    logger.debug("updateDBData_dept started");
        logger.debug("tenantId=" + vo.getTenantId() + ",cn=" + vo.getCn() + ",displayName=" + vo.getDisplayName()
        + ",displayName2=" + vo.getDisplayName2() + ",parentCn=" + vo.getParentCn());	    
	    
        if (vo.getDisplayName2() == null || vo.getDisplayName2().equals("")) {
            vo.setDisplayName2(vo.getDisplayName());
        }
        
		ezOrganAdminDao.updateDBData_dept(vo);
		
		ezOrganAdminDao.updateUserDeptDisplayName(vo);
		
		/**
		 * Active Directory
		 * - 부서 정보 수정
		 * */
		if (ezCommonService.getTenantConfig("USE_AD", vo.getTenantId()).equalsIgnoreCase("YES")) {
			DirContext ctx = conn.setConnection();
			ezOrganAdminDao.updateDeptInAD(ctx, vo);				
		}
		
		logger.debug("updateDBData_dept ended");
	}

	@Override
	public void deleteDBData(String cn, String pClass, int tenantID) throws Exception {
	    logger.debug("deleteDBData started.");
	    logger.debug("cn=" + cn + ",pClass=" + pClass + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
        map.put("v_TENANT_ID", tenantID);		
		map.put("v_CN", cn);
		map.put("v_CLASS", pClass);
		
	    if (pClass.toLowerCase().equals("group")) {
	        ezOrganAdminDao.deleteDBData(map);
	        
	        //회사 삭제시 넣었던 초기데이터 테이블 삭제
	        ezOrganAdminDao.deleteCompany_D1(map);
	        ezOrganAdminDao.deleteCompany_D2(map);
	        ezOrganAdminDao.deleteCompany_D3(map);
	        ezOrganAdminDao.deleteCompany_D4(map);
	        ezOrganAdminDao.deleteCompany_D5(map);
	        ezOrganAdminDao.deleteCompany_D6(map);
	        ezOrganAdminDao.deleteCompany_D7(map);
	        ezOrganAdminDao.deleteCompany_D8(map);
	        ezOrganAdminDao.deleteCompany_D9(map);
	        ezOrganAdminDao.deleteCompany_D10(map);
	        ezOrganAdminDao.deleteCompany_D11(map);
	        ezOrganAdminDao.deleteCompany_D12(map);
	        ezOrganAdminDao.deleteCompany_D13(map);
	        ezOrganAdminDao.deleteCompany_D14(map);
	        ezOrganAdminDao.deleteCompany_D15(map);
	        ezOrganAdminDao.deleteCompany_D16(map);
	        ezOrganAdminDao.deleteCompany_D17(map);
	        ezOrganAdminDao.deleteCompany_D18(map);
	        ezOrganAdminDao.deleteCompany_D19(map);
	        ezOrganAdminDao.deleteCompany_D20(map);
	        ezOrganAdminDao.deleteCompanyInfo_IKMS7(map);
	        
		    /**
		     * Active Directory
		     * - 부서 정보 삭제
		     * */
		    if (ezCommonService.getTenantConfig("USE_AD", tenantID).equalsIgnoreCase("YES")) {
		    	DirContext ctx = conn.setConnection();
		    	ezOrganAdminDao.deleteDeptInAD(ctx, cn);
		    }			        
	    } else {
	    	//삭제 테이블에 중복된 아이디를 제거하기 위헤 제거부터 수행. 2018-06-04 홍대표
	    	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			date.setTimeZone(TimeZone.getTimeZone("GMT"));
			String nowDate = date.format(new Date());
			
			map.put("nowDate", nowDate);
	    	ezOrganAdminDao.deleteDelUserDBData_I(map);
	    	//사용자를 삭제 할 때, 대상의 정보를 저장한다. 2018-06-04 홍대표
	    	ezOrganAdminDao.insertDelUserDBData_I(map);
	    	
	        ezOrganAdminDao.deleteDBDataForJMocha(map);
     
	        ezOrganAdminDao.deleteDBData_D1(map);
	        ezOrganAdminDao.deleteDBData_D4(map);
	        ezOrganAdminDao.deleteDBData_D5(map);
	        
		    /**
		     * Active Directory
		     * - 유저 정보 삭제
		     * */
		    if (ezCommonService.getTenantConfig("USE_AD", tenantID).equalsIgnoreCase("YES")) {
		    	DirContext ctx = conn.setConnection();
		    	ezOrganAdminDao.deleteUserInAD(ctx, cn);
		    }		        
	    }
		
		logger.debug("deleteDBData ended.");
	}

	@Override
	public OrganUserVO getUserInfo(String cn, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		
		map.put("v_TENANT_ID", tenantID);		
		map.put("v_CN", cn);
		map.put("v_LANGDATA", lang);
		
	    // Proxy User인 지 여부를 확인한다.
		String temp = ezOrganAdminDao.getUserInfo_S1(map);
		
		// Proxy User인 경우 a=1 권한을 추가하여 반환한다.
		if (temp != null && temp.equals("1")) {
			return ezOrganAdminDao.getUserInfo(map);
		// Proxy User가 아닌 경우엔 있는 그대로의 속성값을 반환한다.	
		} else {
			return ezOrganAdminDao.getUserInfo_S2(map);
		}
	}
	
	@Override
	public OrganUserVO getRetireEntryInfo(String cn, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_LANGDATA", lang);
		
		return ezOrganAdminDao.getRetireEntryInfo(map);
	}

	@Override
	public void addJob(String userID, String titleInfo, int tenantID) throws Exception {
	    logger.debug("addJob started");
	    logger.debug("userID=" + userID + ",titleInfo=" + titleInfo + ",tenantID=" + tenantID);
	    
		String sTitle1 = "";
        String sTitle2 = "";
        String pDeptID = "";
        
        if (!titleInfo.equals("")) {
            String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
            
        	String[] addJobinfo = titleInfo.split(";");
        	
            for (int i = 0; i < addJobinfo.length; i++) {
            	String[] userInfo = addJobinfo[i].split(":");
            	pDeptID = userInfo[0];
            	            	
            	if (userInfo.length > 1) {
            		sTitle1 = userInfo[1];
            	}
                
                sTitle2 = "";
                
                if (userInfo.length > 2) {
                    sTitle2 = userInfo[2];
                } else {
                    sTitle2 = sTitle1;
                }
                
                // 해당 User가 겸직할 부서의 Group Email 주소에 User를 등록한다.                  
                String groupAddr = pDeptID + "@" + domain;
                String mailAddr = userID + "@" + domain;
                int rc = ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
                
                logger.debug("updateGroupAdd rc=" + rc);
                
                if (rc == 0) { // updateGroup 성공
                    Map<String, Object> map = new HashMap<String, Object>();		
            		
                    map.put("v_TENANT_ID", tenantID);
            		map.put("v_CN", userID);
            		map.put("v_DEPTID", pDeptID);
            		map.put("v_TITLE1", sTitle1);
            		map.put("v_TITLE2", sTitle2);
                    
            		String bizmekaResult = "ERROR";
            		
            		try {
    					String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
    					
    					// 비즈메카와 연동된 경우에는 비즈메카 API를 이용해 비즈메카 사용자 계정을 삭제한다.
    					if (useBizmekaSpambox.equals("YES")) {
    						String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
    						String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
    						String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
    						
    						bizmekaResult = ezEmailUtil.bizmekaAddSubtitle(bizmekaAdminId, bizmekaAdminPw,
    											bizmekaCompanyId, userID, pDeptID, sTitle1, sTitle2);	
    						
    						logger.debug("bizmekaResult=" + bizmekaResult);
    						
    						if (!bizmekaResult.equals("OK")) {
    							throw new Exception("bizmekaAddSubtitle failed");
    						}						
    					}
    					
        				if ((pDeptID != null && !pDeptID.equals("")) || (sTitle1 != null && !sTitle1.equals(""))) {
        					ezOrganAdminDao.setAddJob_I(map);
        				}       
            		} catch (Exception e) { // Exception이 발생하면 Group Email 주소로부터 취소 처리를 한다.
            		    ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
            		}
                } else {
                	throw new Exception("Adding the user '" + mailAddr + "' to the specified group email '" + groupAddr + "' failed.");
                }
            }
        }
        
        logger.debug("addJob ended");
	}

    @Override
    public void deleteJob(String userID, String titleInfo, int tenantID) throws Exception {
        logger.debug("deleteJob started");
        logger.debug("userID=" + userID + ",titleInfo=" + titleInfo + ",tenantID=" + tenantID);
        
        String pDeptID = "";
        
        if (!titleInfo.equals("")) {
            String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
            
            String[] addJobinfo = titleInfo.split(";");
            
            for (int i = 0; i < addJobinfo.length; i++) {
                String[] userInfo = addJobinfo[i].split(":");
                pDeptID = userInfo[0];
                
                // 겸직 부서의 Group Email 주소로부터 해당 User를 제거한다.                  
                String groupAddr = pDeptID + "@" + domain;
                String mailAddr = userID + "@" + domain;
                
                int rc = ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
                
                logger.debug("updateGroupDel rc=" + rc);
                
                if (rc != -100) { // updateGroupDel 성공(부모그룹이나 자식 주소를 찾지 못해도 성공으로 봄. 어차피 삭제하려는 것이므로.)
                    Map<String, Object> map = new HashMap<String, Object>();        
                    
                    map.put("v_TENANT_ID", tenantID);
                    map.put("v_CN", userID);
                    map.put("v_DEPTID", pDeptID);
                    
                    String bizmekaResult = "ERROR";
                    
                    try {
    					String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
    					
    					// 비즈메카와 연동된 경우에는 비즈메카 API를 이용해 비즈메카 사용자 계정을 삭제한다.
    					if (useBizmekaSpambox.equals("YES")) {
    						String bizmekaAdminId = ezCommonService.getTenantConfig("bizmekaAdminId", tenantID);
    						String bizmekaAdminPw = ezCommonService.getTenantConfig("bizmekaAdminPw", tenantID);
    						String bizmekaCompanyId = ezCommonService.getTenantConfig("BizmekaCompanyId", tenantID);
    						
    						bizmekaResult = ezEmailUtil.bizmekaDeleteSubtitle(bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, userID, pDeptID);		
    						
    						logger.debug("bizmekaResult=" + bizmekaResult);
    						
    						if (!bizmekaResult.equals("OK")) {
    							throw new Exception("bizmekaDeleteSubtitle failed");
    						}						
    					}
                    	
                        ezOrganAdminDao.deleteAddJob(map);   
                    } catch (Exception e) { // Exception이 발생하면 Group Email 주소에 해당 User를 다시 등록한다.
                        ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
                    }                    
                }
            }
        }       
        
        logger.debug("deleteJob ended");
    }
    
	@Override
	public void restoreRetireEntry(String cn, String deptID, int tenantID) throws Exception {
	    logger.debug("restoreRetireEntry started");
	    logger.debug("cn=" + cn + ",deptID=" + deptID + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();		
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	    date.setTimeZone(TimeZone.getTimeZone("GMT"));
	    String nowDate = date.format(new Date()); 
		
		map.put("nowDate", nowDate);
	    map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_PARENTCN", deptID);
		map.put("temp", "");
		
    	ezOrganAdminDao.restoreRetireEntry(map);
    	ezOrganAdminDao.restoreRetireEntry_D(map);  
		
		logger.debug("restoreRetireEntry ended");		
	}

	// 지정된 부서에 속한 사원의 수를 반환한다.
	@Override
	public int userCountCheck(String cn, int tenantID) throws Exception {
		return ezOrganAdminDao.userCountCheck(cn, tenantID);
	}
	
	/**
	 * 그룹웨어 계정으로 비즈메카톡 계정을 동기화한다.
	 */
	@Override
	public void syncWithBizmekaTalkAccounts(int tenantID) throws Exception {
		ezOrganAdminDao.syncWithBizmekaTalkAccounts(tenantID);
	}
	
	// 사용자 이름,부서 목록을 반환한다.
    @Override
    public List<OrganUserVO> getUserList(int tenantID,int startPage, int maxItemPerPage,
    									 String keycode,String keyword,String companyId) throws Exception {     
    	logger.debug("getUserList started");
    	
    	Map<String, Object> params = new HashMap<String, Object>();
    	
    	params.put("tenantID", tenantID);
		params.put("v_start", startPage);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("companyId", companyId);
		
    	List<OrganUserVO> list = ezOrganAdminDao.getUserList(params);
    	
    	logger.debug("getUserList ended");
    	
    	return list;
    }

    // 사용자 이름,부서 목록개수를 반환한다.
    @Override
    public int getUserCount(int tenantID, String keycode,String keyword,String companyId) throws Exception {     
    	logger.debug("getUserCount started");
    	
    	Map<String, Object> params = new HashMap<String, Object>();
    	
    	params.put("tenantID", tenantID);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("companyId", companyId);
		
		int userCount = ezOrganAdminDao.getUserCount(params);
		
		logger.debug("getUserCount ended. userCount=" + userCount);
    	
		return userCount;
    }	
    
	@Override
	public String mailAddDistributionList(String domain, String job, String job2, String companyId, int tenantID, String cn) throws Exception {
		logger.debug("mailAddDistributionList started.");
		logger.debug("domain=" + domain + ",job=" + job + ",job2=" + job2 + ",companyId=" + companyId + ",tenantID=" + tenantID + ",cn=" + cn);
		
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
		String result = "ERROR";
		String bizmekaResult = "ERROR";
		int reasonCode = -100;
		List<String> memberList = null;
		
		if (useBizmekaSpambox.equals("YES")) {
			String bizmekaAdminId = ezCommonService.getTenantConfig
					("bizmekaAdminId", tenantID);
			String bizmekaAdminPw = ezCommonService.getTenantConfig
					("bizmekaAdminPw", tenantID);
			String bizmekaCompanyId = ezCommonService.getTenantConfig
					("BizmekaCompanyId", tenantID);
			
			bizmekaResult = ezEmailUtil.bizmekaAddDistributionList(
					bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId,
					job2, job, memberList);

			logger.debug("bizmekaResult=" + bizmekaResult);

			if (!bizmekaResult.equals("OK")) {
				throw new Exception("bizmekaAddDistributionList failed");
			}
		}
		
		String inputParams = "companyId="
				 + URLEncoder.encode(companyId, "UTF-8") + "&name="
				 + URLEncoder.encode(job, "UTF-8") + "&id="
				 + URLEncoder.encode(job2, "UTF-8") + "&domain="
				 + URLEncoder.encode(domain, "UTF-8") + "&memberId="
				 + URLEncoder.encode(cn, "UTF-8");
		 
		logger.debug("inputParams=" + inputParams);
			 
		String requestURL = config.getProperty("config.JGwServerURL")
					 + "/jMochaAccess/setDistributionList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
			 
		logger.debug("response=" + response);
			 
		if (response != null) {
			 JSONParser jsonParser = new JSONParser();
			 JSONObject responseObj = (JSONObject) jsonParser.parse(response);
			 String resultCode = (String) responseObj.get("resultCode");
			 if (resultCode.equals("OK")) {	
					reasonCode = ((Long) responseObj.get("reasonCode"))
							.intValue();
				}
		 }
			 
		if (reasonCode == 0) {
			result = "OK";
		} else if (reasonCode == -1) {
				result = "GROUP_NAME";
		} else if (reasonCode == -2) {
				result = "GROUP_ID";
		}
			 
		logger.debug("result= " + result);
		logger.debug("mailAddDistributionList ended.");
		
		return result;
	}

	@Override
	public String mailUpdateDistributionList(String domain, String job, String job2, String companyId, int tenantID,
			String memberId) throws Exception {
		logger.debug("mailUpdateDistributionList started.");
		logger.debug("domain=" + domain + ",job=" + job + ",job2=" + job2 + ",companyId=" + companyId + ",tenantID=" + tenantID + ",memberId=" + memberId);
		
		String useBizmekaSpambox = ezCommonService.getTenantConfig("UseBizmekaSpambox", tenantID);
		String bizmekaResult = "ERROR";
		String result = "ERROR";
		List<String> memberList = new ArrayList<String>();
		int reasonCode = -100;
		String inputParams = "";
		String requestURL = "" ;
		String response = "" ;
		String[] arrAddress = null;
		
		inputParams = "userName="
			+ URLEncoder.encode(job2, "UTF-8") + "&domainName="
			+ URLEncoder.encode(domain, "UTF-8");
		
		logger.debug("inputParams=" + inputParams);

		 requestURL = config.getProperty("config.JGwServerURL")
			+ "/jMochaAccess/getTargetAddress";
		 response = ezEmailUtil.getWebServiceResult(requestURL,
				inputParams);
		
		 logger.debug("response=" + response);
		 
		if (response != null) {
			int isUser = -1;
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);
			String targetAddress = (String) responseObj.get("targetAddress");
			String resultCode = (String) responseObj.get("resultCode");
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long) responseObj.get("reasonCode"))
						.intValue();
				
				if (reasonCode == 0) {
					if (!targetAddress.equals("")) {
						arrAddress = targetAddress.split(";");
						
						for (int i = 0 ; i < arrAddress.length ; i++) {
							int idx = arrAddress[i].indexOf("@");
							memberList.add(arrAddress[i].substring(0, idx));
						}
						
						for (int i = 0; i < memberList.size() ; i++) {
							if (memberList.get(i).equals(memberId)) {
								isUser = 1;
							} else {
								isUser = -1;
							}
						}
						
						if (isUser == -1 && !memberId.equals("")) {
							memberList.add(memberId);
						}
					} 
				}
			}
		} 
		
		logger.debug("meberId=" + memberList.toString());
		
		if (useBizmekaSpambox.equals("YES")) {
			String bizmekaAdminId = ezCommonService.getTenantConfig(
					"bizmekaAdminId", tenantID);
			String bizmekaAdminPw = ezCommonService.getTenantConfig(
					"bizmekaAdminPw", tenantID);
			String bizmekaCompanyId = ezCommonService.getTenantConfig(
					"BizmekaCompanyId", tenantID);
			
			
			bizmekaResult = ezEmailUtil.bizmekaEditDistributionList(
					bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId,
					job2, job, memberList);

			logger.debug("bizmekaResult=" + bizmekaResult);

			if (!bizmekaResult.equals("OK")) {
				throw new Exception(
						"bizmekaEditDistributionList failed");
			}
		}

		 inputParams = "companyId="
				+ URLEncoder.encode(companyId, "UTF-8") + "&cn="
				+ URLEncoder.encode(job2, "UTF-8") + "&name="
				+ URLEncoder.encode(job, "UTF-8") + "&id="
				+ URLEncoder.encode(job2, "UTF-8") + "&domain="
				+ URLEncoder.encode(domain, "UTF-8");
		 
		for (int i = 0; i < memberList.size(); i++) {
			inputParams += "&memberId="
					+ URLEncoder.encode(memberList.get(i), "UTF-8");
		}
		
		logger.debug("inputParams=" + inputParams);

		requestURL = config.getProperty("config.JGwServerURL")
			+ "/jMochaAccess/updateDistributionList";
		response = ezEmailUtil.getWebServiceResult(requestURL,
			inputParams);

		logger.debug("response=" + response);

		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser
					.parse(response);

			String resultCode = (String) responseObj.get("resultCode");
			if (resultCode.equals("OK")) {
				reasonCode = ((Long) responseObj.get("reasonCode"))
						.intValue();
			}
		}
		
		if (reasonCode == 0) {
			result = "OK";
		} else if (reasonCode == -1) {
			result = "GROUP_NAME";
		} else if (reasonCode == -2) {
			result = "GROUP_ID";
		}
		
		logger.debug("result=" + result);
		logger.debug("mailUpdateDistributionList ended.");
		
		return result;
	}

	@Override
	public String getDistributionUserName (int tenantID,  String groupName) throws Exception {
		logger.debug("getDistributionUserName started.");
		logger.debug("tenantId=" + tenantID + ",groupName=" + groupName);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		
		String inputParams = "domainName=" + URLEncoder.encode(domain, "UTF-8") 
				+"&groupName=" + URLEncoder.encode(groupName, "UTF-8");
		
		logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL") + "/jMochaAccess/getDistributionUserName";			
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams);
		
		logger.debug("response=" + response);

		String resultCode = "Error";
		int reasonCode = -100;
		String userName = "";
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject)jsonParser.parse(response);

			resultCode = (String)responseObj.get("resultCode");		
			
			if (resultCode.equals("OK")) {
				reasonCode = ((Long)responseObj.get("reasonCode")).intValue();
				
				if (reasonCode == 0) {
					userName = (String) responseObj.get("userName");
				}
			}
		}

		logger.debug("resultCode=" + resultCode + ",reasonCode=" + reasonCode + ",userName=" + userName);
		logger.debug("getDistributionUserName ended.");

		return userName;
	}
	@Override
	public String mailDelDistributionList (int tenantID ,String cn) throws  Exception{
		logger.debug("mailDelDistributionList started.");
		logger.debug("tenantId=" + tenantID + ",cn=" + cn);
		
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);

		String result = "ERROR";
		String bizmekaResult = "ERROR";

		try {
			String useBizmekaSpambox = ezCommonService.getTenantConfig(
					"UseBizmekaSpambox", tenantID);

			if (useBizmekaSpambox.equals("YES")) {
				String bizmekaAdminId = ezCommonService.getTenantConfig(
						"bizmekaAdminId", tenantID);
				String bizmekaAdminPw = ezCommonService.getTenantConfig(
						"bizmekaAdminPw", tenantID);
				String bizmekaCompanyId = ezCommonService.getTenantConfig(
						"BizmekaCompanyId", tenantID);

				bizmekaResult = ezEmailUtil.bizmekaDeleteDistributionList(
						bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId, cn);

				logger.debug("bizmekaResult=" + bizmekaResult);

				if (!bizmekaResult.equals("OK")) {
					throw new Exception("bizmekaDeleteDistributionList failed");
				}
			}

			String inputParams = "cn=" + URLEncoder.encode(cn, "UTF-8")
					+ "&domain=" + URLEncoder.encode(domain, "UTF-8");

			logger.debug("inputParams=" + inputParams);

			String requestURL = config.getProperty("config.JGwServerURL")
					+ "/jMochaAccess/deleteDistribution";
			String response = ezEmailUtil.getWebServiceResult(requestURL,
					inputParams);

			logger.debug("response=" + response);

			if (response != null) {
				JSONParser jsonParser = new JSONParser();
				JSONObject responseObj = (JSONObject) jsonParser
						.parse(response);

				result = (String) responseObj.get("resultCode");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		logger.debug("result=" + result);
		logger.debug("mailDelDistributionList ended.");

		return result;
	}

	@Override
	public String deleteTargetAddressUser(int tenantID, String groupName, String memberID, String companyID) throws Exception {
		logger.debug("deleteTargetAddressUser started.");
		logger.debug("tenantID=" + tenantID + ",groupName=" + groupName);

		String userName = getDistributionUserName(tenantID, groupName);
		String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
		String useBizmekaSpambox = ezCommonService.getTenantConfig(
				"UseBizmekaSpambox", tenantID);
		
		String inputParams = "userName="
				+ URLEncoder.encode(userName, "UTF-8") + "&domainName="
				+ URLEncoder.encode(domain, "UTF-8");
			
			logger.debug("inputParams=" + inputParams);

		String requestURL = config.getProperty("config.JGwServerURL")
				+ "/jMochaAccess/getTargetAddress";
		String response = ezEmailUtil.getWebServiceResult(requestURL,
					inputParams);
		List<String> memberList = null; 	
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject resopnseObj = (JSONObject) jsonParser.parse(response);
			String targetAddress = (String) resopnseObj.get("targetAddress");
			
			if (!targetAddress.equals("")) {
				String[] arrAddress = targetAddress.split(";");
				memberList = new ArrayList<String>();
				
				for (int i = 0 ; i < arrAddress.length ; i++) {
					if (!arrAddress[i].equals(memberID + "@" + domain)) {
						memberList.add(arrAddress[i]); //기존 공용배포그룹에 추가하는 유저
					}
				}
			} 
		} 
		
		if (useBizmekaSpambox.equals("YES")) {
			String bizmekaAdminId = ezCommonService.getTenantConfig(
					"bizmekaAdminId", tenantID);
			String bizmekaAdminPw = ezCommonService.getTenantConfig(
					"bizmekaAdminPw", tenantID);
			String bizmekaCompanyId = ezCommonService.getTenantConfig(
					"BizmekaCompanyId", tenantID);
			
			
			String bizmekaResult = ezEmailUtil.bizmekaEditDistributionList(
					bizmekaAdminId, bizmekaAdminPw, bizmekaCompanyId,
					userName, groupName, memberList);

			logger.debug("bizmekaResult=" + bizmekaResult);

			if (!bizmekaResult.equals("OK")) {
				throw new Exception(
						"bizmekaEditDistributionList failed");
			}
		}

		 inputParams = "companyId="
				+ URLEncoder.encode(companyID, "UTF-8") + "&cn="
				+ URLEncoder.encode(userName, "UTF-8") + "&name="
				+ URLEncoder.encode(groupName, "UTF-8") + "&id="
				+ URLEncoder.encode(userName, "UTF-8") + "&domain="
				+ URLEncoder.encode(domain, "UTF-8");
		 
		for (int i = 0; i < memberList.size(); i++) {
			inputParams += "&memberId="
					+ URLEncoder.encode(memberList.get(i), "UTF-8");
		}
		
		logger.debug("inputParams=" + inputParams);

		requestURL = config.getProperty("config.JGwServerURL")
			+ "/jMochaAccess/updateDistributionList";
		response = ezEmailUtil.getWebServiceResult(requestURL,
			inputParams);

		logger.debug("response=" + response);

		
		int reasonCode = -100;
		String result = "";
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser
					.parse(response);

			String resultCode = (String) responseObj.get("resultCode");
			if (resultCode.equals("OK")) {
				reasonCode  = ((Long) responseObj.get("reasonCode"))
						.intValue();
			}
		}
		
		if (reasonCode == 0) {
			result = "OK";
		} else if (reasonCode == -1) {
			result = "GROUP_NAME";
		} else if (reasonCode == -2) {
			result = "GROUP_ID";
		}	
			
		logger.debug("result=" + result);
		logger.debug("deleteTargetAddressUser ended.");
		
		return result;
	}
}
