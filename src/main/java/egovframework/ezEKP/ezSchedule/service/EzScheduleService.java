package egovframework.ezEKP.ezSchedule.service;

import java.util.List;

import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheHqVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheSecVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;


public interface EzScheduleService {
	List<ScheGetHolidayVO> getTholiday (String companyID, String userCompany) throws Exception;
	ScheduleConfigVO getScheduleConfig(String userId) throws Exception;
	ScheduleInfoVO getScheduleInfo(String scheduleId) throws Exception;
	List<AttendantListVO> getAttendantList(String scheduleId) throws Exception;
	List<AttachListVO> getAttachList(String scheduleId) throws Exception;
	List<PubScheHqVO> getPublicScheduleHq(String userId) throws Exception;
	List<PubScheSecVO> getPublicScheduleSec(String userId, String lang) throws Exception;
	List<PubScheDeptVO> getPublicScheduleDept(String userId, String lang) throws Exception;
	List<PubScheCumulerVO> getPublicScheduleCumuler(String userId, String lang) throws Exception;
	public int getReceiveCount (String pUserId) throws Exception;
	public int getInviteScheduleGroupCnt (String pUserId) throws Exception;

	public void scheduleNewItem(ScheduleInfoVO scheduleInfoVO) throws Exception;
}
