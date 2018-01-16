package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
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
		map.put("fileExt", fileVO.getFileExt());
		map.put("fileFavourite", fileVO.getFileFavourite());
		map.put("uploaderId", fileVO.getUploaderId());
		map.put("uploaderName", fileVO.getUploaderName());
		map.put("createdDate", fileVO.getCreatedDate());
		map.put("updatedDate", fileVO.getUpdatedDate());
		map.put("folderId", fileVO.getFolderId());
		map.put("tenantId", fileVO.getTenantId());

		ezWebFolderDAO.insertFile(map);
	}

	@Override
	public String getFileIconFromExt(String ext, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("extension", ext);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileIconFromExt(map);
	}

	@Override
	public FileVO getFileByFileId(String fileId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileByFileId(map);
	}

}
