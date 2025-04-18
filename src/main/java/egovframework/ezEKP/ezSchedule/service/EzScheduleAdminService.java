package egovframework.ezEKP.ezSchedule.service;

import java.util.List;

import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupVO;
import egovframework.let.user.login.vo.LoginVO;
import org.springframework.web.multipart.MultipartFile;

public interface EzScheduleAdminService {
	
	public String scheduleGetShareManage(String lang, int tenantId, String companyID) throws Exception;

	public void scheduleDelShareDept(String id, int tenantId) throws Exception;

	public void scheduleSaveShareDept(String userID, String userName, String userName2, String deptID, String deptName, String deptName2, int tenantId, String companyID) throws Exception;

	public void scheduleDelHoliday(String holidayID, int tenantId) throws Exception;

	public void scheduleChangeHolidayUse(String holidayID, String isUse, int tenantId) throws Exception;

	public String scheduleSaveHoliday(String holidayName, String holidayName2, String holidayFlag, String holidayDate, String holidayRepeat, String isSolar, String isRepeat, String isRest, String companyID, int tenantId) throws Exception;

	public void scheduleUpdateHoliday(String holidayName, String holidayName2, String holidayFlag, String holidayDate, String holidayRepeat, String isSolar, String isRepeat, String isRest, String companyID, int tenantId, String holidayID) throws Exception;

	public void scheduleInsertLunarUse(String companyID, String lunarUse, int tenantId) throws Exception;

	public void scheduleUpdateLunarUse(String companyID, String lunarUse, int tenantId) throws Exception;

	public void scheduleInsertRegi(String companyID, String regi, int tenantId) throws Exception;

	public void scheduleUpdateRegi(String companyID, String regi, int tenantId) throws Exception;

	public int scheduleShareCheck(String userID, String deptID, int tenantId, String companyID) throws Exception;

	public List<ScheduleGroupListVO> getMyGroupList(String offset, String userId, int tenantId ,String companyID, String searchType2, String searchValue, String startDate, String endDate) throws Exception;
	
	public List<ScheduleGroupVO> getMyGroupList2 (String offset, String userId, int tenantId ,String companyID, String searchType2, String searchValue, String startDate, String endDate, int startRow, int maxItemPerPage, String primaryData) throws Exception;
	
	public int getMyGroupMemberListCnt(String groupId, String lang, int tenantId ,String companyID) throws Exception;
	
	public String scheduleGetExecutiveList(String cn, String companyID, int tenantId, String offset, String keyword, String lang, String companyName) throws Exception;
	
	public void scheduleSaveExecutive(String userID, int priority, String usage, String createUser, String companyID, int tenantID) throws Exception;
	
	public void scheduleUpdateExecutive(String userID, int priority, String usage, String createUser, String companyID, int tenantID) throws Exception;

	public void scheduleDelExecutive(String userID, String companyID, int tenantId) throws Exception;

	public void scheduleNumUpdateExecutive(String userID, int priority, String companyID, int tenantID) throws Exception;
	
	public String companyScheduleExcelUpload(String userID, MultipartFile uploadFile, String companyID, String companyName, String companyName2, LoginVO loginVO, String defaultPath, String content) throws Exception;
}
