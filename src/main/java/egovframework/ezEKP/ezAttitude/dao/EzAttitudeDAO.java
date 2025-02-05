package egovframework.ezEKP.ezAttitude.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezAttitude.vo.AdminAttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAnnualVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeAuthorVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeFormVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeStatisVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.DeptViewVO;
import egovframework.ezEKP.ezAttitude.vo.HolidayVO;
import egovframework.ezEKP.ezAttitude.vo.ModApplHistoryVO;
import egovframework.ezEKP.ezOrgan.vo.OrganDeptVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzAttitudeDAO")
public class EzAttitudeDAO extends EgovAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<AttitudeDeptVO> getCompanyList(Map<String, Object> map) throws Exception{
		return (List<AttitudeDeptVO>) list("ezAttitudeAdminDAO.getCompanyList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttitudeUserConfigVO> getAttitudeUserConfigList(Map<String, Object> map) throws Exception{
		return (List<AttitudeUserConfigVO>) list("ezAttitudeAdminDAO.getAttitudeUserConfigList", map);
	}

	public AttitudeConfigVO getAttitudeConfig(Map<String, Object> map) throws Exception{
		return (AttitudeConfigVO) select("ezAttitudeAdminDAO.getAttitudeConfig", map);
	}

	public void updateAttitudeConfig(Map<String, Object> map) throws Exception {
		update("ezAttitudeAdminDAO.updateAttitudeConfig", map);
	}
	
