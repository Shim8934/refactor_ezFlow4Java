package egovframework.ezEKP.ezSchedule.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezSchedule.dao.EzScheduleDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheHqVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheSecVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzScheduleService")
public class EzScheduleServiceImpl implements EzScheduleService{
	
	@Resource(name="EzScheduleDAO")
	private EzScheduleDAO ezScheduleDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private CommonUtil commonUtil;

	@Override
	public List<ScheGetHolidayVO> getTholiday(String companyID, String userCompany) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_USERCOMPANY", userCompany);
		return ezScheduleDAO.getTholiday(map);
	}

	@Override
	public ScheduleConfigVO getScheduleConfig(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		return ezScheduleDAO.getScheduleConfig(map);
	}

	@Override
	public ScheduleInfoVO getScheduleInfo(String scheduleID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleID);
		return ezScheduleDAO.getScheduleInfo(map);
	}

	@Override
	public List<AttendantListVO> getAttendantList(String scheduleID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleID);
		return ezScheduleDAO.getAttendantList(map);
	}

	@Override
	public List<AttachListVO> getAttachList(String scheduleID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleID);
		return ezScheduleDAO.getAttachList(map);
	}

	@Override
	public List<PubScheHqVO> getPublicScheduleHq(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		return ezScheduleDAO.getPublicScheduleHq(map);
	}

	@Override
	public List<PubScheSecVO> getPublicScheduleSec(String userID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_LANG", lang);
		return ezScheduleDAO.getPublicScheduleSec(map);
	}

	@Override
	public List<PubScheDeptVO> getPublicScheduleDept(String userID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_LANG", lang);
		return ezScheduleDAO.getPublicScheduleDept(map);
	}

	@Override
	public List<PubScheCumulerVO> getPublicScheduleCumuler(String userID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_LANG", lang);
		return ezScheduleDAO.getPublicScheduleCumuler(map);
	}

	@Override
	public int getNewScheduleId() throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		return ezScheduleDAO.getNewScheduleId(map);
	}

	@Override
	public int getReceiveCount(String pUserId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserId);
		return ezScheduleDAO.getReceiveCount(map);
	}

	@Override
	public int getInviteScheduleGroupCnt(String pUserId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserId);
		return ezScheduleDAO.getInviteScheduleGroupCnt(map);
	}

	@Override
	public void scheduleNewItem(ScheduleInfoVO schInfoVO) throws Exception {
		ezScheduleDAO.scheduleNewItem(schInfoVO);
//		ezBoardDAO.newItem(boardListVO.getItemID());
	}

	@Override
	public String getScheduleList(String startDate, String endDate, String userID, String deptID, String companyID) throws Exception {
		StringBuilder sb = new StringBuilder("<DATA>");			
		String pidList = "'" + userID + "'," + "'" + deptID + "'," + "'" + companyID + "'";		
		
		List<ScheduleGroupListVO> gList = getScheduleGroupList(userID);
		
		for(int i = 0; i < gList.size(); i++){			
			if(i == 0){
				pidList += ",";
			}
			
			ScheduleGroupListVO data = gList.get(i);			
			pidList += "'" + data.getGroupId() + "'";
			
			if(i != gList.size()-1){
				pidList += ",";
			}	
		}
		
System.out.println("orign : " +pidList);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PIDLIST", pidList);
		map.put("v_PFIELDLIST", "");
		map.put("v_PFILTER", "");
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_PKEYWORD", "");
		
		List<ScheduleInfoVO> sList = ezScheduleDAO.getScheduleList(map);
		
		for(int j = 0; j < sList.size(); j++){			
			ScheduleInfoVO data = sList.get(j);
			
			sb.append(commonUtil.getQueryResult(data));
		}
		sb.append("</DATA>");
		
System.out.println(sb.toString());		
		
		return sb.toString();
	}
	
	@Override
	public List<ScheduleGroupListVO> getScheduleGroupList(String userID) throws Exception {		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getScheduleGroupList(userID);
		
		return gList;
	}


	
}

