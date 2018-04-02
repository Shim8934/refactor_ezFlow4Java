package egovframework.ezEKP.ezAttitude.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezAttitude.vo.AttitudeApplicationVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeDeptVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeFormVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeStatisVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeTypeVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeUserConfigVO;
import egovframework.ezEKP.ezAttitude.vo.AttitudeVO;
import egovframework.ezEKP.ezAttitude.vo.HolidayVO;
import egovframework.ezEKP.ezJournal.vo.JournalAuthorVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

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

	public void updateAttitudeConfig(Map<String, Object> map) {
		update("ezAttitudeAdminDAO.updateAttitudeConfig", map);
	}
	
	public String getAttitudeUserConfigCount(Map<String, Object> map) throws Exception{
		return (String) select("ezAttitudeAdminDAO.getAttitudeUserConfigCount", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeTypeVO> getAttitudeTypeList(Map<String, Object> map) throws Exception{
		return (List<AttitudeTypeVO>) list("ezAttitudeAdminDAO.getAttitudeTypeList", map);
	}

	@SuppressWarnings("unchecked")
	public void updateAttitudeTypeConfig(Map<String, Object> map) {
		update("ezAttitudeAdminDAO.updateAttitudeTypeConfig", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeApplicationVO> getUsersModiyAtt(Map<String, Object> map) {
		return (List<AttitudeApplicationVO>) list("ezAttitudeDAO.getUsersModiyAtt", map);
	}
	
	public AttitudeTypeVO getAttitudeTypeInfo(Map<String, Object> map) {
		return (AttitudeTypeVO) select("ezAttitudeAdminDAO.getAttitudeTypeInfo", map);
	}

	@SuppressWarnings("unchecked")
	public String getAttitudeTypeMaxTypeId(Map<String, Object> map) {
		return (String) select("ezAttitudeAdminDAO.getAttitudeTypeMaxTypeId", map);
	}

	@SuppressWarnings("unchecked")
	public List<AttitudeFormVO> getAttitudeFormList(Map<String, Object> map) {
		return (List<AttitudeFormVO>) list("ezAttitudeAdminDAO.getAttitudeFormList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttitudeVO> getAttitudeList(Map<String,Object> map) throws Exception{
		return (List<AttitudeVO>) list("ezAttitude.getAttitudeList", map);
	}
	
	public void insertAttitude(Map<String, Object> map) throws Exception {
		insert("ezAttitude.insertAttitude", map);
	}
	
	public String getIsAttitudeUserConf(Map<String, Object> map) throws Exception {
		return (String) select("ezAttitude.getIsAttitudeUserConf", map);
	}
	
	@SuppressWarnings("unchecked")
	public AttitudeUserConfigVO getAttitudeConfTime(Map<String,Object> map) throws Exception {
		return (AttitudeUserConfigVO) select("ezAttitude.getAttitudeUserConfTime",map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttitudeStatisVO> getAttitudeStatisList(Map<String, Object> map) throws Exception {
		return (List<AttitudeStatisVO>) list("ezAttitudeDAO.getAttitudeStatisList", map);
	}
	
	@SuppressWarnings("unchecked")
	public int getUsersModiyAttCount(Map<String, Object> map) {
		return (int) select("ezAttitudeDAO.getUsersModiyAttCount", map);
	}

	@SuppressWarnings("unchecked")
	public void updateAttitudeType(Map<String, Object> map) throws Exception {
		update("ezAttitudeAdminDAO.updateAttitudeType", map);
	}

	@SuppressWarnings("unchecked")
	public void insertAttitudeType(Map<String, Object> map) {
		insert("ezAttitudeAdminDAO.insertAttitudeType", map);
	}

	@SuppressWarnings("unchecked")
	public AttitudeUserConfigVO getAttitudeUserConfigInfo(
			Map<String, Object> map) {
		return (AttitudeUserConfigVO) select("ezAttitudeAdminDAO.getAttitudeUserConfigInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HolidayVO> getHolidayList(Map<String, Object> map) throws Exception {
		return (List<HolidayVO>) list("ezAttitudeDAO.getHolidayList", map);
	}

	@SuppressWarnings("unchecked")
	public List<JournalAuthorVO> getDeptUserList(HashMap<String, String> map) {
		//없앨까 생각중
		return (List<JournalAuthorVO>) list("ezAttitudeAdminDAO.getDeptUserList", map);
	}

	@SuppressWarnings("unchecked")
	public void saveAttitudeUserConfig(Map<String, Object> map) {
		insert("ezAttitudeAdminDAO.saveAttitudeUserConfig", map);
	}
	
	@SuppressWarnings("unchecked")
	public void delUsersModifyAtt(Map<String, Object> map) {
		delete("ezAttitudeDAO.delUsersModifyAtt", map);
	}
	
	public AttitudeApplicationVO attModAppDetail(
			Map<String, Object> map) {
		return (AttitudeApplicationVO) select("ezAttitudeAdminDAO.attModAppDetail", map);
	}
	
}