	public String getAttitudeUserConfigCount(Map<String, Object> map) throws Exception{
		return (String) select("ezAttitudeAdminDAO.getAttitudeUserConfigCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeTypeVO> getAttitudeTypeList(Map<String, Object> map) throws Exception{
		return (List<AttitudeTypeVO>) list("ezAttitudeAdminDAO.getAttitudeTypeList", map);
	}

	public void updateAttitudeTypeConfig(Map<String, Object> map) throws Exception {
		update("ezAttitudeAdminDAO.updateAttitudeTypeConfig", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeApplicationVO> getUsersModiyAtt(Map<String, Object> map) throws Exception {
		return (List<AttitudeApplicationVO>) list("ezAttitudeDAO.getUsersModiyAtt", map);
	}
	
	public AttitudeTypeVO getAttitudeTypeInfo(Map<String, Object> map) throws Exception {
		return (AttitudeTypeVO) select("ezAttitudeAdminDAO.getAttitudeTypeInfo", map);
	}

	public String getAttitudeTypeMaxTypeId(Map<String, Object> map) throws Exception {
		return (String) select("ezAttitudeAdminDAO.getAttitudeTypeMaxTypeId", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeFormVO> getAttitudeFormList(Map<String, Object> map) throws Exception {
		return (List<AttitudeFormVO>) list("ezAttitudeAdminDAO.getAttitudeFormList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttitudeVO> getAttitudeList(Map<String,Object> map) throws Exception{
		return (List<AttitudeVO>) list("ezAttitudeDAO.getAttitudeList", map);
	}
	
	public int insertAttitude(Map<String, Object> map) throws Exception {
		return (int) insert("ezAttitudeDAO.insertAttitude", map); 
	}
	
	public void	insertAdminAttHistory(Map<String, Object> map) throws Exception {
		insert("ezAttitudeDAO.insertAdminAttHistory", map); 
	}
	
	public String getIsAttitudeUserConf(Map<String, Object> map) throws Exception {
		return (String) select("ezAttitudeDAO.getIsAttitudeUserConf", map);
	}
	
	public AttitudeUserConfigVO getAttitudeConfTime(Map<String,Object> map) throws Exception {
		return (AttitudeUserConfigVO) select("ezAttitudeDAO.getAttitudeUserConfTime",map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttitudeStatisVO> getAttitudeStatisList(Map<String, Object> map) throws Exception {
		return (List<AttitudeStatisVO>) list("ezAttitudeDAO.getAttitudeStatisList", map);
	}
	
	public int getUsersModiyAttCount(Map<String, Object> map) throws Exception {
		return (int) select("ezAttitudeDAO.getUsersModiyAttCount", map);
	}
	
	public int getAttsModAttCount(Map<String, Object> map) throws Exception {
		return (int) select("ezAttitudeDAO.getAttsModAttCount", map);
	}

	public void updateAttitudeType(Map<String, Object> map) throws Exception {
		update("ezAttitudeAdminDAO.updateAttitudeType", map);
	}

	public void insertAttitudeType(Map<String, Object> map) throws Exception {
		insert("ezAttitudeAdminDAO.insertAttitudeType", map);
	}

	public AttitudeUserConfigVO getAttitudeUserConfigInfo(Map<String, Object> map) throws Exception {
		return (AttitudeUserConfigVO) select("ezAttitudeAdminDAO.getAttitudeUserConfigInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HolidayVO> getHolidayList(Map<String, Object> map) throws Exception {
		return (List<HolidayVO>) list("ezAttitudeDAO.getHolidayList", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeAuthorVO> getDeptUserList(Map<String, String> map) throws Exception {
		return (List<AttitudeAuthorVO>) list("ezAttitudeAdminDAO.getDeptUserList", map);
	}

	@SuppressWarnings("unchecked")
	public List<DeptViewVO> getDeptViewList(Map<String, Object> map) throws Exception {
		return (List<DeptViewVO>) list("ezAttitudeAdminDAO.selectDeptList",map);
	}

	public void saveAttitudeUserConfig(Map<String, Object> map) throws Exception {
		insert("ezAttitudeAdminDAO.saveAttitudeUserConfig", map);
	}
	
	public void deleteAttitudeUserConfig(Map<String, Object> map) throws Exception {
		delete("ezAttitudeAdminDAO.deleteAttitudeUserConfig", map);
	}
	
	public void saveAttitudeDeptConfig(Map<String, Object> map) throws Exception {
		insert("ezAttitudeAdminDAO.saveAttitudeDeptConfig", map);
	}
	
	public void deleteAttitudeDeptConfig(Map<String, Object> map) throws Exception {
		delete("ezAttitudeAdminDAO.deleteAttitudeDeptConfig", map);
	}
	
	public void delUsersModifyAtt(Map<String, Object> map) throws Exception {
		delete("ezAttitudeDAO.delUsersModifyAtt", map);
	}
	
	public void delUsersModifyAttHistory(Map<String, Object> map) throws Exception {
		delete("ezAttitudeDAO.delUsersModifyAttHistory", map);
	}
	
	public AttitudeApplicationVO attModAppDetail(Map<String, Object> map) throws Exception {
		return (AttitudeApplicationVO) select("ezAttitudeDAO.attModAppDetail", map);
	}
	
	public AttitudeFormVO getFormBody(Map<String, Object> map) throws Exception {
		return (AttitudeFormVO) select("ezAttitudeDAO.getFormBody", map);
	}
	
	public int attModAppModify(Map<String, Object> map) throws Exception {
		return update("ezAttitudeDAO.attModAppModify", map);
	}
	
	public void attSaveAppModify(Map<String, Object> map) throws Exception {
		insert("ezAttitudeDAO.attSaveAppModify", map);
	}
	
	public void setAttModApp(Map<String, Object> map) throws Exception {
		update("ezAttitudeDAO.setAttModApp", map);
	}
	
	public int getAttModApp(Map<String, Object> map) throws Exception {
		return (int) select("ezAttitudeDAO.getAttModApp", map);
	}
	
	public void resetAttModApp(Map<String, Object> map) throws Exception {
		update("ezAttitudeDAO.resetAttModApp", map);
	}

	public void attAppUpdate(Map<String, Object> map) throws Exception {
		update("ezAttitudeDAO.attAppUpdate", map);
	}

	@SuppressWarnings("unchecked")
	public List<AdminAttitudeVO> getAttitudeList2(Map<String, Object> map) throws Exception {
		return (List<AdminAttitudeVO>) list("ezAttitudeAdminDAO.getAttitudeList2", map);
	}

	public String getAttitudeCount2(Map<String, Object> map) throws Exception {
		return (String) select("ezAttitudeAdminDAO.getAttitudeCount2", map);
	}

	public String getAttitudeAbsentCount(Map<String, Object> map) throws Exception {
		return (String) select("ezAttitudeAdminDAO.getAttitudeAbsentCount", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AdminAttitudeVO> getAttitudeAbsentList(Map<String, Object> map) throws Exception {
		return (List<AdminAttitudeVO>) list("ezAttitudeAdminDAO.getAttitudeAbsentList", map);
	}
	
	public AttitudeVO getAttitudeInfo(Map<String, Object> map) throws Exception {
		return (AttitudeVO) select("ezAttitude.getAttitudeInfo", map);
	}
	
	public void changeUsersModifyAtt(Map<String, Object> map) throws Exception {		
		update("ezAttitudeDAO.changeUsersModifyAtt", map);
	}
	
	public void adminChangeUsersModAtt(Map<String, Object> map) throws Exception {		
		update("ezAttitudeDAO.adminChangeUsersModAtt", map);
	}
	
	public AttitudeApplicationVO attDetail(Map<String, Object> map) throws Exception {		
		return (AttitudeApplicationVO) select("ezAttitudeDAO.attDetail", map);
	}
	
	public void changeUsersAtt(Map<String, Object> map) throws Exception {		
		update("ezAttitudeDAO.changeUsersAtt", map);
	}
	
	public void changeUsersAttType(Map<String, Object> map) throws Exception {		
		update("ezAttitudeDAO.changeUsersAttType", map);
	}
	
	public void addUsersModifyAttHistory(Map<String, Object> map) throws Exception {
		insert("ezAttitudeAdminDAO.addUsersModifyAttHistory", map);
	}
	
	public void deleteAttitude(Map<String, Object> map) throws Exception {
		delete("ezAttitudeDAO.deleteAttitude", map);
	}
	
	public void updateAttitude(Map<String, Object> map) throws Exception {
		update("ezAttitudeDAO.updateAttitude", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeAuthorVO> getAttitudeAuthList(Map<String, Object> map) throws Exception {
		return (List<AttitudeAuthorVO>) list("ezAttitudeAdminDAO.getAttitudeAuthList", map);
	}

	public void deleteAttitudeAuth(Map<String, Object> map) throws Exception {
		delete("ezAttitudeAdminDAO.deleteAttitudeAuth", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttitudeApplicationVO> attModGetHistory(Map<String, Object> map) throws Exception {
		return (List<AttitudeApplicationVO>) list("ezAttitudeDAO.attModGetHistory", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeAuthorVO> getAttitudeAuthDeptList(
			Map<String, Object> map) throws Exception {
		return (List<AttitudeAuthorVO>) list("ezAttitudeAdminDAO.getAttitudeAuthDeptList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttitudeAuthorVO> getAttitudeAuthDeptList_hyo(Map<String, Object> map) throws Exception {
		return (List<AttitudeAuthorVO>) list("ezAttitudeAdminDAO.getAttitudeAuthDeptList_hyo", map);
	}
	
	public void insertAttitudeAuth(Map<String, Object> map) throws Exception {
		insert("ezAttitudeAdminDAO.insertAttitudeAuth", map);
	}

	public AttitudeStatisVO getAttitudeUserStatistics(
			Map<String, Object> map) throws Exception {
		return (AttitudeStatisVO) select("ezAttitudeAdminDAO.getAttitudeUserStatistics", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeAuthorVO> getCompanyDeptList(Map<String, Object> map) throws Exception {
		return (List<AttitudeAuthorVO>) list("ezAttitudeAdminDAO.getCompanyDeptList", map);
	}

		public int checkUseAttitudeType(Map<String, Object> map) throws Exception {
		return (int) select("ezAttitudeAdminDAO.checkUseAttitudeType", map);
	}

	public void deleteAttitudeType(Map<String, Object> map) throws Exception {
		delete("ezAttitudeAdminDAO.deleteAttitudeType", map);
	}
	
	public void	insertAdminAttHistory2(Map<String, Object> map) throws Exception {
		insert("ezAttitudeDAO.insertAdminAttHistory2", map);
	}
	
	public void	insertAdminAttHistory3(Map<String, Object> map) throws Exception {
		insert("ezAttitudeDAO.insertAdminAttHistory3", map);
	}
	
	public void	adminAttSaveAppMod(Map<String, Object> map) throws Exception {
		insert("ezAttitudeDAO.adminAttSaveAppMod", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ModApplHistoryVO> getAttitudeHistoryList(Map<String, Object> map) throws Exception {
		return (List<ModApplHistoryVO>) list("ezAttitudeAdminDAO.getAttitudeHistoryList", map);
	}

	public String getAttitudeHistoryCount(Map<String, Object> map) throws Exception {
		return (String) select("ezAttitudeAdminDAO.getAttitudeHistoryCount", map);
	}
	
	public String getIsAttitude(Map<String, Object> map) throws Exception {
		return (String) select("ezAttitudeDAO.getIsAttitude", map);
	}
	
	public int getSearchListCount(Map<String, Object> map) throws Exception {
		return getSearchListCountForLocal(map);                       
	}
	
	private int getSearchListCountForLocal(Map<String, Object> map) {
        return (int) select("ezAttitudeDAO.getSearchListCount", map);
    }
	
    @SuppressWarnings("unchecked")
    private List<OrganDeptVO> attOrganSearchListForLocal(Map<String, Object> map) throws Exception {
        return (List<OrganDeptVO>) list("ezAttitudeDAO.attOrganSearchList", map);
    }
    
    public List<OrganDeptVO> attOrganSearchList(Map<String, Object> map) throws Exception {
        return attOrganSearchListForLocal(map);
    }
    
    public String checkModApplStatus(Map<String, Object> map) throws Exception {
    	return (String) select("ezAttitudeDAO.checkModApplStatus", map);
    }

    @SuppressWarnings("unchecked")
	public List<AttitudeAuthorVO> getDeptUserList(HashMap<String, Object> map) throws Exception {
		return (List<AttitudeAuthorVO>) list("ezAttitudeAdminDAO.getDeptUserList", map);
	}

	public String getAttitudeAnnualListCount(Map<String, Object> map) {
		return (String) select("ezAttitudeAdminDAO.getAttitudeAnnualListCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeAnnualVO> getAttitudeAnnualList(Map<String, Object> map) {
		return (List<AttitudeAnnualVO>) list("ezAttitudeAdminDAO.getAttitudeAnnualList", map);
	}
    
    public int getSimpleAnnualCnt(Map<String, Object> map) throws Exception {
    	return (int) select("ezAttitudeAdminDAO.getSimpleAnnualCnt", map);
    }
    
    public void insertAnnualHistory(Map<String, Object> map) throws Exception {
    	insert("ezAttitudeAdminDAO.insertAnnualHistory", map);
    }
    
    public void changeAnnualHistory(Map<String, Object> map) throws Exception {
    	insert("ezAttitudeAdminDAO.changeAnnualHistory", map);
    }
    
    public void insertAnnual(Map<String, Object> map) throws Exception {
    	insert("ezAttitudeAdminDAO.insertAnnual", map);
    }
    
    public void changeAnnual(Map<String, Object> map) throws Exception {
    	update("ezAttitudeAdminDAO.changeAnnual", map);
    }

    public void excelInsertAnnual(Map<String, Object> map) throws Exception {
    	insert("ezAttitudeAdminDAO.excelInsertAnnual", map);
    }
    
    public void excelChangeAnnual(Map<String, Object> map) throws Exception {
    	update("ezAttitudeAdminDAO.excelChangeAnnual", map);
    }
    
    public AttitudeAnnualVO getAnnualCnt(Map<String, Object> map) throws Exception {
    	return (AttitudeAnnualVO) select("ezAttitudeAdminDAO.getAnnualCnt", map);
    }

	@SuppressWarnings("unchecked")
	public List<AdminAttitudeVO> getUserAnnual(Map<String, Object> map) {
		return (List<AdminAttitudeVO>) list("ezAttitudeAdminDAO.getUserAnnual", map);
	}
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getAnnualHistoryList(Map<String, Object> map) throws Exception {
    	return (List<Map<String, Object>>) list("ezAttitudeAdminDAO.getAnnualHistoryList", map);
    }
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getUserList(Map<String, Object> map) throws Exception {
    	return (List<Map<String, Object>>) list("ezAttitudeAdminDAO.getUserList", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getAttitudeJoinDateUserList(Map<String, Object> map) throws Exception {
    	return (List<Map<String, Object>>) list("ezAttitudeDAO.getAttitudeJoinDateUserList", map);
    }
    
    @SuppressWarnings("unchecked")
    public Map<String, Object> getMonthlyAnnualList(Map<String, Object> map) throws Exception {
    	return (Map<String, Object>) select("ezAttitudeDAO.getMonthlyAnnualList", map);
    }
    
    public void saveCancelAnnual(Map<String, Object> map) throws Exception {
		insert("ezAttitudeDAO.saveCancelAnnual", map);
	}
    
    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getJoinDateUserList(Map<String, Object> map) throws Exception {
    	return (List<Map<String, Object>>)list("ezAttitudeDAO.getJoinDateUserList", map);
    }
    
    public int getAttendanceDay(Map<String, Object> map) throws Exception {
    	return (int) select("ezAttitudeDAO.getAttendanceDay", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getTenantCompanuId() throws Exception {
    	return (List<Map<String, Object>>) list("ezAttitudeDAO.getTenantCompanuId");
    }
    
    public void updateAnnualHoliday(Map<String, Object> map) throws Exception {
    	update("ezAttitudeDAO.updateAnnualHoliday", map);
    }

    @SuppressWarnings("unchecked")
    public List<Map<String, Object>> getuserAnnualCnt(Map<String, Object> map) throws Exception {
    	return (List<Map<String, Object>>) list("ezAttitudeDAO.getuserAnnualCnt", map);
    }

    public int checkAbsentDay(Map<String, Object> map) throws Exception {
    	return (int)select("ezAttitudeDAO.checkAbsentDay", map);
    }

    public int getMonthlyHolidayCnt(Map<String, Object> map) throws Exception {
    	return (int)select("ezAttitudeDAO.getMonthlyHolidayCnt", map);
    }
    
    public String checkCanApplStatus(Map<String, Object> map) throws Exception {
    	return (String) select("ezAttitudeDAO.checkCanApplStatus", map);
    }
    
    public void delCanAppl(Map<String, Object> map) throws Exception {
		delete("ezAttitudeDAO.delCanAppl", map);
	}
    
    public int getUsersCancelAnnCount(Map<String, Object> map) throws Exception {
		return (int) select("ezAttitudeDAO.getUsersCancelAnnCount", map);
	}
    
    @SuppressWarnings("unchecked")
	public List<AttitudeApplicationVO> getUsersCancelAnn(Map<String, Object> map) throws Exception {
		return (List<AttitudeApplicationVO>) list("ezAttitudeDAO.getUsersCancelAnn", map);
	}
    
	public AttitudeApplicationVO annCanAppDetail(Map<String, Object> map) throws Exception {
		return (AttitudeApplicationVO) select("ezAttitudeDAO.annCanAppDetail", map);
	}
    
    public void changeUsersCancelAnn(Map<String, Object> map) throws Exception {		
		update("ezAttitudeDAO.changeUsersCancelAnn", map);
	}
    
    @SuppressWarnings("unchecked")
	public List<AttitudeApplicationVO> getAnnCanHistory(Map<String, Object> map) throws Exception {
		return (List<AttitudeApplicationVO>) list("ezAttitudeDAO.getAnnCanHistory", map);
	}
    
    public void saveJoinDate(Map<String, Object> map) throws Exception {
    	insert("ezAttitudeAdminDAO.saveJoinDate", map);
    }
    
    public void modifyJoinDate(Map<String, Object> map) throws Exception {
    	update("ezAttitudeAdminDAO.modifyJoinDate", map);
    }

	public void insertApprovalGConnInfo(Map<String, Object> map) {
		insert("ezAttitudeDAO.insertApprovalGConnInfo", map);
	}

	public void updateApprovalGConnInfo(Map<String, Object> map) {
		update("ezAttitudeDAO.updateApprovalGConnInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<String> getApprovalGConnAttitudeList(Map<String, Object> map) {
		return (List<String>) list("ezAttitudeDAO.getApprovalGConnAttitudeList", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getAttitudeAnnualConfig(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) select("ezAttitudeAdminDAO.getAttitudeAnnualConfig", map);
	}
	
	public void insertAnnualConfig(Map<String, Object> map) throws Exception {
		insert("ezAttitudeAdminDAO.insertAnnualConfig", map);
	}
	
	public void updateAnnualConfig(Map<String, Object> map) throws Exception {
		update("ezAttitudeAdminDAO.updateAnnualConfig", map);
	}

	public void updateAnnualHistory(Map<String, Object> map) throws Exception {
		update("ezAttitudeAdminDAO.updateAnnualHistory", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getJoinDate(Map<String, Object> map) throws Exception{
		return (Map<String, Object>) select("ezAttitudeAdminDAO.getJoinDate", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAttitudeAprInfo(Map<String, Object> map) throws Exception {
		return (List<Map<String, Object>>) list("ezAttitudeDAO.getAttitudeAprInfo", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeVO> getDisabledAttitudeList(Map<String, Object> map) {
		return (List<AttitudeVO>) list("ezAttitudeDAO.getDisabledAttitudeList", map);
	}

	public void deleteAnnualHistory(Map<String, Object> map) {
		delete("ezAttitudeAdminDAO.deleteAnnualHistory", map);
		
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeVO> getAnuualListSchedule(Map<String, Object> map) {
		return (List<AttitudeVO>) list("ezAttitudeDAO.getAnuualListSchedule", map);
	}

	public String getAttitudeTime(Map<String, Object> map) {
		return (String) select("ezAttitudeDAO.getAttitudeTime", map);
	}

	public void updateWorkStatus(Map<String, Object> map) {
		update("ezAttitudeDAO.updateWorkStatus", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeVO> getAttitudeList3() {
		return (List<AttitudeVO>) list("ezAttitudeDAO.getAttitudeList3");
	}
}