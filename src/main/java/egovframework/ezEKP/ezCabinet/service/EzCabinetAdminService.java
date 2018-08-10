package egovframework.ezEKP.ezCabinet.service;

import java.util.List;
import org.json.simple.JSONArray;
import egovframework.ezEKP.ezCabinet.vo.CabinetModuleVO;
import egovframework.ezEKP.ezCabinet.vo.CompanyCapacityVO;
import egovframework.ezEKP.ezCabinet.vo.UserCapacityVO;

public interface EzCabinetAdminService {
	//Company capacity functions
	CompanyCapacityVO getCompanyCapacity(String companyId, int tenantId) throws Exception;
	void saveCompanyCapacity(int type, double newValue, String companyId, int tenantId) throws Exception;
	
	//Admin capacity functions
	List<UserCapacityVO> getListUserCapacity(String realColmn, String order, String companyId, String searchStr, String searchOpt, int startPoint, int listCnt, int tenantId, String primary) throws Exception;
	int getTotalListUserCapacity(String companyId, String searchStr, String searchOpt, int tenantId, String primary) throws Exception;
	void changeUserCapacity(List<String> userList, double newValue, int type, String companyId, int tenantId) throws Exception;
	UserCapacityVO getUserCapacity(String userId, String companyId, String primary, int tenantId) throws Exception;
	
	//Admin module functions
	List<CabinetModuleVO> getModuleListForAdmin(String companyId, int tenantId) throws Exception;
	void saveModulesSetting(JSONArray modules, String companyId, int tenantId) throws Exception;
	
	
	

}
