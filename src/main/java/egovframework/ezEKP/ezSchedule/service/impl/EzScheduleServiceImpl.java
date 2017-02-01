package egovframework.ezEKP.ezSchedule.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezSchedule.dao.EzScheduleDAO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.AttachListVO;
import egovframework.ezEKP.ezSchedule.vo.AttendantListVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheCumulerVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheDeptVO;
import egovframework.ezEKP.ezSchedule.vo.PubScheHqVO;
import egovframework.ezEKP.ezSchedule.vo.ScheGetHolidayVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleGroupListVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleInfoVO;
import egovframework.ezEKP.ezSchedule.vo.ScheduleSecretaryVO;
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
	public List<ScheGetHolidayVO> getTholiday(String companyId, String userCompany, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyId);
		map.put("v_USERCOMPANY", userCompany);
		map.put("v_TENANTID", tenantId);
		
		return ezScheduleDAO.getTholiday(map);
	}

	@Override
	public ScheduleConfigVO getScheduleConfig(String userId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userId);
		map.put("tenantID", tenantId);
		
		return ezScheduleDAO.getScheduleConfig(map);
	}

	@Override
	public ScheduleInfoVO getScheduleInfo(String scheduleId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		return ezScheduleDAO.getScheduleInfo(map);
	}

	@Override
	public List<AttendantListVO> getAttendantList(String scheduleId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		return ezScheduleDAO.getAttendantList(map);
	}

	@Override
	public List<AttachListVO> getAttachList(String scheduleId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SCHEDULEID", scheduleId);
		return ezScheduleDAO.getAttachList(map);
	}

	@Override
	public List<PubScheHqVO> getPublicScheduleHq(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);
		return ezScheduleDAO.getPublicScheduleHq(map);
	}

	@Override
	public List<ScheduleSecretaryVO> getPublicScheduleSec(String userId, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);
		map.put("v_LANG", lang);
		return ezScheduleDAO.getPublicScheduleSec(map);
	}

	@Override
	public List<PubScheDeptVO> getPublicScheduleDept(String userId, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);
		map.put("v_LANG", lang);
		return ezScheduleDAO.getPublicScheduleDept(map);
	}

	@Override
	public List<PubScheCumulerVO> getPublicScheduleCumuler(String userId, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userId);
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
	}

	@Override
	public List<ScheduleInfoVO> getScheduleList(String pidList, String filter, String startDate, String endDate, String keyword, String offSetMin) throws Exception {						
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PIDLIST", pidList);		
		map.put("v_PFILTER", filter);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_PKEYWORD", keyword);
		map.put("offSetMin", offSetMin);
		
		List<ScheduleInfoVO> sList = ezScheduleDAO.getScheduleList(map);
		
		//반복일정 구현 필요		
		
		return sList;
	}
	
	@Override
	public List<ScheduleGroupListVO> getScheduleGroupList(String userID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantId);
		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getScheduleGroupList(map);
		
		return gList;
	}

	@Override
	public List<ScheduleGroupListVO> getMyGroupList(String userID, int tenantID) throws Exception {	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getMyGroupList(map);
		
		return gList;
	}
	
	@Override
	public int getMyGroupMemberListCnt(String groupId, String lang, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupID", groupId);
		map.put("lang", lang);
		map.put("tenantID", tenantId);
		
		int cnt = ezScheduleDAO.getMyGroupMemberListCnt(map);
		
		return cnt;
	}

	@Override
	public String getMyGroupMemberList(String groupId, String lang, int tenantId) throws Exception {
		StringBuilder sb = new StringBuilder("<DATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupID", groupId);
		map.put("lang", lang);
		map.put("tenantID", tenantId);
		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getMyGroupMemberList(map);
		
		for(int j = 0; j < gList.size(); j++){			
			ScheduleGroupListVO data = gList.get(j);
			
			sb.append(commonUtil.getQueryResult(data));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public void deleteScheduleGroup(String groupId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupID", groupId);		
		map.put("tenantID", tenantId);
		
		ezScheduleDAO.deleteScheduleGroup(map);
		ezScheduleDAO.deleteScheduleGroupMember(map);
	}

	@Override
	public List<ScheduleGroupListVO> getGroupMemberList(String groupID,	int tenantId, String offSetMin) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupID", groupID);		
		map.put("tenantID", tenantId);
		map.put("offSetMin", offSetMin);
		
		List<ScheduleGroupListVO> gList = ezScheduleDAO.getGroupMemberList(map);
		
		return gList;
	}

	@Override
	public void deleteScheduleMember(String groupId, String memberId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupID", groupId);
		map.put("memberID", memberId);
		map.put("tenantID", tenantId);
		
		ezScheduleDAO.deleteScheduleMember(map);
	}

	@Override
	public void updateScheduleMember(String groupId, String memberId, String status, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupID", groupId);
		map.put("memberID", memberId);
		map.put("status", status);
		map.put("tenantID", tenantId);
		
		ezScheduleDAO.updateScheduleMember(map);
	}

	@Override
	public void insertScheduleGroupMember(String groupId, String memberId, String memberName, String memberName2, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("groupID", groupId);
		map.put("memberID", memberId);
		map.put("memberName", memberName);
		map.put("memberName2", memberName2);
		map.put("tenantID", tenantId);
		
		ezScheduleDAO.insertScheduleGroupMember(map);
	}

	@Override
	public String getDeptMemberList(String deptId, String subDept, String lang, int tenantId) throws Exception {
		StringBuilder sb = new StringBuilder("<DATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptID", deptId);
		map.put("subDept", subDept);
		map.put("lang", lang);		
		map.put("tenantID", tenantId);
		
		List<OrganUserVO> gList = ezScheduleDAO.getDeptMemberList(map);
		
		for(int i = 0; i < gList.size(); i++){			
			OrganUserVO data = gList.get(i);
			
			sb.append(commonUtil.getQueryResult(data));
		}
		sb.append("</DATA>");
		
		return sb.toString();		
	}

	@Override
	public void insertScheduleGroup(String gUID, String id, String displayName,	String displayName2, String groupName, String description, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("gUID", gUID);
		map.put("userID", id);
		map.put("displayName", displayName);
		map.put("displayName2", displayName2);
		map.put("groupName", groupName);
		map.put("description", description);
		map.put("tenantID", tenantId);
		
		ezScheduleDAO.insertScheduleGroup(map);
	}

	@Override
	public String scheduleGetLunarUse(String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantId);
		
		String result = ezScheduleDAO.scheduleGetLunarUse(map);
		
		if (result == null || result.equals("")) {
			result = "0";
		}		
		return result;
	}

	@Override
	public String scheduleGetRegi(String companyID, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantId);
		
		String result = ezScheduleDAO.scheduleGetRegi(map);
		
		if (result == null || result.equals("")) {
			result = "0";
		}		
		return result;
	}

	@Override
	public List<ScheduleSecretaryVO> getSecretaryList(String userId, int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userId);		
		map.put("tenantID", tenantId);
		
		List<ScheduleSecretaryVO> sList = ezScheduleDAO.getSecretaryList(map);
		
		return sList;
	}
	
	
}

