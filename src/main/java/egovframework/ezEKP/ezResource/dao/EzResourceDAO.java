package egovframework.ezEKP.ezResource.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepResourceRepeatVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepResourceVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListTermVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzResourceDAO")
public class EzResourceDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(Map<String, Object> map){
		return  (List<ResGetAdmSubClsTreeVO>) list("EzResourceDAO.getAdmSubClsTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(Map<String, Object> map){
		return  (List<ResGetAdmSubClsTreeVO>) list("EzResourceDAO.getSubClsTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetItemListVO> getBrdMainList(Map<String, Object> map){
		return  (List<ResGetItemListVO>) list("EzResourceDAO.getBrdMainList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListVO> getScheduleList(Map<String, Object> map){
		return  (List<ResGetScheduleListVO>) list("EzResourceDAO.getScheduleList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleRepetitionVO> getScheduleRepetition(Map<String, Object> map){
		return  (List<ResGetScheduleRepetitionVO>) list("EzResourceDAO.getScheduleRepetition", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListMainVO> getScheduleListMain(Map<String, Object> map){
		return  (List<ResGetScheduleListMainVO>) list("EzResourceDAO.getScheduleListMain", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListRepetitionVO> getScheduleListRepetiti(Map<String, Object> map){
		return  (List<ResGetScheduleListRepetitionVO>) list("EzResourceDAO.getScheduleListRepetiti", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleListMainVO> getScheduleListRepetitim(Map<String, Object> map){
		return  (List<ResGetScheduleListMainVO>) list("EzResourceDAO.getScheduleListRepetitim", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResBrdListVO> getBrdList(Map<String, Object> map){
		return  (List<ResBrdListVO>) list("EzResourceDAO.getBrdList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleInfo(Map<String, Object> map) {
		return (List<ResGetScheduleVO>) list("EzResourceDAO.getScheduleInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetRepResourceRepeatVO> getRepResourceRepeat(Map<String, Object> map) {
		return (List<ResGetRepResourceRepeatVO>) list("EzResourceDAO.getRepResourceRepeat", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetRepResourceVO> getRepResource(Map<String, Object> map) {
		return (List<ResGetRepResourceVO>) list("EzResourceDAO.getRepResource", map);
	}
	
	public ResGetScheduleListTermVO getScheduleListTerm(Map<String, Object> map){
		return  (ResGetScheduleListTermVO) select("EzResourceDAO.getScheduleListTerm", map);
	}
	
	public ResGetAdminFlagVO getAdmFlag(Map<String, Object> map) {
		return (ResGetAdminFlagVO) select("EzResourceDAO.getAdmFlag", map);
	}
	
	public ResGetRepDateTimesVO getRepDateTimes(Map<String, Object> map) {
		return (ResGetRepDateTimesVO) select("EzResourceDAO.getRepDateTimes", map);
	}
	
	public ResBrdVO getBrd(Map<String, Object> map) {
		return (ResBrdVO) select("EzResourceDAO.getBrd", map);
	}
	
	public ResGetScheduleVO getSchedule(Map<String, Object> map) {
		return (ResGetScheduleVO) select("EzResourceDAO.getSchedule", map);
	}
	
	public ResSelectFormIDVO selectFormID(Map<String, Object> map) {
		return (ResSelectFormIDVO) select("EzResourceDAO.selectFormID", map);
	}
	
	public ResGetRepResourceVO chkDeletedRepResource(Map<String, Object> map) {
		return (ResGetRepResourceVO) select("EzResourceDAO.chkDeletedRepResource", map);
	}
	
	public ResAdminVO getResourceAdminInfo(Map<String, Object> map) {
		return (ResAdminVO) select("EzResourceDAO.getResourceAdminInfo", map);
	}
	
	public ResGetSendMailToUserVO getSendMailToUser(Map<String, Object> map) {
		return (ResGetSendMailToUserVO) select("EzResourceDAO.getSendMailToUser", map);
	}
	
	public String getAclTblBrd(Map<String, Object> map) {
		return (String) select("EzResourceDAO.getAclTblBrd", map);
	}
	
	public String getBrdApproveFlag(Map<String, Object> map) {
		return (String) select("EzResourceDAO.getBrdApproveFlag", map);
	}
	
	public String getAclTblBrd_S1(Map<String, Object> map) {
		return (String) select("EzResourceDAO.getAclTblBrd_S1", map);
	}
	
	public String getAclTblBrd_S2(Map<String, Object> map) {
		return (String) select("EzResourceDAO.getAclTblBrd_S2", map);
	}
	
	public String getAclTblBrd_S3(Map<String, Object> map) {
		return (String) select("EzResourceDAO.getAclTblBrd_S3", map);
	}
	
	public String delResSch_S1(Map<String , Object> map) {
		return (String)select("EzResourceDAO.delResSch_S1", map);
	}
	
	public String modifyResSch_S1(Map<String , Object> map) {
		return (String)select("EzResourceDAO.modifyResSch_S1", map);
	}
	
	public String modifyResSch_S2(Map<String , Object> map) {
		return (String)select("EzResourceDAO.modifyResSch_S2", map);
	}
	
	public String addRessch_S1(Map<String , Object> map) {
		return (String)select("EzResourceDAO.addRessch_S1", map);
	}
	
	public int addResData_S1(Map<String , Object> map) {
		return (int) select("EzResourceDAO.addResData_S1", map);
	}
	
	public int addResData_S2(Map<String, Object> map) {
		return (int) select("EzResourceDAO.addResData_S2", map);
	}
	
	public int addResData_S3(Map<String, Object> map) {
		return (int) select("EzResourceDAO.addResData_S3", map);
	}
	
	public int getBrdCnt(Map<String , Object> map) {
		return (int)select("EzResourceDAO.getBrdCnt", map);
	}
	
	public int insertScheduleRepetition_S(Map<String , Object> map) {
		return (int)select("EzResourceDAO.insertScheduleRepetition_S", map);
	}
	
	public int insertForm_S(Map<String , Object> map) {
		return (int)select("EzResourceDAO.insertForm_S", map);
	}
	
	public int delResSch_S2(Map<String , Object> map) {
		return (int)select("EzResourceDAO.delResSch_S2", map);
	}
	
	public void addResData(Map<String, Object> map) {
		insert("EzResourceDAO.addResData", map);
	}
	
	public void insertScheduleRepetition(Map<String, Object> map) {
		insert("EzResourceDAO.insertScheduleRepetition", map);
	}
	
	public void insertForm(Map<String, Object> map) {
		insert("EzResourceDAO.insertForm", map);
	}
	
	public void addResSch(Map<String, Object> map) {
		insert("EzResourceDAO.addRessch", map);
	}
	
	public void insertForm_I(Map<String, Object> map) {
		insert("EzResourceDAO.insertForm_I", map);
	}
	
	public void delResSch_I(Map<String, Object> map) {
		insert("EzResourceDAO.delResSch_I", map);
	}
	
	public void modifyResSch_I1(Map<String, Object> map) {
		insert("EzResourceDAO.modifyResSch_I1", map);
	}
	
	public void modifyResSch_I2(Map<String, Object> map) {
		insert("EzResourceDAO.modifyResSch_I2", map);
	}
	
	public void modifyResData(Map<String, Object> map) {
		update("EzResourceDAO.modifyResData", map);
	}
	
	public void updateSchedule(Map<String, Object> map) {
		update("EzResourceDAO.updateSchedule", map);
	}
	
	public void updateScheduleDateTime(Map<String, Object> map) {
		update("EzResourceDAO.updateScheduleDateTime", map);
	}
	
	public void updateScheduleRepetition(Map<String, Object> map) {
		update("EzResourceDAO.updateScheduleRepetition", map);
	}
	
	public void modifyResSch(Map<String, Object> map) {
		update("EzResourceDAO.modifyResSch", map);
	}
	
	public void delResData_U(Map<String, Object> map) {
		update("EzResourceDAO.delResData_U", map);
	}
	
	public void insertForm_U(Map<String, Object> map) {
		update("EzResourceDAO.insertForm_U", map);
	}
	
	public void delResSch_U(Map<String, Object> map) {
		update("EzResourceDAO.delResSch_U", map);
	}
	
	public int modifyResSch_U1(Map<String, Object> map) {
		return update("EzResourceDAO.modifyResSch_U1", map);
	}
	
	public void modifyResSch_U2(Map<String, Object> map) {
		update("EzResourceDAO.modifyResSch_U2", map);
	}
	
	public void delResData(Map<String, Object> map) {
		delete("EzResourceDAO.delResData", map);
	}
	
	public void delResData1(Map<String, Object> map) {
		delete("EzResourceDAO.delResData1", map);
	}
	
	public void delResData3(Map<String, Object> map) {
		delete("EzResourceDAO.delResData3", map);
	}
	
	public void deleteRepetition(Map<String, Object> map) {
		delete("EzResourceDAO.deleteRepetition", map);
	}
	
	public void delFormID(Map<String, Object> map) {
		delete("EzResourceDAO.delFormID", map);
	}
	
	public void delResSch(Map<String, Object> map) {
		delete("EzResourceDAO.delResSch", map);
	}
	
	public void delResSch_D1(Map<String, Object> map) {
		delete("EzResourceDAO.delResSch_D1", map);
	}
	
	public void delResSch_D2(Map<String, Object> map) {
		delete("EzResourceDAO.delResSch_D2", map);
	}
	
	public void delResSch_D3(Map<String, Object> map) {
		delete("EzResourceDAO.delResSch_D3", map);
	}
	
	public void modifyResSch_D1(Map<String, Object> map) {
		delete("EzResourceDAO.modifyResSch_D1", map);
	}
	
	public void modifyResSch_D2(Map<String, Object> map) {
		delete("EzResourceDAO.modifyResSch_D2", map);
	}
	
	
}

