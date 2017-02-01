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
	public String scheduleGetShareManage(String lang, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGDATA", lang);
		map.put("v_TENANTID", tenantId);
		
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
	public void scheduleDelShareDept(String id, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ID", id);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleAdminDAO.scheduleDelShareDept(map);
	}

	@Override
	public void scheduleSaveShareDept(String userID, String userName, String userName2, String deptID, String deptName, String deptName2, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_USERNAME", userName);
		map.put("v_USERNAME2", userName2);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTNAME", deptName);
		map.put("v_DEPTNAME2", deptName2);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleAdminDAO.scheduleSaveShareDept(map);
	}

	@Override
	public void scheduleDelHoliday(String holidayID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_HOLIDAYID", holidayID);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleAdminDAO.scheduleDelHoliday(map);
	}

	@Override
	public void scheduleChangeHolidayUse(String holidayID, String isUse, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_HOLIDAYID", holidayID);
		map.put("v_ISUSE", isUse);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleAdminDAO.scheduleChangeHolidayUse(map);		
	}

	@Override
	public void scheduleSaveHoliday(String holidayName, String holidayName2, String holidayDate, String isSolar, String isRepeat, String isRest, String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_HOLIDAYNAME", holidayName);
		map.put("v_HOLIDAYNAME2", holidayName2);
		map.put("v_HOLIDAYDATE", holidayDate);
		map.put("v_ISSOLAR", isSolar);
		map.put("v_ISREPEAT", isRepeat);
		map.put("v_ISREST", isRest);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantId);
		
		ezScheduleAdminDAO.scheduleSaveHoliday(map);
	}

	@Override
	public void scheduleUpdateHoliday(String holidayName, String holidayName2, String holidayDate, String isSolar, String isRepeat, String isRest, String companyID, int tenantId, String holidayID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_HOLIDAYNAME", holidayName);
		map.put("v_HOLIDAYNAME2", holidayName2);
		map.put("v_HOLIDAYDATE", holidayDate);
		map.put("v_ISSOLAR", isSolar);
		map.put("v_ISREPEAT", isRepeat);
		map.put("v_ISREST", isRest);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantId);		
		map.put("v_HOLIDAYID", holidayID);
		
		ezScheduleAdminDAO.scheduleUpdateHoliday(map);	
	}

	@Override
	public void scheduleInsertLunarUse(String companyID, String lunarUse, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_LUNARUSE", lunarUse);
		map.put("v_TENANTID", tenantId);
				
		ezScheduleAdminDAO.scheduleInsertLunarUse(map);	
	}

	@Override
	public void scheduleUpdateLunarUse(String companyID, String lunarUse, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_LUNARUSE", lunarUse);
		map.put("v_TENANTID", tenantId);
				
		ezScheduleAdminDAO.scheduleUpdateLunarUse(map);	
	}

	@Override
	public void scheduleInsertRegi(String companyID, String regi, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_REGI", regi);
		map.put("v_TENANTID", tenantId);
				
		ezScheduleAdminDAO.scheduleInsertRegi(map);	
	}

	@Override
	public void scheduleUpdateRegi(String companyID, String regi, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_REGI", regi);
		map.put("v_TENANTID", tenantId);
				
		ezScheduleAdminDAO.scheduleUpdateRegi(map);			
	}
	
	
}

