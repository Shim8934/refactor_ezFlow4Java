package egovframework.ezEKP.ezResource.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResDateVO;
import egovframework.ezEKP.ezResource.vo.ResFavoriteCategoryVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResOccuVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

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
	public List<ResGetScheduleVO> getScheduleList(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("EzResourceDAO.getScheduleList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResDateVO> getScheduleDateList(Map<String, Object> map){
		return  (List<ResDateVO>) list("EzResourceDAO.getScheduleDateList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleRepetitionVO> getScheduleRepetition(Map<String, Object> map){
		return  (List<ResGetScheduleRepetitionVO>) list("EzResourceDAO.getScheduleRepetition", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleListMain(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("EzResourceDAO.getScheduleListMain", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleListRepetiti(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("EzResourceDAO.getScheduleListRepetiti", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getScheduleListRepetitim(Map<String, Object> map){
		return  (List<ResGetScheduleVO>) list("EzResourceDAO.getScheduleListRepetitim", map);
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
	public List<ResGetScheduleRepetitionVO> getRepResourceRepeat(Map<String, Object> map) {
		return (List<ResGetScheduleRepetitionVO>) list("EzResourceDAO.getRepResourceRepeat", map);
	}
	
	/*@SuppressWarnings("unchecked")
	public List<ResGetScheduleVO> getRepResource(Map<String, Object> map) {
		return (List<ResGetScheduleVO>) list("EzResourceDAO.getRepResource", map);
	}*/
	
	@SuppressWarnings("unchecked")
	public List<String> getDeletedRepScheduleDate(Map<String, Object> map) {
		return (List<String>) list("EzResourceDAO.getDeletedRepScheduleDate", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getAttachList(Map<String, Object> map) {
		return (List<String>) list("EzResourceDAO.getAttachList", map);
	}
	
	public ResGetAdminFlagVO getAdmFlag(Map<String, Object> map) {
		return (ResGetAdminFlagVO) select("EzResourceDAO.getAdmFlag", map);
	}
	
	public ResGetScheduleRepetitionVO getRepDateTimes(Map<String, Object> map) {
		return (ResGetScheduleRepetitionVO) select("EzResourceDAO.getRepDateTimes", map);
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
	
	/*public ResGetScheduleVO chkDeletedRepResource(Map<String, Object> map) {
		return (ResGetScheduleVO) select("EzResourceDAO.chkDeletedRepResource", map);
	}*/
	
	@SuppressWarnings("unchecked")
	public List<ResAdminVO> getResourceAdminInfo(Map<String, Object> map) {
		return (List<ResAdminVO>) list("EzResourceDAO.getResourceAdminInfo", map);
	}
	
	public ResGetSendMailToUserVO getSendMailToUser(Map<String, Object> map) {
		return (ResGetSendMailToUserVO) select("EzResourceDAO.getSendMailToUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<OrganUserVO> getOwnerInfo(Map<String, Object> map) {
		return (List<OrganUserVO>) list("EzResourceDAO.getOwnerInfo", map);
	}
	
	public String getBrdApproveFlag(Map<String, Object> map) {
		return (String) select("EzResourceDAO.getBrdApproveFlag", map);
	}

	public String getBrdRepeatFlag(Map<String, Object> map) {
		return (String) select("EzResourceDAO.getBrdRepeatFlag", map);
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
	
	public int insertForm_S(Map<String , Object> map) {
		return (int)select("EzResourceDAO.insertForm_S", map);
	}
	
	public int delResSch_S2(Map<String , Object> map) {
		return (int)select("EzResourceDAO.delResSch_S2", map);
	}
	
	public int addRessch_S2(Map<String , Object> map) {
		return (int)select("EzResourceDAO.addRessch_S2", map);
	}
	
	public String addRessch_S3(Map<String , Object> map) {
		return (String)select("EzResourceDAO.addRessch_S3", map);
	}
	
	public String getDeptID(Map<String , Object> map) {
		return (String)select("EzResourceDAO.getDeptID", map);
	}
	
	public void addResData(Map<String, Object> map) {
		insert("EzResourceDAO.addResData", map);
	}
	
	public void insertScheduleRepetition(Map<String, Object> map) {
		insert("EzResourceDAO.insertScheduleRepetition", map);
	}
	
	public void addResSch(Map<String, Object> map) {
		insert("EzResourceDAO.addRessch", map);
	}
	
	public void insertForm_I(Map<String, Object> map) {
		insert("EzResourceDAO.insertForm_I", map);
	}
	
	public void copyResSch(Map<String, Object> map) {
		insert("EzResourceDAO.copyResSch", map);
	}
	
	public void modifyResSch_I1(Map<String, Object> map) {
		insert("EzResourceDAO.modifyResSch_I1", map);
	}
	
	public void modifyResSch_I2(Map<String, Object> map) {
		insert("EzResourceDAO.modifyResSch_I2", map);
	}
	
	public void addAttachFile(Map<String, Object> map) {
		insert("EzResourceDAO.addAttachFile", map);
	}
	
	public void modifyResData(Map<String, Object> map) {
		update("EzResourceDAO.modifyResData", map);
	}
	
	public void updateSchedule(Map<String, Object> map) {
		update("EzResourceDAO.updateSchedule", map);
	}
	
	public void updateSchedule2(Map<String, Object> map) {
		update("EzResourceDAO.updateSchedule2", map);
	}
	
	public void updateScheduleDateTime(Map<String, Object> map) {
		update("EzResourceDAO.updateScheduleDateTime", map);
	}
	
	public void updateScheduleRepetition(Map<String, Object> map) {
		update("EzResourceDAO.updateScheduleRepetition", map);
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
	
	public void delAttachFile(Map<String, Object> map) {
		delete("EzResourceDAO.delAttachFile", map);
	}
	
	public String getResourceOrder(Map<String, Object> map) throws Exception {
		return (String) select("EzResourceDAO.getResourceOrder", map);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getTargetResourceOrder(Map<String, Object> map) throws Exception {
		return (Map<String, Object>) select("EzResourceDAO.getTargetResourceOrder", map);
	}
	
	public void changeResourceOrder(Map<String, Object> map) throws Exception {
		update("EzResourceDAO.ChangeResourceOrder", map);
	}
	
	public String getMaxBrdStepInSelectedResourceGroup(Map<String, Object> map) throws Exception {
		return (String) select("EzResourceDAO.getMaxBrdStepInSelectedResourceGroup", map);
	}
	
	public void moveResourceToOtherResourceGroup(Map<String, Object> map) throws Exception {
		update("EzResourceDAO.moveResourceToOtherResourceGroup", map);
	}
	
	public String isResourceGroupManager(Map<String, Object> map) throws Exception {
		return (String) select("EzResourceDAO.isResourceGroupManager", map);
	}
	
	public String getIsDept(Map<String, Object> map) throws Exception {
		return (String) select("EzResourceDAO.getIsDept", map);
	}
	
	public void getDeptAccessLvl(Map<String, Object> map) throws Exception {
		update("EzResourceDAO.getDeptAccessLvl", map);
	}
	
	public String userResPermissionCheck(Map<String, Object> map) throws Exception {
		return (String) select("EzResourceDAO.userResPermissionCheck", map);
	}

	@SuppressWarnings("unchecked")
	public List<ResBrdVO> getResourcePortlet(Map<String, Object> map) throws Exception {
		return (List<ResBrdVO>) list("EzResourceDAO.getResourcePortlet", map);
	}
	
	public void cleanResourcePortlet(Map<String, Object> map) throws Exception {
		delete("EzResourceDAO.cleanResourcePortlet", map);
	}

	public void insertResourcePortlet(Map<String, Object> map) throws Exception {
		insert("EzResourceDAO.insertResourcePortlet", map);
	}

	@SuppressWarnings("unchecked")
	public List<ResGetClsAclListVO> getDeptAcl(Map<String, Object> map) {
		return (List<ResGetClsAclListVO>) list("EzResourceDAO.getDeptAcl", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResOccuVO> getResOccuList(Map<String, Object> map) {
		return (List<ResOccuVO>) list("EzResourceDAO.getResOccuList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResOccuVO> getScheduleListRepetiti2(Map<String, Object> map){
		return  (List<ResOccuVO>) list("EzResourceDAO.getScheduleListRepetiti2", map);
	}
	public String getNewFavoriteCategoryId() throws Exception{
		return (String) select("EzResourceDAO.getNewFavoriteCategoryId");
	}

	public Object insertFavoriteCategory(Map<String, Object> map) throws Exception {
		return insert("EzResourceDAO.insertFavoriteCategory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResFavoriteCategoryVO> selectFavoriteCategoryList(Map<String, Object> map) throws Exception {
		return (List<ResFavoriteCategoryVO>) list("EzResourceDAO.selectFavoriteCategoryList", map);
	}

	public Object updateFavoriteCategory(Map<String, Object> map) throws Exception {
		return update("EzResourceDAO.updateFavoriteCategory", map);
	}

	public void delFavoriteCategory(Map<String, Object> map) throws Exception {
		delete("EzResourceDAO.delFavoriteCategory", map);
	}

	public void insertBrdFavoriteCategory(Map<String, Object> map) throws Exception {
		insert("EzResourceDAO.insertBrdFavoriteCategory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResBrdVO> selectFavoriteBrdList(Map<String, Object> map) throws Exception {
		return (List<ResBrdVO>) list("EzResourceDAO.selectFavoriteBrdList", map);
	}

	public int selectBrdFavoriteCategoryList(Map<String, Object> map) throws Exception {
		return (int) select("EzResourceDAO.selectBrdFavoriteCategoryList", map);
	}

	public void updateFavoriteCategoryBrdYN(Map<String, Object> map) throws Exception {
		update("EzResourceDAO.updateFavoriteCategoryBrdYN", map);
	}

	public void moveCategoryToCategory(Map<String, Object> map) throws Exception {
		update("EzResourceDAO.moveCategoryToCategory", map);
	}

	public void deleteChildList(Map<String, Object> map) throws Exception {
		delete("EzResourceDAO.deleteChildList", map);
	}

	public void deleteCatBrd(Map<String, Object> map) throws Exception {
		delete("EzResourceDAO.deleteCatBrd", map);
	}

	public void moveBrdCategoryToCategory(Map<String, Object> map) throws Exception {
		update("EzResourceDAO.moveBrdCategoryToCategory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> checkChildYN(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzResourceDAO.checkChildYN", map);
	}

	public ResFavoriteCategoryVO selectFavoriteCategory(Map<String, Object> map) throws Exception {
		return (ResFavoriteCategoryVO) select("EzResourceDAO.selectFavoriteCategory", map);
	}

	public int selectBrdCategoryCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzResourceDAO.selectBrdCategoryCnt", map);
	}

	public void deleteBrdFavoriteCategory(Map<String, Object> map) throws Exception {
		delete("EzResourceDAO.deleteBrdFavoriteCategory", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> delBrdCatList(Map<String, Object> map) throws Exception {
		return (List<String>) list("EzResourceDAO.delBrdCatList", map);
	}
	
	public void delResData_F(Map<String, Object> map) throws Exception {
		delete("EzResourceDAO.delResData_F", map);
	}

	public int selectBrdCnt(Map<String, Object> map) throws Exception {
		return (int) select("EzResourceDAO.selectBrdCnt", map);
	}

	public void updateFavoriteCategoryBrdYN2(Map<String, Object> map) throws Exception {
		update("EzResourceDAO.updateFavoriteCategoryBrdYN2", map);
	}

	public void delResDataForm(Map<String, Object> map) throws Exception {
		delete("EzResourceDAO.delResDataForm", map);
	}
	
	// 2024-08-26 유길상 - 최대 예약 가능 기간 조회
	public String selectResMaxDate(Map<String, Object> map) throws Exception {
		return (String) select("EzResourceDAO.selectResMaxDate", map);
	}
}