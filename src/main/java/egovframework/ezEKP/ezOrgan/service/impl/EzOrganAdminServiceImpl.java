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
		
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_CN", pCN);
		map.put("v_LANGDATA", pLangCode);
		
		vo = ezOrganAdminDao.getUserInfo(map);

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
            	
            	propinfo.append("<" + propname.toUpperCase() + ">" + field.get(vo) + "</" + propname.toUpperCase() + ">");            	            	            	                
            }
        }
        propinfo.append("</DATA>");
  
        return propinfo.toString();
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
	public void deleteDBData(String cn, String pClass) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CN", cn);
		map.put("v_CLASS", pClass);
		
		ezOrganAdminDao.deleteDBData(map);
	}	
	
	
}
