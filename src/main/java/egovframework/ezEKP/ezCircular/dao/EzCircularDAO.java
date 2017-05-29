package egovframework.ezEKP.ezCircular.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCircular.vo.CircularAttachVO;
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularDeptVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCircular.vo.CircularMemberVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCircularDAO")
public class EzCircularDAO extends EgovAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCircularList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getCircularList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularListVO> getSearchCircularList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getSearchCircularList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getCircularMapList(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzCircularDAO.getCircularMapList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<HashMap<String, Object>> getSearchCircularMapList(Map<String, Object> map) throws Exception {
		return (List<HashMap<String, Object>>) list("EzCircularDAO.getSearchCircularMapList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCircularUserList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getCircularUserList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularAttachVO> getAttachList(Map<String, Object> map) throws Exception {
		return (List<CircularAttachVO>) list("EzCircularDAO.getAttachList", map);
	}
	
	public CircularConfigVO getCircularList_Config(Map<String, Object> map) throws Exception {
		return (CircularConfigVO) select("EzCircularDAO.getCircularList_Config", map);
	}
	
	public CircularListVO getCircular(Map<String, Object> map) throws Exception {
		return (CircularListVO) select("EzCircularDAO.getCircular", map);
	}

	public String getCircularConfig(Map<String, Object> map) throws Exception {
		return (String) select("EzCircularDAO.getCircularConfig", map);
	}
	
	public int getCircularListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getCircularListCount", map);
	}
	
	public int getConfirmStatusFirst(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getConfirmStatusFirst", map);
	}
	
	public int getConfirmStatusSecond(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getConfirmStatusSecond", map);
	}
	
	public int getLastID() throws Exception {
		return (int) select("EzCircularDAO.getLastID");
	}

	public void setCircularList_Config_U(CircularConfigVO circularConfigVO) throws Exception {
		update("EzCircularDAO.setCircularList_Config_U", circularConfigVO);
	}

	public void setCircularList_Config_I(CircularConfigVO circularConfigVO) throws Exception {
		insert("EzCircularDAO.setCircularList_Config_I", circularConfigVO);
	}

	public void setCircularList_Config2_I(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.setCircularList_Config2_I", map);
	}
	
	public void setCircularConfig2(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.setCircularConfig2", map);
	}
	
	public void insertCircular(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.insertCircular", map);
	}
	
	public void insertCircularUser(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.insertCircularUser", map);
	}
	
	public void insertCircularAttach(Map<String, Object> map) throws Exception{
		insert("EzScheduleDAO.insertCircularAttach", map);
	}
	
	public void setCircularList_Config2_U(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.setCircularList_Config2_U", map);
	}
	
	public void setCircularConfig(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.setCircularConfig", map);
	}
	
	public void modifyCircular(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.modifyCircular", map);
	}
	
	public void modifyCircularUser(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.modifyCircularUser", map);
	}
	
	public void confirmStatus(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.confirmStatus", map);
	}
	
	public void updateStatus(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.updateStatus", map);
	}
	
	public void updateStatusUser(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.updateStatusUser", map);
	}
	
	public void deleteCircular(Map<String, Object> map) throws Exception{
		delete("EzCircularDAO.deleteCircular", map);
	}
	
	public void deleteCircularUser(Map<String, Object> map) throws Exception{
		delete("EzCircularDAO.deleteCircularUser", map);
	}
	
	public void deleteCircularAttach(Map<String, Object> map) throws Exception{
		delete("EzCircularDAO.deleteCircularAttach", map);
	}
	
	public void set_circularDeptSave(CircularDeptVO circularDeptVO) throws Exception {
		insert("EzCircularDAO.set_circularDeptSave", circularDeptVO);
	}

	@SuppressWarnings("unchecked")
	public List<CircularDeptVO> getcircularDeptList(CircularDeptVO circularDeptVO) throws Exception {
		return (List<CircularDeptVO>) list("EzCircularDAO.getcircularDeptList", circularDeptVO);
	}

	public void circularDeptDel(CircularDeptVO circularDeptVO) throws Exception {
		delete("EzCircularDAO.circularDeptDel", circularDeptVO);
	}

	public void update_circularDept(CircularDeptVO circularDeptVO) throws Exception {
		update("EzCircularDAO.update_circularDept", circularDeptVO);
	}

	public int getCircularBMId() throws Exception {
		return (int) select("EzCircularDAO.getCircularBMId");
	}

	public void set_circularMemberList(Map<String, Object> map) {
		insert("EzCircularDAO.set_circularMemberList", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularMemberVO> modify_circularDept(Map<String, Object> map) {
		return (List<CircularMemberVO>) list("EzCircularDAO.modify_circularDept", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularMemberVO> getMemberName(Map<String, Object> map) {
		return (List<CircularMemberVO>) list("EzCircularDAO.getMemberName", map);
	}

}
