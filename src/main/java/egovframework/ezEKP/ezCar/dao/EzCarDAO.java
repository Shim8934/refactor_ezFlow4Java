package egovframework.ezEKP.ezCar.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezCar.vo.CarBrdListVO;
import egovframework.ezEKP.ezCar.vo.CarBrdVO;
import egovframework.ezEKP.ezCar.vo.CarFormListVO;
import egovframework.ezEKP.ezCar.vo.CarGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetClsAclListVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzCarDAO")
public class EzCarDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<CarGetAdmSubClsTreeVO> getAdmSubClsTree(Map<String, Object> map){
		return  (List<CarGetAdmSubClsTreeVO>) list("EzCarDAO.getAdmSubClsTree", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CarGetAdmSubClsTreeVO> getAdmSubClsTreeUser(Map<String, Object> map){
		return  (List<CarGetAdmSubClsTreeVO>) list("EzCarDAO.getAdmSubClsTreeUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CarGetAdmSubClsTreeVO> getSubClsTree(Map<String, Object> map){
		return  (List<CarGetAdmSubClsTreeVO>) list("EzCarDAO.getSubClsTree", map);
	}

	public int getTotalCnt(Map<String, Object> map) {
		return (int) select("EzCarDAO.getTotalCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CarBrdListVO> getCarList(Map<String, Object> map){
		return  (List<CarBrdListVO>) list("EzCarDAO.getCarList", map);
	}
	
	public void deleteCar(Map<String, Object> map) throws Exception {
		delete("EzCarDao.deleteCar", map);
	}
	
	public int addCarData_S1(Map<String , Object> map) {
		return (int) select("EzCarDAO.addCarData_S1", map);
	}
	
	public int addCarData_S2(Map<String, Object> map) {
		return (int) select("EzCarDAO.addCarData_S2", map);
	}
	
	public int addCarData_S3(Map<String, Object> map) {
		return (int) select("EzCarDAO.addCarData_S3", map);
	}
	
	public void addCarData(Map<String, Object> map) {
		insert("EzCarDAO.addCarData", map);
	}

	public void addAttachFile(Map<String, Object> map) {
		insert("EzCarDAO.addAttachFile", map);
	}
	
	public CarBrdVO getBrd(Map<String, Object> map) {
		return (CarBrdVO) select("EzCarDAO.getBrd", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getAttachList(Map<String, Object> map) {
		return (List<String>) list("EzCarDAO.getAttachList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CarFormListVO> getCarFormList(Map<String, Object> map){
		return  (List<CarFormListVO>) list("EzCarDAO.getCarFormList", map);
	}
	@SuppressWarnings("unchecked")
	public List<CarFormListVO> getCarForm3(Map<String, Object> map){
		return  (List<CarFormListVO>) list("EzCarDAO.getCarForm3", map);
	}
	
	public void modifyCarData(Map<String, Object> map) {
		update("EzCarDAO.modifyCarData", map);
	}
	
	public void delAttachFile(Map<String, Object> map) {
		delete("EzCarDAO.delAttachFile", map);
	}
	
	public int getBrdCnt(Map<String , Object> map) {
		return (int)select("EzCarDAO.getBrdCnt", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CarBrdListVO> getBrdList(Map<String, Object> map){
		return  (List<CarBrdListVO>) list("EzCarDAO.getBrdList", map);
	}
	
	public int getMaxCarFormId(Map<String, Object> map){
		return (int)select("EzCarDAO.getMaxCarFormId", map);
	}
	
	public void addCarForm(Map<String, Object> map){
		insert("EzCarDAO.addCarForm", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CarFormListVO> getCarForm(Map<String, Object> map){
		return  (List<CarFormListVO>) list("EzCarDAO.getCarForm", map);
	}
	
	public void modifyCarForm(Map<String, Object> map){
		update("EzCarDAO.modifyCarForm", map);
	}
	
	public void deleteCarForm(Map<String, Object> map) throws Exception {
		delete("EzCarDao.deleteCarForm", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<CarFormListVO> getCarForm2(Map<String, Object> map){
		return  (List<CarFormListVO>) list("EzCarDAO.getCarForm2", map);
	}

	public String getAclTblBrd_S3(Map<String, Object> map) {
		return (String) select("EzCarDAO.getAclTblBrd_S3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<ResGetClsAclListVO> getDeptAcl(Map<String, Object> map) {
		return (List<ResGetClsAclListVO>) list("EzCarDAO.getDeptAcl", map);
	}
	
	public ResGetAdminFlagVO getAdmFlag(Map<String, Object> map) {
		return (ResGetAdminFlagVO) select("EzCarDAO.getAdmFlag", map);
	}
	
	public String getCarUpper(Map<String, Object> map) {
		return (String) select("EzCarDAO.getCarUpper", map);
	}
	
	
	public String getAddJob(Map<String, Object> map) {
		return (String) select("EzCarDAO.getAddJob", map);
	}

	
}