package egovframework.ezEKP.ezCabinet.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezCabinet.vo.CabinetAttachFileVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetColumnVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemSearchVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetItemVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetRelationVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetShareVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserInfoVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserMailVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleUserVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzCabinetDAO")
public class EzCabinetDAO extends EgovAbstractDAO {
	public String getDeptPath(Map<String, Object> map) {
		return (String)select("EzCabinetDAO.getDeptPath", map);
	}
	
	public SimpleDeptVO getSimpleCompany(Map<String, Object> map) {
		return (SimpleDeptVO)select("EzCabinetDAO.getSimpleCompany", map);
	}
	
	public List<SimpleDeptVO> getAllSimpleSubDepts(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzCabinetDAO.getAllSimpleSubDepts", map);
	}
	
	public List<CabinetModuleVO> getModuleListForUser(Map<String, Object> map) {
		return (List<CabinetModuleVO>)list("EzCabinetDAO.getModuleListForUser", map);
	}
	
	public List<CabinetModuleVO> getActiveModuleListForUser(Map<String, Object> map) {
		return (List<CabinetModuleVO>)list("EzCabinetDAO.getActiveModuleListForUser", map);
	}
	
	public void saveModulesSetting(Map<String, Object> map) {
		insert("EzCabinetDAO.saveModulesSetting", map);
	}
	
	public CabinetGeneralVO getUserPreviewConfig(Map<String, Object> map) {
		return (CabinetGeneralVO)select("EzCabinetDAO.getUserPreviewConfig", map);
	}
	
	public void saveUserConfig(Map<String, Object> map) {
		insert("EzCabinetDAO.saveUserConfig", map);
	}
	
	public int getMaxCabinetId(Map<String, Object> map) {
		return (int)select("EzCabinetDAO.getMaxCabinetId", map);
	}
	
	public int getMaxCabinetStep(Map<String, Object> map) {
		return (int)select("EzCabinetDAO.getMaxCabinetStep", map);
	}
	
	public void insertCabinet(CabinetVO cabinet) {
		insert("EzCabinetDAO.insertCabinet", cabinet);
	}
	
	public CabinetVO getCabinetById(Map<String, Object> map) {
		return (CabinetVO)select("EzCabinetDAO.getCabinetById", map);
	}
	
	public CabinetSimpleVO getRootCabinetTree(Map<String, Object> map) {
		return (CabinetSimpleVO)select("EzCabinetDAO.getRootCabinetTree", map);
	}
	
	public List<CabinetSimpleVO> getCabinetSubTree(Map<String, Object> map) {
		return (List<CabinetSimpleVO>)list("EzCabinetDAO.getCabinetSubTree", map);
	}
	
	public List<CabinetSimpleVO> getMyCabinetNodesInDetail(Map<String, Object> map) {
		return (List<CabinetSimpleVO>)list("EzCabinetDAO.getMyCabinetNodesInDetail", map);
	}
	
	public void updateCabinet(CabinetVO cabinet) {
		update("EzCabinetDAO.updateCabinet", cabinet);
	}
	
	public void deleteSubCabinetList(Map<String, Object> map) {
		update("EzCabinetDAO.deleteSubCabinetList", map);
	}
	
	public void deleteAllCabinetItems(Map<String, Object> map) {
		update("EzCabinetDAO.deleteAllCabinetItems", map);
	}
	
	public List<CabinetVO> getCabinetListForPermission(Map<String, Object> map) {
		return (List<CabinetVO>)list("EzCabinetDAO.getCabinetListForPermission", map);
	}
	
	public List<String> getUserDepartmentIdList(Map<String, Object> map) {
		return (List<String>)list("EzCabinetDAO.getUserDepartmentIdList", map);
	}
	
	public List<CabinetVO> getReceivedCabinetListForPermission(Map<String, Object> map) {
		return (List<CabinetVO>)list("EzCabinetDAO.getReceivedCabinetListForPermission", map);
	}
	
	public List<Integer> getReceivedCabinetIdListForPermission(Map<String, Object> map) {
		return (List<Integer>)list("EzCabinetDAO.getReceivedCabinetIdListForPermission", map);
	}
	
	public void moveSubCabinetList(Map<String, Object> map) {
		update("EzCabinetDAO.moveSubCabinetList", map);
	}
	
	public List<CabinetVO> getAllSubCabinet(Map<String, Object> map) {
		return (List<CabinetVO>)list("EzCabinetDAO.getAllSubCabinet", map);
	}
	
	public int getMaxItem(Map<String, Object> map) {
		return (int)select("EzCabinetDAO.getMaxItem", map);
	}
	
	public int getMaxAttachId(Map<String, Object> map) {
		return (int)select("EzCabinetDAO.getMaxAttachId", map);
	}
	
	public void saveAttachFile(CabinetAttachFileVO attachFile) {
		insert("EzCabinetDAO.saveAttachFile", attachFile);
	}
	
	public int getMaxRelationId(Map<String, Object> map) {
		return (int)select("EzCabinetDAO.getMaxRelationId", map);
	}
	
	public void saveRelationFile(CabinetRelationVO relationFile) {
		insert("EzCabinetDAO.saveRelationFile", relationFile);
	}
	
	public void saveItem(CabinetItemVO itemVO) {
		insert("EzCabinetDAO.saveItem", itemVO);
	}
	
	public List<CabinetItemVO> getAllItemsOfCabinet(Map<String, Object> map) {
		return (List<CabinetItemVO>)list("EzCabinetDAO.getAllItemsOfCabinet", map);
	}
	
