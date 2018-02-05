package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO;
import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_y;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_y;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService_y")
public class EzWebFolderServiceImpl_y implements EzWebFolderService_y {
	@Resource(name = "EzWebFolderDAO_y")
	private EzWebFolderDAO_y ezWebFolderDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	public List<FileVO> getFileList(String folderId, int tenantId,
			String companyId, String searchExt, String searchFileName,
			String searchStartDate, String searchEndDate,
			String searchCreateName, String searchFileType,
			String searchPageCount, String searchListCount) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("folderId",folderId);
		map.put("tenantId",tenantId);
		map.put("companyId",companyId);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("searchPageCount", searchPageCount);
		map.put("searchListCount", searchListCount);
		
		List<FileVO> filevo = (List<FileVO>) ezWebFolderDAO.getFileList(map);
		
		return filevo;
	}
}
