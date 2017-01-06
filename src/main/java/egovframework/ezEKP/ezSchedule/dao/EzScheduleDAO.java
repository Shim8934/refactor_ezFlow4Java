package egovframework.ezEKP.ezSchedule.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheHqVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheSecVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGmailInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.UserLocalInfoVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzScheduleDAO")
public class EzScheduleDAO extends EgovAbstractDAO {
	
	@SuppressWarnings("unchecked")
	public List<ScheGetHolidayVO> getTholiday(Map<String, Object> map){
		return  (List<ScheGetHolidayVO>) list("EzScheduleDAO.getTholiday", map);
	}
		
	public ScheduleConfigVO getScheduleConfig(Map<String, Object> map){
		return (ScheduleConfigVO) select("EzScheduleDAO.getScheduleConfig", map);
	}
	
	public ScheduleInfoVO getScheduleInfo(Map<String, Object> map){
		return (ScheduleInfoVO) select("EzScheduleDAO.getScheduleInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttendantListVO> getAttendantList(Map<String, Object> map){
		return (List<AttendantListVO>) list("EzScheduleDAO.getAttendantList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<AttachListVO> getAttachList(Map<String, Object> map){
		return (List<AttachListVO>) list("EzScheduleDAO.getAttachList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubScheHqVO> getPublicScheduleHq(Map<String, Object> map){
		return (List<PubScheHqVO>) list("EzScheduleDAO.getPublicScheduleHq", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubScheSecVO> getPublicScheduleSec(Map<String, Object> map){
		return (List<PubScheSecVO>) list("EzScheduleDAO.getPublicScheduleSec", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubScheDeptVO> getPublicScheduleDept(Map<String, Object> map){
		return (List<PubScheDeptVO>) list("EzScheduleDAO.getPublicScheduleDept", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PubScheCumulerVO> getPublicScheduleCumuler(Map<String, Object> map){
		return (List<PubScheCumulerVO>) list("EzScheduleDAO.getPublicScheduleCumuler", map);
	}

	public int getNewScheduleId(Map<String, Object> map) {
		select("EzScheduleDAO.getNewScheduleId", map);
		return (int) map.get("v_pScheduleId");
	}

	public int getReceiveCount(Map<String, Object> map) {
		select("EzScheduleDAO.getReceiveCount", map);
		return (int) map.get("v_pCount");
	}

	public int getInviteScheduleGroupCnt(Map<String, Object> map) {
		select("EzScheduleDAO.getInviteScheduleGroupCnt", map);
		return (int) map.get("v_pCount");
	}

	public String getConfigInfo(Map<String, Object> map) {
		select("EzScheduleDAO.getConfigInfo", map);
		return (String) map.get("v_pConfigInfo");
	}

	public UserLocalInfoVO getUserLocalInfo(Map<String, Object> map) {
		select("EzScheduleDAO.getUserLocalInfo", map);
		return (UserLocalInfoVO) map.get("ezScheduleDaO.getUserLocalInfo");
	}	
	
	@SuppressWarnings("unchecked")
	public List<ScheduleGmailInfoVO> getScheduleGmailInfo(Map<String, Object> map){
		return (List<ScheduleGmailInfoVO>) list("EzScheduleDAO.getScheduleGmailInfo", map);
	}
	
	public void scheduleNewItem(ScheduleInfoVO scheduleInfoVO) throws Exception{
		insert("EzScheduleDAO.scheduleNewItem", scheduleInfoVO);
	}

	@SuppressWarnings("unchecked")
	public List<ScheduleGroupListVO> getScheduleGroupList(String userID) throws Exception {
		return (List<ScheduleGroupListVO>) list("EzScheduleDAO.getScheduleGroupList", userID);
	}

	@SuppressWarnings("unchecked")
	public List<ScheduleInfoVO> getScheduleList(Map<String, Object> map) throws Exception  {
		return (List<ScheduleInfoVO>) list("EzScheduleDAO.getScheduleList", map);
	}
}

