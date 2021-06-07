package egovframework.ezEKP.ezSchedule.service;

import org.json.simple.JSONObject;

import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzScheduleGoogleService {
	
	public String getIsSync(LoginVO userInfo) throws Exception;
	
	public String authorize() throws Exception;
	
	public JSONObject getReturnMessage(String code, String userID, String companyID, int tenantID);
}
