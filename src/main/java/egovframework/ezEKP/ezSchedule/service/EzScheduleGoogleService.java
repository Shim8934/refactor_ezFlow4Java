package egovframework.ezEKP.ezSchedule.service;

import java.util.List;

import org.json.simple.JSONObject;

import com.google.api.services.calendar.model.Event;

import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzScheduleGoogleService {
	
	public String getIsSync(LoginVO userInfo) throws Exception;
	
	public String authorize() throws Exception;
	
	public JSONObject getReturnMessage(String code, String userID, String companyID, int tenantID);

	public List<ScheduleInfoVO> getGoogleScheduleList(String startDate, String endDate, LoginVO userinfo, String memberId, String scheduleFlag, String memberName) throws Exception;

	public void checkGoogleToken(String type) throws Exception;
	
	public Event getGoogleScheduleInfo(String googleid, LoginVO loginVO, String readFlag, String memberId) throws Exception;
}
