package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;

@Service("EzWebFolderService")
public class EzWebFolderServiceImpl implements EzWebFolderService {
	@Resource(name = "EzWebFolderDAO")
	private EzWebFolderDAO ezWebFolderDAO;
	
	@Override
	public String getFileSequence(int tenantId) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();		
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileSequence(map);
	}

	@Override
	public void insertFile(FileVO fileVO) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();		
		map.put("fileId", fileVO.getFileId());		
		map.put("fileName", fileVO.getFileName());
		map.put("filePath", fileVO.getFilePath());
		map.put("fileSize", fileVO.getFileSize());
		map.put("typeId", fileVO.getTypeId());
		map.put("downloadCnt", fileVO.getDownloadCnt());
		map.put("fileExt", fileVO.getFileExt());
		map.put("folderId", fileVO.getFolderId());
		map.put("useStatus", fileVO.getUseStatus());
		map.put("createId", fileVO.getCreateId());
		map.put("createName", fileVO.getCreateName());
		map.put("createDate", fileVO.getCreateDate());
		map.put("updateId", fileVO.getUpdateId());
		map.put("updateDate", fileVO.getUpdateDate());		
		map.put("tenantId", fileVO.getTenantId());

		ezWebFolderDAO.insertFile(map);
	}

	@Override
	public FileVO getFileByFileId(String fileId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileByFileId(map);
	}

	@Override
	public FileTypeVO getFileTypeByFileExt(String extend, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("extension", extend);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileTypeByFileExt(map);
	}

	@Override
	public void deleteFileByFileId(String fileId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		ezWebFolderDAO.deleteFileByFileId(map);	
	}

	@Override
	public void updateFileUseStatus(String fileId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		ezWebFolderDAO.updateFileUseStatus(map);	
	}

	@Override
	public void updateFileName(String fileId, String newName, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("name", newName);
		map.put("tenantId", tenantId);
		ezWebFolderDAO.updateFileName(map);		
	}

	@Override
	public void moveFile(String fileId, String folderId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		ezWebFolderDAO.moveFile(map);		
	}

}
