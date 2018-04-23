package egovframework.ezEKP.ezPMS.service.impl;

import java.text.ParseException;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.text.SimpleDateFormat;

import egovframework.ezEKP.ezPMS.dao.EzPMSDAO;
import egovframework.ezEKP.ezPMS.service.EzPMSAdminService;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.DeptViewVO;
import egovframework.ezEKP.ezPMS.vo.ProjectCompanyVO;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberScheduleVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectUserVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.SearchVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezMobile.ezCommon.web.MCommonGWController;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPMSService")
public class EzPMSServiceImpl extends EgovAbstractServiceImpl implements EzPMSService {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzPMSServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzPMSDAO")
	private EzPMSDAO ezPMSDAO;

	@Override
	public List<ProjectInfoVO> getProjectList(int tenantId, MCommonVO userInfo, String status,
			Map<String, Object> map, String offset, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void addNewProject(ProjectInfoVO newProject, String tenantId) {
		LOGGER.debug("Service addNewProject started.");
		
		System.out.println(newProject.getProjectName());
		
		Map<String, Object> map = new HashMap<>();
		map.put("projectName", newProject.getProjectName());
		map.put("weightInput", newProject.getWeightInput());
		map.put("planStartDate", newProject.getPlanStartDate());
		map.put("planEndDate", newProject.getPlanEndDate());
		map.put("overview", newProject.getOverview());
		map.put("alamMailStatus", newProject.getAlamMailStatus());
		map.put("headManagerId", newProject.getHeadManagerId());
		map.put("tenantId", tenantId);
		map.put("createDate", newProject.getCreateDate());
		map.put("creatorName", newProject.getCreatorName());
		map.put("creatorName2", newProject.getCreatorName2());
		map.put("creatorDeptname", newProject.getCreatorDeptname());
		map.put("creatorDeptname2", newProject.getCreatorDeptname2());
		map.put("creatorId", newProject.getCreatorId());
		map.put("progress", 0);
		
		try {
			//날짜 차이 계산
			Date startDate = new SimpleDateFormat("yyyy-MM-dd").parse(newProject.getPlanStartDate());
			Date endDate = new SimpleDateFormat("yyyy-MM-dd").parse(newProject.getPlanEndDate());
			Date createDate = new SimpleDateFormat("yyyy-MM-dd").parse(newProject.getCreateDate());
			
			int workingDays = getWorkinDays(startDate, endDate);
			
			int createAndEndDateComp = createDate.compareTo(endDate);
			
			if(createAndEndDateComp > 0) {
				map.put("status", "L");
			} else {
				map.put("status", "W");
			}
						
			map.put("workingDay", workingDays);
			map.put("restDueday", workingDays);
			
			//프로젝트 총괄담당자 정보 불러오기
			ProjectMemberVO headManagerInfo = getUserInfo(newProject.getHeadManagerId(), Integer.parseInt(tenantId));
			map.put("headManagerDeptname", headManagerInfo.getUserDeptname());
			map.put("headManagerDeptname2", headManagerInfo.getUserDeptname2());
			map.put("headManagerName", headManagerInfo.getUserName());
			map.put("headManagerName2", headManagerInfo.getUserName2());
			
		} catch (Exception e) {
			LOGGER.debug("Error : " + e.getMessage());
		}
		
		ezPMSDAO.addNewProject(map);
		LOGGER.debug("Service addNewProject ended.");
	}

	@Override
	public void deleteProject(int tenantId, int projectId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateMainSetting(ProjectMainSettingVO project, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateProjectStatus(int projectId, String status, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public ProjectInfoVO getProjectDetails(int projectId, String userId, int tenantId, String offset, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateProject(ProjectInfoVO project, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<ProjectMemberVO> getProjectMemberList(int projectId, int roleId, String lang, int tenantId) {
		LOGGER.debug("getProjectMemberList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("project_Id", projectId);
		param.put("role_Id", roleId);
		param.put("lang", lang);
		param.put("tenant_Id", tenantId);
		
		List<ProjectMemberVO> list = ezPMSDAO.getProjectMemberList(param);
		
		LOGGER.debug("getProjectMemberList ended");
		return list;
	}

	@Override
	public List<ProjectTaskVO> getMyTasks(int projectId, String status, int tenantId, String userId, String offset, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProjectTaskVO> getProjectTasks(int projectId, String status, int tenantId, String offset, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void changeKanbanOrder(int projectId, String userId, String orderStatus, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void addFavoriteProject(int projectId, String userId, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteFavortieProject(int projectId, String userId, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void addTaskLog(TaskLogListVO taskLog, int tenantId, String userId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<TaskLogListVO> getTaskLogList(int taskId, int groupId, Map<String, Object> map, String offset, String lang, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getProjectListCount(ProjectInfoVO project, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int getTaskListCount(String status, String mytask, int projectId, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int getTaskLogListCount(TaskLogListVO taskLog, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int getMemberCount(int projectId, int roleId, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getKanbanOrder(int projectId, String userId, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<String> getProjectNameList(String userId, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProjectTaskVO> getTaskList(SearchVO search) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProjectGroupVO> getGroupList(SearchVO search) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int addTask(ProjectTaskVO task) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<ProjectMemberScheduleVO> getMemberScheduleList(int projectId, String startDate, String endDate) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProjectTaskVO getTaskDetails(int taskId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int updateTask(ProjectTaskVO task) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteTask(int taskId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int addGroup(ProjectGroupVO group) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public ProjectGroupVO getGroupDetails(int groupId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int updateGroup(ProjectGroupVO group) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteGroup(int groupId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String getUserRole(String userId, int projectId, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public ProjectMainSettingVO getProjectMainSetting(String userId, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProjectTaskTreeVO> getProjectTaskTree(int projectId) {
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("project_Id", projectId);
		
		List<ProjectTaskTreeVO> list = ezPMSDAO.getProjectGroupTree(map);
		
		for(int i = 0; i < list.size(); i++) {
			ProjectTaskTreeVO vo = list.get(i);
			vo.setIcon("jstree-folder");
			if(vo.getParent().equals("0")) {
				vo.setParent("#");
			}
		}
		
		List<ProjectTaskTreeVO> list2 = ezPMSDAO.getProjectTaskTree(map);
		
		System.out.println(list2.size());
		
		for(int i = 0; i < list2.size(); i++) {
			ProjectTaskTreeVO vo = list2.get(i);
			vo.setIcon("jstree-file");
			list.add(vo);
		}
		
		return list;
	}
	
	@Override
	public List<ProjectUserVO> getDeptUserList(int tenantId, String key ,String value, String lang) throws Exception{
		LOGGER.debug("getDeptUserList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("key", key);
		param.put("value", value);
		param.put("lang", lang);
		List<ProjectUserVO> userList = ezPMSDAO.getDeptUserList(param);
		
		LOGGER.debug("getDeptUserList ended");
		return userList;
	}
	
	@Override
	public List<ProjectCompanyVO> getCompanyList(String userId, int tenantId, String companyId,String lang) throws Exception {
		LOGGER.debug("getCompanyList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<ProjectCompanyVO> compList = ezPMSDAO.getCompanyList(param);
		
		LOGGER.debug("getCompanyList ended");
		return compList;
	}

	@Override
	public List<DeptViewVO> getDeptViewList(String userId,String companyId, int tenantId,String lang) throws Exception {
		LOGGER.debug("getDeptViewList started");
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tenantId", tenantId);
		param.put("userId", userId);
		param.put("companyId", companyId);
		param.put("lang", lang);
		List<DeptViewVO> deptList = ezPMSDAO.getDeptViewVO(param);
		
		LOGGER.debug("getDeptViewList ended");
		return deptList;
	}
	
	public int getWorkinDays(Date start, Date end){
	    //Ignore argument check

	    Calendar c1 = GregorianCalendar.getInstance();
	    c1.setTime(start);
	    int w1 = c1.get(Calendar.DAY_OF_WEEK);
	    c1.add(Calendar.DAY_OF_WEEK, -w1 + 1);

	    Calendar c2 = GregorianCalendar.getInstance();
	    c2.setTime(end);
	    int w2 = c2.get(Calendar.DAY_OF_WEEK);
	    c2.add(Calendar.DAY_OF_WEEK, -w2 + 1);

	    //end Saturday to start Saturday 
	    long days = (c2.getTimeInMillis()-c1.getTimeInMillis())/(1000*60*60*24);
	    long daysWithoutSunday = days-(days*2/7);

	    if (w1 == Calendar.SUNDAY) {
	        w1 = Calendar.MONDAY;
	    }
	    if (w2 == Calendar.SUNDAY) {
	        w2 = Calendar.MONDAY;
	    }
	    
	    int workingDays = (int) (daysWithoutSunday-w1+w2);
	    return workingDays;
	}
	
	//프로젝트 총괄 담당자의 유저 정보 불러오기
	@Override
	public ProjectMemberVO getUserInfo(String userId, int tenantId) throws Exception {
		ProjectMemberVO headManager = new ProjectMemberVO();
		
		HashMap<String, Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("tenantId", tenantId);
		
		headManager = ezPMSDAO.getUserInfo(param);
		return headManager;
	}
	
	@Override
	public List<ProjectMemberVO> getProjectMember(int projectId, int roleId,
			String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void addProjectMember(ProjectMemberVO projectMemberList, int tenantId) {		
		LOGGER.debug("Service ezPMS addProjectMember Started");
		HashMap<String, Object> map = new HashMap<>();
		
		try {
			map.put("userId", projectMemberList.getUserId());
			map.put("userName", projectMemberList.getUserName());
			map.put("userName2", projectMemberList.getUserName2());
			map.put("userDeptname", projectMemberList.getUserDeptname());
			map.put("userDeptname2", projectMemberList.getUserDeptname2());
			map.put("userPosition", projectMemberList.getUserPosition());
			map.put("userPosition2", projectMemberList.getUserPosition2());
			map.put("memberRoleId", projectMemberList.getMemberRoleId());
			map.put("userIdType", "user");
			map.put("projectId", projectMemberList.getProjectId());
			map.put("tenantId", tenantId);
			
			ezPMSDAO.addProjectMember(map);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			LOGGER.debug("ERROR : " + e.getMessage());
		}
		
		LOGGER.debug("Service ezPMS addProjectMember Ended");
	}
}
