package egovframework.ezEKP.ezWebFolder.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.FileTypeVO;
import egovframework.ezEKP.ezWebFolder.vo.FileVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderSimpleVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderUserVO;
import egovframework.ezEKP.ezWebFolder.vo.FolderVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleDeptVO;
import egovframework.ezEKP.ezWebFolder.vo.SimpleUserVO;
import egovframework.ezEKP.ezWebFolder.vo.WebfolderEnvVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzWebFolderDAO")
public class EzWebFolderDAO extends EgovAbstractDAO {
	public String getFileSequence(Map<String, Object> map) {
		return (String)select("EzWebFolderDAO.getFileSequence", map);
	}

	public void insertFile(Map<String, Object> map) {
		insert("EzWebFolderDAO.insertFile", map);
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
}