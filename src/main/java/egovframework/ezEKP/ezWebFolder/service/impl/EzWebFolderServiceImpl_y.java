package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import egovframework.ezEKP.ezWebFolder.web.EzWebFolderGWController_y;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService_y")
public class EzWebFolderServiceImpl_y implements EzWebFolderService_y {
	@Resource(name = "EzWebFolderDAO_y")
	private EzWebFolderDAO_y ezWebFolderDAO;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderServiceImpl_y.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	// fileList출력
	public List<FileVO> getFileList(String folderId,String folderType, int tenantId,
			String companyId, String searchExt, String searchFileName,
			String searchStartDate, String searchEndDate,
			String searchCreateName, String searchFileType,
			String searchPageCount, String searchListCount, int pStart , int pEnd) throws Exception {
		
		String parentId = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId",folderId);
		map.put("tenantId",tenantId);
		parentId = ezWebFolderDAO.getparentId (map);
		
		map.put("parentId", parentId);
		map.put("folderType",folderType);
		map.put("comId",companyId);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("searchPageCount", searchPageCount);
		map.put("searchListCount", searchListCount);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		
		List<FileVO> filevo = (List<FileVO>) ezWebFolderDAO.getFileList(map);
		return filevo;
	}
	
	// fileTotalCount
	public int getFileToTalCount (String folderId,String folderType, int tenantId,
			String companyId, String searchExt, String searchFileName,
			String searchStartDate, String searchEndDate,
			String searchCreateName, String searchFileType,
			String searchPageCount, String searchListCount, int pStart , int pEnd) throws Exception {
		
		String parentId = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId",folderId);
		map.put("tenantId",tenantId);
		parentId = ezWebFolderDAO.getparentId (map);
		
		map.put("parentId", parentId);
		map.put("folderType",folderType);
		map.put("comId",companyId);
		map.put("searchExt", searchExt);
		map.put("searchFileName", searchFileName);
		map.put("searchStartDate", searchStartDate);
		map.put("searchEndDate", searchEndDate);
		map.put("searchCreateName", searchCreateName);
		map.put("searchFileType", searchFileType);
		map.put("searchPageCount", searchPageCount);
		map.put("searchListCount", searchListCount);
		map.put("pStart", pStart);
		map.put("pEnd", pEnd);
		int totalCnt = ezWebFolderDAO.getFileTotalCount(map);
		System.out.println(totalCnt);
		String test_totalCnt = totalCnt+"";
		LOGGER.debug(test_totalCnt);
		
		return totalCnt;
	}
	
	@Override
	public List<Map<String, Object>> getFolderList(String admin, String userId,String deptId, String comId ,
			String folderId, String folderType, int tenantId) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("deptId", deptId);
		map.put("comId", comId);
		map.put("folderId", folderId);
		map.put("folderType", folderType);
		map.put("tenantId", tenantId);
		List<Map<String, Object>> folderList = new ArrayList<Map<String,Object>>();
		
		if ( folderType.equals("C")) {
			if (admin.equals("ad")) {
				folderList = ezWebFolderDAO.getFolderListAd(map);
			} else {
				folderList = ezWebFolderDAO.getFolderList(map);
			}
		}else if ( folderType.equals("D")) {
			// TODO: 부서폴더 다시해야함 
			folderList = ezWebFolderDAO.getFolderListDept(map);
		}else if ( folderType.equals("U")) {
			folderList = ezWebFolderDAO.getFolderListUser(map);
		}
		
//		System.out.println(folderList.get(0).get("id"));
		System.out.println(folderList.size());
		
		
		
		return folderList;
	}

	@Override
	public String insertFolder(String folderUppId, String folderType,
			String tenantId, String companyId) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public FolderVO getFolderDetail(String folderUppId, String folderType,
			int tenantId, String comId) {
		FolderVO uppFolder  = new FolderVO() ;
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("folderUppId", folderUppId);
		map.put("folderType", folderType);
		map.put("tenantId", tenantId);
		map.put("comId", comId);
		
		
		uppFolder = ezWebFolderDAO.getFolderDetail(map);
		return null;
	}
}
