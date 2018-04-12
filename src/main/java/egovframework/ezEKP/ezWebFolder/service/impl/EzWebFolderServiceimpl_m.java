package egovframework.ezEKP.ezWebFolder.service.impl;

import java.io.File;
import java.io.FileNotFoundException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderFileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.TrashCanVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService_m")
public class EzWebFolderServiceimpl_m implements EzWebFolderService_m {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderServiceimpl_m.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzWebFolderDAO_m")
	private EzWebFolderDAO_m ezWebFolderDAO;
	
	@Autowired
	private EzWebFolderService ezWebFolderService;

	@Override
	public List<FolderFileVO> getShares(String companyId, String deptId, String userId, String startDate, String endDate, String fileExt, String fileName, String createName, String pageSize, String pageNum, String fileType, int tenantId, String type) throws Exception {
		LOGGER.debug("getShares in service");
		Map<String, Object> map = new HashMap<String, Object>();  
		map.put("companyId",  companyId);
		map.put("deptId",     deptId);
		map.put("userId",     userId);
		map.put("startDate",  startDate);
		map.put("endDate",    endDate);
		map.put("fileExt",    fileExt);
		map.put("fileName",   fileName);
		map.put("createName", createName);
		map.put("pageSize",   pageSize);
		map.put("pageNum",    pageNum);
		map.put("fileType",   fileType);
		map.put("tenantId",   tenantId);
		
		if(type.equals("GET")) {
			return ezWebFolderDAO.getShareGet(map);
		} else {
			return ezWebFolderDAO.getShareGive(map);
		}
		
	}
	
	@Override
	public int getShareSeq(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getShareSeq(map);
	}

