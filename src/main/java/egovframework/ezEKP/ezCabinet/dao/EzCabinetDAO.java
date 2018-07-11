package egovframework.ezEKP.ezCabinet.dao;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import egovframework.ezEKP.ezCabinet.vo.CabinetGeneralVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetSimpleVO;
import egovframework.ezEKP.ezCabinet.vo.CabinetVO;
import egovframework.ezEKP.ezCabinet.vo.SimpleDeptVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@SuppressWarnings("unchecked")
@Repository("EzCabinetDAO")
public class EzCabinetDAO extends EgovAbstractDAO {
	public List<SimpleDeptVO> getAllSimpleDeptsOfCompany(Map<String, Object> map) {
		return (List<SimpleDeptVO>)list("EzCabinetDAO.getAllSimpleDeptsOfCompany", map);
	}
	
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
}
