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

import org.json.simple.JSONArray;
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
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
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
	private Properties config;
	
	@Autowired	
	private CommonUtil commonUtil;
	
    @Autowired
    private EzCommonService ezCommonService;	
	
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
	public List<OrganUserVO> getPermissionList(String companyID, String type, String strLang, int startRow, int endRow, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TYPE", type);
		map.put("v_LANGDATA", strLang);
		map.put("v_PSTARTROW", startRow);
		map.put("v_PENDROW", endRow);
        map.put("v_STARTNUM", startRow - 1);
        map.put("v_COUNT", endRow - startRow + 1);
		
		return ezOrganAdminDao.getPermissionList(map);
	}

	@Override
	public List<OrganUserVO> getRetireList(int pPage, int pPageRow, int tenantID)	throws Exception {
        logger.debug("getRetireList started");
        logger.debug("pPage=" + pPage + ",pPageRow=" + pPageRow + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_PAGE", pPage);
		map.put("v_ROWPERPAGE", pPageRow);
		map.put("v_STARTROW", pPageRow*(pPage - 1));
				
		List<OrganUserVO> retireList = ezOrganAdminDao.getRetireList(map);
		
        logger.debug("getRetireList ended");
		
		return retireList;
	}

    @Override
    public List<OrganUserVO> getUserCnList(int tenantID) throws Exception {     
        return ezOrganAdminDao.getUserCnList(tenantID);
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
		
		if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
			ezOrganAdminDao.updateProperty(map);
	    } else {
	        // 사원의 경우
	    	if (pClass.toLowerCase().equals("user")) {
	    		ezOrganAdminDao.updateProperty(map);
	    	// 부서의 경우
	    	} else {
	    		ezOrganAdminDao.updateProperty_U(map);
	    	}
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
		
		if (config.getProperty("config.IsJMochaStandAlone").equals("YES")) {
			ezOrganAdminDao.moveDBData(map);
        } else {
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
        	} else {
    	    	ezOrganAdminDao.moveGroupUser_U(map);
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
	}
	
	@Override
	public void retireEntry(String cn, int tenantID) throws Exception {
	    logger.debug("retireEntry started");
	    logger.debug("cn=" + cn + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		
		map.put("nowDate", nowDate);
		
		if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
		    ezOrganAdminDao.retireDBData(map);
		} else {
		    ezOrganAdminDao.retireDBData_I(map);
		    ezOrganAdminDao.retireDBData(map);
		    ezOrganAdminDao.retireDBData_D3(map);
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
	public int getRetireListCount(int pPage, int pPageRow, int tenantID) throws Exception {
	    logger.debug("getRetireListCount started");
	    logger.debug("pPage=" + pPage + ",pPageRow=" + pPageRow + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_PAGE", pPage);
		map.put("v_ROWPERPAGE", pPageRow);
		
		logger.debug("getRetireListCount ended");
		
		return ezOrganAdminDao.getRetireListCount(map);
	}

	@Override
	public int getPermissionListCount(String companyID, String type, String strLang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TYPE", type);
		map.put("v_LANGDATA", strLang);
		
		return ezOrganAdminDao.getPermissionListCount(map);
	}

	@Override
	public void insertDBData_company(String cn, String displayName,	String displayName2, String mailAddr, String parentCn, String ldapPath, int tenantID) throws Exception {
	    logger.debug("insertDBData_company started");
	    logger.debug("cn=" + cn + ",displayName=" + displayName + ",displayName2=" + displayName2 
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
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		ezOrganAdminDao.insertDBData_company(map);
		
		logger.debug("insertDBData_company ended");
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
		map.put("v_EXTATTR4", vo.getExtensionAttribute4());
		map.put("v_EXTATTR5", vo.getExtensionAttribute5());
		map.put("v_EXTATTR6", vo.getExtensionAttribute6());
		map.put("v_EXTATTR8", vo.getExtensionAttribute8());
		map.put("v_EXTATTR9", vo.getExtensionAttribute9());
		map.put("v_EXTATTR10", vo.getExtensionAttribute10());
		map.put("v_EXTATTR15", vo.getExtensionAttribute15());		
		map.put("v_LDAPPATH", "");
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		ezOrganAdminDao.insertDBData_dept(map);
		
		logger.debug("insertDBData_dept ended");
	}
	
	@Override
	public void insertDBData_user(OrganUserVO vo) throws Exception {
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
		map.put("v_MAILNICKNAME", vo.getMailNickName());
		map.put("v_UPNNAME", vo.getUpnName());
		map.put("v_PARENTCN", vo.getParentCn());
		map.put("v_TITLE", vo.getTitle());
		map.put("v_TITLE2", vo.getTitle2());
		map.put("v_TELEPHONE", vo.getTelephoneNumber());
		map.put("v_HOMEPHONE", vo.getHomePhone());
		map.put("v_FAX", vo.getFacsimileTelephoneNumber());
		map.put("v_MOBILE", vo.getMobile());
		map.put("v_POSTALCODE", vo.getPostalCode());
		map.put("v_ADDRESS", vo.getStreetAddress());
		if (vo.getExtensionAttribute1() == null || vo.getExtensionAttribute1().equals("")) {
			map.put("v_EXTATTR1", "c=0;k=0;g=0;a=0;i=0;n=0;l=0;w=0;m=0;");
		} else {
			map.put("v_EXTATTR1", vo.getExtensionAttribute1());
			
		}
		map.put("v_EXTATTR6", vo.getExtensionAttribute6());
		map.put("v_EXTATTR10", vo.getExtensionAttribute10());
		map.put("v_EXTATTR102", vo.getExtensionAttribute102());
		map.put("v_EXTATTR14", vo.getExtensionAttribute14());
		map.put("v_EXTATTR15", vo.getExtensionAttribute15());
		map.put("v_LDAPPATH", "");
		map.put("v_BIRTH", vo.getBirth());		
		map.put("v_BIRTHTYPE", vo.getBirthType());
		map.put("v_PASS", vo.getPassword());
				
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
	public void updateDBData_dept(OrganDeptVO vo) throws Exception {
	    logger.debug("updateDBData_dept started");
        logger.debug("tenantId=" + vo.getTenantId() + ",cn=" + vo.getCn() + ",displayName=" + vo.getDisplayName()
        + ",displayName2=" + vo.getDisplayName2() + ",parentCn=" + vo.getParentCn());	    
	    
        if (vo.getDisplayName2() == null || vo.getDisplayName2().equals("")) {
            vo.setDisplayName2(vo.getDisplayName());
        }
        
		ezOrganAdminDao.updateDBData_dept(vo);
		ezOrganAdminDao.updateUserDeptDisplayName(vo);
		
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
		
		if (config.getProperty("config.IsJMochaStandAlone").equals("YES")) {
		    ezOrganAdminDao.deleteDBData(map);
		} else {
		    if (pClass.toLowerCase().equals("group")) {
		        ezOrganAdminDao.deleteDBData(map);
		    } else {
		        ezOrganAdminDao.deleteDBDataForJMocha(map);
	     
		        ezOrganAdminDao.deleteDBData_D1(map);
		        ezOrganAdminDao.deleteDBData_D4(map);
		        ezOrganAdminDao.deleteDBData_D5(map);
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
		
		if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
			return ezOrganAdminDao.getUserInfo(map);
		} else {
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
                    
            		try {
            			if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
            				ezOrganAdminDao.setAddJob(map);
            			} else {
            				if ((pDeptID != null && !pDeptID.equals("")) || (sTitle1 != null && !sTitle1.equals(""))) {
            					ezOrganAdminDao.setAddJob_I(map);
            				}
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
                    
                    try {
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
		
		if (config.getProperty("config.UseJMochaUserRepository").equals("YES")) {
			ezOrganAdminDao.restoreRetireEntry(map);
	    } else {
	    	ezOrganAdminDao.restoreRetireEntry(map);
	    	ezOrganAdminDao.restoreRetireEntry_D(map);
	    }  
		
		logger.debug("restoreRetireEntry ended");		
	}

	// 지정된 부서에 속한 사원의 수를 반환한다.
	@Override
	public int userCountCheck(String cn, int tenantID) throws Exception {
		return  ezOrganAdminDao.userCountCheck(cn, tenantID);
	}
	
}
