package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService")
public class EzWebFolderServiceImpl implements EzWebFolderService {
	@Resource(name = "EzWebFolderDAO")
	private EzWebFolderDAO ezWebFolderDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
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
		map.put("createName1", fileVO.getCreateName1());
		map.put("createName2", fileVO.getCreateName2());
		map.put("createDate", fileVO.getCreateDate());
		map.put("updateId", fileVO.getUpdateId());
		map.put("updateDate", fileVO.getUpdateDate());		
		map.put("tenantId", fileVO.getTenantId());

		ezWebFolderDAO.insertFile(map);
	}

	@Override
	public FileVO getFileByFileId(String fileId, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
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

	@Override
	public String getFileLogSequence(int tenantId) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();		
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFileLogSequence(map);
	}

	@Override
	public FolderVO getFolderByFolderId(String folderId, String offset, int tenantId) throws Exception {		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getFolderByFolderId(map);
	}

	@Override
	public FolderSimpleVO getSimpleFolder(String folderId, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("primary", primary);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getSimpleSubFolder(map);
		
	}

	@Override
	public List<FolderSimpleVO> getAllSimpleSubFolders(String folderUpperId, String primary, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderUpper", folderUpperId);
		map.put("primary", primary);
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getAllSimpleSubFolders(map);		
	}

	@Override
	public FolderVO getCompanyFolderId(String companyId, String offset, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);		
		map.put("tenantId", tenantId);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		return ezWebFolderDAO.getCompanyFolderId(map);
	}

	@Override
	public void getAllSubDepts(FolderSimpleVO company, String primary, int tenantId, int mode) throws Exception {
		List<FolderSimpleVO> listSubSimpleFolders = getAllSimpleSubFolders(company.getFolderId(), primary, tenantId);
		
		if (listSubSimpleFolders.size() > 0) {			
			company.setListSubFolders(listSubSimpleFolders);
			company.setHasSubFolder(1);
			
			for (FolderSimpleVO subFolder: listSubSimpleFolders) {
				if (mode == 0) {
					getAllSubDepts(subFolder, primary, tenantId, mode);
				}
				else {
					List<FolderSimpleVO> subSimpleDepts = getAllSimpleSubFolders(subFolder.getFolderId(), primary, tenantId);
					if (subSimpleDepts.size() > 0) {
						subFolder.setHasSubFolder(1);
					}
					else {
						subFolder.setHasSubFolder(0);
					}
				}		
			}
		}
		else {
			company.setHasSubFolder(0);			
		}		
	}
	
	@Override
	public void updateDownCnt(String fileId, int tenantId) {		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);		
		map.put("tenantId", tenantId);		
		ezWebFolderDAO.updateDownCnt(map);
	}

}
