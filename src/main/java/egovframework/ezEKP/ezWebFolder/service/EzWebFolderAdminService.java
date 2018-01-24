package egovframework.ezEKP.ezWebFolder.service;

import java.util.List;

import egovframework.ezEKP.ezWebFolder.vo.FileLogVO;
import egovframework.ezEKP.ezWebFolder.vo.UserCapacityVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderConfigVO;

public interface EzWebFolderAdminService {
	void saveConfig(String personalLimit, String uploadLimit, String companyId, int tenantId) throws Exception;
	WebfolderConfigVO getWebfolderConfig(String companyId, int tenantId) throws Exception;
	List<UserCapacityVO> getListUserCapacity(String companyId, String searchStr, String searchOpt, int tenantId, String primary) throws Exception;
	void updateNewAmount(String userId, String newStorageValue, String companyId, int tenantId) throws Exception;
	List<FileLogVO> getListFileLogs(String companyId, String offset, int tenantId) throws Exception;
	void insertFileLog(FileLogVO fileLog) throws Exception;
}
