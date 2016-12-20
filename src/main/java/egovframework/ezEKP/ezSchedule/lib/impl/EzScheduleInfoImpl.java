package egovframework.ezEKP.ezSchedule.lib.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezSchedule.dao.EzScheduleDAO;
import egovframework.ezEKP.ezSchedule.lib.EzScheduleInfo;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGmailInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.UserLocalInfoVO;

@Service("EzScheduleInfo")
public class EzScheduleInfoImpl implements EzScheduleInfo {
	@Resource(name="EzScheduleDAO")
	private EzScheduleDAO ezScheduleDAO;
	

	@Override
	public UserLocalInfoVO GetUserLocalInfo(String pUserID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserID);
		return ezScheduleDAO.getUserLocalInfo(map);
	};

	@Override
	public List<ScheduleGroupListVO> GetScheduleGroupList(String pUserID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserID);
		return ezScheduleDAO.getScheduleGroupList(map);
	};

	@Override
	public List<ScheduleGmailInfoVO> GetScheduleGmailInfo(String pUserID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserID);
		return ezScheduleDAO.getScheduleGmailInfo(map);
	};

	@Override
	public ScheduleConfigVO GetConfigInfo(String pUserID) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserID);
		return ezScheduleDAO.getScheduleConfig(map);
	}

}
