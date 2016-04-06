package egovframework.ezEKP.ezOrgan.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezOrgan.dao.EzOrganAdminDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;

@Service("EzOrganAdminService")
public class EzOrganAdminServiceImpl implements EzOrganAdminService {
	
	@Autowired
	private EzOrganAdminDAO ezOrganAdminDao;
	
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
