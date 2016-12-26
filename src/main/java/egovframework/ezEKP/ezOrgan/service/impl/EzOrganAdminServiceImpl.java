package egovframework.ezEKP.ezOrgan.service.impl;

import java.lang.reflect.Field;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

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
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("lang", lang);
		map.put("tenantID", tenantID);
		
		return ezOrganAdminDao.getCompanyList(map);
	}
	
	@Override
	public List<OrganUserVO> getAddJobList(String companyID, String strLang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_COMPANYID", companyID);
		map.put("v_LANGDATA", strLang);
		
		return ezOrganAdminDao.getAddJobList(map);
	}

	@Override
	public List<OrganUserVO> getUserAddJobList(String cn, String strLang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_LANGDATA", strLang);
		
		return ezOrganAdminDao.getUserAddJobList(map);
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
		
		return ezOrganAdminDao.getPermissionList(map);
	}

	@Override
	public List<OrganUserVO> getRetireList(int pPage, int pPageRow, int tenantID)	throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("v_TENANT_ID", tenantID);
		map.put("v_PAGE", pPage);
		map.put("v_ROWPERPAGE", pPageRow);
		
		return ezOrganAdminDao.getRetireList(map);
	}

    @Override
    public List<OrganUserVO> getUserCnList(int tenantID) throws Exception {     
        return ezOrganAdminDao.getUserCnList(tenantID);
    }
	
	@Override
	public String getPropertyList(String pCN, String pPropList, String pLangCode, int tenantID) throws Exception {
		String propvalue = "";
		String DataType = "user";
		Object vo = null;
		StringBuilder propinfo = new StringBuilder("<DATA>");
		pLangCode = commonUtil.convertLangCode(pLangCode);
		
		vo = getUserInfo(pCN, pLangCode, tenantID);

		if(vo == null){
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("userID", pCN);
			map1.put("primary", pLangCode);
			map1.put("v_TENANT_ID", tenantID);
			
			vo = ezOrganDao.getDeptInfo(map1);
			DataType = "group";
		}
		
		pPropList = ezOrganService.convertAddandConvert(DataType, pPropList);
		String[] proplist = pPropList.split(";");
	
		for(String propname : proplist){
            if (ezOrganService.checkDBColum(propname.toUpperCase()) == false){
                propvalue = ezOrganService.getPropertyValue(pCN, propname, tenantID);
                propinfo.append("<" + propname.toUpperCase() + ">" + commonUtil.cleanValue(propvalue) + "</" + propname.toUpperCase() + ">");
            }else if (!propname.toUpperCase().equals("")){
            	Field field = vo.getClass().getDeclaredField(propname);
            	field.setAccessible(true);          	            		
            	
            	propinfo.append("<" + propname.toUpperCase() + ">" + (field.get(vo) != null ? commonUtil.cleanValue(String.valueOf(field.get(vo))) : "") + "</" + propname.toUpperCase() + ">");            	            	            	                
            }
        }
        propinfo.append("</DATA>");
  
        return propinfo.toString();
	}

	@Override
	public String moveEntry(String parentCn, String cn, String type, int tenantID) throws Exception {
		String result = "";
		
		if(parentCn.equals(cn)){
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
		
		return result;
	}
	
	@Override
	public void updateProperty(String cn, String column, String number, String pClass, int tenantID) throws Exception{
		String strFlag = "N";
		
		if(!pClass.equals("user")){
			if(column.toLowerCase().indexOf("displayname") != -1){
				strFlag = "Y";
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_CLASS", pClass);
		map.put("v_PROPNAME", column);
		map.put("v_PROPVALUE", number);
		map.put("v_FLAG", strFlag);
		
		ezOrganAdminDao.updateProperty(map);
	}

	public void moveDBData(String parentCn, String cn, String type, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_PARENTCN", parentCn);
		map.put("v_CN", cn);
		map.put("v_CLASS", type);
		
		ezOrganAdminDao.moveDBData(map);
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
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		
		ezOrganAdminDao.retireDBData(map);
	}	

	@Override
	public void updateDBData_user(OrganUserVO vo) throws Exception {
		ezOrganAdminDao.updateDBData_user(vo);
	}	

	@Override
	public int companyCheck(String cn) throws Exception {
		return ezOrganAdminDao.companyCheck(cn);
	}

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
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_PAGE", pPage);
		map.put("v_ROWPERPAGE", pPageRow);
		
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
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_DISPLAYNAME", displayName);
		map.put("v_DISPLAYNAME2", displayName2);
		map.put("v_MAIL", mailAddr);
		map.put("v_PARENTCN", parentCn);
		map.put("v_LDAPPATH", ldapPath);
		
		ezOrganAdminDao.insertDBData_company(map);
	}

	@Override
	public void insertDBData_dept(OrganDeptVO vo) throws Exception {
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
		
		ezOrganAdminDao.insertDBData_dept(map);
	}
	
	@Override
	public void insertDBData_user(OrganUserVO vo) throws Exception {
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
		map.put("v_EXTATTR6", vo.getExtensionAttribute6());
		map.put("v_EXTATTR10", vo.getExtensionAttribute10());
		map.put("v_EXTATTR102", vo.getExtensionAttribute102());
		map.put("v_EXTATTR14", vo.getExtensionAttribute14());
		map.put("v_EXTATTR15", vo.getExtensionAttribute15());
		map.put("v_LDAPPATH", "");
		map.put("v_BIRTH", vo.getBirth());		
		map.put("v_BIRTHTYPE", vo.getBirthType());
		map.put("v_PASS", vo.getPassword());
		
		ezOrganAdminDao.insertDBData_user(map);
	}

	@Override
	public void updateDBData_dept(OrganDeptVO vo) throws Exception {
		ezOrganAdminDao.updateDBData_dept(vo);
	}

	@Override
	public void deleteDBData(String cn, String pClass, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
        map.put("v_TENANT_ID", tenantID);		
		map.put("v_CN", cn);
		map.put("v_CLASS", pClass);
		
		ezOrganAdminDao.deleteDBData(map);
	}

	@Override
	public OrganUserVO getUserInfo(String cn, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		
		map.put("v_TENANT_ID", tenantID);		
		map.put("v_CN", cn);
		map.put("v_LANGDATA", lang);		
		
		return ezOrganAdminDao.getUserInfo(map);
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
		String sTitle1 = "";
        String sTitle2 = "";
        String delFlag = "1";
        String pDeptID = "";
        
        if (!titleInfo.equals("")) {
            delFlag = "2";
            
            String domain = ezCommonService.getTenantConfig("DomainName", tenantID);
            
        	String[] addJobinfo = titleInfo.split(";");
        	
            for (int i = 0; i < addJobinfo.length; i++) {
            	String[] userInfo = addJobinfo[i].split(":");
            	pDeptID = userInfo[0];
            	if (userInfo.length > 2) {
            		sTitle1 = userInfo[1];
            	}
                
                sTitle2 = "";
                
                if (userInfo.length == 3) {
                    sTitle2 = userInfo[2];
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
            		map.put("v_DELFLAG", delFlag);
                    
            		try {
            		    ezOrganAdminDao.setAddJob(map);
            		} catch (Exception e) { // Exception이 발생하면 Group Email 주소로부터 취소 처리를 한다.
            		    ezEmailUserAdminService.updateGroupDel(groupAddr, mailAddr);
            		}
                }
            }
        }
	}

    @Override
    public void deleteJob(String userID, String titleInfo, int tenantID) throws Exception {
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
                
                if (rc == 0) { // updateGroupDel 성공
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
    }
    
	@Override
	public void restoreRetireEntry(String cn, String deptID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		
	    map.put("v_TENANT_ID", tenantID);
		map.put("v_CN", cn);
		map.put("v_PARENTCN", deptID);
		
		ezOrganAdminDao.restoreRetireEntry(map);
	}

	@Override
	public int userCountCheck(String cn, int tenantID) throws Exception {
		return  ezOrganAdminDao.userCountCheck(cn, tenantID);
	}
	
}
