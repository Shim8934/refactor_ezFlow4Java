package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderAdminDAO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderAdminService;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;

@Service("EzWebFolderAdminService")
public class EzWebFolderAdminServiceImpl implements EzWebFolderAdminService {
	@Resource(name = "EzWebFolderAdminDAO")
	private EzWebFolderAdminDAO ezWebFolderAdminDAO;
	
	@Override
	public void saveConfig(String personalLimit, String uploadLimit, String companyId, int tenantId) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("personalLimit", personalLimit);
		map.put("uploadLimit", uploadLimit);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		ezWebFolderAdminDAO.saveConfig(map);
	}

	@Override
	public WebfolderConfigVO getWebfolderConfig(String companyId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		return ezWebFolderAdminDAO.getWebfolderConfig(map);
	}

	@Override
	public List<UserCapacityVO> getListUserCapacity(String companyId, int tenantId, String primary) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("primary", primary);
		return ezWebFolderAdminDAO.getListUserCapacity(map);
	}

}
