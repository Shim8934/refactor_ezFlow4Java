package egovframework.ezEKP.ezPMS.service.impl;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezPMS.service.EzPMSAdminService;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectListVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberScheduleVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskListVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.SearchVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPMSService")
public class EzPMSServiceImpl extends EgovAbstractServiceImpl implements EzPMSService {

	@Override
	public List<ProjectListVO> getProjectList(int tenantId, MCommonVO userInfo, String status,
			Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void addNewProject(JSONObject newProject, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteProject(int tenantId, int projectId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateMainSetting(JSONObject project, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void updateProjectStatus(int projectId, String status, int tenantId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public ProjectListVO getProjectDetails(int projectId, String uerId, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateProject(int projectId, Map<String, Object> map) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<ProjectMemberVO> getProjectMember(int projectId, int roleId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProjectTaskListVO> getMyTasks(int projectid, String status, int tenantId, String suerId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<ProjectTaskListVO> getProjectTasks(int projectId, String status, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void changeKanbanOrder(int projectId, String userId, String orderStatus) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void addFavoriteProject(int projectId, String userId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteFavortieProject(int projectId, String userId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void addTaskLog(JSONObject taskLog, int tenantId, String userId) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public List<TaskLogListVO> getTaskLogList(int taskId, int groupId, Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int getProjectListCount(JSONObject project, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int getTaskListCount(String status, boolean mytask, int projectId, int tenantId) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int getTaskLogListCount(JSONObject taskLog, int tenantId) {
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

}
