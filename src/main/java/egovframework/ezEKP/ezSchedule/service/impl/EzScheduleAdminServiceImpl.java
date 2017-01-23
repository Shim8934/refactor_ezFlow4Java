package egovframework.ezEKP.ezSchedule.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezSchedule.dao.EzScheduleAdminDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleAdminService;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.ezEKP.ezSchedule.vo.ScheduleShareVO;

@Service("EzScheduleAdminService")
public class EzScheduleAdminServiceImpl implements EzScheduleAdminService{
	
	@Resource(name="EzScheduleAdminDAO")
	private EzScheduleAdminDAO ezScheduleAdminDAO;
		
	@Autowired
	private CommonUtil commonUtil;

	
	@Override
	public String scheduleGetShareManage(String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGDATA", lang);
		
		List<ScheduleShareVO> list = ezScheduleAdminDAO.scheduleGetShareManage(map);
		
		StringBuilder sb = new StringBuilder("<DATA>");
		
		for (int i=0; i < list.size(); i++) {
			ScheduleShareVO vo = list.get(i);
			sb.append(commonUtil.getQueryResult(vo));
		}		
		sb.append("</DATA>");
				
		return sb.toString();
	}

	@Override
	public void scheduleDelShareDept(String id) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ID", id);
		
		ezScheduleAdminDAO.scheduleDelShareDept(map);
	}

	@Override
	public void scheduleSaveShareDept(String userID, String userName, String userName2, String deptID, String deptName, String deptName2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_USERNAME", userName);
		map.put("v_USERNAME2", userName2);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTNAME", deptName);
		map.put("v_DEPTNAME2", deptName2);
		
		ezScheduleAdminDAO.scheduleSaveShareDept(map);
		
	}
	
}

