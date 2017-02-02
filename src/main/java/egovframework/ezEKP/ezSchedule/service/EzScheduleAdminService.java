package egovframework.ezEKP.ezSchedule.service;

public interface EzScheduleAdminService {
	
	public String scheduleGetShareManage(String lang, int tenantId) throws Exception;

	public void scheduleDelShareDept(String id, int tenantId) throws Exception;

	public void scheduleSaveShareDept(String userID, String userName, String userName2, String deptID, String deptName, String deptName2, int tenantId) throws Exception;

	public void scheduleDelHoliday(String holidayID, int tenantId) throws Exception;

	public void scheduleChangeHolidayUse(String holidayID, String isUse, int tenantId) throws Exception;

	public void scheduleSaveHoliday(String holidayName, String holidayName2, String holidayDate, String isSolar, String isRepeat, String isRest, String companyID, int tenantId) throws Exception;

	public void scheduleUpdateHoliday(String holidayName, String holidayName2, String holidayDate, String isSolar, String isRepeat, String isRest, String companyID, int tenantId, String holidayID) throws Exception;

	public void scheduleInsertLunarUse(String companyID, String lunarUse, int tenantId) throws Exception;

	public void scheduleUpdateLunarUse(String companyID, String lunarUse, int tenantId) throws Exception;

	public void scheduleInsertRegi(String companyID, String regi, int tenantId) throws Exception;

	public void scheduleUpdateRegi(String companyID, String regi, int tenantId) throws Exception;
	
}
