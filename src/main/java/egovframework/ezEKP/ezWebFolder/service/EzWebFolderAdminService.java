package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;

import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;

public interface EzWebFolderAdminService {
	void saveConfig(String personalLimit, String uploadLimit, String companyId, int tenantId) throws Exception;
	WebfolderConfigVO getWebfolderConfig(String companyId, int tenantId) throws Exception;
	List<UserCapacityVO> getListUserCapacity(String companyId, int tenantId, String primary) throws Exception;
}
