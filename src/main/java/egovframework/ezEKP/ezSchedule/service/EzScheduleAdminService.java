package egovframework.ezEKP.ezSchedule.service;

public interface EzScheduleAdminService {
	
	public String scheduleGetShareManage(String lang) throws Exception;

	public void scheduleDelShareDept(String id) throws Exception;

	public void scheduleSaveShareDept(String userID, String userName, String userName2, String deptID, String deptName, String deptName2) throws Exception;
	
}