	@Override
	public void insertShare(int seqId, String companyId, String userId, String userType, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("seqId",          seqId);
		map.put("companyId",      companyId);
		map.put("userId",         userId);
		map.put("userType",       userType);
		map.put("folderFileId",   folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("createId",       createId);
		map.put("tenantId",       tenantId);
		
		ezWebFolderDAO.insertShare(map);
	}

	@Override
	public void delShare(String companyId, String folderFileId, String folderFileType, String createId, int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyId",      companyId);
		map.put("folderFileId",   folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("createId",       createId);
		map.put("tenantId",       tenantId);
		
		ezWebFolderDAO.delShare(map);
	}

	public List<String> userDeptList(String userId, int tenantId)
			throws Exception {
		
		List<String> result = new ArrayList<String>();
		List<String> temp = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		String notInDept = "";
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		result = chiefDeptList(userId, tenantId);
		
		LOGGER.debug("result of chiefDeptList in userDeplist: " + result);
		
		if(result.size() >0) {
			notInDept = makeDeptString(result);
			
			LOGGER.debug("notInDept in userDeptList: " + notInDept);
			
			map.put("notInDept", notInDept);
		}
		
		temp = ezWebFolderDAO.userDeptList(map);
		result.addAll(temp);
		
		LOGGER.debug("userDeptList result: " + result);
		
		return result;
	}

	public List<String> chiefDeptPath(String userId, int tenantId)
			throws Exception {
		
		List<String> result = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		result = ezWebFolderDAO.chiefDeptPath(map);
		
		LOGGER.debug("chiefDeptPath result: " + result);
		
		return result;
	}
	
	public List<String> chiefDeptList(String userId, int tenantId)
			throws Exception {
		
		List<String> result = new ArrayList<String>();
		List<String> temp = new ArrayList<String>();
		List<String> path = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		String notInDept = "";
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		path = chiefDeptPath(userId, tenantId);
		
		if(path.size() >0) {
		
			for (int i = 0; i < path.size(); i++) {
				map.put("deptCdPath", path.get(i));
				map.put("notInDept", notInDept);
				
				LOGGER.debug("chiefDeptList map : " + map);
				
				temp = ezWebFolderDAO.chiefDeptList(map);
				
				LOGGER.debug("chiefDeptList temp: " + temp);
				
				if(temp.size() >0) {
					
					if(notInDept.isEmpty()) {
						notInDept = notInDept + makeDeptString(temp);
					} else {
						notInDept = notInDept + "," + makeDeptString(temp);
					}
				
				}
				
				result.addAll(temp);
			}

		}
				
		LOGGER.debug("chiefDeptList result: " + result);
		
		return result;
	}

	public String makeDeptString(List<String> deptList) {
		
		String result = "";
		
		for (int i = 0; i < deptList.size(); i++) {
			
			result = result + ",'" + deptList.get(i) + "'";
			
		}
		
		result = result.substring(1);
		
		LOGGER.debug("makeDeptString result: " + result);
		
		return result;
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getTrashCanList(String userId, String offset, int tenantId) throws Exception {
		LOGGER.debug("getTrashCanList Started.");
		LOGGER.debug("userId=" + userId + ",offset=" + offset + ",tenantId=" + tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("offset", offset);
		map.put("tenantId", tenantId);
		
		List<TrashCanVO> folderList = ezWebFolderDAO.getFolderList(map);
		List<TrashCanVO> fileList = ezWebFolderDAO.getFileList(map);
		List<TrashCanVO> trashCanList = new ArrayList<TrashCanVO>();
		
		JSONObject result = new JSONObject();
		int fileCnt = 0;
		int folderCnt = 0;
		
		if (folderList != null) {
			for (TrashCanVO folder : folderList) {
				if (folder != null) {
					FolderVO upperFolder = ezWebFolderService.getFolderByFolderId(folder.getFolderUpper(), offset, tenantId);
					
					if (upperFolder.getUseStatus().equals("Y")) {
						trashCanList.add(folder);
						folderCnt += 1;
					} 
				}
			}
		}
		
		if (fileList != null) {
			for (TrashCanVO file : fileList) {
					map.put("folderId", file.getFileFolderId());
					String folderPath = ezWebFolderDAO.getFolderPath(map);
					
					if (folderPath != null) {
						file.setTrashCanPath(folderPath);
					}
					
					FolderVO folder = ezWebFolderService.getFolderByFolderId(file.getFileFolderId(), offset, tenantId);
					
					if (folder != null && folder.getUseStatus().equals("Y")) {
						trashCanList.add(file);
						fileCnt += 1;
					}
			}
		}
		
		result.put("fileCnt", fileCnt);
		result.put("folderCnt", folderCnt);
		result.put("trashCanList", trashCanList);
		
		LOGGER.debug("result=" + result);
		LOGGER.debug("getTrashCanList ended.");
		return result;
	}

	@Override
	public List<TrashCanVO> getFolderList(String userId, String offset, int tenantId) throws Exception {
		LOGGER.debug("getFolderList Started.");
		LOGGER.debug("userId=" + userId + ",offset=" + offset + ",tenantId=" + tenantId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("offset", offset);
		map.put("tenantId", tenantId);

		List<TrashCanVO> folderList = ezWebFolderDAO.getFolderList(map); 
		
		LOGGER.debug("getFolderList ended.");
		return folderList;
	}

	@Override
	public List<TrashCanVO> getFileList(String userId, String offset, int tenantId) throws Exception {
		LOGGER.debug("getFileList Started.");
		LOGGER.debug("userId=" + userId + ",offset=" + offset + ",tenantId=" + tenantId);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("offset", offset);
		map.put("tenantId", tenantId);

		List<TrashCanVO> fileList = ezWebFolderDAO.getFileList(map); 
		
		LOGGER.debug("getFileList ended.");
		return fileList;
	}

	@Override
	public String getFolderPath(String folderId, int tenantId) throws Exception {
		LOGGER.debug("getFolderPath Started.");
		LOGGER.debug("folderId=" + folderId + ",tenantId=" + tenantId);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		
		String folderPath = ezWebFolderDAO.getFolderPath(map);
		
		LOGGER.debug("getFolderPath ended.");
		return folderPath;
	}

	@Override
	public void permanetDeleteSelectedFiles(String[] fileIDList, LoginVO userInfo, String realPath) throws Exception {
		LOGGER.debug("permanetDeleteSelectedFiles Started.");
		LOGGER.debug("fileIDList=" + fileIDList + ",userInfo=" + userInfo + ",realPath=" + realPath);
		
		String userName1 = userInfo.getDisplayName1();
		String userName2 = userInfo.getDisplayName2();
		String companyId = userInfo.getCompanyID();
		int tenantId     = userInfo.getTenantId();
		String offset    = userInfo.getOffset();
		String userId    = userInfo.getId();
		
		for (int i = 0; i < fileIDList.length; i++) {
			FileVO fileVO = ezWebFolderService.getFileByFileId(fileIDList[i], offset, tenantId);
			
			if (fileVO == null) {
				FolderVO folderVO = ezWebFolderService.getFolderByFolderId(fileIDList[i], offset, tenantId);
				updateFolderUseStatus(folderVO);
				updateStatusAllFilesInFolder(folderVO);
			} else {
				updateFileUseStatus(fileIDList[i], tenantId);
				ezWebFolderService.saveLog("P", companyId, offset, userId, userName1, userName2, fileVO.getFileName(), fileVO.getFileSize(), fileVO.getFileExt(), fileVO.getFileTypeName(), tenantId);
				realFileDelete(fileVO.getFileName(), realPath, userInfo);
			}
			
		}
		
	LOGGER.debug("permanetDeleteSelectedFiles ended");
	}

	@Override
	public void realFileDelete(String fileName, String realPath, LoginVO userInfo) throws Exception {
		LOGGER.debug("realFileDelete Started.");
		LOGGER.debug("fileName=" + fileName + ",realPath=" + realPath + ",uesrInfo=" + userInfo);
		
		String pDirPath = getWebFolderDirPath(userInfo.getTenantId());
		pDirPath = realPath + pDirPath;
		
		if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
			pDirPath = pDirPath + commonUtil.separator;
		}
		
		File file = new File(pDirPath + fileName);
		
		if (file.exists()) {
			if (file.delete()) {
				LOGGER.debug(fileName + "delete is success");
			} else {
				LOGGER.debug(fileName + "delete is fail");
			}
		} else {
			throw new FileNotFoundException(fileName);
		}
		
		LOGGER.debug("realFileDelete ended.");
	}
	
	@Override
	public void realFileDeleteInFolder(String folderPath, String companyId ,String realPath, LoginVO userInfo, String offset, int tenantId) throws Exception {
		LOGGER.debug("realFileDeleteInFolder Started.");
		LOGGER.debug("folderPath=" + folderPath + ",companyId=" + companyId + ",realPath=" + realPath + ",uesrInfo=" + userInfo);
		
		List<TrashCanVO> innerFolderList = getFolderByFolderPath(folderPath, tenantId, companyId);
		
		for (TrashCanVO innerfolder : innerFolderList) {
			List<TrashCanVO> innserFileList = getFileByFolderId(innerfolder.getTrashCanId(), tenantId, userInfo.getId());
			
			if (innserFileList != null) {
				for (TrashCanVO innerfile : innserFileList) {
					FileVO file = ezWebFolderService.getFileByFileId(innerfile.getTrashCanId(), offset, tenantId);
					ezWebFolderService.saveLog("P", companyId, offset, userInfo.getId(),userInfo.getDisplayName1(), userInfo.getDisplayName2(), innerfile.getTrashCanName(), String.valueOf(innerfile.getTrashCanSize()), innerfile.getTrashCanExt(), file.getFileTypeName(), tenantId);
					realFileDelete(innerfile.getTrashCanName(), realPath, userInfo);
				}
			}
		}
		
		LOGGER.debug("realFileDeleteInFolder ended.");
	}
	
	@Override
	public void updateFileUseStatus(String fileId, int tenantId) throws Exception {
		LOGGER.debug("updateFileUseStatus Started.");
		LOGGER.debug("fildId=" + fileId + ",tenantId=" + tenantId);

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("fileId", fileId);
		map.put("tenantId", tenantId);
		
		int result = ezWebFolderDAO.updateFileUseStatus(map);
		
		if (result > 0) {
			LOGGER.debug("updateFileUseStatus is success");
		} else {
			LOGGER.debug("updateFileUseStatus is fail");
		}
		
		LOGGER.debug("updateFileUseStatus ended.");
	}

	@Override
	public void updateFolderUseStatus(FolderVO folderVO) throws Exception {
		LOGGER.debug("updateFolderUseStatus Started.");
		LOGGER.debug("folderVO="  + folderVO);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderVO.getFolderPath());
		map.put("tenantId", folderVO.getTenantId());
		map.put("companyId", folderVO.getCompanyId());
		
		int result = ezWebFolderDAO.updateFolderUseStatus(map);
		
		if (result > 0) {
			LOGGER.debug("updateFolderUseStatus is success");
		} else {
			LOGGER.debug("updateFolderUseStatus is fail");
		}
		
		LOGGER.debug("updateFolderUseStatus ended.");
	}

	@Override
	public void updateStatusAllFilesInFolder(FolderVO folderVO) throws Exception {
		LOGGER.debug("updateStatusAllFilesInFolder Started.");
		LOGGER.debug("folderVO="  + folderVO);
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderVO.getFolderPath());
		map.put("tenantId", folderVO.getTenantId());
		map.put("companyId", folderVO.getCompanyId());
		
		int result = ezWebFolderDAO.updateStatusAllFilesInFolder(map);
		
		if (result > 0) {
			LOGGER.debug("updateFolderUseStatus is success");
		} else {
			LOGGER.debug("updateFolderUseStatus is fail");
		}
		
		LOGGER.debug("updateStatusAllFilesInFolder ended.");
	}

	@Override
	public List<TrashCanVO> getFileByFolderId(String folderId, int tenantId, String userId) throws Exception {
		LOGGER.debug("getFileByFolderId Started.");

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderId", folderId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		List<TrashCanVO> fileList = ezWebFolderDAO.getFileListByFolderId(map);
		
		LOGGER.debug("getFileByFolderId ended");
		return fileList;
	}

	@Override
	public List<TrashCanVO> getFolderByFolderPath(String folderPath, int tenantId, String companyId) throws Exception {
		LOGGER.debug("getFolderByFolderPath Started.");
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("folderPath", folderPath);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<TrashCanVO> folderList = ezWebFolderDAO.getFolderByFolderPath(map);
		
		LOGGER.debug("getFolderByFolderPath ended.");
		return folderList;
	}
	
	private String getWebFolderDirPath(int tenantId) {
		return commonUtil.separator + "fileroot" + commonUtil.separator + tenantId + commonUtil.separator + "webfolder" + commonUtil.separator;
	}
}
