package egovframework.ezEKP.ezWebFolder.service;

import egovframework.ezEKP.ezWebFolder.vo.FileVO;

public interface EzWebFolderService {
	String getFileSequence(int tenantId) throws Exception;
	void insertFile(FileVO fileVO) throws Exception;
	String getFileIconFromExt(String ext, int tenantId) throws Exception;
}
