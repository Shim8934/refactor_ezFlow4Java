package egovframework.ezEKP.ezWebFolder.service;

import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;

public interface EzWebFolderService {
	String getFileSequence(int tenantId) throws Exception;
	void insertFile(FileVO fileVO) throws Exception;
	FileVO getFileByFileId(String string, int tenantId) throws Exception;
	FileTypeVO getFileTypeByFileExt(String extend, int tenantId) throws Exception;
	void deleteFileByFileId(String fileId, int tenantId) throws Exception;
	void updateFileUseStatus(String fileId, int tenantId) throws Exception;
	void updateFileName(String fileId, String newName, int tenantId) throws Exception;
}
