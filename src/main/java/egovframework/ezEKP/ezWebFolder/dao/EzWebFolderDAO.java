package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezWebFolder.vo.DuplicateInfoVO;
import egovframework.ezEKP.ezWebFolder.vo.FileHistoryVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderEnvVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO")
public class EzWebFolderDAO extends EgovAbstractDAO {
	@Autowired
	private EzWebFolderDAO_m ezWebFolderDAO_m;

	public String getFileSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFileSequence", map);
	}

	public int insertFile(Map<String, Object> map) {
		int fileId = 0;
		if (map.get("fileId").equals("")){
			fileId = (int) insert("EzWebFolderDAO.insertFile", map);
		} else {
			map.put("fileId",    Integer.parseInt((String) map.get("fileId")));
			update("EzWebFolderDAO.updateFile", map);
			fileId = (int) map.get("fileId"); 
		}
		return fileId;
	}
	
	public void updateFileRoot(Map<String, Object> map) {
		update("EzWebFolderDAO.updateFileRoot", map);
	}

	public FileVO getFileByFileId(Map<String, Object> map) {
		return (FileVO)select("EzWebFolderDAO.getFileByFileId", map);
	}

	public FileTypeVO getFileTypeByFileExt(Map<String, Object> map) {
		return (FileTypeVO)select("EzWebFolderDAO.getFileTypeByFileExt", map);
	}

	public void deleteFileByFileId(Map<String, Object> map) {
		delete("EzWebFolderDAO.deleteFileByFileId", map);
	}

	public void updateFileUseStatus(Map<String, Object> map) {
		update("EzWebFolderDAO.updateFileUseStatus", map);
	}

	public void updateDownCnt(Map<String, Object> map) {
		update("EzWebFolderDAO.updateDownCnt", map);
	}

	public void updateFileName(Map<String, Object> map) {
		update("EzWebFolderDAO.updateFileName", map);
	}

	public void moveFile(Map<String, Object> map) {
		update("EzWebFolderDAO.moveFile", map);
	}

	public void moveRenameFile(Map<String, Object> map) {
		update("EzWebFolderDAO.moveRenameFile", map);
	}

	public String getFileLogSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFileLogSequence", map);
	}

	public FolderVO getFolderByFolderId(Map<String, Object> map) {
		return (FolderVO)select("EzWebFolderDAO.getFolderByFolderId", map);
	}

	public FolderSimpleVO getSimpleSubFolder(Map<String, Object> map) {
		return (FolderSimpleVO)select("EzWebFolderDAO.getSimpleSubFolder", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderSimpleVO> getAllSimpleSubFolders(Map<String, Object> map) {
		return (List<FolderSimpleVO>)list("EzWebFolderDAO.getAllSimpleSubFolders", map);
	}

	public FolderVO getRootFolderId(Map<String, Object> map) {
		return (FolderVO)select("EzWebFolderDAO.getRootFolderId", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderUserVO> getFolderUsers(Map<String, Object> map) {
		return (List<FolderUserVO>)list("EzWebFolderDAO.getFolderUsers", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderUserVO> getFileUsers(Map<String, Object> map) {
		return (List<FolderUserVO>)list("EzWebFolderDAO.getFileUsers", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getFolderDepts(Map<String, Object> map) {
		return (List<OrganDeptVO>)list("EzWebFolderDAO.getFolderDepts", map);
	}

	public String getFolderSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFolderSequence", map);
	}

	public String getMaxFolderStep(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getMaxFolderStep", map);
	}

	public String getFolderUserSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFolderUserSequence", map);
	}

	public void updateFolderUseStatus(Map<String, Object> map) {
		update("EzWebFolderDAO.updateFolderUseStatus", map);
	}
	
	public void updateSubFolderUseStatus(Map<String, Object> map) {
		update("EzWebFolderDAO.updateSubFolderUseStatus", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<DuplicateInfoVO> getAllDuplicateInfo(Map<String, Object> map) {
		return (List<DuplicateInfoVO>) list("EzWebFolderDAO.getAllDuplicateInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<DuplicateInfoVO> getAllDuplicateInfoForFile(Map<String, Object> map) {
		return (List<DuplicateInfoVO>) list("EzWebFolderDAO.getAllDuplicateInfoForFile", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<DuplicateInfoVO> getAllDuplicateInfoForFolder(Map<String, Object> map) {
		return (List<DuplicateInfoVO>) list("EzWebFolderDAO.getAllDuplicateInfoForFolder", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<FileVO> getAllFilesInFolder(Map<String, Object> map) {
		return (List<FileVO>)list("EzWebFolderDAO.getAllFilesInFolder", map);
	}

	public int getTotalFileCnt(Map<String, Object> map) {
		return (int)select("EzWebFolderDAO.getTotalFileCnt1", map);
	}

	@SuppressWarnings("unchecked")
	public List<FileVO> getAllFiles(Map<String, Object> map) {
		return (List<FileVO>)list("EzWebFolderDAO.getAllFiles", map);
	}

	public int getTotalFileCnt2(Map<String, Object> map) {
		return (int)select("EzWebFolderDAO.getTotalFileCnt2", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderVO> getAllSubFolders(Map<String, Object> map) {
		return (List<FolderVO>)list("EzWebFolderDAO.getAllSubFolders", map);
	}

	@SuppressWarnings("unchecked")
	public List<SimpleDeptVO> getAllSimpleDeptsOfCompany(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzWebFolderDAO.getAllSimpleDeptsOfCompany", map);
	}

	public SimpleDeptVO getSimpleCompany(Map<String, Object> map) {
		return (SimpleDeptVO)select("EzWebFolderDAO.getSimpleCompany", map);
	}

	@SuppressWarnings("unchecked")
	public List<SimpleDeptVO> getAllSimpleSubDepts(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzWebFolderDAO.getAllSimpleSubDepts", map);
	}

	public String getDeptPath(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getDeptPath", map);
	}

	@SuppressWarnings("unchecked")
	public List<SimpleUserVO> getDeptMemberList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzWebFolderDAO.getDeptMemberList", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderSimpleVO> getAllSimpleDeptFolder(Map<String, Object> map) {
		return (List<FolderSimpleVO>)list("EzWebFolderDAO.getAllSimpleDeptFolder", map);
	}

	@SuppressWarnings("unchecked")
	public List<OrganDeptVO> getAllDepartments(Map<String, Object> map) {
		return (List<OrganDeptVO>)list("EzWebFolderDAO.getAllDepartments", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderSimpleVO> getDeptFolderTreeForUser(Map<String, Object> map) {
		return (List<FolderSimpleVO>)list("EzWebFolderDAO.getDeptFolderTreeForUser", map);
	}

	public FolderSimpleVO getCompanySimpleFolder(Map<String, Object> map) {
		return (FolderSimpleVO)select("EzWebFolderDAO.getCompanySimpleFolder", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderSimpleVO> getCompanySubSimpleFolder(Map<String, Object> map) {
		return (List<FolderSimpleVO>)list("EzWebFolderDAO.getCompanySubSimpleFolder", map);
	}

	public FolderSimpleVO getUserSimpleFolder(Map<String, Object> map) {
		return (FolderSimpleVO)select("EzWebFolderDAO.getUserSimpleFolder", map);
	}

	public int checkDepartChief(Map<String, Object> map) {
		return (int)select("EzWebFolderDAO.checkDepartChief", map);
	}

	public WebfolderEnvVO getListCount(Map<String, Object> map) {
		return (WebfolderEnvVO)select("EzWebFolderDAO.getListCount", map);
	}

	public void updateListCount(Map<String, Object> map) {
		insert("EzWebFolderDAO.updateListCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<SimpleDeptVO> getAllDeptsForChief(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzWebFolderDAO.getAllDeptsForChief", map);
	}

	@SuppressWarnings("unchecked")
	public List<SimpleDeptVO> getSelectedDeptsForChief(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzWebFolderDAO.getSelectedDeptsForChief", map);
	}

	public void updateListDeptEnv(Map<String, Object> map) {
		insert("EzWebFolderDAO.updateListDeptEnv", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderSimpleVO> getDeptFolderTreeForChief(Map<String, Object> map) {
		return (List<FolderSimpleVO>)list("EzWebFolderDAO.getDeptFolderTreeForChief", map);
	}

	@SuppressWarnings("unchecked")
	public List<FolderSimpleVO> getCompanyFolderTreeForChief(Map<String, Object> map) {
		return (List<FolderSimpleVO>)list("EzWebFolderDAO.getCompanyFolderTreeForChief", map);
	}

	public void updateStatusAllFilesInFolder(Map<String, Object> map) {
		update("EzWebFolderDAO.updateStatusAllFilesInFolder", map);
	}

	public int checkFilesOwner(Map<String, Object> map) {
		return (int)select("EzWebFolderDAO.checkFilesOwner", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getFolderNameList(Map<String, Object> map) {
		return (List<String>)list("EzWebFolderDAO.getFolderNameList", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, String> getAllFolderNameMap(Map<String, Object> map) {
		return (Map<String, String>)map("EzWebFolderDAO.getAllFolderNameMap", map, "bnkKey", "bnkValue");
	}

	@SuppressWarnings("unchecked")
	public List<String> getFolderListFromFileId(Map<String, Object> map) {
		return (List<String>)list("EzWebFolderDAO.getFolderListFromFileId", map);
	}

	public double getTotalFilesSize(Map<String, Object> map) {
		return (double)select("EzWebFolderDAO.getTotalFilesSize", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<FolderSimpleVO> getAllSimpleShareFolder(Map<String, Object> map) {
		return (List<FolderSimpleVO>)list("EzWebFolderDAO.getAllSimpleShareFolder", map);
	}
	
	public void updateFileExt(Map<String, Object> map) {
		update("EzWebFolderDAO.updateFileExt", map);
	}

	public void insertEncryptionFolder(Map<String, Object> map) {
		insert("EzWebFolderDAO.insertEncryptionFolder", map);
	}

	public void deleteEncryptionFolder(Map<String, Object> map) {
		insert("EzWebFolderDAO.deleteEncryptionFolder", map);
	}

	public void deleteAllChildrenEncryptionFolder(Map<String, Object> map) {
		map.put("folderPath", ezWebFolderDAO_m.getFolderPath(map));

		delete("EzWebFolderDAO.deleteAllChildrenEncryptionFolder", map);
	}

	public void insertEncryptedFile(Map<String, Object> map) {
		insert("EzWebFolderDAO.insertEncryptedFile", map);
	}

	public void deleteEncryptedLatestVersion(Map<String, Object> map) {
		delete("EzWebFolderDAO.deleteEncryptedLatestVersion", map);
	}

	public void deleteEncryptedAllVersions(Map<String, Object> map) {
		delete("EzWebFolderDAO.deleteEncryptedAllVersions", map);
	}

	public void deleteEncryptedVersion(Map<String, Object> map) {
		delete("EzWebFolderDAO.deleteEncryptedVersion", map);
	}

	public FolderVO getEncryptionRootFolder(Map<String, Object> map) {
		map.put("folderPath", ezWebFolderDAO_m.getFolderPath(map));

		return (FolderVO) select("EzWebFolderDAO.getEncryptionRootFolder", map);
	}

	public boolean isEncryptionFolder(Map<String, Object> map) {
		map.put("folderPath", ezWebFolderDAO_m.getFolderPath(map));

		Integer count = (Integer) select("EzWebFolderDAO.isEncryptionFolder", map);
//		return count != null && count > 0;
		return false;
	}

	public boolean isEncryptedFile(Map<String, Object> map) {
		Integer count = (Integer) select("EzWebFolderDAO.isEncryptedFile", map);
//		return count != null && count > 0;
		return false;
	}

	public boolean isEncryptedVersion(Map<String, Object> map) {
		Integer count = (Integer) select("EzWebFolderDAO.isEncryptedVersion", map);
//		return count != null && count > 0;
		return false;
	}

	public boolean isEncryptedFilePath(Map<String, Object> map) {
		Integer count = (Integer) select("EzWebFolderDAO.isEncryptedFilePath", map);
//		return count != null && count > 0;
		return false;
	}

	@SuppressWarnings("unchecked")
	public List<FileHistoryVO> getFileHistories(Map<String, Object> map) {
		return (List<FileHistoryVO>) list("EzWebFolderDAO.getFileHistories", map);
	}

	public FileHistoryVO getFileHistory(Map<String, Object> map) {
		return (FileHistoryVO) select("EzWebFolderDAO.getFileHistory", map);
	}

	public FileHistoryVO getLatestHistory(Map<String, Object> map) {
		return (FileHistoryVO) select("EzWebFolderDAO.getLatestHistory", map);
	}

	public int getCurrentVersion(Map<String, Object> map) {
		return Optional.ofNullable((Integer) select("EzWebFolderDAO.getCurrentVersion", map)).orElse(0);
	}

	public void insertFileHistory(Map<String, Object> map) {
		insert("EzWebFolderDAO.insertFileHistory", map);
	}

	public void updateFilePathHistory(Map<String, Object> map) {
		insert("EzWebFolderDAO.updateFilePathHistory", map);
	}

	public void updateCurrentFileVersion(Map<String, Object> map) {
		update("EzWebFolderDAO.updateCurrentFileVersion", map);
	}

	public void deleteFileVersion(Map<String, Object> map) {
		update("EzWebFolderDAO.deleteFileVersion", map);
	}

	public void restoreFileVersionFromTrash(Map<String, Object> map) {
		update("EzWebFolderDAO.restoreFileVersionFromTrash", map);
	}

	public void deletePermanetlyFileHistory(Map<String, Object> map) {
		delete("EzWebFolderDAO.deletePermanetlyFileHistory", map);
	}

	public void deletePermanetFileHistories(Map<String, Object> map) {
		delete("EzWebFolderDAO.deletePermanetlyFileHistories", map);
	}

	public void insertFileUser(Map<String, Object> map) {
		insert ("EzWebFolderDAO.insertFileUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getWebFolderMembers(Map<String, Object> map) {
		return (List<OrganUserVO>)list("EzEmailDAO.getWebFolderMembers", map);
	}

	public boolean containsReplyFile(Map<String, Object> map) {
		Integer count = (Integer) select("EzWebFolderDAO.containsReplyFile", map);
		return count != null && count > 0;
	}

	@SuppressWarnings("unchecked")
	public List<String> getContainsReplyFiles(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO.getContainsReplyFiles", map);
	}

	public int checkFileUserExists(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO.checkFileUserExists", map);
	}
	
	public int checkFolderUserExists(Map<String, Object> map) {
		return (int) select("EzWebFolderDAO.checkFolderUserExists", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getNotInheritFolders(Map<String, Object> map) {
		return (List<String>) list("EzWebFolderDAO.getNotInheritFolders", map);
	}

	public boolean isNotInheritFolder(Map<String, Object> map) {
		map.put("folderPath", ezWebFolderDAO_m.getFolderPath(map));

		Integer count = (Integer) select("EzWebFolderDAO.isNotInheritFolder", map);
		return count != null && count > 0;
	}

	public void insertNotInheritFolder(Map<String, Object> map) {
		insert("EzWebFolderDAO.insertNotInheritFolder", map);
	}

	public void deleteNotInheritFolder(Map<String, Object> map) {
		insert("EzWebFolderDAO.deleteNotInheritFolder", map);
	}
}