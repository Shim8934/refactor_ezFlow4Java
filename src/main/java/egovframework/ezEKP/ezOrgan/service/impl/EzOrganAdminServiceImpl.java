package egovframework.ezEKP.ezOrgan.service.impl;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzOrganAdminService")
public class EzOrganAdminServiceImpl implements EzOrganAdminService {
	
	@Autowired
	private EzOrganService ezOrganService;
	
	@Autowired
	private EzOrganDAO ezOrganDao;
		
	@Autowired
	private EzOrganAdminDAO ezOrganAdminDao;
	
	@Autowired	
	private CommonUtil commonUtil;
	
	@Override
	public String getPropertyList(String pCN, String pPropList, String pLangCode) throws Exception {
		String propvalue = "";
		String DataType = "user";
		Object vo = null;
		StringBuilder propinfo = new StringBuilder("<DATA>");
		pLangCode = commonUtil.convertLangCode(pLangCode);
		
		vo = getUserInfo(pCN, pLangCode);

		if(vo == null){
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("userID", pCN);
			map1.put("primary", pLangCode);
			
			vo = ezOrganDao.getDeptInfo(map1);
			DataType = "group";
		}
		
		pPropList = ezOrganService.convertAddandConvert(DataType, pPropList);
		String[] proplist = pPropList.split(";");
	
		for(String propname : proplist){
            if (ezOrganService.checkDBColum(propname.toUpperCase()) == false){
                propvalue = ezOrganService.getPropertyValue(pCN, propname);
                propinfo.append("<" + propname.toUpperCase() + ">" + propvalue + "</" + propname.toUpperCase() + ">");
            }else if (!propname.toUpperCase().equals("")){
            	Field field = vo.getClass().getDeclaredField(propname);
            	field.setAccessible(true);          	            		
            	
            	propinfo.append("<" + propname.toUpperCase() + ">" + (field.get(vo) != null ? field.get(vo) : "") + "</" + propname.toUpperCase() + ">");            	            	            	                
            }
        }
        propinfo.append("</DATA>");
  
        return propinfo.toString();
	}

	@Override
	public String moveEntry(String parentCn, String cn, String type) throws Exception {
		String result = "";
		
		if(parentCn.equals(cn)){
			result = "SAME";
		}else{
			moveDBData(parentCn, cn, type);
			result = "OK";
		}
		
		return result;
	}
	
	@Override
	public void updateProperty(String cn, String column, String number, String pClass) throws Exception{
		String strFlag = "N";
		
		if(!pClass.equals("user")){
			if(column.toLowerCase().indexOf("displayname") != -1){
				strFlag = "Y";
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CN", cn);
		map.put("v_CLASS", pClass);
		map.put("v_PROPNAME", column);
		map.put("v_PROPVALUE", number);
		map.put("v_FLAG", strFlag);
		
		ezOrganAdminDao.updateProperty(map);
	}

	public void moveDBData(String parentCn, String cn, String type) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PARENTCN", parentCn);
		map.put("v_CN", cn);
		map.put("v_CLASS", type);
		
		ezOrganAdminDao.moveDBData(map);
	}

	@Override
	public int companyCheck(String cn) throws Exception {
		return ezOrganAdminDao.companyCheck(cn);
	}

	@Override
	public int companyChildCheck(String cn) throws Exception {
		return ezOrganAdminDao.companyChildCheck(cn);
	}

	@Override
	public void insertDBData_company(String cn, String displayName,	String displayName2, String mailAddr, String parentCn, String ldapPath) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
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
	public void updateDBData_dept(OrganDeptVO vo) throws Exception {
		ezOrganAdminDao.updateDBData_dept(vo);
	}

	@Override
	public void deleteDBData(String cn, String pClass) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CN", cn);
		map.put("v_CLASS", pClass);
		
		ezOrganAdminDao.deleteDBData(map);
	}

	@Override
	public OrganUserVO getUserInfo(String cn, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		
		map.put("v_CN", cn);
		map.put("v_LANGDATA", lang);
		
		return ezOrganAdminDao.getUserInfo(map);
	}
	
	
	
	
}
