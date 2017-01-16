package egovframework.ezEKP.ezSchedule.lib;

import java.util.List;

import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGmailInfoVO;
import egovframework.ezEKP.ezSchedule.vo.UserLocalInfoVO;

public interface EzScheduleInfo {
	UserLocalInfoVO		GetUserLocalInfo(String pUserID);
	
	List<ScheduleGmailInfoVO>	GetScheduleGmailInfo(String pUserID);
	
	ScheduleConfigVO	GetConfigInfo(String pUserID);
}
