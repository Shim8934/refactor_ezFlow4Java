package egovframework.ezEKP.ezOrgan.service.impl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.annotation.Resource;
import javax.naming.directory.DirContext;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAddJobVO;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailUserAdminService;
import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezNewPortal.dao.EzNewPortalDAO;
import egovframework.ezEKP.ezNewPortal.vo.PortalTopVO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.service.PreResult;
import egovframework.ezEKP.ezOrgan.util.ADConnection;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganGroupVO;
import egovframework.ezEKP.ezOrgan.vo.OrganJobVO;
import egovframework.ezEKP.ezOrgan.vo.OrganLoginStopUserVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.dao.EzPersonalDAO;
import egovframework.ezEKP.ezResource.dao.EzResourceAdminDAO;
import egovframework.ezEKP.ezSystem.vo.PermissionInfoVO;
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
    
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
   	@Autowired
	private Properties globals;
    
	@Resource(name="EzResourceAdminDAO")
	private EzResourceAdminDAO ezResourceAdminDAO;
	
    @Autowired
    private EzPersonalDAO ezPersonalDAO; // 2021-11-01 이사라 추가
    
    @Autowired
    private EzNewPortalDAO ezNewPortalDAO;
    
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
	public List<OrganUserVO> getAddJobList(String companyID, String strLang, String searchType, String searchValue, int tenantID, int totalCount, int pageSize, int startRow, int endRow) throws Exception {
	    logger.debug("getAddJobList started");
	    logger.debug("companyID=" + companyID + ",strLang=" + strLang + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_LANGDATA", strLang);
		map.put("v_TOTALCOUNT", totalCount);
		map.put("v_PAGESIZE", pageSize);
		map.put("v_STARTROW", startRow);
		map.put("v_ENDROW", endRow);
		map.put("v_STARTNUM", startRow - 1);
        map.put("v_COUNT", endRow - startRow + 1);
        map.put("searchType", searchType);
        map.put("searchValue", searchValue);
        
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
	
	// 2022-07-07 이사라 - 한 부서에 겸직이 2개 이상 있는 경우를 확인
	@Override
	public int getAddJobCountInOneDept(String cn, String deleteTitleInfo, int tenantId) throws Exception {
		logger.debug("getAddJobCountInOneDept started. cn={},deleteTitleInfo={}", cn, deleteTitleInfo);

		String[] deptIdArray = deleteTitleInfo.split(":"); // deleteTitleInfo는 부서id:;부서id: 형태로 부서id만 알아내기 위해서는 :로 배열에 저장한 첫번째 값을 추출하면 됨
		String deptId = deptIdArray[0];
		logger.debug("cn=" + cn + ",deptId=" + deptId + ",tenantId=" + tenantId);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantId);
		map.put("v_CN", cn);
		map.put("v_DEPTID", deptId);

		int addJobCnt = ezOrganAdminDao.getAddJobCountInOneDept(map);

		logger.debug("getAddJobCountInOneDept ended");

		return addJobCnt;
	}

	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 권한 조회 메소드 수정
	@Override
	public List<OrganUserVO> getPermissionList(String companyID, String type, String searchType, String searchValue, String strLang, int startRow, int endRow, int tenantID, String permissionBasisDeptYN) throws Exception {
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
		map.put("permissionBasisDeptYN", permissionBasisDeptYN);
		
		return ezOrganAdminDao.getPermissionList(map);
	}

	@Override
	public List<OrganUserVO> getRetireList(int pPage, int pPageRow, int tenantID, String offset, String searchStartDate, String searchEndDate, String searchKeycode, String searchKeyword, String searchCompanyID)	throws Exception {
        logger.debug("getRetireList started");
        logger.debug("pPage=" + pPage + ",pPageRow=" + pPageRow);
        logger.debug("tenantID=" + tenantID + ",offset=" + offset);
        logger.debug("searchStartDate=" + searchStartDate + ",searchEndDate=" + searchEndDate);
   		logger.debug("searchKeycode=" + searchKeycode + ",searchKeyword=" + searchKeyword);
   		logger.debug("searchCompanyID=" + searchCompanyID );
   		
   		if (!searchStartDate.equals("")) {
   			searchStartDate += " 00:00:00";
   			searchEndDate += " 23:59:59";
		}
   		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("v_ROWPERPAGE", pPageRow);
		map.put("v_STARTROW", pPageRow*(pPage - 1));
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("search_keycode", searchKeycode);
		map.put("search_keyword", searchKeyword);
		map.put("companyId", searchCompanyID);
				
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
	public String moveEntry(String parentCn, String cn, String type, String offset, int tenantID) throws Exception {
	    logger.debug("moveEntry started");
	    logger.debug("parentCn=" + parentCn + ",cn=" + cn + ",type=" + type + ",tenantID=" + tenantID);
	    
		String result = "";
		
		if (parentCn.equals(cn)) {
			result = "SAME";
		} else {
			// 2019-01-08 천성준 - 사원이동 시, 사원이 이동하려는 부서에 겸직이 되어있는지 체크하는 로직 추가 
			/*List<OrganUserVO> userAddJobList = getUserAddJobList(cn, "1", tenantID);
			if (userAddJobList != null && userAddJobList.size() > 0) {
				String gyumJikDeptID = "";
				for (int i = 0; i < userAddJobList.size(); i++) {
					gyumJikDeptID = userAddJobList.get(i).getDepartment();
					
					if (gyumJikDeptID != null && parentCn.equals(gyumJikDeptID)) {
						result = "HASGYUMJIK";
						return result;
					}
				}
			}*/
			
			OrganDeptVO parentDept = ezOrganService.getDeptInfo(parentCn, "1", tenantID);
			String compId = "";
			
			if (type.equalsIgnoreCase("group")) {
				OrganDeptVO deptVO = ezOrganService.getDeptInfo(cn, "1", tenantID);
				compId = deptVO.getExtensionAttribute2();
			} else {
				OrganUserVO userVO = getUserInfo(cn, "1", tenantID);
				compId = userVO.getPhysicalDeliveryOfficeName();
			}

			/* 2024.02.27 한슬기 : 회사 간 부서이동 허용으로 변경
			// 회사 간 부서 이동하지 못하도록 막음
			if (type.equalsIgnoreCase("group") && !parentDept.getExtensionAttribute2().equals(compId)) {
				result = "DIFF_COMPANY";
				logger.debug("moveEntry ended. result=" + result);
				return result;
			}
			 */
			
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
					moveDBData(parentCn, cn, type, offset, tenantID);
		            result = "OK";
				} catch (Exception e) {
					logger.error(e.getMessage(), e);
					ezEmailUserAdminService.updateGroupMove(newGroupAddr, oldGroupAddr, mailAddr);
					result = "EMAIL_ERROR";
				}				
			} else {
				result = "EMAIL_ERROR";
			}
		}
		
		logger.debug("moveEntry ended. result=" + result);
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
    	} else if (pClass.toLowerCase().equals("addJob")) {
    		ezOrganAdminDao.updateProperty_addJob(map);
    	// 부서의 경우
    	} else {
    		ezOrganAdminDao.updateProperty_U(map);
    	}       
		
		logger.debug("updateProperty ended");
	}
	
	@Override
	public void updateProperty(String cn, String column, String number, String pClass, int tenantID, String deptID) throws Exception {
	    logger.debug("updateProperty started");
	    logger.debug("cn=" + cn + ",column=" + column + ",number=" + number + ",pClass=" + pClass + ",tenantID=" + tenantID + ",deptID=" + deptID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_CLASS", pClass);
		map.put("v_PROPNAME", column);
		map.put("v_PROPVALUE", number);
		map.put("V_DEPTID", deptID);
		
		if (column.equals("EXTENSIONATTRIBUTE15")) {
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			date.setTimeZone(TimeZone.getTimeZone("GMT"));
			String nowDate = date.format(new Date());
			map.put("nowDate", nowDate);
		}
		
        // 사원의 경우
    	if (pClass.toLowerCase().equals("user")) {
    		ezOrganAdminDao.updateProperty(map);
    	} else if (pClass.toLowerCase().equals("addjob")) {
    		ezOrganAdminDao.updateProperty_addJob(map);
    	// 부서의 경우
    	} else {
    		ezOrganAdminDao.updateProperty_U(map);
    	}       
		
		logger.debug("updateProperty ended");
	}
	
	public void moveDBData(String parentCn, String cn, String type, String offset, int tenantID) throws Exception {
        logger.debug("moveDBData started");
        logger.debug("parentCn=" + parentCn + ",cn=" + cn + ",type=" + type + ",tenantID=" + tenantID);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_PARENTCN", parentCn);
		map.put("v_CN", cn);
		map.put("v_CLASS", type);
		
		logger.debug("type="+type);
		
        /*ezOrganAdminDao.moveDBDataForJMocha(map);*/
        
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
    		    	// 2024.03.19 한슬기 : 부서이동시 이동하는 부서의 하위부서 deptLevel이 변경되지 않는 문제 수정
    		    	// (새 상위부서레벨 - 기존의 레벨) 값을 하위부서모두에 더해준다.
        		    int deptLevel = Integer.parseInt(dept.getDeptLevel().trim()) + 1;
        		    int deptLevelBefore = Integer.parseInt(dept1.getDeptLevel().trim());
        		    
        		    int deptLevelChange = deptLevel - deptLevelBefore;
        		    
        		    map.put("v_DEPTLEVEL", deptLevel);
        		    map.put("v_DEPTLEVEL_CHANGE", deptLevelChange);
        		    
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
    		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    		Date date                  = new Date();
    		String timeUTC             =  commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
    		
    		map.put("timeUTC", timeUTC);
    		map.put("nowDate", timeUTC);
    		map.put("v_EXTATTR15", "0");
    		
    		// 사원이동 시 트리뷰순서값을 0으로 세팅
    		ezOrganAdminDao.updateDBData_addjobmasterOrder(map); // 겸직되어있는 사용자 트리뷰순서값 1씩 증가
			ezOrganAdminDao.updateDBData_userOrder(map); // 원부서 사용자 트리뷰순서값 1씩 증가
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
		
		// 2021-11-09 이사라 : 현재암호 가장최근 암호로 저장
		ezCommonService.setPrevPwd(tenantID, cn, ezPersonalDAO.getPassword(cn, tenantID));
		
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
	public String changePasswordWithEmailSystem(String cn, int tenantId, String decryptedOldPassword, String decryptedNewPassword) throws Exception {
		logger.debug("changePasswordWithEmailSystem started");
		String result = "";

		String domain = ezCommonService.getTenantConfig("DomainName", tenantId);
		String mailAddr = cn + "@" + domain;

		logger.debug("cn=" + cn + ",domain=" + domain + ",tenantID=" + tenantId);

		// 이메일 계정의 암호를 새 암호로 설정한다.
		int rc = ezEmailUserAdminService.checkAndUpdateUserPassword(mailAddr, decryptedOldPassword, decryptedNewPassword);

		// checkAndUpdateUserPassword 성공
		if (rc == 0) {

			// 로컬 시스템에서 해당 User의 암호를 변경한다.
			try {
				setPassword(cn, decryptedNewPassword, tenantId);
				result = "OK";
			// Exception이 발생하면 취소 처리를 한다.
			} catch (Exception e) {
				ezEmailUserAdminService.checkAndUpdateUserPassword(mailAddr, decryptedNewPassword, decryptedOldPassword);
				result = "UPDATEERROR";
				logger.debug("UPDATEERROR : setting the user '{}' password failed.", cn);
			}
		} else {
			result = "MAILERROR";
			logger.debug("MAILERROR : setting the user '{}' password failed.", mailAddr);
		}

		logger.debug("changePasswordWithEmailSystem ended");
		return result;
	}

	@Override
	public void retireEntry(String cn, String domain, String adminPassword, int tenantID, String offset) throws Exception {
	    logger.debug("retireEntry started");
	    logger.debug("cn=" + cn + ",domain=" + domain + ",tenantID=" + tenantID + ",offset=" + offset);
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		// 퇴직자의 암호를 현재 관리자의 암호와 동일하게 변경한다.
		// 이후 과정에서 에러가 발생했을 때 암호를 롤백할 방법이 없는 문제가 있다. 
		setPasswordWithEmailSystem(cn, domain, adminPassword, tenantID);
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             =  commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
	
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("timeUTC", timeUTC);
		
	    ezOrganAdminDao.retireDBData_I(map);
	    /*ezOrganAdminDao.retireDBData(map);*/
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
	public PreResult checkDuplicateId(String cn, String employeeNumber, int tenantId) throws Exception {
		if (ezOrganAdminDao.userCheck(cn, tenantId) > 0) {
			return PreResult.PRE;
		}

		return checkDuplicateLoginId(cn, employeeNumber, tenantId);
	}

	@Override
	public PreResult checkDuplicateLoginId(String cn, String employeeNumber, int tenantId) throws Exception {
		if (!"yes".equalsIgnoreCase(ezCommonService.getTenantConfig("UseEmpNumberLogin", tenantId))) {
			return PreResult.NONE;
		}

		if (ezOrganAdminDao.isDuplicateLoginId(cn, cn, tenantId)) {
			return PreResult.PRE_CN;
		}

		if (StringUtils.isNotEmpty(employeeNumber) && ezOrganAdminDao.isDuplicateLoginId(cn, employeeNumber, tenantId)) {
			return PreResult.PRE_EMPLOYEE_NUMBER;
		}

		return PreResult.NONE;
	}

	@Override
	public int getRetireListCount(int pPage, int pPageRow, int tenantID, String searchStartDate, String searchEndDate, String searchKeycode, String searchKeyword, String searchCompanyID) throws Exception {
	    logger.debug("getRetireListCount started");
	    logger.debug("pPage=" + pPage + ",pPageRow=" + pPageRow + ",tenantID=" + tenantID);
	    logger.debug("searchStartDate=" + searchStartDate + ",searchEndDate=" + searchEndDate);
   		logger.debug("searchKeycode=" + searchKeycode + ",searchKeyword=" + searchKeyword);
   		
   		if (!searchStartDate.equals("")) {
   			searchStartDate += " 00:00:00";
   			searchEndDate += " 23:59:59";
		}
	    
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_PAGE", pPage);
		map.put("v_ROWPERPAGE", pPageRow);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("search_keycode", searchKeycode);
		map.put("search_keyword", searchKeyword);
		map.put("companyId", searchCompanyID);
		
		logger.debug("getRetireListCount ended");
		
		return ezOrganAdminDao.getRetireListCount(map);
	}

	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 권한 카운트 조회 메소드 수정
	@Override
	public int getPermissionListCount(String companyID, String type, String searchType, String searchValue, String strLang, int tenantID, String permissionBasisDeptYN) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TYPE", type);
		map.put("v_LANGDATA", strLang);
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);
		map.put("permissionBasisDeptYN", permissionBasisDeptYN);
		
		return ezOrganAdminDao.getPermissionListCount(map);
	}

	@Override
	public void insertDBData_company(String cn, String displayName,	String displayName2, String mailAddr,
					String parentCn, String ldapPath, String extensionAttribute15, String skipInitData,
					String manualFlag, int tenantID, LoginVO userInfo) throws Exception {
	    logger.debug("insertDBData_company started");
	    logger.debug("cn=" + cn + ",displayName=" + displayName + ",displayName2=" + displayName2
	    		+ ",extensionAttribute15=" + extensionAttribute15 + ",skipInitData=" + skipInitData
	    		+ ",manualFlag=" + manualFlag + ",parentCn=" + parentCn + ",tenantID=" + tenantID);
	    
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
		map.put("v_MANUAL_FLAG", manualFlag);
		
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
				map1.put("PrimaryLang", ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId()));
				map1.put("menuType", "0");
				for (int i = 0; i < 112; i++) {
					map1.put("menuItemUUID"+String.valueOf(i), UUID.randomUUID().toString());
				}
				
				for (int i = 0; i < 19; i++) {
					map1.put("portalItemUID"+i, UUID.randomUUID().toString());
				}
				
				for (int i = 0; i < 44; i++) {
					map1.put("menuItemSUID"+i, UUID.randomUUID().toString());
				}
				
//				ezOrganAdminDao.insertCompanyInfo_I6(map1);
				ezOrganAdminDao.insertCompanyInfo_I7(map1);
				ezOrganAdminDao.insertCompanyInfo_I8(map1);
				ezOrganAdminDao.insertCompanyInfo_I9(map1);
				ezOrganAdminDao.insertCompanyInfo_I10(map1);
//				ezOrganAdminDao.insertCompanyInfo_I11(map1);
				/* 2020-08-24 홍승비 - insert all 시, 오라클에서는 insert한 레코드 바로 select할수 없어 null이 삽입되는 오류 수정 */
				if (globals.getProperty("Globals.DbType").equals("oracle")) {
					ezOrganAdminDao.insertCompanyInfo_I12_separate(map1); // insertCompanyInfo_I12 오라클 쿼리에서 6개의 insert를 분리
				}
				ezOrganAdminDao.insertCompanyInfo_I12(map1);
				ezOrganAdminDao.insertCompanyInfo_I13(map1);
				ezOrganAdminDao.insertCompanyInfo_I14(map1);
				ezOrganAdminDao.insertCompanyInfo_I15(map1);
				ezOrganAdminDao.insertCompanyInfo_I16(map1);
				ezOrganAdminDao.insertCompanyInfo_I17(map1);
				ezOrganAdminDao.insertCompanyInfo_I18(map1);
				ezOrganAdminDao.insertCompanyInfo_I19(map1);
				
				ezOrganAdminDao.insertCompanyInfo_IKMS7(map1);
				
				//회사등록시 근태설정(근태규율관리) 기본값 insert
				ezOrganAdminDao.insertCompanyInfo_I20(map1);
				map1.put("lang", userInfo.getLang());
				ezOrganAdminDao.insertCompanyInfo_I21(map1);
				
				//회사 생성시 포탈 개인화 기본값 설정 insert
				ezOrganAdminDao.insertCompanyInfo_I23(map1);
				ezOrganAdminDao.insertCompanyInfo_I24(map1);
				ezOrganAdminDao.insertCompanyInfo_I25(map1);
				ezOrganAdminDao.insertCompanyInfo_I26(map1);
				ezOrganAdminDao.insertCompanyInfo_I27(map1);
				ezOrganAdminDao.insertCompanyInfo_I28(map1);
				ezOrganAdminDao.insertCompanyInfo_I29(map1);
				ezOrganAdminDao.insertCompanyInfo_I30(map1);
				ezOrganAdminDao.insertCompanyInfo_I31(map1);
				ezOrganAdminDao.insertCompanyInfo_I32(map1);
				
				//회사등록시 근태설정(연차설정관리) 기본값 insert
				ezOrganAdminDao.insertCompanyInfo_IJHS1(map1);
				//차량관리 기본값 insert
				ezOrganAdminDao.insertCompanyInfo_I33(map1);
				
				PortalTopVO portalTopVO = new PortalTopVO();
				portalTopVO.setCompanyID(cn);
				portalTopVO.setTenantID(tenantID);
				portalTopVO.setType(0);
				ezNewPortalDAO.insertTopMenuDisplayModeForCompany(portalTopVO); // 2024-05-17 한태훈 > 회사 탑메뉴 설정 위치 기본값 세팅 (기본값 : 0 = 메뉴 위치 상단)
				ezOrganAdminDao.insertConnectMenuForNewCompany(map1);
				ezOrganAdminDao.insertMobileMenuForNewCompany(map1);	// 2024-08-12 조수빈 - 모바일 기본 메뉴 생성
            // 로컬 등록이 실패하면 JMocha User Repository에 등록한 것을 삭제한다.
            } catch (Exception e) {
                logger.error(e.getMessage(), e);
                /*
                map.put("v_CLASS", "group");
                ezOrganAdminDao.deleteDBDataForJMocha(map);*/
                
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
		// 2024.03.22 한슬기 : UpdateDT컬럼에 들어갈 값 추가 
		vo.setNowDate(nowDate);
		
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
		map.put("v_EXTATTR11", vo.getExtensionAttribute11() != null ? vo.getExtensionAttribute11() : "");
		map.put("v_MANUAL_FLAG", vo.getManualFlag() != null ? vo.getManualFlag() : "N");
		map.put("v_LDAPPATH", "");
		map.put("v_DEPTTREEFLAG",vo.getDeptTreeFlag() != null ? vo.getDeptTreeFlag() : "Y");
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);

		// 신규 부서 추가 시 제일 하위에 위치하도록 순서 조정
		if (vo.getManualFlag() != null && vo.getManualFlag().equals("Y")) {
			if (checkExtrattrIsNull(vo.getExtensionAttribute15())) {
				vo.setExtensionAttribute15(ezOrganAdminDao.getDeptExtension15(map));
//				ezOrganAdminDao.updateDBData_deptOrderIsNull(map);
			}
			
//			map.put("v_EXTATTR15", vo.getExtensionAttribute15());
//			
//			ezOrganAdminDao.updateDBData_deptOrder(map); // 부서 트리뷰순서값 1씩 증가
		}
		
		map.put("v_EXTATTR15", vo.getExtensionAttribute15());
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
		
		// 코린도에서 extensionAttribute11 필드를 한국인, 현지인 구분에 사용하여 추가함
		map.put("v_EXTATTR11", vo.getExtensionAttribute11() != null ? vo.getExtensionAttribute11() : "");

		// 직위/직책 CODE( 7=직위, 8=직책 )
		map.put("v_EXTATTR7", vo.getExtensionAttribute7() != null ? vo.getExtensionAttribute7() : "");
		map.put("v_EXTATTR8", vo.getExtensionAttribute8() != null ? vo.getExtensionAttribute8() : "");
		
		map.put("v_LDAPPATH", "");
		map.put("v_BIRTH", vo.getBirth() != null ? vo.getBirth() : "");		
		map.put("v_BIRTHTYPE", vo.getBirthType() != null ? vo.getBirthType() : "");
		map.put("v_PASS", vo.getPassword());
		map.put("v_INSERTADPASS", oriPass);
		map.put("v_MANUAL_FLAG", vo.getManualFlag() != null ? vo.getManualFlag() : "N");
		map.put("v_FURIGANA", vo.getFurigana() != null ? vo.getFurigana() : "");
		map.put("v_EXTENSION_PHONE", vo.getExtensionPhone() != null ? vo.getExtensionPhone() : "");
		map.put("v_OFFICE_MOBILE", vo.getOfficeMobile() != null ? vo.getOfficeMobile() : "");
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		// 신규 사원 추가 시 제일 하위에 위치하도록 순서 조정
		if (vo.getManualFlag() != null && vo.getManualFlag().equals("Y")) {
			if (checkExtrattrIsNull(vo.getExtensionAttribute15())) {
				vo.setExtensionAttribute15(ezOrganAdminDao.getUserExtension15(map));
//				ezOrganAdminDao.updateDBData_userOrderIsNull(map);
			}
			
//			map.put("v_EXTATTR15", vo.getExtensionAttribute15());
			
			// 2023.06.07 한슬기 : 트리뷰 순서값이 지정된 경우 순서값 유지, 지정되지 않았을 경우 1씩 증가하도록 수정
//			if ("0".equals(map.get("v_EXTATTR15"))) {
//				ezOrganAdminDao.updateDBData_addjobmasterOrder(map); // 겸직되어있는 사용자 트리뷰순서값 1씩 증가
//				ezOrganAdminDao.updateDBData_userOrder(map); // 원부서 사용자 트리뷰순서값 1씩 증가
//				
//			}
			
			/* 원본코드
			ezOrganAdminDao.updateDBData_addjobmasterOrder(map); // 겸직되어있는 사용자 트리뷰순서값 1씩 증가
			ezOrganAdminDao.updateDBData_userOrder(map); // 원부서 사용자 트리뷰순서값 1씩 증가
			*/
		}
		
		map.put("v_EXTATTR15", vo.getExtensionAttribute15());
		map.put("v_USERTREEFLAG", vo.getUserTreeFlag() != null ? vo.getUserTreeFlag() : "Y");
		ezOrganAdminDao.insertDBData_user(map);
				
		logger.debug("insertDBData_user ended");
	}
	
	public boolean checkExtrattrIsNull(String str) {
		if (str == null || str.equals("")) {
			return true;
		} else {
			return false;
		}
	}

    @Override
    public void updateDBData_user(OrganUserVO vo) throws Exception {
        logger.debug("updateDBData_user started");
        logger.debug("tenantId=" + vo.getTenantId() + ",cn=" + vo.getCn() + ",displayName=" + vo.getDisplayName()
                + ",displayName2=" + vo.getDisplayName2() + ",parentCn=" + vo.getParentCn()
                + ",ExtensionPhone=" + vo.getExtensionPhone() + ",OfficeMobile=" + vo.getOfficeMobile());
                
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
	    	// 겸직테이블에서 해당 부서 겸직정보 삭제
	    	Map<String, Object> map2 = new HashMap<String, Object>();
	    	map2.put("v_TENANT_ID", tenantID);
	    	map2.put("v_DEPTID", cn);
	    	ezOrganAdminDao.deleteAddJob(map2);
	    	
	    	deleteUserAddJob(cn, tenantID);
	    	
	    	// company_config 삭제
	    	deleteCompanyConfig(cn, tenantID);
	    	
	        ezOrganAdminDao.deleteDBData(map);
	        
	        //회사 삭제시 넣었던 초기데이터 테이블 삭제
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
	        
	        //2023-06-01 장혜연 : 회사데이터 삭제 코드 추가
	        //근태설정(근태규율관리) 데이터 삭제 
	        ezOrganAdminDao.deleteCompany_D20(map);
	        ezOrganAdminDao.deleteCompany_D21(map);
	        
	        //포탈 개인화 설정 데이터 삭제
	        ezOrganAdminDao.deleteCompany_D23(map);
	        ezOrganAdminDao.deleteCompany_D24(map);
	        ezOrganAdminDao.deleteCompany_D25(map);
	        ezOrganAdminDao.deleteCompany_D26(map);
	        ezOrganAdminDao.deleteCompany_D27(map);
	        ezOrganAdminDao.deleteCompany_D28(map);
	        ezOrganAdminDao.deleteCompany_D29(map);
	        ezOrganAdminDao.deleteCompany_D30(map);
	        ezOrganAdminDao.deleteCompany_D31(map);
	        ezOrganAdminDao.deleteCompany_D32(map);
	        
	        //차량관리  데이터 삭제
	        ezOrganAdminDao.deleteCompany_D33(map);
	        //근태설정(연차설정관리) 데이터 삭제
	        ezOrganAdminDao.deleteCompanyInfo_IJHS1(map);

	        ezOrganAdminDao.deleteCompanyInfo_IKMS7(map);
	        
	        //웹폴더 데이터 삭제 
	        ezOrganAdminDao.deleteCompany_D34(map);
	        
	        // 포탈 > 메뉴 설정 값 삭제 (상단 표출, 좌측 표출)
	        ezOrganAdminDao.deleteCompany_D35(map);
	        
	        // 시스템 > 시스템 컨피그 값 삭제
	        ezOrganAdminDao.deleteCompany_D36(map);
	        ezOrganAdminDao.deleteCompany_D37(map);
	        // 
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
	    	
	        /*ezOrganAdminDao.deleteDBDataForJMocha(map);*/
     
	        ezOrganAdminDao.deleteDBData_D1(map); // TBL_USERMASTER
	        ezOrganAdminDao.deleteDBData_D4(map); // TBL_ADDJOBMASTER
	        ezOrganAdminDao.deleteDBData_D5(map); // TBL_USERMASTER_RETIRE
	        ezOrganAdminDao.deleteDBData_D6(map); // 2021-11-10 이사라 : TBL_USER_CONFIG
			ezPersonalDAO.clearNotiDisableItems(cn, tenantID); // TBL_USER_NOTI_DISABLE_ITEM
	        
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

    /**
     * 사용자 프로필 삭제 함수		// 인사연동 소스에서 따옴.
     *
     * 프로필을 사진삭제를 해야하는 부분은 다음 3가지가 있다.
     * 현재 효율성으로 extensionAttribute2값만 ""으로 update하고 있는데, 퇴직자 삭제의 경우는 파일을 실제 삭제하므로 이 함수를 사용한다.
     * (1)/admin/ezOrgan/delUser.do 퇴직자 삭제
     * (2)/ezPersonal/deletePicture.do 사용자가 사진삭제
     * (3)/admin/ezOrgan/userInfo.do->function deleteImg()->/admin/ezOrgan/saveUserInfo.do 관리자가 사진삭제
     *
     * ※ 만약 2,3의 경우에도 파일 실제 삭제를 원한다면 해당 controller에서 이 함수를 추가하면 됨.
     * ※ thumbnailFile을 삭제하는 것은 그냥 범용적으로 둔 것인데, 현재는 썸네일을 사용하지 않는다고 알고 있다. 사이트에 따라 필요하다고 판단하면 주석처리를 풀면 된다.
     * */
	@Override
	public void deleteDestUserProfileImage(String cn, int tenantID, String realPath) throws Exception {
		logger.debug("deleteDestUserProfileImage started. cn={}", cn);

	    String photoPath = realPath + commonUtil.getUploadPath("upload_personal.PHOTO", tenantID) + commonUtil.separator;
		String thumbnailPath = photoPath + "thumbnail" + commonUtil.separator;

		try {
			String photoFilePath = photoPath + cn + ".jpg";
			logger.debug("photoFilePath={}", photoFilePath);

			File photoFile = new File(commonUtil.detectPathTraversal(photoFilePath));
			if (photoFile.exists()) {
				photoFile.delete();
				logger.debug("photoFile delete.");
			}
			/*
			String thumbnailFilePath = thumbnailPath + cn + ".jpg";
			logger.debug("thumbnailFilePath={}", thumbnailFilePath);

			File thumbnailFile = new File(commonUtil.detectPathTraversal(thumbnailFilePath));
			if (thumbnailFile.exists()) {
				thumbnailFile.delete();
				logger.debug("thumbnailFile delete.");
			}
			*/
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("deleteDestUserProfileImage ended");
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
	public void addJob(String userID, String titleInfo, String jobID, String roleInfo, int tenantID) throws Exception {
	    logger.debug("addJob started");
	    logger.debug("userID={}, titleInfo={}, jobID={}, roleInfo={}, tenantID={}",userID, titleInfo, jobID, roleInfo, tenantID);
		String sTitle1 = "";
        String sTitle2 = "";
        String pDeptID = "";
        String manualFlag = "";
        if (!titleInfo.equals("")) {
            String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
            
        	String[] addJobinfo = titleInfo.split(";");
        	String[] jobIDinfo = jobID.split(";");
        	String[] addJobRoleInfo = roleInfo.split(";");
        	
            for (int i = 0; i < addJobinfo.length; i++) {
            	// 직책은 없을 수 도 있으니 값을 초기화 한다 
            	String sRole1 = "";
                String sRole2 = "";
                String roleId = "";
            	String[] userInfo = addJobinfo[i].split(":");
            	String [] userRoleInfo = addJobRoleInfo[i].split(":");
            	pDeptID = userInfo[0];
            	manualFlag = userInfo[userInfo.length - 1];
            	
            	if (manualFlag.equals("null")) {
            		manualFlag = null;
            	}
            	            	
            	if (userInfo.length > 2) {
            		sTitle1 = userInfo[1];
            	}
                
                sTitle2 = "";
                
                if (userInfo.length > 3) {
                    sTitle2 = userInfo[2];
                } else {
                    sTitle2 = sTitle1;
                }
                
                if (userRoleInfo.length > 1) {
                	roleId = userRoleInfo[0];
                	sRole1 = userRoleInfo[1];
                	sRole2 = userRoleInfo[2];
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
            		map.put("v_ROLE", sRole1);
            		map.put("v_ROLE2", sRole2);
            		map.put("v_PARENTCN", pDeptID);
            		map.put("v_JOBID", jobIDinfo[i]);
            		map.put("v_ROLEID", roleId.length() > 0 ? roleId : "0");
            		map.put("v_MANUAL_FLAG", manualFlag);
            		
            		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            		date.setTimeZone(TimeZone.getTimeZone("GMT"));
            		String nowDate = date.format(new Date());
            		map.put("nowDate", nowDate);
					map.put("v_EXTATTR15", ezOrganAdminDao.getUserExtension15(map));

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
        					
        					// 겸직 시 조직도에서 트리뷰순서값 0으로 수정(맨 위에 세팅 되도록)
                    		// 부서 사용자 순서값 1씩 증가
//                    		ezOrganAdminDao.updateDBData_userOrder(map);
//                    		ezOrganAdminDao.updateDBData_addjobmasterOrder(map);
        					ezOrganAdminDao.setAddJob_I(map);
        					
        				}       
            		} catch (Exception e) { // Exception이 발생하면 Group Email 주소로부터 취소 처리를 한다.
            			logger.error(e.getMessage(), e);
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
		deleteJob(userID, titleInfo, tenantID, "none", "none", false);
	}

	// 2022-07-07 이사라 - 한 부서에 2개 이상의 겸직이 있는 경우 1개만 삭제를 하기 위해 추가된 파라미터가 있어 deletJob 메소드 오버로딩 함
    @Override
    public void deleteJob(String userID, String titleInfo, int tenantID, String delJobId, String delRoleId, boolean isAddJobMoreInOneDept) throws Exception {
        logger.debug("deleteJob started");
        logger.debug("userID=" + userID + ",titleInfo=" + titleInfo + ",tenantID=" + tenantID + ",delJobId=" + delJobId + ",isAddJobMoreInOneDept=" + isAddJobMoreInOneDept);
        
        OrganUserVO userVO = getUserInfo(userID, "1", tenantID);
        String userDept = userVO.getDepartment();
		boolean hasJobId = ("none".equalsIgnoreCase(delJobId)) ? false : true; // 2022-07-06 이사라 - 겸직 1개만 삭제할 때만 jobid를 전달 함
        
        String pDeptID = "";
		int rc = 0;
        
        if (!titleInfo.equals("")) {
            String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
            
            String[] addJobinfo = titleInfo.split(";");
            
            for (int i = 0; i < addJobinfo.length; i++) {
                String[] userInfo = addJobinfo[i].split(":");
                pDeptID = userInfo[0];
                
                // 겸직 부서의 Group Email 주소로부터 해당 User를 제거한다.                  
                String groupAddr = pDeptID + "@" + domain;
                String mailAddr = userID + "@" + domain;
                
				if (!isAddJobMoreInOneDept) { // 한 부서에 여러 겸직이 있는 경우에는 rewrite에서 삭제되는 것을 막음
					rc = (userDept.equals(pDeptID)) ? 0 : ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
				}

                logger.debug("updateGroupDel rc=" + rc);
                
                if (rc != -100) { // updateGroupDel 성공(부모그룹이나 자식 주소를 찾지 못해도 성공으로 봄. 어차피 삭제하려는 것이므로.)
                    Map<String, Object> map = new HashMap<String, Object>();        
                    
                    map.put("v_TENANT_ID", tenantID);
                    map.put("v_CN", userID);
                    map.put("v_DEPTID", pDeptID);
					if (hasJobId) { // 2022-07-06 이사라 - 겸직 부분 삭제
						map.put("v_JOBID", delJobId);
						map.put("v_ROLEID", delRoleId);
					}
                    
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

						if (!isAddJobMoreInOneDept) { // 한 부서에 여러 겸직이 있는 경우에는 rewrite에서 삭제하지 않았기때문에 제외
							ezEmailUserAdminService.updateGroupAdd(groupAddr, mailAddr);
						}
                    }                    
                }
            }
        }       
        
        logger.debug("deleteJob ended");
    }
    
	@Override
	public void restoreRetireEntry(String cn, String deptID, int tenantID, String offset) throws Exception {
	    logger.debug("restoreRetireEntry started");
	    logger.debug("cn=" + cn + ",deptID=" + deptID); 
	    logger.debug("tenantID=" + tenantID + ",offset=" + offset);
	    
		Map<String, Object> map = new HashMap<String, Object>();		
		
	    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date                  = new Date();
		String timeUTC             =  commonUtil.getDateStringInUTC(formatter.format(date), offset, true);
		String initPermission = "c=0;k=0;g=0;a=0;i=0;n=0;l=0;w=0;m=0;";
		
		map.put("timeUTC", timeUTC);
	    map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_PARENTCN", deptID);
		map.put("temp", "");
		map.put("initPermission", initPermission);
		
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
    									 String keycode,String keyword,String companyId, String sortColumn, String sortType, boolean[] searchFor) throws Exception {     
    	logger.debug("getUserList started");
    	if(searchFor == null) {
    		searchFor = new boolean[] {true, true, true}; 
    	}
    	
    	Map<String, Object> params = new HashMap<String, Object>();
    	
    	params.put("tenantID", tenantID);
		params.put("v_start", startPage);
		params.put("v_end", (!searchFor[0] && !searchFor[1] && !searchFor[2])? 0 : startPage + maxItemPerPage - 1);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("companyId", companyId);
		params.put("sortColumn", sortColumn);      
		params.put("sortType", sortType);
		params.put("searchForAll", searchFor[0] && searchFor[1] && searchFor[2]);
		params.put("isAnd", (searchFor[0] && !searchFor[1] && !searchFor[2]) 
					    || (!searchFor[0] && !(searchFor[1] && searchFor[2])));
		params.put("retired", searchFor[1]);
		params.put("stopped", searchFor[2]);
		// 2024-09-06 김승연 공유사서함 조회 플래그 추가
		if (searchFor.length == 4 ) {
			params.put("sharedMailBox", searchFor[3]);
		}
		
		String orderByData = "";
		if(!sortColumn.equals("")){
			if(sortColumn.equals("persent")){
				orderByData = " (MAILBOXUSAGE/MAILBOXQUOTA)*100 " + sortType;
			}else if (sortColumn.equals("mailboxusage")){
				orderByData = sortColumn +"/1024 " + sortType;
			}				
			 else {
				orderByData = sortColumn + " " + sortType;
			}
		}
		
		params.put("orderbyData", orderByData);
    	List<OrganUserVO> list = ezOrganAdminDao.getUserList(params);
    	
    	logger.debug("getUserList ended");
    	
    	return list;
    }

    // 사용자 이름,부서 목록개수를 반환한다.
    @Override
    public int getUserCount(int tenantID, String keycode, String keyword, boolean[] searchFor, String companyId) throws Exception {     
    	logger.debug("getUserCount started");
    	if(searchFor == null) {
    		searchFor = new boolean[] {true, true, true}; 
    	}
   		
    	Map<String, Object> params = new HashMap<String, Object>();
    	
    	params.put("tenantID", tenantID);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("companyId", companyId);
		
		params.put("searchForAll", searchFor[0] && searchFor[1] && searchFor[2]);
		params.put("isAnd", (searchFor[0] && !searchFor[1] && !searchFor[2]) 
					    || (!searchFor[0] && !(searchFor[1] && searchFor[2])));
		params.put("retired", searchFor[1]);
		params.put("stopped", searchFor[2]);
		
		// 2024-09-06 김승연 공유사서함 조회 플래그 추가
		if (searchFor.length == 4 ) {
			params.put("sharedMailBox", searchFor[3]);
		}

		int userCount = (!searchFor[0] && !searchFor[1] && !searchFor[2])? 0 : ezOrganAdminDao.getUserCount(params);
		
		logger.debug("getUserCount ended. userCount=" + userCount);
    	
		return userCount;
    }	
    // 사용자 관리 액셀 생성
	@Override
	public String createExcelTotalUsers(String realPath, String dirPath, List<OrganUserVO> exportUserlist, String primary, Locale locale) throws Exception {
		logger.debug("createExcelTotalUsers started.");

		Date date                  = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String fileName            = egovMessageSource.getMessage("ezOrgan.ksy02", locale).trim() + "_" + formatter.format(date) + ".xlsx";
		String filePath            = dirPath + fileName;
		File file                  = new File(dirPath);
		File file2                 = new File(filePath);

		// temp 폴더가 없는 경우: 만들거나(mkdir), 폴더 안을 깨끗히 비운다.
		if (file == null || !file.exists()) {
			file.mkdirs();
		}
		else {
			FileUtils.cleanDirectory(file);
		}

		// 같은 이름의 파일이 있을 경우: "파일(2).xlsx"으로 만든다.
		if (file2.exists()) {
			int pos         = fileName.lastIndexOf('.');
			String extend   = fileName.substring(pos + 1);
			String mainName = fileName.substring(0, pos);
			int k           = 1;
			fileName        = mainName + "(" + Integer.toString(k) + ")." + extend;
			filePath        = dirPath + fileName;
			file2           = new File(filePath);

			while (file2.exists()) {
				fileName = mainName + "(" + Integer.toString(++k) + ")." + extend;
				filePath = dirPath + fileName;
			}
		}

		// 엑셀 파일 생성(workbook). 시트 이름은(sheet1): "ezOrgan.ksy02"
		FileOutputStream fileOut = null;
		Workbook workbook = new XSSFWorkbook();

		Sheet sheet1 = workbook.createSheet(egovMessageSource.getMessage("ezOrgan.ksy02", locale).trim());
		sheet1.setDefaultRowHeight((short)500);
		
		//Set style
		CellStyle centerStyle = workbook.createCellStyle();
		centerStyle.setWrapText(false);
		centerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		centerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		CellStyle centerStyle2 = workbook.createCellStyle();
		centerStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		CellStyle centerStyle3 = workbook.createCellStyle();
		centerStyle3.setAlignment(CellStyle.ALIGN_LEFT);
		centerStyle3.setIndention((short)3);
		centerStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		//sheet1.setColumnWidth(0, 8 * 256);

		//Process first row
		Row rowhead1 = sheet1.createRow(0);
		rowhead1.createCell(0).setCellValue(egovMessageSource.getMessage("main.t252",locale) + " " + exportUserlist.size() +
				egovMessageSource.getMessage("ezSystem.kyj2",locale));

		Row rowhead = sheet1.createRow(1);

		rowhead.createCell(0).setCellValue(egovMessageSource.getMessage("ezSystem.kyj1",locale));
		rowhead.createCell(1).setCellValue(egovMessageSource.getMessage("ezEmail.lsd04",locale));
		rowhead.createCell(2).setCellValue(egovMessageSource.getMessage("ezOrgan.t68",locale));
		rowhead.createCell(3).setCellValue(egovMessageSource.getMessage("ezOrgan.t69", locale).trim());
		rowhead.createCell(4).setCellValue(egovMessageSource.getMessage("ezOrgan.t1500", locale).trim());
		rowhead.createCell(5).setCellValue(egovMessageSource.getMessage("ezOrgan.t96", locale).trim());
		rowhead.createCell(6).setCellValue(egovMessageSource.getMessage("ezOrgan.t95", locale).trim());
		
		int i = 2;

		// 액셀 라이브러리가 지원하는 row수: 65536건
		for (OrganUserVO exportUser : exportUserlist) {
			Row newRow1 = sheet1.createRow(i);

			newRow1.createCell(0).setCellValue(i -1);
			newRow1.createCell(1).setCellValue(exportUser.getDisplayName() + "(" + exportUser.getCn() + ")");
			newRow1.createCell(2).setCellValue(exportUser.getDescription());
			newRow1.createCell(3).setCellValue(exportUser.getTitle());
			newRow1.createCell(4).setCellValue(exportUser.getExtensionAttribute10());
			newRow1.createCell(5).setCellValue(exportUser.getMobile());
			newRow1.createCell(6).setCellValue(exportUser.getTelephoneNumber());

			newRow1.getCell(0).setCellStyle(centerStyle2);
			newRow1.getCell(1).setCellStyle(centerStyle2);
			newRow1.getCell(2).setCellStyle(centerStyle2);
			newRow1.getCell(3).setCellStyle(centerStyle2);
			newRow1.getCell(4).setCellStyle(centerStyle2);
			newRow1.getCell(5).setCellStyle(centerStyle2);
			newRow1.getCell(6).setCellStyle(centerStyle2);

			i++;
		}

		sheet1.setColumnWidth(0, ((int)(5 * 1.14388)) * 256);
		sheet1.setColumnWidth(1, ((int)(20 * 1.14388)) * 256);
		sheet1.setColumnWidth(2, ((int)(25 * 1.14388)) * 256);
		sheet1.setColumnWidth(3, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(4, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(5, ((int)(25 * 1.14388)) * 256);
		sheet1.setColumnWidth(6, ((int)(25 * 1.14388)) * 256);

//		sheet1.autoSizeColumn(0);

		try {
			fileOut = new FileOutputStream(filePath);
			workbook.write(fileOut);
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			// 2023-05-16 이사라 : NullPointerException 시큐어코딩
			//fileOut.close();
			IOUtils.closeQuietly(fileOut);
			workbook.close();
		}
		logger.debug("createExcelTotalUsers end");
		
		return fileName;
	}

	@Override
	public String setTitle(String type, String cn, String displayName, String displayName2, String useFlag, int sort, String companyID, int tenantID) throws Exception {
		logger.debug("setTitle started.");
		
		String rtnVal = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_CN", cn);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_USEFLAG", useFlag);
		map.put("v_SORT", sort);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		try {
			ezOrganAdminDao.setTitle(map);
			rtnVal = "TRUE";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			rtnVal = "FALSE";
		}
		
		logger.debug("setTitle ended. result = " + rtnVal);
		return rtnVal;
	}
	
	/**
	 * tbl_user_jobmaster - jobID로 직위/직책 조회
	 */
	@Override 
	public OrganJobVO getTitleByJobID(String jobID, String lang, int tenantID) throws Exception {
		logger.debug("getTitleByJobID started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_JOBID", jobID);
		map.put("v_LANGDATA", lang);
		map.put("v_TENANTID", tenantID);
		
		OrganJobVO jobVO = ezOrganAdminDao.getTitleByJobID(map);
		
		logger.debug("getTitleByJobID ended.");
		return jobVO;
	}
	
	@Override
	public String getTitleList(String type, String companyID, int tenantID) throws Exception {
		logger.debug("getTitlePageList started.");

		StringBuffer rtnVal = new StringBuffer();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		List<OrganJobVO> jobList = ezOrganAdminDao.getTitleList(map);
		
		int totalCnt = ezOrganAdminDao.getTitleListCnt(map);
		
		rtnVal.append("<LISTVIEWDATA>");
		rtnVal.append("<TOTALCOUNT>" + totalCnt + "</TOTALCOUNT>");
		rtnVal.append("<ROWS>");
		
		if (jobList != null && jobList.size() > 0) {
			for (int i = 0; i < jobList.size(); i++) {
				rtnVal.append("<ROW>");
				rtnVal.append("<CELL><VALUE><![CDATA[" + jobList.get(i).getDisplayName() + "]]></VALUE>");
				rtnVal.append("<DATA1>" + jobList.get(i).getJobID() + "</DATA1>");
				rtnVal.append("<DATA2>" + jobList.get(i).getType()  + "</DATA2>");
				rtnVal.append("<DATA3>" + jobList.get(i).getSort()  + "</DATA3>");
				rtnVal.append("<DATA4><![CDATA[" + jobList.get(i).getCompanyID() + "]]></DATA4></CELL>");
				rtnVal.append("<CELL><VALUE><![CDATA[" + jobList.get(i).getDisplayName2() + "]]></VALUE></CELL>");
				rtnVal.append("<CELL><VALUE>" + jobList.get(i).getSort() + "</VALUE></CELL>");
				rtnVal.append("<CELL><VALUE>" + jobList.get(i).getUseFlag() + "</VALUE></CELL>");
				rtnVal.append("</ROW>");
			}
		}
		
		rtnVal.append("</ROWS></LISTVIEWDATA>");
		
		logger.debug("getTitlePageList ended.");
		
		return rtnVal.toString();
	}
	
	@Override
	public String getTitleInfo(String type, String jobID, String companyID, int tenantID) throws Exception {
		logger.debug("getTitleInfo started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_JOBID", jobID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);

		OrganJobVO vo =  ezOrganAdminDao.getTitleInfo(map);
		
		StringBuffer rtnVal = new StringBuffer();
		if (vo != null) {
			rtnVal.append("<DATA>");
			rtnVal.append("<JOBID>" + vo.getJobID() + "</JOBID>");
			rtnVal.append("<TYPE>" + vo.getType() + "</TYPE>");
			rtnVal.append("<DISPLAYNAME><![CDATA[" + vo.getDisplayName() + "]]></DISPLAYNAME>");
			rtnVal.append("<DISPLAYNAME2><![CDATA[" + vo.getDisplayName2() + "]]></DISPLAYNAME2>");
			rtnVal.append("<USEFLAG>" + vo.getUseFlag() + "</USEFLAG>");
			rtnVal.append("<SORT>" + vo.getSort() + "</SORT>");
			rtnVal.append("<CREATEDATE>" + vo.getCreateDate() + "</CREATEDATE>");
			rtnVal.append("</DATA>");
		} else {
			rtnVal.append("<DATA></DATA>");
		}
		
		logger.debug("getTitleInfo ended.");
		return rtnVal.toString();
	}
	
	@Override
	public String updateTitle(String type, String jobID, String displayName, String displayName2, String useFlag, int sort, String companyID, int tenantID) throws Exception {
		logger.debug("updateTitle started.");
		
		String rtnVal = "";

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_JOBID", jobID);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_USEFLAG", useFlag);
		map.put("v_SORT", sort);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		map.put("nowDate", nowDate);
		
		try {
			ezOrganAdminDao.updateTitle(map);	//TBL_USER_JOBMASTER
			ezOrganAdminDao.updateTitle2(map);	//TBL_USERMASTER
			ezOrganAdminDao.updateTitle3(map);	//TBL_ADDJOBMASTER
			rtnVal = "TRUE";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			rtnVal = "FALSE";
		}
		
		logger.debug("updateTitle ended. result = " + rtnVal);
		return rtnVal;
	}

	@Override
	public String deleteTitle(String type, String jobIDList, String companyID, int tenantID) throws Exception {
		logger.debug("deleteTitle started.");
		
		String rtnVal = "";
		
		try {
			for (String jobID : jobIDList.split(";")) {
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("v_TYPE", type);
				map.put("v_JOBID", jobID);
				map.put("v_COMPANYID", companyID);
				map.put("v_TENANTID", tenantID);
				
				ezOrganAdminDao.deleteTitle(map);
			}
			
			rtnVal = "TRUE";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			rtnVal = "FALSE";
		}
		
		logger.debug("deleteTitle ended. result = " + rtnVal);
		return rtnVal;
	}

	@Override
	public String getTitleUserList(String type, String jobID, String pageSize, String pageNum, String searchType, String searchValue, String primary, String companyID, int tenantID) throws Exception {
		logger.debug("getTitleUserList started.");

		StringBuffer rtnVal = new StringBuffer();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_JOBID", jobID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		if (!pageNum.equals("") && !pageSize.equals("")) {
			int pPageSize = Integer.parseInt(pageSize);
			int pPageNum = Integer.parseInt(pageNum);
			pPageNum = (pPageNum * pPageSize) - pPageSize;
			
			logger.debug("getTitleUserList pageSize : " + pPageSize + " pageNum : " + pPageNum);
			
			map.put("v_PAGESIZE", pPageSize);
			map.put("v_PAGENUM", pPageNum);
		}
		
		if (!searchType.equals("") && !searchValue.equals("")) {
			StringBuffer sb = new StringBuffer();
			
			if (searchType.equals("displayname")) {
				if (primary.equals("1")) {
					if (globals.getProperty("Globals.DbType").equals("oracle")) {
		            	sb.append("DISPLAYNAME LIKE '%" + searchValue.trim() + "%' ESCAPE '\\' " );
		            } else {
		            	sb.append("DISPLAYNAME LIKE '%" + searchValue.trim() + "%'");
		            }
				} else {
					if (globals.getProperty("Globals.DbType").equals("oracle")) {
						sb.append("DISPLAYNAME2 LIKE '%" + searchValue.trim() + "%' ESCAPE '\\' ");
					} else{
						sb.append("DISPLAYNAME2 LIKE '%" + searchValue.trim() + "%'");
					}
				}
			}
			
			map.put("v_SUBQUERY", "WHERE " + sb.toString());
		}
		
		List<OrganUserVO> userList = ezOrganAdminDao.getTitleUserList(map);
		
		int totalCnt = ezOrganAdminDao.getTitleUserListCnt2(map);
		
		if (userList != null && userList.size() > 0) {
			rtnVal.append("<LISTVIEWDATA>");
			rtnVal.append("<TOTALCOUNT>" + totalCnt + "</TOTALCOUNT>");
			rtnVal.append("<ROWS>");
			for (int i = 0; i < userList.size(); i++) {
				rtnVal.append("<ROW>");
				rtnVal.append("<CELL><VALUE><![CDATA["+ userList.get(i).getCn() +"]]></VALUE>");
				rtnVal.append("<DATA1><![CDATA["+ userList.get(i).getDepartment() +"]]></DATA1>");
				rtnVal.append("<DATA2><![CDATA["+ userList.get(i).getDescription() +"]]></DATA2>");
				rtnVal.append("<DATA3><![CDATA["+ userList.get(i).getDescription2() +"]]></DATA3>");
				rtnVal.append("<DATA4><![CDATA["+ userList.get(i).getCn() +"]]></DATA4>");
				rtnVal.append("<DATA5><![CDATA["+ userList.get(i).getUserType() +"]]></DATA5></CELL>");
				if (primary.equals("1")) {
					rtnVal.append("<CELL><VALUE><![CDATA["+ userList.get(i).getDisplayName() +"]]></VALUE></CELL>");
					rtnVal.append("<CELL><VALUE><![CDATA["+ userList.get(i).getDescription() +"]]></VALUE></CELL>");
					rtnVal.append("<CELL><VALUE><![CDATA["+ userList.get(i).getTitle() +"]]></VALUE></CELL>");
				} else {
					rtnVal.append("<CELL><VALUE><![CDATA["+ userList.get(i).getDisplayName2() +"]]></VALUE></CELL>");
					rtnVal.append("<CELL><VALUE><![CDATA["+ userList.get(i).getDescription2() +"]]></VALUE></CELL>");
					rtnVal.append("<CELL><VALUE><![CDATA["+ userList.get(i).getTitle2() +"]]></VALUE></CELL>");
				}
				rtnVal.append("<CELL><VALUE><![CDATA["+ userList.get(i).getTelephoneNumber() +"]]></VALUE></CELL>");
				rtnVal.append("</ROW>");
			}
			rtnVal.append("</ROWS></LISTVIEWDATA>");
		} else {
			rtnVal.append("<LISTVIEWDATA><TOTALCOUNT>0</TOTALCOUNT><ROWS></ROWS></LISTVIEWDATA>");
		}
		
		logger.debug("getTitleUserList ended.");
		
		return rtnVal.toString();
	}
	
	@Override
	public int getTitleListCnt(String type, String companyID, int tenantID) throws Exception {
		logger.debug("getTitleListCnt started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		int rtnCnt = ezOrganAdminDao.getTitleListCnt(map);
		
		logger.debug("getTitleListCnt ended.");
		return rtnCnt;
	}
	
	@Override
	public int getTitleUserListCnt(String type, String jobID, String companyID, int tenantID) throws Exception {
		logger.debug("getTitleUserListCnt started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_JOBID", jobID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		int rtnCnt = ezOrganAdminDao.getTitleUserListCnt(map);
		
		logger.debug("getTitleUserListCnt ended.");
		return rtnCnt;
	}
	
	@Override
	public int getTitleCnt(String type, String jobID, String mode, String displayName, String displayName2, String companyID, int tenantID) throws Exception {
		logger.debug("getTitleCnt started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_JOBID", jobID);
		map.put("v_MODE", mode);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		int rtnCnt = ezOrganAdminDao.getTitleCnt(map);
		
		logger.debug("getTitleCnt ended.");
		return rtnCnt;
	}
	
	@Override
	public String getJobOptionInfo(String type, String companyID, int tenantID) throws Exception {
		logger.debug("getJobOptionInfo started. type = "+type);
		
		StringBuffer rtnVal = new StringBuffer();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		List<OrganJobVO> jobList = ezOrganAdminDao.getTitleList(map);
		
		if (jobList != null && jobList.size() > 0) {
			rtnVal.append("<DATA>");
			rtnVal.append("<TYPE>" + type + "</TYPE>");
			rtnVal.append("<ROWS>");
			for (int i = 0; i < jobList.size(); i++) {
				rtnVal.append("<ROW>");
				rtnVal.append("<SORT>" + jobList.get(i).getSort() + "</SORT>");
				rtnVal.append("<NAME1><![CDATA[" + jobList.get(i).getDisplayName() + "]]></NAME1>");
				rtnVal.append("<NAME2><![CDATA[" + jobList.get(i).getDisplayName2() + "]]></NAME2>");
				rtnVal.append("<JOBID>" + jobList.get(i).getJobID() + "</JOBID>");
				rtnVal.append("<USEFLAG>" + jobList.get(i).getUseFlag() + "</USEFLAG>");
				rtnVal.append("</ROW>");
			}			
			rtnVal.append("</ROWS></DATA>");
		} else {
			rtnVal.append("<DATA><ROWS></ROWS></DATA>");
		}
		
		logger.debug("getJobOptionInfo ended.");
		return rtnVal.toString();
	}

	@Override
	public void updateDBData_user_new(List<OrganUserVO> vo) throws Exception {
	
		logger.debug("updateDBData_user_new started");
		for(OrganUserVO userVO : vo) {
			if (userVO.getDisplayName2() == null || userVO.getDisplayName2().equals("")) {
				userVO.setDisplayName2(userVO.getDisplayName());
			}

			if (userVO.getTitle2() == null || userVO.getTitle2().equals("")) {
				userVO.setTitle2(userVO.getTitle());
			}

			if (userVO.getExtensionAttribute102() == null || userVO.getExtensionAttribute102().equals("")) {
				userVO.setExtensionAttribute102(userVO.getExtensionAttribute10());
			}
			ezOrganAdminDao.updateDBData_user(userVO);
		}
		logger.debug("updateDBData_user_new ended");
	}

	@Override
	public int getAddJobCount(String companyID, String searchType, String searchValue, int tenantId, String strLang) throws Exception {
		logger.debug("getAddJobCount started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_COMPANYID", companyID);
		map.put("v_TENANT_ID", tenantId);
		map.put("strLang", strLang);
		map.put("searchType", searchType);
		map.put("searchValue", searchValue);

		logger.debug("getAddJobCount ended");
		return ezOrganAdminDao.getAddJobCount(map);
	}

	public List<OrganUserVO> getAllUserCnList(int tenantID) throws Exception {
		return ezOrganAdminDao.getAllUserCnList(tenantID);
	}

	@Override
	public String getCompanyName(String displayName, int tenantID, String lang) throws Exception {
		logger.debug("getCompanyName started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_CN", displayName);
		map.put("v_TENANT_ID", tenantID);
		map.put("v_LANG", lang);

		String companyName = ezOrganAdminDao.getCompanyName(map);

		logger.debug("getCompanyName ended");
		return companyName;
	}
	
	private void deleteUserAddJob(String deptId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
    	map.put("v_DEPTID", deptId);
    	map.put("v_TENANT_ID", tenantId);
		
    	List<OrganUserVO> list = ezOrganAdminDao.getDeptAddJobUserList(map);
    	
    	for (OrganUserVO vo : list) {
    		String ext4 = vo.getExtensionAttribute4();
			String[] arr = ext4.split(";");
    		String newExt4 = "";
			
			for (String str : arr) {
				if (!str.startsWith(deptId + ":")) {
					if (newExt4.equals("")) {
						newExt4 = str;
					} else {
						newExt4 += ";" + str;
					}
				}
			}
			
			if (!newExt4.equals(ext4)) {
	    		updateProperty(vo.getCn(), "EXTENSIONATTRIBUTE4", newExt4, "user", tenantId);
			}
    	}
    }
	
	@Override
	public String insertPermissionGroup(String groupID, String groupName, String createID, String companyID, int tenantID, List<String> groupMemberList) throws Exception {
		logger.debug("insertPermissionGroup started");
		String result = "fail";
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_GROUP_ID", groupID);
		map.put("v_GROUP_NAME", groupName);
		map.put("v_CREATE_ID", createID);
		map.put("v_CREATE_DATE", nowDate);
		map.put("v_COMPANY_ID", companyID);
		map.put("v_TENANT_ID", tenantID);

		ezOrganAdminDao.setPermissionGroupList(map);
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		String memberID = "";
		String memberType = "";
		
		for (int i = 0; i < groupMemberList.size(); i++) {
			String sub_Dept_YN = "N";
			String memberCompanyID = "";
			
			memberID = groupMemberList.get(i).split(":")[0];
			memberType = groupMemberList.get(i).split(":")[1];

			if (memberType.equalsIgnoreCase("DEPT")) {
				sub_Dept_YN = groupMemberList.get(i).split(":")[2];
			} else if (memberType.equalsIgnoreCase("JIKWI") || memberType.equalsIgnoreCase("JIKCHEK")) {
				memberCompanyID = groupMemberList.get(i).split(":")[3];
			}
			
			map2.put("v_GROUP_ID", groupID);
			map2.put("v_MEMBER_ID", memberID);
			map2.put("v_MEMBER_TYPE", memberType);
			map2.put("v_MEMBER_COMPANYID", memberCompanyID);
			map2.put("v_ADDED_DATE", nowDate);
			map2.put("v_SUB_DEPT_YN", sub_Dept_YN);
			map2.put("v_COMPANY_ID", companyID);
			map2.put("v_TENANT_ID", tenantID);
			
			ezOrganAdminDao.setPermissionGroupInfo(map2);

		}
		
		result = "OK";

		logger.debug("insertPermissionGroup ended");
		return result;
	}
	
	@Override
	public String updatePermissionGroup(String groupID, String groupName, String updateID, String companyID, int tenantID, List<String> groupMemberList) throws Exception {
		logger.debug("updatePermissionGroup started");
		String result = "fail";

		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		Map<String, Object> map2 = new HashMap<String, Object>();

		map2.put("v_GROUP_ID", groupID);
		map2.put("v_COMPANY_ID", companyID);
		map2.put("v_TENANT_ID", tenantID);
		
		ezOrganAdminDao.deletePermissionGroupInfo(map2);
		
		Map<String, Object> map3 = new HashMap<String, Object>();
		String memberID = "";
		String memberType = "";

		for (int i = 0; i < groupMemberList.size(); i++) {
			String sub_Dept_YN = "N";
			String memberCompanyID = "";
			memberID = groupMemberList.get(i).split(":")[0];
			memberType = groupMemberList.get(i).split(":")[1];

			if (memberType.equalsIgnoreCase("DEPT")) {
				sub_Dept_YN = groupMemberList.get(i).split(":")[2];
			} else if (memberType.equalsIgnoreCase("JIKWI") || memberType.equalsIgnoreCase("JIKCHEK")) {
				memberCompanyID = groupMemberList.get(i).split(":")[3];
			}
			
			map3.put("v_GROUP_ID", groupID);
			map3.put("v_MEMBER_ID", memberID);
			map3.put("v_MEMBER_TYPE", memberType);
			map3.put("v_MEMBER_COMPANYID", memberCompanyID);
			map3.put("v_ADDED_DATE", nowDate);
			map3.put("v_SUB_DEPT_YN", sub_Dept_YN);
			map3.put("v_COMPANY_ID", companyID);
			map3.put("v_TENANT_ID", tenantID);
			
			ezOrganAdminDao.setPermissionGroupInfo(map3);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_GROUP_ID", groupID);
		map.put("v_GROUP_NAME", groupName);
		map.put("v_UPDATE_ID", updateID);
		map.put("v_UPDATE_DATE", nowDate);
		map.put("v_COMPANY_ID", companyID);
		map.put("v_TENANT_ID", tenantID);

		ezOrganAdminDao.updatePermissionGroupList(map);
		
		result = "OK";

		logger.debug("updatePermissionGroup ended");
		return result;
	}
	
    @Override
    public List<OrganLoginStopUserVO> getLoginStopUserList(int tenantID,int startPage, int maxItemPerPage, String keycode, String keyword, String stopFlag, String offset, String companyId) throws Exception {
    	logger.debug("getLoginStopUserList started");
    	
    	Map<String, Object> params = new HashMap<String, Object>();
    	
    	params.put("tenantID", tenantID);
		params.put("v_start", startPage);
		params.put("v_end",   startPage + maxItemPerPage - 1);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("stopFlag", stopFlag);
		params.put("offset", commonUtil.getMinuteUTC(offset));
		params.put("companyId", companyId);
		
    	List<OrganLoginStopUserVO> list = ezOrganAdminDao.getLoginStopUserList(params);
    	
    	logger.debug("getLoginStopUserList ended");
    	
    	return list;
    }

    @Override
    public int getLoginStopUserListCount(int tenantID, String keycode, String keyword, String stopFlag, String companyId) throws Exception {     
    	logger.debug("getLoginStopUserListCount started");
   		
    	Map<String, Object> params = new HashMap<String, Object>();
    	
    	params.put("tenantID", tenantID);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("stopFlag", stopFlag);
		params.put("companyId", companyId);
		
		int userCount = ezOrganAdminDao.getLoginStopUserListCount(params);
		
		logger.debug("getLoginStopUserListCount ended. userCount=" + userCount);
    	
		return userCount;
    }

	@Override
	public String insertStopUser(String[] cnArr, String companyID, int tenantID) throws Exception {
		logger.debug("insertStopUser started.");
		
		String rtnVal = "";

		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("tenantID", tenantID);
		map.put("cnArr", cnArr);
		map.put("nowDate", nowDate);
		
		try {
			ezOrganAdminDao.insertStopUser(map);
			rtnVal = "TRUE";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			rtnVal = "FALSE";
		}
		
		logger.debug("insertStopUser ended. result = " + rtnVal);
		return rtnVal;
	}
		
	
	@Override
	public int getPermissionGroupListCount(int tenantID, String searchKeycode, String searchKeyword, String companyID) throws Exception {
		logger.debug("getPermissionGroupListCount started");
   		logger.debug("searchKeycode=" + searchKeycode + ",searchKeyword=" + searchKeyword);

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("search_keycode", searchKeycode);
		map.put("search_keyword", searchKeyword);
		map.put("companyId", companyID);
		
		logger.debug("getPermissionGroupListCount ended");
		
		return ezOrganAdminDao.getPermissionGroupListCount(map);
	}
	
	@Override
	public List<OrganGroupVO> getPermissionGroupList(int pPage, int pPageRow, int tenantID, String offset, String searchKeycode, String searchKeyword, String searchCompanyID)	throws Exception {
        logger.debug("getPermissionGroupList started");
        logger.debug("pPage=" + pPage + ",pPageRow=" + pPageRow);
        logger.debug("tenantID=" + tenantID + ",offset=" + offset);
   		logger.debug("searchKeycode=" + searchKeycode + ",searchKeyword=" + searchKeyword);
   		logger.debug("searchCompanyID=" + searchCompanyID );

   		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("v_ROWPERPAGE", pPageRow);
		map.put("v_STARTROW", pPageRow*(pPage - 1));
		map.put("search_keycode", searchKeycode);
		map.put("search_keyword", searchKeyword);
		map.put("companyId", searchCompanyID);
				
		List<OrganGroupVO> retireList = ezOrganAdminDao.getPermissionGroupList(map);
		
        logger.debug("getPermissionGroupList ended");
		
		return retireList;
	}
	
	@Override
	public List<OrganGroupVO> getPermissionGroupInfo(String groupID, int tenantID, String companyID) throws Exception{
		logger.debug("getPermissionGroupList started");
   		logger.debug("companyID=" + companyID );

   		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_GROUP_ID", groupID);
		map.put("v_TENANT_ID", tenantID);
		
		if (!companyID.equals("")) {
			map.put("v_COMPANY_ID", companyID);
		}
				
		List<OrganGroupVO> retireList = ezOrganAdminDao.getPermissionGroupInfo(map);
		
        logger.debug("getPermissionGroupList ended");
		
		return retireList;
	}
	
	public void deletePermissionGroup(String groupList, String companyID, int tenantID) throws Exception{
		logger.debug("updatePermissionGroup started");
		String groupID[] = groupList.split(",");

		for (int i = 0; i < groupID.length; i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_GROUP_ID", groupID[i]);
			map.put("v_TENANT_ID", tenantID);
			map.put("v_COMPANY_ID", companyID);
			
			ezOrganAdminDao.deletePermissionGroupList(map);
		}
		
		logger.debug("updatePermissionGroup ended");
	}
	
	@Override
	public List<OrganGroupVO> getGroupList(int tenantID, String companyID) throws Exception{
		logger.debug("getGroupList started");
   		logger.debug("companyID=" + companyID );

   		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANY_ID", companyID);
				
		List<OrganGroupVO> retireList = ezOrganAdminDao.getGroupList(map);
		
        logger.debug("getGroupList ended");
		
		return retireList;
	}
	
	@Override
	public String getTitleList_group(String type, String companyID, int tenantID, String lang) throws Exception {
		logger.debug("getTitleList_group started.");

		StringBuffer rtnVal = new StringBuffer();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		List<OrganJobVO> jobList = ezOrganAdminDao.getTitleList_group(map);
		
		rtnVal.append("<LISTVIEWDATA>");
		rtnVal.append("<ROWS>");
		
		if (jobList != null && jobList.size() > 0) {
			for (int i = 0; i < jobList.size(); i++) {
				rtnVal.append("<ROW>");
				if (lang.equalsIgnoreCase("1")) {
					rtnVal.append("<CELL><VALUE><![CDATA[" + jobList.get(i).getDisplayName() + "]]></VALUE>");
				} else {
					rtnVal.append("<CELL><VALUE><![CDATA[" + jobList.get(i).getDisplayName2() + "]]></VALUE>");
				}
				rtnVal.append("<DATA1>" + jobList.get(i).getJobID() + "</DATA1>");
				rtnVal.append("<DATA2>" + jobList.get(i).getType()  + "</DATA2>");
				rtnVal.append("<DATA4><![CDATA[" + jobList.get(i).getCompanyID() + "]]></DATA4>");
				rtnVal.append("<DATA5><![CDATA[" + getCompanyName(jobList.get(i).getCompanyID(), tenantID, lang) + "]]></DATA5>");
				rtnVal.append("<DATA6><![CDATA[" + jobList.get(i).getDisplayName() + "]]></DATA6>");
				rtnVal.append("<DATA7><![CDATA[" + jobList.get(i).getDisplayName2() + "]]></DATA7></CELL>");
				rtnVal.append("</ROW>");
			}
		}
		
		rtnVal.append("</ROWS></LISTVIEWDATA>");
		
		logger.debug("getTitleList_group ended.");
		
		return rtnVal.toString();
	}
	
	@Override
	public OrganJobVO getTitleInfo_group(String type, String jobID, String companyID, int tenantID) throws Exception {
		logger.debug("getTitleInfo_group started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_JOBID", jobID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);

		OrganJobVO vo =  ezOrganAdminDao.getTitleInfo(map);
		
		logger.debug("getTitleInfo_group ended.");
		return vo;
	}
	
	// 관리자 > 조직도 > 엑셀내려받기 :사용자 목록
	@Override
	public List<OrganUserVO> getExportUserList(String primary, String companyId, int tenantId) throws Exception {
		logger.debug("getExportUserList start");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("primary",  primary);
		map.put("companyId",  companyId);
		map.put("tenantId",  tenantId);
		
		logger.debug("getExportUserList end");
		return ezOrganAdminDao.getExportUserList(map);
	}
	
	@Override
	public String createExcelUsers(String realPath, String dirPath, List<OrganUserVO> exportUserlist, String primary, Locale locale) throws Exception {
		logger.debug("createExcelUsers start");
		Date date                  = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String fileName            = egovMessageSource.getMessage("ezOrgan.t72", locale).trim() + "_" + formatter.format(date) + ".xlsx";
		String filePath            = dirPath + fileName;
		File file                  = new File(dirPath);
		File file2                 = new File(filePath);
		
		// temp 폴더가 없는 경우: 만들거나(mkdir), 폴더 안을 깨끗히 비운다.
		if (file == null || !file.exists()) {
			file.mkdirs();
		}
		else {
			FileUtils.cleanDirectory(file); 
		}
		
		// 같은 이름의 파일이 있을 경우: "파일(2).xlsx"으로 만든다.
		if (file2.exists()) {
			int pos         = fileName.lastIndexOf('.');
			String extend   = fileName.substring(pos + 1);
			String mainName = fileName.substring(0, pos);
			int k           = 1;
			fileName        = mainName + "(" + Integer.toString(k) + ")." + extend;
			filePath        = dirPath + fileName;
			file2           = new File(filePath);
			
			while (file2.exists()) {
				fileName = mainName + "(" + Integer.toString(++k) + ")." + extend;
				filePath = dirPath + fileName;
			}
		}
		
		// 엑셀 파일 생성(workbook). 시트 이름은(sheet1): "ezOrgan.t72"
		FileOutputStream fileOut = null;
		Workbook workbook = new XSSFWorkbook();
		
		Sheet sheet1 = workbook.createSheet(egovMessageSource.getMessage("ezOrgan.t72", locale).trim());
		sheet1.setDefaultRowHeight((short)500);
		
		//Set style
		CellStyle centerStyle = workbook.createCellStyle();
		centerStyle.setWrapText(false);
		centerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		centerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		
		CellStyle centerStyle2 = workbook.createCellStyle();
		centerStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		
		CellStyle centerStyle3 = workbook.createCellStyle();
		centerStyle3.setAlignment(CellStyle.ALIGN_LEFT);
		centerStyle3.setIndention((short)3);
		centerStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		
		//sheet1.setColumnWidth(0, 8 * 256);
		
		//Process first row
		Row rowhead1 = sheet1.createRow(0);
		
		rowhead1.createCell(0).setCellValue(egovMessageSource.getMessage("ezPersonal.t67", locale).trim());
		rowhead1.createCell(1).setCellValue(egovMessageSource.getMessage("ezOrgan.t68", locale).trim());
		rowhead1.createCell(2).setCellValue(egovMessageSource.getMessage("ezAttitude.t218", locale).trim());
		rowhead1.createCell(3).setCellValue(egovMessageSource.getMessage("ezOrgan.t67", locale).trim());
		rowhead1.createCell(4).setCellValue(egovMessageSource.getMessage("ezPersonal.t75", locale).trim());
		rowhead1.createCell(5).setCellValue(egovMessageSource.getMessage("ezOrgan.t69", locale).trim());
		rowhead1.createCell(6).setCellValue(egovMessageSource.getMessage("ezOrgan.t1500", locale).trim());
		
		rowhead1.getCell(0).setCellStyle(centerStyle);
		rowhead1.getCell(1).setCellStyle(centerStyle);
		rowhead1.getCell(2).setCellStyle(centerStyle);
		rowhead1.getCell(3).setCellStyle(centerStyle);
		rowhead1.getCell(4).setCellStyle(centerStyle);
		rowhead1.getCell(5).setCellStyle(centerStyle);
		rowhead1.getCell(6).setCellStyle(centerStyle);
		
		int i = 1;
		
		// 액셀 라이브러리가 지원하는 row수: 65536건
		for (OrganUserVO exportUser : exportUserlist) {
			Row newRow1 = sheet1.createRow(i);
			
			newRow1.createCell(0).setCellValue(exportUser.getCompany());
			newRow1.createCell(1).setCellValue(exportUser.getDescription());
			newRow1.createCell(2).setCellValue(exportUser.getCn());
			newRow1.createCell(3).setCellValue(exportUser.getDisplayName());
			newRow1.createCell(4).setCellValue(exportUser.getMail());
			newRow1.createCell(5).setCellValue(exportUser.getTitle());
			newRow1.createCell(6).setCellValue(exportUser.getExtensionAttribute10());
			
			newRow1.getCell(0).setCellStyle(centerStyle2);
			newRow1.getCell(1).setCellStyle(centerStyle2);
			newRow1.getCell(2).setCellStyle(centerStyle2);
			newRow1.getCell(3).setCellStyle(centerStyle2);
			newRow1.getCell(4).setCellStyle(centerStyle2);
			newRow1.getCell(5).setCellStyle(centerStyle2);
			newRow1.getCell(6).setCellStyle(centerStyle2);
			
			i++;
		}
		
		sheet1.setColumnWidth(0, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(1, ((int)(25 * 1.14388)) * 256);
		sheet1.setColumnWidth(2, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(3, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(4, ((int)(45 * 1.14388)) * 256);
		sheet1.setColumnWidth(5, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(6, ((int)(15 * 1.14388)) * 256);
		
//		sheet1.autoSizeColumn(0);
		
		try {
			fileOut = new FileOutputStream(filePath);
			workbook.write(fileOut);
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			// 2023-05-16 이사라 : NullPointerException 시큐어코딩
			//fileOut.close();
			IOUtils.closeQuietly(fileOut);
			workbook.close();
		}
		logger.debug("createExcelUsers end");
		return fileName;
	}

	@Override
	public void getExcelFile(String fileName, String realPath, String userAgent, HttpServletResponse response, int tenantId) throws Exception {
		String _fileName = CommonUtil.getEncodedFileNameForDownload(userAgent, fileName);
		String dirPath   = commonUtil.getUploadPath("upload_ezOrgan.ROOT", tenantId) + commonUtil.separator;
		dirPath          = realPath + dirPath + "temp" + commonUtil.separator;
		File file        = new File(dirPath + commonUtil.detectPathTraversal(fileName));
		
		if (!file.exists()) {
			throw new FileNotFoundException(fileName);
		}
	
		if (!file.isFile()) {
			throw new FileNotFoundException(fileName);
		}
		
		BufferedInputStream in = null;
		
		try {
			in              = new BufferedInputStream(new FileInputStream(file));
			String mimetype = "application/octet-stream";
			
			response.setBufferSize(2048);		// BUFF_SIZE: 2048 (extends EgovFileMngUtil) 
			response.setContentType(mimetype);
			response.setHeader("Content-Disposition", "attachment; filename=\"" + _fileName + "\"");
			response.setContentLength((int)file.length());
			
			FileCopyUtils.copy(in, response.getOutputStream());
		}
		finally {
			if (in != null) {
				try {
					in.close();
				} catch (Exception ignore) {
					logger.debug("IGNORED: {}", ignore.getMessage());
				}
			}
			
			try {
				file = new File(dirPath + fileName);
				file.delete();
			}
			catch (Exception e) {
				logger.error(e.getMessage(), e);
			}
		}
		
	}

	@Override
	public List<OrganGroupVO> getGroupListBoard(int tenantID, String companyID, String isAllGroupBoard) throws Exception{
		logger.debug("getGroupListBoard started");
   		logger.debug("companyID=" + companyID );

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANY_ID", companyID);
		map.put("isAllGroupBoard", isAllGroupBoard);
		
		/* 2019-10-22 홍승비 - 그룹사게시판이라면 기본적으로 top회사의 권한그룹과 자신이 소속한 회사의 권한그룹을 리턴 */
		List<OrganGroupVO> groupList = ezOrganAdminDao.getGroupListBoard(map);
		
        logger.debug("getGroupListBoard ended");
		
		return groupList;
	}
	
	/* 2019-09-25 홍승비 - 게시판 권한설정용 > 직위,직책 리스트 호출 시 다국어 이름도 함께 가져옴 */
	@Override
	public String getTitleListBoard(String type, String companyID, int tenantID, String lang) throws Exception {
		logger.debug("getTitleListBoard started.");

		StringBuffer rtnVal = new StringBuffer();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TYPE", type);
		map.put("v_COMPANYID", companyID); // 이 값이 없다면 모든 회사의 직위,직책을 가져온다. (그룹사게시판이라면 ""으로 전달됨)
		map.put("v_TENANTID", tenantID);
		
		List<OrganJobVO> jobList = ezOrganAdminDao.getTitleList_group(map);
		
		rtnVal.append("<LISTVIEWDATA>");
		rtnVal.append("<ROWS>");
		
		if (jobList != null && jobList.size() > 0) {
			for (int i = 0; i < jobList.size(); i++) {
				rtnVal.append("<ROW>");
				if (lang.equalsIgnoreCase("1")) {
					rtnVal.append("<CELL><VALUE><![CDATA[" + jobList.get(i).getDisplayName() + "]]></VALUE>");
				} else {
					rtnVal.append("<CELL><VALUE><![CDATA[" + jobList.get(i).getDisplayName2() + "]]></VALUE>");
				}
				rtnVal.append("<DATA1>" + jobList.get(i).getJobID() + "</DATA1>");
				rtnVal.append("<DATA2>" + jobList.get(i).getType()  + "</DATA2>");
				rtnVal.append("<DATA4><![CDATA[" + jobList.get(i).getCompanyID() + "]]></DATA4>");
				rtnVal.append("<DATA5><![CDATA[" + getCompanyName(jobList.get(i).getCompanyID(), tenantID, lang) + "]]></DATA5>");
				rtnVal.append("<DISPLAYNAME><![CDATA[" + jobList.get(i).getDisplayName() + "]]></DISPLAYNAME>");
				rtnVal.append("<DISPLAYNAME2><![CDATA[" + jobList.get(i).getDisplayName2() + "]]></DISPLAYNAME2>");
				rtnVal.append("</CELL></ROW>");
			}
		}
		
		rtnVal.append("</ROWS></LISTVIEWDATA>");
		
		logger.debug("getTitleListBoard ended.");
		
		return rtnVal.toString();
	}

	@Override
	public String deleteStopUser(String[] cnArr, String companyID, int tenantID) throws Exception {
		logger.debug("deleteStopUser started.");
		
		String rtnVal = "";

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("tenantID", tenantID);
		map.put("cnArr", cnArr);
		
		try {
			ezOrganAdminDao.deleteStopUser(map);
			rtnVal = "TRUE";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			rtnVal = "FALSE";
		}
		
		logger.debug("deleteStopUser ended. result = " + rtnVal);
		return rtnVal;
	}
	
	@Override
	public int checkStopUser(String userID, int tenantID) throws Exception {
		logger.debug("checkStopUser started.");
		
		int flag = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		try {
			flag = ezOrganAdminDao.checkStopUser(map);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("checkStopUser ended. result = " + flag);
		return flag;
	}
	
	private void deleteCompanyConfig(String compId, int tenantId) throws Exception {
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_CN", compId);
		map1.put("v_TENANT_ID", tenantId);
    	
		Map<String, Object> map2 = new HashMap<String, Object>(map1);
		map2.put("v_FIELD", "EXTENSIONATTRIBUTE2");
		
    	String extensionAttr2 = ezOrganDao.getPropertyValue_S5(map2);
    	logger.debug("companyID=" + compId + "extenstionAttr2=" + extensionAttr2);
    	
    	if (compId.equals(extensionAttr2)) { // 회사면
        	ezOrganAdminDao.deleteCompanyConfig(map1);    		
    	}
     }

	@Override
	public List<String> getNotUseMobileUserList(int tenantId) throws Exception {
		logger.debug("getNotUseMobileUserList started.");

		List<String> result = ezOrganAdminDao.getNotUseMobileUserList(tenantId);

		logger.debug("getNotUseMobileUserList ended.");
		return result;
	}
	
	@Override
	public List<String> getAutoDeleteOfRetireUserList(int tenantId, int days) throws Exception {
		logger.debug("getAutoDeleteOfRetireUserList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("v_days", days);

		List<String> result = ezOrganAdminDao.getAutoDeleteOfRetireUserList(map);

		logger.debug("getAutoDeleteOfRetireUserList ended.");
		return result;
	}

	@Override
	public void insertPermissionChHist(List<PermissionInfoVO> vo) throws Exception {
		logger.debug("insertPermissionChHist started");

		for (PermissionInfoVO userVO : vo) {
			ezOrganAdminDao.insertPermissionChHist(userVO);
		}

		logger.debug("insertPermissionChHist ended");
	}
	
	// 2023-08-24 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/부서별 권한 설정 옵션에 따른 권한 히스토리 삽입 메소드
	@Override
	public void insertPermissionChHistBasisDept(List<PermissionInfoVO> vo) throws Exception {
		logger.debug("insertPermissionChHistBasisDept started");

		for (PermissionInfoVO userVO : vo) {
			ezOrganAdminDao.insertPermissionChHistBasisDept(userVO);
		}

		logger.debug("insertPermissionChHistBasisDept ended");
	}
	
	// 2023-08-25 전인하 - 해당 유저가 원직인지 겸직인지 확인 메소드
	@Override
	public String isThisAddJob(String cn, int tenant_id, String deptId, String jobId) throws Exception {
		logger.debug("isThisAddJob started");
		
		HashMap<String, Object> map = new HashMap<String, Object>();

		map.put("v_CN", cn);
		map.put("v_DEPTID", deptId);
		map.put("v_TENANT_ID", tenant_id);
		map.put("v_JOBID", jobId);
		
		int tempVal = ezOrganAdminDao.isThisAddJob(map);

		logger.debug("isThisAddJob ended. isThisAddJob = " + tempVal);
		return tempVal > 0 ? "Y" : "N";
	}
	
	// 2023-07-31 전인하 - 관리자 > 조직도 > 권한관리 - 겸직/부서 별 권한 부여 옵션에 따른 권한 수정 메소드
	@Override
	public void updatePermissionBasisDept(List<OrganUserVO> vo) throws Exception {
		logger.debug("updatePermissionBasisDept started");
		for (OrganUserVO userVO : vo) {
			HashMap<String, Object> map = new HashMap<String, Object>();

			map.put("v_CN", userVO.getCn());
			map.put("v_DEPTID", userVO.getDepartment());
			map.put("v_TENANT_ID", userVO.getTenantId());
			map.put("v_JOBID", userVO.getJobID());
			map.put("v_PERMMSION", userVO.getExtensionAttribute1());
			
			String isThisAddJobFlag = isThisAddJob(userVO.getCn(), userVO.getTenantId(), userVO.getDepartment(), userVO.getJobID());
			
			if (isThisAddJobFlag.equals("N")) {
				ezOrganAdminDao.updatePermissionIntoUserMaster(map);
			} else {
				ezOrganAdminDao.updatePermissionIntoAddJobMaster(map);
			}
		}
		logger.debug("updatePermissionBasisDept ended");
	}

	@Override
	public OrganUserVO getUserDeptInfo(String cn, int tenantID) throws Exception {
		OrganUserVO userVO = new OrganUserVO();
		userVO.setCn(cn);
		userVO.setTenantId(tenantID);
		return ezOrganAdminDao.getUserDeptInfo(userVO);
	}

	@Override
	public OrganDeptVO getDeptDisplayNm(String cn, int tenantID) throws Exception {
		OrganDeptVO deptVO = new OrganDeptVO();
		deptVO.setCn(cn);
		deptVO.setTenantId(tenantID);
		return ezOrganAdminDao.getDeptDisplayNm(deptVO);
	}

	@Override
	public String getDeptParentCn(String cn, int tenantID) throws Exception {
		OrganDeptVO deptVO = new OrganDeptVO();
		deptVO.setCn(cn);
		deptVO.setTenantId(tenantID);
		return ezOrganAdminDao.getDeptParentCn(deptVO);
	}

	@Override
	public OrganUserVO getAddJobInfo(String cn, String deptId, String jobId, String roleId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<>();
		map.put("CN", cn);
		map.put("DEPTID", deptId);
		map.put("JOBID", jobId);
		map.put("ROLEID", roleId);
		map.put("TENANTID", tenantId);
		return ezOrganAdminDao.getAddJobInfo(map);
	}

	public List<OrganUserVO> getExportAddJobList(String primary, String companyId, int tenantId) throws Exception {
		logger.debug("getExportAddJobList started");

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("primary",  primary);
		map.put("companyId",  companyId);
		map.put("tenantId",  tenantId);

		logger.debug("getExportAddJobList ended");

		return ezOrganAdminDao.getExportAddJobList(map);
	}

	@Override
	public String createExcelAddJobList(String realPath, String dirPath, List<OrganUserVO> exportAddJobList, String primary, Locale locale) throws Exception {
		logger.debug("createExcelAddJobList start");

		Date date                  = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String fileName            = egovMessageSource.getMessage("ezOrgan.t00013", locale).trim() + "_" + formatter.format(date) + ".xlsx";
		String filePath            = dirPath + fileName;
		File file                  = new File(dirPath);
		File file2                 = new File(filePath);

		// temp 폴더가 없는 경우: 만들거나(mkdir), 폴더 안을 깨끗히 비운다.
		if (file == null || !file.exists()) {
			file.mkdirs();
		} else {
			FileUtils.cleanDirectory(file);
		}

		// 같은 이름의 파일이 있을 경우: "파일(2).xlsx"으로 만든다.
		if (file2.exists()) {
			int pos         = fileName.lastIndexOf('.');
			String extend   = fileName.substring(pos + 1);
			String mainName = fileName.substring(0, pos);
			int k           = 1;
			fileName        = mainName + "(" + Integer.toString(k) + ")." + extend;
			filePath        = dirPath + fileName;
			file2           = new File(filePath);

			while (file2.exists()) {
				fileName = mainName + "(" + Integer.toString(++k) + ")." + extend;
				filePath = dirPath + fileName;
			}
		}

		// 엑셀 파일 생성(workbook). 시트 이름은(sheet1): "ezOrgan.t00017"
		FileOutputStream fileOut = null;
		Workbook workbook = new XSSFWorkbook();

		Sheet sheet1 = workbook.createSheet(egovMessageSource.getMessage("ezOrgan.t00017", locale).trim()); // 겸직자 리스트
		sheet1.setDefaultRowHeight((short)500);

		//Set style
		CellStyle centerStyle = workbook.createCellStyle();
		centerStyle.setWrapText(false);
		centerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		centerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		CellStyle centerStyle2 = workbook.createCellStyle();
		centerStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		CellStyle centerStyle3 = workbook.createCellStyle();
		centerStyle3.setAlignment(CellStyle.ALIGN_LEFT);
		centerStyle3.setIndention((short)3);
		centerStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		//sheet1.setColumnWidth(0, 8 * 256);

		//Process first row 가장 위의 칼럼명 만들고
		Row rowhead1 = sheet1.createRow(0);

		rowhead1.createCell(0).setCellValue(egovMessageSource.getMessage("ezAttitude.t218", locale).trim()); // 아이디
		rowhead1.createCell(1).setCellValue(egovMessageSource.getMessage("ezOrgan.t67", locale).trim()); //이름
		rowhead1.createCell(2).setCellValue(egovMessageSource.getMessage("ezOrgan.t69", locale).trim()); // 직위 (원부서)
		rowhead1.createCell(3).setCellValue(egovMessageSource.getMessage("ezOrgan.t68", locale).trim()); // 원부서
		rowhead1.createCell(4).setCellValue(egovMessageSource.getMessage("ezOrgan.t123", locale).trim()); // 회사이름
		rowhead1.createCell(5).setCellValue(egovMessageSource.getMessage("ezOrgan.t9905", locale).trim()); // 겸직 부서명
		rowhead1.createCell(6).setCellValue(egovMessageSource.getMessage("ezOrgan.t69", locale).trim());  // 겸직 직위

		rowhead1.getCell(0).setCellStyle(centerStyle);
		rowhead1.getCell(1).setCellStyle(centerStyle);
		rowhead1.getCell(2).setCellStyle(centerStyle);
		rowhead1.getCell(3).setCellStyle(centerStyle);
		rowhead1.getCell(4).setCellStyle(centerStyle);
		rowhead1.getCell(5).setCellStyle(centerStyle);
		rowhead1.getCell(6).setCellStyle(centerStyle);

		int i = 1;

		// 액셀 라이브러리가 지원하는 row수: 65536건
		for (OrganUserVO exportAddJobInfo : exportAddJobList) {
			Row newRow1 = sheet1.createRow(i);

			newRow1.createCell(0).setCellValue(exportAddJobInfo.getCn());
			newRow1.createCell(1).setCellValue(exportAddJobInfo.getDisplayName());
			newRow1.createCell(2).setCellValue(exportAddJobInfo.getTitle());
			newRow1.createCell(3).setCellValue(exportAddJobInfo.getDescription());
			newRow1.createCell(4).setCellValue(exportAddJobInfo.getCompany());
			newRow1.createCell(5).setCellValue(exportAddJobInfo.getAddJobDeptNM());
			newRow1.createCell(6).setCellValue(exportAddJobInfo.getAddJobTitle());

			newRow1.getCell(0).setCellStyle(centerStyle2);
			newRow1.getCell(1).setCellStyle(centerStyle2);
			newRow1.getCell(2).setCellStyle(centerStyle2);
			newRow1.getCell(3).setCellStyle(centerStyle2);
			newRow1.getCell(4).setCellStyle(centerStyle2);
			newRow1.getCell(5).setCellStyle(centerStyle2);
			newRow1.getCell(6).setCellStyle(centerStyle2);

			i++;
		}

		sheet1.setColumnWidth(0, ((int)(25 * 1.14388)) * 256);
		sheet1.setColumnWidth(1, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(2, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(3, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(4, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(5, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(6, ((int)(15 * 1.14388)) * 256);
//		sheet1.autoSizeColumn(0);

		try {
			fileOut = new FileOutputStream(filePath);
			workbook.write(fileOut);
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			// 2023-05-16 이사라 : NullPointerException 시큐어코딩
			//fileOut.close();
			IOUtils.closeQuietly(fileOut);
			workbook.close();
		}
		logger.debug("createExcelAddJobList end");
		return fileName;
	}

	public List<OrganUserVO> getExportPermissionsList(String primary, String companyId, int tenantId) throws Exception {
		logger.debug("getExportPermissionsList started");

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("primary",  primary);
		map.put("companyId",  companyId);
		map.put("tenantId",  tenantId);

		logger.debug("getExportPermissionsList ended");

		return ezOrganAdminDao.getExportPermissionsList(map);
	}

	@Override
	public String createExcelPermissionsList(String realPath, String dirPath, List<OrganUserVO> exportPermissionList, String primary, Locale locale, boolean isRollC) throws Exception {
		logger.debug("createExcelPermissionsList start");

		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String fileName            = egovMessageSource.getMessage("ezOrgan.t00005", locale).trim() + "_" + formatter.format(date) + ".xlsx";
		String filePath            = dirPath + fileName;
		File file                  = new File(dirPath);
		File file2                 = new File(filePath);

		// temp 폴더가 없는 경우: 만들거나(mkdir), 폴더 안을 깨끗히 비운다.
		if (file == null || !file.exists()) {
			file.mkdirs();
		}
		else {
			FileUtils.cleanDirectory(file);
		}

		// 같은 이름의 파일이 있을 경우: "파일(2).xlsx"으로 만든다.
		if (file2.exists()) {
			int pos         = fileName.lastIndexOf('.');
			String extend   = fileName.substring(pos + 1);
			String mainName = fileName.substring(0, pos);
			int k           = 1;
			fileName        = mainName + "(" + Integer.toString(k) + ")." + extend;
			filePath        = dirPath + fileName;
			file2           = new File(filePath);

			while (file2.exists()) {
				fileName = mainName + "(" + Integer.toString(++k) + ")." + extend;
				filePath = dirPath + fileName;
			}
		}

		// 엑셀 파일 생성(workbook). 시트 이름은(sheet1): "ezOrgan.nj001"
		FileOutputStream fileOut = null;
		Workbook workbook = new XSSFWorkbook();

		Sheet sheet1 = workbook.createSheet(egovMessageSource.getMessage("ezOrgan.nj001", locale).trim()); // 시트명은 권한 리스트 - 시트는 하나만 생성한다.
		sheet1.setDefaultRowHeight((short)500);

		//Set style
		CellStyle centerStyle = workbook.createCellStyle();
		centerStyle.setWrapText(false);
		centerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		centerStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		CellStyle centerStyle2 = workbook.createCellStyle();
		centerStyle2.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

		CellStyle centerStyle3 = workbook.createCellStyle();
		centerStyle3.setAlignment(CellStyle.ALIGN_LEFT);
		centerStyle3.setIndention((short)3);
		centerStyle3.setVerticalAlignment(CellStyle.VERTICAL_CENTER); //중앙정렬

		//sheet1.setColumnWidth(0, 8 * 256);

		//Process first row 가장 위의 칼럼명 만들고
		Row rowhead1 = sheet1.createRow(0);

		//첫번째 행의 칼럼들을 순차적으로 만들어준다.
		rowhead1.createCell(0).setCellValue(egovMessageSource.getMessage("ezCabinet.t105", locale).trim());// 권한
		rowhead1.createCell(1).setCellValue(egovMessageSource.getMessage("ezOrgan.t218", locale).trim()); // 아이디
		rowhead1.createCell(2).setCellValue(egovMessageSource.getMessage("ezOrgan.t67", locale).trim()); // 이름
		rowhead1.createCell(3).setCellValue(egovMessageSource.getMessage("ezOrgan.t69", locale).trim()); // 직위
		rowhead1.createCell(4).setCellValue(egovMessageSource.getMessage("ezOrgan.t68", locale).trim()); // 부서
		rowhead1.createCell(5).setCellValue(egovMessageSource.getMessage("ezOrgan.t91", locale).trim()); // 메일주소
		rowhead1.createCell(6).setCellValue(egovMessageSource.getMessage("ezOrgan.t95", locale).trim());  // 회사전화
		rowhead1.createCell(7).setCellValue(egovMessageSource.getMessage("ezOrgan.t123", locale).trim());  // 회사이름

		// 첫번째 행의 칼럼들의 스타일을 만들어준다.
		rowhead1.getCell(0).setCellStyle(centerStyle);
		rowhead1.getCell(1).setCellStyle(centerStyle);
		rowhead1.getCell(2).setCellStyle(centerStyle);
		rowhead1.getCell(3).setCellStyle(centerStyle);
		rowhead1.getCell(4).setCellStyle(centerStyle);
		rowhead1.getCell(5).setCellStyle(centerStyle);
		rowhead1.getCell(6).setCellStyle(centerStyle);
		rowhead1.getCell(7).setCellStyle(centerStyle);

		int i = 1;

		String permission = "";

		// 액셀 라이브러리가 지원하는 row수: 65536건
		// 사용자의 권한을 타입별로 나눠준다 (전체관리자)
		if (isRollC) {
			for (OrganUserVO exportPermissionInfo : exportPermissionList) {
				Row newRow1 = sheet1.createRow(i);

				if (exportPermissionInfo.getExtensionAttribute1().contains("c=1")) {
					permission = egovMessageSource.getMessage("ezOrgan.t291", locale).trim();

					newRow1.createCell(0).setCellValue(permission); // 권한
					newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
					newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
					newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
					newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
					newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
					newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
					newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

					newRow1.getCell(0).setCellStyle(centerStyle2);
					newRow1.getCell(1).setCellStyle(centerStyle2);
					newRow1.getCell(2).setCellStyle(centerStyle2);
					newRow1.getCell(3).setCellStyle(centerStyle2);
					newRow1.getCell(4).setCellStyle(centerStyle2);
					newRow1.getCell(5).setCellStyle(centerStyle2);
					newRow1.getCell(6).setCellStyle(centerStyle2);
					newRow1.getCell(7).setCellStyle(centerStyle2);

					i++;
				}
			}
		}
		// 사용자의 권한을 타입별로 나눠준다 (회사관리자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("k=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.t293", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (부서관리자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("g=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.t295", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (수발신담당자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("a=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.t292", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (심사자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("i=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.t294", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (게시판관리자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("n=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.t297", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (설문관리자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("l=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.t296", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (업무담당자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("w=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.t301", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (기록물관리책임자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("m=1")) {
				permission = egovMessageSource.getMessage("ezApprovalG.t1753", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (결재조회관리자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("f=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.lhj1", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (웹폴더관리자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("wf=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.t303", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		// 사용자의 권한을 타입별로 나눠준다 (근태관리자)
		for (OrganUserVO exportPermissionInfo : exportPermissionList) {
			Row newRow1 = sheet1.createRow(i);

			if (exportPermissionInfo.getExtensionAttribute1().contains("e=1")) {
				permission = egovMessageSource.getMessage("ezOrgan.kbm01", locale).trim();

				newRow1.createCell(0).setCellValue(permission); // 권한
				newRow1.createCell(1).setCellValue(exportPermissionInfo.getCn()); // 아이디
				newRow1.createCell(2).setCellValue(exportPermissionInfo.getDisplayName()); // 이름
				newRow1.createCell(3).setCellValue(exportPermissionInfo.getTitle()); // 직위
				newRow1.createCell(4).setCellValue(exportPermissionInfo.getDescription()); // 부서
				newRow1.createCell(5).setCellValue(exportPermissionInfo.getMail()); // 메일
				newRow1.createCell(6).setCellValue(exportPermissionInfo.getTelephoneNumber()); // 회사전화
				newRow1.createCell(7).setCellValue(exportPermissionInfo.getCompany()); // 회사이름

				newRow1.getCell(0).setCellStyle(centerStyle2);
				newRow1.getCell(1).setCellStyle(centerStyle2);
				newRow1.getCell(2).setCellStyle(centerStyle2);
				newRow1.getCell(3).setCellStyle(centerStyle2);
				newRow1.getCell(4).setCellStyle(centerStyle2);
				newRow1.getCell(5).setCellStyle(centerStyle2);
				newRow1.getCell(6).setCellStyle(centerStyle2);
				newRow1.getCell(7).setCellStyle(centerStyle2);

				i++;
			}
		}

		sheet1.setColumnWidth(0, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(1, ((int)(25 * 1.14388)) * 256);
		sheet1.setColumnWidth(2, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(3, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(4, ((int)(15 * 1.14388)) * 256);
		sheet1.setColumnWidth(5, ((int)(45 * 1.14388)) * 256); // 메일란
		sheet1.setColumnWidth(6, ((int)(25 * 1.14388)) * 256);
		sheet1.setColumnWidth(7, ((int)(15 * 1.14388)) * 256);

//		sheet1.autoSizeColumn(0);

		try {
			fileOut = new FileOutputStream(filePath);
			workbook.write(fileOut);
		}
		catch (Exception e) {
			throw e;
		}
		finally {
			// 2023-05-16 이사라 : NullPointerException 시큐어코딩
			//fileOut.close();
			IOUtils.closeQuietly(fileOut);
			workbook.close();
		}
		logger.debug("createExcelPermissionsList end");
		return fileName;
	}

	@Override
	public int userJobCheck(String cn, String deptId, String jobId, String roleId, int tenantID) throws Exception {
		logger.debug("userJobCheck started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("CN", cn);
		map.put("DEPTID", deptId);
		map.put("JOBID", jobId);
		map.put("ROLEID",  Optional.ofNullable(roleId).filter(str -> !str.isEmpty()).orElse("0"));
		map.put("TENANT_ID", tenantID);

		logger.debug("userJobCheck ended");

		return ezOrganAdminDao.getUserJobCheckCount(map);
	}

	// 지정된 부서에 속한 퇴직자 수를 반환한다.
	@Override
	public int retireUserCountCheck(String cn, int tenantID) throws Exception {
		return ezOrganAdminDao.retireUserCountCheck(cn, tenantID);
	}

	@Override
	public Optional<String> getJobIdForFirstUser(String userId, int tenantId) throws Exception {
		List<OrganUserVO> allUserInfo = ezOrganService.getAllUserinfo(userId, tenantId);
		return Optional.ofNullable(allUserInfo.get(0).getJobID());
	}


	/**
	 * 일반적인 관리자의 관리 회사 리스트를 불러온다.
	 * @param id      the ID of the admin user
	 * @param tenantID the ID of the tenant
	 * @param primary  the primary parameter
	 * @return 전체관리자 - 모든 회사 리스트 / 회사관리자 - 권한이 있는 회사리스트
	 * @throws Exception if an error occurs while retrieving the company list
	 */
	public List<OrganDeptVO> getAdminCompanyList(String id, int tenantID, String primary, String deptId, String jobId) throws Exception {
		List<OrganDeptVO> list = getCompanyList(primary, tenantID);

		OrganAuth organAuth = commonUtil.makeOrganAuth(id, tenantID, deptId, jobId);

        if (!organAuth.isAuth(AdminAuth.ADMIN_MASTER, "")) {
            list.removeIf(vo -> !organAuth.isAuth(AdminAuth.COMPANY_MANAGER, vo.getCn()));
        }

        return list;
	}

	// 2024-05-27 관리자 > 조직도 > 겸직 사용자 상세정보 내용 호출 함수
	@Override
	public String getEntryAddJobInfo(String cn, String deptId, String language, String jobId, int tenantID, String prop) throws Exception {
		logger.debug("getEntryAddJobInfo started");

		String info="";
		StringBuilder sb = new StringBuilder();
		String[] propList = prop.split(";");
		String propValue = "";
		OrganAddJobVO propVO = new OrganAddJobVO();
		OrganDeptVO vo = new OrganDeptVO();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_DEPTID", deptId);
		map.put("v_JOBID", jobId);


		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("userID", deptId);
		map1.put("primary", language);
		map1.put("v_TENANT_ID", tenantID);
		try {
			propVO = ezOrganAdminDao.getAddJobPorpValue(map);
			vo = ezOrganDao.getDeptInfo(map1);
		} catch (NullPointerException e) {
			logger.debug("getAddJobPorpValue failed.");
			return "ERROR";
		}

		try {
			for (int i = 0; i < propList.length; i++) {
				switch(propList[i]) {
					case "title" :
						try {
							if ("1".equals(language)) {
								propValue = propVO.getTitle();
							} else {
								propValue = propVO.getTitle2();
							}
						} catch (NullPointerException e) {
							propValue = "";
						}
						propValue = propList[i] + ":" + propValue + "\\";
						break;
					case "role" :
						try {
							if ("1".equals(language)) {
								propValue = propVO.getRole();
							} else {
								propValue = propVO.getRole2();
							}
						} catch (NullPointerException e) {
							propValue = "";
						}
						propValue = propList[i] + ":" + propValue + "\\";
						break;

					case "userTreeFlag" :
						try {
							propValue = propVO.getUserTreeFlag();
						} catch (NullPointerException e) {
							propValue = "";
						}
						propValue = propList[i] + ":" + propValue + "\\";
						break;

					case "topMenuType" :
						try {
							propValue = propVO.getTopMenuType();
						} catch (NullPointerException e) {
							propValue = "";
						}
						propValue = propList[i] + ":" + propValue + "\\";
						break;
						
					case "orderBy" :
						try {
							propValue = propVO.getOrderBy();
						} catch (NullPointerException e) {
							propValue = "";
						}
						propValue = propList[i] + ":" + propValue + "\\";
						break;
					case "deptName" :
						try {
							propValue = vo.getDisplayName1();
						} catch (NullPointerException e) {
							propValue = "";
						}
						propValue = propList[i] + ":" + propValue + "\\";
						break;
					case "deptName2" :
						try {
							propValue = vo.getDisplayName2();
						} catch (NullPointerException e) {
							propValue = "";
						}
						propValue = propList[i] + ":" + propValue + "\\";
						break;
					default :
						map.put("v_FIELD", propList[i]);
						propValue = ezOrganDao.getPropertyValue_S4(map);
						propValue = propValue == null ? "" : propValue;
						propValue = propList[i] + ":" + propValue + "\\";

						break;
				}

				sb.append(propValue);
				continue;
			}

		} catch (Exception e) {
			logger.debug("getEntryAddJobInfo failed.");
			return "ERROR";
		}

		info = sb.toString();
		info = info.substring(0, info.length() - 1); // 마지막 "\"는 제거

		logger.debug("getEntryAddJobInfo ended");
		return info;
	}

	@Override
	public void updateAddJobInfo(String cn, String deptId, String jobId, int tenantID, String orderBy, String userTreeFlag)throws Exception {
		logger.debug("updateDBData_user started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CN", cn);
		map.put("v_DEPTID", deptId);
		map.put("v_JOBID", jobId);
		map.put("v_TENANTID", tenantID);
		map.put("v_ORDERBY", orderBy);
		map.put("v_USERTREEFLAG", userTreeFlag);
		
		ezOrganAdminDao.updateAddJobInfo(map);
		
		logger.debug("updateDBData_user ended");
	}
}
