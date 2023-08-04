package egovframework.ezEKP.ezCar.service;

import java.util.List;
import java.util.Locale;














import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezCar.vo.CarBrdListVO;
import egovframework.ezEKP.ezCar.vo.CarBrdVO;
import egovframework.ezEKP.ezCar.vo.CarFormListVO;

public interface EzCarService {
	
	public String getSubClsTree(String xmlReq, String lang, String companyID, String deptID, String id, int tenantID) throws Exception;
	public String getSubClsTreeUser(String xmlReq, String lang, String companyID, String deptID, String id, int tenantID) throws Exception;
	public int getTotalCnt(String carID, String companyID) throws Exception;
	public List<CarBrdListVO> getCarList(int carID, String companyID, int tenantID) throws Exception; 
	public void deleteCar(String carID, int tenantId, String companyID) throws Exception;
/*	public String getAdminFlag(String companyID, String brdID, String id, int tenantID, String deptID) throws Exception;
*/
	public boolean addCarData(HttpServletRequest request, String xmlStr, int tenantID,Locale locale) throws Exception;
	public CarBrdVO getBrd(int brdID, String companyID, int tenantID) throws Exception;
	public List<String> getAttachList(String carID, String companyID, int tenantID) throws Exception;
	public List<CarFormListVO> getCarFormList(int carID, String companyID, int tenantID, String currentDate) throws Exception;
	
	public boolean modifyCarData(String xmlStr, int tenantID) throws Exception;
	
	public int getBrdCnt(int brdID, String companyID, int tenantID) throws Exception;
	public List<CarBrdListVO> getBrdList(int topCnt, int brdID, String CompanyID, String ownDeptNm, String ownerNm, String ownerPosition, String brdNm, int tenantID) throws Exception;
	public int getMaxCarFormId(String carID, int tenantID, String CompanyID) throws Exception;
	public boolean addCarForm(String companyID, String id, int tenantID, String currentDate ,String carID, int car_form_id, String rev_date, 
			String rev_time, String rev_time2, String driverdeptname, String dirvername, String s2timepicker, String bdistance, String drivepurpose, 
			String drivepoint, String s3timepicker, String adistance, String adistanceauto, String adistancecommute, String adistancework, String adistanceetc, int j, String control) throws Exception;
	public List<CarFormListVO> getCarForm(String carID, int car_form_id, String companyID, int tenantID) throws Exception;
	public void modifyCarForm(int car_form_id, int car_form_id2, String carID, String companyID, int tenantID, String currentDate) throws Exception;
	public void deleteCarForm(String car_form_id, String carID, int tenantId, String companyID) throws Exception;
	public List<CarFormListVO> getCarFormList2(int carID, String companyID, int tenantID, String yearMonth) throws Exception;
	public List<CarFormListVO> getCarFormList3(int carID, String companyID, int tenantID, String yearMonth, String carFormID) throws Exception;
	public String getAdminFlag(String companyID, String brdID, String userID, int tenantID, String deptID) throws Exception;
	public String getAdminFlagForm(String companyID, String brdID, String userID, int tenantID, String deptID) throws Exception;
}