	public List<CabinetAttachFileVO> getAllAttachFilesOfItem(Map<String, Object> map) {
		return (List<CabinetAttachFileVO>)list("EzCabinetDAO.getAllAttachFilesOfItem", map);
	}
	
	public List<CabinetRelationVO> getAllRelatedFilesOfItem(Map<String, Object> map) {
		return (List<CabinetRelationVO>)list("EzCabinetDAO.getAllRelatedFilesOfItem", map);
	}
	
	public long getCabinetStorage(Map<String, Object> map) {
		return (long)select("EzCabinetDAO.getCabinetStorage", map);
	}
	
	public List<CabinetItemVO> getItems(CabinetItemSearchVO searchVO) {
		return (List<CabinetItemVO>)list("EzCabinetDAO.getItems", searchVO);
	}
	
	public int getTotalItems(CabinetItemSearchVO searchVO) {
		return (int)select("EzCabinetDAO.getTotalItems", searchVO);
	}
	
	public List<CabinetItemVO> getItemsRecursive(CabinetItemSearchVO searchVO) {
		return (List<CabinetItemVO>)list("EzCabinetDAO.getItemsRecursive", searchVO);
	}
	
	public int getTotalItemsRecursive(CabinetItemSearchVO searchVO) {
		return (int)select("EzCabinetDAO.getTotalItemsRecursive", searchVO);
	}
	
	public void deleteItems(Map<String, Object> map) {
		update("EzCabinetDAO.deleteItems", map);
	}
	
	public List<CabinetVO> getRelatedCabinetListForUser(Map<String, Object> map) {
		return (List<CabinetVO>)list("EzCabinetDAO.getRelatedCabinetListForUser", map);
	}
	
	public void moveItemsForUser(Map<String, Object> map) {
		update("EzCabinetDAO.moveItemsForUser", map);
	}
	
	public long getTotalItemsSize(Map<String, Object> map) {
		return (long)select("EzCabinetDAO.getTotalItemsSize", map);
	}
	
	public List<CabinetItemVO> getItemsFromIdList(Map<String, Object> map) {
		return (List<CabinetItemVO>)list("EzCabinetDAO.getItemsFromIdList", map);
	}
	
	public List<CabinetItemSimpleVO> getCabinetFiles(Map<String, Object> map) {
		return (List<CabinetItemSimpleVO>)list("EzCabinetDAO.getCabinetFiles", map);
	}
	
	public List<CabinetItemSimpleVO> getFilesByTitle(Map<String, Object> map) {
		return (List<CabinetItemSimpleVO>)list("EzCabinetDAO.getFilesByTitle", map);
	}
	
	public int getTotalFiles(Map<String, Object> map) {
		return (int)select("EzCabinetDAO.getTotalFiles", map);
	}
	
	public int getTotalFilesByTitle(Map<String, Object> map) {
		return (int)select("EzCabinetDAO.getTotalFilesByTitle", map);
	}
	
	public List<SimpleUserVO> getSharedUserList(Map<String, Object> map) {
		return (List<SimpleUserVO>)list("EzCabinetDAO.getSharedUserList", map);
	}
	
	public List<CabinetSimpleVO> getUserSharedCabinet(Map<String, Object> map) {
		return (List<CabinetSimpleVO>)list("EzCabinetDAO.getUserSharedCabinet", map);
	}
	
	public List<CabinetShareVO> getSharedCabinetListById(Map<String, Object> map) {
		return (List<CabinetShareVO>)list("EzCabinetDAO.getSharedCabinetListById", map);
	}
	
	public List<CabinetShareVO> checkSubPermission(Map<String, Object> map) {
		return (List<CabinetShareVO>)list("EzCabinetDAO.checkSubPermission", map);
	}
	
	public CabinetItemVO getItemById(Map<String, Object> map) {
		return (CabinetItemVO)select("EzCabinetDAO.getItemById", map);
	}
	
	public void deleteAttachFiles(Map<String, Object> map) {
		delete("EzCabinetDAO.deleteAttachFiles", map);
	}
	
	public void deleteRelatedFiles(Map<String, Object> map) {
		delete("EzCabinetDAO.deleteRelatedFiles", map);
	}
	
	public CabinetVO getRootCabinetByType(Map<String, Object> map) {
		return (CabinetVO)select("EzCabinetDAO.getRootCabinetByType", map);
	}
	
	public void saveRelatedColumn(CabinetColumnVO column) {
		insert("EzCabinetDAO.saveRelatedColumn", column);
	}
	
	public List<CabinetColumnVO> getAllRelatedColumnsOfItem(Map<String, Object> map) {
		return (List<CabinetColumnVO>)list("EzCabinetDAO.getAllRelatedColumnsOfItem", map);
	}
	
	public List<SimpleUserMailVO> getUserInfoFromEmail(Map<String, Object> map) {
		return (List<SimpleUserMailVO>)list("EzCabinetDAO.getUserInfoFromEmail", map);
	}
	
	public SimpleUserInfoVO getSimpleUserInfo(Map<String, Object> map) {
		return (SimpleUserInfoVO)select("EzCabinetDAO.getSimpleUserInfo", map);
	}
	
	public List<SimpleUserInfoVO> getUsersInfoFromIdList(Map<String, Object> map) {
		return (List<SimpleUserInfoVO>)list("EzCabinetDAO.getUsersInfoFromIdList", map);
	}
	
	public int getTotalChildren(Map<String, Object> map) {
		return (int)select("EzCabinetDAO.getTotalChildren", map);
	}
	
	public List<CabinetSimpleVO> getMySharedCabinetList(Map<String, Object> map) {
		return (List<CabinetSimpleVO>)list("EzCabinetDAO.getMySharedCabinetList", map);
	}
}
