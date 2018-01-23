package egovframework.ezEKP.ezWebFolder.service;

import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;

public interface EzWebFolderAdminService {
	void saveConfig(String personalLimit, String uploadLimit, String companyId, int tenantId) throws Exception;
	WebfolderConfigVO getWebfolderConfig(String companyId, int tenantId) throws Exception;
}
