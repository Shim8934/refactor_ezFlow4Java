package egovframework.ezEKP.ezPMS.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezPMS.dao.EzPMSDAO;
import egovframework.ezEKP.ezPMS.service.EzPMSAdminService;
import egovframework.ezEKP.ezPMS.service.EzPMSService;
import egovframework.ezEKP.ezPMS.vo.ProjectGroupVO;
import egovframework.ezEKP.ezPMS.vo.ProjectInfoVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMainSettingVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberScheduleVO;
import egovframework.ezEKP.ezPMS.vo.ProjectMemberVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskVO;
import egovframework.ezEKP.ezPMS.vo.ProjectTaskTreeVO;
import egovframework.ezEKP.ezPMS.vo.SearchVO;
import egovframework.ezEKP.ezPMS.vo.TaskLogListVO;
import egovframework.ezMobile.ezOption.vo.MCommonVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPMSService")
public class EzPMSServiceImpl extends EgovAbstractServiceImpl implements EzPMSService {
	@Resource(name = "EzPMSDAO")
	private EzPMSDAO ezPMSDAO;

	@Override
	public List<ProjectInfoVO> getProjectList(int tenantId, MCommonVO userInfo, String status,
			Map<String, Object> map, String offset, String lang) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void addNewProject(ProjectInfoVO newProject, int tenantId) {
		// TODO Auto-generated method stub
		
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
	public List<ProjectMemberVO> getProjectMember(int projectId, int roleId, String lang) {
		// TODO Auto-generated method stub
		return null;
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
		List<ProjectTaskTreeVO> list = ezPMSDAO.getProjectTaskTree(map);
		System.out.println(list.size());
		for(int i = 0; i < list.size(); i++) {
			ProjectTaskTreeVO vo = list.get(i);
			if(vo.getParent().equals("0")) {
				vo.setParent("#");
			}
		}
		return list;
	}

}
