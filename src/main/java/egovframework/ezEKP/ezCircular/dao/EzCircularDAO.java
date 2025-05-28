package egovframework.ezEKP.ezCircular.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCircular.vo.CircularAttachVO;
import egovframework.ezEKP.ezCircular.vo.CircularCommentVO;
import egovframework.ezEKP.ezCircular.vo.CircularConfigVO;
import egovframework.ezEKP.ezCircular.vo.CircularConfirmVO;
import egovframework.ezEKP.ezCircular.vo.CircularDeptVO;
import egovframework.ezEKP.ezCircular.vo.CircularFolderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListHeaderVO;
import egovframework.ezEKP.ezCircular.vo.CircularListVO;
import egovframework.ezEKP.ezCircular.vo.CircularMemberVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCircularDAO")
public class EzCircularDAO extends EgovAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCircularList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getCircularList", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCircularUserList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getCircularUserList", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCircularDeptUserList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getCircularDeptUserList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularAttachVO> getAttachList(Map<String, Object> map) throws Exception {
		return (List<CircularAttachVO>) list("EzCircularDAO.getAttachList", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularMemberVO> modify_circularDept(Map<String, Object> map) throws Exception {
		return (List<CircularMemberVO>) list("EzCircularDAO.modify_circularDept", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularMemberVO> getMemberName(Map<String, Object> map) throws Exception {
		return (List<CircularMemberVO>) list("EzCircularDAO.getMemberName", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCircularCompleteList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getCircularCompleteList", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCircularTempList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getCircularTempList", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularListVO> getMyCircularList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getMyCircularList", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularFolderVO> getTopFolder(Map<String, Object> map) throws Exception {
		return (List<CircularFolderVO>) list("EzCircularDAO.getTopFolder", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCircularTDList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getCircularTDList", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularListVO> getFolderCircularList(Map<String, Object> map) throws Exception{
		return (List<CircularListVO>) list("EzCircularDAO.getFolderCircularList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularCommentVO> getCircularComment(Map<String, Object> map) throws Exception {
		return (List<CircularCommentVO>) list("EzCircularDAO.getCircularComment", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularCommentVO> getCircularCommentUserList(Map<String, Object> map) throws Exception {
		return (List<CircularCommentVO>) list("EzCircularDAO.getCircularCommentUserList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularListVO> getUserList(Map<String, Object> map) throws Exception {
		return (List<CircularListVO>) list("EzCircularDAO.getUserList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularListHeaderVO> getListHeader(Map<String, Object> map) throws Exception {
		return (List<CircularListHeaderVO>) list("EzCircularDAO.getListHeader", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularDeptVO> getcircularDeptList(Map<String, Object> map) throws Exception {
		return (List<CircularDeptVO>) list("EzCircularDAO.getcircularDeptList", map);
	}

	@SuppressWarnings("unchecked")
	public List<CircularListVO> getCommentStatus(Map<String, Object> map) {
		return (List<CircularListVO>) list("EzCircularDAO.getCommentStatus", map);
	}

	public CircularConfigVO getCircularList_Config(Map<String, Object> map) throws Exception {
		return (CircularConfigVO) select("EzCircularDAO.getCircularList_Config", map);
	}
	
	public CircularListVO getCircular(Map<String, Object> map) throws Exception {
		return (CircularListVO) select("EzCircularDAO.getCircular", map);
	}
	
	public CircularAttachVO getAttachInfo(Map<String, Object> map) throws Exception {
		return (CircularAttachVO) select("EzCircularDAO.getAttachInfo", map);
	}

	public String getCircularConfig(Map<String, Object> map) throws Exception {
		return (String) select("EzCircularDAO.getCircularConfig", map);
	}

	public String getFolderInfo(Map<String, Object> map) throws Exception {
		return (String) select("EzCircularDAO.getFolderInfo", map);
	}

	public String getCircularStatus(Map<String, Object> map) throws Exception {
		return (String) select("EzCircularDAO.getCircularStatus", map);
	}

	public int getCircularListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getCircularListCount", map);
	}
	
	public int checkUpdateStatus(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.checkUpdateStatus", map);
	}

	public int getCircularCompleteListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getCircularCompleteListCount", map);
	}

	public int getCircularTempListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getCircularTempListCount", map);
	}
	
	public int getMyCircularListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getMyCircularListCount", map);
	}

	public int getCircularTDListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getCircularTDListCount", map);
	}

	public int getFolderCircularListCount(Map<String, Object> map) throws Exception{
		return (int) select("EzCircularDAO.getFolderCircularListCount", map);
	}

	public String insertComment(Map<String, Object> map) throws Exception {
		return (String) insert("EzCircularDAO.insertComment", map);
	}

	public int confirmFolderCheck(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.confirmFolderCheck", map);
	}

	public int getCommentCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getCommentCount", map);
	}
	
	public int getListCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getListCount", map);
	}
	
	public void setCircularList_Config_I(CircularConfigVO circularConfigVO) throws Exception {
		insert("EzCircularDAO.setCircularList_Config_I", circularConfigVO);
	}

	public void setCircularConfig2(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.setCircularConfig2", map);
	}
	
	public int insertCircular(Map<String, Object> map) throws Exception{
		return (int) insert("EzCircularDAO.insertCircular", map);
	}
	
	public void insertCircularUser(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.insertCircularUser", map);
	}
	
	public void insertCircularAttach(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.insertCircularAttach", map);
	}
	
	public String setCircularDeptSave(Map<String, Object> map) throws Exception {
		return (String) insert("EzCircularDAO.setCircularDeptSave", map);
	}
	
	public void setCircularMemberList(Map<String, Object> map) throws Exception {
		insert("EzCircularDAO.setCircularMemberList", map);
	}

	public void circularFolderAdd(Map<String, Object> map) throws Exception {
		insert("EzCircularDAO.circularFolderAdd", map);
	}
	public void setCircularList_Config_U(CircularConfigVO circularConfigVO) throws Exception {
		update("EzCircularDAO.setCircularList_Config_U", circularConfigVO);
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
	
	public void updateUpdateStatus(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.updateUpdateStatus", map);
	}
	
	public void updateStatus(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.updateStatus", map);
	}
	
	public void updateCircularDept(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.updateCircularDept", map);
	}

	public void circularClose(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.circularClose", map);
	}
	
	public void circularFolderModify(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.circularFolderModify", map);
	}
	
	public void deleteCircularMemberList(Map<String, Object> map) throws Exception {
		delete("EzCircularDAO.deleteCircularMemberList", map);
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

	public void circularDeptDel(Map<String, Object> map) throws Exception {
		delete("EzCircularDAO.circularDeptDel", map);
	}

	public void circularDeleteFolder(Map<String, Object> map) throws Exception {
		delete("EzCircularDAO.circularDeleteFolder", map);
	}

	public void tempDeleteCircular(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.tempDeleteCircular", map);
	}

	public void moveCircular(Map<String, Object> map) throws Exception{
		update("EzCircularDAO.moveCircular", map);
	}

	public void moveCircular2(Map<String, Object> map) throws Exception{
		insert("EzCircularDAO.moveCircular2", map);
	}

	public void updateFolderId(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.updateFolderId", map);
	}
	
	public void updateCircularCommentStatus(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.updateCircularCommentStatus", map);
	}
	
	public void insertCommentState(Map<String, Object> map) throws Exception {
		insert("EzCircularDAO.insertCommentState", map);
	}
	
	public void moveCircular3(Map<String, Object> map) throws Exception {
		delete("EzCircularDAO.moveCircular3", map);
	}
	
	public void updateConfirmStatus(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.updateConfirmStatus", map);
	}
	
	public void deleteCommentState(Map<String, Object> map) throws Exception {
		delete("EzCircularDAO.deleteCommentState", map);
	}
	
	public void deleteCircularComment(Map<String, Object> map) throws Exception {
		delete("EzCircularDAO.deleteCircularComment", map);
	}

	public void updateCircularStatus(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.updateCircularStatus", map);
	}
	
	public void updateCommentState(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.updateCommentState", map);
	}
	
	public void updateCircularShareStatus(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.updateCircularShareStatus", map);
	}

	public void updateDeleteFlag(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.updateDeleteFlag", map);
	}

	public void updateCircular(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.updateCircular", map);
	}

//	public void updateCircularAttach(Map<String, Object> map) throws Exception {
//		update("EzCircularDAO.updateCircularAttach", map);
//	}

	public String getCommentStateID(Map<String, Object> map) throws Exception {
		return (String) select("EzCircularDAO.getCommentStateID", map);
	}

	public void restoreCircular(Map<String, Object> map) throws Exception {
		update("EzCircularDAO.restoreCircular", map);
	}

	public int checkFolder(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.checkFolder", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CircularConfirmVO> getConfirmMember(Map<String, Object> map) throws Exception {
		return (List<CircularConfirmVO>) list("EzCircularDAO.getConfirmMember", map);
	}
	
	public int getConfirmMemberCount(Map<String, Object> map) throws Exception {
		return (int) select("EzCircularDAO.getConfirmMemberCount", map);
	}
	
	public CircularMemberVO getCircularUserDeptId(Map<String, Object> map) throws Exception {
		return (CircularMemberVO) select("EzCircularDAO.getCircularUserDeptId", map);
	}
}
